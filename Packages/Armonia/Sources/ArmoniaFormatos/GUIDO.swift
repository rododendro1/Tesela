import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// Exportación a GUIDO Music Notation (GMN), el formato de texto de Guido Engine (guido.grame.fr), la biblioteca que
// graba partituras en SVG: `guido2svg coral.gmn > coral.svg`. Es la entrada que necesita el motor para dibujar las
// partituras con él en vez de con `ArmoniaPartitura`.
//
// Se escribe la grafía de cada voz (`Voz.grafia`), con la ortografía tal cual y en altura absoluta: en GMN la octava
// 1 es la del Do central (Do4 → `c1`, Fa♯3 → `f#0`, Si♭1 → `b&-2`) y las alteraciones son `#` y `&`. Cada duración se
// escribe como fracción de redonda (`/4`, `*3/8`, `/12`), así que los puntillos y los grupos irregulares los decide
// Guido a partir de lo que dura cada nota; los grupos irregulares se marcan además con `\tuplet`. Las barras se
// escriben a mano (`autoBarlines="off"`) para que la anacrusa quede bien. Los cifrados van encima de la nota en que
// empieza cada acorde, con `\harmony`, y el análisis, debajo, con `\text`. Los cuartos de tono se escriben con la
// nota temperada.

extension Voz {
    /// La voz como partitura GMN de un solo pentagrama.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let gmn = voz.guido(titulo: "Escala")
    ///
    /// - Parameters:
    ///   - tonalidad: da la armadura; si es `nil`, se estima a partir de las notas.
    ///   - clave: si es `nil`, la de sol o la de fa, según el registro de las notas.
    ///   - tempo: si se da, se escribe la indicación metronómica.
    ///   - titulo: el título de la obra.
    ///   - parte: el nombre del pentagrama.
    public func guido(
        tonalidad: Tonalidad? = nil, clave: Clave? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Voz"
    ) -> String {
        Exportacion.documento(
            EscritorGUIDO.self, de: self, tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo,
            parte: parte)
    }
}

