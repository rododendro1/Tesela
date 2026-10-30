// Los textos de ArmoniaNucleo en euskera. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let euskera = TextosDeNucleo(
        // Intervalo+Idiomas.swift
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

        // Nota+Idiomas.swift
        palabraNatural: "bekadro",
        palabraSostenido: "diesa",
        palabraBemol: "bemol",
        multiplicadores: ["bikoitza", "hirukoitza", "laukoitza"],
        palabraSostenidos: "diesa",
        palabraBemoles: "bemol",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "«\(simbolo)» ez dago zifratu ezagunetan" },
        tensionNoValida: { tension in "«\(tension)» ez da tentsio baliozkoa (♭/♯ 5, 9, 11 eta 13rekin onartzen dira, eta add 2, 4, 6, 9, 11 eta 13rekin)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» ez da akorde-zenbaki bat (5, 6, 7, 9, 11 edo 13)" },
        numeroRepetido: { numero in "«\(numero)» beste zenbaki baten ondoren dago; tentsio gehigarriak parentesi artean doaz, 7(9)-n bezala" },
        disminuidoYSemidisminuido: "gutxitua (°) eta erdi-gutxitua (ø) ezin dira batera erabili",
        quintaConCalidad: "bosgarren akordeak (5) ez du hirugarrenik, beraz ez ditu m, °, ø eta + onartzen",
        fundamentalNoOmitible: "oinarria ezin da kendu",
        gradoNoOmitible: { grado in "«omit\(grado)» ez da baliozkoa (3, 5, 7, 9, 11 eta 13 ken daitezke)" },
        faltaLaFundamental: "oinarria falta da",
        intervaloSinPapel: { intervalo, notacion in "\(intervalo.nombre(en: .euskera)): tarte honek ez du paperik hirugarrenez osatutako akorde batean" },
        terceraMayorYMenor: "hirugarren handia eta txikia ditu aldi berean (♯9 9. gehitu gisa idazten da, ez 3. txiki gisa)",
        variasSeptimas: "zazpigarren bat baino gehiago ditu",
        septimaDisminuidaFueraDelDisminuido: "zazpigarren gutxitua akorde gutxituan bakarrik agertzen da (3. txikiarekin eta 5. gutxituarekin)",
        noEsPorTerceras: "ez da hirugarrenez osatutako akordea",
        bajoNoValido: { bajo in "«\(bajo)» ez da baxurako nota-izen bat" },
        idiomasMezclados: { nombre in "«\(nombre)» oinarria ez bezalako hizkuntzan idatzita dago: idatzi dena silabekin (Sol7/Si) edo dena letrekin (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "«\(nombre)» ez da tonalitate baten modua: tonalitatea maiorra edo minorra da (beste moduetarako, erabili Escala)" },
        faltaElTipoDeEscala: "eskala-mota falta da (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» ez da eskala-mota ezagun bat" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Balio baliogabea",
        noSePuedeLeer: { texto in "Ezin da «\(texto)» irakurri" },
        caracter: { p in " (\(p + 1). karakterea)" },
        textoVacio: "testua hutsik dago",
        caracteresSobrantes: { resto in "«\(resto)» soberan dago" },

        // ErrorDeLectura+Notas.swift
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
        intervaloInexistente: { numero, calidad, notacion, regla in "\(numero). \(calidad.nombre(en: .euskera)) ez da existitzen: \(regla.euskera)" },
        alteracionNoReconocida: { signo in "«\(signo)» ez da alterazio bat (♯, ♭, 𝄪, 𝄫, #, b, x edo ♮ espero zen)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "«\(texto)» ez da iraupen bat: figura bat espero zen (1, 2, 4, 8, 16…, puntuekin: 4.) edo biribilaren zatiki bat (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» ez da konpas bat: zenbakitzailea/izendatzailea espero zen, izendatzailea 2ren berretura izanik (4/4, 6/8, 7/8), C edo ¢" },
        vocesDistintas: "akorde guztiek ahots kopuru bera izan behar dute, eta gutxienez bi",
        contrapuntoDeOtraDuracion: { redondas in "kontrapuntuak cantus firmusak beste iraun behar du: \(redondas) biribil, nota bakoitzeko bat" }
    )
}
