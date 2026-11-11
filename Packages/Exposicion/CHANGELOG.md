# Cambios

## Sin publicar

### Lo nuevo

- `PresentacionDeEstudioDeEscala.relojMicrotonal(de:afinacion:colores:en:)`: la versión microtonal de una escala en el
  reloj de cents (`RelojDeAlturas`), con el título «… · Círculo microtonal» (`TextosDeApps.circuloMicrotonal`, en los
  trece idiomas), con `colores` para pintar cada grado del color de sus cents.
- `TemperamentoPresentado.reloj(de:quintas:colores:en:)`: un temperamento del catálogo en el reloj de cents, o en su
  círculo de quintas si lo tiene.
- `Escucha.grados(de:afinacion:)`: cada grado de la escala solo, con su microtono, para tocarlo en el círculo
  microtonal; `Escucha.escala(_:afinacion:)` suena también en otra de sus afinaciones (la de Chrysanthos).
- La hoja de estudio de una escala con microtonos lleva, con el reloj, su círculo microtonal.
- `PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(de:en:secciones:)`: la hoja de estudio como página HTML, con
  los textos en HTML y los dibujos como SVG dentro; se adapta al ancho (las columnas se apilan en una pantalla
  estrecha), sigue el modo oscuro y se imprime en A4. `ficheroDeLaHojaHTML(de:secciones:en:)` la da para exportarla,
  con `FicheroParaExportar.html(_:nombre:)` y el formato nuevo `.html` («Página HTML», `TextosDeApps.paginaHTML`, en
  los trece idiomas). Quien recorra `FicheroParaExportar.Formato` con un `switch` sin `default` tiene que añadir el
  caso. En la línea de comandos, `armonia hoja Re dórico --html`; en Ars Harmonica, se exporta también en HTML.
- Las demás hojas, también en HTML: `PresentacionDeRelacionesDeAcorde.hojaDeEstudioHTML(de:en:)` (la de un acorde,
  con un diagrama por digitación), `PresentacionDeAnalisis.hojaDeEstudioHTML(_:disposicion:en:)`,
  `hojaEnLasDoceTonalidadesHTML(_:tonalidad:disposicion:en:)` y `hojaDeLaComparacionHTML(_:con:en:disposicion:notacion:)`
  (las de una progresión), `PresentacionDeTonalidad.hojaDeEstudioHTML(de:en:)` y
  `PresentacionDeEstudioDeEscala.comparacionNotaANotaHTML(_:con:en:)` con `ficheroDeLaComparacionHTML`. En la línea de
  comandos, `--html` vale en todas las variantes de `armonia hoja`; en Ars Harmonica, las pestañas de acordes, de
  análisis y de escalas las exportan también en HTML.

## 0.5.0 (2026-11-10)

### Cambios incompatibles

- `Escucha.afinado(en:)` se quita: `afinado(con:)`, que ahora toma un `TemperamentoQueAfina` y ya no deja la
  escucha como está con un sistema de otra tradición (no se puede pasar).

### Lo demás

- `ComparacionPresentada` lleva `relacion` (`RelacionEntreAcordes`) y `disposiciones` en vez de `comparacion`, y
  `ComparacionDeEscalasPresentada`, `relacion` (`RelacionEntreEscalas`) en vez de `comparacion`.
- `PresentacionDeEstudioDeEscala.grados(_:)` toma también los tipos de acorde de cada grado. Las cuatríadas con la
  quinta disminuida se escriben `V7(♭5)`, con el cifrado del acorde (antes `V7♭5`).

- Por dentro, sin cambios de API: la raíz se reparte en carpetas. `ConsultasPresentadas` se divide por lo que
  consulta (`Acordes/`, `Escalas/` y la nueva `Postonal/`, con el análisis postonal y la serie); `Escucha` y
  `CambioMIDI` van a `Sonido/`, `PentagramaPresentado` a `Partituras/` y `ValorDeMedida` a `Acordes/`.

