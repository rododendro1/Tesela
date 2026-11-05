// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en occitano. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let occitano = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acòrds> [--en <tonalitat>] [--escalas]",
        descripcionAnalizar: "chifratge roman, foncions, cadéncias e modulacions (amb lor acòrd pivòt; sens --en)\n--escalas: la gama de cada acòrd, amb las tensions e nòtas d'evitar",
        notasAnalizar: "--notas-guia: doas linhas de nòtas guidas, dempuèi la tèrça e dempuèi la setena",
        sintaxisAnalizarArchivo: "analizar --archivo <fichièr> [--ventana <durada>]",
        descripcionAnalizarArchivo: "lo meteis, amb los acòrds d'un fichièr MIDI, MusicXML, MEI o ABC (un per temps ; --ventana 2 : un per blanca)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalitat>] [--propuestas 3]",
        descripcionArmonizar: "acòrds per una melodia, del melhor al pièger; amb octavas (Mi4), tanben lo coral a quatre voses",
        sintaxisRealizar: "realizar <acòrds> [--en <tonalitat>]",
        descripcionRealizar: "los acòrds a quatre voses, sens fautas de conducha",
        sintaxisRevisar: "revisar <acòrds>",
        descripcionRevisar: "fautas de conducha (quintas parallèlas…); acòrds del grèu a l'agut, separats per de virgulas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunt> [--especie 1]",
        descripcionContrapunto: "fautas d'un contrapunt d'espècias (1 a 5) sus un cantus firmus en redondas; nòtas sens durada: la de l'espècia",
        sintaxisTransponer: "transponer <interval|tonica> <acòrds o nòtas>",
        descripcionTransponer: "mena d'acòrds, una melodia o un coral a un autre ton: un interval (2M, -3m) o la tonica novèla (Re)",
        sintaxisRearmonizar: "rearmonizar <acòrds> [--en <tonalitat>]",
        descripcionRearmonizar: "autras armonias per cada acòrd: substitut de triton, dominantas segondàrias, manlèu modal e substituts diatonics",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <chifratge>…",
        descripcionAcorde: "nòtas, tipe e ròtle de cada nòta",
        notasAcorde: "opcions: --disposiciones, --nombres, --tonalidades, --sustituciones (dins la tonalitat de --en Do mayor, a la fin) e --comparar Do (nòtas comunas e conducha de las vòtz); --bebop e --pentatonicas (gamas per improvisar dessús)",
        sintaxisArpegio: "arpegio <chifratge> [--patron <motiu>]",
        descripcionArpegio: "nòtas de l'arpegi e gamas de l'acòrd (--patron ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado, alberti)",
        notasArpegio: "opcions: --octavas 2 (d'1 a 4), --sin-octava, --desde Mi (o 3: comença per aquela nòta), --tensiones 9,13, --grados 1-5-3-8 (un percors pròpri) e --aproximacion abajo, arriba o encierro (nòtas cromaticas que mènan a caduna)",
        sintaxisIdentificar: "identificar <nòtas>",
        descripcionIdentificar: "acòrds que fan unas nòtas",
        notasIdentificar: "opcions: --escalas (las gamas que contenon las nòtas, en plaça d'acòrdis) e --archivo melodia.mid (las nòtas d'un fichièr MIDI, MusicXML, MEI o ABC, amb --escalas)",
        sintaxisIntervalo: "intervalo <nòta> <nòta>",
        descripcionIntervalo: "interval entre doas nòtas o nautors",
        sintaxisEscala: "escala <gama> [--acordes]",
        descripcionEscala: "nòtas e acòrds d'una gama\n--acordes: totes los que i caben sus cada gra, pas sonque los de tèrças",
        notasEscala: "opcions: --secuencia terceras (o cuartas, grupos-de-3, grupos-de-4, triadas, cuatriadas), --bajando, --octavas 2 (de 1 a 4), --piano (digitacion), --modos (parallèls e relatius) e --comparar Do lidio (a la fin); --simetria (cada quant se repetís e sos acòrdis); --vecinas (las que sortisson en desplaçant una nòta) e --doce (dins las dotze tonalitats); --doce --acordes (los acòrdis de cada grad; --triadas, sens setena); --estadisticas (nombre de nòtas, brilhança, vector d’intervals…); --escalera (de la mai escura a la mai brilhanta, en montant una nòta cada còp)",
        sintaxisEscalas: "escalas [<tèxte>] [opcions]",
        descripcionEscalas: "lo catalòg de las gamas: las abitualas e las d'autras tradicions, per categorias, amb lors nòtas dempuèi Do",
        notasEscalas: "opcions: --tradicion turquia (o india, grecia, grecia-antigua, mundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia, africa, sudeste-asiatico, gregoriano, europa, vietnam, brasil) e --categoria maqam (o rāga, makam, dastgah, dromos…); --uso jazz (o clasica, blues, siglo-xx, popular, sintetica) filtra las abitualas; --notas 5 garda sonque las de cinc nòtas; --orden brillo (o notas) las ordena, e --sin-semitonos e --regulares gardan las anemitonicas e las maximalament regularas; un tèxte cerca dins los noms",
        sintaxisTradiciones: "tradiciones [<tradicion>]",
        descripcionTradiciones: "las tradicions del catalòg, amb lors categorias e quantas gamas i a dins caduna; amb una, sas gamas",
        sintaxisTonalidad: "tonalidad <tonalitat>",
        descripcionTonalidad: "armadura, relativas e grases",
        sintaxisConjunto: "conjunto <classas>",
        descripcionConjunto: "forma prima, numèro de Forte, vectors, simetrias e nòtas",
        sintaxisSerie: "serie <seria>",
        descripcionSerie: "matritz, formas e combinatòria d'una seria dodecafonica",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <nòtas>",
        descripcionTonnetz: "Tonnetz en SVG d'unas nòtas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <chifratge> | --escala <gama> | --clases <nombres>",
        descripcionTonnetzAcorde: "d'un acòrd, una gama o un ensems de classas de nautor",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triadas> | --camino <triada> <triada>",
        descripcionTonnetzRecorrido: "un percors de triadas, amb de sagetas, o lo camin mai cort per P, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <cicle> <triada>",
        descripcionTonnetzCiclo: "un cicle exatonic, octatonic o LR",
        notasTonnetzCiclo: "(--margen 2: mai de malhum a l'entorn)",
        sintaxisTabla: "tabla <nòtas o nautors>",
        descripcionTabla: "taula armonica en SVG (exagònes)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "coma pel Tonnetz (--margen 2: mai de taula a l'entorn)",
        sintaxisCuadricula: "cuadricula <nòtas o nautors> | --acorde | --escala | --clases",
        descripcionCuadricula: "clavièr en quadrilha en SVG (pads), amb lo contorn e la primièra nòta",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <nautor>\ncuadricula --giro 0-3 --espejo --en-tono --escala <gama>",
        descripcionCuadriculaOpciones: "axes (1,5: en quartas), grasilha del controlaire (8x8), nòta del canton, quarts de torn, miralh e dins la tonalitat",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acòrd> [--voces 2]",
        descripcionVecinos: "acòrds a un semiton (setenas: dominanta, menora, semidiminuida e diminuida; triadas: majora, menora e aumentada; un maj7, entre las setenas e los maj7; --ampliada: amb los maj7 tanben)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acòrd> <acòrd> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d'un acòrd a l'autre en movent una votz (o doas) d'un semiton a cada pas",
        sintaxisConduccionMinima: "conduccion-minima <acòrd> <acòrd>",
        descripcionConduccionMinima: "la conducha amb lo mens de semitons",
        sintaxisPlr: "plr <triada> <P, L, R…>",
        descripcionPlr: "transformacions neoriemannianas",
        sintaxisPlrCamino: "plr <triada> <triada>",
        descripcionPlrCamino: "lo camin mai cort per P, L e R",
        sintaxisPlrCiclo: "plr <triada> <cicle>",
        descripcionPlrCiclo: "un cicle: hexatonico (P, L), octatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eveniments> [opcions]",
        descripcionMusicxmlMelodia: "partición MusicXML d'una melodia",
        sintaxisMusicxmlCoral: "musicxml coral <acòrds> [opcions]",
        descripcionMusicxmlCoral: "coral a quatre voses en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <chifratges> [opcions]",
        descripcionMusicxmlAcordes: "progression amb chifratges e analisi",
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sòl major, --clave fa, --tempo 90 (o --tempo 60 4.), --titulo Mon coral, --duracion 2 (çò que dura cada acòrd; negra se que non), --cifrados e --analisis (dins lo coral: chifratge american dessús, roman e foncion dejós)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <chifratges> [opcions]",
        descripcionMusicxmlArpegios: "los acòrds arpejats, nòta a nòta",
        notasMusicxmlArpegios: "opcions: --patron alberti (o ascendente, descendente, ida y vuelta), --figura 16 (çò que dura cada nòta; cròcha se que non), --duracion 1 (çò que dura cada acòrd: lo motiu se repetís fins a l'emplenar) e las autras d'«acordes»\n--enlazar: cada arpegi comença per la nòta mai pròcha de la darrièra de l'anterior",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichièr>",
        descripcionMusicxmlArchivo: "la progression d'un fichièr MIDI, MusicXML, MEI o ABC, amb çò que dura cada acòrd (tanben arpegios, mei e midi)",
        sintaxisMusicxmlEscala: "musicxml escala <gama> [opcions]",
        descripcionMusicxmlEscala: "una gama en negras, amb sos microtons: lo mièg bemòl d'un maqam, lo koron, las comas d'un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMeiMelodia: "lo meteis en MEI 5, lo format de las edicions criticas (amb las meteissas opcions)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionLilypondMelodia: "lo meteis en LilyPond, per gravar la partitura en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionGuidoMelodia: "lo meteis en GUIDO (.gmn), per o veire amb GuidoLib o INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionAbcMelodia: "lo meteis en ABC, la notacion en tèxte de la musica tradicionala",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMidiMelodia: "lo meteis coma fichièr MIDI, per l'ausir (sens --clave ni --cifrados; amb --programa 0…127, General MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opcions]",
        descripcionGrabar: "la partitura en PDF, SVG o PNG amb LilyPond, MuseScore, Verovio o Guido, o lo dessenh amb rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio, --formato pdf|svg|png; Verovio e Guido donan d'SVG, que rsvg-convert passa en PDF o PNG; armonia motores ditz quins son installats",
        sintaxisMotores: "motores",
        descripcionMotores: "los motors d'armonia grabar: ont es cada programa e sa version, o la variabla (ARMONIA_…) que ne dona lo camin",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <chifratge>… [opcions]",
        descripcionDigitaciones: "biaisses de jogar un acòrd, del mai comòde al mens, sus un instrument de còrdas amb trasts (còrdas del grèu a l'agut)\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|… (tanben «guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»), --limite 5, --traste 12 (lo mai naut que s'utiliza), --dedos 4 (los que se pòdon utilizar), --completo (amb totas las nòtas: per defaut la quinta pòt mancar), --diagrama (una linha per còrda), --capo 2 (los trasts, dempuèi lo capodastre), --musicxml (la primièra forma de cada acòrd, coma tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <gama> [--caged]",
        descripcionPosiciones: "la gama per posicions a la guitarra: tres nòtas per còrda (doas dins las pentatonicas) o CAGED",
        notasPosiciones: "opcions: --secuencia terceras (o una autra: la sequéncia dins cada posicion; amb --bajando, en davalant) e --formas (las cinc formas de la pentatonica e las nòtas comunas); --instrumento bajo (o un autre; tanben re-abierto, sol-abierto, dadgad) e --capo 2",
        sintaxisTeclado: "teclado <gama> [--mano derecha]",
        descripcionTeclado: "la gama sus un clavièr de piano (SVG): sas nòtas o, amb --mano derecha o izquierda, los dets; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "la gama sus un relòtge de dotze oras (SVG): lo cercle cromatic o, amb --quintas, lo de quintas",
        sintaxisHoja: "hoja <escala>",
        descripcionHoja: "la gama sus un fuèlh d'estudi d'imprimir (SVG): pentagrama, clavièr amb los dets, relòtge, estatisticas, acòrdis e escalièr de brilhança; armonia grabar hoja … la passa en PDF",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "una gama, un acòrd, un arpègi (amb ritme: --figura 16, --tresillos) o d'acòrds amb lor chifratge sus una portada (SVG); --nombres, --intervalos, --semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <qué> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "los grases en nombres romans jos los acòrds; los dets del piano (--mano derecha) o de la guitarra (--tab --dedos); la gama per tèrças o en grops (--secuencia terceras); la tablatura dejós (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <qué> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "l'octava (--octava 2), la clau (--clave fa), la portada dobla, los cambiaments de clau segon lo registre e lo bas chifrat dels acòrds (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <nòtas> --sobre <acòrds>",
        descripcionPentagramaMelodia: "una melodia (Do4:8 Re4:8…) amb un acòrd per mesura dessús; las nòtas que son pas de l'acòrd, en verd (o en roge se son cromaticas); --ajenas o fa dins los autres",
        sintaxisPosicionesArpegio: "posiciones --arpegio <chifratge> [--caged|--barrido]",
        descripcionPosicionesArpegio: "l'arpègi d'un acòrdi dins cada posicion del margue, en tablatura amb los dets; --ida-y-vuelta, monta e davala",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musicala dempuèi la linha de comandas.

        Usatge: armonia <òrdre> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Òrdres (los òrdres e las opcions s'escrivon en castelhan o en anglés):
        """,
        pieDeLaAyuda: """
        S'acceptan de noms de nòta en castelhan, catalan, galician, basc, portugués, occitan o
        anglés (Do, C, Sib, Bb, si bemòl). Amb --idioma oc, la responsa utiliza la notacion occitana
        e los messatges en occitan; amb --ingles, en anglés.
        Amb --textos, los tèxtes son dins una autra lenga que las nòtas: --idioma en --textos oc.
        En castelhan e anglés, --escritura palabras|ascii|unicode escriu las nòtas coma Fa sostenido,
        Fa# o Fa♯ (en anglés, F sharp, F# o F♯).
        Dins las autras lengas, --escritura palabras|compacto causís los mots o la forma compacta:
        fa dièse o Fa♯, F Kreuz o Fis.
        Dins las escrituras compactas l'octava va en subindici (La₄) e dins las autras, amb chifras (La4);
        --subindices o --cifras la fixan (se legisson las doas formas).
        Amb --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones e tradiciones donan lors donadas en JSON.
        Amb --json tanben armonizar, realizar, revisar, contrapunto e transponer. Se la sortida es pas
        lo terminal, lo JSON va sus una sola linha.
        ARMONIA_IDIOMA=eu fixa la lenga sens --idioma; amb ARMONIA_IDIOMA=sistema, la de LANG.
        Còdis de sortida: 0 plan, 1 tèxte que se pòt pas legir, 2 òrdre mal escrich e 3 fautas (revisar,
        contrapunto).
        Sens arguments e dins lo terminal, armonia dobrís una sesilha: un òrdre per linha.
        Amb l'entrada dins un fichièr (armonia < exercicis.txt), n'executa las linhas parièr; una linha
        sonque amb d'opcions (--idioma eu) las daissa per las seguentas.
        Amb -o fichièr, çò que dona l'òrdre s'escriu dins aquel fichièr, tanben dins la sesilha.
        Amb --idioma, las nòtas se legisson tanben dins aquela lenga: H7 e Fis en alemand, ré en francés.
        """,
        sintaxisAyuda: "ayuda [<òrdre>]",
        descripcionAyuda: "aquesta ajuda, o la d'un òrdre (tanben <òrdre> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "l'autocompletatge de las òrdres e opcions pel terminal",
        sintaxisManual: "manual",
        descripcionManual: "aquesta ajuda coma pagina de manual",
        manualNombre: "NOM",
        manualNotas: "NÒTAS",
        manualEntorno: "ENVIRONAMENT",
        manualEstadoDeSalida: "ESTAT DE SORTIDA",
        manualIdiomaDelEntorno: "La lenga, coma --idioma (que l'anulla): es, en, eu…; amb sistema, la de LC_ALL, LC_MESSAGES o LANG.",
        manualRutaDelPrograma: { p in "Lo camin de \(p), se es pas dins lo PATH." },
        manualCodigosDeSalida: ["Tot es anat plan.", "Un tèxte o un fichièr que se pòt pas legir, o res a donar.", "L'òrdre es mal escrich.", "revisar o contrapunto an trobat de fautas."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "mancan los acòrds: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "calon dos acòrds: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "mancan las nòtas de la melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "mancan lo cantus firmus e lo contrapunt, separats per /: " + ejemplo },
        especieFueraDeRango: "--especie va d'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "mancan los acòrds: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "manca lo chifratge: armonia acorde Sol7",
        faltaCifradoDelArpegio: "manca lo chifratge: armonia arpegio Do7",
        patronDesconocido: { patron in "motiu desconegut: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado o alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: es pas una tradicion (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: es pas una categoria de gamas (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: es pas un usatge de gamas (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        ordenDeEscalasDesconocido: { orden in "«\(orden)»: las gamas s'ordenan per brillo o per notas: --orden brillo" },
        faltanNotas: "mancan las nòtas: armonia identificar Do Mi Sol",
        dosNotas: "calon doas nòtas: armonia intervalo Do Mi",
        faltaEscala: "manca la gama: armonia escala Re dórico",
        faltaTonalidad: "manca la tonalitat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "manca la tonalitat aprèp --en",
        faltaConjunto: "manca lo conjunt: armonia conjunto 0 4 7",
        faltaSerie: "manca la seria: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "mancan los acòrds: " + ejemplo },
        archivoIlegible: { nombre in "se pòt pas legir lo fichièr « \(nombre) »" },
        archivoNoEscrito: { nombre in "se pòt pas escriure lo fichièr « \(nombre) »" },
        archivoConAcordes: "amb --archivo, escrivètz pas d'acòrds",
        archivoSinAcordes: "lo fichièr a pas cap d'acòrd",
        faltaTransporte: { ejemplo in "mancan l'interval (o la tonica novèla) e çò que se transpausa: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "mancan los acòrds: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "lo marge es un nombre de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "mancan las nòtas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "manca l'acòrd: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "manca la gama: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "mancan las classas d'autor: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "mancan las triadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "lo cicle es exatonic, octatonic o LR, dempuèi una triada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "lo percors es fach de triadas majoras e menoras: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "lo camin va d'una triada majora o menora a una autra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "lo cicle comença sus una triada majora o menora: " + ejemplo },
        opcionesDeCuadricula: "opcions de la quadrilha: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <nautor> (Do2), --giro 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "las voses que se mòvon son 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "cal un acòrd: " + ejemplo },
        vecinosSinFamilia: "los vesins se cercan entre setenas de dominanta, menoras, semidiminuidas, diminuidas e maj7, o entre triadas majoras, menoras e aumentadas",
        dosAcordesDeCamino: { ejemplo in "calon dos acòrds: " + ejemplo },
        caminoSinConexion: "los dos acòrds devon èsser de la meteissa familha (setenas, amb maj7 o sens, o triadas) e èsser connectats",
        faltanPasosDePLR: { ejemplo in "calon una triada e de passes o una autra triada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L e R s'aplican a las triadas majoras e menoras: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "manca «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "lo programa es un nombre General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados e --analisis son per MusicXML, MEI, LilyPond, GUIDO e ABC",
        faltaValor: { opcion in "manca la valor de --\(opcion)" },
        tempoMalEscrito: "lo tempo s'escriu «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "mancan las nòtas: " + ejemplo },
        marcasSoloCoral: "--cifrados e --analisis son per «coral»",
        duracionSoloCoral: "--duracion es sonque per «coral»",
        claveDesconocida: { clave, claves in "clau desconeguda: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "mancan los acòrds: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) es sonque per «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) es sonque per «arpegios»" },
        archivoSoloParaAcordes: "--archivo es sonque per «acordes» e «arpegios»",
        ventanaSinArchivo: "--ventana va amb --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "mancan los acòrds: " + ejemplo },
        acordesConCifradosYAnalisis: "los acòrds pòrtan totjorn chifratges e analisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s'exporta una «melodia», un «coral», d'«acordes», lors «arpegios» o una «escala»" },
        faltaLoQueSeGraba: "manca çò que se grava: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: los motors son lilypond, musescore, verovio, guido e propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: se grava en «pdf», «svg» o «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: se grava una partitura (melodia, coral, acordes, arpegios, escala) o un dessenh (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "se tròba pas «\(programa)»: installatz-lo o metètz son camin dins \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» s\'es acabat amb lo còdi \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» s\'es pas acabat a temps e es estat arrestat" },
        motorNoInstalado: { variable in "pas installat (o mete son camin dins \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "manca l'instrument: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument desconegut: «\(nombre)» (\(lista(.occitanoPalabras)))" },
        faltaLimite: "manca lo nombre de digitacions: --limite 5",
        limiteFueraDeRango: "lo limit es un nombre d'1 a 200: --limite 5",
        faltanDedos: "manca lo nombre de dets: --dedos 3",
        dedosFueraDeRango: "los dets son un nombre d'1 a 4: --dedos 3",
        faltaTraste: "manca lo trast mai naut: --traste 12",
        trasteFueraDeRango: "lo trast mai naut es un nombre de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "manca lo chifratge: \(d)" },
        faltaEscalaDePosiciones: "manca la gama: armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "manca la gama: armonia teclado Re mayor",
        manoDesconocida: { texto in "man desconeguda: «\(texto)» (derecha o izquierda)" },
        archivoConNotas: "amb --archivo, escrivètz pas de nòtas",
        noEsPentatonica: "las formas son d'una gama de cinc nòtas: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "manca la gama: armonia reloj Re mayor",
        faltaEscalaDeLaHoja: "manca la gama: armonia hoja Re mayor",
        faltaLoQueDibujaElPentagrama: "manca çò que cal dessenhar: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "lo capodastre es un nombre de 0 a 12: --capo 2",
        octavasFueraDeRango: "las octavas son un nombre d'1 a 4: --octavas 2",
        notasFueraDeRango: "las nòtas son un nombre d'1 a 24: --notas 5",
        octavaFueraDeRango: "l'octava es un nombre de 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» es pas una nòta ni un grau de l'acòrd: --desde Mi o --desde 3" },
        tensionesMalEscritas: "las tensions son 9, 11 o 13: --tensiones 9,13",
        gradosMalEscritos: "los graus son de nombres d'1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "aproximacion desconeguda: «\(aproximacion)» (abajo, arriba o encierro)" },
        secuenciaDesconocida: { secuencia in "sequéncia desconeguda: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas o cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Ensaja «armonia ayuda».",
        ordenDesconocida: { orden in "òrdre desconegut: «\(orden)»" },
        opcionDesconocida: { opcion in "opcion desconeguda: «\(opcion)»" },
        idiomaDesconocido: { idioma in "lenga desconeguda: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)" },
        terminalDesconocida: { t in "terminal desconegut: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "escritura invalida: «\(escritura)» (palabras/words o compacto/compact; ascii o unicode, sonque amb es e en)" },
        sinSalidaJSON: { orden in "«\(orden)» dona pas de sortida en JSON" },

        // Mensaje.swift
        mensajeNotas: "nòtas",
        mensajeAcordes: "acòrds",
        mensajeMicrotonos: "microtons",
        mensajeEscalas: "gamas",
        mensajeHabituales: "abitualas",
        mensajeNingunaEscala: "i a pas cap de gama aital",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "omonima",
        mensajeBajo: { nota in "bassa \(nota)" },
        mensajeBajoAjeno: "bassa estrangièra a l'acòrd",
        mensajeSinAcordes: "Fan pas cap d'acòrd conegut.",
        mensajeSin: { notas in "sens \(notas)" },
        mensajeSemitonos: { n in "\(n) semitons" },
        mensajeSinAlteraciones: "sens alteracions",
        mensajeSostenidos: { n in Idioma.occitano.contar(n, "diesi", "dièsis") },
        mensajeBemoles: { n in Idioma.occitano.contar(n, "bemòl", "bemòls") },
        mensajeACuatroVoces: "A quatre voses (bassa, tenor, contralt, soprano):",
        mensajeSinDigitaciones: "i a pas de digitacions comòdas",
        mensajeDedos: { n in Idioma.occitano.contar(n, "det", "dets") },
        mensajeCejilla: { traste in "barra al trast \(traste)" },
        mensajeNingunPaso: "cap de pas",
        mensajeUnPaso: "1 pas",
        mensajePasos: { n in "\(n) passes" },
        mensajeTriadas: { n in Idioma.occitano.contar(n, "triada", "triadas") },
        mensajeFormaNormal: "forma normala",
        mensajeFormaPrima: "forma prima",
        mensajeVectorIntervalico: "vector d'intervals",
        mensajeVectorDeIndice: "vector d'indèx",
        mensajeEjesDeSimetria: "axes de simetria",
        mensajeIntervalos: "intervals",
        mensajeDeTodosLosIntervalos: "de totes los intervals",
        mensajeFormasDistintas: { n in "\(n) formas diferentas" },
        mensajeHexacordos: "hexacòrds",
        mensajeFormasCombinatorias: "formas combinatòrias",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "la version d'armonia",
        quisoDecir: { x in "Voliás dire «\(x)»?" },
        pruebaLaAyudaDe: { o in "Ensaja «armonia ayuda \(o)»." },
        salidaBinaria: "la sortida es un fichièr binari (MIDI, PDF o PNG); enregistratz-la amb > fichièr",
        escalasPorNotas: { e in "i a pas cap de gama amb aqueste nom; per la cercar per sas nòtas: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» escriu ja la partitura; «grabar» la dona en PDF, SVG o PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultas", "Armonia e voses", "Particions e gravadura", "Dessenhs (SVG)", "Neoriemanniana", "Instruments de tòcas", "Lo terminal e l'ajuda"],
        pieDelIndice: """
        L'ajuda d'un òrdre: armonia ayuda <òrdre> (o armonia <òrdre> --help).
        Tota l'ajuda, amb las opcions de cada òrdre: armonia ayuda --todo.
        Per totes los òrdres: --ingles, --idioma, --textos, --escritura, --subindices, --cifras e --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Escrivètz un òrdre per linha, sens «armonia» (ayuda: los òrdres; salir: acabar)." }
    )
}
