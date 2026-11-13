import Elementos
import Foundation
import Partituras
import Teoria

// Importación de partituras: ficheros MIDI estándar (LecturaMIDI.swift), MusicXML, sin comprimir
// (LecturaMusicXML.swift) o comprimido (.mxl, LecturaMXL.swift), MEI (LecturaMEI.swift) y ABC
// (LecturaABC.swift), leídos como una lista de notas con su comienzo y su duración.
//
// De ahí salen los acordes que suenan (`acordes(ventana:)`) y su análisis armónico. La reducción
// a acordes es una estimación: la pieza se corta en ventanas de un pulso, en cada una se pesan las
// clases de altura por lo que suenan y se elige la lectura que mejor explica las de más peso,
// dejando fuera, si hace falta, las notas breves (de paso, bordaduras, apoyaturas). Las ventanas
// seguidas con el mismo acorde se funden en uno.
//
// Las repeticiones y los saltos (da capo, dal segno, coda, fine) de MusicXML, MEI y ABC se despliegan en el orden en
// que se tocan (Importacion+Repeticiones.swift). Las notas de adorno van aparte, en `notasDeAdorno`. Se queda fuera,
// por ahora: la percusión y los instrumentos transpositores de MIDI (que ya suenan en su altura).

/// Una nota de una pieza importada: su altura, cuándo empieza y cuánto dura, contado en redondas
/// desde el principio de la pieza, y la parte (pista o pentagrama) de la que viene. Un microtono lleva además su
/// `desvio`: cuántos cents se aparta de su altura temperada (`<alter>-0.5</alter>` en MusicXML, una inflexión de
/// tono en MIDI) y, si su signo lo dice, su `sistema`: el koron y el sori persas, las comas de Arel-Ezgi-Uzdilek,
/// los moria de Wyschnegradsky o las flechas de Helmholtz-Ellis (en MusicXML, el `<accidental>` y su atributo
/// `smufl`; en MEI, `accid`). De MusicXML, MEI y ABC se leen además la dinámica que se marca en la nota y sus
/// articulaciones.
public struct NotaDeLaPieza: Hashable, Sendable {
    public let altura: Altura
    public let inicio: Duracion
    public let duracion: Duracion
    /// La parte de la pieza, contando desde 0: la pista y el canal en MIDI, la parte en MusicXML.
    public let parte: Int
    /// Cents sobre (o bajo) `altura`; 0 si es una nota temperada.
    public let desvio: Double
    /// La teoría en que se escribe el microtono, si la dice su signo (``Evento/NotaDelEvento/sistema``); `nil` si no se
    /// aparta, o si su signo (un medio bemol) o la falta de él no la dicen.
    public let sistema: SistemaDeAlturas?
    /// Los pasos de `sistema` que se aparta (``NotaDeLaAfinacion/ajuste``); 0 si no hay sistema.
    public let ajuste: Int
    /// La dinámica que se marca al empezar la nota, si se marca alguna.
    public let dinamica: Dinamica?
    /// Sus articulaciones, sin repetir y en el orden de `Articulacion.allCases`.
    public let articulaciones: [Articulacion]
    /// El pentagrama de la parte en que se escribe, contando desde 0 (`<staff>1</staff>` en MusicXML es el 0), si el
    /// fichero lo dice.
    public let pentagrama: Int?
    /// La voz en que se escribe (`<voice>` en MusicXML, `<layer n>` en MEI), si el fichero la dice.
    public let voz: Int?

