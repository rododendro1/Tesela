# Escalas

Tipos de escala, modos, escalas que suben y bajan distinto, arpegios, escalas sobre un acorde y cómo se
estudia una escala. Las de otras tradiciones están en <doc:EscalasDelMundo>.

## Más escalas y tonalidades

- Modos de la menor armónica (locrio ♮6, jónico ♯5, dórico ♯4, frigio dominante,
  lidio ♯2, ultralocrio) y de la melódica (dórico ♭2, lidio aumentado, lidio dominante,
  mixolidio ♭6, locrio ♮2, alterada), la mayor armónica y sus modos (dórico ♭5, frigio ♭4,
  lidio ♭3, mixolidio ♭2, lidio aumentado ♯2, locrio ♭♭7) y cinco escalas bebop (dominante,
  mayor, dórica, menor melódica y menor armónica).
- Escalas de colores «exóticos»: doble armónica (bizantina), menor y mayor húngaras,
  napolitanas menor y mayor, enigmática (Verdi), persa, mayor locria (árabe), lidio menor y
  Prometeo (Skriabin).
- Simétricas y otras: disminuida semitono-tono (además de la tono-semitono), aumentada, blues
  mayor, egipcia (pentatónica suspendida), Petrushka (dos acordes mayores a un tritono) y
  cromática. Los modos de Messiaen 1 y 2 se leen como tonos enteros y disminuida
  semitono-tono, y del 3 al 7 tienen tipo propio (el 3 es también la escala de nueve notas de
  Tcherepnin).
- La escala flamenca o andaluza: el frigio con la tercera mayor y la menor, de ocho notas.
- Los modos de la doble armónica (lidio ♯2 ♯6, ultrafrigio, menor húngara, oriental,
  jónico ♯2 ♯5, locrio ♭♭3 ♭♭7), de la napolitana mayor (lidio aumentado ♯6 o tonos enteros
  con sensible, lidio dominante aumentado, lidio menor, mayor locria, locrio ♮2 ♭4,
  superlocrio ♭♭3) y de la napolitana menor (lidio ♯6, mixolidio aumentado, eólico ♯4 o
  gitana húngara, locrio dominante, jónico ♯2, ultralocrio ♭♭3).
- Los modos de la mayor húngara: ultralocrio ♭♭6, menor armónica ♭5, superlocrio ♮6 (la
  alterada con 6ª mayor), menor melódica ♯5, dórico ♭2 ♯4 y lidio aumentado ♯3.
- La mayor rumana (Do Re♭ Mi Fa♯ Sol La Si♭), del folclore balcánico.
- Pentatónicas del jazz: dominante, menor 6 (dórica), mayor ♭6 (de Coltrane) y menor ♭5; la
  mixolidia (Do Mi Fa Sol Si♭), la lidia (Do Mi Fa♯ Sol Si) y la escocesa (Do Re Fa Sol La, la
  pentatónica mayor desde su 4.º grado); la blues de nueve notas y la blues menor con 2ª.
- Hexatónicas gaélicas, los modos con un hueco de la música escocesa e irlandesa: jónico sin 4ª,
  mixolidio sin 3ª, dórico sin 6ª y eólico sin 2ª. Y las de dos tríadas, mayores a un tono
  (Do + Re: Do Re Mi Fa♯ Sol La) o menores (Rem + Mim: Re Mi Fa Sol La Si).
- El hexacordo de Guido (ut re mi fa sol la), con `Escala.hexacordoNatural` (Do),
  `hexacordoDuro` (Sol) y `hexacordoBlando` (Fa).
- La argelina, de ocho notas: la menor húngara con la 4ª justa además de la aumentada.
- Otros nombres de escalas que ya estaban: acústica o de Bartók (lidio dominante), menor
  rumana (dórico ♯4), dominante ♭9 ♭13 (frigio dominante), mayor melódica (mixolidio ♭6),
  gitana española (flamenca), nordestina (lidio dominante, la del baião), las que llevan el
  nombre de quien las popularizó (de Liszt = menor húngara, de Rimski-Kórsakov = disminuida
  semitono-tono, de Debussy = tonos enteros, de Weitzmann = aumentada) y las
  auxiliares de la cromática lidia de George Russell (aumentada auxiliar = tonos enteros,
  disminuida auxiliar = disminuida, disminuida auxiliar blues = semitono-tono). La cromática
  lidia en sí tiene las doce notas: es la cromática ordenada por quintas. Y los de los conservatorios
  españoles: menor bachiana o de Bach (menor melódica de jazz, la que sube y baja igual), menor dórica
  (dórico) y menor antigua (menor natural).
- Todas se leen también en inglés ("E phrygian dominant", "G altered", "A hungarian minor").

