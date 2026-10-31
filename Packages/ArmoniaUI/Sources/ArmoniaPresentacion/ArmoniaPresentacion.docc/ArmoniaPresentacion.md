# ``ArmoniaPresentacion``

Lo que las apps y la línea de comandos enseñan del motor, ya preparado para mostrarlo, oírlo y exportarlo.

## Overview

Entre el motor (`Armonia`) y las vistas (`ArmoniaUI`) hay una capa que decide qué se muestra: los tramos y
cadencias de un análisis, las filas de un coral, el texto de cada aviso en el idioma elegido, lo que suena al
pulsar «Escuchar» y los ficheros que se comparten. Vive aquí, sin SwiftUI, para que la compartan ArmoniaApp,
TonnetzApp y la herramienta `armonia`, y para que se pruebe en Linux.

```swift
import Armonia
import ArmoniaPresentacion

let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .espanolUnicode)
analisis.titulo                                   // "I–vi–V7/V–V7–I en Do mayor"
analisis.tramos.flatMap(\.filas).map(\.grado)     // ["I", "vi", "V7/V", "V7", "I"]
analisis.ficheros.map(\.formato)                  // [.musicXML, .mei, .midi]
```

Cada presentación da tres cosas a la vez:

- **Lo que se lee**, ya escrito en la notación elegida: ``AnalisisPresentado``, ``CoralPresentado``,
  ``AnalisisPostonalPresentado``…
- **Lo que suena**, una ``Escucha``: notas MIDI con su inicio y su duración, que el reproductor de ArmoniaUI toca y que
  ``Escucha/afinado(en:)`` lleva a otro temperamento.
- **Lo que se exporta**, una lista de ``FicheroParaExportar`` (MusicXML, MEI, MIDI o SVG), con su nombre de fichero.

Los textos de la interfaz (pestañas, etiquetas, indicaciones) están en ``TextoDeLasApps``, en los mismos catorce
idiomas que los textos del motor: siguen la notación elegida, así que el selector de notación cambia la app entera.

## Topics

### Análisis

- ``PresentacionDeAnalisis``
- ``AnalisisPresentado``
- ``TramoPresentado``
- ``RitmoArmonico``

### Abrir ficheros

- ``ImportacionDeProgresion``
- ``ProgresionImportada``

### Coral a cuatro voces

- ``PresentacionDeCoral``
- ``CoralPresentado``

### Transponer y rearmonizar

- ``PresentacionDeTransposicion``
- ``PresentacionDeRearmonizacion``
- ``PropuestaDeRearmonizacion``

### Arpegios, pentagramas y tablaturas

- ``PresentacionDeArpegios``
- ``ArpegioPresentado``
- ``PentagramaPresentado``
- ``PresentacionDeTablatura``

### Conjuntos de clases

- ``AnalisisPostonalPresentado``

### Sonido y teclados MIDI

- ``Escucha``
- ``CambioMIDI``

### Exportar

- ``FicheroParaExportar``

### Textos de la interfaz

- ``TextoDeLasApps``
