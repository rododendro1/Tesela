import Armonia
import Exposicion

/// Lo que se elige en la pestaña de acordes de Ars Harmonica y lo que sale de ello: el acorde leído, el arpegio,
/// el mástil y los ficheros para exportar. No usa SwiftUI, así que se prueba también en Linux; la vista lo guarda
/// en un `@State` y solo lo dibuja.
///
///     var modelo = ModeloDeAcordes()
///     modelo.texto = "Lam7"            // se vuelve a leer el acorde
///     modelo.acorde?.cifrado(en: .compacta(.espanol))   // "Lam7"
public struct ModeloDeAcordes: Sendable {
    /// El cifrado escrito. Al cambiarlo se lee el acorde (una vez por cambio, no en cada redibujado) y el arpegio
    /// vuelve a empezar por el bajo.
    public var texto: String {
        didSet {
            guard texto != oldValue else { return }
            lectura = Self.leer(texto)
            inicio = 0
        }
    }
    /// El acorde leído de `texto`, o por qué no se pudo leer.
    public private(set) var lectura: Result<Acorde, any Error>

    public var encordado = Encordado.guitarra
    public var patron = Arpegio.Patron.ascendente
    public var octavas = 1
    public var conOctava = true
    public var figura = Figura.corchea
    /// La nota del acorde por la que empieza el arpegio, desde el bajo (``Arpegio/inicio``).
    public var inicio = 0
    public var tensiones: [Int] = []
    /// Un recorrido propio por grados («1 5 3 8»); si se lee, manda sobre el patrón.
    public var grados = ""
    public var aproximacion: Arpegio.Aproximacion?
    public var tresillos = false
    public var swing = false
    public var tempo = 72
    /// Qué posiciones del arpegio se enseñan en el mástil.
    public var formas = FormasDeArpegio.porPosiciones
    /// Si cada posición del arpegio sube y vuelve a bajar.
    public var subirYBajar = false
    /// El traste del capo en las digitaciones y el arpegio en el mástil, o 0 sin capo.
    public var capo = 0
    /// La disposición de piano o jazz que se enseña (drop 2, shell…).
    public var disposicion = DisposicionDeAcorde.drop2
    /// El grupo de cuerdas en que se toca la disposición en el instrumento de las digitaciones.
    public var grupoDeCuerdas = 0
    /// El acorde con que se compara el leído, o vacío.
    public var otroAcorde = "Do"

    /// Las figuras que se ofrecen para las notas del arpegio.
    public static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// Las tensiones que se ofrecen para añadir al arpegio.
    public static let opcionesDeTensiones: [[Int]] = [[], [9], [9, 11], [9, 13], [9, 11, 13]]

    /// Los trastes del mástil de las digitaciones y de las disposiciones.
    public static let trastesDeLasDigitaciones = 15

    /// Un modelo con el cifrado `texto` y lo demás como al abrir la app.
    public init(texto: String = "Sol7/Si") {
        self.texto = texto
        lectura = Self.leer(texto)
    }

    /// El acorde leído, o `nil` si el texto no se lee.
    public var acorde: Acorde? { try? lectura.get() }

    /// Pone en el campo un acorde pedido desde otra pestaña («Ver en Acordes»), escrito en la notación de la app.
    public mutating func mostrar(_ acorde: Acorde, en notacion: Notacion) {
        texto = acorde.cifrado(en: notacion)
    }

    // MARK: Lo que sale de lo elegido

    /// Para qué texto, instrumento y capo se calcularon las digitaciones: mientras no coincida con lo que hay
    /// escrito, la vista enseña «Calculando…» y no las de otro acorde.
    public var claveDeLasDigitaciones: String { "\(texto)|\(encordado.nombre)|\(capo)" }

    /// Lo que dura cada nota del arpegio: la figura elegida, de tresillo si se pide.
    public var duracion: Duracion { tresillos ? figura.duracion.grupoIrregular(3, en: 2) : figura.duracion }

    /// El mástil del instrumento elegido, con el capo si lo lleva.
    public func mastil(trastes: Int) -> Mastil {
        Mastil(encordado.conCapo(capo), numeroDeTrastes: trastes)
    }

    /// Los trastes del mástil del arpegio: 12 por posiciones; 15 con las formas CAGED o de una nota por cuerda, que
    /// suben más.
    public var trastesDelArpegio: Int { formas == .porPosiciones ? 12 : 15 }

