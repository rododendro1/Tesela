import Elementos
import Partituras
import Teoria

// Lo que comparten las exportaciones a MusicXML (MusicXML.swift), a MEI (MEI.swift) y a MIDI
// (ArchivoMIDI.swift).

/// Lo que comparten las exportaciones a MusicXML, MEI y MIDI: la tonalidad que se estima, las
/// divisiones del tiempo, las figuras, cómo se preparan las voces de un coral y de una
/// progresión y lo que se anota en ellas.
package enum Exportacion {
    /// La tonalidad que se estima para una voz, por sus notas y lo que duran.
    package static func tonalidad(de voz: Voz) -> Tonalidad? {
        let alturas = voz.eventos.flatMap(\.alturas)
        let duraciones = voz.eventos.flatMap { e in e.alturas.map { _ in e.duracion.enRedondas } }
        return Tonalidad.identificar(alturas: alturas, duraciones: duraciones).first
    }

    /// Divisiones por negra: lo mínimo para que todas las duraciones sean enteras.
    package static func divisiones(_ duraciones: [Duracion]) -> Int {
        duraciones.reduce(1) { resultado, d in
            guard d.numerador > 0 else { return resultado }
            // d en negras = 4·num/den; hace falta que divisiones·4·num/den sea entero.
            let necesario = d.denominador / maximoComunDivisor(4 * d.numerador, d.denominador)
            return resultado / maximoComunDivisor(resultado, necesario) * necesario
        }
    }

    /// Las dos voces de una progresión: los acordes en posición cerrada desde La3 y el bajo
    /// desde Fa2, de `duracion` cada uno, y el último de `final`.
    package static func progresion(_ acordes: [Acorde], duracion: Duracion, final: Duracion) -> (
        acordes: [Evento], bajo: [Evento]
    ) {
        progresion(acordes, duraciones: acordes.indices.map { $0 == acordes.count - 1 ? final : duracion })
    }

    /// Lo mismo, con lo que dura cada acorde.
    package static func progresion(_ acordes: [Acorde], duraciones: [Duracion]) -> (
        acordes: [Evento], bajo: [Evento]
    ) {
        var superior: [Evento] = []
        var grave: [Evento] = []
        for (acorde, figura) in zip(acordes, duraciones) {
            superior.append(Evento(alturas: Altura.posicionCerrada(acorde.notas, desde: 57), duracion: figura))
            grave.append(Evento(Altura.posicionCerrada([acorde.bajo], desde: 41)[0], figura))
        }
        return (superior, grave)
    }

    /// Dónde empieza cada acorde de una progresión, contado desde el principio.
    package static func inicios(_ duraciones: [Duracion]) -> [Duracion] {
        var inicio = Duracion.cero
        return duraciones.map { duracion in
            defer { inicio = inicio + duracion }
            return inicio
        }
    }

    /// La figura con que se escribe una duración y, si es de un grupo irregular, la proporción:
    /// 1/12 → corchea de tresillo (3 en el tiempo de 2). Sin figura si no se puede escribir así.
    package static func figura(de duracion: Duracion) -> (
        figura: Figura?, puntillos: Int, irregular: (reales: Int, normales: Int)?
    ) {
        if let escrita = duracion.figuraYPuntillos { return (escrita.figura, escrita.puntillos, nil) }
        var impar = duracion.denominador
        while impar % 2 == 0 { impar /= 2 }
        guard impar > 1 else { return (nil, 0, nil) }
        var normales = 1
        while normales * 2 < impar { normales *= 2 }
        if let escrita = (duracion * Duracion(impar, normales)).figuraYPuntillos {
            return (escrita.figura, escrita.puntillos, (impar, normales))
        }
        return (nil, 0, nil)
    }

    /// Los grupos irregulares (tresillos…) de los eventos de un compás: los eventos seguidos con la misma proporción,
    /// hasta que lo que suman se puede escribir sin ella (un tresillo de corcheas, al llegar a la negra).
    package static func irregulares(_ eventos: [Evento]) -> [(rango: ClosedRange<Int>, reales: Int, normales: Int)] {
        var grupos: [(rango: ClosedRange<Int>, reales: Int, normales: Int)] = []
        // El grupo abierto: dónde empieza, su proporción y lo que lleva.
        var abierto: (desde: Int, reales: Int, normales: Int, acumulado: Duracion)?
        func cerrar(en i: Int) {
            if let grupo = abierto { grupos.append((grupo.desde...i, grupo.reales, grupo.normales)) }
            abierto = nil
        }
        for (i, evento) in eventos.enumerated() {
            guard let (reales, normales) = figura(de: evento.duracion).irregular else {
                cerrar(en: i - 1)
                continue
            }
            // Todo lo que va dentro de un grupo tiene su proporción: otra abre otro grupo.
            if let grupo = abierto, grupo.reales != reales || grupo.normales != normales { cerrar(en: i - 1) }
            let acumulado = (abierto?.acumulado ?? .cero) + evento.duracion
            abierto = (abierto?.desde ?? i, reales, normales, acumulado)
            if acumulado.denominador & (acumulado.denominador - 1) == 0 || i == eventos.count - 1 { cerrar(en: i) }
        }
        return grupos
    }

    /// Los compases de la grafía de una voz (`Voz.grafia`) para los formatos de texto, con dónde empieza cada evento
    /// desde el principio de la voz y si es nuevo: si no lo es, sigue ligado al anterior con las mismas notas, y no
    /// lleva anotaciones.
    ///
    /// Lo que no se puede escribir con una figura se parte en figuras ligadas (5/16 → corchea con puntillo ligada a
    /// corchea; 5/12 → negra ligada a corchea, de tresillo), y la ligadura de un evento solo se escribe si el
    /// siguiente tiene alguna de sus notas.
    package static func compases(de voz: Voz) -> [[(evento: Evento, inicio: Duracion, nuevo: Bool)]] {
        let partidos = voz.grafia.map { $0.flatMap(escribibles) }
        let todos = partidos.joined().map { $0 }
        var k = 0
        var inicio = Duracion.cero
        var ligadas: [Altura] = []
        return partidos.map { eventos in
            eventos.map { original in
                let siguiente = k + 1 < todos.count ? todos[k + 1].alturas : []
                let evento = original.con(
                    duracion: original.duracion,
                    ligada: original.ligada && original.alturas.contains(where: siguiente.contains))
                defer {
                    k += 1
                    inicio = inicio + evento.duracion
                    ligadas = evento.ligada ? evento.alturas : []
                }
                return (evento, inicio, ligadas.isEmpty || evento.alturas != ligadas)
            }
        }
    }

    /// Un evento como figuras que se pueden escribir, ligadas entre sí: el mismo si ya tiene figura (con o sin
    /// grupo irregular) y como mucho dos puntillos, que es lo que admiten todos los formatos.
    private static func escribibles(_ evento: Evento) -> [Evento] {
        let actual = figura(de: evento.duracion)
        guard actual.figura == nil || actual.puntillos > 2 else { return [evento] }
        // En un grupo irregular, las figuras de lo que dura escrito, y cada una devuelta a su proporción.
        var impar = evento.duracion.denominador
        while impar % 2 == 0 { impar /= 2 }
        var normales = 1
        while normales * 2 < impar { normales *= 2 }
        let escrita = evento.duracion * Duracion(impar, normales)
        // Figuras sin puntillo, de mayor a menor, como `Duracion.descomposicion`, también si ya tiene figura.
        var resto = impar > 1 ? escrita : evento.duracion
        var partes: [Duracion] = []
        for figura in Figura.allCases {
            while figura.duracion <= resto {
                partes.append(figura.duracion)
                resto = resto - figura.duracion
            }
        }
        guard resto.esCero, partes.count > 1 else { return [evento] }
        return partes.enumerated().map { i, parte in
            let ultima = i == partes.count - 1
            let escrito = evento.con(
                duracion: impar > 1 ? parte * Duracion(normales, impar) : parte,
                ligada: ultima ? evento.ligada : !evento.esSilencio)
            // La dinámica y las articulaciones, solo en la primera figura.
            return i == 0 ? escrito : escrito.sinExpresion
        }
    }

    /// Una altura escrita sin alteraciones triples, que no tienen todos los formatos: con la nota natural vecina
    /// que suena igual (Fa𝄪♯4 → Sol♯4). La octava es la de la nota natural escrita.
    package static func sinTriples(_ altura: Altura) -> (natural: NotaNatural, semitonos: Int, octava: Int) {
        let escala = [0, 2, 4, 5, 7, 9, 11]
        var natural = altura.nota.natural.rawValue
        var octava = altura.octava
        var semitonos = altura.nota.alteracion.semitonos
        while semitonos > 2 {
            let siguiente = (natural + 1) % 7
            semitonos -= (escala[siguiente] - escala[natural] + 12) % 12
            if siguiente == 0 { octava += 1 }
            natural = siguiente
        }
        while semitonos < -2 {
            let anterior = (natural + 6) % 7
            semitonos += (escala[natural] - escala[anterior] + 12) % 12
            if natural == 0 { octava -= 1 }
            natural = anterior
        }
        return (NotaNatural(rawValue: natural)!, semitonos, octava)
    }

    /// Una voz con lo que se anota en ella, para los escritores que la guardan así (`EscritorDeLineas`: ABC,
    /// LilyPond, GUIDO y MEI).
    package struct LineaAnotada {
        package let voz: Voz
        package let pentagrama: Int
        /// `nil` si la plica va donde toque; si no, hacia arriba o hacia abajo.
        package let plicaArriba: Bool?
        /// El cifrado que se escribe encima de la nota que empieza en cada punto de la voz.
        package let cifrados: [Duracion: String]
        /// Las líneas de texto que se escriben debajo de la nota que empieza en cada punto.
        package let letras: [Duracion: [String]]

        package init(
            _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
            cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion
        ) {
            self.voz = voz
            self.pentagrama = pentagrama
            self.plicaArriba = plicaArriba
            self.cifrados = cifrados.mapValues { $0.cifrado(en: notacion) }
            self.letras = analisis.mapValues(Exportacion.letras)
        }
    }

    // MARK: Anotaciones

    /// Las anotaciones de una progresión ya analizada.
    package static func anotaciones(
        de progresion: AnalisisArmonico, duraciones: [Duracion],
        cifrados: Bool, analisis: Bool
    ) -> AnotacionesDeAcordes {
        var resultado = AnotacionesDeAcordes()
        resultado.tonalidad = progresion.tonalidad
        if analisis { resultado.tonalidadDelAnalisis = progresion.tonalidad }
        for (inicio, analizado) in zip(inicios(duraciones), progresion.acordes) {
            if cifrados { resultado.cifrados[inicio] = analizado.acorde }
            if analisis { resultado.analisis[inicio] = analizado }
        }
        return resultado
    }

    /// Los textos de análisis de un acorde: el cifrado romano y la abreviatura de la función.
    package static func letras(_ analizado: AcordeAnalizado) -> [String] {
        [analizado.cifrado, analizado.funcion?.abreviatura ?? ""]
    }

    /// Un número sin decimales si es entero: 90 → "90", 92.5 → "92.5".
    package static func formatear(_ valor: Double) -> String {
        valor == valor.rounded() ? String(Int(valor)) : String(valor)
    }
}

