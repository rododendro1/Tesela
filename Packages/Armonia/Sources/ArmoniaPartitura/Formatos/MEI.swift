import ArmoniaNucleo
import ArmoniaTeoria

// Exportación a MEI 5 (Music Encoding Initiative), el formato de las ediciones críticas y de la
// musicología: lo abren Verovio, mei-friend o MuseScore 4, y se puede validar con el esquema
// mei-CMN de music-encoding.org.
//
// Como en MusicXML (MusicXML.swift), se escribe la grafía de cada voz (`Voz.grafia`), con la
// ortografía tal cual y la armadura de la tonalidad. MEI no deduce qué alteraciones se ven, así
// que se calculan como en una partitura: una alteración vale hasta la barra en su pentagrama y
// en su octava, y la de la armadura no se escribe. Cada nota lleva siempre la que suena
// (`accid.ges`) cuando no se escribe ninguna.
//
// Los cifrados van en `<harm>` encima del pentagrama; el análisis, como letra (`<verse>`) debajo
// del bajo, y la tonalidad del análisis, en un `<dir>` al principio.

extension Voz {
    /// La voz como partitura MEI de un solo pentagrama.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let mei = voz.mei(titulo: "Escala")
    ///
    /// - Parameters:
    ///   - tonalidad: da la armadura; si es `nil`, se estima a partir de las notas.
    ///   - clave: si es `nil`, la de sol o la de fa, según el registro de las notas.
    ///   - tempo: si se da, se escribe la indicación metronómica.
    ///   - titulo: el título de la obra.
    ///   - parte: el nombre del pentagrama.
    public func mei(
        tonalidad: Tonalidad? = nil, clave: Clave? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Voz"
    ) -> String {
        let tonalidad = tonalidad ?? Exportacion.tonalidad(de: self)
        let clave = clave ?? Clave.masAdecuada(para: eventos.flatMap(\.alturas)) ?? .sol
        var escritor = EscritorMEI(
            compas: compas, anacrusa: anacrusa, tonalidad: tonalidad,
            tempo: tempo, titulo: titulo, parte: parte, claves: [clave])
        escritor.anadir(self, pentagrama: 1, plicaArriba: nil)
        return escritor.documento
    }
}

extension Coral {
    /// Los acordes como coral MEI en dos pentagramas, como `musicXML(duracion:compas:tonalidad:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// soprano y contralto en clave de sol y tenor y bajo en clave de fa, cada pareja con las
    /// plicas en sentidos contrarios.
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let mei = coral.mei(duracion: .blanca, compas: "3/2", titulo: "Cadencia", cifrados: true)
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - tonalidad: da la armadura y la tonalidad del análisis; si es `nil`, se estima.
    ///   - cifrados: si se escribe el cifrado americano de cada acorde encima del soprano.
    ///   - analisis: si se escriben el cifrado romano y la función debajo del bajo.
    ///   - notacion: la de los cifrados y la tonalidad.
    public func mei(
        duracion: Duracion = .negra, compas: Compas = .compasillo,
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Coro",
        cifrados: Bool = false, analisis: Bool = false,
        notacion: Notacion = .espanolUnicode
    ) -> String {
        let anotaciones = Exportacion.anotaciones(
            de: self, duracion: duracion, tonalidad: tonalidad,
            cifrados: cifrados, analisis: analisis)
        var escritor = EscritorMEI(
            compas: compas, anacrusa: .cero, tonalidad: anotaciones.tonalidad,
            tempo: tempo, titulo: titulo, parte: parte, claves: [.sol, .fa])
        if let rotulo = anotaciones.tonalidadDelAnalisis { escritor.rotulo = (rotulo.nombre(en: notacion) + ":", 2) }
        let n = numeroDeVoces
        for linea in Exportacion.voces(de: self, duracion: duracion, compas: compas) {
            // Los cifrados, con la voz más aguda; el análisis, con la más grave.
            escritor.anadir(
                linea.voz, pentagrama: linea.pentagrama, plicaArriba: linea.plicaArriba,
                cifrados: linea.indice == n - 1 ? anotaciones.cifrados.mapValues { $0.cifrado(en: notacion) } : [:],
                letras: linea.indice == 0 && linea.indice != n - 1
                    ? anotaciones.analisis.mapValues(Exportacion.letras) : [:])
        }
        return escritor.documento
    }
}

