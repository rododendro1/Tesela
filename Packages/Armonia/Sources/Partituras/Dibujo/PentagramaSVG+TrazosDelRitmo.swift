import Elementos
import Teoria

// Los trazos del ritmo sobre las cabezas ya colocadas: las plicas, las barras de unión, los corchetes, las ligaduras y
// los tresillos, cada parte en su método. `PentagramaSVG.trazosDelRitmo(_:colocadas:pentagramas:)` los llama en orden.

extension PentagramaSVG {
    /// Los trazos del ritmo de un pentagrama, y lo que suben y bajan sobre las líneas. Se dibujan por partes, en el
    /// orden de `PentagramaSVG.trazosDelRitmo(_:colocadas:pentagramas:)`: primero las barras de unión, que fijan las
    /// plicas de sus notas; después las demás plicas, con su corchete; y por último las ligaduras y los tresillos, del
    /// lado que dicen las plicas.
    struct TrazosDelRitmo {
        /// La plica de una columna en un pentagrama: hacia arriba si la nota más alejada de la 3.ª línea está debajo.
        struct Plica {
            var arriba: Bool
            var x: Double
            /// Donde nace (en la nota más alejada del extremo) y donde acaba.
            var desde: Double
            var hasta: Double
        }

        let ritmo: Ritmo
        let colocadas: [ColumnaColocada]
        let pentagramas: Int
        /// Todas las plicas hacia un lado, si se pide (`PentagramaSVG.plicasHaciaArriba`).
        let plicasHaciaArriba: Bool?
        /// Si la línea acaba en una barra final: si no, la última columna ligada lleva media ligadura.
        let conBarraFinal: Bool
        /// El color de las plicas y los corchetes de los grupos.
        let color: String

        /// Lo dibujado, en el orden en que va en el SVG.
        private(set) var trazos: [String] = []
        /// Lo más alto y lo más bajo a que llegan los trazos.
        private(set) var arriba = Double.infinity
        private(set) var abajo = -Double.infinity
        /// La plica de cada columna en cada pentagrama, si la lleva.
        private(set) var plicas: [[Plica?]]
        /// Los grupos de columnas que van unidos por una barra: no llevan el corchete de tresillo.
        private var conBarra: Set<[Int]> = []
        /// Las barras de unión, que van después de las plicas en el SVG.
        private var barrasSVG: [String] = []

        init(
            ritmo: Ritmo, colocadas: [ColumnaColocada], pentagramas: Int, plicasHaciaArriba: Bool?,
            conBarraFinal: Bool, color: String
        ) {
            self.ritmo = ritmo
            self.colocadas = colocadas
            self.pentagramas = pentagramas
            self.plicasHaciaArriba = plicasHaciaArriba
            self.conBarraFinal = conBarraFinal
            self.color = color
            plicas = [[Plica?]](repeating: [Plica?](repeating: nil, count: pentagramas), count: colocadas.count)
        }

        // MARK: Medidas

        private static func n(_ valor: Double) -> String { PentagramaSVG.n(valor) }
        private static func elemento(_ nombre: String) -> ElementoSVG {
            ElementoSVG(nombre, numeros: .hastaTresDecimales)
        }
        private static func y(_ lugar: Int, _ k: Int) -> Double { PentagramaSVG.y(deLugar: lugar, pentagrama: k) }

        private static func rectangulo(
            _ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, grosor: Double
        ) -> String {
            let d = "M\(n(x1)) \(n(y1))L\(n(x2)) \(n(y2))V\(n(y2 + grosor))L\(n(x1)) \(n(y1 + grosor))Z"
            return elemento("path").con("d", d).vacio
        }

        private mutating func alcanzar(_ y: Double) {
            arriba = min(arriba, y)
            abajo = max(abajo, y)
        }

        /// Hacia dónde va la plica de unas notas: hacia arriba si la más alejada de la 3.ª línea está debajo.
        private func haciaArriba(_ lugares: [Int]) -> Bool {
            if let plicasHaciaArriba { return plicasHaciaArriba }
            guard let maximo = lugares.max(), let minimo = lugares.min() else { return true }
            return maximo - 4 < 4 - minimo
        }

