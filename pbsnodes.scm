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

(define *node* '());

(define (set-current-node  line) 
	(if (node? line) 
		(begin (set! *node* line) (display *node*))
		'()))	
(define (get-pair line )	 
	(if (string-match "=" line) 
		(let ((pair-list  (string-split line #\=)))
			(cons (car pair-list) (car (cdr pair-list))))
		'()))
	
(define *node-list* (let ((node-table '()) (port (open-input-pipe "pbsnodes -av"))) 
			(op-by-line (lambda (x) (set! node-table (append node-table (cons x '())))) port ) node-table))




(define display-with-newline (lambda (x) 
		(display x) 
		(newline)))
;; (let ((port	(open-input-pipe "pbsnodes -av")) ) 
;; 	(op-by-line (lambda (x)
;; 			(if (node? x) 
;; 				(display x  )
;; 				(display (get-pair x)))
;; 				(newline))
;; 							  port)
;; 	;;(op-by-line display-with-newline port)
		
;; 	(close-pipe port)			
;; )




;; (define *node-table* (let ((node-table '()) (node-attr '()) (node '()) )
;; 	(map (lambda (x)  (display x)
;; 		(cond ((node? x) (set! node x)
;; 			((eq? x "") (set! node-table (assoc-set! node-table node node-attr)))	
;; 			(else (set! node-attr (append node-attr (cons (get-pair x) '())))))))  *node-list* ) node-table))
					


(display *node-list*)

