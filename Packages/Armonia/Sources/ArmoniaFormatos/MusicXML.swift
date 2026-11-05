import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// Exportación a MusicXML 4.0 (score-partwise), para abrir melodías y corales en MuseScore,
// Finale, Sibelius, Dorico o cualquier editor de partituras.
//
// Se escribe la grafía de cada voz (`Voz.grafia`): las notas ya divididas y ligadas según el
// compás. La ortografía se conserva tal cual (un Sol♯ es G con alter 1, nunca A♭) y la armadura
// es la de la tonalidad: en MusicXML, `<fifths>` es exactamente `Tonalidad.armadura`.
// MusicXML solo admite las octavas de 0 a 9: una altura fuera de ellas da un documento que los
// editores pueden rechazar.
//
// `Exportacion` (Exportacion.swift) reúne lo que comparten MusicXML, MEI (MEI.swift) y MIDI
// (ArchivoMIDI.swift): la tonalidad estimada, las divisiones del tiempo, las figuras, las voces de un
// coral y de una progresión y lo que se anota en ellos.

// MARK: - Escritor MusicXML

/// Reúne varias voces en una parte (con uno o más pentagramas) y escribe el documento.
package struct EscritorMusicXML: EscritorDePartitura {
    package struct Linea {
        package let voz: Voz
        package let pentagrama: Int
        package let numero: Int
        package let plica: String?
        /// Lo que se escribe con la nota que empieza en cada punto de la voz (contado desde su
        /// comienzo): un cifrado encima y textos debajo.
        package let anotaciones: [Duracion: Anotacion]
        /// En una línea de un pentagrama de tablatura, sus cuerdas y lo que se pulsa en la nota que empieza en cada
        /// punto de la voz; en las demás, `nil`.
        package var tablatura: (cuerdas: Int, pulsaciones: [Duracion: [Tablatura.Pulsacion]])? = nil
    }

    /// Un pentagrama de tablatura, después de los de la partitura: sus cuerdas, su afinación y su capo.
    package struct PentagramaDeTablatura {
        package let cuerdas: Int
        package let afinacion: [Altura]?
        package let capo: Int?
    }

    package struct Anotacion {
        /// El elemento `<harmony>` del cifrado, si lo hay.
        package var armonia: String?
        /// Una línea de texto debajo de la nota por elemento (cifrado romano, función…).
        package var letras: [String] = []
    }

    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
    package var lineas: [Linea] = []
    package var tablaturas: [PentagramaDeTablatura] = []

    /// Los pentagramas de la parte: los de las claves y, debajo, los de tablatura.
    private var numeroDePentagramas: Int { claves.count + tablaturas.count }

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

    /// Un texto debajo del primer pentagrama de la línea, al principio (la tonalidad del análisis).
    package var rotulo: (texto: String, pentagrama: Int)?

    package mutating func anadir(
        _ voz: Voz, pentagrama: Int, numero: Int, plica: String?,
        anotaciones: [Duracion: Anotacion] = [:]
    ) {
        lineas.append(Linea(voz: voz, pentagrama: pentagrama, numero: numero, plica: plica, anotaciones: anotaciones))
    }

    /// La voz con su número de orden, con los cifrados como `<harmony>` encima y el análisis como letra debajo.
    package mutating func anadir(
        _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
        cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion
    ) {
        var anotaciones = cifrados.mapValues {
            Anotacion(armonia: EscritorMusicXML.armonia($0, notacion, pentagrama: 1))
        }
        for (punto, analizado) in analisis {
            anotaciones[punto, default: Anotacion()].letras = Exportacion.letras(analizado)
        }
        anadir(
            voz, pentagrama: pentagrama, numero: lineas.count + 1, plica: plicaArriba.map { $0 ? "up" : "down" },
            anotaciones: anotaciones)
    }

    /// La voz otra vez, en un pentagrama de tablatura debajo de los demás, con la cuerda y el traste de cada nota
    /// (`<technical>`), y el pentagrama con sus líneas, su afinación y su capo (`<staff-details>`).
    package mutating func anadirTablatura(
        _ voz: Voz, pulsaciones: [Duracion: [Tablatura.Pulsacion]], cuerdas: Int, afinacion: [Altura]?, capo: Int?
    ) {
        tablaturas.append(PentagramaDeTablatura(cuerdas: cuerdas, afinacion: afinacion, capo: capo))
        var linea = Linea(
            voz: voz, pentagrama: claves.count + tablaturas.count, numero: lineas.count + 1, plica: nil,
            anotaciones: [:])
        linea.tablatura = (cuerdas, pulsaciones)
        lineas.append(linea)
    }

    package var documento: String {
        let grafias = lineas.map(\.voz.grafia)
        let barras = lineas.map(\.voz.barrasDeAgrupacion)
        let divisiones = Exportacion.divisiones(grafias.flatMap { $0.flatMap { $0.map(\.duracion) } })
        let numeroDeCompases = grafias.map(\.count).max() ?? 0

        var xml = """
            <?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 4.0 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">
            <score-partwise version="4.0">

            """
        if let titulo {
            xml += "  <work>\n    <work-title>\(EscrituraXML.escapar(titulo))</work-title>\n  </work>\n"
        }
        xml += """
              <identification>
                <encoding>
                  <software>Armonia</software>
                </encoding>
              </identification>
              <part-list>
                <score-part id="P1">
                  <part-name>\(EscrituraXML.escapar(parte))</part-name>
                </score-part>
              </part-list>
              <part id="P1">

            """
        // Una ligadura que viene del compás anterior, por línea.
        var ligadaDesde: [[Altura]] = Array(repeating: [], count: lineas.count)
        // Dónde va cada línea, desde su comienzo, para colocar las anotaciones.
        var posiciones = Array(repeating: Duracion.cero, count: lineas.count)
        // Lo que se pulsa en el evento en curso de cada línea de tablatura, también en sus notas ligadas.
        var pulsadas: [[Tablatura.Pulsacion]] = Array(repeating: [], count: lineas.count)
        for c in 0..<max(numeroDeCompases, 1) {
            let esAnacrusa = c == 0 && anacrusa > .cero
            let numero = anacrusa > .cero ? c : c + 1
            xml += "    <measure number=\"\(numero)\"\(esAnacrusa ? " implicit=\"yes\"" : "")>\n"
            if c == 0 { xml += atributos(divisiones) + metronomo + rotuloInicial }
            for (l, linea) in lineas.enumerated() where c < grafias[l].count {
                let eventos = grafias[l][c]
                if l > 0, c < grafias[l - 1].count {
                    let anterior = grafias[l - 1][c].map(\.duracion).total
                    if !anterior.esCero {
                        xml += "      <backup><duration>\(ticks(anterior, divisiones))</duration></backup>\n"
                    }
                }
                var haciaBarra: [Int: String] = [:]
                for grupo in barras[l][c] {
                    for (k, i) in grupo.enumerated() {
                        haciaBarra[i] = k == 0 ? "begin" : (k == grupo.count - 1 ? "end" : "continue")
                    }
                }
                let compasEntero =
                    eventos.count == 1 && eventos[0].esSilencio && !esAnacrusa
                    && eventos[0].duracion == compas.duracion
                var irregular = Duracion.cero // lo acumulado del grupo irregular abierto
                for (i, evento) in eventos.enumerated() {
                    let figura = EscritorMusicXML.figura(de: evento.duracion)
                    var grupo: [String] = []
                    if figura.irregular != nil {
                        if irregular.esCero { grupo.append("start") }
                        irregular = irregular + evento.duracion
                        let cierra = irregular.denominador & (irregular.denominador - 1) == 0 || i == eventos.count - 1
                        if cierra {
                            grupo.append("stop")
                            irregular = .cero
                        }
                    }
                    // Las anotaciones van con la primera nota escrita de cada evento, no con sus ligadas. La
                    // dinámica y las articulaciones de una nota partida en varias ligadas ya van solo en la primera.
                    let nuevo = ligadaDesde[l].isEmpty || evento.alturas != ligadaDesde[l]
                    if let tablatura = linea.tablatura, nuevo {
                        pulsadas[l] = tablatura.pulsaciones[posiciones[l]] ?? []
                    }
                    var nota = NotaEscrita(
                        evento: evento, figura: figura, divisiones: divisiones, linea: linea,
                        variosPentagramas: numeroDePentagramas > 1,
                        medidaCompleta: compasEntero, barra: haciaBarra[i], grupo: grupo,
                        ligadaDesde: ligadaDesde[l])
                    if let tablatura = linea.tablatura {
                        nota.cuerdasYTrastes = pulsadas[l].map { (tablatura.cuerdas - $0.cuerda, $0.traste) }
                    }
                    let anotacion = nuevo ? linea.anotaciones[posiciones[l]] : nil
                    if let armonia = anotacion?.armonia { xml += armonia }
                    if let dinamica = evento.dinamica, linea.tablatura == nil {
                        xml += EscritorMusicXML.dinamica(
                            dinamica, voz: linea.numero, pentagrama: numeroDePentagramas > 1 ? linea.pentagrama : nil)
                    }
                    xml += nota.xml(letras: anotacion?.letras ?? [])
                    ligadaDesde[l] = evento.ligada ? evento.alturas : []
                    posiciones[l] = posiciones[l] + evento.duracion
                }
            }
            if c == numeroDeCompases - 1 {
                xml +=
                    "      <barline location=\"right\">\n        <bar-style>light-heavy</bar-style>\n      </barline>\n"
            }
            xml += "    </measure>\n"
        }
        xml += "  </part>\n</score-partwise>\n"
        return xml
    }

    private func atributos(_ divisiones: Int) -> String {
        var xml = "      <attributes>\n        <divisions>\(divisiones)</divisions>\n"
        let fifths = tonalidad?.armadura ?? 0
        xml += "        <key>\n          <fifths>\(fifths)</fifths>\n"
        if let tonalidad { xml += "          <mode>\(tonalidad.modo == .mayor ? "major" : "minor")</mode>\n" }
        xml += "        </key>\n"
        let simbolo = compas == .compasillo ? " symbol=\"common\"" : (compas == .partido ? " symbol=\"cut\"" : "")
        let beats =
            compas.agrupacion.count > 1 && Set(compas.agrupacion).count > 1 && compas.tipo != .compuesto
            ? compas.agrupacion.map(String.init).joined(separator: "+") : "\(compas.numerador)"
        xml +=
            "        <time\(simbolo)>\n          <beats>\(beats)</beats>\n          <beat-type>\(compas.denominador)</beat-type>\n        </time>\n"
        let varios = numeroDePentagramas > 1
        if varios { xml += "        <staves>\(numeroDePentagramas)</staves>\n" }
        for (i, clave) in claves.enumerated() {
            let (signo, linea, cambio) = EscritorMusicXML.signo(de: clave)
            let numero = varios ? " number=\"\(i + 1)\"" : ""
            xml += "        <clef\(numero)>\n          <sign>\(signo)</sign>\n          <line>\(linea)</line>\n"
            if cambio != 0 { xml += "          <clef-octave-change>\(cambio)</clef-octave-change>\n" }
            xml += "        </clef>\n"
        }
        for (i, tablatura) in tablaturas.enumerated() {
            let numero = " number=\"\(claves.count + i + 1)\""
            xml += "        <clef\(numero)>\n          <sign>TAB</sign>\n          <line>5</line>\n        </clef>\n"
            xml += "        <staff-details\(numero)>\n"
            xml += "          <staff-lines>\(tablatura.cuerdas)</staff-lines>\n"
            // La línea 1 es la de abajo: la cuerda 0, la más grave del mástil.
            for (linea, cuerda) in (tablatura.afinacion ?? []).enumerated() where linea < tablatura.cuerdas {
                xml += "          <staff-tuning line=\"\(linea + 1)\">"
                xml += "<tuning-step>\(EscritorMusicXML.paso(cuerda.nota.natural))</tuning-step>"
                if cuerda.nota.alteracion.semitonos != 0 {
                    xml += "<tuning-alter>\(cuerda.nota.alteracion.semitonos)</tuning-alter>"
                }
                xml += "<tuning-octave>\(cuerda.octava)</tuning-octave></staff-tuning>\n"
            }
            if let capo = tablatura.capo, capo > 0 { xml += "          <capo>\(capo)</capo>\n" }
            xml += "        </staff-details>\n"
        }
        return xml + "      </attributes>\n"
    }

    private var rotuloInicial: String {
        guard let rotulo else { return "" }
        return """
                  <direction placement="below">
                    <direction-type>
                      <words>\(EscrituraXML.escapar(rotulo.texto))</words>
                    </direction-type>
                    <staff>\(rotulo.pentagrama)</staff>
                  </direction>

            """
    }

    private var metronomo: String {
        guard let tempo else { return "" }
        let porMinuto = Exportacion.formatear(tempo.pulsosPorMinuto)
        var unidad = ""
        if let escrita = tempo.unidad.figuraYPuntillos {
            let (figura, puntillos) = (escrita.figura, escrita.puntillos)
            unidad =
                "            <beat-unit>\(EscritorMusicXML.tipo(figura))</beat-unit>\n"
                + String(repeating: "            <beat-unit-dot/>\n", count: puntillos)
        }
        guard !unidad.isEmpty else {
            return "      <sound tempo=\"\(Exportacion.formatear(tempo.negrasPorMinuto))\"/>\n"
        }
        return """
                  <direction placement="above">
                    <direction-type>
                      <metronome>
            \(unidad)            <per-minute>\(porMinuto)</per-minute>
                      </metronome>
                    </direction-type>
                    <sound tempo="\(Exportacion.formatear(tempo.negrasPorMinuto))"/>
                  </direction>

            """
    }

    // MARK: Nota

    /// Un evento escrito como uno o más elementos `<note>` (uno por altura en un acorde).
    package struct NotaEscrita {
        package let evento: Evento
        package let figura: (tipo: String?, puntillos: Int, irregular: (reales: Int, normales: Int)?)
        package let divisiones: Int
        package let linea: Linea
        package let variosPentagramas: Bool
        package let medidaCompleta: Bool
        package let barra: String?
        package let grupo: [String]
        package let ligadaDesde: [Altura]
        /// En un pentagrama de tablatura, la cuerda (la 1 es la más aguda, como en MusicXML) y el traste de cada
        /// nota del evento, en el orden de sus alturas.
        package var cuerdasYTrastes: [(cuerda: Int, traste: Int)] = []

        package func xml(letras: [String]) -> String {
            let duracion = ticks(evento.duracion, divisiones)
            let articulaciones = evento.articulaciones
            guard !evento.esSilencio else {
                var xml = "      <note>\n"
                xml += medidaCompleta ? "        <rest measure=\"yes\"/>\n" : "        <rest/>\n"
                xml += "        <duration>\(duracion)</duration>\n"
                xml += comun(incluirFigura: !medidaCompleta, plica: false, barra: nil)
                xml += notaciones(ligadura: [], articulaciones: articulaciones)
                return xml + "      </note>\n"
            }
            var xml = ""
            for (i, altura) in evento.alturas.enumerated() {
                xml += "      <note>\n"
                if i > 0 { xml += "        <chord/>\n" }
                let nota = altura.nota
                xml += "        <pitch>\n          <step>\(EscritorMusicXML.paso(nota.natural))</step>\n"
                // Un microtono va en `alter` con decimales (Mi𝄳 = Mi con −0.5) y con su signo en `<accidental>`.
                let desvio = evento.notas[i].desvio
                if nota.alteracion.semitonos != 0 || desvio != 0 {
                    xml += "          <alter>\(NotaEscrita.alter(nota.alteracion.semitonos, desvio))</alter>\n"
                }
                xml += "          <octave>\(altura.octava)</octave>\n        </pitch>\n"
                xml += "        <duration>\(duracion)</duration>\n"
                var ligadura: [String] = []
                if ligadaDesde.contains(altura) { ligadura.append("stop") }
                if evento.ligada { ligadura.append("start") }
                for tipo in ligadura { xml += "        <tie type=\"\(tipo)\"/>\n" }
                let signo = evento.notas[i].signo()
                xml += comun(incluirFigura: true, plica: i == 0, barra: i == 0 ? barra : nil, signo: signo)
                xml += notaciones(
                    ligadura: ligadura, grupo: i == 0 ? grupo : [], articulaciones: i == 0 ? articulaciones : [],
                    tecnica: cuerdasYTrastes.indices.contains(i) ? cuerdasYTrastes[i] : nil)
                if i == 0 {
                    for (k, letra) in letras.enumerated() where !letra.isEmpty {
                        xml += "        <lyric number=\"\(k + 1)\" placement=\"below\">\n"
                        xml +=
                            "          <syllabic>single</syllabic>\n          <text>\(EscrituraXML.escapar(letra))</text>\n        </lyric>\n"
                    }
                }
                xml += "      </note>\n"
            }
            return xml
        }

        private func comun(incluirFigura: Bool, plica: Bool, barra: String?, signo: SignoMicrotonal? = nil) -> String {
            var xml = "        <voice>\(linea.numero)</voice>\n"
            if incluirFigura, let tipo = figura.tipo {
                xml += "        <type>\(tipo)</type>\n"
                xml += String(repeating: "        <dot/>\n", count: figura.puntillos)
            }
            if let signo {
                let (valor, smufl) = signo.musicXML
                xml += "        <accidental" + (smufl.map { " smufl=\"\($0)\"" } ?? "") + ">\(valor)</accidental>\n"
            }
            if incluirFigura, let (reales, normales) = figura.irregular {
                xml += "        <time-modification>\n          <actual-notes>\(reales)</actual-notes>\n"
                xml += "          <normal-notes>\(normales)</normal-notes>\n        </time-modification>\n"
            }
            if let direccion = linea.plica, !evento.esSilencio { xml += "        <stem>\(direccion)</stem>\n" }
            if variosPentagramas { xml += "        <staff>\(linea.pentagrama)</staff>\n" }
            if let barra { xml += "        <beam number=\"1\">\(barra)</beam>\n" }
            return xml
        }

        /// La alteración en semitonos con el microtono en decimales: −1 y 50 cents → «-0.5».
        package static func alter(_ semitonos: Int, _ desvio: Double) -> String {
            let valor = (Double(semitonos) * 10_000 + desvio * 100).rounded() / 10_000
            return valor == valor.rounded() ? String(Int(valor)) : String(valor)
        }

        private func notaciones(
            ligadura: [String], grupo: [String] = [], articulaciones: [Articulacion] = [],
            tecnica: (cuerda: Int, traste: Int)? = nil
        ) -> String {
            guard !ligadura.isEmpty || !grupo.isEmpty || !articulaciones.isEmpty || tecnica != nil else { return "" }
            var xml = "        <notations>\n"
            for tipo in ligadura { xml += "          <tied type=\"\(tipo)\"/>\n" }
            for tipo in grupo {
                xml +=
                    tipo == "start"
                    ? "          <tuplet type=\"start\" bracket=\"yes\"/>\n"
                    : "          <tuplet type=\"stop\"/>\n"
            }
            let elementos = articulaciones.compactMap(EscritorMusicXML.articulacion)
            if !elementos.isEmpty {
                xml += "          <articulations>\n"
                for elemento in elementos { xml += "            <\(elemento)/>\n" }
                xml += "          </articulations>\n"
            }
            let ornamentos = articulaciones.compactMap(EscritorMusicXML.ornamento)
            if !ornamentos.isEmpty {
                xml += "          <ornaments>\n"
                for ornamento in ornamentos { xml += "            <\(ornamento)/>\n" }
                xml += "          </ornaments>\n"
            }
            if articulaciones.contains(.calderon) { xml += "          <fermata type=\"upright\"/>\n" }
            if let tecnica {
                xml += "          <technical>\n            <string>\(tecnica.cuerda)</string>\n"
                xml += "            <fret>\(tecnica.traste)</fret>\n          </technical>\n"
            }
            return xml + "        </notations>\n"
        }
    }

    // MARK: Expresión

    /// El elemento de `<articulations>` de una articulación; `nil` para el calderón, que va aparte (`<fermata>`).
    package static func articulacion(_ articulacion: Articulacion) -> String? {
        switch articulacion {
        case .staccato: return "staccato"
        case .staccatissimo: return "staccatissimo"
        case .tenuto: return "tenuto"
        case .acento: return "accent"
        case .marcato: return "strong-accent"
        case .calderon, .trino, .mordenteSuperior, .mordenteInferior, .grupeto, .grupetoInvertido: return nil
        }
    }

    /// El elemento de `<ornaments>` de un ornamento; `nil` para lo demás.
    package static func ornamento(_ articulacion: Articulacion) -> String? {
        switch articulacion {
        case .trino: return "trill-mark"
        case .mordenteSuperior: return "inverted-mordent"
        case .mordenteInferior: return "mordent"
        case .grupeto: return "turn"
        case .grupetoInvertido: return "inverted-turn"
        default: return nil
        }
    }

    /// Una dinámica como `<direction>`, debajo del pentagrama, delante de su nota.
    package static func dinamica(_ dinamica: Dinamica, voz: Int, pentagrama: Int?) -> String {
        var xml = "      <direction placement=\"below\">\n        <direction-type>\n"
        xml += "          <dynamics><\(dinamica.rawValue)/></dynamics>\n        </direction-type>\n"
        xml += "        <voice>\(voz)</voice>\n"
        if let pentagrama { xml += "        <staff>\(pentagrama)</staff>\n" }
        return xml + "      </direction>\n"
    }

    // MARK: Armonía

    /// Las especies de acorde de MusicXML (`<kind>`), con sus intervalos como (número simple,
    /// semitonos dentro de la octava).
    package static let especies: [(nombre: String, intervalos: [(Int, Int)])] = [
        ("major", [(3, 4), (5, 7)]), ("minor", [(3, 3), (5, 7)]),
        ("augmented", [(3, 4), (5, 8)]), ("diminished", [(3, 3), (5, 6)]),
        ("dominant", [(3, 4), (5, 7), (7, 10)]), ("major-seventh", [(3, 4), (5, 7), (7, 11)]),
        ("minor-seventh", [(3, 3), (5, 7), (7, 10)]), ("diminished-seventh", [(3, 3), (5, 6), (7, 9)]),
        ("augmented-seventh", [(3, 4), (5, 8), (7, 10)]), ("half-diminished", [(3, 3), (5, 6), (7, 10)]),
        ("major-minor", [(3, 3), (5, 7), (7, 11)]),
        ("major-sixth", [(3, 4), (5, 7), (6, 9)]), ("minor-sixth", [(3, 3), (5, 7), (6, 9)]),
        ("dominant-ninth", [(3, 4), (5, 7), (7, 10), (2, 2)]), ("major-ninth", [(3, 4), (5, 7), (7, 11), (2, 2)]),
        ("minor-ninth", [(3, 3), (5, 7), (7, 10), (2, 2)]),
        ("dominant-11th", [(3, 4), (5, 7), (7, 10), (2, 2), (4, 5)]),
        ("major-11th", [(3, 4), (5, 7), (7, 11), (2, 2), (4, 5)]),
        ("minor-11th", [(3, 3), (5, 7), (7, 10), (2, 2), (4, 5)]),
        ("dominant-13th", [(3, 4), (5, 7), (7, 10), (2, 2), (4, 5), (6, 9)]),
        ("major-13th", [(3, 4), (5, 7), (7, 11), (2, 2), (4, 5), (6, 9)]),
        ("minor-13th", [(3, 3), (5, 7), (7, 10), (2, 2), (4, 5), (6, 9)]),
        ("suspended-second", [(2, 2), (5, 7)]), ("suspended-fourth", [(4, 5), (5, 7)]),
        ("power", [(5, 7)]),
        ("Italian", [(3, 4), (6, 10)]), ("French", [(3, 4), (4, 6), (6, 10)]),
        ("German", [(3, 4), (5, 7), (6, 10)]),
    ]

    /// El cifrado de un acorde como elemento `<harmony>`: fundamental, especie (con el texto del
    /// cifrado en `notacion`), bajo y los grados que se añaden o se quitan respecto a la especie.
    package static func armonia(_ acorde: Acorde, _ notacion: Notacion, pentagrama: Int?) -> String {
        let intervalos = acorde.tipo.intervalos.filter { $0.numero != 1 }
        let clave = { (i: Intervalo) in (i.numeroSimple, modulo(i.semitonos, 12)) }
        // La especie que más intervalos comparte con el acorde, penalizando los que le sobran.
        let puntuar = { (especie: [(Int, Int)]) -> Int in
            let comunes = especie.filter { e in intervalos.contains { clave($0) == e } }.count
            return comunes * 2 - (especie.count - comunes) * 3
        }
        var mejor = (nombre: "other", intervalos: [(Int, Int)]())
        var puntos = 0
        for especie in especies where puntuar(especie.intervalos) > puntos {
            mejor = especie
            puntos = puntuar(especie.intervalos)
        }
        var xml = "      <harmony print-frame=\"no\">\n        <root>\n"
        xml += "          <root-step>\(paso(acorde.fundamental.natural))</root-step>\n"
        if acorde.fundamental.alteracion.semitonos != 0 {
            xml += "          <root-alter>\(acorde.fundamental.alteracion.semitonos)</root-alter>\n"
        }
        xml += "        </root>\n"
        xml +=
            "        <kind text=\"\(EscrituraXML.escapar(acorde.tipo.cifrado(en: notacion)))\">\(mejor.nombre)</kind>\n"
        if acorde.bajo != acorde.fundamental {
            xml += "        <bass>\n          <bass-step>\(paso(acorde.bajo.natural))</bass-step>\n"
            if acorde.bajo.alteracion.semitonos != 0 {
                xml += "          <bass-alter>\(acorde.bajo.alteracion.semitonos)</bass-alter>\n"
            }
            xml += "        </bass>\n"
        }
        // Grados respecto a la escala mayor de la fundamental: la novena menor es 9 con −1.
        let mayor = [0, 2, 4, 5, 7, 9, 11]
        func grado(_ numero: Int, _ semitonos: Int, _ tipo: String) -> String {
            let alteracion = semitonos - mayor[(numero - 1) % 7]
            return "        <degree>\n          <degree-value>\(numero)</degree-value>\n"
                + "          <degree-alter>\(alteracion)</degree-alter>\n"
                + "          <degree-type>\(tipo)</degree-type>\n        </degree>\n"
        }
        for intervalo in intervalos where !mejor.intervalos.contains(where: { $0 == clave(intervalo) }) {
            xml += grado(intervalo.numero, modulo(intervalo.semitonos, 12), "add")
        }
        for (numero, semitonos) in mejor.intervalos
        where !intervalos.contains(where: { clave($0) == (numero, semitonos) }) {
            xml += grado(numero, semitonos, "subtract")
        }
        if let pentagrama { xml += "        <staff>\(pentagrama)</staff>\n" }
        return xml + "      </harmony>\n"
    }

    // MARK: Auxiliares

    /// La figura con que se escribe una duración y, si es de un grupo irregular, la proporción:
    /// 1/12 → corchea de tresillo (3 en el tiempo de 2).
    package static func figura(de duracion: Duracion) -> (
        tipo: String?, puntillos: Int, irregular: (reales: Int, normales: Int)?
    ) {
        let figura = Exportacion.figura(de: duracion)
        return (figura.figura.map(tipo), figura.puntillos, figura.irregular)
    }

    package static func tipo(_ figura: Figura) -> String {
        switch figura {
        case .cuadrada: return "breve"
        case .redonda: return "whole"
        case .blanca: return "half"
        case .negra: return "quarter"
        case .corchea: return "eighth"
        case .semicorchea: return "16th"
        case .fusa: return "32nd"
        case .semifusa: return "64th"
        case .garrapatea: return "128th"
        }
    }

    package static func paso(_ natural: NotaNatural) -> String {
        ["C", "D", "E", "F", "G", "A", "B"][natural.rawValue]
    }

    package static func signo(de clave: Clave) -> (signo: String, linea: Int, cambioDeOctava: Int) {
        switch clave {
        case .sol: return ("G", 2, 0)
        case .solOctavaBaja: return ("G", 2, -1)
        case .solOctavaAlta: return ("G", 2, 1)
        case .fa: return ("F", 4, 0)
        case .faEnTercera: return ("F", 3, 0)
        case .doEnPrimera: return ("C", 1, 0)
        case .doEnSegunda: return ("C", 2, 0)
        case .doEnTercera: return ("C", 3, 0)
        case .doEnCuarta: return ("C", 4, 0)
        }
    }
}

private func ticks(_ duracion: Duracion, _ divisiones: Int) -> Int {
    duracion.numerador * 4 * divisiones / duracion.denominador
}
