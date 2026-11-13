import Elementos

// MARK: - El carácter de un elemento del catálogo
//
// El carácter no sale de las notas: es lo que una tradición dice de una escala, un acorde, una progresión o un ritmo.
// Por eso cada carácter lleva su fuente, es del nombre y no de las notas (el jónico y Bilāval tienen las mismas, pero
// no el mismo carácter), y lo que no tiene fuente no tiene carácter. Los datos están en `TipoDeEscala+Caracter.swift`
// y en `Caracter+Catalogos.swift`.

/// Lo que una fuente dice del carácter de una escala, un acorde, una progresión o un ritmo: los afectos que expresa y,
/// si los da, el momento del día, la estación y la ocasión en que se toca, y lo que representa.
///
///     let frigia = TipoDeEscala.harmoniaFrigia.caracter[0]
///     frigia.afectos       // [.entusiasta]
///     frigia.testigo       // .aristoteles
///     frigia.fuente.cita   // "Monro 1894: 12–13"
public struct Caracter: Hashable, Sendable {
    /// Lo que expresa o provoca, de lo más a lo menos importante; vacío si la fuente solo da el uso.
    public let afectos: [Afecto]
    /// Cuándo se toca: la hora de un rāga, la parte de la noche de un pathet.
    public let momento: MomentoDelDia?
    /// En qué estación se toca, o a cuál corresponde.
    public let estacion: Estacion?
    /// Para qué se toca: el lamento, el banquete, la guerra.
    public let ocasion: Ocasion?
    /// Lo que representa en el orden del mundo, en China: la de gōng, el soberano.
    public let papel: PapelDeLaNota?
    /// Su fase (wǔxíng), en China: la de jué, la madera.
    public let fase: FaseDeLaNaturaleza?
    /// Quién lo dice, si es un autor antiguo que se lee en otra obra: Platón, Aristóteles, Cotón. `nil` si lo dice la
    /// propia `fuente`.
    public let testigo: TestigoDelCaracter?
    /// Dónde lo dice el `testigo`, en su numeración de siempre: «398e–399a» en la República, «1340a–b» en la Política.
    public let pasaje: String?
    /// La obra donde se lee, con las páginas si se saben.
    public let fuente: Referencia

    package init(
        _ afectos: [Afecto] = [], momento: MomentoDelDia? = nil, estacion: Estacion? = nil, ocasion: Ocasion? = nil,
        papel: PapelDeLaNota? = nil, fase: FaseDeLaNaturaleza? = nil, testigo: TestigoDelCaracter? = nil,
        pasaje: String? = nil, fuente: Referencia
    ) {
        self.afectos = afectos
        self.momento = momento
        self.estacion = estacion
        self.ocasion = ocasion
        self.papel = papel
        self.fase = fase
        self.testigo = testigo
        self.pasaje = pasaje
        self.fuente = fuente
    }

    /// El año de lo que dice: el del testigo o, si no hay, el de la fuente. Ordena los caracteres de una escala.
    public var anio: Int? { testigo?.anio ?? fuente.anio }

    /// Quién lo dice y dónde se lee: «Platón 398e–399a (Monro 1894: 7–8)», «Bor 1999».
    public func cita(en notacion: Notacion) -> String {
        guard let testigo else { return fuente.cita }
        return testigo.nombre(en: notacion) + (pasaje.map { " " + $0 } ?? "") + " (" + fuente.cita + ")"
    }

    /// Todo lo que dice, en una línea y en el idioma de la notación: «blando · banquete», «amanecer · devoto, solemne».
    public func descripcion(en notacion: Notacion) -> String {
        let usos: [(any Nombrable)?] = [momento, estacion, ocasion, papel, fase]
        let partes = usos.compactMap { $0?.nombre(en: notacion) }
        let afectos = afectos.map { $0.nombre(en: notacion) }.joined(separator: ", ")
        return (partes + (afectos.isEmpty ? [] : [afectos])).joined(separator: " · ")
    }
}

// MARK: - Los afectos

/// Lo que expresa o provoca una escala, según una fuente: un vocabulario cerrado, traducido a los trece idiomas, para
/// poder buscar y agrupar (`escalas --afecto triste`). Cada palabra traduce la de su fuente: `blando` es el *malakós*
/// de Platón; `entusiasta`, el *enthousiastikós* de Aristóteles; `templado`, el *sṓphrōn*.
public enum Afecto: String, Sendable, Codable, CaseIterable, Nombrable {
    case alegre, festivo, sereno, templado, tierno, amoroso, blando, nostalgico, inquieto, triste, lastimero
    case grave, severo, noble, solemne, majestuoso, valiente, energico, entusiasta, devoto, contemplativo

