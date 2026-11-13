import Armonia
import Exposicion

// Los errores de uso de la herramienta, en los trece idiomas de los textos. Lo común a todos los
// textos de la herramienta está explicado en Mensaje.swift.
//
// Están todos aquí, por grupos de órdenes como su ayuda (Ayuda+…) y su código (LineaDeComandos+…): primero los
// generales (orden, opción o idioma desconocidos) y después los de cada grupo. Los que acaban en una orden de
// ejemplo la dan en `traduccion` (`conEjemplo`), en español o en inglés según el idioma, y los textos de
// `TextosDeConsola` solo dicen lo que falta.

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
    case usoDesconocido(String)
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
    /// `--octava` fuera de 0…7.
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
    /// `reloj … --microtonal` con una escala sin versión microtonal (o sin la de `--fuente`).
    case escalaSinMicrotonos(String)
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

    /// Lo que falta o sobra, en el idioma de los textos de la notación, como cualquier `ErrorDeArmonia`.
    func descripcion(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El mensaje que escribe la terminal: el error, lo que se quiso escribir si se parece a una orden o una opción
    /// conocida, y la línea que remite a la ayuda, la de la orden si se está ejecutando una
    /// (`enCurso`).
    func mensajeDeUso(en notacion: Notacion, enCurso: LineaDeComandos.OrdenEnCurso? = nil) -> String {
        var lineas = ["armonia: " + descripcion(en: notacion)]
        if let propuesta = propuesta(enCurso: enCurso) {
            lineas.append(TextosDeConsola.traduccion { $0.quisoDecir(propuesta) }.en(notacion))
        }
        if let enCurso {
            lineas.append(TextosDeConsola.traduccion { $0.pruebaLaAyudaDe(enCurso.nombre) }.en(notacion))
        } else {
            lineas.append(TextosDeConsola.en(notacion, \.pruebaLaAyuda))
        }
        return lineas.joined(separator: "\n") + "\n"
    }

    /// La orden o la opción conocida que más se parece a la desconocida (Sugerencias.swift).
    /// Las opciones que se proponen son las de la orden en curso, si la hay.
    private func propuesta(enCurso: LineaDeComandos.OrdenEnCurso?) -> String? {
        switch self {
        case .ordenDesconocida(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: LineaDeComandos.nombresDeLasOrdenes)
        case .opcionDesconocida(let opcion):
            return LineaDeComandos.propuesta(para: opcion, entre: LineaDeComandos.opcionesConocidas(enCurso: enCurso))
        case .idiomaDesconocido(let idioma):
            let nombres = Idioma.allCases.flatMap { [$0.codigo] + $0.nombres }
            return LineaDeComandos.propuesta(para: idioma, entre: nombres)
        case .tradicionDesconocida(let tradicion):
            let claves = LineaDeComandos.nombresDeLasTradiciones.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: tradicion, entre: claves)
        case .familiaDeTemperamentoDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia,
                entre: LineaDeComandos.nombresDeLasFamiliasDeTemperamento.flatMap { [$0.espanol, $0.ingles] })
        case .familiaDeNotaDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeNota.flatMap { [$0.espanol, $0.ingles] })
        case .familiaDeFuncionDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeFuncion.flatMap { [$0.espanol, $0.ingles] })
        case .ritmoDesconocido(let ritmo):
            return LineaDeComandos.propuesta(para: ritmo, entre: RitmoConNombre.catalogo.map(\.nombre))
        case .familiaDeRitmoDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeRitmo.flatMap { [$0.espanol, $0.ingles] })
        case .categoriaDesconocida(let categoria):
            return LineaDeComandos.propuesta(para: categoria, entre: CategoriaTradicional.allCases.map(\.rawValue))
        case .fuenteDesconocida(let fuente):
            return LineaDeComandos.propuesta(para: fuente, entre: FuenteTeorica.allCases.map(\.rawValue))
        case .usoDesconocido(let uso):
            let claves =
                LineaDeComandos.nombresDeLosUsos.flatMap { [$0.espanol, $0.ingles] }
                + LineaDeComandos.nombresDeLasCorrientes.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: uso, entre: claves)
        case .lugarDesconocido(let lugar):
            return LineaDeComandos.propuesta(para: lugar, entre: Lugar.todos.map(\.clave))
        case .epocaDesconocida(let epoca):
            return LineaDeComandos.propuesta(
                para: epoca, entre: LineaDeComandos.nombresDeLasEpocas.flatMap { [$0.espanol, $0.ingles] })
        case .afectoDesconocido(let afecto):
            return LineaDeComandos.propuesta(
                para: afecto, entre: Afecto.allCases.flatMap { [$0.rawValue, $0.nombre(en: .compacta(.ingles))] })
        case .escuelaDesconocida(let escuela):
            return LineaDeComandos.propuesta(
                para: escuela, entre: LineaDeComandos.nombresDeLasEscuelas.flatMap { [$0.espanol, $0.ingles] })
        case .afinacionDesconocida(let afinacion):
            return LineaDeComandos.propuesta(
                para: afinacion, entre: LineaDeComandos.nombresDeLasAfinaciones.flatMap { [$0.espanol, $0.ingles] })
        case .agrupacionDesconocida(let agrupacion):
            let claves = LineaDeComandos.nombresDeLasAgrupaciones.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: agrupacion, entre: claves)
        case .intervaloDeEscalasDesconocido(let intervalo):
            return LineaDeComandos.propuesta(
                para: intervalo, entre: Array(LineaDeComandos.clasesIntervalicasPorNombre.keys))
        case .ordenDeEscalasDesconocido(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: Array(LineaDeComandos.ordenesDeEscalas.keys))
        case .ordenDeAcordesDesconocido(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: Array(LineaDeComandos.ordenesDeAcordes.keys))
        case .escrituraNoValida(let escritura):
            return LineaDeComandos.propuesta(para: escritura, entre: LineaDeComandos.nombresDeLasEscrituras)
        case .sistemaDesconocido(let sistema):
            return LineaDeComandos.propuesta(
                para: sistema, entre: SistemaDeNombres.allCases.flatMap { [$0.rawValue] + $0.nombres })
        case .grafiaNoValida(let grafia):
            return LineaDeComandos.propuesta(para: grafia, entre: LineaDeComandos.nombresDeLasGrafias.map(\.0))
        default:
            return nil
        }
    }

    /// La orden de ejemplo de los errores de las digitaciones: en español y en inglés.
    private static let digitaciones = (
        "armonia digitaciones Sol7/Si --instrumento ukelele", "armonia fingerings G7/B --instrument ukulele"
    )

    /// El texto de un error que acaba en una orden de ejemplo (el hueco `{1}` del campo): con los nombres españoles de
    /// las órdenes y las notas en unos idiomas y con los ingleses en otros, como los ejemplos de la ayuda
    /// (`LineaDeComandos.ejemplo`). Así los textos de cada idioma solo dicen lo que falta.
    private static func conEjemplo(
        _ campo: KeyPath<TextosDeConsola, Plantilla>, _ espanol: String, _ ingles: String
    ) -> Traduccion {
        let ejemplo = LineaDeComandos.ejemplo(espanol, ingles)
        return Traduccion(cadaIdioma: { notacion in
            TextosDeConsola.en(notacion) { $0[keyPath: campo](ejemplo.en(notacion)) }
        })
    }

    /// El texto de cada error, de los campos de `TextosDeConsola`. El `switch` no tiene `default`, así que un caso
    /// nuevo no compila hasta que tiene su texto.
    private var traduccion: Traduccion {
        switch self {
        case .ordenDesconocida(let orden):
            return TextosDeConsola.traduccion { $0.ordenDesconocida(orden) }
        case .opcionDesconocida(let opcion):
            return TextosDeConsola.traduccion { $0.opcionDesconocida(opcion) }
        case .idiomaDesconocido(let idioma):
            return TextosDeConsola.traduccion { $0.idiomaDesconocido(idioma) }
        case .terminalDesconocida(let terminal):
            return TextosDeConsola.traduccion { $0.terminalDesconocida(terminal) }
        case .escrituraNoValida(let escritura):
            return TextosDeConsola.traduccion { $0.escrituraNoValida(escritura) }
        case .sistemaDesconocido(let sistema):
            let lista = SistemaDeNombres.allCases.map { $0.nombres[0] }.joined(separator: ", ")
            return TextosDeConsola.traduccion { $0.sistemaDesconocido(sistema, lista) }
        case .grafiaNoValida(let grafia):
            return TextosDeConsola.traduccion { $0.grafiaNoValida(grafia) }
        case .sistemaMovil(let sistema):
            return TextosDeConsola.traduccion { $0.sistemaMovil(sistema) }
        case .sinSalidaJSON(let orden):
            return TextosDeConsola.traduccion { $0.sinSalidaJSON(orden) }
        case .faltaCifrado: return Self.conEjemplo(\.faltaCifrado, "armonia acorde Sol7", "armonia chord G7")
        case .faltaCifradoDelArpegio:
            return Self.conEjemplo(\.faltaCifrado, "armonia arpegio Do7", "armonia arpeggio C7")
        case .patronDesconocido(let patron): return TextosDeConsola.traduccion { $0.patronDesconocido(patron) }
        case .tradicionDesconocida(let tradicion):
            return TextosDeConsola.traduccion { $0.tradicionDesconocida(tradicion) }
        case .categoriaDesconocida(let categoria):
            return TextosDeConsola.traduccion { $0.categoriaDesconocida(categoria) }
        case .familiaDeTemperamentoDesconocida(let familia):
            return TextosDeConsola.traduccion { $0.familiaDeTemperamentoDesconocida(familia) }
        case .familiaDeNotaDesconocida(let familia):
            return TextosDeConsola.traduccion { $0.familiaDeNotaDesconocida(familia) }
        case .familiaDeFuncionDesconocida(let familia):
            return TextosDeConsola.traduccion { $0.familiaDeFuncionDesconocida(familia) }
        case .ritmoDesconocido(let ritmo):
            return TextosDeConsola.traduccion { $0.ritmoDesconocido(ritmo) }
        case .familiaDeRitmoDesconocida(let familia):
            return TextosDeConsola.traduccion { $0.familiaDeRitmoDesconocida(familia) }
        case .fuenteDesconocida(let fuente):
            return TextosDeConsola.traduccion { $0.fuenteDesconocida(fuente) }
        case .usoDesconocido(let uso):
            return TextosDeConsola.traduccion { $0.usoDesconocido(uso) }
        case .lugarDesconocido(let lugar):
            return TextosDeConsola.traduccion { $0.lugarDesconocido(lugar) }
        case .agrupacionDesconocida(let agrupacion):
            return TextosDeConsola.traduccion { $0.agrupacionDesconocida(agrupacion) }
        case .epocaDesconocida(let epoca):
            return TextosDeConsola.traduccion { $0.epocaDesconocida(epoca) }
        case .afectoDesconocido(let afecto):
            return TextosDeConsola.traduccion { $0.afectoDesconocido(afecto) }
        case .escuelaDesconocida(let escuela):
            return TextosDeConsola.traduccion { $0.escuelaDesconocida(escuela) }
        case .afinacionDesconocida(let afinacion):
            return TextosDeConsola.traduccion { $0.afinacionDesconocida(afinacion) }
        case .ordenDeEscalasDesconocido(let orden):
            return TextosDeConsola.traduccion { $0.ordenDeEscalasDesconocido(orden) }
        case .ordenDeAcordesDesconocido(let orden):
            return TextosDeConsola.traduccion { $0.ordenDeAcordesDesconocido(orden) }
        case .intervaloDeEscalasDesconocido(let intervalo):
            return TextosDeConsola.traduccion { $0.intervaloDeEscalasDesconocido(intervalo) }
        case .pasoFueraDeRango: return TextosDeConsola.traduccion(\.pasoFueraDeRango)
        case .faltanNotas:
            return Self.conEjemplo(\.faltanNotas, "armonia identificar Do Mi Sol", "armonia identify C E G")
        case .dosNotas: return Self.conEjemplo(\.dosNotas, "armonia intervalo Do Mi", "armonia interval C E")
        case .faltaEscala: return Self.conEjemplo(\.faltaEscala, "armonia escala Re dórico", "armonia scale D dorian")
        case .faltaTonalidad:
            return Self.conEjemplo(\.faltaTonalidad, "armonia tonalidad La menor", "armonia key A minor")
        case .faltanAcordesDeLasVoces:
            return Self.conEjemplo(
                \.faltanAcordes, "armonia revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4",
                "armonia check C3 E4 G4 C5, G2 D4 G4 B4")
        case .dosAcordesDeConduccion:
            return Self.conEjemplo(
                \.dosAcordes, "armonia conduccion-minima Sol7 Do", "armonia minimal-voice-leading G7 C")
        case .faltaTonalidadTrasEn: return TextosDeConsola.traduccion(\.faltaTonalidadTrasEn)
        case .faltaConjunto: return Self.conEjemplo(\.faltaConjunto, "armonia conjunto 0 4 7", "armonia set 0 4 7")
        case .faltaSerie:
            return Self.conEjemplo(
                \.faltaSerie, "armonia serie 0 e 7 4 2 9 3 8 t 1 5 6", "armonia row 0 e 7 4 2 9 3 8 t 1 5 6")
        case .faltanAcordesDelAnalisis:
            return Self.conEjemplo(\.faltanAcordes, "armonia analizar Do Fa Sol7 Do", "armonia analyze C F G7 C")
        case .archivoConAcordes: return TextosDeConsola.traduccion(\.archivoConAcordes)
        case .archivoSinAcordes: return TextosDeConsola.traduccion(\.archivoSinAcordes)
        case .faltaTransporte:
            return Self.conEjemplo(
                \.faltaTransporte, "armonia transponer 2M Do Lam Fa Sol7", "armonia transpose M2 C Am F G7")
        case .faltanAcordesDeLaRearmonizacion:
            return Self.conEjemplo(
                \.faltanAcordes, "armonia rearmonizar Do Lam Rem7 Sol7", "armonia reharmonize C Am Dm7 G7")
        case .faltanNotasDeLaArmonizacion:
            return Self.conEjemplo(
                \.faltanNotasDeLaArmonizacion, "armonia armonizar Mi4 Re4 Do4", "armonia harmonize E4 D4 C4")
        case .propuestasFueraDeRango: return TextosDeConsola.traduccion(\.propuestasFueraDeRango)
        case .faltanVocesDelContrapunto:
            return Self.conEjemplo(
                \.faltanVocesDelContrapunto, "armonia contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5",
                "armonia counterpoint D4 F4 E4 D4 / A4 A4 C#5 D5")
        case .especieFueraDeRango: return TextosDeConsola.traduccion(\.especieFueraDeRango)
        case .sinContrapuntoPosible: return TextosDeConsola.traduccion(\.sinContrapuntoPosible)
        case .formatoDePartituraDesconocido(let formato):
            return TextosDeConsola.traduccion { $0.formatoDePartituraDesconocido(formato) }
        case .faltanAcordesDeLaRealizacion:
            return Self.conEjemplo(\.faltanAcordes, "armonia realizar Do Fa Sol7 Do", "armonia realize C F G7 C")
        case .faltaInstrumento: return Self.conEjemplo(\.faltaInstrumento, Self.digitaciones.0, Self.digitaciones.1)
        case .instrumentoDesconocido(let nombre):
            // Los nombres conocidos, en el idioma del mensaje (se aceptan en cualquiera de los trece).
            let conocidos = Encordado.todos.map { Mensaje.instrumento($0).traduccion }
            let lista = { (idioma: Notacion) in conocidos.map { $0.en(idioma) }.joined(separator: ", ") }
            return TextosDeConsola.traduccion { $0.instrumentoDesconocido(nombre, lista) }
        case .faltaLimite: return TextosDeConsola.traduccion(\.faltaLimite)
        case .limiteFueraDeRango: return TextosDeConsola.traduccion(\.limiteFueraDeRango)
        case .faltanDedos: return TextosDeConsola.traduccion(\.faltanDedos)
        case .dedosFueraDeRango: return TextosDeConsola.traduccion(\.dedosFueraDeRango)
        case .faltaTraste: return TextosDeConsola.traduccion(\.faltaTraste)
        case .trasteFueraDeRango: return TextosDeConsola.traduccion(\.trasteFueraDeRango)
        case .faltaCifradoDeDigitaciones:
            return Self.conEjemplo(\.faltaCifrado, Self.digitaciones.0, Self.digitaciones.1)
        case .faltaEscalaDePosiciones:
            return Self.conEjemplo(\.faltaEscala, "armonia posiciones Sol mayor", "armonia positions G major")
        case .capoFueraDeRango: return TextosDeConsola.traduccion(\.capoFueraDeRango)
        case .octavasFueraDeRango: return TextosDeConsola.traduccion(\.octavasFueraDeRango)
        case .notasFueraDeRango: return TextosDeConsola.traduccion(\.notasFueraDeRango)
        case .octavaFueraDeRango: return TextosDeConsola.traduccion(\.octavaFueraDeRango)
        case .desdeNoValido(let desde): return TextosDeConsola.traduccion { $0.desdeNoValido(desde) }
        case .tensionesMalEscritas: return TextosDeConsola.traduccion(\.tensionesMalEscritas)
        case .gradosMalEscritos: return TextosDeConsola.traduccion(\.gradosMalEscritos)
        case .aproximacionDesconocida(let nombre):
            return TextosDeConsola.traduccion { $0.aproximacionDesconocida(nombre) }
        case .secuenciaDesconocida(let nombre):
            return TextosDeConsola.traduccion { $0.secuenciaDesconocida(nombre) }
        case .faltaEscalaDelTeclado:
            return Self.conEjemplo(\.faltaEscala, "armonia teclado Re mayor", "armonia keyboard D major")
        case .manoDesconocida(let mano): return TextosDeConsola.traduccion { $0.manoDesconocida(mano) }
        case .archivoConNotas: return TextosDeConsola.traduccion(\.archivoConNotas)
        case .noEsPentatonica:
            return Self.conEjemplo(
                \.noEsPentatonica, "armonia posiciones La pentatónica menor --formas",
                "armonia positions A minor pentatonic --shapes")
        case .faltaEscalaDelReloj:
            return Self.conEjemplo(\.faltaEscala, "armonia reloj Re mayor", "armonia clock D major")
        case .escalaSinMicrotonos(let escala):
            return TextosDeConsola.traduccion { $0.escalaSinMicrotonos(escala) }
        case .sinCirculoDeQuintas(let temperamento):
            return TextosDeConsola.traduccion { $0.sinCirculoDeQuintas(temperamento) }
        case .faltaEscalaDeLaHoja:
            return Self.conEjemplo(\.faltaEscala, "armonia hoja Re mayor", "armonia sheet D major")
        case .faltanLosAcordesDeLaHoja:
            return Self.conEjemplo(
                \.faltanAcordes, "armonia hoja acordes Rem7 Sol7 Do7M", "armonia sheet chords Dm7 G7 Cmaj7")
        case .faltaElAcordeDeLaHoja:
            return Self.conEjemplo(\.faltaAcorde, "armonia hoja acorde Sol7", "armonia sheet chord G7")
        case .faltaLoQueDibujaElPentagrama:
            return Self.conEjemplo(
                \.faltaLoQueDibujaElPentagrama, "armonia pentagrama escala Re dórico", "armonia staff scale D dorian")
        case .vocesFueraDeRango: return TextosDeConsola.traduccion(\.vocesFueraDeRango)
        case .unAcordeDeVecinos:
            return Self.conEjemplo(\.unAcordeDeVecinos, "armonia vecinos Sol7", "armonia neighbors G7")
        case .vecinosSinFamilia: return TextosDeConsola.traduccion(\.vecinosSinFamilia)
        case .dosAcordesDeCamino:
            return Self.conEjemplo(\.dosAcordes, "armonia camino-parsimonioso Sol7 Rem7", "armonia smooth-path G7 Dm7")
        case .caminoSinConexion: return TextosDeConsola.traduccion(\.caminoSinConexion)
        case .faltanPasosDePLR: return Self.conEjemplo(\.faltanPasosDePLR, "armonia plr Do PLR", "armonia plr C PLR")
        case .plrSoloTriadas(let camino):
            let (espanol, ingles) = camino ? ("camino Do Mibm", "shortest C Ebm") : ("Do PLR", "C PLR")
            return Self.conEjemplo(\.plrSoloTriadas, "armonia plr " + espanol, "armonia plr " + ingles)
        case .faltaTipoDePartitura(let orden):
            return Self.conEjemplo(
                \.faltaTipoDePartitura, "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4",
                "armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --time 3/4")
        case .instrumentoMIDI: return TextosDeConsola.traduccion(\.instrumentoMIDI)
        case .marcasSoloMusicXML: return TextosDeConsola.traduccion(\.marcasSoloMusicXML)
        case .faltaValor(let opcion): return TextosDeConsola.traduccion { $0.faltaValor(opcion) }
        case .tempoMalEscrito: return TextosDeConsola.traduccion(\.tempoMalEscrito)
        case .faltanNotasDeLaMelodia(let orden):
            return Self.conEjemplo(
                \.faltanNotas, "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4",
                "armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --time 3/4")
        case .marcasSoloCoral: return TextosDeConsola.traduccion(\.marcasSoloCoral)
        case .duracionSoloCoral: return TextosDeConsola.traduccion(\.duracionSoloCoral)
        case .claveDesconocida(let clave):
            let claves = LineaDeComandos.ejemplo(
                "(sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)",
                "(treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)")
            return Traduccion(cadaIdioma: { notacion in
                TextosDeConsola.en(notacion) { $0.claveDesconocida(clave, claves.en(notacion)) }
            })
        case .faltanAcordesDelCoral(let orden):
            return Self.conEjemplo(
                \.faltanAcordes, "armonia \(orden) coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4",
                "armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4")
        case .soloParaMelodia(let opcion): return TextosDeConsola.traduccion { $0.soloParaMelodia(opcion) }
        case .soloParaArpegios(let opcion): return TextosDeConsola.traduccion { $0.soloParaArpegios(opcion) }
        case .archivoSoloParaAcordes: return TextosDeConsola.traduccion(\.archivoSoloParaAcordes)
        case .ventanaSinArchivo: return TextosDeConsola.traduccion(\.ventanaSinArchivo)
        case .faltanAcordesDeLaProgresion(let orden):
            return Self.conEjemplo(
                \.faltanAcordes, "armonia \(orden) acordes Do Lam Re7 Sol7 Do", "armonia \(orden) chords C Am D7 G7 C")
        case .acordesConCifradosYAnalisis: return TextosDeConsola.traduccion(\.acordesConCifradosYAnalisis)
        case .tipoDePartituraDesconocido(let tipo):
            return TextosDeConsola.traduccion { $0.tipoDePartituraDesconocido(tipo) }
        case .faltaLoQueSeGraba:
            return Self.conEjemplo(
                \.faltaLoQueSeGraba, "armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
                "armonia engrave chorale C3 E4 G4 C5 > chorale.pdf")
        case .grabarUnaPartitura(let orden):
            let ejemplo = LineaDeComandos.ejemplo(
                "armonia grabar melodia Do4:4 Re4:4 > melodia.pdf", "armonia engrave melody C4:4 D4:4 > melody.pdf")
            return Traduccion(cadaIdioma: { notacion in
                TextosDeConsola.en(notacion) { $0.grabarUnaPartitura(orden, ejemplo.en(notacion)) }
            })
        case .motorDesconocido(let motor): return TextosDeConsola.traduccion { $0.motorDesconocido(motor) }
        case .formatoDeGrabadoDesconocido(let formato):
            return TextosDeConsola.traduccion { $0.formatoDeGrabadoDesconocido(formato) }
        case .nadaQueGrabar(let orden): return TextosDeConsola.traduccion { $0.nadaQueGrabar(orden) }
        case .margenFueraDeRango: return TextosDeConsola.traduccion(\.margenFueraDeRango)
        case .faltanNotasDelDibujo(let orden):
            return Self.conEjemplo(\.faltanNotas, "armonia \(orden) Do Mi Sol", "armonia \(orden) C E G")
        case .faltaAcordeDelDibujo(let orden):
            return Self.conEjemplo(\.faltaAcorde, "armonia \(orden) acorde Sol7", "armonia \(orden) chord G7")
        case .faltaEscalaDelDibujo(let orden):
            return Self.conEjemplo(
                \.faltaEscala, "armonia \(orden) escala Re dórico", "armonia \(orden) scale D dorian")
        case .faltanClasesDelDibujo(let orden):
            return Self.conEjemplo(
                \.faltanClasesDelDibujo, "armonia \(orden) clases 0 4 7", "armonia \(orden) pcs 0 4 7")
        case .faltanTriadasDelRecorrido(let orden):
            return Self.conEjemplo(
                \.faltanTriadasDelRecorrido, "armonia \(orden) recorrido Do Lam Fa Rem",
                "armonia \(orden) sequence C Am F Dm")
        case .cicloMalEscrito(let orden):
            return Self.conEjemplo(
                \.cicloMalEscrito, "armonia \(orden) ciclo hexatonico Do", "armonia \(orden) cycle hexatonic C")
        case .recorridoSoloTriadas(let orden):
            return Self.conEjemplo(
                \.recorridoSoloTriadas, "armonia \(orden) recorrido Do Lam Fa Rem",
                "armonia \(orden) sequence C Am F Dm")
        case .caminoSoloTriadas(let orden):
            return Self.conEjemplo(
                \.caminoSoloTriadas, "armonia \(orden) camino Do Mibm", "armonia \(orden) shortest C Ebm")
        case .cicloSoloTriadas(let orden):
            return Self.conEjemplo(
                \.cicloSoloTriadas, "armonia \(orden) ciclo hexatonico Do", "armonia \(orden) cycle hexatonic C")
        case .opcionesDeCuadricula: return TextosDeConsola.traduccion(\.opcionesDeCuadricula)
        }
    }
}
