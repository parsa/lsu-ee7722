;;; Assembler and SPIM Code for use in LSU ECE classes by David Koppelman
;;
;; Includes settings for asm-mode for highlighting MIPS and SPARC
;; assembler code, and for running XSPIM.

;; $Id:$

;; Variables for SPIM

(provide 'asm-class)

(defvar default-spim-options
  "-notrap -delayed_branches -dont_fix -fg black -bg white"
  "Options to pass to spim for normal invocation.")

(defvar spim-program "xspim" "Location of xspim")
;(defvar spim-program "/home/classes/ee4720/com/bin/xspim"
 ; "Location of xspim")


;(setq spim-program "/fac/drk/pub/sim/spim-6.3/xspim")

(defvar spim-menu (make-sparse-keymap "SPIM") "Menu for SPIM")

(define-key spim-menu [rspim]
  '(menu-item "Run XSPIM on current buffer."
              start-spim
              :help "What are you waiting for?"))

(define-key spim-menu [mipstov]
  '(menu-item "Assemble buffer into Verilog."
              mips-to-verilog
              :help "Go ahead, don't be shy!"))

;; Font Lock Settings for asm-mode

(defface asm-comment-heading-face
  '((t (:family "helv" :weight bold :height 1.5)))
  "Assembler comment heading face.")
(defface asm-comment-sub-heading-face
  '((t (:family "helv" :weight bold :inherit 'font-lock-comment-face)))
  "Assembler comment sub-heading face.")
(defface asm-directive-face
  '((t (:foreground "navy" :slant italic)))
  "Assembler directive face.")
(defface asm-constant-radix-face
  '((t (:foreground "gray60")))
  "Assembler radix indicator face.")
(defface asm-heading-sample-face
  '((t (:foreground "ForestGreen" )))
  "Face for sample heading in assembler lecture code.")
(defface asm-heading-def-face
  '((t (:foreground "magenta" :weight bold )))
  "Face for definition marker in assembler lecture code.")
(defface number-highlight-face
    '((t (:foreground "magenta4")))
    "Face for highlighting digit groups in numbers.")
(defface asm-pseudo-instruction-face
  '((t (:inherit 'font-lock-keyword-face :slant italic)))
  "Face for highlighting assembler pseudo instructions.")
(defface asm-heading-example-face
  '((t (:foreground "ForestGreen" :weight bold)))
  "Face for example heading in assembler lecture code.")
(defface asm-defined-term-face
  '((t (:foreground "Black" :family "helv" :weight bold :slant italic)))
  "Face for defined terms in assembler lecture code.")
(defface asm-heading-syntax-face
  '((t (:foreground "magenta" :slant italic )))
  "Face for syntax heading in assembler lecture code.")

(when nil
  (regexp-opt 
   (list
    "movl" "pushl" "call" "jmp"
)))

(defvar ia32-all-instr-regexp
  "\\<\\(movl\\|pushl\\|call\\|jmp\\)\\>"
  "IA-32 Instruction Regexps")