    /// El nombre en el idioma de los textos de la notación: «lastimero», «plaintive», «klagend».
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas. El `switch` no tiene `default`: un afecto nuevo no compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .alegre: TextosDeTeoria.traduccion(\.afectoAlegre)
        case .festivo: TextosDeTeoria.traduccion(\.afectoFestivo)
        case .sereno: TextosDeTeoria.traduccion(\.afectoSereno)
        case .templado: TextosDeTeoria.traduccion(\.afectoTemplado)
        case .tierno: TextosDeTeoria.traduccion(\.afectoTierno)
        case .amoroso: TextosDeTeoria.traduccion(\.afectoAmoroso)
        case .blando: TextosDeTeoria.traduccion(\.afectoBlando)
        case .nostalgico: TextosDeTeoria.traduccion(\.afectoNostalgico)
        case .inquieto: TextosDeTeoria.traduccion(\.afectoInquieto)
        case .triste: TextosDeTeoria.traduccion(\.afectoTriste)
        case .lastimero: TextosDeTeoria.traduccion(\.afectoLastimero)
        case .grave: TextosDeTeoria.traduccion(\.afectoGrave)
        case .severo: TextosDeTeoria.traduccion(\.afectoSevero)
        case .noble: TextosDeTeoria.traduccion(\.afectoNoble)
        case .solemne: TextosDeTeoria.traduccion(\.afectoSolemne)
        case .majestuoso: TextosDeTeoria.traduccion(\.afectoMajestuoso)
        case .valiente: TextosDeTeoria.traduccion(\.afectoValiente)
        case .energico: TextosDeTeoria.traduccion(\.afectoEnergico)
        case .entusiasta: TextosDeTeoria.traduccion(\.afectoEntusiasta)
        case .devoto: TextosDeTeoria.traduccion(\.afectoDevoto)
        case .contemplativo: TextosDeTeoria.traduccion(\.afectoContemplativo)
        }
    }
}

// MARK: - El uso

/// La parte del día en que se toca una escala, en tramos de tres horas como los prahar de la India: Bhairav, por la
/// mañana; Darbārī, pasada la medianoche; el pathet manyura, de madrugada.
public enum MomentoDelDia: String, Sendable, Codable, CaseIterable, Nombrable {
    /// De las 3 a las 6, antes del amanecer.
    case madrugada
    /// De las 6 a las 9, con el amanecer.
    case manana
    /// De las 9 a las 12.
    case finalDeLaManana
    /// De las 12 a las 15.
    case primeraHoraDeLaTarde
    /// De las 15 a las 18, hasta la puesta del sol.
    case tarde
    /// De las 18 a las 21, con el anochecer.
    case anochecer
    /// De las 21 a las 24.
    case noche
    /// De las 0 a las 3.
    case medianoche

    /// La hora en que empieza: 3 la madrugada, 0 la medianoche. El tramo dura tres horas.
    public var horaDeInicio: Int {
        switch self {
        case .madrugada: 3
        case .manana: 6
        case .finalDeLaManana: 9
        case .primeraHoraDeLaTarde: 12
        case .tarde: 15
        case .anochecer: 18
        case .noche: 21
        case .medianoche: 0
        }
    }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .madrugada: TextosDeTeoria.traduccion(\.momentoMadrugada)
        case .manana: TextosDeTeoria.traduccion(\.momentoManana)
        case .finalDeLaManana: TextosDeTeoria.traduccion(\.momentoFinalDeLaManana)
        case .primeraHoraDeLaTarde: TextosDeTeoria.traduccion(\.momentoPrimeraHoraDeLaTarde)
        case .tarde: TextosDeTeoria.traduccion(\.momentoTarde)
        case .anochecer: TextosDeTeoria.traduccion(\.momentoAnochecer)
        case .noche: TextosDeTeoria.traduccion(\.momentoNoche)
        case .medianoche: TextosDeTeoria.traduccion(\.momentoMedianoche)
        }
    }
}

/// La estación en que se toca una escala o a la que corresponde: Megh, las lluvias; jué, la primavera.
public enum Estacion: String, Sendable, Codable, CaseIterable, Nombrable {
    case primavera, verano, lluvias, otono, invierno

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .primavera: TextosDeTeoria.traduccion(\.estacionPrimavera)
        case .verano: TextosDeTeoria.traduccion(\.estacionVerano)
        case .lluvias: TextosDeTeoria.traduccion(\.estacionLluvias)
        case .otono: TextosDeTeoria.traduccion(\.estacionOtono)
        case .invierno: TextosDeTeoria.traduccion(\.estacionInvierno)
        }
    }
}

