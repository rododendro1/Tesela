import Armonia
import InterfazArmonia
import SwiftUI

/// Las opciones de un selector de instrumento: los de `Encordado.todos`, agrupados por familias, cada uno con su
/// nombre y su afinación. Va dentro de un `Picker` con la selección de un `Encordado`.
struct OpcionesDeEncordado: View {
    @Environment(\.notacion) private var notacion

    var body: some View {
        ForEach(FamiliaDeEncordado.allCases, id: \.self) { familia in
            Section(familia.nombre(en: notacion)) {
                ForEach(familia.encordados, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
            }
        }
    }
}

/// La ficha de un instrumento, plegada: su familia, su afinación, sus cuerdas y sus órdenes en octavas, sus trastes,
/// sus estilos y de dónde viene (`EncordadoPresentado.ficha(en:)`).
struct FichaDelEncordado: View {
    let encordado: Encordado
    @Environment(\.notacion) private var notacion

    var body: some View {
        DisclosureGroup(notacion.texto(\.fichaDelInstrumento)) {
            ForEach(EncordadoPresentado(encordado, en: notacion).ficha(en: notacion), id: \.nombre) { dato in
                LabeledContent(dato.nombre, value: dato.valor)
            }
        }
    }
}
