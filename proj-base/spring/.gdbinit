
# Breakpoints to catch errors and for catching instructions.
#
set breakpoint pending on
b pError_Exit
b exit
set breakpoint pending auto

# Suppress gdb messages for each thread start/stop.
#
set print thread-events off

# If using GNU LIBC, have heap routines (malloc,free,...) check for
# common errors such as free something twice.
#
set environment MALLOC_CHECK_ 3
unset environment MALLOC_CHECK_

#set environment CUDA_PROFILE 1
set environment CUDA_PROFILE_CONFIG .cuda-profile-config

# Control messages about search for separate debug files for libraries, etc.
# If 0, silent;  if 1, complain about missing files; if 2, more kvetching.
#
set build-id-verbose 0