- `MedidaDeAcorde`: cada medida de un acorde descrita una sola vez, con su clave, su título en `TextosDeApps` y cómo
  se escribe su valor en texto y en JSON (`ValorDeMedida`). La lista de la consola y la app, la tabla de `acordes
  --estadisticas`, el JSON (`EstadisticasDeAcordePresentadas`, ahora con `valores` por clave en vez de un campo por
  medida) y el TSV de `EjemploCatalogoDeAcordes` recorren `MedidaDeAcorde.todas`. La tabla escribe el número de notas
  con su cardinal, como la lista, y las columnas del TSV llevan la clave del JSON.

- Las presentaciones redondean con `Redondeo`; el JSON lleva valores exactos.

- `FuncionDeNotaPresentada`: una función de nota del catálogo con su ficha (familia, intervalo, cents y desvío), con
  `ficha(en:)`.

- `NotaPresentada`: una nota del catálogo con su ficha (familia, altura, desvío, frecuencia, La4, MIDI, año, nombre
  original y alturas de la posición guidoniana), con `ficha(en:)`. `TextosDeApps` tiene sus nombres en los trece
  idiomas.

- `TemperamentoPresentado`: un temperamento del catálogo con su ficha (familia, autor, año, pasos por octava,
  quinta) y lo que se mide de él, con `ficha(en:)` y `datos(en:)`. `TextosDeApps` tiene sus nombres en los trece
  idiomas.

- `RitmoPresentado`: un ritmo del catálogo con su ficha (familia, patrón, agrupación, compás) y lo que se mide de él,
  con `ficha(en:)` y `datos(en:)`; `RelacionEntreRitmosPresentada`, las distancias de Hamming y de intercambio.
  `TextosDeApps` tiene sus nombres en los trece idiomas.

- Las medidas de relación, escritas y para el JSON: `RelacionEntreAcordesPresentada`,
  `AcordeEnLaTonalidadPresentado` (Krumhansl, función probable, tonalidades cercanas y escalas del catálogo),
  `RelacionEntreEscalasPresentada`, `RelacionEntreConjuntosPresentada` y `EstadisticasDeProgresionPresentadas`, cada una
  con `datos(en:)` para escribirla dato por dato. `TextosDeApps` tiene sus nombres en los trece idiomas.
- `PresentacionDeEstadisticasDeAcorde`: lo que se mide de un acorde (`EstadisticasDeAcorde`), un dato por fila, la
  tabla para comparar varios del catálogo y su resumen (`ResumenDeAcordesPresentado`: cuántos hay de cada número de
  notas, de cada estilo y por terceras). `EstadisticasDeAcordePresentadas` es lo mismo para el JSON. Ars Harmonica lo
  enseña en la vista de acordes, en una sección «Estadísticas».
- `DatoDeEscalaPresentado` se llama ahora `DatoPresentado`, porque lo usan también los acordes; el nombre antiguo
  queda como alias.
- `PresentacionDeEstadisticasDeAcorde.estadisticas(_:sobre:en:)` y `EstadisticasDeAcordePresentadas` añaden las
  medidas de la teoría (Huron, Hindemith, Parncutt, Euler, Fourier, Tymoczko, Cook y Sethares); con `sobre:`, las
  fundamentales se escriben como notas. La tabla añade la consonancia y el grupo de Hindemith, y `triadas(_:)` da
  las tríadas contenidas («M 1 · m 0 · ° 1 · + 0»).
- `PresentacionDeEstadisticasDeAcorde` y `EstadisticasDeAcordePresentadas` añaden la afinación justa (Tenney,
  Partch, Gill y Purves), la entropía armónica, la fundamental virtual, la fusión tonal, las rugosidades de
  Vassilakis y de Hutchinson y Knopoff, la pareja Z, el complemento y la disposición (`disposicion(_:en:)`).
- `PresentacionDeEstudioDeEscala.estadisticas(de:en:)` añade lo que dicen las teorías de escalas, una fila por medida
  y una de «Propiedades»; `MedidasDeEscalaPresentadas` es lo mismo para el JSON, y `propiedad(_:en:)`, `grados(_:)`,
  `combinatoriedad(_:)` y `propiedades(_:en:)` escriben cada parte.

## 0.4.4 (2026-11-09)

- **Cambio incompatible:** una sola regla para pasar la notación: `en:` cuando nada más ocupa esa etiqueta y
  `notacion:` cuando `en:` ya es la tonalidad, el mástil o la red. Pasan a `en:` los seis `PentagramaPresentado(…)`
  y `PresentacionDeCoral.realizar(_:en:)` (el del análisis ya hecho); las demás ya la seguían.
