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
(define and-1
  (gensym 'and))

(define not-1
  (gensym 'not))

(add-directed-edge! g 'root and-1)

(add-directed-edge! g and-1 'p)

(add-directed-edge! g and-1 not-1)

(add-directed-edge! g not-1 'q)
