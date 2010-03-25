# Location of simulator source code.
#dir ~/src
#dir /fac/drk/localpri/sim/rs_main/src/Processor
#dir ~/pri/sim/rs_bug_463/src/Processor
#dir ~/pri/sim/rs_bug_480/src/Processor
#dir /fac/drk/localpri/sim/rs_bug_383/src/Processor
#dir /fac/drk/localpri/sim/rs_bug_373/src/Processor


# Breakpoints to catch errors and for catching instructions.
b pre_exit
b FatalException
b found_instr
b YS__errmsg

# If using GNU LIBC, have heap routines (malloc,free,...) check for
# common errors such as free something twice.
#
set environment MALLOC_CHECK_ 2

define time
        print YS__Simtime
end

# Show some information about the processor state.
# Not complete and may be out of date.
define state
        call show_regs = 0
        call show_line_info = 0
        call print_proc(0)
end

# Show some information about the processor state, including register values.
# Not complete and may be out of date.
define stater
        call show_regs = 1
        call show_line_info = 1
        call print_proc(0)
end

# Show processor and thread status.
define proc
        call core_print(rproc)
end

# Show the contents of the reorder buffer.
define rob
  if $arg0
        call print_rob(rproc,$arg0)
  else
        call print_al_inst(rproc)
  end
end

# Show logical register status.
define freg
        call regmap_print(rproc,$arg0,false)
end
define reg
        call regmap_print(rproc,$arg0,true)
end

define ri
  print rproc->thread_unit->contexts[$arg0].info_gpr
end

define rmi
  print &rproc->thread_unit->contexts[$arg0].info_gpr.info[$arg1]
end

define frmi
  print &rproc->thread_unit->contexts[$arg0].info_fpr.info[$arg1]
end


# Show the benchmark call stack.  Does not work well yet.
define stackr
        call print_call_stack(rproc)
end

# Convert a tag to a pointer to the corresponding DIn (instance) structure.
define tag_to_din
 call convert_tag_to_inst($arg0,rproc)
end


# Set watchpoints on various DIn (dynamic instruction) members.
# Used in conjunction with the -b rsiml command line switch.
define wi
 up
 call $wi_addr_ready = &addr_ready
 watch * (int*) $wi_addr_ready
 call $wi_state = &istate
 watch * (Inst_State *) $wi_state
 call $wi_memprogress = &memprogress
 watch * (int *) $wi_memprogress
 call $wi_busybits = &busybits
 watch * (unsigned char *) $wi_busybits
 call $wi_specbits = &specbits
 watch * (unsigned char *) $wi_specbits
 call $wi_serrbits = &serrbits
 watch * (unsigned char *) $wi_serrbits
 call $wi_exception_code = &exception_code
 watch * (except*) $wi_exception_code
 call $wi_sp_pre_schedule = &sp_pre_schedule
 watch * (bool*) $wi_sp_pre_schedule
end
 
define wi2
 up
 call $wi_addr_ready = &din->addr_ready
 watch * (int*) $wi_addr_ready
 call $wi_state = &din->istate
 watch * (Insn_State *) $wi_state
 call $wi_memprogress = &din->memprogress
 watch * (int *) $wi_memprogress
 call $wi_busybits = &din->busybits
 watch * (unsigned char *) $wi_busybits
 call $wi_specbits = &din->specbits
 watch * (unsigned char *) $wi_specbits
 call $wi_serrbits = &din->serrbits
 watch * (unsigned char *) $wi_serrbits
 call $wi_exception_code = &din->exception_code
 watch * (except*) $wi_exception_code
end
 
