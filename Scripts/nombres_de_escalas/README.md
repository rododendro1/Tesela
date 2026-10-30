# Generadores de nombres de escalas

Scripts que sembraron los ficheros de `Packages/Armonia/Sources/ArmoniaTeoria/Escalas/Nombres/`. Son de un solo uso
(los ficheros de idioma ya están escritos y se editan a mano); quedan aquí por si hay que añadir un idioma o
regenerar una familia de alias. Todos reciben la raíz del repositorio y reescriben ficheros: revisa el diff.

| Script | Qué hace |
|---|---|
| `lexico.py` | Palabras (modos, adjetivos) de los diez idiomas latinos, germánicos y vasco con que se componen los alias. |
| `generar.py` | Añade alias a las filas `.init(…)` sin alias de esos diez idiomas, componiéndolos con `lexico.py` y evitando choques. |
| `generar_rg.py` | Alias del ruso y del griego, escritos a mano por tipo; los suma a los que ya hay. |
| `tradicionales.py` | Añade a cada fichero de idioma las filas `.tradicional(…)` de las escalas de otras tradiciones. |
| `translit_trad.py` | Transcribe al ruso y al griego los nombres de esas tradicionales (no los melakarta). |
| `quitar_alias_normalizados.py` | Quita de `alias:` las grafías que `aliasNormalizados` ya deduce (`aplicar` para escribir). |

Después de cualquiera: `python3 Scripts/comprobar_catalogo.py` (cobertura y choques de alias) y los tests de
`NombresDeEscalasPorIdiomaTests`. Las traducciones no las ha revisado ningún hablante nativo.

Todos comparan nombres con `Scripts/normalizar_escalas.py`, la copia en Python de `TipoDeEscala.normalizar`. Los casos
de `Scripts/vectores/normalizar.tsv` los lee también `NormalizarVectoresTests` (Swift): para cambiar la normalización,
cambia las dos funciones y añade el caso al fichero. `python3 Scripts/normalizar_escalas.py --comprobar` los pasa.
