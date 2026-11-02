// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en griego. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let griego = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "καθαρή",
        calidadMayor: "μεγάλη",
        calidadMenor: "μικρή",
        calidadAumentada: "αυξημένη",
        calidadDisminuida: "ελαττωμένη",
        multiplicidadSimple: "",
        multiplicidadDoble: "δις ",
        multiplicidadTriple: "τρις ",
        multiplicidad: { n in "\(n) φορές " },
        plantillaDescendente: "κατιούσα _",
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
        noSePuedeLeer: { texto in "Δεν μπορεί να διαβαστεί το «\(texto)»" },
        caracter: { p in " (χαρακτήρας \(p + 1))" },
        textoVacio: "το κείμενο είναι κενό",
        caracteresSobrantes: { resto in "περισσεύει το «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "αναμενόταν όνομα νότας (ντο, ρε, μι… ή C, D, E…)",
        faltaLaOctava: "λείπει η οκτάβα (για παράδειγμα, ντο4)",
        octavaNoValida: { resto in "το «\(resto)» δεν είναι έγκυρη οκτάβα" },
        faltaElNumeroDeIntervalo: "λείπει ο αριθμός του διαστήματος (για παράδειγμα, M3)",
        numeroDeIntervaloNoValido: { resto in "το «\(resto)» δεν είναι αριθμός διαστήματος" },
        faltaLaCalidad: "λείπει το είδος του διαστήματος (P, M, m, A ή d)",
        calidadNoValida: { resto in "το «\(resto)» δεν είναι είδος διαστήματος (P, M, m, A ή d)" },
        unisonoDisminuido: "δεν υπάρχει ελαττωμένη πρώτη: από ντο σε ντο ύφεση είναι κατιούσα αυξημένη πρώτη (γράψε -A1)",
        reglaDeLasJustas: "η πρώτη, η τέταρτη, η πέμπτη και η όγδοη είναι καθαρές, αυξημένες ή ελαττωμένες",
        reglaDeLasMayores: "η δεύτερη, η τρίτη, η έκτη και η έβδομη είναι μεγάλες, μικρές, αυξημένες ή ελαττωμένες",
        intervaloInexistente: { numero, calidad, notacion, regla in "δεν υπάρχει \(calidad.nombre(en: .griegoPalabras)) \(Intervalo.ordinal(numero, en: .griego)): \(regla.griego)" },
        alteracionNoReconocida: { signo in "το «\(signo)» δεν είναι αλλοίωση (αναμενόταν ♯, ♭, 𝄪, 𝄫, #, b, x ή ♮)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["πρώτη", "δεύτερη", "τρίτη", "τέταρτη", "πέμπτη", "έκτη", "έβδομη", "όγδοη", "ένατη", "δέκατη", "ενδέκατη", "δωδέκατη", "δέκατη τρίτη", "δέκατη τέταρτη", "διπλή όγδοη"],
        ordinalEnCifras: { n in "\(n)η" },
        dosPuntos: ": "
    )
}
