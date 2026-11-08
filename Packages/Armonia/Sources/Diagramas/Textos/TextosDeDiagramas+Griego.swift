// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en griego. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let griego = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "κύκλος των πεμπτών",

        // DibujoSVG.swift
        conjunto: "Σύνολο ",
        cicloDesde: "{1} από {2}",
        primeraClase: "πρώτη τονική κλάση",
        primeraNota: "πρώτη νότα",
        leyendaNota: "νότα",
        leyendaClaseDeAltura: "τονική κλάση (όλα τα αντίγραφά της)",
        leyendaAltura: "τονικό ύψος (όλα τα πλήκτρα του)",
        leyendaIntervalos: "πέμπτη ή τρίτη ανάμεσα σε νότες",
        leyendaContorno: "περίγραμμα του σχήματος",
        leyendaTriadaMayor: "μείζον τρίφωνο",
        leyendaTriadaMenor: "ελάσσον τρίφωνο",
        leyendaPasoDelRecorrido: "βήμα της ακολουθίας (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "θεμέλια της πρώτης συγχορδίας",

        // TecladoIsomorfico.swift
        tablaArmonica: "Αρμονικός πίνακας",
        wickiHaydenEspejo: "Wicki-Hayden (καθρέφτης)",
        wickiHaydenPlano: "Wicki-Hayden (επίπεδο)",
        acordeonC: "Ακορντεόν συστήματος C",
        acordeonB: "Ακορντεόν συστήματος B",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Πλέγμα τετάρτων",
        cuadriculaEnTercerasMayores: "Πλέγμα μεγάλων τρίτων",
        cuadriculaEnQuintas: "Πλέγμα πέμπτων",
        wickiHaydenCuadrado: "Wicki-Hayden (πλέγμα)",
        cuadriculaDeTonosEnteros: "Πλέγμα ολόκληρων τόνων",
        tonnetzDeEuler: "Tonnetz του Όιλερ",
        cuadriculaEnTercerasMenores: "Πλέγμα μικρών τρίτων",
        cuadriculaEnTritonos: "Πλέγμα τριτόνων",
        cuadriculaEnOctavas: "Πλέγμα οκτάβων",
        cuadriculaSecuencial: "Διαδοχικό πλέγμα",
        // FormatoUIL.swift
        uilNoValido: "Μη έγκυρο UIL: «{1}». Αναμένεται L,G,D;R<μοίρες>[M], για παράδειγμα 2,7,5;R30M.",
        intervalosIncoherentes: "Ασυνεπή διαστήματα: {1},{2},{3}. Πρέπει να ισχύει 0 < L ≤ D και G = L + D.",
        giroNoValido: "Η περιστροφή των {1}° δεν είναι πολλαπλάσιο των 30°.",
        afinacionNoSoportada: "Σχεδιάζονται μόνο πληκτρολόγια 12 φθόγγων, όχι {1}.",
        cizallaNoSoportada: "Η διάτμηση S{1} δεν υποστηρίζεται."
    )
}
