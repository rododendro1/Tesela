import Armonia

/// Una línea de bajo caminante sobre una progresión: un compás de negras por acorde y, al final, la fundamental del
/// último en una redonda, con su pentagrama en clave de fa, su tablatura de bajo, lo que suena y los ficheros.
public struct BajoCaminantePresentado: Hashable, Sendable {
    /// Las notas escritas, una octava por encima de lo que suenan, como se escribe el bajo.
    public let alturas: [Altura]
    /// «Re₃ Fa₃ La₃ La♭₃», un compás por acorde.
    public let compases: [String]
    public let voz: Voz
    /// La voz en clave de fa, con el cifrado de cada compás y la tablatura del bajo de cuatro cuerdas debajo.
    public let partitura: Partitura
    public let pentagrama: PentagramaPresentado
    /// El bajo, donde suena, con los acordes encima.
    public let sonido: Escucha
    public let ficheros: [FicheroParaExportar]
}

extension PresentacionDeAnalisis {
    // MARK: El bajo caminante

    /// Dónde va el bajo, escrito: del Mi₂ al La₃ (suena del Mi₁ al La₂).
    static let registroDelBajo = 40...57

    /// Un bajo caminante en negras sobre la progresión, un compás por acorde: la fundamental en la primera parte,
    /// notas del acorde en la segunda y la tercera, hacia la fundamental del siguiente, y en la cuarta una nota de
    /// paso cromática que lleva a ella. El último acorde, su fundamental en una redonda. `nil` sin acordes.
    ///
    ///     let bajo = PresentacionDeAnalisis.bajoCaminante(
    ///         [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], en: .compacta(.espanol))
    ///     bajo?.alturas.count   // 9
    public static func bajoCaminante(_ acordes: [Acorde], en notacion: Notacion) -> BajoCaminantePresentado? {
        guard let primero = acordes.first else { return nil }
        var alturas: [Altura] = []
        var compases: [String] = []
        var eventos: [Evento] = []
        var raiz = cercana(primero.fundamental, a: 50)
        for (i, acorde) in acordes.enumerated() {
            guard i + 1 < acordes.count else {
                alturas.append(raiz)
                eventos.append(Evento(raiz, .redonda))
                compases.append(raiz.nombre(en: notacion))
                break
            }
            let destino = cercana(acordes[i + 1].fundamental, a: raiz.midi)
            let compas = caminar(acorde, desde: raiz, hasta: destino)
            alturas += compas
            eventos += compas.map { Evento($0, .negra) }
            compases.append(compas.map { $0.nombre(en: notacion) }.joined(separator: " "))
            raiz = destino
        }
        let voz = Voz(eventos)
        let titulo = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")

        // La tablatura del bajo, donde suena cada nota: en el traste más cercano al anterior.
        let mastil = Mastil(.bajoElectrico, numeroDeTrastes: 20)
        var posiciones: [Int: [PosicionEnElMastil]] = [:]
        var traste = 3
        for (i, altura) in alturas.enumerated() {
            let elegida = mastil.posiciones(de: sonando(altura)).min {
                abs($0.traste - traste) < abs($1.traste - traste)
            }
            if let elegida {
                posiciones[i] = [elegida]
                traste = elegida.traste
            }
        }
        let tablatura = Tablatura(mastil, posiciones: posiciones)
        var cifrados: [Int: Acorde] = [:]
        for (i, acorde) in acordes.enumerated() { cifrados[4 * i] = acorde }
        let linea = Partitura.Linea(
            voz, porEvento: .init(cifrados: cifrados, pulsaciones: tablatura.pulsaciones))
        let partitura = Partitura(
            pentagramas: [Partitura.Pentagrama(clave: .fa, voces: [linea], tablatura: tablatura)],
            encabezado: Encabezado(titulo: titulo), notacion: notacion)
        let nombre = notacion.texto(\.bajoCaminante) + " " + titulo
        let descripcion = titulo + ": " + compases.joined(separator: " | ")

        // Lo que suena: el bajo, en su octava, y cada acorde encima mientras dura su compás.
        let negra = Escucha.tempo.segundos(de: .negra)
        var notas = Escucha.voz(Voz(eventos.map { Evento(sonando($0.alturas[0]), $0.duracion) })).notas
        for (i, acorde) in acordes.enumerated() {
            let duracion = 4 * negra * 0.95
            notas += Escucha.cerrada(acorde.notas, desde: 55).map {
                Escucha.NotaMIDI(altura: $0, inicio: Double(4 * i) * negra, duracion: duracion)
            }
        }
        return BajoCaminantePresentado(
            alturas: alturas, compases: compases, voz: voz, partitura: partitura,
            pentagrama: PentagramaPresentado(partitura, titulo: nombre, descripcion: descripcion, notacion: notacion),
            sonido: Escucha(notas: notas, tonica: primero.fundamental),
            ficheros: FicheroParaExportar.partituras(nombre: nombre) { partitura.exportar(como: $0) })
    }

    /// Las cuatro negras de un compás: la fundamental, dos notas del acorde hacia el destino (o hacia el otro lado,
    /// si no caben en el registro) y la nota cromática de al lado del destino, por el lado de donde se viene.
    static func caminar(_ acorde: Acorde, desde raiz: Altura, hasta destino: Altura) -> [Altura] {
        let tonos = acorde.notas.flatMap { nota in
            (1...4).map { Altura(nota, octava: $0) }.filter { registroDelBajo.contains($0.midi) }
        }
        func hacia(_ sube: Bool) -> [Altura] {
            tonos.filter { sube ? $0.midi > raiz.midi : $0.midi < raiz.midi }
                .sorted { sube ? $0.midi < $1.midi : $0.midi > $1.midi }
        }
        let sube = destino.midi > raiz.midi || (destino.midi == raiz.midi && raiz.midi < 48)
        let camino = hacia(sube).count >= 2 ? hacia(sube) : hacia(!sube)
        let segunda = camino.isEmpty ? raiz : camino[0]
        let tercera = camino.count > 1 ? camino[1] : segunda
        // Por encima del destino si se viene de arriba; si no, por debajo. Si cae fuera o repite, del otro lado.
        let arriba = destino.midi + 1
        let abajo = destino.midi - 1
        var lados = tercera.midi > destino.midi ? [arriba, abajo] : [abajo, arriba]
        lados = lados.filter { $0 != tercera.midi } + lados.filter { $0 == tercera.midi }
        let paso = registroDelBajo.contains(lados[0]) ? lados[0] : lados[1]
        let cuarta = Altura(midi: paso, ventana: paso > destino.midi ? .bemoles : .sostenidos)
        return [raiz, segunda, tercera, cuarta]
    }

    /// La nota en el registro del bajo más cercana a `midi`.
    static func cercana(_ nota: Nota, a midi: Int) -> Altura {
        // El registro abarca más de una octava, así que siempre hay alguna.
        var mejor = Altura(nota, octava: 2)
        for octava in 1...4 {
            let candidata = Altura(nota, octava: octava)
            guard registroDelBajo.contains(candidata.midi) else { continue }
            if !registroDelBajo.contains(mejor.midi) || abs(candidata.midi - midi) < abs(mejor.midi - midi) {
                mejor = candidata
            }
        }
        return mejor
    }

    /// Donde suena una nota escrita del bajo: una octava más grave.
    private static func sonando(_ altura: Altura) -> Altura {
        Altura(altura.nota, octava: altura.octava - 1)
    }
}
