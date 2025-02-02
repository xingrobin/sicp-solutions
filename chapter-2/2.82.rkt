#lang racket
(define (apply-generic op . args)
  (define (coerce-list lst type)
    (if (null? lst)
        '()
        (let ((item (car lst))
              (item-type (type-tag (car lst))))
          (if (eq? type item-type)
              (cons item (coerce-list (cdr lst)))
              (let ((item-type->type (get-coercion item-type type)))
                (if (item-type->type)
                    (cons (item-type->type item) (coerce-list (cdr lst) type))
                    #f))))))
  
  (let ((type-tags (map type-tag args)))
    (define (iter tags)
      (if (null? tags)
          (error "BAD TYPES: NO COERCION APPLIED")
          (let ((type (car tags)))
            (if (coerce-list lst type)
                (let ((proc (get op type)))
                  (if proc
                      (apply proc (map content args))
                      (iter (cdr tags))))
                (iter (cdr tags))))))
    (iter type-tags)))