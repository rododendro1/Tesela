# La consola, paso a paso

Un recorrido por `armonia`, la línea de comandos de Tesela: primero un acorde, luego una escala, un análisis y una
realización a cuatro voces, y al final los datos en JSON para un script y el motor como servidor MCP para un
asistente. Las salidas son las de la versión de este repositorio, con la notación por defecto (la española).

Cómo instalarla está en el [README](../README.md#la-línea-de-comandos). `armonia ayuda` da todas las órdenes, y
`armonia ayuda acorde`, las opciones de una.

## Un acorde

```console
$ armonia acorde Sol7
Sol7: séptima de dominante
  notas: Sol Si Re Fa
  Sol fundamental · Si tercera · Re quinta · Fa séptima
```

Los nombres se leen en español o en inglés, y la respuesta sale en el idioma de `--idioma` (o en inglés con
`--ingles`):

```console
$ armonia acorde G7 --ingles
G7: dominant seventh
  notes: G B D F
  G root · B third · D fifth · F seventh
$ armonia acorde Sol7 --idioma eu
Sol7: dominanteko zazpigarrena
  notak: sol si re fa
  sol oinarria · si hirugarrena · re bosgarrena · fa zazpigarrena
```

Al revés, `identificar` dice qué acordes forman unas notas, del más probable al menos:

```console
$ armonia identificar Do Mi Sol Sib
Do7  séptima de dominante
Mi°/Do  disminuido
…
```

Y `arpegio`, las notas del arpegio y las escalas que se tocan sobre él:

```console
$ armonia arpegio Sol7
Arpegio de Sol séptima de dominante, estado fundamental (ascendente)
  notas: Sol₄ Si₄ Re₅ Fa₅ Sol₅
  escalas: Sol mixolidio, Sol bebop dominante, Sol lidio dominante, Sol mixolidio ♭6, Sol frigio dominante, Sol disminuida semitono-tono
```

## Una escala

`escala` da las notas, de qué escala es modo, lo que dice el catálogo de ella (sus épocas, sus lugares y sus
fuentes) y, con `--acordes`, los acordes de cada grado y todos los que caben en él:

```console
$ armonia escala Re dórico --acordes
Re dórico
  notas: Re Mi Fa Sol La Si Do
  modo 2 de Do mayor
  …
  referencias: Powers et al. 2001; Levine 1995; Rechberger 2008; Temperley & Tan 2013: 248
  acordes: i7 Rem7 · ii7 Mim7 · ♭IIImaj7 Famaj7 · IV7 Sol7 · v7 Lam7 · viø7 Sim7(♭5) · ♭VIImaj7 Domaj7
  Acordes que caben:
    1 · Re: Rem · Resus2 · Resus4 · Rem7 · Re7sus4 · Rem6 · Rem(add9) · Rem9 · Rem6/9 · Rem11
    …
```

`armonia escalas` es el catálogo entero, y `armonia ayuda escala`, las demás opciones: `--vecinas`, `--modos`,
`--tensiones-disponibles`, `--estadisticas`…

## Un análisis

`analizar` lee una progresión y da el grado, la función y las cadencias:

```console
$ armonia analizar Do Lam Re7 Sol7 Do
I–vi–V7/V–V7–I en Do mayor
  Do        I         tónica
  Lam       vi        tónica
  Re7       V7/V      dominante
  Sol7      V7        dominante
  Do        I         tónica
Cadencia auténtica V7–I (acordes 4 → 5)
```

Con `--escalas`, también la escala de cada acorde, con sus tensiones, las notas a evitar y las notas guía:

```console
$ armonia analizar Rem7 Sol7 Do7M --en "Do mayor" --escalas
ii7–V7–Imaj7 en Do mayor
  Rem7      ii7       subdominante
    Re dórico — Tensiones: Mi 9 · Sol 11 · Si 13
      Estructuras superiores: Mim · Sol · Do · Lam
      notas guía: Fa, Do
  Sol7      V7        dominante
    Sol mixolidio — Tensiones: La 9 · Mi 13 — A evitar: Do 11
  …
```

## A cuatro voces

`realizar` escribe los acordes a cuatro voces sin faltas de conducción, y con `--bajo-cifrado` realiza un bajo con
sus cifras detrás de dos puntos:

```console
$ armonia realizar La Fa:6 Mi:# La --bajo-cifrado --en "La menor"
La menor
  Lam       i         La₂ La₃ Do₄ La₄
  Rem/Fa    iv6       Fa₂ La₃ Re₄ La₄
  Mi        V         Mi₂ Si₃ Mi₄ Sol♯₄
  Lam       i         La₂ Do₄ Mi₄ La₄
```

`revisar` busca las faltas de un coral escrito a mano, voz a voz y con los acordes separados por comas. Si las hay,
sale con código 3, así que sirve en un script:

```console
$ armonia revisar Do3 Mi4 Sol4 Do5, Re3 Fa4 La4 Re5 || echo mal
Quintas paralelas entre bajo y contralto (acordes 1 → 2)
Octavas paralelas entre bajo y soprano (acordes 1 → 2)
mal
```

Las partituras salen con `musicxml`, `mei`, `lilypond`, `abc` y `midi`, a la salida estándar o a un fichero con `-o`:

```sh
armonia midi acordes Do Fa Sol Do -o cadencia.mid
armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf     # con LilyPond instalado
```

## Para un script: JSON

Con `--json`, cada orden da sus datos en JSON, con las mismas claves en todos los idiomas:

```console
$ armonia acorde Sol7 --json | jq -c '.[0].notas'
["Sol","Si","Re","Fa"]
```

Un error sale también en JSON, en la salida de errores, y con un código distinto de 0:

```console
$ armonia acorde Xx --json
{"error":{"codigo":1,"mensaje":"No se puede leer «Xx» (carácter 1): se esperaba un nombre de nota (Do, Re, Mi… o C, D, E…)","posicion":0,"texto":"Xx","tipo":"notaNoReconocida"}}
```

Sin argumentos y en la terminal, `armonia` abre una sesión con una orden por línea. Lo mismo vale para un fichero por
la entrada estándar (`armonia < ejercicios.txt`), que sale con el peor código de sus órdenes.

## Para un asistente: MCP

`armonia mcp` sirve el motor por el Model Context Protocol, por la entrada y la salida estándar. Cada orden que da
JSON es una herramienta (33 en esta versión), y para añadirla a Claude Code basta con:

```sh
claude mcp add armonia -- armonia mcp
```

Cada herramienta recibe en `argumentos` lo que se escribiría en la terminal tras el nombre de la orden, y cada opción
que da JSON es además una propiedad propia de su esquema, con su descripción y, si tiene pocos valores, su lista. Las
que solo dan texto (`analizar --escalas`, `acorde --bebop`…) no se ofrecen: con `--json`, dicen que no dan salida en
JSON. Estas dos
llamadas a `escala` son la misma:

```json
{"name": "escala", "arguments": {"argumentos": "Re dórico --acordes"}}
{"name": "escala", "arguments": {"argumentos": "Re dórico", "acordes": true}}
```

Una propiedad que la orden no tiene da un error (-32602), en lugar de ignorarse.
