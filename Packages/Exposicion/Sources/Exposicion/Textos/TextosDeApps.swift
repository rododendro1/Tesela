// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// MARK: - Textos de las apps
//
// Un idioma por fichero: `TextosDeApps+Espanol.swift`, `TextosDeApps+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de la interfaz de las apps en un idioma: los de las pestañas, secciones y etiquetas, que se leen con
/// `Notacion.texto(_:)`, los avisos y las tareas de `PresentacionDeCoral` y los nombres de `FicheroParaExportar`.
///
///     Notacion.ascii(.ingles).texto(\.digitaciones)    // "Fingerings"
public struct TextosDeApps: TextosTraducidos {
    // MARK: Notacion+TextosDeApps.swift y las vistas
    public let acordes: String
    public let escalas: String
    public let analisis: String
    public let coral: String
    public let acorde: String
    public let campoDeCifrado: Plantilla  // {1} ejemplo
    public let informacion: String
    public let nombre: String
    public let cifrado: String
    public let notas: String
    public let digitaciones: String
    public let arpegio: String
    public let patron: String
    public let arpegioEnElMastil: String
    public let trastes: Plantilla  // {1} desde, {2} hasta
    public let escalasCompatibles: String
    public let identificar: String
    public let tocaElMastil: String
    public let tocaNotas: String
    public let borrar: String
    public let sinAcordeConocido: String
    public let verEnAcordes: String
    public let tecladoMIDI: String
    public let dispositivosMIDI: String
    public let teoriaPostonal: String
    public let formaPrima: String
    public let numeroDeForte: String
    public let vectorIntervalico: String
    public let instrumentoYAfinacion: String
    public let sinDigitaciones: String
    public let calculando: String
    public let dedos: @Sendable (Int) -> String
    public let cejilla: Plantilla  // {1} traste
    public let escala: String
    public let tonica: String
    public let tipo: String
    public let habituales: String
    public let otrasTradiciones: String
    public let acordesDeLaEscala: String
    public let posicionesEnElMastil: String
    public let notasPorCuerda: @Sendable (Int) -> String
    public let forma: Plantilla  // {1} forma
    public let mastilDeGuitarra: String
    public let pentagrama: String
    public let progresion: String
    public let campoDeProgresion: String
    public let resultado: String
    public let acordeAAcorde: String
    public let arpegiar: String
    public let cadencias: String
    public let tarea: String
    public let campoDeTonalidad: String
    public let tonalidad: String
    public let armonizaciones: String
    public let aCuatroVoces: String
    public let conduccionDeLasVoces: String
    public let avisos: String
    public let recorridoPLR: String
    public let modo: String
    public let red: String
    public let formatoUIL: String
    public let giro: String
    public let espejo: String
    public let ejesHV: String
    public let rejilla: String
    public let notaDeOrigen: String
    public let enTono: String
    public let noSeDibuja: String
    public let campoDeTriadaInicial: Plantilla  // {1} ejemplo
    public let reiniciar: String
    public let deshacer: String
    public let textos: String
    public let comoLasNotas: String
    public let octavaEnSubindice: String
    /// El interruptor del selector que escribe el ruso y el griego en el alfabeto latino (ISO 9 y ELOT 743).
    public let alfabetoLatino: String
    public let octavas: String
    public let conLaOctavaFinal: String
    public let figura: String
    public let empezarEn: String
    public let porGrados: String
    public let aproximacion: String
    public let tresillos: String
    public let swing: String
    public let enlazarLosAcordes: String
    public let porPosiciones: String
    public let dedosSugeridos: String
    public let tempo: Plantilla  // {1} negras por minuto
    public let sinCapo: String
    public let capo: Plantilla  // {1} traste
    public let rearmonizar: String
    public let aplicar: String
    public let detener: String
    public let transponer: String
    public let escuchar: String
    public let afinacionAlEscuchar: String
    public let exportar: String
    public let abrir: String
    public let rejillaHexagonal: String
    public let casillas: @Sendable (Int) -> String
    public let elegida: String
    public let mastilDe: @Sendable (String, Int, Int) -> String
    public let posicion: Plantilla  // {1} cuerda, {2} traste
    public let marcas: @Sendable (Int) -> String
    public let cuerdasApagadas: Plantilla  // {1} lista
    public let sinMarcas: String

