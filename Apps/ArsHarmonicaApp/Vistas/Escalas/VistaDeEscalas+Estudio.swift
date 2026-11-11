import Armonia
import Interfaz
import SwiftUI

// Las secciones de la pestaña de escalas para estudiarla: la secuencia, la digitación de piano, la simetría, las
// estadísticas, el mapa de brillo, el reloj y la hoja de estudio.

/// La escala en una secuencia de estudio (por terceras, en grupos, en tríadas…), subiendo o bajando, con su
/// pentagrama y «Escuchar»; se exporta con la barra.
struct SeccionDeLaSecuencia: View {
    let presentada: SecuenciaPresentada
    @Binding var secuencia: SecuenciaDeEscala
    @Binding var bajando: Bool
    @Binding var octavas: Int
    @Environment(\.notacion) private var notacion

    var body: some View {
        Section(notacion.texto(\.secuencia)) {
            Picker(notacion.texto(\.secuencia), selection: $secuencia) {
                ForEach(SecuenciaDeEscala.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            Toggle(notacion.texto(\.bajando), isOn: $bajando)
            Stepper("\(notacion.texto(\.octavas)): \(octavas)", value: $octavas, in: 1...3)
            if presentada.notas.isEmpty {
                Text("—").foregroundColor(.secondary)
            } else {
                Text(presentada.notas).font(.system(.footnote, design: .monospaced))
                DiagramaDePentagrama(presentada.pentagrama)
                BotonDeEscuchar(presentada.sonido)
            }
        }
    }
}

/// La digitación de piano de cada mano, con el dedo debajo de cada nota y dibujada en un teclado.
struct SeccionDeLaDigitacionDePiano: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        let teclados = PresentacionDeEstudioDeEscala.teclados(de: escala, en: notacion)
        Section(notacion.texto(\.digitacionDePiano)) {
            ForEach(
                Array(PresentacionDeEstudioDeEscala.digitaciones(escala, en: notacion).enumerated()),
                id: \.offset
            ) { i, mano in
                VStack(alignment: .leading, spacing: 4) {
                    Text(mano.mano).bold()
                    let pares = zip(mano.notas.split(separator: " "), mano.dedos.split(separator: " "))
                    Text(pares.map { "\($0) \($1)" }.joined(separator: " · "))
                        .font(.system(.footnote, design: .monospaced))
                    if teclados.indices.contains(i) {
                        VistaSVG(svg: teclados[i].svg)
                            .frame(height: 150)
                            .accessibilityLabel(Text(teclados[i].titulo))
                    }
                }
            }
        }
    }
}

/// Las escalas simétricas: cada cuánto se repiten, desde qué notas empiezan igual y los acordes que se repiten sobre
/// cada una, para escucharlos.
struct SeccionDeLaSimetria: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, en: notacion) {
            Section(notacion.texto(\.simetria)) {
                Text(simetria.resumen)
                LabeledContent(notacion.texto(\.tonicasEquivalentes), value: simetria.tonicas)
                ForEach(simetria.ciclos, id: \.self) { ciclo in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ciclo.nombre).bold()
                            Text(ciclo.detalle).font(.footnote)
                        }
                        Spacer()
                        BotonDeEscuchar(ciclo.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

/// Lo que se mide de la escala: el número de notas con su cardinal, el brillo, los pasos, el vector interválico…
struct SeccionDeLasEstadisticas: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        Section(notacion.texto(\.estadisticas)) {
            ForEach(PresentacionDeEstudioDeEscala.estadisticas(de: escala, en: notacion), id: \.self) { dato in
                LabeledContent(dato.nombre, value: dato.valor)
            }
        }
    }
}