```swift
Escala(.do, .dobleArmonica).notas      // Do Re♭ Mi Fa Sol La♭ Si
Escala("Do enigmática").notas          // Do Re♭ Mi Fa♯ Sol♯ La♯ Si
Escala("La menor húngara").nombre(en: .ascii(.ingles))   // "A hungarian minor"
TipoDeEscala.mayorArmonica.modo(grado: 4).nombre    // "lidio ♭3"
TipoDeEscala.dobleArmonica == .hitzazkiar        // true
Escala("Mi flamenca").notas                      // Mi Fa Sol Sol♯ La Si Do Re
Escala("Do modo 3 de Messiaen").notas            // Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si
Escala("Re menor rumana").tipo.nombre            // "dórico ♯4"
TipoDeEscala.dobleArmonica.modo(grado: 5).nombre    // "oriental"
Escala.hexacordoBlando.notas                     // Fa Sol La Si♭ Do Re
TipoDeEscala.mayorHungara.modo(grado: 4).nombre     // "superlocrio ♮6"
Escala("Do pentatónica escocesa").notas          // Do Re Fa Sol La
Escala("La de Liszt").tipo.nombre                // "menor húngara"
Escala("Do menor bachiana").notas                // Do Re Mi♭ Fa Sol La Si
```
- `Escala.candidatos(notas:)` y `candidatos(clasesDeAltura:)`: qué escalas contienen unas notas, de más a menos
  probable (menos notas sobrantes y menos alteraciones); `identificar` da solo las escalas.
- `notasDeLaArmadura` (Mi♭ mayor → Si♭, Mi♭, La♭), `Escala(armadura:tipo:)`,
  `circuloDeQuintas(_:)`, `distancia(hasta:)` y `enarmonicaMasSimple` (Do♯ → Re♭ mayor),
  también para los modos. Para las relaciones entre tonalidades, mira `Tonalidad`.
- `nombreDeGrado(_:)` y `nombreDeGrado(de:)`: tónica, supertónica… sensible o subtónica.

## Cromáticas por ventana de quintas

Una escala cromática escrita son doce quintas seguidas de la línea de quintas, contadas desde la
tónica (Fa = −1, Do = 0, Sol = 1): doce quintas seguidas dan las doce clases de altura sin repetir
ninguna. Para que la escala mayor de la tónica quede dentro, la ventana empieza entre −6 y −1, así
que hay seis. Cada una cambia una nota de la anterior de bemol a sostenido, por el orden de la
línea de quintas: Sol♭ → Fa♯, Re♭ → Do♯, La♭ → Sol♯, Mi♭ → Re♯ y Si♭ → La♯.

| Ventana | Tipo | En Do |
|---|---|---|
| −6…5 | `cromaticaConCincoBemoles` | Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si |
| −5…6 | `cromatica` (`cromaticaConCuatroBemoles`) | Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si |
| −4…7 | `cromaticaConTresBemoles` | Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si |
| −3…8 | `cromaticaConDosBemoles` | Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si |
| −2…9 | `cromaticaConUnBemol` | Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si |
| −1…10 | `cromaticaConCincoSostenidos` | Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si |

Se nombran por sus bemoles, porque los sostenidos son siempre los que faltan hasta cinco. Se leen
por el nombre, en cada idioma, o por la ventana («cromática −3…8», «cromatica -3..8»). Como se
cuentan desde la tónica, en Re la primera empieza Re Mi♭ y la última, Re Re♯. Con una de ellas,
cada clase de altura se escribe como dice su ventana. `cromatica(ventana:)` da la de una
`VentanaDeQuintas` leída desde Do: `.bemoles` es la de cinco bemoles; `.masSimple`, `cromatica`, y
`.sostenidos`, la de cinco sostenidos:

```swift
TipoDeEscala.cromaticasPorQuintas.count                     // 6
TipoDeEscala.cromatica(ventana: .masSimple) == TipoDeEscala.cromatica   // true
Escala(.re, .cromaticaConCincoSostenidos).notas             // Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯
Escala("Do cromática con dos bemoles").notas                // Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si
Escala("Do cromatica -6..5").tipo.nombre                    // "cromática con cinco bemoles"
Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10)   // La♯
```

## Clásica, jazz, blues: el estilo de una escala

Las notas no dicen de qué música es una escala: la menor melódica de jazz es la «bachiana» de los conservatorios, y
el lidio dominante es la acústica de Bartók. Lo dice el estilo, y `TipoDeEscala.estilos` lo da para cada escala de
`todos`, con uno o varios `Estilo` de la tradición occidental:

- **clásica**: la escala da la tonalidad y de ella sale la armonía (la mayor, las menores, los modos, las
  napolitanas, la cromática, el hexacordo).
- **jazz**: la escala se elige acorde a acorde (los modos de la menor melódica, las bebop, las disminuidas, las
  pentatónicas del jazz y las de dos tríadas, y los siete modos de la mayor).
- **blues**: las blues y las pentatónicas de las que salen.
- **de compositor**: las simétricas y las de compositor (tonos enteros, disminuidas, Messiaen, Prometeo, Petrushka,
  la acústica, la cromática).
- **folclore**: las que vienen de una música tradicional europea (mayor rumana, menor húngara, pentatónicas,
  gaélicas, dórico ♯4).
- **flamenco**: la flamenca y el frigio dominante.
- **pop y rock**, también el metal: el frigio dominante, la doble armónica, las pentatónicas.
- **sintética**: las que salen de rotar o alterar otra, sin repertorio propio (casi todos los modos de la menor y la
  mayor armónicas, de la doble armónica y de las napolitanas).

