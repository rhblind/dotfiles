(defun newline-without-break-of-line ()
  "1. move to end of the line.
     2. insert newline with index"
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent))
  )
(provide 'newline-without-break-of-line)
