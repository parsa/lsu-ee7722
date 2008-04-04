!!ARBvp1.0
OPTION NV_vertex_program3;
# cgc version 2.0.0010, build date Dec 12 2007
# command line args: -profile vp40 -oglsl
# source file: cube4_vshader.cc
#vendor NVIDIA Corporation
#version 2.0.0.10
#profile vp40
#program vs_main_circle
#semantic gl_ModelViewMatrix : state.matrix.modelview.transpose
#semantic gl_ObjectPlaneS : state.texgen.object.s
#semantic gl_ObjectPlaneT : state.texgen.object.t
#semantic gl_NormalMatrix : state.matrix.modelview.inverse
#semantic gl_LightSource : state.light
#semantic gl_ModelViewProjectionMatrix : state.matrix.mvp.transpose
#var float3 bump_info : $vin.ATTR1 : ATTR1 : -1 : 1
#var float4 pinnacle :  :  : -1 : 0
#var float4 gl_Vertex : $vin.POSITION : POSITION : -1 : 1
#var float4x4 gl_ModelViewMatrix : state.matrix.modelview.transpose : c[0], 4 : -1 : 1
#var float3 gl_Normal : $vin.NORMAL : NORMAL : -1 : 1
#var float4 gl_BackColor : $vout.BCOL0 : BCOL0 : -1 : 1
#var float4 gl_FrontColor : $vout.COLOR0 : COL0 : -1 : 1
#var float4 gl_ObjectPlaneS[0] : state.texgen[0].object.s : c[4] : -1 : 1
#var float4 gl_ObjectPlaneS[1] : state.texgen[1].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[2] : state.texgen[2].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[3] : state.texgen[3].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[4] : state.texgen[4].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[5] : state.texgen[5].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[6] : state.texgen[6].object.s :  : -1 : 0
#var float4 gl_ObjectPlaneS[7] : state.texgen[7].object.s :  : -1 : 0
#var float4 gl_TexCoord[0] : $vout.TEX0 : TEX0 : -1 : 1
#var float4 gl_TexCoord[1] :  :  : -1 : 0
#var float4 gl_TexCoord[2] :  :  : -1 : 0
#var float4 gl_TexCoord[3] :  :  : -1 : 0
#var float4 gl_TexCoord[4] :  :  : -1 : 0
#var float4 gl_TexCoord[5] :  :  : -1 : 0
#var float4 gl_TexCoord[6] :  :  : -1 : 0
#var float4 gl_TexCoord[7] :  :  : -1 : 0
#var float4 gl_Color : $vin.COLOR0 : COLOR0 : -1 : 1
#var float4 gl_ObjectPlaneT[0] : state.texgen[0].object.t : c[5] : -1 : 1
#var float4 gl_ObjectPlaneT[1] : state.texgen[1].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[2] : state.texgen[2].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[3] : state.texgen[3].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[4] : state.texgen[4].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[5] : state.texgen[5].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[6] : state.texgen[6].object.t :  : -1 : 0
#var float4 gl_ObjectPlaneT[7] : state.texgen[7].object.t :  : -1 : 0
#var float4 gl_Position : $vout.POSITION : HPOS : -1 : 1
#var float3x3 gl_NormalMatrix : state.matrix.modelview.inverse : c[6], 3 : -1 : 1
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
#var float4 gl_LightSource[1].ambient : state.light[1].ambient : c[9] : -1 : 1
#var float4 gl_LightSource[1].diffuse : state.light[1].diffuse : c[10] : -1 : 1
#var float4 gl_LightSource[1].specular : state.light[1].specular :  : -1 : 0
#var float4 gl_LightSource[1].position : state.light[1].position : c[11] : -1 : 1
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
#var float4x4 gl_ModelViewProjectionMatrix : state.matrix.mvp.transpose : c[12], 4 : -1 : 1
#const c[16] = 0 1
PARAM c[17] = { state.matrix.modelview.transpose,
		state.texgen[0].object.s,
		state.texgen[0].object.t,
		state.matrix.modelview.inverse.row[0..2],
		state.light[1].ambient,
		state.light[1].diffuse,
		state.light[1].position,
		state.matrix.mvp.transpose,
		{ 0, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP RC, HC;
BB1:
MUL   R2.xyz, vertex.normal.y, c[7];
MAD   R2.xyz, vertex.normal.x, c[6], R2;
SIN   R0.y, vertex.position.x;
COS   R0.x, vertex.position.x;
MAD   R3.xy, vertex.attrib[1].z, R0, vertex.attrib[1];
MOV   R3.zw, c[16].xyxy;
MUL   R0, R3.y, c[1];
MAD   R0, R3.x, c[0], R0;
ADD   R0, c[3], R0;
ADD   R0, c[16].x, R0;
ADD   R1, c[11], -R0;
DP4   R0.w, R1, R1;
RSQ   R0.w, R0.w;
MAD   R2.xyz, vertex.normal.z, c[8], R2;
DP3   R0.y, R2, -R0;
MUL   R1.xyz, R0.w, R1;
DP3   R0.w, R2, R1;
MOV   R0.x, |R0.w|;
SSG   R0.z, R0.w;
SSG   R0.y, R0;
SEQC  HC.x, R0.z, R0.y;
MOV   R0.x(EQ), c[16];
MUL   R0.xyz, R0.x, c[10];
ADD   R0.xyz, c[9], R0;
MUL   result.color.xyz, vertex.color, R0;
MUL   R0, R3.y, c[13];
MAD   R0, R3.x, c[12], R0;
ADD   R0, c[15], R0;
ADD   result.position, c[16].x, R0;
DP4   result.texcoord[0].x, R3, c[4];
DP4   result.texcoord[0].y, R3, c[5];
MOV   result.color.back, vertex.color;
MOV   result.texcoord[0].zw, c[16].xyxy;
MOV   result.color.w, vertex.color;
END
# 34 instructions, 4 R-regs
