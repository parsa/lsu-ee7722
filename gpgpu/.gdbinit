
# Breakpoints to catch errors and for catching instructions.
#
set breakpoint pending on
b pError_Exit
set breakpoint pending auto

# Suppress gdb messages for each thread start/stop.
#
set print thread-events off

# If using GNU LIBC, have heap routines (malloc,free,...) check for
# common errors such as free something twice.
#
set environment MALLOC_CHECK_ 2

#set environment CUDA_PROFILE 1
set environment CUDA_PROFILE_CONFIG .cuda-profile-config
