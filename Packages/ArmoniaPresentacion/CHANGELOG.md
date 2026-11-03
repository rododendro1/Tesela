# Cambios

## Sin publicar

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