    /// Una nota; `desvio` se redondea a la centésima de cent y las articulaciones se ordenan sin repetir. Como en
    /// `Evento.NotaDelEvento`, una nota que no se aparta no tiene sistema.
    public init(
        altura: Altura, inicio: Duracion, duracion: Duracion, parte: Int = 0, desvio: Double = 0,
        sistema: SistemaDeAlturas? = nil, ajuste: Int = 0, dinamica: Dinamica? = nil,
        articulaciones: [Articulacion] = [], pentagrama: Int? = nil, voz: Int? = nil
    ) {
        let nota = Evento.NotaDelEvento(altura, desvio: desvio, sistema: sistema, ajuste: ajuste)
        self.altura = altura
        self.inicio = inicio
        self.duracion = duracion
        self.parte = parte
        // Redondeado a la centésima de cent, como `Evento.NotaDelEvento.desvio`.
        self.desvio = nota.desvio
        self.sistema = nota.sistema
        self.ajuste = nota.ajuste
        self.dinamica = dinamica
        self.articulaciones = Articulacion.allCases.filter(articulaciones.contains)
        self.pentagrama = pentagrama
        self.voz = voz
    }

    /// La misma nota con otra dinámica: la de una marca que se lee después de la nota (`<dynam>` en MEI).
    func con(dinamica: Dinamica?) -> NotaDeLaPieza {
        NotaDeLaPieza(
            altura: altura, inicio: inicio, duracion: duracion, parte: parte, desvio: desvio, sistema: sistema,
            ajuste: ajuste, dinamica: dinamica, articulaciones: articulaciones, pentagrama: pentagrama, voz: voz)
    }

    /// La misma nota con otra duración: la de una nota ligada a la siguiente, que se alarga con ella.
    func con(duracion: Duracion) -> NotaDeLaPieza {
        NotaDeLaPieza(
            altura: altura, inicio: inicio, duracion: duracion, parte: parte, desvio: desvio, sistema: sistema,
            ajuste: ajuste, dinamica: dinamica, articulaciones: articulaciones, pentagrama: pentagrama, voz: voz)
    }

    /// Cuándo termina.
    public var fin: Duracion { inicio + duracion }

    /// La nota como la de un evento, con su microtono y su sistema: la que se escribe en una voz.
    ///
    ///     let pieza = try PiezaImportada(leyendo: Data(Escala(.re, .sur).partitura().musicXML().utf8))
    ///     pieza.notas[1].nota   // Mi♭4(50¢,persa,1): el Mi koron
    public var nota: Evento.NotaDelEvento {
        Evento.NotaDelEvento(altura, desvio: desvio, sistema: sistema, ajuste: ajuste)
    }
}

/// Una pieza leída de un fichero MIDI, MusicXML, MEI o ABC.
///
///     let pieza = try PiezaImportada(leyendo: Data(contentsOf: URL(fileURLWithPath: "coral.mid")))
///     pieza.tonalidad                 // la de la armadura del fichero, si la tiene
///     pieza.acordes().map(\.cifrado)  // ["Do", "Sol7/Re", "Do/Mi", …]
///     pieza.analisis()?.cifrados      // ["I", "V43", "I6", …]
public struct PiezaImportada: Hashable, Sendable {
    public let titulo: String?
    /// La tonalidad que da la armadura del fichero; `nil` si no tiene.
    public let tonalidad: Tonalidad?
    public let compas: Compas?
    public let tempo: Tempo?
    /// Las notas, ordenadas por su comienzo y, a igual comienzo, de grave a agudo. Con las repeticiones desplegadas:
    /// un compás que se repite da sus notas dos veces, una detrás de otra.
    public let notas: [NotaDeLaPieza]
    /// Las notas de adorno (apoyaturas y mordentes escritos con notas pequeñas), por su comienzo y en el orden en
    /// que se escriben. No duran: cada una empieza donde empieza la nota a la que adorna y su `duracion` es cero. No
    /// cuentan para los acordes.
    public let notasDeAdorno: [NotaDeLaPieza]

    /// Una pieza con esas notas, que se ordenan por su comienzo y, a igual comienzo, de grave a agudo.
    public init(
        titulo: String? = nil, tonalidad: Tonalidad? = nil, compas: Compas? = nil, tempo: Tempo? = nil,
        notas: [NotaDeLaPieza], notasDeAdorno: [NotaDeLaPieza] = []
    ) {
        self.titulo = titulo
        self.tonalidad = tonalidad
        self.compas = compas
        self.tempo = tempo
        self.notas = notas.sorted { ($0.inicio, $0.altura.midi, $0.parte) < ($1.inicio, $1.altura.midi, $1.parte) }
        // Las de adorno, en el orden en que se leen: varias seguidas empiezan todas en el mismo momento.
        self.notasDeAdorno = notasDeAdorno.enumerated().sorted {
            ($0.element.inicio, $0.element.parte, $0.offset) < ($1.element.inicio, $1.element.parte, $1.offset)
        }.map(\.element)
    }

