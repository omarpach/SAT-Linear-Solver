#lang racket

(struct expressed () #:transparent)
(struct bool-expressed expressed (val) #:transparent)

(define (expressed->bool val)
  (match val
    [(bool-expressed val) val]
    [else
     (error 'expressed->bool "Not a bool: ~a" val)]))

(provide
 (contract-out
  [expressed? (-> any/c boolean?)]
  [struct bool-expressed ([val boolean?])]
  [expressed->bool  (-> expressed? boolean?)]))
