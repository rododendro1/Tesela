# Cambios

## Sin publicar

### Organización

- Los ficheros `X+Idiomas.swift` se funden en el fichero de su tipo (`Nota+Idiomas.swift` en `Nota.swift`, etc.),
  al final, tras `// MARK: - Idiomas`. `ErrorDeLectura+Idiomas`, `+Notas`, `+Acordes`, `+Escalas` y `+Partitura` pasan a
  `ErrorDeLectura.swift`. No cambia ninguna API.
- Escalas en menos ficheros: `Escala+Busqueda` y `+Ortografia` pasan a `Escala.swift`; `TipoDeEscala+Basicas` y
  `+Catalogo`, a `TipoDeEscala.swift`; `+ModosExoticos`, a `Occidentales/TipoDeEscala+Modos.swift`; `+Hexatonicas`, `+Jazz`
  y `+Messiaen`, a `Occidentales/TipoDeEscala+Exoticas.swift`; y las tradiciones (salvo la India, que sigue aparte),
  a `Tradiciones/TipoDeEscala+Tradiciones.swift`, cada una tras su `// MARK: - Nombre`. No cambia ninguna API.

### Swift 6

- El paquete pide Swift 6.0 o posterior (`swift-tools-version:6.0`) y compila en el modo de lenguaje 6: la
  concurrencia se comprueba al compilar, no solo en el CI. Antes pedía Swift 5.9.

### Importar MIDI y MusicXML

- `PiezaImportada(leyendo:)` lee un fichero MIDI estándar (formatos 0, 1 y 2) o una partitura MusicXML por partes sin
  comprimir, según su contenido: `PiezaImportada(midi:)` y `PiezaImportada(musicXML:)` para uno en concreto. Da las
  notas (`NotaDeLaPieza`: altura, comienzo y duración en redondas, parte) y el título, la armadura, el compás y el
  tempo del fichero. En MIDI, la ortografía sale de la armadura o, si no la hay, de `tonalidadEstimada`; en MusicXML se
  conserva, con acordes, voces (`<backup>`, `<forward>`), ligaduras e instrumentos transpositores. No cuentan la
  percusión, las notas de adorno ni las notas guía.
- `acordes(ventana:)` (y `acordesConInicio(ventana:)`) reduce las notas a los acordes que suenan, por ventanas de un
  pulso: cada clase de altura pesa lo que suena, se descartan las notas breves si sin ellas sale una lectura más
  probable y las ventanas seguidas con el mismo acorde se funden. `analisis(en:ventana:)` las analiza.
- `ErrorDeImportacion` dice por qué no se puede leer un fichero (formato desconocido, MusicXML comprimido, MIDI dañado
  o con tiempo SMPTE, XML mal formado, sin notas o sin acordes), en los catorce idiomas.
- En la línea de comandos, `armonia analizar --archivo coral.mid [--ventana 2] [--en Do mayor]` (o
  `analyze --file chorale.musicxml --window 2`) analiza los acordes de un fichero como si se hubieran escrito.
- Todavía no se leen el MusicXML comprimido (.mxl), las repeticiones ni los saltos.

### Arpegios

- `Arpegio`: un acorde recorrido nota a nota, con `Patron` (`.ascendente`, `.descendente`, `.idaYVuelta`, `.alberti`),
  `octavas` y `conOctava`. `alturas(octava:)`, `notas`, `transponer(_:)`, `nombre(en:)` en los catorce idiomas y
  `Arpegio(leyendo:)` («arpegio Dom7», «Dom7 arpeggio», «Arpège de Do»). No forma parte de `TipoDeEscala.todos`.
- `Escala.arpegio(grado:cuatriada:…)`, `Escala.arpegio(grados:…)`, `Escala.arpegios(cuatriadas:)`, `Acorde.arpegio(…)`
  y `Acorde.escalasCompatibles(entre:)` (la relación acorde-escala: Do7 → Do mixolidio…).
- `Arpegio.svgPentagrama(octava:opciones:)`: las notas en el orden del patrón, una por columna.
- En la línea de comandos, `armonia arpegio Do7 [--patron alberti]` (o `arpeggio C7 --pattern up-down`): las notas
  del arpegio desde la octava 4 y las escalas que encajan con el acorde. El patrón se escribe como en el código, con
  guiones (`ida-y-vuelta`), en inglés o con su nombre en cualquiera de los catorce idiomas. La ayuda, los errores y la
  etiqueta nueva («escalas»), en los catorce.
- `Voz(_:figura:octava:compas:)`: un arpegio con ritmo, que se dibuja, suena y se exporta como cualquier voz.
  `Voz(arpegiando:patron:octavas:conOctava:figura:porAcorde:octava:compas:)` arpegia una progresión: cada acorde con el
  mismo patrón, el patrón repetido hasta llenar `porAcorde` (la última nota se alarga si no cabe un número entero) y el
  bajo de cada acorde en la octava más cercana al del primero.
- En la línea de comandos, `armonia musicxml|mei|midi arpegios Do Lam Fa Sol7 [--patron alberti] [--figura 16]
  [--duracion 2]` (o `arpeggios … --pattern up-down`) exporta la progresión arpegiada, con la armadura de la tonalidad
  que mejor la explica (o la de `--tonalidad`). `--patron` y `--figura` solo valen para los arpegios. La ayuda y los
  errores, en los catorce idiomas.
- `Mastil.posiciones(de:trastes:)` da las posiciones de las notas de un acorde, y `Mastil.arpegios(de:ancho:)` el
  arpegio por posiciones (`ArpegioEnElMastil`): franjas de cuatro trastes que empiezan un traste por debajo de la
  fundamental en una de las dos cuerdas más graves, con las notas de grave a agudo y sin unísonos repetidos.

### Teclados isomórficos

- `TecladoIsomorfico.acordeonC` y `.acordeonB`: el acordeón cromático de botones (sistemas C y B), con hexágonos planos:
  arriba una tercera menor y, a los lados, un semitono y un tono (el B es el espejo del C).
- `TecladoIsomorfico.wickiHaydenPlano` (hexágonos planos, con la quinta en vertical) y `.wickiHaydenEspejo` (la
  quinta arriba a la izquierda y la cuarta arriba a la derecha; el tono, hacia la izquierda).
- `FormatoUIL`: el formato UIL (Unified Isomorphic Layout, Park y Gerhard 2013) para describir cualquier teclado
  hexagonal isomórfico, `L,G,D;R<grados>[M][;T<tonos>]`. `FormatoUIL(leyendo:)` (también con intervalos como `M2,P5,P4`,
  `II,V,IV` o `9:8,3:2,4:3`), `descripcion`, `esCompleto` (L y D coprimos), `caso` (cero e igualdad), `orientacion`,
  `anguloDelEjeDeAltura`, `semitonos(rumbo:)`, `rotado(grados:)`, `reflejado` y `teclado(nombre:midiDelOrigen:)`.
  `ErrorDeUIL` dice por qué no se lee. `FormatoUIL.conocidos` trae los ocho de la Tabla 1 del artículo.
- `TecladoIsomorfico.uil` (su formato, p. ej. `2,7,5;R30M`), `TecladoIsomorfico.conUIL(_:)`, `rotado(pasos:)` y
  `rotado(grados:)` (de 30° en 30°, en sentido horario), `reflejado` y `semitonos(rumbo:)`.
- Los teclados que ya había coinciden con el artículo (Wicki-Hayden `2,7,5;R30M`, tabla armónica `3,7,4;R0`,
  Jankó `1,2,1;R90`) salvo los acordeones: `.acordeonC` es `1,3,2;R0M` y `.acordeonB` `1,3,2;R0`, y el artículo da
  `R270M` y `R270` (los mismos, girados 90°).
- Corregido: `TecladoIsomorfico.midi(en:)` había perdido su cabecera y no compilaba.

### Pentagramas en SVG

- `Escala.svgPentagrama(octava:sentido:opciones:)` y `Acorde.svgPentagrama(octava:cifrado:opciones:)` dibujan escalas y
  acordes en un pentagrama, en Swift y sin dependencias: clave, armadura, redondas, alteraciones, líneas adicionales y,
  en los acordes, segundas desplazadas y cifrado encima. Los glifos son los de Bravura (SMuFL, OFL).
- La escala sube y, si baja con otras notas (la menor melódica), también baja, con los becuadros que hagan falta.
- Cada nota lleva un `<title>` con su nombre en la notación elegida; el pentagrama se ensancha si el cifrado o los
  nombres son más anchos que las notas.
- `OpcionesDePentagrama`: clave (por defecto, la de sol o la de fa con menos líneas adicionales), armadura, notación,
  nombres de las notas, tamaño y color.
- `OpcionesDePentagrama.pentagramas` (`.automatico`, `.simple`, `.doble`): en el pentagrama doble, sol y fa unidos por
  una barra, las notas se reparten por el Do central y las armaduras se escriben en los dos. Automático: solo si la
  clave no se fija, el rango pasa a los dos lados del Do central y con uno harían falta más de tres líneas adicionales.
- Marca 8va u 8vb (`marcaDeOctava`): con la clave sin fijar, si el rango es muy agudo o muy grave y no pasa por el Do
  central, se escribe una octava más cerca del pentagrama con una línea de puntos hasta la última nota.
- Las etiquetas con los nombres de las notas no se pisan (la columna se corre si hace falta) y la medida del texto se
  ajusta con `anchoDeLosCaracteres`. Un hueco entre la clave (o la armadura) y la primera nota.
- Las alteraciones se reparten en columnas según lo que sube y baja cada glifo (y cada columna mide lo que su glifo
  más ancho), así que siete alteraciones seguidas caben en tres columnas, no en siete.
- La marca 8va/8vb también funciona en el pentagrama doble, cada uno con la suya (8va arriba, 8vb abajo).
- El pentagrama doble lleva una llave de Bravura (`llave` en `GlifosSMuFL`, con `extraer_glifos_bravura.py`).
- La medida del texto sale de una tabla de anchos por carácter (sin tildes) en vez de una constante, y el texto lleva
  `textLength`. `anchoDeLosCaracteres` es ahora un multiplicador (1 por defecto, antes 0,62 por carácter).
- `OpcionesDePentagrama.disposicionDelAcorde` (`.automatica`, `.cerrada`, `.abierta`): el bajo una octava más grave y
  el resto en posición cerrada; automática en los acordes que abarcan más de una octava y media.
