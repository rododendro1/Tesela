import Armonia
// Los textos de ArmoniaCLI en occitano. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let occitano = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acòrds> [--en <tonalitat>]",
        descripcionAnalizar: "chifratge roman, foncions, cadéncias e\nmodulacions (amb lor acòrd pivòt; sens\n--en)",
        sintaxisAnalizarArchivo: "analizar --archivo <fichièr> [--ventana <durada>]",
        descripcionAnalizarArchivo: "lo meteis, amb los acòrds d'un fichièr\nMIDI o MusicXML (un per temps ;\n--ventana 2 : un per blanca)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalitat>] [--propuestas 3]",
        descripcionArmonizar: "acòrds per una melodia, del melhor al\npièger; amb octavas (Mi4), tanben lo\ncoral a quatre voses",
        sintaxisRealizar: "realizar <acòrds> [--en <tonalitat>]",
        descripcionRealizar: "los acòrds a quatre voses, sens fautas\nde conducha",
        sintaxisRevisar: "revisar <acòrds>",
        descripcionRevisar: "fautas de conducha (quintas\nparallèlas…); acòrds del grèu a\nl'agut, separats per de virgulas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunt> [--especie 1]",
        descripcionContrapunto: "fautas d'un contrapunt d'espècias\n(1 a 5) sus un cantus firmus en\nredondas; nòtas sens durada: la de\nl'espècia",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <chifratge>…",
        descripcionAcorde: "nòtas, tipe e ròtle de cada nòta",
        sintaxisArpegio: "arpegio <chifratge> [--patron <motiu>]",
        descripcionArpegio: "nòtas de l'arpegi e gamas de\nl'acòrd (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <nòtas>",
        descripcionIdentificar: "acòrds que fan unas nòtas",
        sintaxisIntervalo: "intervalo <nòta> <nòta>",
        descripcionIntervalo: "interval entre doas nòtas o nautors",
        sintaxisEscala: "escala <gama>",
        descripcionEscala: "nòtas e acòrds d'una gama",
        sintaxisTonalidad: "tonalidad <tonalitat>",
        descripcionTonalidad: "armadura, relativas e grases",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <nòtas>",
        descripcionTonnetz: "Tonnetz en SVG d'unas nòtas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <chifratge> | --escala <gama> | --clases <nombres>",
        descripcionTonnetzAcorde: "d'un acòrd, una gama o un ensems de\nclassas de nautor",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triadas> | --camino <triada> <triada>",
        descripcionTonnetzRecorrido: "un percors de triadas, amb de sagetas,\no lo camin mai cort per P, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <cicle> <triada>",
        descripcionTonnetzCiclo: "un cicle exatonic, octatonic o LR",
        notasTonnetzCiclo: "(--margen 2: mai de malhum a l'entorn)",
        sintaxisTabla: "tabla <nòtas o nautors>",
        descripcionTabla: "taula armonica en SVG (exagònes)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "coma pel Tonnetz (--margen 2: mai de\ntaula a l'entorn)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acòrd> [--voces 2]",
        descripcionVecinos: "acòrds a un semiton (setenas:\ndominanta, menora, semidiminuida e\ndiminuida; triadas: majora, menora e\naumentada; un maj7, entre las setenas\ne los maj7; --ampliada: amb los maj7\ntanben)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acòrd> <acòrd> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d'un acòrd a l'autre en movent una\nvotz (o doas) d'un semiton a cada pas",
        sintaxisConduccionMinima: "conduccion-minima <acòrd> <acòrd>",
        descripcionConduccionMinima: "la conducha amb lo mens de semitons",
        sintaxisPlr: "plr <triada> <P, L, R…>",
        descripcionPlr: "transformacions neoriemannianas",
        sintaxisPlrCamino: "plr <triada> <triada>",
        descripcionPlrCamino: "lo camin mai cort per P, L e R",
        sintaxisPlrCiclo: "plr <triada> <cicle>",
        descripcionPlrCiclo: "un cicle: hexatonico (P, L),\noctatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eveniments> [opcions]",
        descripcionMusicxmlMelodia: "partición MusicXML d'una melodia",
        sintaxisMusicxmlCoral: "musicxml coral <acòrds> [opcions]",
        descripcionMusicxmlCoral: "coral a quatre voses en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <chifratges> [opcions]",
        descripcionMusicxmlAcordes: "progression amb chifratges e analisi",
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sòl major,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo Mon coral,\n--duracion 2 (çò que dura cada acòrd; negra dins lo coral e\nblanca dins los acòrds se que non), --cifrados e --analisis\n(dins lo coral: chifratge american dessús, roman e foncion\ndejós)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <chifratges> [opcions]",
        descripcionMusicxmlArpegios: "los acòrds arpejats, nòta a nòta",
        notasMusicxmlArpegios: "opcions: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (çò que dura cada nòta; cròcha se que\nnon), --duracion 1 (çò que dura cada acòrd: lo motiu se repetís\nfins a l'emplenar) e las autras d'«acordes»",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichièr>",
        descripcionMusicxmlArchivo: "la progression d'un fichièr MIDI o\nMusicXML, amb çò que dura cada acòrd\n(tanben arpegios, mei e midi)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opcions]",
        descripcionMeiMelodia: "lo meteis en MEI 5, lo format de las\nedicions criticas (amb las meteissas\nopcions)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opcions]",
        descripcionMidiMelodia: "lo meteis coma fichièr MIDI, per\nl'ausir (sens --clave ni --cifrados;\namb --programa 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <chifratge>… [opcions]",
        descripcionDigitaciones: "biaisses de jogar un acòrd, del mai comòde al mens, sus un\ninstrument de còrdas amb trasts (còrdas del grèu a l'agut)\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|… (tanben\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (lo mai naut que s'utiliza), --dedos 4\n(los que se pòdon utilizar), --completo (amb totas las nòtas:\nper defaut la quinta pòt mancar), --diagrama (una linha per\ncòrda)",
        sintaxisPosiciones: "posiciones <gama> [--caged]",
        descripcionPosiciones: "la gama per posicions a la guitarra:\ntres nòtas per còrda (doas dins las\npentatonicas) o CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musicala dempuèi la linha de comandas.

        Usatge: armonia <òrdre> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Òrdres (los òrdres e las opcions s'escrivon en castelhan o en anglés):
        """,
        pieDeLaAyuda: """
        S'acceptan de noms de nòta en castelhan, catalan, galician, basc, portugués, occitan o
        anglés (Do, C, Sib, Bb, si bemòl). Amb --idioma oc, la responsa utiliza la notacion occitana
        e los messatges en occitan; amb --ingles, en anglés.
        Amb --textos, los tèxtes son dins una autra lenga que las nòtas: --idioma en --textos oc.
        En castelhan e anglés, --escritura palabras|ascii|unicode escriu las nòtas coma Fa sostenido,
        Fa# o Fa♯ (en anglés, F sharp, F# o F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "aquesta ajuda",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "mancan los acòrds: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "calon dos acòrds: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "mancan las nòtas de la melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "mancan lo cantus firmus e lo contrapunt, separats per /: " + ejemplo },
        especieFueraDeRango: "--especie va d'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "mancan los acòrds: " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "manca lo chifratge: armonia acorde Sol7",
        faltaCifradoDelArpegio: "manca lo chifratge: armonia arpegio Do7",
        patronDesconocido: { patron in "motiu desconegut: «\(patron)» (ascendente, descendente, ida-y-vuelta o alberti)" },
        faltanNotas: "mancan las nòtas: armonia identificar Do Mi Sol",
        dosNotas: "calon doas nòtas: armonia intervalo Do Mi",
        faltaEscala: "manca la gama: armonia escala Re dórico",
        faltaTonalidad: "manca la tonalitat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "manca la tonalitat aprèp --en",
        faltanAcordesDelAnalisis: { ejemplo in "mancan los acòrds: " + ejemplo },
        archivoIlegible: { nombre in "se pòt pas legir lo fichièr « \(nombre) »" },
        archivoConAcordes: "amb --archivo, escrivètz pas d'acòrds",
        archivoSinAcordes: "lo fichièr a pas cap d'acòrd",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "lo marge es un nombre de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "mancan las nòtas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "manca l'acòrd: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "manca la gama: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "las classas de nautor son de nombres de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "mancan las triadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "lo cicle es exatonic, octatonic o LR, dempuèi una triada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "lo percors es fach de triadas majoras e menoras: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "lo camin va d'una triada majora o menora a una autra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "lo cicle comença sus una triada majora o menora: " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "las voses que se mòvon son 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "cal un acòrd: " + ejemplo },
        vecinosSinFamilia: "los vesins se cercan entre setenas de dominanta, menoras, semidiminuidas, diminuidas e maj7, o entre triadas majoras, menoras e aumentadas",
        dosAcordesDeCamino: { ejemplo in "calon dos acòrds: " + ejemplo },
        caminoSinConexion: "los dos acòrds devon èsser de la meteissa familha (setenas, amb maj7 o sens, o triadas) e èsser connectats",
        faltanPasosDePLR: { ejemplo in "calon una triada e de passes o una autra triada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L e R s'aplican a las triadas majoras e menoras: " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "manca «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "lo programa es un nombre General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados e --analisis son per MusicXML e MEI",
        faltaValor: { opcion in "manca la valor de --\(opcion)" },
        tempoMalEscrito: "lo tempo s'escriu «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "mancan las nòtas: " + ejemplo },
        marcasSoloCoral: "--cifrados e --analisis son per «coral»",
        duracionSoloCoral: "--duracion es sonque per «coral»",
        claveDesconocida: { clave, claves in "clau desconeguda: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "mancan los acòrds: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) es sonque per «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) es sonque per «arpegios»" },
        archivoSoloParaAcordes: "--archivo es sonque per «acordes» e «arpegios»",
        ventanaSinArchivo: "--ventana va amb --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "mancan los acòrds: " + ejemplo },
        acordesConCifradosYAnalisis: "los acòrds pòrtan totjorn chifratges e analisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s'exporta una «melodia», un «coral», d'«acordes» o lors «arpegios»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "manca l'instrument: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument desconegut: «\(nombre)» (\(lista(.occitano)))" },
        faltaLimite: "manca lo nombre de digitacions: --limite 5",
        limiteFueraDeRango: "lo limit es un nombre d'1 a 200: --limite 5",
        faltanDedos: "manca lo nombre de dets: --dedos 3",
        dedosFueraDeRango: "los dets son un nombre d'1 a 4: --dedos 3",
        faltaTraste: "manca lo trast mai naut: --traste 12",
        trasteFueraDeRango: "lo trast mai naut es un nombre de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "manca lo chifratge: \(d)" },
        faltaEscalaDePosiciones: "manca la gama: armonia posiciones Sol mayor",

        // ErrorDeUso.swift
        pruebaLaAyuda: "Ensaja «armonia ayuda».",
        ordenDesconocida: { orden in "òrdre desconegut: «\(orden)»" },
        opcionDesconocida: { opcion in "opcion desconeguda: «\(opcion)»" },
        idiomaDesconocido: { idioma in "lenga desconeguda: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        escrituraNoValida: { escritura in "escritura invalida: «\(escritura)» (palabras/words, ascii o unicode; sonque amb es e en)" },

        // Mensaje.swift
        mensajeNotas: "nòtas",
        mensajeAcordes: "acòrds",
        mensajeEscalas: "gamas",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "omonima",
        mensajeBajo: { nota in "bassa \(nota)" },
        mensajeBajoAjeno: "bassa estrangièra a l'acòrd",
        mensajeSinAcordes: "Fan pas cap d'acòrd conegut.",
        mensajeSin: { notas in "sens \(notas)" },
        mensajeSemitonos: { n in "\(n) semitons" },
        mensajeSinAlteraciones: "sens alteracions",
        mensajeSostenidos: { n in n == 1 ? "1 diesi" : "\(n) dièsis" },
        mensajeBemoles: { n in n == 1 ? "1 bemòl" : "\(n) bemòls" },
        mensajeACuatroVoces: "A quatre voses (bassa, tenor, contralt, soprano):",
        mensajeSinDigitaciones: "i a pas de digitacions comòdas",
        mensajeDedos: { n in n == 1 ? "1 det" : "\(n) dets" },
        mensajeCejilla: { traste in "barra al trast \(traste)" },
        mensajeNingunPaso: "cap de pas",
        mensajeUnPaso: "1 pas",
        mensajePasos: { n in "\(n) passes" },
        mensajeTriadas: { n in n == 1 ? "1 triada" : "\(n) triadas" }
    )
}
