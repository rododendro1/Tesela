// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// MARK: - Textos de ConsolaArmonia
//
// Un idioma por fichero: `TextosDeConsola+Espanol.swift`, `TextosDeConsola+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ConsolaArmonia en un idioma.
struct TextosDeConsola: TextosTraducidos {
    // MARK: Ayuda+Armonizacion.swift
    let sintaxisAnalizar: String
    let descripcionAnalizar: String
    let notasAnalizar: String
    let sintaxisAnalizarArchivo: String
    let descripcionAnalizarArchivo: String
    let sintaxisArmonizar: String
    let descripcionArmonizar: String
    let sintaxisArmonizarArchivo: String
    let descripcionArmonizarArchivo: String
    let sintaxisRealizar: String
    let descripcionRealizar: String
    let sintaxisRealizarArchivo: String
    let descripcionRealizarArchivo: String
    let sintaxisRealizarBajoCifrado: String
    let descripcionRealizarBajoCifrado: String
    let sintaxisRevisar: String
    let descripcionRevisar: String
    let sintaxisRevisarArchivo: String
    let descripcionRevisarArchivo: String
    let sintaxisContrapunto: String
    let descripcionContrapunto: String
    let sintaxisProponerContrapunto: String
    let descripcionProponerContrapunto: String
    let sintaxisContrapuntoAVariasVoces: String
    let descripcionContrapuntoAVariasVoces: String
    let sintaxisTransponer: String
    let descripcionTransponer: String
    let sintaxisTransponerArchivo: String
    let descripcionTransponerArchivo: String
    let sintaxisRearmonizar: String
    let descripcionRearmonizar: String

    // MARK: Ayuda+Consultas.swift
    let sintaxisAcorde: String
    let descripcionAcorde: String
    let notasAcorde: String
    let sintaxisArpegio: String
    let descripcionArpegio: String
    let notasArpegio: String
    let sintaxisIdentificar: String
    let descripcionIdentificar: String
    let notasIdentificar: String
    let sintaxisIntervalo: String
    let descripcionIntervalo: String
    let sintaxisEscala: String
    let descripcionEscala: String
    let notasEscala: String
    let sintaxisEscalas: String
    let descripcionEscalas: String
    let notasEscalas: String
    let sintaxisTradiciones: String
    let descripcionTradiciones: String
    let sintaxisProgresiones: String
    let descripcionProgresiones: String
    let sintaxisRitmos: String
    let descripcionRitmos: String
    let notasRitmos: String
    let sintaxisTemperamentos: String
    let descripcionTemperamentos: String
    let notasTemperamentos: String
    let sintaxisNotasConNombre: String
    let descripcionNotasConNombre: String
    let notasNotasConNombre: String
    let sintaxisFunciones: String
    let descripcionFunciones: String
    let notasFunciones: String
    let sintaxisAcordesConNombre: String
    let descripcionAcordesConNombre: String
    let notasAcordesConNombre: String
    let sintaxisTonalidad: String
    let descripcionTonalidad: String
    let sintaxisConjunto: String
    let descripcionConjunto: String
    let sintaxisSerie: String
    let descripcionSerie: String

    // MARK: Ayuda+Dibujos.swift
    let sintaxisTonnetz: String
    let descripcionTonnetz: String
    let sintaxisTonnetzAcorde: String
    let descripcionTonnetzAcorde: String
    let sintaxisTonnetzRecorrido: String
    let descripcionTonnetzRecorrido: String
    let sintaxisTonnetzCiclo: String
    let descripcionTonnetzCiclo: String
    let notasTonnetzCiclo: String
    let sintaxisTabla: String
    let descripcionTabla: String
    let sintaxisTablaAcorde: String
    let descripcionTablaAcorde: String
    let sintaxisCuadricula: String
    let descripcionCuadricula: String
    let sintaxisCuadriculaOpciones: String
    let descripcionCuadriculaOpciones: String

