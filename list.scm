#!/usr/bin/guile -s 
!# 


(define (my-map op var-list) 
	(let ((r-list '())) 
		(if (eq? (cdr var-list) '()) 
			r-list
			(begin (set! r-list (append r-list (cons (op (car var-list) '())))) 
				(my-map op (cdr var-list))
				r-list))))
