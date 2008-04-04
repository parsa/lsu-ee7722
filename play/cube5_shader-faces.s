!!ARBvp1.0
OPTION NV_vertex_program3;
# cgc version 2.0.0010, build date Dec 12 2007
# command line args: -profile vp40 -oglsl
# source file: cube5_shader.cc
#vendor NVIDIA Corporation
#version 2.0.0.10
#profile vp40
#program main_faces
#semantic gravity_force
#semantic gs_constant
#semantic damping_factor
#semantic gp_mass_inv
#semantic delta_t
#semantic ball_size
#semantic gl_ModelViewMatrix : state.matrix.modelview.transpose
#semantic gl_ModelViewProjectionMatrix : state.matrix.mvp.transpose
#semantic gl_NormalMatrix : state.matrix.modelview.inverse
#semantic gl_LightSource : state.light
#var float3 gravity_force :  :  : -1 : 0
#var float gs_constant :  :  : -1 : 0
#var float damping_factor :  :  : -1 : 0
#var float gp_mass_inv :  :  : -1 : 0
#var float delta_t :  :  : -1 : 0
#var float2 ball_size :  :  : -1 : 0
#var float step_last_time : $vin.ATTR1 : ATTR1 : -1 : 1
#var float4 position_left : $vin.ATTR2 : ATTR2 : -1 : 1
#var float4 position_right : $vin.ATTR3 : ATTR3 : -1 : 1
#var float4 position_above : $vin.ATTR4 : ATTR4 : -1 : 1
#var float4 position_below : $vin.ATTR5 : ATTR5 : -1 : 1
#var float3 velocity_left :  :  : -1 : 0
#var float3 velocity_right :  :  : -1 : 0
#var float3 velocity_above :  :  : -1 : 0
#var float3 velocity_below :  :  : -1 : 0
#var float3 in_velocity :  :  : -1 : 0
#var float3 in_force :  :  : -1 : 0
#var float3 in_extra : $vin.ATTR6 : ATTR6 : -1 : 1
#var float3 ball_position :  :  : -1 : 0
#var float3 ball_speed :  :  : -1 : 0
#var float4 out_position :  :  : -1 : 0
#var float3 out_velocity :  :  : -1 : 0
#var float3 out_force :  :  : -1 : 0
#var float3 out_extra :  :  : -1 : 0
#var float time_th : $vin.ATTR7 : ATTR7 : -1 : 1
#var float4 gl_TexCoord[0] : $vout.TEX0 : TEX0 : -1 : 1
#var float4 gl_TexCoord[1] :  :  : -1 : 0
#var float4 gl_TexCoord[2] :  :  : -1 : 0
#var float4 gl_TexCoord[3] :  :  : -1 : 0
#var float4 gl_TexCoord[4] :  :  : -1 : 0
#var float4 gl_TexCoord[5] :  :  : -1 : 0
#var float4 gl_TexCoord[6] :  :  : -1 : 0
#var float4 gl_TexCoord[7] :  :  : -1 : 0
#var float4 gl_Vertex : $vin.POSITION : POSITION : -1 : 1
#var float4x4 gl_ModelViewMatrix : state.matrix.modelview.transpose : c[0], 4 : -1 : 1
#var float4 gl_FrontColor : $vout.COLOR0 : COL0 : -1 : 1
#var float4 gl_MultiTexCoord0 : $vin.TEXCOORD0 : TEXCOORD0 : -1 : 1
#var float4 gl_BackColor : $vout.BCOL0 : BCOL0 : -1 : 1
#var float4x4 gl_ModelViewProjectionMatrix : state.matrix.mvp.transpose : c[4], 4 : -1 : 1
#var float4 gl_Position : $vout.POSITION : HPOS : -1 : 1
#var float3x3 gl_NormalMatrix : state.matrix.modelview.inverse : c[8], 3 : -1 : 1
#var float4 gl_LightSource[0].ambient : state.light[0].ambient :  : -1 : 0
#var float4 gl_LightSource[0].diffuse : state.light[0].diffuse :  : -1 : 0
#var float4 gl_LightSource[0].specular : state.light[0].specular :  : -1 : 0
#var float4 gl_LightSource[0].position : state.light[0].position :  : -1 : 0
#var float4 gl_LightSource[0].halfVector : state.light[0].half :  : -1 : 0
#var float3 gl_LightSource[0].spotDirection : state.light[0].spot.direction :  : -1 : 0
#var float gl_LightSource[0].spotExponent : state.light[0].attenuation.w :  : -1 : 0
#var float gl_LightSource[0].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[0].spotCosCutoff : state.light[0].spot.direction.w :  : -1 : 0
#var float gl_LightSource[0].constantAttenuation : state.light[0].attenuation.x :  : -1 : 0
#var float gl_LightSource[0].linearAttenuation : state.light[0].attenuation.y :  : -1 : 0
#var float gl_LightSource[0].quadraticAttenuation : state.light[0].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[1].ambient : state.light[1].ambient : c[11] : -1 : 1
#var float4 gl_LightSource[1].diffuse : state.light[1].diffuse : c[12] : -1 : 1
#var float4 gl_LightSource[1].specular : state.light[1].specular :  : -1 : 0
#var float4 gl_LightSource[1].position : state.light[1].position : c[13] : -1 : 1
#var float4 gl_LightSource[1].halfVector : state.light[1].half :  : -1 : 0
#var float3 gl_LightSource[1].spotDirection : state.light[1].spot.direction :  : -1 : 0
#var float gl_LightSource[1].spotExponent : state.light[1].attenuation.w :  : -1 : 0
#var float gl_LightSource[1].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[1].spotCosCutoff : state.light[1].spot.direction.w :  : -1 : 0
#var float gl_LightSource[1].constantAttenuation : state.light[1].attenuation.x :  : -1 : 0
#var float gl_LightSource[1].linearAttenuation : state.light[1].attenuation.y :  : -1 : 0
#var float gl_LightSource[1].quadraticAttenuation : state.light[1].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[2].ambient : state.light[2].ambient :  : -1 : 0
#var float4 gl_LightSource[2].diffuse : state.light[2].diffuse :  : -1 : 0
#var float4 gl_LightSource[2].specular : state.light[2].specular :  : -1 : 0
#var float4 gl_LightSource[2].position : state.light[2].position :  : -1 : 0
#var float4 gl_LightSource[2].halfVector : state.light[2].half :  : -1 : 0
#var float3 gl_LightSource[2].spotDirection : state.light[2].spot.direction :  : -1 : 0
#var float gl_LightSource[2].spotExponent : state.light[2].attenuation.w :  : -1 : 0
#var float gl_LightSource[2].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[2].spotCosCutoff : state.light[2].spot.direction.w :  : -1 : 0
#var float gl_LightSource[2].constantAttenuation : state.light[2].attenuation.x :  : -1 : 0
#var float gl_LightSource[2].linearAttenuation : state.light[2].attenuation.y :  : -1 : 0
#var float gl_LightSource[2].quadraticAttenuation : state.light[2].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[3].ambient : state.light[3].ambient :  : -1 : 0
#var float4 gl_LightSource[3].diffuse : state.light[3].diffuse :  : -1 : 0
#var float4 gl_LightSource[3].specular : state.light[3].specular :  : -1 : 0
#var float4 gl_LightSource[3].position : state.light[3].position :  : -1 : 0
#var float4 gl_LightSource[3].halfVector : state.light[3].half :  : -1 : 0
#var float3 gl_LightSource[3].spotDirection : state.light[3].spot.direction :  : -1 : 0
#var float gl_LightSource[3].spotExponent : state.light[3].attenuation.w :  : -1 : 0
#var float gl_LightSource[3].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[3].spotCosCutoff : state.light[3].spot.direction.w :  : -1 : 0
#var float gl_LightSource[3].constantAttenuation : state.light[3].attenuation.x :  : -1 : 0
#var float gl_LightSource[3].linearAttenuation : state.light[3].attenuation.y :  : -1 : 0
#var float gl_LightSource[3].quadraticAttenuation : state.light[3].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[4].ambient : state.light[4].ambient :  : -1 : 0
#var float4 gl_LightSource[4].diffuse : state.light[4].diffuse :  : -1 : 0
#var float4 gl_LightSource[4].specular : state.light[4].specular :  : -1 : 0
#var float4 gl_LightSource[4].position : state.light[4].position :  : -1 : 0
#var float4 gl_LightSource[4].halfVector : state.light[4].half :  : -1 : 0
#var float3 gl_LightSource[4].spotDirection : state.light[4].spot.direction :  : -1 : 0
#var float gl_LightSource[4].spotExponent : state.light[4].attenuation.w :  : -1 : 0
#var float gl_LightSource[4].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[4].spotCosCutoff : state.light[4].spot.direction.w :  : -1 : 0
#var float gl_LightSource[4].constantAttenuation : state.light[4].attenuation.x :  : -1 : 0
#var float gl_LightSource[4].linearAttenuation : state.light[4].attenuation.y :  : -1 : 0
#var float gl_LightSource[4].quadraticAttenuation : state.light[4].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[5].ambient : state.light[5].ambient :  : -1 : 0
#var float4 gl_LightSource[5].diffuse : state.light[5].diffuse :  : -1 : 0
#var float4 gl_LightSource[5].specular : state.light[5].specular :  : -1 : 0
#var float4 gl_LightSource[5].position : state.light[5].position :  : -1 : 0
#var float4 gl_LightSource[5].halfVector : state.light[5].half :  : -1 : 0
#var float3 gl_LightSource[5].spotDirection : state.light[5].spot.direction :  : -1 : 0
#var float gl_LightSource[5].spotExponent : state.light[5].attenuation.w :  : -1 : 0
#var float gl_LightSource[5].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[5].spotCosCutoff : state.light[5].spot.direction.w :  : -1 : 0
#var float gl_LightSource[5].constantAttenuation : state.light[5].attenuation.x :  : -1 : 0
#var float gl_LightSource[5].linearAttenuation : state.light[5].attenuation.y :  : -1 : 0
#var float gl_LightSource[5].quadraticAttenuation : state.light[5].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[6].ambient : state.light[6].ambient :  : -1 : 0
#var float4 gl_LightSource[6].diffuse : state.light[6].diffuse :  : -1 : 0
#var float4 gl_LightSource[6].specular : state.light[6].specular :  : -1 : 0
#var float4 gl_LightSource[6].position : state.light[6].position :  : -1 : 0
#var float4 gl_LightSource[6].halfVector : state.light[6].half :  : -1 : 0
#var float3 gl_LightSource[6].spotDirection : state.light[6].spot.direction :  : -1 : 0
#var float gl_LightSource[6].spotExponent : state.light[6].attenuation.w :  : -1 : 0
#var float gl_LightSource[6].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[6].spotCosCutoff : state.light[6].spot.direction.w :  : -1 : 0
#var float gl_LightSource[6].constantAttenuation : state.light[6].attenuation.x :  : -1 : 0
#var float gl_LightSource[6].linearAttenuation : state.light[6].attenuation.y :  : -1 : 0
#var float gl_LightSource[6].quadraticAttenuation : state.light[6].attenuation.z :  : -1 : 0
#var float4 gl_LightSource[7].ambient : state.light[7].ambient :  : -1 : 0
#var float4 gl_LightSource[7].diffuse : state.light[7].diffuse :  : -1 : 0
#var float4 gl_LightSource[7].specular : state.light[7].specular :  : -1 : 0
#var float4 gl_LightSource[7].position : state.light[7].position :  : -1 : 0
#var float4 gl_LightSource[7].halfVector : state.light[7].half :  : -1 : 0
#var float3 gl_LightSource[7].spotDirection : state.light[7].spot.direction :  : -1 : 0
#var float gl_LightSource[7].spotExponent : state.light[7].attenuation.w :  : -1 : 0
#var float gl_LightSource[7].spotCutoff : NONE :  : -1 : 0
#var float gl_LightSource[7].spotCosCutoff : state.light[7].spot.direction.w :  : -1 : 0
#var float gl_LightSource[7].constantAttenuation : state.light[7].attenuation.x :  : -1 : 0
#var float gl_LightSource[7].linearAttenuation : state.light[7].attenuation.y :  : -1 : 0
#var float gl_LightSource[7].quadraticAttenuation : state.light[7].attenuation.z :  : -1 : 0
#const c[14] = 0.065490201 0.094901964 0.034901958 0
#const c[15] = 0.57735002 1 0.89999998
#const c[16] = 0.34509805 0.050980393 0.65098041
PARAM c[17] = { state.matrix.modelview.transpose,
		state.matrix.mvp.transpose,
		state.matrix.modelview.inverse.row[0..2],
		state.light[1].ambient,
		state.light[1].diffuse,
		state.light[1].position,
		{ 0.065490201, 0.094901964, 0.034901958, 0 },
		{ 0.57735002, 1, 0.89999998 },
		{ 0.34509805, 0.050980393, 0.65098041 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP RC, HC;
BB1:
MOV   R1.x, vertex.attrib[7];
SGTC  HC.x, vertex.attrib[6], R1;
MOV   R0.x, vertex.attrib[6];
ADD   R0.x, vertex.attrib[1], -R0;
MUL   R0.xyz, R0.x, c[14];
MOV   R1.x, c[14].w;
ADD   R0.xyz, c[16], R0;
MOV   R0.w, c[15].z;
MOV   R0(EQ.x), c[15].yyyz;
MOVC  RC.x, vertex.attrib[6].z;
MOV   R1.x(EQ), c[15].y;
MOVC  RC.x, R1;
MOV   R3.xyz, c[15].x;
BRA   BB3 (LE.x);
BB2:
MOV   R1.xyz, vertex.position;
ADD   R5.xyz, -R1, vertex.attrib[5];
ADD   R4.xyz, -R1, vertex.attrib[3];
ADD   R2.xyz, -R1, vertex.attrib[4];
ADD   R1.xyz, vertex.attrib[2], -R1;
MUL   R3.xyz, R1.zxyw, R2.yzxw;
MUL   R6.xyz, R4.zxyw, R5.yzxw;
MAD   R1.xyz, R1.yzxw, R2.zxyw, -R3;
MAD   R4.xyz, R4.yzxw, R5.zxyw, -R6;
ADD   R1.xyz, R1, R4;
DP3   R1.w, R1, R1;
RSQ   R1.w, R1.w;
MUL   R3.xyz, R1.w, R1;
BB3:
MUL   R4.xyz, R3.y, c[9];
MUL   R1, vertex.position.y, c[1];
MAD   R1, vertex.position.x, c[0], R1;
MAD   R1, vertex.position.z, c[2], R1;
MAD   R1, vertex.position.w, c[3], R1;
ADD   R2, c[13], -R1;
DP4   R1.w, R2, R2;
RSQ   R1.w, R1.w;
MAD   R4.xyz, R3.x, c[8], R4;
MAD   R3.xyz, R3.z, c[10], R4;
DP3   R1.y, R3, -R1;
MUL   R2.xyz, R1.w, R2;
DP3   R1.w, R3, R2;
MOV   R1.x, |R1.w|;
SSG   R1.z, R1.w;
SSG   R1.y, R1;
SEQC  HC.x, R1.z, R1.y;
MOV   R1.x(EQ), c[14].w;
MUL   R1.xyz, R1.x, c[12];
ADD   R1.xyz, c[11], R1;
MUL   result.color.xyz, R0, R1;
MUL   R1, vertex.position.y, c[5];
MAD   R1, vertex.position.x, c[4], R1;
MAD   R1, vertex.position.z, c[6], R1;
MOV   result.color.w, R0;
MOV   result.color.back, R0;
MAD   result.position, vertex.position.w, c[7], R1;
MOV   result.texcoord[0], vertex.texcoord[0];
END
# 55 instructions, 7 R-regs