    /// Lee un fichero MIDI estándar, MusicXML (comprimido o no), MEI o ABC, según lo que contenga (no según su
    /// extensión). Lanza `ErrorDeLecturaDeFichero` si no es ninguno de ellos, está dañado o no tiene notas.
    public init(leyendo datos: Data) throws {
        let inicio = [UInt8](datos.prefix(4))
        if inicio == Array("MThd".utf8) {
            try self.init(midi: datos)
        } else if inicio == [0x50, 0x4B, 0x03, 0x04] {
            try self.init(mxl: datos) // un zip: MusicXML comprimido (.mxl)
        } else if PiezaImportada.pareceABC(datos) {
            try self.init(abc: String(decoding: datos, as: UTF8.self))
        } else if String(decoding: datos.prefix(1024), as: UTF8.self).contains("<") {
            // MusicXML o MEI, según su elemento raíz.
            if LectorXML.raiz(de: datos) == "mei" {
                try self.init(mei: datos)
            } else {
                try self.init(musicXML: datos)
            }
        } else {
            throw ErrorDeLecturaDeFichero.formatoDesconocido
        }
    }

    /// Lo que dura la pieza: hasta que termina la última nota.
    public var duracion: Duracion { notas.map(\.fin).max() ?? .cero }

    /// La tonalidad de la armadura o, si el fichero no la da, la que mejor explica las notas
    /// (pesadas por lo que duran).
    public var tonalidadEstimada: Tonalidad? {
        tonalidad
            ?? Tonalidad.identificar(
                midi: notas.map(\.altura.midi),
                duraciones: notas.map(\.duracion.enRedondas)
            ).first
    }

    // MARK: Acordes

    /// Los acordes que suenan, en orden, cada uno desde que cambia la armonía.
    ///
    /// La pieza se corta en ventanas de `ventana` (por omisión, un pulso del compás, o una negra si no hay compás),
    /// y las ventanas seguidas de un mismo compás se agrupan donde la armonía no cambia: se elige el reparto en
    /// tramos que mejor explica lo que suena, y cada tramo nuevo cuesta un poco, así que dos pulsos se juntan si
    /// juntos se leen casi tan bien como por separado (un acorde con una nota de paso en el segundo pulso) y se
    /// separan si no (Do y luego Sol). En cada tramo, cada clase de altura pesa lo que suena dentro de él; el bajo es
    /// la nota más grave que suena al empezar (o la más grave del tramo, si no suena ninguna). Las notas de paso y
    /// las bordaduras de una voz (más breves que la ventana, que no empiezan con ella y a las que se llega y de las
    /// que se sale por grado conjunto) pesan una cuarta parte. Se prueba el conjunto entero y el que queda al quitar
    /// las una o dos clases que menos pesan, y gana la lectura más probable, penalizada por lo que deja fuera. Las
    /// ventanas en silencio o sin lectura posible no dan acorde, y los tramos seguidos con el mismo acorde se funden.
    ///
    /// Los acordes se escriben en `tonalidadEstimada`.
    public func acordes(ventana: Duracion? = nil) -> [Acorde] {
        acordesConInicio(ventana: ventana).map(\.acorde)
    }

