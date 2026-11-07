// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en griego. Los campos y lo que significa cada uno están en
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
        claveDeDoEnCuarta: "κλειδί του ντο στην τέταρτη γραμμή",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "πιάνο",
        instrumentoFlauta: "φλάουτο",
        instrumentoFlautin: "πίκολο",
        instrumentoFlautaEnSol: "φλάουτο άλτο σε σολ",
        instrumentoOboe: "όμποε",
        instrumentoCornoIngles: "αγγλικό κόρνο",
        instrumentoClarineteEnSib: "κλαρινέτο σε σι♭",
        instrumentoClarineteEnLa: "κλαρινέτο σε λα",
        instrumentoClarineteEnMib: "κλαρινέτο σε μι♭",
        instrumentoClarineteBajo: "μπάσο κλαρινέτο",
        instrumentoFagot: "φαγκότο",
        instrumentoSaxofonSoprano: "σαξόφωνο σοπράνο",
        instrumentoSaxofonAlto: "σαξόφωνο άλτο",
        instrumentoSaxofonTenor: "σαξόφωνο τενόρο",
        instrumentoSaxofonBaritono: "σαξόφωνο βαρύτονο",
        instrumentoTrompetaEnSib: "τρομπέτα σε σι♭",
        instrumentoTrompetaEnDo: "τρομπέτα σε ντο",
        instrumentoFliscorno: "φλικόρνο",
        instrumentoTrompaEnFa: "κόρνο σε φα",
        instrumentoTrombon: "τρομπόνι",
        instrumentoTuba: "τούμπα",
        instrumentoViolin: "βιολί",
        instrumentoViola: "βιόλα",
        instrumentoViolonchelo: "βιολοντσέλο",
        instrumentoContrabajo: "κοντραμπάσο",
        instrumentoGuitarra: "κιθάρα",
        instrumentoBajoElectrico: "ηλεκτρικό μπάσο",
        instrumentoXilofono: "ξυλόφωνο",
        instrumentoGlockenspiel: "γκλόκενσπιλ",
        instrumentoCelesta: "τσελέστα",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "το «\(texto)» δεν είναι διάρκεια: αναμενόταν αξία νότας (1, 2, 4, 8, 16…, με τελεία: 4.) ή κλάσμα ολόκληρου (3/8, 1/12)" },
        compasNoValido: { texto in "το «\(texto)» δεν είναι μέτρο: αναμενόταν αριθμητής/παρονομαστής με παρονομαστή δύναμη του 2 (4/4, 6/8, 7/8), C ή ¢" },
        contrapuntoDeOtraDuracion: { redondas in "η αντίστιξη πρέπει να διαρκεί όσο το cantus firmus: \(redondas) ολόκληρα, ένα ανά νότα" }
    )
}