(when nil
  (regexp-opt 
   (list
    "add" "addc" "addcc" "addccc" "addx" "addxcc" "alignaddr" "alignaddrl"
    "and" "andcc" "andn" "andncc" "array16" "array32" "array8" "b" "ba"
    "bcc" "bclr" "bcs" "be" "beq" "bg" "bge" "bgeu" "bgt" "bgu" "bl" "ble"
    "bleu" "blt" "blu" "bn" "bne" "bneg" "bnz" "bpos" "brgez" "brgz"
    "brlez" "brlz" "brnz" "brz" "bset" "btog" "btst" "bvc" "bvs" "bz"
    "call" "cas" "casa" "casl" "casx" "casxa" "casxl" "cb" "cb0" "cb01"
    "cb012" "cb013" "cb02" "cb023" "cb03" "cb1" "cb12" "cb123" "cb13"
    "cb2" "cb23" "cb3" "cba" "cbe" "cbef" "cbefr" "cber" "cbf" "cbfr"
    "cbn" "cbne" "cbnef" "cbnefr" "cbner" "cbnf" "cbnfr" "cbnr" "cbr"
    "clr" "clrb" "clrh" "clruw" "clrx" "cmp" "cpop1" "cpop2" "cpull"
    "cpush" "cpusha" "crdcxt" "cwrcxt" "dec" "deccc" "divscc" "done"
    "edge16" "edge16l" "edge32" "edge32l" "edge8" "edge8l" "efabss"
    "efaddd" "efadds" "efcmpd" "efcmped" "efcmpes" "efcmps" "efdivd"
    "efdivs" "efdtoi" "efdtos" "efitod" "efitos" "efmovs" "efmuld"
    "efmuls" "efnegs" "efsmuld" "efsqrtd" "efsqrts" "efstod" "efstoi"
    "efsubd" "efsubs" "fabsd" "fabsq" "fabss" "fabsx" "faddd" "faddq"
    "fadds" "faddx" "faligndata" "fand" "fandnot1" "fandnot1s" "fandnot2"
    "fandnot2s" "fands" "fb" "fba" "fbe" "fbg" "fbge" "fbl" "fble" "fblg"
    "fbn" "fbne" "fbnz" "fbo" "fbu" "fbue" "fbug" "fbuge" "fbul" "fbule"
    "fbz" "fcmpd" "fcmped" "fcmpeq" "fcmpeq16" "fcmpeq32" "fcmpes"
    "fcmpex" "fcmpgt16" "fcmpgt32" "fcmple16" "fcmple32" "fcmpne16"
    "fcmpne32" "fcmpq" "fcmps" "fcmpx" "fdivd" "fdivq" "fdivs" "fdivx"
    "fdmulq" "fdmulx" "fdtoi" "fdtoq" "fdtos" "fdtox" "fexpand" "fitod"
    "fitoq" "fitos" "flush" "flushw" "fmovd" "fmovda" "fmovdcc" "fmovdcs"
    "fmovde" "fmovdg" "fmovdge" "fmovdgeu" "fmovdgu" "fmovdl" "fmovdle"
    "fmovdleu" "fmovdlg" "fmovdlu" "fmovdn" "fmovdne" "fmovdneg" "fmovdnz"
    "fmovdo" "fmovdpos" "fmovdu" "fmovdue" "fmovdug" "fmovduge" "fmovdul"
    "fmovdule" "fmovdvc" "fmovdvs" "fmovdz" "fmovq" "fmovqa" "fmovqcc"
    "fmovqcs" "fmovqe" "fmovqg" "fmovqge" "fmovqgeu" "fmovqgu" "fmovql"
    "fmovqle" "fmovqleu" "fmovqlg" "fmovqlu" "fmovqn" "fmovqne" "fmovqneg"
    "fmovqnz" "fmovqo" "fmovqpos" "fmovqu" "fmovque" "fmovqug" "fmovquge"
    "fmovqul" "fmovqule" "fmovqvc" "fmovqvs" "fmovqz" "fmovrde"
    "fmovrdgez" "fmovrdgz" "fmovrdlez" "fmovrdlz" "fmovrdne" "fmovrdnz"
    "fmovrdz" "fmovrqe" "fmovrqgez" "fmovrqgz" "fmovrqlez" "fmovrqlz"
    "fmovrqne" "fmovrqnz" "fmovrqz" "fmovrse" "fmovrsgez" "fmovrsgz"
    "fmovrslez" "fmovrslz" "fmovrsne" "fmovrsnz" "fmovrsz" "fmovs"
    "fmovsa" "fmovscc" "fmovscs" "fmovse" "fmovsg" "fmovsge" "fmovsgeu"
    "fmovsgu" "fmovsl" "fmovsle" "fmovsleu" "fmovslg" "fmovslu" "fmovsn"
    "fmovsne" "fmovsneg" "fmovsnz" "fmovso" "fmovspos" "fmovsu" "fmovsue"
    "fmovsug" "fmovsuge" "fmovsul" "fmovsule" "fmovsvc" "fmovsvs" "fmovsz"
    "fmovx" "fmul8sux16" "fmul8ulx16" "fmul8x16" "fmul8x16al" "fmul8x16au"
    "fmuld" "fmuld8sux16" "fmuld8ulx16" "fmulq" "fmuls" "fmulx" "fnand"
    "fnands" "fnegd" "fnegq" "fnegs" "fnegx" "fnor" "fnors" "fnot1"
    "fnot1s" "fnot2" "fnot2s" "fone" "fones" "for" "fornot1" "fornot1s"
    "fornot2" "fornot2s" "fors" "fpack16" "fpack32" "fpackfix" "fpadd16"
    "fpadd16s" "fpadd32" "fpadd32s" "fpmerge" "fpsub16" "fpsub16s"
    "fpsub32" "fpsub32s" "fqtod" "fqtoi" "fqtos" "fqtox" "fsmuld" "fsqrtd"
    "fsqrtq" "fsqrts" "fsqrtx" "fsrc1" "fsrc1s" "fsrc2" "fsrc2s" "fstod"
    "fstoi" "fstoq" "fstox" "fsubd" "fsubq" "fsubs" "fsubx" "fxnor"
    "fxnors" "fxor" "fxors" "fxtod" "fxtoq" "fxtos" "fzero" "fzeros"
    "iflush" "illtrap" "impdep1" "impdep2" "inc" "inccc" "iprefetch" "jmp"
    "jmpl" "ld" "lda" "ldd" "ldda" "ldq" "ldqa" "ldsb" "ldsba" "ldsh"
    "ldsha" "ldstub" "ldstuba" "ldsw" "ldswa" "ldub" "lduba" "lduh"
    "lduha" "lduw" "lduwa" "ldx" "ldxa" "membar" "mov" "mova" "movcc"
    "movcs" "move" "movg" "movge" "movgeu" "movgu" "movl" "movle" "movleu"
    "movlg" "movlu" "movn" "movne" "movneg" "movnz" "movo" "movpos"
    "movre" "movrgez" "movrgz" "movrlez" "movrlz" "movrne" "movrnz"
    "movrz" "movu" "movue" "movug" "movuge" "movul" "movule" "movvc"
    "movvs" "movz" "mulscc" "mulx" "neg" "nop" "not" "or" "orcc" "orn"
    "orncc" "pdist" "popc" "prefetch" "prefetcha" "rd" "rdpr" "restore"
    "restored" "ret" "retl" "retry" "rett" "return" "save" "saved" "scan"
    "sdiv" "sdivcc" "sdivx" "set" "sethi" "setsw" "setuw" "setx" "shuffle"
    "shutdown" "signx" "sir" "sll" "sllx" "smac" "smacd" "smul" "smulcc"
    "smuld" "spill" "spilld" "sra" "srax" "srl" "srlx" "st" "sta" "stb"
    "stba" "stbar" "std" "stda" "sth" "stha" "stq" "stqa" "stsb" "stsba"
    "stsh" "stsha" "stsw" "stswa" "stub" "stuba" "stuh" "stuha" "stuw"
    "stuwa" "stw" "stwa" "stx" "stxa" "sub" "subc" "subcc" "subccc" "subx"
    "subxcc" "swap" "swapa" "t" "ta" "taddcc" "taddcctv" "tcc" "tcs" "te"
    "teq" "tg" "tge" "tgeu" "tgt" "tgu" "tl" "tle" "tleu" "tlt" "tlu" "tn"
    "tne" "tneg" "tnz" "tpos" "tst" "tsubcc" "tsubcctv" "tvc" "tvs" "tz"
    "udiv" "udivcc" "udivx" "umac" "umacd" "umul" "umulcc" "umuld" "unimp"
    "wr" "wrpr" "xnor" "xnorcc" "xor" "xorcc")))

