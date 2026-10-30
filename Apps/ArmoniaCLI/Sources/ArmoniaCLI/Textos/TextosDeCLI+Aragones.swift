import Armonia
// Los textos de ArmoniaCLI en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let aragones = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidat>]",
        descripcionAnalizar: "cifrau romano, funcions, cadencias\ny modulacions (con o suyo acorde\npivot; sin --en)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidat>] [--propuestas 3]",
        descripcionArmonizar: "acordes ta una melodía, de millor a\npior; con octavas (Mi4), tamién o\ncoral a cuatro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidat>]",
        descripcionRealizar: "os acordes a cuatro voces, sin\nfaltas de conducción",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "faltas de conducción (quintas\nparalelas…); acordes de grave a\nagudo, separaus por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "faltas d\'un contrapunto d\'especies\n(1 a 5) sobre un cantus firmus en\nredondas; notas sin duración: a\nd\'a especie",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrau>…",
        descripcionAcorde: "notas, tipo y papel de cada nota",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unas notas",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dos notas u alturas",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notas y acordes d\'una escala",
        sintaxisTonalidad: "tonalidad <tonalidat>",
        descripcionTonalidad: "armadura, relativas y grados",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG d\'unas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrau> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "d\'un acorde, una escala u un\nconchunto de clases d\'altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un recorrido de tríadas, con flechas,\nu o camín más curto por P, L y R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríada>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico u LR",
        notasTonnetzCiclo: "(--margen 2: más ret arredol)",
        sintaxisTabla: "tabla <notas u alturas>",
        descripcionTabla: "tabla armónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde <cifrau> | --escala <escala> | --clases <números>\ntabla --recorrido <tríadas> | --camino <tríada> <tríada>\ntabla --ciclo <ciclo> <tríada>",
        descripcionTablaAcorde: "(--margen 2: más tabla arredol)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semitono (séptimas: dominant, menor, semidisminuida\ny disminuida; tríadas: mayor, menor y aumentada; un maj7, entre\nas séptimas y os maj7; --ampliada: con os maj7 tamién)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d\'un acorde a atro movendo una voz\n(u dos) un semitono en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "a conducción con menos semitonos",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "transformacions neorriemannianas",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "o camín más curto por P, L y R",
        sintaxisPlrCiclo: "plr <tríada> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L),\noctatonico (P, R) u \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opcions]",
        descripcionMusicxmlMelodia: "partitura MusicXML d\'una melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opcions]",
        descripcionMusicxmlCoral: "coral a cuatro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifraus> [opcions]",
        descripcionMusicxmlAcordes: "progresión con cifraus y análisi",
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (u --tempo 60 4.), --titulo O mio coral,\n--duracion 2 (o que dura cada acorde; negra en o coral y\nblanca en os acordes si no), --cifrados y --analisis (en o\ncoral: cifrau americano encima, romano y función debaixo)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes <…> [opcions]",
        descripcionMeiMelodia: "o mesmo en MEI 5, o formato d\'as\nedicions críticas (con as mesmas\nopcions)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes <…> [opcions]",
        descripcionMidiMelodia: "o mesmo como fichero MIDI, ta sentir-lo\n(sin --clave ni --cifrados; con\n--programa 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrau>… [opcions]",
        descripcionDigitaciones: "formas de tocar un acorde, d\'a más cómoda a la menos, en un\ninstrumento de cuerda con trastes (cuerdas de grave a agudo)\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|…\n(tamién «guitarra de siete cuerdas», «bajo de 5 cuerdas»,\n«drop D»), --limite 5, --traste 12 (o más alto que se fa servir),\n--dedos 4 (os que se pueden fer servir), --completo (con todas as notas:\nper defecto a quinta puede faltar), --diagrama (una linia per cuerda)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical dende a linia de comandos.

        Uso: armonia <orden> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Ordens (as ordens y as opcions s'escriben en castellano u en anglés):
        """,
        pieDeLaAyuda: """
        S'acceptan nombres de nota en castellano, aragonés, catalán, gallego, basco u anglés (Do, C,
        Sib, Bb, si bemol). Con --idioma an, a respuesta fa servir a notación aragonesa y os mensaches
        en aragonés; con --ingles, en anglés.
        Con --textos, os textos van en atro idioma que as notas: --idioma en --textos an.
        En castellano y anglés, --escritura palabras|ascii|unicode escribe as notas como Fa sostenido,
        Fa# u Fa♯ (en anglés, F sharp, F# u F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "esta aduya",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "faltan os acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "fan falta dos acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "faltan as notas d\'a melodía: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d\'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "faltan o cantus firmus y o contrapunto, deseparaus por /: " + ejemplo },
        especieFueraDeRango: "--especie va d\'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "falta o cifrau: armonia acorde Sol7",
        faltanNotas: "faltan as notas: armonia identificar Do Mi Sol",
        dosNotas: "fan falta dos notas: armonia intervalo Do Mi",
        faltaEscala: "falta a escala: armonia escala Re dórico",
        faltaTonalidad: "falta a tonalidat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta a tonalidat dimpués de --en",
        faltanAcordesDelAnalisis: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "o marguin ye un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan as notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta l\'acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta a escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "as clases d\'altura son números de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan as tríadas: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "o ciclo ye hexatónico, octatónico u LR, dende una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "o recorrido ye de tríadas mayors y menors: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "o camín va d\'una tríada mayor u menor a unatra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "o ciclo empecipia en una tríada mayor u menor: " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "as voces que se mueven son 1 u 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "fa falta un acorde: " + ejemplo },
        vecinosSinFamilia: "os vecinos se buscan entre séptimas de dominant, menors, semidisminuidas, disminuidas y maj7, u entre tríadas mayors, menors y aumentadas",
        dosAcordesDeCamino: { ejemplo in "fan falta dos acordes: " + ejemplo },
        caminoSinConexion: "os dos acordes han de estar d\'a mesma familia (séptimas, con u sin maj7, u tríadas) y estar connectaus",
        faltanPasosDePLR: { ejemplo in "fan falta una tríada y bels pasos u atra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L y R s\'aplican a tríadas mayors y menors: " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» u «acordes»: " + ejemplo },
        instrumentoMIDI: "o programa ye un número General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados y --analisis son ta MusicXML y MEI",
        faltaValor: { opcion in "falta o valor de --\(opcion)" },
        tempoMalEscrito: "o tempo s\'escribe «--tempo 90» u «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "faltan as notas: " + ejemplo },
        marcasSoloCoral: "--cifrados y --analisis son ta «coral»",
        duracionSoloCoral: "--duracion ye nomás ta «coral»",
        claveDesconocida: { clave, claves in "clau desconoixida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) ye nomás ta «melodia»" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "os acordes leban siempre cifraus y análisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s\'exporta una «melodia», un «coral» u bels «acordes»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "falta o instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento desconoixiu: «\(nombre)» (\(lista(.aragones)))" },
        faltaLimite: "falta o número de digitacions: --limite 5",
        limiteFueraDeRango: "o límite ye un número d\'1 a 200: --limite 5",
        faltanDedos: "falta o número de didos: --dedos 3",
        dedosFueraDeRango: "os didos son un número d\'1 a 4: --dedos 3",
        faltaTraste: "falta o traste más alto: --traste 12",
        trasteFueraDeRango: "o traste más alto ye un número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta o cifrau: \(d)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Preba «armonia ayuda».",
        ordenDesconocida: { orden in "orden desconoixida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción desconoixida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconoixiu: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        escrituraNoValida: { escritura in "escritura no valida: «\(escritura)» (palabras/words, ascii u unicode; nomás con es y en)" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "baixo \(nota)" },
        mensajeBajoAjeno: "baixo difuera de l\'acorde",
        mensajeSinAcordes: "No forman garra acorde conoixiu.",
        mensajeSin: { notas in "sin \(notas)" },
        mensajeSemitonos: { n in "\(n) semitonos" },
        mensajeSinAlteraciones: "sin alteracions",
        mensajeSostenidos: { n in n == 1 ? "1 sosteniu" : "\(n) sostenius" },
        mensajeBemoles: { n in n == 1 ? "1 bemol" : "\(n) bemols" },
        mensajeACuatroVoces: "A cuatro voces (baixo, tenor, contralto, soprano):",
        mensajeSinDigitaciones: "no bi ha digitacions cómodas",
        mensajeDedos: { n in n == 1 ? "1 dido" : "\(n) didos" },
        mensajeCejilla: { traste in "ceja en o traste \(traste)" },
        mensajeNingunPaso: "garra paso",
        mensajeUnPaso: "1 paso",
        mensajePasos: { n in "\(n) pasos" },
        mensajeTriadas: { n in n == 1 ? "1 tríada" : "\(n) tríadas" }
    )
}