Los tres últimos son los populares (`Estilo.populares`, `esPopular`). Las escalas de `todos` son de la tradición
occidental (`Tradicion.occidental`), y estos son sus estilos; las de otras tradiciones tienen escuelas (``Escuela``):
la música carnática o el gagaku, de la India o de Japón. `Estilo.tipos` da las de un estilo, en el orden del
catálogo, y en la línea de comandos `armonia escalas --uso jazz` las lista.

```swift
TipoDeEscala.dorico.estilos == [.jazz, .clasica]    // true
Estilo.blues.tipos.count                            // 6
Estilo.deCompositor.nombre                          // "de compositor"
TipoDeEscala.kafi.escuelas == [.indostanica]        // true
TipoDeEscala.dorico.tradicion                        // .occidental
```

### Lo principal primero, y las corrientes

Los estilos de una escala van de más a menos importante, en el orden de su declaración: el dórico es central en el
jazz modal y raro en la música clásica, y el frigio dominante es sobre todo flamenco. `estiloPrincipal` da el
primero. Dentro de un estilo, una escala puede ser de una o varias corrientes (``Corriente``), cada una con el año en
que empieza: el bebop (1945) y el jazz modal (1959) en el jazz, el impresionismo (1890) en las de compositor, y el
rock (1955), el heavy metal (1970) y el metal neoclásico (1984) en el pop y el rock. Las corrientes precisan las
épocas de uso de su estilo: la escala de tonos enteros, por el impresionismo, ya se usa en el Romanticismo. En la
línea de comandos, `armonia escalas --uso modal` o `--uso metal-neoclasico` las lista.

```swift
TipoDeEscala.frigioDominante.estiloPrincipal                    // .flamenco
TipoDeEscala.dorico.corrientes == [.modal]                      // true
TipoDeEscala.menorArmonica.corrientes == [.metalNeoclasico]     // true
Corriente.modal.anio                                            // 1959
Corriente.impresionismo.epocasDeUso == [.romanticismo, .sigloXX]  // true
```

## Antigua, medieval, tonal: la época de una escala

`TipoDeEscala.epocaDeOrigen` dice cuándo aparece una escala, y `epocasDeUso`, en qué épocas se usa. Las dos son una
``Epoca`` (antigüedad, Edad Media, Renacimiento, las tres de la época tonal, que son el Barroco, el Clasicismo y el
Romanticismo, y los siglos XX y XXI), y ninguna se escribe en el catálogo: se
calculan con lo que ya sabe de cada escala. La de origen es la primera de estas que da algo:

1. la de su año (`TipoDeEscala.anioDeOrigen`, con `Epoca(anio:)`): el de la obra más antigua que da la escala
   (`documentada`: la menor húngara es del Romanticismo por el libro de Liszt sobre la música gitana de Hungría,
   de 1859; los tonos enteros, por «Ruslán y Liudmila» de Glinka, de 1842; las octatónicas, por «Sadkó» de
   Rimski-Kórsakov, de 1867; los modos de Messiaen, por su «Technique de mon langage musical», de 1944; los echoi, por el Theōrētikon de Chrysanthos, de 1832; los makamlar que ya están en Cantemir, por su
   tratado, de hacia 1700), el de su fuente teórica (`FuenteTeorica.anio`: los géneros de Ptolomeo son de la
   antigüedad, y los çeşni de Arel-Ezgi-Uzdilek, del siglo XX) o el de su categoría (`CategoriaTradicional.anio`:
   los mēḷa, de 1660; los thāṭ, de 1909; los grāma y las mūrchanā, del Nāṭyaśāstra; los dastgāh, del radif de
   hacia 1880; los mugam, de Hacıbəyov, de 1945; los dromoi, del rebético, de los años veinte);
2. la de su tradición, si es una época (`Tradicion.epoca`): la Grecia antigua, Mesopotamia, el canto gregoriano y el
   Renacimiento;
3. en las occidentales de la música clásica, la de las escalas gregorianas y renacentistas con sus mismas notas: el
   dórico es medieval por el protus, y la mayor renacentista por el jónico de Glareano;
4. en las sintéticas, la de la escala de la que son modo (`Escala.escalaMadre`);
5. en las sintéticas y las populares, la de las escalas de las que son un modo: la doble armónica y el ultrafrigio,
   la de la menor húngara; la mayor locria, la de la napolitana mayor. Las populares solo la toman de una escala
   documentada: la flamenca tiene las notas de un modo de una escala de jazz, pero no viene del jazz;
6. la más antigua de las de uso de sus estilos (`Estilo.epocasDeUso`): la clásica da el Barroco, y el jazz, el
   blues y el siglo XX, el siglo XX.

Las de uso son las de sus estilos, sin la de origen: la clásica da las tres de la época tonal (`Epoca.tonales`), el
jazz y el blues, los siglos XX y XXI, y las de compositor, el XX. Las populares que no salen por ninguna regla (la flamenca, la
mayor rumana) no tienen época de origen.