- **Cambio incompatible:** los resultados se llaman todos `…Presentado` o `…Presentada`, y los datos de las
  consultas dejan de ser una familia aparte: `DatosDeAcorde` es `AcordePresentado`, `DatosDeCandidato`,
  `CandidatoPresentado`, `DatosDeEscala`, `EscalaPresentada`, `DatosDeConjunto`, `ConjuntoPresentado`, y
  `DatosDeSerie`, `SeriePresentada`. La serie de la app, que antes se llamaba así, es `MatrizDeSeriePresentada`, y
  `ComparacionDeProgresiones`, `ComparacionDeProgresionesPresentada`. El JSON de `armonia … --json` no cambia.
- **Cambio incompatible:** las seis `Fila` anidadas tienen nombre propio: `AnalisisPresentado.AcordeDelAnalisis`,
  `CoralPresentado.AcordeDelCoral`, `ContrapuntoPresentado.CompasDelContrapunto`,
  `DisposicionesPresentadas.AcordeDispuesto`, `TablaDeAcordesPresentada.AcordesDeUnaTonalidad` y
  `ComparacionDeProgresionesPresentada.PosicionComparada`. Las propiedades siguen siendo `filas`.
- **Cambio incompatible:** `EscalaSobreElAcordePresentada`, que se confundía con `EscalaSobreAcordePresentada`, es
  `EscalaConDetallePresentada`: una escala con su detalle, que sirve para las bebop y las pentatónicas sobre un acorde,
  las vecinas, las parecidas y los ciclos de la simetría.
- README del paquete: qué presenta cada carpeta, de qué depende y dónde está su DocC.

## 0.4.3 (2026-11-09)

- Revisión del catalán y del inglés en las apps: «Número de Forte», «Reharmonitzar» y los apóstrofos rectos en
  catalán; en inglés, la red del Tonnetz es «Lattice» (la rejilla del controlador sigue siendo «Grid») y la nota de
  paso, «passing tone».
- Revisión de los demás idiomas en las apps: la red del Tonnetz ya no se llama como la rejilla en húngaro («Háló»),
  griego («Δίκτυο») y ruso («Решётка»); las notas guía no son «Leittöne» ni «vezetőhangok»; el francés trata siempre
  de usted, «Instrument et accordage»; el portugués es siempre de Portugal («anemitónica», «meios-tons»); en euskera,
  «Laugarrenka», «Bosgarrenen zirkulua» y «Ahots-eramatea»; en gallego, «Padrón por graos» y «Grella hexagonal»; el
  rótulo de las tónicas equivalentes dice «la misma escala desde» en alemán, sueco, húngaro, euskera, griego y
  francés, y en ruso los semitonos ya no dependen de la concordancia con el número.

## 0.4.2 (2026-11-08)

- **Cambio incompatible:** `DatosDeAcorde`, `DatosDeCandidato`, `DatosDeEscala`, `DatosDeConjunto`, `DatosDeSerie`
  y `RecorridoDePartitura` toman la notación con `en:`, como las demás presentaciones (antes `notacion:`).
- **Cambio incompatible:** `PentagramaPresentado` y `PresentacionDeTablatura` ya no ponen la notación española si no
  se da: hay que pasarla, para que nada salga en español en una app en otro idioma.

- **Cambio incompatible:** los textos de `TextosDeApps` que solo llevaban valores (`campoDeCifrado`, `trastes`,
  `cuerdas`, `soloEn`, `cambianAcordes`…) son plantillas con huecos `{1}` (`Plantilla`) en lugar de funciones. Se
  siguen llamando igual (`textos.trastes(5, 8)`), pero ya no se pueden pasar como función.
- `ModoPresentado`, `EscalaSobreElAcordePresentada`, `TablaDeAcordesPresentada` y `AnalisisPresentado` (con sus filas
  y sus tramos) son `Encodable`, con las claves que da `armonia … --json`.
- Las hojas de estudio en SVG acaban todas con la misma función (la cabecera, el fondo y el cuerpo).

## 0.4.1 (2026-11-08)