// MARK: - Escritores

/// Lo que comparten los escritores de MusicXML, MEI, LilyPond, GUIDO y ABC: se crean con la cabecera de la
/// partitura, se les añaden voces con lo que se anota en ellas y escriben el documento. Con él, una voz, un coral y
/// una progresión se preparan una sola vez para todos los formatos (`Exportacion.documento(_:de:)`).
/// Lo que un escritor sabe de la partitura antes de sus voces: el compás y la anacrusa, la tonalidad y el tempo del
/// encabezado, el título, el nombre de la parte y la clave de cada pentagrama.
package struct CabeceraDePartitura {
    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
}

/// Un texto debajo de un pentagrama, al principio: la tonalidad del análisis. Los pentagramas se cuentan desde 1.
package struct Rotulo {
    package let texto: String
    package let pentagrama: Int
}

package protocol EscritorDePartitura {
    init(cabecera: CabeceraDePartitura)
    var cabecera: CabeceraDePartitura { get }

    /// Un texto debajo de un pentagrama, al principio (la tonalidad del análisis).
    var rotulo: Rotulo? { get set }

    /// Añade una voz, con el cifrado americano de los acordes que empiezan en cada punto encima y su análisis
    /// (cifrado romano y función) debajo. `plicaArriba` es `nil` si la plica va donde toque.
    mutating func anadir(
        _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
        cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion)

    /// Añade la voz otra vez en un pentagrama de tablatura, debajo de los demás, con lo que se pulsa en cada nota.
    /// Solo lo escribe MusicXML; los demás formatos no tienen tablatura y no hacen nada.
    mutating func anadirTablatura(
        _ voz: Voz, pulsaciones: [Duracion: [Tablatura.Pulsacion]], cuerdas: Int, afinacion: [Altura]?, capo: Int?)

    var documento: String { get }
}

