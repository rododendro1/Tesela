import Armonia
import ArmoniaPresentacion

// Los errores de uso de la herramienta, en los quince idiomas de los textos. Lo común a todos los
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
    /// `completado` sin bash, zsh ni fish.
    case terminalDesconocida(String)
    /// `--escritura` con un valor que no es palabras ni compacto (ni, en español e inglés, ascii o unicode).
    case escrituraNoValida(String)
    /// `--json` con una orden que no da JSON.
    case sinSalidaJSON(String)

    // Consultas y armonización
    case faltaCifrado
    case faltaCifradoDelArpegio
    case patronDesconocido(String)
    case tradicionDesconocida(String)
    case categoriaDesconocida(String)
    case usoDesconocido(String)
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
    /// `analizar --archivo` con un fichero que no existe o no se puede abrir.
    case archivoIlegible(String)
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

    /// El mensaje completo: el error, lo que se quiso escribir si se parece a una orden o una opción conocida, y la
    /// línea que remite a la ayuda, la de la orden si se está ejecutando una (`LineaDeComandos.OrdenEnCurso`).
    func texto(en notacion: Notacion) -> String {
        var lineas = ["armonia: " + traduccion.en(notacion)]
        if let propuesta {
            lineas.append(TextosDeCLI.traduccion { $0.quisoDecir(propuesta) }.en(notacion))
        }
        if let enCurso = LineaDeComandos.OrdenEnCurso.actual {
            lineas.append(TextosDeCLI.traduccion { $0.pruebaLaAyudaDe(enCurso.nombre) }.en(notacion))
        } else {
            lineas.append(TextosDeCLI.en(notacion, \.pruebaLaAyuda))
        }
        return lineas.joined(separator: "\n") + "\n"
    }

    /// La orden o la opción conocida que más se parece a la desconocida (Sugerencias.swift).
    private var propuesta: String? {
        switch self {
        case .ordenDesconocida(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: LineaDeComandos.nombresDeLasOrdenes)
        case .opcionDesconocida(let opcion):
            return LineaDeComandos.propuesta(para: opcion, entre: LineaDeComandos.opcionesConocidas)
        case .idiomaDesconocido(let idioma):
            let nombres = Idioma.allCases.flatMap { [$0.codigo] + $0.nombres }
            return LineaDeComandos.propuesta(para: idioma, entre: nombres)
        case .tradicionDesconocida(let tradicion):
            let claves = LineaDeComandos.nombresDeLasTradiciones.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: tradicion, entre: claves)
        case .categoriaDesconocida(let categoria):
            return LineaDeComandos.propuesta(para: categoria, entre: CategoriaTradicional.allCases.map(\.rawValue))
        case .usoDesconocido(let uso):
            let claves = LineaDeComandos.nombresDeLosUsos.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: uso, entre: claves)
        case .escrituraNoValida(let escritura):
            return LineaDeComandos.propuesta(para: escritura, entre: LineaDeComandos.nombresDeLasEscrituras)
        default:
            return nil
        }
    }

    /// La orden de ejemplo de los errores de las digitaciones: en español y en inglés.
    private static let digitaciones = (
        "armonia digitaciones Sol7/Si --instrumento ukelele", "armonia fingerings G7/B --instrument ukulele"
    )

    /// El texto de cada error, de los campos de `TextosDeCLI`. El `switch` no tiene `default`, así que un caso nuevo
    /// no compila hasta que tiene su texto.
    private var traduccion: Traduccion {
        switch self {
        case .ordenDesconocida(let orden):
            return TextosDeCLI.traduccion { $0.ordenDesconocida(orden) }
        case .opcionDesconocida(let opcion):
            return TextosDeCLI.traduccion { $0.opcionDesconocida(opcion) }
        case .idiomaDesconocido(let idioma):
            return TextosDeCLI.traduccion { $0.idiomaDesconocido(idioma) }
        case .terminalDesconocida(let terminal):
            return TextosDeCLI.traduccion { $0.terminalDesconocida(terminal) }
        case .escrituraNoValida(let escritura):
            return TextosDeCLI.traduccion { $0.escrituraNoValida(escritura) }
        case .sinSalidaJSON(let orden):
            return TextosDeCLI.traduccion { $0.sinSalidaJSON(orden) }
        case .faltaCifrado: return TextosDeCLI.traduccion(\.faltaCifrado)
        case .faltaCifradoDelArpegio: return TextosDeCLI.traduccion(\.faltaCifradoDelArpegio)
        case .patronDesconocido(let patron): return TextosDeCLI.traduccion { $0.patronDesconocido(patron) }
        case .tradicionDesconocida(let tradicion):
            return TextosDeCLI.traduccion { $0.tradicionDesconocida(tradicion) }
        case .categoriaDesconocida(let categoria):
            return TextosDeCLI.traduccion { $0.categoriaDesconocida(categoria) }
        case .usoDesconocido(let uso):
            return TextosDeCLI.traduccion { $0.usoDesconocido(uso) }
        case .faltanNotas: return TextosDeCLI.traduccion(\.faltanNotas)
        case .dosNotas: return TextosDeCLI.traduccion(\.dosNotas)
        case .faltaEscala: return TextosDeCLI.traduccion(\.faltaEscala)
        case .faltaTonalidad: return TextosDeCLI.traduccion(\.faltaTonalidad)
        case .faltanAcordesDeLasVoces:
            let ejemplo = "armonia revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLasVoces(ejemplo) }
        case .dosAcordesDeConduccion:
            let ejemplo = "armonia conduccion-minima Sol7 Do"
            return TextosDeCLI.traduccion { $0.dosAcordesDeConduccion(ejemplo) }
        case .faltaTonalidadTrasEn: return TextosDeCLI.traduccion(\.faltaTonalidadTrasEn)
        case .faltaConjunto: return TextosDeCLI.traduccion(\.faltaConjunto)
        case .faltaSerie: return TextosDeCLI.traduccion(\.faltaSerie)
        case .faltanAcordesDelAnalisis:
            let ejemplo = "armonia analizar Do Fa Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDelAnalisis(ejemplo) }
        case .archivoIlegible(let nombre): return TextosDeCLI.traduccion { $0.archivoIlegible(nombre) }
        case .archivoConAcordes: return TextosDeCLI.traduccion(\.archivoConAcordes)
        case .archivoSinAcordes: return TextosDeCLI.traduccion(\.archivoSinAcordes)
        case .faltaTransporte:
            let ejemplo = "armonia transponer 2M Do Lam Fa Sol7"
            return TextosDeCLI.traduccion { $0.faltaTransporte(ejemplo) }
        case .faltanAcordesDeLaRearmonizacion:
            let ejemplo = "armonia rearmonizar Do Lam Rem7 Sol7"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaRearmonizacion(ejemplo) }
        case .faltanNotasDeLaArmonizacion:
            let ejemplo = "armonia armonizar Mi4 Re4 Do4"
            return TextosDeCLI.traduccion { $0.faltanNotasDeLaArmonizacion(ejemplo) }
        case .propuestasFueraDeRango: return TextosDeCLI.traduccion(\.propuestasFueraDeRango)
        case .faltanVocesDelContrapunto:
            let ejemplo = "armonia contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5"
            let ingles = "armonia counterpoint D4 F4 E4 D4 / A4 A4 C#5 D5"
            return TextosDeCLI.traduccion { $0.faltanVocesDelContrapunto(ejemplo, ingles) }
        case .especieFueraDeRango: return TextosDeCLI.traduccion(\.especieFueraDeRango)
        case .faltanAcordesDeLaRealizacion:
            let ejemplo = "armonia realizar Do Fa Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaRealizacion(ejemplo) }
        case .faltaInstrumento:
            return TextosDeCLI.traduccion { $0.faltaInstrumento(Self.digitaciones.0, Self.digitaciones) }
        case .instrumentoDesconocido(let nombre):
            // Los nombres conocidos, en el idioma del mensaje (se aceptan en cualquiera de los quince).
            let conocidos = Encordado.todos.map { Mensaje.instrumento($0).traduccion }
            let lista = { (idioma: Notacion) in conocidos.map { $0.en(idioma) }.joined(separator: ", ") }
            return TextosDeCLI.traduccion { $0.instrumentoDesconocido(nombre, lista) }
        case .faltaLimite: return TextosDeCLI.traduccion(\.faltaLimite)
        case .limiteFueraDeRango: return TextosDeCLI.traduccion(\.limiteFueraDeRango)
        case .faltanDedos: return TextosDeCLI.traduccion(\.faltanDedos)
        case .dedosFueraDeRango: return TextosDeCLI.traduccion(\.dedosFueraDeRango)
        case .faltaTraste: return TextosDeCLI.traduccion(\.faltaTraste)
        case .trasteFueraDeRango: return TextosDeCLI.traduccion(\.trasteFueraDeRango)
        case .faltaCifradoDeDigitaciones:
            return TextosDeCLI.traduccion { $0.faltaCifradoDeDigitaciones(Self.digitaciones.0, Self.digitaciones) }
        case .faltaEscalaDePosiciones: return TextosDeCLI.traduccion(\.faltaEscalaDePosiciones)
        case .capoFueraDeRango: return TextosDeCLI.traduccion(\.capoFueraDeRango)
        case .octavasFueraDeRango: return TextosDeCLI.traduccion(\.octavasFueraDeRango)
        case .octavaFueraDeRango: return TextosDeCLI.traduccion(\.octavaFueraDeRango)
        case .desdeNoValido(let desde): return TextosDeCLI.traduccion { $0.desdeNoValido(desde) }
        case .tensionesMalEscritas: return TextosDeCLI.traduccion(\.tensionesMalEscritas)
        case .gradosMalEscritos: return TextosDeCLI.traduccion(\.gradosMalEscritos)
        case .aproximacionDesconocida(let nombre):
            return TextosDeCLI.traduccion { $0.aproximacionDesconocida(nombre) }
        case .secuenciaDesconocida(let nombre):
            return TextosDeCLI.traduccion { $0.secuenciaDesconocida(nombre) }
        case .faltaEscalaDelTeclado: return TextosDeCLI.traduccion(\.faltaEscalaDelTeclado)
        case .manoDesconocida(let mano): return TextosDeCLI.traduccion { $0.manoDesconocida(mano) }
        case .archivoConNotas: return TextosDeCLI.traduccion(\.archivoConNotas)
        case .noEsPentatonica: return TextosDeCLI.traduccion(\.noEsPentatonica)
        case .faltaEscalaDelReloj: return TextosDeCLI.traduccion(\.faltaEscalaDelReloj)
        case .faltaLoQueDibujaElPentagrama: return TextosDeCLI.traduccion(\.faltaLoQueDibujaElPentagrama)
        case .vocesFueraDeRango: return TextosDeCLI.traduccion(\.vocesFueraDeRango)
        case .unAcordeDeVecinos:
            let ejemplo = "armonia vecinos Sol7"
            return TextosDeCLI.traduccion { $0.unAcordeDeVecinos(ejemplo) }
        case .vecinosSinFamilia: return TextosDeCLI.traduccion(\.vecinosSinFamilia)
        case .dosAcordesDeCamino:
            let ejemplo = "armonia conduccion-parsimoniosa Sol7 Rem7"
            return TextosDeCLI.traduccion { $0.dosAcordesDeCamino(ejemplo) }
        case .caminoSinConexion: return TextosDeCLI.traduccion(\.caminoSinConexion)
        case .faltanPasosDePLR:
            let ejemplo = "armonia plr Do PLR"
            return TextosDeCLI.traduccion { $0.faltanPasosDePLR(ejemplo) }
        case .plrSoloTriadas(let camino):
            let ejemplo = "armonia plr " + (camino ? "Do Mibm" : "Do PLR")
            return TextosDeCLI.traduccion { $0.plrSoloTriadas(ejemplo, camino) }
        case .faltaTipoDePartitura(let orden):
            let ejemplo = "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4"
            return TextosDeCLI.traduccion { $0.faltaTipoDePartitura(ejemplo, orden) }
        case .instrumentoMIDI: return TextosDeCLI.traduccion(\.instrumentoMIDI)
        case .marcasSoloMusicXML: return TextosDeCLI.traduccion(\.marcasSoloMusicXML)
        case .faltaValor(let opcion): return TextosDeCLI.traduccion { $0.faltaValor(opcion) }
        case .tempoMalEscrito: return TextosDeCLI.traduccion(\.tempoMalEscrito)
        case .faltanNotasDeLaMelodia(let orden):
            let ejemplo = "armonia \(orden) melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4"
            return TextosDeCLI.traduccion { $0.faltanNotasDeLaMelodia(ejemplo, orden) }
        case .marcasSoloCoral: return TextosDeCLI.traduccion(\.marcasSoloCoral)
        case .duracionSoloCoral: return TextosDeCLI.traduccion(\.duracionSoloCoral)
        case .claveDesconocida(let clave):
            let claves = "(sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)"
            return TextosDeCLI.traduccion { $0.claveDesconocida(clave, claves) }
        case .faltanAcordesDelCoral(let orden):
            let ejemplo = "armonia \(orden) coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4"
            return TextosDeCLI.traduccion { $0.faltanAcordesDelCoral(ejemplo, orden) }
        case .soloParaMelodia(let opcion): return TextosDeCLI.traduccion { $0.soloParaMelodia(opcion) }
        case .soloParaArpegios(let opcion): return TextosDeCLI.traduccion { $0.soloParaArpegios(opcion) }
        case .archivoSoloParaAcordes: return TextosDeCLI.traduccion(\.archivoSoloParaAcordes)
        case .ventanaSinArchivo: return TextosDeCLI.traduccion(\.ventanaSinArchivo)
        case .faltanAcordesDeLaProgresion(let orden):
            let ejemplo = "armonia \(orden) acordes Do Lam Re7 Sol7 Do"
            return TextosDeCLI.traduccion { $0.faltanAcordesDeLaProgresion(ejemplo, orden) }
        case .acordesConCifradosYAnalisis: return TextosDeCLI.traduccion(\.acordesConCifradosYAnalisis)
        case .tipoDePartituraDesconocido(let tipo):
            return TextosDeCLI.traduccion { $0.tipoDePartituraDesconocido(tipo) }
        case .faltaLoQueSeGraba: return TextosDeCLI.traduccion(\.faltaLoQueSeGraba)
        case .grabarUnaPartitura(let orden):
            let ejemplo = LineaDeComandos.ejemplo(
                "armonia grabar melodia Do4:4 Re4:4 > melodia.pdf", "armonia engrave melody C4:4 D4:4 > melody.pdf")
            return Traduccion(cadaIdioma: { notacion in
                TextosDeCLI.en(notacion) { $0.grabarUnaPartitura(orden, ejemplo.en(notacion)) }
            })
        case .motorDesconocido(let motor): return TextosDeCLI.traduccion { $0.motorDesconocido(motor) }
        case .formatoDeGrabadoDesconocido(let formato):
            return TextosDeCLI.traduccion { $0.formatoDeGrabadoDesconocido(formato) }
        case .nadaQueGrabar(let orden): return TextosDeCLI.traduccion { $0.nadaQueGrabar(orden) }
        case .margenFueraDeRango: return TextosDeCLI.traduccion(\.margenFueraDeRango)
        case .faltanNotasDelDibujo(let orden):
            let ejemplo = "armonia \(orden) Do Mi Sol"
            return TextosDeCLI.traduccion { $0.faltanNotasDelDibujo(ejemplo, orden) }
        case .faltaAcordeDelDibujo(let orden):
            let ejemplo = "armonia \(orden) --acorde Sol7"
            return TextosDeCLI.traduccion { $0.faltaAcordeDelDibujo(ejemplo, orden) }
        case .faltaEscalaDelDibujo(let orden):
            let ejemplo = "armonia \(orden) --escala Re dórico"
            return TextosDeCLI.traduccion { $0.faltaEscalaDelDibujo(ejemplo, orden) }
        case .faltanClasesDelDibujo(let orden):
            let ejemplo = "armonia \(orden) --clases 0 4 7"
            return TextosDeCLI.traduccion { $0.faltanClasesDelDibujo(ejemplo, orden) }
        case .faltanTriadasDelRecorrido(let orden):
            let ejemplo = "armonia \(orden) --recorrido Do Lam Fa Rem"
            return TextosDeCLI.traduccion { $0.faltanTriadasDelRecorrido(ejemplo, orden) }
        case .cicloMalEscrito(let orden):
            let ejemplo = "armonia \(orden) --ciclo hexatonico Do"
            return TextosDeCLI.traduccion { $0.cicloMalEscrito(ejemplo, orden) }
        case .recorridoSoloTriadas(let orden):
            let ejemplo = "armonia \(orden) --recorrido Do Lam Fa Rem"
            return TextosDeCLI.traduccion { $0.recorridoSoloTriadas(ejemplo, orden) }
        case .caminoSoloTriadas(let orden):
            let ejemplo = "armonia \(orden) --camino Do Mibm"
            return TextosDeCLI.traduccion { $0.caminoSoloTriadas(ejemplo, orden) }
        case .cicloSoloTriadas(let orden):
            let ejemplo = "armonia \(orden) --ciclo hexatonico Do"
            return TextosDeCLI.traduccion { $0.cicloSoloTriadas(ejemplo, orden) }
        case .opcionesDeCuadricula: return TextosDeCLI.traduccion(\.opcionesDeCuadricula)
        }
    }
}
