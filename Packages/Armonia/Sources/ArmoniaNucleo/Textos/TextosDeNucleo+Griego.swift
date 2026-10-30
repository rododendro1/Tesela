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

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "το «\(simbolo)» δεν ανήκει σε κανένα γνωστό σύμβολο συγχορδίας" },
        tensionNoValida: { tension in "το «\(tension)» δεν είναι έγκυρη τάση (τα ♭/♯ μπαίνουν με 5, 9, 11 και 13, και το add με 2, 4, 6, 9, 11 και 13)" },
        numeroDeAcordeNoValido: { numero in "το «\(numero)» δεν είναι αριθμός συγχορδίας (5, 6, 7, 9, 11 ή 13)" },
        numeroRepetido: { numero in "το «\(numero)» έρχεται μετά από άλλον αριθμό· οι πρόσθετες τάσεις μπαίνουν σε παρένθεση, όπως στο 7(9)" },
        disminuidoYSemidisminuido: "το ελαττωμένο (°) και το ημιελαττωμένο (ø) δεν συνδυάζονται",
        quintaConCalidad: "η συγχορδία πέμπτης (5) δεν έχει τρίτη, οπότε δεν δέχεται m, °, ø ή +",
        fundamentalNoOmitible: "η θεμέλια δεν μπορεί να παραλειφθεί",
        gradoNoOmitible: { grado in "το «omit\(grado)» δεν είναι έγκυρο (παραλείπονται μόνο τα 3, 5, 7, 9, 11 και 13)" },
        faltaLaFundamental: "λείπει η θεμέλια",
        intervaloSinPapel: { intervalo, notacion in "η \(intervalo.nombre(en: .griego)) δεν έχει ρόλο σε συγχορδία κατά τρίτες" },
        terceraMayorYMenor: "έχει ταυτόχρονα μεγάλη και μικρή τρίτη (η ♯9 γράφεται ως αυξημένη ένατη, όχι ως μικρή τρίτη)",
        variasSeptimas: "έχει περισσότερες από μία έβδομες",
        septimaDisminuidaFueraDelDisminuido: "η ελαττωμένη έβδομη εμφανίζεται μόνο στην ελαττωμένη συγχορδία (με μικρή τρίτη και ελαττωμένη πέμπτη)",
        noEsPorTerceras: "δεν είναι συγχορδία κατά τρίτες",
        bajoNoValido: { bajo in "το «\(bajo)» δεν είναι όνομα νότας για το μπάσο" },
        idiomasMezclados: { nombre in "το «\(nombre)» είναι γραμμένο σε άλλη γλώσσα από τη θεμέλια: γράψ' τα όλα με συλλαβές (Sol7/Si) ή όλα με γράμματα (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "το «\(nombre)» δεν είναι τρόπος τονικότητας: μια τονικότητα είναι μείζονα ή ελάσσονα (για τους άλλους τρόπους, χρησιμοποίησε Escala)" },
        faltaElTipoDeEscala: "λείπει το είδος της κλίμακας (μείζονα, δώριος, αρμονική ελάσσονα…)",
        tipoDeEscalaNoReconocido: { nombre in "το «\(nombre)» δεν είναι γνωστό είδος κλίμακας" },

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
        intervaloInexistente: { numero, calidad, notacion, regla in "δεν υπάρχει \(calidad.nombre(en: .griego)) \(Intervalo.ordinal(numero, en: .griego)): \(regla.griego)" },
        alteracionNoReconocida: { signo in "το «\(signo)» δεν είναι αλλοίωση (αναμενόταν ♯, ♭, 𝄪, 𝄫, #, b, x ή ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "το «\(texto)» δεν είναι διάρκεια: αναμενόταν αξία νότας (1, 2, 4, 8, 16…, με τελεία: 4.) ή κλάσμα ολόκληρου (3/8, 1/12)" },
        compasNoValido: { texto in "το «\(texto)» δεν είναι μέτρο: αναμενόταν αριθμητής/παρονομαστής με παρονομαστή δύναμη του 2 (4/4, 6/8, 7/8), C ή ¢" },
        vocesDistintas: "όλες οι συγχορδίες πρέπει να έχουν τον ίδιο αριθμό φωνών, και τουλάχιστον δύο",
        contrapuntoDeOtraDuracion: { redondas in "η αντίστιξη πρέπει να διαρκεί όσο το cantus firmus: \(redondas) ολόκληρα, ένα ανά νότα" }
    )
}
