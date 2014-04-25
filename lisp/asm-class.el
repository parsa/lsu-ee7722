;;; Assembler and SPIM Code for use in LSU ECE classes by David Koppelman
;;
;; Includes settings for asm-mode for highlighting assembly code and
;; for running XSPIM. The following instruction sets are supported:
;; MIPS, SPARC, IA-32, OpenGL Vertex Program 1, NVIDIA PTX, NVIDIA
;; SASS (Tesla, Fermi, Kepler).

;; Variables for SPIM

(require 'p-util)

(defvar default-spim-options
  "-notrap -delayed_branches -dont_fix -fg black -bg white"
  "Options to pass to spim for normal invocation.")

(defvar spim-program "/home/faculty/koppel/pub/ee4720/bin/xspim"
  "Location of xspim")
(defvar asv-program "/home/faculty/koppel/pub/ee4720/bin/asv"
  "Location of script to convert assembler into Verilog for MIPS input.")

(defvar spim-menu (make-sparse-keymap "SPIM") "Menu for SPIM")

(define-key spim-menu [rspim]
  '(menu-item "Run XSPIM on current buffer."
              start-spim
              :help "Start XSPIM simulator."))

(define-key spim-menu [mipstov]
  '(menu-item "Assemble buffer into Verilog."
              mips-to-verilog
              :help "Convert MIPS assembler code into a form that can be read by our MIPS Verilog models."))

;; Font Lock Settings for asm-mode

(defvar asm-ss-family-name
  (if (>= emacs-major-version 23)
      (p-first-member
       (list "DejaVu LGC Sans" "DejaVu Sans" "FreeSans") (p-font-family-list))
      "Helv"))

(defface asm-comment-heading-face
  '((t (:family "DejaVu Sans" :weight bold :height 1.5)))
  "Assembler comment heading face.")

(defface asm-comment-sub-heading-face
  '((t (:family "DejaVu Sans" :weight bold :inherit font-lock-comment-face)))
  "Assembler comment sub-heading face.")
(defface asm-directive-face
  '((t (:foreground "navy" :slant italic)))
  "Assembler directive face.")
(defface asm-memory-space-face
  '((t (:foreground "dark magenta" :slant italic)))
  "Assembler memory space face. (For CUDA memory/register categories.")


(defface asm-vector-register-face
  '((t (:foreground "dark magenta" :slant normal)))
  "Assembler vector register space face.")

(defface asm-insn-special-face
  '((t (:inherit font-lock-keyword-face :weight bold)))
  "Face for instructions of special interest.")

(defface asm-insn-modifier-face
  '((t (:foreground "medium blue" :slant normal)))
  "Assembler face for instruction modifiers (other than size).")
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
  '((t (:inherit font-lock-keyword-face :slant italic)))
  "Face for highlighting assembler pseudo instructions.")
(defface asm-heading-example-face
  '((t (:foreground "ForestGreen" :weight bold)))
  "Face for example heading in assembler lecture code.")
