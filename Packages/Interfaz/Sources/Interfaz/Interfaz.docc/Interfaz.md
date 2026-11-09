# ``Interfaz``

Las vistas de SwiftUI que comparten ArsHarmonicaApp y TonnetzApp: pentagramas, mástiles, redes de notas, «Escuchar»,
«Exportar» y el selector de notación.

## Overview

Interfaz dibuja y hace sonar lo que prepara `Exposicion`, la capa sin SwiftUI que comparten las apps y la
línea de comandos. Las vistas leen la notación elegida del entorno (`@Environment(\.notacion)`), así que basta con
ponerla una vez en la raíz de la app y añadir el selector a la barra:

```swift
import SwiftUI
import Armonia
import Exposicion
import Interfaz

struct VistaDeEscala: View {
    @Environment(\.notacion) private var notacion
    let escala = Escala("Re dórico")

    var body: some View {
        let pentagrama = PentagramaPresentado(escala, en: notacion)
        VStack {
            DiagramaDePentagrama(pentagrama)
            BotonDeEscuchar(.escala(escala))
        }
        .toolbar { ToolbarItem { BotonDeExportar([pentagrama.fichero]) } }
        .selectorDeNotacionEnLaBarra()
    }
}

// En la raíz de la app: WindowGroup { VistaDeEscala().notacionGuardada() }
```

Las vistas están tras `#if canImport(SwiftUI)`: en Linux el módulo compila solo con lo que no dibuja (la notación
guardada, dónde se toca un mástil o una rejilla), que es lo que se prueba allí. Las redes de notas que dibuja
``DiagramaDeTonnetz`` (`RedDeNotas`, `ContenidoDeRed`, `PresentacionDeRedes`, `AjusteUIL` y `AjusteCuadrado`) están
en `Exposicion`, que este módulo reexporta, porque también las dibuja la línea de comandos.

## Topics

### Dibujos

- ``DiagramaDePentagrama``
- ``DiagramaDeMastil``
- ``DiagramaDeTonnetz``
- ``DiagramaDeRejilla``
- ``VistaSVG``

### Sonido y teclados MIDI

- ``Reproductor``
- ``BotonDeEscuchar``
- ``EntradaMIDI``

### Exportar

- ``BotonDeExportar``

### Notación, ajustes y aspecto

- ``SelectorDeNotacion``
- ``AjustesDeLasApps``
- ``TemaDeLasApps``

### Cálculos mientras se escribe

- ``Calculado``
- ``FilaCalculando``