        /// La plica de una columna en un pentagrama, hacia un lado, o `nil` si no la lleva.
        private func plica(_ columna: Int, _ k: Int, arriba: Bool) -> Plica? {
            let y = Self.y
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

        // MARK: Barras de unión

        /// Los tramos que van unidos por una barra: cada grupo de `Ritmo.vigas`, en un pentagrama; si sus notas se
        /// reparten entre los dos pentagramas, cada tramo seguido del mismo pentagrama va por su lado.
        private var tramos: [(columnas: [Int], k: Int)] {
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
            return tramos
        }

        /// Las barras de unión de cada tramo, con todas sus plicas hacia el mismo lado y hasta la barra.
        mutating func barrasDeUnion() {
            for (columnas, k) in tramos {
                conBarra.insert(columnas)
                let arribaDelGrupo = haciaArriba(columnas.flatMap { colocadas[$0].lugares[k] })
                var suyas = columnas.compactMap { plica($0, k, arriba: arribaDelGrupo) }
                guard suyas.count == columnas.count, let primera = suyas.first, let ultima = suyas.last,
                    ultima.x > primera.x
                else { continue }
                // La barra, inclinada como las notas pero poco (como mucho, un espacio en todo el grupo), y lo
                // bastante lejos para que ninguna plica quede más corta de lo debido.
                let ancho = ultima.x - primera.x
                let pendiente = max(-1, min(1, ultima.hasta - primera.hasta)) / ancho
                let base =
                    arribaDelGrupo
                    ? suyas.map { $0.hasta - pendiente * ($0.x - primera.x) }.min() ?? primera.hasta
                    : suyas.map { $0.hasta - pendiente * ($0.x - primera.x) }.max() ?? primera.hasta
                func linea(_ x: Double) -> Double { base + pendiente * (x - primera.x) }
                for i in suyas.indices { suyas[i].hasta = linea(suyas[i].x) }
                for (columna, suya) in zip(columnas, suyas) { plicas[columna][k] = suya }
                dibujarLasBarras(de: columnas, plicas: suyas, arriba: arribaDelGrupo, linea: linea)
            }
        }

        /// Las barras de un tramo, nivel a nivel. Las notas seguidas con barras de un nivel van unidas; una sola lleva
        /// un trozo hacia la de al lado. Van hacia las notas: la de abajo de unas plicas hacia arriba, la de arriba de
        /// unas hacia abajo.
        private mutating func dibujarLasBarras(
            de columnas: [Int], plicas suyas: [Plica], arriba arribaDelGrupo: Bool, linea: (Double) -> Double
        ) {
            let hacia = arribaDelGrupo ? 1.0 : -1.0
            let maximo = columnas.map { ritmo.barras($0) }.max() ?? 1
            let grosor = PentagramaSVG.grosorDeLaBarra
            let arranque = arribaDelGrupo ? 0 : -grosor
            for nivel in 0..<maximo {
                let desplazamiento = hacia * PentagramaSVG.distanciaEntreBarras * Double(nivel)
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
                    barrasSVG.append(Self.rectangulo(x1, y1, x2, y2, grosor: grosor))
                    for y in [y1, y1 + grosor, y2, y2 + grosor] { alcanzar(y) }
                    i = j + 1
                }
            }
        }

        // MARK: Plicas y corchetes

        /// Las plicas que no van en una barra, con su corchete si lo llevan; después, todas las plicas y, encima, las
        /// barras de unión.
        mutating func plicasYCorchetes() {
            let n = Self.n
            for columna in colocadas.indices {
                for k in 0..<pentagramas where plicas[columna][k] == nil {
                    guard let suya = plica(columna, k, arriba: haciaArriba(colocadas[columna].lugares[k])) else {
                        continue
                    }
                    plicas[columna][k] = suya
                    guard ritmo.llevaCorchete(columna) else { continue }
                    let corchete = Self.corchete(barras: ritmo.barras(columna), arriba: suya.arriba)
                    let x = suya.x - PentagramaSVG.grosorDeLaPlica / 2
                    trazos.append(
                        Self.elemento("path").con("transform", "translate(\(n(x)) \(n(suya.hasta)))")
                            .con("d", corchete.trazado).vacio)
                    alcanzar(suya.hasta + corchete.arriba)
                    alcanzar(suya.hasta + corchete.abajo)
                }
            }
            for columna in plicas.indices {
                for case let suya? in plicas[columna] {
                    trazos.append(
                        Self.elemento("line").con("x1", suya.x).con("y1", suya.desde).con("x2", suya.x)
                            .con("y2", suya.hasta).con("stroke-width", PentagramaSVG.grosorDeLaPlica)
                            .con("stroke", color).vacio)
                    alcanzar(suya.hasta)
                }
            }
            trazos += barrasSVG
        }

        /// El corchete de una nota suelta: de corchea, de semicorchea o de fusa, hacia arriba o hacia abajo.
        private static func corchete(barras: Int, arriba: Bool) -> Glifo {
            switch (barras, arriba) {
            case (1, true): GlifosSMuFL.corcheteDeCorcheaArriba
            case (1, false): GlifosSMuFL.corcheteDeCorcheaAbajo
            case (2, true): GlifosSMuFL.corcheteDeSemicorcheaArriba
            case (2, false): GlifosSMuFL.corcheteDeSemicorcheaAbajo
            case (_, true): GlifosSMuFL.corcheteDeFusaArriba
            case (_, false): GlifosSMuFL.corcheteDeFusaAbajo
            }
        }

