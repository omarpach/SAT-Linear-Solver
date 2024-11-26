#lang racket

(require "ast.rkt")

(define f1
  (l-prop 'p))

(define f2
  (l-neg (l-and (l-prop 'p)
                (l-prop 'q))))

(define (prettier formula)
  (match formula
    [(l-prop p)
     (printf "~a" p)]
    [(l-neg p)
     (printf "(¬")
     (prettier p)
     (printf ")")]
    [(l-and left right)
     (printf "(")
     (prettier left)
     (printf "∧")
     (prettier right)
     (printf ")")]))

(provide
  (contract-out
    [prettier (-> formula? void?)]))
