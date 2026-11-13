import Armonia
import Exposicion

// El texto de cada error de uso (`ErrorDeUso.swift`), de los campos de `TextosDeConsola`.

extension ErrorDeUso {
    /// Lo que falta o sobra, en el idioma de los textos de la notación, como cualquier `ErrorDeArmonia`.
    func descripcion(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// La orden de ejemplo de los errores de las digitaciones: en español y en inglés.
    private static let digitaciones = (
        "armonia digitaciones Sol7/Si --instrumento ukelele", "armonia fingerings G7/B --instrument ukulele"
    )

    /// El texto de un error que acaba en una orden de ejemplo (el hueco `{1}` del campo): con los nombres españoles de
    /// las órdenes y las notas en unos idiomas y con los ingleses en otros, como los ejemplos de la ayuda
    /// (`LineaDeComandos.ejemplo(_:_:)`). Así los textos de cada idioma solo dicen lo que falta.
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
        case .estiloDesconocido(let estilo):
            return TextosDeConsola.traduccion { $0.estiloDesconocido(estilo) }
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
        case .escalaSinAfinacionPropia(let escala):
            return TextosDeConsola.traduccion { $0.escalaSinAfinacionPropia(escala) }
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