    // MARK: Ayuda+Neorriemann.swift
    let sintaxisVecinos: String
    let descripcionVecinos: String
    let sintaxisConduccionParsimoniosa: String
    let descripcionConduccionParsimoniosa: String
    let sintaxisConduccionMinima: String
    let descripcionConduccionMinima: String
    let sintaxisPlr: String
    let descripcionPlr: String
    let sintaxisPlrCamino: String
    let descripcionPlrCamino: String
    let sintaxisPlrCiclo: String
    let descripcionPlrCiclo: String

    // MARK: Ayuda+Partituras.swift
    let sintaxisMusicxmlMelodia: String
    let descripcionMusicxmlMelodia: String
    let sintaxisMusicxmlCoral: String
    let descripcionMusicxmlCoral: String
    let sintaxisMusicxmlAcordes: String
    let descripcionMusicxmlAcordes: String
    let notasMusicxmlAcordes: String
    let sintaxisMusicxmlArpegios: String
    let descripcionMusicxmlArpegios: String
    let notasMusicxmlArpegios: String
    let sintaxisMusicxmlArchivo: String
    let descripcionMusicxmlArchivo: String
    let sintaxisMusicxmlEscala: String
    let descripcionMusicxmlEscala: String
    let sintaxisMeiMelodia: String
    let descripcionMeiMelodia: String
    let sintaxisLilypondMelodia: String
    let descripcionLilypondMelodia: String
    let sintaxisGuidoMelodia: String
    let descripcionGuidoMelodia: String
    let sintaxisAbcMelodia: String
    let descripcionAbcMelodia: String
    let sintaxisMidiMelodia: String
    let descripcionMidiMelodia: String

    // MARK: Ayuda+Grabado.swift
    let sintaxisGrabar: String
    let descripcionGrabar: String
    let notasGrabar: String
    let sintaxisMotores: String
    let descripcionMotores: String

    // MARK: Ayuda+Trastes.swift
    let sintaxisDigitaciones: String
    let descripcionDigitaciones: String
    let sintaxisPosiciones: String
    let descripcionPosiciones: String
    let notasPosiciones: String
    let sintaxisTeclado: String
    let descripcionTeclado: String
    let sintaxisReloj: String
    let descripcionReloj: String
    let sintaxisHoja: String
    let descripcionHoja: String
    let sintaxisHojaDeAcorde: String
    let descripcionHojaDeAcorde: String
    let sintaxisHojaDeAcordes: String
    let descripcionHojaDeAcordes: String
    let sintaxisHojaDeTonalidad: String
    let descripcionHojaDeTonalidad: String
    let sintaxisPentagrama: String
    let descripcionPentagrama: String
    let sintaxisPentagramaEstudio: String
    let descripcionPentagramaEstudio: String
    let sintaxisPentagramaRegistro: String
    let descripcionPentagramaRegistro: String
    let sintaxisPentagramaMelodia: String
    let descripcionPentagramaMelodia: String
    let sintaxisPentagramaBajo: String
    let descripcionPentagramaBajo: String
    let sintaxisPosicionesArpegio: String
    let descripcionPosicionesArpegio: String

    // MARK: Ayuda.swift
    let cabeceraDeLaAyuda: String
    let pieDeLaAyuda: String
    let sintaxisAyuda: String
    let descripcionAyuda: String

    // MARK: Terminal.swift
    let sintaxisCompletado: String
    let descripcionCompletado: String
    let sintaxisManual: String
    let descripcionManual: String
    let manualNombre: String
    let manualNotas: String
    /// Los apartados ENTORNO y ESTADO DE SALIDA del manual: sus títulos, lo que hace `ARMONIA_IDIOMA`, lo que da la
    /// variable de un programa de grabado y qué quiere decir cada código de salida, del 0 al 3.
    let manualEntorno: String
    let manualEstadoDeSalida: String
    let manualIdiomaDelEntorno: String
    let manualRutaDelPrograma: Plantilla  // {1} programa
    let manualCodigosDeSalida: [String]