extension Coral {
    /// Los acordes como coral GMN en dos pentagramas, como `lilyPond(duracion:compas:tonalidad:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// soprano y contralto en clave de sol y tenor y bajo en clave de fa, cada pareja con las plicas en sentidos
    /// contrarios.
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let gmn = coral.guido(duracion: .blanca, compas: "3/2", titulo: "Cadencia", cifrados: true)
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - tonalidad: da la armadura y la tonalidad del análisis; si es `nil`, se estima.
    ///   - cifrados: si se escribe el cifrado americano de cada acorde encima del soprano.
    ///   - analisis: si se escriben el cifrado romano y la función debajo del bajo.
    ///   - notacion: la de los cifrados y la tonalidad.
    public func guido(
        duracion: Duracion = .negra, compas: Compas = .compasillo,
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Coro",
        cifrados: Bool = false, analisis: Bool = false,
        notacion: Notacion = .espanolCompacto
    ) -> String {
        Exportacion.documento(
            EscritorGUIDO.self, de: self, duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

extension AnalisisArmonico {
    /// La progresión como partitura GMN en dos pentagramas, como `lilyPond(duracion:compas:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// los acordes en posición cerrada en clave de sol, con su cifrado americano encima, y el bajo en clave de fa,
    /// con el cifrado romano y la función debajo.
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let gmn = analisis.guido(titulo: "Progresión")
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - cifrados: si se escriben los cifrados americanos.
    ///   - analisis: si se escriben los cifrados romanos y las funciones.
    ///   - notacion: la de los cifrados americanos y la tonalidad.
    public func guido(
        duracion: Duracion = .blanca, compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolCompacto
    ) -> String {
        guido(
            duraciones: Array(repeating: duracion, count: acordes.count), compas: compas, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }

    /// Lo mismo, con lo que dura cada acorde; el último se alarga hasta la barra.
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func guido(
        duraciones: [Duracion], compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolCompacto
    ) -> String {
        Exportacion.documento(
            EscritorGUIDO.self, de: self, duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo,
            parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }
}

// MARK: - Escritor GUIDO

/// Reúne varias voces, cada una en una secuencia `[ … ]` con su `\staff`, y escribe el segmento `{ … }` del fichero
/// `.gmn`.
package struct EscritorGUIDO: EscritorDePartitura {
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
        // Sin voces, un pentagrama con un compás de silencio.
        let vacia =
            cabecera(pentagrama: 1, plicaArriba: nil, primera: true) + "\n    _"
            + EscritorGUIDO.duracion(compas.duracion) + "\n    \\endBar\n  ]"
        let secuencias = lineas.isEmpty ? [vacia] : lineas.indices.map(secuencia)
        return "{\n" + secuencias.joined(separator: ",\n") + "\n}\n"
    }

    /// Lo que va al principio de una secuencia: pentagrama, plicas, clave, armadura, compás y, en la primera, el
    /// título, el nombre de la parte, la llave de los dos pentagramas y el tempo.
    private func cabecera(pentagrama: Int, plicaArriba: Bool?, primera: Bool) -> String {
        let clave = claves.indices.contains(pentagrama - 1) ? claves[pentagrama - 1] : .sol
        var inicio: [String] = []
        if primera, let titulo { inicio.append("\\title<\(EscritorGUIDO.cadena(titulo))>") }
        if primera && claves.count > 1 { inicio.append("\\accol<id=1, range=\"1-\(claves.count)\">") }
        inicio.append("\\staff<\(pentagrama)>")
        if primera { inicio.append("\\instr<\(EscritorGUIDO.cadena(parte))>") }
        if let arriba = plicaArriba { inicio.append(arriba ? "\\stemsUp" : "\\stemsDown") }
        inicio.append("\\clef<\"\(EscritorGUIDO.clave(clave))\">")
        inicio.append("\\key<\(tonalidad?.armadura ?? 0)>")
        inicio.append(EscritorGUIDO.compas(compas))
        if primera, let tempo { inicio.append(EscritorGUIDO.indicacion(tempo)) }
        return "  [ " + inicio.joined(separator: " ")
    }

    /// Una voz como secuencia `[ … ]`, con un compás por renglón.
    private func secuencia(_ l: Int) -> String {
        let linea = lineas[l]
        var gmn = cabecera(pentagrama: linea.pentagrama, plicaArriba: linea.plicaArriba, primera: l == 0) + "\n"
        let compases = Exportacion.compases(de: linea.voz)
        // El rótulo va con la primera nota de la voz del análisis o, si no hay, de la primera de su pentagrama.
        let conRotulo = rotulo.flatMap { r in
            r.pentagrama == linea.pentagrama && lineaDelRotulo(r.pentagrama) == l ? r.texto : nil
        }
        // Las ligaduras se numeran para que una cadena (a~b~c) no cierre la que acaba de abrir: la que empieza en
        // un evento se cierra después del siguiente.
        var abierta: Int?
        var siguiente = 1
        for (c, eventos) in compases.enumerated() {
            var piezas: [String] = []
            var abiertos = Exportacion.irregulares(eventos.map(\.evento))[...]
            var dentro: (fin: Int, piezas: [String], cabecera: String)?
            for (i, (evento, inicio, nuevo)) in eventos.enumerated() {
                if dentro == nil, let grupo = abiertos.first, grupo.rango.lowerBound == i {
                    abiertos.removeFirst()
                    dentro = (grupo.rango.upperBound, [], "\\tuplet<\"-\(grupo.reales)-\">(")
                }
                var texto = EscritorGUIDO.evento(evento)
                var debajo = (nuevo ? linea.letras[inicio] ?? [] : []).filter { !$0.isEmpty }
                if c == 0 && i == 0, let conRotulo { debajo.insert(conRotulo, at: 0) }
                // De arriba abajo, cada línea un poco más baja que la anterior (en medios espacios).
                for (n, letra) in debajo.enumerated().reversed() {
                    texto = "\\text<\(EscritorGUIDO.cadena(letra)), dy=-\(8 + 3 * n)hs>(\(texto))"
                }
                if nuevo, let cifrado = linea.cifrados[inicio] {
                    texto = "\\harmony<\(EscritorGUIDO.cadena(cifrado))>(\(texto))"
                }
                if evento.ligada {
                    texto = "\\tieBegin:\(siguiente) " + texto
                }
                if let numero = abierta {
                    texto += " \\tieEnd:\(numero)"
                    abierta = nil
                }
                if evento.ligada {
                    abierta = siguiente
                    siguiente = siguiente % 2 + 1
                }
                if var grupo = dentro {
                    grupo.piezas.append(texto)
                    dentro = grupo
                    if grupo.fin == i {
                        piezas.append(grupo.cabecera + " " + grupo.piezas.joined(separator: " ") + " )")
                        dentro = nil
                    }
                } else {
                    piezas.append(texto)
                }
            }
            gmn += "    " + piezas.joined(separator: " ") + (c == compases.count - 1 ? "" : " \\bar") + "\n"
        }
        if compases.isEmpty { gmn += "    _" + EscritorGUIDO.duracion(compas.duracion) + "\n" }
        return gmn + "    \\endBar\n  ]"
    }

    /// La línea que lleva el rótulo de un pentagrama: la que tiene el análisis o, si no, la primera.
    private func lineaDelRotulo(_ pentagrama: Int) -> Int? {
        let suyas = lineas.indices.filter { lineas[$0].pentagrama == pentagrama }
        return suyas.first { !lineas[$0].letras.isEmpty } ?? suyas.first
    }

    // MARK: Eventos

    /// Una nota (`f#1/4`), un acorde (`{c1/2, e1/2, g1/2}`) o un silencio (`_/8`).
    private static func evento(_ evento: Evento) -> String {
        let figura = duracion(evento.duracion)
        switch evento.alturas.count {
        case 0: return "_" + figura
        case 1: return altura(evento.alturas[0]) + figura
        default: return "{" + evento.alturas.map { altura($0) + figura }.joined(separator: ", ") + "}"
        }
    }

    /// La altura absoluta: Do4 → `c1`, Fa♯3 → `f#0`, Si♭1 → `b&-2`, Re𝄪5 → `d##2`.
    package static func altura(_ altura: Altura) -> String {
        let (natural, semitonos, octava) = Exportacion.sinTriples(altura)
        let nombre = ["c", "d", "e", "f", "g", "a", "b"][natural.rawValue]
        let alteracion = String(repeating: semitonos >= 0 ? "#" : "&", count: abs(semitonos))
        return nombre + alteracion + String(octava - 3)
    }

    /// Una duración como fracción de redonda: `/4` (negra), `*3/8` (negra con puntillo), `/12` (corchea de
    /// tresillo), `*2` (cuadrada).
    package static func duracion(_ duracion: Duracion) -> String {
        switch (duracion.numerador, duracion.denominador) {
        case (1, let d): return "/\(d)"
        case (let n, 1): return "*\(n)"
        case (let n, let d): return "*\(n)/\(d)"
        }
    }

    // MARK: Lo del principio

    /// La clave de GMN: la letra y la línea en que va, con la octava si la lleva.
    package static func clave(_ clave: Clave) -> String {
        switch clave {
        case .sol: return "g2"
        case .solOctavaBaja: return "g2-8"
        case .solOctavaAlta: return "g2+8"
        case .fa: return "f4"
        case .faEnTercera: return "f3"
        case .doEnPrimera: return "c1"
        case .doEnSegunda: return "c2"
        case .doEnTercera: return "c3"
        case .doEnCuarta: return "c4"
        }
    }

    /// `\meter<"3/4", autoBarlines="off">`, y `\meter<"2+2+3/8", …>` en uno de amalgama irregular.
    private static func compas(_ compas: Compas) -> String {
        let pulsos = EscritorMEI.pulsos(compas)
        return "\\meter<\"\(pulsos)/\(compas.denominador)\", autoBarlines=\"off\">"
    }

    /// `\tempo<"[1/4] = 60", "1/4=60">`, con la figura del pulso entre corchetes, que Guido dibuja como nota; en
    /// negras si el pulso no tiene figura.
    private static func indicacion(_ tempo: Tempo) -> String {
        let (unidad, pulsos) =
            tempo.unidad.figuraYPuntillos != nil
            ? (tempo.unidad, tempo.pulsosPorMinuto) : (Duracion.negra, tempo.negrasPorMinuto)
        let fraccion = "\(unidad.numerador)/\(unidad.denominador)"
        let valor = Int(pulsos.rounded())
        return "\\tempo<\"[\(fraccion)] = \(valor)\", \"\(fraccion)=\(valor)\">"
    }

    /// Un texto entre comillas, con `"` y `\` escapadas.
    package static func cadena(_ texto: String) -> String {
        "\"" + String(texto.flatMap { $0 == "\\" || $0 == "\"" ? "\\\($0)" : "\($0)" }) + "\""
    }
}
