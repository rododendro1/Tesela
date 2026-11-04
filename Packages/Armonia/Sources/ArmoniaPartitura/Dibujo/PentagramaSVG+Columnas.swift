import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Las columnas, de izquierda a derecha: las notas con sus alteraciones, puntillos, silencios y líneas adicionales, y
// los textos de cada una (nombres, intervalos, grados, bajo cifrado).

extension PentagramaSVG {
    /// Dónde ha quedado cada columna y lo que va con ella, para las pasadas que vienen después.
    struct Maquetacion {
        var etiquetas: [(x: Double, texto: String)] = []
        var intervalos: [(x: Double, texto: String)] = []
        var grados: [(x: Double, texto: String)] = []
        var bajoCifrado: [(x: Double, cifras: [String])] = []
        /// El centro de cada columna, para los dedos y la tablatura.
        var centros: [Double] = []
        var cifrados: [(x: Double, texto: String, mitad: Double)] = []
        /// Para el arco de los semitonos: dónde va la nota de cada columna de una sola nota.
        var notasSueltas: [(x: Double, y: Double, midi: Int)?] = []
        /// El centro de la primera columna, donde va el cifrado.
        var cifradoX: Double?
        /// Por pentagrama: dónde empiezan y acaban sus notas y lo que suben y bajan, para la marca de octava.
        var primeraX: [Double?]
        var ultimaX: [Double]
        var arribaDeLasNotas: [Double]
        var abajoDeLasNotas: [Double]
        var lineasAdicionales: [(pentagrama: Int, lugar: Int, desde: Double, hasta: Double)] = []
        /// Con ritmo: lo que necesitan las plicas y las barras, las barras de compás y lo que se deja detrás de la
        /// última columna.
        var colocadas: [ColumnaColocada] = []
        var barrasDeCompas: [Double] = []
        var ultimaSeparacion = PentagramaSVG.separacionEntreColumnas

        init(pentagramas: Int) {
            primeraX = [Double?](repeating: nil, count: pentagramas)
            ultimaX = [Double](repeating: 0, count: pentagramas)
            arribaDeLasNotas = [Double](repeating: .infinity, count: pentagramas)
            abajoDeLasNotas = [Double](repeating: -.infinity, count: pentagramas)
        }
    }

