#lang racket

(require graph
         "ast.rkt")

(define (invert-graph graph)
  (define g-reverse (directed-graph null)) ;; Grafo dirigido invertido

  ;; Función auxiliar para agregar los nodos inversos
  (define (add-inverted-edges! current-node)
    (define children (get-neighbors graph current-node))
    ;; Si no tiene vecinos, asegúrate de agregarlo al grafo invertido
    (if (null? children)
        (add-directed-edge! g-reverse 'root current-node) ;; Si no tiene hijos, agrega a root
        (for ([child children])
          (add-directed-edge! g-reverse child current-node)
          (add-inverted-edges! child))))
  ;; Comienza desde cada nodo raíz (sin padres)
  (let ([raiz (car (get-neighbors graph 'root))])
    (add-inverted-edges! raiz))

  g-reverse)

(define (ast->dag formula)
  (define g
    (directed-graph null))
  (define (formula->node formula graph [prev-node 'root])
    (match formula
      [(l-prop p)
       (add-directed-edge! graph prev-node p)]
      [(l-neg p)
       (let [(current (gensym 'neg))]
         (add-directed-edge! graph prev-node current)
         (formula->node p graph current))]
      [(l-and exp1 exp2)
       (let [(current (gensym 'and))]
         (add-directed-edge! graph prev-node current)
         (formula->node exp1 graph current)
         (formula->node exp2 graph current))]
      [else
        (error 'formula "Not a valid logic formula")]))
  (formula->node formula g)
  g)

(define myformula
  (l-and
   (l-prop 'p)
   (l-neg 
    (l-prop 'q))))

(define my-graph
  (ast->dag myformula))

(provide
  (contract-out
    [ast->dag (-> formula? graph?)]
    [invert-graph (-> graph? graph?)]))
