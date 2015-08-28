#include <stdio.h>
#include <string.h>
#include "../include/coord.h"

void
sample_code()
{
  // This routine contains examples of how to use the geometric
  // classes such as coordinate, vertex, and matrix.  It is not
  // supposed to do anything useful.

  // For more details on these classes read the code in coord.h.


  /// Coordinate Construction
  //

  // Construct a coordinate with default w value.
  //
  pCoor c1(11,22,33);  // w is 1 by default.
  printf("x component of c1 is %.1f\n",c1.x);

  // Change c1 to (4,7,0)
  //
  c1.x = 4;  c1.y = 7;  c1.z = 0;

  // Construct a coordinate with non-default w value.
  //
  pCoor c2(1,2,3,0.5); // w is 0.5

  pCoor c3;     // Declare a coordinate without initializing it.
  c3 = c2;
  c2.x = c1.y;

  /// Vector Class
  //

  // Construct using x, y, and z components.
  //
  pVect vec(1,2,3);

  // A slightly tedious way of initializing a vector.
  //
  pVect v2;
  v2.x = 1;  v2.y = 2; v2.z = 3;

  pVect v3;
  v3 = c3 - c2;        // Result of subtracting coordinates is a vector.
  pVect v4 = c3 - c2;  // Ditto.


  /// Vector Operations

  pVect v5 = 0.6 * v4;  // Scalar multiplication.
  pVect v6 = v5 + v4;   // Vector addition.
  float l1 = v6.mag();  // Magnitude (length) of v6.

  /// Normalized Vector
  //
  {
    pVect some_random_vector(5,6,7);

    // Construct a normalized version of some_random_vector the hard way.
    //
    float srv_mag = some_random_vector.mag();
    pVect srv_n_h = some_random_vector / srv_mag;

    // Construct a normalized version of some_random_vector the easy way.
    //
    pNorm srv_n(some_random_vector);

    // Construct a unit vector between two coordinates.
    //
    pCoor c1(1,2,3);
    pCoor c2(4,5,6);
    pNorm nvec(c1,c2);  // Unit (normalized) vector from c1 to c2.

    // Get the distance from c1 to c2.
    //
    float distance_c1_c2 = nvec.magnitude;

    pVect c1_velocity(7,8,9);
    float speed_c1_to_c2 = dot( c1_velocity, nvec );

  }


  /// :Sample Problem:
  //
  // Johnny at p_jo throws a ball towards Sally at p_sa, but only
  // throws the ball 2 units of distance. Assign the location to p4.

  // Step 1 - Define Johnny and Sally's coordinates.
  //
  pCoor p_jo(1,2,3);      // Johnny's location.
  pCoor p_sa(10,11,12);  // Sally's location.

  // Step 2 - Compute unit vector from Johnny to Sally.
  //
  pNorm jo_to_sa(p_jo,p_sa);

  // Step 3 - Use unit vector to find point two units from Johnny in
  // the direction of Sally.
  //
  pCoor p4 = p_jo + 2 * jo_to_sa;



  /// Computing Dot Products, Cross Products, and Angles

  float l2 = dot(v5,v6);   // Dot product.

  pVect v7 = cross(v5,v6); // Cross product.

  pVect c1223b = cross(c1,c2,c3);       // Cross product (c1-c2) x (c3-c2).

  float a1223a = pangle(vec_21,vec_23); // Angle between vectors, in [0,pi].
  float a1223b = pangle(c1,c2,c3);      // Angle between c1 c2 c3, in [0,pi].


  /// Automatically Constructing a Vector from Coordinates.

  // Construct vector vec_12 using two coords, result is c2 - c1.
  pVect vec_12(c1,c2);    
  vec_12 = c2 - c1;  // No change to vec_12, the constructor already subtr.

  pVect vec_xa(v1,v2);    // Cross product: v1 x v2
  pVect vec_xb(c1,c2,c3); // Cross product: (c1-c2) x (c3-c2).


  /// Coordinate and Vector Operators
  //
  pVect vec_12b = c2 - c1;   // Subtraction of coords yields vector.
  pVect vec_12c = v2 - v1;   // Vector subtraction.
  pCoor c2c = c1 + vec_12b;  // Coord + vec yields a coordinate.
  pVect vscaled = 5 * vec_12b;  // Multiply each element.


  /// Coordinate Member Functions
  //
  cx1.homogenize();         // Divide all elements by w
  cx1.homogenize_keep_w();  // Divide x, y, and z by w. (Be careful.)

  /// Vector Member Functions
  //
  float length_12b = vec_12b.mag();  // Length of vector.
  float length_12c = vec_12c.normalize();  // Return length, then normalize.




}


int
main(int argc, char **argv)
{

}
