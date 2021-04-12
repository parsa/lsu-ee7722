/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2021
 /// Homework 1
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2021/hw01.pdf
 //
 //  Modify this file only.

#include <stdio.h>

#include <cuda_runtime.h>
#include <gp/cuda-gpuinfo.h>
#include <ptable.h>

typedef float wht_t;
typedef float acc_t;

struct Layer_Shape
{
  int nn, nc, ni, no, nm;
};

constexpr Layer_Shape ls[] = { { 800, 20, 28, 28, 20 },
                               { 800, 52, 44, 44, 52 } };

constexpr int n_shapes = sizeof(ls)/sizeof(ls[0]);

struct Layer
{
  wht_t *w_h, *w_d;
  wht_t *w2_h, *w2_d;
  acc_t *ai_h, *ai_d;
  acc_t *ao_h, *ao_d, *ao_check_h;

  Layer_Shape s;

  size_t sz_ai_elts, sz_ao_elts, sz_w_elts;
  size_t sz_ai_bytes, sz_ao_bytes, sz_w_bytes;

};

template<int tpnn=0, int tpnc=0, int tpni=0>
__global__ void
dnn_base(Layer l)
{
  Layer_Shape& s = l.s;

  const int [[gnu::unused]] tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int [[gnu::unused]] num_threads = blockDim.x * gridDim.x;

  // If template parameters are non-zero verify and use them.
  const int nn = tpnn ? tpnn : s.nn;  // Number of batches.
  const int ni = tpni ? tpni : s.ni;  // Number of input neurons per channel.
  const int nc = tpnc ? tpnc : s.nc;  // Number of input channels.
  const int no = ni;                  // Number of output neurons per channel.
  const int nm = nc;                  // Number of output channels.
  assert( ni == s.ni );
  assert( nc == s.nc );
  assert( nn == s.nn );

  acc_t* const ai = l.ai_d;
  acc_t* const ao = l.ao_d;
  wht_t [[gnu::unused]] * const w = l.w_d;
  wht_t [[gnu::unused]] * const w2 = l.w2_d;

  for ( int in = blockIdx.x; in < nn; in += gridDim.x )
    for ( int im = threadIdx.x; im < nm; im += blockDim.x )
      for ( int io = 0; io < no; io++ )
          {
            acc_t ac = 0;
            for ( int ic = 0; ic < nc; ic++ )
              for ( int ii = 0; ii < ni; ii++ )
                ac +=
                  ai[ ii + ni * ( ic + nc * in ) ]
                  * w[ ic + nc * ( im + nm * ( ii + ni * io ) ) ];
            ao[ io + no * ( im + nm * in ) ] = ac;
          }
}

template<int tpnn=0, int tpnc=0, int tpni=0>
__global__ void
dnn_sol_a(Layer l)
{
  Layer_Shape& s = l.s;

  const int [[gnu::unused]] tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int [[gnu::unused]] num_threads = blockDim.x * gridDim.x;

  // If template parameters are non-zero verify and use them.
  const int nn = tpnn ? tpnn : s.nn;  // Number of batches.
  const int ni = tpni ? tpni : s.ni;  // Number of input neurons per channel.
  const int nc = tpnc ? tpnc : s.nc;  // Number of input channels.
  const int no = ni;                  // Number of output neurons per channel.
  const int nm = nc;                  // Number of output channels.
  assert( ni == s.ni );
  assert( nc == s.nc );
  assert( nn == s.nn );

  acc_t* const ai = l.ai_d;
  acc_t* const ao = l.ao_d;
  wht_t [[gnu::unused]] * const w = l.w_d;
  wht_t [[gnu::unused]] * const w2 = l.w2_d;

  for ( int in = blockIdx.x; in < nn; in += gridDim.x )
    for ( int im = threadIdx.x; im < nm; im += blockDim.x )
      for ( int io = 0; io < no; io++ )
          {
            acc_t ac = 0;
            for ( int ic = 0; ic < nc; ic++ )
              for ( int ii = 0; ii < ni; ii++ )
                ac +=
                  ai[ ii + ni * ( ic + nc * in ) ]
                  * w[ ic + nc * ( im + nm * ( ii + ni * io ) ) ];
            ao[ io + no * ( im + nm * in ) ] = ac;
          }
}

