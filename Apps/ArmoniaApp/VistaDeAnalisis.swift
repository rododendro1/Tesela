import Armonia
import ArmoniaUI
import SwiftUI
import UniformTypeIdentifiers

/// Escribe una progresión (Do Fa Sol7 Do Lam Re7 Sol), o la saca de un fichero MIDI, MusicXML, MEI o ABC con «Abrir»
/// (con su ritmo armónico, que siguen la partitura, el MIDI y «Escuchar» mientras no se retoque), y
/// muestra sus tonalidades, los grados, las funciones, las modulaciones y las cadencias, y la exporta como
/// partitura o MIDI, también arpegiada. Mientras suena, se resalta el acorde que se oye. La progresión se puede
/// llevar a otra tonalidad y rearmonizar acorde a acorde.
struct VistaDeAnalisis: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    @State private var texto = "Do Fa Sol7 Do Lam Re7 Sol"
    /// El análisis de `texto`, que se rehace al cambiar el texto o la notación, no en cada redibujado.
    @State private var resultado: Result<AnalisisPresentado, Error>?
    @State private var abriendo = false
    /// Por qué no se pudo abrir el último fichero; se borra al abrir otro o al cambiar el texto.
    @State private var errorAlAbrir: Error?
    /// La progresión del último fichero abierto, con su ritmo armónico: se usa mientras el campo diga lo mismo.
    @State private var importada: ProgresionImportada?
    @State private var patron = Arpegio.Patron.ascendente
    @State private var figura = Figura.corchea
    /// Si cada arpegio empieza por la nota más cercana a la última del anterior.
    @State private var enlazados = false
    /// La disposición de la progresión dispuesta (drop 2, shell…).
    @State private var disposicion = DisposicionDeAcorde.drop2
    /// Lo que está sonando, para resaltar el acorde que se oye.
    @ObservedObject private var reproductor = Reproductor.compartido

    /// Las figuras que se ofrecen para las notas de la progresión arpegiada.
    private static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// MIDI, MusicXML (.musicxml, .xml y .mxl), MEI y ABC.
    private static let tipos: [UTType] =
        [.midi, .xml]
        + ImportacionDeProgresion.extensiones.compactMap { UTType(filenameExtension: $0) }

    var body: some View {
        Form {
            Section(notacion.texto(\.progresion)) {
                TextField(notacion.texto(\.campoDeProgresion), text: $texto)
                    .comoCampoDeCifrado()
                if let errorAlAbrir {
                    Text(notacion.mensaje(de: errorAlAbrir)).foregroundColor(.red)
                }
            }
            switch resultado {
            case .some(.success(let analisis)):
                Section(notacion.texto(\.resultado)) {
                    Text(analisis.titulo).font(.headline)
                    BotonDeEscuchar(analisis.sonido)
                }
                // El acorde que suena, contado desde el primero de todos los tramos.
                let sonando = reproductor.paso(de: analisis.sonido)
                // Lo que cambia de una escala a la siguiente y las notas guía de cada acorde.
                let cambios = analisis.cambiosDeEscala(en: notacion)
                ForEach(Array(analisis.tramos.enumerated()), id: \.offset) { t, tramo in
                    let antes = analisis.tramos.prefix(t).map(\.filas.count).reduce(0, +)
                    Section(tramo.cabecera ?? notacion.texto(\.acordeAAcorde)) {
                        ForEach(Array(tramo.filas.enumerated()), id: \.offset) { i, fila in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(fila.cifrado)
                                        .font(.system(.body, design: .monospaced))
                                        .frame(minWidth: 80, alignment: .leading)
                                    Text(fila.grado).bold()
                                    Spacer()
                                    Text(fila.funcion).foregroundColor(.secondary)
                                }
                                if let escala = fila.escala { escalaDelAcorde(escala) }
                                if cambios.indices.contains(antes + i) {
                                    Text(cambios[antes + i]).font(.caption).foregroundColor(.secondary)
                                }
                            }
                            .listRowBackground(sonando == antes + i ? TemaDeLasApps.resaltado.opacity(0.25) : nil)
                        }
                    }
                }
                if !analisis.cadencias.isEmpty {
                    Section(notacion.texto(\.cadencias)) {
                        ForEach(analisis.cadencias, id: \.self) { Text($0) }
                    }
                }
                lineasDeNotasGuia(analisis)
                modulaciones(analisis)
                doceTonalidades(analisis)
                arpegiar(analisis)
                disponer(analisis)
                rearmonizar(analisis)
            case .some(.failure(let error)):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            case .none:
                EmptyView()
            }
        }
        .navigationTitle(notacion.texto(\.analisis))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                Button {
                    abriendo = true
                } label: {
                    Label(notacion.texto(\.abrir), systemImage: "folder")
                }
            }
            ToolbarItem {
                menuDeTransponer
            }
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .fileImporter(isPresented: $abriendo, allowedContentTypes: Self.tipos) { elegido in
            abrir(elegido)
        }
        .onChange(of: texto) { _ in errorAlAbrir = nil }
        .task(id: "\(texto)|\(notacion.clave)|\(importada?.hashValue ?? 0)") {
            // Lo abierto, con el ritmo de la pieza, mientras no se retoque; si no, lo escrito.
            let abierta = importada?.texto == texto ? importada : nil
            if let abierta, let analisis = PresentacionDeAnalisis.analizar(abierta, notacion: notacion) {
                resultado = .success(analisis)
            } else {
                resultado = Result { try PresentacionDeAnalisis.analizar(texto, notacion: notacion) }
            }
        }
    }

    /// Las partituras y el MIDI de la progresión y de la progresión arpegiada con el patrón elegido, y la hoja de
    /// estudio de la progresión, con la disposición elegida.
    private var ficheros: [FicheroParaExportar] {
        guard let analisis = try? resultado?.get() else { return [] }
        let arpegiada = analisis.arpegiada(patron, figura: figura.duracion, enlazados: enlazados, notacion: notacion)
        let dispuesta = PresentacionDeDisposiciones.progresion(
            analisis.acordes, disposicion, notacion: notacion)
        let guias = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, notacion: notacion
        ).flatMap(\.ficheros)
        let hoja = FicheroParaExportar.svg(
            PresentacionDeAnalisis.hojaDeEstudio(analisis, disposicion: disposicion, notacion: notacion),
            nombre: notacion.texto(\.hojaDeEstudio))
        var todos: [FicheroParaExportar] = analisis.ficheros + [hoja]
        if let tonalidad = tonalidadDeLasDoce(analisis) {
            let svg = PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
                analisis.acordes, tonalidad: tonalidad, disposicion: disposicion, notacion: notacion)
            let nombre = notacion.texto(\.hojaDeEstudio) + " · " + notacion.texto(\.enLasDoceTonalidades)
            todos.append(FicheroParaExportar.svg(svg, nombre: nombre))
        }
        todos += arpegiada?.ficheros ?? []
        todos += dispuesta?.ficheros ?? []
        return todos + guias
    }

    /// La tonalidad desde la que se lleva la progresión a las doce: la del análisis o, si modula, la del primer
    /// acorde.
    private func tonalidadDeLasDoce(_ analisis: AnalisisPresentado) -> Tonalidad? {
        analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia
    }

    /// La progresión en las doce tonalidades, de quinta en quinta, para escucharla en cada una; la hoja para
    /// practicarla se exporta con la barra.
    @ViewBuilder
    private func doceTonalidades(_ analisis: AnalisisPresentado) -> some View {
        if let tonalidad = tonalidadDeLasDoce(analisis), !analisis.acordes.isEmpty {
            Section(notacion.texto(\.enLasDoceTonalidades)) {
                ForEach(
                    PresentacionDeAnalisis.enLasDoceTonalidades(
                        analisis.acordes, tonalidad: tonalidad, notacion: notacion),
                    id: \.self
                ) { progresion in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(progresion.titulo).bold()
                            Text(progresion.cifrados).font(.system(.footnote, design: .monospaced))
                        }
                        Spacer()
                        BotonDeEscuchar(progresion.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    /// «Transponer»: las demás tonalidades del mismo modo. Lo abierto de un fichero conserva su ritmo armónico.
    @ViewBuilder
    private var menuDeTransponer: some View {
        if let analisis = try? resultado?.get(), let tonalidad = analisis.tonalidad {
            Menu {
                ForEach(PresentacionDeTransposicion.destinos(desde: tonalidad), id: \.self) { destino in
                    Button(destino.nombre(en: notacion)) { transponer(de: tonalidad, a: destino) }
                }
            } label: {
                Label(notacion.texto(\.transponer), systemImage: "arrow.up.arrow.down")
            }
        }
    }

    private func transponer(de origen: Tonalidad, a destino: Tonalidad) {
        if let abierta = importada, abierta.texto == texto {
            let intervalo = origen.tonica.intervaloMasCorto(hasta: destino.tonica)
            let transportada = PresentacionDeTransposicion.transponer(abierta, intervalo)
            importada = transportada
            texto = transportada.texto
        } else if let nuevo = try? PresentacionDeTransposicion.transponer(
            texto, de: origen, a: destino, notacion: notacion)
        {
            texto = nuevo
        }
    }

    /// Las dos líneas de notas guía de la progresión, desde la tercera y desde la séptima, con su pentagrama y
    /// «Escuchar»; se exportan con la barra.
    @ViewBuilder
    private func lineasDeNotasGuia(_ analisis: AnalisisPresentado) -> some View {
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, notacion: notacion)
        if !lineas.isEmpty {
            Section(notacion.texto(\.lineasDeNotasGuia)) {
                ForEach(lineas, id: \.titulo) { linea in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(linea.titulo).bold()
                            Spacer()
                            BotonDeEscuchar(linea.sonido)
                        }
                        Text(linea.notas).font(.system(.footnote, design: .monospaced))
                        DiagramaDePentagrama(linea.pentagrama)
                    }
                }
            }
        }
    }

    /// Cómo llegar desde la tonalidad de la progresión a cada tono vecino: la técnica, el acorde pivote y una
    /// progresión de ejemplo, para escucharla.
    @ViewBuilder
    private func modulaciones(_ analisis: AnalisisPresentado) -> some View {
        if let tonalidad = analisis.tonalidad {
            Section(notacion.texto(\.modulaciones)) {
                ForEach(
                    PresentacionDeModulaciones.modulaciones(desde: tonalidad, notacion: notacion), id: \.self
                ) { modulacion in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(modulacion.destino).bold()
                            Text(modulacion.tecnica).foregroundColor(.secondary)
                            Spacer()
                            BotonDeEscuchar(modulacion.sonido).labelStyle(.iconOnly)
                        }
                        .buttonStyle(.borderless)
                        Text(modulacion.acordes).font(.system(.footnote, design: .monospaced))
                        if let pivote = modulacion.pivote {
                            Text(pivote).font(.footnote).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }

    /// Otras armonías para cada acorde: cómo suena el pasaje con el cambio y el botón que lo pone en la progresión.
    @ViewBuilder
    private func rearmonizar(_ analisis: AnalisisPresentado) -> some View {
        let propuestas = analisis.rearmonizaciones(en: notacion)
        if !propuestas.isEmpty {
            Section(notacion.texto(\.rearmonizar)) {
                ForEach(propuestas, id: \.self) { propuesta in
                    HStack {
                        Text(propuesta.descripcion)
                        Spacer()
                        BotonDeEscuchar(propuesta.sonido)
                            .labelStyle(.iconOnly)
                        Button(notacion.texto(\.aplicar)) { texto = propuesta.texto }
                    }
                    // Cada botón por su lado, no la fila entera.
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    /// La progresión arpegiada: cada acorde una blanca (o lo que dure en la pieza abierta), con el patrón y la
    /// figura elegidos.
    @ViewBuilder
    private func arpegiar(_ analisis: AnalisisPresentado) -> some View {
        if let arpegiada = analisis.arpegiada(
            patron, figura: figura.duracion, enlazados: enlazados, notacion: notacion)
        {
            Section(notacion.texto(\.arpegiar)) {
                Picker(notacion.texto(\.patron), selection: $patron) {
                    ForEach(Arpegio.Patron.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                }
                Picker(notacion.texto(\.figura), selection: $figura) {
                    ForEach(Self.figuras, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                }
                Toggle(notacion.texto(\.enlazarLosAcordes), isOn: $enlazados)
                BotonDeEscuchar(arpegiada.sonido)
            }
        }
    }

    /// La escala del acorde en su tonalidad, que se abre en la pestaña de escalas, con sus tensiones, sus notas a
    /// evitar y sus estructuras superiores debajo.
    @ViewBuilder
    private func escalaDelAcorde(_ escala: EscalaSobreAcordePresentada) -> some View {
        Button(escala.nombre) { navegacion.ver(escala.escala) }
            .buttonStyle(.borderless)
            .font(.callout)
        if !escala.resumen.isEmpty {
            Text(escala.resumen).font(.caption).foregroundColor(.secondary)
        }
        if !escala.estructurasSuperiores.isEmpty {
            Text(notacion.texto(\.estructurasSuperiores) + ": " + escala.estructurasSuperiores)
                .font(.caption).foregroundColor(.secondary)
        }
    }

    /// La progresión dispuesta como en el piano o el jazz, con el menor movimiento de las voces de un acorde al
    /// siguiente: cada acorde con sus alturas, el pentagrama y cómo suena. Mientras suena, se resalta el acorde.
    @ViewBuilder
    private func disponer(_ analisis: AnalisisPresentado) -> some View {
        Section(notacion.texto(\.disposicion)) {
            Picker(notacion.texto(\.disposicion), selection: $disposicion) {
                ForEach(DisposicionDeAcorde.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            if let dispuesta = PresentacionDeDisposiciones.progresion(
                analisis.acordes, disposicion, notacion: notacion)
            {
                let sonando = reproductor.paso(de: dispuesta.sonido)
                DiagramaDePentagrama(dispuesta.pentagrama)
                BotonDeEscuchar(dispuesta.sonido)
                ForEach(Array(dispuesta.filas.enumerated()), id: \.offset) { i, fila in
                    HStack {
                        Text(fila.cifrado)
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 80, alignment: .leading)
                        Spacer()
                        Text(fila.voces).font(.system(.callout, design: .monospaced))
                    }
                    .listRowBackground(sonando == i ? TemaDeLasApps.resaltado.opacity(0.25) : nil)
                }
                conduccion(analisis)
            } else {
                Text(notacion.texto(\.noSeDibuja)).foregroundColor(.secondary)
            }
        }
    }

    /// Paso a paso, las notas comunes y lo que se mueve cada voz en la disposición elegida, y el movimiento total.
    @ViewBuilder
    private func conduccion(_ analisis: AnalisisPresentado) -> some View {
        if let voces = PresentacionDeAnalisis.conduccion(
            analisis.acordes, disposicion: disposicion, notacion: notacion)
        {
            Text(notacion.texto(\.conduccionDeVoces) + " · " + voces.disposicion).bold()
            ForEach(Array(voces.pasos.enumerated()), id: \.offset) { _, paso in
                VStack(alignment: .leading, spacing: 2) {
                    Text(paso.titulo + " · " + paso.comunes)
                    Text(paso.voces.joined(separator: " · "))
                        .font(.system(.footnote, design: .monospaced)).foregroundColor(.secondary)
                }
            }
            Text(voces.movimientoTotal).foregroundColor(.secondary)
        }
    }

    /// Lee el fichero elegido y pone sus acordes en el campo de la progresión, que se analiza como si se
    /// hubieran escrito.
    private func abrir(_ elegido: Result<URL, Error>) {
        do {
            let url = try elegido.get()
            // Los ficheros de fuera de la app (Archivos, iCloud) solo se leen con permiso.
            let conPermiso = url.startAccessingSecurityScopedResource()
            defer { if conPermiso { url.stopAccessingSecurityScopedResource() } }
            let leida = try ImportacionDeProgresion.leer(Data(contentsOf: url))
            importada = leida
            texto = leida.texto
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }
}
