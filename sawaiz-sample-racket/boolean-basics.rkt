#lang racket

;#t is true, #f is false

(define less_than (< 5 10)) ;boolean operators work as such
(define more_eq_than (>= 3 4))
(define num_equal (= 4 4))
(define bool_or (or #t #f))
(define bool_and (and #t #f))
(define bool_not (not bool_and))
(define string_equal (equal? "hello" "hello")) ;As = does not work for strings
(define list_equal (equal? '(1 2 3) (list '"1" '"2" '"3"))) ;or lists
(define list_eq (eq? '(a) '(a))) ;checks MEMORY equality
(define num_eq (eq? 1 1))