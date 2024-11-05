#lang racket

(require graph)

(define root
  'l-and)

(define my-graph
  (directed-graph '((l-and l-neg) (l-and p) (l-neg p))))

(define (is-satisfiable? dag [expected-val #t])
  #f)
