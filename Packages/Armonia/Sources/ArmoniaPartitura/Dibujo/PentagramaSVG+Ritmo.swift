import ArmoniaNucleo
import ArmoniaTeoria

// El ritmo en el pentagrama en SVG: las cabezas según la figura, plicas, corchetes, barras de unión, puntillos,
// silencios, ligaduras, tresillos, la cifra del compás y las barras de compás. Lo dibuja `PentagramaSVG` cuando
// lleva un `Ritmo`; sin él, todo son redondas, como en las escalas y los acordes.

extension PentagramaSVG {
    /// Lo que el pentagrama necesita saber del ritmo, columna a columna (una columna por evento de
    /// `Voz.grafia`).
    struct Ritmo {
        /// La figura con que se escribe cada columna, con sus puntillos.
        let figuras: [(figura: Figura, puntillos: Int)]
        /// Si la columna se liga a la siguiente.
        let ligadas: [Bool]
        let compas: Compas
        /// Las columnas detrás de las que va una barra de compás (la última no: lleva la barra final).
        let finesDeCompas: Set<Int>
        /// Las columnas unidas por una barra, en grupos de dos o más.
        let vigas: [[Int]]
        /// Las columnas de cada tresillo (o grupo irregular: cinquillo, seisillo, septillo…).
        let tresillos: [[Int]]
        /// Las columnas de la nota que está sonando (más de una si se divide en notas ligadas).
        let resaltadas: Set<Int>
        /// Dónde empieza cada columna, desde el principio de la voz.
        var inicios: [Duracion] = []
        /// La cifra de cada grupo de `tresillos`: 3 en un tresillo, 5 en un cinquillo…
        var cifrasDeLosGrupos: [Int] = []

