;;; Emacs initialization file for use in LSU EE 7700-X (Graphics Processors)

;; $Id:$

(when (< emacs-major-version 21)
  (error "Initialization file intended for Emacs 21.0 and higher"))

(defvar gpu-lisp-directory nil
  "Set to location of directory containing lisp code for LSU EE 7700-X.
If nil, assume ~/.emacs file is a simlink to lisp directory.")

(unless gpu-lisp-directory
  (setq gpu-lisp-directory
        (file-name-directory (file-truename "~/.emacs"))))

(unless (file-readable-p (concat gpu-lisp-directory "/gpu-settings.el"))
  (error "Could not find directory for EE 7700-X files. See ~/.emacs"))

(add-to-list 'load-path gpu-lisp-directory)
(require 'popular-settings)
(require 'gpu-settings)

(when (fboundp 'fancy-splash-screens) (fancy-splash-screens))
