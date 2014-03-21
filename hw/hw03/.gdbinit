
# Breakpoints to catch errors and for catching instructions.
#
set breakpoint pending on
b pError_Exit
set breakpoint pending auto
b exit

# Suppress gdb messages for each thread start/stop.
#
set print thread-events off

# If using GNU LIBC, have heap routines (malloc,free,...) check for
# common errors such as free something twice.
#
set environment MALLOC_CHECK_ 3
unset environment MALLOC_CHECK_

# Set to either 1 or 0 (or unset) to enable or disable profiling.
#set environment COMPUTE_PROFILE 1

# Set to either 1 (set) or 0 (unset) to enable or disable a comma separated 
# version of the log output. 
#
set environment COMPUTE_PROFILE_CSV 0

# File to write profile data to.
# set environment COMPUTE_PROFILE_LOG 


# Specify a config file for enabling performance counters in the GPU. 
#
set environment COMPUTE_PROFILE_CONFIG .cuda-profile-config
