# ``ArmoniaPresentacion``

Lo que las apps y la línea de comandos enseñan del motor, ya preparado para mostrarlo, oírlo y exportarlo.

## Overview

Entre el motor (`Armonia`) y las vistas (`ArmoniaUI`) hay una capa que decide qué se muestra: los tramos y
cadencias de un análisis, las filas de un coral, el texto de cada aviso en el idioma elegido, lo que suena al
pulsar «Escuchar» y los ficheros que se comparten. Vive aquí, sin SwiftUI, para que la compartan ArsHarmonicaApp,
TonnetzApp y la herramienta `armonia`, y para que se pruebe en Linux.

```swift
import Armonia
import ArmoniaPresentacion

let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: .espanolCompacto)
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

Los textos de la interfaz (pestañas, etiquetas, indicaciones) son campos de ``TextosDeApps``, en los mismos quince
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
- ``SeriePresentada``

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
- ``PresentacionDeEstudioDeEscala``
- ``SecuenciaPresentada``
- ``DigitacionDePianoPresentada``
- ``ModoPresentado``
- ``ComparacionDeEscalasPresentada``
- ``EscalaSobreElAcordePresentada``
- ``EscalaEncontrada``
- ``SimetriaPresentada``
- ``HojaDeEstudioPresentada``
- ``TablaDeAcordesPresentada``
- ``ArpegioEnElMastilPresentado``
- ``FormasDeArpegio``
- ``PosicionPresentada``
- ``PresentacionDeTablatura``

### Conjuntos de clases

- ``AnalisisPostonalPresentado``

### Sonido y teclados MIDI

- ``Escucha``
- ``CambioMIDI``

### Datos de las consultas

Lo que se consulta de un acorde, unas notas, una escala, un conjunto o una serie, sin escribir: lo mismo para el
texto de `armonia`, para su `--json` (son sus claves) y para las apps.

- ``DatosDeAcorde``
- ``DatosDeCandidato``
- ``DatosDeEscala``
- ``DatosDeConjunto``
- ``DatosDeSerie``

### Exportar

- ``FicheroParaExportar``

### Textos de la interfaz

- ``TextosDeApps``
- ``CampoDeLasApps``
