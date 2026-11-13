import Armonia
import Exposicion

// Los errores de uso de la herramienta, en los trece idiomas de los textos. Lo común a todos los
// textos de la herramienta está explicado en Mensaje.swift.
//
// Están todos aquí, por grupos de órdenes como su ayuda (Ayuda+…) y su código (LineaDeComandos+…): primero los
// generales (orden, opción o idioma desconocidos) y después los de cada grupo. Su texto está en
// ErrorDeUso+Textos.swift: los que acaban en una orden de ejemplo la dan en `traduccion` (`conEjemplo`), en español
// o en inglés según el idioma, y los textos de `TextosDeConsola` solo dicen lo que falta. Lo que escribe la terminal
// (el error, la propuesta y la remisión a la ayuda) está en ErrorDeUso+Mensaje.swift.

/// Una orden mal escrita: lo que falta o sobra, con un ejemplo de cómo se escribe. Las órdenes lo lanzan, y
/// `ejecutar` lo escribe con `uso(_:_:enCurso:)`.
enum ErrorDeUso: ErrorDeArmonia {
    // Generales
    case ordenDesconocida(String)
    case opcionDesconocida(String)
    case idiomaDesconocido(String)
    /// `completado` sin bash, zsh ni fish.
    case terminalDesconocida(String)
    /// `--escritura` con un valor que no es palabras ni compacto (ni, en español e inglés, ascii o unicode).
    case escrituraNoValida(String)
    /// `--sistema` con un sistema de nombres que no se conoce.
    case sistemaDesconocido(String)
    /// `--grafia` con un valor que no es original, transliterada ni ascii.
    case grafiaNoValida(String)
    /// `--sistema` con uno móvil (sargam, jianpu…) en una orden que no es `escala`: nombran grados, no notas.
    case sistemaMovil(String)
    /// `--json` con una orden que no da JSON.
    case sinSalidaJSON(String)

    // Consultas y armonización
    case faltaCifrado
    case faltaCifradoDelArpegio
    case patronDesconocido(String)
    case tradicionDesconocida(String)
    case categoriaDesconocida(String)
    case familiaDeRitmoDesconocida(String)
    /// `ritmos --comparar` con un ritmo que no está en el catálogo.
    case ritmoDesconocido(String)
    case familiaDeTemperamentoDesconocida(String)
    case familiaDeNotaDesconocida(String)
    case familiaDeFuncionDesconocida(String)
    case fuenteDesconocida(String)
    case estiloDesconocido(String)
    case lugarDesconocido(String)
    case agrupacionDesconocida(String)
    case epocaDesconocida(String)
    case afectoDesconocido(String)
    case escuelaDesconocida(String)
    case afinacionDesconocida(String)
    case ordenDeEscalasDesconocido(String)
    case ordenDeAcordesDesconocido(String)
    case intervaloDeEscalasDesconocido(String)
    case pasoFueraDeRango
    case faltanNotas
    case dosNotas
    case faltaEscala
    case faltaTonalidad
    case faltanAcordesDeLasVoces
    case dosAcordesDeConduccion
    case faltaTonalidadTrasEn
    case faltaConjunto
    case faltaSerie
    case faltanAcordesDelAnalisis
    /// `analizar --archivo` y además acordes escritos.
    case archivoConAcordes
    /// `analizar --archivo` con un fichero que tiene notas pero ningún acorde (una sola voz, por ejemplo).
    case archivoSinAcordes
    /// `transponer` sin el intervalo o sin lo que se transporta.
    case faltaTransporte
    case faltanAcordesDeLaRearmonizacion
    case faltanNotasDeLaArmonizacion
    case propuestasFueraDeRango
    case faltanAcordesDeLaRealizacion
    case faltanVocesDelContrapunto
    case especieFueraDeRango
    /// `contrapunto --proponer` sobre un cantus en el que no cabe ningún contrapunto sin faltas.
    case sinContrapuntoPosible
    /// `transponer --archivo … --formato` con un formato que no es de partitura.
    case formatoDePartituraDesconocido(String)

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
    /// `--capo` sin valor o fuera de 0…12.
    case capoFueraDeRango
    /// `arpegio --octavas` fuera de 1…4.
    case octavasFueraDeRango
    /// `escalas --notas` sin valor o fuera de 1…24.
    case notasFueraDeRango
    /// `--registro` fuera de 0…7.
    case octavaFueraDeRango
    /// `arpegio --desde` con algo que no es una nota ni un grado del acorde.
    case desdeNoValido(String)
    /// `arpegio --tensiones` con algo que no es 9, 11 o 13.
    case tensionesMalEscritas
    /// `arpegio --grados` con algo que no es un número de 1 a 22.
    case gradosMalEscritos
    /// `arpegio --aproximacion` con un nombre que no se conoce.
    case aproximacionDesconocida(String)
    case secuenciaDesconocida(String)
    /// `teclado` sin escala.
    case faltaEscalaDelTeclado
    /// `teclado … --mano` con una mano que no es derecha ni izquierda.
    case manoDesconocida(String)
    /// `identificar --archivo` con notas detrás.
    case archivoConNotas
    /// `posiciones Do mayor --formas`: las formas son de las escalas de cinco notas.
    case noEsPentatonica
    /// `reloj` sin escala.
    case faltaEscalaDelReloj
    /// `reloj … --microtonal` con una escala sin afinación propia (o sin la de `--fuente`).
    case escalaSinAfinacionPropia(String)
    /// `temperamentos … --reloj --quintas` con un temperamento cuya quinta no recorre todos sus pasos.
    case sinCirculoDeQuintas(String)
    case faltaEscalaDeLaHoja
    /// `hoja acordes` sin acordes.
    case faltanLosAcordesDeLaHoja
    /// `hoja acorde` sin acorde, o con más de uno.
    case faltaElAcordeDeLaHoja
    /// `pentagrama` sin escala, acorde ni arpegio.
    case faltaLoQueDibujaElPentagrama

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

    // Grabado
    /// `grabar` sin nada detrás.
    case faltaLoQueSeGraba
    /// `grabar midi …` (o musicxml, mei, lilypond, guido, abc): esa orden ya escribe la partitura.
    case grabarUnaPartitura(String)
    /// `grabar … --motor` con un motor que no es lilypond, musescore, verovio, guido ni propio.
    case motorDesconocido(String)
    /// `grabar … --formato` con algo que no es pdf, svg ni png.
    case formatoDeGrabadoDesconocido(String)
    /// `grabar` con algo que no es una partitura ni una orden que dibuja.
    case nadaQueGrabar(String)

    // Dibujos (`orden` es «tonnetz» o «tabla»)
    case margenFueraDeRango
    case faltanNotasDelDibujo(orden: String)
    case faltaAcordeDelDibujo(orden: String)
    case faltaEscalaDelDibujo(orden: String)
    case faltanClasesDelDibujo(orden: String)
    case faltanTriadasDelRecorrido(orden: String)
    case cicloMalEscrito(orden: String)
    case recorridoSoloTriadas(orden: String)
    case caminoSoloTriadas(orden: String)
    case cicloSoloTriadas(orden: String)
    /// `cuadricula` con una opción sin valor o con uno que no se lee: unos ejes, una rejilla, una altura o un giro.
    case opcionesDeCuadricula
}
