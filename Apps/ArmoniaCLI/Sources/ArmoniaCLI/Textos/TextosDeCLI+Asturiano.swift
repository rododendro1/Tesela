// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let asturiano = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidá>]",
        descripcionAnalizar: "cifráu romanu, funciones, cadencies\ny modulaciones (col so acorde\npivote; ensin --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <ficheru> [--ventana <duración>]",
        descripcionAnalizarArchivo: "lo mesmo, colos acordes d'un ficheru\nMIDI o MusicXML (ún per pulsu;\n--ventana 2: ún per blanca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidá>] [--propuestas 3]",
        descripcionArmonizar: "acordes pa una melodía, de meyor a\npeor; con octaves (Mi4), tamién el\ncoral a cuatro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidá>]",
        descripcionRealizar: "los acordes a cuatro voces, ensin\nfalles de conducción",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "falles de conducción (quintes\nparaleles…); acordes de grave a\nagudu, separtaos por comes",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapuntu> [--especie 1]",
        descripcionContrapunto: "falles d\'un contrapuntu d\'especies\n(1 a 5) sobre un cantus firmus en\nredondes; notes ensin duración: la\nde la especie",
        sintaxisTransponer: "transponer <intervalu|tónica> <acordes o notes>",
        descripcionTransponer: "lleva unos acordes, una melodía o un\ncoral a otru tonu: un intervalu (2M,\n-3m) o la nueva tónica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidá>]",
        descripcionRearmonizar: "otres armoníes pa cada acorde:\nsustitutu tritonal, dominantes\nsecundaries, emprestu modal y\nsustitutos diatónicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifráu>…",
        descripcionAcorde: "notes, tipu y papel de cada nota",
        sintaxisArpegio: "arpegio <cifráu> [--patron <patrón>]",
        descripcionArpegio: "notes del arpexu y escales del\nacorde (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notes>",
        descripcionIdentificar: "acordes que formen unes notes",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalu ente dos notes o altures",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notes y acordes d\'una escala",
        sintaxisTonalidad: "tonalidad <tonalidá>",
        descripcionTonalidad: "armadura, relatives y graos",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "Tonnetz en SVG d\'unes notes",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifráu> | --escala <escala> | --clases <númberos>",
        descripcionTonnetzAcorde: "d\'un acorde, una escala o un\nconxuntu de clases d\'altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríades> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un percorríu de tríades, con fleches,\no\'l camín más curtiu per P, L y R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclu> <tríada>",
        descripcionTonnetzCiclo: "un ciclu hexatónicu, octatónicu o LR",
        notasTonnetzCiclo: "(--margen 2: más rede alredor)",
        sintaxisTabla: "tabla <notes o altures>",
        descripcionTabla: "tabla armónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde <cifráu> | --escala <escala> | --clases <númberos>\ntabla --recorrido <tríades> | --camino <tríada> <tríada>\ntabla --ciclo <ciclu> <tríada>",
        descripcionTablaAcorde: "(--margen 2: más tabla alredor)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semitonu (séptimes: dominante, menor, semimenguada\ny menguada; tríades: mayor, menor y aumentada; un maj7, ente\nles séptimes y los maj7; --ampliada: colos maj7 tamién)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d\'un acorde a otru moviendo una voz\n(o dos) un semitonu en cada pasu",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "la conducción con menos semitonos",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "tresformaciones neorriemannianes",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "el camín más curtiu per P, L y R",
        sintaxisPlrCiclo: "plr <tríada> <ciclu>",
        descripcionPlrCiclo: "un ciclu: hexatonico (P, L),\noctatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opciones]",
        descripcionMusicxmlMelodia: "partitura MusicXML d\'una melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opciones]",
        descripcionMusicxmlCoral: "coral a cuatro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifraos> [opciones]",
        descripcionMusicxmlAcordes: "progresión con cifraos y análisis",
        notasMusicxmlAcordes: "opciones: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo El mio coral,\n--duracion 2 (lo que dura cada acorde; negra nel coral y\nblanca nos acordes si non), --cifrados y --analisis (nel\ncoral: cifráu americanu enriba, romanu y función embaxo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifraos> [opciones]",
        descripcionMusicxmlArpegios: "los acordes arpexaos, nota a nota",
        notasMusicxmlArpegios: "opciones: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (lo que dura cada nota; corchea si non),\n--duracion 1 (lo que dura cada acorde: el patrón repítese\nhasta enllenalu) y les demás de «acordes»",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <ficheru>",
        descripcionMusicxmlArchivo: "la progresión d'un ficheru MIDI o\nMusicXML, colo que dura cada acorde\n(tamién arpegios, mei y midi)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionMeiMelodia: "lo mesmo en MEI 5, el formatu de les\nediciones crítiques (coles mesmes\nopciones)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionLilypondMelodia: "lo mesmo en LilyPond, pa grabar la\npartitura en PDF",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionAbcMelodia: "lo mesmo en ABC, la notación en testu\nde la música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionMidiMelodia: "lo mesmo como ficheru MIDI, pa oyilo\n(ensin --clave nin --cifrados; con\n--programa 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifráu>… [opciones]",
        descripcionDigitaciones: "formes de tocar un acorde, de la más cómoda a la menos, nun\ninstrumentu de cuerda con trastes (cuerdes de grave a agudu)\nopciones: --instrumento guitarra|bajo|ukelele|mandolina|…\n(tamién «guitarra de siete cuerdas», «bajo de 5 cuerdas»,\n«drop D»), --limite 5, --traste 12 (el más altu que s\'usa),\n--dedos 4 (los que se puen usar), --completo (con toles notes:\npor defectu la quinta pue faltar), --diagrama (una llinia per cuerda),\n--capo 2 (los trastes, dende'l capo), --musicxml (la primer forma\nde cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "la escala per posiciones na guitarra:\ntres notes per cuerda (dos nes\npentatóniques) o CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical dende la llinia de comandos.

        Usu: armonia <orde> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Ordes (les ordes y les opciones escríbense en castellán o n'inglés):
        """,
        pieDeLaAyuda: """
        Acéptense nomes de nota en castellán, asturianu, catalán, gallegu, vascu o inglés (Do, C,
        Sib, Bb, si bemol). Con --idioma ast, la rempuesta usa la notación asturiana y los mensaxes
        n'asturianu; con --ingles, n'inglés.
        Con --textos, los testos van n'otra llingua que les notes: --idioma en --textos ast.
        En castellán y inglés, --escritura palabras|ascii|unicode escribe les notes como Fa sostenido,
        Fa# o Fa♯ (n'inglés, F sharp, F# o F♯).
        Con --subindices, la octava va en subíndiz: La₄, Fa♯₃ (lléese de les dos maneres, La4 y La₄).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "esta ayuda",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "l'autocompletáu de les órdenes y\nopciones pa la terminal",
        sintaxisManual: "manual",
        descripcionManual: "esta ayuda como páxina de manual",
        manualNombre: "NOME",
        manualNotas: "NOTES",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "falten los acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "faen falta dos acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "falten les notes de la melodía: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d\'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "falten el cantus firmus y el contrapuntu, separtaos por /: " + ejemplo },
        especieFueraDeRango: "--especie va d\'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "falten los acordes: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "falta\'l cifráu: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta\'l cifráu: armonia arpegio Do7",
        patronDesconocido: { patron in "patrón desconocíu: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado o alberti)" },
        faltanNotas: "falten les notes: armonia identificar Do Mi Sol",
        dosNotas: "faen falta dos notes: armonia intervalo Do Mi",
        faltaEscala: "falta la escala: armonia escala Re dórico",
        faltaTonalidad: "falta la tonalidá: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta la tonalidá tres de --en",
        faltanAcordesDelAnalisis: { ejemplo in "falten los acordes: " + ejemplo },
        archivoIlegible: { nombre in "nun se pue lleer el ficheru «\(nombre)»" },
        archivoConAcordes: "con --archivo nun s'escriben acordes",
        archivoSinAcordes: "el ficheru nun tien nengún acorde",
        faltaTransporte: { ejemplo in "falten l'intervalu (o la nueva tónica) y lo que se tresporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "falten los acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "el marxe ye un númberu de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "falten les notes: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta l\'acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta la escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "les clases d\'altura son númberos de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "falten les tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "el ciclu ye hexatónicu, octatónicu o LR, dende una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "el percorríu ye de tríades mayores y menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "el camín va d\'una tríada mayor o menor a otra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "el ciclu entama nuna tríada mayor o menor: " + ejemplo },

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "les voces que se mueven son 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "fai falta un acorde: " + ejemplo },
        vecinosSinFamilia: "los vecinos búsquense ente séptimes de dominante, menores, semimenguaes, menguaes y maj7, o ente tríades mayores, menores y aumentaes",
        dosAcordesDeCamino: { ejemplo in "faen falta dos acordes: " + ejemplo },
        caminoSinConexion: "los dos acordes han ser de la mesma familia (séptimes, con o ensin maj7, o tríades) y tar coneutaos",
        faltanPasosDePLR: { ejemplo in "faen falta una tríada y dellos pasos o otra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L y R aplíquense a tríades mayores y menores: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "el programa ye un númberu General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados y --analisis son pa MusicXML, MEI, LilyPond y ABC",
        faltaValor: { opcion in "falta\'l valor de --\(opcion)" },
        tempoMalEscrito: "el tempo escríbese «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "falten les notes: " + ejemplo },
        marcasSoloCoral: "--cifrados y --analisis son pa «coral»",
        duracionSoloCoral: "--duracion ye namás pa «coral»",
        claveDesconocida: { clave, claves in "clave desconocida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "falten los acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) ye namás pa «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) ye namás pa «arpegios»" },
        archivoSoloParaAcordes: "--archivo ye namás pa «acordes» y «arpegios»",
        ventanaSinArchivo: "--ventana va con --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "falten los acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "los acordes lleven siempre cifraos y análisis",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: espórtase una «melodia», un «coral», unos «acordes» o los sos «arpegios»" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta l\'instrumentu: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumentu desconocíu: «\(nombre)» (\(lista(.asturiano)))" },
        faltaLimite: "falta\'l númberu de digitaciones: --limite 5",
        limiteFueraDeRango: "la llende ye un númberu d\'1 a 200: --limite 5",
        faltanDedos: "falta\'l númberu de deos: --dedos 3",
        dedosFueraDeRango: "los deos son un númberu d\'1 a 4: --dedos 3",
        faltaTraste: "falta\'l traste más altu: --traste 12",
        trasteFueraDeRango: "el traste más altu ye un númberu de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta\'l cifráu: \(d)" },
        faltaEscalaDePosiciones: "falta la escala: armonia posiciones Sol mayor",
        capoFueraDeRango: "el capo ye un númberu de 0 a 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prueba «armonia ayuda».",
        ordenDesconocida: { orden in "orde desconocida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción desconocida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "llingua desconocida: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        terminalDesconocida: { t in "terminal desconocida: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "escritura non válida: «\(escritura)» (palabras/words, ascii o unicode; namái con es y en)" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "acordes",
        mensajeEscalas: "escales",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "baxu \(nota)" },
        mensajeBajoAjeno: "baxu ayenu al acorde",
        mensajeSinAcordes: "Nun formen nengún acorde conocíu.",
        mensajeSin: { notas in "ensin \(notas)" },
        mensajeSemitonos: { n in "\(n) semitonos" },
        mensajeSinAlteraciones: "ensin alteraciones",
        mensajeSostenidos: { n in Idioma.asturiano.contar(n, "sosteníu", "sosteníos") },
        mensajeBemoles: { n in Idioma.asturiano.contar(n, "bemol", "bemoles") },
        mensajeACuatroVoces: "A cuatro voces (baxu, tenor, contraltu, soprano):",
        mensajeSinDigitaciones: "nun hai digitaciones cómodes",
        mensajeDedos: { n in Idioma.asturiano.contar(n, "deu", "deos") },
        mensajeCejilla: { traste in "ceya nel traste \(traste)" },
        mensajeNingunPaso: "nengún pasu",
        mensajeUnPaso: "1 pasu",
        mensajePasos: { n in "\(n) pasos" },
        mensajeTriadas: { n in Idioma.asturiano.contar(n, "tríada", "tríades") }
    )
}