    /// El arpegio del acorde con lo elegido: los grados escritos, si se leen, o el patrón con sus opciones.
    public func arpegio(de acorde: Acorde) -> Arpegio {
        if let grados = try? Arpegio.grados(leyendo: grados) {
            return Arpegio(acorde, grados: grados, octavas: octavas, aproximacion: aproximacion)
        }
        return Arpegio(
            acorde, patron: patron, octavas: octavas, conOctava: conOctava, inicio: inicio, tensiones: tensiones,
            aproximacion: aproximacion)
    }

    /// El arpegio con la figura, el tempo y el swing elegidos.
    public func presentado(_ arpegio: Arpegio, en notacion: Notacion) -> ArpegioPresentado {
        PresentacionDeArpegios.arpegio(
            arpegio, figura: duracion, tempo: Tempo(Double(tempo)), swing: swing, en: notacion)
    }

    /// El arpegio en el pentagrama con el ritmo con que suena: la figura elegida, en tresillos si se piden.
    public func pentagrama(de arpegio: Arpegio, resaltada: Int? = nil, en notacion: Notacion) -> PentagramaPresentado {
        PentagramaPresentado(
            presentado(arpegio, en: notacion).voz, titulo: arpegio.nombre(en: notacion), en: notacion,
            resaltada: resaltada)
    }

    /// Las digitaciones del acorde escrito en el instrumento elegido. Puede tardar: la vista la llama fuera del hilo
    /// principal. La quinta puede faltar en los acordes de cuatro notas o más (el Do7 `x32310`), como se toca.
    public func digitaciones() -> [Digitacion] {
        guard let acorde else { return [] }
        return mastil(trastes: Self.trastesDeLasDigitaciones).digitaciones(de: acorde, exigirQuinta: false, limite: 6)
    }

    /// Los pentagramas del acorde leído y de su arpegio como SVG, la hoja de estudio, la disposición elegida, el
    /// arpegio en MusicXML, MEI y MIDI, y las `digitaciones` (si ya están) y el arpegio en el mástil como tablaturas
    /// MusicXML; o nada si el texto no se lee.
    public func ficheros(digitaciones: [Digitacion]?, en notacion: Notacion) -> [FicheroParaExportar] {
        guard let acorde else { return [] }
        let arpegio = self.arpegio(de: acorde)
        var ficheros = [
            PentagramaPresentado(acorde, en: notacion).fichero,
            pentagrama(de: arpegio, en: notacion).fichero,
            FicheroParaExportar.svg(
                PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: acorde, en: notacion),
                nombre: notacion.texto(\.hojaDeEstudio) + " " + acorde.cifrado(en: notacion)),
        ]
        if let presentadas = PresentacionDeDisposiciones.acorde(acorde, disposicion, en: notacion) {
            ficheros.append(presentadas.pentagrama.fichero)
            ficheros += presentadas.ficheros
        }
        ficheros += presentado(arpegio, en: notacion).ficheros
        let cifrado = acorde.cifrado(en: notacion)
        if let formas = digitaciones, !formas.isEmpty {
            let titulo = "Tablatura " + cifrado
            let xml = PresentacionDeTablatura.musicXML(
                digitaciones: formas, acordes: formas.map { _ in acorde }, titulo: titulo, en: notacion)
            ficheros.append(.musicXML(xml, nombre: titulo))
        }
        if let posicion = mastil(trastes: 12).arpegios(de: acorde).first {
            let titulo = "Tablatura del arpegio " + cifrado
            let xml = PresentacionDeTablatura.musicXML(
                arpegio: posicion, acorde: acorde, figura: figura, titulo: titulo, en: notacion)
            ficheros.append(.musicXML(xml, nombre: titulo))
        }
        return ficheros
    }

    /// El acorde de «Comparar con», si se lee, comparado con el leído.
    public func comparacion(en notacion: Notacion) -> ComparacionPresentada? {
        guard let acorde, let otro = try? Acorde(leyendo: otroAcorde) else { return nil }
        return PresentacionDeRelacionesDeAcorde.comparar(acorde, con: otro, en: notacion)
    }

    /// Los nombres que tiene el acorde leído en el catálogo, el genérico primero («séptima de dominante»; «novena
    /// añadida, acorde mu»), o `nil` si no tiene ninguno o el texto no se lee.
    public func nombresDelCatalogo(en notacion: Notacion) -> String? {
        guard let acorde else { return nil }
        let nombres = acorde.tipo.acordesConNombre.map { $0.nombre(en: notacion) }
        return nombres.isEmpty ? nil : nombres.joined(separator: ", ")
    }

    private static func leer(_ texto: String) -> Result<Acorde, any Error> {
        Result { try Acorde(leyendo: texto) }
    }
}
