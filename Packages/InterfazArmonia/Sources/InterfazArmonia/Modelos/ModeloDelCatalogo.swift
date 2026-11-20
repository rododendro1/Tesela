import Armonia
import ExposicionArmonia

/// Lo que se elige en la pestaña «Catálogo» de Ars Harmonica y lo que sale de ello: la lista (progresiones, acordes
/// con nombre, ritmos, ornamentos o instrumentos), lo buscado y la tónica, y una tarjeta por elemento con su nombre
/// en la notación, lo que es, sus referencias, cómo suena y a qué pestaña lleva. No usa SwiftUI, así que se prueba
/// también en Linux; la vista lo guarda en un `@State` y solo lo dibuja.
///
///     var modelo = ModeloDelCatalogo()
///     modelo.texto = "andaluza"
///     modelo.tarjetas(en: .compacta(.espanol)).first?.nombre   // "cadencia andaluza"
public struct ModeloDelCatalogo: Sendable {
    /// Las listas del catálogo.
    public enum Lista: CaseIterable, Identifiable, Hashable, Sendable {
        case progresiones
        case acordes
        case ritmos
        case ornamentos
        case instrumentos
        public var id: Self { self }

        /// Su nombre en el selector.
        public func titulo(en notacion: Notacion) -> String {
            switch self {
            case .progresiones: return notacion.texto(\.progresionesConNombre)
            case .acordes: return notacion.texto(\.acordesConNombre)
            case .ritmos: return notacion.texto(\.ritmosConNombre)
            case .ornamentos: return notacion.texto(\.ornamentosConNombre)
            case .instrumentos: return notacion.texto(\.instrumentosDeCuerda)
            }
        }

        /// Si sus tarjetas se escriben sobre la tónica elegida: las progresiones, los acordes y los ornamentos.
        public var usaLaTonica: Bool { self != .ritmos && self != .instrumentos }
    }

    /// La pestaña a la que lleva una tarjeta: la progresión escrita, a Análisis; el acorde, a Acordes.
    public enum Destino: Hashable, Sendable {
        case analisis(String)
        case acordes(Acorde)
    }

    /// Un elemento del catálogo, listo para dibujarlo.
    public struct Tarjeta: Identifiable, Hashable, Sendable {
        /// El nombre del catálogo, que no cambia con el idioma.
        public let id: String
        /// El nombre en la notación.
        public let nombre: String
        /// Lo que es: el cifrado romano y los acordes de una progresión, las notas de un acorde, el patrón de un
        /// ritmo.
        public let detalle: String
        /// Los estilos o la familia y, en las progresiones y los acordes, la época de origen (con el año de su obra, si
        /// lo tiene), separados por « · », o vacío: «clásica · Romanticismo (1859)».
        public let estilos: String
        /// Las obras de donde sale, ya citadas.
        public let referencias: [String]
        public let sonido: Escucha
        /// A dónde lleva, o `nil` si a ningún sitio.
        public let destino: Destino?
    }

    public var lista = Lista.progresiones
    /// Lo buscado, en cualquier idioma, sin mirar mayúsculas ni tildes; vacío, todo.
    public var texto = ""
    /// La nota sobre la que se escriben y suenan las progresiones, los acordes y los ornamentos.
    public var tonica = Nota.do

    /// Un catálogo como al abrir la app: las progresiones sobre Do, sin buscar nada.
    public init() {}

    /// Las tarjetas de la lista elegida que se llaman como lo buscado, en el orden del catálogo.
    public func tarjetas(en notacion: Notacion) -> [Tarjeta] {
        switch lista {
        case .progresiones: return ProgresionConNombre.buscar(conteniendo: texto).map { tarjeta(de: $0, en: notacion) }
        case .acordes: return AcordeConNombre.buscar(conteniendo: texto).map { tarjeta(de: $0, en: notacion) }
        case .ritmos: return RitmoConNombre.buscar(conteniendo: texto).map { tarjeta(de: $0, en: notacion) }
        case .ornamentos: return OrnamentoConNombre.buscar(conteniendo: texto).map { tarjeta(de: $0, en: notacion) }
        case .instrumentos: return Encordado.buscar(conteniendo: texto).map { tarjeta(de: $0, en: notacion) }
        }
    }

