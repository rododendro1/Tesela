import Armonia
import Interfaz
import SwiftUI

// Las secciones de la pestaña de escalas con lo que se relaciona con ella: los acordes que caben, las escalas más
// brillantes u oscuras, las vecinas y las parecidas, las progresiones, las doce tonalidades, los modos y otra escala
// para comparar. Lo que es una escala se abre al tocarlo.

/// Los acordes que caben sobre cada grado, no solo los de terceras (sus, sextas, add9, dominantes alteradas),
/// plegados por grado; cada uno se abre en la pestaña de acordes.
struct SeccionDeAcordesQueCaben: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion

    var body: some View {
        let grados = PresentacionDeEscalaYAcorde.acordesQueCaben(escala, en: notacion)
        if !grados.isEmpty {
            Section(notacion.texto(\.acordesQueCaben)) {
                ForEach(grados, id: \.self) { grado in
                    DisclosureGroup("\(grado.grado) (\(grado.acordes.count))") {
                        ForEach(Array(grado.acordes.enumerated()), id: \.offset) { _, acorde in
                            Button(acorde.cifrado(en: notacion)) { navegacion.ver(acorde) }
                        }
                    }
                }
            }
        }
    }
}

/// Las escalas con la misma tónica, de la más oscura a la más brillante, subiendo una nota cada vez; la de partida,
/// en negrita.
struct SeccionDeLaEscaleraDeBrillo: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion

    var body: some View {
        let peldanos = PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, en: notacion)
        if peldanos.count > 1 {
            Section(notacion.texto(\.escaleraDeBrillo)) {
                ForEach(peldanos, id: \.self) { peldano in
                    HStack {
                        Button {
                            navegacion.ver(peldano.escala)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(peldano.nombre).bold(peldano.esLaDePartida)
                                Text([peldano.brillo, peldano.cambio].filter { !$0.isEmpty }.joined(separator: " · "))
                                    .font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        BotonDeEscuchar(peldano.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

/// Una sección de escalas con su detalle debajo y «Escuchar» (las vecinas, que salen moviendo una nota un semitono,
/// o las parecidas, que comparten más notas); nada si no hay ninguna.
struct ListaDeEscalas: View {
    let escalas: [EscalaConDetallePresentada]
    let titulo: String
    @EnvironmentObject private var navegacion: Navegacion

    init(_ escalas: [EscalaConDetallePresentada], titulo: String) {
        self.escalas = escalas
        self.titulo = titulo
    }

    var body: some View {
        if !escalas.isEmpty {
            Section(titulo) {
                ForEach(escalas, id: \.self) { vecina in
                    HStack {
                        Button {
                            navegacion.ver(vecina.escala)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(vecina.nombre)
                                Text(vecina.detalle).font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        BotonDeEscuchar(vecina.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

/// Progresiones con las tríadas de la escala, con sus grados y las notas que no son de la mayor o la menor, para
/// escucharlas.
struct SeccionDeProgresiones: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        let progresiones = PresentacionDeEstudioDeEscala.progresiones(de: escala, en: notacion)
        if !progresiones.isEmpty {
            Section(notacion.texto(\.progresionesEnLaEscala)) {
                ForEach(progresiones, id: \.self) { progresion in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(progresion.grados).bold()
                            Text(progresion.cifrados).font(.system(.footnote, design: .monospaced))
                            if !progresion.fuera.isEmpty {
                                Text(progresion.fuera).font(.caption).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        BotonDeEscuchar(progresion.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

/// La escala en las doce tonalidades, de quinta en quinta, para escucharla seguida y exportarla con la barra.
struct SeccionDeLasDoceTonalidades: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(escala, en: notacion)
        Section(notacion.texto(\.enLasDoceTonalidades)) {
            BotonDeEscuchar(hoja.sonido)
            ForEach(hoja.tonalidades, id: \.titulo) { tonalidad in
                DisclosureGroup(tonalidad.titulo) {
                    Text(tonalidad.notas).font(.system(.footnote, design: .monospaced))
                    DiagramaDePentagrama(tonalidad.pentagrama)
                    BotonDeEscuchar(tonalidad.sonido)
                }
            }
        }
    }
}

/// Los acordes de cada grado en las doce tonalidades, si la escala forma uno en cada grado: una fila por tonalidad,
/// para escucharla, y la partitura con todos para exportarla.
struct SeccionDeLosAcordesEnLasDoceTonalidades: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion
    /// Si los acordes llevan séptima.
    @State private var conSeptima = true

    var body: some View {
        if let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
            escala, cuatriadas: conSeptima, en: notacion)
        {
            Section(notacion.texto(\.acordesEnLasDoceTonalidades)) {
                Toggle(notacion.texto(\.conSeptima), isOn: $conSeptima)
                HStack {
                    BotonDeEscuchar(tabla.sonido)
                    Spacer()
                    BotonDeExportar(tabla.ficheros)
                }
                .buttonStyle(.borderless)
                Text(tabla.grados.joined(separator: " · "))
                    .font(.system(.footnote, design: .monospaced)).foregroundColor(.secondary)
                ForEach(tabla.filas, id: \.tonalidad) { fila in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(fila.tonalidad)
                            Text(fila.acordes.joined(separator: " · ")).font(.system(.footnote, design: .monospaced))
                        }
                        Spacer()
                        BotonDeEscuchar(fila.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

/// Los modos sobre la misma tónica, del más brillante al más oscuro, con lo que cambia cada uno, y los modos con las
/// mismas notas.
struct SeccionDeLosModos: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion

    var body: some View {
        let paralelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion)
        let relativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, en: notacion)
        Section(notacion.texto(\.modosParalelos)) {
            ForEach(paralelos, id: \.self) { fila(de: $0) }
        }
        if !relativos.isEmpty {
            Section(notacion.texto(\.modosRelativos)) {
                ForEach(relativos, id: \.self) { fila(de: $0) }
            }
        }
    }

    private func fila(de modo: ModoPresentado) -> some View {
        HStack {
            Button {
                navegacion.ver(modo.escala)
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(modo.brillo.isEmpty ? modo.nombre : modo.nombre + " (" + modo.brillo + ")")
                    if !modo.cambios.isEmpty {
                        Text(modo.cambios).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            BotonDeEscuchar(modo.sonido).labelStyle(.iconOnly)
        }
        .buttonStyle(.borderless)
    }
}

/// La escala elegida y otra escrita: notas comunes, las que solo están en una, los grados que cambian y la distancia
/// en el círculo de quintas, y nota a nota, para exportarla con la barra.
struct SeccionDeLaComparacion: View {
    let escala: Escala
    @Binding var otraEscala: String
    @Environment(\.notacion) private var notacion

    var body: some View {
        Section(notacion.texto(\.compararCon)) {
            TextField(notacion.campo(.escala), text: $otraEscala)
                .comoCampoDeCifrado()
            if let otra = try? Escala(leyendo: otraEscala) {
                let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, en: notacion)
                LabeledContent(notacion.texto(\.notasComunes), value: comparacion.comunes)
                ForEach([comparacion.soloEnOrigen, comparacion.soloEnDestino].filter { !$0.isEmpty }, id: \.self) {
                    Text($0)
                }
                ForEach(comparacion.cambios, id: \.self) { Text($0).font(.system(.body, design: .monospaced)) }
                HStack {
                    if let distancia = comparacion.distancia {
                        Text(distancia).foregroundColor(.secondary)
                    }
                    Spacer()
                    BotonDeEscuchar(comparacion.sonido).labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                // Nota a nota: los dos pentagramas, la tabla grado a grado y el reloj con las dos encima.
                let hoja = PresentacionDeEstudioDeEscala.comparacionNotaANota(escala, con: otra, en: notacion)
                let tamano = PresentacionDeEstudioDeEscala.tamano(deUnSVG: hoja) ?? (ancho: 595, alto: 842)
                VistaSVG(svg: hoja)
                    .aspectRatio(CGSize(width: tamano.ancho, height: tamano.alto), contentMode: .fit)
                    .accessibilityLabel(Text(escala.nombre(en: notacion) + " → " + otra.nombre(en: notacion)))
            }
        }
    }
}
