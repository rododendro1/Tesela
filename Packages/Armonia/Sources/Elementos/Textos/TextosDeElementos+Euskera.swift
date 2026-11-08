// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en euskera. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let euskera = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "justua",
        calidadMayor: "handia",
        calidadMenor: "txikia",
        calidadAumentada: "gehitua",
        calidadDisminuida: "gutxitua",
        multiplicidadSimple: "",
        multiplicidadDoble: "bi aldiz ",
        multiplicidadTriple: "hiru aldiz ",
        multiplicidad: "{1} aldiz ",
        plantillaDescendente: "beheranzko {1}",
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
        noSePuedeLeer: "Ezin da «{1}» irakurri",
        caracter: { p in " (\(p + 1). karakterea)" },
        textoVacio: "testua hutsik dago",
        caracteresSobrantes: "«{1}» soberan dago",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "nota-izen bat espero zen (Do, Re, Mi… edo C, D, E…)",
        faltaLaOctava: "zortziduna falta da (adibidez, Do4)",
        octavaNoValida: "«{1}» ez da zortzidun baliozkoa",
        faltaElNumeroDeIntervalo: "tartearen zenbakia falta da (adibidez, 3M)",
        numeroDeIntervaloNoValido: "«{1}» ez da tarte-zenbaki bat",
        faltaLaCalidad: "tartearen kalitatea falta da (J, M, m, A edo d)",
        calidadNoValida: "«{1}» ez da tarte-kalitate bat (J, M, m, A edo d)",
        unisonoDisminuido: "unisono gutxitua ez da existitzen: Do-tik Do♭-ra beheranzko unisono gehitua dago (idatzi -1A)",
        reglaDeLasJustas: "unisonoa, 4.a, 5.a eta 8.a justuak, gehituak edo gutxituak dira",
        reglaDeLasMayores: "2.a, 3.a, 6.a eta 7.a handiak, txikiak, gehituak edo gutxituak dira",
        intervaloInexistente: { numero, calidad, notacion, regla in "\(numero). \(calidad.nombre(en: .conPalabras(.euskera))) ez da existitzen: \(regla.texto(en: .euskera))" },
        alteracionNoReconocida: "«{1}» ez da alterazio bat (♯, ♭, 𝄪, 𝄫, #, b, x edo ♮ espero zen)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» ez da altuera-klase bat (0tik 11ra, edo t eta e 10erako eta 11rako) ez nota-izen bat",
        numeroDeForteDesconocido: "«{1}» ez da Forte zenbaki bat (adibidez, 3-11 edo 4-Z15)",
        faltaElCierre: "amaierako «{1}» falta da",
        serieNoDodecafonica: "serie dodekafoniko batek hamabi altuera-klaseak ditu, bakoitza behin",
        faltanEnLaSerie: "falta dira: {1}",
        repetidasEnLaSerie: "errepikatuta daude: {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» ez da hamahiru hizkuntzetako bat ere: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
