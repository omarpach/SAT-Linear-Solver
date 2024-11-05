#lang racket

(require "denval.rkt")

(struct environment () #:transparent)

(struct empty-env environment () #:transparent)
(struct extend-env environment (var val parent) #:transparent)

(define (apply-env env var)
  (match env
    [(empty-env)
     (error "Empty-env reached")]
    [(extend-env (== var) val parent)
     (bool-denoted val)]
    [(extend-env bar val parent)
     (apply-env parent var)]
    [else
      (error 'apply-env "Proposition not defined in environment")]))

(provide
  (contract-out
    [environment? (-> any/c boolean?)]
    [struct empty-env ()]
    [struct extend-env ([var symbol?] [val boolean?] [parent environment?])]
    [apply-env (-> environment? symbol? denoted?)]))
