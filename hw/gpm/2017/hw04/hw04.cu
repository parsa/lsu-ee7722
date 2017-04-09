#include <stdio.h>
#include <vector>
#include <cuda_runtime.h>
#include <gp/cuda-gpuinfo.h>
#include <nperf.h>

using namespace std;

struct App
{

  float elt_min;
  float bin_width_inv;
  int nbins;
  int nelts;

  float *d_data;
  int *d_histo;

};

App app;
__constant__ App d_app;

const int NBINS = 20;

typedef void (*KPtr)();

extern "C" __global__ void
h_basic()
{
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int num_threads = blockDim.x * gridDim.x;

  for ( int idx = tid;  idx < d_app.nelts; idx += num_threads )
    {
      float elt = d_app.d_data[idx];
      int bin_raw = ( elt - d_app.elt_min ) * d_app.bin_width_inv;
      int bin_pos = max( 0, bin_raw );
      int bin = min( bin_pos, d_app.nbins-1 );
      atomicAdd(&d_app.d_histo[bin],1);
    }
}

extern "C" __global__ void
h_priv_blk()
{
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int num_threads = blockDim.x * gridDim.x;

  __shared__ int histo[NBINS];

  for ( int i = threadIdx.x; i < NBINS; i += blockDim.x )
    histo[i] = 0;

  __syncthreads();

  for ( int idx = tid;  idx < d_app.nelts; idx += num_threads )
    {
      float elt = d_app.d_data[idx];
      int bin_raw = ( elt - d_app.elt_min ) * d_app.bin_width_inv;
      int bin_pos = max( 0, bin_raw );
      int bin = min( bin_pos, NBINS-1 );
      atomicAdd(&histo[bin],1);
    }
  __syncthreads();
  for ( int i = threadIdx.x; i < NBINS; i += blockDim.x )
    atomicAdd( &d_app.d_histo[i], histo[i] );
}

extern "C" __global__ void
h_priv_blk2()
{
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int DEG = 256;
  __shared__ int histo[NBINS][DEG];
  int *hlinear = &histo[0][0];
  const int dupidx = threadIdx.x % DEG;

  for ( int i = threadIdx.x; i < NBINS*DEG; i += blockDim.x )
    hlinear[i] = 0;

  __syncthreads();

  for ( int idx = tid;  idx < d_app.nelts; idx += num_threads )
    {
      float elt = d_app.d_data[idx];
      int bin_raw = ( elt - d_app.elt_min ) * d_app.bin_width_inv;
      int bin_pos = max( 0, bin_raw );
      int bin = min( bin_pos, NBINS-1 );
      if ( blockDim.x > DEG )
        atomicAdd(&histo[bin][dupidx],1);
      else
        histo[bin][dupidx]++;
    }
  __syncthreads();

  if ( threadIdx.x >= NBINS ) return;

  int val = 0;
  for ( int i=0; i<DEG; i++ )
    val += histo[threadIdx.x][i];
  atomicAdd( &d_app.d_histo[threadIdx.x], val );
}



GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  gpu_info_print();

  // Determine which GPU to use. (For starters, if there's more than
  // one, choose the one connected to the display.)
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);


  /// Add kernels to the list of kernels to run.
  //

  info.GET_INFO(h_basic);
  info.GET_INFO(h_priv_blk);
  info.GET_INFO(h_priv_blk2);

  // Print information about kernel.
  //
  printf("\nCUDA Kernel Resource Usage:\n");

  for ( int i=0; i<info.num_kernels; i++ )
    {
      printf("For %s:\n", info.ki[i].name);
      printf("  %6zd shared, %zd const, %zd loc, %d regs; "
             "%d max threads per block.\n",
             info.ki[i].cfa.sharedSizeBytes,
             info.ki[i].cfa.constSizeBytes,
             info.ki[i].cfa.localSizeBytes,
             info.ki[i].cfa.numRegs,
             info.ki[i].cfa.maxThreadsPerBlock);
    }
  return info;
}

