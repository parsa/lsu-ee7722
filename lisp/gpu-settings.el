;;; Emacs initialization file for use in LSU EE 7700-X (Graphics Processors)

;; $Id:$

(provide 'gpu-settings)

(when (< emacs-major-version 21)
  (error "Initialization file intended for Emacs 21.0 and higher"))

(eval-after-load "asm-mode" '(require 'asm-class "asm-class.el" t))
