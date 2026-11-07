import Elementos
import PartituraArmonia
import Teoria

// Exportación a GUIDO Music Notation (GMN), el formato de texto de Guido Engine (guido.grame.fr), la biblioteca que
// graba partituras en SVG: `guido2svg coral.gmn > coral.svg`. Es la entrada que necesita el motor para dibujar las
// partituras con él en vez de con `PartituraArmonia`.
//
// Se escribe la grafía de cada voz (`Voz.grafia`), con la ortografía tal cual y en altura absoluta: en GMN la octava
// 1 es la del Do central (Do4 → `c1`, Fa♯3 → `f#0`, Si♭1 → `b&-2`) y las alteraciones son `#` y `&`. Cada duración se
// escribe como fracción de redonda (`/4`, `*3/8`, `/12`), así que los puntillos y los grupos irregulares los decide
// Guido a partir de lo que dura cada nota; los grupos irregulares se marcan además con `\tuplet`. Las barras se
// escriben a mano (`autoBarlines="off"`) para que la anacrusa quede bien. Los cifrados van encima de la nota en que
// empieza cada acorde, con `\harmony`, y el análisis, debajo, con `\text`. Los cuartos de tono se escriben con la
// nota temperada.

// MARK: - Escritor GUIDO

/// Reúne varias voces, cada una en una secuencia `[ … ]` con su `\staff`, y escribe el segmento `{ … }` del fichero
/// `.gmn`.
package struct EscritorGUIDO: EscritorDeTexto {
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
        let clave = self.clave(delPentagrama: pentagrama)
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
        // Las ligaduras se numeran para que una cadena (a~b~c) no cierre la que acaba de abrir: la que empieza en
        // un evento se cierra después del siguiente.
        var abierta: Int?
        var siguiente = 1
        for (c, eventos) in compases.enumerated() {
            var piezas: [String] = []
            for (i, (evento, inicio, nuevo)) in eventos.enumerated() {
                var texto = EscritorGUIDO.evento(evento)
                texto = EscritorGUIDO.conExpresion(texto, evento)
                let debajo = self.debajo(enLaLinea: l, compas: c, evento: i, inicio: inicio, nuevo: nuevo)
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
                piezas.append(texto)
            }
            piezas = Exportacion.envolviendo(
                piezas, grupos: Exportacion.irregulares(eventos.map(\.evento)),
                abrir: { reales, _ in "\\tuplet<\"-\(reales)-\">(" }, cerrar: ")")
            gmn += "    " + piezas.joined(separator: " ") + (c == compases.count - 1 ? "" : " \\bar") + "\n"
        }
        if compases.isEmpty { gmn += "    _" + EscritorGUIDO.duracion(compas.duracion) + "\n" }
        return gmn + "    \\endBar\n  ]"
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

    /// Un evento con sus articulaciones, cada una una etiqueta que lo envuelve (`\stacc(c1/4)`), y su dinámica
    /// delante (`\intens<"mf"> c1/4`).
    package static func conExpresion(_ texto: String, _ evento: Evento) -> String {
        var texto = texto
        for articulacion in evento.articulaciones {
            let etiqueta: String
            switch articulacion {
            case .staccato: etiqueta = "\\stacc"
            case .staccatissimo: etiqueta = "\\stacc<type=\"heavy\">"
            case .tenuto: etiqueta = "\\ten"
            case .acento: etiqueta = "\\accent"
            case .marcato: etiqueta = "\\marcato"
            case .calderon: etiqueta = "\\fermata"
            case .trino: etiqueta = "\\trill"
            case .mordenteSuperior: etiqueta = "\\mord"
            case .mordenteInferior: etiqueta = "\\mord<inverted=\"true\">"
            case .grupeto: etiqueta = "\\turn"
            case .grupetoInvertido: etiqueta = "\\turn<inverted=\"true\">"
            }
            texto = etiqueta + "(" + texto + ")"
        }
        return (evento.dinamica.map { "\\intens<\"\($0.rawValue)\"> " } ?? "") + texto
    }

    /// La altura absoluta: Do4 → `c1`, Fa♯3 → `f#0`, Si♭1 → `b&-2`, Re𝄪5 → `d##2`.
    package static func altura(_ altura: Altura) -> String {
        let (natural, semitonos, octava) = Exportacion.sinTriples(altura)
        let nombre = natural.letra.lowercased()
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
}
