Descripción General
El repositorio SAT-Linear-Solver implementa un algoritmo para resolver fórmulas lógicas bien formadas utilizando el algoritmo SAT (Satisfiability). Este tipo de algoritmos se utilizan para determinar si existe una asignación de variables que haga verdadera una fórmula lógica dada.
Es decir para poder identificar si una fórmula lógica es satisfacible. Esto significa que la fórmula, con cierta combinación de valores de verdad, afirmamos que la fórmula es verdadera.


-------------------------------------------------------------------
Sintaxis y Semántica
Para expresar las fórmulas lógicas en este programa, se debe seguir una sintaxis específica. Aquí se detallan las reglas:

Átomos: Los nombres de los átomos están restringidos a p, q, o r.

Acepta Operadores Lógicos:
¬ para la negación.
∧ para la conjunción.
∨ para la disyunción.
→ para la implicación.

Despues se hace la transformacion a una formula aceptada por la gramatica del SAT-Solver.
φ ::= p | (¬φ) | (φ ∧ φ)

Paréntesis: Se deben usar paréntesis para agrupar subfórmulas y definir el orden de evaluación.
(p ∧ ¬(q ∨ ¬p)) la transformamos a T(φ) = (p ∧ ¬¬(¬q ∧ ¬¬p))
-----------------------------------------
Limitaciones
Sintaxis: El programa no verifica si la sintaxis de las fórmulas es correcta. Es responsabilidad del usuario asegurarse de que las fórmulas estén bien formadas.

Uso de Paréntesis: Los usuarios deben usar paréntesis para evitar ambigüedades en la interpretación de las fórmulas.

-----------------------------------------
Ejemplo de uso del programa:
1. **Escribe tu fórmula lógica**

Supongamos que deseas evaluar la fórmula lógica:

(p ∧ ¬(q ∨ ¬p))

La fórmula debe transformarse a la sintaxis aceptada por el programa. Por ejemplo:

T(φ) = (p ∧ ¬(¬q ∧ ¬¬p))

---

2. **Ejecuta el programa**

a) Abre el archivo `main.rkt` en tu entorno de desarrollo.

b) Sustituye la fórmula en la definición de `my-formula` con tu fórmula transformada:

(define my-formula
  (l-and
    (l-prop 'p)
    (l-neg 
      (l-and
        (l-neg (l-prop 'q))
        (l-neg (l-neg (l-prop 'p)))))))

---

3. **Procesa la fórmula**

El programa realiza los siguientes pasos:

a) Construcción del DAG:
   La función `ast->dag` convierte tu fórmula lógica en un grafo dirigido acíclico (DAG) donde los nodos representan operadores lógicos o proposiciones, y las aristas reflejan relaciones entre ellos.

b) Impresión legible de la fórmula:
   Utiliza el módulo Pretty-Printer para generar una representación legible de la fórmula:

   (prettier my-formula)

   Salida esperada:
   (p ∧ ¬(¬q ∧ ¬¬p))

c) Evaluación Top-Down:
   La función `top-down-processing` evalúa la fórmula desde la raíz hasta las hojas, asignando valores booleanos a los nodos según las operaciones lógicas.

d) Verificación Bottom-Up:
   Con el DAG invertido (utilizando `invert-graph`), la función `bottom-up-processing` verifica que los valores asignados sean consistentes con las reglas lógicas.

---

4. **Interpreta los resultados**

Salida esperada: Una tabla hash (`ht`) que asigna un valor booleano a cada nodo, indicando si la fórmula es satisfacible.

Ejemplo de resultado:
'((p . #t) (q . #f) ...)

Esto indica que la fórmula es satisfacible con la asignación p = verdadero y q = falso.



--------------------------------------
DISTRIBUCIÓN DE TAREAS

TEORÍA Y CONTEXTO 
Georgina Salcido Valenzuela
Jorge Luna Munguia
Se enfocaron en plasmar la teoría y el contexto del problema en la libreta, además de poner diagramas y ejemplos para que pueda ser entendido de mejor manera.

INTERFAZ LENGUAJE
Ana Laura Chenoweth Galaz
Se enfocó en desarrollar la interfaz para nuestro lenguaje, el cual llamamos logical, y a su vez componentes como el arbol de sintaxis abstracta

IMPLEMENTAR ESTRUCTURAS
Denisse Antunez Lopez
Omar Pacheco
Nos hemos enfocado en implementar las estructuras necesarias del lenguaje para los entornos y los tipos de valores que contiene nuestro lenguaje.
Entornos, valores expresados, valores denotados

EVALUADOR E INTERPRETE Y COMPILADOR
Todos

FORMULA LOGICA A DAG(Arriba hacia abajo)
Omar Pacheco
ast->dag: Construcción de un DAG desde una fórmula lógica
Esta función toma como entrada una fórmula lógica y construye un DAG. Los nodos representan operadores lógicos (como AND o NOT) o proposiciones, y las aristas representan las relaciones entre ellos.

Uso de gensym:
Para garantizar nombres únicos en los nodos correspondientes a operadores compuestos (l-neg, l-and), se utiliza gensym, que genera símbolos únicos para evitar colisiones en los nombres de nodos dentro del grafo. Por ejemplo:

gensym 'neg produce un símbolo único para un operador de negación.
gensym 'and produce un símbolo único para un operador AND.

Funcionamiento:
Proposición (l-prop): Se agrega una arista entre el nodo actual y el símbolo de la proposición.
Negación (l-neg): Se crea un nuevo nodo para la negación y se conecta con el nodo previo. Luego, se aplica recursivamente a la subfórmula.
Conjunción (l-and): Similar a la negación, pero se crean aristas para las dos subfórmulas involucradas.


FUNCION DEL DAG INVERTIDA (Abajo hacia arriba)
Ana Laura Chenoweth Galaz
Toma un grafo dirigido representado de "arriba hacia abajo" (donde las aristas apuntan de padres a hijos) y genera su versión invertida, "de abajo hacia arriba". Esto se logra recorriendo el grafo original, invirtiendo las direcciones de las aristas, y construyendo un nuevo grafo donde cada nodo hijo apunta a su nodo padre.

Este proceso facilita análisis estructurales diferentes al invertir la perspectiva de las relaciones entre nodos, como en el caso de transformar la representación lógica de fórmulas proposicionales.

PRETTY-PRINTER
Denisse Antunez Lopez
Este módulo implementa una función para representar fórmulas lógicas proposicionales en un formato legible. Incluye:

prettier: Transforma estructuras internas de fórmulas lógicas en cadenas formateadas que reflejan su notación matemática habitual. Por ejemplo:
(l-prop 'p) → p
(l-neg (l-prop 'p)) → (¬p)
(l-and (l-prop 'p) (l-prop 'q)) → (p∧q)
Esto es útil para depurar, presentar resultados mas legibles

SATIS.RKT:
TODOS

Procesamiento de un DAG: Top-Down y Bottom-Up
1. top-down-processing: Evaluación descendente
	Propósito: Asignar valores booleanos a cada nodo desde la raíz hacia las hojas según las operaciones lógicas (and, 	neg, proposiciones).
Funcionamiento:
	Los valores se almacenan en una tabla hash (ht).
		and: Propaga el valor actual a los hijos.
		neg: Invierte el valor para el hijo.
Proposiciones: Reciben el valor actual.
Resultado: Una tabla hash con valores asignados.

2. bottom-up-processing: Verificación ascendente
	Propósito: Verificar que los valores asignados sean coherentes con las reglas lógicas, trabajando en el grafo 	invertido.
Funcionamiento:
	neg: Confirma que el valor de un nodo es la negación del valor del padre.
	and: Comprueba que todos los hijos satisfacen la condición lógica.
Condición de parada: Los nodos sin padres son válidos.