(defvar sparc-all-instr-regexp
  "\\<\\(a\\(?:dd\\(?:[cx]?cc\\|[cx]\\)?\\|lignaddrl?\\|nd\\(?:cc\\|n\\(?:cc\\)?\\)?\\|rray\\(?:16\\|32\\|8\\)\\)\\|b\\(?:c\\(?:lr\\|[cs]\\)\\|eq\\|g\\(?:eu\\|[etu]\\)\\|l\\(?:eu\\|[etu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|r\\(?:\\(?:[gl]e\\|[gln]\\)?z\\)\\|set\\|t\\(?:og\\|st\\)\\|v[cs]\\|[aeglnz]\\)\\|c\\(?:a\\(?:ll\\|s\\(?:x[al]\\|[alx]\\)?\\)\\|b\\(?:0\\(?:1[23]\\|23\\|[123]\\)\\|1\\(?:23\\|[23]\\)\\|23\\|e\\(?:fr\\|[fr]\\)\\|fr\\|n\\(?:e\\(?:fr\\|[fr]\\)\\|fr\\|[efr]\\)\\|[0-3aefnr]\\)?\\|lr\\(?:uw\\|[bhx]\\)?\\|mp\\|p\\(?:op[12]\\|u\\(?:ll\\|sha?\\)\\)\\|\\(?:rd\\|wr\\)cxt\\)\\|d\\(?:ec\\(?:cc\\)?\\|ivscc\\|one\\)\\|e\\(?:dge\\(?:16l?\\|32l?\\|8l?\\)\\|f\\(?:a\\(?:bss\\|dd[ds]\\)\\|cmp\\(?:e[ds]\\|[ds]\\)\\|d\\(?:iv[ds]\\|to[is]\\)\\|ito[ds]\\|m\\(?:ovs\\|ul[ds]\\)\\|negs\\|s\\(?:muld\\|qrt[ds]\\|to[di]\\|ub[ds]\\)\\)\\)\\|f\\(?:a\\(?:bs[dqsx]\\|dd[dqsx]\\|ligndata\\|nd\\(?:not\\(?:[12]s\\|[12]\\)\\|s\\)?\\)\\|b\\(?:ge\\|l[eg]\\|n[ez]\\|u\\(?:[gl]e\\|[egl]\\)\\|[aeglnouz]\\)?\\|cmp\\(?:e\\(?:q\\(?:16\\|32\\)\\|[dqsx]\\)\\|gt\\(?:16\\|32\\)\\|le\\(?:16\\|32\\)\\|ne\\(?:16\\|32\\)\\|[dqsx]\\)\\|d\\(?:iv[dqsx]\\|mul[qx]\\|to[iqsx]\\)\\|expand\\|ito[dqs]\\|lushw?\\|m\\(?:ov\\(?:d\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|q\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|r\\(?:d\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|q\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|s\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\)\\|s\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|[dqsx]\\)\\|ul\\(?:8\\(?:sux16\\|ulx16\\|x16\\(?:a[lu]\\)?\\)\\|d8\\(?:\\(?:su\\|ul\\)x16\\)\\|[dqsx]\\)\\)\\|n\\(?:ands?\\|eg[dqsx]\\|o\\(?:rs?\\|t\\(?:[12]s\\|[12]\\)\\)\\)\\|o\\(?:nes?\\|r\\(?:not\\(?:[12]s\\|[12]\\)\\|s\\)?\\)\\|p\\(?:a\\(?:ck\\(?:16\\|32\\|fix\\)\\|dd\\(?:16s?\\|32s?\\)\\)\\|merge\\|sub\\(?:16s?\\|32s?\\)\\)\\|qto[disx]\\|s\\(?:muld\\|qrt[dqsx]\\|rc\\(?:[12]s\\|[12]\\)\\|to[diqx]\\|ub[dqsx]\\)\\|x\\(?:nors?\\|ors?\\|to[dqs]\\)\\|zeros?\\)\\|i\\(?:flush\\|lltrap\\|mpdep[12]\\|nc\\(?:cc\\)?\\|prefetch\\)\\|jmpl?\\|ld\\(?:da\\|qa\\|s\\(?:ba\\|ha\\|tuba?\\|wa\\|[bhw]\\)\\|u\\(?:[bhw]a\\|[bhw]\\)\\|xa\\|[adqx]\\)?\\|m\\(?:embar\\|ov\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|r\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)?\\|ul\\(?:scc\\|x\\)\\)\\|n\\(?:eg\\|o[pt]\\)\\|or\\(?:cc\\|n\\(?:cc\\)?\\)?\\|p\\(?:dist\\|opc\\|refetcha?\\)\\|r\\(?:d\\(?:pr\\)?\\|e\\(?:stored?\\|t\\(?:ry\\|urn\\|[lt]\\)?\\)\\)\\|s\\(?:aved?\\|can\\|div\\(?:cc\\|x\\)?\\|et\\(?:hi\\|sw\\|uw\\|x\\)?\\|hu\\(?:ffle\\|tdown\\)\\|i\\(?:gnx\\|r\\)\\|llx?\\|m\\(?:acd?\\|ul\\(?:cc\\|d\\)?\\)\\|pilld?\\|r\\(?:[al]x\\|[al]\\)\\|t\\(?:bar?\\|da\\|ha\\|qa\\|s\\(?:[bhw]a\\|[bhw]\\)\\|u\\(?:[bhw]a\\|[bhw]\\)\\|[wx]a\\|[abdhqwx]\\)?\\|ub\\(?:[cx]?cc\\|[cx]\\)?\\|wapa?\\)\\|t\\(?:addcc\\(?:tv\\)?\\|c[cs]\\|eq\\|g\\(?:eu\\|[etu]\\)\\|l\\(?:eu\\|[etu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|s\\(?:t\\|ubcc\\(?:tv\\)?\\)\\|v[cs]\\|[aeglnz]\\)\\|u\\(?:div\\(?:cc\\|x\\)?\\|m\\(?:acd?\\|ul\\(?:cc\\|d\\)?\\)\\|nimp\\)\\|wr\\(?:pr\\)?\\|x\\(?:nor\\(?:cc\\)?\\|or\\(?:cc\\)?\\)\\|[bt]\\)\\>"
  "Regexp matching all SPARC instructions")