(defface asm-defined-term-face
  '((t (:foreground "Black" :family "DejaVu Sans" :weight bold :slant italic)))
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
  "\\<\\(k\\(and[nr]\\|concat[hl]\\|extract\\|merge2l1[hl]\\|not\\|or\\|xn?or\\|ortest\\)\\|vcvt[dfpu][a-z2]+\\|jkn?zd\\|v?p?\\(nop\\|inc\\|sh[rl]\\|sar\\|neg\\|lea\\|test\\|v?sub[sp]?\\|v?add[sp]?\\|[vi]?div[sp]\\|[iv]?mul[sp]?\\|not\\|and\\|xor\\|or\\|cmpu?\\|pop\\|sal\\|clt\\|push\\)[blsdq]?\\|call\\|\\(j\\|set\\)\\([bngla]?e?\\)\\|re[pt]\\|jmp\\|[vk]?mov\\(zw\\|dq\\)?[ah]?p?[bsldq]*\\(32\\|64\\)?\\|v\\(broadcast\\|packstore[hl]\\)[sp][blsdq]\\|vprefetche?[012n]\\(ta\\)?\\|vp?broadcast[dfi]\\(32\\|64\\)\\|v[ps]?\\(gather\\|scatter\\)dp?[sdq]\\|vfm\\(add\\|sub\\)[123]+[ps][sd]\\|vloadunpack[lh]p?[sdq]\\)\\>"
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
    "fmadds" "fmaddd" "fmsubs" "fmsubd"
    "fnmadds" "fnmaddd" "fnmsubs" "fnmsubd"
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
  "\\<\\(?:a\\(?:dd\\(?:[cx]?cc\\|[cx]\\)?\\|lignaddrl?\\|nd\\(?:cc\\|n\\(?:cc\\)?\\)?\\|rray\\(?:16\\|32\\|8\\)\\)\\|b\\(?:c\\(?:lr\\|[cs]\\)\\|eq\\|g\\(?:eu\\|[etu]\\)\\|l\\(?:eu\\|[etu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|r\\(?:\\(?:[gl]e\\|[gln]\\)?z\\)\\|set\\|t\\(?:og\\|st\\)\\|v[cs]\\|[aeglnz]\\)\\|c\\(?:a\\(?:ll\\|s\\(?:x[al]\\|[alx]\\)?\\)\\|b\\(?:0\\(?:1[23]\\|23\\|[123]\\)\\|1\\(?:23\\|[23]\\)\\|23\\|e\\(?:fr\\|[fr]\\)\\|fr\\|n\\(?:e\\(?:fr\\|[fr]\\)\\|fr\\|[efr]\\)\\|[0-3aefnr]\\)?\\|lr\\(?:uw\\|[bhx]\\)?\\|mp\\|p\\(?:op[12]\\|u\\(?:ll\\|sha?\\)\\)\\|\\(?:rd\\|wr\\)cxt\\)\\|d\\(?:ec\\(?:cc\\)?\\|ivscc\\|one\\)\\|e\\(?:dge\\(?:16l?\\|32l?\\|8l?\\)\\|f\\(?:a\\(?:bss\\|dd[ds]\\)\\|cmp\\(?:e[ds]\\|[ds]\\)\\|d\\(?:iv[ds]\\|to[is]\\)\\|ito[ds]\\|m\\(?:ovs\\|ul[ds]\\)\\|negs\\|s\\(?:muld\\|qrt[ds]\\|to[di]\\|ub[ds]\\)\\)\\)\\|f\\(?:a\\(?:bs[dqsx]\\|dd[dqsx]\\|ligndata\\|nd\\(?:not\\(?:[12]s\\|[12]\\)\\|s\\)?\\)\\|b\\(?:ge\\|l[eg]\\|n[ez]\\|u\\(?:[gl]e\\|[egl]\\)\\|[aeglnouz]\\)?\\|cmp\\(?:e\\(?:q\\(?:16\\|32\\)\\|[dqsx]\\)\\|gt\\(?:16\\|32\\)\\|le\\(?:16\\|32\\)\\|ne\\(?:16\\|32\\)\\|[dqsx]\\)\\|d\\(?:iv[dqsx]\\|mul[qx]\\|to[iqsx]\\)\\|expand\\|ito[dqs]\\|lushw?\\|m\\(?:add[ds]\\|ov\\(?:d\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|q\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|r\\(?:d\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|q\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|s\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\)\\|s\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)\\|[dqsx]\\)\\|sub[ds]\\|ul\\(?:8\\(?:sux16\\|ulx16\\|x16\\(?:a[lu]\\)?\\)\\|d8\\(?:\\(?:su\\|ul\\)x16\\)\\|[dqsx]\\)\\)\\|n\\(?:ands?\\|eg[dqsx]\\|m\\(?:add[ds]\\|sub[ds]\\)\\|o\\(?:rs?\\|t\\(?:[12]s\\|[12]\\)\\)\\)\\|o\\(?:nes?\\|r\\(?:not\\(?:[12]s\\|[12]\\)\\|s\\)?\\)\\|p\\(?:a\\(?:ck\\(?:16\\|32\\|fix\\)\\|dd\\(?:16s?\\|32s?\\)\\)\\|merge\\|sub\\(?:16s?\\|32s?\\)\\)\\|qto[disx]\\|s\\(?:muld\\|qrt[dqsx]\\|rc\\(?:[12]s\\|[12]\\)\\|to[diqx]\\|ub[dqsx]\\)\\|x\\(?:nors?\\|ors?\\|to[dqs]\\)\\|zeros?\\)\\|i\\(?:flush\\|lltrap\\|mpdep[12]\\|nc\\(?:cc\\)?\\|prefetch\\)\\|jmpl?\\|ld\\(?:da\\|qa\\|s\\(?:ba\\|ha\\|tuba?\\|wa\\|[bhw]\\)\\|u\\(?:[bhw]a\\|[bhw]\\)\\|xa\\|[adqx]\\)?\\|m\\(?:embar\\|ov\\(?:c[cs]\\|g\\(?:eu\\|[eu]\\)\\|l\\(?:eu\\|[egu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|r\\(?:g\\(?:e?z\\)\\|l\\(?:e?z\\)\\|n[ez]\\|[ez]\\)\\|u\\(?:[gl]e\\|[egl]\\)\\|v[cs]\\|[aeglnouz]\\)?\\|ul\\(?:scc\\|x\\)\\)\\|n\\(?:eg\\|o[pt]\\)\\|or\\(?:cc\\|n\\(?:cc\\)?\\)?\\|p\\(?:dist\\|opc\\|refetcha?\\)\\|r\\(?:d\\(?:pr\\)?\\|e\\(?:stored?\\|t\\(?:ry\\|urn\\|[lt]\\)?\\)\\)\\|s\\(?:aved?\\|can\\|div\\(?:cc\\|x\\)?\\|et\\(?:hi\\|sw\\|uw\\|x\\)?\\|hu\\(?:ffle\\|tdown\\)\\|i\\(?:gnx\\|r\\)\\|llx?\\|m\\(?:acd?\\|ul\\(?:cc\\|d\\)?\\)\\|pilld?\\|r\\(?:[al]x\\|[al]\\)\\|t\\(?:bar?\\|da\\|ha\\|qa\\|s\\(?:[bhw]a\\|[bhw]\\)\\|u\\(?:[bhw]a\\|[bhw]\\)\\|[wx]a\\|[abdhqwx]\\)?\\|ub\\(?:[cx]?cc\\|[cx]\\)?\\|wapa?\\)\\|t\\(?:addcc\\(?:tv\\)?\\|c[cs]\\|eq\\|g\\(?:eu\\|[etu]\\)\\|l\\(?:eu\\|[etu]\\)\\|n\\(?:eg\\|[ez]\\)\\|pos\\|s\\(?:t\\|ubcc\\(?:tv\\)?\\)\\|v[cs]\\|[aeglnz]\\)\\|u\\(?:div\\(?:cc\\|x\\)?\\|m\\(?:acd?\\|ul\\(?:cc\\|d\\)?\\)\\|nimp\\)\\|wr\\(?:pr\\)?\\|x\\(?:nor\\(?:cc\\)?\\|or\\(?:cc\\)?\\)\\|[bt]\\)\\>"
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


;;
;; PTX
;;

(when nil
  (regexp-opt
   (list

    "add" "sub" "addc" "subc" "mul" "mad" "mul24" "mad24" "sad" "div"
    "div.sat"
    "rem" "abs" "neg" "min" "max"

    "setp.eq" "setp.ne" "setp.lt" "setp.le" "setp.gt" "setp.ge"
    "setp.lo" "setp.ls" "setp.hi" "setp.hs" "setp.equ" "setp.neu"
    "setp.ltu" "setp.leu" "setp.gtu" "setp.geu" "setp.num" "setp.nan"

    "set.eq" "set.ne" "set.lt" "set.le" "set.gt" "set.ge" "set.lo"
    "set.ls" "set.hi" "set.hs" "set.equ" "set.neu" "set.ltu" "set.leu"
    "set.gtu" "set.geu" "set.num" "set.nan"

    "selp" "slct" "and" "or"
    "xor" "not" "cnot" "shl" "shr" "mov" "ld" "ld.volatile" "st" "cvt"
    "tex.1d" "tex.2d" "tex.3d"
    "bra" "bra.uni"
    "call" "call.uni" "ret" "ret.uni" "exit" "bar.sync" "atom" "red"
    "vote.all" "vote.any" "vote.uni"
    "rcp" "sqrt" "rsqrt"
    "sin" "cos" "lg2" "ex2" "trap" "brkpt"

    "fma" "cvta"

    ) 'words))

(defvar ptx-all-instr-regexp
  "\\<\\(a\\(?:bs\\|ddc?\\|nd\\|tom\\)\\|b\\(?:ar\\.sync\\|r\\(?:a\\(?:\\.uni\\)?\\|kpt\\)\\)\\|c\\(?:all\\(?:\\.uni\\)?\\|not\\|os\\|vta?\\)\\|div\\(?:\\.sat\\)?\\|ex\\(?:2\\|it\\)\\|fma\\|l\\(?:d\\(?:\\.volatile\\)?\\|g2\\)\\|m\\(?:a\\(?:d24\\|[dx]\\)\\|in\\|ov\\|ul\\(?:24\\)?\\)\\|n\\(?:eg\\|ot\\)\\|or\\|r\\(?:cp\\|e\\(?:t\\.uni\\|[dmt]\\)\\|sqrt\\)\\|s\\(?:ad\\|e\\(?:lp\\|t\\(?:\\.\\(?:equ?\\|g\\(?:[et]u\\|[et]\\)\\|h[is]\\|l\\(?:[et]u\\|[eost]\\)\\|n\\(?:an\\|eu?\\|um\\)\\)\\|p\\.\\(?:equ?\\|g\\(?:[et]u\\|[et]\\)\\|h[is]\\|l\\(?:[et]u\\|[eost]\\)\\|n\\(?:an\\|eu?\\|um\\)\\)\\)\\)\\|h[lr]\\|in\\|lct\\|qrt\\|t\\|ubc?\\)\\|t\\(?:ex\\.\\(?:[123]d\\)\\|rap\\)\\|vote\\.\\(?:a\\(?:ll\\|ny\\)\\|uni\\)\\|xor\\)\\>"
  "Regexp matching PTX instructions.")

;;
;; VP 1  (Vertex Program)
;;

(when nil
  (regexp-opt
   (list
    "ARL" "MOV" "MUL" "ADD" "MAD"
    "RCP" "RSQ" "DP3" "DP4" "DST" "MIN" "MAX" "SLT" "SGE" "EXP" "LOG" "LIT"
    ) 'words)
  )

(defvar vp1-all-instr-regexp
"\\<\\(A\\(?:DD\\|RL\\)\\|D\\(?:P[34]\\|ST\\)\\|EXP\\|L\\(?:IT\\|OG\\)\\|M\\(?:A[DX]\\|IN\\|OV\\|UL\\)\\|R\\(?:CP\\|SQ\\)\\|S\\(?:GE\\|LT\\)\\)\\>")


;; SASS GT200 (NVIDIA native)

(when nil
  (regexp-opt
   (list
    "A2R" "ADA" "BAR" "BRA" "BRK" "BRX" "C2R" "CAL" "COS" "DADD"
    "DFMA" "DMAX" "DMIN" "DMUL" "DSET"
    "EX2" "F2F" "F2I" "FADD" "FADD32" "FADD32I" "FCMP" "FMAD" "FMAD32"
    "FMAD32I" "FMAX"
    "FMIN" "FMUL" "FMUL32" "FMUL32I" "FSET" "G2R" "GLD"
    "GLD.LCK" "R2G.UNL" "GST" "I2F" "I2I"
    "IADD" "IADD32" "IADD32I" "IMAD" "IMAD32" "IMAD32I"
    "IMAX" "IMIN" "IMUL" "IMUL32"
    "IMUL32I" "ISAD" "ISAD32" "ISET" "LG2" "LLD" "LST"
    "LOP.XOR" "LOP.AND" "LOP.OR" 
    "MOV" "MOV32" "MVC" "MVI" "NOP"
    "R2A" "R2C" "R2G" "RCP" "RCP32" "RET" "RRO" "RSQ" "S2R"
    "SHL" "SHR" "SIN" "SSY" "TEX" "TEX32" "VOTE"
    ) 'words)
)

(defvar sass-gt200-all-instr-regexp
"\\<\\(A\\(?:2R\\|DA\\)\\|B\\(?:AR\\|R[AKX]\\)\\|C\\(?:2R\\|AL\\|OS\\)\\|D\\(?:ADD\\|FMA\\|M\\(?:AX\\|IN\\|UL\\)\\|SET\\)\\|EX2\\|F\\(?:2[FI]\\|ADD\\(?:32I?\\)?\\|CMP\\|M\\(?:A\\(?:D32I?\\|[DX]\\)\\|IN\\|UL\\(?:32I?\\)?\\)\\|SET\\)\\|G\\(?:2R\\|LD\\(?:\\.LCK\\)?\\|ST\\)\\|I\\(?:2[FI]\\|ADD\\(?:32I?\\)?\\|M\\(?:A\\(?:D32I?\\|[DX]\\)\\|IN\\|UL\\(?:32I?\\)?\\)\\|S\\(?:AD\\(?:32\\)?\\|ET\\)\\)\\|L\\(?:G2\\|LD\\|OP\\.\\(?:AND\\|X?OR\\)\\|ST\\)\\|M\\(?:OV\\(?:32\\)?\\|V[CI]\\)\\|NOP\\|R\\(?:2\\(?:G\\.UNL\\|[ACG]\\)\\|CP\\|ET\\|RO\\|SQ\\)\\|S\\(?:2R\\|H[LR]\\|IN\\|SY\\)\\|TEX\\(?:32\\)?\\|RCP32\\|VOTE\\|GATOM\\.\\(IADD\\|EXCH\\|CAS\\|IMIN\\|IMAX\\|INC\\|DEC\\|IAND\\|IOR\\|IXOR\\)\\|GRED\\.\\(IADD\\|IMIN\\|IMAX\\|INC\\|DEC\\|IAND\\|IOR\\|IXOR\\)\\|PBK\\)\\>")

;; SASS Fermi (NVIDIA native)

(when nil
  (regexp-opt
   (list
    "ATOM" "B2R" "BAR" "BFE" "BFI" "BPT" "BRA" "BRK" "BRX" "CAL" "CCTL"
    "CCTLL" "CONT" "CSET" "CSETP" "DADD" "DFMA" "DMNMX" "DMUL" "DSET"
    "DSETP" "EXIT" "F2F" "F2I" "FADD" "FCMP" "FFMA" "FLO" "FMNMX" 
    "FMUL" "FMUL32I"
    "FSET" "FSETP" "FSWZ" "I2F" "I2I" "IADD" "ICMP" "IMAD" "IMNMX" "IMUL"
    "ISAD" "ISCADD" "ISET" "ISETP" "JCAL" "JMP" "JMX" "LD" "LDC" "LDL"
    "LDLK" "LDS" "LDSLK" "LDS_LDU" "LDU" "LDU" "LD_LDU" "LEPC" "LONGJMP"
    "LOP" "LOP32I"
    "MEMBAR" "MOV" "MOV32I" "MUFU" "NOP" "P2R" "PBK" "PCNT" "PLONGJMP"
    "POPC" "PRET" "PRMT" "PSET" "PSETP" "R2P" "RED" "RET" "RRO" "S2R"
    "SEL" "SHL" "SHR" "SSY" "ST" "STL" "STS" "STSUL" "STUL" "SULD"
    "SULEA" "SUQ" "SURED" "SUST" "TEX" "TLD" "TLD4" "TXQ" "VOTE"
    ) 'words))

(defvar sass-fermi-all-instr-regexp
  "\\<\\(ATOM\\|B\\(?:2R\\|AR\\|F[EI]\\|PT\\|R[AKX]\\)\\|C\\(?:AL\\|CTLL?\\|ONT\\|SETP?\\)\\|D\\(?:ADD\\|FMA\\|M\\(?:NMX\\|UL\\)\\|SETP?\\)\\|EXIT\\|F\\(?:2[FI]\\|ADD\\|CMP\\|FMA\\|LO\\|M\\(?:NMX\\|UL\\)\\|S\\(?:ETP?\\|WZ\\)\\)\\|I\\(?:2[FI]\\|ADD\\|CMP\\|M\\(?:AD\\|NMX\\|UL\\)\\|S\\(?:AD\\|CADD\\|ETP?\\)\\)\\|J\\(?:CAL\\|M[PX]\\)\\|L\\(?:D\\(?:LK\\|S\\(?:LK\\|_LDU\\)\\|_LDU\\|[CLSU]\\)?\\|EPC\\|O\\(?:\\(?:NGJM\\)?P\\)\\)\\|M\\(?:EMBAR\\|OV\\|UFU\\)\\|NOP\\|P\\(?:2R\\|BK\\|CNT\\|LONGJMP\\|OPC\\|R\\(?:[EM]T\\)\\|SETP?\\)\\|R\\(?:2P\\|E[DT]\\|RO\\)\\|S\\(?:2R\\|EL\\|H[LR]\\|SY\\|T\\(?:S?UL\\|[LS]\\)?\\|U\\(?:L\\(?:D\\|EA\\)\\|Q\\|RED\\|ST\\)\\)\\|T\\(?:EX\\|LD4?\\|XQ\\)\\|VOTE\\)\\>")

;; SASS Kepler (NVIDIA native)
(when nil
  (regexp-opt
   (list
    "FFMA" "FADD" "FCMP" "FMUL" "FMNMX" "FSWZ" "FSET" "FSETP" "FCHK" "RRO"
    "MUFU" "DFMA" "DADD" "DMUL" "DMNMX" "DSET" "DSETP" "IMAD" "IMADSP"
    "IMUL" "IADD" "ISCADD" "ISAD" "IMNMX" "BFE" "BFI" "SHR" "SHL" "SHF"
    "LOP" "FLO" "ISET" "ISETP" "ICMP" "POPC" "F2F" "F2I" "I2F" "I2I" "MOV"
    "SEL" "PRMT" "SHFL" "P2R" "R2P" "CSET" "CSETP" "PSET" "PSETP" "TEX"
    "TLD" "TLD4" "TXQ" "LDC" "LD" "LDG" "LDL" "LDS" "LDSLK" "ST" "STL"
    "STS" "STSCUL" "ATOM" "RED" "CCTL" "CCTLL" "MEMBAR" "SUCLAMP" "SUBFM"
    "SUEAU" "SULDGA" "SUSTGA" "BRA" "BRX" "JMP" "JMX" "CAL" "JCAL" "RET"
    "BRK" "CONT" "SSY" "PBK" "PCNT" "PRET" "BPT" "EXIT" "NOP" "S2R" "B2R"
    "BAR" "VOTE" "MOV32I" "FMUL32I" "LOP32I" "TEXDEPBAR" "ISUB"
    ) 'words))

(defvar sass-kepler-all-instr-regexp
"\\<\\(ATOM\\|B\\(?:2R\\|AR\\|F[EI]\\|PT\\|R[AKX]\\)\\|C\\(?:AL\\|CTLL?\\|ONT\\|SETP?\\)\\|D\\(?:ADD\\|FMA\\|M\\(?:NMX\\|UL\\)\\|SETP?\\)\\|EXIT\\|F\\(?:2[FI]\\|ADD\\|C\\(?:HK\\|MP\\)\\|FMA\\|LO\\|M\\(?:NMX\\|UL\\(?:32I\\)?\\)\\|S\\(?:ETP?\\|WZ\\)\\)\\|I\\(?:2[FI]\\|ADD\\|CMP\\|M\\(?:AD\\(?:SP\\)?\\|NMX\\|UL\\)\\|S\\(?:AD\\|CADD\\|ETP?\\|UB\\)\\)\\|J\\(?:CAL\\|M[PX]\\)\\|L\\(?:D\\(?:SLK\\|[CGLS]\\)?\\|OP\\(?:32I\\)?\\)\\|M\\(?:EMBAR\\|OV\\(?:32I\\)?\\|UFU\\)\\|NOP\\|P\\(?:2R\\|BK\\|CNT\\|OPC\\|R\\(?:[EM]T\\)\\|SETP?\\)\\|R\\(?:2P\\|E[DT]\\|RO\\)\\|S\\(?:2R\\|EL\\|H\\(?:FL\\|[FLR]\\)\\|SY\\|T\\(?:SCUL\\|[LS]\\)?\\|U\\(?:BFM\\|CLAMP\\|EAU\\|\\(?:LD\\|ST\\)GA\\)\\)\\|T\\(?:EX\\(?:DEPBAR\\)?\\|LD4?\\|XQ\\)\\|VOTE\\)\\>")



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
  (cond
   ((save-excursion
      ;; Vertex Program.
      (goto-char (point-min))
      (looking-at "!!ARBvp"))
    (setq
     asm-comment-char ?#
     asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list
            (cons vp1-all-instr-regexp
                  font-lock-keyword-face))

           '(
             ;; Line Labels (PTX)
             ("\\$L[_A-Z0-9a-z]+" . font-lock-constant-face)

             ;; Line Labels (Decuda)
             ("^[A-Z]+:" . font-lock-constant-face)
             ("\\.label \\(label[0-9]+\\)" (1 font-lock-constant-face))

             ;; Instruction Modifiers
             ("[. ][busf]\\(8\\|16\\|32\\|64\\|128\\)\\>" . font-lock-type-face)
             ("\\.[xyzwrgba]\\>" . font-lock-type-face)
             ("\\<\\(ld\\|\\(ld\\|st\\)\\.volatile\\|st\\)\\.\\(param\\|const\\|shared\\|global\\)"
              (3 'asm-memory-space-face))
             ("\\.\\(r[nzmp]i?\\)\\>" . font-lock-keyword-face)
             ("\\<\\(ld\\|st\\)\\.\\(local\\)"
              (2 font-lock-warning-face))

             ;; nv50
             ("\\<\\(e\\|lg\\|bar\\|join\\(at\\)?\\|set\\)\\>"
              . font-lock-keyword-face)

             ; Predicated Instruction Prefix
             ("\\(@!?\\)[%$]p[0-9]" (1 font-lock-keyword-face))

             ;; Alignment, Vector
             ("\\.\\(align\\|v2\\|v4\\)\\>"
              (1 (list font-lock-type-face 'italic)))

             ;; Assembler Directives
             ("\\.\\(loc\\|file\\|version\\|target\\)\\>"
              (1 'asm-directive-face))

             ;; Registers
             ("\\(tex[0-9]+\\|c.[0-9]+.\\|R[0-9]+\\|\\(vertex\\|result\\)\\.[a-z]+\\)\\>"
              (1 font-lock-variable-name-face) )

             ))))

   ((save-excursion
      ;; SASS GT200 (NVIDIA native)
      (goto-char (point-min))
      (or
       (re-search-forward "code for sm_1" 1000 t)))
    (setq asm-comment-char ?#
          asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list (cons sass-gt200-all-instr-regexp font-lock-keyword-face))
           '(
             ;; Instruction Modifiers
             ("[.][FSU]\\(8\\|16\\|32\\|64\\|128\\)\\>" . font-lock-type-face)

             ;; Reconvergence points.
             ("[A-Z264][.]\\(S\\)\\>"
              (1 (list font-lock-constant-face 'italic)))
             ("\\<\\(SSY\\|PBK\\) \\(0x\\([a-f0-9]+\\)\\)"
              (2 'italic)
              (3 (list 'italic font-lock-constant-face)))

             ;; Predicates
             ("\\((\\)\\(C[0-9]\\)\\(\\.\\)\\([A-Z]+\\)\\()\\)"
              (1 (list 'italic font-lock-constant-face))
              (2 (list 'italic font-lock-variable-name-face))
              (3 (list 'italic font-lock-constant-face))
              (4 (list 'italic 'asm-insn-modifier-face))
              (5 (list 'italic font-lock-constant-face)))

             ; Memory Space Indicator
             ("\\(global14\\|c\\|o\\|g\\) *\\["
              (1 'asm-memory-space-face))
             ; Memory Space Indicator
             ("\\(local\\) *\\["
              (1 (list font-lock-warning-face 'italic)))

             ; Comparison
             ("\\<\\(LT\\|GT\\|EQU?\\|NEU?\\|GE\\|LE\\)\\>"
              . 'asm-insn-modifier-face)

             ;; Assembler Directives
             ("\\.\\(loc\\|file\\|version\\|target\\)\\>"
              (1 'asm-directive-face))

             ;; Registers
             ("\\<\\(R[0-9]+\\)\\([LH]*\\)\\>"
              (1 font-lock-variable-name-face)
              (2 font-lock-type-face)
              )

             ("\\<\\(C[0-9]\\|A[0-9]+\\)\\>"
              (1 font-lock-variable-name-face) )

             ))))

   ((save-excursion
      ;; SASS Fermi (NVIDIA native)
      (goto-char (point-min))
      (or
       (re-search-forward "code for sm_2" 1000 t)))
    (setq asm-comment-char ?#
          asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list (cons sass-fermi-all-instr-regexp font-lock-keyword-face))
           '(
             ;; Instruction Modifiers
             ("[.][FSU]\\(8\\|16\\|32\\|64\\|128\\)\\>" . font-lock-type-face)

             ;; Instruction Modifiers
             ("[.]\\(FTZ\\|HI\\|[WXE]\\)\\>" . font-lock-type-face)

             ;; Reconvergence points.
             ("[A-Z264][.]\\(S\\)\\>"
              (1 (list font-lock-constant-face 'italic)))
             ("\\<\\(SSY\\|PBK\\) \\(0x\\([a-f0-9]+\\)\\)"
              (2 'italic)
              (3 (list 'italic font-lock-constant-face)))

             ; Comparison
             ("\\<\\(LTU?\\|GTU?\\|EQU?\\|NEU?\\|GEU?\\|LEU?\\|OR\\|AND\\|XOR\\)\\>"
              . 'asm-insn-modifier-face)

             ;; Assembler Directives
             ("\\.\\(loc\\|file\\|version\\|target\\)\\>"
              (1 'asm-directive-face))

             ;; Predicate Registers
             ("\\<@?\\(P[0-9]+\\)\\>"
              (1 font-lock-constant-face))

             ;; Registers
             ("\\<\\(R[0-9]+\\)\\([LH]*\\)\\>"
              (1 font-lock-variable-name-face)
              (2 font-lock-type-face)
              )

             ; Constant Memory
             ("\\(c\\) *\\["
              (1 'asm-memory-space-face))

             ;; Local Memory
             ("\\(LDL\\|STL\\)"
              (1 (list font-lock-warning-face 'italic) t))

             ;; Shared Memory
             ("\\(LDS\\|STS\\)"
              (1 'asm-memory-space-face t))

             ;; Multi Funk (Special FP Unit?) Insn
             ("\\<MUFU\\.\\(RSQ\\|RCP\\|SIN\\|COS\\)\\>"
              (1 font-lock-keyword-face t))

             ;; Special Registers
             ("\\<\\(SR_[A-Za-z_]+\\|RZ\\)\\>"
              (1 (list font-lock-variable-name-face 'italic)))

             ))))

   ((save-excursion
      ;; SASS Kepler (NVIDIA native)
      (goto-char (point-min))
      (or
       (re-search-forward "code for sm_3" 1000 t)))
    (setq asm-comment-char ?#
          asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list (cons sass-kepler-all-instr-regexp font-lock-keyword-face))
           '(
             ;; Instruction Modifiers
             ("[.][FSU]\\(8\\|16\\|32\\|64\\|128\\)\\>" . font-lock-type-face)

             ;; Instruction Modifiers
             ("[.]\\(FTZ\\|HI\\|[WXE]\\)\\>" . font-lock-type-face)

             ;; Reconvergence points.
             ("[A-Z264][.]\\(S\\)\\>"
              (1 (list font-lock-constant-face 'italic)))
             ("\\<\\(SSY\\|PBK\\) \\(0x\\([a-f0-9]+\\)\\)"
              (2 'italic)
              (3 (list 'italic font-lock-constant-face)))

             ; Comparison
             ("\\<\\(LTU?\\|GTU?\\|EQU?\\|NEU?\\|GEU?\\|LEU?\\|OR\\|AND\\|XOR\\)\\>"
              . 'asm-insn-modifier-face)

             ;; Assembler Directives
             ("\\.\\(loc\\|file\\|version\\|target\\)\\>"
              (1 'asm-directive-face))

             ;; Predicate Registers
             ("\\<@?\\(P[0-9]+\\)\\>"
              (1 font-lock-constant-face))

             ;; Registers
             ("\\<\\(R[0-9]+\\)\\([LH]*\\)\\>"
              (1 font-lock-variable-name-face)
              (2 font-lock-type-face)
              )

             ; Constant Memory
             ("\\(c\\) *\\["
              (1 'asm-memory-space-face))

             ;; Local Memory
             ("\\(LDL\\|STL\\)"
              (1 (list font-lock-warning-face 'italic) t))

             ;; Shared Memory
             ("\\(LDS\\|STS\\)[A-Z]*"
              (0 'asm-memory-space-face t))

             ;; Multi Func (Special FP Unit?) Insn
             ("\\<MUFU\\.\\(RSQ\\|RCP\\|SIN\\|COS\\)\\>"
              (1 font-lock-keyword-face t))

             ;; Special Registers
             ("\\<\\(SR[0-9]+\\|SR_[A-Za-z_]+\\|RZ\\)\\>"
              (1 (list font-lock-variable-name-face 'italic)))

             ))))

   ((save-excursion
      ;; PTX (NVIDIA CUDA)
      (goto-char (point-min))
      (or
       (string-match "\\.ptx$" (or (buffer-file-name) ""))
       (re-search-forward "NVIDIA NVVM" 1000 t)))
    (setq asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list
            (cons (concat "[^._]" ptx-all-instr-regexp)
                  font-lock-keyword-face))

           '(
             ;; Line Labels (PTX)
             ("\\$L[_A-Z0-9a-z]+" . font-lock-constant-face)

             ;; Line Labels (Decuda)
             ("^label[0-9]+:" . font-lock-constant-face)
             ("\\.label \\(label[0-9]+\\)" (1 font-lock-constant-face))

             ;; Instruction Modifiers
             ("[. ][busf]\\(8\\|16\\|32\\|64\\|128\\)\\>" . font-lock-type-face)
             ("\\.pred\\>" . font-lock-type-face)
             ("\\<\\(ld\\|ld\\.volatile\\|st\\)\\.\\(param\\|const\\|shared\\|global\\)"
              (2 'asm-memory-space-face))
             ("\\.\\(r[nzmp]i?\\)\\>" . font-lock-keyword-face)
             ("\\<\\(ld\\|st\\)\\.\\(local\\)"
              (2 font-lock-warning-face))

             ;; nv50
             ("\\<\\(e\\|lg\\|bar\\|join\\(at\\)?\\|set\\)\\>"
              . font-lock-keyword-face)

             ;; Decuda Instructions
             ("\\(movsh\\|join\\.label\\|nop\\)"
              . font-lock-keyword-face)

             ; Predicated Instruction Prefix
             ("\\(@!?\\)[%$]p[0-9]" (1 font-lock-keyword-face))

             ;; Alignment, Vector
             ("\\.\\(align\\|v2\\|v4\\)\\>"
              (1 (list font-lock-type-face 'italic)))

             ;; Assembler Directives
             ("\\.\\(loc\\|file\\|version\\|target\\|address_size\\)\\>"
              (1 'asm-directive-face))

             ;; Register/Memory Space Definitions
             ("^\\s *\\.\\(const\\|tex\\|reg\\|shared\\|local\\|param\\)\\>"
              (1 'asm-memory-space-face))

             ;; Decuda Register/Memory Space Definitions
             ("^#?\\.\\([ls]mem\\|reg\\|bar\\|constseg\\)\\>"
              (1 'asm-memory-space-face))

             ("\\<\\(c[01]\\|g\\|s\\)\\["
              (1 (list font-lock-keyword-face 'italic)))

             ;; Code Entry Point
             ("\\.\\(entry\\)\\>\\s +\\(\\(\\sw\\|\\s_\\)+\\)"
              (1 'asm-directive-face)
              (2 font-lock-function-name-face))

             ;; Registers
             ("\\(\\%\\|\\$\\)\\(tex[0-9]+\\|ofs[0-3]\\|p[0-9]+\\|fd?[0-9]+\\|pm[0-3]\\|r[lchd]?[0-9]+\\|a[0-9]+\\|clock\\|tid\\|ntid\\|laneid\\|warpid\\|ctaid\\|nctaid\\|smid\\|nsmid\\|gridid\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-variable-name-face) )

             ;; Registers
             ("\\(\\$\\)\\(r[0-9]+\\)\\([lhg]\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-variable-name-face)
              (3 font-lock-string-face)
              )
             ))))

   ((save-excursion
      ;; SPARC
      (goto-char (point-min))
      (or
       (re-search-forward "^!" 100 t)
       (re-search-forward "\\<save[ \t]+%sp\\>" 50000 t)))
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
             ;; ("^\\s +\\(\\(\\sw\\|\\s_\\)+\\)" 1 font-lock-keyword-face)

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

             ("\\(\\%\\)\\([ioglf][12]?[0-9]\\|[iogl]3[01]\\|f[3-6][0-9]\\|[sf]p\\|[fix]cc[0-3]\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-variable-name-face) )

             ))))

   ((save-excursion
      ;; IA-32, 64, phi
      (goto-char (point-min))
      (or
       (re-search-forward "x86_64" 1000 t)
       (re-search-forward "%eax" 50000 t)))
    (setq asm-comment-char ?#
          asm-font-lock-keywords
          (append
           asm-markup-extra-font-lock-keywords
           (list
            (cons ia32-all-instr-regexp font-lock-keyword-face))
           '(
             ("^[ \t]*\\.section.*" . font-lock-heading-face)
             ("^\\(\\(\\sw\\|\\s_\\)+\\)\\>:?[\t]*\\(\\sw+\\)?"
              (1 font-lock-function-name-face)
              (3 font-lock-keyword-face nil t))
             ("^\\s *\.L[A-Z0-9a-z]*:" . font-lock-function-name-face)
             ;; ("^\\s +\\(\\(\\sw\\|\\s_\\)+\\)" 1 font-lock-keyword-face)

             ;; Instructions possibly indicating inefficiency.
             ("\\(vpermf32x4\\|vpermd\\|\\(vloadunpack\\)[hl]p[dsq]\\)\\>"
              (0 font-lock-warning-face t t))

             ;; Instructions of special interest.
             ("\\(vprefetch[a-z0-9]*\\)"
              (0 'asm-insn-special-face t t))

             ;; Comment used as a heading.
             ("^## \\(.*\\)"
              (1 'asm-comment-heading-face t t))

             ;; Comment used as a sub heading.
             ("^\\s-+## \\(.*\\)"
              (1 'asm-comment-sub-heading-face t t))

             ;; Literal Directives
             ("\\.\\([248]*\\(?:space\\|string\\|long\\|byte\\|double\\|float\\|quad\\|size\\||long\\|half\\|word\\)\\)\\>"
              (1 (list font-lock-type-face 'italic)))

             ;; Assembler Directives
             ("\\.\\(loc\\|align\\|file\\|type\\)\\>"
              (1 'asm-directive-face))

             ;; Other Assembler Directives
             ("\\.\\(extern\\|globl\\|global\\)\\>\\s +\\(\\(\\sw\\|\\s_\\)+\\)"
              (1 'asm-directive-face)
              (2 font-lock-function-name-face)
              )

             ;; Immediate Values
             ("\\(\\$\\)[0-9]+"
              (1 font-lock-string-face))              

             ;; Segment Directives
             ("\\.\\([rk]?o?data\\|[rk]?text\\|section\\)\\>"
              (1 (list 'asm-directive-face 'bold)))

             ;; Predicate Registers
             ("\\(\\%\\)\\(k[0-9]+\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-constant-face) )

             ;; Vector Registers
             ("\\(\\%\\)\\([xyz]mm[0-9]+\\)\\>"
              (1 font-lock-string-face)
              (2 'asm-vector-register-face))

             ;; Registers
             ("\\(\\%\\)\\(r[0-9]+d?\\|rs[ip]\\|r[a-d][ipx]\\|rip\\|e[a-ds][ix]\\)\\>"
              (1 font-lock-string-face)
              (2 font-lock-variable-name-face) )

             ))))

   ((save-excursion
      (goto-char (point-min))
      (or (looking-at "#")
          (re-search-forward "\\<addi\\>" 20000 t)))
    ;; MIPS
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
              (0 font-lock-string-face) (1 font-lock-heading-face t))))))))

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
  (compile (concat 
            asv-program " " (file-name-nondirectory (buffer-file-name)))))


(add-hook 'asm-mode-set-comment-hook 'asm-mode-prefs)
(add-hook 'asm-mode-hook 'asm-mode-prefs-2)

(provide 'asm-class)
