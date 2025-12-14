#lang racket

(define a 10)
(define b (cons a '())) ;append a to empty list
(define c (cons b '(20 30 40))) ;append b to a defined list (which is quoted to prevent evaluation)

(define list_head (car c)) ;get the first element of a list
(define list_rest (cdr c)) ;get the last element of a list

(define empty_list '())
(define check_empty (null? empty_list)) ;null? checks if something is empty

(define built_list (list 'built 'from 'arguments)) ;list builds a list from provided arguments
