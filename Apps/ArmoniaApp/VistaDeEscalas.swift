import Armonia
import ArmoniaUI
import SwiftUI

/// Elige una tónica y una escala del catálogo (occidentales y de otras tradiciones) y muestra sus notas,
/// sus acordes, dónde caen en el mástil y cómo se tocan por posiciones (CAGED o tres notas por cuerda).
struct VistaDeEscalas: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    @State private var tonica = 0 // índice en `tonicas`
    @State private var tipo = 0 // índice en `catalogo`
    /// Las posiciones en el mástil: las del sistema CAGED o las de tres (o dos) notas por cuerda.
    @State private var caged = true
    /// La secuencia de estudio, su sentido y cuántas octavas abarca.
    @State private var secuencia = SecuenciaDeEscala.terceras
    @State private var bajando = false
    @State private var octavas = 1
    /// Una escala propia, por sus notas o por sus pasos; si se lee, manda sobre la tónica y el tipo elegidos.
    @State private var propia = ""
    /// El instrumento y el capo de las posiciones en el mástil.
    @State private var encordado = Encordado.guitarra
    @State private var capo = 0
    /// El reloj de la escala: el círculo cromático o el de quintas.
    @State private var ordenDelReloj = RelojDeClases.Orden.cromatico
    /// Si los acordes de las doce tonalidades llevan séptima.
    @State private var conSeptima = true
    /// La escala con que se compara la elegida, o vacío.
    @State private var otraEscala = "Do lidio"
    /// Lo que está sonando, para resaltar la nota en el pentagrama y en el mástil.
    @ObservedObject private var reproductor = Reproductor.compartido

    /// Las escalas habituales y, después, las de otras tradiciones. Se elige por índice porque dos
    /// escalas con las mismas notas son iguales (`==`) aunque se llamen distinto.
    private static let catalogo = TipoDeEscala.todos + TipoDeEscala.tradicionales

    /// Las doce tónicas, de Do a Si, con la grafía habitual de una tonalidad: Re♭, Mi♭, La♭ y Si♭ con
    /// bemoles y Fa♯ con sostenido. (`Altura(midi:)` daría Do♯, Re♯, Sol♯ y La♯, con dobles sostenidos
    /// en la escala.) Se indican por su posición en la línea de quintas.
    private static let tonicas: [Nota] = [0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5].map { Nota(pasosDeQuinta: $0) }

    private var escala: Escala {
        if !propia.isEmpty, let leida = try? Escala(leyendo: propia) { return leida }
        let nota = VistaDeEscalas.tonicas[min(tonica, VistaDeEscalas.tonicas.count - 1)]
        return Escala(nota, VistaDeEscalas.catalogo[min(tipo, VistaDeEscalas.catalogo.count - 1)])
    }

    var body: some View {
        let escala = self.escala
        let pentagrama = PentagramaPresentado(escala, notacion: notacion)
        let sonido = Escucha.escala(escala)
        Form {
            Section(notacion.texto(\.escala)) {
                Picker(notacion.texto(\.tonica), selection: $tonica) {
                    ForEach(VistaDeEscalas.tonicas.indices, id: \.self) {
                        Text(VistaDeEscalas.tonicas[$0].nombre(en: notacion)).tag($0)
                    }
                }
                Picker(notacion.texto(\.tipo), selection: $tipo) {
                    Section(notacion.texto(\.habituales)) {
                        ForEach(0..<TipoDeEscala.todos.count, id: \.self) { Text(nombre($0)).tag($0) }
                    }
                    Section(notacion.texto(\.otrasTradiciones)) {
                        ForEach(TipoDeEscala.todos.count..<VistaDeEscalas.catalogo.count, id: \.self) {
                            Text(nombre($0)).tag($0)
                        }
                    }
                }
                TextField(notacion.texto(\.campoDeEscalaPropia), text: $propia)
                    .comoCampoDeCifrado()
                    .accessibilityLabel(Text(notacion.texto(\.escalaPropia)))
            }
            Section(notacion.texto(\.notas)) {
                Text(escala.nombre(en: notacion)).font(.headline)
                // De qué escala es modo (Re dórico → modo 2 de Do mayor); se abre al tocarlo.
                if let modo = PresentacionDeEscalaYAcorde.modo(de: escala, notacion: notacion),
                    let madre = escala.escalaMadre?.madre
                {
                    Button(modo) { navegacion.ver(madre) }
                }
                Text(escala.notas.map { $0.nombre(en: notacion) }.joined(separator: "  "))
                    .font(.system(.body, design: .monospaced))
                // La versión microtonal (Re Bayātī: Re Mi𝄳 Fa…) y los cents de cada grado, si la escala la tiene.
                if let microtonos = escala.notasMicrotonales() {
                    Text(microtonos.map { $0.nombre(en: notacion) }.joined(separator: "  "))
                        .font(.system(.body, design: .monospaced))
                    Text("¢  " + microtonos.map { "\(Int($0.cents.rounded()))" }.joined(separator: "  "))
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                LabeledContent(
                    notacion.texto(\.pasosEnSemitonos),
                    value: escala.pasosEnSemitonos.map(String.init).joined(separator: "-")
                        + (escala.numeroDeForte.map { "  ·  " + $0 } ?? ""))
                BotonDeEscuchar(sonido)
            }
            let acordes = escala.armonizar().compactMap { $0 }
            if !acordes.isEmpty {
                Section(notacion.texto(\.acordesDeLaEscala)) {
                    Text(acordes.map { $0.cifrado(en: notacion) }.joined(separator: "   "))
                }
            }
            acordesQueCaben(en: escala)
            Section(notacion.texto(\.pentagrama)) {
                // Mientras suena, la nota que se oye, de otro color.
                if let paso = reproductor.paso(de: sonido) {
                    DiagramaDePentagrama(PentagramaPresentado(escala, notacion: notacion, resaltada: paso))
                } else {
                    DiagramaDePentagrama(pentagrama)
                }
            }
            Section(notacion.texto(\.mastilDeGuitarra)) {
                DiagramaDeMastil(mastil: Mastil(.guitarra, numeroDeTrastes: 12), escala: escala, notacion: notacion)
            }
            posiciones(de: escala)
            formasPentatonicas(de: escala)
            seccionDeLaSecuencia(de: escala)
            secuenciaEnLasPosiciones(de: escala)
            digitacionDePiano(de: escala)
            simetria(de: escala)
            estadisticas(de: escala)
            reloj(de: escala)
            vecinas(de: escala)
            doceTonalidades(de: escala)
            acordesEnLasDoceTonalidades(de: escala)
            modos(de: escala)
            comparacion(de: escala)
        }
        .navigationTitle(notacion.texto(\.escalas))
        .selectorDeNotacionEnLaBarra()
        // Una escala pedida desde otra pestaña (las compatibles con un acorde), ahora o si se pidió antes de abrir
        // esta.
        .onChange(of: navegacion.escalaPedida) { _ in tomarLaEscalaPedida() }
        .onAppear(perform: tomarLaEscalaPedida)
        .toolbar {
            ToolbarItem {
                BotonDeExportar(
                    [pentagrama.fichero] + secuenciaPresentada(de: escala).ficheros + svgs(de: escala)
                        + PresentacionDeEstudioDeEscala.enLasDoceTonalidades(escala, notacion: notacion).ficheros)
            }
        }
    }

    /// Los acordes que caben sobre cada grado, no solo los de terceras (sus, sextas, add9, dominantes alteradas),
    /// plegados por grado; cada uno se abre en la pestaña de acordes.
    @ViewBuilder
    private func acordesQueCaben(en escala: Escala) -> some View {
        let grados = PresentacionDeEscalaYAcorde.acordesQueCaben(escala, notacion: notacion)
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

    private func secuenciaPresentada(de escala: Escala) -> SecuenciaPresentada {
        PresentacionDeEstudioDeEscala.secuencia(
            escala, secuencia, octavas: octavas, sentido: bajando ? .descendente : .ascendente, notacion: notacion)
    }

    /// La escala en una secuencia de estudio (por terceras, en grupos, en tríadas…), subiendo o bajando, con su
    /// pentagrama y «Escuchar»; se exporta con la barra.
    @ViewBuilder
    private func seccionDeLaSecuencia(de escala: Escala) -> some View {
        let presentada = secuenciaPresentada(de: escala)
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

    /// La digitación de piano de cada mano, con el dedo debajo de cada nota y dibujada en un teclado.
    @ViewBuilder
    private func digitacionDePiano(de escala: Escala) -> some View {
        let teclados = self.teclados(de: escala)
        Section(notacion.texto(\.digitacionDePiano)) {
            ForEach(
                Array(PresentacionDeEstudioDeEscala.digitaciones(escala, notacion: notacion).enumerated()),
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

    /// Los teclados de cada mano, para exportarlos en SVG.
    private func svgs(de escala: Escala) -> [FicheroParaExportar] {
        teclados(de: escala).map { FicheroParaExportar.svg($0.svg, nombre: $0.titulo) }
    }

    /// La escala en el teclado de piano con los dedos de cada mano, la derecha primero: el dibujo y su título.
    private func teclados(de escala: Escala) -> [(svg: String, titulo: String)] {
        Mano.allCases.map { mano in
            let titulo =
                escala.nombre(en: notacion) + " · "
                + notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda }
            return (PresentacionDeEstudioDeEscala.teclado(de: escala, mano: mano, notacion: notacion), titulo)
        }
    }

    /// Las escalas simétricas: cada cuánto se repiten, desde qué notas empiezan igual y los acordes que se repiten
    /// sobre cada una, para escucharlos.
    @ViewBuilder
    private func simetria(de escala: Escala) -> some View {
        if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, notacion: notacion) {
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

    /// Lo que se mide de la escala: el número de notas con su cardinal, el brillo, los pasos, el vector interválico…
    private func estadisticas(de escala: Escala) -> some View {
        Section(notacion.texto(\.estadisticas)) {
            ForEach(PresentacionDeEstudioDeEscala.estadisticas(de: escala, notacion: notacion), id: \.self) { dato in
                LabeledContent(dato.nombre, value: dato.valor)
            }
        }
    }

    /// Las cinco formas de una pentatónica en la guitarra, con las notas que cada una comparte con la siguiente.
    @ViewBuilder
    private func formasPentatonicas(de escala: Escala) -> some View {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(de: escala, mastil: mastil, notacion: notacion)
        if !formas.isEmpty {
            Section(notacion.texto(\.formasDeLaPentatonica)) {
                ForEach(formas, id: \.self) { forma in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(forma.titulo).bold()
                            Spacer()
                            BotonDeEscuchar(forma.sonido)
                        }
                        DiagramaDeMastil(posicion: forma.posicion, escala: escala, notacion: notacion)
                            .frame(maxHeight: 120)
                        Text(forma.comunes).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    /// La secuencia elegida tocada en cada posición (CAGED o por cuerdas, como arriba), sin salir de ella, en
    /// tablatura.
    @ViewBuilder
    private func secuenciaEnLasPosiciones(de escala: Escala) -> some View {
        let posiciones = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            escala, secuencia, caged: caged, sentido: bajando ? .descendente : .ascendente, mastil: mastil,
            notacion: notacion
        ).filter { !$0.notas.isEmpty }
        if !posiciones.isEmpty {
            Section(notacion.texto(\.secuenciaEnLasPosiciones)) {
                ForEach(posiciones, id: \.self) { posicion in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(posicion.titulo).bold()
                            Spacer()
                            BotonDeEscuchar(posicion.sonido)
                        }
                        ScrollView(.horizontal) {
                            Text(posicion.tablatura.joined(separator: "\n"))
                                .font(.system(.caption2, design: .monospaced))
                                .fixedSize()
                        }
                    }
                }
            }
        }
    }

    /// Los modos sobre la misma tónica, del más brillante al más oscuro, con lo que cambia cada uno, y los modos
    /// con las mismas notas; cada uno se abre al tocarlo.
    @ViewBuilder
    private func modos(de escala: Escala) -> some View {
        let paralelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, notacion: notacion)
        let relativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, notacion: notacion)
        Section(notacion.texto(\.modosParalelos)) {
            ForEach(paralelos, id: \.self) { filaDeModo($0) }
        }
        if !relativos.isEmpty {
            Section(notacion.texto(\.modosRelativos)) {
                ForEach(relativos, id: \.self) { filaDeModo($0) }
            }
        }
    }

    private func filaDeModo(_ modo: ModoPresentado) -> some View {
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

    /// La escala elegida y otra escrita: notas comunes, las que solo están en una, los grados que cambian y la
    /// distancia en el círculo de quintas.
    @ViewBuilder
    private func comparacion(de escala: Escala) -> some View {
        Section(notacion.texto(\.compararCon)) {
            TextField(notacion.campo(.escala), text: $otraEscala)
                .comoCampoDeCifrado()
            if let otra = try? Escala(leyendo: otraEscala) {
                let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, notacion: notacion)
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
            }
        }
    }

    /// Elige la tónica y el tipo de la escala pedida: el tipo con el mismo nombre o, si no, el primero con las
    /// mismas notas.
    private func tomarLaEscalaPedida() {
        guard let pedida = navegacion.escalaPedida else { return }
        navegacion.escalaPedida = nil
        propia = ""
        if let indice = VistaDeEscalas.tonicas.firstIndex(where: { $0.claseDeAltura == pedida.tonica.claseDeAltura }) {
            tonica = indice
        }
        let nombre = pedida.tipo.nombre(en: .espanolCompacto)
        if let indice = VistaDeEscalas.catalogo.firstIndex(where: { $0.nombre(en: .espanolCompacto) == nombre })
            ?? VistaDeEscalas.catalogo.firstIndex(of: pedida.tipo)
        {
            tipo = indice
        }
    }

    /// La escala por posiciones en la guitarra, con el diagrama de cada una y «Escuchar», de la más baja a la
    /// más alta.
    @ViewBuilder
    private func posiciones(de escala: Escala) -> some View {
        let mastil = self.mastil
        let porCuerda = escala.notas.count >= 6 ? 3 : 2
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        Section(notacion.texto(\.posicionesEnElMastil)) {
            Picker(notacion.texto(\.posicionesEnElMastil), selection: $caged) {
                Text("CAGED").tag(true)
                Text(notacion.texto { $0.notasPorCuerda(porCuerda) }).tag(false)
            }
            .pickerStyle(.segmented)
            Picker(notacion.texto(\.instrumentoYAfinacion), selection: $encordado) {
                ForEach(Encordado.todos, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
            }
            Stepper(
                capo == 0 ? notacion.texto(\.sinCapo) : notacion.texto { $0.capo(capo) }, value: $capo, in: 0...12)
            ForEach(posiciones, id: \.self) { posicion in
                let sonido = self.sonido(de: posicion, en: escala)
                let paso = reproductor.paso(de: sonido)
                let sonando = paso.flatMap { posicion.posiciones.indices.contains($0) ? posicion.posiciones[$0] : nil }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if let forma = posicion.forma {
                            Text(notacion.texto { $0.forma(forma.rawValue) }).bold()
                        }
                        Text(rotulo(de: posicion)).foregroundColor(.secondary)
                        Spacer()
                        BotonDeEscuchar(sonido)
                    }
                    DiagramaDeMastil(posicion: posicion, escala: escala, notacion: notacion)
                        .resaltando(sonando)
                        .frame(maxHeight: 120)
                }
            }
        }
    }

    /// El mástil de las posiciones: el instrumento elegido, con su capo.
    private var mastil: Mastil { Mastil(encordado.conCapo(capo), numeroDeTrastes: 15) }

    /// La escala en un reloj de doce horas, en el círculo cromático o en el de quintas, para ver su forma.
    @ViewBuilder
    private func reloj(de escala: Escala) -> some View {
        Section(notacion.texto(\.relojDeLaEscala)) {
            Picker(notacion.texto(\.relojDeLaEscala), selection: $ordenDelReloj) {
                Text(notacion.texto(\.circuloCromatico)).tag(RelojDeClases.Orden.cromatico)
                Text(notacion.texto(\.circuloDeQuintas)).tag(RelojDeClases.Orden.quintas)
            }
            .pickerStyle(.segmented)
            VistaSVG(svg: PresentacionDeEstudioDeEscala.reloj(de: escala, orden: ordenDelReloj, notacion: notacion))
                .frame(height: 300)
        }
    }

    /// Las escalas que salen de esta moviendo una nota un semitono, con el cambio; cada una se abre al tocarla.
    @ViewBuilder
    private func vecinas(de escala: Escala) -> some View {
        let vecinas = PresentacionDeEstudioDeEscala.vecinas(de: escala, notacion: notacion)
        if !vecinas.isEmpty {
            Section(notacion.texto(\.escalasVecinas)) {
                ForEach(vecinas, id: \.self) { vecina in
                    HStack {
                        Button {
                            propia = ""
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

    /// La escala en las doce tonalidades, de quinta en quinta, para escucharla seguida y exportarla con la barra.
    @ViewBuilder
    private func doceTonalidades(de escala: Escala) -> some View {
        let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(escala, notacion: notacion)
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

    /// Los acordes de cada grado en las doce tonalidades, si la escala forma uno en cada grado: una fila por
    /// tonalidad, para escucharla, y la partitura con todos para exportarla.
    @ViewBuilder
    private func acordesEnLasDoceTonalidades(de escala: Escala) -> some View {
        if let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
            escala, cuatriadas: conSeptima, notacion: notacion)
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

    /// Los trastes que abarca una posición: «Trastes 2–6».
    private func rotulo(de posicion: EscalaEnElMastil) -> String {
        notacion.texto { $0.trastes(posicion.rangoDeTrastes.lowerBound, posicion.rangoDeTrastes.upperBound) }
    }

    /// Una posición nota a nota, cuerda a cuerda, como se estudia.
    private func sonido(de posicion: EscalaEnElMastil, en escala: Escala) -> Escucha {
        Escucha.voz(Voz(posicion.alturas.map { Evento($0, .corchea) })).conTonica(escala.tonica)
    }

    private func nombre(_ indice: Int) -> String {
        VistaDeEscalas.catalogo[indice].nombre(en: notacion)
    }
}
