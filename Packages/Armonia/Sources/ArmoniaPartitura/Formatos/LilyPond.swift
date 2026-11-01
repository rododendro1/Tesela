import ArmoniaNucleo
import ArmoniaTeoria

// Exportación a LilyPond (lilypond.org), el programa libre que graba partituras en PDF con la calidad de una
// edición impresa: `lilypond coral.ly` deja `coral.pdf`. Frescobaldi lo edita y lo muestra a la vez.
//
// Se escribe la grafía de cada voz (`Voz.grafia`), con la ortografía tal cual, en altura absoluta y con los nombres
// holandeses de LilyPond (`fis'`, `bes,`). LilyPond decide qué alteraciones se ven y cómo se agrupan las barras,
// como en una partitura. Los cifrados van encima de la nota en que empieza cada acorde y el análisis, debajo, como
// `\markup`.

extension Voz {
    /// La voz como partitura de LilyPond de un solo pentagrama.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let ly = voz.lilyPond(titulo: "Escala")
    ///
    /// - Parameters:
    ///   - tonalidad: da la armadura; si es `nil`, se estima a partir de las notas.
    ///   - clave: si es `nil`, la de sol o la de fa, según el registro de las notas.
    ///   - tempo: si se da, se escribe la indicación metronómica.
    ///   - titulo: el título de la obra.
    ///   - parte: el nombre del pentagrama.
    public func lilyPond(
        tonalidad: Tonalidad? = nil, clave: Clave? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Voz"
    ) -> String {
        Exportacion.documento(
            EscritorLilyPond.self, de: self, tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo,
            parte: parte)
    }
}

