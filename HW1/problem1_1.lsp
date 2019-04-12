(DEFUN prime (n)
	(if (<= n 1)
		(return-from prime nil)
 	)
 	(let ((i 2))
  		(loop
			(when (> (* i i) n) (return T))
   			(if (= (mod n i) 0)
    				(return  nil)
   			)
   			(setq i (+ i 1))
  		)
 	)
)