    // MARK: ErrorDeUso.swift (armonización)
    let faltanAcordes: Plantilla  // {1} ejemplo
    let dosAcordes: Plantilla  // {1} ejemplo
    let faltanNotasDeLaArmonizacion: Plantilla  // {1} ejemplo
    let propuestasFueraDeRango: String
    let faltanVocesDelContrapunto: Plantilla  // {1} ejemplo
    let especieFueraDeRango: String

    // MARK: ErrorDeUso.swift (consultas)
    let faltaCifrado: Plantilla  // {1} ejemplo
    let patronDesconocido: Plantilla  // {1} patron
    let tradicionDesconocida: Plantilla  // {1} tradicion
    let familiaDeRitmoDesconocida: Plantilla  // {1} familia
    let ritmoDesconocido: Plantilla  // {1} ritmo
    let familiaDeTemperamentoDesconocida: Plantilla  // {1} familia
    let familiaDeNotaDesconocida: Plantilla  // {1} familia
    let familiaDeFuncionDesconocida: Plantilla  // {1} familia
    let categoriaDesconocida: Plantilla  // {1} categoria
    let fuenteDesconocida: Plantilla  // {1} fuente
    let escalaSinMicrotonos: Plantilla  // {1} escala
    let sinCirculoDeQuintas: Plantilla  // {1} temperamento
    let usoDesconocido: Plantilla  // {1} uso
    let lugarDesconocido: Plantilla  // {1} lugar
    let agrupacionDesconocida: Plantilla  // {1} agrupacion
    let epocaDesconocida: Plantilla  // {1} epoca
    let afectoDesconocido: Plantilla  // {1} afecto
    let escuelaDesconocida: Plantilla  // {1} escuela
    let afinacionDesconocida: Plantilla  // {1} afinación
    let ordenDeEscalasDesconocido: Plantilla  // {1} orden
    let ordenDeAcordesDesconocido: Plantilla  // {1} orden
    let intervaloDeEscalasDesconocido: Plantilla  // {1} intervalo
    let pasoFueraDeRango: String
    let faltanNotas: Plantilla  // {1} ejemplo
    let dosNotas: Plantilla  // {1} ejemplo
    let faltaEscala: Plantilla  // {1} ejemplo
    let faltaTonalidad: Plantilla  // {1} ejemplo
    let faltaTonalidadTrasEn: String
    let faltaConjunto: Plantilla  // {1} ejemplo
    let faltaSerie: Plantilla  // {1} ejemplo
    let archivoIlegible: Plantilla  // {1} nombre
    /// Un fichero de `-o` que no se puede escribir.
    let archivoNoEscrito: Plantilla  // {1} nombre
    let archivoConAcordes: String
    let archivoSinAcordes: String
    let sinContrapuntoPosible: String
    let faltaTransporte: Plantilla  // {1} ejemplo

    // MARK: ErrorDeUso.swift (dibujos)
    let margenFueraDeRango: String
    let faltaAcorde: Plantilla  // {1} ejemplo
    let faltanClasesDelDibujo: Plantilla  // {1} ejemplo
    let faltanTriadasDelRecorrido: Plantilla  // {1} ejemplo
    let cicloMalEscrito: Plantilla  // {1} ejemplo
    let recorridoSoloTriadas: Plantilla  // {1} ejemplo
    let caminoSoloTriadas: Plantilla  // {1} ejemplo
    let cicloSoloTriadas: Plantilla  // {1} ejemplo
    let opcionesDeCuadricula: String

    // MARK: ErrorDeUso.swift (neorriemanniana)
    let vocesFueraDeRango: String
    let unAcordeDeVecinos: Plantilla  // {1} ejemplo
    let vecinosSinFamilia: String
    let caminoSinConexion: String
    let faltanPasosDePLR: Plantilla  // {1} ejemplo
    let plrSoloTriadas: Plantilla  // {1} ejemplo

