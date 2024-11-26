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
  ht)

(define (bottom-up-processing dag r-dag ht)
  (define (obtener-otro-hijo dag hijo padre)
    (let ([hijos (get-neighbors dag padre)])
      (if (eq? (first hijos)
               hijo)
        (second hijos)
        (first hijos))))
  (define (check-mark nodo-act)
    (define lst-padre
      (get-neighbors r-dag nodo-act))
    (cond
      [(null? lst-padre)
       #t]
      [else
        (define val-nodo-act
          (hash-ref ht nodo-act))
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
           (define val-otro-hijo
             (hash-ref ht (obtener-otro-hijo dag nodo-act nodo-padre)))
           (cond
             [(and val-nodo-act val-otro-hijo)
              (if (eq? val-nodo-padre #t)
                (check-mark nodo-padre)
                #f)]
             [(eq? val-nodo-act #f)
              (if (eq? val-nodo-padre #f)
                (check-mark nodo-padre)
                #f)]
             [(eq? val-otro-hijo #f)
              (if (eq? val-nodo-padre #f)
                (check-mark nodo-padre)
                #f)]
             [(and (eq? val-nodo-act #t)
                   (eq? val-nodo-padre #f))
              (if (eq? val-otro-hijo #f)
                (check-mark nodo-padre)
                #f)]
             [(and (eq? val-otro-hijo #t)
                   (eq? val-nodo-padre #f))
              (if (eq? val-nodo-act #f)
                (check-mark nodo-padre)
                #f)])])]))
  (define (aux-func lst-hijos)
    (if (null?)
      #t
      (and (check-mark (first lst-hijos))
           (aux-func (rest lst-hijos)))))
  (aux-func (get-neighbors r-dag 'root)))

(define (sat? formula)
  (define dag
    (ast->dag formula))
  (define constraints
    (top-down-processing dag))
  (define inverted-dag
    (invert-graph dag))
  (bottom-up-processing dag inverted-dag constraints))
