import Elementos

// MARK: - AcordeConNombre

/// Un acorde del catálogo: un nombre y las notas que lo forman, contadas desde la nota más grave.
///
/// `TipoDeAcorde` es solo contenido (dos tipos con las mismas notas son iguales) y se escribe con su cifrado. Un
/// `AcordeConNombre` es un acorde concreto: el nombre con que se conoce, sus otros nombres y una disposición con su
/// ortografía. Varios pueden tener el mismo tipo, como Kāfī y el dórico entre las escalas.
///
///     AcordeConNombre.dominanteSeptima.nombre                         // "séptima de dominante"
///     AcordeConNombre.dominanteSeptima.nombre(en: .conPalabras(.ingles))  // "dominant seventh"
///     AcordeConNombre.dominanteSeptima.tipo?.cifrado                  // "7"
///     TipoDeAcorde.dominanteSeptima.acordeConNombre?.nombre           // "séptima de dominante"
///
/// El catálogo (`catalogo`) tiene dos partes. Los genéricos (`genericos`) son los tipos que tienen nombre (la tríada
/// mayor, la séptima de dominante, las sextas aumentadas…) y dan nombre a su `TipoDeAcorde`. Los de nombre propio
/// (`conNombrePropio`) son acordes concretos de una obra o de un estilo: el de Tristán, el místico de Skriabin, el de
/// Petrushka, el So What… No dan nombre a su tipo, si lo tienen (el de Hendrix es un 7(♯9) sin quinta cualquiera), y
/// alguno no lo tiene, porque sus notas no se leen por terceras. Los nombres en los otros idiomas están en
/// `Acordes/Nombres/`, un fichero por idioma.
///
///     AcordeConNombre.tristan.notas(sobre: .fa)          // [Fa, Si, Re♯, Sol♯]
///     AcordeConNombre.petrushka.tipo                     // nil
///     TipoDeAcorde.mayorNovenaAnadida.acordesConNombre   // [novena añadida, acorde mu]
///
/// Dos acordes con nombre son iguales si se llaman igual y tienen las mismas notas en el mismo orden. Los estilos y
/// las referencias no cuentan.
public struct AcordeConNombre: Sendable {
    /// El nombre en español: «séptima de dominante».
    public let nombre: String
    /// Otros nombres del acorde, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre (otro género, otra grafía).
    public let variantes: [String]
    /// Las notas desde la más grave, en el orden en que se disponen, con su ortografía; empieza por el unísono.
    /// Pueden ser intervalos compuestos (la novena, la undécima…).
    public let intervalos: [Intervalo]
    /// Lo demás que sabe el catálogo del acorde: sus estilos y sus referencias.
    package let datos: DatosDelCatalogo

    /// Un acorde con nombre, del catálogo o fuera de él. Si los intervalos no empiezan por el unísono, se le añade.
    /// `documentada` es la obra más antigua que lo da, con su año, y va también entre sus referencias.
    public init(
        nombre: String, intervalos: [Intervalo], alias: [String] = [], variantes: [String] = [],
        estilos: [Estilo] = [], referencias: [Referencia] = [], documentada: Referencia? = nil
    ) {
        self.nombre = nombre
        self.alias = alias
        self.variantes = variantes
        self.intervalos = intervalos.first == .unisono ? intervalos : [.unisono] + intervalos
        self.datos = DatosDelCatalogo(estilos: estilos, referencias: referencias, documentada: documentada)
    }

    // MARK: Propiedades

    /// El tipo de acorde por terceras que forman sus notas, o `nil` si no se pueden leer así.
    public var tipo: TipoDeAcorde? { TipoDeAcorde(intervalos: intervalos) }

    /// Los desplazamientos en quintas de sus notas desde la más grave, como `TipoDeAcorde.pasosDeQuinta`, sin
    /// crear el tipo.
    package var pasosDeQuinta: Set<Int> { Set(intervalos.map(\.pasosDeQuintaConSigno)).union([0]) }

    /// Las notas del acorde sobre una nota, de grave a agudo: `AcordeConNombre.dominanteSeptima.notas(sobre: .sol)`
    /// → Sol Si Re Fa.
    public func notas(sobre fundamental: Nota) -> [Nota] { intervalos.map { fundamental + $0 } }

    /// En qué estilos se usa (la clásica, el jazz, la popular…); vacío si no es propio de ninguno.
    public var estilos: [Estilo] { datos.estilos }

    /// Dónde se lee el acorde, con las obras de su carácter.
    public var referencias: [Referencia] { Referencia.unicas(datos.referencias + caracter.map(\.referencia)) }

    /// La obra más antigua que da el acorde, con su año: la partitura de «Tristan und Isolde» (1859) en el de Tristán.
    /// `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// El nombre en el idioma de la notación, y en su grafía: «séptima de dominante», «dominant seventh»,
    /// «Dominantseptakkord», «dominantseptakkord» (en ruso transliterado)… Un acorde fuera del catálogo se llama en
    /// todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }

    /// Los otros nombres de el acorde en el idioma de la notación, como `nombre(en:)`; vacío si no tiene.
    public func alias(en notacion: Notacion) -> [String] { aliasTraducidos(en: notacion) }

    /// Las otras formas de escribir su nombre o un alias en el idioma de la notación; vacío si no tiene.
    public func variantes(en notacion: Notacion) -> [String] { variantesTraducidas(en: notacion) }
}

extension AcordeConNombre: Hashable {
    public static func == (a: AcordeConNombre, b: AcordeConNombre) -> Bool {
        a.nombre == b.nombre && a.intervalos == b.intervalos
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nombre)
        hasher.combine(intervalos)
    }
}

// MARK: - Búsqueda por nombre

extension AcordeConNombre {
    /// El acorde del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes,
    /// espacios ni guiones: «séptima de dominante», «dominant seventh», «Tristan chord», «acorde de Tristán».
    public static func buscar(nombre: String) -> AcordeConNombre? { buscarNombre(nombre) }

    /// Los del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma (sin mirar mayúsculas ni
    /// tildes), en el orden del catálogo: «sexta aumentada» da la italiana, la francesa, la alemana y la suiza.
    public static func buscar(conteniendo texto: String) -> [AcordeConNombre] { buscarConteniendo(texto) }
}

// MARK: - Desde el tipo

extension TipoDeAcorde {
    /// El acorde genérico del catálogo con el que se nombra este tipo, si tiene nombre: el primero de
    /// `AcordeConNombre.genericos` con sus mismas notas. `TipoDeAcorde.dominanteSeptima.acordeConNombre` es
    /// `AcordeConNombre.dominanteSeptima`; un tipo como 7(♭9,♯11) no tiene.
    public var acordeConNombre: AcordeConNombre? { TipoDeAcorde.nombresConocidos[pasosDeQuinta] }

    /// Todos los acordes del catálogo con las notas de este tipo, el genérico primero: add9 es la novena añadida y el
    /// acorde mu, y 7(♯9) sin quinta, el acorde de Hendrix.
    public var acordesConNombre: [AcordeConNombre] {
        AcordeConNombre.catalogo.filter { $0.pasosDeQuinta == pasosDeQuinta }
    }
}
