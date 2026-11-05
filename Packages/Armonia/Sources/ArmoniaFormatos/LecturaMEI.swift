import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Lectura de MEI (Music Encoding Initiative), versiones 3 a 5: lo que exportan Verovio, mei-friend, Sibelius (con su
// complemento), MuseScore 4 y `mei()`.
//
// Se leen las notas (`<note>`), los acordes (`<chord>`), los silencios y los huecos (`<rest>`, `<space>`, `<mRest>`,
// `<mSpace>`), los grupos irregulares (`<tuplet>`), los puntillos (`dots` o `<dot/>`), las ligaduras (`tie`), cada
// pentagrama como una parte y cada capa (`<layer>`) desde el principio del compás. La duración exacta es la de
// `dur.ppq` cuando el pentagrama da sus divisiones (`ppq`) y, si no, la de la figura.
//
// La alteración que suena es `accid.ges` o, si no está, la escrita (`accid`); si no hay ninguna, la que vale en el
// compás o en la armadura. Los cuartos de tono (`1qf`, `3qs`…), el koron y el sori y las comas de Arel-Ezgi-Uzdilek
// (`kf`, `bs`…) se leen con su desvío en cents. Los instrumentos transpositores (`trans.diat`, `trans.semi`) se leen
// como suenan. Las notas de adorno (`grace`) van aparte, sin duración. Las repeticiones (`left` y `right` de
// `<measure>`: `rptstart`, `rptend`, `rptboth`), las casillas (`<ending>`) y los saltos (`<repeatMark>` y los textos
// de `<dir>`: «D.C.», «D.S.», «Fine», «To Coda») se despliegan. Del principio: el título, la armadura, el compás y el
// tempo (`midi.bpm`). De cada nota o acorde, sus articulaciones (`artic`, `<artic>`, `fermata`) y su dinámica
// (`<dynam>` con `startid`).

extension PiezaImportada {
    /// Lee una partitura MEI.
    ///
    ///     let mei = coral.partitura(duracion: .blanca).mei()
    ///     let pieza = try PiezaImportada(mei: Data(mei.utf8))
    public init(mei datos: Data) throws {
        let lector = LectorMEI()
        try LectorXML.leer(datos, con: lector)
        guard lector.raiz == "mei" else { throw ErrorDeLecturaDeFichero.noEsMusicXMLPorPartes }
        guard !lector.notas.isEmpty else { throw ErrorDeLecturaDeFichero.sinNotas }
        let fin = PulsosDeLectura.duracion(lector.finDeLaPieza)
        self.init(
            titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas, tempo: lector.tempo,
            notas: CompasLeido.desplegar(lector.notas, compases: lector.compases, fin: fin),
            notasDeAdorno: CompasLeido.desplegar(lector.adornos, compases: lector.compases, fin: fin))
    }
}

/// El tiempo de los formatos de texto (MEI y ABC) en pulsos enteros, para que sumar duraciones no desborde las
/// fracciones: 322 560 por redonda, que dividen la redonda hasta la garrapatea de la garrapatea (1/1024) y los
/// grupos de 3, 5, 7 y 9.
enum PulsosDeLectura {
    static let porRedonda = 322_560
    /// Hasta dónde se lee: unas 200 000 redondas, horas de música. Lo que empieza después no se lee, para que las
    /// cuentas con las duraciones no desborden.
    static let limite = 1 << 36

    /// Los pulsos de una duración, redondeados.
    static func de(_ duracion: Duracion) -> Int {
        Int((Double(duracion.numerador) * Double(porRedonda) / Double(duracion.denominador)).rounded())
    }

    static func duracion(_ pulsos: Int) -> Duracion { Duracion(pulsos, porRedonda) }

    /// La duración en pulsos de una figura de MEI o ABC (`1` redonda, `4` negra, `breve`, `long`) con sus puntillos.
    static func figura(_ valor: String, puntillos: Int) -> Int? {
        let redondas: Duracion
        switch valor {
        case "maxima": redondas = Duracion(8)
        case "long": redondas = Duracion(4)
        case "breve": redondas = Duracion(2)
        default:
            guard let n = Int(valor), [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048].contains(n) else {
                return nil
            }
            redondas = Duracion(1, n)
        }
        guard (0...4).contains(puntillos) else { return nil }
        return de(redondas * Duracion((1 << (puntillos + 1)) - 1, 1 << puntillos))
    }
}

/// Los cents sobre la nota natural de una alteración de MEI: «s» 100, «ff» −200, «1qf» −50, «kf» una coma
/// (1200/53 cents) menos. `nil` si no es una alteración.
func centsDeAlteracionMEI(_ valor: String) -> Double? {
    let coma = 1200.0 / 53
    let tabla: [String: Double] = [
        "n": 0, "s": 100, "f": -100, "ss": 200, "x": 200, "ff": -200, "xs": 300, "sx": 300, "ts": 300, "tf": -300,
        "nf": -100, "ns": 100, "1qf": -50, "3qf": -150, "1qs": 50, "3qs": 150, "koron": -50, "sori": 50,
        "ks": coma, "kf": -coma, "bs": 4 * coma, "bf": -4 * coma, "kms": 5 * coma, "kmf": -5 * coma,
        "bms": 8 * coma, "bmf": -8 * coma,
    ]
    return tabla[valor]
}

/// La alteración en semitonos y el desvío en cents de unos cents sobre la natural: el semitono más cercano y, a medio
/// camino, el de abajo, como el `<alter>` de MusicXML (−50 es un bemol y 50 cents).
func alteracionYDesvio(cents: Double) -> (semitonos: Int, desvio: Double) {
    let semitonos = (cents / 100 - 0.5).rounded(.up)
    return (Int(semitonos), cents - 100 * semitonos)
}

/// Recorre el documento elemento a elemento y va colocando las notas en el tiempo.
final class LectorMEI: LectorDeElementosXML {
    private(set) var raiz: String?
    private(set) var titulo: String?
    private(set) var tonalidad: Tonalidad?
    private(set) var compas: Compas?
    private(set) var tempo: Tempo?
    private(set) var notas: [NotaDeLaPieza] = []
    private(set) var adornos: [NotaDeLaPieza] = []
    /// Los compases, con sus repeticiones y sus saltos.
    private(set) var compases: [CompasLeido] = []
    /// Donde acaba el último compás, en pulsos.
    private(set) var finDeLaPieza = 0
    /// Los números del `<ending>` abierto.
    private var casillas: Set<Int>?
    /// Si el compás anterior acababa en `rptboth`: el siguiente abre una repetición.
    private var abreElSiguiente = false

    private var pila: [String] = []
    private var contenido = ""

    /// Lo que se sabe de cada pentagrama, por su `n`.
    private struct Pentagrama {
        var parte: Int
        var ppq: Int?
        var transposicion: (pasos: Int, semitonos: Int)?
    }
    private var pentagramas: [String: Pentagrama] = [:]
    private var armadura: [NotaNatural: Int] = [:]
    /// Lo que dura un compás entero (para `<mRest>`), en pulsos.
    private var duracionDelCompas = PulsosDeLectura.porRedonda

    // El compás, el pentagrama y la capa en curso.
    private var inicioDelCompas = 0
    private var finDelCompas = 0
    private var pentagrama: Pentagrama?
    private var nombreDelPentagrama = "1"
    private var posicion = 0
    /// El `n` de la capa en curso: la voz de sus notas.
    private var capa: Int?
    /// Las alteraciones escritas en el compás, por pentagrama y lugar (octava y nota natural), en cents y con su
    /// signo, si es microtonal.
    private var vigentes: [String: (cents: Double, signo: SignoMicrotonal?)] = [:]
    /// Los grupos irregulares abiertos: lo que dura cada figura, en proporción.
    private var irregulares: [(normales: Int, reales: Int)] = []

    /// Un acorde o una nota sueltos, con lo que se va leyendo de sus hijos.
    private struct Evento {
        var figura: String?
        var puntillos = 0
        var pulsosExactos: Int?
        var sinTiempo = false
        var id: String?
        var articulaciones: [Articulacion] = []
    }
    private var acorde: Evento?
    private var inicioDelAcorde = 0
    private var evento = Evento()
    private var nota = NotaLeida()

    private struct NotaLeida {
        var paso: NotaNatural?
        var octava: Int?
        var escrita: Double?
        var sonora: Double?
        /// Los signos microtonales de `escrita` y de `sonora` (el koron, una koma), si lo son.
        var signoEscrito: SignoMicrotonal?
        var signoSonoro: SignoMicrotonal?
        var ligaduraQueEmpieza = false
        var ligaduraQueAcaba = false
        var id: String?
        var articulaciones: [Articulacion] = []
    }
    /// Las notas con una ligadura que sigue, por parte y altura MIDI: su índice en `notas`.
    private var ligadas: [Int: Int] = [:]
    /// Las notas que se han colocado de cada nota o acorde, por su `xml:id`: a ellas va la dinámica de `<dynam>`.
    private var notasPorId: [String: [Int]] = [:]
    /// El `startid` del `<dynam>` que se está leyendo.
    private var inicioDeLaDinamica: String?

    /// Los valores de `artic` de MEI.
    private static let valoresDeArtic: [String: Articulacion] = [
        "stacc": .staccato, "stacciss": .staccatissimo, "spicc": .staccatissimo, "ten": .tenuto, "acc": .acento,
        "marc": .marcato,
    ]

    /// Las articulaciones de los atributos `artic` (separadas por espacios) y `fermata` de un elemento.
    private static func articulaciones(_ atributos: [String: String]) -> [Articulacion] {
        let leidas = (atributos["artic"] ?? "").split(separator: " ").compactMap { valoresDeArtic[String($0)] }
        let ornamentos = (atributos["ornam"] ?? "").compactMap { letra in
            Articulacion.allCases.first { EscritorMEI.ornam($0) == String(letra) }
        }
        return leidas + (atributos["fermata"] != nil ? [.calderon] : []) + ornamentos
    }

    func abre(_ nombre: String, atributos: [String: String]) {
        if raiz == nil { raiz = nombre }
        defer { pila.append(nombre) }
        contenido = ""
        switch nombre {
        case "scoreDef", "staffDef":
            definicion(atributos)
            if nombre == "staffDef", let n = atributos["n"] {
                var suyo = pentagramas[n] ?? Pentagrama(parte: pentagramas.count)
                if let ppq = atributos["ppq"].flatMap(Int.init), ppq > 0, ppq <= 100_000 { suyo.ppq = ppq }
                let pasos = atributos["trans.diat"].flatMap(Int.init) ?? 0
                let semitonos = atributos["trans.semi"].flatMap(Int.init) ?? 0
                if abs(pasos) <= 100, abs(semitonos) <= 200, pasos != 0 || semitonos != 0 {
                    suyo.transposicion = (pasos, semitonos)
                }
                pentagramas[n] = suyo
            }
        case "keySig":
            definicion(["keysig": atributos["sig"] ?? "", "key.mode": atributos["mode"] ?? ""])
        case "meterSig":
            definicion(["meter.count": atributos["count"] ?? "", "meter.unit": atributos["unit"] ?? ""])
        case "tempo":
            definicion(["midi.bpm": atributos["midi.bpm"] ?? ""])
        case "measure":
            posicion = inicioDelCompas
            finDelCompas = inicioDelCompas
            vigentes = [:]
            var leido = CompasLeido(inicio: PulsosDeLectura.duracion(inicioDelCompas))
            let izquierda = atributos["left"] ?? ""
            let derecha = atributos["right"] ?? ""
            leido.abreRepeticion = abreElSiguiente || izquierda == "rptstart" || izquierda == "rptboth"
            if derecha == "rptend" || derecha == "rptboth" {
                leido.cierraRepeticion = 2
            }
            if izquierda == "rptend" || izquierda == "rptboth", !compases.isEmpty {
                compases[compases.count - 1].cierraRepeticion = 2
            }
            abreElSiguiente = derecha == "rptboth"
            leido.casillas = casillas ?? []
            compases.append(leido)
        case "ending":
            casillas = LectorMusicXML.numerosDeCasilla(atributos["n"] ?? atributos["label"] ?? "1")
        case "repeatMark":
            marcar { compas in
                switch atributos["func"] {
                case "daCapo": compas.daCapo = true
                case "dalSegno": compas.dalSegno = true
                case "segno": compas.segno = true
                case "coda": compas.coda = true
                case "fine": compas.fine = true
                default: break
                }
            }
        case "staff":
            nombreDelPentagrama = atributos["n"] ?? "1"
            if pentagramas[nombreDelPentagrama] == nil {
                pentagramas[nombreDelPentagrama] = Pentagrama(parte: pentagramas.count)
            }
            pentagrama = pentagramas[nombreDelPentagrama]
        case "layer":
            posicion = inicioDelCompas
            capa = atributos["n"].flatMap { Int($0) }.flatMap { (1...64).contains($0) ? $0 : nil }
        case "tuplet":
            let reales = atributos["num"].flatMap(Int.init) ?? 3
            let normales = atributos["numbase"].flatMap(Int.init) ?? 2
            // Como mucho cuatro grupos uno dentro de otro, de hasta 64 figuras.
            irregulares.append(
                (1...64).contains(reales) && (1...64).contains(normales) && irregulares.count < 4
                    ? (normales, reales) : (1, 1))
        case "chord":
            acorde = leerEvento(atributos)
            inicioDelAcorde = posicion
        case "note":
            if acorde == nil { evento = leerEvento(atributos) }
            nota = NotaLeida()
            nota.paso = atributos["pname"].flatMap {
                ["c", "d", "e", "f", "g", "a", "b"].firstIndex(of: $0.lowercased()).flatMap(NotaNatural.init(rawValue:))
            }
            nota.octava = atributos["oct"].flatMap(Int.init).flatMap { abs($0) <= 20 ? $0 : nil }
            alteraciones(atributos)
            let ligadura = atributos["tie"] ?? ""
            nota.ligaduraQueEmpieza = ligadura == "i" || ligadura == "m"
            nota.ligaduraQueAcaba = ligadura == "t" || ligadura == "m"
            // Una nota suelta tiene ya sus articulaciones en `evento`; la de un acorde, además las del acorde.
            if acorde != nil {
                nota.id = atributos["xml:id"]
                nota.articulaciones = LectorMEI.articulaciones(atributos)
            }
        case "accid" where padre == "note":
            alteraciones(atributos)
        case "artic":
            let suyas = LectorMEI.articulaciones(atributos)
            if padre == "chord" {
                acorde?.articulaciones += suyas
            } else if padre == "note" {
                if acorde != nil { nota.articulaciones += suyas } else { evento.articulaciones += suyas }
            }
        case "dynam":
            inicioDeLaDinamica = atributos["startid"].map { $0.hasPrefix("#") ? String($0.dropFirst()) : $0 }
        case "rest", "space":
            if acorde == nil { evento = leerEvento(atributos) }
        case "dot":
            if padre == "chord" {
                acorde?.puntillos += 1
            } else if padre == "note" || padre == "rest" {
                evento.puntillos += 1
            }
        default:
            break
        }
    }

    func texto(_ cadena: String) {
        contenido += cadena
    }

    func cierra(_ nombre: String) {
        let valor = contenido.trimmingCharacters(in: .whitespacesAndNewlines)
        contenido = ""
        pila.removeLast()
        switch nombre {
        case "title" where pila.contains("titleStmt"):
            if titulo == nil, !valor.isEmpty { titulo = valor }
        case "dynam":
            if let inicio = inicioDeLaDinamica, let dinamica = Dinamica(rawValue: valor.lowercased()) {
                for i in notasPorId[inicio] ?? [] { notas[i] = notas[i].con(dinamica: dinamica) }
            }
            inicioDeLaDinamica = nil
        case "note":
            if acorde != nil {
                colocar(desde: inicioDelAcorde, pulsos: pulsos(de: acorde!))
            } else {
                let duracion = pulsos(de: evento)
                colocar(desde: posicion, pulsos: duracion)
                avanzar(duracion)
            }
        case "chord":
            if let acorde { avanzar(pulsos(de: acorde)) }
            acorde = nil
        case "rest", "space":
            if acorde == nil { avanzar(pulsos(de: evento)) }
        case "mRest", "mSpace":
            avanzar(duracionDelCompas)
        case "tuplet":
            if !irregulares.isEmpty { irregulares.removeLast() }
        case "staff":
            pentagrama = nil
        case "measure":
            inicioDelCompas = max(finDelCompas, posicion)
            finDeLaPieza = inicioDelCompas
        case "ending":
            casillas = nil
        case "dir":
            marcar { $0.leer(indicacion: valor) }
        default:
            break
        }
    }

    /// El elemento que contiene al actual.
    private var padre: String? { pila.last }

    /// La armadura, el compás y el tempo de `<scoreDef>`, `<staffDef>` y sus hijos; solo los primeros.
    private func definicion(_ atributos: [String: String]) {
        if let firma = atributos["keysig"] ?? atributos["key.sig"], let quintas = LectorMEI.quintas(firma) {
            let menor = (atributos["key.mode"] ?? atributos["mode"]) == "minor"
            if tonalidad == nil, abs(quintas) <= 7 {
                tonalidad = Tonalidad(armadura: quintas, modo: menor ? .menor : .mayor)
            }
            armadura = Dictionary(
                (Tonalidad(armadura: max(-7, min(7, quintas))).notasDeLaArmadura).map {
                    ($0.natural, $0.alteracion.semitonos)
                }, uniquingKeysWith: { primera, _ in primera })
        }
        if let pulsos = (atributos["meter.count"]).map({ texto in
            texto.split(separator: "+").map { Int($0.trimmingCharacters(in: .whitespaces)) }
        }), !pulsos.contains(nil), let unidad = atributos["meter.unit"].flatMap(Int.init) {
            let total = pulsos.compactMap { $0 }.reduce(0, +)
            if let leido = Compas(comprobando: total, unidad), total <= 1000 {
                if compas == nil { compas = leido }
                duracionDelCompas = PulsosDeLectura.de(leido.duracion)
            }
        }
        if tempo == nil, let bpm = atributos["midi.bpm"].flatMap(Double.init), bpm > 0, bpm < 10_000 {
            tempo = Tempo(comprobando: bpm)
        }
    }

    /// «2s» → 2, «3f» → −3, «0» → 0.
    private static func quintas(_ firma: String) -> Int? {
        if firma == "0" { return 0 }
        guard let signo = firma.last, signo == "s" || signo == "f", let n = Int(firma.dropLast()), n <= 7 else {
            return nil
        }
        return signo == "s" ? n : -n
    }

    private func leerEvento(_ atributos: [String: String]) -> Evento {
        var evento = Evento()
        evento.figura = atributos["dur"]
        evento.puntillos = atributos["dots"].flatMap(Int.init) ?? 0
        if let exactos = atributos["dur.ppq"].flatMap(Int.init), exactos > 0, exactos < 10_000_000,
            let ppq = pentagrama?.ppq
        {
            evento.pulsosExactos = Int(
                (Double(exactos) * Double(PulsosDeLectura.porRedonda) / Double(4 * ppq)).rounded())
        }
        evento.sinTiempo = atributos["grace"] != nil
        evento.id = atributos["xml:id"]
        evento.articulaciones = LectorMEI.articulaciones(atributos)
        return evento
    }

    /// `accid` y `accid.ges`, en cents y con su signo; y el glifo SMuFL que se dé (`glyph.name`), que manda sobre el
    /// signo de `accid`.
    private func alteraciones(_ atributos: [String: String]) {
        if let accid = atributos["accid"], let escrita = centsDeAlteracionMEI(accid) {
            nota.escrita = escrita
            nota.signoEscrito = SignoMicrotonal(mei: accid)
        }
        if let accid = atributos["accid.ges"], let sonora = centsDeAlteracionMEI(accid) {
            nota.sonora = sonora
            nota.signoSonoro = SignoMicrotonal(mei: accid)
        }
        if let glifo = atributos["glyph.name"].flatMap({ SignoMicrotonal(smufl: $0) }) {
            if nota.escrita != nil { nota.signoEscrito = glifo }
            if nota.sonora != nil { nota.signoSonoro = glifo }
        }
    }

    /// Lo que dura un evento, en pulsos: el exacto o el de su figura, en su grupo irregular.
    private func pulsos(de evento: Evento) -> Int {
        guard !evento.sinTiempo else { return 0 }
        if let exactos = evento.pulsosExactos { return exactos }
        guard let figura = evento.figura, var pulsos = PulsosDeLectura.figura(figura, puntillos: evento.puntillos)
        else { return 0 }
        for (normales, reales) in irregulares { pulsos = pulsos * normales / reales }
        return pulsos
    }

    /// Cambia lo que se sabe del compás en curso.
    private func marcar(_ cambio: (inout CompasLeido) -> Void) {
        guard !compases.isEmpty else { return }
        cambio(&compases[compases.count - 1])
    }

    private func avanzar(_ pulsos: Int) {
        posicion = min(posicion + pulsos, PulsosDeLectura.limite + 1)
        finDelCompas = max(finDelCompas, posicion)
    }

    private func colocar(desde inicio: Int, pulsos: Int) {
        let deAdorno = (acorde ?? evento).sinTiempo
        guard pulsos > 0 || deAdorno, inicio + pulsos <= PulsosDeLectura.limite, let paso = nota.paso,
            let octava = nota.octava, let pentagrama
        else { return }
        let lugar = "\(nombreDelPentagrama) \(octava * 7 + paso.rawValue)"
        if let escrita = nota.escrita { vigentes[lugar] = (escrita, nota.signoEscrito) }
        let cents = nota.sonora ?? vigentes[lugar]?.cents ?? 100 * Double(armadura[paso] ?? 0)
        let signo = nota.sonora != nil ? nota.signoSonoro : vigentes[lugar]?.signo
        let (semitonos, desvio) = alteracionYDesvio(cents: cents)
        var altura = Altura(Nota(paso, Alteracion(semitonos)), octava: octava)
        if let transposicion = pentagrama.transposicion {
            altura = Altura(pasos: altura.pasos + transposicion.pasos, midi: altura.midi + transposicion.semitonos)
        }
        let parte = pentagrama.parte
        let desde = PulsosDeLectura.duracion(inicio)
        let duracion = PulsosDeLectura.duracion(pulsos)
        let microtono = signo?.sistemaYAjuste(altura: altura, desvio: desvio)
        if deAdorno {
            // Empieza donde empezará la nota a la que adorna.
            adornos.append(
                NotaDeLaPieza(
                    altura: altura, inicio: desde, duracion: .cero, parte: parte, desvio: desvio,
                    sistema: microtono?.sistema, ajuste: microtono?.ajuste ?? 0, voz: capa))
            return
        }
        let clave = parte * 1024 + altura.midi + 512
        if nota.ligaduraQueAcaba, let i = ligadas[clave], notas[i].fin == desde {
            notas[i] = notas[i].con(duracion: notas[i].duracion + duracion)
            if !nota.ligaduraQueEmpieza { ligadas[clave] = nil }
        } else {
            let suyo = acorde ?? evento
            notas.append(
                NotaDeLaPieza(
                    altura: altura, inicio: desde, duracion: duracion, parte: parte, desvio: desvio,
                    sistema: microtono?.sistema, ajuste: microtono?.ajuste ?? 0,
                    articulaciones: suyo.articulaciones + nota.articulaciones, voz: capa))
            if nota.ligaduraQueEmpieza { ligadas[clave] = notas.count - 1 }
            for id in [suyo.id, nota.id].compactMap({ $0 }) { notasPorId[id, default: []].append(notas.count - 1) }
        }
    }
}