extension EscritorDePartitura {
    package var compas: Compas { cabecera.compas }
    package var anacrusa: Duracion { cabecera.anacrusa }
    package var tonalidad: Tonalidad? { cabecera.tonalidad }
    package var tempo: Tempo? { cabecera.tempo }
    package var titulo: String? { cabecera.titulo }
    package var parte: String { cabecera.parte }
    package var claves: [Clave] { cabecera.claves }

    package mutating func anadirTablatura(
        _ voz: Voz, pulsaciones: [Duracion: [Tablatura.Pulsacion]], cuerdas: Int, afinacion: [Altura]?, capo: Int?
    ) {}
}

extension Exportacion {
    /// La partitura en el formato de `Escritor`: cada pentagrama con su clave (la que pidan sus notas si no lleva
    /// ninguna), cada voz en el suyo con sus cifrados y su análisis, y la tonalidad del análisis debajo del último.
    /// En MusicXML, la tablatura de un pentagrama con `numeroDeCuerdas` va en un pentagrama de tablatura debajo de todos.
    package static func documento<Escritor: EscritorDePartitura>(
        _: Escritor.Type, de partitura: Partitura
    ) -> String {
        let encabezado = partitura.encabezado
        var escritor = Escritor(
            cabecera: CabeceraDePartitura(
                compas: partitura.compas, anacrusa: partitura.anacrusa, tonalidad: encabezado.tonalidad,
                tempo: encabezado.tempo, titulo: encabezado.titulo(en: partitura.notacion),
                parte: partitura.nombreDeLaParte, claves: partitura.pentagramas.map(\.claveEscrita)))
        if let rotulo = partitura.tonalidadDelAnalisis {
            escritor.rotulo = Rotulo(
                texto: rotulo.nombre(en: partitura.notacion) + ":", pentagrama: partitura.pentagramas.count)
        }
        // Los escritores cuentan los pentagramas desde 1, como `<staff>` en MusicXML.
        for (linea, pentagrama) in partitura.lineas.map({ ($0.linea, $0.pentagrama) }) {
            escritor.anadir(
                linea.voz, pentagrama: pentagrama + 1, plicaArriba: linea.plicaArriba, cifrados: linea.cifrados,
                analisis: linea.analisis, notacion: partitura.notacion)
        }
        // La tablatura de cada pentagrama que la lleva, con lo que se pulsa en su primera voz.
        for pentagrama in partitura.pentagramas {
            guard let cuerdas = pentagrama.numeroDeCuerdas, cuerdas > 0, let primera = pentagrama.voces.first else {
                continue
            }
            escritor.anadirTablatura(
                primera.voz, pulsaciones: primera.pulsaciones, cuerdas: cuerdas, afinacion: pentagrama.afinacion,
                capo: pentagrama.capo)
        }
        return escritor.documento
    }
}
