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
| `Acordes/`           | Los arpegios (también en el mástil), las disposiciones, las relaciones de un acorde y la tablatura |
| `Analisis/`          | El análisis armónico (y sus hojas, el bajo, las doce tonalidades), la tonalidad, las modulaciones, la transposición, el análisis postonal y la serie |
| `CoralYContrapunto/` | El coral a cuatro voces, el contrapunto de especies y la rearmonización                     |
| `Escalas/`           | El estudio de una escala: sus acordes, sus progresiones, sus estadísticas, el mapa de brillo y la comparación con otras |
| `Relaciones/`        | Lo que separa a dos acordes, a dos escalas o a los acordes de una progresión, y cómo encaja un acorde en una tonalidad |
| `Redes/`             | El Tonnetz, la tabla armónica y los teclados isomórficos, y el recorrido de una partitura     |
| `Textos/`            | `TextosDeApps`, un fichero por idioma                                                        |

La documentación de DocC está en `Sources/Exposicion/Exposicion.docc`.

```sh
cd Packages/Exposicion && swift test
```
