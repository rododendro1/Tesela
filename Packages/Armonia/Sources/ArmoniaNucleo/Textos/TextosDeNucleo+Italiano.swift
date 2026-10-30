// Los textos de ArmoniaNucleo en italiano. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let italiano = TextosDeNucleo(
        // Intervalo+Idiomas.swift
        calidadJusta: "giusta",
        calidadMayor: "maggiore",
        calidadMenor: "minore",
        calidadAumentada: "aumentata",
        calidadDisminuida: "diminuita",
        multiplicidadSimple: "",
        multiplicidadDoble: "doppiamente ",
        multiplicidadTriple: "triplamente ",
        multiplicidad: { n in "\(n) volte " },
        plantillaDescendente: "_ discendente",
        consonanciaPerfecta: "consonanza perfetta",
        consonanciaImperfecta: "consonanza imperfetta",
        disonancia: "dissonanza",

        // Nota+Idiomas.swift
        palabraNatural: "bequadro",
        palabraSostenido: "diesis",
        palabraBemol: "bemolle",
        multiplicadores: ["doppio ", "triplo ", "quadruplo "],
        palabraSostenidos: "diesis",
        palabraBemoles: "bemolli",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "«\(simbolo)» non fa parte di nessuna sigla conosciuta" },
        tensionNoValida: { tension in "«\(tension)» non è una tensione valida (si ammettono ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» non è un numero di accordo (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» compare dopo un altro numero; le tensioni aggiuntive vanno tra parentesi, come in 7(9)" },
        disminuidoYSemidisminuido: "diminuito (°) e semidiminuito (ø) non si possono combinare",
        quintaConCalidad: "l'accordo di quinta (5) non ha la terza, quindi non ammette m, °, ø né +",
        fundamentalNoOmitible: "non si può omettere la fondamentale",
        gradoNoOmitible: { grado in "«omit\(grado)» non è valido (si possono omettere 3, 5, 7, 9, 11 e 13)" },
        faltaLaFundamental: "manca la fondamentale",
        intervaloSinPapel: { intervalo, notacion in "l'intervallo di \(intervalo.nombre(en: .italiano)) non ha un ruolo in un accordo per terze" },
        terceraMayorYMenor: "ha insieme la terza maggiore e quella minore (la ♯9 si scrive come 9ª aumentata, non come 3ª minore)",
        variasSeptimas: "ha più di una settima",
        septimaDisminuidaFueraDelDisminuido: "la settima diminuita compare solo nell'accordo diminuito (con 3ª minore e 5ª diminuita)",
        noEsPorTerceras: "non è un accordo per terze",
        bajoNoValido: { bajo in "«\(bajo)» non è un nome di nota per il basso" },
        idiomasMezclados: { nombre in "«\(nombre)» è scritto in un'altra lingua rispetto alla fondamentale: si scrive tutto in sillabe (Sol7/Si) o tutto in lettere (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "«\(nombre)» non è il modo di una tonalità: una tonalità è maggiore o minore (per gli altri modi, usa Escala)" },
        faltaElTipoDeEscala: "manca il tipo di scala (maggiore, dorica, minore armonica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» non è un tipo di scala conosciuto" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Valore non valido",
        noSePuedeLeer: { texto in "Impossibile leggere «\(texto)»" },
        caracter: { p in " (carattere \(p + 1))" },
        textoVacio: "il testo è vuoto",
        caracteresSobrantes: { resto in "«\(resto)» è di troppo" },

        // ErrorDeLectura+Notas.swift
        notaNoReconocida: "si aspettava un nome di nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "manca l'ottava (per esempio, Do4)",
        octavaNoValida: { resto in "«\(resto)» non è un'ottava valida" },
        faltaElNumeroDeIntervalo: "manca il numero dell'intervallo (per esempio, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» non è un numero di intervallo" },
        faltaLaCalidad: "manca la specie dell'intervallo (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» non è una specie di intervallo (J, M, m, A o d)" },
        unisonoDisminuido: "l'unisono diminuito non esiste: da Do a Do♭ c'è un unisono aumentato discendente (scrivilo -1A)",
        reglaDeLasJustas: "l'unisono, la 4ª, la 5ª e l'8ª sono giuste, aumentate o diminuite",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª e la 7ª sono maggiori, minori, aumentate o diminuite",
        intervaloInexistente: { numero, calidad, notacion, regla in "non esiste la \(numero)ª \(calidad.nombre(en: .italiano)): \(regla.italiano)" },
        alteracionNoReconocida: { signo in "«\(signo)» non è un'alterazione (si aspettava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "«\(texto)» non è una durata: si aspettava una figura (1, 2, 4, 8, 16…, puntata: 4.) o una frazione di semibreve (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» non è un tempo: si aspettava numeratore/denominatore con il denominatore potenza di 2 (4/4, 6/8, 7/8), C o ¢" },
        vocesDistintas: "tutti gli accordi devono avere lo stesso numero di voci, e almeno due",
        contrapuntoDeOtraDuracion: { redondas in "il contrappunto deve durare quanto il cantus firmus: \(redondas) semibrevi, una per nota" }
    )
}
