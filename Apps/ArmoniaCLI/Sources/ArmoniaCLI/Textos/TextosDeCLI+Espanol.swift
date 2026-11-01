// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en español. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let espanol = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidad>]",
        descripcionAnalizar: "cifrado romano, funciones, cadencias\ny modulaciones (con su acorde\npivote; sin --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <fichero> [--ventana <duración>]",
        descripcionAnalizarArchivo: "lo mismo, con los acordes de un\nfichero MIDI o MusicXML (uno por\npulso; --ventana 2: uno por blanca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidad>] [--propuestas 3]",
        descripcionArmonizar: "acordes para una melodía, de mejor a\npeor; con octavas (Mi4), también el\ncoral a cuatro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidad>]",
        descripcionRealizar: "los acordes a cuatro voces, sin\nfaltas de conducción",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "faltas de conducción (quintas\nparalelas…); acordes de grave a\nagudo, separados por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "faltas de un contrapunto de especies\n(1 a 5) sobre un cantus firmus en\nredondas; notas sin duración: la de\nla especie",
        sintaxisTransponer: "transponer <intervalo|tónica> <acordes o notas>",
        descripcionTransponer: "lleva unos acordes, una melodía o un\ncoral a otro tono: un intervalo (2M,\n-3m) o la nueva tónica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidad>]",
        descripcionRearmonizar: "otras armonías para cada acorde:\nsustituto tritonal, dominantes\nsecundarias, préstamo modal y\nsustitutos diatónicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrado>…",
        descripcionAcorde: "notas, tipo y papel de cada nota",
        sintaxisArpegio: "arpegio <cifrado> [--patron <patrón>]",
        descripcionArpegio: "notas del arpegio y escalas del\nacorde (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unas notas",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dos notas o alturas",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notas y acordes de una escala",
        sintaxisTonalidad: "tonalidad <tonalidad>",
        descripcionTonalidad: "armadura, relativas y grados",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG de unas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "de un acorde, una escala o un\nconjunto de clases de altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un recorrido de tríadas, con flechas,\no el camino más corto por P, L y R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríada>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico o LR",
        notasTonnetzCiclo: "(--margen 2: más red alrededor)",
        sintaxisTabla: "tabla <notas o alturas>",
        descripcionTabla: "tabla armónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde <cifrado> | --escala <escala> | --clases <números>\ntabla --recorrido <tríadas> | --camino <tríada> <tríada>\ntabla --ciclo <ciclo> <tríada>",
        descripcionTablaAcorde: "(--margen 2: más tabla alrededor)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semitono (séptimas: dominante, menor, semidisminuida\ny disminuida; tríadas: mayor, menor y aumentada; un maj7, entre\nlas séptimas y los maj7; --ampliada: con los maj7 también)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "de un acorde a otro moviendo una voz\n(o dos) un semitono en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "la conducción con menos semitonos",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "transformaciones neorriemannianas",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "el camino más corto por P, L y R",
        sintaxisPlrCiclo: "plr <tríada> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L),\noctatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opciones]",
        descripcionMusicxmlMelodia: "partitura MusicXML de una melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opciones]",
        descripcionMusicxmlCoral: "coral a cuatro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifrados> [opciones]",
        descripcionMusicxmlAcordes: "progresión con cifrados y análisis",
        notasMusicxmlAcordes: "opciones: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo Mi coral,\n--duracion 2 (lo que dura cada acorde; negra en el coral y\nblanca en los acordes si no), --cifrados y --analisis (en el\ncoral: cifrado americano encima, romano y función debajo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifrados> [opciones]",
        descripcionMusicxmlArpegios: "los acordes arpegiados, nota a nota",
        notasMusicxmlArpegios: "opciones: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (lo que dura cada nota; corchea si no),\n--duracion 1 (lo que dura cada acorde: el patrón se repite\nhasta llenarlo) y las demás de «acordes»",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichero>",
        descripcionMusicxmlArchivo: "la progresión de un fichero MIDI o\nMusicXML, con lo que dura cada acorde\n(también arpegios, mei y midi)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionMeiMelodia: "lo mismo en MEI 5, el formato de las\nediciones críticas (con las mismas\nopciones)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionLilypondMelodia: "lo mismo en LilyPond, para grabar la\npartitura en PDF",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionAbcMelodia: "lo mismo en ABC, la notación en texto\nde la música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opciones]",
        descripcionMidiMelodia: "lo mismo como fichero MIDI, para oírlo\n(sin --clave ni --cifrados; con\n--programa 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrado>… [opciones]",
        descripcionDigitaciones: "formas de tocar un acorde, de la más cómoda a la menos, en un\ninstrumento de cuerda con trastes (cuerdas de grave a agudo)\nopciones: --instrumento guitarra|bajo|ukelele|mandolina|…\n(también «guitarra de siete cuerdas», «bajo de 5 cuerdas»,\n«drop D»), --limite 5, --traste 12 (el más alto que se usa),\n--dedos 4 (los que se pueden usar), --completo (con todas las notas:\npor defecto la quinta puede faltar), --diagrama (una línea por cuerda),\n--capo 2 (los trastes, desde el capo), --musicxml (la primera forma\nde cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "la escala por posiciones en la\nguitarra: tres notas por cuerda (dos\nen las pentatónicas) o CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical desde la línea de comandos.

        Uso: armonia <orden> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Órdenes:
        """,
        pieDeLaAyuda: """
        Se aceptan nombres en español o en inglés (Do, C, Sib, Bb). Con --ingles, la respuesta
        usa la notación inglesa. Con --idioma ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru, las
        notas, los nombres, los mensajes y esta ayuda salen en catalán, gallego, asturiano, aragonés,
        euskera, portugués, francés, occitano, italiano, alemán, griego o ruso.
        Con --textos, los textos van en otro idioma que las notas: --idioma en --textos es.
        En español e inglés, --escritura palabras|ascii|unicode escribe las notas como Fa sostenido,
        Fa# o Fa♯ (en inglés, F sharp, F# o F♯).
        Con --subindices, la octava va en subíndice: La₄, Fa♯₃ (se lee de las dos formas, La4 y La₄).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "esta ayuda",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "el autocompletado de las órdenes y\nopciones para la terminal",
        sintaxisManual: "manual",
        descripcionManual: "esta ayuda como página de manual",
        manualNombre: "NOMBRE",
        manualNotas: "NOTAS",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "faltan los acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "hacen falta dos acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "faltan las notas de la melodía: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va de 1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "faltan el cantus firmus y el contrapunto, separados por /: " + ejemplo },
        especieFueraDeRango: "--especie va de 1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "faltan los acordes: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "falta el cifrado: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta el cifrado: armonia arpegio Do7",
        patronDesconocido: { patron in "patrón desconocido: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado o alberti)" },
        faltanNotas: "faltan las notas: armonia identificar Do Mi Sol",
        dosNotas: "hacen falta dos notas: armonia intervalo Do Mi",
        faltaEscala: "falta la escala: armonia escala Re dórico",
        faltaTonalidad: "falta la tonalidad: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta la tonalidad tras --en",
        faltanAcordesDelAnalisis: { ejemplo in "faltan los acordes: " + ejemplo },
        archivoIlegible: { nombre in "no se puede leer el fichero «\(nombre)»" },
        archivoConAcordes: "con --archivo no se escriben acordes",
        archivoSinAcordes: "el fichero no tiene ningún acorde",
        faltaTransporte: { ejemplo in "faltan el intervalo (o la nueva tónica) y lo que se transporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "faltan los acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "el margen es un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan las notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta el acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta la escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "las clases de altura son números de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan las tríadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "el ciclo es hexatónico, octatónico o LR, desde una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "el recorrido es de tríadas mayores y menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "el camino va de una tríada mayor o menor a otra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "el ciclo empieza en una tríada mayor o menor: " + ejemplo },

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "las voces que se mueven son 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "hace falta un acorde: " + ejemplo },
        vecinosSinFamilia: "los vecinos se buscan entre séptimas de dominante, menores, semidisminuidas, disminuidas y maj7, o entre tríadas mayores, menores y aumentadas",
        dosAcordesDeCamino: { ejemplo in "hacen falta dos acordes: " + ejemplo },
        caminoSinConexion: "los dos acordes han de ser de la misma familia (séptimas, con o sin maj7, o tríadas) y estar conectados",
        faltanPasosDePLR: { ejemplo in "hacen falta una tríada y unos pasos u otra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L y R se aplican a tríadas mayores y menores: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "el programa es un número General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados y --analisis son para MusicXML, MEI, LilyPond y ABC",
        faltaValor: { opcion in "falta el valor de --\(opcion)" },
        tempoMalEscrito: "el tempo se escribe «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "faltan las notas: " + ejemplo },
        marcasSoloCoral: "--cifrados y --analisis son para «coral»",
        duracionSoloCoral: "--duracion es solo para «coral»",
        claveDesconocida: { clave, claves in "clave desconocida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "faltan los acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) es solo para «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) es solo para «arpegios»" },
        archivoSoloParaAcordes: "--archivo es solo para «acordes» y «arpegios»",
        ventanaSinArchivo: "--ventana va con --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "faltan los acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "los acordes llevan siempre cifrados y análisis",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: se exporta una «melodia», un «coral», unos «acordes» o sus «arpegios»" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta el instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento desconocido: «\(nombre)» (\(lista(.espanolCompacto)))" },
        faltaLimite: "falta el número de digitaciones: --limite 5",
        limiteFueraDeRango: "el límite es un número de 1 a 200: --limite 5",
        faltanDedos: "falta el número de dedos: --dedos 3",
        dedosFueraDeRango: "los dedos son un número de 1 a 4: --dedos 3",
        faltaTraste: "falta el traste más alto: --traste 12",
        trasteFueraDeRango: "el traste más alto es un número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta el cifrado: \(d)" },
        faltaEscalaDePosiciones: "falta la escala: armonia posiciones Sol mayor",
        capoFueraDeRango: "el capo es un número de 0 a 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prueba «armonia ayuda».",
        ordenDesconocida: { orden in "orden desconocida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción desconocida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconocido: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        terminalDesconocida: { t in "terminal desconocida: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "escritura no válida: «\(escritura)» (palabras, ascii o unicode; solo con es y en)" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeEscalas: "escalas",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "bajo \(nota)" },
        mensajeBajoAjeno: "bajo ajeno al acorde",
        mensajeSinAcordes: "No forman ningún acorde conocido.",
        mensajeSin: { notas in "sin \(notas)" },
        mensajeSemitonos: { n in "\(n) semitonos" },
        mensajeSinAlteraciones: "sin alteraciones",
        mensajeSostenidos: { n in Idioma.espanol.contar(n, "sostenido", "sostenidos") },
        mensajeBemoles: { n in Idioma.espanol.contar(n, "bemol", "bemoles") },
        mensajeACuatroVoces: "A cuatro voces (bajo, tenor, contralto, soprano):",
        mensajeSinDigitaciones: "no hay digitaciones cómodas",
        mensajeDedos: { n in Idioma.espanol.contar(n, "dedo", "dedos") },
        mensajeCejilla: { traste in "cejilla en el traste \(traste)" },
        mensajeNingunPaso: "ningún paso",
        mensajeUnPaso: "1 paso",
        mensajePasos: { n in "\(n) pasos" },
        mensajeTriadas: { n in Idioma.espanol.contar(n, "tríada", "tríadas") }
    )
}
