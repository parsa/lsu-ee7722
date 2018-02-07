
#if 1
struct __builtin_align__(2*sizeof(float)) __align__(2*sizeof(float))
 Vector2 { float x, y; };
#else
typedef float2 Vector2;
#endif

__host__ void dots_launch(dim3 dg, dim3 db);
__host__ void dots_iterate_launch(dim3 dg, dim3 db, int kernel);

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attrs, const char **names, int max);