    /// Igual que `acordes(ventana:)`, con el momento en que empieza cada acorde.
    public func acordesConInicio(ventana: Duracion? = nil) -> [AcordeConInicio] {
        var paso = ventana ?? compas?.pulso ?? .negra
        guard paso > .cero, !notas.isEmpty else { return [] }
        // Como mucho 100 000 ventanas, aunque una nota dure horas (un fichero dañado, por ejemplo). La ventana se
        // alarga a un múltiplo entero de la de partida: así su denominador no crece y sumarla una y otra vez no
        // desborda las fracciones.
        let maximo = 100_000
        let cuantas = (duracion.enRedondas / paso.enRedondas).rounded(.up)
        if cuantas > Double(maximo) { paso = paso * Int((cuantas / Double(maximo)).rounded(.up)) }
        let tonalidad = tonalidadEstimada
        let factores = factoresMelodicos(paso: paso)

        // Las ventanas, cada una con las notas que suenan en ella.
        var ventanas: [(desde: Duracion, hasta: Duracion, notas: [Int])] = []
        // Hasta dónde llega lo que ha empezado: las notas anteriores a `primera` ya no suenan.
        var finales: [Duracion] = []
        for nota in notas { finales.append(max(finales.last ?? .cero, nota.fin)) }
        var primera = 0
        var desde = Duracion.cero
        let total = duracion
        while desde < total {
            let hasta = desde + paso
            while primera < notas.count, finales[primera] <= desde { primera += 1 }
            var suenan: [Int] = []
            var k = primera
            while k < notas.count, notas[k].inicio < hasta {
                if notas[k].fin > desde { suenan.append(k) }
                k += 1
            }
            ventanas.append((desde, hasta, suenan))
            desde = hasta
        }

        // Las lecturas iguales (un acorde que se mantiene, o una nota de horas) se identifican una vez. Sin esto, una
        // nota larga de un fichero dañado hacía identificar el mismo acorde 100 000 veces.
        var identificados: [VentanaSonora: Candidato<Acorde>?] = [:]
        func lectura(_ i: Int, _ j: Int) -> Candidato<Acorde>? {
            let desde = ventanas[i].desde
            let hasta = ventanas[j].hasta
            var indices = Set<Int>()
            for v in i...j { indices.formUnion(ventanas[v].notas) }
            let suenan = indices.sorted().map { (notas[$0], factores[$0]) }
            guard let sonora = VentanaSonora(suenan, desde: desde, hasta: hasta) else { return nil }
            if let previo = identificados[sonora] { return previo }
            let leido = PiezaImportada.acorde(de: sonora, tonalidad: tonalidad)
            identificados[sonora] = leido
            return leido
        }

        // El mejor reparto en tramos (programación dinámica): `mejor[j]` es el coste de explicar las `j` primeras
        // ventanas, y `desdeDonde[j]`, dónde empieza su último tramo (o `nil` si la ventana `j - 1` no da acorde).
        let porCompas = max(1, (compas ?? .compasillo).duracion.enRedondas / paso.enRedondas).rounded(.down)
        let largoMaximo = Swift.min(8, Swift.max(1, Int(porCompas)))
        let duracionDelCompas = (compas ?? .compasillo).duracion.enRedondas
        func compasDe(_ v: Int) -> Int { Int((ventanas[v].desde.enRedondas / duracionDelCompas + 1e-9).rounded(.down)) }
        let costeDeUnTramo = 0.05
        var mejor = [0.0]
        var desdeDonde: [(inicio: Int, acorde: Acorde)?] = []
        for j in ventanas.indices {
            var elMejor = ElMejor<(inicio: Int, acorde: Acorde)?, Double>()
            if ventanas[j].notas.isEmpty {
                elMejor.proponer(nil, coste: mejor[j])
            } else {
                var i = j
                // Las notas del acorde más rico de las ventanas del tramo: juntarlas no puede dar un acorde con más
                // notas que eso (Do y Sol/Si no se juntan en un Domaj9), solo quitar las de paso.
                var masNotas = 0
                while i >= 0, j - i < largoMaximo, !ventanas[i].notas.isEmpty, compasDe(i) == compasDe(j) {
                    guard let suyo = lectura(i, i) else { break }
                    masNotas = Swift.max(masNotas, suyo.valor.notas.count)
                    if let leido = lectura(i, j), leido.valor.notas.count <= masNotas {
                        // Lo que cuesta la lectura, en cada ventana del tramo: un acorde raro (una novena, una
                        // sexta añadida) que junta dos acordes sencillos cuesta más cuanto más dura.
                        let ventanasDelTramo = Double(j - i + 1)
                        elMejor.proponer(
                            (i, leido.valor), coste: mejor[i] + leido.coste * ventanasDelTramo + costeDeUnTramo)
                    }
                    i -= 1
                }
                // Sin lectura posible, la ventana no da acorde.
                if elMejor.valor == nil { elMejor.proponer(nil, coste: mejor[j]) }
            }
            mejor.append(elMejor.coste ?? mejor[j])
            desdeDonde.append(elMejor.valor ?? nil)
        }
        var tramos: [AcordeConInicio] = []
        var j = ventanas.count
        while j > 0 {
            if let tramo = desdeDonde[j - 1] {
                tramos.append(AcordeConInicio(tramo.acorde, inicio: ventanas[tramo.inicio].desde))
                j = tramo.inicio
            } else {
                j -= 1
            }
        }
        var resultado: [AcordeConInicio] = []
        for tramo in tramos.reversed() where resultado.last?.acorde != tramo.acorde {
            resultado.append(tramo)
        }
        return resultado
    }

