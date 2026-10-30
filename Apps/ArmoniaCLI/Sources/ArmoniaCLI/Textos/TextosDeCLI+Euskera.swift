import Armonia
// Los textos de ArmoniaCLI en euskera. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let euskera = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <akordeak> [--en <tonalitatea>]",
        descripcionAnalizar: "zifratu erromatarra, funtzioak,\nkadentziak eta modulazioak (pibota\nbarne; --en gabe)",
        sintaxisAnalizarArchivo: "analizar --archivo <fitxategia> [--ventana <iraupena>]",
        descripcionAnalizarArchivo: "gauza bera, MIDI edo MusicXML\nfitxategi baten akordeekin (bat\npultsuko; --ventana 2: bat zuriko)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalitatea>] [--propuestas 3]",
        descripcionArmonizar: "melodia baterako akordeak, onenetik\ntxarrenera; zortzidunekin (Mi4), lau\nahotseko korala ere bai",
        sintaxisRealizar: "realizar <akordeak> [--en <tonalitatea>]",
        descripcionRealizar: "akordeak lau ahotsetara, ahots-\neramate akatsik gabe",
        sintaxisRevisar: "revisar <akordeak>",
        descripcionRevisar: "ahots-eramate akatsak (bosgarren\nparaleloak…); akordeak baxutik\naltura, komaz bereizita",
        sintaxisContrapunto: "contrapunto <cantus> / <kontrapuntua> [--especie 1]",
        descripcionContrapunto: "espezie-kontrapuntu baten akatsak\n(1etik 5era) biribiletako cantus\nfirmus baten gainean; iraupenik\ngabeko notek espeziearena dute",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <zifratua>…",
        descripcionAcorde: "notak, mota eta nota bakoitzaren\npapera",
        sintaxisArpegio: "arpegio <zifratua> [--patron <eredua>]",
        descripcionArpegio: "arpegioaren notak eta akordeari\ndagozkion eskalak (--patron\nascendente, descendente,\nida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notak>",
        descripcionIdentificar: "nota batzuek osatzen dituzten\nakordeak",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "bi nota edo altueren arteko tartea",
        sintaxisEscala: "escala <eskala>",
        descripcionEscala: "eskala baten notak eta akordeak",
        sintaxisTonalidad: "tonalidad <tonalitatea>",
        descripcionTonalidad: "armadura, erlatiboak eta graduak",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notak>",
        descripcionTonnetz: "nota batzuen Tonnetza SVGn",
        sintaxisTonnetzAcorde: "tonnetz --acorde <zifratua> | --escala <eskala> | --clases <zenbakiak>",
        descripcionTonnetzAcorde: "akorde, eskala edo altuera-klase\nmultzo batena",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triadeak> | --camino <triadea> <triadea>",
        descripcionTonnetzRecorrido: "triade-ibilbide bat, geziekin, edo\nP, L eta R bidezko biderik laburrena",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <zikloa> <triadea>",
        descripcionTonnetzCiclo: "ziklo hexatoniko, oktatoniko edo LR\nbat (--margen 2: sare gehiago\ninguruan)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notak edo altuerak>",
        descripcionTabla: "taula harmonikoa SVGn (hexagonoak)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "Tonnetzean bezala (--margen 2: taula\ngehiago inguruan)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <akordea> [--voces 2]",
        descripcionVecinos: "tonuerdi batera dauden akordeak\n(zazpigarrenak: dominantea, txikia,\nerdi-gutxitua eta gutxitua;\ntriadeak: handia, txikia eta\ngehitua; --ampliada: maj7ekin ere)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <akordea> <akordea> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "akorde batetik bestera, urrats\nbakoitzean ahots bat (edo bi)\ntonuerdi bat mugituz",
        sintaxisConduccionMinima: "conduccion-minima <akordea> <akordea>",
        descripcionConduccionMinima: "tonuerdi gutxieneko ahots-eramatea",
        sintaxisPlr: "plr <triadea> <P, L, R…>",
        descripcionPlr: "eraldaketa neoerriemanndarrak",
        sintaxisPlrCamino: "plr <triadea> <triadea>",
        descripcionPlrCamino: "P, L eta R bidezko biderik laburrena",
        sintaxisPlrCiclo: "plr <triadea> <zikloa>",
        descripcionPlrCiclo: "ziklo bat: hexatonico (P, L),\noctatonico (P, R) edo \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <gertaerak> [aukerak]",
        descripcionMusicxmlMelodia: "melodia baten MusicXML partitura",
        sintaxisMusicxmlCoral: "musicxml coral <akordeak> [aukerak]",
        descripcionMusicxmlCoral: "lau ahotseko korala MusicXMLn",
        sintaxisMusicxmlAcordes: "musicxml acordes <zifratuak> [aukerak]",
        descripcionMusicxmlAcordes: "progresioa zifratu eta analisiarekin",
        notasMusicxmlAcordes: "aukerak: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (edo --tempo 60 4.), --titulo Nire\nkorala, --duracion 2 (akorde bakoitzaren iraupena; bestela\nbeltza koralean eta zuria akordeetan), --cifrados eta --analisis\n(koralean: zifratu amerikarra goian, erromatarra eta funtzioa\nbehean)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes <…> [aukerak]",
        descripcionMeiMelodia: "gauza bera MEI 5en, edizio kritikoen\nformatuan (aukera berberekin)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes <…> [aukerak]",
        descripcionMidiMelodia: "gauza bera MIDI fitxategi gisa,\nentzuteko (--clave eta --cifrados\ngabe; --programa 0…127, General\nMIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <zifratua>… [aukerak]",
        descripcionDigitaciones: "akorde bat jotzeko moduak,\nerosoenetik gutxien erosora,\ntrasteak dituen hari-instrumentu\nbatean\naukerak: --instrumento guitarra|bajo|ukelele|mandolina|… (baita\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D» ere),\n--limite 5, --traste 12 (erabiltzen den altuena), --dedos 4\n(erabil daitezkeenak), --completo (nota guztiekin: berez\nbosgarrena falta daiteke), --diagrama (lerro bat hari\nbakoitzeko)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: musika-teoria komando-lerrotik.

        Erabilera: armonia <agindua> <argumentuak> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Aginduak (aginduak eta aukerak gaztelaniaz edo ingelesez idazten dira):
        """,
        pieDeLaAyuda: """
        Nota-izenak gaztelaniaz, katalanez, galegoz, euskaraz edo ingelesez onartzen dira (Do, C,
        Sib, Bb, si bemol). --idioma eu erabiliz, erantzunak euskal notazioa eta euskarazko mezuak
        ditu; --ingles erabiliz, ingelesez.
        --textos erabiliz, testuak notak ez bezalako hizkuntzan daude: --idioma en --textos eu.
        Gaztelaniaz eta ingelesez, --escritura palabras|ascii|unicode erabiliz, notak Fa sostenido,
        Fa# edo Fa♯ idazten dira (ingelesez, F sharp, F# edo F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "laguntza hau",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "akordeak falta dira: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "bi akorde behar dira: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "melodiaren notak falta dira: " + ejemplo },
        propuestasFueraDeRango: "--propuestas 1etik 20ra doa",
        faltanVocesDelContrapunto: { ejemplo, ingles in "cantus firmusa eta kontrapuntua falta dira, / batez bereizita: " + ejemplo },
        especieFueraDeRango: "--especie 1etik 5era doa",
        faltanAcordesDeLaRealizacion: { ejemplo in "akordeak falta dira: " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "zifratua falta da: armonia acorde Sol7",
        faltaCifradoDelArpegio: "zifratua falta da: armonia arpegio Do7",
        patronDesconocido: { patron in "eredu ezezaguna: «\(patron)» (ascendente, descendente, ida-y-vuelta edo alberti)" },
        faltanNotas: "notak falta dira: armonia identificar Do Mi Sol",
        dosNotas: "bi nota behar dira: armonia intervalo Do Mi",
        faltaEscala: "eskala falta da: armonia escala Re dórico",
        faltaTonalidad: "tonalitatea falta da: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "tonalitatea falta da --en ondoren",
        faltanAcordesDelAnalisis: { ejemplo in "akordeak falta dira: " + ejemplo },
        archivoIlegible: { nombre in "ezin da «\(nombre)» fitxategia irakurri" },
        archivoConAcordes: "--archivo erabiltzean ez idatzi akorderik",
        archivoSinAcordes: "fitxategiak ez du akorderik",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "marjina 0tik 6ra bitarteko zenbaki bat da: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "notak falta dira: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "akordea falta da: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "eskala falta da: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "altuera-klaseak 0tik 11ra bitarteko zenbakiak dira: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "triadeak falta dira: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "zikloa hexatonikoa, oktatonikoa edo LR da, triade batetik abiatuta: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "ibilbidea triade handi eta txikiz osatzen da: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "bidea triade handi edo txiki batetik beste batera doa: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "zikloa triade handi edo txiki batean hasten da: " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "mugitzen diren ahotsak 1 edo 2 dira: --voces 2",
        unAcordeDeVecinos: { ejemplo in "akorde bat behar da: " + ejemplo },
        vecinosSinFamilia: "auzokideak dominanteko zazpigarrenen, txikien, erdi-gutxituen, gutxituen eta maj7en artean bilatzen dira, edo triade handi, txiki eta gehituen artean",
        dosAcordesDeCamino: { ejemplo in "bi akorde behar dira: " + ejemplo },
        caminoSinConexion: "bi akordeek familia berekoak izan behar dute (zazpigarrenak, maj7rekin edo gabe, edo triadeak) eta lotuta egon",
        faltanPasosDePLR: { ejemplo in "triade bat eta urrats batzuk edo beste triade bat behar dira: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L eta R triade handi eta txikiei aplikatzen zaizkie: " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "«melodia», «coral» edo «acordes» falta da: " + ejemplo },
        instrumentoMIDI: "programa 0tik 127ra bitarteko General MIDI zenbaki bat da: --programa 52",
        marcasSoloMusicXML: "--cifrados eta --analisis MusicXML eta MEIrako dira",
        faltaValor: { opcion in "--\(opcion) aukeraren balioa falta da" },
        tempoMalEscrito: "tempoa «--tempo 90» edo «--tempo 60 4.» idazten da",
        faltanNotasDeLaMelodia: { ejemplo, orden in "notak falta dira: " + ejemplo },
        marcasSoloCoral: "--cifrados eta --analisis «coral»erako dira",
        duracionSoloCoral: "--duracion «coral»erako bakarrik da",
        claveDesconocida: { clave, claves in "giltza ezezaguna: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "akordeak falta dira: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) «melodia»rako bakarrik da" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "akordeak falta dira: " + ejemplo },
        acordesConCifradosYAnalisis: "akordeek beti daramatzate zifratuak eta analisia",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: «melodia», «coral» edo «acordes» bat esportatzen da" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "instrumentua falta da: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumentu ezezaguna: «\(nombre)» (\(lista(.euskera)))" },
        faltaLimite: "hatz-jarrera kopurua falta da: --limite 5",
        limiteFueraDeRango: "muga 1etik 200era bitarteko zenbaki bat da: --limite 5",
        faltanDedos: "hatz kopurua falta da: --dedos 3",
        dedosFueraDeRango: "hatzak 1etik 4ra bitarteko zenbaki bat dira: --dedos 3",
        faltaTraste: "traste altuena falta da: --traste 12",
        trasteFueraDeRango: "traste altuena 0tik 24ra bitarteko zenbaki bat da: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "zifratua falta da: \(d)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Probatu «armonia ayuda».",
        ordenDesconocida: { orden in "agindu ezezaguna: «\(orden)»" },
        opcionDesconocida: { opcion in "aukera ezezaguna: «\(opcion)»" },
        idiomaDesconocido: { idioma in "hizkuntza ezezaguna: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el edo ru)" },
        escrituraNoValida: { escritura in "idazkera baliogabea: «\(escritura)» (palabras/words, ascii edo unicode; es eta en-ekin bakarrik)" },

        // Mensaje.swift
        mensajeNotas: "notak",
        mensajeAcordes: "akordeak",
        mensajeEscalas: "eskalak",
        mensajeArmadura: "armadura",
        mensajeRelativa: "erlatiboa",
        mensajeHomonima: "homonimoa",
        mensajeBajo: { nota in "baxua \(nota)" },
        mensajeBajoAjeno: "akordetik kanpoko baxua",
        mensajeSinAcordes: "Ez dute akorde ezagunik osatzen.",
        mensajeSin: { notas in "\(notas) gabe" },
        mensajeSemitonos: { n in "\(n) tonuerdi" },
        mensajeSinAlteraciones: "alteraziorik gabe",
        mensajeSostenidos: { n in "\(n) diesa" },
        mensajeBemoles: { n in "\(n) bemol" },
        mensajeACuatroVoces: "Lau ahotsetara (baxua, tenorra, altua, sopranoa):",
        mensajeSinDigitaciones: "ez dago hatz-jarrera erosorik",
        mensajeDedos: { n in "\(n) hatz" },
        mensajeCejilla: { traste in "zeja \(traste). trastean" },
        mensajeNingunPaso: "urratsik ez",
        mensajeUnPaso: "urrats 1",
        mensajePasos: { n in "\(n) urrats" },
        mensajeTriadas: { n in "\(n) triade" }
    )
}
