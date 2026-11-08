// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en griego. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let griego = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "καθαρή",
        calidadMayor: "μεγάλη",
        calidadMenor: "μικρή",
        calidadAumentada: "αυξημένη",
        calidadDisminuida: "ελαττωμένη",
        multiplicidadSimple: "",
        multiplicidadDoble: "δις ",
        multiplicidadTriple: "τρις ",
        multiplicidad: "{1} φορές ",
        plantillaDescendente: "κατιούσα {1}",
        consonanciaPerfecta: "τέλεια συμφωνία",
        consonanciaImperfecta: "ατελής συμφωνία",
        disonancia: "διαφωνία",

        // Nota.swift
        palabraNatural: "αναίρεση",
        palabraSostenido: "δίεση",
        palabraBemol: "ύφεση",
        multiplicadores: ["διπλή ", "τριπλή ", "τετραπλή "],
        palabraSostenidos: "διέσεις",
        palabraBemoles: "υφέσεις",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Μη έγκυρη τιμή",
        noSePuedeLeer: "Δεν μπορεί να διαβαστεί το «{1}»",
        caracter: { p in " (χαρακτήρας \(p + 1))" },
        textoVacio: "το κείμενο είναι κενό",
        caracteresSobrantes: "περισσεύει το «{1}»",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "αναμενόταν όνομα νότας (ντο, ρε, μι… ή C, D, E…)",
        faltaLaOctava: "λείπει η οκτάβα (για παράδειγμα, ντο4)",
        octavaNoValida: "το «{1}» δεν είναι έγκυρη οκτάβα",
        faltaElNumeroDeIntervalo: "λείπει ο αριθμός του διαστήματος (για παράδειγμα, M3)",
        numeroDeIntervaloNoValido: "το «{1}» δεν είναι αριθμός διαστήματος",
        faltaLaCalidad: "λείπει το είδος του διαστήματος (P, M, m, A ή d)",
        calidadNoValida: "το «{1}» δεν είναι είδος διαστήματος (P, M, m, A ή d)",
        unisonoDisminuido: "δεν υπάρχει ελαττωμένη πρώτη: από ντο σε ντο ύφεση είναι κατιούσα αυξημένη πρώτη (γράψε -A1)",
        reglaDeLasJustas: "η πρώτη, η τέταρτη, η πέμπτη και η όγδοη είναι καθαρές, αυξημένες ή ελαττωμένες",
        reglaDeLasMayores: "η δεύτερη, η τρίτη, η έκτη και η έβδομη είναι μεγάλες, μικρές, αυξημένες ή ελαττωμένες",
        intervaloInexistente: { numero, calidad, notacion, regla in "δεν υπάρχει \(calidad.nombre(en: .conPalabras(.griego))) \(Intervalo.ordinal(numero, en: .griego)): \(regla.texto(en: .griego))" },
        alteracionNoReconocida: "το «{1}» δεν είναι αλλοίωση (αναμενόταν ♯, ♭, 𝄪, 𝄫, #, b, x ή ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "το «{1}» δεν είναι ούτε τονική κλάση (από 0 έως 11, ή t και e για το 10 και το 11) ούτε όνομα νότας",
        numeroDeForteDesconocido: "το «{1}» δεν είναι αριθμός Forte (για παράδειγμα, 3-11 ή 4-Z15)",
        faltaElCierre: "λείπει το τελικό «{1}»",
        serieNoDodecafonica: "μια δωδεκάφθογγη σειρά έχει και τις δώδεκα τονικές κλάσεις, την καθεμία μία φορά",
        faltanEnLaSerie: "λείπουν {1}",
        repetidasEnLaSerie: "επαναλαμβάνονται {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "το «{1}» δεν είναι καμία από τις δεκατρείς γλώσσες: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{1} {2}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["πρώτη", "δεύτερη", "τρίτη", "τέταρτη", "πέμπτη", "έκτη", "έβδομη", "όγδοη", "ένατη", "δέκατη", "ενδέκατη", "δωδέκατη", "δέκατη τρίτη", "δέκατη τέταρτη", "διπλή όγδοη"],
        ordinalEnCifras: { n in "\(n)η" },
        dosPuntos: ": "
    )
}