- Ejemplos en `NotacionYPartitura.md`, que se prueban como los demás.
- Sin ritmo, vigas ni voces: para partituras completas, MEI o MusicXML y un motor externo.

### Normalización y documentación

- `Scripts/vectores/normalizar.tsv` reúne los casos de `TipoDeEscala.normalizar`; los lee `NormalizarVectoresTests` y
  `Scripts/normalizar_escalas.py`, la copia en Python que ahora usan `comprobar_catalogo.py` y los generadores (antes
  cada uno llevaba la suya).
- DocC (`Escalas.md`) y el README describen los nombres por idioma, los alias escritos y normalizados, y la clase y la
  tradición de las escalas (con ejemplos que se prueban).

### Tradición y clase de las escalas

- `TipoDeEscala.clase` (`ClaseDeEscala`: `raga`, `melakarta`, `janya`, `thaat`, `dromos`, `maqam`, `dastgah`…) y
  `TipoDeEscala.tradicion` (`Tradicion`: `india`, `grecia`, `mundoArabe`…) dicen qué es una escala de otra tradición;
  `esRaga` es cierto para ragas, melakarta y janya, no para los thaat. Salen de las listas de cada tradición (no cambian
  `TipoDeEscala` ni su `Codable`) y valen `nil` en las occidentales y en las propias. Se buscan por el nombre, porque
  Āsāvarī es igual a la menor natural por sus intervalos. `TipoDeEscala.tradicionales(clase:)` y `(tradicion:)`
  las filtran, y `ClaseDeEscala.nombre(en:)` da el nombre de la clase en cada idioma, tomado de las filas `.clase` de
  los ficheros de `Escalas/Nombres/` (`comprobar_catalogo.py` vigila que no falte ninguna).
- `clase` y `tradicion` exigen también que los intervalos coincidan: una escala propia que se llame «Kāfī» pero suene
  distinto no es el thaat. `padre` da el melakarta del que deriva un raga janya (Mohanam → Harikāmbhojī; Revati no
  tiene uno único); siempre es uno de sus `melakartasCompatibles`.

### Alias escritos y alias normalizados

- `TipoDeEscala.alias` guarda solo las grafías correctas («dórico ♭2», «húngara»); las simplificadas («dorico b2»,
  «hungara») ya no se repiten: salen de `aliasNormalizados` y de `normalizar`, que ahora también pliega «ª» y «−».
  Se quitaron 120 alias que eran solo la forma sin diacríticos; la lectura no cambia (`Scripts/comprobar_catalogo.py`
  avisa si se vuelve a guardar uno). `normalizar` pliega también «…» como «..», con lo que «cromatica -5..6» ya no
  hace falta como alias.
- Alias que faltaban en euskera y alemán («vermindert», «symmetrisch übermäßig», «phrygisch Dur», «gutxitua»…) y
  algunos más en ruso y griego.

### Alias en ruso y griego

- `NombresDeEscalas+Ruso.swift` y `NombresDeEscalas+Griego.swift` tienen ya alias (modos en femenino, «Мессиан 3»,
  «εξατονική», nombres propios como Лист o Σκριάμπιν…), como el resto de idiomas.
- En ruso y griego, las escalas de otras tradiciones llevan su nombre transcrito (Бхайрав, Μπιλαβάλ, Хиджаз…);
  los 72 melakarta siguen en IAST. El nombre original, en latino, se sigue leyendo.
- `Scripts/comprobar_traducciones.py` funciona también sin `.git`.
- Las filas `.tradicional` de los ficheros de idioma nombran la escala por su miembro de `TipoDeEscala`
  (`.tradicional(.hitzaz, "…")`), no por una cadena: renombrar o quitar una escala da un error de compilación en
  lugar de dejar la fila huérfana. Los 72 melakarta ya no se listan (sin fila conservan su nombre en IAST).
- Los generadores de alias y de nombres tradicionales están en `Scripts/nombres_de_escalas/` (con su README).

### Un idioma por fichero

- Los nombres de los tipos de escala y sus alias pasan a `NombresDeEscalas`, con un fichero por idioma en
  `ArmoniaTeoria/Escalas/Nombres/` (catalán, gallego, euskera, aragonés, asturiano, portugués, francés,
  italiano, alemán, occitano, ruso, griego e inglés). Sustituyen a `TipoDeEscala+Idiomas.swift` y a sus cuatro
  tablas agrupadas por familias de idiomas; `TipoDeEscala.nombre(en:)` y la lectura de «Re dòric», «Fis dorisch»
  o «ре дорийский» no cambian. Un idioma nuevo es un fichero más y su fila en `NombresDeEscalas.traducidos`.
- Las escalas de otras tradiciones están también en esos ficheros (`.tradicional`), por su nombre original: sus
  nombres propios (Kafi, Hitzáz, Hirajōshi…) se escriben igual en todos los idiomas, pero ahora se pueden traducir
  uno a uno. Se traducen las que llevan un nombre descriptivo en español —las escalas andinas, los tetracordos y
  las harmoniai griegas— y el «mayor» y «menor» de las etíopes. `TipoDeEscala.nombre(en:)` los da traducidos.

- Los textos de `ArmoniaNucleo` (calidades de intervalo, consonancias, palabras de las alteraciones y
  mensajes de `ErrorDeLectura`) pasan a `TextosDeNucleo`, con un fichero por idioma en `Textos/`. Los que
  llevan valores («la 7ª no es…») son cierres: `intervaloSinPapel: { intervalo, notacion in "…" }`.
- Los textos de `ArmoniaPartitura` (figuras, claves, faltas de contrapunto, pistas MIDI) pasan a
  `TextosDePartitura`, igual.
- Los textos de `ArmoniaRepresentaciones` (temperamentos, ciclos y transformaciones neorriemannianas,
  leyendas de los dibujos) pasan a `TextosDeRepresentaciones`, igual.
- Los textos de `ArmoniaTeoria` (tipos de acorde, papeles, inversiones, grados, funciones, cadencias,
  faltas de conducción, voces) pasan a `TextosDeTeoria`, igual. La declinación vasca de «De Do mayor a Sol
  mayor» pasa del código al fichero del euskera.
- En la línea de comandos, los textos de la ayuda, los errores de uso y las etiquetas de la salida pasan a
  `TextosDeCLI`, igual. La salida no cambia.
- Los textos de `ArmoniaTrastes` (los nombres de los instrumentos) pasan de un `Traduccion` con los
  catorce idiomas juntos a un fichero por idioma: `Textos/TextosDeTrastes+Espanol.swift`,
  `…+Ingles.swift`… Cada fichero da todos los campos de `TextosDeTrastes`, sin valores por omisión, así que
  un texto nuevo sigue sin compilar hasta que está en los catorce, y un idioma nuevo es un fichero más.
  `Encordado.nombre(en:)` y `titulo(en:)` dan lo mismo que antes.
- `Scripts/comprobar_traducciones.py` lee también los ficheros por idioma.

### Las reglas de cada idioma, como datos

- `EscrituraDeNotas` deja de ser una lista de dieciocho casos y pasa a ser el idioma con su variante
  (`idioma`, `conPalabras`, `tipografia`). Las constantes (`.espanolUnicode`, `.ruso`…), `allCases`,
  `init(idioma:ascii:)` y el orden no cambian, pero ya no se puede hacer `switch` sobre ella: para eso está
  `escrituraDeLaAlteracion`. Un idioma nuevo no añade casos aquí.
- Las reglas dicen además cómo escribe cada idioma las alteraciones (`alteraciones`) y los signos de sus
  cifrados (`tipografia`), así que las tres escrituras del español y del inglés salen de ellas.

- Nuevo `ReglasDeIdioma` (`Idioma.reglas`): las siete sílabas del idioma, el separador de la alteración en
  palabras (" " en casi todos, "-" en ruso) y dónde va el multiplicador (delante, detrás en euskera, unido en
  alemán). `NotaNatural.nombre(en:)` y `Alteracion.nombre(en:)` lo consultan en vez de repartir los catorce
  idiomas por sus `switch`.
- Nuevo `EscrituraDeNotas.escrituraDeLaAlteracion`: `.palabras`, `.signos` o `.alemana`. `Nota.nombre(en:)`,
  `Nota.nombreCompacto(en:)`, `Nota(leyendo:en:)` y `Altura(leyendo:en:)` preguntan por esto y ya no listan
  las dieciocho escrituras.
- Sin cambios de comportamiento: los nombres, las lecturas y los cifrados salen igual en los catorce idiomas.
  Añadir un idioma pasa a ser una fila en las reglas y un caso en `Idioma` y `EscrituraDeNotas`.

### Español e inglés con palabras, ASCII o Unicode

