#lang racket

(define (member x my_list) (cond [(null? my_list) #f]
                                  [(equal? x (car my_list)) #t]
                                  [else (member x (cdr my_list))]))