    // MARK: PresentacionDeCoral.swift
    public let sinArmonizacion: String
    public let faltanOctavas: Plantilla  // {1} ejemplo
    public let sinCoralParaLaMelodia: Plantilla  // {1} grave, {2} agudo
    public let sinRealizacion: String
    public let sinFaltasDeConduccion: String
    public let armonizar: String
    public let realizar: String
    public let revisar: String
    public let indicacionArmonizar: Plantilla  // {1} ejemplo, {2} ejemplo con ritmo
    public let indicacionRevisar: Plantilla  // {1} ejemplo

    // MARK: PresentacionDeContrapunto.swift
    public let contrapunto: String
    public let especie: String
    public let indicacionCantus: Plantilla  // {1} ejemplo
    public let indicacionContrapunto: Plantilla  // {1} ejemplo
    public let compasNumero: Plantilla  // {1} número

    // MARK: PresentacionDeSerie.swift
    public let serieDodecafonica: String
    public let indicacionSerie: Plantilla  // {1} ejemplo, {2} ejemplo con números
    public let formaDeSerie: String
    public let matriz: String
    public let intervalos: String
    public let deTodosLosIntervalos: String
    public let hexacordos: String
    public let formasCombinatorias: String
    public let formasDistintas: Plantilla  // {1} cuántas

    // MARK: RecorridoDePartitura.swift
    public let partitura: String
    public let anterior: String
    public let siguiente: String
    public let abreUnaPartitura: String

    // MARK: PresentacionDeDisposiciones.swift
    public let disposicion: String
    public let disposicionCerrada: String
    public let fundamentalTerceraYSeptima: String
    public let terceraYSeptima: String
    public let disposicionCuartal: String
    public let disposicionSinFundamentalA: String
    public let disposicionSinFundamentalB: String
    public let disposicionDosManos: String
    public let enElMastil: String
    public let cuerdas: Plantilla  // {1} cuerdas
    public let otrosNombres: String
    public let sinLaFundamental: String
    public let tonalidadesDelAcorde: String
    public let sustituciones: String
    public let compararCon: String
    public let notasComunes: String
    public let ningunaNotaComun: String
    public let movimientoTotal: Plantilla  // {1} semitonos
    public let secuencia: String
    public let bajando: String
    public let digitacionDePiano: String
    public let manoDerecha: String
    public let manoIzquierda: String
    public let modosParalelos: String
    public let modosRelativos: String
    public let soloEn: Plantilla  // {1} escala
    public let alteracionesDeDiferencia: Plantilla  // {1} cuántas
    public let escalasBebop: String
    public let notaDePaso: Plantilla  // {1} nota
    public let pentatonicas: String
    public let cambian: Plantilla  // {1} notas
    public let notasGuia: Plantilla  // {1} notas
    public let escalasQueLasContienen: String
    public let ademas: Plantilla  // {1} notas
    public let simetria: String
    public let repiteCada: Plantilla  // {1} semitonos, {2} transposiciones
    public let tonicasEquivalentes: String
    public let lineasDeNotasGuia: String
    public let desdeLaTercera: String
    public let desdeLaSeptima: String
    public let secuenciaEnLasPosiciones: String
    public let formasDeLaPentatonica: String
    public let formaNumero: Plantilla  // {1} número
    public let comparteCon: Plantilla  // {1} forma, {2} posiciones
    public let teclado: String
    public let escalaPropia: String
    public let campoDeEscalaPropia: String
    public let pasosEnSemitonos: String
    public let escalasVecinas: String
    public let relojDeLaEscala: String
    public let circuloCromatico: String
    public let circuloDeQuintas: String
    public let circuloMicrotonal: String
    public let enLasDoceTonalidades: String
    public let acordesEnLasDoceTonalidades: String
    public let conSeptima: String
    public let subirYBajar: String

