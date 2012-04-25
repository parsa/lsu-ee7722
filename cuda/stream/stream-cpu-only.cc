#include <stdio.h>
#include <stdlib.h>

struct Vector2 {
  double x, y;
};

void
dots(int size, Vector2 *a, double v0, double v1, double v2, double *b)
{
  for ( int i=0; i<size; i++ )
    {
      b[i] = v0 + v1 * a[i].x + v2 * a[i].y;
    }
}

int
main(int argc, char **argv)
{
  srand48(1);
  const int size_lg = argc > 1 ? atoi(argv[1]) : 10;
  const int size = 1 << size_lg;

  Vector2* const a = new Vector2[size];
  double* const b = new double[size];
  double xi = drand48();
  double yi = drand48();
  for ( int i=0; i<size; i++ )
    {
      a[i].x = xi; a[i].y = yi;
      xi += 0.1; yi += 0.1;
    }
  const double v0 = drand48();
  const double v1 = drand48();
  const double v2 = drand48();

  dots(size,a,v0,v1,v2,b);

  printf("Finished with %d elements, element %d is %.5f\n",
         size, argc, b[argc]);
}
