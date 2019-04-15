;;; Determine whether the number is a prime number
(DEFUN prime (n)
	;; If n<=1, definitely not a prime number
	(if (<= n 1)
		(return-from prime nil)
 	)
	;; If n>=2, check divisors from 2 to sqrt(n)
 	(let ((i 2))
  		(loop
			(when (> (* i i) n) (return T))	; loop until i>sqrt(n)
   			(if (= (mod n i) 0)	; found its factor, so it is not a prime number
    				(return  nil)
   			)
   			(setq i (+ i 1))	; check next divisor
  		)
 	)
)

(format t "~a~&" (prime 2))
(format t "~a~&" (prime 239))
(format t "~a~&" (prime 999))
(format t "~a~&" (prime 17))
