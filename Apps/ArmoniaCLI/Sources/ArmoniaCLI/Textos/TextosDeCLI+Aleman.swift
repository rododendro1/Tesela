// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en alemán. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let aleman = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <Akkorde> [--in <Tonart>] [--scales]",
        descripcionAnalizar: "Stufenbezeichnung, Funktionen, Kadenzen und Modulationen (mit ihrem Drehakkord; ohne --in)\n--scales: die Skala jedes Akkords, mit Spannungs- und Avoid-Tönen",
        notasAnalizar: "--guide-tones: zwei Leittonlinien, ab der Terz und ab der Septime",
        sintaxisAnalizarArchivo: "analyze --file <Datei> [--window <Dauer>]",
        descripcionAnalizarArchivo: "dasselbe mit den Akkorden einer MIDI-, MusicXML-, MEI- oder ABC-Datei (einer pro Schlag; --window 2: einer pro Halbe)",
        sintaxisArmonizar: "harmonize <Melodie> [--in <Tonart>] [--proposals 3]",
        descripcionArmonizar: "Akkorde für eine Melodie, die besten zuerst; mit Oktaven (E4) auch der vierstimmige Satz",
        sintaxisRealizar: "realize <Akkorde> [--in <Tonart>]",
        descripcionRealizar: "die Akkorde vierstimmig, ohne Stimmführungsfehler",
        sintaxisRevisar: "check <Akkorde>",
        descripcionRevisar: "Stimmführungsfehler (Quintparallelen…); Akkorde von tief nach hoch, durch Kommas getrennt",
        sintaxisContrapunto: "counterpoint <Cantus> / <Kontrapunkt> [--species 1]",
        descripcionContrapunto: "Fehler im Gattungskontrapunkt (1 bis 5) über einem Cantus firmus in ganzen Noten; Noten ohne Dauer erhalten die der Gattung",
        sintaxisTransponer: "transpose <Intervall|Grundton> <Akkorde oder Töne>",
        descripcionTransponer: "versetzt Akkorde, eine Melodie oder einen Choral in eine andere Tonart: ein Intervall (M2, -m3) oder der neue Grundton (D)",
        sintaxisRearmonizar: "reharmonize <Akkorde> [--in <Tonart>]",
        descripcionRearmonizar: "andere Harmonien für jeden Akkord: Tritonussubstitution, Zwischendominanten, modale Entlehnung und diatonische Substitutionen",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <Akkordsymbol>…",
        descripcionAcorde: "Noten, Art und Funktion jeder Note",
        notasAcorde: "Optionen: --voicings, --names, --keys, --substitutions (in der Tonart von --in C major, am Ende) und --compare C (gemeinsame Töne und Stimmführung); --bebop und --pentatonics (Skalen zum Improvisieren darüber)",
        sintaxisArpegio: "arpeggio <Akkordsymbol> [--pattern <Muster>]",
        descripcionArpegio: "Töne des Arpeggios und passende Skalen (--pattern ascending, descending, up-down, down-up, broken, alberti)",
        notasArpegio: "Optionen: --octaves 2 (1 bis 4), --no-octave, --from E (oder 3: beginnt mit diesem Ton), --tensions 9,13, --degrees 1-5-3-8 (ein eigener Verlauf) und --approach below, above oder enclosure (chromatische Töne, die zu jedem führen)",
        sintaxisIdentificar: "identify <Noten>",
        descripcionIdentificar: "Akkorde, die einige Noten bilden",
        notasIdentificar: "Optionen: --scales (die Skalen, die die Töne enthalten, statt Akkorden) und --file melody.mid (die Töne einer MIDI-, MusicXML-, MEI- oder ABC-Datei, mit --scales)",
        sintaxisIntervalo: "interval <Note> <Note>",
        descripcionIntervalo: "Intervall zwischen zwei Noten oder Tonhöhen",
        sintaxisEscala: "scale <Skala> [--chords]",
        descripcionEscala: "Noten und Akkorde einer Skala\n--chords: alle Akkorde, die auf jede Stufe passen, nicht nur Terzschichtungen",
        notasEscala: "Optionen: --sequence thirds (oder fourths, groups-of-3, groups-of-4, triads, sevenths), --descending, --octaves 2 (1 bis 4), --piano (Fingersatz), --modes (parallel und relativ) und --compare C lydian (am Ende); --symmetry (wie oft sie sich wiederholt, und ihre Akkorde); --neighbors (einen Ton verschoben) und --all-keys (in allen zwölf Tonarten); --all-keys --chords (die Akkorde jeder Stufe; --triads, ohne Septime)",
        sintaxisEscalas: "scales [<Text>] [Optionen]",
        descripcionEscalas: "der Skalenkatalog: die gängigen und die anderer Traditionen, nach Kategorien, mit ihren Tönen ab C",
        notasEscalas: "Optionen: --tradition turkey (oder india, greece, ancient-greece, arab-world, persia, azerbaijan, china, japan, korea, ethiopia, indonesia, klezmer, andes, byzantium, mesopotamia, africa, southeast-asia, gregorian, europe, vietnam, brazil) und --category maqam (oder rāga, makam, dastgah, dromos…); --use jazz (oder classical, blues, 20th-century, folk, synthetic) filtert die üblichen; --notes 5 lässt nur die mit fünf Tönen; ein Text sucht in den Namen",
        sintaxisTradiciones: "traditions [<Tradition>]",
        descripcionTradiciones: "die Traditionen des Katalogs mit ihren Kategorien und der Zahl ihrer Skalen; mit einer, ihre Skalen",
        sintaxisTonalidad: "key <Tonart>",
        descripcionTonalidad: "Vorzeichen, verwandte Tonarten und Stufen",
        sintaxisConjunto: "set <Klassen>",
        descripcionConjunto: "Primform, Forte-Nummer, Vektoren, Symmetrien und Noten",
        sintaxisSerie: "row <Reihe>",
        descripcionSerie: "Matrix, Formen und Kombinatorik einer Zwölftonreihe",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <Noten>",
        descripcionTonnetz: "SVG-Tonnetz einiger Noten",
        sintaxisTonnetzAcorde: "tonnetz --chord <Symbol> | --scale <Skala> | --pcs <Zahlen>",
        descripcionTonnetzAcorde: "eines Akkords, einer Skala oder einer Tonklassenmenge",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <Dreiklänge> | --shortest <Dreiklang> <Dreiklang>",
        descripcionTonnetzRecorrido: "eine Folge von Dreiklängen mit Pfeilen oder der kürzeste Weg über P, L und R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <Zyklus> <Dreiklang>",
        descripcionTonnetzCiclo: "ein hexatonischer, oktatonischer oder LR-Zyklus",
        notasTonnetzCiclo: "(--margen 2: mehr Netz rundherum)",
        sintaxisTabla: "tabla <Noten oder Tonhöhen>",
        descripcionTabla: "harmonische Tabelle in SVG (Sechsecke)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "wie beim Tonnetz (--margen 2: mehr Tabelle rundherum)",
        sintaxisCuadricula: "cuadricula <Noten oder Tonhöhen> | --chord | --scale | --pcs",
        descripcionCuadricula: "Rastertastatur in SVG (Pads), mit Umriss und erster Note",
        sintaxisCuadriculaOpciones: "cuadricula --axes H,V --grid CxR --origin <Tonhöhe>\ncuadricula --rotate 0-3 --mirror --in-key --scale <Skala>",
        descripcionCuadriculaOpciones: "Achsen (1,5: in Quarten), Raster des Controllers (8x8), Ecknote, Viertelumdrehungen, Spiegeln und in der Tonart",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <Akkord> [--voices 2]",
        descripcionVecinos: "Akkorde im Halbtonabstand (Septakkorde: dominant, Moll, halbvermindert und vermindert; Dreiklänge: Dur, Moll und übermäßig; ein maj7 unter den Septakkorden und den maj7; --extended: auch mit den maj7)",
        sintaxisConduccionParsimoniosa: "smooth-path <Akkord> <Akkord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "von einem Akkord zum anderen, bei jedem Schritt eine Stimme (oder zwei) um einen Halbton",
        sintaxisConduccionMinima: "minimal-voice-leading <Akkord> <Akkord>",
        descripcionConduccionMinima: "die Stimmführung mit den wenigsten Halbtönen",
        sintaxisPlr: "plr <Dreiklang> <P, L, R…>",
        descripcionPlr: "neo-riemannsche Transformationen",
        sintaxisPlrCamino: "plr <Dreiklang> <Dreiklang>",
        descripcionPlrCamino: "der kürzeste Weg über P, L und R",
        sintaxisPlrCiclo: "plr <Dreiklang> <Zyklus>",
        descripcionPlrCiclo: "ein Zyklus: hexatonic (P, L), octatonic (P, R) oder \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <Ereignisse> [Optionen]",
        descripcionMusicxmlMelodia: "MusicXML-Partitur einer Melodie",
        sintaxisMusicxmlCoral: "musicxml chorale <Akkorde> [Optionen]",
        descripcionMusicxmlCoral: "vierstimmiger Satz in MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <Symbole> [Optionen]",
        descripcionMusicxmlAcordes: "Akkordfolge mit Symbolen und Analyse",
        notasMusicxmlAcordes: "Optionen: --compas 6/8 (Taktart), --anacrusa 8 (Auftakt), --tonalidad G major (Tonart), --clave fa (Schlüssel), --tempo 90 (oder --tempo 60 4.), --titulo Mein Choral (Titel), --duracion 2 (Dauer jedes Akkords; standardmäßig eine Viertel), --cifrados und --analisis (im Choral: Akkordsymbole oben, Stufen und Funktion unten)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <Symbole> [Optionen]",
        descripcionMusicxmlArpegios: "die Akkorde arpeggiert, Ton für Ton",
        notasMusicxmlArpegios: "Optionen: --patron alberti (oder up, down, up-down), --figura 16 (Dauer jedes Tons; standardmäßig eine Achtel), --duracion 1 (Dauer jedes Akkords: das Muster wiederholt sich, bis er voll ist) und die übrigen von „chords“\n--connect: jedes Arpeggio beginnt mit dem Ton, der dem letzten des vorigen am nächsten liegt",
        sintaxisMusicxmlArchivo: "musicxml chords --file <Datei>",
        descripcionMusicxmlArchivo: "die Akkordfolge einer MIDI-, MusicXML-, MEI- oder ABC-Datei mit der Dauer jedes Akkords (auch arpeggios, mei, midi)",
        sintaxisMusicxmlEscala: "musicxml scale <Skala> [Optionen]",
        descripcionMusicxmlEscala: "eine Skala in Vierteln, mit ihren Mikrotönen: dem Halb-b eines Maqam, dem Koron, den Kommas eines Makam",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios|scale <…> [Optionen]",
        descripcionMeiMelodia: "dasselbe in MEI 5, dem Format kritischer Ausgaben (mit denselben Optionen)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios|scale <…> [Optionen]",
        descripcionLilypondMelodia: "dasselbe in LilyPond, um die Partitur als PDF zu setzen",
        sintaxisGuidoMelodia: "guido melody|chorale|chords|arpeggios|scale <…> [Optionen]",
        descripcionGuidoMelodia: "dasselbe in GUIDO (.gmn), zum Ansehen mit GuidoLib oder INScore",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios|scale <…> [Optionen]",
        descripcionAbcMelodia: "dasselbe in ABC, der Textnotation der Volksmusik",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios|scale <…> [Optionen]",
        descripcionMidiMelodia: "dasselbe als MIDI-Datei zum Anhören (ohne --clave oder --cifrados; mit --program 0…127, General MIDI)",
        sintaxisGrabar: "engrave melody|chorale|chords|arpeggios|scale <…>\nengrave staff|tonnetz|harmonic-table|keyboard|clock <…> [Optionen]",
        descripcionGrabar: "die Partitur als PDF, SVG oder PNG mit LilyPond, MuseScore, Verovio oder Guido, oder die Zeichnung mit rsvg-convert",
        notasGrabar: "--engine lilypond|musescore|verovio|guido|own, --format pdf|svg|png; Verovio und Guido liefern SVG, das rsvg-convert in PDF oder PNG umwandelt; armonia engines zeigt, welche installiert sind",
        sintaxisMotores: "engines",
        descripcionMotores: "die Engines von armonia engrave: wo jedes Programm liegt und seine Version, oder die Variable (ARMONIA_…), die seinen Pfad angibt",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <Akkordsymbol>… [Optionen]",
        descripcionDigitaciones: "Griffe für einen Akkord, vom bequemsten zum unbequemsten, auf einem Saiteninstrument mit Bünden (Saiten von tief nach hoch)\nOptionen: --instrument guitar|bass|ukulele|mandolin|… (auch \"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5, --fret 12 (der höchste verwendete Bund), --fingers 4 (wie viele benutzt werden dürfen), --complete (mit allen Noten: standardmäßig darf die Quinte fehlen), --diagram (eine Zeile pro Saite), --capo 2 (Bünde ab dem Kapodaster), --musicxml (die erste Griffform jedes Akkords als MusicXML-Tabulatur)",
        sintaxisPosiciones: "positions <Skala> [--caged]",
        descripcionPosiciones: "die Skala in Lagen auf der Gitarre: drei Töne pro Saite (zwei bei Pentatonik) oder CAGED",
        notasPosiciones: "Optionen: --sequence thirds (oder eine andere: die Sequenz in jeder Lage; mit --descending abwärts) und --shapes (die fünf Pentatonik-Formen und ihre gemeinsamen Töne); --instrument bass (oder ein anderes; auch open-d, open-g, dadgad) und --capo 2",
        sintaxisTeclado: "keyboard <Skala> [--hand right]",
        descripcionTeclado: "die Skala auf einer Klaviertastatur (SVG): ihre Töne oder, mit --hand right oder left, die Finger; --octaves 2",
        sintaxisReloj: "clock <scale> [--fifths]",
        descripcionReloj: "die Skala auf einer Zwölf-Stunden-Uhr (SVG): der chromatische Kreis oder, mit --fifths, der Quintenzirkel",
        sintaxisPentagrama: "staff scale|chord|arpeggio|chords <Noten>",
        descripcionPentagrama: "eine Skala, einen Akkord, ein Arpeggio (mit Rhythmus: --figure 16, --triplets) oder Akkorde mit ihren Symbolen auf einem Notensystem (SVG); --names, --intervals, --semitones, --tonic, --in <key>",
        sintaxisPentagramaEstudio: "staff <was> --roman|--hand|--sequence|--tab",
        descripcionPentagramaEstudio: "die Stufen in römischen Ziffern unter den Akkorden; der Fingersatz am Klavier (--hand right) oder an der Gitarre (--tab --fingers); die Skala in Terzen oder in Gruppen (--sequence thirds); die Tabulatur darunter (--tab, --instrument)",
        sintaxisPentagramaRegistro: "staff <was> --octave|--clef|--grand-staff|--clef-changes|--figured-bass",
        descripcionPentagramaRegistro: "die Oktave (--octave 2), der Schlüssel (--clef bass), das Klaviersystem, Schlüsselwechsel nach Lage und der Generalbass der Akkorde (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "staff melody <Noten> --over <Akkorde>",
        descripcionPentagramaMelodia: "eine Melodie (C4:8 D4:8…) mit einem Akkord pro Takt darüber; akkordfremde Töne grün (oder rot, wenn chromatisch); --non-chord macht das auch sonst",
        sintaxisPosicionesArpegio: "positions --arpeggio <Akkordsymbol> [--caged|--sweep]",
        descripcionPosicionesArpegio: "das Arpeggio eines Akkords in jeder Lage des Griffbretts, als Tabulatur mit den Fingern; --up-and-down, auf und ab",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: Musiktheorie auf der Kommandozeile.

        Aufruf: armonia <Befehl> <Argumente> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Befehle (Befehle und Optionen werden auf Spanisch oder Englisch geschrieben):
        """,
        pieDeLaAyuda: """
        Notennamen werden auf Spanisch, Katalanisch, Galicisch, Baskisch, Portugiesisch oder Englisch
        angenommen (Do, C, Sib, Bb, si bemol). Mit --idioma de verwendet die Antwort die deutsche
        Notation (B, H, Fis) und deutsche Meldungen; mit --ingles Englisch.
        Mit --textos stehen die Texte in einer anderen Sprache als die Noten: --idioma en --textos de.
        Auf Spanisch und Englisch schreibt --escritura palabras|ascii|unicode die Noten als
        Fa sostenido, Fa# oder Fa♯ (auf Englisch F sharp, F# oder F♯).
        In den anderen Sprachen wählt --escritura palabras|compacto Wörter oder die Kurzform:
        fa dièse oder Fa♯, F Kreuz oder Fis.
        In den kompakten Schreibweisen steht die Oktave als Index (La₄), sonst als Ziffer (La4);
        --subindices oder --cifras legen sie fest (gelesen wird beides).
        Mit --json geben chord, identify, arpeggio, interval, scale, key, analyze, set, row,
        fingerings und traditions ihre Daten als JSON aus.
        Mit --json auch harmonize, realize, check, counterpoint und transpose. Ist die Ausgabe kein
        Terminal, steht das JSON in einer einzigen Zeile.
        ARMONIA_IDIOMA=eu legt die Sprache ohne --idioma fest; ARMONIA_IDIOMA=system nimmt die von LANG.
        Exit-Codes: 0 gut, 1 unlesbarer Text, 2 falsch geschriebener Befehl und 3 Fehler gefunden (check,
        counterpoint).
        Ohne Argumente im Terminal öffnet armonia eine Sitzung: ein Befehl pro Zeile.
        Mit der Eingabe aus einer Datei (armonia < uebungen.txt) führt es deren Zeilen genauso aus; eine
        Zeile nur mit Optionen (--idioma eu) gilt für die folgenden weiter.
        Mit -o Datei wird die Ausgabe des Befehls in diese Datei geschrieben, auch in der Sitzung.
        Mit --idioma werden Noten auch in dieser Sprache gelesen: H7 und Fis auf Deutsch, ré auf Französisch.
        """,
        sintaxisAyuda: "help [<Befehl>]",
        descripcionAyuda: "diese Hilfe oder die eines Befehls (auch <Befehl> --help)",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "die Vervollständigung der Befehle und Optionen für die Shell",
        sintaxisManual: "manual",
        descripcionManual: "diese Hilfe als Manpage",
        manualNombre: "BEZEICHNUNG",
        manualNotas: "HINWEISE",
        manualEntorno: "UMGEBUNG",
        manualEstadoDeSalida: "EXIT-STATUS",
        manualIdiomaDelEntorno: "Die Sprache, wie --idioma (das sie überschreibt): es, en, eu…; mit system die aus LC_ALL, LC_MESSAGES oder LANG.",
        manualRutaDelPrograma: { p in "Der Pfad zu \(p), falls es nicht im PATH ist." },
        manualCodigosDeSalida: ["Alles ist gut gegangen.", "Ein Text oder eine Datei, die sich nicht lesen lässt, oder nichts auszugeben.", "Der Befehl ist falsch geschrieben.", "check oder counterpoint haben Fehler gefunden."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "die Akkorde fehlen: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "zwei Akkorde sind nötig: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "die Noten der Melodie fehlen: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "--proposals geht von 1 bis 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "Cantus firmus und Kontrapunkt fehlen, getrennt durch /: " + ingles },
        especieFueraDeRango: "--species geht von 1 bis 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "die Akkorde fehlen: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "das Akkordsymbol fehlt: armonia chord G7",
        faltaCifradoDelArpegio: "das Akkordsymbol fehlt: armonia arpeggio C7",
        patronDesconocido: { patron in "unbekanntes Muster: „\(patron)“ (ascending, descending, up-down, down-up, broken oder alberti)" },
        tradicionDesconocida: { tradicion in "„\(tradicion)“ ist keine Tradition (india, greece, arab-world, persia, turkey…)" },
        categoriaDesconocida: { categoria in "„\(categoria)“ ist keine Skalenkategorie (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "„\(uso)“ ist keine Verwendung von Skalen (classical, jazz, blues, 20th-century, folk, synthetic)" },
        faltanNotas: "die Noten fehlen: armonia identify C E G",
        dosNotas: "zwei Noten sind nötig: armonia interval C E",
        faltaEscala: "die Skala fehlt: armonia scale D dorian",
        faltaTonalidad: "die Tonart fehlt: armonia key A minor",
        faltaTonalidadTrasEn: "die Tonart nach --in fehlt",
        faltaConjunto: "die Menge fehlt: armonia set 0 4 7",
        faltaSerie: "die Reihe fehlt: armonia row 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "die Akkorde fehlen: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "die Datei „\(nombre)“ kann nicht gelesen werden" },
        archivoNoEscrito: { nombre in "die Datei „\(nombre)“ kann nicht geschrieben werden" },
        archivoConAcordes: "mit --file keine Akkorde angeben",
        archivoSinAcordes: "die Datei enthält keine Akkorde",
        faltaTransporte: { ejemplo in "Intervall (oder neuer Grundton) und das zu Versetzende fehlen: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "die Akkorde fehlen: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "der Rand ist eine Zahl von 0 bis 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "die Noten fehlen: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "der Akkord fehlt: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "die Skala fehlt: armonia \(orden) --scale D dorian" },
        faltanClasesDelDibujo: { ejemplo, orden in "die Tonhöhenklassen fehlen: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "die Dreiklänge fehlen: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "der Zyklus ist hexatonisch, oktatonisch oder LR, ab einem Dreiklang: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "die Folge besteht aus Dur- und Molldreiklängen: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "der kürzeste Weg führt von einem Dur- oder Molldreiklang zu einem anderen: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "der Zyklus beginnt mit einem Dur- oder Molldreiklang: armonia \(orden) --cycle hexatonic C" },
        opcionesDeCuadricula: "Rasteroptionen: --axes H,V (1,5), --grid CxR (8x8), --origin <Tonhöhe> (C2), --rotate 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "es bewegen sich 1 oder 2 Stimmen: --voices 2",
        unAcordeDeVecinos: { ejemplo in "ein Akkord ist nötig: armonia neighbors G7" },
        vecinosSinFamilia: "Nachbarn werden unter Dominant-, Moll-, halbverminderten, verminderten und maj7-Septakkorden gesucht oder unter Dur-, Moll- und übermäßigen Dreiklängen",
        dosAcordesDeCamino: { ejemplo in "zwei Akkorde sind nötig: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "beide Akkorde müssen zur selben Familie gehören (Septakkorde, mit oder ohne maj7, oder Dreiklänge) und verbunden sein",
        faltanPasosDePLR: { ejemplo in "ein Dreiklang und Schritte oder ein weiterer Dreiklang sind nötig: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "P, L und R gelten für Dur- und Molldreiklänge: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "„melody“, „chorale“ oder „chords“ fehlt: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "das Programm ist eine General-MIDI-Nummer von 0 bis 127: --program 52",
        marcasSoloMusicXML: "--cifrados und --analisis sind für MusicXML, MEI, LilyPond, GUIDO und ABC",
        faltaValor: { opcion in "der Wert von --\(opcion) fehlt" },
        tempoMalEscrito: "das Tempo wird „--tempo 90“ oder „--tempo 60 4.“ geschrieben",
        faltanNotasDeLaMelodia: { ejemplo, orden in "die Noten fehlen: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "--cifrados und --analisis sind für „chorale“",
        duracionSoloCoral: "--duracion ist nur für „chorale“",
        claveDesconocida: { clave, claves in "unbekannter Schlüssel: „\(clave)“ (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "die Akkorde fehlen: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "--\(opcion) ist nur für „melody“" },
        soloParaArpegios: { opcion in "--\(opcion) ist nur für „arpeggios“" },
        archivoSoloParaAcordes: "--file ist nur für „chords“ und „arpeggios“",
        ventanaSinArchivo: "--window gehört zu --file",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "die Akkorde fehlen: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "Akkorde kommen immer mit Akkordsymbolen und Analyse",
        tipoDePartituraDesconocido: { tipo in "„\(tipo)“: exportiert wird eine „melody“, ein „chorale“, „chords“, ihre „arpeggios“ oder eine „scale“" },
        faltaLoQueSeGraba: "es fehlt, was gesetzt werden soll: armonia engrave chorale C3 E4 G4 C5 > chorale.pdf",
        motorDesconocido: { motor in "„\(motor)“: die Engines sind lilypond, musescore, verovio, guido und own" },
        formatoDeGrabadoDesconocido: { formato in "„\(formato)“: ausgegeben wird „pdf“, „svg“ oder „png“" },
        nadaQueGrabar: { orden in "„\(orden)“: gesetzt wird eine Partitur (melody, chorale, chords, arpeggios, scale) oder eine Zeichnung (staff, tonnetz, harmonic-table, keyboard, grid, clock)" },
        motorNoEncontrado: { programa, variable in "„\(programa)“ nicht gefunden: installiere es oder gib seinen Pfad in \(variable) an" },
        motorFallo: { programa, codigo in "„\(programa)“ wurde mit Code \(codigo) beendet:" },
        motorSinTerminar: { programa in "„\(programa)“ wurde nicht rechtzeitig fertig und abgebrochen" },
        motorNoInstalado: { variable in "nicht installiert (oder den Pfad in \(variable) angeben)" },
        motorPropio: "own",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "das Instrument fehlt: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "unbekanntes Instrument: „\(nombre)“ (\(lista(.alemanPalabras)))" },
        faltaLimite: "die Anzahl der Griffe fehlt: --limit 5",
        limiteFueraDeRango: "das Limit ist eine Zahl von 1 bis 200: --limit 5",
        faltanDedos: "die Anzahl der Finger fehlt: --fingers 3",
        dedosFueraDeRango: "die Finger sind eine Zahl von 1 bis 4: --fingers 3",
        faltaTraste: "der höchste Bund fehlt: --fret 12",
        trasteFueraDeRango: "der höchste Bund ist eine Zahl von 0 bis 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "das Akkordsymbol fehlt: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "die Skala fehlt: armonia positions G major",
        faltaEscalaDelTeclado: "die Skala fehlt: armonia keyboard D major",
        manoDesconocida: { texto in "unbekannte Hand: „\(texto)“ (right oder left)" },
        archivoConNotas: "mit --file keine Töne angeben",
        noEsPentatonica: "die Formen gibt es nur bei fünftönigen Skalen: armonia positions A minor pentatonic --shapes",
        faltaEscalaDelReloj: "die Skala fehlt: armonia clock D major",
        faltaLoQueDibujaElPentagrama: "es fehlt, was gezeichnet werden soll: armonia staff scale D dorian",
        capoFueraDeRango: "der Kapodaster ist eine Zahl von 0 bis 12: --capo 2",
        octavasFueraDeRango: "die Oktaven sind eine Zahl von 1 bis 4: --octaves 2",
        notasFueraDeRango: "die Töne sind eine Zahl von 1 bis 24: --notes 5",
        octavaFueraDeRango: "die Oktave ist eine Zahl von 0 bis 7: --octave 3",
        desdeNoValido: { desde in "„\(desde)“ ist weder ein Ton noch eine Stufe des Akkords: --from E oder --from 3" },
        tensionesMalEscritas: "die Optionstöne sind 9, 11 oder 13: --tensions 9,13",
        gradosMalEscritos: "die Stufen sind Zahlen von 1 bis 22: --degrees 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "unbekannte Annäherung: „\(aproximacion)“ (below, above oder enclosure)" },
        secuenciaDesconocida: { secuencia in "unbekannte Sequenz: „\(secuencia)“ (thirds, fourths, groups-of-3, groups-of-4, triads oder sevenths)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Versuche „armonia help“.",
        ordenDesconocida: { orden in "unbekannter Befehl: „\(orden)“" },
        opcionDesconocida: { opcion in "unbekannte Option: „\(opcion)“" },
        idiomaDesconocido: { idioma in "unbekannte Sprache: „\(idioma)“ (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru oder hu)" },
        terminalDesconocida: { t in "unbekannte Shell: „\(t)“ (bash, zsh oder fish)" },
        escrituraNoValida: { escritura in "ungültige Schreibweise: „\(escritura)“ (palabras/words oder compacto/compact; ascii oder unicode, nur bei es oder en)" },
        sinSalidaJSON: { orden in "„\(orden)“ hat keine JSON-Ausgabe" },

        // Mensaje.swift
        mensajeNotas: "Noten",
        mensajeAcordes: "Akkorde",
        mensajeMicrotonos: "Mikrotöne",
        mensajeEscalas: "Skalen",
        mensajeHabituales: "gängige",
        mensajeNingunaEscala: "keine Skala passt dazu",
        mensajeArmadura: "Vorzeichen",
        mensajeRelativa: "Paralleltonart",
        mensajeHomonima: "Varianttonart",
        mensajeBajo: { nota in "Bass \(nota)" },
        mensajeBajoAjeno: "Bass nicht im Akkord",
        mensajeSinAcordes: "Kein bekannter Akkord.",
        mensajeSin: { notas in "ohne \(notas)" },
        mensajeSemitonos: { n in "\(n) Halbtöne" },
        mensajeSinAlteraciones: "keine Vorzeichen",
        mensajeSostenidos: { n in Idioma.aleman.contar(n, "Kreuz", "Kreuze") },
        mensajeBemoles: { n in "\(n) Be" },
        mensajeACuatroVoces: "Vierstimmig (Bass, Tenor, Alt, Sopran):",
        mensajeSinDigitaciones: "keine bequemen Griffe gefunden",
        mensajeDedos: { n in Idioma.aleman.contar(n, "Finger", "Finger") },
        mensajeCejilla: { traste in "Barré im \(traste). Bund" },
        mensajeNingunPaso: "keine Schritte",
        mensajeUnPaso: "1 Schritt",
        mensajePasos: { n in "\(n) Schritte" },
        mensajeTriadas: { n in Idioma.aleman.contar(n, "Dreiklang", "Dreiklänge") },
        mensajeFormaNormal: "Normalform",
        mensajeFormaPrima: "Primform",
        mensajeVectorIntervalico: "Intervallvektor",
        mensajeVectorDeIndice: "Indexvektor",
        mensajeEjesDeSimetria: "Symmetrieachsen",
        mensajeIntervalos: "Intervalle",
        mensajeDeTodosLosIntervalos: "Allintervallreihe",
        mensajeFormasDistintas: { n in "\(n) verschiedene Formen" },
        mensajeHexacordos: "Hexachorde",
        mensajeFormasCombinatorias: "kombinatorische Formen",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "die Version von armonia",
        quisoDecir: { x in "Meintest du „\(x)“?" },
        pruebaLaAyudaDe: { o in "Versuche „armonia help \(o)“." },
        salidaBinaria: "die Ausgabe ist eine Binärdatei (MIDI, PDF oder PNG); speichere sie mit > Datei",
        escalasPorNotas: { e in "keine Skala heißt so; um eine nach ihren Tönen zu suchen: \(e)" },
        grabarUnaPartitura: { o, e in "„armonia \(o)“ schreibt die Partitur schon; „engrave“ setzt sie als PDF, SVG oder PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Abfragen", "Harmonik und Stimmen", "Partituren und Notensatz", "Zeichnungen (SVG)", "Neo-Riemann-Theorie", "Bundinstrumente", "Terminal und Hilfe"],
        pieDelIndice: """
        Die Hilfe zu einem Befehl: armonia help <Befehl> (oder armonia <Befehl> --help).
        Die ganze Hilfe, mit den Optionen jedes Befehls: armonia help --all.
        Für alle Befehle: --ingles, --idioma, --textos, --escritura, --subindices, --cifras und --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Ein Befehl pro Zeile, ohne „armonia“ (help: die Befehle; exit: beenden)." }
    )
}
