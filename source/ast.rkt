#lang racket

(struct formula () #:transparent)

(struct l-prop formula (name) #:transparent)         ;; p
(struct l-neg formula (subformula) #:transparent)    ;; ¬φ
(struct l-and formula (left right) #:transparent)    ;; φ ∧ φ
(struct l-or formula (left right) #:transparent)     ;; φ ∨ φ
(struct l-impl formula (left right) #:transparent) ;; φ → φ

(provide
 (contract-out
  [formula? (-> any/c boolean?)]
  [struct l-prop ([name symbol?])]
  [struct l-neg ([subformula formula?])]
  [struct l-and ([left formula?] [right formula?])]
  [struct l-or ([left formula?] [right formula?])]
  [struct l-impl ([left formula?] [right formula?])]))
