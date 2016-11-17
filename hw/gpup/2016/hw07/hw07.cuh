
struct CWorld {

  float *ball_mass, *ball_fdt_to_do;
  float4 *force, *ball_torque, *ball_position, *ball_velocity;
  float4 *ball_omega, *ball_orientation;


};




struct CUDA_Ball_X { // X is for transpose.
  float4 *position;
  float4 *orientation;
  float4 *velocity;
  float4 *prev_velocity;
  float4 *omega;
  int4 *tact_counts;
  float4 *ball_props;
  float4 *to_111;
};
