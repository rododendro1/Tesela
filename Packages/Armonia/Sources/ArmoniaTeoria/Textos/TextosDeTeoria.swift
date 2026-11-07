// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaElementos
// MARK: - Textos de ArmoniaTeoria
//
// Un idioma por fichero: `TextosDeTeoria+Espanol.swift`, `TextosDeTeoria+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los quince y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaTeoria en un idioma.
struct TextosDeTeoria: TextosTraducidos {
    // MARK: AfinacionHistorica.swift
    let temperamentoIgual: String
    let pitagorico: String
    let mesotonico: String
    let werckmeisterIII: String
    let kirnbergerIII: String
    let vallotti: String
    let young: String
    let afinacionJusta: String

    // MARK: Acorde.swift
    /// Un acorde en estado fundamental con otro bajo: «Do mayor, con bajo en Re», «C major over D».
    let conBajoEn: @Sendable (_ acorde: String, _ bajo: String) -> String
    let nombresDeLasInversiones: [String]
    let inversionConNumero: String

    // MARK: CicloNeorriemanniano.swift
    let cicloHexatonico: String
    let cicloOctatonico: String
    let cicloLR: String

    // MARK: ConduccionParsimoniosa.swift
    let semitonos: @Sendable (Int) -> String

    // MARK: TransformacionNeorriemanniana.swift
    let homonima: String
    let cambioDeSensible: String
    let relativa: String

    // MARK: EstructuraDeAcorde.swift
    let papelFundamental: String
    let papelTercera: String
    let papelSuspension: String
    let papelQuinta: String
    let papelSexta: String
    let papelSeptima: String
    let papelNovena: String
    let papelUndecima: String
    let papelDecimotercera: String
    let papelTension: @Sendable (Int) -> String
    let triadaMayor: String
    let triadaMenor: String
    let triadaDisminuida: String
    let triadaAumentada: String
    let triadaSuspendida: String
    let triadaDeQuinta: String
    let triadaSinTercera: String

    // MARK: TipoDeAcorde.swift
    let acordeDesconocido: @Sendable (Bool, String, String) -> String
    let tipoMayor: String
    let tipoMenor: String
    let tipoDisminuido: String
    let tipoAumentado: String
    let tipoSuspendidoDeSegunda: String
    let tipoSuspendidoDeCuarta: String
    let tipoQuintaAcordeDePotencia: String
    let tipoSeptimaDeDominante: String
    let tipoSeptimaMayor: String
    let tipoMenorSeptima: String
    let tipoSemidisminuido: String
    let tipoSeptimaDisminuida: String
    let tipoMenorConSeptimaMayor: String
    let tipoAumentadoConSeptimaMenor: String
    let tipoAumentadoConSeptimaMayor: String
    let tipoSeptimaSuspendida: String
    let tipoSexta: String
    let tipoMenorSexta: String
    let tipoSextaYNovena: String
    let tipoNovenaDeDominante: String
    let tipoNovenaMayor: String
    let tipoMenorNovena: String
    let tipoNovenaAnadida: String
    let tipoUndecima: String
    let tipoMenorUndecima: String
    let tipoDecimotercera: String
    let tipoMenorDecimotercera: String
    let tipoSeptimaConNovenaMenor: String
    let tipoSextaAumentadaItaliana: String
    let tipoSextaAumentadaFrancesa: String
    let tipoSextaAumentadaAlemana: String

    // MARK: Coral.swift
    let entreLasVoces: @Sendable ([String]) -> String
    let enLaVoz: @Sendable (String) -> String
    let enLosAcordes: @Sendable (String) -> String
    let enElAcorde: @Sendable (Int) -> String
    let quintasParalelas: String
    let octavasParalelas: String
    let quintasDirectas: String
    let octavasDirectas: String
    let cruceDeVoces: String
    let superposicion: String
    let separacionExcesiva: String
    let saltoNoMelodico: String
    let fueraDeTesitura: String
    let vozBajo: String
    let vozTenor: String
    let vozContralto: String
    let vozSoprano: String
    let vozNumero: @Sendable (Int) -> String

