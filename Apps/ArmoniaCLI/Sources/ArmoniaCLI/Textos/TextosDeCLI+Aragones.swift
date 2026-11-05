// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let aragones = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidat>] [--escalas]",
        descripcionAnalizar: "cifrau romano, funcions, cadencias\ny modulacions (con o suyo acorde\npivot; sin --en)\n--escalas: a escala de cada acorde,\ncon as tensions y notas a evitar",
        notasAnalizar: "--notas-guia: dos linias de notas guía,\ndende la tercera y dende la septima",
        sintaxisAnalizarArchivo: "analizar --archivo <fichero> [--ventana <duración>]",
        descripcionAnalizarArchivo: "lo mesmo, con os acordes d'un fichero\nMIDI, MusicXML, MEI u ABC (un per\npulso; --ventana 2: un per blanca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidat>] [--propuestas 3]",
        descripcionArmonizar: "acordes ta una melodía, de millor a\npior; con octavas (Mi4), tamién o\ncoral a cuatro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidat>]",
        descripcionRealizar: "os acordes a cuatro voces, sin\nfaltas de conducción",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "faltas de conducción (quintas\nparalelas…); acordes de grave a\nagudo, separaus por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "faltas d\'un contrapunto d\'especies\n(1 a 5) sobre un cantus firmus en\nredondas; notas sin duración: a\nd\'a especie",
        sintaxisTransponer: "transponer <intervalo|tonica> <acordes u notas>",
        descripcionTransponer: "leva bels acordes, una melodía u un\ncoral a atro ton: un intervalo (2M,\n-3m) u a nueva tonica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidat>]",
        descripcionRearmonizar: "atras armonías ta cada acorde:\nsustituto tritonal, dominants\nsecundarias, emprestamiento modal y\nsustitutos diatonicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrau>…",
        descripcionAcorde: "notas, tipo y papel de cada nota",
        notasAcorde: "opcions: --disposiciones, --nombres,\n--tonalidades, --sustituciones\n(en a tonalidat de --en Do mayor, a la fin) y --comparar Do\n(notas comuns y conducción d'as voces); --bebop y --pentatonicas\n(escalas ta improvisar encima)",
        sintaxisArpegio: "arpegio <cifrau> [--patron <patrón>]",
        descripcionArpegio: "notas de l'arpechio y escalas de\nl'acorde (--patron ascendente,\ndescendente, ida-y-vuelta,\nbaja-y-sube, quebrado, alberti)",
        notasArpegio: "opcions: --octavas 2 (de 1 a 4), --sin-octava, --desde Mi\n(u 3: empecipia por ixa nota), --tensiones 9,13, --grados\n1-5-3-8 (un recorriu propio) y --aproximacion abajo, arriba\nu encierro (notas cromaticas que levan a cadaguna)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unas notas",
        notasIdentificar: "opcions: --escalas (as escalas que contienen\nas notas, en cuenta d'acordes) y --archivo\nmelodia.mid (as notas d'un fichero MIDI,\nMusicXML, MEI u ABC, con --escalas)",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dos notas u alturas",
        sintaxisEscala: "escala <escala> [--acordes]",
        descripcionEscala: "notas y acordes d\'una escala\n--acordes: toz os que caben en\ncada grau, no solo os de terceras",
        notasEscala: "opcions: --secuencia terceras (u cuartas, grupos-de-3,\ngrupos-de-4, triadas, cuatriadas), --bajando, --octavas 2\n(de 1 a 4), --piano (dixitación), --modos (paralelos y relativos)\ny --comparar Do lidio (a la fin); --simetria (cada cuánto\nse repite y os suyos acordes);\n--vecinas (as que salen de mover una\nnota) y --doce (en as dotze tonalidaz);\n--doce --acordes (os acordes de cada\ngrau; --triadas, sin septena)",
        sintaxisEscalas: "escalas [<texto>] [opcions]",
        descripcionEscalas: "o catalogo d'escalas: as habituals y\nas d'atras tradicions, por\ncategorías, con as suyas notas dende Do",
        notasEscalas: "opcions: --tradicion turquia (u india, grecia, grecia-antigua,\nmundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia,\nindonesia, klezmer, andes,\nbizancio, mesopotamia, africa,\nsudeste-asiatico, gregoriano, europa,\nvietnam, brasil) y --categoria maqam (u rāga, makam,\ndastgah, dromos…);\n--uso jazz (u clasica, blues, siglo-xx, popular, sintetica)\nfiltra as habituals; un texto busca en os nombres",
        sintaxisTradiciones: "tradiciones [<tradición>]",
        descripcionTradiciones: "as tradicions d'o catalogo, con\nas suyas categorías y cuántas\nescalas bi ha en cada una; con\nuna, as suyas escalas",
        sintaxisTonalidad: "tonalidad <tonalidat>",
        descripcionTonalidad: "armadura, relativas y grados",
        sintaxisConjunto: "conjunto <clases>",
        descripcionConjunto: "forma prima, numero de Forte,\nvectors, simetrías y notas",
        sintaxisSerie: "serie <serie>",
        descripcionSerie: "matriz, formas y combinatoriedat\nd'una serie dodecafonica",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG d\'unas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrau> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "d\'un acorde, una escala u un\nconchunto de clases d\'altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un recorrido de tríadas, con flechas,\nu o camín más curto por P, L y R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríada>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico u LR",
        notasTonnetzCiclo: "(--margen 2: más ret arredol)",
        sintaxisTabla: "tabla <notas u alturas>",
        descripcionTabla: "tabla armónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde <cifrau> | --escala <escala> | --clases <números>\ntabla --recorrido <tríadas> | --camino <tríada> <tríada>\ntabla --ciclo <ciclo> <tríada>",
        descripcionTablaAcorde: "(--margen 2: más tabla arredol)",
        sintaxisCuadricula: "cuadricula <notas u alturas> | --acorde | --escala | --clases",
        descripcionCuadricula: "teclau de cuadricula en SVG (pads),\ncon o contorno y a primera nota",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <altura>\ncuadricula --giro 0-3 --espejo --en-tono --escala <escala>",
        descripcionCuadriculaOpciones: "exes (1,5: en cuartas), rexa d'o\ncontrolador (8x8), nota d'o cantón,\nquartos de vuelta, espello y en ton",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semitono (séptimas: dominant, menor, semidisminuida\ny disminuida; tríadas: mayor, menor y aumentada; un maj7, entre\nas séptimas y os maj7; --ampliada: con os maj7 tamién)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d\'un acorde a atro movendo una voz\n(u dos) un semitono en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "a conducción con menos semitonos",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "transformacions neorriemannianas",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "o camín más curto por P, L y R",
        sintaxisPlrCiclo: "plr <tríada> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L),\noctatonico (P, R) u \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opcions]",
        descripcionMusicxmlMelodia: "partitura MusicXML d\'una melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opcions]",
        descripcionMusicxmlCoral: "coral a cuatro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifraus> [opcions]",
        descripcionMusicxmlAcordes: "progresión con cifraus y análisi",
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (u --tempo 60 4.), --titulo O mio coral,\n--duracion 2 (o que dura cada acorde; negra si no), --cifrados\ny --analisis (en o coral: cifrau americano encima, romano y\nfunción debaixo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifraus> [opcions]",
        descripcionMusicxmlArpegios: "os acordes arpechaus, nota a nota",
        notasMusicxmlArpegios: "opcions: --patron alberti (u ascendente, descendente, ida y\nvuelta), --figura 16 (o que dura cada nota; corchea si no),\n--duracion 1 (o que dura cada acorde: o patrón se repite\ndica plenar-lo) y as atras de «acordes»\n--enlazar: cada arpechio empecipia por a nota más cercana a\na zaguera de l'anterior",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichero>",
        descripcionMusicxmlArchivo: "a progresión d'un fichero MIDI,\nMusicXML, MEI u ABC, con o que dura\ncada acorde (tamién arpegios, mei y\nmidi)",
        sintaxisMusicxmlEscala: "musicxml escala <escala> [opcions]",
        descripcionMusicxmlEscala: "una escala en negras, con os suyos\nmicrotonos: o meyo bemol d'un maqam,\no koron, as comas d'un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMeiMelodia: "o mesmo en MEI 5, o formato d\'as\nedicions críticas (con as mesmas\nopcions)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionLilypondMelodia: "o mesmo en LilyPond, ta grabar a\npartitura en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionGuidoMelodia: "o mesmo en GUIDO (.gmn), ta veyer-lo\ncon GuidoLib u INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionAbcMelodia: "o mesmo en ABC, a notación en texto\nd'a mosica tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMidiMelodia: "o mesmo como fichero MIDI, ta sentir-lo\n(sin --clave ni --cifrados; con\n--programa 0…127, General MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opcions]",
        descripcionGrabar: "a partitura en PDF, SVG u PNG con\nLilyPond, MuseScore, Verovio u Guido,\nu o dibuixo con rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio,\n--formato pdf|svg|png; Verovio y Guido dan SVG,\nque rsvg-convert pasa a PDF u PNG; armonia\nmotores diz quals son instalaus",
        sintaxisMotores: "motores",
        descripcionMotores: "os motors d'armonia grabar: an ye\ncada programa y a suya versión, u a\nvariable (ARMONIA_…) que da a suya\nrota",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrau>… [opcions]",
        descripcionDigitaciones: "formas de tocar un acorde, d\'a más cómoda a la menos, en un\ninstrumento de cuerda con trastes (cuerdas de grave a agudo)\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|…\n(tamién «guitarra de siete cuerdas», «bajo de 5 cuerdas»,\n«drop D»), --limite 5, --traste 12 (o más alto que se fa servir),\n--dedos 4 (os que se pueden fer servir), --completo (con todas as notas:\nper defecto a quinta puede faltar), --diagrama (una linia per cuerda),\n--capo 2 (os trastes, dende o capo), --musicxml (a primera forma\nde cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "a escala por posicions en a guitarra:\ntres notas por corda (dos en as\npentatonicas) u CAGED",
        notasPosiciones: "opcions: --secuencia terceras (u atra:\na secuencia en cada posición; con\n--bajando, baixando) y --formas (as cinco\nformas d'a pentatonica y as notas comuns);\n--instrumento bajo (u atro;\ntamién re-abierto, sol-abierto, dadgad) y --capo 2",
        sintaxisTeclado: "teclado <escala> [--mano derecha]",
        descripcionTeclado: "a escala en un teclau de piano\n(SVG): as notas u, con --mano derecha\nu izquierda, os dedos; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "a escala en un reloch de dotze horas\n(SVG): o cerclo cromatico u, con\n--quintas, o de quintas",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "una escala, un acorde, un arpechio (con\nritmo: --figura 16, --tresillos) u unos\nacordes con o suyo cifrau en un pentagrama\n(SVG); --nombres, --intervalos,\n--semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <qué> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "os graus en numeros romanos debaixo d'os\nacordes; os didos d'o piano (--mano\nderecha) u d'a guitarra (--tab --dedos);\na escala por terceras u en grupos\n(--secuencia terceras); a tablatura\ndebaixo (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <qué> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "a octava (--octava 2), a clau (--clave\nfa), o pentagrama doble, os cambeos de\nclau seguntes o rechistro y o baixo\ncifrau d'os acordes (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <notas> --sobre <acordes>",
        descripcionPentagramaMelodia: "una melodía (Do4:8 Re4:8…) con un acorde\npor compás alto; as notas que no son\nd'o acorde, en verde (u en royo si son\ncromaticas); --ajenas lo fa en as atras",
        sintaxisPosicionesArpegio: "posiciones --arpegio <cifrau> [--caged|--barrido]",
        descripcionPosicionesArpegio: "l'arpechio d'un acorde en cada\nposición d'o mástil, en tablatura y con\nos dedos; --ida-y-vuelta, puya y baixa",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical dende a linia de comandos.

        Uso: armonia <orden> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Ordens (as ordens y as opcions s'escriben en castellano u en anglés):
        """,
        pieDeLaAyuda: """
        S'acceptan nombres de nota en castellano, aragonés, catalán, gallego, basco u anglés (Do, C,
        Sib, Bb, si bemol). Con --idioma an, a respuesta fa servir a notación aragonesa y os mensaches
        en aragonés; con --ingles, en anglés.
        Con --textos, os textos van en atro idioma que as notas: --idioma en --textos an.
        En castellano y anglés, --escritura palabras|ascii|unicode escribe as notas como Fa sostenido,
        Fa# u Fa♯ (en anglés, F sharp, F# u F♯).
        En os atros idiomas, --escritura palabras|compacto tría as parolas u a forma compacta:
        fa dièse u Fa♯, F Kreuz u Fis.
        En as escrituras compactas a octava va en subíndiz (La₄) y en as atras, con cifras (La4);
        --subindices u --cifras la fixan (se leyen as dos trazas).
        Con --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones y tradiciones dan os suyos datos en JSON.
        Con --json tamién armonizar, realizar, revisar, contrapunto y transponer. Si a salida no ye
        a terminal, o JSON va en una sola linia.
        ARMONIA_IDIOMA=eu fixa a luenga sin --idioma; con ARMONIA_IDIOMA=sistema, a de LANG.
        Codigos de salida: 0 bien, 1 texto que no se leye, 2 orden mal escrita y 3 faltas (revisar,
        contrapunto).
        Sin argumentos y en a terminal, armonia ubre una sesión: una orden per linia.
        Con a dentrada en un fichero (armonia < exercicios.txt), executa as suyas linias igual; una linia
        nomás con opcions (--idioma eu) las deixa puestas ta las siguients.
        """,
        sintaxisAyuda: "ayuda [<orden>]",
        descripcionAyuda: "esta aduya, u a d'una orden\n(tamién <orden> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "l'autocompletau d'as ordens y\nopcions ta la terminal",
        sintaxisManual: "manual",
        descripcionManual: "ista aduya como pachina de manual",
        manualNombre: "NOMBRE",
        manualNotas: "NOTAS",
        manualEntorno: "ENTORNO",
        manualEstadoDeSalida: "ESTAU DE SALIDA",
        manualIdiomaDelEntorno: "A luenga, como --idioma (que la anula): es, en, eu…; con sistema, a de LC_ALL, LC_MESSAGES u LANG.",
        manualRutaDelPrograma: { p in "A rota de \(p), si no ye en o PATH." },
        manualCodigosDeSalida: ["Tot ha iu bien.", "Un texto u un fichero que no se puede leyer, u cosa que dar.", "L'orden ye mal escrita.", "revisar u contrapunto han trobau faltas."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "faltan os acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "fan falta dos acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "faltan as notas d\'a melodía: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d\'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "faltan o cantus firmus y o contrapunto, deseparaus por /: " + ejemplo },
        especieFueraDeRango: "--especie va d\'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "falta o cifrau: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta o cifrau: armonia arpegio Do7",
        patronDesconocido: { patron in "patrón desconoixiu: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado u alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: no ye una tradición (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: no ye una categoría d'escalas (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: no ye un uso d'escalas (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        faltanNotas: "faltan as notas: armonia identificar Do Mi Sol",
        dosNotas: "fan falta dos notas: armonia intervalo Do Mi",
        faltaEscala: "falta a escala: armonia escala Re dórico",
        faltaTonalidad: "falta a tonalidat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta a tonalidat dimpués de --en",
        faltaConjunto: "falta lo conchunto: armonia conjunto 0 4 7",
        faltaSerie: "falta a serie: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "faltan os acordes: " + ejemplo },
        archivoIlegible: { nombre in "no se puede leyer o fichero «\(nombre)»" },
        archivoConAcordes: "con --archivo no s'escriben acordes",
        archivoSinAcordes: "o fichero no tiene garra acorde",
        faltaTransporte: { ejemplo in "faltan l'intervalo (u a nueva tonica) y o que se transposa: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "o marguin ye un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan as notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta l\'acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta a escala: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "faltan as clases d'altura: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan as tríadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "o ciclo ye hexatónico, octatónico u LR, dende una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "o recorrido ye de tríadas mayors y menors: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "o camín va d\'una tríada mayor u menor a unatra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "o ciclo empecipia en una tríada mayor u menor: " + ejemplo },
        opcionesDeCuadricula: "opcions d'a cuadricula: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <altura> (Do2), --giro 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "as voces que se mueven son 1 u 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "fa falta un acorde: " + ejemplo },
        vecinosSinFamilia: "os vecinos se buscan entre séptimas de dominant, menors, semidisminuidas, disminuidas y maj7, u entre tríadas mayors, menors y aumentadas",
        dosAcordesDeCamino: { ejemplo in "fan falta dos acordes: " + ejemplo },
        caminoSinConexion: "os dos acordes han de estar d\'a mesma familia (séptimas, con u sin maj7, u tríadas) y estar connectaus",
        faltanPasosDePLR: { ejemplo in "fan falta una tríada y bels pasos u atra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L y R s\'aplican a tríadas mayors y menors: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» u «acordes»: " + ejemplo },
        instrumentoMIDI: "o programa ye un número General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados y --analisis son ta MusicXML, MEI, LilyPond, GUIDO y ABC",
        faltaValor: { opcion in "falta o valor de --\(opcion)" },
        tempoMalEscrito: "o tempo s\'escribe «--tempo 90» u «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "faltan as notas: " + ejemplo },
        marcasSoloCoral: "--cifrados y --analisis son ta «coral»",
        duracionSoloCoral: "--duracion ye nomás ta «coral»",
        claveDesconocida: { clave, claves in "clau desconoixida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) ye nomás ta «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) ye nomás ta «arpegios»" },
        archivoSoloParaAcordes: "--archivo ye nomás ta «acordes» y «arpegios»",
        ventanaSinArchivo: "--ventana va con --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "os acordes leban siempre cifraus y análisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s\'exporta una «melodia», un «coral», bels «acordes», os suyos «arpegios» u una «escala»" },
        faltaLoQueSeGraba: "falta o que se graba: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: os motors son lilypond, musescore, verovio, guido y propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: se graba en «pdf», «svg» u «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: se graba una partitura (melodia, coral, acordes, arpegios, escala) u un dibuixo (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "no se troba «\(programa)»: instala-lo u mete a suya rota en \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» ha rematau con o codigo \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» no ha rematau a tiempo y s\'ha aturau" },
        motorNoInstalado: { variable in "no instalau (u pon a suya rota en \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta o instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento desconoixiu: «\(nombre)» (\(lista(.aragonesPalabras)))" },
        faltaLimite: "falta o número de digitacions: --limite 5",
        limiteFueraDeRango: "o límite ye un número d\'1 a 200: --limite 5",
        faltanDedos: "falta o número de didos: --dedos 3",
        dedosFueraDeRango: "os didos son un número d\'1 a 4: --dedos 3",
        faltaTraste: "falta o traste más alto: --traste 12",
        trasteFueraDeRango: "o traste más alto ye un número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta o cifrau: \(d)" },
        faltaEscalaDePosiciones: "falta a escala: armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "falta a escala: armonia teclado Re mayor",
        manoDesconocida: { texto in "man desconoixida: «\(texto)» (derecha u izquierda)" },
        archivoConNotas: "con --archivo no s'escriben notas",
        noEsPentatonica: "as formas son d'una escala de cinco notas: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "falta a escala: armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "falta qué dibuixar: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "o capo ye un numero de 0 a 12: --capo 2",
        octavasFueraDeRango: "as octavas son un numero de 1 a 4: --octavas 2",
        octavaFueraDeRango: "a octava ye un numero de 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» no ye una nota ni un grau de l'acorde: --desde Mi u --desde 3" },
        tensionesMalEscritas: "as tensions son 9, 11 u 13: --tensiones 9,13",
        gradosMalEscritos: "os graus son numeros de 1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "aproximación desconoixida: «\(aproximacion)» (abajo, arriba u encierro)" },
        secuenciaDesconocida: { secuencia in "secuencia desconoixida: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas u cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Preba «armonia ayuda».",
        ordenDesconocida: { orden in "orden desconoixida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción desconoixida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconoixiu: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)" },
        terminalDesconocida: { t in "terminal desconoixida: «\(t)» (bash, zsh u fish)" },
        escrituraNoValida: { escritura in "escritura no valida: «\(escritura)» (palabras/words u compacto/compact; ascii u unicode, nomás con es y en)" },
        sinSalidaJSON: { orden in "«\(orden)» no da salida en JSON" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeMicrotonos: "microtonos",
        mensajeEscalas: "escalas",
        mensajeHabituales: "habituals",
        mensajeNingunaEscala: "no bi ha garra escala asinas",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "baixo \(nota)" },
        mensajeBajoAjeno: "baixo difuera de l\'acorde",
        mensajeSinAcordes: "No forman garra acorde conoixiu.",
        mensajeSin: { notas in "sin \(notas)" },
        mensajeSemitonos: { n in "\(n) semitonos" },
        mensajeSinAlteraciones: "sin alteracions",
        mensajeSostenidos: { n in Idioma.aragones.contar(n, "sosteniu", "sostenius") },
        mensajeBemoles: { n in Idioma.aragones.contar(n, "bemol", "bemols") },
        mensajeACuatroVoces: "A cuatro voces (baixo, tenor, contralto, soprano):",
        mensajeSinDigitaciones: "no bi ha digitacions cómodas",
        mensajeDedos: { n in Idioma.aragones.contar(n, "dido", "didos") },
        mensajeCejilla: { traste in "ceja en o traste \(traste)" },
        mensajeNingunPaso: "garra paso",
        mensajeUnPaso: "1 paso",
        mensajePasos: { n in "\(n) pasos" },
        mensajeTriadas: { n in Idioma.aragones.contar(n, "tríada", "tríadas") },
        mensajeFormaNormal: "forma normal",
        mensajeFormaPrima: "forma prima",
        mensajeVectorIntervalico: "vector intervalico",
        mensajeVectorDeIndice: "vector d'indiz",
        mensajeEjesDeSimetria: "exes de simetría",
        mensajeIntervalos: "intervalos",
        mensajeDeTodosLosIntervalos: "de totz os intervalos",
        mensajeFormasDistintas: { n in "\(n) formas diferents" },
        mensajeHexacordos: "hexacordos",
        mensajeFormasCombinatorias: "formas combinatorias",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "a versión d'armonia",
        quisoDecir: { x in "¿Querebas dicir «\(x)»?" },
        pruebaLaAyudaDe: { o in "Preba «armonia ayuda \(o)»." },
        salidaBinaria: "a salida ye un fichero binario (MIDI, PDF u PNG); alza-la con > fichero",
        escalasPorNotas: { e in "no bi ha garra escala con ixe nombre; ta buscar-la por as suyas notas: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» ya escribe a partitura; «grabar» la da en PDF, SVG u PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultas", "Harmonía y voces", "Partituras y grabau", "Dibuixos (SVG)", "Neorriemanniana", "Instrumentos de trastes", "A terminal y l'aduya"],
        pieDelIndice: """
        L'aduya d'una orden: armonia ayuda <orden> (u armonia <orden> --help).
        Toda l'aduya, con as opcions de cada orden: armonia ayuda --todo.
        Ta todas as ordens: --ingles, --idioma, --textos, --escritura, --subindices, --cifras y --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Escribe una orden per linia, sin «armonia» (ayuda: as ordens; salir: rematar)." }
    )
}
