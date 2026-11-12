// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Teoria
//
// Un idioma por fichero: `TextosDeTeoria+Espanol.swift`, `TextosDeTeoria+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Teoria en un idioma.
struct TextosDeTeoria: TextosTraducidos {
    let familiaDeRitmoLineaDeTiempo: String
    let familiaDeRitmoFlamenco: String
    let familiaDeRitmoTala: String
    let familiaDeRitmoIqa: String
    let familiaDeRitmoAksak: String
    let familiaDeRitmoModoRitmico: String
    let familiaDeRitmoDanza: String
    let familiaDeTemperamentoRegular: String
    let familiaDeTemperamentoCircular: String
    let familiaDeTemperamentoJusta: String
    let familiaDeTemperamentoDivisionesIguales: String
    let familiaDeTemperamentoTradicional: String
    let familiaDeNotaDiapason: String
    let familiaDeNotaReferencia: String
    let familiaDeNotaGuidoniana: String
    let familiaDeNotaArabe: String
    let familiaDeNotaTurca: String
    let familiaDeNotaGriega: String
    let familiaDeFuncionGrado: String
    let familiaDeFuncionGregoriana: String
    let familiaDeFuncionIndia: String
    let familiaDeFuncionMaqam: String
    let familiaDeFuncionBlues: String
    let familiaDeFuncionAdorno: String
    let familiaDeFuncionNotaExtrana: String

    // MARK: Acorde.swift
    /// Un acorde en estado fundamental con otro bajo: «Do mayor, con bajo en Re», «C major over D».
    let conBajoEn: Plantilla  // {1} acorde, {2} bajo
    let nombresDeLasInversiones: [String]
    let inversionConNumero: Plantilla  // {1} número

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
    let cadenciaEnLosAcordes: Plantilla  // {1} pasos
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
    let arpegioDe: Plantilla  // {1} acorde
    let patronAscendente: String
    let patronDescendente: String
    let patronIdaYVuelta: String
    /// Escala+Tetracordos.swift.
    let tetracordoGriego: Plantilla  // {1} nombre griego (en su alfabeto en griego)
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
    let simboloNoReconocido: Plantilla  // {1} simbolo
    let tensionNoValida: Plantilla  // {1} tension
    let numeroDeAcordeNoValido: Plantilla  // {1} numero
    let numeroRepetido: Plantilla  // {1} numero
    let disminuidoYSemidisminuido: String
    let quintaConCalidad: String
    let fundamentalNoOmitible: String
    let gradoNoOmitible: Plantilla  // {1} grado
    let faltaLaFundamental: String
    let intervaloSinPapel: @Sendable (Intervalo, Notacion) -> String
    let terceraMayorYMenor: String
    let variasSeptimas: String
    let septimaDisminuidaFueraDelDisminuido: String
    let noEsPorTerceras: String
    let bajoNoValido: Plantilla  // {1} bajo
    let idiomasMezclados: Plantilla  // {1} nombre

    // MARK: ErrorDeLecturaDeTeoria.swift (escalas)
    let modoNoReconocido: Plantilla  // {1} nombre
    let faltaElTipoDeEscala: String
    let tipoDeEscalaNoReconocido: Plantilla  // {1} nombre

    // MARK: ErrorDeLecturaDeTeoria.swift (coral)
    let vocesDistintas: String
    let vocesDeDistintaLongitud: String

    // MARK: ErrorDeLecturaDeTeoria.swift (nombres y digitaciones)
    let nombreNoReconocido: Plantilla  // {1} nombre, {2} opciones
    let numeroFueraDeRango: Plantilla  // {1} texto, {2} desde, {3} hasta
    let trasteNoValido: Plantilla  // {1} traste, {2} ultimo
    let cuerdasDistintas: Plantilla  // {1} esperadas, {2} leidas

    // MARK: ErrorDeLecturaDeTeoria.swift (cifrado romano y bajo cifrado)
    let cifradoRomanoNoValido: Plantilla  // {1} cifrado
    let destinoNoTonicalizable: Plantilla  // {1} destino
    let cifrasNoValidas: Plantilla  // {1} cifras
    let cifrasSinAcorde: Plantilla  // {1} cifras

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

    // MARK: Epoca.swift
    let epocaAntiguedad: String
    let epocaEdadMedia: String
    let epocaRenacimiento: String
    let epocaTonal: String
    let epocaSigloXX: String

    // MARK: CardinalDeAcorde.swift
    let cardinalDiada: String
    let cardinalTriada: String
    let cardinalTetrada: String
    let cardinalPentada: String
    let cardinalHexada: String
    let cardinalHeptada: String
    let cardinalOctada: String

    // MARK: Tradicion+Nombre.swift
    let tradicionOccidental: String
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
    let tradicionRenacimiento: String

    // MARK: Estilo.swift y RegionDeEscala.swift
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
    let subtradicionIstria: String
    let subtradicionAndalucia: String
    let subtradicionRumania: String

    // MARK: Geografia.swift
    let continenteEuropa: String
    let continenteAsia: String
    let continenteAfrica: String
    let continenteAmerica: String
    let continenteOceania: String
    let paisEspana: String
    let paisReinoUnido: String
    let paisSuiza: String
    let paisAustria: String
    let paisCroacia: String
    let paisEslovenia: String
    let paisUcrania: String
    let paisPolonia: String
    let paisHungria: String
    let paisRumania: String
    let paisGeorgia: String
    let paisGrecia: String
    let paisTurquia: String
    let paisAzerbaiyan: String
    let paisIran: String
    let paisIrak: String
    let paisIndia: String
    let paisChina: String
    let paisJapon: String
    let paisCoreaDelSur: String
    let paisCoreaDelNorte: String
    let paisVietnam: String
    let paisIndonesia: String
    let paisTailandia: String
    let paisCamboya: String
    let paisMyanmar: String
    let paisUganda: String
    let paisMozambique: String
    let paisZimbabue: String
    let paisMali: String
    let paisSenegal: String
    let paisGambia: String
    let paisGuinea: String
    let paisEtiopia: String
    let paisBrasil: String
    let paisPeru: String
    let paisBolivia: String
    let paisEcuador: String
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
    let fuenteGuanzi: String
    let fuenteLushiChunqiu: String
    let fuenteVicentino: String
    let fuenteChrysanthos: String
    let fuenteRamosDePareja: String
    let fuenteZarlino: String
    let fuenteSalinas: String
    let fuenteZhuZaiyu: String

    // MARK: Gramática (Acorde.swift, Tonalidad.swift)
    /// El tipo de un acorde sobre su fundamental: «Do mayor», «Dominantseptakkord auf G».
    let acordeSobre: Plantilla  // {1} tipo, {2} raiz
    /// «en Do mayor», «in C major», «в до мажоре», «do maiorrean».
    let enLaTonalidad: @Sendable (String) -> String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeTeoria>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
