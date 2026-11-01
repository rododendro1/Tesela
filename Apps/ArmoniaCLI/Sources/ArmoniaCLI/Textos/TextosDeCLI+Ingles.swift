// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en inglés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let ingles = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <chords> [--in <key>]",
        descripcionAnalizar: "roman numerals, functions, cadences\nand modulations (with their pivot\nchord; without --in)",
        sintaxisAnalizarArchivo: "analyze --file <file> [--window <duration>]",
        descripcionAnalizarArchivo: "the same, with the chords of a MIDI\nor MusicXML file (one per beat;\n--window 2: one per half note)",
        sintaxisArmonizar: "harmonize <melody> [--in <key>] [--proposals 3]",
        descripcionArmonizar: "chords for a melody, best first; with\noctaves (E4), also the four-part\nchorale",
        sintaxisRealizar: "realize <chords> [--in <key>]",
        descripcionRealizar: "the chords in four parts, without\nvoice-leading errors",
        sintaxisRevisar: "check <chords>",
        descripcionRevisar: "voice-leading errors (parallel\nfifths…); chords from low to high,\nseparated by commas",
        sintaxisContrapunto: "counterpoint <cantus> / <counterpoint> [--species 1]",
        descripcionContrapunto: "errors in species counterpoint (1 to\n5) over a cantus firmus in whole\nnotes; notes without a duration take\nthe species' one",
        sintaxisTransponer: "transpose <interval|tonic> <chords or notes>",
        descripcionTransponer: "moves chords, a melody or a chorale\nto another key: an interval (M2, -m3)\nor the new tonic (D)",
        sintaxisRearmonizar: "reharmonize <chords> [--in <key>]",
        descripcionRearmonizar: "other harmonies for each chord:\ntritone substitution, secondary\ndominants, modal borrowing and\ndiatonic substitutions",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <symbol>…",
        descripcionAcorde: "notes, type and role of each note",
        sintaxisArpegio: "arpeggio <symbol> [--pattern <pattern>]",
        descripcionArpegio: "arpeggio notes and the scales that\nfit the chord (--pattern ascending,\ndescending, up-down, alberti)",
        sintaxisIdentificar: "identify <notes>",
        descripcionIdentificar: "chords formed by some notes",
        sintaxisIntervalo: "interval <note> <note>",
        descripcionIntervalo: "interval between two notes or pitches",
        sintaxisEscala: "scale <scale>",
        descripcionEscala: "notes and chords of a scale",
        sintaxisTonalidad: "key <key>",
        descripcionTonalidad: "key signature, relatives and degrees",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "SVG Tonnetz of some notes",
        sintaxisTonnetzAcorde: "tonnetz --chord <symbol> | --scale <scale> | --pcs <numbers>",
        descripcionTonnetzAcorde: "of a chord, a scale or a\npitch-class set",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <triads> | --shortest <triad> <triad>",
        descripcionTonnetzRecorrido: "a sequence of triads, with arrows, or\nthe shortest path through P, L and R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <cycle> <triad>",
        descripcionTonnetzCiclo: "a hexatonic, octatonic or LR cycle",
        notasTonnetzCiclo: "(--margen 2: more grid around it)",
        sintaxisTabla: "tabla <notes or pitches>",
        descripcionTabla: "SVG harmonic table (hexagons)",
        sintaxisTablaAcorde: "tabla --chord <symbol> | --scale <scale> | --pcs <numbers>\ntabla --sequence <triads> | --shortest <triad> <triad>\ntabla --cycle <cycle> <triad>",
        descripcionTablaAcorde: "(--margen 2: more table around it)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <chord> [--voices 2]",
        descripcionVecinos: "chords a semitone away (sevenths: dominant, minor, half-diminished\nand diminished; triads: major, minor and augmented; a maj7, among\nthe sevenths and the maj7s; --extended: with the maj7s too)",
        sintaxisConduccionParsimoniosa: "smooth-path <chord> <chord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "from one chord to another moving one\nvoice (or two) a semitone at a time",
        sintaxisConduccionMinima: "minimal-voice-leading <chord> <chord>",
        descripcionConduccionMinima: "the voice leading with fewest semitones",
        sintaxisPlr: "plr <triad> <P, L, R…>",
        descripcionPlr: "neo-Riemannian transformations",
        sintaxisPlrCamino: "plr <triad> <triad>",
        descripcionPlrCamino: "the shortest path through P, L and R",
        sintaxisPlrCiclo: "plr <triad> <cycle>",
        descripcionPlrCiclo: "a cycle: hexatonic (P, L),\noctatonic (P, R) or \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <events> [options]",
        descripcionMusicxmlMelodia: "MusicXML score of a melody",
        sintaxisMusicxmlCoral: "musicxml chorale <chords> [options]",
        descripcionMusicxmlCoral: "four-part chorale in MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <symbols> [options]",
        descripcionMusicxmlAcordes: "progression with symbols and analysis",
        notasMusicxmlAcordes: "options: --compas 6/8 (time signature), --anacrusa 8 (pickup),\n--tonalidad G major (key), --clave fa (clef), --tempo 90 (or\n--tempo 60 4.), --titulo My chorale (title), --duracion 2 (how\nlong each chord lasts; a quarter note in the chorale and a half\nnote in the chords by default), --cifrados and --analisis (in\nthe chorale: chord symbols above, roman numerals and function below)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <symbols> [options]",
        descripcionMusicxmlArpegios: "the chords arpeggiated, note by note",
        notasMusicxmlArpegios: "options: --patron alberti (or up, down, up-down), --figura 16\n(how long each note lasts; an eighth note by default),\n--duracion 1 (how long each chord lasts: the pattern repeats\nto fill it) and the other options of \"chords\"",
        sintaxisMusicxmlArchivo: "musicxml chords --file <file>",
        descripcionMusicxmlArchivo: "the progression of a MIDI or MusicXML\nfile, with how long each chord lasts\n(also arpeggios, mei and midi)",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios <…> [options]",
        descripcionMeiMelodia: "the same in MEI 5, the format of\ncritical editions (with the same\noptions)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios <…> [options]",
        descripcionLilypondMelodia: "the same in LilyPond, to engrave the\nscore as a PDF",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios <…> [options]",
        descripcionAbcMelodia: "the same in ABC, the text notation of\ntraditional music",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios <…> [options]",
        descripcionMidiMelodia: "the same as a MIDI file, to listen to\n(without --clave or --cifrados; with\n--program 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <symbol>… [options]",
        descripcionDigitaciones: "ways to play a chord, from the most comfortable to the least, on a\nfretted string instrument (strings from low to high)\noptions: --instrument guitar|bass|ukulele|mandolin|…\n(also \"seven-string guitar\", \"five-string bass\",\n\"drop D\"), --limit 5, --fret 12 (the highest one used),\n--fingers 4 (how many can be used), --complete (with every note:\nby default the fifth may be left out), --diagram (one line per string),\n--capo 2 (frets counted from the capo), --musicxml (the first shape\nof each chord as a MusicXML tablature)",
        sintaxisPosiciones: "positions <scale> [--caged]",
        descripcionPosiciones: "the scale by positions on the guitar:\nthree notes per string (two in the\npentatonics) or CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: music theory from the command line.

        Usage: armonia <command> <arguments> [--ingles | --language es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Commands:
        """,
        pieDeLaAyuda: """
        Note names are accepted in Spanish or English (Do, C, Sib, Bb). With --ingles, the answer
        uses English notation, and so do messages and this help. With --language ca, gl, ast, an, eu,
        pt, fr, oc, it, de, el or ru, notes, names, messages and this help are in Catalan, Galician,
        Asturian, Aragonese, Basque, Portuguese, French, Occitan, Italian, German, Greek or Russian.
        With --texts, the texts use another language than the notes: --language es --texts en.
        In Spanish and English, --writing words|ascii|unicode writes notes as F sharp, F# or F♯
        (in Spanish, Fa sostenido, Fa# or Fa♯).
        With --subscripts, the octave is a subscript: A₄, F♯₃ (both A4 and A₄ are read).
        """,
        sintaxisAyuda: "help",
        descripcionAyuda: "this help",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "completion of commands and options\nfor the shell",
        sintaxisManual: "manual",
        descripcionManual: "this help as a manual page",
        manualNombre: "NAME",
        manualNotas: "NOTES",

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
        faltanNotas: "missing the notes: armonia identify C E G",
        dosNotas: "two notes are needed: armonia interval C E",
        faltaEscala: "missing the scale: armonia scale D dorian",
        faltaTonalidad: "missing the key: armonia key A minor",
        faltaTonalidadTrasEn: "missing the key after --in",
        faltanAcordesDelAnalisis: { ejemplo in "missing the chords: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "cannot read the file \"\(nombre)\"" },
        archivoConAcordes: "with --file, do not write chords",
        archivoSinAcordes: "the file has no chords",
        faltaTransporte: { ejemplo in "missing the interval (or the new tonic) and what to transpose: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "missing the chords: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "the margin is a number from 0 to 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "missing the notes: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "missing the chord: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "missing the scale: armonia \(orden) --scale D dorian" },
        clasesFueraDeRango: { ejemplo, orden in "pitch classes are numbers from 0 to 11: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "missing the triads: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "the cycle is hexatonic, octatonic or LR, from a triad: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "the sequence is made of major and minor triads: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "the shortest path goes from one major or minor triad to another: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "the cycle starts on a major or minor triad: armonia \(orden) --cycle hexatonic C" },

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
        marcasSoloMusicXML: "--cifrados and --analisis are for MusicXML, MEI, LilyPond and ABC",
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
        tipoDePartituraDesconocido: { tipo in "\"\(tipo)\": the export is a \"melody\", a \"chorale\", \"chords\" or their \"arpeggios\"" },

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
        capoFueraDeRango: "the capo is a number from 0 to 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Try \"armonia help\".",
        ordenDesconocida: { orden in "unknown command: \"\(orden)\"" },
        opcionDesconocida: { opcion in "unknown option: \"\(opcion)\"" },
        idiomaDesconocido: { idioma in "unknown language: \"\(idioma)\" (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el or ru)" },
        terminalDesconocida: { t in "unknown shell: \"\(t)\" (bash, zsh or fish)" },
        escrituraNoValida: { escritura in "invalid writing: \"\(escritura)\" (words, ascii or unicode; only with es and en)" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "chords",
        mensajeEscalas: "scales",
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
        mensajeTriadas: { n in Idioma.ingles.contar(n, "triad", "triads") }
    )
}
