import ArmoniaNucleo
import ArmoniaTeoria

// Una voz larga en varias líneas, una debajo de otra, con `OpcionesDePentagrama.maquetacion.compasesPorLinea`.
//
// Cada línea lleva los compases que le tocan (la primera, también la anacrusa) y empieza con su clave y su armadura;
// la cifra del compás solo va en la primera y la barra doble, en la última. Una nota que pasa de una línea a la
// siguiente se divide en la barra y se liga, como en cualquier compás. Las claves son las de la voz entera, para que
// no cambien de una línea a otra, y las líneas se estiran hasta medir lo que la más ancha (la última, si es mucho más
// corta, se queda como está). Los acordes, los grados, los dedos y lo demás que va por evento pasan a la línea en que
// empieza su evento.

extension Voz {
    /// Una línea de una voz larga: sus eventos (las notas que cruzan el final de la línea, divididas y ligadas) y el
    /// momento en que empieza, desde el principio de la voz.
    struct LineaDeLaVoz {
        let eventos: [Evento]
        let inicio: Duracion

        /// Donde acaba.
        var fin: Duracion { eventos.reduce(inicio) { $0 + $1.duracion } }

        /// Dónde empieza cada evento, desde el principio de la voz.
        var inicios: [Duracion] {
            var resultado: [Duracion] = []
            var momento = inicio
            for evento in eventos {
                resultado.append(momento)
                momento = momento + evento.duracion
            }
            return resultado
        }
    }

    /// Las líneas de `compasesPorLinea` compases (la anacrusa, además, en la primera).
    func lineas(de compasesPorLinea: Int) -> [LineaDeLaVoz] {
        let compases = self.compases
        let conAnacrusa = anacrusa > .cero ? 1 : 0
        var resultado: [LineaDeLaVoz] = []
        var desde = 0
        var inicio = Duracion.cero
        while desde < compases.count {
            let hasta = min(compases.count, desde + max(1, compasesPorLinea) + (desde == 0 ? conAnacrusa : 0))
            let linea = LineaDeLaVoz(eventos: compases[desde..<hasta].flatMap { $0 }, inicio: inicio)
            resultado.append(linea)
            inicio = linea.fin
            desde = hasta
        }
        return resultado
    }