template<int tpnn=0, int tpnc=0, int tpni=0>
__global__ void
dnn_sol_b(Layer l)
{
  Layer_Shape& s = l.s;

  const int [[gnu::unused]] tid = blockIdx.x * blockDim.x + threadIdx.x;
  const int [[gnu::unused]] num_threads = blockDim.x * gridDim.x;

  // If template parameters are non-zero verify and use them.
  const int nn = tpnn ? tpnn : s.nn;  // Number of batches.
  const int ni = tpni ? tpni : s.ni;  // Number of input neurons per channel.
  const int nc = tpnc ? tpnc : s.nc;  // Number of input channels.
  const int no = ni;                  // Number of output neurons per channel.
  const int nm = nc;                  // Number of output channels.
  assert( ni == s.ni );
  assert( nc == s.nc );
  assert( nn == s.nn );

  acc_t* const ai = l.ai_d;
  acc_t* const ao = l.ao_d;
  wht_t [[gnu::unused]] * const w = l.w_d;
  wht_t [[gnu::unused]] * const w2 = l.w2_d;

  for ( int in = blockIdx.x; in < nn; in += gridDim.x )
    for ( int im = threadIdx.x; im < nm; im += blockDim.x )
      for ( int io = 0; io < no; io++ )
          {
            acc_t ac = 0;
            for ( int ic = 0; ic < nc; ic++ )
              for ( int ii = 0; ii < ni; ii++ )
                ac +=
                  ai[ ii + ni * ( ic + nc * in ) ]
                  * w[ ic + nc * ( im + nm * ( ii + ni * io ) ) ];
            ao[ io + no * ( im + nm * in ) ] = ac;
          }
}