extension AnalisisArmonico {
    /// La progresión como partitura MEI en dos pentagramas, como `musicXML(duracion:compas:tempo:titulo:parte:cifrados:analisis:notacion:)`:
    /// los acordes en posición cerrada en clave de sol, con su cifrado americano encima, y el
    /// bajo en clave de fa, con el cifrado romano y la función debajo.
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let mei = analisis.mei(titulo: "Progresión")
    ///
    /// - Parameters:
    ///   - duracion: lo que dura cada acorde; el último se alarga hasta la barra.
    ///   - cifrados: si se escriben los cifrados americanos.
    ///   - analisis: si se escriben los cifrados romanos y las funciones.
    ///   - notacion: la de los cifrados americanos y la tonalidad.
    public func mei(
        duracion: Duracion = .blanca, compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        mei(
            duraciones: Array(repeating: duracion, count: acordes.count), compas: compas, tempo: tempo,
            titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis, notacion: notacion)
    }

    /// Lo mismo, con lo que dura cada acorde; el último se alarga hasta la barra.
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func mei(
        duraciones: [Duracion], compas: Compas = .compasillo, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, notacion: Notacion = .espanolUnicode
    ) -> String {
        Exportacion.comprobar(duraciones, acordes: acordes.count)
        let (superior, grave) = Exportacion.progresion(
            acordes.map(\.acorde), duraciones: Exportacion.hastaLaBarra(duraciones, compas))
        let anotaciones = Exportacion.anotaciones(
            de: self, duraciones: duraciones, cifrados: cifrados, analisis: analisis)
        var escritor = EscritorMEI(
            compas: compas, anacrusa: .cero, tonalidad: tonalidad, tempo: tempo,
            titulo: titulo, parte: parte, claves: [.sol, .fa])
        if let rotulo = anotaciones.tonalidadDelAnalisis { escritor.rotulo = (rotulo.nombre(en: notacion) + ":", 2) }
        escritor.anadir(
            Voz(superior, compas: compas), pentagrama: 1, plicaArriba: nil,
            cifrados: anotaciones.cifrados.mapValues { $0.cifrado(en: notacion) })
        escritor.anadir(
            Voz(grave, compas: compas), pentagrama: 2, plicaArriba: nil,
            letras: anotaciones.analisis.mapValues(Exportacion.letras))
        return escritor.documento
    }
}

// MARK: - Escritor MEI