    /// El dibujo de cada línea de la voz: una sola si no hay `opciones.maquetacion.compasesPorLinea` o la voz cabe en
    /// una.
    func dibujosPorLinea(
        titulo: String, anotaciones: AnotacionesDelPentagrama, tonica: Nota?, armadura: [Nota]?,
        opciones: OpcionesDePentagrama
    ) -> [PentagramaSVG] {
        let tramos = opciones.maquetacion.compasesPorLinea.map { lineas(de: $0) } ?? []
        guard tramos.count > 1 else {
            return [
                pentagrama(
                    titulo: titulo, anotaciones: anotaciones, tonica: tonica, armadura: armadura, opciones: opciones)
            ]
        }
        var deUnaLinea = opciones
        deUnaLinea.maquetacion.compasesPorLinea = nil
        deUnaLinea.marcas.resaltada = nil
        let inicios = LineaDeLaVoz(eventos: eventos, inicio: .cero).inicios
        // Los momentos en que empieza una nota que se oye (no un silencio ni una nota a la que se liga la anterior),
        // para contar la resaltada.
        var comienzosDeNota: [Duracion] = []
        var ligadaALaAnterior = false
        for (evento, inicio) in zip(eventos, inicios) {
            if !evento.esSilencio && !ligadaALaAnterior { comienzosDeNota.append(inicio) }
            ligadaALaAnterior = evento.ligada
        }
        let microtonos = anotaciones.microtonos ?? microtonosDeLosEventos(en: opciones.notacion)

        var dibujos: [PentagramaSVG] = []
        for (l, linea) in tramos.enumerated() {
            let fin = linea.fin
            let locales = linea.inicios
            var indiceLocal: [Duracion: Int] = [:]
            for (j, momento) in locales.enumerated() where indiceLocal[momento] == nil { indiceLocal[momento] = j }
            // Lo de cada evento que empieza en la línea, en el evento de la línea que empieza con él.
            var suyas = anotaciones.reasignadas { i in
                guard inicios.indices.contains(i), inicios[i] >= linea.inicio, inicios[i] < fin else { return nil }
                return indiceLocal[inicios[i]]
            }
            // Los microtonos, en todos los eventos de la línea, también en la parte ligada de una nota que viene de
            // la anterior.
            var microtonosDeLaLinea: [Int: [PentagramaSVG.Microtono?]] = [:]
            for (j, momento) in locales.enumerated() {
                if let i = inicios.lastIndex(where: { $0 <= momento }), let microtono = microtonos[i] {
                    microtonosDeLaLinea[j] = microtono
                }
            }
            suyas.microtonos = microtonosDeLaLinea
            if suyas.acordes[0] == nil {
                let anteriores = anotaciones.acordes.filter { inicios.indices.contains($0.key) }
                    .filter { inicios[$0.key] < linea.inicio }
                suyas.acordeVigente = anteriores.max { $0.key < $1.key }?.value
            }
            var opcionesDeLaLinea = deUnaLinea
            if let resaltada = opciones.marcas.resaltada {
                opcionesDeLaLinea.marcas.resaltada = Voz.resaltada(
                    resaltada, en: linea, comienzosDeNota: comienzosDeNota)
            }
            let voz = Voz(linea.eventos, compas: compas, anacrusa: l == 0 ? anacrusa : .cero)
            let dibujo = voz.pentagrama(
                titulo: titulo, anotaciones: suyas, tonica: tonica, armadura: armadura, opciones: opcionesDeLaLinea)
            dibujos.append(dibujo)
        }
        return dibujos
    }

    /// La nota resaltada de la voz (contada entre las que se oyen) en la cuenta de una línea, o `nil` si no está en
    /// ella. La línea cuenta como nota la parte ligada de una nota de la anterior, si empieza con ella.
    static func resaltada(_ resaltada: Int, en linea: LineaDeLaVoz, comienzosDeNota: [Duracion]) -> Int? {
        let antes = comienzosDeNota.filter { $0 < linea.inicio }.count
        let continua = linea.eventos.first.map { !$0.esSilencio } == true && !comienzosDeNota.contains(linea.inicio)
        let local = resaltada - antes + (continua ? 1 : 0)
        return local >= 0 ? local : nil
    }
}

extension Voz {
    /// Esta voz y `otra` en el mismo pentagrama: esta con las plicas hacia arriba y `otra` hacia abajo, con las notas
    /// que suenan a la vez en la misma vertical y los silencios de cada una encima o debajo. `otra` se mide con el
    /// compás y la anacrusa de esta. Los acordes (por evento de esta voz) van encima; los nombres de las notas y lo que
    /// marca `opciones.marcas.resaltada`, solo en esta. Con `opciones.maquetacion.compasesPorLinea`, las dos se parten
    /// en las mismas líneas. No hay marca de octava ni cambios de clave: las claves son las que piden las dos voces
    /// juntas. Si las dos suenan a una segunda o al unísono, la cabeza de `otra` se aparta a la derecha.
    ///
    ///     let soprano = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
    ///     let contralto = try Voz(leyendo: "Do5:4 Si4:4 Sol4:2")
    ///     let svg = soprano.svgPentagrama(junto: contralto, titulo: "Dos voces")
    func svgPentagrama(
        junto otra: Voz, titulo: String, acordes: [Int: Acorde] = [:],
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        var deArriba = opciones
        deArriba.maquetacion.marcaDeOctava = false
        deArriba.maquetacion.cambiosDeClave = false
        var deAbajo = deArriba
        deAbajo.marcas.nombresDeLasNotas = false
        deAbajo.marcas.intervalosDeLasNotas = false
        deAbajo.marcas.resaltada = nil
        let arriba = dibujosPorLinea(
            titulo: titulo, anotaciones: AnotacionesDelPentagrama(acordes: acordes), tonica: nil, armadura: nil,
            opciones: deArriba)
        let abajo = Voz(otra.eventos, compas: compas, anacrusa: anacrusa).dibujosPorLinea(
            titulo: titulo, anotaciones: AnotacionesDelPentagrama(), tonica: nil, armadura: nil, opciones: deAbajo)
        let porLinea = (0..<max(arriba.count, abajo.count)).map { l in
            var voces = Array(arriba.dropFirst(l).prefix(1))
            if l < abajo.count {
                var suya = abajo[l]
                suya.soloLasNotas = !voces.isEmpty
                voces.append(suya)
            }
            if voces.count == 2 {
                voces[0].plicasHaciaArriba = true
                voces[1].plicasHaciaArriba = false
            }
            return voces
        }
        return PentagramaSVG.svg(porLinea, titulo: titulo, tamano: opciones.maquetacion.tamano)
    }
}

