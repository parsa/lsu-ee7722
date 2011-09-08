
#if 0
struct Vector2 { float x, y; };
#else
typedef float2 Vector2;
#endif

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attrs, char **names, int max);

__host__ void dots_launch(dim3 dg, dim3 db);
