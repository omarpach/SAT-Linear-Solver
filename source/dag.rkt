#lang racket

(require graph
         "ast.rkt")

(define (has? list x)
  (cond
    [(null? list)
     #f]
    [(equal? (car list) x)
     #t]
    [else
      (has? (cdr list) x)]))

(define (ast->dag formula)
  (define g
    (directed-graph null))
  (define (formula->node formula graph [prev-node 'root])
    (match formula
      [(l-prop p)
       (add-directed-edge! graph prev-node p)]
      [(l-neg p)
       (let [(current (gensym 'neg))]
         (add-directed-edge! graph prev-node current)
         (formula->node p graph current))]
      [(l-and exp1 exp2)
       (let [(current (gensym 'and))]
         (add-directed-edge! graph prev-node current) 
         (formula->node exp1 graph current)
         (formula->node exp2 graph current))]
      [else
        (error 'formula "Not a valid logic formula")]))
  (formula->node formula g)
  g)

(define myformula
  (l-and
   (l-prop 'p)
   (l-neg 
    (l-prop 'q))))

(define my-graph
  (ast->dag myformula))

(provide
  (contract-out
    [has? (-> list? symbol? boolean?)]
    [ast->dag (-> formula? graph?)]))