- `TextosDeApps.alfabetoLatino`, el texto del interruptor del alfabeto latino, en los trece idiomas.
- Usa las notaciones nuevas del motor: `.compacta(.espanol)` en lugar de `.espanolCompacto`, y las demás igual.
- Los textos de las apps (`TextosDeApps`) están también en sueco.

## 0.3.7 (2026-11-07)

- **Cambio incompatible:** el paquete, el producto y el módulo se llaman ahora `Exposicion` (antes
  `TeselaPresentacion`), y la carpeta es `Packages/Exposicion`. Quien lo use por SwiftPM cambia
  `.product(name: "TeselaPresentacion", …)` por `.product(name: "Exposicion", …)` y `import TeselaPresentacion`
  por `import Exposicion`; los tipos no cambian.

- **La notación, con `en:`.** Las funciones que recibían la notación como `notacion:` la reciben como `en notacion:`,
  como en el motor: `modosParalelos(de:en:)`, `bajoCaminante(_:en:)`, `teclados(de:en:)`… Se quedan con `notacion:`
  las que ya tienen otro `en:`, como `PresentacionDeAnalisis.comparar(_:con:en:notacion:)`. **Cambio incompatible**,
  sin nombres obsoletos.

## 0.3.6 (2026-11-06)

- **La escala elegida en la pestaña de escalas.** `EleccionDeEscala`: la tónica y el tipo del catálogo, por su índice,
  o una escala escrita, y `elegir(_:)` para una pedida desde otra pestaña. `PresentacionDeEstudioDeEscala` suma lo que
  esa pestaña dibujaba o exportaba por su cuenta: los `teclados(de:notacion:)` de cada mano, los `trastes(de:notacion:)`
  y el `sonido(de:en:)` de una posición en el mástil, y los ficheros de la hoja de estudio, del mapa de brillo y de la
  comparación.
- **Las redes de notas, desde `TeselaUI`.** `RedDeNotas`, `ContenidoDeRed`, `PresentacionDeRedes`, `AjusteUIL` y
  `AjusteCuadrado` vienen de `TeselaUI`, para que las use también la línea de comandos; el paquete depende ahora
  también de `Hexagonos`. `ContenidoDeRed` suma `.notas`, `.camino` y `.ciclo` (lo que dibujan `armonia tonnetz`,
  `armonia tabla` y `armonia cuadricula`), `escala` y `red(_:)`, el contenido en el Tonnetz o en la tabla armónica
  con el protocolo `RedDeTriadas` del motor. `PresentacionDeRedes.svg(_:en:casillas:notacion:)` dibuja en un teclado
  de cuadrícula ya colocado. Quien recorra `ContenidoDeRed` con un `switch` sin `default` tiene que añadir los casos
  nuevos.

- **Cambio incompatible:** el paquete, el producto y el módulo se llaman ahora `TeselaPresentacion` (antes
  `ArmoniaPresentacion`), y la carpeta es `Packages/TeselaPresentacion`. No es parte del motor sino lo que comparten
  las apps y la línea de comandos. Quien lo use por SwiftPM cambia `.product(name: "ArmoniaPresentacion", …)` por
  `.product(name: "TeselaPresentacion", …)` y `import ArmoniaPresentacion` por `import TeselaPresentacion`; los
  tipos no cambian.

## 0.3.5 (2026-11-05)

- **Las tablaturas, desde la partitura del mástil.** `PresentacionDeTablatura.musicXML(…)` hace la partitura del
  mástil y la exporta con `Partitura.musicXML()`, en lugar de con su propio MusicXML. **Cambio incompatible** en lo
  que escribe, con la misma API: las notas van en dos pentagramas de la misma parte, el de las notas (en clave de sol
  octava baja en la guitarra) y debajo el de tablatura; los cifrados de las digitaciones son `<harmony>` en lugar de
  `<words>`, y un compás vacío es un silencio de compás entero.

## 0.3.4 (2026-11-04)

- **Los datos de las consultas, en un solo sitio.** `DatosDeAcorde`, `DatosDeCandidato` (con
  `identificar(_:limite:notacion:)`), `DatosDeEscala`, `DatosDeConjunto` y `DatosDeSerie` son lo que se consulta de
  un acorde, unas notas, una escala, un conjunto o una serie, sin darle forma. Son `Codable` y sus nombres son las
  claves de `armonia … --json`, que no cambian. De ellos salen el texto de `armonia`, su JSON, la serie de la app
  (`PresentacionDeSerie`) y `AnalisisPostonalPresentado`, que tiene además `init(_:)` desde un `DatosDeConjunto`.

