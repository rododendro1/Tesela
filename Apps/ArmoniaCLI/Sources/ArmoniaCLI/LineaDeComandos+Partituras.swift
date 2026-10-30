import Armonia
import Foundation

// MARK: - Partituras: MusicXML, MEI y MIDI

extension LineaDeComandos {
    enum Formato { case musicXML, mei, midi }

    /// `musicxml melodia …`, `mei melodia …` y `midi melodia …`: las mismas opciones, salvo la clave y
    /// las marcas (no en MIDI) y el instrumento (solo MIDI).
    static func partitura(_ argumentos: [String], _ notacion: Notacion, formato: Formato) throws -> ResultadoDeOrden {
        let orden = formato == .midi ? "midi" : (formato == .mei ? "mei" : "musicxml")
        guard let tipo = argumentos.first?.lowercased() else { return uso(.faltaTipoDePartitura(orden: orden), notacion) }
        // Los argumentos hasta la primera opción son la música; cada opción toma lo que la sigue.
        var musica: [String] = []
        var opciones: [String: String] = [:]
        var opcion: String?
        var marcas: Set<String> = []
        let sinValor: Set = ["cifrados", "analisis", "análisis"]
        for argumento in argumentos.dropFirst() {
            if argumento.hasPrefix("--") {
                let nombre = String(argumento.dropFirst(2)).lowercased()
                if sinValor.contains(nombre) {
                    marcas.insert(nombre == "análisis" ? "analisis" : nombre)
                    opcion = nil
                    continue
                }
                opcion = nombre
                opciones[nombre] = ""
            } else if let actual = opcion {
                opciones[actual] = opciones[actual]!.isEmpty ? argumento : opciones[actual]! + " " + argumento
            } else {
                musica.append(argumento)
            }
        }
        // `--program` es `--programa` en inglés.
        if formato == .midi, let valor = opciones.removeValue(forKey: "program") { opciones["programa"] = valor }
        // `--patrón` y `--pattern` son `--patron`.
        for otro in ["patrón", "pattern"] {
            if let valor = opciones.removeValue(forKey: otro) { opciones["patron"] = valor }
        }
        let conocidas: Set = formato == .midi
            ? ["compas", "anacrusa", "tonalidad", "tempo", "titulo", "duracion", "programa", "patron", "figura"]
            : ["compas", "anacrusa", "tonalidad", "clave", "tempo", "titulo", "duracion", "patron", "figura"]
        if let desconocida = opciones.keys.sorted().first(where: { !conocidas.contains($0) }) {
            return uso(.opcionDesconocida("--" + desconocida), notacion)
        }
        var instrumento: Int?
        if let texto = opciones["programa"] {
            guard let n = Int(texto), (0...127).contains(n) else {
                return uso(.instrumentoMIDI, notacion)
            }
            instrumento = n
        }
        if formato == .midi && !marcas.isEmpty { return uso(.marcasSoloMusicXML, notacion) }
        if let vacia = opciones.keys.sorted().first(where: { opciones[$0]!.isEmpty }) {
            return uso(.faltaValor(vacia), notacion)
        }
        let compas = try opciones["compas"].map { try Compas(leyendo: $0) } ?? .compasillo
        let tonalidad = try opciones["tonalidad"].map { try Tonalidad(leyendo: $0) }
        var tempo: Tempo?
        if let texto = opciones["tempo"] {
            let partes = texto.split(separator: " ").map(String.init)
            guard let bpm = Double(partes[0].replacingComa()), bpm > 0, partes.count <= 2 else {
                return uso(.tempoMalEscrito, notacion)
            }
            tempo = Tempo(bpm, unidad: try partes.dropFirst().first.map { try Duracion(leyendo: $0) } ?? .negra)
        }
        let titulo = opciones["titulo"]
        let arpegios: Set = ["arpegios", "arpegio", "arpeggios", "arpeggio"]
        if !arpegios.contains(tipo), let opcion = ["figura", "patron"].first(where: { opciones[$0] != nil }) {
            return uso(.soloParaArpegios(opcion), notacion)
        }

        switch tipo {
        case "melodia", "melodía", "melody":
            guard !musica.isEmpty else { return uso(.faltanNotasDeLaMelodia(orden: orden), notacion) }
            if !marcas.isEmpty { return uso(.marcasSoloCoral, notacion) }
            if opciones["duracion"] != nil { return uso(.duracionSoloCoral, notacion) }
            var clave: Clave?
            if let texto = opciones["clave"] {
                guard let leida = leerClave(texto) else {
                    return uso(.claveDesconocida(texto), notacion)
                }
                clave = leida
            }
            let anacrusa = try opciones["anacrusa"].map { try Duracion(leyendo: $0) } ?? .cero
            let voz = try Voz(leyendo: musica.joined(separator: " "), compas: compas, anacrusa: anacrusa)
            if formato == .midi {
                return binario(voz.midi(tonalidad: tonalidad, tempo: tempo, titulo: titulo, instrumento: instrumento ?? 0))
            }
            if formato == .mei {
                return bien(voz.mei(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo)
                    .trimmingCharacters(in: "\n"))
            }
            return bien(voz.musicXML(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo)
                .trimmingCharacters(in: "\n"))
        case "coral", "chorale":
            guard !musica.isEmpty else {
                return uso(.faltanAcordesDelCoral(orden: orden), notacion)
            }
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                return uso(.soloParaMelodia(opcion), notacion)
            }
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .negra
            let coral = try Coral(leyendo: musica.joined(separator: " "))
            if formato == .midi {
                return binario(coral.midi(duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
                                          titulo: titulo, instrumento: instrumento ?? 52, notacion: notacion))
            }
            if formato == .mei {
                return bien(coral.mei(duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
                                      titulo: titulo, cifrados: marcas.contains("cifrados"),
                                      analisis: marcas.contains("analisis"), notacion: notacion)
                    .trimmingCharacters(in: "\n"))
            }
            return bien(coral.musicXML(duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
                                       titulo: titulo, cifrados: marcas.contains("cifrados"),
                                       analisis: marcas.contains("analisis"), notacion: notacion)
                .trimmingCharacters(in: "\n"))
        case "acordes", "progresion", "progresión", "chords":
            guard !musica.isEmpty else { return uso(.faltanAcordesDeLaProgresion(orden: orden), notacion) }
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                return uso(.soloParaMelodia(opcion), notacion)
            }
            if !marcas.isEmpty { return uso(.acordesConCifradosYAnalisis, notacion) }
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .blanca
            let analisis = try AnalisisArmonico.analizar(leyendo: musica.joined(separator: " "), en: tonalidad)
            if formato == .midi {
                return binario(analisis.midi(duracion: duracion, compas: compas, tempo: tempo, titulo: titulo,
                                             instrumento: instrumento ?? 0, notacion: notacion))
            }
            if formato == .mei {
                return bien(analisis.mei(duracion: duracion, compas: compas, tempo: tempo, titulo: titulo,
                                         notacion: notacion).trimmingCharacters(in: "\n"))
            }
            return bien(analisis.musicXML(duracion: duracion, compas: compas, tempo: tempo, titulo: titulo,
                                          notacion: notacion).trimmingCharacters(in: "\n"))
        case _ where arpegios.contains(tipo):
            guard !musica.isEmpty else { return uso(.faltanAcordesDeLaProgresion(orden: orden), notacion) }
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                return uso(.soloParaMelodia(opcion), notacion)
            }
            if !marcas.isEmpty { return uso(.acordesConCifradosYAnalisis, notacion) }
            var patron = Arpegio.Patron.ascendente
            if let texto = opciones["patron"] {
                guard let elegido = patronDeArpegio(texto) else { return uso(.patronDesconocido(texto), notacion) }
                patron = elegido
            }
            let figura = try opciones["figura"].map { try Duracion(leyendo: $0) } ?? .corchea
            if figura <= .cero, let texto = opciones["figura"] {   // "0/4"
                throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto))
            }
            let porAcorde = try opciones["duracion"].map { try Duracion(leyendo: $0) }
            // La tonalidad, la dada o la que mejor explica los acordes, pone la armadura.
            let analisis = try AnalisisArmonico.analizar(leyendo: musica.joined(separator: " "), en: tonalidad)
            let voz = Voz(arpegiando: analisis.acordes.map(\.acorde), patron: patron, figura: figura,
                          porAcorde: porAcorde, compas: compas)
            if formato == .midi {
                return binario(voz.midi(tonalidad: analisis.tonalidad, tempo: tempo, titulo: titulo,
                                        instrumento: instrumento ?? 0))
            }
            if formato == .mei {
                return bien(voz.mei(tonalidad: analisis.tonalidad, tempo: tempo, titulo: titulo)
                    .trimmingCharacters(in: "\n"))
            }
            return bien(voz.musicXML(tonalidad: analisis.tonalidad, tempo: tempo, titulo: titulo)
                .trimmingCharacters(in: "\n"))
        default:
            return uso(.tipoDePartituraDesconocido(tipo), notacion)
        }
    }

    /// "sol", "fa", "do3", "do en tercera", "clave de fa", "treble", "bass", "alto"…
    static func leerClave(_ texto: String) -> Clave? {
        let abreviaturas: [String: Clave] = [
            "sol": .sol, "fa": .fa, "do1": .doEnPrimera, "do2": .doEnSegunda, "do3": .doEnTercera,
            "do4": .doEnCuarta, "sol8b": .solOctavaBaja, "sol8a": .solOctavaAlta, "fa3": .faEnTercera,
            "g": .sol, "f": .fa, "treble": .sol, "bass": .fa, "alto": .doEnTercera, "tenor": .doEnCuarta,
        ]
        let limpio = texto.lowercased()
        if let clave = abreviaturas[limpio] { return clave }
        return Clave.allCases.first { clave in
            [clave.nombre, clave.nombre(en: .inglesASCII)].contains { nombre in
                nombre == limpio || nombre.hasPrefix("clave de ") && String(nombre.dropFirst(9)) == limpio
            }
        }
    }
}
