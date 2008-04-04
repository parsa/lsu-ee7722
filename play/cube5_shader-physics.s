!!ARBvp1.0
OPTION NV_vertex_program3;
# cgc version 2.0.0010, build date Dec 12 2007
# command line args: -profile vp40 -oglsl
# source file: cube5_shader.cc
#vendor NVIDIA Corporation
#version 2.0.0.10
#profile vp40
#program main_physics
#semantic gravity_force
#semantic gs_constant
#semantic damping_factor
#semantic gp_mass_inv
#semantic delta_t
#semantic ball_size
#semantic gl_ModelViewMatrix : state.matrix.modelview.transpose
#var float3 gravity_force :  : c[0] : -1 : 1
#var float gs_constant :  : c[1] : -1 : 1
#var float damping_factor :  : c[2] : -1 : 1
#var float gp_mass_inv :  : c[3] : -1 : 1
#var float delta_t :  : c[4] : -1 : 1
#var float2 ball_size :  : c[5] : -1 : 1
#var float step_last_time : $vin.ATTR1 : ATTR1 : -1 : 1
#var float4 position_left : $vin.ATTR2 : ATTR2 : -1 : 1
#var float4 position_right : $vin.ATTR3 : ATTR3 : -1 : 1
#var float4 position_above : $vin.ATTR4 : ATTR4 : -1 : 1
#var float4 position_below : $vin.ATTR5 : ATTR5 : -1 : 1
#var float3 velocity_left : $vin.ATTR6 : ATTR6 : -1 : 1
#var float3 velocity_right : $vin.ATTR7 : ATTR7 : -1 : 1
#var float3 velocity_above : $vin.ATTR8 : ATTR8 : -1 : 1
#var float3 velocity_below : $vin.ATTR9 : ATTR9 : -1 : 1
#var float3 in_velocity : $vin.ATTR10 : ATTR10 : -1 : 1
#var float3 in_force : $vin.ATTR11 : ATTR11 : -1 : 1
#var float3 in_extra : $vin.ATTR12 : ATTR12 : -1 : 1
#var float3 ball_position : $vin.ATTR13 : ATTR13 : -1 : 1
#var float3 ball_speed : $vin.ATTR14 : ATTR14 : -1 : 1
#var float4 out_position : $vout.TEX0 : TEX0 : -1 : 1
#var float3 out_velocity : $vout.TEX1 : TEX1 : -1 : 1
#var float3 out_force : $vout.TEX2 : TEX2 : -1 : 1
#var float3 out_extra : $vout.TEX3 : TEX3 : -1 : 1
#var float time_th :  :  : -1 : 0
#var float4 gl_Vertex : $vin.POSITION : POSITION : -1 : 1
#var float4x4 gl_ModelViewMatrix : state.matrix.modelview.transpose : c[6], 4 : -1 : 1
#var float4 gl_FrontColor : $vout.COLOR0 : COL0 : -1 : 1
#var float4 gl_Position : $vout.POSITION : HPOS : -1 : 1
#const c[10] = 4 0.5 0.16666667 1
#const c[11] = 0 2 1 -1
PARAM c[12] = { program.local[0..5],
		state.matrix.modelview.transpose,
		{ 4, 0.5, 0.16666667, 1 },
		{ 0, 2, 1, -1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
TEMP RC, HC;
BB1:
MOVC  RC.x, vertex.attrib[12].z;
BRA   BB3 (EQ.x);
BB2:
MUL   R0, vertex.attrib[11].y, c[7];
MAD   R0, vertex.attrib[11].x, c[6], R0;
MAD   R0, vertex.attrib[11].z, c[8], R0;
ADD   R1, c[9], R0;
ADD   R2.xyz, -vertex.position, R1;
RCP   R0.w, c[4].x;
MUL   R2.xyz, R2, R0.w;
MOV   R0.xyz, R1;
MOV   result.texcoord[0], R1;
MOV   R1.xyz, R2;
MOV   result.texcoord[1].xyz, R2;
MOV   result.texcoord[2].xyz, vertex.attrib[11];
BRA   BB4;
BB3:
MOV   R0.xyz, vertex.attrib[3];
ADD   R0.xyz, vertex.attrib[2], R0;
ADD   R1.xyz, vertex.attrib[4], R0;
MOV   R0.xyz, vertex.attrib[7];
ADD   R1.xyz, vertex.attrib[5], R1;
ADD   R0.xyz, vertex.attrib[6], R0;
MAD   R1.xyz, -vertex.position, c[10].x, R1;
ADD   R0.xyz, vertex.attrib[8], R0;
MUL   R1.xyz, R1, c[1].x;
ADD   R0.xyz, vertex.attrib[9], R0;
ADD   R1.xyz, c[0], R1;
MAD   R0.xyz, -vertex.attrib[10], c[10].x, R0;
MAD   R2.xyz, R0, c[2].x, R1;
ADD   R1.xyz, -vertex.attrib[11], R2;
MUL   R0.xyz, R1, c[4].x;
MUL   R0.w, c[4].x, c[4].x;
MUL   R1.xyz, R1, R0.w;
MUL   R3.xyz, R1, c[10].z;
MUL   R0.xyz, R0, c[10].y;
MUL   R1.xyz, R2, R0.w;
MAD   R1.xyz, R1, c[10].y, R3;
MAD   R0.xyz, R2, c[4].x, -R0;
MAD   R3.xyz, R0, c[3].x, vertex.attrib[10];
MUL   R1.xyz, R1, c[3].x;
MAD   R0.xyz, R3, c[4].x, R1;
ADD   R0.xyz, vertex.position, R0;
MOV   result.texcoord[0].xyz, R0;
MOV   R1.xyz, R3;
MOV   result.texcoord[1].xyz, R3;
MOV   result.texcoord[2].xyz, R2;
MOV   result.texcoord[0].w, c[10];
BB4:
ADD   R2.xyz, R0, -vertex.attrib[13];
DP3   R1.w, R2, R2;
SLEC  HC.x, R1.w, c[5].y;
MOV   result.position, c[11].yyyz;
MOV   result.texcoord[3].xyz, vertex.attrib[12];
SNE   R0.w, vertex.attrib[12].z, c[11].x;
BRA   BB9 (LE.x);
BB5:
DP3   R1.w, R2, R2;
RSQ   R1.w, R1.w;
MOV   R3.xyz, vertex.attrib[10];
MOVC  RC.x, R0.w;
MUL   R2.xyz, R1.w, R2;
ADD   R3.xyz, vertex.attrib[14], -R3;
MOV   result.texcoord[3].x, vertex.attrib[1];
BRA   BB7 (LE.x);
BB6:
MOV   R4.xyz, -R2;
BRA   BB8;
BB7:
MOV   R4.xyz, vertex.position;
ADD   R5.xyz, -R4, vertex.attrib[3];
ADD   R7.xyz, -R4, vertex.attrib[4];
ADD   R6.xyz, -R4, vertex.attrib[2];
MUL   R8.xyz, R6.yzxw, R7.zxyw;
MAD   R9.xyz, R6.zxyw, R7.yzxw, -R8;
MUL   R8.xyz, R5.zxyw, R7.yzxw;
DP3   R1.w, R9, R9;
MAD   R7.xyz, R5.yzxw, R7.zxyw, -R8;
RSQ   R2.w, R1.w;
DP3   R1.w, R7, R7;
MUL   R8.xyz, R2.w, R9;
RSQ   R1.w, R1.w;
ADD   R4.xyz, vertex.attrib[5], -R4;
MAD   R9.xyz, R1.w, R7, R8;
MUL   R8.xyz, R4.yzxw, R6.zxyw;
MAD   R6.xyz, R4.zxyw, R6.yzxw, -R8;
MUL   R7.xyz, R4.zxyw, R5.yzxw;
MAD   R4.xyz, R4.yzxw, R5.zxyw, -R7;
DP3   R1.w, R4, R4;
DP3   R2.w, R6, R6;
RSQ   R2.w, R2.w;
MAD   R5.xyz, R2.w, R6, R9;
RSQ   R1.w, R1.w;
MAD   R4.xyz, R1.w, R4, R5;
MUL   R4.xyz, R4, vertex.attrib[12].y;
BB8:
MOV   result.texcoord[0].xyz, R0;
MOVC  RC.x, R0.w;
DP3   R0.x, R4, R4;
RSQ   R0.x, R0.x;
MUL   R0.xyz, R0.x, R4;
DP3   R0.w, R0, R3;
MUL   R0.xyz, -R0.w, R0;
MOV   R0.w, -R0;
MAD   result.texcoord[0].xyz(EQ.x), R2, c[5].x, vertex.attrib[13];
MOV   result.color, R0;
ADD   result.texcoord[1].xyz, R1, -R0;
MOV   result.position, c[11].wwxz;
BB9:
END
# 101 instructions, 10 R-regs
