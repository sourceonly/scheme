#!/usr/bin/guile -s \
!#

(use-modules (ice-9 popen)) 
(use-modules (ice-9 rdelim))
(use-modules (ice-9 regex)) 




(define (get-line op port) 
	(let ((x (read-line port))) 
		(if (eof-object? x)
			'() 
			(begin (op x) (get-line op port)	
				))))
				



(define a (open-input-pipe "pbsnodes -av"))


(get-line (lambda (x) 
		(display x) 
		(newline)) a) 