```swift
TipoDeEscala.dorico.epocaDeOrigen == .edadMedia              // true
TipoDeEscala.dorico.epocasDeUso.first == .barroco           // true
TipoDeEscala.mayor.epocaDeOrigen == .renacimiento            // true
TipoDeEscala.alterada.epocaDeOrigen == .sigloXX              // true
TipoDeEscala.menorHungara.documentada?.anio == 1859          // true
TipoDeEscala.dobleArmonica.epocaDeOrigen == .romanticismo    // true
Epoca.romanticismo.nombre                                    // "Romanticismo"
```

La época de origen es la de sus notas. La de su nombre (`TipoDeEscala.epocaDelNombre`) es otra en las que se llaman
como se llaman desde otra época: la mayor tiene las notas del jónico de Glareano, del Renacimiento, pero se llama
«mayor» desde que la teoría francesa del Barroco deja solo dos modos; los modos llevan los nombres griegos desde la
«Alia musica», de hacia 900.

```swift
TipoDeEscala.mayor.epocaDelNombre == .barroco                // true
TipoDeEscala.dorico.epocaDelNombre == .edadMedia             // true
```

### El período en cada tradición

Las épocas son europeas: que un tratado indio sea «de la Edad Media» es una etiqueta de fuera. `TipoDeEscala.periodo`
da el ``PeriodoMusical`` de su tradición en que aparece, con los nombres que se usan en ella: en la India, el védico,
el del Nāṭyaśāstra, el del Saṅgītaratnākara, el de los mēḷa y el de Bhātkhaṇḍe; en el mundo árabe, Persia y
Azerbaiyán, el abasí, la escuela sistematista, el otomano y safávida y, en el mundo árabe, desde el Congreso de El
Cairo, y en Persia, el qayar; en Turquía, además, los de Cantemir, de Selim III y de Arel-Ezgi-Uzdilek; en China, las dinastías, y en Japón,
los períodos de su historia. Sale de su tradición y de su año, con `PeriodoMusical.de(_:anio:)`, y es `nil` en las
tradiciones sin períodos propios y en las escalas sin año. `PeriodoMusical.periodos(de:)` da los de una tradición, en
orden, y `TipoDeEscala.periodosDeUso`, los que vienen después del suyo, en los que se sigue usando: las tradiciones
con períodos siguen vivas, salvo la del Nāṭyaśāstra.

```swift
TipoDeEscala.melakarta(29)?.periodo == .mela                // true
TipoDeEscala.rastMakami.periodo == .cantemir                // true
TipoDeEscala.rastDortlusu.periodo == .arelEzgiUzdilek       // true
TipoDeEscala.rastMakami.periodosDeUso == [.selimIII, .arelEzgiUzdilek]   // true
PeriodoMusical.mela.nombre                                  // "período de los mēḷa"
```

## Flamenca, rumana, persa: de dónde viene una escala

La tradición (`TipoDeEscala.tradicion`) dice de qué música es una escala; los lugares, de dónde viene y dónde se usa.
Un ``Lugar`` es un ``Continente``, una ``ZonaMusical`` (las del mundo árabe: el Levante, Egipto, Irak, el Golfo y el
Magreb), un ``Pais``, un ``LugarHistorico`` (Bizancio, Mesopotamia, la Grecia antigua, con los países de hoy en su
territorio), un ``Pueblo`` que vive en varios países (el gitano, los judíos asquenazíes) o una ``RegionDeEscala`` (una
región o un pueblo de un sitio, como los mandinga). `contenidoEn` da los que lo contienen (Andalucía está en España,
que está en Europa) y `esta(en:)` lo pregunta.

`TipoDeEscala.lugaresDeOrigen` da los más concretos que se saben:

1. sus regiones y sus pueblos: el sléndro es de Java y de Bali; las occidentales populares que vienen de un lugar lo
   declaran también (la flamenca, de Andalucía; la mayor rumana, de Rumanía); la menor húngara es de Hungría y del
   pueblo gitano, y el klezmer, de los judíos asquenazíes;
2. el lugar histórico de su tradición: los echoi, de Bizancio;
3. las zonas de su tradición: Bayātī, del Levante, Egipto, Irak, el Golfo y el Magreb;
4. los países de sus estilos, si todos los tienen (la alterada y la blues, de Estados Unidos por el jazz y el blues),
   o los de su tradición (Bilāval, de la India);
5. los continentes de su tradición: la mayor, de Europa.

`paisesDeOrigen` y `continentesDeOrigen` dan los de cada nivel.

`TipoDeEscala.lugaresDeUso` da dónde se usa también, aunque no venga de allí: los países de sus estilos que no son de
origen (el dórico, de Europa, también en Estados Unidos por el jazz) y los lugares de origen de sus parientes, las
escalas de otras tradiciones que son la misma con un nombre que viene de ella (`TipoDeEscala.familias`). El frigio
dominante se usa así en el mundo árabe (Ḥijāz), en Turquía (Hicaz makamı), en Grecia (el dromos Hitzáz) y entre los
judíos asquenazíes (el Freygish). Las demás escalas con sus mismas notas son coincidencias, no usos, y van aparte en
`lugaresQueCoinciden`: la mayor coincide con Bilāval, pero no se usa en la India.