        /// El ritmo de una voz y sus columnas (las alturas de cada evento de su grafía; un silencio, ninguna).
        /// `resaltada` cuenta las notas que se oyen: sin los silencios ni las notas a las que se liga otra.
        ///
        /// Si hay tresillos, las notas solo se dividen en las barras de compás (`compases`): la grafía las partiría en
        /// cada pulso, y una negra de tresillo que lo cruza se lee mejor entera.
        static func de(
            _ voz: Voz, resaltada: Int?
        ) -> (ritmo: Ritmo, columnas: [[Altura]], primeras: [Int]) {
            let irregular = voz.eventos.contains { $0.duracion.figuraYPuntillos == nil }
            let compases = irregular ? voz.compases : voz.grafia
            let eventos = compases.flatMap { $0 }
            var figuras: [(figura: Figura, puntillos: Int)] = []
            // La proporción del grupo irregular de cada columna (3:2 en un tresillo, 5:4 en un cinquillo), o `nil`.
            var deGrupo: [(numero: Int, en: Int)?] = []
            for evento in eventos {
                if let escrita = evento.duracion.figuraYPuntillos {
                    figuras.append(escrita)
                    deGrupo.append(nil)
                } else if let grupo = Ritmo.grupoIrregular(evento.duracion) {
                    figuras.append(grupo.figura)
                    deGrupo.append(grupo.proporcion)
                } else {
                    // Los demás: la figura más larga que no la pasa, sin cifra.
                    let figura = Figura.allCases.first { $0.duracion <= evento.duracion } ?? .garrapatea
                    figuras.append((figura, 0))
                    deGrupo.append(nil)
                }
            }

            // Las barras de unión, como en `Voz.barrasDeAgrupacion`: las notas seguidas que se escriben con corchea o
            // algo más breve, dentro de un mismo pulso.
            var finesDeCompas: Set<Int> = []
            var vigas: [[Int]] = []
            var primera = 0
            let inicios = voz.compas.iniciosDePulso
            for (indice, delCompas) in compases.enumerated() {
                var posicion = indice == 0 && voz.anacrusa > .cero ? voz.compas.duracion - voz.anacrusa : .cero
                var actual: [Int] = []
                var pulsoActual = -1
                for (j, evento) in delCompas.enumerated() {
                    let i = primera + j
                    let pulso = inicios.lastIndex { $0 <= posicion } ?? 0
                    let corta = !evento.esSilencio && figuras[i].figura.rawValue >= Figura.corchea.rawValue
                    if corta && pulso == pulsoActual {
                        actual.append(i)
                    } else {
                        if actual.count >= 2 { vigas.append(actual) }
                        actual = corta ? [i] : []
                        pulsoActual = corta ? pulso : -1
                    }
                    posicion = posicion + evento.duracion
                }
                if actual.count >= 2 { vigas.append(actual) }
                primera += delCompas.count
                if primera < eventos.count { finesDeCompas.insert(primera - 1) }
            }

            // Los tresillos y los demás grupos: notas seguidas con la misma proporción, hasta que suman una figura
            // sin puntillo (tres corcheas de tresillo, una negra; cinco semicorcheas de cinquillo, otra) o acaba el
            // compás.
            var tresillos: [[Int]] = []
            var cifras: [Int] = []
            var actual: [Int] = []
            var suma = Duracion.cero
            func cerrar(_ numero: Int) {
                if !actual.isEmpty {
                    tresillos.append(actual)
                    cifras.append(numero)
                }
                actual = []
                suma = .cero
            }
            // Un grupo que se corta antes de completarse (por otra figura u otra proporción) no lleva cifra.
            for i in eventos.indices {
                guard let proporcion = deGrupo[i] else {
                    actual = []
                    suma = .cero
                    continue
                }
                if let anterior = actual.last.flatMap({ deGrupo[$0] }), anterior != proporcion {
                    actual = []
                    suma = .cero
                }
                actual.append(i)
                suma = suma + eventos[i].duracion
                if suma.figuraYPuntillos?.puntillos == 0 || finesDeCompas.contains(i) { cerrar(proporcion.numero) }
            }
            if let ultimo = actual.last.flatMap({ deGrupo[$0] }) { cerrar(ultimo.numero) }

            var resaltadas: Set<Int> = []
            if let resaltada {
                var nota = -1
                var ligadaALaAnterior = false
                for (i, evento) in eventos.enumerated() {
                    if !evento.esSilencio && !ligadaALaAnterior { nota += 1 }
                    if !evento.esSilencio && nota == resaltada { resaltadas.insert(i) }
                    ligadaALaAnterior = evento.ligada
                }
            }

            var ritmo = Ritmo(
                figuras: figuras, ligadas: eventos.map(\.ligada), compas: voz.compas, finesDeCompas: finesDeCompas,
                vigas: vigas, tresillos: tresillos, resaltadas: resaltadas)
            ritmo.cifrasDeLosGrupos = cifras
            var momento = Duracion.cero
            for evento in eventos {
                ritmo.inicios.append(momento)
                momento = momento + evento.duracion
            }
            // La primera columna de cada evento de la voz: la que empieza cuando él.
            var primeras: [Int] = []
            var inicioDelEvento = Duracion.cero
            var inicioDeLaColumna = Duracion.cero
            var columna = 0
            for evento in voz.eventos {
                while columna < eventos.count, inicioDeLaColumna < inicioDelEvento {
                    inicioDeLaColumna = inicioDeLaColumna + eventos[columna].duracion
                    columna += 1
                }
                primeras.append(min(columna, max(0, eventos.count - 1)))
                inicioDelEvento = inicioDelEvento + evento.duracion
            }
            return (ritmo, eventos.map(\.alturas), primeras)
        }

        /// Las proporciones de los grupos irregulares que se reconocen, con la cifra que se escribe: el tresillo (3
        /// en el tiempo de 2), el cinquillo (5 en 4), el septillo (7 en 4 o en 8), el de nueve (9 en 8), el dosillo
        /// y el cuatrillo de los compases compuestos (2 y 4 en 3), el cinquillo en 2 o en 6 y el de once y trece.
        static let proporcionesDeGrupo: [(numero: Int, en: Int)] = [
            (3, 2), (5, 4), (7, 4), (2, 3), (4, 3), (6, 4), (7, 8), (9, 8), (5, 2), (5, 6), (11, 8), (13, 8),
        ]

        /// La proporción de un grupo irregular en que `duracion` es una figura, y esa figura; `nil` si no hay.
        static func grupoIrregular(
            _ duracion: Duracion
        ) -> (proporcion: (numero: Int, en: Int), figura: (figura: Figura, puntillos: Int))? {
            for proporcion in proporcionesDeGrupo {
                if let escrita = (duracion * Duracion(proporcion.numero, proporcion.en)).figuraYPuntillos {
                    return (proporcion, escrita)
                }
            }
            return nil
        }