    /// Cuánto pesa cada nota en su acorde: 1, o un cuarto si es una nota de paso o una bordadura de su voz (más
    /// breve que `paso`, no empieza en una ventana, y se llega a ella y se sale de ella por grado conjunto, sin
    /// silencio, en su parte, su pentagrama y su voz).
    func factoresMelodicos(paso: Duracion) -> [Double] {
        var factores = Array(repeating: 1.0, count: notas.count)
        for indices in indicesPorLinea {
            for (posicion, k) in indices.enumerated() {
                let nota = notas[k]
                let fraccion = nota.inicio.enRedondas / paso.enRedondas
                guard nota.duracion < paso, fraccion != fraccion.rounded(.down) else { continue }
                // La de antes acaba donde empieza esta, y la de después empieza donde acaba; si hay varias (un
                // acorde en la misma voz), no es una línea y no se toca.
                let antes = indices[..<posicion].filter { notas[$0].fin == nota.inicio }
                let despues = indices[(posicion + 1)...].prefix { notas[$0].inicio <= nota.fin }
                    .filter { notas[$0].inicio == nota.fin }
                let mismoComienzo = indices.filter { notas[$0].inicio == nota.inicio }
                guard antes.count == 1, despues.count == 1, mismoComienzo.count == 1 else { continue }
                let llegada = abs(nota.altura.midi - notas[antes[0]].altura.midi)
                let salida = abs(notas[despues[0]].altura.midi - nota.altura.midi)
                if (1...2).contains(llegada) && (1...2).contains(salida) { factores[k] = 0.25 }
            }
        }
        return factores
    }

    // MARK: Las voces del fichero

    /// Las notas de cada voz del fichero (cada parte, pentagrama y voz que dice), por su posición en `notas` y en el
    /// orden en que empiezan; las voces, de la más grave a la más aguda por su altura media.
    var indicesPorLinea: [[Int]] {
        var porLinea: [[Int]: [Int]] = [:]
        for (k, nota) in notas.enumerated() {
            porLinea[[nota.parte, nota.pentagrama ?? 0, nota.voz ?? 0], default: []].append(k)
        }
        let medias = porLinea.mapValues { $0.map { notas[$0].altura }.midiMedio }
        // A igual altura media, en el orden de las partes, los pentagramas y las voces.
        let claves = porLinea.keys.sorted {
            let (a, b) = (medias[$0] ?? 0, medias[$1] ?? 0)
            return a != b ? a < b : $0.lexicographicallyPrecedes($1)
        }
        return claves.map { porLinea[$0] ?? [] }
    }

    /// Las notas de cada voz del fichero (`indicesPorLinea`), de la más grave a la más aguda.
    var lineas: [[NotaDeLaPieza]] { indicesPorLinea.map { $0.map { notas[$0] } } }

