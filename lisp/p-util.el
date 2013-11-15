
(provide 'p-util)

(defun p-first-member (need list)
  "Return first element of list NEED that's in LIST or nil."
  (let ((rv nil))
    (dolist (elt need)
      (if (and (not rv) (member elt list)) (setq rv elt)))
    rv))

(defun p-font-family-list ()
  "Return font families as a list of strings."
  (mapcar (lambda (elt) (if (stringp elt) elt (format "%s" elt)))
          (font-family-list)))