void
layer_init(Layer &l)
{
  Layer_Shape& s = l.s;
  int &ni = s.ni; // Number of input neurons.
  int &no = s.no; // Number of output neurons.
  int &nc = s.nc; // Number of input channels.
  int &nm = s.nm; // Number of output channels.
  int &nn = s.nn; // Number of batches.

  // Seed random number generator. Will generate the same sequence
  // of random numbers each time.
  srand48(2735);

  l.sz_ai_elts = ni * nc * nn;
  l.sz_ao_elts = no * nm * nn;
  l.sz_w_elts = nc * nm * ni * no;

  l.ai_h = new acc_t[l.sz_ai_elts];
  l.ao_h = new acc_t[l.sz_ao_elts];
  l.ao_check_h = new acc_t[l.sz_ao_elts];
  l.w_h = new wht_t[l.sz_w_elts];
  l.w2_h = new wht_t[l.sz_w_elts];

  l.sz_ai_bytes = l.sz_ai_elts * sizeof(*l.ai_d);
  l.sz_w_bytes = l.sz_w_elts * sizeof(*l.w_d);
  l.sz_ao_bytes = l.sz_ao_elts * sizeof(*l.ao_d);

  CE( cudaMalloc( &l.ai_d, l.sz_ai_bytes ) );
  CE( cudaMalloc( &l.w_d, l.sz_w_bytes ) );
  CE( cudaMalloc( &l.w2_d, l.sz_w_bytes ) );
  CE( cudaMalloc( &l.ao_d, l.sz_ao_bytes ) );

  acc_t* const ai = l.ai_h;
  acc_t* const ao = l.ao_check_h;
  wht_t* const w = l.w_h;

  const bool debug = false;
  const bool debug_w = false;

  // Initialize ai array.
  //
  for ( int in = 0; in < nn; in++ )
    for ( int ic = 0; ic < nc; ic++ )
      for ( int ii = 0; ii < ni; ii++ )
        {
          size_t idx_ai = ii + ni * ( ic + nc * in );
          ai[idx_ai] = debug ? ic : drand48();
        }

  // Initialize w array.
  //
  for ( size_t i=0; i<l.sz_w_elts; i++ ) w[i] = debug_w ? 1.0 : drand48()-0.5;

# pragma omp parallel for
  for ( size_t i=0; i<l.sz_ao_elts; i++ ) ao[i] = -1;

  // Compute correct result.
  //
# pragma omp parallel for
  for ( int in = 0; in < nn; in++ )
    for ( int im = 0; im < nm; im++ )
      for ( int io = 0; io < no; io++ )
        {
          acc_t ac = 0;
          for ( int ic = 0; ic < nc; ic++ )
            for ( int ii = 0; ii < ni; ii++ )
              {
                size_t idx_ai = ii + ni * ( ic + nc * in );
                size_t idx_w  = ic + nc * ( im + nm * ( ii + ni * io ) );
                ac += ai[ idx_ai ] * w[ idx_w ];
              }
          ao[ io + no * ( im + nm * in ) ] = ac;
        }


  /// Homework 1
  //
  // Initialize alternative (w2) array.
  //
# pragma omp parallel for
  for ( int im = 0; im < nm; im++ )
    for ( int io = 0; io < no; io++ )
      for ( int ic = 0; ic < nc; ic++ )
        for ( int ii = 0; ii < ni; ii++ )
          {
            size_t idx_w = ic + nc * ( im + nm * ( ii + ni * io ) );
            assert( idx_w < l.sz_w_elts );

            /// Homework 1: Modify line below to re-organize w2.
            size_t idx_w2 = ic + nc * ( im + nm * ( ii + ni * io ) ); 

            assert( idx_w2 < l.sz_w_elts );
            l.w2_h[idx_w2] = w[idx_w];
          }
}


GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  gpu_info_print();

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  return info;
}


///
/// Main Routine
///