        /// La cabeza de la nota de una columna: redonda, blanca o negra.
        func cabeza(_ columna: Int) -> Glifo {
            switch figuras[columna].figura {
            case .cuadrada, .redonda: return GlifosSMuFL.redonda
            case .blanca: return GlifosSMuFL.blanca
            default: return GlifosSMuFL.negra
            }
        }

        /// El silencio de una columna y la posición en que se escribe: el de redonda cuelga de la 4.ª línea, el de
        /// blanca se apoya en la 3.ª y los demás se centran en ella.
        func silencio(_ columna: Int) -> (glifo: Glifo, lugar: Int) {
            switch figuras[columna].figura {
            case .cuadrada, .redonda: return (GlifosSMuFL.silencioDeRedonda, 6)
            case .blanca: return (GlifosSMuFL.silencioDeBlanca, 4)
            case .negra: return (GlifosSMuFL.silencioDeNegra, 4)
            case .corchea: return (GlifosSMuFL.silencioDeCorchea, 4)
            case .semicorchea: return (GlifosSMuFL.silencioDeSemicorchea, 4)
            default: return (GlifosSMuFL.silencioDeFusa, 4)
            }
        }

        /// Cuántas barras (o corchetes) lleva la figura de una columna: 1 la corchea, 2 la semicorchea…
        func barras(_ columna: Int) -> Int { max(0, figuras[columna].figura.rawValue - Figura.negra.rawValue) }

        /// Si la columna lleva plica: todas menos la redonda y la cuadrada.
        func llevaPlica(_ columna: Int) -> Bool { figuras[columna].figura.rawValue >= Figura.blanca.rawValue }

        /// Si la columna va con corchete (una corchea o algo más breve, suelta).
        func llevaCorchete(_ columna: Int) -> Bool {
            barras(columna) > 0 && !vigas.contains { $0.contains(columna) }
        }

        /// Lo que se deja detrás de una columna, según lo que dura: más cuanto más larga, pero no en proporción.
        func separacion(_ columna: Int) -> Double {
            let (figura, puntillos) = figuras[columna]
            let duracion = Duracion(figura, puntillos: puntillos).enRedondas
            return 0.9 + 2.0 * (duracion * 4).squareRoot() + (llevaCorchete(columna) ? 0.5 : 0)
        }

        /// La cifra del compás, de arriba abajo.
        var cifras: [[Glifo]] {
            [compas.numerador, compas.denominador].map { numero in
                String(numero).compactMap(\.wholeNumberValue).map { PentagramaSVG.cifrasDeCompas[$0] }
            }
        }
    }

    static let cifrasDeGrupo = [
        GlifosSMuFL.cifraDeGrupo0, GlifosSMuFL.cifraDeGrupo1, GlifosSMuFL.cifraDeGrupo2, GlifosSMuFL.cifraDeTresillo,
        GlifosSMuFL.cifraDeGrupo4, GlifosSMuFL.cifraDeGrupo5, GlifosSMuFL.cifraDeGrupo6, GlifosSMuFL.cifraDeGrupo7,
        GlifosSMuFL.cifraDeGrupo8, GlifosSMuFL.cifraDeGrupo9,
    ]

    static let cifrasDeCompas = [
        GlifosSMuFL.cifraDeCompas0, GlifosSMuFL.cifraDeCompas1, GlifosSMuFL.cifraDeCompas2,
        GlifosSMuFL.cifraDeCompas3, GlifosSMuFL.cifraDeCompas4, GlifosSMuFL.cifraDeCompas5,
        GlifosSMuFL.cifraDeCompas6, GlifosSMuFL.cifraDeCompas7, GlifosSMuFL.cifraDeCompas8,
        GlifosSMuFL.cifraDeCompas9,
    ]

    /// Una columna ya colocada, para las plicas y las barras: dónde empieza su cabeza, cuánto mide y las posiciones
    /// de sus notas en cada pentagrama (y su altura MIDI, para las ligaduras).
    struct ColumnaColocada {
        let x: Double
        let anchoDeLaCabeza: Double
        let lugares: [[Int]]
        let midis: [[Int]]
    }

