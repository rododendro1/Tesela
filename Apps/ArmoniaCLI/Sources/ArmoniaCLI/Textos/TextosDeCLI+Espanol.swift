// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en español. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let espanol = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidad>] [--escalas]",
        descripcionAnalizar: "cifrado romano, funciones, cadencias y modulaciones (con su acorde pivote; sin --en)\n--escalas: la escala de cada acorde, con sus tensiones y notas a evitar",
        notasAnalizar: "--notas-guia: dos líneas de notas guía, desde la tercera y desde la séptima",
        sintaxisAnalizarArchivo: "analizar --archivo <fichero> [--ventana <duración>]",
        descripcionAnalizarArchivo: "lo mismo, con los acordes de un fichero MIDI, MusicXML, MEI o ABC (uno por pulso; --ventana 2: uno por blanca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidad>] [--propuestas 3]",
        descripcionArmonizar: "acordes para una melodía, de mejor a peor; con octavas (Mi4), también el coral a cuatro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidad>]",
        descripcionRealizar: "los acordes a cuatro voces, sin faltas de conducción",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "faltas de conducción (quintas paralelas…); acordes de grave a agudo, separados por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "faltas de un contrapunto de especies (1 a 5) sobre un cantus firmus en redondas; notas sin duración: la de la especie",
        sintaxisTransponer: "transponer <intervalo|tónica> <acordes o notas>",
        descripcionTransponer: "lleva unos acordes, una melodía o un coral a otro tono: un intervalo (2M, -3m) o la nueva tónica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidad>]",
        descripcionRearmonizar: "otras armonías para cada acorde: sustituto tritonal, dominantes secundarias, préstamo modal y sustitutos diatónicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrado>…",
        descripcionAcorde: "notas, tipo y papel de cada nota",
        notasAcorde: "opciones: --disposiciones, --nombres, --tonalidades, --sustituciones (en la tonalidad de --en Do mayor, al final) y --comparar Do (notas comunes y conducción de las voces); --bebop y --pentatonicas (escalas para improvisar encima)",
        sintaxisArpegio: "arpegio <cifrado> [--patron <patrón>]",
        descripcionArpegio: "notas del arpegio y escalas del acorde (--patron ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado, alberti)",
        notasArpegio: "opciones: --octavas 2 (de 1 a 4), --sin-octava, --desde Mi (o 3: empieza por esa nota), --tensiones 9,13, --grados 1-5-3-8 (un recorrido propio) y --aproximacion abajo, arriba o encierro (notas cromáticas que llevan a cada una)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unas notas",
        notasIdentificar: "opciones: --escalas (las escalas que contienen las notas, en vez de acordes) y --archivo melodia.mid (las notas de un fichero MIDI, MusicXML, MEI o ABC, con --escalas)",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dos notas o alturas",
        sintaxisEscala: "escala <escala> [--acordes]",
        descripcionEscala: "notas y acordes de una escala\n--acordes: todos los que caben en cada grado, no solo los de terceras",
        notasEscala: "opciones: --secuencia terceras (o cuartas, grupos-de-3, grupos-de-4, triadas, cuatriadas), --bajando, --octavas 2 (de 1 a 4), --piano (digitación), --modos (paralelos y relativos) y --comparar Do lidio (al final); --simetria (cada cuánto se repite y sus acordes); --vecinas (las que salen de mover una nota) y --doce (en las doce tonalidades); --doce --acordes (los acordes de cada grado; --triadas, sin séptima); --estadisticas (número de notas, brillo, vector interválico…); --escalera (de la más oscura a la más brillante, subiendo una nota cada vez)",
        sintaxisEscalas: "escalas [<texto>] [opciones]",
        descripcionEscalas: "el catálogo de escalas: las habituales y las de otras tradiciones, por categorías, con sus notas desde Do",
        notasEscalas: "opciones: --tradicion turquia (o india, grecia, grecia-antigua, mundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia, africa, sudeste-asiatico, gregoriano, europa, vietnam, brasil) y --categoria maqam (o rāga, makam, dastgah, dromos…); --uso jazz (o clasica, blues, siglo-xx, popular, sintetica) filtra las habituales; --notas 5 deja solo las de cinco notas; --orden brillo (o notas) las ordena, y --sin-semitonos y --regulares dejan las anhemitónicas y las máximamente regulares; un texto busca en los nombres",
        sintaxisTradiciones: "tradiciones [<tradición>]",
        descripcionTradiciones: "las tradiciones del catálogo, con sus categorías y cuántas escalas hay en cada una; con una, sus escalas",
        sintaxisTonalidad: "tonalidad <tonalidad>",
        descripcionTonalidad: "armadura, relativas y grados",
        sintaxisConjunto: "conjunto <clases>",
        descripcionConjunto: "forma prima, número de Forte, vectores, simetrías y notas",
        sintaxisSerie: "serie <serie>",
        descripcionSerie: "matriz, formas y combinatoriedad de una serie dodecafónica",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG de unas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "de un acorde, una escala o un conjunto de clases de altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un recorrido de tríadas, con flechas, o el camino más corto por P, L y R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríada>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico o LR",
        notasTonnetzCiclo: "(--margen 2: más red alrededor)",
        sintaxisTabla: "tabla <notas o alturas>",
        descripcionTabla: "tabla armónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde <cifrado> | --escala <escala> | --clases <números>\ntabla --recorrido <tríadas> | --camino <tríada> <tríada>\ntabla --ciclo <ciclo> <tríada>",
        descripcionTablaAcorde: "(--margen 2: más tabla alrededor)",
        sintaxisCuadricula: "cuadricula <notas o alturas> | --acorde | --escala | --clases",
        descripcionCuadricula: "teclado de cuadrícula en SVG (pads), con el contorno y la primera nota",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <altura>\ncuadricula --giro 0-3 --espejo --en-tono --escala <escala>",
        descripcionCuadriculaOpciones: "ejes (1,5: en cuartas), rejilla del controlador (8x8), nota de la esquina, cuartos de vuelta, espejo y en tono",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semitono (séptimas: dominante, menor, semidisminuida y disminuida; tríadas: mayor, menor y aumentada; un maj7, entre las séptimas y los maj7; --ampliada: con los maj7 también)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "de un acorde a otro moviendo una voz (o dos) un semitono en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "la conducción con menos semitonos",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "transformaciones neorriemannianas",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "el camino más corto por P, L y R",
        sintaxisPlrCiclo: "plr <tríada> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L), octatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opciones]",
        descripcionMusicxmlMelodia: "partitura MusicXML de una melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opciones]",
        descripcionMusicxmlCoral: "coral a cuatro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifrados> [opciones]",
        descripcionMusicxmlAcordes: "progresión con cifrados y análisis",
        notasMusicxmlAcordes: "opciones: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor, --clave fa, --tempo 90 (o --tempo 60 4.), --titulo Mi coral, --duracion 2 (lo que dura cada acorde; negra si no), --cifrados y --analisis (en el coral: cifrado americano encima, romano y función debajo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifrados> [opciones]",
        descripcionMusicxmlArpegios: "los acordes arpegiados, nota a nota",
        notasMusicxmlArpegios: "opciones: --patron alberti (o ascendente, descendente, ida y vuelta), --figura 16 (lo que dura cada nota; corchea si no), --duracion 1 (lo que dura cada acorde: el patrón se repite hasta llenarlo) y las demás de «acordes»\n--enlazar: cada arpegio empieza por la nota más cercana a la última del anterior",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichero>",
        descripcionMusicxmlArchivo: "la progresión de un fichero MIDI, MusicXML, MEI o ABC, con lo que dura cada acorde (también arpegios, mei y midi)",
        sintaxisMusicxmlEscala: "musicxml escala <escala> [opciones]",
        descripcionMusicxmlEscala: "una escala en negras, con sus microtonos: el medio bemol de un maqam, el koron, las comas de un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opciones]",
        descripcionMeiMelodia: "lo mismo en MEI 5, el formato de las ediciones críticas (con las mismas opciones)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opciones]",
        descripcionLilypondMelodia: "lo mismo en LilyPond, para grabar la partitura en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opciones]",
        descripcionGuidoMelodia: "lo mismo en GUIDO (.gmn), para verlo con GuidoLib o INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opciones]",
        descripcionAbcMelodia: "lo mismo en ABC, la notación en texto de la música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opciones]",
        descripcionMidiMelodia: "lo mismo como fichero MIDI, para oírlo (sin --clave ni --cifrados; con --programa 0…127, General MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opciones]",
        descripcionGrabar: "la partitura en PDF, SVG o PNG con LilyPond, MuseScore, Verovio o Guido, o el dibujo con rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio, --formato pdf|svg|png; Verovio y Guido dan SVG, que rsvg-convert pasa a PDF o PNG; armonia motores dice cuáles están instalados",
        sintaxisMotores: "motores",
        descripcionMotores: "los motores de armonia grabar: dónde está cada programa y su versión, o la variable (ARMONIA_…) que da su ruta",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrado>… [opciones]",
        descripcionDigitaciones: "formas de tocar un acorde, de la más cómoda a la menos, en un instrumento de cuerda con trastes (cuerdas de grave a agudo)\nopciones: --instrumento guitarra|bajo|ukelele|mandolina|… (también «guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»), --limite 5, --traste 12 (el más alto que se usa), --dedos 4 (los que se pueden usar), --completo (con todas las notas: por defecto la quinta puede faltar), --diagrama (una línea por cuerda), --capo 2 (los trastes, desde el capo), --musicxml (la primera forma de cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "la escala por posiciones en la guitarra: tres notas por cuerda (dos en las pentatónicas) o CAGED",
        notasPosiciones: "opciones: --secuencia terceras (u otra: la secuencia en cada posición; con --bajando, bajando) y --formas (las cinco formas de la pentatónica y sus notas comunes); --instrumento bajo (u otro; también re-abierto, sol-abierto, dadgad) y --capo 2",
        sintaxisTeclado: "teclado <escala> [--mano derecha]",
        descripcionTeclado: "la escala en un teclado de piano (SVG): sus notas o, con --mano derecha o izquierda, los dedos; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "la escala en un reloj de doce horas (SVG): el círculo cromático o, con --quintas, el de quintas",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "una escala, un acorde, un arpegio (con ritmo: --figura 16, --tresillos) o unos acordes con su cifrado en un pentagrama (SVG); --nombres, --intervalos, --semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <qué> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "los grados en números romanos debajo de los acordes; los dedos del piano (--mano derecha) o de la guitarra (--tab --dedos); la escala por terceras o en grupos (--secuencia terceras); la tablatura debajo (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <qué> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "la octava (--octava 2), la clave (--clave fa), el pentagrama doble, los cambios de clave según el registro y el bajo cifrado de los acordes (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <notas> --sobre <acordes>",
        descripcionPentagramaMelodia: "una melodía (Do4:8 Re4:8…) con un acorde por compás encima; las notas que no son del acorde, en verde (o en rojo si son cromáticas); --ajenas lo hace en las demás",
        sintaxisPosicionesArpegio: "posiciones --arpegio <cifrado> [--caged|--barrido]",
        descripcionPosicionesArpegio: "el arpegio de un acorde en cada posición del mástil, en tablatura y con los dedos; --ida-y-vuelta, sube y baja",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical desde la línea de comandos.

        Uso: armonia <orden> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Órdenes:
        """,
        pieDeLaAyuda: """
        Se aceptan nombres en español o en inglés (Do, C, Sib, Bb). Con --ingles, la respuesta
        usa la notación inglesa. Con --idioma ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu,
        las notas, los nombres, los mensajes y esta ayuda salen en catalán, gallego, asturiano,
        aragonés, euskera, portugués, francés, occitano, italiano, alemán, griego, ruso o húngaro.
        Con --textos, los textos van en otro idioma que las notas: --idioma en --textos es.
        En español e inglés, --escritura palabras|ascii|unicode escribe las notas como Fa sostenido,
        Fa# o Fa♯ (en inglés, F sharp, F# o F♯).
        En los demás idiomas, --escritura palabras|compacto elige las palabras o la forma compacta:
        fa dièse o Fa♯, F Kreuz o Fis.
        En las escrituras compactas la octava va en subíndice (La₄) y en las demás, con cifras (La4);
        --subindices o --cifras la fijan (se leen las dos formas).
        Con --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones y tradiciones dan sus datos en JSON.
        Con --json también armonizar, realizar, revisar, contrapunto y transponer. Si la salida no es
        la terminal, el JSON va en una sola línea.
        ARMONIA_IDIOMA=eu fija el idioma sin --idioma; con ARMONIA_IDIOMA=sistema, el de LANG.
        Códigos de salida: 0 bien, 1 texto que no se lee, 2 orden mal escrita y 3 faltas (revisar,
        contrapunto).
        Sin argumentos y en la terminal, armonia abre una sesión: una orden por línea.
        Con la entrada en un fichero (armonia < ejercicios.txt), ejecuta sus líneas igual; una línea
        con solo opciones (--idioma eu) las deja puestas para las siguientes.
        Con -o fichero, lo que da la orden se escribe en ese fichero, también en la sesión.
        Con --idioma, las notas se leen también en ese idioma: H7 y Fis en alemán, ré en francés.
        """,
        sintaxisAyuda: "ayuda [<orden>]",
        descripcionAyuda: "esta ayuda, o la de una orden (también <orden> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "el autocompletado de las órdenes y opciones para la terminal",
        sintaxisManual: "manual",
        descripcionManual: "esta ayuda como página de manual",
        manualNombre: "NOMBRE",
        manualNotas: "NOTAS",
        manualEntorno: "ENTORNO",
        manualEstadoDeSalida: "ESTADO DE SALIDA",
        manualIdiomaDelEntorno: "El idioma, como --idioma (que la anula): es, en, eu…; con sistema, el de LC_ALL, LC_MESSAGES o LANG.",
        manualRutaDelPrograma: { p in "La ruta de \(p), si no está en el PATH." },
        manualCodigosDeSalida: ["Todo ha ido bien.", "Un texto o un fichero que no se puede leer, o nada que dar.", "La orden está mal escrita.", "revisar o contrapunto han encontrado faltas."],

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
        tradicionDesconocida: { tradicion in "«\(tradicion)»: no es una tradición (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: no es una categoría de escalas (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: no es un uso de escalas (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        ordenDeEscalasDesconocido: { orden in "«\(orden)»: las escalas se ordenan por brillo o por notas: --orden brillo" },
        faltanNotas: "faltan las notas: armonia identificar Do Mi Sol",
        dosNotas: "hacen falta dos notas: armonia intervalo Do Mi",
        faltaEscala: "falta la escala: armonia escala Re dórico",
        faltaTonalidad: "falta la tonalidad: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta la tonalidad tras --en",
        faltaConjunto: "falta el conjunto: armonia conjunto 0 4 7",
        faltaSerie: "falta la serie: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "faltan los acordes: " + ejemplo },
        archivoIlegible: { nombre in "no se puede leer el fichero «\(nombre)»" },
        archivoNoEscrito: { nombre in "no se puede escribir el fichero «\(nombre)»" },
        archivoConAcordes: "con --archivo no se escriben acordes",
        archivoSinAcordes: "el fichero no tiene ningún acorde",
        faltaTransporte: { ejemplo in "faltan el intervalo (o la nueva tónica) y lo que se transporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "faltan los acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "el margen es un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan las notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta el acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta la escala: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "faltan las clases de altura: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan las tríadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "el ciclo es hexatónico, octatónico o LR, desde una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "el recorrido es de tríadas mayores y menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "el camino va de una tríada mayor o menor a otra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "el ciclo empieza en una tríada mayor o menor: " + ejemplo },
        opcionesDeCuadricula: "opciones de la cuadrícula: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <altura> (Do2), --giro 0-3",

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
        marcasSoloMusicXML: "--cifrados y --analisis son para MusicXML, MEI, LilyPond, GUIDO y ABC",
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
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: se exporta una «melodia», un «coral», unos «acordes», sus «arpegios» o una «escala»" },
        faltaLoQueSeGraba: "falta lo que se graba: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: los motores son lilypond, musescore, verovio, guido y propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: se graba en «pdf», «svg» o «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: se graba una partitura (melodia, coral, acordes, arpegios, escala) o un dibujo (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "no se encuentra «\(programa)»: instálalo o pon su ruta en \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» terminó con el código \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» no terminó a tiempo y se ha parado" },
        motorNoInstalado: { variable in "no instalado (o pon su ruta en \(variable))" },
        motorPropio: "propio",

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
        faltaEscalaDelTeclado: "falta la escala: armonia teclado Re mayor",
        manoDesconocida: { texto in "mano desconocida: «\(texto)» (derecha o izquierda)" },
        archivoConNotas: "con --archivo no se escriben notas",
        noEsPentatonica: "las formas son de una escala de cinco notas: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "falta la escala: armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "falta qué dibujar: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "el capo es un número de 0 a 12: --capo 2",
        octavasFueraDeRango: "las octavas son un número de 1 a 4: --octavas 2",
        notasFueraDeRango: "las notas son un número de 1 a 24: --notas 5",
        octavaFueraDeRango: "la octava es un número de 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» no es una nota ni un grado del acorde: --desde Mi o --desde 3" },
        tensionesMalEscritas: "las tensiones son 9, 11 o 13: --tensiones 9,13",
        gradosMalEscritos: "los grados son números de 1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "aproximación desconocida: «\(aproximacion)» (abajo, arriba o encierro)" },
        secuenciaDesconocida: { secuencia in "secuencia desconocida: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas o cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prueba «armonia ayuda».",
        ordenDesconocida: { orden in "orden desconocida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción desconocida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconocido: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)" },
        terminalDesconocida: { t in "terminal desconocida: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "escritura no válida: «\(escritura)» (palabras o compacto; ascii o unicode, solo con es y en)" },
        sinSalidaJSON: { orden in "«\(orden)» no da salida en JSON" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeMicrotonos: "microtonos",
        mensajeEscalas: "escalas",
        mensajeHabituales: "habituales",
        mensajeNingunaEscala: "no hay ninguna escala así",
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
        mensajeTriadas: { n in Idioma.espanol.contar(n, "tríada", "tríadas") },
        mensajeFormaNormal: "forma normal",
        mensajeFormaPrima: "forma prima",
        mensajeVectorIntervalico: "vector interválico",
        mensajeVectorDeIndice: "vector de índice",
        mensajeEjesDeSimetria: "ejes de simetría",
        mensajeIntervalos: "intervalos",
        mensajeDeTodosLosIntervalos: "de todos los intervalos",
        mensajeFormasDistintas: { n in "\(n) formas distintas" },
        mensajeHexacordos: "hexacordos",
        mensajeFormasCombinatorias: "formas combinatorias",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "la versión de armonia",
        quisoDecir: { x in "¿Querías decir «\(x)»?" },
        pruebaLaAyudaDe: { o in "Prueba «armonia ayuda \(o)»." },
        salidaBinaria: "la salida es un fichero binario (MIDI, PDF o PNG); guárdala con > fichero",
        escalasPorNotas: { e in "no hay ninguna escala con ese nombre; para buscarla por sus notas: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» ya escribe la partitura; «grabar» la da en PDF, SVG o PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultas", "Armonía y voces", "Partituras y grabado", "Dibujos (SVG)", "Neorriemanniana", "Instrumentos de trastes", "La terminal y la ayuda"],
        pieDelIndice: """
        La ayuda de una orden: armonia ayuda <orden> (o armonia <orden> --help).
        Toda la ayuda, con las opciones de cada orden: armonia ayuda --todo.
        Para todas las órdenes: --ingles, --idioma, --textos, --escritura, --subindices, --cifras y --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Escribe una orden por línea, sin «armonia» (ayuda: las órdenes; salir: terminar)." }
    )
}