    /// Su ritmo armónico: los acordes con lo que dura cada uno (hasta que empieza el siguiente y, el último, hasta
    /// que acaba la pieza), en su compás (o en 4/4, si no lo dice) y a su tempo. Lo que suena antes del primer
    /// acorde no cuenta.
    ///
    ///     let pieza = try PiezaImportada(leyendo: datos)
    ///     let xml = pieza.ritmoArmonico().partitura().musicXML()
    public func ritmoArmonico(ventana: Duracion? = nil) -> RitmoArmonico {
        let leidos = acordesConInicio(ventana: ventana)
        let fin = duracion
        let conDuracion = leidos.indices.map { i in
            let hasta = i + 1 < leidos.count ? leidos[i + 1].inicio : fin
            return AcordeConDuracion(leidos[i].acorde, hasta - leidos[i].inicio)
        }
        return RitmoArmonico(conDuracion, compas: compas ?? .compasillo, tempo: tempo)
    }

    /// Lo que cuenta de una ventana para leer su acorde: el bajo y cuánto suena cada clase de altura.
    struct VentanaSonora: Hashable {
        let bajo: Int
        let pesos: [Int: Double]

        /// Lo que cuenta de las notas que suenan entre `desde` y `hasta`, cada una con lo que pesa en su acorde.
        init?(_ suenan: [(nota: NotaDeLaPieza, factor: Double)], desde: Duracion, hasta: Duracion) {
            guard !suenan.isEmpty else { return nil }
            let largo = (hasta - desde).enRedondas
            var pesos: [Int: Double] = [:]
            for (nota, factor) in suenan {
                let solapado = (min(nota.fin, hasta) - max(nota.inicio, desde)).enRedondas
                pesos[modulo(nota.altura.midi, 12), default: 0] += factor * min(1, solapado / largo)
            }
            let notas = suenan.map(\.nota)
            let alComienzo = notas.filter { $0.inicio <= desde }
            guard let grave = (alComienzo.isEmpty ? notas : alComienzo).map(\.altura.midi).min() else { return nil }
            self.bajo = modulo(grave, 12)
            self.pesos = pesos
        }
    }

    /// El acorde de una ventana, con lo que cuesta su lectura, o `nil` si no hay ninguna.
    static func acorde(de ventana: VentanaSonora, tonalidad: Tonalidad?) -> Candidato<Acorde>? {
        let bajo = ventana.bajo
        let pesos = ventana.pesos
        // Las demás clases, de más a menos peso (a igual peso, de grave a agudo, para que no dependa del orden).
        let resto = pesos.keys.filter { $0 != bajo }.sorted {
            (-pesos[$0, default: 0], $0) < (-pesos[$1, default: 0], $1)
        }

        var mejor = ElMejor<Acorde, Double>()
        for quitadas in 0...min(2, resto.count) {
            let quedan = Array(resto.dropLast(quitadas))
            guard quedan.count >= min(2, resto.count) else { break }
            // Quitar una nota que suena toda la ventana cuesta 0,8, más que una tensión (0,5): una corchea
            // de paso en una ventana de negra (0,4) se quita, una novena que dura todo el pulso se queda.
            let penalizacion = resto.suffix(quitadas).map { 0.8 * min(1, pesos[$0, default: 0]) }.reduce(0, +)
            guard let candidato = Acorde.candidatos(clasesDeAltura: [bajo] + quedan, tonalidad: tonalidad).first else {
                continue
            }
            let coste = candidato.coste + penalizacion
            mejor.proponer(candidato.valor, coste: coste)
        }
        guard let acorde = mejor.valor, let coste = mejor.coste else { return nil }
        return Candidato(acorde, coste: coste)
    }

    // MARK: Análisis

