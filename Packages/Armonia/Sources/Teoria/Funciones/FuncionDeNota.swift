import Elementos
import Foundation

// MARK: - FuncionDeNota

/// El papel que hace una nota, con nombre: los grados de la escala (tónica, dominante, sensible…), las notas del modo
/// gregoriano (finalis, tenor, confinalis), las del rāga (sa, pa, vādī, saṃvādī, nyāsa), las del maqam y el makam
/// (qarār, ghammāz, yeden), las blue notes, los adornos (acciaccatura, mordente, grupeto, trino) y las notas extrañas
/// al acorde (nota de paso, bordadura, apoyatura…).
///
///     FuncionDeNota.dominante.intervalo                   // .quintaJusta
///     FuncionDeNota.septimaBlue.desvio                    // -31,17: la séptima armónica, 7/4
///     FuncionDeNota.buscar(nombre: "leading tone")        // .sensible
///
/// Los nombres en los otros idiomas están en `Funciones/Nombres/`, un fichero por idioma. Dos funciones son
/// iguales si se llaman igual.
public struct FuncionDeNota: Sendable {
    /// El nombre en español: «dominante», «finalis», «tercera blue».
    public let nombre: String
    /// Otros nombres, escritos correctamente.
    public let alias: [String]
    /// Otras formas de escribir el nombre o uno de los alias, que no son otro nombre.
    public let variantes: [String]
    /// La familia: grado, modo gregoriano, rāga, maqam, blues, adorno o nota extraña.
    public let familia: FamiliaDeFuncionDeNota
    /// Lo que la separa de la tónica, de la finalis o del sa, si es siempre el mismo: la quinta justa en la dominante y
    /// en el pa; la tercera mayor en la mediante (la de la escala mayor); `nil` en las que dependen del modo (el
    /// tenor, el vādī, el ghammāz), en los adornos y en las notas extrañas.
    public let intervalo: Intervalo?
    /// Lo que se aparta en cents de `intervalo` temperado: +50 en la tercera blue (la neutra, entre la menor y la
    /// mayor) y −31,17 en la séptima blue (la armónica, 7/4); 0 en las demás.
    public let desvio: Double
    /// El grado de la escala que es, en las de la familia `grado`.
    public let nombreDeGrado: NombreDeGrado?
    /// Dónde se lee.
    package let ficha: FichaDelCatalogo

    package init(
        nombre: String, familia: FamiliaDeFuncionDeNota, intervalo: Intervalo? = nil, desvio: Double = 0,
        nombreDeGrado: NombreDeGrado? = nil, alias: [String] = [], variantes: [String] = [],
        referencias: [Referencia] = []
    ) {
        self.nombre = nombre
        self.familia = familia
        self.intervalo = intervalo
        self.desvio = desvio
        self.nombreDeGrado = nombreDeGrado
        self.alias = alias
        self.variantes = variantes
        ficha = FichaDelCatalogo(referencias: referencias)
    }

    /// Dónde se lee.
    public var referencias: [Referencia] { ficha.referencias }

    /// Los cents desde la tónica: los de `intervalo` temperado más `desvio`; `nil` si no tiene intervalo.
    public var cents: Double? { intervalo.map { Double($0.semitonos) * 100 + desvio } }

    /// La nota que es sobre una tónica: la dominante de Re es La; `nil` si no tiene intervalo.
    public func nota(sobre tonica: Nota) -> Nota? { intervalo.map { tonica + $0 } }

    /// El nombre en el idioma de la notación: «dominante», «dominant»… Una función fuera del catálogo se llama en
    /// todos los idiomas como se escribió.
    public func nombre(en notacion: Notacion) -> String { nombreTraducido(en: notacion) }
}

extension FuncionDeNota: Hashable {
    public static func == (a: FuncionDeNota, b: FuncionDeNota) -> Bool { a.nombre == b.nombre }
    public func hash(into hasher: inout Hasher) { hasher.combine(nombre) }
}

extension FuncionDeNota: Identifiable {
    /// El nombre en español, que no se repite en el catálogo.
    public var id: String { nombre }
}

extension FuncionDeNota: Nombrable, CustomStringConvertible {
    public var description: String { nombre }
}

// MARK: - Búsqueda por nombre

extension FuncionDeNota {
    /// La del catálogo con ese nombre, alias o variante en cualquier idioma, sin mirar mayúsculas, tildes, guiones ni
    /// espacios: «dominante», «leading tone», «vadi».
    public static func buscar(nombre: String) -> FuncionDeNota? { buscarNombre(nombre) }

    /// Las del catálogo cuyo nombre, alias o variante contiene el texto en algún idioma, en el orden del catálogo:
    /// «blue» da las tres blue notes.
    public static func buscar(conteniendo texto: String) -> [FuncionDeNota] { buscarConteniendo(texto) }

    /// Las del catálogo de una familia, en su orden.
    public static func todas(de familia: FamiliaDeFuncionDeNota) -> [FuncionDeNota] {
        catalogo.filter { $0.familia == familia }
    }
}

extension NombreDeGrado {
    /// La función del catálogo que es.
    public var funcion: FuncionDeNota { FuncionDeNota.catalogo.first { $0.nombreDeGrado == self }! }
}

// MARK: - Familias

/// La familia de una función de nota del catálogo.
public enum FamiliaDeFuncionDeNota: String, Hashable, Sendable, Codable, CaseIterable, Nombrable {
    /// Los grados de la escala: de la tónica a la sensible y la subtónica.
    case grado
    /// Las notas del modo gregoriano: la finalis, el tenor y la confinalis.
    case gregoriana
    /// Las notas del rāga: sa, pa, vādī, saṃvādī y nyāsa.
    case india
    /// Las notas del maqam árabe y del makam turco: qarār, ghammāz y yeden.
    case maqam
    /// Las blue notes: la tercera, la quinta y la séptima.
    case blues
    /// Los adornos: acciaccatura, mordente, grupeto y trino.
    case adorno
    /// Las notas extrañas al acorde: de paso, bordadura, apoyatura, retardo, anticipación, escapada, pedal y libre.
    case notaExtrana

    /// «grados de la escala», «scale degrees»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .grado: TextosDeTeoria.en(notacion, \.familiaDeFuncionGrado)
        case .gregoriana: TextosDeTeoria.en(notacion, \.familiaDeFuncionGregoriana)
        case .india: TextosDeTeoria.en(notacion, \.familiaDeFuncionIndia)
        case .maqam: TextosDeTeoria.en(notacion, \.familiaDeFuncionMaqam)
        case .blues: TextosDeTeoria.en(notacion, \.familiaDeFuncionBlues)
        case .adorno: TextosDeTeoria.en(notacion, \.familiaDeFuncionAdorno)
        case .notaExtrana: TextosDeTeoria.en(notacion, \.familiaDeFuncionNotaExtrana)
        }
    }
}
