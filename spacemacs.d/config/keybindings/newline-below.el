(defun newline-below ()
  "Insert an empty line below the current line."
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))
(provide 'newline-below)