- **GUIDO en el menú de exportar, y todos los formatos de una vez.** `FicheroParaExportar.Formato.guido` («Partitura
  GUIDO», `.gmn`, con su texto en los quince idiomas). `FicheroParaExportar.partituras(nombre:_:)` da una partitura
  por cada `FormatoDePartitura`, en su orden, y `partitura(_:formato:nombre:)`, una. `Formato(_:)` y
  `Formato.partitura` pasan de un tipo al otro. Todas las presentaciones que exportan (análisis, coral, arpegios,
  disposiciones, escalas, contrapunto y serie) dan ahora seis ficheros en lugar de cinco, con el GUIDO entre el
  LilyPond y el ABC. Las partituras de texto del contrapunto y de la serie llevan el tempo, como su MIDI.

- **Series dodecafónicas en las apps.** `PresentacionDeSerie.presentar(_:forma:notacion:)` da una serie
  (`SeriePresentada`) con sus notas, sus intervalos, sus hexacordos, sus formas combinatorias, la matriz con el nombre
  de cada fila y columna, y la forma elegida con su pentagrama, su sonido y sus ficheros para exportar.
  `PresentacionDeSerie.indicacion(en:)` es lo que pide el campo. Textos nuevos en los quince idiomas. En Armonía, la
  serie se abre desde Identificar.

## 0.3.2 (2026-11-03)

- **El arpegio con su ritmo en el pentagrama.** `PentagramaPresentado(_:titulo:tonalidad:notacion:nombresDeLasNotas:resaltada:)`
  dibuja una voz con sus figuras, barras y compás, y con la armadura de la tonalidad si se da. La pestaña de acordes
  de la app enseña (y exporta) el arpegio con la figura y los tresillos con que suena.

- **Acordes en las doce tonalidades y arpegios en el mástil.**
  `PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(_:cuatriadas:notacion:)` (`TablaDeAcordesPresentada`:
  los acordes de cada grado de quinta en quinta, con sonido y partitura) y
  `PresentacionDeArpegios.enElMastil(_:formas:idaYVuelta:mastil:notacion:)` (`ArpegioEnElMastilPresentado`, por
  posiciones, CAGED o con una nota por cuerda, con tablatura, dedos, sonido y MusicXML). Textos nuevos en los quince
  idiomas.

- **Escalas propias.** `PresentacionDeEstudioDeEscala`: `vecinas(de:notacion:)`, `reloj(de:orden:notacion:)` (el
  reloj de la escala en SVG) y `enLasDoceTonalidades(_:secuencia:notacion:)` (`HojaDeEstudioPresentada`, con
  pentagramas, sonido y ficheros). Textos nuevos en los quince idiomas.

- **Más escalas.** `PresentacionDeEstudioDeEscala`: `escalas(conLasNotas:)` y `escalas(de:)` (`EscalaEncontrada`, con
  las notas que añade cada una), `simetria(de:)` (`SimetriaPresentada`), `lineasDeNotasGuia`, `formasPentatonicas` y
  `secuenciaEnLasPosiciones` (`PosicionPresentada`, con tablatura de texto y MusicXML), `tablatura(_:en:notacion:)` y
  `teclado(de:mano:octavas:notacion:)`, el teclado de piano en SVG. Textos nuevos en los quince idiomas.

- **Textos de los teclados de cuadrícula**: `ejesHV`, `rejilla`, `notaDeOrigen` y `enTono`, en los quince idiomas.

- **Estudiar escalas.** `PresentacionDeEstudioDeEscala`: `secuencia` (`SecuenciaPresentada`, con pentagrama,
  sonido y ficheros para exportar), `digitaciones` (`DigitacionDePianoPresentada`), `modosParalelos` y
  `modosRelativos` (`ModoPresentado`), `comparar` (`ComparacionDeEscalasPresentada`) y `bebop` y `pentatonicas`
  sobre un acorde (`EscalaSobreElAcordePresentada`). `AnalisisPresentado.cambiosDeEscala(en:)` da, por acorde, las
  notas que cambian y las notas guía. Textos nuevos en los quince idiomas.