extension PentagramaSVG {
    /// Las líneas de una voz (o de dos en un pentagrama, una encima de otra), en un SVG: con las mismas claves, la
    /// cifra del compás en la primera y la barra final en la última, y estiradas hasta medir lo que la más ancha
    /// (la última no, si mide menos de tres cuartos).
    static func svg(_ porLinea: [[PentagramaSVG]], titulo: String, tamano: Double) -> String {
        var lineas = porLinea.filter { !$0.isEmpty }
        let todas = lineas.flatMap { $0 }
        guard let primera = todas.first else { return envolver([], titulo: titulo, tamano: tamano) }
        let claves = PentagramaSVG(
            columnas: todas.flatMap(\.columnas), armadura: primera.armadura, cifrado: nil, titulo: titulo,
            opciones: primera.opciones
        ).clavesDelPentagrama()
        for l in lineas.indices {
            for v in lineas[l].indices {
                lineas[l][v].claves = claves
                lineas[l][v].conCifraDeCompas = l == 0
                lineas[l][v].conBarraFinal = l == lineas.count - 1
            }
        }
        var dibujos: [Dibujo] = []
        for l in lineas.indices { dibujos.append(componer(&lineas[l])) }
        return envolver(
            igualadas(dibujos) { l, ancho in componer(&lineas[l], ancho: ancho) }, titulo: titulo, tamano: tamano)
    }

    /// Las líneas, estiradas (con `estirar`, que vuelve a componer la línea `l` con un ancho) hasta lo que mide la
    /// más ancha; la última no, si mide menos de tres cuartos.
    static func igualadas(_ dibujos: [Dibujo], estirar: (_ l: Int, _ ancho: Double) -> Dibujo) -> [Dibujo] {
        var resultado = dibujos
        let ancho = dibujos.map(\.ancho).max() ?? 0
        for l in dibujos.indices where dibujos.count > 1 && dibujos[l].ancho < ancho - 0.01 {
            let corta = l == dibujos.count - 1 && dibujos[l].ancho < ancho * 0.75
            if !corta { resultado[l] = estirar(l, ancho) }
        }
        return resultado
    }

