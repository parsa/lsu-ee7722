;;; Emacs initialization file for use in LSU EE 7700-X (Graphics Processors)

;; $Id:$

;; This file sets general preferences. Other files are for
;; code specific to the class.

(when (< emacs-major-version 21)
  (error "Initialization file intended for Emacs 21.0 and higher"))

(provide 'popular-settings)
(require 'p-util)

; Tell Emacs to use mouse wheel (if you have one).
(when (fboundp 'mouse-wheel-mode) (mouse-wheel-mode 1))
(setq mouse-wheel-progressive-speed nil)

(when (fboundp 'blink-cursor-mode) (blink-cursor-mode 0))

;;; CUDA, OpenGL, OpenCL Settings

; OpenCL
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hcl\\'" . c++-mode))

; OpenGL Shader Language
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . c-mode))

; CUDA
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cup\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ptx\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . asm-mode))


;;; Misc. Settings

(menu-bar-mode 1)  ; Turn on menus. Change argument to zero to turn off menus.

; Turn on tool bar. Change argument to zero to turn off toolbar.
(when (fboundp 'tool-bar-mode) (tool-bar-mode 1))

(setq-default next-screen-context-lines 1
              scroll-step 1
              line-spacing 2
              indicate-empty-lines t)

(setq scalable-fonts-allowed t
      dired-recursive-copies 'always
      dired-copy-preserve-time t
      scroll-preserve-screen-position t)


;; Keybindings active with windowing systems.

(if window-system
    (progn
;      (global-set-key [f7] 'previous-error) ; Didn't work.
      (global-set-key [f8] 'next-error)
      (global-set-key [f9] 'compile)
      (global-set-key [C-left] 'backward-word)
      (global-set-key [home] 'beginning-of-line)
      (global-set-key [end] 'end-of-line)
      (global-set-key [C-prior] 'beginning-of-buffer)
      (global-set-key [C-next] 'end-of-buffer)
      (global-set-key [backspace] 'delete-backward-char)
      (global-set-key [A-backspace] 'advertised-undo)
      (global-set-key [M-backspace] 'advertised-undo)
      (global-set-key [A-backspace] 'advertised-undo)
      (global-set-key [f2] 'save-buffer)
      (global-set-key [C-f4] 'kill-buffer)
      (global-set-key [f5] 'goto-line)
      (global-set-key [f16] 'kill-ring-save) ;Copy
      (global-set-key [f18] 'yank)
      (global-set-key [f20] 'kill-region) ;Cut
      (global-set-key [S-f20] 'kill-line)
      (global-set-key [S-f31] 'recenter)
      (global-set-key [f29] [prior])
      (global-set-key [S-f29] [S-prior])
      (global-set-key [C-f29] [C-prior])
      (global-set-key [f35] [next])
      (global-set-key [S-f35] [S-next])
      (global-set-key [C-f35] [C-next])
      (global-set-key [f27] [home])
      (global-set-key [S-f27] [S-home])
      (global-set-key [C-f27] [C-home])
      (global-set-key [f33] [end])
      (global-set-key [S-f33] [S-end])
      (global-set-key [C-f33] [C-end])))


;;; Settings for Font Lock (Syntax Highlighting)

;; Change the standard fonts.  This can also be done through
;; the Options | Customize Emacs | Specific Face

(require 'font-lock)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(jit-lock-mode 1)

(defvar p-ss-family-name
  (if (>= emacs-major-version 23)
      (p-first-member
       (list
        "DejaVu LGC Sans" "DejaVu Sans" "Nimbus Sans L"
        "FreeSans") (p-font-family-list))
      "Helv"))


(set-face-attribute
 'font-lock-function-name-face nil
 :family p-ss-family-name :weight 'bold :height 1.4 :foreground "black")
(set-face-attribute
 'font-lock-comment-face nil
 :foreground "Firebrick")
(set-face-attribute
 'font-lock-string-face nil
 :foreground "DarkSlateGray")
(set-face-attribute
 'font-lock-keyword-face nil
 :foreground "RoyalBlue")
(set-face-attribute
 'font-lock-variable-name-face nil
 :foreground "DarkGoldenrod")
(set-face-attribute
 'font-lock-type-face nil
 :foreground "Purple")
(set-face-attribute
 'font-lock-constant-face nil
 :foreground "MediumSeaGreen")

(defface font-lock-api-face
  `((t (:foreground "medium blue" :weight normal :slant normal)))
  "Personal font lock face for API calls, set 1")

(defface font-lock-api2-face
  `((t (:foreground "navy" :weight normal :slant normal)))
  "Personal font lock face for API calls, set 2.")

(defface font-lock-api3-face
  `((t (:foreground "dark cyan" :weight normal :slant normal)))
  "Personal font lock face for API calls, set 3.")


;; Comment heading.

(defface comment-heading-face
  `((t (:family ,p-ss-family-name :weight bold :height 1.5)))
  "Comment heading face.")
(defface comment-sub-heading-face
  `((t (:family ,p-ss-family-name :weight bold 
                :inherit 'font-lock-comment-face)))
  "Comment sub-heading face.")

(font-lock-add-keywords
 'c++-mode
 '(("^/// +\\(.*\\)" (1 'comment-heading-face t))
   ("^ +/// +\\(.*\\)" (1 'comment-sub-heading-face t))))
(font-lock-add-keywords
 'c-mode
 '(("^/// +\\(.*\\)" (1 'comment-heading-face t))
   ("^ +/// +\\(.*\\)" (1 'comment-sub-heading-face t))))
(font-lock-add-keywords
 'cperl-mode
 '(("^## +\\(.*\\)" (1 'comment-heading-face t))
   ("^ +## +\\(.*\\)" (1 'comment-sub-heading-face t))))


;; CUDA-related Highlighting

(font-lock-add-keywords
 'c++-mode
 '(("\\<[cg]l[A-Z][A-Za-z0-9]+\\>" . 'font-lock-api-face)
   ("\\<cu\\(da\\)?[A-Z][A-Za-z0-9]+\\>" . 'font-lock-api2-face)
   ("__syncthreads\\>" . 'font-lock-api2-face)
   ("\\<pthread_[_a-z0-9]+\\>" . 'font-lock-api2-face)
   ("\\<cupti[A-Z][A-Za-z0-9]+\\>" . 'font-lock-api3-face)
   ("\\<[GC]L_[A-Z][_A-Z0-9]+" . 'font-lock-constant-face)
   ("__\\(global\\|device\\|shared\\|constant\\|host\\)__"
    . 'font-lock-keyword-face)
   ))

;; OpenGL Shader Language storage and layout specifiers

(font-lock-add-keywords
 'c++-mode
 '(("\\<\\(in\\|out\\|uniform\\|attribute\\|varying\\|buffer\\)\\>"
    . 'font-lock-keyword-face)
   ("\\<\\(layout\\|binding\\|location\\)\\>"
    . 'font-lock-keyword-face)))
   

;; Highlight long numbers to improve visibility.

(defface number-highlight-face
    `((t (:foreground "cyan4")))
    "Face for highlighting digit groups in numbers.")

(defface number-radix-face
    `((t (:foreground "gray60")))
    "Face for 0x prefix in certain hexadecimal numbers.")

(defvar p-number-highlight-keywords
  '(
    ;; Hexidecimal Integers
;;    ("0x\\([0-9a-fA-F]?[0-9a-fA-F]?[0-9a-fA-F]?[0-9a-fA-F]\\)[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\\>"
    ;;     (1 (quote number-highlight-face) t))
    ("\\(0x\\)[0-9a-fA-F]\\{1,4\\}\\>"
     (1 (quote number-radix-face) t))

    ("\\(0x\\)\\([0-9a-fA-F]\\{1,4\\}\\)[0-9a-fA-F]\\{4\\}\\([Ll]\\{0,2\\}\\)\\>"
     (1 (quote number-radix-face) t)
     (2 (quote number-highlight-face) t)
     (3 (quote number-radix-face) t))

    ("\\(0x\\)[0-9a-fA-F]\\{1,4\\}\\([0-9a-fA-F]\\{4\\}\\)[0-9a-fA-F]\\{4\\}\\([lL]\\{0,2\\}\\)\\>"
     (1 (quote number-radix-face) t)
     (2 (quote number-highlight-face) t)
     (1 (quote number-radix-face) t)
     )

    ("\\(0x\\)\\([0-9a-fA-F]\\{1,4\\}\\)[0-9a-fA-F]\\{4\\}\\([0-9a-fA-F]\\{4\\}\\)[0-9a-fA-F]\\{4\\}\\([lL]\\{0,2\\}\\)\\>"
     (1 (quote number-radix-face) t)
     (2 (quote number-highlight-face) t)
     (3 (quote number-highlight-face) t)
     (4 (quote number-radix-face) t))

    ;; Integer part, highlight thousands and billions (10^9)
    ("\\([^.]\\|^\\)\\<[$]?\\([0-9][0-9]\\)[0-9][0-9][0-9]%?\\>"
     (2 (quote number-highlight-face) t))
    ("\\([^.]\\|^\\)\\<[$]?[0-9]?[0-9]?[0-9]?\\([0-9][0-9][0-9]\\)[0-9][0-9][0-9]%?\\>"
     (2 (quote number-highlight-face) t))
    ("\\([^.]\\|^\\)\\<[$]?\\([0-9]?[0-9]?[0-9]\\)[0-9][0-9][0-9]\\([0-9][0-9][0-9]\\)[0-9][0-9][0-9]%?\\>"
     (2 (quote number-highlight-face) t ) (3 (quote number-highlight-face) t ))

    ("\\([^.]\\|^\\)\\<[$]?[0-9]\\{1,3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}%?\\>"
     (2 'number-highlight-face t)
     (3 (quote number-highlight-face) t))

    ("\\([^.]\\|^\\)\\<[$]?\\([0-9]\\{1,3\\}\\)[0-9]\\{3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}%?\\>"
     (2 'number-highlight-face t)
     (3 (quote number-highlight-face) t)
     (4 'number-highlight-face t))

    ("\\([^.]\\|^\\)\\<[$]?[0-9]\\{1,3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}\\([0-9]\\{3\\}\\)[0-9]\\{3\\}%?\\>"
     (2 'number-highlight-face t)
     (3 (quote number-highlight-face) t)
     (4 'number-highlight-face t)
     )

    ;; Fractional Part
    ("\\(?:[0-9 ]\\|^\\)\\.[0-9]\\{3\\}\\(?:\\(?4:[0-9]\\{3\\}\\)[0-9]\\{0,3\\}\\|\\(?4:[0-9]\\{3\\}\\)\\)\\(?6:[DdEe]\\|\\)\\>"
     (4 'number-highlight-face t)
     (6 'number-radix-face t))

    ("\\(?:[0-9 ]\\|^\\)\\.[0-9]\\{1,5\\}\\(?6:[DdEe]\\)\\>"
     (6 'number-radix-face t))

    ("\\(?:[0-9 ]\\|^\\)\\.[0-9]\\{3\\}\\(?3:[0-9]\\{3\\}\\)[0-9]\\{3\\}\\(?:\\(?4:[0-9]\\{3\\}\\)[0-9]\\{0,3\\}\\|\\(?4:[0-9]\\{1,3\\}\\)\\)\\(?6:[DdEe]\\|\\)\\>"
     (3 'number-highlight-face t)
     (4 'number-highlight-face t)
     (6 'number-radix-face t))

    ("\\(?:[0-9 ]\\|^\\)\\.[0-9]\\{3\\}\\(?2:[0-9]\\{3\\}\\)[0-9]\\{3\\}\\(?3:[0-9]\\{3\\}\\)[0-9]\\{3\\}\\(?:\\(?4:[0-9]\\{3\\}\\)[0-9]\\{0,3\\}\\|\\(?4:[0-9]\\{1,3\\}\\)\\)\\(?6:[DdEe]\\|\\)\\>"
     (2 'number-highlight-face t)
     (3 'number-highlight-face t)
     (4 'number-highlight-face t)
     (6 'number-radix-face t)))

  "Font lock keywords for highlighting groups of digits.
Highlights thousands and billions in integers and second group of
four in hexadecimal integers.")


(font-lock-add-keywords
 'c++-mode
 p-number-highlight-keywords)
(font-lock-add-keywords
 'c-mode
 p-number-highlight-keywords)
(font-lock-add-keywords
 'cperl-mode
 p-number-highlight-keywords)


;; Hi-lock Highlight based on regexps.

(if (functionp 'global-hi-lock-mode)
            (global-hi-lock-mode 1) (hi-lock-mode 1))

;;; Settings for Flyspell  (Spell checker.)


(require 'flyspell)

(defun turn-on-flyspell-mode () (flyspell-mode 1))
(defun turn-off-flyspell-mode () (flyspell-mode 0))
(setq flyspell-highlight-properties t
      flyspell-multi-language-p nil 
      flyspell-issue-welcome-flag nil)

(defun turn-on-flyspell-prog-mode () (interactive)
  (if (fboundp 'flyspell-prog-mode)
      (flyspell-prog-mode)
    (setq p-flyspell-restricted-checking t)
    (flyspell-mode 1)))

(when (and (>= emacs-major-version 20) window-system)
  (add-hook 'mail-send-hook 'turn-off-flyspell-mode)
  (add-hook 'text-mode-hook 'turn-on-flyspell-mode)
  (add-hook 'tex-mode-hook 'turn-on-flyspell-mode t)
  (add-hook 'mail-setup-hook 'turn-on-flyspell-mode)
  (add-hook 'fundamenal-mode-hook 'turn-on-flyspell-mode t)
  (add-hook 'log-mode-hook 'turn-on-flyspell-mode t)
  (add-hook 'math-edit-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'verilog-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'perl-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'tcl-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'c-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'postscript-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'c++-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'sh-mode-hook 'turn-on-flyspell-prog-mode t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-flyspell-prog-mode t))


(defvar p-flyspell-restricted-checking nil
  "If not nil, flyspell only checks spelling in comments and strings.")
(make-variable-buffer-local 'p-flyspell-restricted-checking)

(defadvice flyspell-get-word
  (after checkable first activate)
  "Return nil instead of word if checking restricted and not in comment or string.

Spell check is restricted if p-flyspell-restricted-checking non-nil.
Word considered to be in comment or string if face property is set
to font-lock-comment-face or font-lock-string-face."
  (setq ad-return-value
        (if (and p-flyspell-restricted-checking
                 ad-return-value
                 (not (member (get-text-property (car (cdr ad-return-value))
                                                 `face)
                              (list 'font-lock-comment-face
                                    'font-lock-string-face))))
            nil
          ad-return-value)))

(if (fboundp 'flyspell-prog-mode)
  (ad-deactivate 'flyspell-get-word));

;;; Calendar

(setq calendar-latitude 30.4
      calendar-longitude -91.2
      calendar-location-name "Baton Rouge, LA  U.S.A."
      mark-holidays-in-calendar t
      calendar-time-display-form
      '(24-hours ":" minutes (if time-zone " (") time-zone (if time-zone ")"))
      calendar-date-display-form
      '((if dayname (concat dayname ", ")) day " " monthname " " year))

(add-hook 'calendar-load-hooks 'p-calendar-prefs)
(add-hook 'calendar-after-frame-setup-hooks 'p-calendar-prefs)

(defun p-calendar-prefs () (interactive)
  (define-key calendar-mode-map [M-right] 'calendar-forward-month)
  (define-key calendar-mode-map [M-left] 'calendar-backward-month)
  (define-key calendar-mode-map [C-M-left] 'calendar-backward-year)
  (define-key calendar-mode-map [M-C-right] 'calendar-forward-year))
