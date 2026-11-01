import ArmoniaNucleo
import ArmoniaTeoria

// Exportación a ABC 2.1 (abcnotation.com), la notación en texto de la música tradicional: la leen abcjs (en el
// navegador), abcm2ps, EasyABC y MuseScore (con un complemento), y se comparte en foros y cancioneros.
//
// Se escribe la grafía de cada voz (`Voz.grafia`), con la ortografía tal cual y la armadura de la tonalidad. En ABC
// una alteración vale hasta la barra para esa nota en esa octava y en esa voz, y la de la armadura no se escribe,
// así que se calculan las que hay que escribir. Las notas unidas por barras van juntas, sin espacios.
//
// Los cifrados van como texto encima de la nota en que empieza cada acorde (`"^Do7"`) y el análisis, debajo
// (`"_V7"`): como texto, y no como acordes de ABC, para que se escriban en cualquier notación.

extension Voz {
    /// La voz como melodía en ABC.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let abc = voz.abc(titulo: "Escala")
    ///
    /// - Parameters:
    ///   - tonalidad: da la armadura; si es `nil`, se estima a partir de las notas.
    ///   - clave: si es `nil`, la de sol o la de fa, según el registro de las notas.
    ///   - tempo: si se da, se escribe la indicación metronómica.
    ///   - titulo: el título de la obra.
    ///   - parte: el nombre del pentagrama.
    public func abc(
        tonalidad: Tonalidad? = nil, clave: Clave? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Voz"
    ) -> String {
        Exportacion.documento(
            EscritorABC.self, de: self, tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo,
            parte: parte)
    }
}

