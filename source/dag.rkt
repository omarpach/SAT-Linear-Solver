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

;; (define (ast->dag formula)
;;   (define g
;;     (directed-graph null))
;;   (define root
;;     'root)
;;   (define seen-props
;;     null)
;;   (define (formula->node formula graph prev-node)
;;     (match formula
;;       [(l-prop p)
;;        (if (has? seen-props p)
;;          (add-directed-edge! ))
;;        (add-directed-edge! g prev-node p)]
;;       [else
;;         (error "asdfasd")])))

(provide
  (contract-out
    [has? (-> list? symbol? boolean?)]))
    ;; [ast->dag (-> formula? graph?)]))