    /// Lo largo de una plica, desde la nota más alejada de la barra.
    static let largoDeLaPlica = 3.5
    static let grosorDeLaPlica = 0.12
    static let grosorDeLaBarra = 0.5
    /// De una barra de unión a la siguiente (de una semicorchea, por ejemplo).
    static let distanciaEntreBarras = 0.75
    /// Lo que se aparta de la cabeza el punto en que nace la plica (los anclajes de Bravura).
    static let anclajeDeLaPlica = 0.168

    /// Plicas, corchetes, barras de unión, ligaduras y tresillos, y lo que suben y bajan.
    func trazosDelRitmo(
        _ ritmo: Ritmo, colocadas: [ColumnaColocada], pentagramas: Int
    ) -> (trazos: [String], arriba: Double, abajo: Double, plicasArriba: [Bool?]) {
        func elemento(_ nombre: String) -> ElementoSVG { ElementoSVG(nombre, numeros: .hastaTresDecimales) }
        let n = PentagramaSVG.n
        var trazos: [String] = []
        var arriba = Double.infinity
        var abajo = -Double.infinity
        func alcanzar(_ y: Double) {
            arriba = min(arriba, y)
            abajo = max(abajo, y)
        }
        func y(_ lugar: Int, _ k: Int) -> Double { PentagramaSVG.y(deLugar: lugar, pentagrama: k) }
        func rectangulo(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, grosor: Double) -> String {
            let d = "M\(n(x1)) \(n(y1))L\(n(x2)) \(n(y2))V\(n(y2 + grosor))L\(n(x1)) \(n(y1 + grosor))Z"
            return elemento("path").con("d", d).vacio
        }

        // La plica de cada columna y pentagrama: hacia arriba si la nota más alejada de la 3.ª línea está debajo.
        struct Plica {
            var arriba: Bool
            var x: Double
            /// Donde nace (en la nota más alejada del extremo) y donde acaba.
            var desde: Double
            var hasta: Double
        }
        var plicas = [[Plica?]](repeating: [Plica?](repeating: nil, count: pentagramas), count: colocadas.count)
        func haciaArriba(_ lugares: [Int]) -> Bool {
            if let plicasHaciaArriba { return plicasHaciaArriba }
            guard let maximo = lugares.max(), let minimo = lugares.min() else { return true }
            return maximo - 4 < 4 - minimo
        }
        func plica(_ columna: Int, _ k: Int, arriba: Bool) -> Plica? {
            let colocada = colocadas[columna]
            guard ritmo.llevaPlica(columna), let alto = colocada.lugares[k].max(),
                let bajo = colocada.lugares[k].min()
            else { return nil }
            let extra = PentagramaSVG.distanciaEntreBarras * Double(max(0, ritmo.barras(columna) - 2))
            let largo = PentagramaSVG.largoDeLaPlica + extra
            if arriba {
                return Plica(
                    arriba: true, x: colocada.x + colocada.anchoDeLaCabeza - PentagramaSVG.grosorDeLaPlica / 2,
                    desde: y(bajo, k) - PentagramaSVG.anclajeDeLaPlica, hasta: min(y(alto, k) - largo, y(4, k)))
            }
            return Plica(
                arriba: false, x: colocada.x + PentagramaSVG.grosorDeLaPlica / 2,
                desde: y(alto, k) + PentagramaSVG.anclajeDeLaPlica, hasta: max(y(bajo, k) + largo, y(4, k)))
        }

        // Las barras de unión: cada grupo, en un pentagrama, con todas las plicas hacia el mismo lado; si sus notas
        // se reparten entre los dos pentagramas, cada tramo seguido del mismo pentagrama va por su lado.
        var conBarra: Set<[Int]> = []
        var barrasSVG: [String] = []
        var tramos: [(columnas: [Int], k: Int)] = []
        for viga in ritmo.vigas {
            var tramo: [Int] = []
            var suyo = -1
            for columna in viga {
                let llenos = colocadas[columna].lugares.indices.filter { !colocadas[columna].lugares[$0].isEmpty }
                let k = llenos.count == 1 ? llenos[0] : -1
                if k == suyo, k >= 0 {
                    tramo.append(columna)
                } else {
                    if tramo.count >= 2 { tramos.append((tramo, suyo)) }
                    tramo = k >= 0 ? [columna] : []
                    suyo = k
                }
            }
            if tramo.count >= 2 { tramos.append((tramo, suyo)) }
        }
        for (columnas, k) in tramos {
            conBarra.insert(columnas)
            let arribaDelGrupo = haciaArriba(columnas.flatMap { colocadas[$0].lugares[k] })
            var suyas = columnas.compactMap { plica($0, k, arriba: arribaDelGrupo) }
            guard suyas.count == columnas.count, let primera = suyas.first, let ultima = suyas.last,
                ultima.x > primera.x
            else { continue }
            // La barra, inclinada como las notas pero poco (como mucho, un espacio en todo el grupo), y lo bastante
            // lejos para que ninguna plica quede más corta de lo debido.
            let ancho = ultima.x - primera.x
            let pendiente = max(-1, min(1, ultima.hasta - primera.hasta)) / ancho
            let base =
                arribaDelGrupo
                ? suyas.map { $0.hasta - pendiente * ($0.x - primera.x) }.min() ?? primera.hasta
                : suyas.map { $0.hasta - pendiente * ($0.x - primera.x) }.max() ?? primera.hasta
            func linea(_ x: Double) -> Double { base + pendiente * (x - primera.x) }
            for i in suyas.indices { suyas[i].hasta = linea(suyas[i].x) }
            for (columna, suya) in zip(columnas, suyas) { plicas[columna][k] = suya }
            // Hacia las notas: la barra de abajo de unas plicas hacia arriba, la de arriba de unas hacia abajo.
            let hacia = arribaDelGrupo ? 1.0 : -1.0
            let maximo = columnas.map { ritmo.barras($0) }.max() ?? 1
            for nivel in 0..<maximo {
                let desplazamiento = hacia * PentagramaSVG.distanciaEntreBarras * Double(nivel)
                let grosor = PentagramaSVG.grosorDeLaBarra
                let arranque = arribaDelGrupo ? 0 : -grosor
                // Las notas seguidas con barras de este nivel van unidas; una sola lleva un trozo hacia la de al lado.
                var i = 0
                while i < columnas.count {
                    guard ritmo.barras(columnas[i]) > nivel else {
                        i += 1
                        continue
                    }
                    var j = i
                    while j + 1 < columnas.count, ritmo.barras(columnas[j + 1]) > nivel { j += 1 }
                    let medio = PentagramaSVG.grosorDeLaPlica / 2
                    var x1 = suyas[i].x - medio
                    var x2 = suyas[j].x + medio
                    if i == j {
                        if i + 1 < columnas.count { x2 = x1 + 1.0 } else { x1 = x2 - 1.0 }
                    }
                    let y1 = linea(x1) + desplazamiento + arranque
                    let y2 = linea(x2) + desplazamiento + arranque
                    barrasSVG.append(rectangulo(x1, y1, x2, y2, grosor: grosor))
                    alcanzar(y1)
                    alcanzar(y1 + grosor)
                    alcanzar(y2)
                    alcanzar(y2 + grosor)
                    i = j + 1
                }
            }
        }

        // Las demás plicas, con su corchete si lo llevan.
        for columna in colocadas.indices {
            for k in 0..<pentagramas where plicas[columna][k] == nil {
                guard let suya = plica(columna, k, arriba: haciaArriba(colocadas[columna].lugares[k])) else {
                    continue
                }
                plicas[columna][k] = suya
                guard ritmo.llevaCorchete(columna) else { continue }
                let corchete: Glifo
                switch (ritmo.barras(columna), suya.arriba) {
                case (1, true): corchete = GlifosSMuFL.corcheteDeCorcheaArriba
                case (1, false): corchete = GlifosSMuFL.corcheteDeCorcheaAbajo
                case (2, true): corchete = GlifosSMuFL.corcheteDeSemicorcheaArriba
                case (2, false): corchete = GlifosSMuFL.corcheteDeSemicorcheaAbajo
                case (_, true): corchete = GlifosSMuFL.corcheteDeFusaArriba
                case (_, false): corchete = GlifosSMuFL.corcheteDeFusaAbajo
                }
                let x = suya.x - PentagramaSVG.grosorDeLaPlica / 2
                trazos.append(
                    elemento("path").con("transform", "translate(\(n(x)) \(n(suya.hasta)))")
                        .con("d", corchete.trazado).vacio)
                alcanzar(suya.hasta + corchete.arriba)
                alcanzar(suya.hasta + corchete.abajo)
            }
        }
        for columna in plicas.indices {
            for case let suya? in plicas[columna] {
                trazos.append(
                    elemento("line").con("x1", suya.x).con("y1", suya.desde).con("x2", suya.x).con("y2", suya.hasta)
                        .con("stroke-width", PentagramaSVG.grosorDeLaPlica).con("stroke", opciones.color).vacio)
                alcanzar(suya.hasta)
            }
        }
        trazos += barrasSVG

        // Las ligaduras: de cada nota a la misma de la columna siguiente, del lado contrario a la plica. La última
        // columna de una línea que sigue en la siguiente lleva media ligadura, hasta el final.
        let ultimaLigada = !conBarraFinal && ritmo.ligadas.last == true ? colocadas.indices.last : nil
        for columna in colocadas.indices where ritmo.ligadas[columna] {
            let siguiente = colocadas.indices.contains(columna + 1) ? colocadas[columna + 1] : nil
            guard siguiente != nil || columna == ultimaLigada else { continue }
            for k in 0..<pentagramas {
                let actual = colocadas[columna]
                let arribaLaPlica = plicas[columna][k]?.arriba ?? haciaArriba(actual.lugares[k])
                for (lugar, midi) in zip(actual.lugares[k], actual.midis[k])
                where siguiente.map({ $0.midis[k].contains(midi) }) ?? true {
                    let lado = arribaLaPlica ? 1.0 : -1.0
                    let y0 = y(lugar, k) + lado * 0.45
                    let x1 = actual.x + actual.anchoDeLaCabeza * 0.75
                    let hastaElFinal = actual.x + actual.anchoDeLaCabeza + 1.6
                    let x2 = siguiente.map { $0.x + $0.anchoDeLaCabeza * 0.25 } ?? hastaElFinal
                    let medio = (x1 + x2) / 2
                    let curva = lado * min(1.0, 0.35 + (x2 - x1) * 0.08)
                    trazos.append(
                        elemento("path").con(
                            "d",
                            "M\(n(x1)) \(n(y0))Q\(n(medio)) \(n(y0 + curva * 2)) \(n(x2)) \(n(y0))"
                                + "Q\(n(medio)) \(n(y0 + curva * 2 - lado * 0.3)) \(n(x1)) \(n(y0))Z"
                        ).vacio)
                    alcanzar(y0 + curva * 1.2)
                }
            }
        }

        // Los tresillos y los demás grupos: su cifra del lado de las plicas, con corchete si las notas no van unidas
        // por una barra.
        for (g, grupo) in ritmo.tresillos.enumerated() {
            guard let primera = grupo.first, let ultima = grupo.last else { continue }
            let k =
                colocadas[primera].lugares.indices.first { !colocadas[primera].lugares[$0].isEmpty } ?? 0
            let suyas = grupo.compactMap { plicas[$0][k] }
            let arribaElNumero = suyas.first?.arriba ?? true
            let inicio = colocadas[primera].x
            let fin = colocadas[ultima].x + colocadas[ultima].anchoDeLaCabeza
            let extremos =
                suyas.map(\.hasta)
                + grupo.flatMap { colocadas[$0].lugares[k].map { y($0, k) } } + [y(arribaElNumero ? 8 : 0, k)]
            let numero = ritmo.cifrasDeLosGrupos.indices.contains(g) ? ritmo.cifrasDeLosGrupos[g] : 3
            let digitos = String(numero).compactMap(\.wholeNumberValue).map { PentagramaSVG.cifrasDeGrupo[$0] }
            // Lo que miden juntas las cifras.
            let glifo = Glifo(
                ancho: digitos.map(\.ancho).reduce(0, +), arriba: digitos.map(\.arriba).reduce(.infinity, min),
                abajo: digitos.map(\.abajo).reduce(-.infinity, max), trazado: "")
            let baseDelNumero =
                arribaElNumero
                ? (extremos.min() ?? 0) - 0.6 - (PentagramaSVG.grosorDeLaBarra / 2)
                : (extremos.max() ?? 4) + 0.6 - glifo.arriba + PentagramaSVG.grosorDeLaBarra / 2
            let centro = (inicio + fin) / 2
            var xDelNumero = centro - glifo.ancho / 2
            for digito in digitos {
                trazos.append(
                    elemento("path").con("transform", "translate(\(n(xDelNumero)) \(n(baseDelNumero)))")
                        .con("d", digito.trazado).vacio)
                xDelNumero += digito.ancho
            }
            alcanzar(baseDelNumero + glifo.arriba)
            alcanzar(baseDelNumero)
            // Sin barra, un corchete partido por el número; si el grupo es tan corto que no cabe, solo el número.
            if !conBarra.contains(grupo), fin - inicio > glifo.ancho + 1.5 {
                let yDelCorchete = baseDelNumero + glifo.arriba / 2
                let gancho = arribaElNumero ? 0.6 : -0.6
                let hueco = glifo.ancho / 2 + 0.25
                for (desde, hasta) in [(inicio, centro - hueco), (centro + hueco, fin)] {
                    let d =
                        desde < centro
                        ? "M\(n(desde)) \(n(yDelCorchete + gancho))V\(n(yDelCorchete))H\(n(hasta))"
                        : "M\(n(desde)) \(n(yDelCorchete))H\(n(hasta))V\(n(yDelCorchete + gancho))"
                    trazos.append(
                        elemento("path").con("d", d).con("fill", "none").con("stroke", opciones.color)
                            .con("stroke-width", "0.12").vacio)
                }
            }
        }
        return (trazos, arriba, abajo, plicas.map { $0.compactMap { $0 }.first?.arriba })
    }
}

