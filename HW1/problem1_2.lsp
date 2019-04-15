;;; Determine whether the list elements compose a palindrome
(DEFUN palindrome (l)
	;; If the reversed list is equal to the original list, it is a palindrome
	(if (equal (reverse l) l)
		(return-from palindrome T)
		(return-from palindrome nil)
	)
)

(format t "~a~&" (palindrome '(a b c)))
(format t "~a~&" (palindrome '(m a d a m)))
(format t "~a~&" (palindrome '(cat dog)))
(format t "~a~&" (palindrome '()))
(format t "~a~&" (palindrome '(cat dog bird bird dog cat)))
