#lang racket

(require graph
         "ast.rkt"
         "dag.rkt")

(define my-list
  (list 'x 'y 'z))

(has? my-list 'x)

(define g
  (unweighted-graph/directed '()))

;; Representamos (and p (not q))
(