- **Más acordes.** `PresentacionDeRelacionesDeAcorde.relaciones(de:en:notacion:)` (otros nombres, sin la
  fundamental, tonalidades con su función y sustituciones con su sonido) y `comparar(_:con:disposicion:notacion:)`
  (notas comunes, cada voz con su movimiento y el movimiento total). `PresentacionDeDisposiciones.gruposDeCuerdas` y
  `enElMastil` dan las disposiciones en la guitarra con su tablatura y los dedos, y `acorde(_:_:notacion:)` da ya
  los ficheros para exportar. Textos nuevos en los quince idiomas.

- **Arpegios con tempo, swing y enlace.** `PresentacionDeArpegios.arpegio(_:figura:tempo:swing:notacion:)` y
  `progresion(…enlazados:tempo:swing:…)`; `AnalisisPresentado.arpegiada(_:figura:enlazados:notacion:)`. El tempo va
  también en las partituras; el swing solo cambia cómo suena (`Escucha.conSwing(pulso:proporcion:)`, larga-corta en
  cada pulso). La figura puede ser de tresillo. Textos nuevos en los quince idiomas para las opciones del arpegio
  en las apps.

- **`DisposicionDeAcorde.cuartal`** se nombra en los quince idiomas («Por cuartas», «Quartal»), y Armonía la ofrece
  junto a las demás disposiciones.
- **`PresentacionDeEscalaYAcorde.acordesQueCaben(_:notacion:)`** (`AcordesDelGrado`) y
  `EscalaSobreAcordePresentada.estructurasSuperiores`. En Armonía, la vista de escalas pliega por grado todos los
  acordes que caben (cada uno se abre en Acordes) y el análisis pone las estructuras superiores debajo de cada
  acorde. Las escalas compatibles de la vista de acordes salen de las que menos notas a evitar tienen a las que más.
- **`PresentacionDeEscalaYAcorde`**: una escala sobre un acorde, con su nombre, de qué escala es modo, cada nota
  con su grado y las tensiones y notas a evitar (`EscalaSobreAcordePresentada`). Cada fila del análisis lleva la
  escala de su acorde (`AnalisisPresentado.Fila.escala`). En Armonía, la vista de análisis la enseña debajo de cada
  acorde, la de acordes pone las tensiones y notas a evitar de cada escala compatible y la de escalas dice de qué
  escala es modo (y la abre).
- **`PresentacionDeDisposiciones`**: las disposiciones de un acorde (de Do3 a Sol5) y una progresión dispuesta con
  el menor movimiento de las voces, con sus filas, su pentagrama, su sonido y, en la progresión, la partitura y el
  MIDI. `PentagramaPresentado` dibuja acordes con sus alturas escritas, y `DisposicionDeAcorde.nombre(en:)` los
  nombra en los quince idiomas (los drops, igual en todos).
- **`PresentacionDeContrapunto`**, la vista de contrapunto de la app de armonía: comprueba un contrapunto de
  especies y lo enseña con una fila por compás (sus notas, los intervalos con el cantus y las faltas que lo tocan),
  las faltas una a una, el sonido de las dos voces (con el compás que suena) y los ficheros para exportar. Trae un
  ejemplo sin faltas de cada especie sobre el cantus en re de Fux.
- **`RecorridoDePartitura`**, «Partitura» en la app del Tonnetz: los acordes de un fichero MIDI, MusicXML, MEI o
  ABC con su ritmo armónico y, entre cada dos tríadas, las transformaciones P, L y R que llevan de una a otra.
  `tramo(hasta:longitud:)` da las tríadas seguidas que se dibujan con sus flechas.
- Textos nuevos en los quince idiomas: contrapunto, especie, los campos del cantus y del contrapunto, el número de
  compás, partitura, anterior, siguiente y la indicación para abrir una partitura.
- Paquete propio: `ArmoniaPresentacion` (lo que enseñan las apps y la línea de comandos, sin SwiftUI) estaba dentro de
  `Packages/ArmoniaUI` y ahora está en `Packages/ArmoniaPresentacion`, con sus pruebas, su CI y su documentación. Su
  historial anterior está en el CHANGELOG de `ArmoniaUI`.
