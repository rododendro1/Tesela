// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en griego. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let griego = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "— " + nombres.joined(separator: " και ") },
        enLaVoz: { primera in "— \(primera)" },
        enLosAcordes: { pasos in "(συγχορδίες \(pasos))" },
        enElAcorde: { acorde in "(συγχορδία \(acorde + 1))" },
        quintasParalelas: "Παράλληλες πέμπτες",
        octavasParalelas: "Παράλληλες οκτάβες",
        quintasDirectas: "Κρυφές πέμπτες",
        octavasDirectas: "Κρυφές οκτάβες",
        cruceDeVoces: "Διασταύρωση φωνών",
        superposicion: "Επικάλυψη φωνών",
        separacionExcesiva: "Πάνω από μία οκτάβα",
        saltoNoMelodico: "Μη μελωδικό πήδημα",
        fueraDeTesitura: "Εκτός έκτασης",
        vozBajo: "μπάσο",
        vozTenor: "τενόρος",
        vozContralto: "άλτο",
        vozSoprano: "σοπράνο",
        vozNumero: { numero in "φωνή \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["διαβατική νότα", "γειτονική νότα", "αποτζιατούρα", "καθυστέρηση", "πρόληψη", "νότα διαφυγής", "νότα πεντάλ", "ελεύθερη νότα"],

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
        sinFaltas: "Χωρίς λάθη."
    )
}