    // MARK: Escala.swift
    let gradoTonica: String
    let gradoSupertonica: String
    let gradoMediante: String
    let gradoSubdominante: String
    let gradoDominante: String
    let gradoSuperdominante: String
    let gradoSensible: String
    let gradoSubtonica: String

    // MARK: AnalisisArmonico.swift
    let funcionTonica: String
    let funcionSubdominante: String
    let funcionDominante: String

    // MARK: Cadencia.swift
    let cadenciaEnLosAcordes: @Sendable (String) -> String
    let cadenciaAutentica: String
    let cadenciaPlagal: String
    let cadenciaRota: String
    let semicadencia: String
    let semicadenciaFrigia: String
    let cadenciaPlagalMenor: String

    // MARK: RecorridoTonal.swift
    let deUnaTonalidadAOtra: @Sendable (String, String, Int) -> String
    let pivote: String
    let directa: String

    // MARK: Arpegio.swift
    let arpegioDe: @Sendable (String) -> String
    let patronAscendente: String
    let patronDescendente: String
    let patronIdaYVuelta: String
    let patronAlberti: String
    let patronQuebrado: String
    let patronBajaYSube: String
    let aproximacionDesdeAbajo: String
    let aproximacionDesdeArriba: String
    let aproximacionEncierro: String

    // MARK: Escala+Acorde.swift
    let papelNotaDelAcorde: String
    let papelTensionDisponible: String
    let papelNotaAEvitar: String
    /// Una escala como modo de otra: «modo 2 de Do mayor», «mode 2 of C major».
    let modoDe: @Sendable (_ modo: Int, _ escala: String) -> String

    // MARK: NotaExtrana.swift
    /// En el orden de `NotaExtrana.allCases`: nota de paso, bordadura, apoyatura, retardo, anticipación, escapada,
    /// pedal y libre.
    let nombresDeNotasExtranas: [String]

    // MARK: EsquemaArmonico.swift
    /// En el orden de `EsquemaArmonico.Tipo.allCases`.
    let nombresDeEsquemas: [String]

    // MARK: Rearmonizacion.swift
    let sustitutoTritonal: String
    let dominanteSecundaria: String
    let prestamoModal: String
    let sustitutoDiatonico: String
    let rearmonizacionIIV: String
    let rearmonizacionBackdoor: String
    let rearmonizacionIIRelativo: String
    let rearmonizacionDisminuido: String
    let secuenciaTerceras: String
    let secuenciaCuartas: String
    let secuenciaGruposDeTres: String
    let secuenciaGruposDeCuatro: String
    let secuenciaTriadas: String
    let secuenciaCuatriadas: String

    // MARK: ErrorDeLecturaDeTeoria.swift (acordes)
    let simboloNoReconocido: @Sendable (String) -> String
    let tensionNoValida: @Sendable (String) -> String
    let numeroDeAcordeNoValido: @Sendable (Int) -> String
    let numeroRepetido: @Sendable (Int) -> String
    let disminuidoYSemidisminuido: String
    let quintaConCalidad: String
    let fundamentalNoOmitible: String
    let gradoNoOmitible: @Sendable (Int) -> String
    let faltaLaFundamental: String
    let intervaloSinPapel: @Sendable (Intervalo, Notacion) -> String
    let terceraMayorYMenor: String
    let variasSeptimas: String
    let septimaDisminuidaFueraDelDisminuido: String
    let noEsPorTerceras: String
    let bajoNoValido: @Sendable (String) -> String
    let idiomasMezclados: @Sendable (String) -> String

    // MARK: ErrorDeLecturaDeTeoria.swift (escalas)
    let modoNoReconocido: @Sendable (String) -> String
    let faltaElTipoDeEscala: String
    let tipoDeEscalaNoReconocido: @Sendable (String) -> String

    // MARK: ErrorDeLecturaDeTeoria.swift (coral)
    let vocesDistintas: String
    let vocesDeDistintaLongitud: String

