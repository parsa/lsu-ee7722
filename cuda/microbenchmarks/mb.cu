#include <stdio.h>
#include <assert.h>
#include <ptable.h>
#include "util.h"
#include "misc.h"

/// LSU EE 7722 - GPU Microarchitecture
//
 /// Microbenchmark Code
 //
 //  Load latency


const int unroll_deg = 10;

struct App
{
  uint array_n_elts;
  uint n_iters;
  void **a;
  uint *result_d;
  clock_t *wp_time_d;
};

App app;
__constant__ App app_c;

#define div_up(a,b) ( b ? ((a)+(b)-1)/(b) : 0 )

string
fmt_Po2(uint64_t val, uint64_t scaled_max = 1023)
{
  const int size_lg = fl1(val);
  vector<const char*> mult( {"  ","ki","Mi","Gi","Ti","Pi","Ei","Zi","Yi"} );
  int tens = max(0,size_lg-1) / 10;
  while ( tens && ( val >> 10 * ( tens - 1 ) ) < scaled_max ) tens--;
  pStringF val_str("%lu %s", val >> 10*tens, mult[tens]);
  return val_str.ss();
}


__global__ void
array_init(uint stride)
{
  const uint tid = threadIdx.x + blockIdx.x * blockDim.x;
  const uint n_thds = blockDim.x * gridDim.x;
  for ( uint i = tid;  i < app_c.array_n_elts;  i += n_thds )
    app_c.a[i] = &app_c.a[( i + stride ) % app_c.array_n_elts ];
}

typedef void (*KPtr)(void **a);

template<bool ro> __device__ void
mb(void **a)
{
  const uint tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int wp_lg = 5;
  const int lane = threadIdx.x & ( (1<<wp_lg) - 1 );
  void** idx = &a[tid];
  clock_t start = clock();
  for ( int i=0; i<app_c.n_iters; i += unroll_deg )
    for ( int j=0; j<unroll_deg; j++ )
      idx = ro ? (void**)__ldg((uint64_t*)idx) : (void**)*idx;
  app_c.result_d[tid] = idx - a;
  if ( lane == 0 )
    app_c.wp_time_d[tid>>wp_lg] = clock() - start;
}

