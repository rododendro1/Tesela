// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let hungaro = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <akkordok> [--in <hangnem>]",
        descripcionAnalizar: "fokszámok, funkciók, zárlatok és\nmodulációk (közvetítő akkordjukkal;\n--in nélkül)",
        sintaxisAnalizarArchivo: "analyze --file <fájl> [--window <időtartam>]",
        descripcionAnalizarArchivo: "ugyanez egy MIDI- vagy MusicXML-fájl\nakkordjaival (ütésenként egy;\n--window 2: félhangonként egy)",
        sintaxisArmonizar: "harmonize <dallam> [--in <hangnem>] [--proposals 3]",
        descripcionArmonizar: "akkordok egy dallamhoz, a legjobb\nelöl; oktávokkal (E4) a négyszólamú\nkorál is",
        sintaxisRealizar: "realize <akkordok> [--in <hangnem>]",
        descripcionRealizar: "az akkordok négy szólamban,\nszólamvezetési hibák nélkül",
        sintaxisRevisar: "check <akkordok>",
        descripcionRevisar: "szólamvezetési hibák (párhuzamos\nkvintek…); akkordok mélytől\nmagasig, vesszővel elválasztva",
        sintaxisContrapunto: "counterpoint <cantus> / <ellenpont> [--species 1]",
        descripcionContrapunto: "hibák a fajtás ellenpontban (1–5)\negész hangokban írt cantus firmus\nfölött; az időtartam nélküli hangok a\nfajtáét kapják",
        sintaxisTransponer: "transpose <hangköz|alaphang> <akkordok vagy hangok>",
        descripcionTransponer: "akkordokat, dallamot vagy korált visz\nát másik hangnembe: hangköz (M2, -m3)\nvagy az új alaphang (D)",
        sintaxisRearmonizar: "reharmonize <akkordok> [--in <hangnem>]",
        descripcionRearmonizar: "más harmóniák minden akkordhoz:\ntritónuszhelyettesítés,\nmellékdominánsok, modális kölcsönzés\nés diatonikus helyettesítések",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <akkordjelzés>…",
        descripcionAcorde: "hangok, típus és minden hang szerepe",
        sintaxisArpegio: "arpeggio <akkordjelzés> [--pattern <minta>]",
        descripcionArpegio: "a felbontás hangjai és az akkordhoz\nillő skálák (--pattern ascending,\ndescending, up-down, alberti)",
        sintaxisIdentificar: "identify <hangok>",
        descripcionIdentificar: "a hangokból alkotható akkordok",
        sintaxisIntervalo: "interval <hang> <hang>",
        descripcionIntervalo: "két hang vagy hangmagasság közötti\nhangköz",
        sintaxisEscala: "scale <skála>",
        descripcionEscala: "egy skála hangjai és akkordjai",
        sintaxisTonalidad: "key <hangnem>",
        descripcionTonalidad: "előjegyzés, rokon hangnemek és fokok",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <hangok>",
        descripcionTonnetz: "néhány hang Tonnetze SVG-ben",
        sintaxisTonnetzAcorde: "tonnetz --chord <jelzés> | --scale <skála> | --pcs <számok>",
        descripcionTonnetzAcorde: "egy akkordé, egy skáláé vagy egy\nhangosztályhalmazé",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <hármashangzatok> | --shortest <hármashangzat> <hármashangzat>",
        descripcionTonnetzRecorrido: "hármashangzatok sora nyilakkal, vagy\na legrövidebb út P, L és R mentén",
        sintaxisTonnetzCiclo: "tonnetz --cycle <ciklus> <hármashangzat>",
        descripcionTonnetzCiclo: "hexatonikus, oktatonikus vagy\nLR-ciklus",
        notasTonnetzCiclo: "(--margen 2: több rács körülötte)",
        sintaxisTabla: "tabla <hangok vagy hangmagasságok>",
        descripcionTabla: "harmonikus tábla SVG-ben (hatszögek)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "mint a Tonnetznél (--margen 2: több\ntábla körülötte)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <akkord> [--voices 2]",
        descripcionVecinos: "félhangnyira lévő akkordok\n(szeptimakkordok: domináns, moll,\nfélszűkített és szűkített;\nhármashangzatok: dúr, moll és\nbővített; egy maj7 a\nszeptimakkordok és a maj7-ek között;\n--extended: a maj7-ekkel is)",
        sintaxisConduccionParsimoniosa: "smooth-path <akkord> <akkord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "egyik akkordtól a másikig, minden\nlépésben egy (vagy két) szólam mozog\nfélhangot",
        sintaxisConduccionMinima: "minimal-voice-leading <akkord> <akkord>",
        descripcionConduccionMinima: "a legkevesebb félhangú szólamvezetés",
        sintaxisPlr: "plr <hármashangzat> <P, L, R…>",
        descripcionPlr: "neo-riemanni transzformációk",
        sintaxisPlrCamino: "plr <hármashangzat> <hármashangzat>",
        descripcionPlrCamino: "a legrövidebb út P, L és R mentén",
        sintaxisPlrCiclo: "plr <hármashangzat> <ciklus>",
        descripcionPlrCiclo: "ciklus: hexatonic (P, L),\noctatonic (P, R) vagy \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <események> [opciók]",
        descripcionMusicxmlMelodia: "egy dallam MusicXML-kottája",
        sintaxisMusicxmlCoral: "musicxml chorale <akkordok> [opciók]",
        descripcionMusicxmlCoral: "négyszólamú korál MusicXML-ben",
        sintaxisMusicxmlAcordes: "musicxml chords <jelzések> [opciók]",
        descripcionMusicxmlAcordes: "akkordmenet jelzésekkel és elemzéssel",
        notasMusicxmlAcordes: "opciók: --compas 6/8 (ütemmutató), --anacrusa 8 (felütés),\n--tonalidad G major (hangnem), --clave fa (kulcs), --tempo 90\n(vagy --tempo 60 4.), --titulo Korálom (cím), --duracion 2 (az\nakkordok hossza; alapból negyed a korálban és fél az\nakkordoknál), --cifrados és --analisis (a korálban: fölül\nakkordjelzések, alul fokszámok és funkció)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <jelzések> [opciók]",
        descripcionMusicxmlArpegios: "az akkordok felbontva, hangról hangra",
        notasMusicxmlArpegios: "opciók: --patron alberti (vagy up, down, up-down), --figura 16\n(a hangok hossza; alapból nyolcad), --duracion 1 (az akkordok\nhossza: a minta ismétlődik, amíg ki nem tölti) és a \"chords\"\ntöbbi opciója",
        sintaxisMusicxmlArchivo: "musicxml chords --file <fájl>",
        descripcionMusicxmlArchivo: "egy MIDI- vagy MusicXML-fájl\nakkordmenete az akkordok hosszával\n(arpeggios, mei és midi is)",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios <…> [opciók]",
        descripcionMeiMelodia: "ugyanez MEI 5-ben, a kritikai\nkiadások formátumában (ugyanazokkal\naz opciókkal)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios <…> [opciók]",
        descripcionLilypondMelodia: "ugyanez LilyPondban, hogy PDF-be\nszedd a kottát",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios <…> [opciók]",
        descripcionAbcMelodia: "ugyanez ABC-ben, a népzene szöveges\nkottaírásában",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios <…> [opciók]",
        descripcionMidiMelodia: "ugyanez MIDI-fájlként, meghallgatásra\n(--clave és --cifrados nélkül;\n--program 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <akkordjelzés>… [opciók]",
        descripcionDigitaciones: "egy akkord fogásai a legkényelmesebbtől a legkevésbé kényelmesig,\nbundos húros hangszeren (a húrok mélytől magasig)\nopciók: --instrument guitar|bass|ukulele|mandolin|… (\"seven-string\nguitar\", \"five-string bass\", \"drop D\" is), --limit 5, --fret 12\n(a legmagasabb használt bund), --fingers 4 (hány ujj használható),\n--complete (minden hanggal: alapból a kvint elhagyható), --diagram\n(húronként egy sor), --capo 2 (a bundok a kapodasztertől számítva),\n--musicxml (minden akkord első fogása MusicXML-tabulatúraként)",
        sintaxisPosiciones: "positions <skála> [--caged]",
        descripcionPosiciones: "a skála fekvésenként a gitáron:\nhúronként három hang (a pentatonnál\nkettő) vagy CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: zeneelmélet a parancssorban.

        Használat: armonia <parancs> <argumentumok> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Parancsok (a parancsok és az opciók spanyolul vagy angolul íródnak):
        """,
        pieDeLaAyuda: """
        A hangneveket spanyolul, katalánul, galíciaiul, baszkul, portugálul vagy angolul fogadja el
        (Do, C, Sib, Bb, si bemol). A --idioma hu kapcsolóval a válasz magyar hangneveket (B, H, Fisz)
        és magyar üzeneteket használ; a --ingles kapcsolóval angolt.
        A --textos kapcsolóval a szövegek más nyelven vannak, mint a hangok: --idioma en --textos hu.
        Spanyolul és angolul a --escritura palabras|ascii|unicode így írja a hangokat:
        Fa sostenido, Fa# vagy Fa♯ (angolul F sharp, F# vagy F♯).
        A --subindices kapcsolóval az oktáv alsó indexbe kerül: La₄, Fa♯₃ (mindkettőt olvassa, La4 és La₄).
        """,
        sintaxisAyuda: "help",
        descripcionAyuda: "ez a súgó",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "a parancsok és az opciók kiegészítése\na parancsértelmezőben",
        sintaxisManual: "manual",
        descripcionManual: "ez a súgó kézikönyvoldalként",
        manualNombre: "NÉV",
        manualNotas: "MEGJEGYZÉSEK",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "hiányoznak az akkordok: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "két akkord kell: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "hiányoznak a dallam hangjai: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "a --proposals értéke 1 és 20 között lehet",
        faltanVocesDelContrapunto: { ejemplo, ingles in "hiányzik a cantus firmus és az ellenpont, /-rel elválasztva: " + ingles },
        especieFueraDeRango: "a --species értéke 1 és 5 között lehet",
        faltanAcordesDeLaRealizacion: { ejemplo in "hiányoznak az akkordok: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "hiányzik az akkordjelzés: armonia chord G7",
        faltaCifradoDelArpegio: "hiányzik az akkordjelzés: armonia arpeggio C7",
        patronDesconocido: { patron in "ismeretlen minta: „\(patron)” (ascending, descending, up-down, down-up, broken vagy alberti)" },
        faltanNotas: "hiányoznak a hangok: armonia identify C E G",
        dosNotas: "két hang kell: armonia interval C E",
        faltaEscala: "hiányzik a skála: armonia scale D dorian",
        faltaTonalidad: "hiányzik a hangnem: armonia key A minor",
        faltaTonalidadTrasEn: "hiányzik a hangnem a --in után",
        faltanAcordesDelAnalisis: { ejemplo in "hiányoznak az akkordok: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "nem olvasható a fájl: „\(nombre)”" },
        archivoConAcordes: "a --file mellett ne írj akkordokat",
        archivoSinAcordes: "a fájlban nincsenek akkordok",
        faltaTransporte: { ejemplo in "hiányzik a hangköz (vagy az új alaphang) és az, amit transzponálni kell: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "hiányoznak az akkordok: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "a margó 0 és 6 közötti szám: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "hiányoznak a hangok: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "hiányzik az akkord: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "hiányzik a skála: armonia \(orden) --scale D dorian" },
        clasesFueraDeRango: { ejemplo, orden in "a hangosztályok 0 és 11 közötti számok: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "hiányoznak a hármashangzatok: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "a ciklus hexatonikus, oktatonikus vagy LR, egy hármashangzattól indulva: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "a sor dúr és moll hármashangzatokból áll: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "a legrövidebb út egy dúr vagy moll hármashangzattól egy másikig vezet: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "a ciklus dúr vagy moll hármashangzaton kezdődik: armonia \(orden) --cycle hexatonic C" },

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "1 vagy 2 szólam mozog: --voices 2",
        unAcordeDeVecinos: { ejemplo in "egy akkord kell: armonia neighbors G7" },
        vecinosSinFamilia: "a szomszédokat domináns, moll, félszűkített, szűkített és maj7 szeptimakkordok, vagy dúr, moll és bővített hármashangzatok között keresi",
        dosAcordesDeCamino: { ejemplo in "két akkord kell: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "a két akkordnak ugyanabba a családba kell tartoznia (szeptimakkordok, maj7-tel vagy anélkül, vagy hármashangzatok), és összeköthetőnek kell lennie",
        faltanPasosDePLR: { ejemplo in "egy hármashangzat és lépések vagy egy másik hármashangzat kell: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "a P, L és R dúr és moll hármashangzatokra vonatkozik: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "hiányzik a „melody”, „chorale” vagy „chords”: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "a program 0 és 127 közötti General MIDI-szám: --program 52",
        marcasSoloMusicXML: "a --cifrados és a --analisis a MusicXML, a MEI, a LilyPond és az ABC számára van",
        faltaValor: { opcion in "hiányzik a --\(opcion) értéke" },
        tempoMalEscrito: "a tempó írásmódja „--tempo 90” vagy „--tempo 60 4.”",
        faltanNotasDeLaMelodia: { ejemplo, orden in "hiányoznak a hangok: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "a --cifrados és a --analisis a „chorale” számára van",
        duracionSoloCoral: "a --duracion csak a „chorale” számára van",
        claveDesconocida: { clave, claves in "ismeretlen kulcs: „\(clave)” (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "hiányoznak az akkordok: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "a --\(opcion) csak a „melody” számára van" },
        soloParaArpegios: { opcion in "a --\(opcion) csak az „arpeggios” számára van" },
        archivoSoloParaAcordes: "a --file csak a „chords” és az „arpeggios” számára van",
        ventanaSinArchivo: "a --window a --file mellé tartozik",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "hiányoznak az akkordok: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "az akkordok mindig akkordjelzéssel és elemzéssel jelennek meg",
        tipoDePartituraDesconocido: { tipo in "„\(tipo)”: az export lehet „melody”, „chorale”, „chords” vagy ezek „arpeggios” változata" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "hiányzik a hangszer: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "ismeretlen hangszer: „\(nombre)” (\(lista(.hungaro)))" },
        faltaLimite: "hiányzik a fogások száma: --limit 5",
        limiteFueraDeRango: "a korlát 1 és 200 közötti szám: --limit 5",
        faltanDedos: "hiányzik az ujjak száma: --fingers 3",
        dedosFueraDeRango: "az ujjak száma 1 és 4 között lehet: --fingers 3",
        faltaTraste: "hiányzik a legmagasabb bund: --fret 12",
        trasteFueraDeRango: "a legmagasabb bund 0 és 24 közötti szám: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "hiányzik az akkordjelzés: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "hiányzik a skála: armonia positions G major",
        capoFueraDeRango: "a kapodaszter 0 és 12 közötti szám: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Próbáld ki: „armonia help”.",
        ordenDesconocida: { orden in "ismeretlen parancs: „\(orden)”" },
        opcionDesconocida: { opcion in "ismeretlen opció: „\(opcion)”" },
        idiomaDesconocido: { idioma in "ismeretlen nyelv: „\(idioma)” (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru vagy hu)" },
        terminalDesconocida: { t in "ismeretlen parancsértelmező: „\(t)” (bash, zsh vagy fish)" },
        escrituraNoValida: { escritura in "érvénytelen írásmód: „\(escritura)” (palabras/words, ascii vagy unicode; csak es és en mellett)" },

        // Mensaje.swift
        mensajeNotas: "hangok",
        mensajeAcordes: "akkordok",
        mensajeEscalas: "skálák",
        mensajeArmadura: "előjegyzés",
        mensajeRelativa: "párhuzamos hangnem",
        mensajeHomonima: "azonos alaphangú hangnem",
        mensajeBajo: { nota in "basszus: \(nota)" },
        mensajeBajoAjeno: "a basszus nincs az akkordban",
        mensajeSinAcordes: "Nem található ismert akkord.",
        mensajeSin: { notas in "\(notas) nélkül" },
        mensajeSemitonos: { n in "\(n) félhang" },
        mensajeSinAlteraciones: "nincs előjegyzés",
        mensajeSostenidos: { n in Idioma.hungaro.contar(n, "kereszt") },
        mensajeBemoles: { n in Idioma.hungaro.contar(n, "bé") },
        mensajeACuatroVoces: "Négy szólamban (basszus, tenor, alt, szoprán):",
        mensajeSinDigitaciones: "nem található kényelmes fogás",
        mensajeDedos: { n in Idioma.hungaro.contar(n, "ujj") },
        mensajeCejilla: { traste in "barré: \(traste). bund" },
        mensajeNingunPaso: "nincs lépés",
        mensajeUnPaso: "1 lépés",
        mensajePasos: { n in "\(n) lépés" },
        mensajeTriadas: { n in Idioma.hungaro.contar(n, "hármashangzat") }
    )
}
