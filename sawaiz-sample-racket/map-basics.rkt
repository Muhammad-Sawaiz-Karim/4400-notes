#lang racket

;map basically applies a function to all elements of a list or something.
(define (square x) (* x x))
(define (map my_func my_list) (if (null? my_list) my_list (cons (my_func (car my_list))
                                                  (map my_func (cdr my_list)))))