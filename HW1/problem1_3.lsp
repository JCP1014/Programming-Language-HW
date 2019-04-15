;;; Fibonacci function with original recursion and tail recursion

;; Original recursion
(DEFUN fib1 (n)
	(if (< n 2)	; termination condition
		n	; fib(0)=0, fib(1)=1
		(+ (fib1 (- n 1)) (fib1 (- n 2)))	; fib(n) = fib(n-1)+fib(n-2)
 	)
)

;; Tail recursion
(DEFUN tailFib (n a b)	
	(if (= n 0)
		(return-from tailFib a)
	)
	(if (= n 1)
		(return-from tailFib b)
	)
	(tailFib (- n 1) b (+ a b))	; Calculate fib(n-1) and fib(n-2) and pass down to next recursion
)
(DEFUN fib2 (n)
	(tailfib n 0 1)	; initial a=0,b=1
)


;; Use trace to show the execution details
(trace fib1)
(fib1 3)
(format t "----------------------------------~%")
(trace fib2)
(fib2 8)
