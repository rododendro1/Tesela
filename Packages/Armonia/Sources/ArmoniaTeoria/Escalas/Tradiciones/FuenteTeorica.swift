import ArmoniaElementos

// MARK: - Fuente teórica de una escala

/// El teórico que definió una escala: el autor de unas razones (los géneros de Arquitas, Dídimo, Eratóstenes y
/// Ptolomeo), de unas partes del tono (los colores de Aristóxeno), de unas especies (las harmoniai de Arístides
/// Quintiliano) o de un sistema (los hexacordos de Guido d'Arezzo, los modos que añadió Glareano, los shudūd de Ṣafī
/// al-Dīn, las cinco notas del Guanzi, los doce lü del Lüshi chunqiu y los géneros de Vicentino).
///
/// Una escala la lleva en su declaración (`fuente: .ptolomeo`). Las que no son de un autor concreto (las siete
/// harmoniai, los modos gregorianos) no la llevan. No es la `fuente` de una afinación
/// (`TipoDeEscalaMicrotonal.fuente`), que es texto libre y dice quién midió una versión microtonal.
///
///     TipoDeEscala.tetracordoDiatonicoTenso.fuente   // .ptolomeo
///     TipoDeEscala.tradicionales(fuente: .didimo)    // sus tres tetracordos
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

    /// La tradición de sus escalas. El `switch` no tiene `default`: una fuente nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .arquitas, .aristoxeno, .eratostenes, .didimo, .ptolomeo, .aristides: .greciaAntigua
        case .guido, .glareano: .gregoriano
        case .safiAlDin: .mundoArabe
        case .guanzi, .lushiChunqiu: .china
        case .vicentino: .renacimiento
        }
    }

    /// El nombre en el idioma de los textos de la notación: «Ptolomeo», «Ptolemy», «Ptolémée», «Птолемей».
    /// En español, también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los quince idiomas, de los `TextosDeTeoria`.
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

    /// Las escalas de otras tradiciones de una fuente, en el orden del catálogo: `tradicionales(fuente: .ptolomeo)`
    /// da los siete géneros de las Harmónicas.
    public static func tradicionales(fuente: FuenteTeorica) -> [TipoDeEscala] {
        tradicionales.filter { $0.fuente == fuente }
    }
}
