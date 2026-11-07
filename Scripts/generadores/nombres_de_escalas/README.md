# Generadores de nombres de escalas

Scripts que sembraron los ficheros de `Packages/Armonia/Sources/Teoria/Escalas/Nombres/`. Son de un solo uso
(los ficheros de idioma ya están escritos y se editan a mano); quedan aquí por si hay que añadir un idioma o
regenerar una familia de alias. Todos reciben la raíz del repositorio y reescriben ficheros: revisa el diff.

| Script | Qué hace |
|---|---|
| `lexico.py` | Palabras (modos, adjetivos) de los diez idiomas latinos, germánicos y vasco con que se componen los alias. |
| `generar.py` | Añade alias a las filas `.init(…)` sin alias de esos diez idiomas, componiéndolos con `lexico.py` y evitando choques. |
| `generar_rg.py` | Alias del ruso y del griego, escritos a mano por tipo; los suma a los que ya hay. |
| `tradicionales.py` | Añade a cada fichero de idioma las filas `.tradicional(…)` de las escalas de otras tradiciones. |
| `translit_trad.py` | Transcribe al ruso y al griego los nombres de esas tradicionales (no los mēḷa). Rellenaba las filas `.tradicional(.miembro)` sin traducción que escribía la primera versión de `tradicionales.py`; ya no se escriben (sin fila, la escala conserva su nombre), así que para volver a usarlo hay que añadir antes esas filas. |
| `quitar_alias_normalizados.py` | Quita de `alias:` las grafías que `aliasNormalizados` ya deduce (`aplicar` para escribir). |
| `separar_variantes.py` | Pasa de `alias:` a `variantes:` las otras grafías del nombre o de un alias anterior (femenino, transliteración, otra escritura), por parecido y con dos listas de excepciones (`aplicar` para escribir). Los scripts anteriores leen filas sin `variantes:`. |

Después de cualquiera: `python3 Scripts/comprobaciones/comprobar_catalogo.py` (cobertura y choques de alias) y los tests de
`NombresDeEscalasPorIdiomaTests`. Las traducciones no las ha revisado ningún hablante nativo.

Todos comparan nombres con `Scripts/comprobaciones/normalizar_escalas.py`, la copia en Python de `TipoDeEscala.normalizar`. Los casos
de `Scripts/datos/normalizar.tsv` los lee también `NormalizarVectoresTests` (Swift): para cambiar la normalización,
cambia las dos funciones y añade el caso al fichero. `python3 Scripts/comprobaciones/normalizar_escalas.py --comprobar` los pasa.
