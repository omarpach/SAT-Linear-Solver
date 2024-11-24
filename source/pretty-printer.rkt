#lang racket

(require "ast.rkt")

(define f1
  (l-prop 'p))

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