    /// El recorrido tonal de los acordes (`acordes(ventana:)`): los tramos de la pieza en cada tonalidad, con las
    /// modulaciones y sus acordes pivote. `nil` si no suena ningún acorde. Es lo que da `analisis()` cuando la pieza
    /// no se queda en una tonalidad:
    ///
    ///     let pieza = try PiezaImportada(leyendo: datos)
    ///     // Do Fa Sol7 Do Lam Re7 Sol, un acorde por pulso
    ///     let recorrido = pieza.recorridoTonal()
    ///     recorrido?.tramos.map(\.tonalidad)     // [Do mayor, Sol mayor]
    ///     recorrido?.cifrados                   // ["I", "IV", "V7", "I", "ii", "V7", "I"]
    public func recorridoTonal(ventana: Duracion? = nil) -> RecorridoTonal? {
        RecorridoTonal(acordes(ventana: ventana))
    }

    /// El análisis armónico de los acordes (`acordes(ventana:)`), en `tonalidad` o, si es `nil`, en
    /// la que mejor los explique, toda la pieza en una sola. `nil` si no suena ningún acorde. Con modulaciones,
    /// `recorridoTonal(ventana:)`.
    public func analisis(en tonalidad: Tonalidad? = nil, ventana: Duracion? = nil) -> AnalisisArmonico? {
        let acordes = self.acordes(ventana: ventana)
        guard !acordes.isEmpty else { return nil }
        return tonalidad.map { $0.analizar(acordes) } ?? AnalisisArmonico.analizar(acordes)
    }
}

// MARK: - Errores

/// Por qué no se puede importar un fichero.
public enum ErrorDeLecturaDeFichero: ErrorDeArmonia, Hashable {
    /// No es MIDI ni MusicXML.
    case formatoDesconocido
    /// Es un zip, como el MusicXML comprimido (.mxl), pero está dañado, no tiene partitura o usa una compresión
    /// que no se lee (solo DEFLATE, sin cifrar y sin ZIP64).
    case comprimido
    /// El fichero MIDI está cortado o tiene datos que no siguen el formato.
    case midiDanado
    /// El fichero MIDI cuenta el tiempo en fotogramas SMPTE, no en pulsos por negra.
    case midiConTiempoSMPTE
    /// El XML no está bien formado; `linea` es donde se detuvo la lectura.
    case xmlDanado(linea: Int)
    /// El XML no es una partitura MusicXML por partes (`score-partwise`).
    case noEsMusicXMLPorPartes
    /// El fichero se lee, pero no tiene ninguna nota.
    case sinNotas
    /// Tiene notas, pero no suena ningún acorde (una melodía sola, por ejemplo).
    case sinAcordes

    /// La explicación en el idioma de los textos de la notación.
    public func descripcion(en notacion: Notacion) -> String {
        let textos = TextosDeFormatos.traducidos
        switch self {
        case .formatoDesconocido: return textos.map(\.formatoDesconocido).en(notacion)
        case .comprimido: return textos.map(\.musicXMLComprimido).en(notacion)
        case .midiDanado: return textos.map(\.midiDanado).en(notacion)
        case .midiConTiempoSMPTE: return textos.map(\.midiConTiempoSMPTE).en(notacion)
        case .xmlDanado(let linea): return textos.map { $0.xmlDanado(linea) }.en(notacion)
        case .noEsMusicXMLPorPartes: return textos.map(\.noEsMusicXMLPorPartes).en(notacion)
        case .sinNotas: return textos.map(\.sinNotas).en(notacion)
        case .sinAcordes: return textos.map(\.sinAcordes).en(notacion)
        }
    }
}

// MARK: - Auxiliares

extension Altura {
    /// La altura con esa distancia diatónica a Do4 (`pasos`) y ese número MIDI: (1, 62) → Re4,
    /// (1, 63) → Re♯4. Sirve para transportar una altura escrita sabiendo cuántos pasos y cuántos
    /// semitonos sube.
    package init(pasos: Int, midi: Int) {
        // pasos = 4q + 7o y midi − 60 = 7q + 12o, con determinante −1: siempre hay solución entera.
        let m = midi - 60
        self.init(pasosDeQuinta: 7 * m - 12 * pasos, pasosDeOctava: 7 * pasos - 4 * m)
    }
}
