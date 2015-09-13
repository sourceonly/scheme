#!/usr/bin/guile -s 
!#

(use-modules (ice-9 popen))
(use-modules (ice-9 rdelim))
(use-modules (ice-9 regex))
(define read-line-port  (lambda (port) (let ((x port)) (read-line x))))
(define (op-by-line  op port ) (let ((x (read-line-port port)))
					(if (eof-object? x)  
						(+ 1 1)
						((lambda (z) (op x) (op-by-line op port) ) x ) )))


(define (node? x)  
		(string-match "^[A-Za-z0-9]" x))



		
	
		




(define display-with-newline (lambda (x) 
		(display x) 
		(newline)))
(let ((port	(open-input-pipe "pbsnodes -av")) )
	(op-by-line print-node port)
	;;(op-by-line display-with-newline port)
		
	(close-pipe port)			
)
