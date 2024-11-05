#lang racket

(require "ast.rkt"
         "env.rkt"
         "denval.rkt"
         "expval.rkt")

(define (value-of formula env)
  (match formula
    [(l-prop p)
     (bool-expressed
       (denoted->bool
         (apply-env env p)))]
    [(l-neg p)
     (bool-expressed
       (not (expressed->bool
              (value-of p env))))]
    [(l-and left right)
       (bool-expressed
         (and (expressed->bool (value-of left env))
            (expressed->bool (value-of right env))))]
    [(l-or left right)
       (bool-expressed
         (or (expressed->bool (value-of left env))
            (expressed->bool (value-of right env))))]
    [(l-impl left right)
       (bool-expressed
         (implies (expressed->bool (value-of left env))
                  (expressed->bool (value-of right env))))]))

(define mi-entorno
  (extend-env 'p #t
              (extend-env 'q #f
                          (empty-env))))

(define tautologia
  (l-and (l-neg (l-prop 'q)) (l-prop 'q)))

(provide
  (contract-out
    [value-of (-> formula? environment? expressed?)]))
