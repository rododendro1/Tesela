import Armonia
// Los textos de ArmoniaCLI en griego. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let griego = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <συγχορδίες> [--in <τονικότητα>]",
        descripcionAnalizar: "ρωμαϊκή αρίθμηση, λειτουργίες, πτώσεις\nκαι μετατροπίες (με την κοινή τους\nσυγχορδία· χωρίς --in)",
        sintaxisAnalizarArchivo: "analyze --file <αρχείο> [--window <διάρκεια>]",
        descripcionAnalizarArchivo: "το ίδιο, με τις συγχορδίες ενός αρχείου\nMIDI ή MusicXML (μία ανά χρόνο;\n--window 2: μία ανά μισό)",
        sintaxisArmonizar: "harmonize <μελωδία> [--in <τονικότητα>] [--proposals 3]",
        descripcionArmonizar: "συγχορδίες για μια μελωδία, οι\nκαλύτερες πρώτα· με οκτάβες (E4), και\nτο τετράφωνο χορικό",
        sintaxisRealizar: "realize <συγχορδίες> [--in <τονικότητα>]",
        descripcionRealizar: "οι συγχορδίες σε τετραφωνία, χωρίς\nλάθη φωνητικής οδήγησης",
        sintaxisRevisar: "check <συγχορδίες>",
        descripcionRevisar: "λάθη φωνητικής οδήγησης (παράλληλες\nπέμπτες…)· συγχορδίες από χαμηλά προς\nψηλά, χωρισμένες με κόμματα",
        sintaxisContrapunto: "counterpoint <cantus> / <αντίστιξη> [--species 1]",
        descripcionContrapunto: "λάθη σε αντίστιξη ειδών (1 έως 5)\nπάνω σε cantus firmus σε ολόκληρα·\nνότες χωρίς διάρκεια παίρνουν του\nείδους",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <σύμβολο>…",
        descripcionAcorde: "νότες, είδος και ρόλος κάθε νότας",
        sintaxisArpegio: "arpeggio <σύμβολο> [--pattern <μοτίβο>]",
        descripcionArpegio: "νότες του αρπέζ και κλίμακες της\nσυγχορδίας (--pattern ascending,\ndescending, up-down, alberti)",
        sintaxisIdentificar: "identify <νότες>",
        descripcionIdentificar: "συγχορδίες που σχηματίζουν οι νότες",
        sintaxisIntervalo: "interval <νότα> <νότα>",
        descripcionIntervalo: "διάστημα ανάμεσα σε δύο νότες ή τονικά\nύψη",
        sintaxisEscala: "scale <κλίμακα>",
        descripcionEscala: "νότες και συγχορδίες μιας κλίμακας",
        sintaxisTonalidad: "key <τονικότητα>",
        descripcionTonalidad: "οπλισμός, σχετικές τονικότητες και\nβαθμίδες",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <νότες>",
        descripcionTonnetz: "Tonnetz σε SVG για κάποιες νότες",
        sintaxisTonnetzAcorde: "tonnetz --chord <σύμβολο> | --scale <κλίμακα> | --pcs <αριθμοί>",
        descripcionTonnetzAcorde: "μιας συγχορδίας, μιας κλίμακας ή ενός\nσυνόλου τονικών κλάσεων",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <τρίφωνα> | --shortest <τρίφωνο> <τρίφωνο>",
        descripcionTonnetzRecorrido: "μια ακολουθία τριφώνων με βέλη ή η\nσυντομότερη διαδρομή μέσω P, L και R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <κύκλος> <τρίφωνο>",
        descripcionTonnetzCiclo: "ένας εξατονικός, οκτατονικός ή LR\nκύκλος",
        notasTonnetzCiclo: "(--margen 2: περισσότερο δίκτυο γύρω)",
        sintaxisTabla: "tabla <νότες ή τονικά ύψη>",
        descripcionTabla: "αρμονικός πίνακας σε SVG (εξάγωνα)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "όπως στο Tonnetz (--margen 2:\nπερισσότερος πίνακας γύρω)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <συγχορδία> [--voices 2]",
        descripcionVecinos: "συγχορδίες σε απόσταση ημιτονίου\n(έβδομες: δεσπόζουσας, ελάσσονα,\nημιελαττωμένη και ελαττωμένη· τρίφωνα:\nμείζον, ελάσσον και αυξημένο· ένα\nmaj7, ανάμεσα στις έβδομες και στα\nmaj7· --extended: και με τα maj7)",
        sintaxisConduccionParsimoniosa: "smooth-path <συγχορδία> <συγχορδία> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "από μία συγχορδία σε άλλη,\nμετακινώντας σε κάθε βήμα μία φωνή (ή\nδύο) κατά ένα ημιτόνιο",
        sintaxisConduccionMinima: "minimal-voice-leading <συγχορδία> <συγχορδία>",
        descripcionConduccionMinima: "η φωνητική οδήγηση με τα λιγότερα\nημιτόνια",
        sintaxisPlr: "plr <τρίφωνο> <P, L, R…>",
        descripcionPlr: "νεο-ριμανικοί μετασχηματισμοί",
        sintaxisPlrCamino: "plr <τρίφωνο> <τρίφωνο>",
        descripcionPlrCamino: "η συντομότερη διαδρομή μέσω P, L και R",
        sintaxisPlrCiclo: "plr <τρίφωνο> <κύκλος>",
        descripcionPlrCiclo: "ένας κύκλος: hexatonic (P, L),\noctatonic (P, R) ή \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <συμβάντα> [επιλογές]",
        descripcionMusicxmlMelodia: "παρτιτούρα MusicXML μιας μελωδίας",
        sintaxisMusicxmlCoral: "musicxml chorale <συγχορδίες> [επιλογές]",
        descripcionMusicxmlCoral: "τετράφωνο χορικό σε MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <σύμβολα> [επιλογές]",
        descripcionMusicxmlAcordes: "αλληλουχία με σύμβολα και ανάλυση",
        notasMusicxmlAcordes: "επιλογές: --compas 6/8 (μέτρο), --anacrusa 8 (άρση), --tonalidad\nG major (τονικότητα), --clave fa (κλειδί), --tempo 90 (ή --tempo\n60 4.), --titulo Το χορικό μου (τίτλος), --duracion 2 (πόσο\nδιαρκεί κάθε συγχορδία· από προεπιλογή τέταρτο στο χορικό και\nμισό στις συγχορδίες), --cifrados και --analisis (στο χορικό:\nσύμβολα από πάνω, βαθμίδες και λειτουργία από κάτω)",
        sintaxisMeiMelodia: "mei melody|chorale|chords <…> [επιλογές]",
        descripcionMeiMelodia: "το ίδιο σε MEI 5, τη μορφή των\nκριτικών εκδόσεων (με τις ίδιες\nεπιλογές)",
        sintaxisMidiMelodia: "midi melody|chorale|chords <…> [επιλογές]",
        descripcionMidiMelodia: "το ίδιο ως αρχείο MIDI, για να το\nακούσεις (χωρίς --clave ή --cifrados·\nμε --program 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <σύμβολο>… [επιλογές]",
        descripcionDigitaciones: "τρόποι να παίξεις μια συγχορδία, από τον πιο άνετο στον\nλιγότερο, σε έγχορδο όργανο με τάστα (χορδές από χαμηλά προς\nψηλά)\nεπιλογές: --instrument guitar|bass|ukulele|mandolin|… (και\n\"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5,\n--fret 12 (το ψηλότερο τάστο που χρησιμοποιείται), --fingers 4\n(πόσα δάχτυλα μπορούν να χρησιμοποιηθούν), --complete (με όλες\nτις νότες: από προεπιλογή μπορεί να λείπει η πέμπτη), --diagram\n(μία γραμμή ανά χορδή)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: θεωρία της μουσικής από τη γραμμή εντολών.

        Χρήση: armonia <εντολή> <ορίσματα> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Εντολές (οι εντολές και οι επιλογές γράφονται στα ισπανικά ή στα αγγλικά):
        """,
        pieDeLaAyuda: """
        Τα ονόματα των νοτών γίνονται δεκτά στα ισπανικά, στα αγγλικά, στα ελληνικά και σε άλλες
        γλώσσες (Do, C, Sib, Bb, ντο, σι ύφεση). Με --idioma el, η απάντηση χρησιμοποιεί την ελληνική
        σημειογραφία και ελληνικά μηνύματα· με --ingles, αγγλικά.
        Με --textos, τα κείμενα βγαίνουν σε άλλη γλώσσα από τις νότες: --idioma en --textos el.
        Στα ισπανικά και στα αγγλικά, το --escritura palabras|ascii|unicode γράφει τις νότες
        Fa sostenido, Fa# ή Fa♯ (στα αγγλικά, F sharp, F# ή F♯).
        """,
        sintaxisAyuda: "help",
        descripcionAyuda: "αυτή η βοήθεια",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "λείπουν οι συγχορδίες: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "χρειάζονται δύο συγχορδίες: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "λείπουν οι νότες της μελωδίας: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "το --proposals πάει από 1 έως 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "λείπουν το cantus firmus και η αντίστιξη, χωρισμένα με /: " + ingles },
        especieFueraDeRango: "το --species πάει από 1 έως 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "λείπουν οι συγχορδίες: armonia realize C F G7 C" },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "λείπει το σύμβολο της συγχορδίας: armonia chord G7",
        faltaCifradoDelArpegio: "λείπει το σύμβολο της συγχορδίας: armonia arpeggio C7",
        patronDesconocido: { patron in "άγνωστο μοτίβο: «\(patron)» (ascending, descending, up-down ή alberti)" },
        faltanNotas: "λείπουν οι νότες: armonia identify C E G",
        dosNotas: "χρειάζονται δύο νότες: armonia interval C E",
        faltaEscala: "λείπει η κλίμακα: armonia scale D dorian",
        faltaTonalidad: "λείπει η τονικότητα: armonia key A minor",
        faltaTonalidadTrasEn: "λείπει η τονικότητα μετά το --in",
        faltanAcordesDelAnalisis: { ejemplo in "λείπουν οι συγχορδίες: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "δεν είναι δυνατή η ανάγνωση του αρχείου «\(nombre)»" },
        archivoConAcordes: "με το --file δεν γράφονται συγχορδίες",
        archivoSinAcordes: "το αρχείο δεν έχει συγχορδίες",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "το περιθώριο είναι αριθμός από 0 έως 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "λείπουν οι νότες: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "λείπει η συγχορδία: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "λείπει η κλίμακα: armonia \(orden) --scale D dorian" },
        clasesFueraDeRango: { ejemplo, orden in "οι τονικές κλάσεις είναι αριθμοί από 0 έως 11: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "λείπουν τα τρίφωνα: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "ο κύκλος είναι εξατονικός, οκτατονικός ή LR, από ένα τρίφωνο: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "η ακολουθία αποτελείται από μείζονα και ελάσσονα τρίφωνα: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "η συντομότερη διαδρομή πάει από ένα μείζον ή ελάσσον τρίφωνο σε άλλο: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "ο κύκλος ξεκινά από ένα μείζον ή ελάσσον τρίφωνο: armonia \(orden) --cycle hexatonic C" },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "κινούνται 1 ή 2 φωνές: --voices 2",
        unAcordeDeVecinos: { ejemplo in "χρειάζεται μία συγχορδία: armonia neighbors G7" },
        vecinosSinFamilia: "οι γειτονικές αναζητούνται ανάμεσα σε συγχορδίες έβδομης δεσπόζουσας, ελάσσονες, ημιελαττωμένες, ελαττωμένες και maj7, ή ανάμεσα σε μείζονα, ελάσσονα και αυξημένα τρίφωνα",
        dosAcordesDeCamino: { ejemplo in "χρειάζονται δύο συγχορδίες: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "οι δύο συγχορδίες πρέπει να είναι της ίδιας οικογένειας (έβδομες, με ή χωρίς maj7, ή τρίφωνα) και να συνδέονται",
        faltanPasosDePLR: { ejemplo in "χρειάζονται ένα τρίφωνο και κάποια βήματα ή άλλο τρίφωνο: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "τα P, L και R εφαρμόζονται σε μείζονα και ελάσσονα τρίφωνα: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "λείπει το «melody», «chorale» ή «chords»: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "το πρόγραμμα είναι αριθμός General MIDI από 0 έως 127: --program 52",
        marcasSoloMusicXML: "τα --cifrados και --analisis είναι για MusicXML και MEI",
        faltaValor: { opcion in "λείπει η τιμή του --\(opcion)" },
        tempoMalEscrito: "το τέμπο γράφεται «--tempo 90» ή «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "λείπουν οι νότες: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "τα --cifrados και --analisis είναι για «chorale»",
        duracionSoloCoral: "το --duracion είναι μόνο για «chorale»",
        claveDesconocida: { clave, claves in "άγνωστο κλειδί: «\(clave)» (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "λείπουν οι συγχορδίες: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "το --\(opcion) είναι μόνο για «melody»" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "λείπουν οι συγχορδίες: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "οι συγχορδίες έχουν πάντα σύμβολα και ανάλυση",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: εξάγεται «melody», «chorale» ή «chords»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "λείπει το όργανο: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "άγνωστο όργανο: «\(nombre)» (\(lista(.griego)))" },
        faltaLimite: "λείπει ο αριθμός δακτυλοθεσιών: --limit 5",
        limiteFueraDeRango: "το όριο είναι αριθμός από 1 έως 200: --limit 5",
        faltanDedos: "λείπει ο αριθμός δαχτύλων: --fingers 3",
        dedosFueraDeRango: "τα δάχτυλα είναι αριθμός από 1 έως 4: --fingers 3",
        faltaTraste: "λείπει το ψηλότερο τάστο: --fret 12",
        trasteFueraDeRango: "το ψηλότερο τάστο είναι αριθμός από 0 έως 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "λείπει το σύμβολο της συγχορδίας: \(digitaciones.1)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Δοκίμασε «armonia help».",
        ordenDesconocida: { orden in "άγνωστη εντολή: «\(orden)»" },
        opcionDesconocida: { opcion in "άγνωστη επιλογή: «\(opcion)»" },
        idiomaDesconocido: { idioma in "άγνωστη γλώσσα: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el ή ru)" },
        escrituraNoValida: { escritura in "μη έγκυρη γραφή: «\(escritura)» (palabras/words, ascii ή unicode· μόνο με es και en)" },

        // Mensaje.swift
        mensajeNotas: "νότες",
        mensajeAcordes: "συγχορδίες",
        mensajeEscalas: "κλίμακες",
        mensajeArmadura: "οπλισμός",
        mensajeRelativa: "σχετική",
        mensajeHomonima: "ομώνυμη",
        mensajeBajo: { nota in "μπάσο \(nota)" },
        mensajeBajoAjeno: "μπάσο εκτός συγχορδίας",
        mensajeSinAcordes: "Δεν σχηματίζουν καμία γνωστή συγχορδία.",
        mensajeSin: { notas in "χωρίς \(notas)" },
        mensajeSemitonos: { n in "\(n) ημιτόνια" },
        mensajeSinAlteraciones: "χωρίς αλλοιώσεις",
        mensajeSostenidos: { n in n == 1 ? "1 δίεση" : "\(n) διέσεις" },
        mensajeBemoles: { n in n == 1 ? "1 ύφεση" : "\(n) υφέσεις" },
        mensajeACuatroVoces: "Σε τετραφωνία (μπάσο, τενόρος, άλτο, σοπράνο):",
        mensajeSinDigitaciones: "δεν υπάρχουν άνετες δακτυλοθεσίες",
        mensajeDedos: { n in n == 1 ? "1 δάχτυλο" : "\(n) δάχτυλα" },
        mensajeCejilla: { traste in "μπαρέ στο \(traste)ο τάστο" },
        mensajeNingunPaso: "κανένα βήμα",
        mensajeUnPaso: "1 βήμα",
        mensajePasos: { n in "\(n) βήματα" },
        mensajeTriadas: { n in n == 1 ? "1 τρίφωνο" : "\(n) τρίφωνα" }
    )
}