    /// Un sistema de pentagramas, línea a línea: `porLinea[l][p]` son las voces (una o dos) del pentagrama `p` en
    /// la línea `l`. Cada pentagrama lleva las claves que piden sus voces en todas las líneas.
    static func svgDelSistema(
        _ porLinea: [[[PentagramaSVG]]], titulo: String, llave: Bool, tamano: Double
    ) -> String {
        let pentagramas = porLinea.map(\.count).reduce(0, max)
        var claves: [[Clave]] = []
        for p in 0..<pentagramas {
            // Todas las líneas llevan todos los pentagramas, y la primera, una voz al menos en cada uno.
            let suyas = porLinea.flatMap { $0[p] }
            let primera = suyas[0]
            claves.append(
                PentagramaSVG(
                    columnas: suyas.flatMap(\.columnas), armadura: primera.armadura, cifrado: nil, titulo: titulo,
                    opciones: primera.opciones
                ).clavesDelPentagrama())
        }
        var lineas: [(voces: [PentagramaSVG], grupos: [[Int]])] = []
        for (l, linea) in porLinea.enumerated() {
            var voces: [PentagramaSVG] = []
            var grupos: [[Int]] = []
            for (p, suyas) in linea.enumerated() where !suyas.isEmpty {
                var grupo: [Int] = []
                for (v, var voz) in suyas.enumerated() {
                    voz.claves = claves[p]
                    voz.conCifraDeCompas = l == 0
                    voz.conBarraFinal = l == porLinea.count - 1
                    voz.soloLasNotas = v > 0
                    if suyas.count > 1 { voz.plicasHaciaArriba = v == 0 }
                    grupo.append(voces.count)
                    voces.append(voz)
                }
                grupos.append(grupo)
            }
            if !voces.isEmpty { lineas.append((voces, grupos)) }
        }
        var dibujos: [Dibujo] = []
        for l in lineas.indices {
            dibujos.append(componer(&lineas[l].voces, pentagramas: lineas[l].grupos, llave: llave))
        }
        let igualados = igualadas(dibujos) { l, ancho in
            componer(&lineas[l].voces, pentagramas: lineas[l].grupos, llave: llave, ancho: ancho)
        }
        return envolver(igualados, titulo: titulo, tamano: tamano)
    }

    /// Las voces de una línea, con lo que suena a la vez en la misma vertical; y, con `ancho`, estiradas hasta
    /// medirlo. `pentagramas` dice qué voces van en cada pentagrama (por su índice; si es `nil`, todas en uno): las
    /// de un pentagrama se dibujan una encima de otra y los pentagramas, uno debajo de otro, unidos por las barras
    /// de compás y, con `llave`, por una llave.
    static func componer(
        _ voces: inout [PentagramaSVG], pentagramas: [[Int]]? = nil, llave: Bool = false, ancho: Double? = nil
    ) -> Dibujo {
        let grupos = pentagramas ?? [Array(voces.indices)]
        // La voz con la que cada una comparte pentagrama y cuyas cabezas no debe pisar: la primera de su pentagrama.
        var companeras = [Int?](repeating: nil, count: voces.count)
        for grupo in grupos {
            for v in grupo.dropFirst() where voces.indices.contains(v) { companeras[v] = grupo.first }
        }
        var dibujos = voces.map { $0.dibujo() }
        // Cada vez, las columnas, las barras y el final van donde la voz que más lejos los lleva; cuando ya no se
        // mueve nada, están alineadas.
        for _ in 0..<8 where voces.count > 1 {
            guard alinear(&voces, dibujos, companeras: companeras) else { break }
            dibujos = voces.map { $0.dibujo() }
        }
        if let ancho, let actual = dibujos.map(\.ancho).max(), actual < ancho - 0.01 {
            estirar(&voces, dibujos, en: ancho - actual)
            dibujos = voces.map { $0.dibujo() }
        }
        let porPentagrama = grupos.map { grupo in
            superpuestos(grupo.filter(dibujos.indices.contains).map { dibujos[$0] })
        }
        guard porPentagrama.count > 1 else { return porPentagrama[0] }
        return apilados(porPentagrama, barras: dibujos[0], llave: llave, color: voces[0].opciones.colores.dibujo)
    }

