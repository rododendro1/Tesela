# InterfazArmonia

Las vistas de SwiftUI que comparten ArsHarmonicaApp y TonnetzApp: pentagramas, mástiles, redes de notas, «Escuchar»,
«Exportar» y el selector de notación. Dibuja y hace sonar lo que prepara `ExposicionArmonia`; las vistas leen la notación
elegida del entorno (`@Environment(\.notacion)`), así que basta con ponerla una vez en la raíz de la app.

Depende de `ExposicionArmonia`, `Armonia` y `Hexagonos`, y solo la usan las apps. Necesita SwiftUI (iOS 16 o macOS 13); en
Linux se compila y se prueba lo que no lo usa.

## Qué hay

| Carpeta      | Qué tiene                                                                                         |
|--------------|---------------------------------------------------------------------------------------------------|
| `Ajustes/`   | Los ajustes y el entorno de las apps, el selector de notación y el tema                           |
| `Diagramas/` | `DiagramaDeMastil`, `DiagramaDePentagrama`, `DiagramaDeTonnetz`, `DiagramaDeRejilla` y `VistaSVG` |
| `Modelos/`   | Lo que eligen y calculan las vistas de acordes, de análisis, del catálogo y del Tonnetz, sin SwiftUI |
| `Sonido/`    | El reproductor de «Escuchar» y la entrada MIDI                                                    |

Fuera de las carpetas están el botón y las exportaciones de «Exportar» y el selector para abrir una partitura. La
documentación de DocC está en `Sources/InterfazArmonia/InterfazArmonia.docc`.

```sh
cd Packages/InterfazArmonia && swift test
```
