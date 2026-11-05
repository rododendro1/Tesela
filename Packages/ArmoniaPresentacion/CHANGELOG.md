# Cambios

## Sin publicar

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
