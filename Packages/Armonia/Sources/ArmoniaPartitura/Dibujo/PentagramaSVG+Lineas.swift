import ArmoniaNucleo
import ArmoniaTeoria

// Una voz larga en varias líneas, una debajo de otra, con `OpcionesDePentagrama.compasesPorLinea`.
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

    /// El dibujo de cada línea de la voz: una sola si no hay `opciones.compasesPorLinea` o la voz cabe en una.
    func dibujosPorLinea(
        titulo: String, anotaciones: AnotacionesDelPentagrama, tonica: Nota?, armadura: [Nota]?,
        opciones: OpcionesDePentagrama
    ) -> [PentagramaSVG] {
        let tramos = opciones.compasesPorLinea.map { lineas(de: $0) } ?? []
        guard tramos.count > 1 else {
            return [
                pentagrama(
                    titulo: titulo, anotaciones: anotaciones, tonica: tonica, armadura: armadura, opciones: opciones)
            ]
        }
        var deUnaLinea = opciones
        deUnaLinea.compasesPorLinea = nil
        deUnaLinea.resaltada = nil
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
            /// Lo de cada evento que empieza en la línea, en el evento de la línea que empieza con él.
            func enLaLinea<T>(_ porEvento: [Int: T]) -> [Int: T] {
                var resultado: [Int: T] = [:]
                for (i, valor) in porEvento where inicios.indices.contains(i) {
                    guard inicios[i] >= linea.inicio, inicios[i] < fin else { continue }
                    if let j = indiceLocal[inicios[i]] { resultado[j] = valor }
                }
                return resultado
            }
            var suyas = AnotacionesDelPentagrama(
                acordes: enLaLinea(anotaciones.acordes), grados: enLaLinea(anotaciones.grados),
                bajoCifrado: enLaLinea(anotaciones.bajoCifrado), digitos: enLaLinea(anotaciones.digitos),
                tablatura: anotaciones.tablatura.map { Tablatura(cuerdas: $0.cuerdas, notas: enLaLinea($0.notas)) })
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
            if let resaltada = opciones.resaltada {
                opcionesDeLaLinea.resaltada = Voz.resaltada(
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
    /// compás y la anacrusa de esta. Los acordes (por evento de esta voz) van encima; los nombres de las notas y lo
    /// que marca `opciones.resaltada`, solo en esta. Con `opciones.compasesPorLinea`, las dos se parten en las mismas
    /// líneas. No hay marca de octava ni cambios de clave: las claves son las que piden las dos voces juntas.
    ///
    ///     let soprano = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
    ///     let contralto = try Voz(leyendo: "Do5:4 Si4:4 Sol4:2")
    ///     let svg = soprano.svgPentagrama(junto: contralto, titulo: "Dos voces")
    public func svgPentagrama(
        junto otra: Voz, titulo: String, acordes: [Int: Acorde] = [:],
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        var deArriba = opciones
        deArriba.marcaDeOctava = false
        deArriba.cambiosDeClave = false
        var deAbajo = deArriba
        deAbajo.nombresDeLasNotas = false
        deAbajo.intervalosDeLasNotas = false
        deAbajo.resaltada = nil
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
        return PentagramaSVG.svg(porLinea, titulo: titulo, tamano: opciones.tamano)
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
        let ancho = dibujos.map(\.ancho).max() ?? 0
        for l in lineas.indices where lineas.count > 1 && dibujos[l].ancho < ancho - 0.01 {
            let corta = l == lineas.count - 1 && dibujos[l].ancho < ancho * 0.75
            if !corta { dibujos[l] = componer(&lineas[l], ancho: ancho) }
        }
        return envolver(dibujos, titulo: titulo, tamano: tamano)
    }

    /// Las voces de una línea, una encima de otra, con lo que suena a la vez en la misma vertical; y, con `ancho`,
    /// estiradas hasta medirlo.
    static func componer(_ voces: inout [PentagramaSVG], ancho: Double? = nil) -> Dibujo {
        var dibujos = voces.map { $0.dibujo() }
        // Cada vez, las columnas, las barras y el final van donde la voz que más lejos los lleva; cuando ya no se
        // mueve nada, están alineadas.
        for _ in 0..<8 where voces.count > 1 {
            guard alinear(&voces, dibujos) else { break }
            dibujos = voces.map { $0.dibujo() }
        }
        if let ancho, let actual = dibujos.map(\.ancho).max(), actual < ancho - 0.01 {
            estirar(&voces, dibujos, en: ancho - actual)
            dibujos = voces.map { $0.dibujo() }
        }
        guard dibujos.count > 1 else { return dibujos[0] }
        let y = dibujos.map(\.y).min() ?? 0
        let abajo = dibujos.map { $0.y + $0.alto }.max() ?? 0
        return Dibujo(
            x: dibujos.map(\.x).min() ?? 0, y: y, ancho: dibujos.map(\.ancho).max() ?? 0, alto: abajo - y,
            descripcion: dibujos.map(\.descripcion).joined(separator: "; "),
            contenido: dibujos.map(\.contenido).joined(separator: "\n"))
    }

    /// Lleva cada columna, cada barra de compás y el final de las voces a donde está el más lejano de todas.
    /// Devuelve si algo se mueve.
    static func alinear(_ voces: inout [PentagramaSVG], _ dibujos: [Dibujo]) -> Bool {
        var columnas: [Duracion: Double] = [:]
        var barras: [Double] = []
        var final = 0.0
        for (voz, dibujo) in zip(voces, dibujos) {
            for (inicio, x) in zip(voz.ritmo?.inicios ?? [], dibujo.columnasX) {
                columnas[inicio] = max(columnas[inicio] ?? -.infinity, x + dibujo.desplazamiento)
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
            let xMinimas = zip(inicios, dibujo.columnasX).map { (columnas[$0] ?? $1 + corrimiento) - corrimiento }
            let barrasMinimas = barras.prefix(dibujo.barras.count).map { $0 - corrimiento }
            let lejos = zip(xMinimas + barrasMinimas, dibujo.columnasX + dibujo.barras).contains { $0 > $1 + 0.001 }
            if lejos || final > dibujo.final + 0.001 { seMueve = true }
            voces[k].xMinimas = xMinimas
            voces[k].barrasMinimas = barrasMinimas
            voces[k].finalMinimo = final
        }
        return seMueve
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
            voces[k].xMinimas = dibujo.columnasX.map(estirada)
            voces[k].barrasMinimas = dibujo.barras.map(estirada)
            voces[k].finalMinimo = final + falta
        }
    }
}
