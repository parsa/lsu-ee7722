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
#semantic time_th
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
#var float contact_time :  :  : -1 : 0
#var float4 gl_Vertex : $vin.POSITION : POSITION : -1 : 1
#var float4x4 gl_ModelViewMatrix : state.matrix.modelview.transpose : c[6], 4 : -1 : 1
#var float4 gl_FrontColor : $vout.COLOR0 : COL0 : -1 : 1
#var float4 gl_Position : $vout.POSITION : HPOS : -1 : 1
#const c[10] = 4 0.5 0.16666667 1
#const c[11] = 0 2 1 -1.5
#const c[12] = -1 0 1
PARAM c[13] = { program.local[0..5],
		state.matrix.modelview.transpose,
		{ 4, 0.5, 0.16666667, 1 },
		{ 0, 2, 1, -1.5 },
		{ -1, 0, 1 } };
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
ADD   R2, c[9], R0;
ADD   R3.xyz, -vertex.position, R2;
RCP   R0.w, c[4].x;
MUL   R3.xyz, R3, R0.w;
MOV   R0.xyz, R2;
MOV   result.texcoord[0], R2;
MOV   R2.xyz, R3;
MOV   result.texcoord[1].xyz, R3;
MOV   result.texcoord[2].xyz, vertex.attrib[11];
BRA   BB4;
BB3:
MOV   R0.xyz, vertex.attrib[3];
ADD   R0.xyz, vertex.attrib[2], R0;
ADD   R2.xyz, vertex.attrib[4], R0;
MOV   R0.xyz, vertex.attrib[7];
ADD   R2.xyz, vertex.attrib[5], R2;
ADD   R0.xyz, vertex.attrib[6], R0;
MAD   R2.xyz, -vertex.position, c[10].x, R2;
ADD   R0.xyz, vertex.attrib[8], R0;
MUL   R2.xyz, R2, c[1].x;
ADD   R0.xyz, vertex.attrib[9], R0;
ADD   R2.xyz, c[0], R2;
MAD   R0.xyz, -vertex.attrib[10], c[10].x, R0;
MAD   R3.xyz, R0, c[2].x, R2;
ADD   R2.xyz, -vertex.attrib[11], R3;
MUL   R0.xyz, R2, c[4].x;
MUL   R0.w, c[4].x, c[4].x;
MUL   R2.xyz, R2, R0.w;
MUL   R4.xyz, R2, c[10].z;
MUL   R0.xyz, R0, c[10].y;
MUL   R2.xyz, R3, R0.w;
MAD   R2.xyz, R2, c[10].y, R4;
MAD   R0.xyz, R3, c[4].x, -R0;
MAD   R4.xyz, R0, c[3].x, vertex.attrib[10];
MUL   R2.xyz, R2, c[3].x;
MAD   R0.xyz, R4, c[4].x, R2;
ADD   R0.xyz, vertex.position, R0;
MOV   result.texcoord[0].xyz, R0;
MOV   R2.xyz, R4;
MOV   result.texcoord[1].xyz, R4;
MOV   result.texcoord[2].xyz, R3;
MOV   result.texcoord[0].w, c[10];
BB4:
ADD   R3.xyz, R0, -vertex.attrib[13];
DP3   R0.w, R3, R3;
SLE   R0.w, R0, c[5].y;
MOVC  RC.x, R0.w;
MOV   result.position, c[11].yyyz;
MOV   result.texcoord[3].xyz, vertex.attrib[12];
SNE   R2.w, vertex.attrib[12].z, c[11].x;
BRA   BB9 (LE.x);
BB5:
DP3   R3.w, R3, R3;
RSQ   R3.w, R3.w;
MOVC  RC.x, R2.w;
MUL   R3.xyz, R3.w, R3;
MOV   R4.xyz, c[11].x;
MOV   result.texcoord[3].x, vertex.attrib[1];
BRA   BB7 (LE.x);
BB6:
MOV   R0.w, c[11].x;
BRA   BB8;
BB7:
MOV   R4.xyz, vertex.position;
ADD   R5.xyz, vertex.attrib[3], -R4;
ADD   R6.xyz, -R4, vertex.attrib[4];
ADD   R8.xyz, -R4, vertex.attrib[2];
MUL   R7.xyz, R5.zxyw, R6.yzxw;
MAD   R7.xyz, R5.yzxw, R6.zxyw, -R7;
MUL   R9.xyz, R6.zxyw, R8.yzxw;
MAD   R6.xyz, R6.yzxw, R8.zxyw, -R9;
ADD   R4.xyz, -R4, vertex.attrib[5];
ADD   R6.xyz, R7, R6;
MUL   R7.xyz, R8.zxyw, R4.yzxw;
MUL   R9.xyz, R5.yzxw, R4.zxyw;
MAD   R7.xyz, R8.yzxw, R4.zxyw, -R7;
MAD   R4.xyz, R5.zxyw, R4.yzxw, -R9;
ADD   R5.xyz, R6, R7;
ADD   R4.xyz, R5, R4;
MUL   R4.xyz, R4, vertex.attrib[12].y;
BB8:
SEQ   R2.w, R2, c[11].x;
MULC  HC.x, R0.w, R2.w;
MOV   result.texcoord[0].xyz, R0;
MAD   result.texcoord[0].xyz(NE.x), R3, c[5].x, vertex.attrib[13];
MOV   result.color.xyz, R1;
DP3   R2.w, R4, R4;
RSQ   R2.w, R2.w;
MOV   R0.xyz, vertex.attrib[10];
MOVC  RC.x, R0.w;
MOV   R1.xyz, c[12];
MOV   R1.xyz(EQ.x), c[11].yyzw;
MUL   R3.xyz, R2.w, R4;
ADD   R0.xyz, vertex.attrib[14], -R0;
DP3   R2.w, R3, R0;
MUL   R0.xyz, -R2.w, R3;
MOV   result.texcoord[1].xyz, R2;
MAD   result.texcoord[1].xyz(NE.x), R0, c[11].w, R2;
MOV   result.color.xyz(NE.x), R0;
MOV   R0.x, R1.w;
MOV   R0.x(NE), -R2.w;
MOV   result.color.w, R0.x;
MOV   result.position, R1.xxyz;
BB9:
END
# 102 instructions, 10 R-regs