extension Voz {
    /// La voz en un pentagrama, como SVG, con su ritmo: cabezas, plicas, corchetes, barras de unión, puntillos,
    /// silencios, ligaduras, tresillos, la cifra del compás y las barras de compás. Las notas se reparten y se ligan
    /// como en `grafia`; las barras de unión son las de `barrasDeAgrupacion`.
    ///
    ///     let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
    ///     let svg = voz.svgPentagrama(titulo: "Arpegio de Do7")
    ///
    /// La clave, la armadura (`.tonalidad`), los pentagramas, los nombres de las notas y la marca de octava son los
    /// de `opciones`; `opciones.resaltada` cuenta las notas que se oyen (sin los silencios ni las notas a las que se
    /// liga otra), como los pasos de lo que suena.
    ///
    /// `acordes` pone el cifrado de cada acorde encima del evento (contado desde 0) en que empieza: en una progresión
    /// arpegiada, encima de la primera nota de cada arpegio. Los intervalos de las notas (`intervalosDeLasNotas`) se
    /// cuentan desde la fundamental del acorde que suena o, sin acordes, desde la tónica de la armadura `.tonalidad`.
    ///
    /// También por evento: `grados` escribe debajo el grado en números romanos (I, V7/V) y `bajoCifrado`, más abajo,
    /// las cifras del bajo continuo («6», «4»); `digitos`, encima, el dedo
    /// de cada nota (de la grave a la aguda; 0, ninguno), y `tablatura`, debajo del pentagrama, la cuerda y el traste.
    /// Una nota que se parte y se liga lleva todo eso solo en su primera parte.
    ///
    /// Con `opciones.compasesPorLinea`, una voz larga va en varias líneas del mismo ancho; con
    /// `svgPentagrama(junto:titulo:acordes:opciones:)`, junto a otra voz en el mismo pentagrama.
    public func svgPentagrama(
        titulo: String, acordes: [Int: Acorde] = [:], grados: [Int: String] = [:],
        bajoCifrado: [Int: [String]] = [:], digitos: [Int: [Int]] = [:], tablatura: Tablatura? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        svgPentagrama(
            titulo: titulo, acordes: acordes, grados: grados, bajoCifrado: bajoCifrado, digitos: digitos,
            tablatura: tablatura, tonica: nil, armadura: nil, opciones: opciones)
    }