    /// Los dibujos de las voces de un pentagrama, uno encima de otro.
    static func superpuestos(_ dibujos: [Dibujo]) -> Dibujo {
        guard dibujos.count > 1 else { return dibujos[0] }
        let y = dibujos.map(\.y).reduce(.infinity, min)
        let abajo = dibujos.map { $0.y + $0.alto }.reduce(-.infinity, max)
        return Dibujo(
            x: dibujos.map(\.x).reduce(.infinity, min), y: y, ancho: dibujos.map(\.ancho).reduce(0, max),
            alto: abajo - y,
            descripcion: dibujos.map(\.descripcion).joined(separator: "; "),
            contenido: dibujos.map(\.contenido).joined(separator: "\n"), colocadas: dibujos[0].colocadas,
            barras: dibujos[0].barras, desplazamiento: dibujos[0].desplazamiento,
            final: dibujos.map(\.final).reduce(0, max))
    }

    /// Lo que se deja entre un pentagrama y el siguiente de un sistema, además de lo que suben y bajan.
    static let separacionEntrePentagramas = 2.5

    /// Los pentagramas de un sistema, uno debajo de otro, con las barras de compás de `barras` (las de la primera
    /// voz, ya alineadas), la del principio y la del final atravesándolos todos, y, con `llave`, una llave delante.
    static func apilados(_ pentagramas: [Dibujo], barras: Dibujo, llave: Bool, color: String) -> Dibujo {
        let n = PentagramaSVG.n
        var y = 0.0
        var grupos: [String] = []
        // Dónde queda la línea de arriba de cada pentagrama.
        var lineasDeArriba: [Double] = []
        for pentagrama in pentagramas {
            grupos.append("<g transform=\"translate(0 \(n(y - pentagrama.y)))\">\n\(pentagrama.contenido)\n</g>")
            lineasDeArriba.append(y - pentagrama.y)
            y += pentagrama.alto + separacionEntrePentagramas
        }
        let alto = y - separacionEntrePentagramas
        let final = pentagramas.map(\.final).reduce(0, max)
        let arriba = lineasDeArriba[0]
        let abajo = lineasDeArriba[lineasDeArriba.count - 1] + 4
        // Las barras, entre un pentagrama y el siguiente (dentro de cada uno ya las dibuja él).
        let xs = [0, final] + barras.barras.map { $0 + barras.desplazamiento }
        var lineas: [String] = []
        for x in xs {
            for (de, a) in zip(lineasDeArriba, lineasDeArriba.dropFirst()) {
                lineas.append(
                    ElementoSVG("line", numeros: .hastaTresDecimales).con("x1", x).con("y1", de + 4).con("x2", x)
                        .con("y2", a).con("stroke-width", "0.16").vacio)
            }
        }
        var x = pentagramas.map(\.x).reduce(.infinity, min)
        var ancho = pentagramas.map(\.ancho).reduce(0, max)
        if llave {
            // La llave de Bravura, estirada de sus 4 espacios a lo que mide el sistema.
            let margen = PentagramaSVG.margenDeLaLlave
            let escala = (abajo - arriba) / 4
            lineas.append(
                ElementoSVG("path", numeros: .hastaTresDecimales)
                    .con("transform", "translate(\(n(x - margen + 0.3)) \(n(abajo))) scale(\(n(escala)))")
                    .con("d", GlifosSMuFL.llave.trazado).con("stroke", "none").con("fill", color).vacio)
            x -= margen
            ancho += margen
        } else {
            // Un corchete: una barra gruesa delante, de arriba abajo.
            lineas.append(
                ElementoSVG("line", numeros: .hastaTresDecimales).con("x1", x - 0.5).con("y1", arriba - 0.3)
                    .con("x2", x - 0.5).con("y2", abajo + 0.3).con("stroke-width", "0.5").vacio)
            x -= 0.9
            ancho += 0.9
        }
        let contenido =
            grupos.joined(separator: "\n") + "\n<g stroke=\"\(EscrituraXML.escapar(color))\">\n"
            + lineas.joined(separator: "\n") + "\n</g>"
        return Dibujo(
            x: x, y: 0, ancho: ancho, alto: alto,
            descripcion: pentagramas.map(\.descripcion).joined(separator: " | "), contenido: contenido,
            colocadas: barras.colocadas, barras: barras.barras, desplazamiento: barras.desplazamiento, final: final)
    }

