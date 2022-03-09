#|
Actividad 2.1 Programación funcional, parte 1
Salvador Salgado Normandia A01422874
Luis Javier Karam A01751941
|#

#lang racket

(define (len-tail lst)
  "Length with tail recursion"
  (let loop
    ([lst lst][result 0])
    (if (empty? lst)
        result
        (loop(cdr lst)(+ 1 result)))))


;15. Func Dot Product (recibe dos listas) Checar listas vacias
(provide dot-product)
(define (dot-product l1 l2)
  (let loop
    ([lst l1][lst2 l2][result 0])
    (if (or (empty? lst)(empty? lst2))
        result
        (loop (cdr lst) (cdr lst2) (+ (* (car lst) (car lst2)) result)))))

;16. Average Function
(provide average)
(define (average lst)
  (define n (len-tail lst))
  (if (empty? lst)
      0
  (let loop 
    ([lst lst][sum 0])
    (if (empty? lst)
        (exact->inexact (/ sum n))
        (loop  (cdr lst) (+ (car lst) sum))))))

;17. Func Standar Deviation
(provide standard-deviation)
(define (standard-deviation lst)
  (define n (len-tail lst))
  (define avg (average lst))
  (if (empty? lst)
      0
  (let loop
    ([lst lst][sum_in 0])
    (if (empty? lst)
        (exact->inexact (sqrt (/ sum_in n)))
        (loop (cdr lst) (+ (expt (- (car lst) avg) 2) sum_in))))))


;20. Func Binary
(provide binary)
(define (binary num)
  (let loop
    ([num num][b_list '()])
    (if (zero? num)
        b_list
     (loop (quotient num 2) (cons (remainder num 2) b_list)))))
        