- **Cambio de nombres**: `Notacion.espanol` (Fa♯) pasa a llamarse `.espanolUnicode` y `Notacion.ingles` (F#),
  `.inglesASCII`; lo mismo en `EscrituraDeNotas`. Los nombres `.espanol` e `.ingles` son ahora las notaciones
  con las alteraciones en palabras: «Fa sostenido», «Si doble bemol», «F sharp», «B double flat». Sus cifrados
  llevan ♯ y ♭ en los dos idiomas (Fa♯7, B♭7(♭9)/D). `.espanolASCII` e `.inglesUnicode` no cambian.
- Las notas, las alturas, las escalas y las tonalidades se leen también con palabras, sin indicar la notación:
  `Nota("Fa sostenido")`, `Altura("B flat 4")`, `Escala("F sharp dorian")`, `Tonalidad("Mi bemol menor")`.
  `Nota(leyendo:en:)` y `Altura(leyendo:en:)` leen las tres formas en cualquiera de las seis notaciones.
- `Notacion.delIdioma(_:)` sigue dando ♯ y ♭ en español (`.espanolUnicode`) y # y b en inglés (`.inglesASCII`).
- **Cambio de nombres** en `EstiloDeCifrado`, para que casen con `Notacion`: `.ascii` pasa a `.espanolASCII`,
  `.ingles` a `.inglesASCII` y `.palabras` (Domin7, Fadim, Solaug) a `.calidadesConPalabras`, que no tiene que
  ver con las notaciones con palabras.
- En la línea de comandos, `--escritura palabras|ascii|unicode` (o `--writing words|ascii|unicode`) elige
  entre las tres en español e inglés: `armonia acorde Sib7 --escritura palabras` da «Si bemol Re Fa La bemol».
  Se combina con `--idioma`, `--ingles` y `--textos`; sin ella, todo sigue igual.
- Los cifrados también se leen con la fundamental y el bajo en palabras: `Acorde(texto: "Fa sostenido m7")`,
  `Acorde(texto: "B flat 7(b9)")`, `Acorde(texto: "Sol7/Fa sostenido")`. La palabra va en el idioma de la nota y
  separada de ella por un espacio. Lo hace el lector común de notas, así que vale para todo lo que lo usa.

### Ficheros con el nombre de su tipo

- Sin cambios en la API: `TransformacionesNeorriemannianas.swift` y `CiclosNeorriemannianos.swift` pasan a
  `TransformacionNeorriemanniana.swift` y `CicloNeorriemanniano.swift`, `Ritmo+Idiomas.swift` a `Duracion+Idiomas.swift`,
  `TipoDeEscala+Peninsulares.swift` a `TipoDeEscala+Idiomas.swift`, `MIDI.swift` a `ArchivoMIDI.swift`, y
  `TipoDeEscala+Maqamat.swift` y `TipoDeEscala+Dastgah.swift` a `TipoDeEscala+MundoArabe.swift` y
  `TipoDeEscala+Persia.swift`, como las demás tradiciones. `Coral`, `Coral+Realizacion` y `Armonizacion` pasan
  de `Tonalidad/` a una carpeta `Coral/`, y `ModoGregoriano` a `Escalas/Occidentales/`.
- Los mensajes de `ErrorDeLectura` se reparten según lo que se leía: `ErrorDeLectura+Notas`, `+Acordes`,
  `+Escalas` y `+Partitura`, con una función por motivo; `ErrorDeLectura+Idiomas.swift` se queda con los generales
  y el `switch`. Los textos no cambian. Las pruebas de `TextoTests.swift` pasan a `ErroresDeLecturaTests`,
  `NotacionInternacionalTests`, `NotacionesPeninsularesTests`, `NotacionesEuropeasTests` y `TraducidoTests`, y los
  errores de uso de la línea de comandos, a `ErrorDeUso+Consultas`, `+Armonizacion`, `+Trastes`, `+Neorriemann`,
  `+Partituras` y `+Dibujos`, como su ayuda.

### Un solo orden para los idiomas

- Los catorce idiomas van en el mismo orden en todas partes: español, inglés, catalán, gallego, asturiano,
  aragonés, euskera, portugués, francés, occitano, italiano, alemán, griego y ruso. Cambia el orden de los casos
  de `Idioma` y `EscrituraDeNotas`, de `Notacion.allCases` y `Idioma.traducidos`, y el de los argumentos de
  `Traducido(_:_:ca:gl:ast:an:eu:pt:fr:oc:it:de:el:ru:)`, así que una `Traduccion` escrita a mano tiene que
  seguir el orden nuevo. `Traducido.todos` también va en ese orden.

### Idiomas y notación

- `Idioma.codigo` («es», «an», «ast»…) e `Idioma(codigo:)`, que acepta también etiquetas con región
  («ca-ES», «pt_BR»), y `Notacion.delIdioma(_:)`, la notación habitual de un idioma (`.ingles` con #, `.espanol`
  con ♯). La línea de comandos (`--idioma`) y las apps (`Notacion.delSistema`) los usan en lugar de su propia
  tabla de códigos.
- `EscrituraDeNotas.tipografia` es ahora la que manda, y `usaASCII` es `tipografia == .ascii`. No cambia nada
  para quien las usa.
- `Texto/Idiomas.swift` se parte en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`,
  como el resto de ficheros `X+Idiomas.swift`, y `EstiloDeCifrado` pasa a su propio fichero. Los nombres de las
  alteraciones usan `Traduccion`, y los ordinales de los intervalos, una sola función con una tabla por idioma.
- Nombres que no encajaban: en alemán, las alteraciones de cuatro signos son «Vierfachkreuz» y «Vierfach-Be»
  (antes «4 Kreuze» y «4 Be»); en ruso, la nota y la alteración se unen con un solo guion, «си-тройной бемоль»
  (antes «си-тройной-бемоль»; «си-дубль-бемоль» no cambia); en gallego, «tripla aumentada» concuerda con la
  calidad como «triplo sostido» con la alteración (antes «triple aumentada»).

### Temperamentos circulares

- `TemperamentoCircular`: octava pura y doce quintas de tamaños distintos que cierran el círculo, con
  `werckmeisterIII`, `kirnbergerIII`, `vallotti` y `young`. Da los cents de cada clase de altura (`clases`) y su
  desviación del temperamento igual (`desviaciones`), y se puede afinar con otro La4 (`afinar(la4:)`).
- `Temperamento`: el catálogo de las afinaciones que se pueden elegir (igual, pitagórica, mesotónica de ¼ de coma,
  las cuatro circulares y la justa), con `afinacion(tonica:la4:)`, `distingueEnarmonicas` y el nombre en los
  catorce idiomas.

### Tipografía de las alteraciones

- `Tipografia` reúne los estilos de escribir los signos de una alteración: `.unicode` (♯♭), `.ascii` (#b) y
  `.compacta` (𝄪𝄫, con ♮ para el natural). `Alteracion.simbolo(en:)` escribe en cualquiera de ellas;
  `simbolo`, `simboloASCII` y `simboloCompacto` siguen igual. `Notacion.tipografia` y
  `EscrituraDeNotas.tipografia` dicen la de cada notación.

### Alias en griego y en devanagari

- Los 15 dromoi se encuentran también por su nombre en griego (`Escala("Re Χιτζάζ")`, «Ουσάκ», «Ραστ»…), y las
  escalas indias (las 72 melakartas, los janya, los thaats y los ragas indostánicos) por su nombre en
  devanagari («यमन», «मायामालवगौळ», «मोहनम्»).
- Al buscar un nombre en devanagari no se quitan las marcas, que distinguen भैरव (Bhairav) de भैरवी (Bhairavī).

### Exportación a MEI

- `Voz.mei(tonalidad:clave:tempo:titulo:parte:)`, `Coral.mei(…)` y `AnalisisArmonico.mei(…)` escriben la
  partitura en MEI 5 (Music Encoding Initiative), con las mismas opciones que `musicXML`: grafía con barras,
  grupos irregulares y ligaduras, anacrusa, tempo, cifrados en `<harm>` y análisis como letra. Como MEI no
  deduce qué alteraciones se ven, se escriben como en una partitura (valen hasta la barra en su pentagrama y
  su octava, y las de la armadura no se escriben), y la que suena sin escribirse va en `accid.ges`.
- `armonia mei melodia|coral|acordes …` lo da desde la terminal, con las opciones de `armonia musicxml`.

### Las seis escalas cromáticas por ventana de quintas

- `TipoDeEscala.cromatica(desdeLaQuinta:)`: la cromática de las doce quintas seguidas que empiezan en una
  quinta de −6 a −1 desde la tónica, siempre con la escala mayor dentro. Las seis son `cromaticaConCincoBemoles`,
  `cromaticaConCuatroBemoles` (la `cromatica` de siempre, que no cambia), `cromaticaConTresBemoles`,
  `cromaticaConDosBemoles`, `cromaticaConUnBemol` y `cromaticaConCincoSostenidos`, y `cromaticasPorQuintas`
  las da en orden.
- Las cinco nuevas entran en `TipoDeEscala.todos`, detrás de la `cromatica`, con nombre en los catorce idiomas
  («cromática con dos bemoles», «chromatic with two flats», «chromatique à deux bémols»…). También se leen por la
  ventana: «Do cromática −3…8», «Do cromatica -3..8». La `cromatica` gana los alias «cromática con cuatro
  bemoles» y «cromática −5…6».

### Contrapunto de especies

- `Contrapunto`: un cantus firmus en redondas y un contrapunto de la primera a la quinta especie, encima o
  debajo, que se comprueba con las reglas del contrapunto estricto de Fux. `faltas` da cada `FaltaDeContrapunto`
  con su tipo y sus compases (ritmo de la especie, principio y final, disonancias mal tratadas, retardos mal
  resueltos, quintas y octavas paralelas y directas, unísonos, cruces, saltos y notas repetidas), e
  `informe(en:)`, el resumen en los catorce idiomas.
- `Contrapunto(cantusFirmus:contrapunto:especie:)` lee las dos voces como texto; si no duran lo mismo, el
  error es `ErrorDeLectura.Motivo.contrapuntoDeOtraDuracion(redondas:)`.
- `armonia contrapunto <cantus> / <contrapunto> [--especie 1…5]` (en inglés, `counterpoint … --species`)
  escribe el informe.

### Aragonés y asturiano

- Dos idiomas más, `Idioma.aragones` e `Idioma.asturiano`, con sus notaciones `Notacion.aragones` y
  `Notacion.asturiano`: notas en do re mi («fa sosteniu», «fa sosteníu»), alteraciones, intervalos, acordes,
  inversiones, escalas, tonalidades, cadencias, avisos del coral, instrumentos y mensajes de error. Ya son
  catorce. `Traducido` gana los campos `aragones` y `asturiano`, y su `init` los argumentos `an:` y `ast:`
  tras `el:`, así que una `Traduccion` escrita a mano necesita los dos nuevos.
- `Nota(leyendo:)`, `Altura(leyendo:)` y `Encordado(nombre:)` entienden también los nombres en aragonés y
  asturiano («sol sosteníu 4», «baxu»).
- `armonia --idioma an` y `--idioma ast` (o `aragones`, `asturianu`) dan la salida y la ayuda en esos idiomas.

### Nombres traducidos de los instrumentos y las transformaciones

- `Encordado.nombre(en:)`, `Encordado.titulo(en:)` y `TransformacionNeorriemanniana.nombre(en:)` pasan de
  ArmoniaUI a la biblioteca, así que se pueden usar sin las apps: `Encordado.mandolina.nombre(en: .portugues)` es
  «bandolim» y `TransformacionNeorriemanniana.l.nombre(en: .ingles)`, «leading-tone exchange». Los dos tipos son
  `Nombrable`.
- `Encordado(nombre:)` reconoce el nombre del instrumento en los doce idiomas: «guitare», «Gitarre», «гитара»
  o «bandolim» encuentran su encordado. Así, `armonia trastes --instrumento` acepta también esos nombres.
- `Acorde.nombreDeLaInversion(_:en:)` da el nombre de una inversión en cada idioma («primera inversión»,
  «zweite Umkehrung», «первое обращение»), el mismo que usa `Acorde.nombre(en:)`. Llega hasta la sexta inversión
  con palabras; a partir de la séptima, con el número («inversión 7», «7. Umkehrung»).
- `Traducido<Valor>`: un valor en los doce idiomas, como `Traduccion`, que pasa a ser `Traducido<String>`
  (todo lo que la usaba se escribe igual). Sirve para listas por idioma, como los nombres de las inversiones o
  de los puntillos, que antes se repartían por los `case` de un `switch`, y tiene `map(_:)`.
- Dos traducciones corregidas: en ruso, «гитара со строем drop D» (era «с строем»), y en euskera, la
  transformación L es «sentsiblearen aldaketa», con el mismo nombre de la sensible que en los grados.

### Nombres de propiedades más claros

Sin alias: los nombres anteriores dejan de existir.

- En `AcordePivote`, `antes` y `despues` pasan a ser `enLaDePartida` y `enLaDeLlegada` (el mismo acorde leído
  en cada tonalidad), y en `RecorridoTonal`, `tonalidadInicial` y `tonalidadFinal` pasan a ser
  `tonalidadDePartida` y `tonalidadDeLlegada`, como en `AcordePivote`.
- `Intervalo.direccion` pasa a ser `sentido`, como su tipo `SentidoDelIntervalo`, y así también el parámetro de
  `Intervalo(pasosDeQuinta:pasosDeOctava:sentido:)`, `Intervalo(numero:calidad:sentido:)`, `Escala.notas(sentido:)`,
  `alturas(octava:sentido:)`, `contiene(_:sentido:)` y `contieneEnarmonico(_:sentido:)`.
- `TipoDeEscala.descenso` pasa a ser `intervalosDescendentes`, también en su inicializador. Al codificar se sigue
  usando la clave `descenso`, así que lo guardado antes se lee igual.
- `Alteracion.cantidad` pasa a ser `numeroDeSignos`; `ConduccionMinima.total`, `semitonosMovidos`;
  `EstiloDeCifrado.alteracionesASCII`, `tensionesEnASCII` (solo afecta a las tensiones), y
  `Clave.alturaPrimeraLinea`, `alturaDeLaPrimeraLinea`.

### Textos en alemán, occitano, ruso y griego

- Los textos del motor (mensajes de error, intervalos, papeles, grados, claves, figuras, cadencias, faltas de
  conducción, dibujos) y los nombres de los catálogos (tipos de acorde y de escala, instrumentos) están también en
  alemán, occitano, ruso y griego, que antes salían en inglés: `Intervalo.terceraMayor.nombre(en: .aleman)` es
  «große Terz» y `Acorde("Sol7/Si").nombre(en: .ruso)`, «доминантсептаккорд от соль, первое обращение».
  `Notacion.aleman.textos` es `.aleman`, y así con las otras tres.
- `Traduccion` pide también `de:`, `oc:`, `ru:` y `el:`, y `Idioma.traducidos` tiene los doce idiomas.
  Desaparecen `Idioma.deLosTextos` y `Notacion.idiomaDeLosTextos`, que ya no hacen falta. `Traduccion.pluralRuso`
  escoge la forma del plural ruso («3 полутона», «5 полутонов»).
- Las escalas se leen también con el tipo en alemán u occitano («D dorisch», «re lidian»).
- En la línea de comandos, `--idioma de|oc|ru|el` (también `--textos`), con los mensajes y la ayuda en esos
  idiomas.

### Más nombres claros

Sin alias: los nombres anteriores dejan de existir.

- En `Notacion`, `idioma` pasa a ser `idiomaDeLasNotas` y `vocabulario`, `idiomaDeLasAbreviaturas`;
  `idiomaDeLosTextos` desaparece porque es `textos`, y `Notacion(idioma:ascii:)` también: es
  `Notacion(escritura: EscrituraDeNotas(idioma:ascii:))`.
- `Coral.problemas` pasa a ser `Coral.faltas`, como `FaltaDeConduccion`.
- `Posicion` pasa a llamarse `PosicionEnElMastil`, `Direccion` (ascendente o descendente) pasa a llamarse
  `SentidoDelIntervalo` y `PuntoDelTonnetz`, `PuntoDeLaRed`, porque también lo usa la tabla armónica.
- En la línea de comandos, `conduccion` pasa a ser `conduccion-minima` (`minimal-voice-leading`), para no
  confundirla con `conduccion-parsimoniosa`. Dejan de aceptarse los sinónimos que no estaban en la ayuda:
  `--progresion` y `--conjunto` (son `--recorrido` y `--clases`), `tabla-armonica` (es `tabla`) y `neorriemanniano`
  (es `plr`).

### Sin nombres obsoletos

- Desaparecen los nombres que estaban marcados como obsoletos: `Nomenclatura`, `ConduccionDeVoces`,
  `ProblemaDeConduccion`, `Instrumento`, `Razon`, `texto(_:)` (en `RepresentableComoTexto`, `Voz`, `Armonizacion`,
  `MovimientoDeVoz`, `PasoParsimonioso` y `ConduccionMinima`), `Notacion.combinada(notas:textos:)`,
  `EstiloDeCifrado(nomenclatura:…)` y `nomenclatura`, `Tonnetz.conOrtografia`, `Tonnetz.Arista.Intervalo` e
  `intervalo`, `TablaArmonica.Modo` y `modo`, `Tonnetz.disposicion(paso:)` y `TablaArmonica.disposicion(paso:)`, y
  `Digitacion.cifra`. Cada uno tenía ya su nombre nuevo, el que proponía Xcode.
- La línea de comandos deja de aceptar los nombres antiguos de órdenes y opciones: `voces` y `voices` (son
  `revisar` y `check`), `camino` y `path` (son `conduccion-parsimoniosa` y `smooth-path`), `--path` en `tonnetz` y
  `tabla` (es `--sequence`, o `--recorrido`) y `--instrumento` en `midi` (es `--programa`, o `--program`).

### Nombres

Los nombres antiguos estuvieron marcados como obsoletos con `renamed:` y ya se han quitado (ver arriba).

- `Nomenclatura` pasa a llamarse `Notacion`, como la llaman ya los parámetros, el entorno de las apps y
  `SelectorDeNotacion`. `EstiloDeCifrado(nomenclatura:…)` y su propiedad `nomenclatura` pasan a ser
  `EstiloDeCifrado(notacion:…)` y `notacion`. Si no se da `alteracionesASCII`, ahora sigue a la notación
  (`Notacion.usaASCII`): `EstiloDeCifrado(notacion:)`, el estilo básico de cada notación, es el mismo
  inicializador con los valores por omisión.
- `ConduccionDeVoces` pasa a llamarse `Coral` (un valor es un coral; la conducción es lo que se revisa), y
  `ProblemaDeConduccion`, `FaltaDeConduccion`, como las «faltas» de las apps.
- `Instrumento` pasa a llamarse `InstrumentoDePartitura`: es el instrumento tal como se escribe (clave y
  transposición). En las apps y en la línea de comandos, «instrumento» es un `Encordado`.
- `RepresentableComoTexto.texto(_:)` pasa a ser `texto(en:)`, como `nombre(en:)` y `cifrado(en:)`; lo mismo en
  `Armonizacion`, `Voz`, `MovimientoDeVoz`, `PasoParsimonioso` y `ConduccionMinima`. Un tipo propio que
  cumpla `RepresentableComoTexto` tiene que implementar `texto(en:)`.
- `Tonnetz.conOrtografia` pasa a llamarse `tieneOrtografia`, como los demás booleanos (`esCorrecta`…).
- **Cambio incompatible:** `Tonalidad.armonizarACuatroVoces(_:)` devuelve `(armonizacion:, coral:)` en lugar de
  `(armonizacion:, voces:)`. Una etiqueta de tupla no admite alias: `resultado.voces` pasa a ser
  `resultado.coral`.
- Las carpetas `Reticulos` y `Reticulos/Neorriemann` de `ArmoniaRepresentaciones` pasan a ser `Redes` y
  `Redes/Neorriemanniana`, y las pruebas `RejillaHexagonalTests`, `RedesSobreHexagonosTests`; las de
  `ConduccionDeVoces`, `CoralTests`. No cambia ningún módulo.

- El ejemplo vuelve a llamarse `EjemploArmonia` (`Ejemplos/EjemploArmonia`, `swift run EjemploArmonia`), como el
  nuevo `EjemploHexagonos`.

### Código

- `ErrorDeLectura` explica sus motivos con un solo `switch` que devuelve una `Traduccion`, en lugar de uno
  por idioma (de 765 a 458 líneas). Los textos no cambian, y un motivo nuevo no compila sin sus ocho idiomas.
- Los `switch` sobre `Nomenclatura` de `Nota(leyendo:en:)`, `Altura(leyendo:en:)` y `Nota.nombreCompacto(en:)`
  ya no tienen `default`: el compilador avisa al añadir una notación.
- `Nomenclatura` deja de ser un `enum` y pasa a ser un `struct` con dos partes: `escritura`
  (`EscrituraDeNotas`, cómo se escriben las notas) y `textos` (el `Idioma` de los textos). `.espanol`,
  `.ruso`… siguen existiendo como constantes, y `conTextos(en:)`, `notas`, `idioma` e `idiomaDeLosTextos` no
  cambian. Desaparece el caso `.combinada(notas:textos:)`: `Nomenclatura.combinada(notas:textos:)` estuvo
  marcada como obsoleta (ya se ha quitado), y se escribe `Nomenclatura(escritura: .ruso, textos: .espanol)`.
  `esCombinada` dice si los textos van en otro idioma. Los `switch` que antes iban sobre `Nomenclatura` van
  ahora sobre `escritura`, sin `default`. Un `switch` sobre `Nomenclatura` fuera del paquete tiene que pasar a
  `escritura`.

### Notas y textos en idiomas distintos

- `Nomenclatura.conTextos(en:)` combina los nombres de nota de una notación con los textos de otro
  idioma: `Acorde("Sol7/Si").nombre(en: Nomenclatura.ruso.conTextos(en: .espanol))` es «соль séptima de
  dominante, primera inversión». `Nomenclatura` gana el caso `.combinada(notas:textos:)` y la propiedad
  `notas`; `allCases` sigue listando solo las notaciones simples. Los textos siguen `idiomaDeLosTextos`
  en lugar de `idioma`.
- Las apps eligen por separado las notas y los textos en el selector de notación (se guarda como
  «ruso+espanol»), y la línea de comandos tiene `--textos`.

### Escalas en francés, italiano, ruso y griego

- `Escala(leyendo:)` acepta la tónica y el tipo en francés e italiano (`Escala("fa dièse lydien")`), y
  en ruso y griego con los tipos más comunes o con su nombre inglés (`Escala("ре дорийский")`,
  `Escala("до lydian dominant")`).

### Nombres de nota en occitano, ruso y griego

- `Nomenclatura` e `Idioma` tienen `.occitano`, `.ruso` y `.griego`: notas, alteraciones y tonalidades
  se escriben y se leen en esas lenguas (`Nota("Fa#").nombre(en: .ruso)` es «фа-диез»;
  `Tonalidad("Re mayor").nombre(en: .griego)`, «ρε μείζονα»; `Altura("sòl dièsi 2")`, Sol♯2). Las lecturas
  genéricas también las aceptan, sin distinguir tildes griegas ni la ё rusa. Los demás textos salen en
  inglés, como en alemán.

### Textos en portugués, francés e italiano

- Los textos del motor y los nombres de los catálogos salen también en portugués, francés e italiano con esas
  notaciones: antes salían en español (portugués) o en inglés (francés e italiano). `Traduccion` pide ahora ocho
  textos (`pt:`, `fr:`, `it:`), y `idiomaDeLosTextos` solo cambia el alemán, que sigue en inglés. El portugués es el europeo (tónica, meio-tom, traste).
  `Intervalo.terceraMayor.nombre(en: .frances)` es «tierce majeure»; `Escala(.re, .dorico).nombre(en: .italiano)`,
  «re dorico»; `Acorde("Sol7/Si").nombre(en: .portugues)`, «sol sétima de dominante, primeira inversão».
- Las escalas se leen también con su nombre en portugués: `Escala("dó maior")`.
- En la línea de comandos, `--idioma pt|fr|it` y la ayuda en esos idiomas.

### Textos en catalán, gallego y euskera

- Los textos del motor salen en catalán, gallego y euskera con esas notaciones, además de en español e inglés:
  los mensajes de `ErrorDeLectura`, los nombres de intervalos, calidades, consonancias, papeles en el acorde,
  calidades de tríada, grados, funciones tonales, claves, figuras y duraciones, cadencias, faltas de conducción,
  análisis y modulaciones, y los nombres de las pistas MIDI. `Intervalo.terceraMayor.nombre(en: .catalan)` es
  «3a major»; en euskera, «3. handia».
- `Traduccion`: un texto en los cinco idiomas, sin valores por omisión, para que el compilador señale el que falta.
  `Nomenclatura.idiomaDeLosTextos` dice en qué idioma salen: el propio en esos cinco, el inglés en alemán, francés
  e italiano, y el español en portugués.
- Cambia la salida con `.catalan`, `.gallego` y `.euskera`, que antes era en español.
- Los nombres de los catálogos también: tipos de acorde («sèptima de dominant», «dominanteko zazpigarrena»), nombres
  de acorde con su inversión, tipos de escala («dòric», «doriarra»; los nombres tradicionales, como los ragas, no
  cambian), instrumentos de la partitura, ciclos neorriemannianos y los títulos y leyendas de los dibujos SVG. Las
  escalas se leen también en esos idiomas: `Escala("re doriarra")`. `Nomenclatura.vocabulario` queda solo para las
  abreviaturas de los intervalos.
- En la línea de comandos, `--idioma ca|gl|eu|es|en` (o `--language`) escribe las notas, los nombres, las
  etiquetas, los errores y la ayuda en ese idioma. Los nombres de las órdenes y de las opciones siguen en español.

### Cadencias, modulaciones y armonización

- `AnalisisArmonico.cadencias`: las cadencias de la progresión (`Cadencia`, con su `Tipo`: auténtica, plagal, rota
  y semicadencia), dónde están y si la auténtica es perfecta (`esPerfecta`).
- `RecorridoTonal`: parte una progresión en tramos (`TramoTonal`), cada uno en su tonalidad, con sus modulaciones
  (`Modulacion`) y el acorde pivote de cada una (`AcordePivote`: «Lam = vi en Do mayor = ii en Sol mayor»). Una
  tonalidad nueva se confirma con una cadencia auténtica; si no, es una tonicalización y no se parte.
- `Tonalidad.acordes(para:)`: los acordes de la tonalidad que tienen una nota, ordenados por coste.
  `Tonalidad.armonizar(melodia:propuestas:)`: las mejores armonizaciones de una melodía (`Armonizacion`), de menor a
  mayor coste, según la armonía funcional y terminando en cadencia.
- `ConduccionDeVoces.realizar(_:soprano:en:)`: escribe unos acordes a cuatro voces sin ninguna falta de las que
  comprueba `problemas`, moviendo las voces lo menos posible, con el soprano fijado si se da.
  `Tonalidad.armonizarACuatroVoces(_:)` armoniza una melodía y la escribe como coral con la melodía en el soprano.
- En la línea de comandos, `analizar` escribe las cadencias y, sin `--en`, las modulaciones con su pivote;
  `armonizar` (`harmonize`) propone acordes para una melodía y, con octavas, escribe el coral; `realizar`
  (`realize`) escribe unos acordes a cuatro voces.

### Paquetes

- El repositorio tiene un `Package.swift` en la raíz, para usar el motor desde otro proyecto:
  `.package(url: "https://github.com/rododendro1/Tesela.git", branch: "main")`, con los productos `Armonia`
  (y uno por capa), `Hexagonos` y `ArmoniaUI`.
- `import Armonia` ya no reexporta `Hexagonos`: quien nombre sus tipos (`CoordenadaAxial`, `FormasDeMapa`,
  `DireccionHexagonal`…) escribe también `import Hexagonos`. Lo que devuelve el motor no cambia.

### La rejilla hexagonal

El motor depende ahora del paquete `Hexagonos` (rejillas hexagonales).

- `PuntoDelTonnetz.coordenada` y `PuntoDelTonnetz(_:)` pasan de un punto del Tonnetz a una `CoordenadaAxial` y
  de vuelta; `distancia(hasta:)` es la de la rejilla (el resultado no cambia).
- `Tonnetz.trazado(paso:)` y `TablaArmonica.trazado(paso:)` dicen dónde dibuja `svg()` cada nota, y
  `punto(en:paso:)`, qué nota hay bajo un punto del dibujo. Los dos dibujos colocan ya las notas con ellas (el SVG
  es el mismo, salvo algún `-0.0` que pasa a `0.0`). `TablaArmonica.coordenada(de:)` y `punto(de:)` traducen entre
  el Tonnetz y la rejilla de la tabla, que es la misma girada 120°.
- `TecladoIsomorfico`: teclados de botones hexagonales en los que cada dirección sube siempre el mismo intervalo
  (`.tablaArmonica`, `.wickiHayden`, `.janko` o cualquier otro), con la altura de cada casilla, las casillas de una
  altura y su dibujo en SVG.

### Tesela

- El ecosistema se llama Tesela: el repositorio es `rododendro1/Tesela`, el proyecto de
  Xcode, `Tesela.xcodeproj`, el paquete de la raíz, `Tesela`, y los identificadores de las apps empiezan por
  `es.solfa.tesela`. El motor no cambia.
- El paquete de la interfaz es `ArmoniaUI`.

### Nombres de tipos

Los nombres anteriores estuvieron marcados como obsoletos y ya se han quitado.

- `Tonnetz.Arista.Intervalo` pasa a `Tonnetz.Arista.Eje`, y la propiedad `intervalo` a `eje`: son los tres ejes de la
  red (quinta justa, tercera mayor y tercera menor), y el nombre tapaba a `Intervalo` dentro de `Tonnetz`.
- `TablaArmonica.Modo` pasa a `TablaArmonica.Colocacion`, y la propiedad `modo` a `colocacion`: dice cómo se colocaron
  las notas, y «modo» ya es `Tonalidad.Modo`.
- `Razon` pasa a `RazonDeFrecuencias`.

### Terminología

- `Digitacion.cifra` pasa a `tablatura` (el nombre anterior estuvo marcado como obsoleto y ya se ha quitado): «cifra» se
  confundía con el cifrado de los acordes.
- La transformación neorriemanniana P se llama «homónima» en `nombre`, no «paralela»: en español, Do mayor y Do menor
  son tonalidades homónimas, y «paralela» era un calco del inglés. El caso `.p` y la letra no cambian.
- `Tonnetz.disposicion(paso:)` y `TablaArmonica.disposicion(paso:)` pasan a `trazado(paso:)` y devuelven un
  `Trazado`, el nuevo nombre de `Disposicion` en `Hexagonos`. Los nombres anteriores estuvieron marcados como
  obsoletos y ya se han quitado.
- La documentación de `Digitacion.trastesPisados` decía que eran el más grave y el más agudo; son todos los que se
  pisan.

### Carpetas

- El objetivo de pruebas `ArmoniaPruebasExhaustivas` pasa a `ArmoniaExhaustivasTests`, como los demás
  (`swift test --filter "^ArmoniaExhaustivasTests\."`).
- El ejemplo pasa de `Apps/ArmoniaEjemplo` a `Ejemplos/ArmoniaEjemplo`: no es una app.
- Los scripts del motor (`comprobar_modulos.py`, `comprobar_catalogo.py`, `comprobar_enlaces_docc.py` y
  `generar_pruebas_de_documentacion.py`) pasan de `Packages/Armonia/Scripts/` al `Scripts/` de la raíz, junto a los
  demás, y se ejecutan desde la raíz del repositorio.

### La línea de comandos, en inglés de verdad

- Con `--ingles`, `armonia` ya no mezcla idiomas: la ayuda, los mensajes de uso («falta el cifrado…») y las
  etiquetas de la salida («pasos», el nombre del instrumento) salen en inglés. Los textos de la herramienta están en
  `Apps/ArmoniaCLI/Sources/ArmoniaCLI/Textos.swift`, cada uno en los dos idiomas, y `LineaDeComandos.ayuda(en:)`
  devuelve la ayuda en el idioma de la notación.
- `Encordado(nombre:)` acepta también «seven-string guitar», «drop D guitar» y «five-string bass».
- Nombres más claros en `armonia` (los de antes se aceptaron un tiempo y ya se han quitado):
  - `voces` pasa a `revisar` (*check*): busca faltas de conducción, y se confundía con `conduccion`.
  - `camino` pasa a `conduccion-parsimoniosa` (*smooth-path*): «camino» y *path* también nombraban la opción
    `--camino` y el alias inglés de `--recorrido` de `tonnetz` y `tabla`.
  - En `tonnetz` y `tabla`, `--recorrido` es *--sequence* en inglés (antes *--path*).
  - En `midi`, `--instrumento` pasa a `--programa` (*--program*): el instrumento es el de cuerda de `digitaciones`.
  - La inversión de un acorde se escribe con ordinal: «primera inversión» (*first inversion*), no «inversión 1».
- «opción desconocida» lleva siempre comillas: antes, según la orden, salía `--foo`, `«--foo»` o `foo`.

### Digitaciones: dedos, orden y ukelele

- **Dedos.** Nuevos `Digitacion.dedos` (los que hacen falta, como mínimo) y `Digitacion.cejilla` (el traste de la
  cejilla, si la forma la lleva): cada nota pisada pide un dedo, salvo en el traste más bajo, donde el índice pisa
  varias cuerdas a la vez si son seguidas o abarcan cuatro o más. `Mastil.digitaciones` tiene un parámetro nuevo,
  `maximoDeDedos` (4 por defecto). **Cambia el resultado por defecto**: antes se devolvían formas que no se pueden
  tocar (con un modelo de dedos, el 19 % de las de una batería de 32 acordes necesitaba más de cuatro).
- **Orden.** Ya no es «menos abertura, más cuerdas, más cerca de la cejilla», que ponía `8-10-10-0-8-0` por delante de
  `x32010`. Ahora es un coste de comodidad (un punto por traste de posición, dedo y traste de abertura; dos por cuerda
  apagada; uno si falta la quinta de un acorde de cuatro notas o más), y a igual coste, antes la de más cuerdas. En una
  batería de 32 acordes de guitarra, la forma de manual pasa de ser la primera en 16 a serlo en 21 (22 con la quinta
  opcional), y de estar entre las tres primeras en 20 a 30 (31); en una de 10 acordes de ukelele, de 4 a 9 primeras.
  Las cifras salen de una réplica en Python del algoritmo (`TrastesTests` comprueba las mismas formas en Swift).
- **Ukelele y reentrantes.** Nuevo `Encordado.esReentrante`. En esos instrumentos, un acorde en estado fundamental ya
  no exige la raíz en la nota más grave (la cuerda de Do suena más grave que la de Sol): antes no aparecían ni el Sol
  `0232`, ni el Fa `2010`, ni el La menor `2000`. Un acorde con bajo propio (`Do/Mi`) sigue exigiéndolo.
- La quinta sigue siendo obligatoria por defecto (`exigirQuinta: true`); la línea de comandos y la aplicación la piden
  opcional, como se toca (el Do7 de manual, `x32310`, no la tiene).
- Corregido un `guard let` que redeclaraba una variable del mismo ámbito en `digitaciones` (no compilaba).

### Plataformas y entradas inválidas

- `Armonia` declara `platforms: [.macOS(.v13), .iOS(.v16)]`, como las apps y `ArmoniaUI`. `ArmoniaCLI` y `ArmoniaEjemplo`
  declaran macOS 13: SwiftPM rechaza que un paquete con un mínimo más bajo dependa de uno con un mínimo más alto.
- Nuevos inicializadores que devuelven `nil` en vez de detener el programa: `Duracion(comprobando:_:)` y
  `Duracion(comprobando:puntillos:)` (denominador 0; puntillos fuera de 0…30), `Compas(comprobando:_:agrupacion:)` y
  `Tempo(comprobando:unidad:)`. Los inicializadores de siempre siguen deteniendo el programa ante un error de
  quien llama, y ahora lo dicen en su documentación. `BaseDeHewlett(alteracionMaxima:)` toma un número negativo como 0.
- MusicXML y MIDI solo se exportan (no se leen), y los analizadores de texto validan: hoy ningún dato de entrada puede
  llegar a esas precondiciones.

### Renombrado

- El paquete `ArmoniaMusical` pasa a llamarse `Armonia` (carpeta `Packages/Armonia`), como su producto principal y su
  módulo paraguas. `import Armonia` no cambia; en un `Package.swift` ahora es
  `.package(path: "…/Packages/Armonia")` y `.product(name: "Armonia", package: "Armonia")`. En Xcode, el esquema de todo
  el paquete pasa de `ArmoniaMusical-Package` a `Armonia-Package`.
- `Apps/LineaDeComandos` pasa a `Apps/ArmoniaCLI`: el paquete, su biblioteca (antes `ArmoniaLineaDeComandos`, ahora
  `ArmoniaCLI`) y sus pruebas (`ArmoniaCLITests`). El ejecutable sigue siendo `armonia`, y el tipo `LineaDeComandos`
  conserva su nombre.
- `Apps/EjemploArmonia` pasa a `Apps/ArmoniaEjemplo` (`swift run ArmoniaEjemplo`).
- Las entradas anteriores de este registro conservan los nombres de su época.

### Eliminado

- Los nombres anteriores de la API, que llevaban una versión marcados como obsoletos (`Armonia/Obsoletos.swift`):
  `quintas`, `octavas`, `quintasConSigno`, `octavasConSigno` y `NotaNatural.quintasBase`, los inicializadores
  `(quintas:octavas:)` y `TipoDeAcorde(quintas:)`/`(comprobandoQuintas:)`, `simpleAscendente(quintas:)`,
  `EstructuraDeAcorde.quintas`, `Altura.octavaCientifica`, `TipoDeAcorde.quinta`, `CalidadDeTriada.quinta`,
  `Intervalo.quinta`, `NombreDeGrado.submediante`, `Intervalo.oncena`/`oncenaAumentada`/`trecenaMenor`/`trecenaMayor`
  y `TipoDeAcorde.dominanteOncena`/`menorSeptimaOncena`/`dominanteTrecena`. Cada uno tiene su equivalente nuevo en la
  tabla de «Nombres nuevos», más abajo. Al leer texto se siguen aceptando «oncena», «trecena» y «submediante».
  `PuntoDelTonnetz.quintas` no cambia: es otra cosa.
- Los dos tests que solo comprobaban que esos alias seguían funcionando, y `Obsoletos.swift` como fichero permitido en
  el módulo paraguas (`Scripts/comprobar_modulos.py`).

### Mástil y digitaciones

- `Mastil(_:trastes:)` toma un número negativo de trastes como 0 en vez de detener el programa.
- Nuevos `Mastil.midiSiExiste(en:)` y `alturaSiExiste(en:preferirBemoles:)`, que devuelven `nil` para una posición
  que no está en el mástil. `midi(en:)` y `altura(en:)` siguen deteniendo el programa en ese caso (error de quien
  llama); ahora lo dicen en su documentación y remiten a las nuevas.
- Nuevos `Digitacion.init?(comprobando:en:)` e `init?(leyendo:en:)` (lee la cifra de `cifra`: «x32010»,
  «x-10-12-12-11-10»), que devuelven `nil` si los trastes no encajan en el mástil. `Digitacion(mastil:trastes:)`
  sigue deteniendo el programa si no hay un traste por cuerda.
- Nuevo `Digitacion.notas(para:)`: las notas que suenan, escritas como las escribe el acorde (Si♭, no La♯).
- Nuevo `Encordado(nombre:)`: busca un instrumento por su nombre, sin tildes ni mayúsculas («ukulele», «drop D»,
  «bajo de 5 cuerdas», «bass»…).
- Nuevo artículo de DocC, `Trastes`, con sus ejemplos entre las pruebas de documentación.
- Corregido un cierre de `Digitacion.digitaciones` que no compilaba (`$0` dentro de un cierre con parámetros
  explícitos).

### Herramientas

- Nuevo `Scripts/comprobar_enlaces_docc.py` (lo ejecuta el CI): los enlaces ``Tipo`` y `<doc:Articulo>` del
  catálogo apuntan a algo que existe. Y, en la raíz, `Scripts/comprobar_higiene.py`: sin caracteres invisibles,
  tabuladores ni espacios al final, scripts ejecutables que compilan.
- Nuevo `Scripts/compilar_todo.sh` (en la raíz del repositorio): compila y prueba por capas, módulo a módulo
  en el orden de sus dependencias, con un log por paso.
- La herramienta de línea de comandos tiene una orden nueva, `armonia digitaciones`
  (`--instrumento`, `--limite`, `--traste`, `--dedos`, `--completo`, `--tab`), que indica los dedos y la cejilla de
  cada forma.
- `Scripts/comprobar_higiene.py` detecta además un `guard let x` que redeclara un `let x` del mismo ámbito.

### Organización interna (la API pública no cambia)

- La carpeta del ejecutable pasa de `Sources/armonia` a `Sources/ArmoniaEjecutable`: en sistemas de
  ficheros que no distinguen mayúsculas (macOS, Windows) chocaba con `Sources/Armonia`. El producto
  sigue llamándose `armonia` (`swift run armonia`). El CI comprueba que ninguna ruta del
  repositorio se repita al ignorar mayúsculas.
- Los catálogos de escalas se reparten en un fichero por tradición (`Escalas/Tradiciones/`) y por
  tema (`Escalas/Occidentales/`). Los tipos y sus nombres son los mismos y `todos` conserva el orden
  (del que depende qué escala gana al identificar).
- Nuevo `Scripts/comprobar_catalogo.py`, que el CI ejecuta: falla si una escala declarada no está en
  `todos` ni en una lista de tradición, si una lista repite una escala, o si una escala de `todos` no
  tiene nombre inglés en `internacionales`.
- La herramienta de línea de comandos se reparte en una extensión por grupo de órdenes
  (`LineaDeComandos+Consultas`, `+Partituras`, `+Dibujos`, `+Neorriemann`).
- `ConduccionDeVoces` pasa de `Partitura/` a `Tonalidad/`, y `Neorriemann/` (transformaciones, ciclos
  y conducción parsimoniosa) de `Acordes/` a `Representaciones/`, junto al Tonnetz del que depende.
  Las extensiones de `Candidato` para `Acorde` y `Tonalidad` pasan a las carpetas de esos tipos.
- `Texto/Idiomas.swift` conserva los nombres de los tipos del núcleo; los de `Tonalidad`, `PapelEnAcorde`,
  `CalidadDeTriada`, `NombreDeGrado`, `Clave`, `Figura`, `Duracion` y `CorrespondenciaDeColores` pasan a
  un fichero `X+Idiomas.swift` junto a cada tipo, de modo que el núcleo ya no depende de las capas
  superiores. Para añadir un idioma, el compilador señala los `switch` sobre `idioma` que falten.
- La biblioteca se reparte en módulos por capas, y `Armonia` los reexporta: `ArmoniaNucleo`
  (Fundamentos, Texto, Postonal), `ArmoniaTeoria` (Acordes, Escalas, Tonalidad), `ArmoniaRepresentaciones`
  `ArmoniaPartitura` y `ArmoniaTrastes`. `import Armonia` da la misma API pública que antes, y cada capa es también un producto
  (`import ArmoniaTeoria`). Lo que era interno y se usa entre capas pasa a `package`: no se añade a la API pública.
  El paquete se llama ahora `ArmoniaMusical`; el producto y el módulo `Armonia` no cambian.
- La herramienta de línea de comandos (`armonia`, con sus pruebas) y `EjemploArmonia` salen del paquete a
  `Apps/LineaDeComandos` y `Apps/EjemploArmonia`, cada uno con su `Package.swift`. El paquete queda solo con la
  biblioteca; `swift run armonia` y `swift run EjemploArmonia` se ejecutan ahora desde esas carpetas.
- Nuevo módulo `ArmoniaTrastes` (y producto del mismo nombre), reexportado por `Armonia`: `Encordado` (guitarra, bajo,
  ukelele, mandolina…), `Mastil` con `Posicion` (dónde suena una nota o una escala) y `Digitacion` (formas de tocar un
  acorde, con `Mastil.digitaciones(de:)`). Depende de `ArmoniaNucleo` y `ArmoniaTeoria`, como Representaciones y Partitura.
- `Scripts/comprobar_capas.py` se sustituye por `Scripts/comprobar_modulos.py`, que el CI ejecuta: comprueba las
  dependencias declaradas en `Package.swift`, las importaciones y los tipos que cada módulo usa de los demás.
- Nuevo `Scripts/comprobar_catalogo.py`, que el CI ejecuta: falla si una escala declarada no está en
  `todos` ni en una lista de tradición, si una lista repite una escala, o si una escala de `todos` no
  tiene nombre inglés en `internacionales`.
- `Partitura/` se divide en `Modelo/` y `Formatos/`, y `Representaciones/` en `Afinacion/`, `Color/`, `Reticulos/` y
  `Dibujo/`. `Escalas/TipoDeEscala.swift` se reparte en cuatro ficheros. Solo se mueve texto: ningún tipo ni nombre cambia.

## Versión 5

Probada en Linux con Swift 5.9, 5.10, 6.0 y 6.1 (y concurrencia estricta en Swift 6).

### Para actualizar desde la versión 4

Casi todo lo que cambia de nombre sigue compilando: los nombres antiguos están en
`Sources/Armonia/Obsoletos.swift`, marcados como obsoletos, y el compilador avisa y propone el
nombre nuevo (Xcode lo cambia con un clic). Desaparecerán en la próxima versión.

Hay dos cambios que **no avisan** y conviene revisar a mano:

1. **`print` de una `Duracion` da su nombre.** `"\(Duracion(.negra, puntillos: 1))"` era `"4."`
   y ahora es `"negra con puntillo"` (la duración nula es `"cero"`). Si usabas la descripción para
   escribir ritmos que luego se leen, usa `duracion.texto`, que sigue dando `"4."` y `"5/8"`.
2. **El inicializador opcional desde texto se llama `init?(texto:)`.** En la versión 4 era
   `init?(_:)`, pero por SE-0213 `Acorde("Sol7")` con un literal nunca lo usaba (crea el valor
   directamente, sin opcional), y con una variable no compilaba. Ahora:
   - con un literal: `Acorde("Sol7")` o `let a: Acorde = "Sol7"`, sin cambios;
   - con texto del usuario: `Acorde(texto: entrada)` devuelve `nil` si no se puede leer;
   - para saber por qué no se puede leer: `try Acorde(leyendo: entrada)`.

### Nombres nuevos

| Antes | Ahora |
|---|---|
| `Nota.quintas`, `Altura.quintas`, `Intervalo.quintas`, `Alteracion.quintas` | `pasosDeQuinta` |
| `Altura.octavas`, `Intervalo.octavas` | `pasosDeOctava` |
| `Nota(quintas:)`, `Altura(quintas:octavas:)`, `Intervalo(quintas:octavas:direccion:)` | `(pasosDeQuinta:pasosDeOctava:…)` |
| `quintasConSigno`, `octavasConSigno` | `pasosDeQuintaConSigno`, `pasosDeOctavaConSigno` |
| `NotaNatural.quintasBase` | `pasosDeQuintaBase` |
| `Intervalo.simpleAscendente(quintas:)` | `simpleAscendente(pasosDeQuinta:)` |
| `TipoDeAcorde.quintas`, `TipoDeAcorde(quintas:)`, `TipoDeAcorde(comprobandoQuintas:)` | `pasosDeQuinta`, `(pasosDeQuinta:)`, `(comprobandoPasosDeQuinta:)` |
| `EstructuraDeAcorde.quintas` | `quintasDelAcorde` |
| `Altura.octavaCientifica` | `octava` (como en `Altura(.do, octava: 4)`) |
| `TipoDeAcorde.quinta`, `CalidadDeTriada.quinta` (acorde de potencia) | `potencia` |
| `Intervalo.oncena`, `oncenaAumentada`, `trecenaMenor`, `trecenaMayor` | `undecima`, `undecimaAumentada`, `decimoterceraMenor`, `decimoterceraMayor` |
| `TipoDeAcorde.dominanteOncena`, `menorSeptimaOncena`, `dominanteTrecena` | `dominanteUndecima`, `menorSeptimaUndecima`, `dominanteDecimotercera` |
| `Intervalo.quinta` | `quintaJusta` |
| `NombreDeGrado.submediante` | `superdominante` |

Al leer texto se siguen aceptando «oncena», «trecena» y «submediante».

Los nombres que escribe la biblioteca también cambian: el papel en el acorde es «undécima» y
«decimotercera» (antes «oncena» y «trecena»), y los tipos de acorde, «undécima», «menor
undécima», «decimotercera» y «menor decimotercera».

### Correcciones

- El paquete no compilaba: los inicializadores opcionales desde texto chocaban con los literales
  (SE-0213), había dos `switch` sobre opcionales en `EstructuraDeAcorde` que el compilador rechazaba y una
  expresión en `Escala.alturas` que el compilador no podía resolver.
- `TipoDeEscala.melakartasCompatibles` comparaba semitonos y aceptaba escalas con otra ortografía;
  ahora compara las notas.
- La identificación de acordes ya no propone lecturas sin tercera, sin suspensión y sin quinta.
- Los cifrados con paréntesis anidados, sin cerrar o cerrados de más (`Do7((b9))`, `Do7(b9`,
  `Do7)`) se rechazan con un error en lugar de leerse a medias.
- No se mezclan idiomas: la tónica en español va con el tipo en español («Re dórico», «D dorian»,
  pero no «Re dorian»), y el bajo de un acorde se escribe como su fundamental («Sol7/Si», «G7/B»,
  pero no «Sol7/B»).

### Novedades

- **Análisis de progresiones**: `AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")` da
  «I–vi–V7/V–V7–I en Do mayor», con la función de cada acorde (tónica, subdominante, dominante)
  y su categoría: diatónico, dominante o sensible secundaria, napolitana, préstamo del modo
  homónimo o cromático. Cifra las inversiones (I6, V65) y, si no se le da, elige la tonalidad.
  La sexta añadida se cifra «iii(add6)», para no confundirla con la primera inversión, y los
  acordes invertidos que no son tríadas ni séptimas llevan los intervalos sobre el bajo
  («IV(add6)643»). Reconoce las sextas aumentadas italiana, francesa y alemana («It+6», «Fr+6»,
  «Ger+6»), escritas desde el ♭6̂ (`La♭(♯6)`), desde otra nota (`Re7(♭5)/La♭`) o, la alemana,
  como séptima de dominante que va a la dominante (`La♭7`), y la napolitana invertida («♭II6»,
  «♭II64»). Al leer la progresión, las comas de dentro de un paréntesis son del cifrado.
  También `tonalidad.analizar(acordes)` para una tonalidad conocida.
- **Conducción de voces**: `ConduccionDeVoces(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5").problemas`
  señala quintas y octavas paralelas y directas, cruces, superposiciones, separación excesiva,
  saltos no melódicos y notas fuera de tesitura, con las voces y los acordes donde ocurren.
- **Exportación a MusicXML**: `voz.musicXML(tonalidad:clave:tempo:titulo:)` escribe una melodía
  (con ligaduras, barras, puntillos, tresillos y demás grupos irregulares, anacrusa, armadura,
  clave y tempo) y `conduccion.musicXML(duracion:compas:)`, un coral a cuatro voces en dos
  pentagramas, y `analisis.musicXML()`, una progresión con los cifrados americanos encima (como
  símbolos de acorde que el editor reconoce) y el cifrado romano y la función debajo; el coral
  también puede llevarlos (`cifrados: true, analisis: true`). Los documentos se validan con el esquema oficial de MusicXML 4.0 y se abren en
  MuseScore, Finale, Sibelius o Dorico. Desde la terminal, `armonia musicxml melodia …` y
  `armonia musicxml coral …` y `armonia musicxml acordes Do Lam Re7 Sol7 Do`.
- **Exportación a MIDI**: `voz.midi(tempo:titulo:instrumento:)`, `coral.midi(duracion:)` y
  `analisis.midi()` escriben ficheros MIDI estándar (formato 1) para oír melodías, corales y
  progresiones: tempo, compás, armadura, una pista por voz con su nombre e instrumento General
  MIDI, ligaduras como una sola nota, grupos irregulares exactos y un marcador por acorde con su
  cifrado. Desde la terminal, `armonia midi melodia|coral|acordes … > fichero.mid`.
- **Grafía de las figuras con puntillo**: `voz.grafia` (y con ella el MusicXML) escribe entera la
  figura con puntillo que empieza en un pulso de un compás simple, sin ocultar la mitad del 4/4:
  la negra con puntillo del 1.er o del 3.er tiempo ya no sale como negra ligada a corchea. En 6/8
  no se cruza el grupo de tres corcheas. En los compases de amalgama (5/8, 7/8, 3+2+2/8) no se
  oculta el paso entre grupos de distinto tamaño (el 7/8 entero es blanca ligada a negra con
  puntillo), y el silencio de todo un compás queda entero.
- **Herramienta de línea de comandos `armonia`**: `armonia acorde Sol7/Si`, `armonia identificar
  Do Mi Sol Sib`, `armonia intervalo Do4 Mi5`, `armonia escala Re dórico`, `armonia tonalidad
  La menor`, `armonia analizar Do Lam Re7 Sol7 Do` y `armonia voces …`; con `--ingles`, en
  notación inglesa.
- **Más escalas occidentales** en `TipoDeEscala.todos`: los seis modos de la mayor armónica
  (dórico ♭5, frigio ♭4, lidio ♭3, mixolidio ♭2, lidio aumentado ♯2, locrio ♭♭7), doble
  armónica, menor y mayor húngaras, napolitanas menor y mayor, enigmática, persa, mayor locria,
  lidio menor, Prometeo, disminuida semitono-tono, aumentada, blues mayor, egipcia, cromática,
  flamenca, Petrushka, bebop menor melódica y menor armónica, los modos 3 a 7 de Messiaen, los
  modos de la doble armónica y de las napolitanas, cuatro pentatónicas del jazz (dominante,
  menor 6, mayor ♭6 y menor ♭5), la blues de nueve notas, la blues menor con 2ª y el hexacordo,
  la argelina, con sus nombres en inglés. `Escala.identificar` y `rotacion` las tienen en cuenta: el modo 2
  de la pentatónica mayor es ahora la egipcia. Más nombres para las que ya estaban: acústica o
  de Bartók, menor rumana, dominante ♭9 ♭13, mayor melódica, gitana española, Tcherepnin (modo 3 de
  Messiaen) y las auxiliares de la cromática lidia de Russell.
- **Escalas chinas y japonesas**: los cinco modos pentatónicos chinos (Gōng, Shāng, Jué, Zhǐ,
  Yǔ) y las escalas Qīngyuè, Yǎyuè y Yànyuè; las japonesas Ritsu, Ryo, Yō, Min'yō, Miyakobushi,
  In, Insen, Iwato, Hirajōshi, Kumoijōshi y Ryūkyū. Los nombres llevan sus diacríticos (tonos
  del pinyin, macrones del Hepburn) y se leen también sin ellos y en chino o japonés:
  `Escala("Do hirajoshi")`, `Escala("Do 平調子")`. También Akebono y Kokin-jōshi.
- **Escalas etíopes, maqamat, de Indonesia y klezmer** (en `TipoDeEscala.tradicionales`): los
  qenet Təzəta, Bati, Ambassäl y Ančihoye; los maqamat temperados Ḥijāz, Nahāwand, Kurd, ʿAjam,
  Ḥijāzkār y Nawā Athar; Pélog selisir y Sléndro, aproximadas; y los modos klezmer Freygish,
  Misheberakh, Adonai Malakh y Magen Avot. Con su transliteración y diacríticos, y sin ellos
  como alias. Al buscar por nombre, un nombre gana a un alias: «Hijaz» es ahora el maqam Ḥijāz
  (el dromos sigue siendo Hitzáz o Hicaz; las notas son las mismas).
- **Más escalas de otras tradiciones** (en `TipoDeEscala.tradicionales`): ragas indostánicos
  (Bhūpālī, Mālkauns, Durgā, Śivarañjanī, Kalāvatī, Candrakauns, Megh, Yaman, Bāgeśrī y Deś), los
  janya Revati y Amṛtavarṣiṇī, los dastgāh Māhur, Homāyun y Čahārgāh (estos dos, aproximados),
  las coreanas P'yŏngjo y Kyemyŏnjo, la pentatónica y la tritónica andinas, y los tetracordos y
  harmoniai de la Grecia antigua (diatónicos y cromáticos).
- **Más escalas occidentales** en `TipoDeEscala.todos`: los modos de la mayor húngara
  (ultralocrio ♭♭6, menor armónica ♭5, superlocrio ♮6, menor melódica ♯5, dórico ♭2 ♯4, lidio
  aumentado ♯3), las hexatónicas gaélicas (jónico sin 4ª, mixolidio sin 3ª, dórico sin 6ª, eólico
  sin 2ª), las hexatónicas mayor y menor de dos tríadas, las pentatónicas mixolidia, lidia y
  escocesa, y la mayor rumana. Al identificar Do Mi Sol Si Fa♯, la primera es ahora Do
  pentatónica lidia, que tiene exactamente esas notas, y la segunda, Sol mayor. Más nombres:
  nordestina (lidio dominante) y los de compositor (de Liszt, de Rimski-Kórsakov, de Debussy, de
  Weitzmann).
- **`ModoGregoriano`**: los ocho modos del canto gregoriano con su final, su tenor y su ámbito:
  `ModoGregoriano(2)` es el protus plagal o hipodórico (final Re, tenor Fa, ámbito La3–La4), y
  también se busca por nombre: `ModoGregoriano(nombre: "hipofrigio")`.
- **Tonnetz**: `Tonnetz(acorde)`, `Tonnetz(escala)`, `Tonnetz(notas)` o `Tonnetz(conjunto)`
  colocan las notas en la red de quintas y terceras, en la disposición más compacta (se prueban
  todas), conservando la
  ortografía (Fa♯ y Sol♭ caen en puntos distintos); `triadas` da los triángulos mayores y menores
  completos y `svg()` dibuja la red. Desde la terminal, `armonia tonnetz --acorde Domaj7`.
- **Transformaciones neorriemannianas**: `Acorde("Do").transformar(.r)` da Lam, y
  `transformar(leyendo: "PLR")` aplica una secuencia (también N, S y H), conservando la
  ortografía. `Tonnetz.camino(desde: "Do", hasta: "Mibm")` da el camino más corto ([P, R, P]) y
  `Tonnetz(recorrido: ["Do", "Lam", "Fa"])` dibuja una progresión con flechas de triángulo a
  triángulo (curvas y separadas cuando el recorrido va y vuelve). Los ciclos hexatónico,
  octatónico y LR (`Acorde("Do").ciclo(.hexatonico)`, `Tonnetz(ciclo:desde:)`) se escriben con la
  ortografía más sencilla y se dibujan como una banda de triángulos. Desde la terminal, `armonia plr Do PLR`, `armonia plr Do Mibm`,
  `armonia plr Do hexatonico` y `armonia tonnetz --recorrido Do Lam Rem Sol Do`.
- **Conducción parsimoniosa**: `Acorde("Sol7").vecinosParsimoniosos()` da los acordes a un
  semitono (Sol♯°7, Solm7, Mim7) entre séptimas de dominante, menores, semidisminuidas y
  disminuidas (las «Power Towers» de Douthett y Steinbach) o entre tríadas mayores, menores y
  aumentadas (el «Cube Dance»); con `voces: 2`, moviendo dos voces (Sol7 → Re♭7). Los maj7
  tienen su propia familia, `familiaDeSeptimasAmpliada` (las «Power Towers» con maj7): Domaj7
  pasa a Do7 y a Do♯ø7.
  `Tonnetz.caminoParsimonioso(desde:hasta:)` da el camino más corto y
  `conduccionMinima(hasta:)`, la conducción con menos semitonos entre acordes cualesquiera
  (Sol7 → Do: 4). Desde la terminal, `armonia vecinos`, `armonia camino` y `armonia conduccion`.
- **Título y leyenda en los dibujos**: los SVG del Tonnetz y de la tabla armónica llevan
  encima el acorde, la escala o la progresión, y debajo una leyenda con lo que aparece (notas,
  tríadas mayores y menores, intervalos, contorno, tónica o fundamental, pasos del recorrido), en
  español o en inglés. `svg(titulo:leyenda:)` los cambia o los quita.
- **Tabla armónica**: `TablaArmonica` coloca notas, acordes, escalas, conjuntos de clases de altura
  o alturas en la disposición en hexágonos de los teclados isomórficos (quinta hacia arriba,
  terceras en diagonal) y `svg()` la dibuja con el contorno de la forma y un punto en cada tríada.
  Con alturas, cada hexágono es una altura concreta, como en el instrumento. También dibuja
  recorridos de tríadas con flechas (`TablaArmonica(recorrido:)`, `TablaArmonica(caminoDesde:hasta:)`)
  y ciclos neorriemannianos (`TablaArmonica(ciclo:desde:)`).
  Desde la terminal, `armonia tabla --acorde Domaj7`, `armonia tabla Do3 Sol3 Mi4`,
  `armonia tabla --recorrido Do Lam Fa Rem` o `armonia tabla --ciclo octatonico Do`.
- **Portugués**: nombres de notas (dó, ré, mi, fá…), alteraciones («sustenido», «bemol», «duplo
  sustenido»…) y modos («maior», «menor»).
- **Errores en inglés**: `ErrorDeLectura` explica el error en inglés cuando se lee con una
  notación inglesa (`descripcion(en:)`), y sus motivos son tipos concretos
  (`ErrorDeLectura.RechazoDeAcorde`, `CalidadesIncompatibles`) en lugar de texto.
- **Pruebas de la documentación**: `Scripts/generar_pruebas_de_documentacion.py` convierte los
  ejemplos del README y del catálogo DocC en pruebas que comprueban el resultado escrito en cada
  comentario. El CI comprueba que estén al día (`--comprobar`).
- **Pruebas nuevas**: ida y vuelta al azar en todas las notaciones (con semilla fija), casos que
  se deben rechazar y nombres obsoletos.
