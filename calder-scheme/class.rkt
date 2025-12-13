#!/usr/bin/racket ; Don't worry about this boilerplate, it's just to make the file executable
#lang racket


; Everything she taught us about Racket in class
; Comments in Racket start with a semicolon (;)
; Racket is a LISP dialect used in COMP-4400 to show off functional programming concepts
; In Racket, everything is an expression that evaluates to a value
; Values are immutable, meaning once defined, they cannot be changed
; There are no statements, only expressions
; There are no loops; instead, recursion is used for iteration
; Functions are first-class, meaning they can be passed as arguments, returned from other functions
; Racket uses lazy evaluation, meaning expressions are not evaluated until their values are needed (she calls this NOR "Normal Order Reduction")
; It's a cool language for learning functional programming!

(define a 10) ; Define an identifier 'a' with value 10. Primitives like 10 are called "atoms" in Racket

; Define a function 'add' that takes two parameters 'x' and 'y' and returns their sum
(define (add x y)
  (+ x y) ; Racket uses prefix notation for function calls, so the operator comes before the list of operands
)

(define result (add a 5)) ; Call the 'add' function with arguments 'a' and 5, store the result in 'result'

; Racket has a all the basic operators you'd expect
(+ 1 2)    ; Addition, results in 3
(- 5 3)    ; Subtraction, results in 2
(* 4 2)    ; Multiplication, results in 8
(/ 8 2)    ; Division, results in 4
(= 3 3)    ; Equality check, results in #t (true)
(< 2 3)    ; Less than check, results in #t (true)
(> 3 2)    ; Greater than check, results in #t (true
(not #t)  ; Logical NOT, results in #f (false
(and #t #f) ; Logical AND, results in #f (false)
(or #t #f)  ; Logical OR, results in #t (true)
(eq? 'a 'a) ; Identity check, results in #t (true) checks if they refer to the same object in memory
(equal? '(1 2) '(1 2)) ; Structural equality check, results in #t (true) checks if they have the same structure and content

; Everything in Racket is a list, which is denoted by parentheses and evaluated from left to right
; If you want to pause evaluation (ie. create a literal list that doesn't collapse), use the quote operator (')
(define my-list '(1 2 3 4 5)) ; Define a list of numbers from 1 to 5

; Given the clear importance of lists, Racket has a number of list manipulation functions
(cons 0 my-list) ; 'cons' adds an element to the front of a list, resulting in '(0 1 2 3 4 5) (cons means "construct")
(car my-list)    ; 'car' retrieves the first element of a list, resulting in 1 (think of it like "head" in prolog)
(cdr my-list)    ; 'cdr' retrieves the rest of the list after the first element, resulting in '(2 3 4 5) (think of it like "tail" in prolog)
(null? my-list)  ; 'null?' checks if a list is empty, resulting in #f (false) since 'my-list' is not empty
(list '6 '7 '8) ; 'list' creates a new list from the given elements, resulting in '(6 7 8)

; Conditional expressions in Racket use 'if' and 'cond'
(if (> a 5) ; In if, everything that doesn't explicitly evaluate to #f is considered true
    'greater-than-5 ; If 'a' is greater than 5, return 'greater-than-5
    'not-greater-than-5) ; Otherwise, return 'not-greater-than-5

(cond ; 'cond' allows for multiple branches, like a switch statement
  [(< a 5) 'less-than-5] ; If 'a' is less than 5, return 'less-than-5
  [(= a 5) 'equal-to-5]  ; If 'a' is equal to 5, return 'equal-to-5
  [else 'greater-than-5]) ; Otherwise, return 'greater-than-5

; Racket uses recursion for iteration since there are no loops
(define (factorial n)
  (if (= n 0) ; Base case: if 'n' is 0
      1 ; Return 1
      (* n (factorial (- n 1))))) ; Recursive case: n * factorial

(factorial 5) ; Call the 'factorial' function with argument 5, resulting in 120

; Another example, check membership in a list
(define (member? x lst)
  (cond
  ((null? lst) #f)
  ((equal? x (car lst)) #t)
  (else (member? x (cdr lst)))))

(member? 3 my-list) ; Check if 3 is in 'my-list', resulting in #t (true)

; Racket uses higher-order functions, meaning functions can take other functions as arguments or return them
; A good example is the 'map' function, which applies a given function element by element to a list, returning a new list with each result
(define (map F Lst)
  (if (null? Lst) ; Base case: if the list is empty, return an empty list
    Lst
  (cons (F (car Lst)) ; Otherwise, apply F to the first element of the list and cons it with the result of mapping F over the rest of the list
    (map F (cdr Lst)))))

(map (lambda (x) (* x 2)) my-list) ; Double each element in 'my-list', resulting in '(2 4 6 8 10)

; Another example is the 'reduce' function, which combines elements of a list using a binary function. This example is reduction from the right (function is applied to the rightmost element first)
(define (reduceright F init L)
  (if (null? L) ; Base case: if the list is empty, return the initial value
    init
  (F (car L) (reduceright F init (cdr L))))) ; Otherwise, apply F to the first element and the result of reducing the rest of the list

; She also showed us reduce-left (function is applied to the leftmost element first)
(define (reduceleft F init L)
  (if (null? L) ; ; Base case: if the list is empty, return the initial value
    init
  (reduceleft F (F init (car L)) (cdr L)))) ; Otherwise, apply F to the initial value and the first element, then reduce the rest of the list 

(reduceleft (lambda (x y) (+ x y)) 0 my-list) ; Sum all elements in 'my-list', resulting in 15. Order of application is (((((0 + 1) + 2) + 3) + 4) + 5)
(reduceright (lambda (x y) (+ x y)) 0 my-list) ; ; Sum all elements in 'my-list', resulting in 15 also. if the function is non-associative, the results may differ. Order of application is (1 + (2 + (3 + (4 + (5 + 0)))))

; Racket also supports anonymous functions (lambdas)
((lambda (x) (* x x)) 5) ; Define and immediately call an anonymous function that squares its input, resulting in 25

; She does an example using lambdas to create function composition
(define (compose f g) ; Take 2 functions f and g as parameters
  (lambda (x) (f (g x)))) ; Return a new function (an anonymous lambda) that applies g to x, then f to the result