Hay nombres que parecen decir de dónde viene la escala y no lo dicen. La persa, la egipcia y la oriental son etiquetas
exóticas de los libros de escalas, y las napolitanas se llaman así por la sexta napolitana: están en
`TipoDeEscala.nombresGeograficosSinOrigen`, `nombreGeograficoSinOrigen` lo dice de cada una, y son de Europa, como las
demás occidentales.

```swift
TipoDeEscala.flamenca.lugaresDeOrigen == [.region(.andalucia)]   // true
TipoDeEscala.flamenca.paisesDeOrigen == [.espana]                // true
TipoDeEscala.mayor.lugaresDeOrigen == [.continente(.europa)]     // true
TipoDeEscala.alterada.lugaresDeOrigen == [.pais(.estadosUnidos)] // true
TipoDeEscala.echosProtos.paisesDeOrigen == [.grecia, .turquia]   // true
TipoDeEscala.persa.nombreGeograficoSinOrigen                     // true
Lugar.region(.andalucia).contenidoEn == [.pais(.espana), .continente(.europa)] // true
```

## Escalas de otras tradiciones

Las escalas de otras tradiciones (rāgas, maqamat, dromoi, las escalas chinas y japonesas, las griegas antiguas, los
modos gregorianos…), su categoría, sus referencias y sus microtonos están en <doc:EscalasDelMundo>.

## Nombres en cada idioma, alias y variantes

El nombre de cada tipo de escala en cada idioma, y las otras formas con que se lee (sus alias y sus variantes), están en un
fichero por idioma: `Escalas/Nombres/NombresDeEscalas+Catalan.swift`, `+Gallego`, `+Ruso`… (el español sale
del propio catálogo). `TipoDeEscala.nombre(en:)` usa el fichero del idioma de la notación, y
`TipoDeEscala(leyendo:)` y `Escala("Re dòric")` leen los de todos. Cada fichero da todos los tipos de
`TipoDeEscala.occidentales`, el nombre de cada `CategoriaTradicional` (`.categoria`) y las escalas de otras tradiciones
que se traducen en ese idioma (`.tradicional(.andina, "…")`, que apunta al miembro de `TipoDeEscala` y no compila si
deja de existir); las demás, sin fila, conservan su nombre original (Kāfī, Hitzáz) y sus alias y variantes del
catálogo («Hicaz», «ትዝታ»), menos los que están en español (`NombresDeEscalas.aliasEnEspanol`: «modo gregoriano 1»,
«hexacordo duro»…), así que también se leen por ellos con la tónica en alemán, en húngaro o en sueco.
`Scripts/comprobaciones/comprobar_catalogo.py` vigila que no falte ninguno y que no haya filas que no traducen nada. Un idioma nuevo es un fichero más.

Un alias es otro nombre de la escala («jónico» para la mayor, «bizantina» para la doble armónica); una variante es
otra forma de escribir el nombre o un alias: otro género («dórica»), otra transliteración («Hicaz» por Hitzáz) u
otra escritura («Χιτζάζ», «बिलावल»). `TipoDeEscala.alias` y `TipoDeEscala.variantes` se leen igual; para enseñar
los otros nombres de una escala, basta con los alias.

```swift
TipoDeEscala.dorico.alias        // ["menor dórica"]
TipoDeEscala.dorico.variantes    // ["dórica"]
try TipoDeEscala(leyendo: "dórica") == .dorico   // true
```