    /// Una progresión: su cifrado romano y sus acordes sobre la tónica, que suenan y se abren en Análisis.
    public func tarjeta(de progresion: ProgresionConNombre, en notacion: Notacion) -> Tarjeta {
        let acordes = progresion.acordes(sobre: tonica)
        let cifrados = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ")
        return Tarjeta(
            id: progresion.nombre, nombre: progresion.nombre(en: notacion),
            detalle: acordes.isEmpty ? progresion.cifrado : progresion.cifrado + " · " + cifrados,
            estilos: ProgresionConNombrePresentada(progresion, sobre: tonica, en: notacion).estilosYOrigen,
            referencias: progresion.referencias.map(\.cita),
            sonido: .acordes(acordes), destino: acordes.isEmpty ? nil : .analisis(cifrados))
    }

    /// Un acorde con nombre: sus notas sobre la tónica y, si es el que nombra a un tipo, su cifrado. Suena como se
    /// escribe en el catálogo, desde la tónica de la octava central (el místico, por cuartas, en tres octavas), y
    /// se abre en Acordes si se puede cifrar.
    public func tarjeta(de acorde: AcordeConNombre, en notacion: Notacion) -> Tarjeta {
        let notas = acorde.notas(sobre: tonica).map { $0.nombre(en: notacion) }.joined(separator: " ")
        let delTipo = acorde.tipo.map { Acorde(tonica, $0) }
        let base = 60 + tonica.claseDeAltura
        let sonido = Escucha.coral([acorde.intervalos.map { Altura(midi: base + $0.semitonos) }])
        var detalle = notas
        if let delTipo, acorde.tipo?.acordeConNombre == acorde {
            detalle = delTipo.cifrado(en: notacion) + " · " + notas
        }
        return Tarjeta(
            id: acorde.nombre, nombre: acorde.nombre(en: notacion), detalle: detalle,
            estilos: AcordeConNombrePresentado(acorde, sobre: tonica, en: notacion).estilosYOrigen,
            referencias: acorde.referencias.map(\.cita),
            sonido: sonido, destino: delTipo.map { .acordes($0) })
    }

    /// Un ritmo: su patrón y su agrupación, con su familia; suena dos vueltas y no lleva a ninguna pestaña.
    public func tarjeta(de ritmo: RitmoConNombre, en notacion: Notacion) -> Tarjeta {
        let agrupacion = ritmo.agrupacion.map(String.init).joined(separator: "+")
        return Tarjeta(
            id: ritmo.nombre, nombre: ritmo.nombre(en: notacion), detalle: ritmo.patron + " · " + agrupacion,
            estilos: Self.familiaYOrigen(ritmo, en: notacion), referencias: ritmo.referencias.map(\.cita),
            sonido: .ritmo(ritmo), destino: nil)
    }

    /// Un ornamento: sus pasos y lo que suena sobre la tónica (en la cuarta octava) en su escala mayor, cada nota con
    /// su figura si la principal es una negra (`OrnamentoConNombre.tocado(sobre:en:duracion:)`), y así se oye.
    public func tarjeta(de ornamento: OrnamentoConNombre, en notacion: Notacion) -> Tarjeta {
        let principal = Altura(tonica, octava: 4)
        let escala = Escala(tonica)
        let presentado = OrnamentoPresentado(
            ornamento, sobre: principal, escala: escala, duracion: .negra, en: notacion)
        let tocado = ornamento.tocado(sobre: principal, en: escala, duracion: .negra) ?? [(principal, .negra)]
        let notas = presentado.tocado?.joined(separator: " ") ?? ""
        let estilos = presentado.estilos + [presentado.origen?.texto].compactMap { $0 }
        return Tarjeta(
            id: ornamento.nombre, nombre: presentado.nombre, detalle: presentado.textoDeLosPasos + " · " + notas,
            estilos: estilos.joined(separator: " · "), referencias: presentado.referencias,
            sonido: .voz(Voz(tocado.map { Evento($0.altura, $0.duracion) })), destino: nil)
    }

