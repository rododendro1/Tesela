import Armonia

// Lo que se consulta de una tonalidad, sin darle forma: lo mismo para el texto de `armonia tonalidad` y para su salida
// `--json`, así que se calcula en un solo sitio. Sus nombres son las claves del JSON: en español, sin tildes y siempre
// las mismas, sea cual sea el idioma. Lo que es `nil` no sale en el JSON.

/// Una tonalidad: su armadura, sus notas, sus relativas, las cuatríadas de sus grados y su carácter.
///
///     let datos = TonalidadPresentada(Tonalidad(.fa), en: .compacta(.espanol))
///     datos.armadura       // -1
///     datos.alteraciones   // ["Si♭"]
public struct TonalidadPresentada: Hashable, Sendable, Codable {
    public let nombre: String
    public let tonica: String
    /// «mayor» o «menor», siempre en español: es un dato, no un texto.
    public let modo: String
    /// Las alteraciones de la armadura: positivas los sostenidos y negativas los bemoles.
    public let armadura: Int
    public let alteraciones: [String]
    public let notas: [String]
    public let clases: [Int]
    public let relativa: String
    public let homonima: String
    /// Las cuatríadas de cada grado, con su cifrado romano.
    public let acordes: [EscalaPresentada.AcordeDelGrado]
    /// Lo que dicen sus fuentes de su carácter (Charpentier, Schubart); `nil` si ninguna dice nada.
    public let caracter: [CaracterPresentado]?
    /// Los pares de fuentes que no coinciden en nada: «Charpentier · Schubart».
    public let discrepancias: [String]?

    public init(_ tonalidad: Tonalidad, en notacion: Notacion) {
        let escala = tonalidad.escala.notas
        nombre = tonalidad.nombre(en: notacion)
        tonica = tonalidad.tonica.nombre(en: notacion)
        modo = tonalidad.modo == .mayor ? "mayor" : "menor"
        armadura = tonalidad.armadura
        alteraciones = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }
        notas = escala.map { $0.nombre(en: notacion) }
        clases = escala.map(\.claseDeAltura)
        relativa = tonalidad.relativa.nombre(en: notacion)
        homonima = tonalidad.homonima.nombre(en: notacion)
        acordes = zip(tonalidad.cifradosRomanos(cuatriadas: true), tonalidad.armonizar(cuatriadas: true)).map {
            EscalaPresentada.AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion))
        }
        caracter = CaracterPresentado.de(tonalidad.caracter, en: notacion)
        discrepancias = CaracterPresentado.discrepancias(tonalidad.caracter, en: notacion)
    }
}
