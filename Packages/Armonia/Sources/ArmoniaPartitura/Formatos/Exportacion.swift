import ArmoniaNucleo
import ArmoniaTeoria

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

    /// Lo que dura el último de `cuantos` acordes de `duracion` para que acabe en la barra.
    package static func hastaLaBarra(_ duracion: Duracion, _ cuantos: Int, _ compas: Compas) -> Duracion {
        hastaLaBarra(Array(repeating: duracion, count: max(0, cuantos)), compas).last ?? duracion
    }

    /// Las duraciones, con la última alargada para que acaben en la barra.
    package static func hastaLaBarra(_ duraciones: [Duracion], _ compas: Compas) -> [Duracion] {
        guard let ultima = duraciones.last else { return duraciones }
        let total = duraciones.reduce(Duracion.cero, +)
        let enCompases = total / compas.duracion
        let resto = total - compas.duracion * (enCompases.numerador / enCompases.denominador)
        return resto.esCero ? duraciones : Array(duraciones.dropLast()) + [ultima + compas.duracion - resto]
    }

    /// Las notas apiladas en posición cerrada: la primera, en la primera octava en que su MIDI
    /// llegue a `minimo`, y cada una, en la primera octava por encima de la anterior.
    package static func posicionCerrada(_ notas: [Nota], desde minimo: Int) -> [Altura] {
        var alturas: [Altura] = []
        for nota in notas {
            let limite = alturas.last.map { $0.midi + 1 } ?? minimo
            var octava = 0
            while Altura(nota, octava: octava).midi < limite { octava += 1 }
            alturas.append(Altura(nota, octava: octava))
        }
        return alturas
    }

    /// Una voz de un coral: una nota por acorde, de `duracion`, y la última de `final`.
    package static func eventos(de alturas: [Altura], duracion: Duracion, final: Duracion) -> [Evento] {
        alturas.enumerated().map { Evento($1, $0 == alturas.count - 1 ? final : duracion) }
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
            superior.append(Evento(alturas: posicionCerrada(acorde.notas, desde: 57), duracion: figura))
            grave.append(Evento(posicionCerrada([acorde.bajo], desde: 41)[0], figura))
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

    /// Comprueba que hay una duración positiva por acorde.
    package static func comprobar(_ duraciones: [Duracion], acordes: Int) {
        precondition(duraciones.count == acordes, "hace falta una duración por acorde")
        precondition(duraciones.allSatisfy { $0 > .cero }, "cada acorde tiene que durar algo")
    }

    /// La figura con que se escribe una duración y, si es de un grupo irregular, la proporción:
    /// 1/12 → corchea de tresillo (3 en el tiempo de 2). Sin figura si no se puede escribir así.
    package static func figura(de duracion: Duracion) -> (
        figura: Figura?, puntillos: Int, irregular: (reales: Int, normales: Int)?
    ) {
        if let (figura, puntillos) = duracion.figuraYPuntillos { return (figura, puntillos, nil) }
        var impar = duracion.denominador
        while impar % 2 == 0 { impar /= 2 }
        guard impar > 1 else { return (nil, 0, nil) }
        var normales = 1
        while normales * 2 < impar { normales *= 2 }
        if let (figura, puntillos) = (duracion * Duracion(impar, normales)).figuraYPuntillos {
            return (figura, puntillos, (impar, normales))
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
                let evento = Evento(
                    alturas: original.alturas, duracion: original.duracion,
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
            return Evento(
                alturas: evento.alturas, duracion: impar > 1 ? parte * Duracion(normales, impar) : parte,
                ligada: ultima ? evento.ligada : !evento.esSilencio)
        }
    }

    /// Una altura escrita sin alteraciones triples, que no tienen todos los formatos: con la nota natural vecina
    /// que suena igual (Fa♯♯♯4 → Sol♯4). La octava es la de la nota natural escrita.
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

    /// Una voz con lo que se anota en ella, para los escritores de texto (LilyPond y ABC).
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

    /// Las voces de un coral repartidas en dos pentagramas, como se escriben: las de la mitad
    /// aguda arriba y las de la grave abajo, de aguda a grave en cada uno. Si comparten
    /// pentagrama, la plica de la de arriba va hacia arriba y la de la de abajo, hacia abajo.
    /// `indice` es el de la voz en el coral (0, el bajo), y el último acorde se alarga hasta la barra.
    package static func voces(de coral: Coral, duracion: Duracion, compas: Compas)
        -> [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)]
    {
        let n = coral.numeroDeVoces
        let agudas = Array((n / 2..<n).reversed())
        let graves = Array((0..<n / 2).reversed())
        let final = hastaLaBarra(duracion, coral.acordes.count, compas)
        var voces: [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)] = []
        for (pentagrama, indices) in [(1, agudas), (2, graves)] {
            for (k, v) in indices.enumerated() {
                let linea = Voz(eventos(de: coral.voz(v), duracion: duracion, final: final), compas: compas)
                voces.append((linea, pentagrama, indices.count == 1 ? nil : k == 0, v))
            }
        }
        return voces
    }

    // MARK: Anotaciones

    /// Lo que se anota en un coral o en una progresión, por el punto en que empieza cada acorde
    /// (contado desde el principio): el acorde que se cifra encima de la voz más aguda y el
    /// análisis que se escribe debajo de la más grave.
    package struct Anotaciones {
        /// La de la armadura.
        package var tonalidad: Tonalidad?
        /// La que se escribe al principio, debajo del bajo, si se analiza.
        package var tonalidadDelAnalisis: Tonalidad?
        package var cifrados: [Duracion: Acorde] = [:]
        package var analisis: [Duracion: AcordeAnalizado] = [:]
    }

    /// Las anotaciones de un coral. Los acordes se identifican por sus notas (con el bajo) entre
    /// los tipos de `TipoDeAcorde.todos`; los que no forman ninguno se quedan sin cifrar. Sin
    /// `tonalidad`, se estima: a partir de los acordes si se analiza, si no, de las notas.
    package static func anotaciones(
        de coral: Coral, duracion: Duracion, tonalidad: Tonalidad?,
        cifrados: Bool, analisis: Bool
    ) -> Anotaciones {
        // Los acordes que se pueden identificar, con su posición en el coral.
        var identificados: [(indice: Int, acorde: Acorde)] = []
        if cifrados || analisis {
            for (i, alturas) in coral.acordes.enumerated() {
                // Solo los tipos del catálogo: un acorde con notas de paso no se cifra como «add♭9».
                if let acorde = Acorde.candidatos(alturas).first(where: { TipoDeAcorde.todos.contains($0.valor.tipo) })?
                    .valor
                {
                    identificados.append((i, acorde))
                }
            }
        }
        let analizado: AnalisisArmonico? =
            analisis
            ? (tonalidad.map { $0.analizar(identificados.map(\.acorde)) }
                ?? AnalisisArmonico.analizar(identificados.map(\.acorde)))
            : nil
        var resultado = Anotaciones()
        resultado.tonalidad =
            tonalidad ?? analizado?.tonalidad ?? Tonalidad.identificar(alturas: coral.acordes.flatMap { $0 }).first
        resultado.tonalidadDelAnalisis = analizado?.tonalidad
        for (k, (i, acorde)) in identificados.enumerated() {
            if cifrados { resultado.cifrados[duracion * i] = acorde }
            if let analizado, k < analizado.acordes.count { resultado.analisis[duracion * i] = analizado.acordes[k] }
        }
        return resultado
    }

    /// Las anotaciones de una progresión ya analizada.
    package static func anotaciones(
        de progresion: AnalisisArmonico, duraciones: [Duracion],
        cifrados: Bool, analisis: Bool
    ) -> Anotaciones {
        var resultado = Anotaciones()
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

/// Lo que comparten `EscritorMusicXML` y `EscritorMEI`: se crean con la cabecera de la partitura, se les añaden
/// voces con lo que se anota en ellas y escriben el documento. Con él, una voz, un coral y una progresión se
/// preparan una sola vez para los dos formatos (`Exportacion.documento`).
package protocol EscritorDePartitura {
    init(
        compas: Compas, anacrusa: Duracion, tonalidad: Tonalidad?, tempo: Tempo?,
        titulo: String?, parte: String, claves: [Clave])

    /// Un texto debajo de un pentagrama, al principio (la tonalidad del análisis).
    var rotulo: (texto: String, pentagrama: Int)? { get set }

    /// Añade una voz, con el cifrado americano de los acordes que empiezan en cada punto encima y su análisis
    /// (cifrado romano y función) debajo. `plicaArriba` es `nil` si la plica va donde toque.
    mutating func anadir(
        _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
        cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion)

    var documento: String { get }
}

extension Exportacion {
    /// Una voz en un solo pentagrama. Sin `tonalidad`, se estima a partir de las notas; sin `clave`, la de sol
    /// o la de fa, según el registro.
    package static func documento<Escritor: EscritorDePartitura>(
        _: Escritor.Type, de voz: Voz, tonalidad: Tonalidad?, clave: Clave?, tempo: Tempo?,
        titulo: String?, parte: String
    ) -> String {
        let armadura = tonalidad ?? Self.tonalidad(de: voz)
        let laClave = clave ?? Clave.masAdecuada(para: voz.eventos.flatMap(\.alturas)) ?? .sol
        var escritor = Escritor(
            compas: voz.compas, anacrusa: voz.anacrusa, tonalidad: armadura,
            tempo: tempo, titulo: titulo, parte: parte, claves: [laClave])
        escritor.anadir(voz, pentagrama: 1, plicaArriba: nil, cifrados: [:], analisis: [:], notacion: .espanolCompacto)
        return escritor.documento
    }

    /// Un coral en dos pentagramas (ver `voces(de:duracion:compas:)`), con los cifrados encima de la voz más aguda
    /// y el análisis debajo de la más grave (ver `anotaciones(de:duracion:tonalidad:cifrados:analisis:)`).
    package static func documento<Escritor: EscritorDePartitura>(
        _: Escritor.Type, de coral: Coral, duracion: Duracion, compas: Compas, tonalidad: Tonalidad?,
        tempo: Tempo?, titulo: String?, parte: String, cifrados: Bool, analisis: Bool, notacion: Notacion
    ) -> String {
        let anotado = Self.anotaciones(
            de: coral, duracion: duracion, tonalidad: tonalidad, cifrados: cifrados, analisis: analisis)
        var escritor = Escritor(
            compas: compas, anacrusa: .cero, tonalidad: anotado.tonalidad,
            tempo: tempo, titulo: titulo, parte: parte, claves: [.sol, .fa])
        if let rotulo = anotado.tonalidadDelAnalisis { escritor.rotulo = (rotulo.nombre(en: notacion) + ":", 2) }
        let n = coral.numeroDeVoces
        for linea in voces(de: coral, duracion: duracion, compas: compas) {
            // Los cifrados, con la voz más aguda; el análisis, con la más grave (si no es también la más aguda).
            let esLaMasAguda = linea.indice == n - 1
            escritor.anadir(
                linea.voz, pentagrama: linea.pentagrama, plicaArriba: linea.plicaArriba,
                cifrados: esLaMasAguda ? anotado.cifrados : [:],
                analisis: linea.indice == 0 && !esLaMasAguda ? anotado.analisis : [:], notacion: notacion)
        }
        return escritor.documento
    }

    /// Una progresión en dos pentagramas: los acordes en posición cerrada, con su cifrado encima, y el bajo, con
    /// el análisis debajo. El último acorde se alarga hasta la barra.
    package static func documento<Escritor: EscritorDePartitura>(
        _: Escritor.Type, de progresion: AnalisisArmonico, duraciones: [Duracion], compas: Compas, tempo: Tempo?,
        titulo: String?, parte: String, cifrados: Bool, analisis: Bool, notacion: Notacion
    ) -> String {
        comprobar(duraciones, acordes: progresion.acordes.count)
        let (superior, grave) = Self.progresion(
            progresion.acordes.map(\.acorde), duraciones: hastaLaBarra(duraciones, compas))
        let anotado = Self.anotaciones(de: progresion, duraciones: duraciones, cifrados: cifrados, analisis: analisis)
        var escritor = Escritor(
            compas: compas, anacrusa: .cero, tonalidad: progresion.tonalidad, tempo: tempo,
            titulo: titulo, parte: parte, claves: [.sol, .fa])
        if let rotulo = anotado.tonalidadDelAnalisis { escritor.rotulo = (rotulo.nombre(en: notacion) + ":", 2) }
        escritor.anadir(
            Voz(superior, compas: compas), pentagrama: 1, plicaArriba: nil,
            cifrados: anotado.cifrados, analisis: [:], notacion: notacion)
        escritor.anadir(
            Voz(grave, compas: compas), pentagrama: 2, plicaArriba: nil,
            cifrados: [:], analisis: anotado.analisis, notacion: notacion)
        return escritor.documento
    }
}
