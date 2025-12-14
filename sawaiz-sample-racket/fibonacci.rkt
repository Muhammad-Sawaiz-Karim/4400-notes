#lang racket

(define (fibonacci num) (if (or (= num 0) (= num 1))
                            num
                         (+ (fibonacci(- num 1)) (fibonacci(- num 2)))))