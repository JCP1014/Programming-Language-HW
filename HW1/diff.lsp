;;; Implement "diff" command
;;; Output the result like "$ diff file1.txt file2.txt"

;; Read the content of the file line-by-line into a list
(DEFUN read_file (fileName)
	; fin = input file stream, file_content = an empty list for storing the content of file 
	(let ( (fin (open fileName :if-does-not-exist nil)) (file_content nil))	; If file does not exist, simply returns nil to indicate error. 
		(when fin
			(loop for line = (read-line fin nil)	; Read the file line-by-line until EOF
				while line
					do (push line file_content)	; Push the line in to the list
			)
			(setq file_content (reverse file_content))	; Reverse the list to reset the order of lines is same as the original file
			(close fin)	; Close the file stream
			(return-from read_file file_content)	; return the list
		)	
	)
)
;; Find the longest common subsequence between two lists
(DEFUN find_lcs (l1 l2)
	(let ( (m (length l1)) (n (length l2)) ) ; m = length of l1, n = length of l2
		(let ((table (make-array (list (+ m 1) (+ n 1) 2) :initial-element 0)))	; create a (m+1)*(n+1)*2 table to record the length of LCS and the direction
			;; Fill the table
			(loop for i from 0 to (- m 1) do
				(loop for j from 0 to (- n 1) do
				 (if (equal (nth i l1) (nth j l2))
				 		; If same element is found
						(progn
							(setf (aref table (+ i 1) (+ j 1) 0) (+ (aref table i j 0) 1))	; Increase length of LCS
						 	(setf (aref table (+ i 1) (+ j 1) 1) 'v)	; Mark this position is a common element
						)
						; If the two elements are different
						(progn
							(setf (aref table (+ i 1) (+ j 1) 0) (max (aref table i (+ j 1) 0) (aref table (+ i 1) j 0)))	; length of LCS doesn't increase
							(if (>= (aref table (+ i 1) j 0) (aref table i (+ j 1) 0) )	
								(setf (aref table (+ i 1) (+ j 1) 1) 'l)	; Mark the direction pointing to position of LCS
						 		(setf (aref table (+ i 1) (+ j 1) 1) 'u)
							)
						)
					)
				)
			)
	
			;; Get LCS from the table, and record the position of LCS
			(let ( (LCS (make-array (list 3 (aref table m n 0)):initial-element 0)) (i m) (j n) (k (- (aref table m n 0) 1)) )	; Create a 3*(length) matrix to store indices of common elements in two list
				(loop 
					(cond	( (equal (aref table i j 1) 'v)	(progn	
											(setf (aref LCS 0 k) (nth (- i 1) l1))	; Record the element of LCS
											(setf (aref LCS 1 k) (- i 1))	; Record the index of common element in l1
											(setf (aref LCS 2 k) (- j 1))	; Pecord the index of common element in l2
											; Go up and left
											(setq k (- k 1))	
											(setq i (- i 1))
											(setq j (- j 1))
										)
						)
						( (equal (aref table i j 1) 'u)	(setq i (- i 1)) )	; Go up
						( (equal (aref table i j 1) 'l)	(setq j (- j 1)) )	; Go left
					)
					(when (equal (aref table i j 1) 0) (return))	; Until reach the empty position
				)
				
				(return-from find_lcs LCS)	; Return the matrix
				
			)
		
		)
	)
	
)
; Visit the list and print whether a line of content is common, additional, or removed 
(DEFUN look_list (LCS _list row col pos)	; row & col are row and column in LCS matrix, pos is the index in _list
	(loop
		(if (>= col (array-dimension LCS 1))	; If common elements are all printed
			(when (>= pos (length _list)) (return))	; Return when the rest of elements are all printed as well
			(when (equal pos (aref LCS row col))
				(cond 	( (= row 1)	(return) )	; If reach index of LCS in l1, return
					( (= row 2)	(progn		; If reach index of LCS in l2, print the common element and then return
								(format t "~c[97m ~a~&~c[0m" #\ESC (nth pos _list) #\ESC)
								(return)
							)
					)
				)		
			)

		)
		
		(cond	( (= row 1) (format t "~c[31m-~a~&~c[0m" #\ESC (nth pos _list) #\ESC) )	; If list1, print "-", [31m for red
			( (= row 2) (format t "~c[32m+~a~&~c[0m" #\ESC (nth pos _list) #\ESC) )	; If list2, print "+", [32m for green
		)
		(setq pos (+ pos 1))	; Check next index
	)
	(return-from look_list pos)	; Return at which index it stops
	
)
; Continuously visit l1 and l2 alternately until printing all contents of two lists
(DEFUN printDiff (LCS l1 l2)
	(let ( (i 0) (j 0) (p1 0) (p2 0) )	; i=column number in LCS(1), j=column number in LCS(2), p1=index in l1, p2=index in l2
		(loop
			(setq p1 (+ (look_list LCS l1 1 i p1) 1))	; Visit l1 until reach an index of LCS, and update index number
			(setq i (+ i 1))	; Update column number
			(setq p2 (+ (look_list LCS l2 2 j p2) 1))	; Visit l2 until reach an index of LCS, and update index number
			(setq j (+ j 1))
			(when (>= p2 (length l2)) (return))	; loop until reaching the end of l2
		)
	)	
)

; Main
(defvar file1 (read_file "file1.txt"))
(defvar file2 (read_file "file2.txt"))
(printDiff (find_lcs file1 file2) file1 file2)
