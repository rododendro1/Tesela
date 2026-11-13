import Armonia
import Exposicion

/// Lo que se elige en la pestaña «Catálogo» de Ars Harmonica y lo que sale de ello: la lista (progresiones, acordes
/// con nombre o ritmos), lo buscado y la tónica, y una ficha por elemento con su nombre en la notación, lo que es,
/// sus fuentes, cómo suena y a qué pestaña lleva. No usa SwiftUI, así que se prueba también en Linux; la vista lo
/// guarda en un `@State` y solo lo dibuja.
///
///     var modelo = ModeloDelCatalogo()
///     modelo.texto = "andaluza"
///     modelo.fichas(en: .compacta(.espanol)).first?.nombre   // "cadencia andaluza"
public struct ModeloDelCatalogo: Sendable {
    /// Las tres listas del catálogo.
    public enum Lista: CaseIterable, Identifiable, Hashable, Sendable {
        case progresiones
        case acordes
        case ritmos
        public var id: Self { self }

        /// Su nombre en el selector.
        public func titulo(en notacion: Notacion) -> String {
            switch self {
            case .progresiones: return notacion.texto(\.progresionesConNombre)
            case .acordes: return notacion.texto(\.acordesConNombre)
            case .ritmos: return notacion.texto(\.ritmosConNombre)
            }
        }
    }

    /// La pestaña a la que lleva una ficha: la progresión escrita, a Análisis; el acorde, a Acordes.
    public enum Destino: Hashable, Sendable {
        case analisis(String)
        case acordes(Acorde)
    }

    /// Un elemento del catálogo, listo para dibujarlo.
    public struct Ficha: Identifiable, Hashable, Sendable {
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
        public let fuentes: [String]
        public let sonido: Escucha
        /// A dónde lleva, o `nil` si a ningún sitio.
        public let destino: Destino?
    }

    public var lista = Lista.progresiones
    /// Lo buscado, en cualquier idioma, sin mirar mayúsculas ni tildes; vacío, todo.
    public var texto = ""
    /// La nota sobre la que se escriben y suenan las progresiones y los acordes.
    public var tonica = Nota.do

    /// Un catálogo como al abrir la app: las progresiones sobre Do, sin buscar nada.
    public init() {}

    /// Las fichas de la lista elegida que se llaman como lo buscado, en el orden del catálogo.
    public func fichas(en notacion: Notacion) -> [Ficha] {
        switch lista {
        case .progresiones: return ProgresionConNombre.buscar(conteniendo: texto).map { ficha(de: $0, en: notacion) }
        case .acordes: return AcordeConNombre.buscar(conteniendo: texto).map { ficha(de: $0, en: notacion) }
        case .ritmos: return RitmoConNombre.buscar(conteniendo: texto).map { ficha(de: $0, en: notacion) }
        }
    }

    /// Una progresión: su cifrado romano y sus acordes sobre la tónica, que suenan y se abren en Análisis.
    public func ficha(de progresion: ProgresionConNombre, en notacion: Notacion) -> Ficha {
        let acordes = progresion.acordes(sobre: tonica)
        let cifrados = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ")
        return Ficha(
            id: progresion.nombre, nombre: progresion.nombre(en: notacion),
            detalle: acordes.isEmpty ? progresion.cifrado : progresion.cifrado + " · " + cifrados,
            estilos: Self.estilos(progresion.estilos, de: progresion, en: notacion),
            fuentes: progresion.referencias.map(\.cita),
            sonido: .acordes(acordes), destino: acordes.isEmpty ? nil : .analisis(cifrados))
    }

    /// Un acorde con nombre: sus notas sobre la tónica y, si es el que nombra a un tipo, su cifrado. Suena como se
    /// escribe en el catálogo, desde la tónica de la octava central (el místico, por cuartas, en tres octavas), y
    /// se abre en Acordes si se puede cifrar.
    public func ficha(de acorde: AcordeConNombre, en notacion: Notacion) -> Ficha {
        let notas = acorde.notas(sobre: tonica).map { $0.nombre(en: notacion) }.joined(separator: " ")
        let delTipo = acorde.tipo.map { Acorde(tonica, $0) }
        let base = 60 + tonica.claseDeAltura
        let sonido = Escucha.coral([acorde.intervalos.map { Altura(midi: base + $0.semitonos) }])
        var detalle = notas
        if let delTipo, acorde.tipo?.acordeConNombre == acorde {
            detalle = delTipo.cifrado(en: notacion) + " · " + notas
        }
        return Ficha(
            id: acorde.nombre, nombre: acorde.nombre(en: notacion), detalle: detalle,
            estilos: Self.estilos(acorde.estilos, de: acorde, en: notacion),
            fuentes: acorde.referencias.map(\.cita),
            sonido: sonido, destino: delTipo.map { .acordes($0) })
    }

    /// Un ritmo: su patrón y su agrupación, con su familia; suena dos vueltas y no lleva a ninguna pestaña.
    public func ficha(de ritmo: RitmoConNombre, en notacion: Notacion) -> Ficha {
        let agrupacion = ritmo.agrupacion.map(String.init).joined(separator: "+")
        return Ficha(
            id: ritmo.nombre, nombre: ritmo.nombre(en: notacion), detalle: ritmo.patron + " · " + agrupacion,
            estilos: ritmo.familia.nombre(en: notacion), fuentes: ritmo.referencias.map(\.cita),
            sonido: .ritmo(ritmo), destino: nil)
    }

    /// Los estilos y la época con el año (`OrigenPresentado`): «jazz · Romanticismo (1865)».
    private static func estilos(
        _ estilos: [Estilo], de elemento: some ElementoConNombre, en notacion: Notacion
    ) -> String {
        let origen = OrigenPresentado(elemento, en: notacion)?.texto
        return (estilos.map { $0.nombre(en: notacion) } + [origen].compactMap { $0 }).joined(separator: " · ")
    }
}
