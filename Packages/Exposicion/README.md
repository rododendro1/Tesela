# Exposicion

Lo que las apps y la línea de comandos enseñan del motor, ya preparado para mostrarlo, oírlo y exportarlo: los tramos
y cadencias de un análisis, las filas de un coral, el estudio de una escala, la tablatura, lo que suena al pulsar
«Escuchar», los ficheros que se comparten y los textos de la interfaz en los trece idiomas. No usa SwiftUI, así que
la comparten ArsHarmonicaApp, TonnetzApp y la herramienta `armonia`, y se prueba igual en Linux que en macOS.

Depende de `Armonia` y de `Hexagonos`. La usa `Interfaz`, que la dibuja, y `ConsolaArmonia`, que la escribe en el
terminal.

## Qué hay

| Carpeta              | Qué presenta                                                                                 |
|----------------------|----------------------------------------------------------------------------------------------|
| `Acordes/`           | Lo que se consulta de un acorde, los arpegios (también en el mástil), las disposiciones, las relaciones de un acorde, la tablatura y sus medidas (`ValorDeMedida`) |
| `Analisis/`          | El análisis armónico (y sus hojas, el bajo, las doce tonalidades), la tonalidad, las modulaciones y la transposición |
| `Catalogos/`         | Los elementos con nombre de los catálogos (acordes, progresiones, notas, funciones de nota, ritmos y temperamentos), con su ficha, sus medidas, sus estilos y su origen, y lo común a todos: `ElementoConNombrePresentado` y `OrigenPresentado`, de cuándo es cada elemento |
| `CoralYContrapunto/` | El coral a cuatro voces, el contrapunto de especies y la rearmonización                     |
| `Escalas/`           | Lo que se consulta de una escala y su estudio: sus acordes, sus progresiones, sus estadísticas, el mapa de brillo y la comparación con otras |
| `Partituras/`        | El pentagrama de una escala o de un acorde                                                   |
| `Postonal/`          | Lo que se consulta de un conjunto o de una serie, el análisis postonal y la matriz de la serie |
| `Redes/`             | El Tonnetz, la tabla armónica y los teclados isomórficos, y el recorrido de una partitura     |
| `Relaciones/`        | Lo que separa a dos acordes, a dos escalas o a los acordes de una progresión, y cómo encaja un acorde en una tonalidad |
| `Sonido/`            | Lo que suena al pulsar «Escuchar» y lo que llega de un teclado MIDI                          |
| `Textos/`            | `TextosDeApps`, un fichero por idioma                                                        |

En la raíz quedan `FicheroParaExportar`, lo que se comparte, y `Notacion+TextosDeApps`. La documentación de DocC
está en `Sources/Exposicion/Exposicion.docc`.

```sh
cd Packages/Exposicion && swift test
```
