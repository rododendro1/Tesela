// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en griego. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let griego = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "— " + nombres.joined(separator: " και ") },
        enLaVoz: { primera in "— \(primera)" },
        enLosAcordes: "(συγχορδίες {1})",
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
        vozNumero: "φωνή {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["διαβατική νότα", "γειτονική νότα", "αποτζιατούρα", "καθυστέρηση", "πρόληψη", "νότα διαφυγής", "νότα πεντάλ", "ελεύθερη νότα"],

        // Contrapunto.swift
        enElCompas: "(μέτρο {1})",
        enLosCompases: "(μέτρα {1})",
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
        especieConElContrapuntoEncima: "Είδος {1}, αντίστιξη πάνω από το cantus firmus",
        especieConElContrapuntoDebajo: "Είδος {1}, αντίστιξη κάτω από το cantus firmus",
        contrapuntoAVariasVoces: "Αντίστιξη {1} φωνών",
        vozDelContrapunto: "φωνή {1}",
        sinFaltas: "Χωρίς λάθη.",
        realizacionSinNotas: "Δεν υπάρχουν συγχορδίες ούτε νότες για γράψιμο.",
        realizacionSopranoDeOtraLongitud: "Η σοπράνο πρέπει να έχει μία νότα ανά συγχορδία (νότες: {1}· συγχορδίες: {2}).",
        realizacionNotaAjena: "Η νότα της σοπράνο δεν ανήκει στη συγχορδία {1}.",
        realizacionSopranoFueraDeTesitura: "Η νότα της σοπράνο στη συγχορδία {1} είναι εκτός της έκτασής της.",
        realizacionDemasiadasNotas: "Η συγχορδία {1} έχει περισσότερες από τέσσερις νότες που δεν μπορούν να λείπουν.",
        realizacionSinDisposicion: "Η συγχορδία {1} δεν γράφεται σε τέσσερις φωνές χωρίς λάθη.",
        realizacionNotaSinAcorde: "Καμία συγχορδία της τονικότητας δεν περιέχει τη νότα {1} της μελωδίας.",
        realizacionSinEnlaceSinFaltas: "Οι συγχορδίες δεν συνδέονται σε τέσσερις φωνές χωρίς λάθη.",
        realizacionOtraMelodia: "Η σοπράνο δεν είναι η μελωδία της εναρμόνισης."
    )
}