`TipoDeEscala.alias` y `variantes` guardan solo las grafías correctas («dórico ♭2», «húngara»). Las simplificadas («dorico b2»,
«hungara») no se repiten: salen de `aliasNormalizados` y de `normalizar` (minúsculas, sin diacríticos, ♯/♭ como
#/b, sin ♮ ni ordinales), con lo que se encuentran igual.

```swift
try TipoDeEscala(leyendo: "dorico b2") == TipoDeEscala(leyendo: "dórico ♭2")        // true
TipoDeEscala.dobleArmonica.aliasNormalizados.contains("doble armonica")                 // true
try TipoDeEscala(leyendo: "jonico sin 4") == TipoDeEscala.jonicoSinCuarta              // true
```

## Escalas que suben y bajan distinto

Algunas escalas usan notas distintas al subir y al bajar: la menor melódica clásica (que baja
como la natural), los dromoi Rast, Kiourdí y Houseïní, y muchos rāgas janya. `intervalos` es la
forma ascendente e `intervalosDescendentes`, la descendente (`nil` si la escala baja igual que sube).

```swift
TipoDeEscala.menorMelodica.esDireccional          // true
TipoDeEscala.menorMelodica.formaDescendente       // == .menorNatural
Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente)   // La5 Sol5 Fa5 … La4
TipoDeEscala.rast.formaAscendente == .mayor       // true; baja con la 7ª menor
TipoDeEscala.kiourdi.formaDescendente             // == .menorNatural
TipoDeEscala.bilahari.intervalosEnAmbasDirecciones
```

Los rāgas janya incluidos son Mohanam, Hindolam, Haṃsadhvani, Ābhogi, Madhyamāvatī, Revati,
Amṛtavarṣiṇī, Śuddha Sāveri, Śuddha Dhanyāsi, Śrīrañjani, Mālayamārutam, Gambhīranāṭa y Haṃsanādam (iguales al
subir y al bajar), y Bilahari, Kāmbhoji, Ārabhi, Kedāragauḷa, Mohanakalyāṇi, Sāveri y Nāṭa (distintos). Se dejan fuera los
vakra, que suben o bajan en zigzag. `melakartasCompatibles` dice de qué mēḷa puede derivar
cada uno: `TipoDeEscala.mohanam.melakartasCompatibles` → `[28, 29, 64, 65]`.

### Qué forma usa cada operación

- **Las dos direcciones:** `contiene(_:)`, `contieneEnarmonico(_:)`, `Escala.candidatos` y la
  ortografía de alturas MIDI. La menor melódica contiene Sol (al bajar) y Sol♯ (al subir), y
  en ella el Sol no se escribe como nota cromática. Con `sentido:` se mira solo una:
  `contiene(.sol, sentido: .ascendente)` → `false`.
- **Solo la subida:** `notas`, los grados (`grado(_:)`, `grado(de: _:)`, `nombreDeGrado(_:)`), la
  armonización, la armadura y `conjuntoDeClasesDeAltura` (la menor melódica es 7-34).
- `notasEnAmbasDirecciones` y `notas(sentido:)` dan las notas de cada caso.

### Menor melódica clásica y de jazz

`menorMelodica` es la clásica: sube con la 6ª y la 7ª mayores y baja como la natural.
`menorMelodicaJazz` usa la 6ª y la 7ª mayores también al bajar; es la escala madre de los modos
de la menor melódica (`TipoDeEscala.alterada.modo(grado: 2) == .menorMelodicaJazz`) y tiene el mismo
contenido que el mēḷa 23, Gaurīmanoharī. En inglés, "melodic minor" es la clásica y
"jazz minor" o "ascending melodic minor", la de jazz.

## Misma escala y mismo nombre

Dos tipos de escala son iguales (`==`) si tienen el mismo contenido al subir y al bajar, se
llamen como se llamen: `TipoDeEscala.kafi == .dorico`. Para comparar también el nombre está
`esIdentico(a:)`, y `equivalentes` da los otros nombres con que se conoce una escala:

```swift
TipoDeEscala.kafi.esIdentico(a: .dorico)          // false
TipoDeEscala.kafi.equivalentes.contains(.dorico)  // true
TipoDeEscala.rast == .mayor                       // false: baja distinto
```

Cuando dos escalas del catálogo coinciden, gana la que va antes en `TipoDeEscala.catalogo`: primero las
occidentales (`todos`) y después las de otras tradiciones (`tradicionales`), cada una en su orden. Así se
nombra una escala escrita por sus notas, y así se ordenan los `equivalentes`. Al buscar por nombre, además, un
nombre gana siempre a un alias o a una variante:

```swift
TipoDeEscala.propio(TipoDeEscala.kafi.intervalos).nombre   // "dórico"
TipoDeEscala.kafi.equivalentes.first?.nombre               // "dórico"
try TipoDeEscala(leyendo: "Hijaz").nombre                 // "Ḥijāz" (el maqam; el dromos Hitzáz lo tiene de variante)
```

## Arpegios

Un arpegio no es un tipo de escala sino un acorde tocado nota a nota, así que ``Arpegio`` no entra en el catálogo de escalas:
guarda un ``Acorde``, el orden del recorrido (``Arpegio/Patron``: ascendente, descendente, de ida y vuelta o el bajo de Alberti) y
las octavas que abarca. Se obtiene de un acorde o de un grado de una escala, se lee y se nombra en los trece idiomas
(«Arpegio de Do mayor», «C major arpeggio», «Arpège de Do majeur») y se dibuja en un pentagrama. ``Acorde/escalasCompatibles(entre:)``
da la relación acorde-escala del jazz: las escalas sobre la fundamental que contienen todas las notas del acorde, entre
las de ``TipoDeEscala/deJazz`` y de las que tienen menos notas a evitar a las que más.

```swift
Arpegio(Acorde("Do7")).alturas(octava: 4).map(\.midi) == [60, 64, 67, 70, 72]       // true
Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3).map(\.midi) == [48, 55, 52, 55]   // true
Escala("Do mayor").arpegio(grado: 5, cuatriada: true)?.acorde == Acorde("Sol7")      // true
Escala("Do mayor").arpegios().count == 7                                              // true
try Arpegio(leyendo: "arpegio Dom7").acorde == Acorde("Dom7")                        // true
Acorde("Do7").escalasCompatibles().contains(Escala(.do, .mixolidio))                 // true
let dibujo = Arpegio(Acorde("Do7")).svgPentagrama()
```

## Escalas sobre un acorde

La teoría acorde-escala del jazz mira cada nota de una escala desde el acorde que suena. ``Escala/notas(sobre:)`` dice
qué es cada una (``PapelEnLaEscala``): una nota del acorde, una tensión disponible o una nota a evitar, la que está un
semitono por encima de una nota del acorde y choca con ella si se sostiene (el fa sobre Do7M en jónico). En un acorde
de dominante, la ♭9 y la ♭13 no se evitan; en uno sus4, sí la tercera mayor. Cada nota lleva su grado sobre la
fundamental como en los cifrados de jazz, como número (``NotaSobreElAcorde/numero``) y alteración
(``NotaSobreElAcorde/alteracion``), y escrito (``NotaSobreElAcorde/cifra``): las 2.ª, 4.ª y 6.ª se cuentan como 9, 11
y 13, y una 3.ª menor sobre un acorde mayor, como ♯9.

Qué escala toca sobre cada acorde depende de lo que hace en la tonalidad. ``Tonalidad/escalaDelAcorde(_:siguiente:)`` y
``AnalisisArmonico/escalas`` la eligen por su papel en el análisis: el modo de la tonalidad para un acorde diatónico
(Rem7 en Do, dórico), el de la escala del destino para una dominante secundaria (V7/ii, frigio dominante: el
mixolidio ♭9 ♭13), el de la homónima para un préstamo (♭VI, lidio) y lidio dominante para el sustituto tritonal. Si el
acorde no cabe en esa escala, se queda con la de ``TipoDeEscala/paraAcordes`` que saca menos notas de la tonalidad.

``Escala/escalaMadre`` dice de qué escala es modo cada una, entre las mayores, las menores melódicas, las menores
armónicas y las mayores armónicas (``TipoDeEscala/familiasDeModos``).

```swift
Escala(.do, .mayor).notasAEvitar(sobre: Acorde("Do7M")) == [.fa]                       // true
Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).map(\.cifra) == ["1", "9", "♭3", "11", "5", "13", "♭7"]   // true
Escala(.sol, .frigioDominante).tensiones(sobre: Acorde("Sol7")) == [Nota(.la, .bemol), Nota(.mi, .bemol)]   // true
Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Sol7"]).escalas[1] == Escala(.la, .frigioDominante)          // true
Tonalidad(.do).escalaDelAcorde(Acorde("Sib7")) == Escala(Nota(.si, .bemol), .lidioDominante)               // true
Escala(.do, .alterada).escalaMadre?.madre == Escala(Nota(.re, .bemol), .menorMelodicaJazz)               // true
Escala(.re, .dorico).escalaMadre?.nombre(en: .compacta(.espanol)) == "modo 2 de Do mayor"                   // true
Acorde("Do7(#11)").escalasCompatibles().first == Escala(.do, .lidioDominante)                            // true
```

### Los acordes de una escala

En el otro sentido, ``Escala/acordesQueCaben(grado:)`` da todos los acordes de ``TipoDeAcorde/paraEscalas`` que caben
sobre un grado, no solo los de terceras superpuestas: en Do mayor, sobre el 1.º, también Dosus2, Do6, Do6/9 y
Do(add9); en Do frigio dominante, Do7(♭9). ``Escala/estructurasSuperiores(sobre:)`` da las tríadas mayores y menores
de la escala que se pueden tocar sobre el acorde: las que tienen alguna tensión y ninguna nota a evitar, primero las
de más tensiones. Sobre Do7M en lidio, Re mayor: la 9, la ♯11 y la 13.

```swift
Escala(.do, .mayor).acordesQueCaben(grado: 1).contains(Acorde(.do, .mayorSexta))                        // true
Escala(.do, .lidio).estructurasSuperiores(sobre: Acorde("Do7M")).first == Acorde(.re, .mayor)             // true
```

### Armonía modal

Los siete modos de la escala mayor (``Escala/modoDeLaMayor``, de 1 a 7) se distinguen del mayor o del menor más
parecido por una nota, ``Escala/notaCaracteristica``: la 6.ª mayor del dórico, la 2.ª menor del frigio, la 4.ª
aumentada del lidio, la 7.ª menor del mixolidio… ``Escala/acordesCaracteristicos`` son las tríadas del modo que la
llevan (sin la de la tónica ni las disminuidas), y ``Escala/cadenciaModal``, la cadencia que afirma el modo sin la
dominante de la tonalidad: IV–i en dórico, ♭II–i en frigio, II–I en lidio, ♭VII–I en mixolidio.

```swift
Escala(.re, .dorico).notaCaracteristica == .si                                          // true
Escala(.re, .dorico).acordesCaracteristicos == [Acorde("Mim"), Acorde("Sol")]           // true
Escala(.sol, .mixolidio).cadenciaModal == [Acorde("Fa"), Acorde("Sol")]                 // true
Escala(.mi, .frigio).cadenciaModal == [Acorde("Fa"), Acorde("Mim")]                     // true
```

### Estudiar una escala

``Escala/secuencia(_:octava:octavas:sentido:)`` da la escala en una ``SecuenciaDeEscala`` de estudio, subiendo o
bajando: por terceras (Do Mi, Re Fa, Mi Sol…), por cuartas, en grupos de tres o de cuatro notas, o en la tríada o la
cuatriada de cada grado. ``Escala/digitacionDePiano(_:octava:octavas:)`` da los dedos de cada ``Mano``: en Do mayor,
1 2 3 1 2 3 4 5 en la derecha y 5 4 3 2 1 3 2 1 en la izquierda; en Fa mayor, 1 2 3 4 1 2 3 4 en la derecha, para que
el pulgar no caiga en el Si♭.

``Escala/modosParalelos`` son los siete modos de la mayor sobre la misma tónica, del más brillante (lidio) al más
oscuro (locrio), y ``Escala/brillo`` mide cuánto: lidio +1, jónico 0, dórico −2, locrio −5.
``Escala/modosRelativos`` son las escalas con las mismas notas que empiezan en cada grado.
``Escala/relacion(con:)`` da una ``RelacionEntreEscalas``: las notas comunes, las que solo están en una, los grados
que cambian (de Do mayor a Do lidio, el 4.º, de Fa a Fa♯) y la distancia en el círculo de quintas.

Sobre un acorde, ``Acorde/escalasBebop`` son las bebop que, bajando en corcheas, ponen una nota del acorde en cada
parte fuerte (Do bebop dominante sobre Do7, con el Si de paso), y ``Acorde/pentatonicas``, las pentatónicas sin notas
a evitar, con las tensiones que suma cada una. En una progresión, ``Escala/cambios(desde:)`` dice qué notas cambian
de la escala de un acorde a la del siguiente y ``Acorde/notasGuia``, su tercera y su séptima.

### Lo que dicen las teorías de escalas

``EstadisticasDeEscala`` reúne, además de lo que se cuenta de sus notas, lo que dicen de ellas las teorías:

- **Myhill y la buena formación** (Clough y Myerson; Carey y Clampitt): si cada intervalo genérico tiene dos
  tamaños, el intervalo que la genera en cadena y si es bien formada, un «momento de simetría» (MOS).
- **Rothenberg**: ``PropiedadDeRothenberg`` (estrictamente propia, propia o impropia), las ambigüedades y
  contradicciones entre clases genéricas, la estabilidad, el cociente de igualdad (a la manera de Carey) y la
  anchura media del espectro.
- **Gamer, Hanson y Forte**: si es profunda, el análisis pmn-sdt de su vector, la pareja Z y el complemento.
- **Messiaen y la simetría**: el modo de transposición limitada que es y si coincide con su inversión.
- **Zeitler y Balzano**: las imperfecciones, la unicidad y la simplicidad.
- **La armonización por grados**: las tríadas y las cuatríadas por terceras de cada grado, en las de siete notas.
- **Babbitt**: ``CombinatoriedadHexacordal``, si las de seis notas se completan con una transposición o una
  inversión suya, con la letra de las totalmente combinatorias.
- **Fourier, Tymoczko y Milne**: las magnitudes |f1|…|f6|, la distancia a la uniformidad, la parsimonia y si está
  equilibrada.
- **Afinación y psicoacústica**: la consonancia de Huron, el gradus de Euler, la altura de Tenney, el límite impar,
  la entropía armónica de Erlich, la rugosidad media de Sethares y la entropía interválica.
- **El perfil tonal** de Krumhansl y Kessler: la correlación con la tonalidad mayor y menor sobre su tónica; y si
  tiene sensible y dos tetracordos iguales.

```swift
Escala(.do, .mayor).estadisticas.intervalosGenericos.propiedadDeRothenberg   // .propia
Escala(.do, .pentatonicaMayor).estadisticas.intervalosGenericos.generador    // 5
Escala(.do, .mayor).estadisticas.conjunto.analisisDeHanson                   // "p⁶m³n⁴s⁵d²t"
Escala(.do, .tonosEnteros).estadisticas.conjunto.modoDeMessiaen              // 1
Escala(.do, .mayor).estadisticas.conjunto.parsimonia                         // 2
```

En la línea de comandos, `armonia escala Do mayor --estadisticas` las escribe, también en `--json` (en
`estadisticas.teoria`).

### Lo que separa a dos escalas

``RelacionEntreEscalas`` mide la distancia entre dos escalas: las quintas entre sus centros (la distancia de sus
armaduras por el círculo de quintas, que vale también para las escalas sin armadura), las notas que cambian, la
conducción mínima de una a otra (Tymoczko) y lo que se parecen sus contenidos (``RelacionEntreConjuntos``).

```swift
Escala(.do, .mayor).relacion(con: Escala(.sol, .mayor)).distanciaEnQuintas              // 1
Escala(.do, .mayor).relacion(con: Escala(.do, .menorNatural)).distanciaEnQuintas        // 3
Escala(.do, .mayor).relacion(con: Escala(.do, .pentatonicaMayor)).conduccion?.semitonosMovidos   // 2
```

`armonia escala Do mayor --comparar Sol mayor` las añade a la comparación.
