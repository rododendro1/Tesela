// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en inglés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let ingles = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <chords> [--in <key>] [--scales]",
        descripcionAnalizar: "roman numerals, functions, cadences and modulations (with their pivot chord; without --in)\n--scales: each chord's scale, with its tensions and avoid notes",
        notasAnalizar: "--guide-tones: two guide-tone lines, from the third and from the seventh",
        sintaxisAnalizarArchivo: "analyze --file <file> [--window <duration>]",
        descripcionAnalizarArchivo: "the same, with the chords of a MIDI, MusicXML, MEI or ABC file (one per beat; --window 2: one per half note)",
        sintaxisArmonizar: "harmonize <melody> [--in <key>] [--proposals 3]",
        descripcionArmonizar: "chords for a melody, best first; with octaves (E4), also the four-part chorale",
        sintaxisRealizar: "realize <chords> [--in <key>]",
        descripcionRealizar: "the chords in four parts, without voice-leading errors",
        sintaxisRevisar: "check <chords>",
        descripcionRevisar: "voice-leading errors (parallel fifths…); chords from low to high, separated by commas",
        sintaxisContrapunto: "counterpoint <cantus> / <counterpoint> [--species 1]",
        descripcionContrapunto: "errors in species counterpoint (1 to 5) over a cantus firmus in whole notes; notes without a duration take the species' one",
        sintaxisTransponer: "transpose <interval|tonic> <chords or notes>",
        descripcionTransponer: "moves chords, a melody or a chorale to another key: an interval (M2, -m3) or the new tonic (D)",
        sintaxisRearmonizar: "reharmonize <chords> [--in <key>]",
        descripcionRearmonizar: "other harmonies for each chord: tritone substitution, secondary dominants, modal borrowing and diatonic substitutions",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <symbol>…",
        descripcionAcorde: "notes, type and role of each note",
        notasAcorde: "options: --voicings, --names, --keys, --substitutions (in the key given by --in C major, at the end) and --compare C (common tones and voice leading); --bebop and --pentatonics (scales to improvise over it)",
        sintaxisArpegio: "arpeggio <symbol> [--pattern <pattern>]",
        descripcionArpegio: "arpeggio notes and the scales that fit the chord (--pattern ascending, descending, up-down, down-up, broken, alberti)",
        notasArpegio: "options: --octaves 2 (from 1 to 4), --no-octave, --from E (or 3: start on that note), --tensions 9,13, --degrees 1-5-3-8 (a pattern of your own) and --approach below, above or enclosure (chromatic notes leading to each one)",
        sintaxisIdentificar: "identify <notes>",
        descripcionIdentificar: "chords formed by some notes",
        notasIdentificar: "options: --scales (the scales that contain the notes, instead of chords) and --file melody.mid (the notes of a MIDI, MusicXML, MEI or ABC file, with --scales)",
        sintaxisIntervalo: "interval <note> <note>",
        descripcionIntervalo: "interval between two notes or pitches",
        sintaxisEscala: "scale <scale> [--chords]",
        descripcionEscala: "notes and chords of a scale\n--chords: every chord that fits on each degree, not only stacked thirds",
        notasEscala: "options: --sequence thirds (or fourths, groups-of-3, groups-of-4, triads, sevenths), --descending, --octaves 2 (from 1 to 4), --piano (fingering), --modes (parallel and relative) and --compare C lydian (at the end); --symmetry (how often it repeats and its chords); --neighbors (moving one note) and --all-keys (in all twelve keys); --all-keys --chords (the chords of each degree; --triads, without sevenths); --statistics (number of notes, brightness, interval vector…); --brightness-ladder (from darkest to brightest, raising one note each time)",
        sintaxisEscalas: "scales [<text>] [options]",
        descripcionEscalas: "the catalog of scales: the common ones and those of other traditions, by category, with their notes from C",
        notasEscalas: "options: --tradition turkey (or india, greece, ancient-greece, arab-world, persia, azerbaijan, china, japan, korea, ethiopia, indonesia, klezmer, andes, byzantium, mesopotamia, africa, southeast-asia, gregorian, europe, vietnam, brazil) and --category maqam (or rāga, makam, dastgah, dromos…); --use jazz (or classical, blues, 20th-century, folk, synthetic) filters the common ones; --notes 5 keeps only the five-note ones; --sort brightness (or notes) sorts them, and --anhemitonic and --maximally-even keep the anhemitonic and the maximally even ones; a text searches the names",
        sintaxisTradiciones: "traditions [<tradition>]",
        descripcionTradiciones: "the catalog's traditions, with their categories and how many scales each has; with one, its scales",
        sintaxisTonalidad: "key <key>",
        descripcionTonalidad: "key signature, relatives and degrees",
        sintaxisConjunto: "set <pcs>",
        descripcionConjunto: "prime form, Forte number, vectors, symmetries and notes",
        sintaxisSerie: "row <row>",
        descripcionSerie: "matrix, forms and combinatoriality of a twelve-tone row",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "SVG Tonnetz of some notes",
        sintaxisTonnetzAcorde: "tonnetz --chord <symbol> | --scale <scale> | --pcs <numbers>",
        descripcionTonnetzAcorde: "of a chord, a scale or a pitch-class set",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <triads> | --shortest <triad> <triad>",
        descripcionTonnetzRecorrido: "a sequence of triads, with arrows, or the shortest path through P, L and R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <cycle> <triad>",
        descripcionTonnetzCiclo: "a hexatonic, octatonic or LR cycle",
        notasTonnetzCiclo: "(--margen 2: more grid around it)",
        sintaxisTabla: "tabla <notes or pitches>",
        descripcionTabla: "SVG harmonic table (hexagons)",
        sintaxisTablaAcorde: "tabla --chord <symbol> | --scale <scale> | --pcs <numbers>\ntabla --sequence <triads> | --shortest <triad> <triad>\ntabla --cycle <cycle> <triad>",
        descripcionTablaAcorde: "(--margen 2: more table around it)",
        sintaxisCuadricula: "cuadricula <notes or pitches> | --chord | --scale | --pcs",
        descripcionCuadricula: "SVG grid keyboard (pads), with the outline and the first note",
        sintaxisCuadriculaOpciones: "cuadricula --axes H,V --grid CxR --origin <pitch>\ncuadricula --rotate 0-3 --mirror --in-key --scale <scale>",
        descripcionCuadriculaOpciones: "axes (1,5: in fourths), controller grid (8x8), corner note, quarter turns, mirror and in key",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <chord> [--voices 2]",
        descripcionVecinos: "chords a semitone away (sevenths: dominant, minor, half-diminished and diminished; triads: major, minor and augmented; a maj7, among the sevenths and the maj7s; --extended: with the maj7s too)",
        sintaxisConduccionParsimoniosa: "smooth-path <chord> <chord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "from one chord to another moving one voice (or two) a semitone at a time",
        sintaxisConduccionMinima: "minimal-voice-leading <chord> <chord>",
        descripcionConduccionMinima: "the voice leading with fewest semitones",
        sintaxisPlr: "plr <triad> <P, L, R…>",
        descripcionPlr: "neo-Riemannian transformations",
        sintaxisPlrCamino: "plr <triad> <triad>",
        descripcionPlrCamino: "the shortest path through P, L and R",
        sintaxisPlrCiclo: "plr <triad> <cycle>",
        descripcionPlrCiclo: "a cycle: hexatonic (P, L), octatonic (P, R) or \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <events> [options]",
        descripcionMusicxmlMelodia: "MusicXML score of a melody",
        sintaxisMusicxmlCoral: "musicxml chorale <chords> [options]",
        descripcionMusicxmlCoral: "four-part chorale in MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <symbols> [options]",
        descripcionMusicxmlAcordes: "progression with symbols and analysis",
        notasMusicxmlAcordes: "options: --compas 6/8 (time signature), --anacrusa 8 (pickup), --tonalidad G major (key), --clave fa (clef), --tempo 90 (or --tempo 60 4.), --titulo My chorale (title), --duracion 2 (how long each chord lasts; a quarter note by default), --cifrados and --analisis (in the chorale: chord symbols above, roman numerals and function below)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <symbols> [options]",
        descripcionMusicxmlArpegios: "the chords arpeggiated, note by note",
        notasMusicxmlArpegios: "options: --patron alberti (or up, down, up-down), --figura 16 (how long each note lasts; an eighth note by default), --duracion 1 (how long each chord lasts: the pattern repeats to fill it) and the other options of \"chords\"\n--connect: each arpeggio starts on the note nearest to the last one of the previous chord",
        sintaxisMusicxmlArchivo: "musicxml chords --file <file>",
        descripcionMusicxmlArchivo: "the progression of a MIDI, MusicXML, MEI or ABC file, with how long each chord lasts (also arpeggios, mei and midi)",
        sintaxisMusicxmlEscala: "musicxml scale <scale> [options]",
        descripcionMusicxmlEscala: "a scale in quarter notes, with its microtones: the half flat of a maqam, the koron, the commas of a makam",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios|scale <…> [options]",
        descripcionMeiMelodia: "the same in MEI 5, the format of critical editions (with the same options)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios|scale <…> [options]",
        descripcionLilypondMelodia: "the same in LilyPond, to engrave the score as a PDF",
        sintaxisGuidoMelodia: "guido melody|chorale|chords|arpeggios|scale <…> [options]",
        descripcionGuidoMelodia: "the same in GUIDO (.gmn), to view it with GuidoLib or INScore",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios|scale <…> [options]",
        descripcionAbcMelodia: "the same in ABC, the text notation of traditional music",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios|scale <…> [options]",
        descripcionMidiMelodia: "the same as a MIDI file, to listen to (without --clave or --cifrados; with --program 0…127, General MIDI)",
        sintaxisGrabar: "engrave melody|chorale|chords|arpeggios|scale <…>\nengrave staff|tonnetz|harmonic-table|keyboard|clock <…> [options]",
        descripcionGrabar: "the score as a PDF, SVG or PNG with LilyPond, MuseScore, Verovio or Guido, or the drawing with rsvg-convert",
        notasGrabar: "--engine lilypond|musescore|verovio|guido|own, --format pdf|svg|png; Verovio and Guido give SVG, which rsvg-convert turns into PDF or PNG; armonia engines says which ones are installed",
        sintaxisMotores: "engines",
        descripcionMotores: "the engines of armonia engrave: where each program is and its version, or the variable (ARMONIA_…) that gives its path",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <symbol>… [options]",
        descripcionDigitaciones: "ways to play a chord, from the most comfortable to the least, on a fretted string instrument (strings from low to high)\noptions: --instrument guitar|bass|ukulele|mandolin|… (also \"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5, --fret 12 (the highest one used), --fingers 4 (how many can be used), --complete (with every note: by default the fifth may be left out), --diagram (one line per string), --capo 2 (frets counted from the capo), --musicxml (the first shape of each chord as a MusicXML tablature)",
        sintaxisPosiciones: "positions <scale> [--caged]",
        descripcionPosiciones: "the scale by positions on the guitar: three notes per string (two in the pentatonics) or CAGED",
        notasPosiciones: "options: --sequence thirds (or another: the sequence in each position; with --descending, going down) and --shapes (the five pentatonic shapes and their shared notes); --instrument bass (or another; also open-d, open-g, dadgad) and --capo 2",
        sintaxisTeclado: "keyboard <scale> [--hand right]",
        descripcionTeclado: "the scale on a piano keyboard (SVG): its notes or, with --hand right or left, the fingers; --octaves 2",
        sintaxisReloj: "clock <scale> [--fifths]",
        descripcionReloj: "the scale on a twelve-hour clock (SVG): the chromatic circle or, with --fifths, the circle of fifths",
        sintaxisPentagrama: "staff scale|chord|arpeggio|chords <…>",
        descripcionPentagrama: "a scale, a chord, an arpeggio (with rhythm: --figure 16, --triplets) or some chords with their symbols on a staff (SVG); --names, --intervals, --semitones, --tonic, --in <key>",
        sintaxisPentagramaEstudio: "staff <what> --roman|--hand|--sequence|--tab",
        descripcionPentagramaEstudio: "the degrees in Roman numerals under the chords; piano fingering (--hand right) or guitar fingering (--tab --fingers); the scale in thirds or in groups (--sequence thirds); the tablature underneath (--tab, --instrument)",
        sintaxisPentagramaRegistro: "staff <what> --octave|--clef|--grand-staff|--clef-changes|--figured-bass",
        descripcionPentagramaRegistro: "the octave (--octave 2), the clef (--clef bass), the grand staff, clef changes by register and the figured bass of the chords (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "staff melody <notes> --over <chords>",
        descripcionPentagramaMelodia: "a melody (C4:8 D4:8…) with one chord per bar above it; notes outside the chord in green (or red if chromatic); --non-chord does the same elsewhere",
        sintaxisPosicionesArpegio: "positions --arpeggio <symbol> [--caged|--sweep]",
        descripcionPosicionesArpegio: "a chord's arpeggio in each position on the neck, in tab with the fingers; --up-and-down, up and back down",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: music theory from the command line.

        Usage: armonia <command> <arguments> [--ingles | --language es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Commands:
        """,
        pieDeLaAyuda: """
        Note names are accepted in Spanish or English (Do, C, Sib, Bb). With --ingles, the answer
        uses English notation, and so do messages and this help. With --language ca, gl, ast, an, eu,
        pt, fr, oc, it, de, el, ru or hu, notes, names, messages and this help are in Catalan,
        Galician, Asturian, Aragonese, Basque, Portuguese, French, Occitan, Italian, German, Greek,
        Russian or Hungarian.
        With --texts, the texts use another language than the notes: --language es --texts en.
        In Spanish and English, --writing words|ascii|unicode writes notes as F sharp, F# or F♯
        (in Spanish, Fa sostenido, Fa# or Fa♯).
        In the other languages, --writing words|compact picks words or the compact form:
        fa dièse or Fa♯, F Kreuz or Fis.
        In compact writings the octave is a subscript (A₄) and in the others, digits (A4);
        --subscripts or --digits choose one (both forms are read).
        With --json, chord, identify, arpeggio, interval, scale, key, analyze, set, row, fingerings and traditions
        give their data as JSON.
        With --json also harmonize, realize, check, counterpoint and transpose. When the output is not
        a terminal, the JSON goes on a single line.
        ARMONIA_IDIOMA=eu sets the language without --language; ARMONIA_IDIOMA=system takes it from LANG.
        Exit codes: 0 fine, 1 unreadable text, 2 badly written command and 3 mistakes found (check,
        counterpoint).
        With no arguments in a terminal, armonia opens a session: one command per line.
        With input from a file (armonia < exercises.txt), it runs its lines the same way; a line with
        only options (--language eu) keeps them for the following ones.
        With -o file, the output of the command is written to that file, also in the session.
        With --language, notes are also read in that language: H7 and Fis in German, ré in French.
        """,
        sintaxisAyuda: "help [<command>]",
        descripcionAyuda: "this help, or a command's help (also <command> --help)",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "completion of commands and options for the shell",
        sintaxisManual: "manual",
        descripcionManual: "this help as a manual page",
        manualNombre: "NAME",
        manualNotas: "NOTES",
        manualEntorno: "ENVIRONMENT",
        manualEstadoDeSalida: "EXIT STATUS",
        manualIdiomaDelEntorno: "The language, like --language (which overrides it): es, en, eu…; with system, the one in LC_ALL, LC_MESSAGES or LANG.",
        manualRutaDelPrograma: { p in "The path to \(p), if it is not in the PATH." },
        manualCodigosDeSalida: ["Everything went well.", "A text or file that cannot be read, or nothing to give.", "The command is badly written.", "check or counterpoint found mistakes."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "missing the chords: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "two chords are needed: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "missing the notes of the melody: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "--proposals goes from 1 to 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "missing the cantus firmus and the counterpoint, separated by /: " + ingles },
        especieFueraDeRango: "--species goes from 1 to 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "missing the chords: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "missing the chord symbol: armonia chord G7",
        faltaCifradoDelArpegio: "missing the chord symbol: armonia arpeggio C7",
        patronDesconocido: { patron in "unknown pattern: \"\(patron)\" (ascending, descending, up-down, down-up, broken or alberti)" },
        tradicionDesconocida: { tradicion in "\"\(tradicion)\" is not a tradition (india, greece, arab-world, persia, turkey…)" },
        categoriaDesconocida: { categoria in "\"\(categoria)\" is not a scale category (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "\"\(uso)\" is not a scale use (classical, jazz, blues, 20th-century, folk, synthetic)" },
        ordenDeEscalasDesconocido: { orden in "\"\(orden)\": scales are sorted by brightness or by notes: --sort brightness" },
        faltanNotas: "missing the notes: armonia identify C E G",
        dosNotas: "two notes are needed: armonia interval C E",
        faltaEscala: "missing the scale: armonia scale D dorian",
        faltaTonalidad: "missing the key: armonia key A minor",
        faltaTonalidadTrasEn: "missing the key after --in",
        faltaConjunto: "missing the set: armonia set 0 4 7",
        faltaSerie: "missing the row: armonia row 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "missing the chords: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "cannot read the file \"\(nombre)\"" },
        archivoNoEscrito: { nombre in "cannot write the file \"\(nombre)\"" },
        archivoConAcordes: "with --file, do not write chords",
        archivoSinAcordes: "the file has no chords",
        faltaTransporte: { ejemplo in "missing the interval (or the new tonic) and what to transpose: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "missing the chords: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "the margin is a number from 0 to 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "missing the notes: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "missing the chord: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "missing the scale: armonia \(orden) --scale D dorian" },
        faltanClasesDelDibujo: { ejemplo, orden in "missing the pitch classes: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "missing the triads: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "the cycle is hexatonic, octatonic or LR, from a triad: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "the sequence is made of major and minor triads: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "the shortest path goes from one major or minor triad to another: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "the cycle starts on a major or minor triad: armonia \(orden) --cycle hexatonic C" },
        opcionesDeCuadricula: "grid options: --axes H,V (1,5), --grid CxR (8x8), --origin <pitch> (C2), --rotate 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "the moving voices are 1 or 2: --voices 2",
        unAcordeDeVecinos: { ejemplo in "one chord is needed: armonia neighbors G7" },
        vecinosSinFamilia: "neighbors are searched among dominant, minor, half-diminished, diminished and maj7 sevenths, or among major, minor and augmented triads",
        dosAcordesDeCamino: { ejemplo in "two chords are needed: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "both chords must be of the same family (sevenths, with or without maj7, or triads) and be connected",
        faltanPasosDePLR: { ejemplo in "a triad and some steps or another triad are needed: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "P, L and R apply to major and minor triads: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "missing \"melody\", \"chorale\" or \"chords\": armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "the program is a General MIDI number from 0 to 127: --program 52",
        marcasSoloMusicXML: "--cifrados and --analisis are for MusicXML, MEI, LilyPond, GUIDO and ABC",
        faltaValor: { opcion in "missing the value of --\(opcion)" },
        tempoMalEscrito: "the tempo is written \"--tempo 90\" or \"--tempo 60 4.\"",
        faltanNotasDeLaMelodia: { ejemplo, orden in "missing the notes: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "--cifrados and --analisis are for \"chorale\"",
        duracionSoloCoral: "--duracion is only for \"chorale\"",
        claveDesconocida: { clave, claves in "unknown clef: \"\(clave)\" (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "missing the chords: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "--\(opcion) is only for \"melody\"" },
        soloParaArpegios: { opcion in "--\(opcion) is only for \"arpeggios\"" },
        archivoSoloParaAcordes: "--file is only for \"chords\" and \"arpeggios\"",
        ventanaSinArchivo: "--window goes with --file",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "missing the chords: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "chords always come with chord symbols and analysis",
        tipoDePartituraDesconocido: { tipo in "\"\(tipo)\": the export is a \"melody\", a \"chorale\", \"chords\", their \"arpeggios\" or a \"scale\"" },
        faltaLoQueSeGraba: "missing what to engrave: armonia engrave chorale C3 E4 G4 C5 > chorale.pdf",
        motorDesconocido: { motor in "\"\(motor)\": the engines are lilypond, musescore, verovio, guido and own" },
        formatoDeGrabadoDesconocido: { formato in "\"\(formato)\": the output is \"pdf\", \"svg\" or \"png\"" },
        nadaQueGrabar: { orden in "\"\(orden)\": engrave a score (melody, chorale, chords, arpeggios, scale) or a drawing (staff, tonnetz, harmonic-table, keyboard, grid, clock)" },
        motorNoEncontrado: { programa, variable in "cannot find \"\(programa)\": install it or set \(variable) to its path" },
        motorFallo: { programa, codigo in "\"\(programa)\" exited with code \(codigo):" },
        motorSinTerminar: { programa in "\"\(programa)\" did not finish in time and was stopped" },
        motorNoInstalado: { variable in "not installed (or set \(variable) to its path)" },
        motorPropio: "own",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "missing the instrument: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "unknown instrument: \"\(nombre)\" (\(lista(.inglesASCII)))" },
        faltaLimite: "missing the number of fingerings: --limit 5",
        limiteFueraDeRango: "the limit is a number from 1 to 200: --limit 5",
        faltanDedos: "missing the number of fingers: --fingers 3",
        dedosFueraDeRango: "the fingers are a number from 1 to 4: --fingers 3",
        faltaTraste: "missing the highest fret: --fret 12",
        trasteFueraDeRango: "the highest fret is a number from 0 to 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "missing the chord symbol: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "missing the scale: armonia positions G major",
        faltaEscalaDelTeclado: "missing the scale: armonia keyboard D major",
        manoDesconocida: { texto in "unknown hand: \"\(texto)\" (right or left)" },
        archivoConNotas: "with --file, do not write notes",
        noEsPentatonica: "shapes need a five-note scale: armonia positions A minor pentatonic --shapes",
        faltaEscalaDelReloj: "missing the scale: armonia clock D major",
        faltaLoQueDibujaElPentagrama: "missing what to draw: armonia staff scale D dorian",
        capoFueraDeRango: "the capo is a number from 0 to 12: --capo 2",
        octavasFueraDeRango: "the octaves are a number from 1 to 4: --octaves 2",
        notasFueraDeRango: "the notes are a number from 1 to 24: --notes 5",
        octavaFueraDeRango: "the octave is a number from 0 to 7: --octave 3",
        desdeNoValido: { desde in "\"\(desde)\" is not a note or degree of the chord: --from E or --from 3" },
        tensionesMalEscritas: "the tensions are 9, 11 or 13: --tensions 9,13",
        gradosMalEscritos: "the degrees are numbers from 1 to 22: --degrees 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "unknown approach: \"\(aproximacion)\" (below, above or enclosure)" },
        secuenciaDesconocida: { secuencia in "unknown sequence: \"\(secuencia)\" (thirds, fourths, groups-of-3, groups-of-4, triads or sevenths)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Try \"armonia help\".",
        ordenDesconocida: { orden in "unknown command: \"\(orden)\"" },
        opcionDesconocida: { opcion in "unknown option: \"\(opcion)\"" },
        idiomaDesconocido: { idioma in "unknown language: \"\(idioma)\" (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru or hu)" },
        terminalDesconocida: { t in "unknown shell: \"\(t)\" (bash, zsh or fish)" },
        escrituraNoValida: { escritura in "invalid writing: \"\(escritura)\" (words or compact; ascii or unicode, only with es and en)" },
        sinSalidaJSON: { orden in "\"\(orden)\" has no JSON output" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "chords",
        mensajeMicrotonos: "microtones",
        mensajeEscalas: "scales",
        mensajeHabituales: "common",
        mensajeNingunaEscala: "no scale matches",
        mensajeArmadura: "key signature",
        mensajeRelativa: "relative",
        mensajeHomonima: "parallel",
        mensajeBajo: { nota in "bass \(nota)" },
        mensajeBajoAjeno: "bass not in the chord",
        mensajeSinAcordes: "No chord found.",
        mensajeSin: { notas in "omits \(notas)" },
        mensajeSemitonos: { n in "\(n) semitones" },
        mensajeSinAlteraciones: "no sharps or flats",
        mensajeSostenidos: { n in Idioma.ingles.contar(n, "sharp", "sharps") },
        mensajeBemoles: { n in Idioma.ingles.contar(n, "flat", "flats") },
        mensajeACuatroVoces: "In four parts (bass, tenor, alto, soprano):",
        mensajeSinDigitaciones: "no comfortable fingerings found",
        mensajeDedos: { n in Idioma.ingles.contar(n, "finger", "fingers") },
        mensajeCejilla: { traste in "barre at fret \(traste)" },
        mensajeNingunPaso: "no steps",
        mensajeUnPaso: "1 step",
        mensajePasos: { n in "\(n) steps" },
        mensajeTriadas: { n in Idioma.ingles.contar(n, "triad", "triads") },
        mensajeFormaNormal: "normal form",
        mensajeFormaPrima: "prime form",
        mensajeVectorIntervalico: "interval vector",
        mensajeVectorDeIndice: "index vector",
        mensajeEjesDeSimetria: "axes of symmetry",
        mensajeIntervalos: "intervals",
        mensajeDeTodosLosIntervalos: "all-interval",
        mensajeFormasDistintas: { n in "\(n) distinct forms" },
        mensajeHexacordos: "hexachords",
        mensajeFormasCombinatorias: "combinatorial forms",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "the armonia version",
        quisoDecir: { x in "Did you mean \"\(x)\"?" },
        pruebaLaAyudaDe: { o in "Try \"armonia help \(o)\"." },
        salidaBinaria: "the output is a binary file (MIDI, PDF or PNG); save it with > file",
        escalasPorNotas: { e in "no scale has that name; to find one by its notes: \(e)" },
        grabarUnaPartitura: { o, e in "\"armonia \(o)\" already writes the score; \"engrave\" gives it as PDF, SVG or PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Lookups", "Harmony and voices", "Scores and engraving", "Drawings (SVG)", "Neo-Riemannian", "Fretted instruments", "Terminal and help"],
        pieDelIndice: """
        The help for one command: armonia help <command> (or armonia <command> --help).
        All the help, with each command's options: armonia help --all.
        For every command: --ingles, --language, --texts, --writing, --subscripts, --digits and --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Type one command per line, without \"armonia\" (help: the commands; exit: quit)." }
    )
}
