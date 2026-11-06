// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en euskera. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let euskera = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "justua",
        calidadMayor: "handia",
        calidadMenor: "txikia",
        calidadAumentada: "gehitua",
        calidadDisminuida: "gutxitua",
        multiplicidadSimple: "",
        multiplicidadDoble: "bi aldiz ",
        multiplicidadTriple: "hiru aldiz ",
        multiplicidad: { n in "\(n) aldiz " },
        plantillaDescendente: "beheranzko _",
        consonanciaPerfecta: "kontsonantzia perfektua",
        consonanciaImperfecta: "kontsonantzia inperfektua",
        disonancia: "disonantzia",

        // Nota.swift
        palabraNatural: "bekadro",
        palabraSostenido: "diesa",
        palabraBemol: "bemol",
        multiplicadores: ["bikoitza", "hirukoitza", "laukoitza"],
        palabraSostenidos: "diesa",
        palabraBemoles: "bemol",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Balio baliogabea",
        noSePuedeLeer: { texto in "Ezin da «\(texto)» irakurri" },
        caracter: { p in " (\(p + 1). karakterea)" },
        textoVacio: "testua hutsik dago",
        caracteresSobrantes: { resto in "«\(resto)» soberan dago" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "nota-izen bat espero zen (Do, Re, Mi… edo C, D, E…)",
        faltaLaOctava: "zortziduna falta da (adibidez, Do4)",
        octavaNoValida: { resto in "«\(resto)» ez da zortzidun baliozkoa" },
        faltaElNumeroDeIntervalo: "tartearen zenbakia falta da (adibidez, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» ez da tarte-zenbaki bat" },
        faltaLaCalidad: "tartearen kalitatea falta da (J, M, m, A edo d)",
        calidadNoValida: { resto in "«\(resto)» ez da tarte-kalitate bat (J, M, m, A edo d)" },
        unisonoDisminuido: "unisono gutxitua ez da existitzen: Do-tik Do♭-ra beheranzko unisono gehitua dago (idatzi -1A)",
        reglaDeLasJustas: "unisonoa, 4.a, 5.a eta 8.a justuak, gehituak edo gutxituak dira",
        reglaDeLasMayores: "2.a, 3.a, 6.a eta 7.a handiak, txikiak, gehituak edo gutxituak dira",
        intervaloInexistente: { numero, calidad, notacion, regla in "\(numero). \(calidad.nombre(en: .conPalabras(.euskera))) ez da existitzen: \(regla.euskera)" },
        alteracionNoReconocida: { signo in "«\(signo)» ez da alterazio bat (♯, ♭, 𝄪, 𝄫, #, b, x edo ♮ espero zen)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "«\(texto)» ez da altuera-klase bat (0tik 11ra, edo t eta e 10erako eta 11rako) ez nota-izen bat" },
        numeroDeForteDesconocido: { texto in "«\(texto)» ez da Forte zenbaki bat (adibidez, 3-11 edo 4-Z15)" },
        faltaElCierre: { signo in "amaierako «\(signo)» falta da" },
        serieNoDodecafonica: "serie dodekafoniko batek hamabi altuera-klaseak ditu, bakoitza behin",
        faltanEnLaSerie: { clases in "falta dira: \(clases)" },
        repetidasEnLaSerie: { clases in "errepikatuta daude: \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "«\(n)» ez da hamabost hizkuntzetako bat ere: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