/// Reúne varias voces, cada una en un pentagrama (con una capa por voz), y escribe el documento.
package struct EscritorMEI {
    package struct Linea {
        package let voz: Voz
        package let pentagrama: Int
        /// `nil` si la plica va donde toque; si no, hacia arriba o hacia abajo.
        package let plicaArriba: Bool?
        /// El cifrado que se escribe encima de la nota que empieza en cada punto de la voz.
        package let cifrados: [Duracion: String]
        /// Las líneas de texto que se escriben debajo de la nota que empieza en cada punto.
        package let letras: [Duracion: [String]]
    }

    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
    package var lineas: [Linea] = []
    /// Un texto debajo de un pentagrama, al principio (la tonalidad del análisis).
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
        cifrados: [Duracion: String] = [:], letras: [Duracion: [String]] = [:]
    ) {
        lineas.append(
            Linea(
                voz: voz, pentagrama: pentagrama, plicaArriba: plicaArriba,
                cifrados: cifrados, letras: letras))
    }

    package var documento: String {
        let grafias = lineas.map(\.voz.grafia)
        let barras = lineas.map(\.voz.barrasDeAgrupacion)
        let numeroDeCompases = grafias.map(\.count).max() ?? 0
        let ppq = Exportacion.divisiones(grafias.flatMap { $0.flatMap { $0.map(\.duracion) } })
        let armadura = Dictionary(
            (tonalidad?.notasDeLaArmadura ?? []).map { ($0.natural, $0.alteracion.semitonos) },
            uniquingKeysWith: { primera, _ in primera })

        var xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <?xml-model href="https://music-encoding.org/schema/5.0/mei-CMN.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
            <mei xmlns="http://www.music-encoding.org/ns/mei" meiversion="5.0">
              <meiHead>
                <fileDesc>
                  <titleStmt>
                    <title>\(Exportacion.escapar(titulo ?? ""))</title>
                  </titleStmt>
                  <pubStmt/>
                </fileDesc>
                <encodingDesc>
                  <appInfo>
                    <application>
                      <name>Armonia</name>
                    </application>
                  </appInfo>
                </encodingDesc>
              </meiHead>
              <music>
                <body>
                  <mdiv>
                    <score>
            \(definicion(ppq))          <section>

            """
        // Lo que viene ligado del compás anterior, por línea.
        var ligadaDesde: [[Altura]] = Array(repeating: [], count: lineas.count)
        // Dónde va cada línea, desde su comienzo, para colocar las anotaciones.
        var posiciones = Array(repeating: Duracion.cero, count: lineas.count)
        var siguienteId = 1
        for c in 0..<max(numeroDeCompases, 1) {
            let esAnacrusa = c == 0 && anacrusa > .cero
            let numero = anacrusa > .cero ? c : c + 1
            var atributos = "n=\"\(numero)\""
            if esAnacrusa { atributos += " metcon=\"false\"" }
            if c == numeroDeCompases - 1 { atributos += " right=\"end\"" }
            xml += "            <measure \(atributos)>\n"

            // Qué viene ligado del anterior en cada evento del compás, y qué alteraciones se ven.
            var continuaciones: [[[Altura]]] = []
            for l in lineas.indices {
                var desde = ligadaDesde[l]
                var suyas: [[Altura]] = []
                for evento in c < grafias[l].count ? grafias[l][c] : [] {
                    suyas.append(desde)
                    desde = evento.ligada ? evento.alturas : []
                }
                continuaciones.append(suyas)
            }
            let alteraciones = escritas(c, grafias, continuaciones, armadura)

            var control: [String] = []
            for pentagrama in 1...max(claves.count, 1) {
                xml += "              <staff n=\"\(pentagrama)\">\n"
                let suyas = lineas.indices.filter { lineas[$0].pentagrama == pentagrama && c < grafias[$0].count }
                if suyas.isEmpty {
                    xml += "                <layer n=\"1\">\n                  <mSpace/>\n                </layer>\n"
                }
                for (capa, l) in suyas.enumerated() {
                    let linea = lineas[l]
                    let eventos = grafias[l][c]
                    xml += "                <layer n=\"\(capa + 1)\">\n"
                    let compasEntero =
                        eventos.count == 1 && eventos[0].esSilencio && !esAnacrusa
                        && eventos[0].duracion == compas.duracion
                    let grupos = EscritorMEI.grupos(eventos, barras[l][c])
                    var nivel = 0
                    for (i, evento) in eventos.enumerated() {
                        for grupo in grupos.abren[i, default: []] {
                            xml += sangria(nivel) + grupo + "\n"
                            nivel += 1
                        }
                        let id = "e\(siguienteId)"
                        siguienteId += 1
                        // Las anotaciones van con la primera nota escrita de cada evento, no con sus ligadas.
                        let esNueva = continuaciones[l][i].isEmpty || evento.alturas != continuaciones[l][i]
                        let letras = esNueva ? linea.letras[posiciones[l]] ?? [] : []
                        if esNueva, let cifrado = linea.cifrados[posiciones[l]] {
                            control.append(
                                "<harm staff=\"\(pentagrama)\" place=\"above\" startid=\"#\(id)\">\(Exportacion.escapar(cifrado))</harm>"
                            )
                        }
                        if c == 0 && i == 0 {
                            if let tempo, l == 0 {
                                control.append(EscritorMEI.indicacion(tempo, pentagrama: pentagrama, id: id))
                            }
                            if let rotulo, rotulo.pentagrama == pentagrama, capa == 0 {
                                control.append(
                                    "<dir staff=\"\(pentagrama)\" place=\"below\" startid=\"#\(id)\">\(Exportacion.escapar(rotulo.texto))</dir>"
                                )
                            }
                        }
                        xml += EscritorMEI.evento(
                            evento, id: id, plicaArriba: linea.plicaArriba,
                            compasEntero: compasEntero, ligadaDesde: continuaciones[l][i],
                            alteraciones: alteraciones[l][i], letras: letras, ppq: ppq, nivel: nivel)
                        posiciones[l] = posiciones[l] + evento.duracion
                        for grupo in grupos.cierran[i, default: []] {
                            nivel -= 1
                            xml += sangria(nivel) + grupo + "\n"
                        }
                    }
                    if let ultimo = eventos.last { ligadaDesde[l] = ultimo.ligada ? ultimo.alturas : [] }
                    xml += "                </layer>\n"
                }
                xml += "              </staff>\n"
            }
            for elemento in control { xml += "              \(elemento)\n" }
            xml += "            </measure>\n"
        }
        xml += """
                      </section>
                    </score>
                  </mdiv>
                </body>
              </music>
            </mei>

            """
        return xml
    }

    /// `<scoreDef>`: compás, armadura y un `<staffDef>` por clave, con las divisiones por negra
    /// (`ppq`) que dan la duración exacta de cada evento en `dur.ppq`.
    private func definicion(_ ppq: Int) -> String {
        var atributos = "meter.count=\"\(EscritorMEI.pulsos(compas))\" meter.unit=\"\(compas.denominador)\""
        if compas == .compasillo { atributos += " meter.sym=\"common\"" }
        if compas == .partido { atributos += " meter.sym=\"cut\"" }
        let fifths = tonalidad?.armadura ?? 0
        atributos += " keysig=\"\(fifths == 0 ? "0" : "\(abs(fifths))\(fifths > 0 ? "s" : "f")")\""
        var xml = "          <scoreDef \(atributos)>\n"
        xml +=
            claves.count > 1
            ? "            <staffGrp symbol=\"brace\" bar.thru=\"true\">\n" : "            <staffGrp>\n"
        xml += "              <label>\(Exportacion.escapar(parte))</label>\n"
        for (i, clave) in claves.enumerated() {
            let (forma, linea, cambio) = EscritorMusicXML.signo(de: clave)
            var definicion = "n=\"\(i + 1)\" lines=\"5\" ppq=\"\(ppq)\" clef.shape=\"\(forma)\" clef.line=\"\(linea)\""
            if cambio != 0 { definicion += " clef.dis=\"8\" clef.dis.place=\"\(cambio > 0 ? "above" : "below")\"" }
            xml += "              <staffDef \(definicion)/>\n"
        }
        return xml + "            </staffGrp>\n          </scoreDef>\n"
    }

    // MARK: Eventos

    /// Una nota, un acorde o un silencio.
    private static func evento(
        _ evento: Evento, id: String, plicaArriba: Bool?, compasEntero: Bool,
        ligadaDesde: [Altura], alteraciones: [AlteracionEscrita], letras: [String],
        ppq: Int, nivel: Int
    ) -> String {
        // La figura, si la hay; la duración exacta va siempre en `dur.ppq`, porque algunos trozos
        // de un grupo irregular partido por la barra no tienen figura propia.
        let figura = Exportacion.figura(de: evento.duracion)
        var duracion = figura.figura.map { " dur=\"\(dur($0))\"" } ?? ""
        if figura.puntillos > 0 { duracion += " dots=\"\(figura.puntillos)\"" }
        duracion += " dur.ppq=\"\(Int(((evento.duracion / .negra).enRedondas * Double(ppq)).rounded()))\""
        let plica = plicaArriba.map { " stem.dir=\"\($0 ? "up" : "down")\"" } ?? ""
        let fuera = sangria(nivel)
        guard !evento.esSilencio else {
            return compasEntero
                ? fuera + "<mRest xml:id=\"\(id)\"/>\n" : fuera + "<rest xml:id=\"\(id)\"\(duracion)/>\n"
        }
        func nota(_ k: Int, _ atributos: String) -> String {
            let altura = evento.alturas[k]
            var xml = "<note\(atributos) pname=\"\(paso(altura.nota.natural))\" oct=\"\(altura.octava)\""
            let alteracion = alteraciones[k]
            if let escrita = alteracion.escrita { xml += " accid=\"\(escrita)\"" }
            if let sonora = alteracion.sonora { xml += " accid.ges=\"\(sonora)\"" }
            let viene = ligadaDesde.contains(altura)
            if viene || evento.ligada { xml += " tie=\"\(viene && evento.ligada ? "m" : (viene ? "t" : "i"))\"" }
            return xml
        }
        let versos = letras.enumerated().filter { !$0.element.isEmpty }.map { k, letra in
            "<verse n=\"\(k + 1)\" place=\"below\"><syl>\(Exportacion.escapar(letra))</syl></verse>"
        }
        if evento.alturas.count == 1 {
            let abre = fuera + nota(0, " xml:id=\"\(id)\"" + duracion) + plica
            guard !versos.isEmpty else { return abre + "/>\n" }
            return abre + ">\n" + versos.map { fuera + "  " + $0 + "\n" }.joined() + fuera + "</note>\n"
        }
        var xml = fuera + "<chord xml:id=\"\(id)\"\(duracion)\(plica)>\n"
        for k in evento.alturas.indices { xml += fuera + "  " + nota(k, "") + "/>\n" }
        for verso in versos { xml += fuera + "  " + verso + "\n" }
        return xml + fuera + "</chord>\n"
    }

    /// La alteración que se escribe y la que suena sin escribirse, en los valores de MEI.
    package struct AlteracionEscrita: Equatable {
        package var escrita: String?
        package var sonora: String?
    }

    /// Las alteraciones de cada altura de cada evento del compás `c`, por línea. Se recorren las
    /// notas de cada pentagrama por orden de tiempo, porque una alteración vale para todas sus
    /// voces hasta la barra; las notas que vienen ligadas no la escriben ni la cambian.
    private func escritas(
        _ c: Int, _ grafias: [[[Evento]]], _ continuaciones: [[[Altura]]],
        _ armadura: [NotaNatural: Int]
    ) -> [[[AlteracionEscrita]]] {
        var resultado: [[[AlteracionEscrita]]] = lineas.indices.map { l in
            (c < grafias[l].count ? grafias[l][c] : []).map {
                Array(repeating: AlteracionEscrita(), count: $0.alturas.count)
            }
        }
        for pentagrama in Set(lineas.map(\.pentagrama)) {
            var notas: [(inicio: Duracion, linea: Int, evento: Int)] = []
            for l in lineas.indices where lineas[l].pentagrama == pentagrama && c < grafias[l].count {
                var inicio = Duracion.cero
                for (i, evento) in grafias[l][c].enumerated() {
                    notas.append((inicio, l, i))
                    inicio = inicio + evento.duracion
                }
            }
            notas.sort { ($0.inicio, $0.linea, $0.evento) < ($1.inicio, $1.linea, $1.evento) }
            var vigentes: [Int: Int] = [:] // por línea o espacio del pentagrama: nota natural y octava
            for (_, l, i) in notas {
                for (k, altura) in grafias[l][c][i].alturas.enumerated() {
                    let semitonos = altura.nota.alteracion.semitonos
                    let lugar = altura.octava * 7 + altura.nota.natural.rawValue
                    let vigente = vigentes[lugar] ?? armadura[altura.nota.natural] ?? 0
                    let sonora = semitonos == 0 ? nil : EscritorMEI.accid(semitonos)
                    if continuaciones[l][i].contains(altura) || semitonos == vigente {
                        resultado[l][i][k] = AlteracionEscrita(escrita: nil, sonora: sonora)
                    } else {
                        resultado[l][i][k] = AlteracionEscrita(escrita: EscritorMEI.accid(semitonos), sonora: nil)
                        vigentes[lugar] = semitonos
                    }
                }
            }
        }
        return resultado
    }

    /// Los grupos irregulares (`<tuplet>`) y las barras (`<beam>`) del compás, como elementos que
    /// se abren antes de un evento y se cierran después de otro. Un grupo que se cruza con otro
    /// ya aceptado se queda fuera, para que el XML quede bien anidado; los irregulares van primero.
    private static func grupos(_ eventos: [Evento], _ barras: [[Int]]) -> (
        abren: [Int: [String]], cierran: [Int: [String]]
    ) {
        var rangos: [(rango: ClosedRange<Int>, abre: String, cierra: String)] = []
        // El grupo abierto: dónde empieza, su proporción y lo que lleva.
        var abierto: (desde: Int, reales: Int, normales: Int, acumulado: Duracion)?
        func cerrar(en i: Int) {
            if let grupo = abierto {
                rangos.append(
                    (grupo.desde...i, "<tuplet num=\"\(grupo.reales)\" numbase=\"\(grupo.normales)\">", "</tuplet>"))
            }
            abierto = nil
        }
        for (i, evento) in eventos.enumerated() {
            guard let (reales, normales) = Exportacion.figura(de: evento.duracion).irregular else {
                cerrar(en: i - 1)
                continue
            }
            // Todo lo que va dentro de un `<tuplet>` tiene su proporción: otra abre otro grupo.
            if let grupo = abierto, grupo.reales != reales || grupo.normales != normales { cerrar(en: i - 1) }
            let acumulado = (abierto?.acumulado ?? .cero) + evento.duracion
            abierto = (abierto?.desde ?? i, reales, normales, acumulado)
            if acumulado.denominador & (acumulado.denominador - 1) == 0 || i == eventos.count - 1 { cerrar(en: i) }
        }
        for grupo in barras where grupo.count > 1 {
            rangos.append((grupo.min()!...grupo.max()!, "<beam>", "</beam>"))
        }
        var aceptados: [(rango: ClosedRange<Int>, abre: String, cierra: String)] = []
        for candidato in rangos {
            let encaja = aceptados.allSatisfy { otro in
                !candidato.rango.overlaps(otro.rango)
                    || (candidato.rango.lowerBound >= otro.rango.lowerBound
                        && candidato.rango.upperBound <= otro.rango.upperBound)
                    || (otro.rango.lowerBound >= candidato.rango.lowerBound
                        && otro.rango.upperBound <= candidato.rango.upperBound)
            }
            if encaja { aceptados.append(candidato) }
        }
        var abren: [Int: [String]] = [:]
        var cierran: [Int: [String]] = [:]
        // En el orden en que se abren: por dónde empiezan y, si empiezan juntos, primero el más
        // largo (y, si son iguales, el irregular). Se cierran en el orden contrario.
        let orden = aceptados.indices.sorted {
            (aceptados[$0].rango.lowerBound, -aceptados[$0].rango.count, $0)
                < (aceptados[$1].rango.lowerBound, -aceptados[$1].rango.count, $1)
        }
        for k in orden { abren[aceptados[k].rango.lowerBound, default: []].append(aceptados[k].abre) }
        for k in orden.reversed() { cierran[aceptados[k].rango.upperBound, default: []].append(aceptados[k].cierra) }
        return (abren, cierran)
    }

    // MARK: Control

    /// `<tempo>` con la figura y las pulsaciones, y su velocidad en negras para MIDI.
    private static func indicacion(_ tempo: Tempo, pentagrama: Int, id: String) -> String {
        let porMinuto = Exportacion.formatear(tempo.pulsacionesPorMinuto)
        var atributos = "staff=\"\(pentagrama)\" place=\"above\" startid=\"#\(id)\""
        var texto = "♩ = " + Exportacion.formatear(tempo.negrasPorMinuto)
        if let (figura, puntillos) = tempo.unidad.figuraYPuntillos {
            atributos += " mm=\"\(porMinuto)\" mm.unit=\"\(dur(figura))\""
            if puntillos > 0 { atributos += " mm.dots=\"\(puntillos)\"" }
            if let simbolo = simbolos[figura] {
                texto = simbolo + String(repeating: ".", count: puntillos) + " = " + porMinuto
            }
        }
        atributos += " midi.bpm=\"\(Exportacion.formatear(tempo.negrasPorMinuto))\""
        return "<tempo \(atributos)>\(texto)</tempo>"
    }

    private static let simbolos: [Figura: String] = [
        .redonda: "𝅝", .blanca: "𝅗𝅥", .negra: "♩", .corchea: "♪", .semicorchea: "𝅘𝅥𝅯",
    ]

    // MARK: Auxiliares

    /// Los pulsos del compás como `meter.count`: "3+2+2" en uno de amalgama irregular.
    package static func pulsos(_ compas: Compas) -> String {
        compas.agrupacion.count > 1 && Set(compas.agrupacion).count > 1 && compas.tipo != .compuesto
            ? compas.agrupacion.map(String.init).joined(separator: "+") : "\(compas.numerador)"
    }

    package static func dur(_ figura: Figura) -> String {
        figura == .cuadrada ? "breve" : String(1 << figura.rawValue)
    }

    /// `accid` y `accid.ges` de MEI: 1 → "s", −2 → "ff", 0 → "n". `nil` más allá de las triples.
    package static func accid(_ semitonos: Int) -> String? {
        [-3: "tf", -2: "ff", -1: "f", 0: "n", 1: "s", 2: "x", 3: "ts"][semitonos]
    }

    package static func paso(_ natural: NotaNatural) -> String {
        ["c", "d", "e", "f", "g", "a", "b"][natural.rawValue]
    }
}

private func sangria(_ nivel: Int) -> String {
    String(repeating: " ", count: 18 + 2 * nivel)
}