    // MARK: PresentacionDeEstudioDeEscala+Estadisticas.swift
    public let estadisticas: String
    public let numeroDeNotas: String
    public let brillo: String
    public let brilloPorQuintas: String
    public let transposicionesDistintas: String
    public let rasgos: String
    public let anhemitonica: String
    public let cohemitonica: String
    public let maximamenteRegular: String
    public let medidaAproximada: String
    // PresentacionDeEstadisticasDeAcorde.swift
    public let amplitudEnQuintas: String
    public let ambito: String
    public let noPorTerceras: String
    public let simetricoPorInversion: String
    public let anhemitonico: String
    public let conTritono: String
    public let porNumeroDeNotas: String
    public let porEstilo: String
    public let sinEstilo: String
    public let porTerceras: String
    public let consonanciaDiadica: String
    public let grupoDeHindemith: String
    public let fundamentalDeHindemith: String
    public let fundamentalDeParncutt: String
    public let intervalosEntreVoces: String
    public let gradoDeSuavidad: String
    public let coeficientesDeFourier: String
    public let distanciaALaUniformidad: String
    public let triadasContenidas: String
    public let tensionDeCook: String
    public let modalidadDeCook: String
    public let rugosidad: String
    public let alturaDeTenney: String
    public let limiteImpar: String
    public let limitePrimo: String
    public let armonicidad: String
    public let entropiaArmonica: String
    public let fundamentalVirtual: String
    public let fusionTonal: String
    public let rugosidadDeVassilakis: String
    public let rugosidadDeHutchinsonKnopoff: String
    public let parejaZ: String
    public let complementoDeForte: String
    public let disposicionAbierta: String
    public let serieArmonica: String
    public let generador: String
    public let propiedadDeRothenberg: String
    public let estrictamentePropia: String
    public let propia: String
    public let impropia: String
    public let ambiguedades: String
    public let estabilidad: String
    public let cocienteDeIgualdad: String
    public let anchuraDelEspectro: String
    public let analisisDeHanson: String
    public let modoDeMessiaen: String
    public let imperfecciones: String
    public let triadasPorGrados: String
    public let cuatriadasPorGrados: String
    public let combinatoriedadHexacordal: String
    public let entropiaIntervalica: String
    public let parsimonia: String
    public let rugosidadMedia: String
    public let perfilTonal: String
    public let propiedadDeMyhill: String
    public let bienFormada: String
    public let escalaProfunda: String
    public let equilibrada: String
    public let simetricaPorInversion: String
    public let unicidad: String
    public let simplicidad: String
    public let conSensible: String
    public let tetracordosIguales: String
    public let tamanosDeTymoczko: String
    public let pasosEnElTonnetz: String
    public let distanciaDeLerdahl: String
    public let distanciaDeFourier: String
    public let distanciaIntervalica: String
    public let asimilitudDeMorris: String
    public let relacionesDeForte: String
    public let conLaTonalidad: String
    public let ajusteDeKrumhansl: String
    public let funcionProbable: String
    public let tonalidadesCercanas: String
    public let escalasDelCatalogo: String
    public let distanciaEnQuintas: String
    public let notasQueCambian: String
    public let conduccionMinima: String
    public let tensionDeLerdahl: String
    public let tensionDesdeLaTonica: String
    public let tensionMedia: String
    public let movimientoDeLasVoces: String
    public let movimientoMedio: String
    public let funcionesProbables: String
    public let notasNuevas: String
    public let notasFueraDeLaTonalidad: String
    public let cromatismo: String
    public let estadisticasDeLaProgresion: String
    public let ritmo: String
    public let familiaDeRitmo: String
    public let patronDeRitmo: String
    public let agrupacionDeRitmo: String
    public let compasDeRitmo: String
    public let pulsosGolpesYFuertes: String
    public let intervalosDeRitmo: String
    public let vectorDeDistancias: String
    public let ritmoEuclideo: String
    public let ritmoProfundo: String
    public let simetriasPorRotacion: String
    public let uniformidadDeRitmo: String
    public let contratiempoDeToussaint: String
    public let sincopaDeRitmo: String
    public let distanciaDeHamming: String
    public let distanciaDeIntercambio: String
    public let familiaDeTemperamento: String
    public let autorDelTemperamento: String
    public let anioDelTemperamento: String
    public let pasosPorOctava: String
    public let quintaDelTemperamento: String
    public let pasoMenorYMayor: String
    public let aproximacionesJustas: String
    public let quintaDelLobo: String
    public let terceraMasPuraYMasLejana: String
    public let desviacionesDelIgual: String
    public let pasosIguales: String
    public let familiaDeLaNota: String
    public let alturaDeLaNota: String
    public let desvioDeLaNota: String
    public let frecuenciaDeLaNota: String
    public let laDeLaNota: String
    public let midiDeLaNota: String
    public let anioDeLaNota: String
    public let nombreOriginalDeLaNota: String
    public let posicionGuidoniana: String
    public let intervaloDeLaFuncion: String
    public let centsDeLaFuncion: String
    public let propiedades: String
    public let escaleraDeBrillo: String
    public let hojaDeEstudio: String
    public let mapaDeBrillo: String
    /// Las escalas con más notas en común con una dada, de la más cercana a la más lejana.
    public let escalasParecidas: String
    /// Las maneras de modular desde una tonalidad.
    public let modulaciones: String
    public let modulacionPorAcordeComun: String
    public let modulacionPorDisminuida: String
    public let modulacionDirecta: String
    /// Cómo va cada voz de un acorde al siguiente en una progresión.
    public let conduccionDeVoces: String
    /// La hoja de una tonalidad.
    public let armadura: String
    public let sinAlteraciones: String
    public let relativa: String
    public let homonima: String
    public let cadenciasTipicas: String
    /// Dos progresiones comparadas: «Cambian 2 de 4 acordes».
    public let cambianAcordes: Plantilla  // {1} cuántos, {2} de cuántos
    /// Una línea de bajo en negras sobre una progresión.
    public let bajoCaminante: String
    /// Progresiones con los acordes de una escala.
    public let progresionesEnLaEscala: String
    /// «Fuera de La menor: Re♯, Sol♯»: las notas de una progresión que no son de esa escala.
    public let notasFueraDe: Plantilla  // {1} escala, {2} notas
    /// La pestaña de los catálogos de Ars Harmonica y sus listas.
    public let catalogo: String
    public let progresionesConNombre: String
    public let acordesConNombre: String
    public let ritmosConNombre: String
    public let buscarEnElCatalogo: String
    /// Las obras donde se lee una entrada del catálogo.
    public let fuentes: String
    public let verEnAnalisis: String
    public let sinResultados: String
    /// El nombre de un acorde en el catálogo («séptima de dominante», «acorde de Tristán»).
    public let nombrePropio: String

    // MARK: PresentacionDeEscalaYAcorde.swift
    public let tensiones: String
    public let notasAEvitar: String
    public let acordesQueCaben: String
    public let estructurasSuperiores: String

    // MARK: FicheroParaExportar.swift
    public let partituraMusicXML: String
    public let partituraMEI: String
    public let partituraLilyPond: String
    public let partituraGUIDO: String
    public let partituraABC: String
    public let dibujoSVG: String
    public let paginaHTML: String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    public static let traducidos = Traducido<TextosDeApps>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
