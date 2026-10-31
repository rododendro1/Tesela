import Armonia
import ArmoniaPresentacion

// Los errores de uso de la herramienta, en los catorce idiomas de los textos. Lo común a todos los
// textos de la herramienta está explicado en Mensaje.swift.
//
// Aquí están los generales (orden, opción o idioma desconocidos); los de cada grupo de órdenes, en
// ErrorDeUso+Consultas, +Armonizacion, +Trastes, +Neorriemann, +Partituras y +Dibujos, como su ayuda
// (Ayuda+…) y su código (LineaDeComandos+…).

/// Una orden mal escrita: lo que falta o sobra, con un ejemplo de cómo se escribe.
enum ErrorDeUso {
    // Generales
    case ordenDesconocida(String)
    case opcionDesconocida(String)
    case idiomaDesconocido(String)
    /// `--escritura` con un valor que no es palabras, ascii ni unicode, o con un idioma que solo tiene una.
    case escrituraNoValida(String)

    // Consultas y armonización
    case faltaCifrado
    case faltaCifradoDelArpegio
    case patronDesconocido(String)
    case faltanNotas
    case dosNotas
    case faltaEscala
    case faltaTonalidad
    case faltanAcordesDeLasVoces
    case dosAcordesDeConduccion
    case faltaTonalidadTrasEn
    case faltanAcordesDelAnalisis
    /// `analizar --archivo` con un fichero que no existe o no se puede abrir.
    case archivoIlegible(String)
    /// `analizar --archivo` y además acordes escritos.
    case archivoConAcordes
    /// `analizar --archivo` con un fichero que tiene notas pero ningún acorde (una sola voz, por ejemplo).
    case archivoSinAcordes
    case faltanNotasDeLaArmonizacion
    case propuestasFueraDeRango
    case faltanAcordesDeLaRealizacion
    case faltanVocesDelContrapunto
    case especieFueraDeRango

    // Digitaciones
    case faltaInstrumento
    case instrumentoDesconocido(String)
    case faltaLimite
    case limiteFueraDeRango
    case faltanDedos
    case dedosFueraDeRango
    case faltaTraste
    case trasteFueraDeRango
    case faltaCifradoDeDigitaciones
    case faltaEscalaDePosiciones

    // Neorriemanniano
    case vocesFueraDeRango
    case unAcordeDeVecinos
    case vecinosSinFamilia
    case dosAcordesDeCamino
    case caminoSinConexion
    case faltanPasosDePLR
    case plrSoloTriadas(camino: Bool)

    // Partituras (`orden` es «musicxml», «mei» o «midi»)
    case faltaTipoDePartitura(orden: String)
    case instrumentoMIDI
    case marcasSoloMusicXML
    case faltaValor(String)
    case tempoMalEscrito
    case faltanNotasDeLaMelodia(orden: String)
    case marcasSoloCoral
    case duracionSoloCoral
    case claveDesconocida(String)
    case faltanAcordesDelCoral(orden: String)
    case soloParaMelodia(String)
    case soloParaArpegios(String)
    /// `--archivo` en una melodía o un coral.
    case archivoSoloParaAcordes
    /// `--ventana` sin `--archivo`.
    case ventanaSinArchivo
    case faltanAcordesDeLaProgresion(orden: String)
    case acordesConCifradosYAnalisis
    case tipoDePartituraDesconocido(String)

    // Dibujos (`orden` es «tonnetz» o «tabla»)
    case margenFueraDeRango
    case faltanNotasDelDibujo(orden: String)
    case faltaAcordeDelDibujo(orden: String)
    case faltaEscalaDelDibujo(orden: String)
    case clasesFueraDeRango(orden: String)
    case faltanTriadasDelRecorrido(orden: String)
    case cicloMalEscrito(orden: String)
    case recorridoSoloTriadas(orden: String)
    case caminoSoloTriadas(orden: String)
    case cicloSoloTriadas(orden: String)

    /// El mensaje completo, con la línea que remite a la ayuda.
    func texto(en notacion: Notacion) -> String {
        "armonia: " + traduccion.en(notacion) + "\n"
            + TextosDeCLI.traducidos.map(\.pruebaLaAyuda).en(notacion) + "\n"
    }

