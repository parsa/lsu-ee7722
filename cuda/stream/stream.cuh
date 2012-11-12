struct Vector2 {
  float x, y;
};

__host__ void dots_launch(dim3 dg, dim3 db);
__host__ void device_addr_get();