/// Para qué se toca: en Platón, la mixolidia es para el lamento y la lidia para el banquete; la chacona es una danza.
public enum Ocasion: String, Sendable, Codable, CaseIterable, Nombrable {
    case lamento, banquete, guerra, danza

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .lamento: TextosDeTeoria.traduccion(\.ocasionLamento)
        case .banquete: TextosDeTeoria.traduccion(\.ocasionBanquete)
        case .guerra: TextosDeTeoria.traduccion(\.ocasionGuerra)
        case .danza: TextosDeTeoria.traduccion(\.ocasionDanza)
        }
    }
}

// MARK: - Las correspondencias chinas

/// Lo que representa cada nota de la pentatónica china, y el modo que empieza en ella, según el *Yueji*: gōng, el
/// soberano; shāng, el ministro; jué, el pueblo; zhǐ, los asuntos; yǔ, las cosas.
public enum PapelDeLaNota: String, Sendable, Codable, CaseIterable, Nombrable {
    case soberano, ministro, pueblo, asuntos, cosas

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .soberano: TextosDeTeoria.traduccion(\.papelSoberano)
        case .ministro: TextosDeTeoria.traduccion(\.papelMinistro)
        case .pueblo: TextosDeTeoria.traduccion(\.papelPueblo)
        case .asuntos: TextosDeTeoria.traduccion(\.papelAsuntos)
        case .cosas: TextosDeTeoria.traduccion(\.papelCosas)
        }
    }
}

/// Las cinco fases (wǔxíng) que el *Lüshi Chunqiu* da a las cinco notas: jué, la madera; zhǐ, el fuego; gōng, la
/// tierra; shāng, el metal; yǔ, el agua.
public enum FaseDeLaNaturaleza: String, Sendable, Codable, CaseIterable, Nombrable {
    case madera, fuego, tierra, metal, agua

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .madera: TextosDeTeoria.traduccion(\.faseMadera)
        case .fuego: TextosDeTeoria.traduccion(\.faseFuego)
        case .tierra: TextosDeTeoria.traduccion(\.faseTierra)
        case .metal: TextosDeTeoria.traduccion(\.faseMetal)
        case .agua: TextosDeTeoria.traduccion(\.faseAgua)
        }
    }
}

// MARK: - Quién lo dice

/// Los autores antiguos que describen el carácter de una escala y que se leen en una obra moderna: Platón y
/// Aristóteles, en Monro; Cotón, en la traducción de Babb.
public enum TestigoDelCaracter: String, Sendable, Codable, CaseIterable, Nombrable {
    /// Platón, la *República* (hacia 375 a. C.).
    case platon
    /// Heraclides Póntico (hacia 340 a. C.), en el libro XIV de Ateneo.
    case heraclides
    /// Aristóteles, la *Política* (hacia 330 a. C.).
    case aristoteles
    /// Los *Problemas* atribuidos a Aristóteles, libro XIX (hacia 300 a. C.).
    case problemas
    /// El *Lüshi Chunqiu* (239 a. C.).
    case lushiChunqiu
    /// El *Yueji*, el capítulo de la música del *Liji* (hacia 100 a. C.).
    case yueji
    /// Johannes Afflighemensis (Cotón), *De musica* (hacia 1100).
    case coton

    /// El año aproximado (negativo antes de Cristo). El `switch` no tiene `default`.
    public var anio: Int {
        switch self {
        case .platon: -375
        case .heraclides: -340
        case .aristoteles: -330
        case .problemas: -300
        case .lushiChunqiu: -239
        case .yueji: -100
        case .coton: 1100
        }
    }

    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .platon: TextosDeTeoria.traduccion(\.testigoPlaton)
        case .heraclides: TextosDeTeoria.traduccion(\.testigoHeraclides)
        case .aristoteles: TextosDeTeoria.traduccion(\.testigoAristoteles)
        case .problemas: TextosDeTeoria.traduccion(\.testigoProblemas)
        case .lushiChunqiu: TextosDeTeoria.traduccion(\.fuenteLushiChunqiu)
        case .yueji: TextosDeTeoria.traduccion(\.testigoYueji)
        case .coton: TextosDeTeoria.traduccion(\.testigoCoton)
        }
    }
}
