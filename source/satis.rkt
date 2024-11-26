#lang racket

(require graph
         "ast.rkt"
         "dag.rkt")

(define ejemplote-enorme
  (l-and (l-prop 'p)
         (l-neg
          (l-neg
           (l-and (l-neg
                   (l-prop 'q))
                  (l-neg
                   (l-neg
                    (l-prop 'p))))))))

(define (top-down-processing dag)
  (define ht
    (make-hash))
  (define (assign-mark ht nodo [past-val #t])
    (match (symbol->string nodo)
      [(regexp #rx"and*")
       (hash-set! ht nodo past-val)
       (for ([hijo (get-neighbors dag nodo)])
         (assign-mark ht hijo past-val))]
      [(regexp #rx"neg*")
       (hash-set! ht nodo past-val)
       (let ([hijo (car (get-neighbors dag nodo))])
         (assign-mark ht hijo (not past-val)))]
      [prop
        (hash-set! ht nodo past-val)]))
  (define root
    (car (get-neighbors dag 'root)))
  (assign-mark ht root)
  (define (check-marks ht nodo))
  ht)

(define (bottom-up-processing r-dag ht)
  (define (check-mark nodo-act)
    (define lst-padre
      (get-neighbors r-dag nodo-act))
    (cond
      [(null? lst-padre)
       #t]
      [else
        (define val-nodo-act
          hash-ref ht nodo-act)
        (define nodo-padre
          (car (lst-padre)))
        (define val-nodo-padre
          (hash-ref ht nodo-padre))
        (match (symbol->string nodo-padre)
          [(regexp #rx"neg*")
           (if (eq? val-nodo-act
                    (not val-nodo-padre))
             (check-mark nodo-padre)
             #f)]
          [(regexp #rx"and*")
           (define otro-hijo
             )])])))