    /// Lleva cada columna, cada barra de compás y el final de las voces a donde está el más lejano de todas.
    /// Devuelve si algo se mueve. `companeras` dice con qué voz comparte pentagrama cada una (la primera del suyo).
    static func alinear(_ voces: inout [PentagramaSVG], _ dibujos: [Dibujo], companeras: [Int?]) -> Bool {
        // Las cabezas que chocarían con las de la primera voz de su pentagrama (a una segunda o al unísono) se
        // apartan a la derecha lo que mide la cabeza de esa.
        for k in voces.indices {
            guard let companera = companeras.indices.contains(k) ? companeras[k] : nil else {
                voces[k].apartes = [Double](repeating: 0, count: dibujos[k].colocadas.count)
                continue
            }
            var suyas: [Duracion: ColumnaColocada] = [:]
            for (inicio, colocada) in zip(voces[companera].ritmo?.inicios ?? [], dibujos[companera].colocadas) {
                suyas[inicio] = colocada
            }
            voces[k].apartes = zip(voces[k].ritmo?.inicios ?? [], dibujos[k].colocadas).map { inicio, colocada in
                guard let suya = suyas[inicio], chocan(suya, colocada) else { return 0 }
                return suya.anchoDeLaCabeza + 0.1
            }
        }
        var columnas: [Duracion: Double] = [:]
        var barras: [Double] = []
        var final = 0.0
        for (voz, dibujo) in zip(voces, dibujos) {
            for (inicio, (x, aparte)) in zip(voz.ritmo?.inicios ?? [], zip(dibujo.columnasX, voz.apartes)) {
                columnas[inicio] = max(columnas[inicio] ?? -.infinity, x + dibujo.desplazamiento - aparte)
            }
            for (i, x) in dibujo.barras.enumerated() {
                let suya = x + dibujo.desplazamiento
                if i < barras.count { barras[i] = max(barras[i], suya) } else { barras.append(suya) }
            }
            final = max(final, dibujo.final)
        }
        var seMueve = false
        for (k, dibujo) in dibujos.enumerated() {
            let corrimiento = dibujo.desplazamiento
            let inicios = voces[k].ritmo?.inicios ?? []
            let xMinimas = zip(inicios, zip(dibujo.columnasX, voces[k].apartes)).map { inicio, columna in
                (columnas[inicio].map { $0 + columna.1 } ?? columna.0 + corrimiento) - corrimiento
            }
            let barrasMinimas = barras.prefix(dibujo.barras.count).map { $0 - corrimiento }
            let lejos = zip(xMinimas + barrasMinimas, dibujo.columnasX + dibujo.barras).contains { $0 > $1 + 0.001 }
            if lejos || final > dibujo.final + 0.001 { seMueve = true }
            voces[k].xMinimas = xMinimas
            voces[k].barrasMinimas = barrasMinimas
            voces[k].finalMinimo = final
        }
        return seMueve
    }

    /// Si dos columnas que suenan a la vez tienen cabezas a una segunda o al unísono en el mismo pentagrama.
    static func chocan(_ una: ColumnaColocada, _ otra: ColumnaColocada) -> Bool {
        zip(una.lugares, otra.lugares).contains { estas, esas in
            estas.contains { lugar in esas.contains { abs($0 - lugar) <= 1 } }
        }
    }