        // MARK: Ligaduras

        /// Las ligaduras: de cada nota a la misma de la columna siguiente, del lado contrario a la plica. La última
        /// columna de una línea que sigue en la siguiente lleva media ligadura, hasta el final.
        mutating func ligaduras() {
            let n = Self.n
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
                        let y0 = Self.y(lugar, k) + lado * 0.45
                        let x1 = actual.x + actual.anchoDeLaCabeza * 0.75
                        let hastaElFinal = actual.x + actual.anchoDeLaCabeza + 1.6
                        let x2 = siguiente.map { $0.x + $0.anchoDeLaCabeza * 0.25 } ?? hastaElFinal
                        let medio = (x1 + x2) / 2
                        let curva = lado * min(1.0, 0.35 + (x2 - x1) * 0.08)
                        trazos.append(
                            Self.elemento("path").con(
                                "d",
                                "M\(n(x1)) \(n(y0))Q\(n(medio)) \(n(y0 + curva * 2)) \(n(x2)) \(n(y0))"
                                    + "Q\(n(medio)) \(n(y0 + curva * 2 - lado * 0.3)) \(n(x1)) \(n(y0))Z"
                            ).vacio)
                        alcanzar(y0 + curva * 1.2)
                    }
                }
            }
        }

        // MARK: Tresillos y demás grupos

        /// Los tresillos y los demás grupos: su cifra del lado de las plicas, con corchete si las notas no van unidas
        /// por una barra.
        mutating func grupos() {
            for (g, grupo) in ritmo.tresillos.enumerated() {
                let numero = ritmo.cifrasDeLosGrupos.indices.contains(g) ? ritmo.cifrasDeLosGrupos[g] : 3
                dibujarElGrupo(grupo, numero: numero)
            }
        }

        /// Un grupo: su cifra, encima o debajo de todo lo que tiene, y si no va en una barra, su corchete partido por
        /// la cifra (si el grupo es tan corto que no cabe, solo la cifra).
        private mutating func dibujarElGrupo(_ grupo: [Int], numero: Int) {
            let n = Self.n
            guard let primera = grupo.first, let ultima = grupo.last else { return }
            let k = colocadas[primera].lugares.indices.first { !colocadas[primera].lugares[$0].isEmpty } ?? 0
            let suyas = grupo.compactMap { plicas[$0][k] }
            let arribaElNumero = suyas.first?.arriba ?? true
            let inicio = colocadas[primera].x
            let fin = colocadas[ultima].x + colocadas[ultima].anchoDeLaCabeza
            let extremos =
                suyas.map(\.hasta)
                + grupo.flatMap { colocadas[$0].lugares[k].map { Self.y($0, k) } } + [Self.y(arribaElNumero ? 8 : 0, k)]
            let cifras = String(numero).compactMap(\.wholeNumberValue).map { PentagramaSVG.cifrasDeGrupo[$0] }
            // Lo que miden juntas las cifras.
            let glifo = Glifo(
                ancho: cifras.map(\.ancho).reduce(0, +), arriba: cifras.map(\.arriba).reduce(.infinity, min),
                abajo: cifras.map(\.abajo).reduce(-.infinity, max), trazado: "")
            let baseDelNumero =
                arribaElNumero
                ? (extremos.min() ?? 0) - 0.6 - (PentagramaSVG.grosorDeLaBarra / 2)
                : (extremos.max() ?? 4) + 0.6 - glifo.arriba + PentagramaSVG.grosorDeLaBarra / 2
            let centro = (inicio + fin) / 2
            var xDelNumero = centro - glifo.ancho / 2
            for digito in cifras {
                trazos.append(
                    Self.elemento("path").con("transform", "translate(\(n(xDelNumero)) \(n(baseDelNumero)))")
                        .con("d", digito.trazado).vacio)
                xDelNumero += digito.ancho
            }
            alcanzar(baseDelNumero + glifo.arriba)
            alcanzar(baseDelNumero)
            guard !conBarra.contains(grupo), fin - inicio > glifo.ancho + 1.5 else { return }
            let yDelCorchete = baseDelNumero + glifo.arriba / 2
            let gancho = arribaElNumero ? 0.6 : -0.6
            let hueco = glifo.ancho / 2 + 0.25
            for (desde, hasta) in [(inicio, centro - hueco), (centro + hueco, fin)] {
                let d =
                    desde < centro
                    ? "M\(n(desde)) \(n(yDelCorchete + gancho))V\(n(yDelCorchete))H\(n(hasta))"
                    : "M\(n(desde)) \(n(yDelCorchete))H\(n(hasta))V\(n(yDelCorchete + gancho))"
                trazos.append(
                    Self.elemento("path").con("d", d).con("fill", "none").con("stroke", color)
                        .con("stroke-width", "0.12").vacio)
            }
        }
    }
}