(when nil
  (regexp-opt (list "abs.d" "abs.s" "add" "add.d" "add.s" "addi" "addiu"
                    "addu" "and" "andi" "bc0f" "bc0t" "bc1f" "bc1t"
                    "bc2f" "bc2t" "bc3f" "bc3t" "beq" "bgez" "bgezal"
                    "bgtz" "blez" "bltz" "bltzal" "bne" "break" "c.eq.d"
                    "c.eq.s" "c.f.d" "c.f.s" "c.le.d" "c.le.s" "c.lt.d"
                    "c.lt.s" "c.nge.d" "c.nge.s" "c.ngl.d" "c.ngl.s"
                    "c.ngle.d" "c.ngle.s" "c.ngt.d" "c.ngt.s" "c.ole.d"
                    "c.ole.s" "c.olt.d" "c.olt.s" "c.seq.d" "c.seq.s"
                    "c.sf.d" "c.sf.s" "c.ueq.d" "c.ueq.s" "c.ule.d"
                    "c.ule.s" "c.ult.d" "c.ult.s" "c.un.d" "c.un.s"
                    "cfc0" "cfc1" "cfc2" "cfc3" "cop0" "cop1" "cop2"
                    "cop3" "ctc0" "ctc1" "ctc2" "ctc3" "cvt.d.s"
                    "cvt.d.w" "cvt.s.d" "cvt.s.w" "cvt.w.d" "cvt.w.s"
                    "div" "div.d" "div.s" "divu" "j" "jal" "jalr" "jr"
                    "lb" "lbu" "lh" "lhu" "lui" "lw" "lwc0" "lwc1"
                    "lwc2" "lwc3" "lwl" "lwr" "mfc0" "mfc1" "mfc1.s"
                    "mfc2" "mfc3" "mfhi" "mflo" "mov.d" "mov.s" "mtc0"
                    "mtc1" "mtc2" "mtc3" "mthi" "mtlo" "mul.d" "mul.s"
                    "mult" "multu" "neg.d" "neg.s" "nor" "or" "ori"
                    "rfe" "sb" "sh" "sll" "sllv" "slt" "slti" "sltiu"
                    "sltu" "sra" "srav" "srl" "srlv" "sub" "sub.d"
                    "sub.s" "subu" "sw" "swc0" "swc1" "swc2" "swc3"
                    "swl" "swr" "syscall" "tlbp" "tlbr" "tlbwi" "tlbwr"
                    "xor" "xori"
                    ;; MIPS32
                    "clz" "ldc1" "sdc1"
                    ) 'words))

(defvar mips-instr-regexp
"\\<\\(a\\(?:bs\\.[ds]\\|dd\\(?:\\.[ds]\\|iu\\|[iu]\\)?\\|ndi?\\)\\|b\\(?:c\\(?:0[ft]\\|1[ft]\\|2[ft]\\|3[ft]\\)\\|eq\\|g\\(?:ez\\(?:al\\)?\\|tz\\)\\|l\\(?:ez\\|tz\\(?:al\\)?\\)\\|ne\\|reak\\)\\|c\\(?:\\.\\(?:eq\\.[ds]\\|f\\.[ds]\\|l\\(?:e\\.[ds]\\|t\\.[ds]\\)\\|ng\\(?:e\\.[ds]\\|l\\(?:\\.[ds]\\|e\\.[ds]\\)\\|t\\.[ds]\\)\\|ol\\(?:e\\.[ds]\\|t\\.[ds]\\)\\|s\\(?:eq\\.[ds]\\|f\\.[ds]\\)\\|u\\(?:eq\\.[ds]\\|l\\(?:e\\.[ds]\\|t\\.[ds]\\)\\|n\\.[ds]\\)\\)\\|fc[0-3]\\|lz\\|op[0-3]\\|tc[0-3]\\|vt\\.\\(?:d\\.[sw]\\|s\\.[dw]\\|w\\.[ds]\\)\\)\\|div\\(?:\\.[ds]\\|u\\)?\\|j\\(?:alr?\\|r\\)?\\|l\\(?:bu\\|dc1\\|hu\\|ui\\|w\\(?:c[0-3]\\|[lr]\\)\\|[bhw]\\)\\|m\\(?:f\\(?:c\\(?:1\\.s\\|[0-3]\\)\\|hi\\|lo\\)\\|ov\\.[ds]\\|t\\(?:c[0-3]\\|hi\\|lo\\)\\|ul\\(?:\\.[ds]\\|tu?\\)\\)\\|n\\(?:eg\\.[ds]\\|or\\)\\|ori?\\|rfe\\|s\\(?:dc1\\|l\\(?:lv\\|t\\(?:iu\\|[iu]\\)\\|[lt]\\)\\|r\\(?:[al]v\\|[al]\\)\\|ub\\(?:\\.[ds]\\|u\\)?\\|w\\(?:c[0-3]\\|[lr]\\)\\|yscall\\|[bhw]\\)\\|tlb\\(?:w[ir]\\|[pr]\\)\\|xori?\\)\\>"
  "Regexp matching MIPS instructions as defined, mostly, by SPIM")

(when nil
    (regexp-opt (list "abs" "b" "bal" "beqz" "bge" "bgeu"
                      "bgt" "bgtu" "ble" "bleu" "blt"
                      "bltu" "bnez" "l.d" "l.s" "la" "ld" "li" "li.d"
                      "li.s" "mfc1.d" "move" "mtc1.d" "mul" "mulo" "mulou"
                      "neg" "negu" "nop" "not" "rem" "remu" "rol" "ror"
                      "s.d" "s.s" "sd" "seq" "sge" "sgeu" "sgt" "sgtu"
                      "sle" "sleu" "sne" "ulh" "ulhu" "ulw" "ush" "usw")
                'words))

(defvar mips-pinstr-regexp
  "\\<\\(abs\\|b\\(?:al\\|eqz\\|g\\(?:[et]u\\|[et]\\)\\|l\\(?:[et]u\\|[et]\\)\\|nez\\)?\\|l\\(?:\\.[ds]\\|i\\.[ds]\\|[adi]\\)\\|m\\(?:fc1\\.d\\|ove\\|tc1\\.d\\|ul\\(?:ou?\\)?\\)\\|n\\(?:egu?\\|o[pt]\\)\\|r\\(?:emu?\\|o[lr]\\)\\|s\\(?:\\.[ds]\\|d\\|eq\\|g\\(?:[et]u\\|[et]\\)\\|leu?\\|ne\\)\\|u\\(?:l\\(?:hu\\|[hw]\\)\\|s[hw]\\)\\)\\>"
  "Regexp matching MIPS pseudoinstructions as defined by SPIM.")



(setq asm-markup-extra-font-lock-keywords
      '(
        ("\\(0x\\)[0-9a-fA-F]\\{1,4\\}\\>"
         (1 (quote asm-constant-radix-face) t))

        ("\\(0x\\)\\([0-9a-fA-F]\\{1,4\\}\\)[0-9a-fA-F]\\{4\\}\\>"
         (1 (quote asm-constant-radix-face) t)
         (2 (quote number-highlight-face) t))

        ("\\(0x\\)[0-9a-fA-F]\\{1,4\\}\\([0-9a-fA-F]\\{4\\}\\)[0-9a-fA-F]\\{4\\}\\>"
         (1 (quote asm-constant-radix-face) t)
         (2 (quote number-highlight-face) t))

        ("\\(0x\\)\\([0-9a-fA-F]\\{1,4\\}\\)[0-9a-fA-F]\\{4\\}\\([0-9a-fA-F]\\{4\\}\\)[0-9a-fA-F]\\{4\\}\\>"
         (1 (quote asm-constant-radix-face) t)
         (2 (quote number-highlight-face) t)
         (3 (quote number-highlight-face) t))

        ("\\(:\\)\\(Keywords?\\)\\(:\\)"
         (1 'asm-constant-radix-face t t)
         (2 (list 'font-lock-keyword-face 'italic) t t)
         (3 'asm-constant-radix-face t t))
        ("\\(:\\)\\(Example\\)\\(:\\)"
         (1 'asm-constant-radix-face t t)
         (2 'asm-heading-example-face t t)
         (3 'asm-constant-radix-face t t))
        ("\\(:\\)\\(Def\\)\\(:\\)\\(.*\\)"
         (1 'asm-constant-radix-face t t)
         (2 'asm-heading-def-face t t)
         (3 'asm-constant-radix-face t t)
         (4 'asm-defined-term-face t t))
        ("\\(:\\)\\(Syntax\\)\\(:\\)"
         (1 'asm-constant-radix-face t t)
         (2 'asm-heading-syntax-face t t)
         (3 'asm-constant-radix-face t t))
        ("\\(:\\)\\(Sample\\)\\(:\\)"
         (1 'asm-constant-radix-face t t)
         (2 'asm-heading-sample-face t t)
         (3 'asm-constant-radix-face t t))))

;; Hook functions for asm-mode.
;;
;;

(defun asm-mode-prefs ()
  "Assembler mode settings for SPARC or MIPS.
Called before asm-mode initializes."
  (if (save-excursion
        (goto-char (point-min))
        (not (or
         (looking-at "#")
         (re-search-forward "\\<addi\\>" 20000 t))))
      ;; SPARC
      (setq asm-comment-char ?!
            asm-font-lock-keywords
            (append
             asm-markup-extra-font-lock-keywords
             (list
              (cons sparc-all-instr-regexp font-lock-keyword-face))
              '(
                ("^[ \t]*\\.section.*" . font-lock-heading-face)
                ("^\\(\\(\\sw\\|\\s_\\)+\\)\\>:?[\t]*\\(\\sw+\\)?"
                 (1 font-lock-function-name-face)
                 (3 font-lock-keyword-face nil t))
                ("^\\s *\.L[A-Z0-9a-z]*:" . font-lock-function-name-face)
                ("^\\.stabn 68,[^,]*,\\([^,]+\\),"
                 (0 font-lock-string-face) (1 font-lock-heading-face t))
                ; ("^\\s +\\(\\(\\sw\\|\\s_\\)+\\)" 1 font-lock-keyword-face)

                ;; Comment used as a heading.
                ("^!! \\(.*\\)"
                 (1 'asm-comment-heading-face t t))

                ;; Comment used as a sub heading.
                ("^\\s-+!! \\(.*\\)"
                 (1 'asm-comment-sub-heading-face t t))

                ;; Literal Directives
                ("\\.\\(asci?iz?\\|byte\\|double\\|float\\||half\\|word\\)\\>"
                (1 (list font-lock-type-face 'italic)))

                ;; SPIM Assembler Directives
                ("\\.\\(align\\|file\\)\\>"
                 (1 'asm-directive-face))

                ;; SPIM Assembler Directives
                ("\\.\\(extern\\|global\\)\\>\\s +\\(\\(\\sw\\|\\s_\\)+\\)"
                 (1 'asm-directive-face)
                 (2 font-lock-function-name-face)
                 )

                ;; Segment Directives
                ("\\.\\([rk]?o?data\\|[rk]?text\\)\\>"
                 (1 (list 'asm-directive-face 'bold)))

                ("\\(\\%\\)\\([ioglf][12]?[0-9]\\|[ioglf]3[01]\\|[sf]p\\|[fi]cc\\)\\>"
                 (1 font-lock-string-face)
                 (2 font-lock-variable-name-face) )

                )))
    ;; SPIM (for MIPS)
    (setq asm-comment-char ?#
          asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords ;; Matches stuff in comments
           (list
            ;; Instructions and pseudo instructions.
            (cons mips-instr-regexp font-lock-keyword-face)
            (cons mips-pinstr-regexp '(quote asm-pseudo-instruction-face)))
           '(
             ;; Comment used as a heading.
             ("^## \\(.*\\)"
              (1 'asm-comment-heading-face t t))

             ;; Comment used as a sub heading.
             ("^\\s-+## \\(.*\\)"
              (1 'asm-comment-sub-heading-face t t))

             ;; Literal Directives
             ("\\.\\(asciiz?\\|byte\\|double\\|float\\||half\\|word\\)\\>"
              (1 (list font-lock-type-face 'italic)))

             ;; SPIM Assembler Directives
             ("\\.\\(stab[sn]\\|align\\|set\\|space\\|frame\\|f?mask\\|end\\|file\\)\\>"
              (1 'asm-directive-face))

             ;; SPIM Assembler Directives
             ("\\.\\(extern\\|globl\\|ent\\)\\>\\s +\\(\\(\\sw\\|\\s_\\)+\\)"
              (1 'asm-directive-face)
              (2 font-lock-function-name-face)
              )

             ;; Segment Directives
             ("\\.\\([rk]?data\\|[rk]?text\\)\\>"
              (1 (list 'asm-directive-face 'bold)))

             ;; Line Numbers
             ("^\\(\\(\\sw\\|[_.]\\)+\\):" (1 font-lock-constant-face) )
             ("^\.L[A-Z0-9a-z]*:" . font-lock-constant-face)

             ;; Registers
             ("\\(\\$\\)\\([0-9]\\|[12][0-9]\\|3[01]\\|zero\\|at\\|v[01]\\|a[0-4]\\|t[0-9]\\|s[0-7]\\|k[01]\\|[gsf]p\\|ra\\|f[012]?[0-9]\\|f3[01]\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-variable-name-face) )

             ;; Line number stab info.
             ("^\\.stabn 68,[^,]*,\\([^,]+\\),"
              (0 font-lock-string-face) (1 font-lock-heading-face t)))))))

(defun asm-mode-prefs-2 ()
  "Preferences for assembler mode.
Called after asm-mode initializes (as most hooks are)."
  (setq fill-prefix nil)  ;; Already overwritten by asm-mode.
  (make-local-variable 'adaptive-fill-regexp)
  (make-local-variable 'adaptive-fill-first-line-regexp)
  (setq adaptive-fill-regexp (concat "[ \t]*" (list asm-comment-char) "+[ \t]*"))
  (setq adaptive-fill-first-line-regexp adaptive-fill-regexp)
  (turn-on-flyspell-prog-mode)
  (when flyspell-mode
    (make-local-variable 'flyspell-prog-text-faces)
    (add-to-list 'flyspell-prog-text-faces 'asm-comment-heading-face)
    (add-to-list 'flyspell-prog-text-faces 'asm-comment-sub-heading-face))
  (local-set-key (vector asm-comment-char) 'self-insert-command)
  (local-set-key ":" 'self-insert-command)
  (local-set-key [menu-bar spim] (cons "SPIM" spim-menu))
  (when (eq asm-comment-char ?#)
    (local-set-key [S-f9] 'mips-to-verilog)
    (local-set-key [f9] 'start-spim))
  (local-unset-key "\C-m"))


(defvar spim-options-history nil)

(defun start-spim (no-args)
  "Start spim on file in buffer.
With a prefix argument prompt for options."
  (interactive "P")
  (unless (eq window-system 'x) (error "Only runs under X-Windows"))
  (save-some-buffers)
  (let ((spim-options
         (if no-args
             (read-from-minibuffer "SPIM Options: "
                                   (cons (or (car spim-options-history) "") 1 )
                                   nil nil 'spim-options-history)
           default-spim-options)))
    (call-process shell-file-name nil 0 nil "-c"
                  (concat spim-program " " spim-options " -file "
                          (file-name-nondirectory (buffer-file-name)) " &"))))

(defun mips-to-verilog ()
  "Assemble MIPS file into Verilog."
  (interactive)
  (save-some-buffers)
  (compile (concat "asv " (file-name-nondirectory (buffer-file-name)))))


(add-hook 'asm-mode-set-comment-hook 'asm-mode-prefs)
(add-hook 'asm-mode-hook 'asm-mode-prefs-2)

