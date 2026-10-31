// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en griego. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let griego = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(μέτρο \(n))" },
        enLosCompases: { pasos in "(μέτρα \(pasos))" },
        ritmoDeLaEspecie: "Ρυθμός ξένος προς το είδος",
        comienzoImperfecto: "Αρχή χωρίς τέλεια συνήχηση",
        finalImperfecto: "Τέλος χωρίς ταυτοφωνία ή οκτάβα",
        finalSinGradoConjunto: "Τέλος χωρίς βηματική κίνηση",
        disonanciaEnParteFuerte: "Διαφωνία σε ισχυρό χρόνο",
        disonanciaMalTratada: "Λανθασμένη χρήση διαφωνίας",
        retardoMalResuelto: "Λανθασμένη λύση καθυστέρησης",
        unisono: "Ταυτοφωνία στη μέση της άσκησης",
        saltoSinCompensar: "Πήδημα χωρίς αντιστάθμιση",
        notaRepetida: "Επαναλαμβανόμενη νότα",
        especieConElContrapuntoEncima: { n in "Είδος \(n), αντίστιξη πάνω από το cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Είδος \(n), αντίστιξη κάτω από το cantus firmus" },
        sinFaltas: "Χωρίς λάθη.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "συγχορδίες",
        pistaDelBajo: "μπάσο",

        // Importacion.swift
        formatoDesconocido: "Το αρχείο δεν είναι ούτε MIDI ούτε MusicXML.",
        musicXMLComprimido: "Το συμπιεσμένο MusicXML (.mxl) είναι κατεστραμμένο ή δεν διαβάζεται: εξαγάγετέ το χωρίς συμπίεση (.musicxml).",
        midiDanado: "Το αρχείο MIDI είναι κατεστραμμένο ή κομμένο.",
        midiConTiempoSMPTE: "Το αρχείο MIDI μετρά τον χρόνο σε καρέ SMPTE, όχι σε παλμούς ανά τέταρτο.",
        xmlDanado: { linea in "Το αρχείο MusicXML είναι κατεστραμμένο (γραμμή \(linea))." },
        noEsMusicXMLPorPartes: "Το XML δεν είναι παρτιτούρα MusicXML ανά μέρη (score-partwise).",
        sinNotas: "Το αρχείο δεν έχει καμία νότα.",
        sinAcordes: "Στο αρχείο δεν ακούγεται καμία συγχορδία.",

        // Duracion.swift
        cuadrada: "διπλό ολόκληρο",
        redonda: "ολόκληρο",
        blanca: "μισό",
        negra: "τέταρτο",
        corchea: "όγδοο",
        semicorchea: "δέκατο έκτο",
        fusa: "τριακοστό δεύτερο",
        semifusa: "εξηκοστό τέταρτο",
        garrapatea: "εκατοστό εικοστό όγδοο",
        cero: "μηδέν",
        fraccionDeRedonda: { fraccion in "\(fraccion) του ολόκληρου" },
        conPuntillos: ["_ με τελεία", "_ με διπλή τελεία", "_ με τριπλή τελεία", "_ με τετραπλή τελεία"],

        // Pentagrama.swift
        claveDeSol: "κλειδί του σολ",
        claveDeSolOctavaBaja: "κλειδί του σολ μία οκτάβα χαμηλότερα",
        claveDeSolOctavaAlta: "κλειδί του σολ μία οκτάβα ψηλότερα",
        claveDeFa: "κλειδί του φα",
        claveDeFaEnTercera: "κλειδί του φα στην τρίτη γραμμή",
        claveDeDoEnPrimera: "κλειδί του ντο στην πρώτη γραμμή",
        claveDeDoEnSegunda: "κλειδί του ντο στη δεύτερη γραμμή",
        claveDeDoEnTercera: "κλειδί του ντο στην τρίτη γραμμή",
        claveDeDoEnCuarta: "κλειδί του ντο στην τέταρτη γραμμή"
    )
}
