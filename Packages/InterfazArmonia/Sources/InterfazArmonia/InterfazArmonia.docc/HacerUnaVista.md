# Hacer una vista

Una vista de un acorde con lo que tienen las de las apps: su pentagrama, «Escuchar», «Exportar», la notación elegida
y lo último que se escribió.

## Overview

Las vistas de ArsHarmonicaApp y TonnetzApp se hacen en tres capas, y esta también:

1. **El motor** (`Armonia`) lee el cifrado y sabe qué notas tiene el acorde.
2. **La exposición** (`ExposicionArmonia`) decide qué se enseña, qué suena y qué se exporta, en la notación elegida.
   No usa SwiftUI, así que se prueba en Linux.
3. **La interfaz** (`InterfazArmonia`) lo dibuja y lo hace sonar.

### Lo que se enseña, sin SwiftUI

``ModeloDeAcordes`` guarda lo escrito y lee el acorde. `PentagramaPresentado`, de `ExposicionArmonia`, es el
pentagrama ya dibujado en SVG, con su fichero para exportarlo, y `Escucha` es lo que suena: las notas MIDI con su
inicio y su duración.

```swift
import Armonia
import ExposicionArmonia
import InterfazArmonia

var modelo = ModeloDeAcordes(texto: "Lam7")
modelo.acorde                                   // Lam7
modelo.texto = "Lam7("                          // a medio escribir
modelo.acorde                                   // nil

let acorde = Acorde("Sol7/Si")
let pentagrama = PentagramaPresentado(acorde, en: .compacta(.espanol))
pentagrama.fichero                              // el SVG, para «Exportar»
Escucha.acorde(acorde)                          // lo que suena con «Escuchar»
```

Todo esto se prueba con `swift test` también en Linux: la lógica de la vista vive en el modelo, y la vista solo la
pinta.

### La vista

La vista lee la notación del entorno (`@Environment(\.notacion)`) y empieza por lo último que se escribió en la pestaña
de acordes (``MemoriaDeLasApps``). ``DiagramaDePentagrama`` dibuja el pentagrama, ``BotonDeEscuchar`` lo hace sonar y
``BotonDeExportar`` lo comparte. `recordando(_:en:valido:)` anota el acorde cuando se deja de escribir un segundo, y
``MenuDeRecuerdos`` vuelve a lo reciente y a los favoritos.

```swift
import SwiftUI
import Armonia
import ExposicionArmonia
import InterfazArmonia

struct VistaDeUnAcorde: View {
    @Environment(\.notacion) private var notacion
    /// Lo escrito, que empieza por lo último que se escribió en la pestaña de acordes.
    @State private var modelo = ModeloDeAcordes(recordado: .cargar())

    var body: some View {
        Form {
            TextField("Sol7/Si", text: $modelo.texto)
            if let acorde = modelo.acorde {
                let pentagrama = PentagramaPresentado(acorde, en: notacion)
                Section(notacion.texto(\.resultado)) {
                    DiagramaDePentagrama(pentagrama)
                    BotonDeEscuchar(.acorde(acorde))
                    BotonDeExportar([pentagrama.fichero])
                }
            }
        }
        .recordando(modelo.texto, en: .acordes, valido: modelo.acorde != nil)
        .toolbar { ToolbarItem { MenuDeRecuerdos(.acordes, texto: $modelo.texto) } }
        .selectorDeNotacionEnLaBarra()
    }
}
```

Los textos de la interfaz salen de `TextosDeApps` en la notación elegida (`notacion.texto(\.resultado)`), así que
la vista habla los trece idiomas sin hacer nada más.

### En la raíz de la app

`notacionGuardada()` pone en el entorno la notación que guarda el selector de la barra, la misma en todas las vistas:

```swift
@main
struct MiApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { VistaDeUnAcorde() }
                .notacionGuardada()
        }
    }
}
```

### Un cálculo largo

Lo que tarda (las digitaciones de un acorde en un mástil, por ejemplo) se hace fuera del hilo principal con
`calcularEnSegundoPlano(para:esperando:en:_:)`, que espera a que se deje de escribir y guarda el resultado en un
``Calculado``. Mientras tanto, ``FilaCalculando`` dice «Calculando…»:

```swift
@State private var digitaciones: Calculado<[Digitacion]>?

// En el cuerpo:
if let lista = digitaciones?.valor(para: modelo.claveDeLasDigitaciones) {
    Text("\(lista.count)")
} else {
    FilaCalculando()
}

// Y en la vista:
.calcularEnSegundoPlano(para: modelo.claveDeLasDigitaciones, en: $digitaciones) { [modelo] in
    modelo.digitaciones()
}
```
