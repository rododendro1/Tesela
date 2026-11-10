import Armonia

// Lo que se consulta de una escala, sin darle forma: lo mismo para el texto de `armonia`, para su salida `--json` y
// para las apps, así que se calcula en un solo sitio. Los nombres van en la notación pedida y, al lado, lo que no
// depende de ella (las clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Una escala: su nombre, sus notas, de qué escala es modo y los acordes de sus grados.
public struct EscalaPresentada: Hashable, Sendable, Codable {
    /// El acorde de un grado, con su cifrado romano: «ii» «Rem7».
    public struct AcordeDelGrado: Hashable, Sendable, Codable {
        public let grado: String
        public let cifrado: String
    }

    public let nombre: String
    public let notas: [String]
    public let clases: [Int]
    /// De qué escala es modo («Modo 2 de Do mayor»), si lo es de alguna conocida.
    public let modo: String?
    /// Las cuatríadas de cada grado, si la escala es heptatónica y todas forman un acorde conocido.
    public let acordes: [AcordeDelGrado]?

    /// Los datos de la escala, escritos en la notación.
    public init(_ escala: Escala, en notacion: Notacion) {
        nombre = escala.nombre(en: notacion)
        notas = escala.notas.map { $0.nombre(en: notacion) }
        clases = escala.notas.map(\.claseDeAltura)
        modo = PresentacionDeEscalaYAcorde.modo(de: escala, en: notacion)
        let cuatriadas = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        if cuatriadas.count == escala.notas.count, romanos.count == cuatriadas.count {
            acordes = zip(romanos, cuatriadas).map { AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion)) }
        } else {
            acordes = nil
        }
    }
}