    // MARK: ErrorDeUso.swift (partituras)
    let faltaTipoDePartitura: Plantilla  // {1} ejemplo
    let instrumentoMIDI: String
    let marcasSoloMusicXML: String
    let faltaValor: Plantilla  // {1} opcion
    let tempoMalEscrito: String
    let marcasSoloCoral: String
    let duracionSoloCoral: String
    let claveDesconocida: Plantilla  // {1} clave, {2} las claves que se conocen
    let soloParaMelodia: Plantilla  // {1} opcion
    let soloParaArpegios: Plantilla  // {1} opcion
    let archivoSoloParaAcordes: String
    let ventanaSinArchivo: String
    let acordesConCifradosYAnalisis: String
    let tipoDePartituraDesconocido: Plantilla  // {1} tipo

    // MARK: ErrorDeUso.swift (grabado)
    let faltaLoQueSeGraba: Plantilla  // {1} ejemplo
    let motorDesconocido: Plantilla  // {1} motor
    let formatoDeGrabadoDesconocido: Plantilla  // {1} formato
    let formatoDePartituraDesconocido: Plantilla  // {1} formato
    let nadaQueGrabar: Plantilla  // {1} orden

    // MARK: LineaDeComandos+Grabado.swift
    /// El programa y la variable de entorno que da su ruta.
    let motorNoEncontrado: Plantilla  // {1} programa, {2} variable
    /// El programa y su código de salida; debajo van las últimas líneas de lo que dijo.
    let motorFallo: Plantilla  // {1} programa, {2} codigo
    let motorSinTerminar: Plantilla  // {1} programa
    /// La variable de entorno que da la ruta del programa que no está.
    let motorNoInstalado: Plantilla  // {1} variable
    /// El nombre de `--motor propio` en el idioma de las órdenes.
    let motorPropio: String

    // MARK: ErrorDeUso.swift (digitaciones)
    let faltaInstrumento: Plantilla  // {1} ejemplo
    let instrumentoDesconocido: @Sendable (String, (Notacion) -> String) -> String
    let faltaLimite: String
    let limiteFueraDeRango: String
    let faltanDedos: String
    let dedosFueraDeRango: String
    let faltaTraste: String
    let trasteFueraDeRango: String
    let manoDesconocida: Plantilla  // {1} texto
    let archivoConNotas: String
    let noEsPentatonica: Plantilla  // {1} ejemplo
    let faltaLoQueDibujaElPentagrama: Plantilla  // {1} ejemplo
    let capoFueraDeRango: String
    let octavasFueraDeRango: String
    let notasFueraDeRango: String
    let octavaFueraDeRango: String
    let desdeNoValido: Plantilla  // {1} desde
    let tensionesMalEscritas: String
    let gradosMalEscritos: String
    let aproximacionDesconocida: Plantilla  // {1} aproximacion
    let secuenciaDesconocida: Plantilla  // {1} secuencia

    // MARK: ErrorDeUso.swift (comunes)
    let pruebaLaAyuda: String
    let ordenDesconocida: Plantilla  // {1} orden
    let opcionDesconocida: Plantilla  // {1} opcion
    let idiomaDesconocido: Plantilla  // {1} idioma
    let terminalDesconocida: Plantilla  // {1} terminal
    let escrituraNoValida: Plantilla  // {1} escritura
    /// `--sistema` con un sistema que no se conoce, y la lista de los que hay.
    let sistemaDesconocido: Plantilla  // {1} sistema, {2} lista
    /// `--grafia` con un valor que no es original, transliterada ni ascii.
    let grafiaNoValida: Plantilla  // {1} grafia
    /// `--sistema` con uno móvil (el sargam) en una orden que no es `escala`.
    let sistemaMovil: Plantilla  // {1} sistema
    let sinSalidaJSON: Plantilla  // {1} orden

