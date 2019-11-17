(defun newline-above()
  "Inserts a new line above the current line"
  (interactive)
  (let ((oldpos (point)))
    (beginning-of-line)
    (open-line 1)
    (indent-according-to-mode)))
(provide 'newline-above)
