import Elementos

// MARK: - Fuente teórica de una escala

/// El teórico que definió una escala o una de sus afinaciones: el autor de unas razones (los géneros de Arquitas,
/// Dídimo, Eratóstenes y Ptolomeo), de unas partes del tono (los colores de Aristóxeno), de unas especies (las
/// harmoniai de Arístides Quintiliano) o de un sistema (los hexacordos de Guido d'Arezzo, los modos que añadió
/// Glareano, los shudūd de Ṣafī al-Dīn, las cinco notas del Guanzi, los doce lü del Lüshi chunqiu y los géneros de
/// Vicentino); o el que midió de otra manera una escala que ya había (los echoi de Crisanto, la entonación justa de
/// Ramos de Pareja, Zarlino y Salinas, el temperamento igual de Zhu Zaiyu).
///
/// Una escala la lleva en su declaración (`fuente: .ptolomeo`), y una afinación en la suya
/// (`.init(.razones, pasos: […], fuente: .zarlino)`). Las que no son de un autor concreto (las siete harmoniai, los
/// modos gregorianos, la primera afinación de cada escala, la de su teoría de hoy) no la llevan.
///
///     TipoDeEscala.tetracordoDiatonicoTenso.fuente             // .ptolomeo
///     TipoDeEscala.echosProtos.afinaciones[1].fuente           // .chrysanthos
///     TipoDeEscala.tradicionales(fuente: .didimo)              // sus tres tetracordos
public enum FuenteTeorica: String, Sendable, Codable, CaseIterable {
    /// Arquitas de Tarento: el cromático, el diatónico y el enarmónico, en razones.
    case arquitas
    /// Aristóxeno de Tarento: los tres tetracordos y sus colores, en doceavos de tono.
    case aristoxeno
    /// Eratóstenes de Cirene: su cromático y su enarmónico.
    case eratostenes
    /// Dídimo el músico: su cromático, su diatónico y su enarmónico.
    case didimo
    /// Claudio Ptolomeo: los géneros de las Harmónicas, del enarmónico al diatónico igual.
    case ptolomeo
    /// Arístides Quintiliano: las harmoniai antiguas que recoge en *Sobre la música*.
    case aristides
    /// Guido d'Arezzo: los tres hexacordos de la solmisación.
    case guido
    /// Heinrich Glareano: los cuatro modos que añadió en el Dodecachordon (1547).
    case glareano
    /// Ṣafī al-Dīn al-Urmawī: los modos (shudūd) del Kitāb al-adwār, en diecisiete notas pitagóricas.
    case safiAlDin
    /// El Guanzi (管子), capítulo «Diyuan» (s. IV a. C.): las cinco notas de la pentatónica, por sanfen sunyi.
    case guanzi
    /// El Lüshi chunqiu (吕氏春秋, 239 a. C.): los doce lü, por sanfen sunyi desde huángzhōng.
    case lushiChunqiu
    /// Nicola Vicentino: los tres géneros de L'antica musica (1555), en 31 diesis por octava.
    case vicentino
    /// Crisanto de Madito: los echoi del Theōrētikon mega tēs mousikēs (1832), en 68 partes de la octava.
    case chrysanthos
    /// Bartolomé Ramos de Pareja: la Musica practica (1482), con las terceras puras.
    case ramosDePareja
    /// Gioseffo Zarlino: el temperamento de dos séptimos de coma de las Istitutioni harmoniche (1558).
    case zarlino
    /// Francisco de Salinas: el temperamento de un tercio de coma del De musica libri septem (1577).
    case salinas
    /// Zhu Zaiyu (朱載堉): el temperamento igual de los doce lü (1584), con la raíz duodécima de dos.
    case zhuZaiyu

    /// La tradición de sus escalas. El `switch` no tiene `default`: una fuente nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .arquitas, .aristoxeno, .eratostenes, .didimo, .ptolomeo, .aristides: .greciaAntigua
        case .guido, .glareano: .gregoriano
        case .safiAlDin: .mundoArabe
        case .guanzi, .lushiChunqiu, .zhuZaiyu: .china
        case .vicentino, .ramosDePareja, .zarlino, .salinas: .renacimiento
        case .chrysanthos: .bizancio
        }
    }

    /// El nombre en el idioma de los textos de la notación: «Ptolomeo», «Ptolemy», «Ptolémée», «Птолемей».
    /// En español, también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .arquitas: TextosDeTeoria.traduccion(\.fuenteArquitas)
        case .aristoxeno: TextosDeTeoria.traduccion(\.fuenteAristoxeno)
        case .eratostenes: TextosDeTeoria.traduccion(\.fuenteEratostenes)
        case .didimo: TextosDeTeoria.traduccion(\.fuenteDidimo)
        case .ptolomeo: TextosDeTeoria.traduccion(\.fuentePtolomeo)
        case .aristides: TextosDeTeoria.traduccion(\.fuenteAristides)
        case .guido: TextosDeTeoria.traduccion(\.fuenteGuido)
        case .glareano: TextosDeTeoria.traduccion(\.fuenteGlareano)
        case .safiAlDin: TextosDeTeoria.traduccion(\.fuenteSafiAlDin)
        case .guanzi: TextosDeTeoria.traduccion(\.fuenteGuanzi)
        case .lushiChunqiu: TextosDeTeoria.traduccion(\.fuenteLushiChunqiu)
        case .vicentino: TextosDeTeoria.traduccion(\.fuenteVicentino)
        case .chrysanthos: TextosDeTeoria.traduccion(\.fuenteChrysanthos)
        case .ramosDePareja: TextosDeTeoria.traduccion(\.fuenteRamosDePareja)
        case .zarlino: TextosDeTeoria.traduccion(\.fuenteZarlino)
        case .salinas: TextosDeTeoria.traduccion(\.fuenteSalinas)
        case .zhuZaiyu: TextosDeTeoria.traduccion(\.fuenteZhuZaiyu)
        }
    }
}

extension FuenteTeorica: Nombrable {}

extension TipoDeEscala {
    /// El teórico que definió la escala (`.ptolomeo`, `.aristoxeno`, `.glareano`…); `nil` en las occidentales, en las
    /// propias y en las de otras tradiciones que no son de un autor concreto. Como `categoria`, por su identidad.
    ///
    ///     TipoDeEscala.tetracordoCromaticoDeArquitas.fuente   // .arquitas
    ///     TipoDeEscala.ionicus.fuente                          // .glareano
    public var fuente: FuenteTeorica? { fichaDelCatalogo.fuente }

    /// Las escalas de otras tradiciones de una fuente, en el orden del catálogo: las que definió y las que afinó.
    /// `tradicionales(fuente: .ptolomeo)` da los siete géneros de las Harmónicas; `tradicionales(fuente: .zarlino)`,
    /// las escalas del Renacimiento que midió en entonación justa.
    public static func tradicionales(fuente: FuenteTeorica) -> [TipoDeEscala] {
        tradicionales.filter { $0.fuente == fuente || $0.afinaciones.contains { $0.fuente == fuente } }
    }
}