/// El mapa de brillo, de su tamaño, para recorrerlo de lado; se exporta con la barra.
struct SeccionDelMapaDeBrillo: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion

    var body: some View {
        let svg = PresentacionDeEstudioDeEscala.mapaDeBrillo(de: escala, en: notacion)
        if let tamano = PresentacionDeEstudioDeEscala.tamano(deUnSVG: svg), tamano.alto > 120 {
            Section(notacion.texto(\.mapaDeBrillo)) {
                ScrollView(.horizontal) {
                    VistaSVG(svg: svg)
                        .frame(width: tamano.ancho, height: tamano.alto)
                        .accessibilityLabel(Text(notacion.texto(\.mapaDeBrillo)))
                }
            }
        }
    }
}

/// La escala en un reloj de doce horas, en el círculo cromático o en el de quintas, para ver su forma; si tiene
/// microtonos, también en el círculo microtonal, cada grado en el ángulo de sus cents.
struct SeccionDelReloj: View {
    let escala: Escala
    @Environment(\.notacion) private var notacion
    /// El círculo del reloj.
    @State private var circulo = Circulo.cromatico
    /// En el microtonal, cuál de las afinaciones de la escala (los echoi tienen dos).
    @State private var afinacion = 0

    /// Los círculos que se pueden elegir: el microtonal, solo si la escala tiene microtonos.
    enum Circulo: Hashable {
        case cromatico, quintas, microtonal
    }

    var body: some View {
        let afinaciones = escala.notasMicrotonales() == nil ? [] : escala.tipo.afinaciones
        // Si la escala cambia y ya no tiene microtonos, el cromático.
        let elegido = circulo == .microtonal && afinaciones.isEmpty ? Circulo.cromatico : circulo
        Section(notacion.texto(\.relojDeLaEscala)) {
            Picker(notacion.texto(\.relojDeLaEscala), selection: $circulo) {
                Text(notacion.texto(\.circuloCromatico)).tag(Circulo.cromatico)
                Text(notacion.texto(\.circuloDeQuintas)).tag(Circulo.quintas)
                if !afinaciones.isEmpty {
                    Text(notacion.texto(\.circuloMicrotonal)).tag(Circulo.microtonal)
                }
            }
            .pickerStyle(.segmented)
            if elegido == .microtonal, afinaciones.count > 1 {
                Picker(notacion.texto(\.circuloMicrotonal), selection: $afinacion) {
                    ForEach(afinaciones.indices, id: \.self) { i in
                        Text(nombre(de: afinaciones[i])).tag(i)
                    }
                }
            }
            VistaSVG(svg: svg(elegido, afinaciones: afinaciones))
                .frame(height: elegido == .microtonal ? 320 : 300)
            // En el microtonal, cada grado se puede tocar solo, con su microtono, y la escala entera en esa afinación.
            if elegido == .microtonal, let notas = escala.notasMicrotonales(afinacion: afinacionElegida(afinaciones)) {
                let grados = Escucha.grados(de: escala, afinacion: afinacionElegida(afinaciones))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(zip(notas, grados).enumerated()), id: \.offset) { _, par in
                            Button(par.0.nombre(en: notacion)) { Reproductor.compartido.tocar(par.1) }
                                .buttonStyle(.bordered)
                        }
                    }
                }
                BotonDeEscuchar(Escucha.escala(escala, afinacion: afinacionElegida(afinaciones)))
            }
        }
    }

    /// La afinación elegida en el selector, si la escala tiene más de una; `nil`, la de su teoría de hoy.
    private func afinacionElegida(_ afinaciones: [TipoDeEscalaMicrotonal]) -> TipoDeEscalaMicrotonal? {
        afinaciones.indices.contains(afinacion) ? afinaciones[afinacion] : nil
    }

    /// El reloj elegido, en SVG.
    private func svg(_ circulo: Circulo, afinaciones: [TipoDeEscalaMicrotonal]) -> String {
        switch circulo {
        case .cromatico: return PresentacionDeEstudioDeEscala.reloj(de: escala, orden: .cromatico, en: notacion)
        case .quintas: return PresentacionDeEstudioDeEscala.reloj(de: escala, orden: .quintas, en: notacion)
        case .microtonal:
            return PresentacionDeEstudioDeEscala.relojMicrotonal(
                de: escala, afinacion: afinacionElegida(afinaciones), en: notacion)
                ?? PresentacionDeEstudioDeEscala.reloj(de: escala, en: notacion)
        }
    }

    /// Cómo se llama una afinación en el selector: por su autor (Chrysanthos) o, la de su teoría de hoy, por su
    /// sistema (72 moria).
    private func nombre(de afinacion: TipoDeEscalaMicrotonal) -> String {
        afinacion.fuente?.nombre(en: notacion) ?? afinacion.sistema.temperamento?.nombre(en: notacion)
            ?? afinacion.sistema.rawValue
    }
}