    /// El microtono de cada altura de cada evento que se aparta de la temperada (`Evento.desvios`), por evento.
    func microtonosDeLosEventos(en notacion: Notacion) -> [Int: [PentagramaSVG.Microtono?]] {
        var microtonos: [Int: [PentagramaSVG.Microtono?]] = [:]
        for (i, evento) in eventos.enumerated() where evento.esMicrotonal {
            microtonos[i] = evento.alturas.indices.map {
                PentagramaSVG.Microtono.de(
                    evento.alturas[$0], desvio: evento.desvio($0), nota: nil, notacion: notacion)
            }
        }
        return microtonos
    }

    /// Como el público, y con `tonica`, la nota desde la que se cuentan los intervalos si no hay acordes (la de la
    /// escala de una secuencia); si es `nil`, la de la armadura `.tonalidad`. `armadura`, si se da, manda sobre la de
    /// `opciones`. Con `opciones.compasesPorLinea`, en varias líneas (`PentagramaSVG+Lineas.swift`).
    func svgPentagrama(
        titulo: String, acordes: [Int: Acorde], grados: [Int: String], bajoCifrado: [Int: [String]],
        digitos: [Int: [Int]], tablatura: Tablatura?, tonica: Nota?, armadura: [Nota]?,
        opciones: OpcionesDePentagrama, microtonos: [Int: [PentagramaSVG.Microtono?]]? = nil
    ) -> String {
        let anotaciones = AnotacionesDelPentagrama(
            acordes: acordes, grados: grados, bajoCifrado: bajoCifrado, digitos: digitos, tablatura: tablatura,
            microtonos: microtonos)
        let lineas = dibujosPorLinea(
            titulo: titulo, anotaciones: anotaciones, tonica: tonica, armadura: armadura, opciones: opciones)
        return PentagramaSVG.svg(lineas.map { [$0] }, titulo: titulo, tamano: opciones.tamano)
    }

