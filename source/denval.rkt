#lang racket

(struct denoted () #:transparent)
(struct bool-denoted denoted (val) #:transparent)

(define (denoted->bool val)
  (match val
    [(bool-denoted val) val]
    [else
     (error 'denoted->bool "Not a bool: ~a" val)]))

(provide
 (contract-out
  [denoted? (-> any/c boolean?)]
  [struct bool-denoted ([val boolean?])]
  [denoted->bool  (-> denoted? boolean?)]))
