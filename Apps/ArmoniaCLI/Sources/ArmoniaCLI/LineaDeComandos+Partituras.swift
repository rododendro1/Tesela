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
            throw ErrorDeUso.faltaTipoDePartitura(orden: orden)
        }
        // Los argumentos hasta la primera opción son la música; cada opción toma lo que la sigue.
        // `--program` es `--programa` en inglés (solo en MIDI); `--patrón` y `--pattern` son `--patron`, y `--file`
        // y `--window`, `--archivo` y `--ventana`.
        var entrada = Argumentos(Array(argumentos.dropFirst()))
        let alias: [(String, String)] =
            (formato == .midi ? [("program", "programa")] : [])
            + [("patrón", "patron"), ("pattern", "patron"), ("file", "archivo"), ("window", "ventana")]
        // `--enlazar`: cada arpegio empieza cerca de donde acabó el anterior.
        let enlazados = entrada.quitarMarca(.enlazar)
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
            throw ErrorDeUso.opcionDesconocida("--" + desconocida)
        }
        var instrumento: Int?
        if let texto = opciones["programa"] {
            guard let n = Int(texto), (0...127).contains(n) else {
                throw ErrorDeUso.instrumentoMIDI
            }
            instrumento = n
        }
        if formato == .midi && !marcas.isEmpty { throw ErrorDeUso.marcasSoloMusicXML }
        if let vacia = opciones.sorted(by: { $0.key < $1.key }).first(where: { $0.value.isEmpty })?.key {
            throw ErrorDeUso.faltaValor(vacia)
        }
        var compas = try opciones["compas"].map { try Compas(leyendo: $0) } ?? .compasillo
        let tonalidad = try opciones["tonalidad"].map { try Tonalidad(leyendo: $0) }
        var tempo: Tempo?
        if let texto = opciones["tempo"] {
            let partes = texto.split(separator: " ").map(String.init)
            guard let bpm = Double(partes[0].replacingComa()), bpm > 0, partes.count <= 2 else {
                throw ErrorDeUso.tempoMalEscrito
            }
            tempo = Tempo(bpm, unidad: try partes.dropFirst().first.map { try Duracion(leyendo: $0) } ?? .negra)
        }
        var titulo = opciones["titulo"]
        let arpegios: Set = ["arpegios", "arpegio", "arpeggios", "arpeggio"]
        let acordes: Set = ["acordes", "progresion", "progresión", "chords"]
        if !arpegios.contains(tipo), let opcion = ["figura", "patron"].first(where: { opciones[$0] != nil }) {
            throw ErrorDeUso.soloParaArpegios(opcion)
        }
        if !arpegios.contains(tipo) && enlazados { throw ErrorDeUso.soloParaArpegios("enlazar") }
        // `--archivo`: los acordes de un fichero MIDI, MusicXML, MEI o ABC, con su ritmo armónico (lo que dura cada
        // uno), y su compás, su tempo y su título si no se dan otros.
        var leido: RitmoArmonico?
        if let archivo = opciones["archivo"] {
            guard acordes.contains(tipo) || arpegios.contains(tipo) else {
                throw ErrorDeUso.archivoSoloParaAcordes
            }
            guard musica.isEmpty else { throw ErrorDeUso.archivoConAcordes }
            guard let datos = contenido(deArchivo: archivo) else { return archivoIlegible(archivo, notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            let ventana = try opciones["ventana"].map { try Duracion(leyendo: $0) }
            let suyo = pieza.ritmoArmonico(ventana: ventana)
            guard !suyo.acordes.isEmpty else { throw ErrorDeUso.archivoSinAcordes }
            if opciones["compas"] == nil, let delFichero = pieza.compas { compas = delFichero }
            tempo = tempo ?? pieza.tempo
            titulo = titulo ?? pieza.titulo
            leido = RitmoArmonico(suyo.acordes, compas: compas, tempo: tempo)
        } else if opciones["ventana"] != nil {
            throw ErrorDeUso.ventanaSinArchivo
        }
        // Los acordes analizados, del fichero o escritos, y su ritmo (`nil`: el de `--duracion`).
        func progresion() throws -> (analisis: AnalisisArmonico, ritmo: RitmoArmonico?)? {
            if let leido {
                let acordes = leido.acordes.map(\.acorde)
                let enSuTonalidad = tonalidad.map { $0.analizar(acordes) }
                guard let analisis = enSuTonalidad ?? AnalisisArmonico.analizar(acordes) else { return nil }
                // `--duracion` manda sobre el ritmo del fichero.
                return (analisis, opciones["duracion"] == nil ? leido : nil)
            }
            guard !musica.isEmpty else { return nil }
            return (try AnalisisArmonico.analizar(leyendo: musica.joined(separator: " "), en: tonalidad), nil)
        }

        switch tipo {
        case "melodia", "melodía", "melody":
            guard !musica.isEmpty else { throw ErrorDeUso.faltanNotasDeLaMelodia(orden: orden) }
            if !marcas.isEmpty { throw ErrorDeUso.marcasSoloCoral }
            if opciones["duracion"] != nil { throw ErrorDeUso.duracionSoloCoral }
            var clave: Clave?
            if let texto = opciones["clave"] {
                guard let leida = leerClave(texto) else {
                    throw ErrorDeUso.claveDesconocida(texto)
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
                throw ErrorDeUso.faltanAcordesDelCoral(orden: orden)
            }
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                throw ErrorDeUso.soloParaMelodia(opcion)
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
                    conCifrados: marcas.contains("cifrados"), conAnalisis: marcas.contains("analisis"),
                    notacion: notacion
                ).exportar(como: formato))
        case _ where acordes.contains(tipo):
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                throw ErrorDeUso.soloParaMelodia(opcion)
            }
            if !marcas.isEmpty { throw ErrorDeUso.acordesConCifradosYAnalisis }
            let duracion = try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? .negra
            guard let leida = try progresion() else {
                throw ErrorDeUso.faltanAcordesDeLaProgresion(orden: orden)
            }
            let (analisis, suyo) = leida
            let ritmo = suyo ?? RitmoArmonico(analisis.acordes.map(\.acorde), duracion: duracion, compas: compas)
            return salida(
                formato,
                ritmo.partitura(
                    en: analisis.tonalidad,
                    encabezado: Encabezado(titulo: titulo, tempo: tempo, instrumento: instrumento), notacion: notacion
                ).exportar(como: formato))
        case _ where arpegios.contains(tipo):
            for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
                throw ErrorDeUso.soloParaMelodia(opcion)
            }
            if !marcas.isEmpty { throw ErrorDeUso.acordesConCifradosYAnalisis }
            var patron = Arpegio.Patron.ascendente
            if let texto = opciones["patron"] {
                guard let elegido = patronDeArpegio(texto) else { throw ErrorDeUso.patronDesconocido(texto) }
                patron = elegido
            }
            let figura = try opciones["figura"].map { try Duracion(leyendo: $0) } ?? .corchea
            if figura <= .cero, let texto = opciones["figura"] { // "0/4"
                throw ErrorDeLecturaDePartitura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto))
            }
            let porAcorde = try opciones["duracion"].map { try Duracion(leyendo: $0) }
            // La tonalidad, la dada o la que mejor explica los acordes, pone la armadura.
            guard let leida = try progresion() else {
                throw ErrorDeUso.faltanAcordesDeLaProgresion(orden: orden)
            }
            let (analisis, ritmo) = leida
            let voz: Voz
            if let ritmo {
                voz = Voz(arpegiando: ritmo, patron: patron, figura: figura, enlazados: enlazados)
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
            guard !musica.isEmpty else { throw ErrorDeUso.faltaEscala }
            if !marcas.isEmpty { throw ErrorDeUso.marcasSoloCoral }
            if opciones["anacrusa"] != nil { throw ErrorDeUso.soloParaMelodia("anacrusa") }
            var clave: Clave?
            if let texto = opciones["clave"] {
                guard let leida = leerClave(texto) else { throw ErrorDeUso.claveDesconocida(texto) }
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
            throw ErrorDeUso.tipoDePartituraDesconocido(tipo)
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
