// -*- c++ -*-

#ifndef SHADER_H
#define SHADER_H

#include <stdio.h>
#include <string>
#include "util.h"

static uint pobject_in_use = 0;

class pShader {
public:
  pShader(const char *path, const char *main_body) {init(path,main_body);}
  pShader()
  {
    validated = true;
    name = strdup("Fixed Functionality.");
    pobject = 0;
  }
  GLint uniform_location(const char *name)
  {
    const GLint rv = glGetUniformLocation(pobject,name);
    if ( rv == -1 ) pError_Msg("Could not get uniform.");
    return rv;
  }
  // Note: Location is "generic attribute index"
  GLint attribute_location(const char *name)
  {return glGetAttribLocation(pobject,name);}
  GLint varying_location(const char *name)
  {return ptr_glGetVaryingLocationNV(pobject, name);}
  uint init(const char *source_path, const char *main_body)
  {
    validated = false;
    name = strdup(main_body);
    const uint sobject =
      ptr_glCreateShader ? ptr_glCreateShader(GL_VERTEX_SHADER) : 0;
    if ( !sobject )
      {
        // Could not create shader, perhaps feature not supported.
        pobject = 0;
        return pobject;
      }
    FILE* const vshader_h = fopen(source_path,"r");
    std::string vshader_text;
    while ( !feof(vshader_h) )
      {
        const int c = getc(vshader_h);
        if ( c == EOF ) break;
        vshader_text += c;
      }
    fclose(vshader_h);
    vshader_text += "void main() {\n";
    vshader_text += main_body;
    vshader_text += "}\n";
    const char *shader_text_lines = vshader_text.c_str();
    glShaderSource(sobject,1,&shader_text_lines,NULL);
    glCompileShader(sobject);
    int rv;
    glGetShaderiv(sobject,GL_COMPILE_STATUS,&rv);
    int info_log_length;
    if ( !rv )
      {
        printf(" Compile status for %s: %d\n",name,rv);
        glGetShaderiv(sobject,GL_INFO_LOG_LENGTH,&info_log_length);
        char* const info_log = (char*) alloca(info_log_length+1);
        glGetShaderInfoLog(sobject,info_log_length+1,NULL,info_log);
        printf(" Info log:\n%s\n",info_log);
      }

    pobject = glCreateProgram();
    glAttachShader(pobject,sobject);
    glLinkProgram(pobject);

    int link_status;
    glGetProgramiv(pobject,GL_LINK_STATUS,&link_status);
    if ( !link_status )
      {
        printf(" Link status for %s: %d\n",name,link_status);
        glGetProgramiv(pobject,GL_INFO_LOG_LENGTH,&info_log_length);
        char* const prog_info_log = (char*) alloca(info_log_length+1);
        glGetProgramInfoLog(pobject,info_log_length+1,NULL,prog_info_log);
        printf(" Program Info log:\n%s\n",prog_info_log);
      }

    return pobject;
  }
  void print_active_attrib()
  {
    if ( !pobject ) return;
    int active_attributes, max_length;
    pError_Check();
    glGetProgramiv(pobject,GL_ACTIVE_ATTRIBUTES,&active_attributes);
    pError_Check();
    glGetProgramiv(pobject,GL_ACTIVE_ATTRIBUTE_MAX_LENGTH,&max_length);
    pError_Check();
    char* const buffer = (char*) alloca(max_length);
    for ( int i=0; i<active_attributes; i++ )
      {
        int size;
        GLenum type;
        glGetActiveAttrib(pobject,i,max_length,NULL,&size,&type,buffer);
        pError_Check();
        const int location = attribute_location(buffer);
        printf("A %2d: SIZE %2d  TYPE %6d  %s\n",location,size,type,buffer);
      }
  }
  void print_active_uniform()
  {
    if ( !pobject ) return;
    int active_attributes, max_length;
    glGetProgramiv(pobject,GL_ACTIVE_UNIFORMS,&active_attributes);
    glGetProgramiv(pobject,GL_ACTIVE_UNIFORM_MAX_LENGTH,&max_length);
    char* const buffer = (char*) alloca(max_length);
    for ( int i=0; i<active_attributes; i++ )
      {
        int size;
        GLenum type;
        glGetActiveUniform(pobject,i,max_length,NULL,&size,&type,buffer);
        printf("U %2d: SIZE %2d  TYPE %6d  %s\n",i,size,type,buffer);
      }
  }
  void print_active_varying()
  {
#ifndef GL_NV_transform_feedback
    return;
#else
    if ( !pobject ) return;
    int active_attributes, max_length;
    glGetProgramiv(pobject,GL_ACTIVE_VARYINGS_NV,&active_attributes);
    glGetProgramiv(pobject,GL_ACTIVE_VARYING_MAX_LENGTH_NV,&max_length);
    char* const buffer = (char*) alloca(max_length);
    for ( int i=0; i<active_attributes; i++ )
      {
        int size;
        GLenum type;
        ptr_glGetActiveVaryingNV(pobject,i,max_length,NULL,&size,&type,buffer);
        printf("V %2d: SIZE %2d  TYPE %6d  %s\n",i,size,type,buffer);
      }
#endif
  }
  void validate_once()
  {
    if ( validated ) return;
    validate();
  }
  void validate()
  {
    validated = true;
    glValidateProgram(pobject);
    int validate_status;
    glGetProgramiv(pobject,GL_VALIDATE_STATUS,&validate_status);
    printf(" Validate status for %s: %d\n",name,validate_status);
    int info_log_length;
    glGetProgramiv(pobject,GL_INFO_LOG_LENGTH,&info_log_length);
    char* const prog_info_log = (char*) alloca(info_log_length+1);
    glGetProgramInfoLog(pobject,info_log_length+1,NULL,prog_info_log);
    printf(" Validation log:\n%s\n",prog_info_log);
  }

  bool use()
  {
    if ( pobject_in_use == pobject ) return false;
    glUseProgram(pobject);
    pError_Check();
    pobject_in_use = pobject;
    return true;
  }

  char* name;
  uint pobject;
  bool validated;
};



#endif
