(DEFUN palindrome (l)
	(if (equal (reverse l) l)
		(return-from palindrome T)
		(return-from palindrome nil)
	)
)
