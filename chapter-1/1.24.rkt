#lang racket
(define (expmod base exp m)
  (cond [(= exp 0) 1]
        [(even? exp)
         (remainder
          (square (expmod base (/ exp 2) m))
          m)]
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))

(define (square x)
  (* x x))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond [(= times 0) #t]
        [(fermat-test n) (fast-prime? n (- times 1))]
        [else
         #f]))

(define (timed-prime-test n)
  (time (fast-prime? n 10)))

(timed-prime-test 1000000211)
        
 
        