/// El temperamento con que suena «Escuchar» (el del selector de la barra) en un reloj de cents: las doce teclas y lo
/// que se apartan del temperamento igual o, si su quinta recorre todos sus pasos, su círculo de quintas. Debajo, su
/// quinta, su paso menor y mayor y, en los de doce notas, la quinta del lobo.
struct SeccionDelTemperamento: View {
    @Environment(\.notacion) private var notacion
    @AppStorage(AjustesDeLasApps.claveDeTemperamento) private var clave =
        AjustesDeLasApps.claveDeTemperamento(.temperamentoIgual)
    /// De quinta en quinta, si el temperamento lo permite.
    @State private var quintas = false

    var body: some View {
        let temperamento = (AjustesDeLasApps.temperamento(deClave: clave) ?? .temperamentoIgual).temperamento
        let conQuintas = quintas && RelojDeAlturas.pasosDeLaQuinta(de: temperamento) != nil
        Section(notacion.texto(\.afinacionAlEscuchar)) {
            Picker(notacion.texto(\.afinacionAlEscuchar), selection: $quintas) {
                Text(notacion.texto(\.circuloCromatico)).tag(false)
                if RelojDeAlturas.pasosDeLaQuinta(de: temperamento) != nil {
                    Text(notacion.texto(\.circuloDeQuintas)).tag(true)
                }
            }
            .pickerStyle(.segmented)
            if let svg = TemperamentoPresentado.reloj(de: temperamento, quintas: conQuintas, en: notacion) {
                VistaSVG(svg: svg).frame(height: 320)
            }
            ForEach(TemperamentoPresentado(temperamento, en: notacion).datos(en: notacion), id: \.nombre) { dato in
                LabeledContent(dato.nombre, value: dato.valor)
            }
        }
    }
}

/// La hoja de estudio vista antes de exportarla, con un interruptor para cada sección; se exporta con la barra.
struct SeccionDeLaHojaDeEstudio: View {
    let escala: Escala
    @Binding var secciones: Set<SeccionDeLaHoja>
    @Environment(\.notacion) private var notacion

    var body: some View {
        let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudio(de: escala, en: notacion, secciones: secciones)
        let tamano = PresentacionDeEstudioDeEscala.tamano(deUnSVG: hoja) ?? (ancho: 595, alto: 842)
        Section(notacion.texto(\.hojaDeEstudio)) {
            DisclosureGroup(notacion.texto(\.hojaDeEstudio) + " (\(secciones.count))") {
                ForEach(SeccionDeLaHoja.allCases, id: \.self) { seccion in
                    Toggle(seccion.nombre(en: notacion), isOn: incluye(seccion))
                }
            }
            VistaSVG(svg: hoja)
                .aspectRatio(CGSize(width: tamano.ancho, height: tamano.alto), contentMode: .fit)
                .accessibilityLabel(Text(notacion.texto(\.hojaDeEstudio) + " " + escala.nombre(en: notacion)))
        }
    }

    /// Si la hoja de estudio lleva una sección, para su interruptor.
    private func incluye(_ seccion: SeccionDeLaHoja) -> Binding<Bool> {
        Binding(
            get: { secciones.contains(seccion) },
            set: { incluida in
                if incluida { secciones.insert(seccion) } else { secciones.remove(seccion) }
            })
    }
}