extension Coral {
    /// Los acordes como coral de LilyPond en dos pentagramas, como `musicXML(duracion:compas:tonalidad:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// soprano y contralto en clave de sol y tenor y bajo en clave de fa, cada pareja con las plicas en sentidos
    /// contrarios.
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let ly = coral.lilyPond(duracion: .blanca, compas: "3/2", titulo: "Cadencia", cifrados: true)
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - tonalidad: da la armadura y la tonalidad del análisis; si es `nil`, se estima.
    ///   - cifrados: si se escribe el cifrado americano de cada acorde encima del soprano.
    ///   - analisis: si se escriben el cifrado romano y la función debajo del bajo.
    ///   - notacion: la de los cifrados y la tonalidad.
    public func lilyPond(
        duracion: Duracion = .negra, compas: Compas = .compasillo,
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Coro",
        cifrados: Bool = false, analisis: Bool = false,
        notacion: Notacion = .espanolUnicode
    ) -> String {
        Exportacion.documento(
            EscritorLilyPond.self, de: self, duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

extension AnalisisArmonico {
    /// La progresión como partitura de LilyPond en dos pentagramas, como `musicXML(duracion:compas:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// los acordes en posición cerrada en clave de sol, con su cifrado americano encima, y el bajo en clave de fa,
    /// con el cifrado romano y la función debajo.
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let ly = analisis.lilyPond(titulo: "Progresión")
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - cifrados: si se escriben los cifrados americanos.
    ///   - analisis: si se escriben los cifrados romanos y las funciones.
    ///   - notacion: la de los cifrados americanos y la tonalidad.
    public func lilyPond(
        duracion: Duracion = .blanca, compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        lilyPond(
            duraciones: Array(repeating: duracion, count: acordes.count), compas: compas, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }

    /// Lo mismo, con lo que dura cada acorde; el último se alarga hasta la barra.
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func lilyPond(
        duraciones: [Duracion], compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        Exportacion.documento(
            EscritorLilyPond.self, de: self, duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo,
            parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

// MARK: - Escritor LilyPond

/// Reúne varias voces, cada una en un pentagrama (con un `Voice` por voz), y escribe el fichero `.ly`.
package struct EscritorLilyPond: EscritorDePartitura {
    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
    package var lineas: [Exportacion.LineaAnotada] = []
    package var rotulo: (texto: String, pentagrama: Int)?

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
        var ly = "\\version \"2.24.0\"\n\n\\header {\n"
        if let titulo { ly += "  title = \(EscritorLilyPond.cadena(titulo))\n" }
        ly += "  tagline = ##f\n}\n\n\\score {\n"
        let nombre = "\\with { instrumentName = \(EscritorLilyPond.cadena(parte)) }"
        let pentagramas = 1...max(claves.count, 1)
        if claves.count > 1 { ly += "  \\new PianoStaff \(nombre) <<\n" }
        for pentagrama in pentagramas {
            ly += claves.count > 1 ? "    \\new Staff <<\n" : "  \\new Staff \(nombre) <<\n"
            for l in lineas.indices where lineas[l].pentagrama == pentagrama {
                ly += voz(l, sangria: claves.count > 1 ? "      " : "    ")
            }
            ly += claves.count > 1 ? "    >>\n" : "  >>\n"
        }
        if claves.count > 1 { ly += "  >>\n" }
        return ly + "  \\layout { }\n}\n"
    }

    /// Un `\new Voice` con lo que va al principio (clave, armadura, compás…) y un compás por renglón.
    private func voz(_ l: Int, sangria: String) -> String {
        let linea = lineas[l]
        let clave = claves.indices.contains(linea.pentagrama - 1) ? claves[linea.pentagrama - 1] : .sol
        var inicio: [String] = []
        if let arriba = linea.plicaArriba { inicio.append(arriba ? "\\voiceOne" : "\\voiceTwo") }
        inicio.append("\\clef \"\(EscritorLilyPond.clave(clave))\"")
        inicio.append(EscritorLilyPond.armadura(tonalidad))
        inicio.append(EscritorLilyPond.compas(compas))
        if let tempo, l == 0 { inicio.append(EscritorLilyPond.indicacion(tempo)) }
        if anacrusa > .cero { inicio.append("\\partial " + EscritorLilyPond.duracion(anacrusa)) }
        var ly = sangria + "\\new Voice {\n" + sangria + "  " + inicio.joined(separator: " ") + "\n"
        let compases = Exportacion.compases(de: linea.voz)
        // El rótulo va con la primera nota de la voz del análisis o, si no hay, de la primera de su pentagrama.
        let conRotulo = rotulo.flatMap { r in
            r.pentagrama == linea.pentagrama && lineaDelRotulo(r.pentagrama) == l ? r.texto : nil
        }
        for (c, eventos) in compases.enumerated() {
            let compasEntero =
                eventos.count == 1 && eventos[0].evento.esSilencio && !(c == 0 && anacrusa > .cero)
                && eventos[0].evento.duracion == compas.duracion
            var piezas: [String] = []
            var abiertos = Exportacion.irregulares(eventos.map(\.evento))[...]
            var dentro: (fin: Int, piezas: [String], cabecera: String)?
            for (i, (evento, inicio, nuevo)) in eventos.enumerated() {
                if dentro == nil, let grupo = abiertos.first, grupo.rango.lowerBound == i {
                    abiertos.removeFirst()
                    dentro = (grupo.rango.upperBound, [], "\\tuplet \(grupo.reales)/\(grupo.normales) {")
                }
                var texto =
                    compasEntero
                    ? "R" + EscritorLilyPond.duracion(compas.duracion)
                    : EscritorLilyPond.evento(evento, irregular: dentro != nil)
                if nuevo, let cifrado = linea.cifrados[inicio] {
                    texto += "^\\markup \(EscritorLilyPond.cadena(cifrado))"
                }
                var debajo = (nuevo ? linea.letras[inicio] ?? [] : []).filter { !$0.isEmpty }
                if c == 0 && i == 0, let conRotulo { debajo.insert(conRotulo, at: 0) }
                if debajo.count == 1 { texto += "_\\markup \(EscritorLilyPond.cadena(debajo[0]))" }
                if debajo.count > 1 {
                    texto += "_\\markup \\column { " + debajo.map(EscritorLilyPond.cadena).joined(separator: " ") + " }"
                }
                if var grupo = dentro {
                    grupo.piezas.append(texto)
                    dentro = grupo
                    if grupo.fin == i {
                        piezas.append(grupo.cabecera + " " + grupo.piezas.joined(separator: " ") + " }")
                        dentro = nil
                    }
                } else {
                    piezas.append(texto)
                }
            }
            // Sin barra de comprobación tras el último, que puede estar incompleto (el que cierra una anacrusa).
            ly += sangria + "  " + piezas.joined(separator: " ") + (c == compases.count - 1 ? "\n" : " |\n")
        }
        if compases.isEmpty { ly += sangria + "  R" + EscritorLilyPond.duracion(compas.duracion) + " |\n" }
        return ly + sangria + "  \\bar \"|.\"\n" + sangria + "}\n"
    }

    /// La línea que lleva el rótulo de un pentagrama: la que tiene el análisis o, si no, la primera.
    private func lineaDelRotulo(_ pentagrama: Int) -> Int? {
        let suyas = lineas.indices.filter { lineas[$0].pentagrama == pentagrama }
        return suyas.first { !lineas[$0].letras.isEmpty } ?? suyas.first
    }

    // MARK: Eventos

    /// Una nota (`fis'4~`), un acorde (`<c e g>2.`) o un silencio (`r8`). En un grupo irregular, la duración es la
    /// de la figura que se escribe, porque `\tuplet` la acorta.
    private static func evento(_ evento: Evento, irregular: Bool) -> String {
        let escrita = Exportacion.figura(de: evento.duracion)
        let figura =
            irregular && escrita.figura != nil
            ? figura(escrita.figura!) + String(repeating: ".", count: escrita.puntillos) : duracion(evento.duracion)
        let ligadura = evento.ligada ? "~" : ""
        switch evento.alturas.count {
        case 0: return "r" + figura
        case 1: return altura(evento.alturas[0]) + figura + ligadura
        default: return "<" + evento.alturas.map(altura).joined(separator: " ") + ">" + figura + ligadura
        }
    }

    /// La altura absoluta con el nombre holandés: Do4 → `c'`, Fa♯3 → `fis`, Si♭1 → `bes,,`.
    package static func altura(_ altura: Altura) -> String {
        let (natural, semitonos, octava) = Exportacion.sinTriples(altura)
        let nombre = ["c", "d", "e", "f", "g", "a", "b"][natural.rawValue]
        let alteracion = [-2: "eses", -1: "es", 0: "", 1: "is", 2: "isis"][semitonos] ?? ""
        let marcas = octava >= 3 ? String(repeating: "'", count: octava - 3) : String(repeating: ",", count: 3 - octava)
        return nombre + alteracion + marcas
    }

    /// Una duración: con su figura (`4.`, `\breve`) si la tiene; si no, como fracción de redonda (`1*5/16`).
    package static func duracion(_ duracion: Duracion) -> String {
        if let (figura, puntillos) = duracion.figuraYPuntillos {
            return self.figura(figura) + String(repeating: ".", count: puntillos)
        }
        return "1*\(duracion.numerador)/\(duracion.denominador)"
    }

    private static func figura(_ figura: Figura) -> String {
        figura == .cuadrada ? "\\breve" : String(1 << figura.rawValue)
    }

    // MARK: Lo del principio

    package static func clave(_ clave: Clave) -> String {
        switch clave {
        case .sol: return "treble"
        case .solOctavaBaja: return "treble_8"
        case .solOctavaAlta: return "treble^8"
        case .fa: return "bass"
        case .faEnTercera: return "varbaritone"
        case .doEnPrimera: return "soprano"
        case .doEnSegunda: return "mezzosoprano"
        case .doEnTercera: return "alto"
        case .doEnCuarta: return "tenor"
        }
    }

    /// `\key d \major`; Do mayor si no hay tonalidad.
    private static func armadura(_ tonalidad: Tonalidad?) -> String {
        guard let tonalidad else { return "\\key c \\major" }
        let tonica = altura(Altura(tonalidad.tonica, octava: 3))
        return "\\key \(tonica) " + (tonalidad.modo == .mayor ? "\\major" : "\\minor")
    }

    /// `\time 3/4`, y `\time 2,2,3 7/8` en uno de amalgama irregular.
    private static func compas(_ compas: Compas) -> String {
        let pulsos = EscritorMEI.pulsos(compas)
        let agrupacion = pulsos.contains("+") ? String(pulsos.map { $0 == "+" ? "," : $0 }) + " " : ""
        return "\\time \(agrupacion)\(compas.numerador)/\(compas.denominador)"
    }

    /// `\tempo 4. = 60`, con la figura del pulso; en negras si no tiene figura.
    private static func indicacion(_ tempo: Tempo) -> String {
        if let (figura, puntillos) = tempo.unidad.figuraYPuntillos {
            let unidad = self.figura(figura) + String(repeating: ".", count: puntillos)
            return "\\tempo \(unidad) = \(Int(tempo.pulsosPorMinuto.rounded()))"
        }
        return "\\tempo 4 = \(Int(tempo.negrasPorMinuto.rounded()))"
    }

    /// Un texto entre comillas, con `"` y `\` escapadas.
    package static func cadena(_ texto: String) -> String {
        "\"" + String(texto.flatMap { $0 == "\\" || $0 == "\"" ? "\\\($0)" : "\($0)" }) + "\""
    }
}
