// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// MARK: - Textos de ArmoniaCLI
//
// Un idioma por fichero: `TextosDeCLI+Espanol.swift`, `TextosDeCLI+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaCLI en un idioma.
struct TextosDeCLI: Sendable {
    // MARK: Ayuda+Armonizacion.swift
    let sintaxisAnalizar: String
    let descripcionAnalizar: String
    let sintaxisAnalizarArchivo: String
    let descripcionAnalizarArchivo: String
    let sintaxisArmonizar: String
    let descripcionArmonizar: String
    let sintaxisRealizar: String
    let descripcionRealizar: String
    let sintaxisRevisar: String
    let descripcionRevisar: String
    let sintaxisContrapunto: String
    let descripcionContrapunto: String

    // MARK: Ayuda+Consultas.swift
    let sintaxisAcorde: String
    let descripcionAcorde: String
    let sintaxisArpegio: String
    let descripcionArpegio: String
    let sintaxisIdentificar: String
    let descripcionIdentificar: String
    let sintaxisIntervalo: String
    let descripcionIntervalo: String
    let sintaxisEscala: String
    let descripcionEscala: String
    let sintaxisTonalidad: String
    let descripcionTonalidad: String

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
    let sintaxisMeiMelodia: String
    let descripcionMeiMelodia: String
    let sintaxisMidiMelodia: String
    let descripcionMidiMelodia: String

    // MARK: Ayuda+Trastes.swift
    let sintaxisDigitaciones: String
    let descripcionDigitaciones: String
    let sintaxisPosiciones: String
    let descripcionPosiciones: String

    // MARK: Ayuda.swift
    let cabeceraDeLaAyuda: String
    let pieDeLaAyuda: String
    let sintaxisAyuda: String
    let descripcionAyuda: String

    // MARK: ErrorDeUso+Armonizacion.swift
    let faltanAcordesDeLasVoces: @Sendable (String) -> String
    let dosAcordesDeConduccion: @Sendable (String) -> String
    let faltanNotasDeLaArmonizacion: @Sendable (String) -> String
    let propuestasFueraDeRango: String
    let faltanVocesDelContrapunto: @Sendable (String, String) -> String
    let especieFueraDeRango: String
    let faltanAcordesDeLaRealizacion: @Sendable (String) -> String

    // MARK: ErrorDeUso+Consultas.swift
    let faltaCifrado: String
    let faltaCifradoDelArpegio: String
    let patronDesconocido: @Sendable (String) -> String
    let faltanNotas: String
    let dosNotas: String
    let faltaEscala: String
    let faltaTonalidad: String
    let faltaTonalidadTrasEn: String
    let faltanAcordesDelAnalisis: @Sendable (String) -> String
    let archivoIlegible: @Sendable (String) -> String
    let archivoConAcordes: String
    let archivoSinAcordes: String

    // MARK: ErrorDeUso+Dibujos.swift
    let margenFueraDeRango: String
    let faltanNotasDelDibujo: @Sendable (String, String) -> String
    let faltaAcordeDelDibujo: @Sendable (String, String) -> String
    let faltaEscalaDelDibujo: @Sendable (String, String) -> String
    let clasesFueraDeRango: @Sendable (String, String) -> String
    let faltanTriadasDelRecorrido: @Sendable (String, String) -> String
    let cicloMalEscrito: @Sendable (String, String) -> String
    let recorridoSoloTriadas: @Sendable (String, String) -> String
    let caminoSoloTriadas: @Sendable (String, String) -> String
    let cicloSoloTriadas: @Sendable (String, String) -> String

    // MARK: ErrorDeUso+Neorriemann.swift
    let vocesFueraDeRango: String
    let unAcordeDeVecinos: @Sendable (String) -> String
    let vecinosSinFamilia: String
    let dosAcordesDeCamino: @Sendable (String) -> String
    let caminoSinConexion: String
    let faltanPasosDePLR: @Sendable (String) -> String
    let plrSoloTriadas: @Sendable (String, Bool) -> String

    // MARK: ErrorDeUso+Partituras.swift
    let faltaTipoDePartitura: @Sendable (String, String) -> String
    let instrumentoMIDI: String
    let marcasSoloMusicXML: String
    let faltaValor: @Sendable (String) -> String
    let tempoMalEscrito: String
    let faltanNotasDeLaMelodia: @Sendable (String, String) -> String
    let marcasSoloCoral: String
    let duracionSoloCoral: String
    let claveDesconocida: @Sendable (String, String) -> String
    let faltanAcordesDelCoral: @Sendable (String, String) -> String
    let soloParaMelodia: @Sendable (String) -> String
    let soloParaArpegios: @Sendable (String) -> String
    let archivoSoloParaAcordes: String
    let ventanaSinArchivo: String
    let faltanAcordesDeLaProgresion: @Sendable (String, String) -> String
    let acordesConCifradosYAnalisis: String
    let tipoDePartituraDesconocido: @Sendable (String) -> String

    // MARK: ErrorDeUso+Trastes.swift
    let faltaInstrumento: @Sendable (String, (String, String)) -> String
    let instrumentoDesconocido: @Sendable (String, (Notacion) -> String) -> String
    let faltaLimite: String
    let limiteFueraDeRango: String
    let faltanDedos: String
    let dedosFueraDeRango: String
    let faltaTraste: String
    let trasteFueraDeRango: String
    let faltaCifradoDeDigitaciones: @Sendable (String, (String, String)) -> String
    let faltaEscalaDePosiciones: String

    // MARK: ErrorDeUso.swift
    let pruebaLaAyuda: String
    let ordenDesconocida: @Sendable (String) -> String
    let opcionDesconocida: @Sendable (String) -> String
    let idiomaDesconocido: @Sendable (String) -> String
    let escrituraNoValida: @Sendable (String) -> String

    // MARK: Mensaje.swift
    let mensajeNotas: String
    let mensajeAcordes: String
    let mensajeEscalas: String
    let mensajeArmadura: String
    let mensajeRelativa: String
    let mensajeHomonima: String
    let mensajeBajo: @Sendable (String) -> String
    let mensajeBajoAjeno: String
    let mensajeSinAcordes: String
    let mensajeSin: @Sendable (String) -> String
    let mensajeSemitonos: @Sendable (Int) -> String
    let mensajeSinAlteraciones: String
    let mensajeSostenidos: @Sendable (Int) -> String
    let mensajeBemoles: @Sendable (Int) -> String
    let mensajeACuatroVoces: String
    let mensajeSinDigitaciones: String
    let mensajeDedos: @Sendable (Int) -> String
    let mensajeCejilla: @Sendable (Int) -> String
    let mensajeNingunPaso: String
    let mensajeUnPaso: String
    let mensajePasos: @Sendable (Int) -> String
    let mensajeTriadas: @Sendable (Int) -> String

    /// Los textos en los catorce idiomas: `traducidos.map(\.campo)` es la `Traduccion` de un campo.
    static let traducidos = Traducido<TextosDeCLI>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