int
main(int argc, char **argv)
{
  // Initialize the collection of metrics if GPU debugging is
  // off. Metrics collected using the NPerf library which itself uses
  // the NVIDIA CUPTI API to collect data from GPU performance (event)
  // counters and to compute performance metrics in terms of the event
  // data.
  //
# ifdef __P_CUDA_DEBUG__
  NPerf_init(false);
# else
  NPerf_init(true);
# endif

  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  /// Indicate which metrics to collect.
  //
  //  See the CUPTI User's Guide for a list of metrics, Section 1.6
  //   for the February 2016 guide.
  //
  NPerf_metric_collect("inst_executed");
  NPerf_metric_collect("eligible_warps_per_cycle");
  NPerf_metric_collect("gld_efficiency");
  NPerf_metric_collect("gst_efficiency");
  NPerf_metric_collect("gld_throughput");
  NPerf_metric_collect("gst_throughput");
  NPerf_metric_collect("shared_load_transactions_per_request");
  NPerf_metric_collect("shared_store_transactions_per_request");
  //
  // Note: The more metrics that are collected, the more times a
  // kernel will need to be run and the longer you'll have to wait for
  // an answer. 


  const int num_mp = info.cuda_prop.multiProcessorCount;

  // Examine argument 1, block count, default is number of MPs.
  // Negative value is a multiple of the number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
    arg1_int == 0 ? num_mp :
    arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of threads per block.
  // Zero means vary the number of threads in multiples of 32.
  //
  const int thd_per_block_arg = argc < 3 ? 0 : atoi(argv[2]);
  const int thd_per_block_goal =
    thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  double arg_3_raw = argc < 4 ? 1 : atof(argv[3]);
  const int in_size_bytes_targ =
    argc < 4 ? 1 << 24 : int( atof(argv[3]) * (1<<20) );
  app.nelts = in_size_bytes_targ / ( sizeof(app.d_data[0]) );

  app.nbins = NBINS;

  if ( num_threads <= 0 || app.nbins <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  app.elt_min = -0.5 / app.nbins;
  const float elt_max = 1.0 + 0.5 / app.nbins;
  app.bin_width_inv = app.nbins / ( elt_max - app.elt_min );

  vector<float> din(app.nelts);
  for ( auto& e: din ) e = drand48();
  vector<int> histo_check(app.nbins);
  vector<int> histo(app.nbins);

  for ( auto& e: din )
    histo_check
      [min(app.nbins-1,max(0,int((e-app.elt_min)*app.bin_width_inv)))]++;

  const size_t data_size_bytes = app.nelts * sizeof(app.d_data[0]);
  const size_t histo_size_bytes = app.nbins * sizeof(app.d_histo[0]);

  printf("Running with %d bins and %.1f MiB array, %.1f elt/thd\n",
         app.nbins, double(data_size_bytes)/(1<<20) ,
         double(app.nelts) / ( num_blocks * num_threads ));


  CE( cudaMalloc( &app.d_data, data_size_bytes ) );
  CE( cudaMalloc( &app.d_histo, histo_size_bytes ) );

  CE( cudaMemcpy
      ( app.d_data, din.data(), data_size_bytes, cudaMemcpyHostToDevice ) );

  CE( cudaMemcpyToSymbol
      ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

  // Prepare events used for timing.
  //
  cudaEvent_t gpu_start_ce, gpu_stop_ce;
  CE(cudaEventCreate(&gpu_start_ce));
  CE(cudaEventCreate(&gpu_stop_ce));

  const size_t amt_data_bytes = data_size_bytes + num_mp * histo_size_bytes;
  const size_t num_madds = app.nelts;

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      Kernel_Info& k = info.ki[kernel];
      bool heading_printed = false;

      cudaFuncAttributes& cfa = k.cfa;
      const int wp_limit = cfa.maxThreadsPerBlock >> 5;

      const int thd_limit = wp_limit << 5;
      const int thd_per_block_no_vary = min(thd_per_block_goal,thd_limit);

      const int wp_start = 4;
      const int wp_stop = vary_warps ? 32 : wp_start;
      const int wp_inc = 4;

      for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
        {
          const int thd_per_block =
            vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

          if ( ! k.block_size_okay(thd_per_block) ) continue;

          // Zero the output array.
          //
          CE( cudaMemset( app.d_histo, 0, histo_size_bytes ) );

          // Measure execution time starting "now", which is after data
          // set to GPU.  This is only used when NPerf is not active.
          //
          CE(cudaEventRecord(gpu_start_ce,0));

          // Launch Kernel
          //
          for ( NPerf_data_reset(); NPerf_need_run_get(); )
            KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>();

          const int nlaunches = NPerf_kernel_nlaunches_get();

          // Stop measuring execution time now, which is before is data
          // returned from GPU.
          //
          CE(cudaEventRecord(gpu_stop_ce,0));
          CE(cudaEventSynchronize(gpu_stop_ce));
          float cuda_time_ms = -1.1;
          CE(cudaEventElapsedTime
             (&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

          const double this_elapsed_time_s =
            NPerf_metrics_collection_get()
            ? NPerf_kernel_et_get() : cuda_time_ms * 0.001;

          const double thpt_compute_gflops =
            num_madds / this_elapsed_time_s * 1e-9;
          const double thpt_data_gbps =
            amt_data_bytes / this_elapsed_time_s * 1e-9;

          if ( vary_warps )
            {
              const int rate =
                sizeof(app.d_data[0]) == sizeof(float)
                ? info.chip_sp_flops : info.chip_dp_flops;
              const double comp_frac __attribute__((unused)) =
                1e9 * thpt_compute_gflops / rate;
              const double comm_frac =
                1e9 * thpt_data_gbps / info.chip_bw_Bps;
              const int max_st_len = 40;

              // Number of warps, rounded up.
              //
              const int num_wps = ( thd_per_block + 31 ) >> 5;

              // The maximum number of active blocks per MP for this
              // kernel when launched with a block size of thd_per_block.
              //
              const int max_bl_per_mp =
                info.get_max_active_blocks_per_mp(kernel,thd_per_block);

              // Compute number of blocks available per MP based only on
              // the number of blocks.  This may be larger than the
              // number of blocks that can run.
              //
              const int bl_per_mp_available =
                0.999 + double(num_blocks) / num_mp;

              // The number of active blocks is the minimum of what
              // can fit and how many are available.
              //
              const int bl_per_mp =
                min( bl_per_mp_available, max_bl_per_mp );

              // Based on the number of blocks, compute the num ber of warps.
              //
              const int act_wps = num_wps * bl_per_mp;

              if ( !heading_printed )
                printf("Kernel %s:\n", info.ki[kernel].name);
              heading_printed = true;

              printf("%2d %2d wp  %6.0f µs  %4.0f GF  %4.0f GB/s %s\n",
                     num_wps, act_wps,
                     this_elapsed_time_s * 1e6,
                     thpt_compute_gflops, thpt_data_gbps,
                     string(int(comm_frac*max_st_len),'=').c_str());

              printf("%2d %2d wp  %6.0f µs  %4.0f GF  %4.0f GB/s "
                     "%5.1f I/F  %4.1f wp/c  %3.0f%%  %4.1f\n",
                     num_wps, act_wps,
                     this_elapsed_time_s * 1e6,
                     thpt_compute_gflops, thpt_data_gbps,
                     NPerf_metric_value_get("inst_executed") * 32 / num_madds,
                     NPerf_metric_value_get("eligible_warps_per_cycle"),
                     NPerf_metric_value_get("gld_efficiency"),
                     NPerf_metric_value_get("shared_load_transactions_per_request"));


            } else {

              printf
                ("%-10s %2d wp  %7.0f µs  %4.0f GF  %4.0f (%4.0f) GB/s  "
                 "%5.2f I/F  %5.1f%% %4.1f\n",
                 info.ki[kernel].name,
                 (thd_per_block + 31 ) >> 5,
                 this_elapsed_time_s * 1e6,
                 thpt_compute_gflops, thpt_data_gbps,
                 ( NPerf_metric_value_get("gld_throughput") +
                   NPerf_metric_value_get("gst_throughput") ) * 1e-9,
                 NPerf_metric_value_get("inst_executed") * 32 / num_madds,
                 //  NPerf_metric_value_get("gld_efficiency"),
                 //  NPerf_metric_value_get("gst_efficiency"),
                 NPerf_metric_value_get("eligible_warps_per_cycle"),
                 //  NPerf_metric_value_get("shared_load_transactions_per_request"),
                 NPerf_metric_value_get("shared_store_transactions_per_request")
                 );

              if (0 )
            printf("K %-15s %2d wp  %11.3f µs  %8.3f GFLOPS  %8.3f GB/s\n",
                   info.ki[kernel].name,
                   (thd_per_block + 31 ) >> 5,
                   this_elapsed_time_s * 1e6,
                   thpt_compute_gflops, thpt_data_gbps);

          }

          // Copy output array from GPU to CPU.
          //
          CE( cudaMemcpy
              ( histo.data(), app.d_histo,
                histo_size_bytes, cudaMemcpyDeviceToHost ) );

          int errs = 0;
          for ( int i=0; i<app.nbins; i++ )
            {
              const int bin_scaled = histo[i] / nlaunches;
              if ( bin_scaled == histo_check[i] ) continue;
              errs++;
              if ( errs < 5 ) printf("Error at %d  %d != %d (correct)\n",
                                     i, bin_scaled, histo_check[i]);
            }

        }
    }


  return 0;
}
