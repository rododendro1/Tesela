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
/// alguno no lo tiene, porque sus notas no se leen por terceras. Los nombres en los otros idiomas están en `Acordes/Nombres/`, un
/// fichero por idioma.
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
    package let ficha: FichaDeAcorde

    /// Un acorde con nombre propio, fuera del catálogo. Si los intervalos no empiezan por el unísono, se le añade.
    public init(nombre: String, intervalos: [Intervalo], alias: [String] = [], variantes: [String] = []) {
        self.init(nombre: nombre, intervalos: intervalos, alias: alias, variantes: variantes, ficha: .vacia)
    }

    /// Un acorde del catálogo, con sus estilos y sus referencias.
    package init(
        nombre: String, intervalos: [Intervalo], alias: [String] = [], variantes: [String] = [],
        estilos: [EstiloDeEscala] = [], referencias: [Referencia] = []
    ) {
        self.init(
            nombre: nombre, intervalos: intervalos, alias: alias, variantes: variantes,
            ficha: FichaDeAcorde(estilos: estilos, referencias: referencias))
    }

    private init(
        nombre: String, intervalos: [Intervalo], alias: [String], variantes: [String], ficha: FichaDeAcorde
    ) {
        self.nombre = nombre
        self.alias = alias
        self.variantes = variantes
        self.intervalos = intervalos.first == .unisono ? intervalos : [.unisono] + intervalos
        self.ficha = ficha
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
    public var estilos: [EstiloDeEscala] { ficha.estilos }

    /// Dónde se lee el acorde.
    public var referencias: [Referencia] { ficha.referencias }

    /// El nombre en el idioma de la notación, y en su grafía: «séptima de dominante», «dominant seventh»,
    /// «Dominantseptakkord», «dominantseptakkord» (en ruso transliterado)… Un acorde fuera del catálogo se llama en
    /// todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String {
        notacion.enSuGrafia(NombresDeAcordes.de(notacion.textos).nombre(de: self) ?? nombre)
    }
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

extension AcordeConNombre: Identifiable {
    /// El nombre en español, que no se repite en el catálogo.
    public var id: String { nombre }
}

extension AcordeConNombre: Nombrable, CustomStringConvertible {
    public var description: String { nombre }
}

// MARK: - Ficha de un acorde del catálogo

/// Lo que el catálogo sabe de un acorde además de su nombre y sus notas. Se escribe en su declaración:
///
///     public static let sextaAumentadaAlemana = AcordeConNombre(
///         nombre: "sexta aumentada alemana", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaAumentada],
///         estilos: [.clasica])
package struct FichaDeAcorde: Sendable {
    /// En qué estilos se usa, en el orden de `EstiloDeEscala.allCases`.
    package let estilos: [EstiloDeEscala]
    /// Dónde se lee el acorde.
    package let referencias: [Referencia]

    package init(estilos: [EstiloDeEscala] = [], referencias: [Referencia] = []) {
        self.estilos = EstiloDeEscala.allCases.filter(estilos.contains)
        self.referencias = referencias
    }

    /// La de un acorde que no es del catálogo.
    package static let vacia = FichaDeAcorde()
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