    /// Las notas, columna a columna. En el pentagrama doble, del Do central para arriba van en el de sol.
    func colocarLasColumnas(
        _ sistema: Sistema, vigentes: [NotaNatural: Int], en lienzo: inout Lienzo
    ) -> Maquetacion {
        var maquetacion = Maquetacion(pentagramas: sistema.claves.count)
        // Altura diatónica (letra y octava) → alteración vigente: «s1» (un sostenido) o el glifo SMuFL de un microtono.
        var enVigor: [Int: String] = [:]
        var ultimaEtiqueta: (centro: Double, mitad: Double)?
        let resaltadas = ritmo?.resaltadas ?? Set(opciones.marcas.resaltada.map { [$0] } ?? [])
        for (columna, alturas) in columnas.enumerated() {
            // Un cambio de clave: la nueva, más pequeña, delante de la columna.
            if sistema.conCambios, columna > 0, sistema.clave(columna, 0) != sistema.clave(columna - 1, 0) {
                let (glifoDeClave, lugarDeClave) = PentagramaSVG.glifoYLugar(de: sistema.clave(columna, 0))
                let escala = PentagramaSVG.escalaDelCambioDeClave
                let y = PentagramaSVG.y(deLugar: lugarDeClave)
                lienzo.minimoY = min(lienzo.minimoY, y + glifoDeClave.arriba * escala)
                lienzo.maximoY = max(lienzo.maximoY, y + glifoDeClave.abajo * escala)
                lienzo.notas.append(
                    elemento("path")
                        .con(
                            "transform",
                            "translate(\(PentagramaSVG.n(lienzo.x)) \(PentagramaSVG.n(y))) scale(\(escala))"
                        )
                        .con("d", glifoDeClave.trazado).vacio)
                lienzo.x += glifoDeClave.ancho * escala + 0.6
            }
            let cabeza = ritmo?.cabeza(columna) ?? GlifosSMuFL.redonda
            let (grupos, anchosDeLasColumnas) = notasDeLaColumna(
                columna, sistema, vigentes: vigentes, enVigor: &enVigor)
            let izquierda =
                anchosDeLasColumnas.reduce(0, +) + PentagramaSVG.huecoEntreColumnasDeAlteraciones
                * Double(max(0, anchosDeLasColumnas.count - 1))
            var xDeLaNota = lienzo.x + izquierda + (anchosDeLasColumnas.isEmpty ? 0 : 0.1)
            let hayDesplazadas = grupos.contains { $0.contains(where: \.desplazada) }
            let puntillos = ritmo?.figuras[columna].puntillos ?? 0
            let silencio = ritmo != nil && alturas.isEmpty ? ritmo?.silencio(columna) : nil
            let ancho =
                (silencio?.glifo.ancho ?? cabeza.ancho * (hayDesplazadas ? 2 : 1))
                + (puntillos > 0 ? 0.2 + 0.5 * Double(puntillos) : 0)
            let textos = textosDeLaColumna(columna)
            // Las etiquetas de las notas no se pisan: si la de esta columna cae demasiado cerca de la anterior, la
            // columna se corre a la derecha.
            if columnas.count > 1, textos.hay, let anterior = ultimaEtiqueta {
                let centroMinimo =
                    anterior.centro + anterior.mitad + textos.mitad + PentagramaSVG.separacionEntreEtiquetas
                xDeLaNota += max(0, centroMinimo - (xDeLaNota + ancho / 2))
            }
            // Lo mismo con los cifrados de una progresión, encima.
            let cifradoDeLaColumna = cifrados[columna]
            let mitadDelCifrado =
                (cifradoDeLaColumna.map {
                    PentagramaSVG.anchoEstimado(
                        $0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado,
                        proporcion: opciones.maquetacion.anchoDeLosCaracteres)
                } ?? 0) / 2
            if cifradoDeLaColumna != nil, let anterior = maquetacion.cifrados.last {
                let centroMinimo = anterior.x + anterior.mitad + mitadDelCifrado + 0.8
                xDeLaNota += max(0, centroMinimo - (xDeLaNota + ancho / 2))
            }
            if xMinimas.indices.contains(columna) { xDeLaNota = max(xDeLaNota, xMinimas[columna]) }

            for (k, notas) in grupos.enumerated() {
                if !notas.isEmpty {
                    if maquetacion.primeraX[k] == nil { maquetacion.primeraX[k] = xDeLaNota }
                    maquetacion.ultimaX[k] = xDeLaNota + ancho
                }
                for nota in notas {
                    let xn = xDeLaNota + (nota.desplazada ? cabeza.ancho : 0)
                    var partes: [String] = []
                    if let alteracion = nota.alteracion {
                        // Cada columna, pegada a la anterior por su borde derecho; la primera, junto a la nota.
                        let anchoDeLasMasCercanas =
                            anchosDeLasColumnas.prefix(nota.columnaDeAlteracion).reduce(0, +)
                            + PentagramaSVG.huecoEntreColumnasDeAlteraciones * Double(nota.columnaDeAlteracion)
                        let xa = xDeLaNota - 0.1 - anchoDeLasMasCercanas - alteracion.ancho
                        lienzo.incluir(alteracion, lugar: nota.lugar, pentagrama: k)
                        partes.append(PentagramaSVG.glifo(alteracion, x: xa, lugar: nota.lugar, pentagrama: k))
                    }
                    lienzo.incluir(cabeza, lugar: nota.lugar, pentagrama: k)
                    let y = PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k)
                    maquetacion.arribaDeLasNotas[k] = min(maquetacion.arribaDeLasNotas[k], y)
                    maquetacion.abajoDeLasNotas[k] = max(maquetacion.abajoDeLasNotas[k], y)
                    partes.append(PentagramaSVG.glifo(cabeza, x: xn, lugar: nota.lugar, pentagrama: k))
                    // Los puntillos, detrás de la cabeza y en un espacio: el de encima, si la nota está en una línea.
                    let lugarDelPuntillo = nota.lugar % 2 == 0 ? nota.lugar + 1 : nota.lugar
                    for p in 0..<puntillos {
                        let xp = xDeLaNota + cabeza.ancho * (hayDesplazadas ? 2 : 1) + 0.25 + 0.5 * Double(p)
                        partes.append(
                            PentagramaSVG.glifo(GlifosSMuFL.puntillo, x: xp, lugar: lugarDelPuntillo, pentagrama: k))
                    }
                    let nombre = nota.microtono?.nombre ?? nota.altura.nombre(en: opciones.notacion)
                    let esTonica =
                        opciones.marcas.tonica
                        && referencia(columna).map { $0.nota.claseDeAltura == nota.altura.nota.claseDeAltura } == true
                    let relleno: String? =
                        resaltadas.contains(columna)
                        ? opciones.colores.resaltado
                        : colorDeNotaAjena(nota.altura.nota, columna) ?? (esTonica ? opciones.colores.tonica : nil)
                    lienzo.notas.append(
                        elemento("g").con("fill", relleno ?? "", si: relleno != nil)
                            .conHijos(elemento("title").conTexto(nombre) + partes.joined()))
                    for lugar in PentagramaSVG.lugaresDeLasLineasAdicionales(de: nota.lugar) {
                        maquetacion.lineasAdicionales.append((k, lugar, xn - 0.4, xn + cabeza.ancho + 0.4))
                    }
                }
            }
            if let silencio {
                // Con dos voces, el silencio de la de arriba sube y el de la de abajo baja.
                let corrido = silencio.lugar + desplazamientoDelSilencio(silencio.glifo)
                lienzo.incluir(silencio.glifo, lugar: corrido, pentagrama: 0)
                var partes = [PentagramaSVG.glifo(silencio.glifo, x: xDeLaNota, lugar: corrido, pentagrama: 0)]
                for p in 0..<puntillos {
                    let xp = xDeLaNota + silencio.glifo.ancho + 0.25 + 0.5 * Double(p)
                    let lugar = 5 + desplazamientoDelSilencio(silencio.glifo)
                    partes.append(PentagramaSVG.glifo(GlifosSMuFL.puntillo, x: xp, lugar: lugar, pentagrama: 0))
                }
                lienzo.notas.append(partes.joined())
            }
            if ritmo != nil {
                maquetacion.colocadas.append(
                    ColumnaColocada(
                        x: xDeLaNota, anchoDeLaCabeza: cabeza.ancho, lugares: grupos.map { $0.map(\.lugar) },
                        midis: grupos.map { $0.map(\.altura.midi) }))
            }
            let centro = xDeLaNota + ancho / 2
            if maquetacion.cifradoX == nil { maquetacion.cifradoX = centro }
            if let etiqueta = textos.etiqueta { maquetacion.etiquetas.append((centro, etiqueta)) }
            if let intervalo = textos.intervalo { maquetacion.intervalos.append((centro, intervalo)) }
            if let grado = textos.grado { maquetacion.grados.append((centro, grado)) }
            if !textos.cifrasDelBajo.isEmpty { maquetacion.bajoCifrado.append((centro, textos.cifrasDelBajo)) }
            maquetacion.centros.append(centro)
            if textos.hay { ultimaEtiqueta = (centro, textos.mitad) }
            if let cifradoDeLaColumna { maquetacion.cifrados.append((centro, cifradoDeLaColumna, mitadDelCifrado)) }
            let suelta = grupos.enumerated().filter { !$0.element.isEmpty }
            if alturas.count == 1, let (k, notas) = suelta.first, let nota = notas.first {
                let y = PentagramaSVG.y(deLugar: nota.lugar, pentagrama: k)
                maquetacion.notasSueltas.append((xDeLaNota + cabeza.ancho / 2, y, nota.altura.midi))
            } else {
                maquetacion.notasSueltas.append(nil)
            }
            maquetacion.ultimaSeparacion = ritmo?.separacion(columna) ?? PentagramaSVG.separacionEntreColumnas
            lienzo.x = xDeLaNota + ancho + maquetacion.ultimaSeparacion
            // La barra de compás, en medio del hueco hasta la nota siguiente; las alteraciones dejan de valer.
            if ritmo?.finesDeCompas.contains(columna) == true {
                lienzo.x -= maquetacion.ultimaSeparacion / 2
                let barra = maquetacion.barrasDeCompas.count
                if barrasMinimas.indices.contains(barra) { lienzo.x = max(lienzo.x, barrasMinimas[barra]) }
                maquetacion.barrasDeCompas.append(lienzo.x)
                lienzo.x += 1.2
                enVigor = [:]
            }
        }
        return maquetacion
    }

    /// Lo que sube (o baja, si es negativo) un silencio de una de dos voces, en lugares: un espacio el de redonda
    /// y el de blanca, dos los demás.
    func desplazamientoDelSilencio(_ glifo: Glifo) -> Int {
        guard let plicasHaciaArriba else { return 0 }
        let largos = [GlifosSMuFL.silencioDeRedonda, GlifosSMuFL.silencioDeBlanca]
        let largo = largos.contains { $0.trazado == glifo.trazado }
        return (plicasHaciaArriba ? 1 : -1) * (largo ? 2 : 4)
    }

    /// Las notas de una columna en cada pentagrama, ordenadas por su lugar, con las segundas desplazadas y las
    /// alteraciones que llevan; y lo que mide de ancho cada columna de alteraciones (la más ancha de sus glifos).
    /// `enVigor` es lo que vale en cada línea o espacio, y se actualiza con las alteraciones de la columna.
    func notasDeLaColumna(
        _ columna: Int, _ sistema: Sistema, vigentes: [NotaNatural: Int], enVigor: inout [Int: String]
    ) -> (grupos: [[NotaColocada]], anchosDeLasColumnas: [Double]) {
        let alturas = columnas[columna]
        let doCentral = PentagramaSVG.doCentral
        // Una nota a la que se liga la de la columna anterior no repite la alteración.
        let ligadaALaAnterior: Set<Int> =
            columna > 0 && ritmo?.ligadas[columna - 1] == true ? Set(columnas[columna - 1].map(\.midi)) : []
        var grupos: [[NotaColocada]] = []
        for k in sistema.claves.indices {
            let delPentagrama = alturas.indices.filter {
                !sistema.doble || (alturas[$0].midi >= doCentral) == (k == 0)
            }
            grupos.append(
                delPentagrama.map { i in
                    let escrita = PentagramaSVG.escrita(alturas[i], octavas: sistema.octavas[k])
                    return NotaColocada(
                        altura: alturas[i], lugar: sistema.clave(columna, k).posicion(de: escrita).lugar,
                        microtono: microtono(columna, i))
                }
                .sorted { ($0.lugar, $0.altura.midi) < ($1.lugar, $1.altura.midi) })
        }
        var anchosDeLasColumnas: [Double] = []
        for k in grupos.indices {
            // Las segundas (y los unísonos con otra alteración) se desplazan a la derecha.
            for i in grupos[k].indices.dropFirst()
            where !grupos[k][i - 1].desplazada && grupos[k][i].lugar - grupos[k][i - 1].lugar <= 1 {
                grupos[k][i].desplazada = true
            }
            // Alteraciones: las que no da la armadura, en columnas a la izquierda sin pisarse.
            var fondoDeLaColumna: [Double] = [] // hasta dónde baja el último glifo de cada columna
            for i in grupos[k].indices.reversed() {
                let semitonos = grupos[k][i].altura.nota.alteracion.semitonos
                // Lo que vale en esa línea o espacio: lo último que se escribió o, si nada, la armadura. Así la
                // bajada de la menor melódica lleva los becuadros que anulan los ♯ de la subida.
                // Un microtono lleva su signo, y la nota siguiente en esa línea vuelve a llevar el suyo.
                let pasos = grupos[k][i].altura.pasos
                guard !ligadaALaAnterior.contains(grupos[k][i].altura.midi) else { continue }
                let signo = grupos[k][i].microtono?.signo
                let propia = signo?.smufl ?? "s\(semitonos)"
                let deLaArmadura = "s\(vigentes[grupos[k][i].altura.nota.natural] ?? 0)"
                guard propia != (enVigor[pasos] ?? deLaArmadura) else { continue }
                enVigor[pasos] = propia
                let glifo = signo?.glifo ?? PentagramaSVG.glifoDeAlteracion(semitonos)
                grupos[k][i].alteracion = glifo
                // Va a la primera columna cuyo último glifo no se le monta por arriba: un bemol baja menos que un
                // sostenido, así que caben más juntos.
                let y = PentagramaSVG.y(deLugar: grupos[k][i].lugar)
                var deLaAlteracion = 0
                while deLaAlteracion < fondoDeLaColumna.count,
                    fondoDeLaColumna[deLaAlteracion] + PentagramaSVG.huecoVerticalEntreAlteraciones > y + glifo.arriba
                { deLaAlteracion += 1 }
                if deLaAlteracion == fondoDeLaColumna.count {
                    fondoDeLaColumna.append(y + glifo.abajo)
                } else {
                    fondoDeLaColumna[deLaAlteracion] = y + glifo.abajo
                }
                grupos[k][i].columnaDeAlteracion = deLaAlteracion
                let anchoDelGlifo = grupos[k][i].alteracion?.ancho ?? 0
                if deLaAlteracion == anchosDeLasColumnas.count {
                    anchosDeLasColumnas.append(anchoDelGlifo)
                } else {
                    anchosDeLasColumnas[deLaAlteracion] = max(anchosDeLasColumnas[deLaAlteracion], anchoDelGlifo)
                }
            }
        }
        return (grupos, anchosDeLasColumnas)
    }

    /// Lo que va debajo de una columna: el nombre de sus notas, su intervalo, su grado y su bajo cifrado.
    struct TextosDeLaColumna {
        let etiqueta: String?
        let intervalo: String?
        let grado: String?
        let cifrasDelBajo: [String]
        /// La mitad de lo que mide el más ancho de ellos.
        let mitad: Double

        var hay: Bool { etiqueta != nil || intervalo != nil || grado != nil || !cifrasDelBajo.isEmpty }
    }

    func textosDeLaColumna(_ columna: Int) -> TextosDeLaColumna {
        let alturas = columnas[columna]
        let etiqueta: String? =
            opciones.marcas.nombresDeLasNotas && !alturas.isEmpty
            ? (columnas.count == 1
                ? alturas.indices.map { nombreDeLaAltura(columna, $0) }.joined(separator: " ")
                : nombreDeLaAltura(columna, 0))
            : nil
        // El intervalo desde la tónica o la fundamental, debajo del nombre (todas las notas, si es un acorde).
        let intervalo: String? =
            opciones.marcas.intervalosDeLasNotas && !alturas.isEmpty
            ? referencia(columna).map { referencia in
                (alturas.count > 1 ? alturas : [alturas[0]]).map { referencia.cifra(de: $0.nota) }
                    .joined(separator: " ")
            } : nil
        let grado = grados[columna]
        let cifrasDelBajo = bajosCifrados[columna] ?? []
        let anchos =
            [etiqueta, intervalo].compactMap { $0 }.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas,
                    proporcion: opciones.maquetacion.anchoDeLosCaracteres)
            }
            + [grado].compactMap { $0 }.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDeLosGrados,
                    proporcion: opciones.maquetacion.anchoDeLosCaracteres)
            }
            + cifrasDelBajo.map {
                PentagramaSVG.anchoEstimado(
                    $0, cuerpoDeLetra: PentagramaSVG.letraDelBajoCifrado,
                    proporcion: opciones.maquetacion.anchoDeLosCaracteres)
            }
        return TextosDeLaColumna(
            etiqueta: etiqueta, intervalo: intervalo, grado: grado, cifrasDelBajo: cifrasDelBajo,
            mitad: anchos.max().map { $0 / 2 } ?? 0)
    }
}
