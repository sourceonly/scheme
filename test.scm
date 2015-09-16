
(let ((a 0))
(map (lambda (x) 
	(display a) 
	(newline)
	(cond ((eq? x 3) (begin (set! a 5) )))) '(1 2 3 4 5)))
