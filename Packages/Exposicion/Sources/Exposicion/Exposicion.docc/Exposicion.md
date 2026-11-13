# ``Exposicion``

Lo que las apps y la línea de comandos enseñan del motor, ya preparado para mostrarlo, oírlo y exportarlo.

## Overview

Entre el motor (`Armonia`) y las vistas (`Interfaz`) hay una capa que decide qué se muestra: los tramos y
cadencias de un análisis, las filas de un coral, el texto de cada aviso en el idioma elegido, lo que suena al
pulsar «Escuchar» y los ficheros que se comparten. Vive aquí, sin SwiftUI, para que la compartan ArsHarmonicaApp,
TonnetzApp y la herramienta `armonia`, y para que se pruebe en Linux.

```swift
import Armonia
import Exposicion

let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .compacta(.espanol))
analisis.titulo                                   // "I–vi–V7/V–V7–I en Do mayor"
analisis.tramos.flatMap(\.filas).map(\.grado)     // ["I", "vi", "V7/V", "V7", "I"]
analisis.ficheros.map(\.formato)                  // [.musicXML, .mei, .midi]
```

Cada presentación da tres cosas a la vez:

- **Lo que se lee**, ya escrito en la notación elegida: ``AnalisisPresentado``, ``CoralPresentado``,
  ``AnalisisPostonalPresentado``…
- **Lo que suena**, una ``Escucha``: notas MIDI con su inicio y su duración, que el reproductor de Interfaz toca y que
  ``Escucha/afinado(en:)`` lleva a otro temperamento.
- **Lo que se exporta**, una lista de ``FicheroParaExportar`` (MusicXML, MEI, MIDI o SVG), con su nombre de fichero.

Los nombres siguen dos reglas. Las funciones están en un espacio de nombres `PresentacionDeX` (``PresentacionDeCoral``,
``PresentacionDeAnalisis``…) y lo que devuelven se llama `XPresentado` o `XPresentada`; cada fichero se llama como el
tipo que guarda. La notación se pasa con `en:` (`PentagramaPresentado(escala, en: notacion)`), salvo cuando `en:` ya es
la tonalidad, el mástil o la red: entonces va con `notacion:` (`PresentacionDeAnalisis.analizar(texto, en: tonalidad,
notacion: notacion)`).

Los textos de la interfaz (pestañas, etiquetas, indicaciones) son campos de ``TextosDeApps``, en los mismos trece
idiomas que los textos del motor, y se leen con `notacion.texto(\.digitaciones)`: siguen la notación elegida, así que
el selector de notación cambia la app entera.

## Topics

### Análisis

- ``PresentacionDeAnalisis``
- ``AnalisisPresentado``
- ``TramoPresentado``

### Abrir ficheros

- ``ImportacionDeProgresion``
- ``ProgresionImportada``
- ``RecorridoDePartitura``

### Coral a cuatro voces

- ``PresentacionDeCoral``
- ``CoralPresentado``

### Contrapunto de especies

- ``PresentacionDeContrapunto``
- ``ContrapuntoPresentado``

### Series dodecafónicas

- ``PresentacionDeSerie``
- ``MatrizDeSeriePresentada``

### Transponer y rearmonizar

- ``PresentacionDeTransposicion``
- ``PresentacionDeRearmonizacion``
- ``PropuestaDeRearmonizacion``

### Arpegios, pentagramas y tablaturas

- ``PresentacionDeArpegios``
- ``ArpegioPresentado``
- ``PentagramaPresentado``
- ``PresentacionDeDisposiciones``
- ``DisposicionesPresentadas``
- ``DisposicionEnElMastilPresentada``
- ``PresentacionDeRelacionesDeAcorde``
- ``RelacionesPresentadas``
- ``ComparacionPresentada``
- ``PresentacionDeEstadisticasDeAcorde``
- ``EstadisticasDeAcordePresentadas``
- ``MedidaDeAcorde``
- ``ValorDeMedida``
- ``ResumenDeAcordesPresentado``
- ``PresentacionDeEstudioDeEscala``
- ``EleccionDeEscala``
- ``SecuenciaPresentada``
- ``DigitacionDePianoPresentada``
- ``ModoPresentado``
- ``ComparacionDeEscalasPresentada``
- ``EscalaConDetallePresentada``
- ``EscalaEncontrada``
- ``SimetriaPresentada``
- ``HojaDeEstudioPresentada``
- ``TablaDeAcordesPresentada``
- ``ArpegioEnElMastilPresentado``
- ``FormasDeArpegio``
- ``PosicionPresentada``
- ``PresentacionDeTablatura``

### Redes de notas

El Tonnetz, la tabla armónica y los teclados isomórficos y de cuadrícula en que la app Tonnetz y `armonia tonnetz`,
`armonia tabla` y `armonia cuadricula` dibujan unas notas.

- ``RedDeNotas``
- ``ContenidoDeRed``
- ``PresentacionDeRedes``
- ``AjusteUIL``
- ``AjusteCuadrado``

### Conjuntos de clases

- ``AnalisisPostonalPresentado``

### Sonido y teclados MIDI

- ``Escucha``
- ``CambioMIDI``

### Catálogos con nombre

Un elemento de uno de los catálogos con nombre, escrito con su nombre, sus alias, las citas de sus obras y su origen
(``ElementoConNombrePresentado``), igual en la consola, la app y las hojas.

- ``ElementoConNombrePresentado``
- ``OrigenPresentado``
- ``AcordeConNombrePresentado``
- ``ProgresionConNombrePresentada``
- ``RitmoPresentado``
- ``TemperamentoPresentado``
- ``NotaPresentada``
- ``FuncionDeNotaPresentada``
- ``OrigenDeEscalaPresentado``

### Consultas

Lo que se consulta de un acorde, unas notas, una escala, un conjunto o una serie, sin darle forma: lo mismo para el
texto de `armonia`, para su `--json` (son sus claves) y para las apps.

- ``AcordePresentado``
- ``CandidatoPresentado``
- ``EscalaPresentada``
- ``ConjuntoPresentado``
- ``SeriePresentada``

### Exportar

- ``FicheroParaExportar``

### Textos de la interfaz

- ``TextosDeApps``
- ``CampoDeLasApps``
