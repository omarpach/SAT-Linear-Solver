#lang racket

(require "ast.rkt")

(define (transform φ)
  (match φ
    [(l-prop _) φ]  ;; Una proposición atómica queda igual
    [(l-neg sub) (l-neg (transform sub))] ;; Negación
    [(l-and left right) (l-and (transform left) (transform right))] ;; Conjunción
    [(l-or left right) ;; T(φ1 ∨ φ2) = ¬(¬T(φ1) ∧ ¬T(φ2))
     (l-neg (l-and (l-neg (transform left)) (l-neg (transform right))))]
    [(l-impl left right) ;; T(φ1 → φ2) = ¬(T(φ1) ∧ ¬T(φ2))
     (l-neg (l-and (transform left) (l-neg (transform right))))]))


;; Construir la expresión p ∧ ¬(q ∨ ¬p)
;;∧ p ¬ ∨ q  ¬ p
(define expr
  (l-and
   (l-prop 'p)
   (l-neg
    (l-or
     (l-prop 'q)
     (l-neg (l-prop 'p))))))

;; Normalizar la expresión y mostrar el resultado p ∧ ¬¬(¬q ∧ ¬¬p)

expr
(transform expr)
