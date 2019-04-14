(DEFUN read_file (fileName)
	(let ( (fin (open fileName :if-does-not-exist nil)) (file_content nil))
		(when fin
			(loop for line = (read-line fin nil)
				while line
					do (push line file_content)
			)
			(setq file_content (reverse file_content))
			(close fin)
			(return-from read_file file_content)
		)	
	)
)

(DEFUN find_lcs (l1 l2)
	(let ( (m (length l1)) (n (length l2)) ) 
		(let ((table (make-array (list (+ m 1) (+ n 1) 2) :initial-element 0)))
			;; Fill the table
			(loop for i from 0 to (- m 1) do
				(loop for j from 0 to (- n 1) do
				 (if (equal (nth i l1) (nth j l2))
						(progn
							(setf (aref table (+ i 1) (+ j 1) 0) (+ (aref table i j 0) 1))
						 	(setf (aref table (+ i 1) (+ j 1) 1) 'v)
						)
						(progn
							(setf (aref table (+ i 1) (+ j 1) 0) (max (aref table i (+ j 1) 0) (aref table (+ i 1) j 0)))
						 	(if (>= (aref table (+ i 1) j 0) (aref table i (+ j 1) 0) )
								(setf (aref table (+ i 1) (+ j 1) 1) 'l)
						 		(setf (aref table (+ i 1) (+ j 1) 1) 'u)
							)
						)
					)
				)
			)

			
			;; Get LCS from the table
			(let ( (LCS (make-array (list 3 (aref table m n 0)):initial-element 0)) (i m) (j n) (k (- (aref table m n 0) 1)) )
				(loop 
					(cond	( (equal (aref table i j 1) 'v)	(progn	
											(setf (aref LCS 0 k) (nth (- i 1) l1))
											(setf (aref LCS 1 k) (- i 1))
											(setf (aref LCS 2 k) (- j 1))
											(setq k (- k 1))
											(setq i (- i 1))
											(setq j (- j 1))
										)
						)
						( (equal (aref table i j 1) 'u)	(setq i (- i 1)) )
						( (equal (aref table i j 1) 'l)	(setq j (- j 1)) )
					)
					(when (equal (aref table i j 1) 0) (return))
				)
				
				(return-from find_lcs LCS)
				
			)
		
		)
	)
	
)

(DEFUN look_list (LCS _list row col pos)
	(loop
		(if (>= col (array-dimension LCS 1))
			(when (>= pos (length _list)) (return))
			(when (equal pos (aref LCS row col))
				(cond 	( (= row 1)	(return) )
					( (= row 2)	(progn
								(format t "~c[97m ~a~&~c[0m" #\ESC (nth pos _list) #\ESC)
								(return)
							)
					)
				)		
			)

		)
		
		(cond	( (= row 1) (format t "~c[31m-~a~&~c[0m" #\ESC (nth pos _list) #\ESC) )
			( (= row 2) (format t "~c[32m+~a~&~c[0m" #\ESC (nth pos _list) #\ESC) )
		)
		(setq pos (+ pos 1))
	)
	(return-from look_list pos)
	
)
(DEFUN printDiff (LCS l1 l2)
	(let ( (i 0) (j 0) (p1 0) (p2 0) )
		(loop
			(setq p1 (+ (look_list LCS l1 1 i p1) 1))
			(setq i (+ i 1))
			(setq p2 (+ (look_list LCS l2 2 j p2) 1))
			(setq j (+ j 1))
			(when (>= p2 (length l2)) (return))
		)
	)	
)

;(defvar l1 '(A B C A B C B A))
;(defvar l2 '(C B A B C A B C C))
;(printDiff (find_lcs l1 l2) l1 l2)

(defvar file1 (read_file "file1.txt"))
(defvar file2 (read_file "file2.txt"))
(printDiff (find_lcs file1 file2) file1 file2)