__global__ void mb_g(void **a) {mb<false>(a);}
__global__ void mb_ro(void **a) {mb<true>(a);}

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

  info.GET_INFO(mb_g);
  info.GET_INFO(mb_ro);

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
  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  const int num_mp = info.cuda_prop.multiProcessorCount;
  const uint num_mp_po2 = floor2(num_mp);

  const size_t array_bytes = ceil2( 4 * info.cuda_prop.l2CacheSize );
  uint& n_elts = app.array_n_elts = array_bytes / sizeof(app.a[0]);

  const uint min_n_iters = 10000;

  const uint wp_sz = 32;
  const uint wp_per_block = 1;
  const uint n_blks_max = num_mp_po2 * 8;
  const uint thds_per_blk = wp_per_block * wp_sz;

  const uint max_num_threads = thds_per_blk * n_blks_max;
  const uint max_num_wps = max_num_threads / wp_sz;

  const size_t max_out_size_elts = max_num_threads;
  const size_t max_out_size_bytes = max_out_size_elts * sizeof(app.result_d[0]);
  const size_t max_wp_time_size_bytes = max_num_wps * sizeof(app.wp_time_d[0]);

  const size_t in_size_elts = size_t(app.array_n_elts);
  const size_t in_size_bytes = in_size_elts * sizeof( app.a[0] );

  // Allocate storage for GPU copy of array.
  //
  CE( cudaMalloc( &app.a,  in_size_bytes ) );
  CE( cudaMalloc( &app.result_d,  max_out_size_bytes ) );
  CE( cudaMalloc( &app.wp_time_d,  max_wp_time_size_bytes ) );

  vector<uint> result_h(max_out_size_elts);
  vector<clock_t> wp_time_h(max_num_wps);

  printf("Array size: %u elts. Block size %u thds.\n",
         app.array_n_elts, thds_per_blk);

  const int output_width = stdout_width_get();

  const int init_num_blocks = num_mp * 2;
  const int init_thds_per_blk = 1024;

  const double clock_period_ns = 1e6 / info.cuda_prop.clockRate;

  const size_t bytes_per_block = thds_per_blk * sizeof(app.a[0]);
  const size_t min_bytes = 1 << 9;

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      cudaFuncAttributes& cfa = info.ki[kernel].cfa;

      pTable table;
      table.stream = stdout;

      const double scale_max_latency_multiple_ns = 100;
      const double preferred_scale_max_latency_ns = 500;
      double scale_max_latency_ns = 0;
      printf("Kernel %s:\n", info.ki[kernel].name);

      for ( size_t tot_bytes = array_bytes; tot_bytes >= min_bytes;
            tot_bytes >>= 1 )
        {
          const size_t elt_per_thd_target = 1000;
          const uint n_blks_raw =
            tot_bytes / ( elt_per_thd_target * bytes_per_block );
          const uint n_blks_f = floor2(n_blks_raw);
          const uint n_blks_c = ceil2(n_blks_raw);
          const uint n_blks_raw_r =
            n_blks_raw - n_blks_f < n_blks_c - n_blks_raw
            ? n_blks_f : n_blks_c;
          const uint n_blks = min(max(1,n_blks_raw_r),n_blks_max);
          const uint n_thds = n_blks * thds_per_blk;

          // In units of elements.
          const size_t stride = n_thds * array_bytes / tot_bytes;
          if ( stride < n_thds ) break;
          assert( n_elts % stride == 0 );

          const int elt_per_thd = n_elts / stride;
          const int elt_per_blk = elt_per_thd * thds_per_blk;
          const size_t touched_total_bytes =
            n_blks * elt_per_blk * sizeof(app.a[0]);
          assert( touched_total_bytes == tot_bytes );

          app.n_iters = max(min_n_iters,elt_per_thd*unroll_deg);

          const size_t out_size_elts = n_thds;
          const size_t out_size_bytes = out_size_elts * sizeof(app.result_d[0]);
          const size_t wp_time_size_bytes =
            n_thds / 32 * sizeof(app.wp_time_d[0]);

          // Copy App structure to GPU.
          //
          CE( cudaMemcpyToSymbol
              ( app_c, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

          CE(cudaMemset(app.result_d,0,out_size_bytes));
          CE(cudaMemset(app.wp_time_d,0,wp_time_size_bytes));

          array_init<<<init_num_blocks,init_thds_per_blk>>>(stride);

          KPtr(info.ki[kernel].func_ptr)<<<n_blks,thds_per_blk>>>(app.a);

          CE( cudaDeviceSynchronize() );

          // Copy output array from GPU to CPU.
          //
          CE( cudaMemcpy
              (result_h.data(), app.result_d,
               out_size_bytes, cudaMemcpyDeviceToHost) );
          CE( cudaMemcpy
              (wp_time_h.data(), app.wp_time_d,
               wp_time_size_bytes, cudaMemcpyDeviceToHost) );

          clock_t min_cyc = wp_time_h[0];
          for ( uint i=1; i<n_blks; i++ ) set_min(min_cyc,wp_time_h[i]);
          double self_time_ns = min_cyc * clock_period_ns;
          double latency_ns = self_time_ns / app.n_iters;
          double latency_cyc = double(min_cyc) / app.n_iters;

          if ( scale_max_latency_ns == 0 )
            scale_max_latency_ns =
              max( preferred_scale_max_latency_ns,
                   scale_max_latency_multiple_ns *
                   ceil( latency_ns / scale_max_latency_multiple_ns ) );

          double frac = latency_ns / scale_max_latency_ns;

          table.row_start();
          table.entry("nbl","%3d", n_blks);
          table.entry("iter","%7d", app.n_iters);
          table.header_span_start("Data Touched");
          table.entry
            ( "Block", "%7sB",
              fmt_Po2(elt_per_blk*sizeof(app.a[0])), pTable::pT_Right );
          table.entry
            ( "Total", "%8sB",
              fmt_Po2( touched_total_bytes), pTable::pT_Right );
          table.header_span_end();
          table.header_span_start("Latency");
          table.entry("ns", "%4.0f", latency_ns);
          table.entry("cyc", "%4.0f", latency_cyc);

          const int max_st_len =
            max(5, output_width - 1 - table.row_len_get() );
          pStringF fmt("%%-%ds",max_st_len);
          pStringF max_lat_txt("%.0f ns",scale_max_latency_ns);
          const int pad_total = max_st_len - 4 - max_lat_txt.length();
          const int pad_left = max(0,pad_total/2);
          const int pad_right = max(0,pad_total-pad_left);
          // Note: "<","|" as first character indicates left just, centering.
          string lat_hdr = "||<" + string(pad_left,'-') + max_lat_txt
            + string(pad_right,'-') + ">|";
          table.entry
            (lat_hdr,fmt,
             string( size_t(max(0.0,frac*max_st_len)), '*' ),
             pTable::pT_Left);

          table.header_span_end();

          int err_count = 0;
          const uint n_elt_mask = n_elts - 1;
          for ( uint i=0; i<out_size_elts; i++ )
            {
              const uint expect = ( i + app.n_iters * stride ) & n_elt_mask;

              if ( expect != result_h[i] )
                {
                  err_count++;
                  if ( err_count < 5 )
                    printf("Error at elt %u: %u != %u (correct)\n",
                           i, result_h[i], expect );
                }
            }
          if ( err_count )
            printf("Total errors %d\n", err_count);
        }
    }
}