    // MARK: ErrorDeLecturaDeTeoria.swift (nombres y digitaciones)
    let nombreNoReconocido: @Sendable (_ nombre: String, _ opciones: String) -> String
    let numeroFueraDeRango: @Sendable (_ texto: String, _ desde: Int, _ hasta: Int) -> String
    let trasteNoValido: @Sendable (_ traste: String, _ ultimo: Int) -> String
    let cuerdasDistintas: @Sendable (_ esperadas: Int, _ leidas: Int) -> String

    // MARK: ErrorDeLecturaDeTeoria.swift (cifrado romano y bajo cifrado)
    let cifradoRomanoNoValido: @Sendable (String) -> String
    let destinoNoTonicalizable: @Sendable (String) -> String
    let cifrasNoValidas: @Sendable (String) -> String
    let cifrasSinAcorde: @Sendable (String) -> String

    // MARK: UsoDeEscala.swift
    let usoClasica: String
    let usoJazz: String
    let usoBlues: String
    let usoSigloXX: String
    let usoPopular: String
    let usoSintetica: String

    // MARK: CardinalDeEscala.swift
    let cardinalMonotonica: String
    let cardinalDitonica: String
    let cardinalTritonica: String
    let cardinalTetratonica: String
    let cardinalPentatonica: String
    let cardinalHexatonica: String
    let cardinalHeptatonica: String
    let cardinalOctatonica: String
    let cardinalNonatonica: String
    let cardinalDecatonica: String
    let cardinalEndecatonica: String
    let cardinalDodecatonica: String

    // MARK: Tradicion+Nombre.swift
    let tradicionIndia: String
    let tradicionGrecia: String
    let tradicionGreciaAntigua: String
    let tradicionMundoArabe: String
    let tradicionPersia: String
    let tradicionTurquia: String
    let tradicionAzerbaiyan: String
    let tradicionChina: String
    let tradicionJapon: String
    let tradicionCorea: String
    let tradicionEtiopia: String
    let tradicionIndonesia: String
    let tradicionKlezmer: String
    let tradicionAndes: String
    let tradicionBizancio: String
    let tradicionMesopotamia: String
    let tradicionAfrica: String
    let tradicionSudesteAsiatico: String
    let tradicionGregoriano: String
    let tradicionEuropa: String
    let tradicionVietnam: String
    let tradicionBrasil: String

    // MARK: Subtradicion.swift
    let subtradicionCarnatica: String
    let subtradicionIndostanica: String
    let subtradicionIndiaAntigua: String
    let subtradicionJava: String
    let subtradicionBali: String
    let subtradicionSunda: String
    let subtradicionTailandia: String
    let subtradicionCamboya: String
    let subtradicionBirmania: String
    let subtradicionBuganda: String
    let subtradicionChopi: String
    let subtradicionMandinga: String
    let subtradicionShona: String
    let subtradicionUcrania: String
    let subtradicionPolonia: String
    let subtradicionHungria: String
    let subtradicionAlpes: String
    let subtradicionEscocia: String
    let subtradicionGeorgia: String
    let subtradicionGagaku: String
    let subtradicionRyukyu: String

    // MARK: FuenteTeorica.swift
    let fuenteArquitas: String
    let fuenteAristoxeno: String
    let fuenteEratostenes: String
    let fuenteDidimo: String
    let fuentePtolomeo: String
    let fuenteAristides: String
    let fuenteGuido: String
    let fuenteGlareano: String
    let fuenteSafiAlDin: String

    // MARK: Gramática (Acorde.swift, Tonalidad.swift)
    /// El tipo de un acorde sobre su fundamental: «Do mayor», «Dominantseptakkord auf G».
    let acordeSobre: @Sendable (_ tipo: String, _ raiz: String) -> String
    /// «en Do mayor», «in C major», «в до мажоре», «do maiorrean».
    let enLaTonalidad: @Sendable (String) -> String

    /// Los textos en los quince idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeTeoria>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro)
}
