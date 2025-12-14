#lang racket

(define my_if (if (< 5 6) "blue" "red")) ;if <cond> then <exp1> else <exp2>
(define my_else (if (< 6 5) "blue" "red")) ;here it will give <exp2> as first thing evaluates to false
(define my_true (if '(1 2 3) "blue" "red")) ;anything other than #f will evaluate as true
(define my_lazy (if (= 3 3) "blue" (2))) ;Racket does lazy evaluation (also known as NOR) but (2) will throw an error if evaluated

(define n "blue")
(define (my_cond color) (cond [(equal? color "blue") "favourite color!"] ;switch statement pretty much
                      [(equal? color "black") "second favourite color!"]
                      [else "a color!"])) ;else statement MUST be the last one