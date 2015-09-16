#!/usr/bin/guile -s 
!# 


(use-modules (ice-9 popen))
(use-modules (ice-9 regex))
(use-modules (ice-9 rdelim))

(define nil '())
(define (get-line-op op port) 
  (let ((str (read-line port))) 
    (if (eof-object? str) 
	'() 
	(begin (op str) 
	       (get-line-op op port)))))


(define (run-cmd  str op) 
  (let ((port (open-input-pipe str))) 
    (get-line-op  op port)))


(define (node? str) 
  (string-match "^[A-Za-z]" str))


(define (node-attributes? str) 
  (string-match "=" str))

(define (node-attributes str) 
  (if (node-attributes? str) 
      (let ((line-list (string-split str #\=))) 
	(cons (strip-space (car line-list)) (strip-space (car (cdr line-list)))))
      (display 2)))

;(define (strip-space str)
;  (regexp-substitute/global #f (string-match "(^ +)\\|( +$)" str ) 'pre "" 'post))


(define (strip-left-space str) 
	(let ((obj (string-match "^\\s+" str ))) 
		(if obj	
		  (regexp-substitute #f obj 'pre "" 'post)
			str)))

(define (strip-right-space str) 
	(let ((obj (string-match "\\s+$" str ))) 
		(if obj	
		  (regexp-substitute #f obj 'pre "" 'post)
			str)))







(define (strip-space str) 
	(strip-left-space (strip-right-space str)))
(define *line-list* 
	(let ((line-list '()))
			(run-cmd "pbsnodes -av" (lambda (x) (set! line-list (append line-list (cons x nil))))) line-list))



(define (display-line  str) 
	(if (node? str) 
		(display str ) 
		(display (node-attributes str)) ) (newline))
;(map  display-line *line-list*)


(define (get-tail list) 
	(if (eq? (cdr list) '()) 
		(car list)
		(get-tail (cdr list))))


 
(define *node-table* (let ((node-table '()) (node-attr '()) (node '() ) (blankline (get-tail *line-list*)))
	(map (lambda (x) 
		(cond ((node? x) (begin (set! node x) (set! node-attr '())))
			((equal? blankline x) (set! node-table (assoc-set! node-table node node-attr)))
			(#t (let ((pair (node-attributes x))) 
				 (set! node-attr (assoc-set! node-attr  (car pair) (cdr pair)))))))
				*line-list*) node-table) )
	

(define  (make-query double-table) 
	(lambda (key1 key2) 
		(get-key double-table key1 key2)))
(define (get-key double-table key1 key2) 
	(assoc-ref (assoc-ref *node-table* key1) key2))
(define *q1* (make-query *node-table*))



(define (get-key-list alist) 
	(let ((key-list '()))
	(map (lambda (x)	
		(set! key-list (append key-list (cons (car x) '())))) alist) key-list))



(define ref-list (list "Mom" "resources_available.platform" "resources_available.pas_applications_enabled" "state" "resources_available.mem" "resources_available.mem_usage" "resources_available.disk_usage" "resources_available.cpu_usage" "resources_available.ncpus" "resources_assigned.ncpus" "jobs"))


(define safe-display  
	(lambda (x) 
		(if x
			(display x) 
			'())))	

(map (lambda (x) 
	(newline)
	(display x)
	(display ";") 
	(map (lambda (y) 
		(safe-display (*q1* x y))
		(display ";")) ref-list)) (get-key-list *node-table*))

(newline)