    /// Estira las voces de una línea, ya alineadas, hasta que midan `falta` más: las columnas y las barras se
    /// apartan de la primera columna en proporción.
    static func estirar(_ voces: inout [PentagramaSVG], _ dibujos: [Dibujo], en falta: Double) {
        let final = dibujos.map(\.final).max() ?? 0
        let primeras = dibujos.compactMap { dibujo in dibujo.columnasX.first.map { $0 + dibujo.desplazamiento } }
        guard let origen = primeras.min(), final > origen else { return }
        let factor = 1 + falta / (final - origen)
        for (k, dibujo) in dibujos.enumerated() {
            let corrimiento = dibujo.desplazamiento
            func estirada(_ x: Double) -> Double { origen + (x + corrimiento - origen) * factor - corrimiento }
            let apartes = voces[k].apartes + Array(repeating: 0, count: dibujo.colocadas.count)
            voces[k].xMinimas = zip(dibujo.columnasX, apartes).map { estirada($0 - $1) + $1 }
            voces[k].barrasMinimas = dibujo.barras.map(estirada)
            voces[k].finalMinimo = final + falta
        }
    }
}

extension Voz {
    /// Varias voces en un sistema de pentagramas, uno debajo de otro, con lo que suena a la vez en la misma vertical
    /// y las barras de compás atravesándolos: un coral a cuatro voces en dos pentagramas, el piano con sus dos
    /// manos, un cuarteto. `pentagramas` lleva, de arriba abajo, las voces de cada pentagrama (una o dos; con dos, la
    /// primera con las plicas hacia arriba). `claves` fija la de cada uno (la que falte o sea `nil`, la que pidan sus
    /// notas). Con `llave`, los une una llave, como en el piano; si no, un corchete, como en un coro. Todas las voces
    /// se miden con el compás y la anacrusa de la primera; con `opciones.maquetacion.compasesPorLinea`, el sistema se
    /// parte en líneas. Los nombres de las notas van solo en la primera voz de cada pentagrama, y la resaltada, en la
    /// primera del primero.
    ///
    ///     let derecha = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
    ///     let izquierda = try Voz(leyendo: "Do3:2 Sol2:2")
    ///     let svg = Voz.svgSistema([[derecha], [izquierda]], titulo: "Piano", claves: [.sol, .fa], llave: true)
    static func svgSistema(
        _ pentagramas: [[Voz]], titulo: String, claves: [Clave?] = [], llave: Bool = false,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let deDosEnDos = pentagramas.map { Array($0.prefix(2)) }.filter { !$0.isEmpty }
        guard let primera = deDosEnDos.first?.first else {
            return PentagramaSVG.envolver([], titulo: titulo, tamano: opciones.maquetacion.tamano)
        }
        var base = opciones
        base.maquetacion.marcaDeOctava = false
        base.maquetacion.cambiosDeClave = false
        base.maquetacion.pentagramas = .simple
        // De cada pentagrama, cada voz partida en líneas.
        var porPentagrama: [[[PentagramaSVG]]] = []
        for (p, voces) in deDosEnDos.enumerated() {
            var delPentagrama = base
            if claves.indices.contains(p), let clave = claves[p] { delPentagrama.maquetacion.clave = clave }
            if p > 0 { delPentagrama.marcas.resaltada = nil }
            porPentagrama.append(
                voces.enumerated().map { v, voz in
                    var suyas = delPentagrama
                    if v > 0 {
                        suyas.marcas.nombresDeLasNotas = false
                        suyas.marcas.intervalosDeLasNotas = false
                        suyas.marcas.resaltada = nil
                    }
                    return Voz(voz.eventos, compas: primera.compas, anacrusa: primera.anacrusa).dibujosPorLinea(
                        titulo: titulo, anotaciones: AnotacionesDelPentagrama(), tonica: nil, armadura: nil,
                        opciones: suyas)
                })
        }
        let lineas = porPentagrama.flatMap { $0.map(\.count) }.reduce(0, max)
        let porLinea = (0..<lineas).map { l in
            porPentagrama.map { voces in voces.compactMap { $0.indices.contains(l) ? $0[l] : nil } }
        }
        return PentagramaSVG.svgDelSistema(porLinea, titulo: titulo, llave: llave, tamano: opciones.maquetacion.tamano)
    }
}