    /// El dibujo de la voz en una línea.
    func pentagrama(
        titulo: String, anotaciones: AnotacionesDelPentagrama, tonica: Nota?, armadura: [Nota]?,
        opciones: OpcionesDePentagrama
    ) -> PentagramaSVG {
        let (ritmo, columnas, primeras) = PentagramaSVG.Ritmo.de(self, resaltada: opciones.resaltada)
        // Lo de cada evento, en la primera columna en que se escribe.
        let porColumna = anotaciones.reasignadas { primeras.indices.contains($0) ? primeras[$0] : nil }
        var cifrados: [Int: String] = [:]
        var referencias: [Int: PentagramaSVG.Referencia] = [:]
        if let tonica {
            referencias[0] = PentagramaSVG.Referencia(tonica)
        } else if case .tonalidad(let tonalidad) = opciones.armadura {
            referencias[0] = PentagramaSVG.Referencia(tonalidad.tonica)
        }
        if let vigente = anotaciones.acordeVigente { referencias[0] = PentagramaSVG.Referencia(vigente) }
        for (columna, acorde) in porColumna.acordes {
            cifrados[columna] = acorde.cifrado(en: opciones.notacion)
            referencias[columna] = PentagramaSVG.Referencia(acorde)
        }
        var dibujo = PentagramaSVG(
            columnas: columnas, armadura: armadura ?? opciones.armadura.notas(), cifrado: nil, titulo: titulo,
            opciones: opciones, ritmo: ritmo, cifrados: cifrados, referencias: referencias
        )
        dibujo.grados = porColumna.grados
        dibujo.bajosCifrados = porColumna.bajoCifrado
        dibujo.digitos = porColumna.digitos
        for (evento, primera) in zip(eventos, primeras) where !evento.articulaciones.isEmpty {
            dibujo.articulaciones[primera] = evento.articulaciones
        }
        dibujo.tablatura = porColumna.tablatura
        // Los microtonos de cada evento, en todas sus columnas (las partes de una nota que se liga, también).
        let porEvento = anotaciones.microtonos ?? microtonosDeLosEventos(en: opciones.notacion)
        if !porEvento.isEmpty {
            dibujo.microtonos = columnas.indices.map { columna in
                let evento = primeras.lastIndex { $0 <= columna } ?? 0
                return porEvento[evento] ?? []
            }
        }
        return dibujo
    }
}