extension Coral {
    /// Los acordes como coral en ABC, en dos pentagramas, como `musicXML(duracion:compas:tonalidad:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// soprano y contralto en clave de sol y tenor y bajo en clave de fa, cada pareja con las plicas en sentidos
    /// contrarios.
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let abc = coral.abc(duracion: .blanca, compas: "3/2", titulo: "Cadencia", cifrados: true)
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - tonalidad: da la armadura y la tonalidad del análisis; si es `nil`, se estima.
    ///   - cifrados: si se escribe el cifrado americano de cada acorde encima del soprano.
    ///   - analisis: si se escriben el cifrado romano y la función debajo del bajo.
    ///   - notacion: la de los cifrados y la tonalidad.
    public func abc(
        duracion: Duracion = .negra, compas: Compas = .compasillo,
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Coro",
        cifrados: Bool = false, analisis: Bool = false,
        notacion: Notacion = .espanolUnicode
    ) -> String {
        Exportacion.documento(
            EscritorABC.self, de: self, duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

extension AnalisisArmonico {
    /// La progresión en ABC, en dos pentagramas, como `musicXML(duracion:compas:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// los acordes en posición cerrada en clave de sol, con su cifrado americano encima, y el bajo en clave de fa,
    /// con el cifrado romano y la función debajo.
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let abc = analisis.abc(titulo: "Progresión")
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - cifrados: si se escriben los cifrados americanos.
    ///   - analisis: si se escriben los cifrados romanos y las funciones.
    ///   - notacion: la de los cifrados americanos y la tonalidad.
    public func abc(
        duracion: Duracion = .blanca, compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        abc(
            duraciones: Array(repeating: duracion, count: acordes.count), compas: compas, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }

    /// Lo mismo, con lo que dura cada acorde; el último se alarga hasta la barra.
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func abc(
        duraciones: [Duracion], compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        Exportacion.documento(
            EscritorABC.self, de: self, duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo,
            parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

// MARK: - Escritor ABC

/// Reúne varias voces, cada una en un pentagrama, y escribe la pieza en ABC (una voz `V:` por línea).
package struct EscritorABC: EscritorDePartitura {
    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
    package var lineas: [Exportacion.LineaAnotada] = []
    package var rotulo: (texto: String, pentagrama: Int)?

    /// La duración de `L:`, a la que se refieren las de las notas: la negra.
    private static let unidad = Duracion.negra
    /// Compases por renglón.
    private static let compasesPorRenglon = 4

    package init(
        compas: Compas, anacrusa: Duracion, tonalidad: Tonalidad?, tempo: Tempo?,
        titulo: String?, parte: String, claves: [Clave]
    ) {
        self.compas = compas
        self.anacrusa = anacrusa
        self.tonalidad = tonalidad
        self.tempo = tempo
        self.titulo = titulo
        self.parte = parte
        self.claves = claves
    }

    package mutating func anadir(
        _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
        cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion
    ) {
        lineas.append(
            Exportacion.LineaAnotada(
                voz, pentagrama: pentagrama, plicaArriba: plicaArriba, cifrados: cifrados, analisis: analisis,
                notacion: notacion))
    }

    package var documento: String {
        var abc = "X:1\nT:\(EscritorABC.texto(titulo ?? ""))\n"
        abc += "M:\(EscritorABC.compas(compas))\nL:1/4\n"
        if let tempo { abc += "Q:\(EscritorABC.indicacion(tempo))\n" }
        if lineas.count > 1 {
            // Las voces de un mismo pentagrama, entre paréntesis; los pentagramas, unidos por una llave.
            let pentagramas = Array(Set(lineas.map(\.pentagrama))).sorted().map { p in
                let suyas = lineas.indices.filter { lineas[$0].pentagrama == p }.map { "\($0 + 1)" }
                return suyas.count > 1 ? "(" + suyas.joined(separator: " ") + ")" : suyas[0]
            }
            abc += "%%score {" + pentagramas.joined(separator: " | ") + "}\n"
        }
        for (l, linea) in lineas.enumerated() {
            let clave = claves.indices.contains(linea.pentagrama - 1) ? claves[linea.pentagrama - 1] : .sol
            abc += "V:\(l + 1) clef=\(EscritorABC.clave(clave))"
            if l == 0 { abc += " name=\"\(EscritorABC.texto(parte))\"" }
            if let arriba = linea.plicaArriba { abc += " stem=\(arriba ? "up" : "down")" }
            abc += "\n"
        }
        abc += "K:\(EscritorABC.armadura(tonalidad))\n"
        for l in lineas.indices {
            abc += "V:\(l + 1)\n" + musica(l)
        }
        return abc
    }

    /// La música de una línea: los compases, unos cuantos por renglón, y la barra final.
    private func musica(_ l: Int) -> String {
        let linea = lineas[l]
        let compases = Exportacion.compases(de: linea.voz)
        let barras = linea.voz.barrasDeAgrupacion
        let armadura = Dictionary(
            (tonalidad?.notasDeLaArmadura ?? []).map { ($0.natural, $0.alteracion.semitonos) },
            uniquingKeysWith: { primera, _ in primera })
        let conRotulo = rotulo.flatMap { r in
            r.pentagrama == linea.pentagrama && lineaDelRotulo(r.pentagrama) == l ? r.texto : nil
        }
        var escritos: [String] = []
        for (c, eventos) in compases.enumerated() {
            let compasEntero =
                eventos.count == 1 && eventos[0].evento.esSilencio && !(c == 0 && anacrusa > .cero)
                && eventos[0].evento.duracion == compas.duracion
            if compasEntero {
                escritos.append("Z")
                continue
            }
            let irregulares = Exportacion.irregulares(eventos.map(\.evento))
            let unidos = Set(barras[c].flatMap { $0.dropLast() })
            // Las alteraciones que valen en el compás, por línea o espacio del pentagrama.
            var vigentes: [Int: Int] = [:]
            var texto = ""
            for (i, (evento, inicio, nuevo)) in eventos.enumerated() {
                let grupo = irregulares.first { $0.rango.contains(i) }
                if let grupo, grupo.rango.lowerBound == i {
                    texto += "(\(grupo.reales):\(grupo.normales):\(grupo.rango.count)"
                }
                if nuevo, let cifrado = linea.cifrados[inicio] { texto += "\"^\(EscritorABC.texto(cifrado))\"" }
                var debajo = (nuevo ? linea.letras[inicio] ?? [] : []).filter { !$0.isEmpty }
                if c == 0 && i == 0, let conRotulo { debajo.insert(conRotulo, at: 0) }
                for linea in debajo { texto += "\"_\(EscritorABC.texto(linea))\"" }
                let alturas = evento.alturas.map { altura in
                    let (natural, semitonos, octava) = Exportacion.sinTriples(altura)
                    let lugar = octava * 7 + natural.rawValue
                    var escrita = ""
                    if semitonos != vigentes[lugar] ?? armadura[natural] ?? 0 {
                        escrita = [-2: "__", -1: "_", 0: "=", 1: "^", 2: "^^"][semitonos] ?? ""
                        vigentes[lugar] = semitonos
                    }
                    return escrita + EscritorABC.nombre(natural, octava: octava)
                }
                let escrita = Exportacion.figura(de: evento.duracion)
                let duracion =
                    grupo != nil && escrita.figura != nil
                    ? escrita.figura!.duracion * Duracion(1 << (escrita.puntillos + 1) - 1, 1 << escrita.puntillos)
                    : evento.duracion
                switch alturas.count {
                case 0: texto += "z"
                case 1: texto += alturas[0]
                default: texto += "[" + alturas.joined() + "]"
                }
                texto += EscritorABC.longitud(duracion) + (evento.ligada && !evento.esSilencio ? "-" : "")
                if !unidos.contains(i) && i < eventos.count - 1 { texto += " " }
            }
            escritos.append(texto)
        }
        if escritos.isEmpty { escritos = ["Z"] }
        var abc = ""
        for (c, compas) in escritos.enumerated() {
            let ultimo = c == escritos.count - 1
            abc += compas + (ultimo ? " |]\n" : " |")
            if !ultimo { abc += (c + 1) % EscritorABC.compasesPorRenglon == 0 ? "\n" : " " }
        }
        return abc
    }

    /// La línea que lleva el rótulo de un pentagrama: la que tiene el análisis o, si no, la primera.
    private func lineaDelRotulo(_ pentagrama: Int) -> Int? {
        let suyas = lineas.indices.filter { lineas[$0].pentagrama == pentagrama }
        return suyas.first { !lineas[$0].letras.isEmpty } ?? suyas.first
    }

    // MARK: Auxiliares

    /// La nota en la octava: Do4 → `C`, Do5 → `c`, Do6 → `c'`, Do3 → `C,`.
    package static func nombre(_ natural: NotaNatural, octava: Int) -> String {
        let letra = ["C", "D", "E", "F", "G", "A", "B"][natural.rawValue]
        if octava >= 5 { return letra.lowercased() + String(repeating: "'", count: octava - 5) }
        return letra + String(repeating: ",", count: max(0, 4 - octava))
    }

    /// La duración en negras (`L:1/4`): la negra no se escribe, la corchea es `/2` y la blanca con puntillo, `3`.
    package static func longitud(_ duracion: Duracion) -> String {
        let enNegras = duracion / unidad
        let numerador = enNegras.numerador == 1 ? "" : "\(enNegras.numerador)"
        return enNegras.denominador == 1 ? numerador : numerador + "/\(enNegras.denominador)"
    }

    package static func clave(_ clave: Clave) -> String {
        switch clave {
        case .sol: return "treble"
        case .solOctavaBaja: return "treble-8"
        case .solOctavaAlta: return "treble+8"
        case .fa: return "bass"
        case .faEnTercera: return "bass3"
        case .doEnPrimera: return "alto1"
        case .doEnSegunda: return "alto2"
        case .doEnTercera: return "alto"
        case .doEnCuarta: return "tenor"
        }
    }

    /// `K:`: la tónica en inglés (`F#`, `Bb`) y `m` si es menor; Do mayor si no hay tonalidad.
    private static func armadura(_ tonalidad: Tonalidad?) -> String {
        guard let tonalidad else { return "C" }
        let (natural, semitonos, _) = Exportacion.sinTriples(Altura(tonalidad.tonica, octava: 4))
        let nombre = ["C", "D", "E", "F", "G", "A", "B"][natural.rawValue]
        let alteracion =
            semitonos > 0 ? String(repeating: "#", count: semitonos) : String(repeating: "b", count: -semitonos)
        return nombre + alteracion + (tonalidad.modo == .menor ? "m" : "")
    }

    /// `M:`: `C` en el compasillo, `C|` en el partido y `(2+2+3)/8` en uno de amalgama irregular.
    private static func compas(_ compas: Compas) -> String {
        if compas == .compasillo { return "C" }
        if compas == .partido { return "C|" }
        let pulsos = EscritorMEI.pulsos(compas)
        return (pulsos.contains("+") ? "(\(pulsos))" : "\(compas.numerador)") + "/\(compas.denominador)"
    }

    /// `Q:3/8=60`: la figura del pulso, como fracción de redonda, y los pulsos por minuto.
    private static func indicacion(_ tempo: Tempo) -> String {
        "\(tempo.unidad.numerador)/\(tempo.unidad.denominador)=\(Int(tempo.pulsosPorMinuto.rounded()))"
    }

    /// Un texto en una línea, sin comillas dobles (que lo cerrarían).
    package static func texto(_ texto: String) -> String {
        String(texto.map { $0 == "\"" ? "'" : ($0.isNewline ? " " : $0) })
    }
}
