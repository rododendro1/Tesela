import Armonia
import Foundation

// MARK: - Partituras: MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI

extension LineaDeComandos {
    /// `musicxml melodia …`, `mei melodia …`, `lilypond melodia …`, `guido melodia …`, `abc melodia …` y
    /// `midi melodia …`: las mismas opciones, salvo la clave y las marcas (no en MIDI) y el instrumento (solo MIDI).
    /// Además de una melodía, se exporta un coral, unos acordes, sus arpegios o una escala (`musicxml escala Re
    /// bayati`, con sus microtonos).
    static func partitura(
        _ argumentos: [String], _ notacion: Notacion, formato: FormatoDePartitura
    ) throws -> ResultadoDeOrden {
        let orden = formato.rawValue
        guard let tipo = argumentos.first?.lowercased() else {
            return uso(.faltaTipoDePartitura(orden: orden), notacion)
        }
        // Los argumentos hasta la primera opción son la música; cada opción toma lo que la sigue.
        // `--program` es `--programa` en inglés (solo en MIDI); `--patrón` y `--pattern` son `--patron`, y `--file`
        // y `--window`, `--archivo` y `--ventana`.
        var entrada = Argumentos(Array(argumentos.dropFirst()))
        let alias: [(String, String)] =
            (formato == .midi ? [("program", "programa")] : [])
            + [("patrón", "patron"), ("pattern", "patron"), ("file", "archivo"), ("window", "ventana")]
        // `--enlazar`: cada arpegio empieza cerca de donde acabó el anterior.
        let enlazados = entrada.quitarMarca("--enlazar", "--connect")
        let (opciones, marcas) = entrada.quitarOpcionesConTexto(
            marcas: ["cifrados": "cifrados", "analisis": "analisis", "análisis": "analisis"], alias: alias)
        let musica = entrada.restantes
        let conocidas: Set =
            formato == .midi
            ? [
                "compas", "anacrusa", "tonalidad", "tempo", "titulo", "duracion", "programa", "patron", "figura",
                "archivo", "ventana",
            ]
            : [
                "compas", "anacrusa", "tonalidad", "clave", "tempo", "titulo", "duracion", "patron", "figura",
                "archivo", "ventana",
            ]
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
        if let vacia = opciones.sorted(by: { $0.key < $1.key }).first(where: { $0.value.isEmpty })?.key {
            return uso(.faltaValor(vacia), notacion)
        }
        var compas = try opciones["compas"].map { try Compas(leyendo: $0) } ?? .compasillo
        let tonalidad = try opciones["tonalidad"].map { try Tonalidad(leyendo: $0) }
        var tempo: Tempo?
        if let texto = opciones["tempo"] {
            let partes = texto.split(separator: " ").map(String.init)
            guard let bpm = Double(partes[0].replacingComa()), bpm > 0, partes.count <= 2 else {
                return uso(.tempoMalEscrito, notacion)
            }
            tempo = Tempo(bpm, unidad: try partes.dropFirst().first.map { try Duracion(leyendo: $0) } ?? .negra)
        }
        var titulo = opciones["titulo"]
        let arpegios: Set = ["arpegios", "arpegio", "arpeggios", "arpeggio"]
        let acordes: Set = ["acordes", "progresion", "progresión", "chords"]
        if !arpegios.contains(tipo), let opcion = ["figura", "patron"].first(where: { opciones[$0] != nil }) {
            return uso(.soloParaArpegios(opcion), notacion)
        }
        if !arpegios.contains(tipo) && enlazados { return uso(.soloParaArpegios("enlazar"), notacion) }
        // `--archivo`: los acordes de un fichero MIDI, MusicXML, MEI o ABC, con su ritmo armónico (lo que dura cada
        // uno), y su compás, su tempo y su título si no se dan otros.
        var leidos: (acordes: [Acorde], duraciones: [Duracion])?
        if let archivo = opciones["archivo"] {
            guard acordes.contains(tipo) || arpegios.contains(tipo) else {
                return uso(.archivoSoloParaAcordes, notacion)
            }
            guard musica.isEmpty else { return uso(.archivoConAcordes, notacion) }
            guard let datos = FileManager.default.contents(atPath: archivo) else {
                return uso(.archivoIlegible(archivo), notacion)
            }
            let pieza = try PiezaImportada(leyendo: datos)
            let ventana = try opciones["ventana"].map { try Duracion(leyendo: $0) }
            let conDuracion = pieza.acordesConDuracion(ventana: ventana)
            guard !conDuracion.isEmpty else { return uso(.archivoSinAcordes, notacion) }
            leidos = (conDuracion.map(\.acorde), conDuracion.map(\.duracion))
            if opciones["compas"] == nil, let suyo = pieza.compas { compas = suyo }
            tempo = tempo ?? pieza.tempo
            titulo = titulo ?? pieza.titulo
        } else if opciones["ventana"] != nil {
            return uso(.ventanaSinArchivo, notacion)
        }
        // Los acordes analizados, del fichero o escritos, y lo que dura cada uno (`nil`: lo de `--duracion`).
        func progresion() throws -> (analisis: AnalisisArmonico, duraciones: [Duracion]?)? {
            if let leidos {
                let enSuTonalidad = tonalidad.map { $0.analizar(leidos.acordes) }
                guard let analisis = enSuTonalidad ?? AnalisisArmonico.analizar(leidos.acordes) else { return nil }
                // `--duracion` manda sobre el ritmo del fichero.
                let duraciones: [Duracion]? = opciones["duracion"] == nil ? leidos.duraciones : nil
                return (analisis, duraciones)
            }
            guard !musica.isEmpty else { return nil }
            return (try AnalisisArmonico.analizar(leyendo: musica.joined(separator: " "), en: tonalidad), nil)
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
            return salida(
                formato,
                voz.partitura(
                    clave: clave,
                    encabezado: Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento)
                ).exportar(como: formato))
        case "coral", "chorale":
            guard !musica.isEmpty else {
                return uso(.faltanAcordesDelCoral(orden: orden), notacion)
            }
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                return uso(.soloParaMelodia(opcion), notacion)
            }
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .negra
            let coral = try Coral(leyendo: musica.joined(separator: " "))
            // En MIDI no hay marcas: ya se ha comprobado.
            return salida(
                formato,
                coral.partitura(
                    duracion: duracion, compas: compas,
                    encabezado: Encabezado(
                        titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento),
                    cifrados: marcas.contains("cifrados"), analisis: marcas.contains("analisis"), notacion: notacion
                ).exportar(como: formato))
        case _ where acordes.contains(tipo):
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                return uso(.soloParaMelodia(opcion), notacion)
            }
            if !marcas.isEmpty { return uso(.acordesConCifradosYAnalisis, notacion) }
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .negra
            guard let leida = try progresion() else {
                return uso(.faltanAcordesDeLaProgresion(orden: orden), notacion)
            }
            let (analisis, ritmo) = leida
            let duraciones = ritmo ?? Array(repeating: duracion, count: analisis.acordes.count)
            return salida(
                formato,
                try analisis.partitura(
                    duraciones: duraciones, compas: compas,
                    encabezado: Encabezado(titulo: titulo, tempo: tempo, instrumento: instrumento), notacion: notacion
                ).exportar(como: formato))
        case _ where arpegios.contains(tipo):
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
            let porAcorde = try opciones["duracion"].map { try Duracion(leyendo: $0) }
            // La tonalidad, la dada o la que mejor explica los acordes, pone la armadura.
            guard let leida = try progresion() else {
                return uso(.faltanAcordesDeLaProgresion(orden: orden), notacion)
            }
            let (analisis, ritmo) = leida
            let voz: Voz
            if let ritmo {
                voz = try Voz(
                    arpegiando: analisis.acordes.map(\.acorde), duraciones: ritmo, patron: patron, figura: figura,
                    compas: compas, enlazados: enlazados)
            } else {
                voz = Voz(
                    arpegiando: analisis.acordes.map(\.acorde), patron: patron, figura: figura,
                    porAcorde: porAcorde, compas: compas, enlazados: enlazados)
            }
            return salida(
                formato,
                voz.partitura(
                    encabezado: Encabezado(
                        titulo: titulo, tonalidad: analisis.tonalidad, tempo: tempo, instrumento: instrumento)
                ).exportar(como: formato))
        case "escala", "scale":
            // Una escala en negras (o en lo que diga `--duracion`), con sus microtonos si los tiene.
            guard !musica.isEmpty else { return uso(.faltaEscala, notacion) }
            if !marcas.isEmpty { return uso(.marcasSoloCoral, notacion) }
            if opciones["anacrusa"] != nil { return uso(.soloParaMelodia("anacrusa"), notacion) }
            var clave: Clave?
            if let texto = opciones["clave"] {
                guard let leida = leerClave(texto) else { return uso(.claveDesconocida(texto), notacion) }
                clave = leida
            }
            let escala = try Escala(leyendo: musica.joined(separator: " "))
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .negra
            var voz = escala.voz(duracion: duracion)
            voz.compas = compas
            let titulo = titulo ?? escala.nombre(en: notacion)
            return salida(
                formato,
                voz.partitura(
                    clave: clave,
                    encabezado: Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento)
                ).exportar(como: formato))
        default:
            return uso(.tipoDePartituraDesconocido(tipo), notacion)
        }
    }

    /// La partitura que da `exportar(como:…)`: el MIDI, tal cual, y los formatos de texto, sin el salto de línea del
    /// final.
    private static func salida(_ formato: FormatoDePartitura, _ datos: Data) -> ResultadoDeOrden {
        guard formato.esTexto else { return binario(datos) }
        return bien(String(decoding: datos, as: UTF8.self).trimmingCharacters(in: "\n"))
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