    /// El texto de cada error. Los de los grupos de órdenes están en su fichero, uno por caso, para que un caso
    /// nuevo no compile hasta que tiene su texto.
    private var traduccion: Traduccion {
        switch self {
        case .ordenDesconocida(let orden):
            return TextosDeCLI.traducidos.map { $0.ordenDesconocida(orden) }
        case .opcionDesconocida(let opcion):
            return TextosDeCLI.traducidos.map { $0.opcionDesconocida(opcion) }
        case .idiomaDesconocido(let idioma):
            return TextosDeCLI.traducidos.map { $0.idiomaDesconocido(idioma) }
        case .escrituraNoValida(let escritura):
            return TextosDeCLI.traducidos.map { $0.escrituraNoValida(escritura) }
        case .faltaCifrado: return TextosDeConsultas.faltaCifrado()
        case .faltaCifradoDelArpegio: return TextosDeConsultas.faltaCifradoDelArpegio()
        case .patronDesconocido(let patron): return TextosDeConsultas.patronDesconocido(patron)
        case .faltanNotas: return TextosDeConsultas.faltanNotas()
        case .dosNotas: return TextosDeConsultas.dosNotas()
        case .faltaEscala: return TextosDeConsultas.faltaEscala()
        case .faltaTonalidad: return TextosDeConsultas.faltaTonalidad()
        case .faltanAcordesDeLasVoces: return TextosDeArmonizacion.faltanAcordesDeLasVoces()
        case .dosAcordesDeConduccion: return TextosDeArmonizacion.dosAcordesDeConduccion()
        case .faltaTonalidadTrasEn: return TextosDeConsultas.faltaTonalidadTrasEn()
        case .faltanAcordesDelAnalisis: return TextosDeConsultas.faltanAcordesDelAnalisis()
        case .archivoIlegible(let nombre): return TextosDeConsultas.archivoIlegible(nombre)
        case .archivoConAcordes: return TextosDeConsultas.archivoConAcordes()
        case .archivoSinAcordes: return TextosDeConsultas.archivoSinAcordes()
        case .faltanNotasDeLaArmonizacion: return TextosDeArmonizacion.faltanNotasDeLaArmonizacion()
        case .propuestasFueraDeRango: return TextosDeArmonizacion.propuestasFueraDeRango()
        case .faltanVocesDelContrapunto: return TextosDeArmonizacion.faltanVocesDelContrapunto()
        case .especieFueraDeRango: return TextosDeArmonizacion.especieFueraDeRango()
        case .faltanAcordesDeLaRealizacion: return TextosDeArmonizacion.faltanAcordesDeLaRealizacion()
        case .faltaInstrumento: return TextosDeTrastes.faltaInstrumento()
        case .instrumentoDesconocido(let nombre): return TextosDeTrastes.instrumentoDesconocido(nombre)
        case .faltaLimite: return TextosDeTrastes.faltaLimite()
        case .limiteFueraDeRango: return TextosDeTrastes.limiteFueraDeRango()
        case .faltanDedos: return TextosDeTrastes.faltanDedos()
        case .dedosFueraDeRango: return TextosDeTrastes.dedosFueraDeRango()
        case .faltaTraste: return TextosDeTrastes.faltaTraste()
        case .trasteFueraDeRango: return TextosDeTrastes.trasteFueraDeRango()
        case .faltaCifradoDeDigitaciones: return TextosDeTrastes.faltaCifradoDeDigitaciones()
        case .faltaEscalaDePosiciones: return TextosDeTrastes.faltaEscalaDePosiciones()
        case .vocesFueraDeRango: return TextosDeNeorriemann.vocesFueraDeRango()
        case .unAcordeDeVecinos: return TextosDeNeorriemann.unAcordeDeVecinos()
        case .vecinosSinFamilia: return TextosDeNeorriemann.vecinosSinFamilia()
        case .dosAcordesDeCamino: return TextosDeNeorriemann.dosAcordesDeCamino()
        case .caminoSinConexion: return TextosDeNeorriemann.caminoSinConexion()
        case .faltanPasosDePLR: return TextosDeNeorriemann.faltanPasosDePLR()
        case .plrSoloTriadas(let camino): return TextosDeNeorriemann.plrSoloTriadas(camino: camino)
        case .faltaTipoDePartitura(let orden): return TextosDePartituras.faltaTipoDePartitura(orden: orden)
        case .instrumentoMIDI: return TextosDePartituras.instrumentoMIDI()
        case .marcasSoloMusicXML: return TextosDePartituras.marcasSoloMusicXML()
        case .faltaValor(let opcion): return TextosDePartituras.faltaValor(opcion)
        case .tempoMalEscrito: return TextosDePartituras.tempoMalEscrito()
        case .faltanNotasDeLaMelodia(let orden): return TextosDePartituras.faltanNotasDeLaMelodia(orden: orden)
        case .marcasSoloCoral: return TextosDePartituras.marcasSoloCoral()
        case .duracionSoloCoral: return TextosDePartituras.duracionSoloCoral()
        case .claveDesconocida(let clave): return TextosDePartituras.claveDesconocida(clave)
        case .faltanAcordesDelCoral(let orden): return TextosDePartituras.faltanAcordesDelCoral(orden: orden)
        case .soloParaMelodia(let opcion): return TextosDePartituras.soloParaMelodia(opcion)
        case .soloParaArpegios(let opcion): return TextosDePartituras.soloParaArpegios(opcion)
        case .archivoSoloParaAcordes: return TextosDePartituras.archivoSoloParaAcordes()
        case .ventanaSinArchivo: return TextosDePartituras.ventanaSinArchivo()
        case .faltanAcordesDeLaProgresion(let orden):
            return TextosDePartituras.faltanAcordesDeLaProgresion(orden: orden)
        case .acordesConCifradosYAnalisis: return TextosDePartituras.acordesConCifradosYAnalisis()
        case .tipoDePartituraDesconocido(let tipo): return TextosDePartituras.tipoDePartituraDesconocido(tipo)
        case .margenFueraDeRango: return TextosDeDibujos.margenFueraDeRango()
        case .faltanNotasDelDibujo(let orden): return TextosDeDibujos.faltanNotasDelDibujo(orden: orden)
        case .faltaAcordeDelDibujo(let orden): return TextosDeDibujos.faltaAcordeDelDibujo(orden: orden)
        case .faltaEscalaDelDibujo(let orden): return TextosDeDibujos.faltaEscalaDelDibujo(orden: orden)
        case .clasesFueraDeRango(let orden): return TextosDeDibujos.clasesFueraDeRango(orden: orden)
        case .faltanTriadasDelRecorrido(let orden): return TextosDeDibujos.faltanTriadasDelRecorrido(orden: orden)
        case .cicloMalEscrito(let orden): return TextosDeDibujos.cicloMalEscrito(orden: orden)
        case .recorridoSoloTriadas(let orden): return TextosDeDibujos.recorridoSoloTriadas(orden: orden)
        case .caminoSoloTriadas(let orden): return TextosDeDibujos.caminoSoloTriadas(orden: orden)
        case .cicloSoloTriadas(let orden): return TextosDeDibujos.cicloSoloTriadas(orden: orden)
        }
    }
}
