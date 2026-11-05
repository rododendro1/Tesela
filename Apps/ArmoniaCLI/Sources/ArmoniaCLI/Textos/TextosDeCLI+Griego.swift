// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en griego. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let griego = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <συγχορδίες> [--in <τονικότητα>] [--scales]",
        descripcionAnalizar: "ρωμαϊκή αρίθμηση, λειτουργίες, πτώσεις\nκαι μετατροπίες (με την κοινή τους\nσυγχορδία· χωρίς --in)\n--scales: η κλίμακα κάθε συγχορδίας,\nμε τις εντάσεις και τους φθόγγους\nπρος αποφυγή",
        notasAnalizar: "--guide-tones: δύο γραμμές νοτών-οδηγών,\nαπό την τρίτη και από την έβδομη",
        sintaxisAnalizarArchivo: "analyze --file <αρχείο> [--window <διάρκεια>]",
        descripcionAnalizarArchivo: "το ίδιο, με τις συγχορδίες ενός αρχείου\nMIDI, MusicXML, MEI ή ABC (μία ανά\nχρόνο; --window 2: μία ανά μισό)",
        sintaxisArmonizar: "harmonize <μελωδία> [--in <τονικότητα>] [--proposals 3]",
        descripcionArmonizar: "συγχορδίες για μια μελωδία, οι\nκαλύτερες πρώτα· με οκτάβες (E4), και\nτο τετράφωνο χορικό",
        sintaxisRealizar: "realize <συγχορδίες> [--in <τονικότητα>]",
        descripcionRealizar: "οι συγχορδίες σε τετραφωνία, χωρίς\nλάθη φωνητικής οδήγησης",
        sintaxisRevisar: "check <συγχορδίες>",
        descripcionRevisar: "λάθη φωνητικής οδήγησης (παράλληλες\nπέμπτες…)· συγχορδίες από χαμηλά προς\nψηλά, χωρισμένες με κόμματα",
        sintaxisContrapunto: "counterpoint <cantus> / <αντίστιξη> [--species 1]",
        descripcionContrapunto: "λάθη σε αντίστιξη ειδών (1 έως 5)\nπάνω σε cantus firmus σε ολόκληρα·\nνότες χωρίς διάρκεια παίρνουν του\nείδους",
        sintaxisTransponer: "transpose <διάστημα|τονική> <συγχορδίες ή νότες>",
        descripcionTransponer: "μεταφέρει συγχορδίες, μελωδία ή\nχορικό σε άλλη τονικότητα: ένα\nδιάστημα (M2, -m3) ή η νέα τονική (D)",
        sintaxisRearmonizar: "reharmonize <συγχορδίες> [--in <τονικότητα>]",
        descripcionRearmonizar: "άλλες αρμονίες για κάθε συγχορδία:\nτριτονική υποκατάσταση, δευτερεύουσες\nδεσπόζουσες, τροπικός δανεισμός και\nδιατονικές υποκαταστάσεις",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <σύμβολο>…",
        descripcionAcorde: "νότες, είδος και ρόλος κάθε νότας",
        notasAcorde: "επιλογές: --voicings, --names, --keys, --substitutions\n(στην τονικότητα του --in C major, στο τέλος) και --compare C\n(κοινές νότες και οδήγηση φωνών); --bebop και --pentatonics\n(κλίμακες για αυτοσχεδιασμό)",
        sintaxisArpegio: "arpeggio <σύμβολο> [--pattern <μοτίβο>]",
        descripcionArpegio: "νότες του αρπέζ και κλίμακες της\nσυγχορδίας (--pattern ascending,\ndescending, up-down, down-up,\nbroken, alberti)",
        notasArpegio: "επιλογές: --octaves 2 (από 1 έως 4), --no-octave, --from E\n(ή 3: ξεκινά από αυτή τη νότα), --tensions 9,13, --degrees\n1-5-3-8 (δική σας πορεία) και --approach below, above ή\nenclosure (χρωματικές νότες που οδηγούν σε καθεμία)",
        sintaxisIdentificar: "identify <νότες>",
        descripcionIdentificar: "συγχορδίες που σχηματίζουν οι νότες",
        notasIdentificar: "επιλογές: --scales (οι κλίμακες που περιέχουν\nτις νότες, αντί για συγχορδίες) και --file\nmelody.mid (οι νότες ενός αρχείου MIDI,\nMusicXML, MEI ή ABC, με --scales)",
        sintaxisIntervalo: "interval <νότα> <νότα>",
        descripcionIntervalo: "διάστημα ανάμεσα σε δύο νότες ή τονικά\nύψη",
        sintaxisEscala: "scale <κλίμακα> [--chords]",
        descripcionEscala: "νότες και συγχορδίες μιας κλίμακας\n--chords: όλες όσες χωρούν σε κάθε\nβαθμίδα, όχι μόνο κατά τρίτες",
        notasEscala: "επιλογές: --sequence thirds (ή fourths, groups-of-3,\ngroups-of-4, triads, sevenths), --descending, --octaves 2\n(από 1 έως 4), --piano (δακτυλοθεσία), --modes (παράλληλοι και σχετικοί)\nκαι --compare C lydian (στο τέλος); --symmetry (κάθε πόσο\nεπαναλαμβάνεται και οι συγχορδίες της);\n--neighbors (μετακινώντας μία νότα) και\n--all-keys (και στις δώδεκα τονικότητες);\n--all-keys --chords (οι συγχορδίες κάθε\nβαθμίδας· --triads, χωρίς έβδομη)",
        sintaxisEscalas: "scales [<κείμενο>] [επιλογές]",
        descripcionEscalas: "ο κατάλογος των κλιμάκων: οι συνήθεις\nκαι όσες άλλων παραδόσεων, ανά\nκατηγορία, με τις νότες τους από το Ντο",
        notasEscalas: "επιλογές: --tradition turkey (ή india, greece, ancient-greece,\narab-world, persia, azerbaijan, china, japan, korea, ethiopia,\nindonesia, klezmer, andes,\nbyzantium, mesopotamia, africa,\nsoutheast-asia, gregorian) και --category maqam (ή rāga, makam,\ndastgah, dromos…)· ένα κείμενο ψάχνει στα ονόματα",
        sintaxisTradiciones: "traditions [<παράδοση>]",
        descripcionTradiciones: "οι παραδόσεις του καταλόγου, με\nτις κατηγορίες τους και πόσες\nκλίμακες έχει η καθεμία· με μία,\nοι κλίμακές της",
        sintaxisTonalidad: "key <τονικότητα>",
        descripcionTonalidad: "οπλισμός, σχετικές τονικότητες και\nβαθμίδες",
        sintaxisConjunto: "set <κλάσεις>",
        descripcionConjunto: "πρωταρχική μορφή, αριθμός Forte,\nδιανύσματα, συμμετρίες και νότες",
        sintaxisSerie: "row <σειρά>",
        descripcionSerie: "πίνακας, μορφές και συνδυαστικότητα\nδωδεκάφθογγης σειράς",

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
        sintaxisCuadricula: "cuadricula <νότες ή τονικά ύψη> | --chord | --scale | --pcs",
        descripcionCuadricula: "πληκτρολόγιο πλέγματος σε SVG (pads),\nμε το περίγραμμα και την πρώτη νότα",
        sintaxisCuadriculaOpciones: "cuadricula --axes H,V --grid CxR --origin <τονικό ύψος>\ncuadricula --rotate 0-3 --mirror --in-key --scale <κλίμακα>",
        descripcionCuadriculaOpciones: "άξονες (1,5: σε τέταρτες), πλέγμα του\nελεγκτή (8x8), νότα της γωνίας,\nτέταρτα στροφής, καθρέφτης και στην κλίμακα",

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
        notasMusicxmlAcordes: "επιλογές: --compas 6/8 (μέτρο), --anacrusa 8 (άρση), --tonalidad\nG major (τονικότητα), --clave fa (κλειδί), --tempo 90 (ή --tempo\n60 4.), --titulo Το χορικό μου (τίτλος), --duracion 2 (πόσο\nδιαρκεί κάθε συγχορδία· από προεπιλογή τέταρτο), --cifrados και\n--analisis (στο χορικό: σύμβολα από πάνω, βαθμίδες και\nλειτουργία από κάτω)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <σύμβολα> [επιλογές]",
        descripcionMusicxmlArpegios: "οι συγχορδίες σε αρπίσματα, νότα νότα",
        notasMusicxmlArpegios: "επιλογές: --patron alberti (ή up, down, up-down), --figura 16\n(πόσο διαρκεί κάθε νότα· από προεπιλογή όγδοο), --duracion 1\n(πόσο διαρκεί κάθε συγχορδία: το σχήμα επαναλαμβάνεται ώσπου\nνα τη γεμίσει) και οι υπόλοιπες των «chords»\n--connect: κάθε αρπέζ ξεκινά από τη νότα που βρίσκεται πιο\nκοντά στην τελευταία του προηγούμενου",
        sintaxisMusicxmlArchivo: "musicxml chords --file <αρχείο>",
        descripcionMusicxmlArchivo: "η αλληλουχία ενός αρχείου MIDI,\nMusicXML, MEI ή ABC, με τη διάρκεια\nκάθε συγχορδίας (και arpeggios, mei,\nmidi)",
        sintaxisMusicxmlEscala: "musicxml scale <κλίμακα> [επιλογές]",
        descripcionMusicxmlEscala: "μια κλίμακα σε τέταρτα, με τα\nμικροτόνιά της: την ημιύφεση ενός\nμακάμ, το κορόν, τα κόμματα ενός μακάμ",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios|scale <…> [επιλογές]",
        descripcionMeiMelodia: "το ίδιο σε MEI 5, τη μορφή των\nκριτικών εκδόσεων (με τις ίδιες\nεπιλογές)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios|scale <…> [επιλογές]",
        descripcionLilypondMelodia: "το ίδιο σε LilyPond, για να χαραχθεί\nη παρτιτούρα σε PDF",
        sintaxisGuidoMelodia: "guido melody|chorale|chords|arpeggios|scale <…> [επιλογές]",
        descripcionGuidoMelodia: "το ίδιο σε GUIDO (.gmn), για προβολή\nμε το GuidoLib ή το INScore",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios|scale <…> [επιλογές]",
        descripcionAbcMelodia: "το ίδιο σε ABC, τη γραφή με κείμενο\nτης παραδοσιακής μουσικής",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios|scale <…> [επιλογές]",
        descripcionMidiMelodia: "το ίδιο ως αρχείο MIDI, για να το\nακούσεις (χωρίς --clave ή --cifrados·\nμε --program 0…127, General MIDI)",
        sintaxisGrabar: "engrave melody|chorale|chords|arpeggios|scale <…>\nengrave staff|tonnetz|harmonic-table|keyboard|clock <…> [επιλογές]",
        descripcionGrabar: "η παρτιτούρα σε PDF, SVG ή PNG με\nLilyPond, MuseScore, Verovio ή Guido,\nή το σχέδιο με το rsvg-convert",
        notasGrabar: "--engine lilypond|musescore|verovio|guido|own,\n--format pdf|svg|png· το Verovio και το Guido\nδίνουν SVG, που το rsvg-convert μετατρέπει σε PDF\nή PNG· το armonia engines δείχνει ποιες είναι\nεγκατεστημένες",
        sintaxisMotores: "engines",
        descripcionMotores: "οι μηχανές του armonia engrave: πού\nβρίσκεται κάθε πρόγραμμα και η έκδοσή\nτου, ή η μεταβλητή (ARMONIA_…) που\nδίνει τη διαδρομή του",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <σύμβολο>… [επιλογές]",
        descripcionDigitaciones: "τρόποι να παίξεις μια συγχορδία, από τον πιο άνετο στον\nλιγότερο, σε έγχορδο όργανο με τάστα (χορδές από χαμηλά προς\nψηλά)\nεπιλογές: --instrument guitar|bass|ukulele|mandolin|… (και\n\"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5,\n--fret 12 (το ψηλότερο τάστο που χρησιμοποιείται), --fingers 4\n(πόσα δάχτυλα μπορούν να χρησιμοποιηθούν), --complete (με όλες\nτις νότες: από προεπιλογή μπορεί να λείπει η πέμπτη), --diagram\n(μία γραμμή ανά χορδή),\n--capo 2 (τάστα από το καποτάστο), --musicxml (η πρώτη μορφή κάθε\nσυγχορδίας ως ταμπλατούρα MusicXML)",
        sintaxisPosiciones: "positions <κλίμακα> [--caged]",
        descripcionPosiciones: "η κλίμακα σε θέσεις στην κιθάρα:\nτρεις νότες ανά χορδή (δύο στις\nπεντατονικές) ή CAGED",
        notasPosiciones: "επιλογές: --sequence thirds (ή άλλη:\nη αλληλουχία σε κάθε θέση· με\n--descending, κατεβαίνοντας) και --shapes (τα πέντε\nσχήματα της πεντατονικής και οι κοινές νότες);\n--instrument bass (ή άλλο·\nεπίσης open-d, open-g, dadgad) και --capo 2",
        sintaxisTeclado: "keyboard <κλίμακα> [--hand right]",
        descripcionTeclado: "η κλίμακα σε πληκτρολόγιο πιάνου\n(SVG): οι νότες ή, με --hand right\nή left, τα δάχτυλα· --octaves 2",
        sintaxisReloj: "clock <scale> [--fifths]",
        descripcionReloj: "η κλίμακα σε ρολόι δώδεκα ωρών\n(SVG): ο χρωματικός κύκλος ή, με\n--fifths, ο κύκλος των πεμπτών",
        sintaxisPentagrama: "staff scale|chord|arpeggio|chords <νότες>",
        descripcionPentagrama: "μια κλίμακα, μια συγχορδία, ένα αρπίσμα\n(με ρυθμό: --figure 16, --triplets) ή\nσυγχορδίες με τα σύμβολά τους σε πεντάγραμμο\n(SVG); --names, --intervals,\n--semitones, --tonic, --in <key>",
        sintaxisPentagramaEstudio: "staff <τι> --roman|--hand|--sequence|--tab",
        descripcionPentagramaEstudio: "οι βαθμίδες με λατινικούς αριθμούς κάτω\nαπό τις συγχορδίες· τα δάχτυλα στο πιάνο\n(--hand right) ή στην κιθάρα (--tab\n--fingers)· η κλίμακα σε τρίτες ή σε\nομάδες (--sequence thirds)· η ταμπλατούρα\nαπό κάτω (--tab, --instrument)",
        sintaxisPentagramaRegistro: "staff <τι> --octave|--clef|--grand-staff|--clef-changes|--figured-bass",
        descripcionPentagramaRegistro: "η οκτάβα (--octave 2), το κλειδί (--clef\nbass), το διπλό πεντάγραμμο, οι αλλαγές\nκλειδιού ανά περιοχή και ο αριθμημένος\nβαθύφωνος (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "staff melody <νότες> --over <συγχορδίες>",
        descripcionPentagramaMelodia: "μια μελωδία (C4:8 D4:8…) με μία συγχορδία\nανά μέτρο από πάνω· οι ξένες νότες με\nπράσινο (ή κόκκινο αν είναι χρωματικές)·\nτο --non-chord το κάνει και αλλού",
        sintaxisPosicionesArpegio: "positions --arpeggio <σύμβολο> [--caged|--sweep]",
        descripcionPosicionesArpegio: "το αρπίσιμο μιας συγχορδίας σε κάθε\nθέση της ταστιέρας, σε ταμπλατούρα με\nτα δάχτυλα· --up-and-down, πάνω και κάτω",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: θεωρία της μουσικής από τη γραμμή εντολών.

        Χρήση: armonia <εντολή> <ορίσματα> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Εντολές (οι εντολές και οι επιλογές γράφονται στα ισπανικά ή στα αγγλικά):
        """,
        pieDeLaAyuda: """
        Τα ονόματα των νοτών γίνονται δεκτά στα ισπανικά, στα αγγλικά, στα ελληνικά και σε άλλες
        γλώσσες (Do, C, Sib, Bb, ντο, σι ύφεση). Με --idioma el, η απάντηση χρησιμοποιεί την ελληνική
        σημειογραφία και ελληνικά μηνύματα· με --ingles, αγγλικά.
        Με --textos, τα κείμενα βγαίνουν σε άλλη γλώσσα από τις νότες: --idioma en --textos el.
        Στα ισπανικά και στα αγγλικά, το --escritura palabras|ascii|unicode γράφει τις νότες
        Fa sostenido, Fa# ή Fa♯ (στα αγγλικά, F sharp, F# ή F♯).
        Στις άλλες γλώσσες, το --escritura palabras|compacto επιλέγει λέξεις ή τη σύντομη μορφή:
        fa dièse ή Fa♯, F Kreuz ή Fis.
        Στις συμπαγείς γραφές η οκτάβα γράφεται ως δείκτης (La₄) και στις άλλες με ψηφία (La4)·
        το --subindices ή το --cifras την ορίζει (διαβάζονται και τα δύο).
        Με --json, οι chord, identify, arpeggio, interval, scale, key, analyze, set, row,
        fingerings και traditions δίνουν τα δεδομένα τους σε JSON.
        Με --json επίσης οι harmonize, realize, check, counterpoint και transpose. Αν η έξοδος δεν
        είναι τερματικό, το JSON γράφεται σε μία γραμμή.
        Το ARMONIA_IDIOMA=eu ορίζει τη γλώσσα χωρίς --idioma· το ARMONIA_IDIOMA=system παίρνει αυτήν του LANG.
        Κωδικοί εξόδου: 0 εντάξει, 1 κείμενο που δεν διαβάζεται, 2 λάθος εντολή και 3 σφάλματα (check,
        counterpoint).
        Χωρίς ορίσματα σε τερματικό, το armonia ανοίγει μια συνεδρία: μία εντολή ανά γραμμή.
        """,
        sintaxisAyuda: "help [<εντολή>]",
        descripcionAyuda: "αυτή η βοήθεια, ή μιας εντολής\n(και <εντολή> --help)",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "η αυτόματη συμπλήρωση εντολών και\nεπιλογών για το τερματικό",
        sintaxisManual: "manual",
        descripcionManual: "αυτή η βοήθεια ως σελίδα εγχειριδίου",
        manualNombre: "ΟΝΟΜΑ",
        manualNotas: "ΣΗΜΕΙΩΣΕΙΣ",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "λείπουν οι συγχορδίες: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "χρειάζονται δύο συγχορδίες: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "λείπουν οι νότες της μελωδίας: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "το --proposals πάει από 1 έως 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "λείπουν το cantus firmus και η αντίστιξη, χωρισμένα με /: " + ingles },
        especieFueraDeRango: "το --species πάει από 1 έως 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "λείπουν οι συγχορδίες: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "λείπει το σύμβολο της συγχορδίας: armonia chord G7",
        faltaCifradoDelArpegio: "λείπει το σύμβολο της συγχορδίας: armonia arpeggio C7",
        patronDesconocido: { patron in "άγνωστο μοτίβο: «\(patron)» (ascending, descending, up-down, down-up, broken ή alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: δεν είναι παράδοση (india, greece, arab-world, persia, turkey…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: δεν είναι κατηγορία κλιμάκων (rāga, maqam, makam, dastgah…)" },
        faltanNotas: "λείπουν οι νότες: armonia identify C E G",
        dosNotas: "χρειάζονται δύο νότες: armonia interval C E",
        faltaEscala: "λείπει η κλίμακα: armonia scale D dorian",
        faltaTonalidad: "λείπει η τονικότητα: armonia key A minor",
        faltaTonalidadTrasEn: "λείπει η τονικότητα μετά το --in",
        faltaConjunto: "λείπει το σύνολο: armonia set 0 4 7",
        faltaSerie: "λείπει η σειρά: armonia row 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "λείπουν οι συγχορδίες: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "δεν είναι δυνατή η ανάγνωση του αρχείου «\(nombre)»" },
        archivoConAcordes: "με το --file δεν γράφονται συγχορδίες",
        archivoSinAcordes: "το αρχείο δεν έχει συγχορδίες",
        faltaTransporte: { ejemplo in "λείπουν το διάστημα (ή η νέα τονική) και ό,τι μεταφέρεται: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "λείπουν οι συγχορδίες: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "το περιθώριο είναι αριθμός από 0 έως 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "λείπουν οι νότες: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "λείπει η συγχορδία: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "λείπει η κλίμακα: armonia \(orden) --scale D dorian" },
        faltanClasesDelDibujo: { ejemplo, orden in "λείπουν οι τονικές κλάσεις: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "λείπουν τα τρίφωνα: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "ο κύκλος είναι εξατονικός, οκτατονικός ή LR, από ένα τρίφωνο: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "η ακολουθία αποτελείται από μείζονα και ελάσσονα τρίφωνα: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "η συντομότερη διαδρομή πάει από ένα μείζον ή ελάσσον τρίφωνο σε άλλο: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "ο κύκλος ξεκινά από ένα μείζον ή ελάσσον τρίφωνο: armonia \(orden) --cycle hexatonic C" },
        opcionesDeCuadricula: "επιλογές του πλέγματος: --axes H,V (1,5), --grid CxR (8x8), --origin <τονικό ύψος> (C2), --rotate 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "κινούνται 1 ή 2 φωνές: --voices 2",
        unAcordeDeVecinos: { ejemplo in "χρειάζεται μία συγχορδία: armonia neighbors G7" },
        vecinosSinFamilia: "οι γειτονικές αναζητούνται ανάμεσα σε συγχορδίες έβδομης δεσπόζουσας, ελάσσονες, ημιελαττωμένες, ελαττωμένες και maj7, ή ανάμεσα σε μείζονα, ελάσσονα και αυξημένα τρίφωνα",
        dosAcordesDeCamino: { ejemplo in "χρειάζονται δύο συγχορδίες: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "οι δύο συγχορδίες πρέπει να είναι της ίδιας οικογένειας (έβδομες, με ή χωρίς maj7, ή τρίφωνα) και να συνδέονται",
        faltanPasosDePLR: { ejemplo in "χρειάζονται ένα τρίφωνο και κάποια βήματα ή άλλο τρίφωνο: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "τα P, L και R εφαρμόζονται σε μείζονα και ελάσσονα τρίφωνα: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "λείπει το «melody», «chorale» ή «chords»: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "το πρόγραμμα είναι αριθμός General MIDI από 0 έως 127: --program 52",
        marcasSoloMusicXML: "τα --cifrados και --analisis είναι για MusicXML, MEI, LilyPond, GUIDO και ABC",
        faltaValor: { opcion in "λείπει η τιμή του --\(opcion)" },
        tempoMalEscrito: "το τέμπο γράφεται «--tempo 90» ή «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "λείπουν οι νότες: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "τα --cifrados και --analisis είναι για «chorale»",
        duracionSoloCoral: "το --duracion είναι μόνο για «chorale»",
        claveDesconocida: { clave, claves in "άγνωστο κλειδί: «\(clave)» (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "λείπουν οι συγχορδίες: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "το --\(opcion) είναι μόνο για «melody»" },
        soloParaArpegios: { opcion in "το --\(opcion) είναι μόνο για «arpeggios»" },
        archivoSoloParaAcordes: "το --file είναι μόνο για «chords» και «arpeggios»",
        ventanaSinArchivo: "το --window πάει με το --file",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "λείπουν οι συγχορδίες: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "οι συγχορδίες έχουν πάντα σύμβολα και ανάλυση",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: εξάγεται «melody», «chorale», «chords», τα «arpeggios» τους ή «scale»" },
        faltaLoQueSeGraba: "λείπει τι θα χαραχθεί: armonia engrave chorale C3 E4 G4 C5 > chorale.pdf",
        motorDesconocido: { motor in "«\(motor)»: οι μηχανές είναι lilypond, musescore, verovio, guido και own" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: η έξοδος είναι «pdf», «svg» ή «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: χαράσσεται μια παρτιτούρα (melody, chorale, chords, arpeggios, scale) ή ένα σχέδιο (staff, tonnetz, harmonic-table, keyboard, grid, clock)" },
        motorNoEncontrado: { programa, variable in "δεν βρέθηκε το «\(programa)»: εγκαταστήστε το ή δώστε τη διαδρομή του στη \(variable)" },
        motorFallo: { programa, codigo in "το «\(programa)» τερμάτισε με κωδικό \(codigo):" },
        motorSinTerminar: { programa in "το «\(programa)» δεν τελείωσε εγκαίρως και σταμάτησε" },
        motorNoInstalado: { variable in "δεν είναι εγκατεστημένο (ή βάλε τη διαδρομή στη \(variable))" },
        motorPropio: "own",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "λείπει το όργανο: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "άγνωστο όργανο: «\(nombre)» (\(lista(.griegoPalabras)))" },
        faltaLimite: "λείπει ο αριθμός δακτυλοθεσιών: --limit 5",
        limiteFueraDeRango: "το όριο είναι αριθμός από 1 έως 200: --limit 5",
        faltanDedos: "λείπει ο αριθμός δαχτύλων: --fingers 3",
        dedosFueraDeRango: "τα δάχτυλα είναι αριθμός από 1 έως 4: --fingers 3",
        faltaTraste: "λείπει το ψηλότερο τάστο: --fret 12",
        trasteFueraDeRango: "το ψηλότερο τάστο είναι αριθμός από 0 έως 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "λείπει το σύμβολο της συγχορδίας: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "λείπει η κλίμακα: armonia positions G major",
        faltaEscalaDelTeclado: "λείπει η κλίμακα: armonia keyboard D major",
        manoDesconocida: { texto in "άγνωστο χέρι: «\(texto)» (right ή left)" },
        archivoConNotas: "με το --file δεν γράφονται νότες",
        noEsPentatonica: "τα σχήματα είναι για κλίμακα πέντε φθόγγων: armonia positions A minor pentatonic --shapes",
        faltaEscalaDelReloj: "λείπει η κλίμακα: armonia clock D major",
        faltaLoQueDibujaElPentagrama: "λείπει τι θα σχεδιαστεί: armonia staff scale D dorian",
        capoFueraDeRango: "το καποτάστο είναι αριθμός από 0 έως 12: --capo 2",
        octavasFueraDeRango: "οι οκτάβες είναι αριθμός από 1 έως 4: --octaves 2",
        octavaFueraDeRango: "η οκτάβα είναι αριθμός από 0 έως 7: --octave 3",
        desdeNoValido: { desde in "το «\(desde)» δεν είναι νότα ή βαθμίδα της συγχορδίας: --from E ή --from 3" },
        tensionesMalEscritas: "οι επεκτάσεις είναι 9, 11 ή 13: --tensions 9,13",
        gradosMalEscritos: "οι βαθμίδες είναι αριθμοί από 1 έως 22: --degrees 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "άγνωστη προσέγγιση: «\(aproximacion)» (below, above ή enclosure)" },
        secuenciaDesconocida: { secuencia in "άγνωστη αλληλουχία: «\(secuencia)» (thirds, fourths, groups-of-3, groups-of-4, triads ή sevenths)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Δοκίμασε «armonia help».",
        ordenDesconocida: { orden in "άγνωστη εντολή: «\(orden)»" },
        opcionDesconocida: { opcion in "άγνωστη επιλογή: «\(opcion)»" },
        idiomaDesconocido: { idioma in "άγνωστη γλώσσα: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru ή hu)" },
        terminalDesconocida: { t in "άγνωστο κέλυφος: «\(t)» (bash, zsh ή fish)" },
        escrituraNoValida: { escritura in "μη έγκυρη γραφή: «\(escritura)» (palabras/words ή compacto/compact· ascii ή unicode, μόνο με es και en)" },
        sinSalidaJSON: { orden in "η «\(orden)» δεν δίνει έξοδο JSON" },

        // Mensaje.swift
        mensajeNotas: "νότες",
        mensajeAcordes: "συγχορδίες",
        mensajeMicrotonos: "μικροτόνια",
        mensajeEscalas: "κλίμακες",
        mensajeHabituales: "συνήθεις",
        mensajeNingunaEscala: "καμία κλίμακα δεν ταιριάζει",
        mensajeArmadura: "οπλισμός",
        mensajeRelativa: "σχετική",
        mensajeHomonima: "ομώνυμη",
        mensajeBajo: { nota in "μπάσο \(nota)" },
        mensajeBajoAjeno: "μπάσο εκτός συγχορδίας",
        mensajeSinAcordes: "Δεν σχηματίζουν καμία γνωστή συγχορδία.",
        mensajeSin: { notas in "χωρίς \(notas)" },
        mensajeSemitonos: { n in "\(n) ημιτόνια" },
        mensajeSinAlteraciones: "χωρίς αλλοιώσεις",
        mensajeSostenidos: { n in Idioma.griego.contar(n, "δίεση", "διέσεις") },
        mensajeBemoles: { n in Idioma.griego.contar(n, "ύφεση", "υφέσεις") },
        mensajeACuatroVoces: "Σε τετραφωνία (μπάσο, τενόρος, άλτο, σοπράνο):",
        mensajeSinDigitaciones: "δεν υπάρχουν άνετες δακτυλοθεσίες",
        mensajeDedos: { n in Idioma.griego.contar(n, "δάχτυλο", "δάχτυλα") },
        mensajeCejilla: { traste in "μπαρέ στο \(traste)ο τάστο" },
        mensajeNingunPaso: "κανένα βήμα",
        mensajeUnPaso: "1 βήμα",
        mensajePasos: { n in "\(n) βήματα" },
        mensajeTriadas: { n in Idioma.griego.contar(n, "τρίφωνο", "τρίφωνα") },
        mensajeFormaNormal: "κανονική μορφή",
        mensajeFormaPrima: "πρωταρχική μορφή",
        mensajeVectorIntervalico: "διάνυσμα διαστημάτων",
        mensajeVectorDeIndice: "διάνυσμα δεικτών",
        mensajeEjesDeSimetria: "άξονες συμμετρίας",
        mensajeIntervalos: "διαστήματα",
        mensajeDeTodosLosIntervalos: "όλων των διαστημάτων",
        mensajeFormasDistintas: { n in "\(n) διαφορετικές μορφές" },
        mensajeHexacordos: "εξάχορδα",
        mensajeFormasCombinatorias: "συνδυαστικές μορφές",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "η έκδοση του armonia",
        quisoDecir: { x in "Μήπως εννοούσες «\(x)»;" },
        pruebaLaAyudaDe: { o in "Δοκίμασε «armonia help \(o)»." },
        salidaBinaria: "η έξοδος είναι δυαδικό αρχείο (MIDI, PDF ή PNG)· αποθήκευσέ την με > αρχείο",
        escalasPorNotas: { e in "καμία κλίμακα δεν έχει αυτό το όνομα· για αναζήτηση με τις νότες: \(e)" },
        grabarUnaPartitura: { o, e in "η «armonia \(o)» γράφει ήδη την παρτιτούρα· η «engrave» τη χαράσσει σε PDF, SVG ή PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Ερωτήματα", "Αρμονία και φωνές", "Παρτιτούρες και χάραξη", "Σχέδια (SVG)", "Νεο-ριμανική θεωρία", "Όργανα με τάστα", "Τερματικό και βοήθεια"],
        pieDelIndice: """
        Η βοήθεια μιας εντολής: armonia help <εντολή> (ή armonia <εντολή> --help).
        Όλη η βοήθεια, με τις επιλογές κάθε εντολής: armonia help --all.
        Για όλες τις εντολές: --ingles, --idioma, --textos, --escritura, --subindices, --cifras και --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Γράψτε μία εντολή ανά γραμμή, χωρίς «armonia» (help: οι εντολές· exit: τέλος)." }
    )
}