    // MARK: Mensaje.swift
    let mensajeNotas: String
    let mensajeAcordes: String
    /// La línea de `armonia escala` con las notas de la versión microtonal (maqamat, dastgāh, makamlar).
    let mensajeMicrotonos: String
    let mensajeReferencias: String
    let mensajeCaracter: String
    let mensajeEscalas: String
    let mensajeHabituales: String
    let mensajeSinLugar: String
    let mensajeSinEpoca: String
    let mensajeNingunaEscala: String
    let mensajeNingunaProgresion: String
    let mensajeNingunRitmo: String
    let mensajeNingunTemperamento: String
    let mensajeNingunaNota: String
    let mensajeNingunaFuncion: String
    let mensajeNingunAcorde: String
    let mensajeTetracordos: String
    let mensajeSinTetracordos: String
    let mensajeAjnas: String
    let mensajeArmadura: String
    let mensajeRelativa: String
    let mensajeHomonima: String
    let mensajeBajo: Plantilla  // {1} nota
    let mensajeMela: Plantilla  // {1} número del mēḷa, {2} número del cakra, {3} nombre del cakra, {4} mnemónico, {5} solfa
    let mensajeBajoAjeno: String
    let mensajeSinAcordes: String
    let mensajeSin: Plantilla  // {1} notas
    let mensajeSemitonos: @Sendable (Int) -> String
    let mensajeSinAlteraciones: String
    let mensajeSostenidos: @Sendable (Int) -> String
    let mensajeBemoles: @Sendable (Int) -> String
    let mensajeACuatroVoces: String
    let mensajeSinDigitaciones: String
    let mensajeDedos: @Sendable (Int) -> String
    let mensajeCejilla: Plantilla  // {1} traste
    let mensajeNingunPaso: String
    let mensajeUnPaso: String
    let mensajePasos: @Sendable (Int) -> String
    let mensajeTriadas: @Sendable (Int) -> String
    let mensajeFormaNormal: String
    let mensajeFormaPrima: String
    let mensajeVectorIntervalico: String
    let mensajeVectorDeIndice: String
    let mensajeEjesDeSimetria: String
    let mensajeIntervalos: String
    let mensajeDeTodosLosIntervalos: String
    let mensajeFormasDistintas: Plantilla  // {1} cuántas
    let mensajeHexacordos: String
    let mensajeFormasCombinatorias: String

    // MARK: LineaDeComandos.swift (versión, erratas y salida binaria)
    let sintaxisVersion: String
    let descripcionVersion: String
    /// La propuesta tras una orden o una opción mal escrita: «¿Querías decir «acorde»?».
    let quisoDecir: Plantilla  // {1} propuesta
    /// Como `pruebaLaAyuda`, con la ayuda de la orden: «Prueba «armonia ayuda acorde».».
    let pruebaLaAyudaDe: Plantilla  // {1} orden
    /// Una orden que da un fichero binario con la salida en la terminal.
    let salidaBinaria: String
    /// `escalas` con unas notas, que no son el nombre de ninguna escala: cómo buscarla por sus notas (el ejemplo).
    let escalasPorNotas: Plantilla  // {1} ejemplo
    /// `grabar midi …` (o musicxml, mei…): esa orden ya escribe la partitura; el ejemplo, cómo grabarla.
    let grabarUnaPartitura: Plantilla  // {1} orden, {2} ejemplo

    // MARK: Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
    /// Los títulos de los grupos del índice de `armonia ayuda`, uno por cada lista de `gruposDeOrdenes`.
    let gruposDeLaAyuda: [String]
    /// Lo que sigue al índice: cómo ver la ayuda de una orden y toda la ayuda, y las opciones de todas las órdenes.
    let pieDelIndice: String
    /// La primera línea de la sesión (`armonia` sin argumentos en la terminal), con la versión.
    let bienvenidaDeLaSesion: Plantilla  // {1} versión

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeConsola>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