int
main(int argc, char **argv)
{
  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  constexpr int wp_sz = 32;

  struct App_Kernel_Info {
    App_Kernel_Info(Kernel_Info& k,const char *name, int i):
      k_ptr(k.func_ptr),name_base(name),shape_idx{i}{}
    GPU_Info_Func k_ptr;
    const char *name_base;
    const int shape_idx;
  };

  vector<App_Kernel_Info> kernels;

  #define EXAMINE_KERNEL(k,sidx) \
    { const int idx = kernels.size(); \
      kernels.emplace_back(info.GET_INFO((k)),#k,sidx); }

  #define SPECIFY_KERNEL(k,sidx) \
    EXAMINE_KERNEL((k<ls[sidx].nn,ls[sidx].nc,ls[sidx].ni>),sidx);

  #define SPECIALIZE_KERNEL(sidx) \
    SPECIFY_KERNEL(dnn_base,sidx); \
    SPECIFY_KERNEL(dnn_sol_a,sidx); \
    SPECIFY_KERNEL(dnn_sol_b,sidx);

  SPECIALIZE_KERNEL(0);
  SPECIALIZE_KERNEL(1);

  #undef SPECIALIZE_KERNEL

  const bool want_kernel_info = true;
  if ( want_kernel_info )
    {
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
    }


  // Get number of multiprocessors. (A.k.a. streaming multiprocessors or SMs)
  //
  const int num_mp = info.cuda_prop.multiProcessorCount;

  // Examine argument 1, block count, default is number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
     arg1_int == 0 ? num_mp :
     arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of warps per block.
  //
  const int wp_per_block_arg = argc < 3 ? 0 : atoi(argv[2]);
  const int wp_per_block_goal =
   wp_per_block_arg == 0 ? 32 : wp_per_block_arg;
  const int n_threads = num_blocks * wp_per_block_goal * wp_sz;

  // If true, run kernels at multiple block sizes.
  //
  const bool vary_warps = wp_per_block_arg == 0;


  Layer layers[n_shapes];
  for ( int i=0; i<n_shapes; i++ )
    {
      Layer& l = layers[i];
      Layer_Shape& s = l.s;
      s = ls[i];
      layer_init(l);
      const size_t act_one_bytes =
        ( s.ni*s.nc + s.no*s.nm ) * sizeof(l.ai_h[0]);
      const size_t act_all_bytes = act_one_bytes * s.nn;
      printf("Layer shape %d: ni=no=%d.  nc=nm=%d. nn=%d.\n",
             i, s.ni, s.nc, s.nn);
      printf("  Number elts: activations %zd, weights %zd\n",
             l.sz_ai_elts + l.sz_ao_elts, l.sz_w_elts);
      printf("  Weights size: %zu kiB   L2 cache units: %.3f\n",
             l.sz_w_bytes >> 10,
             double(l.sz_w_bytes) / info.cuda_prop.l2CacheSize);
      printf("  Act size one batch  : %zu B   L2 cache units: %.3f\n",
             act_one_bytes,
             double(act_one_bytes) / info.cuda_prop.l2CacheSize);
      printf("  Act size all batches: %zu B   L2 cache units: %.3f\n",
             act_all_bytes,
             double(act_all_bytes) / info.cuda_prop.l2CacheSize);
    }

  if ( n_threads <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[COL PER MP]\n",
             argv[0]);
      exit(1);
    }


  // The width, in characters, of the output to which we are printing.
  //
  const int output_width = stdout_width_get();

  {
    // Prepare events used for timing.
    //
    cudaEvent_t gpu_start_ce, gpu_stop_ce;
    CE(cudaEventCreate(&gpu_start_ce));
    CE(cudaEventCreate(&gpu_stop_ce));

    // Copy input array from CPU to GPU.
    //
    for ( auto &l: layers )
      {
        CE( cudaMemcpy
            ( l.ai_d, l.ai_h, l.sz_ai_bytes, cudaMemcpyHostToDevice ) );
        CE( cudaMemcpy
            ( l.w_d, l.w_h, l.sz_w_bytes, cudaMemcpyHostToDevice ) );
        CE( cudaMemcpy
            ( l.w2_d, l.w2_h, l.sz_w_bytes, cudaMemcpyHostToDevice ) );
      }

    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d warps. \n",
           num_blocks, wp_per_block_goal);

    for ( auto& aki: kernels )
      {
        const char* kname = aki.name_base;
        const int sidx = aki.shape_idx;
        Layer& l = layers[sidx];
        const Layer_Shape s = l.s;

        printf("Kernel %s:\n", kname);
        pTable table(stdout);

        Kernel_Info* const ki = &info.get_info(aki.k_ptr);

        const int wp_limit = ki->cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary =
          min(wp_per_block_goal*wp_sz,thd_limit);

        const int wp_start = 1;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 1;

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            if ( vary_warps && wp_cnt > 4 && wp_cnt & 0x3 ) continue;


            /// Compute Expected Computation and Communication
            //
            // Number of multiply/add operations. Ignore everything else.
            //
            const int64_t num_ops_fp = l.sz_w_elts * s.nn;
            // Load and store instructions.
            const int64_t num_ops_ls =
              s.nn * l.sz_w_elts
              + s.no * s.nm * l.sz_ai_elts + l.sz_ao_elts;

            //
            // Amount of data in and out of GPU chip --- if perfect.
            //
            const int64_t amt_data_bytes =
              l.sz_w_bytes + l.sz_ai_bytes + l.sz_ao_bytes;

            {
              // Zero the output array.
              //
              CE(cudaMemset(l.ao_d,0,l.sz_ao_bytes));

              // Measure execution time starting "now", which is after data
              // set to GPU.
              //
              CE(cudaEventRecord(gpu_start_ce,0));

              typedef void (*KPtr)(Layer);

              /// Launch Kernel
              //
              KPtr(ki->func_ptr) <<< num_blocks, thd_per_block >>>(l);

              // Stop measuring execution time now, which is before is data
              // returned from GPU.
              //
              CE(cudaEventRecord(gpu_stop_ce,0));
              CE(cudaEventSynchronize(gpu_stop_ce));
              float cuda_time_ms = -1.1;
              CE( cudaEventElapsedTime
                  (&cuda_time_ms,gpu_start_ce,gpu_stop_ce) );

              const double this_elapsed_time_s = cuda_time_ms * 0.001;

              const double thpt_compute_gflops =
                num_ops_fp / this_elapsed_time_s * 1e-9;
              const double thpt_data_gbps =
                amt_data_bytes / this_elapsed_time_s * 1e-9;

              // Number of load/store operations per second.
              const double chip_ls_ops = info.chip_sp_flops / 4;

              const double t_bound_fp = num_ops_fp / info.chip_sp_flops;
              const double t_bound_ls = num_ops_ls / chip_ls_ops;
              const double t_bound_insn = t_bound_fp + t_bound_ls;

              {
                const double comp_frac = t_bound_insn / this_elapsed_time_s;
                //  1e9 * thpt_compute_gflops / info.chip_sp_flops;
                const double bw_frac =
                  1e9 * thpt_data_gbps / info.chip_bw_Bps;

                // Number of warps, rounded up.
                //
                const int num_wps = ( thd_per_block + 31 ) >> 5;

                // The maximum number of active blocks per MP for this
                // kernel when launched with a block size of thd_per_block.
                //
                const int max_bl_per_mp =
                  ki->get_max_active_blocks_per_mp(thd_per_block);

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

                // Based on the number of blocks, compute number of warps.
                //
                const int act_wps = num_wps * bl_per_mp;

                pTable_Row row(table);
                table.entry("nn","%2d",s.nn);
                table.entry("nc","%2d",s.nc);
                table.entry("ni","%2d",s.ni);
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry("FP θ","%4.0f", thpt_compute_gflops);
                table.entry("GB/s","%4.0f", thpt_data_gbps);

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);
                string util_hdr =
                  "--- Utilization: ++Compute++   **Data**  ";
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                const bool bw_more = bw_frac > comp_frac;
                const char* sym = bw_more ? "+*" : "*+";
                const double frac_min =  bw_more ? comp_frac : bw_frac;
                const double frac_max = !bw_more ? comp_frac : bw_frac;
                const size_t len_min = frac_min * max_st_len + 0.5;
                const size_t len_max = frac_max * max_st_len + 0.5;
                string bar = string( len_min, sym[0] ) +
                  string( len_max - len_min, sym[1] );

                table.entry(util_hdr,fmt, bar, pTable::pT_Left);
              }

              // Copy output array from GPU to CPU.
              //
              CE( cudaMemcpy
                  ( l.ao_h, l.ao_d, l.sz_ao_bytes, cudaMemcpyDefault) );
              {
                int err_count = 0;
                Layer_Shape& s = l.s;

                const int no = s.no; // Number of output neurons.
                const int nm = s.nm; // Number of output channels.
                const int nn = s.nn; // Number of batches.

                for ( int in = 0; in < nn; in++ )
                  for ( int im = 0; im < nm; im++ )
                    for ( int io = 0; io < no; io++ )
                      {
                        size_t idx = io + no * ( im + nm * in );
                        if ( fabs( l.ao_check_h[idx] - l.ao_h[idx] ) > 1e-4 )
                          {
                            err_count++;
                            if ( err_count < 5 )
                              printf
                                ("Error at %d, %d, %d: "
                                 "%.7f != %.7f (correct)\n",
                                 in, im, io, l.ao_h[idx],
                                 l.ao_check_h[idx]);
                          }}
                if ( err_count )
                  printf("Total errors %d\n", err_count);
              }
            }
          }
      }
  }
}