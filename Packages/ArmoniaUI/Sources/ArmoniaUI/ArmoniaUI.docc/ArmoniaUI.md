# ``ArmoniaUI``

Las vistas de SwiftUI que comparten ArmoniaApp y TonnetzApp: pentagramas, mástiles, redes de notas, «Escuchar»,
«Exportar» y el selector de notación.

## Overview

ArmoniaUI dibuja y hace sonar lo que prepara `ArmoniaPresentacion`, la capa sin SwiftUI que comparten las apps y la
línea de comandos. Las vistas leen la notación elegida del entorno (`@Environment(\.notacion)`), así que basta con
ponerla una vez en la raíz de la app y añadir el selector a la barra:

```swift
import SwiftUI
import Armonia
import ArmoniaPresentacion
import ArmoniaUI

struct VistaDeEscala: View {
    @Environment(\.notacion) private var notacion
    let escala = Escala("Re dórico")

    var body: some View {
        let pentagrama = PresentacionDePentagrama(escala, notacion: notacion)
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

Las vistas están tras `#if canImport(SwiftUI)`: en Linux el módulo compila solo con lo que no dibuja
(``RedDeNotas``, ``PresentacionDeRedes``, ``AjusteUIL``…), que es lo que se prueba allí.

## Topics

### Dibujos

- ``DiagramaDePentagrama``
- ``DiagramaDeMastil``
- ``DiagramaDeTonnetz``
- ``DiagramaDeRejilla``
- ``VistaSVG``

### Redes de notas

- ``RedDeNotas``
- ``ContenidoDeRed``
- ``PresentacionDeRedes``
- ``AjusteUIL``

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