    /// Un instrumento: su afinación y sus cuerdas, con su familia y sus trastes; suenan sus cuerdas al aire, de la
    /// más grave a la más aguda, y no lleva a ninguna pestaña.
    public func tarjeta(de encordado: Encordado, en notacion: Notacion) -> Tarjeta {
        let presentado = EncordadoPresentado(encordado, en: notacion)
        let estilos = [presentado.familia, presentado.trastes].compactMap { $0 } + presentado.estilos
        let alturas = encordado.afinacion.sorted { $0.midi < $1.midi }
        return Tarjeta(
            id: encordado.nombre, nombre: presentado.nombre,
            detalle: presentado.afinacion.joined(separator: " ") + " · " + presentado.cuerdas(en: notacion),
            estilos: estilos.joined(separator: " · "), referencias: presentado.referencias,
            sonido: .voz(Voz(alturas.map { Evento($0, .corchea) })), destino: nil)
    }

    /// La hoja de estudio de una tarjeta de la lista elegida, en SVG y en HTML (`BotonDeExportar` le añade el PDF): la
    /// de la progresión sobre la tónica, la del acorde con nombre que se puede cifrar, la del ritmo o la del
    /// instrumento. Los ornamentos no tienen hoja. Se pide por el `id` de la tarjeta, cuando se va a exportar, porque
    /// hacer la hoja de todas las tarjetas a la vez tardaría.
    ///
    ///     var modelo = ModeloDelCatalogo()
    ///     modelo.lista = .ritmos
    ///     modelo.ficheros(deLaTarjeta: "tresillo", en: .compacta(.espanol)).map(\.nombreDeFichero)
    ///     // ["Hoja de estudio tresillo.svg", "Hoja de estudio tresillo.html"]
    public func ficheros(deLaTarjeta id: String, en notacion: Notacion) -> [FicheroParaExportar] {
        let hoja: (titulo: String, hacer: (HojaDeEstudio.Formato) -> String)?
        switch lista {
        case .progresiones:
            let tonica = self.tonica
            hoja = ProgresionConNombre.buscar(nombre: id).map { progresion in
                (
                    progresion.nombre(en: notacion),
                    { HojaDeEstudio.progresion(progresion, sobre: tonica, en: notacion, formato: $0) }
                )
            }
        case .acordes:
            hoja = AcordeConNombre.buscar(nombre: id).flatMap(\.tipo).map { tipo in
                let acorde = Acorde(tonica, tipo)
                return (acorde.cifrado(en: notacion), { HojaDeEstudio.acorde(acorde, en: notacion, formato: $0) })
            }
        case .ritmos:
            hoja = RitmoConNombre.buscar(nombre: id).map { ritmo in
                (ritmo.nombre(en: notacion), { HojaDeEstudio.ritmo(ritmo, en: notacion, formato: $0) })
            }
        case .instrumentos:
            hoja = Encordado.buscar(nombre: id).map { encordado in
                (
                    encordado.nombre(en: notacion),
                    { HojaDeEstudio.instrumento(encordado, en: notacion, formato: $0) }
                )
            }
        case .ornamentos:
            hoja = nil
        }
        guard let hoja else { return [] }
        let nombre = notacion.texto(\.hojaDeEstudio) + " " + hoja.titulo
        return [.svg(hoja.hacer(.svg), nombre: nombre), .html(hoja.hacer(.html), nombre: nombre)]
    }

    /// La familia de un ritmo, sus estilos y su época con el año, los que tenga: «danza · jazz · Siglo XX (1923)».
    private static func familiaYOrigen(_ ritmo: RitmoConNombre, en notacion: Notacion) -> String {
        let presentado = RitmoPresentado(ritmo, en: notacion)
        return ([presentado.familia] + presentado.estilos + [presentado.origen?.texto].compactMap { $0 })
            .joined(separator: " · ")
    }
}
