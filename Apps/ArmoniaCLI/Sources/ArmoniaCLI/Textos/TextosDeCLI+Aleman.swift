// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en alemán. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let aleman = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <Akkorde> [--in <Tonart>]",
        descripcionAnalizar: "Stufenbezeichnung, Funktionen,\nKadenzen und Modulationen (mit ihrem\nDrehakkord; ohne --in)",
        sintaxisAnalizarArchivo: "analyze --file <Datei> [--window <Dauer>]",
        descripcionAnalizarArchivo: "dasselbe mit den Akkorden einer MIDI-\noder MusicXML-Datei (einer pro\nSchlag; --window 2: einer pro Halbe)",
        sintaxisArmonizar: "harmonize <Melodie> [--in <Tonart>] [--proposals 3]",
        descripcionArmonizar: "Akkorde für eine Melodie, die besten\nzuerst; mit Oktaven (E4) auch der\nvierstimmige Satz",
        sintaxisRealizar: "realize <Akkorde> [--in <Tonart>]",
        descripcionRealizar: "die Akkorde vierstimmig, ohne\nStimmführungsfehler",
        sintaxisRevisar: "check <Akkorde>",
        descripcionRevisar: "Stimmführungsfehler\n(Quintparallelen…); Akkorde von tief\nnach hoch, durch Kommas getrennt",
        sintaxisContrapunto: "counterpoint <Cantus> / <Kontrapunkt> [--species 1]",
        descripcionContrapunto: "Fehler im Gattungskontrapunkt (1 bis\n5) über einem Cantus firmus in\nganzen Noten; Noten ohne Dauer\nerhalten die der Gattung",
        sintaxisTransponer: "transpose <Intervall|Grundton> <Akkorde oder Töne>",
        descripcionTransponer: "versetzt Akkorde, eine Melodie oder\neinen Choral in eine andere Tonart:\nein Intervall (M2, -m3) oder der neue\nGrundton (D)",
        sintaxisRearmonizar: "reharmonize <Akkorde> [--in <Tonart>]",
        descripcionRearmonizar: "andere Harmonien für jeden Akkord:\nTritonussubstitution,\nZwischendominanten, modale Entlehnung\nund diatonische Substitutionen",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <Akkordsymbol>…",
        descripcionAcorde: "Noten, Art und Funktion jeder Note",
        sintaxisArpegio: "arpeggio <Akkordsymbol> [--pattern <Muster>]",
        descripcionArpegio: "Töne des Arpeggios und passende\nSkalen (--pattern ascending,\ndescending, up-down, alberti)",
        sintaxisIdentificar: "identify <Noten>",
        descripcionIdentificar: "Akkorde, die einige Noten bilden",
        sintaxisIntervalo: "interval <Note> <Note>",
        descripcionIntervalo: "Intervall zwischen zwei Noten oder\nTonhöhen",
        sintaxisEscala: "scale <Skala>",
        descripcionEscala: "Noten und Akkorde einer Skala",
        sintaxisTonalidad: "key <Tonart>",
        descripcionTonalidad: "Vorzeichen, verwandte Tonarten und\nStufen",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <Noten>",
        descripcionTonnetz: "SVG-Tonnetz einiger Noten",
        sintaxisTonnetzAcorde: "tonnetz --chord <Symbol> | --scale <Skala> | --pcs <Zahlen>",
        descripcionTonnetzAcorde: "eines Akkords, einer Skala oder einer\nTonklassenmenge",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <Dreiklänge> | --shortest <Dreiklang> <Dreiklang>",
        descripcionTonnetzRecorrido: "eine Folge von Dreiklängen mit Pfeilen\noder der kürzeste Weg über P, L und R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <Zyklus> <Dreiklang>",
        descripcionTonnetzCiclo: "ein hexatonischer, oktatonischer oder\nLR-Zyklus",
        notasTonnetzCiclo: "(--margen 2: mehr Netz rundherum)",
        sintaxisTabla: "tabla <Noten oder Tonhöhen>",
        descripcionTabla: "harmonische Tabelle in SVG (Sechsecke)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "wie beim Tonnetz (--margen 2: mehr\nTabelle rundherum)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <Akkord> [--voices 2]",
        descripcionVecinos: "Akkorde im Halbtonabstand\n(Septakkorde: dominant, Moll,\nhalbvermindert und vermindert;\nDreiklänge: Dur, Moll und übermäßig;\nein maj7 unter den Septakkorden und\nden maj7; --extended: auch mit den\nmaj7)",
        sintaxisConduccionParsimoniosa: "smooth-path <Akkord> <Akkord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "von einem Akkord zum anderen, bei\njedem Schritt eine Stimme (oder zwei)\num einen Halbton",
        sintaxisConduccionMinima: "minimal-voice-leading <Akkord> <Akkord>",
        descripcionConduccionMinima: "die Stimmführung mit den wenigsten\nHalbtönen",
        sintaxisPlr: "plr <Dreiklang> <P, L, R…>",
        descripcionPlr: "neo-riemannsche Transformationen",
        sintaxisPlrCamino: "plr <Dreiklang> <Dreiklang>",
        descripcionPlrCamino: "der kürzeste Weg über P, L und R",
        sintaxisPlrCiclo: "plr <Dreiklang> <Zyklus>",
        descripcionPlrCiclo: "ein Zyklus: hexatonic (P, L),\noctatonic (P, R) oder \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <Ereignisse> [Optionen]",
        descripcionMusicxmlMelodia: "MusicXML-Partitur einer Melodie",
        sintaxisMusicxmlCoral: "musicxml chorale <Akkorde> [Optionen]",
        descripcionMusicxmlCoral: "vierstimmiger Satz in MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <Symbole> [Optionen]",
        descripcionMusicxmlAcordes: "Akkordfolge mit Symbolen und Analyse",
        notasMusicxmlAcordes: "Optionen: --compas 6/8 (Taktart), --anacrusa 8 (Auftakt),\n--tonalidad G major (Tonart), --clave fa (Schlüssel), --tempo 90\n(oder --tempo 60 4.), --titulo Mein Choral (Titel), --duracion 2\n(Dauer jedes Akkords; standardmäßig eine Viertel im Choral und\neine Halbe bei den Akkorden), --cifrados und --analisis (im\nChoral: Akkordsymbole oben, Stufen und Funktion unten)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <Symbole> [Optionen]",
        descripcionMusicxmlArpegios: "die Akkorde arpeggiert, Ton für Ton",
        notasMusicxmlArpegios: "Optionen: --patron alberti (oder up, down, up-down), --figura 16\n(Dauer jedes Tons; standardmäßig eine Achtel), --duracion 1\n(Dauer jedes Akkords: das Muster wiederholt sich, bis er voll\nist) und die übrigen von „chords“",
        sintaxisMusicxmlArchivo: "musicxml chords --file <Datei>",
        descripcionMusicxmlArchivo: "die Akkordfolge einer MIDI- oder\nMusicXML-Datei mit der Dauer jedes\nAkkords (auch arpeggios, mei, midi)",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios <…> [Optionen]",
        descripcionMeiMelodia: "dasselbe in MEI 5, dem Format\nkritischer Ausgaben (mit denselben\nOptionen)",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios <…> [Optionen]",
        descripcionMidiMelodia: "dasselbe als MIDI-Datei zum Anhören\n(ohne --clave oder --cifrados; mit\n--program 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <Akkordsymbol>… [Optionen]",
        descripcionDigitaciones: "Griffe für einen Akkord, vom bequemsten zum unbequemsten, auf\neinem Saiteninstrument mit Bünden (Saiten von tief nach hoch)\nOptionen: --instrument guitar|bass|ukulele|mandolin|… (auch\n\"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5,\n--fret 12 (der höchste verwendete Bund), --fingers 4 (wie viele\nbenutzt werden dürfen), --complete (mit allen Noten:\nstandardmäßig darf die Quinte fehlen), --diagram (eine Zeile pro\nSaite),\n--capo 2 (Bünde ab dem Kapodaster), --musicxml (die erste Griffform\njedes Akkords als MusicXML-Tabulatur)",
        sintaxisPosiciones: "positions <Skala> [--caged]",
        descripcionPosiciones: "die Skala in Lagen auf der Gitarre:\ndrei Töne pro Saite (zwei bei\nPentatonik) oder CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: Musiktheorie auf der Kommandozeile.

        Aufruf: armonia <Befehl> <Argumente> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Befehle (Befehle und Optionen werden auf Spanisch oder Englisch geschrieben):
        """,
        pieDeLaAyuda: """
        Notennamen werden auf Spanisch, Katalanisch, Galicisch, Baskisch, Portugiesisch oder Englisch
        angenommen (Do, C, Sib, Bb, si bemol). Mit --idioma de verwendet die Antwort die deutsche
        Notation (B, H, Fis) und deutsche Meldungen; mit --ingles Englisch.
        Mit --textos stehen die Texte in einer anderen Sprache als die Noten: --idioma en --textos de.
        Auf Spanisch und Englisch schreibt --escritura palabras|ascii|unicode die Noten als
        Fa sostenido, Fa# oder Fa♯ (auf Englisch F sharp, F# oder F♯).
        Mit --subindices steht die Oktave als Index: La₄, Fa♯₃ (gelesen wird beides, La4 und La₄).
        """,
        sintaxisAyuda: "help",
        descripcionAyuda: "diese Hilfe",

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
        faltanNotas: "die Noten fehlen: armonia identify C E G",
        dosNotas: "zwei Noten sind nötig: armonia interval C E",
        faltaEscala: "die Skala fehlt: armonia scale D dorian",
        faltaTonalidad: "die Tonart fehlt: armonia key A minor",
        faltaTonalidadTrasEn: "die Tonart nach --in fehlt",
        faltanAcordesDelAnalisis: { ejemplo in "die Akkorde fehlen: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "die Datei „\(nombre)“ kann nicht gelesen werden" },
        archivoConAcordes: "mit --file keine Akkorde angeben",
        archivoSinAcordes: "die Datei enthält keine Akkorde",
        faltaTransporte: { ejemplo in "Intervall (oder neuer Grundton) und das zu Versetzende fehlen: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "die Akkorde fehlen: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "der Rand ist eine Zahl von 0 bis 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "die Noten fehlen: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "der Akkord fehlt: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "die Skala fehlt: armonia \(orden) --scale D dorian" },
        clasesFueraDeRango: { ejemplo, orden in "Tonklassen sind Zahlen von 0 bis 11: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "die Dreiklänge fehlen: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "der Zyklus ist hexatonisch, oktatonisch oder LR, ab einem Dreiklang: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "die Folge besteht aus Dur- und Molldreiklängen: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "der kürzeste Weg führt von einem Dur- oder Molldreiklang zu einem anderen: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "der Zyklus beginnt mit einem Dur- oder Molldreiklang: armonia \(orden) --cycle hexatonic C" },

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
        marcasSoloMusicXML: "--cifrados und --analisis sind für MusicXML und MEI",
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
        tipoDePartituraDesconocido: { tipo in "„\(tipo)“: exportiert wird eine „melody“, ein „chorale“, „chords“ oder ihre „arpeggios“" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "das Instrument fehlt: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "unbekanntes Instrument: „\(nombre)“ (\(lista(.aleman)))" },
        faltaLimite: "die Anzahl der Griffe fehlt: --limit 5",
        limiteFueraDeRango: "das Limit ist eine Zahl von 1 bis 200: --limit 5",
        faltanDedos: "die Anzahl der Finger fehlt: --fingers 3",
        dedosFueraDeRango: "die Finger sind eine Zahl von 1 bis 4: --fingers 3",
        faltaTraste: "der höchste Bund fehlt: --fret 12",
        trasteFueraDeRango: "der höchste Bund ist eine Zahl von 0 bis 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "das Akkordsymbol fehlt: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "die Skala fehlt: armonia positions G major",
        capoFueraDeRango: "der Kapodaster ist eine Zahl von 0 bis 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Versuche „armonia help“.",
        ordenDesconocida: { orden in "unbekannter Befehl: „\(orden)“" },
        opcionDesconocida: { opcion in "unbekannte Option: „\(opcion)“" },
        idiomaDesconocido: { idioma in "unbekannte Sprache: „\(idioma)“ (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el oder ru)" },
        escrituraNoValida: { escritura in "ungültige Schreibweise: „\(escritura)“ (palabras/words, ascii oder unicode; nur bei es oder en)" },

        // Mensaje.swift
        mensajeNotas: "Noten",
        mensajeAcordes: "Akkorde",
        mensajeEscalas: "Skalen",
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
        mensajeTriadas: { n in Idioma.aleman.contar(n, "Dreiklang", "Dreiklänge") }
    )
}
