import Armonia
// Los textos de ArmoniaCLI en francés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let frances = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <accords> [--en <tonalité>]",
        descripcionAnalizar: "chiffrage romain, fonctions,\ncadences et modulations (avec\nl'accord pivot ; sans --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <fichier> [--ventana <durée>]",
        descripcionAnalizarArchivo: "la même chose, avec les accords d'un\nfichier MIDI ou MusicXML (un par\ntemps ; --ventana 2 : un par blanche)",
        sintaxisArmonizar: "armonizar <mélodie> [--en <tonalité>] [--propuestas 3]",
        descripcionArmonizar: "accords pour une mélodie, du\nmeilleur au moins bon ; avec octaves\n(Mi4), aussi le choral à quatre voix",
        sintaxisRealizar: "realizar <accords> [--en <tonalité>]",
        descripcionRealizar: "les accords à quatre voix, sans\nfaute de conduite des voix",
        sintaxisRevisar: "revisar <accords>",
        descripcionRevisar: "fautes de conduite des voix (quintes\nparallèles…) ; accords du grave à\nl'aigu, séparés par des virgules",
        sintaxisContrapunto: "contrapunto <cantus> / <contrepoint> [--especie 1]",
        descripcionContrapunto: "fautes d'un contrepoint d'espèces\n(1 à 5) sur un cantus firmus en\nrondes ; notes sans durée : celle de\nl'espèce",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <chiffrage>…",
        descripcionAcorde: "notes, type et rôle de chaque note",
        sintaxisArpegio: "arpegio <chiffrage> [--patron <motif>]",
        descripcionArpegio: "notes de l'arpège et gammes de\nl'accord (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notes>",
        descripcionIdentificar: "accords que forment des notes",
        sintaxisIntervalo: "intervalo <note> <note>",
        descripcionIntervalo: "intervalle entre deux notes ou\nhauteurs",
        sintaxisEscala: "escala <gamme>",
        descripcionEscala: "notes et accords d'une gamme",
        sintaxisTonalidad: "tonalidad <tonalité>",
        descripcionTonalidad: "armure, relatives et degrés",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "Tonnetz en SVG de quelques notes",
        sintaxisTonnetzAcorde: "tonnetz --acorde <chiffrage> | --escala <gamme> | --clases <nombres>",
        descripcionTonnetzAcorde: "d'un accord, d'une gamme ou d'un\nensemble de classes de hauteur",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triades> | --camino <triade> <triade>",
        descripcionTonnetzRecorrido: "un parcours de triades, avec des\nflèches, ou le chemin le plus court\npar P, L et R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <cycle> <triade>",
        descripcionTonnetzCiclo: "un cycle hexatonique, octatonique ou\nLR (--margen 2 : plus de réseau\nautour)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notes ou hauteurs>",
        descripcionTabla: "table harmonique en SVG (hexagones)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "comme pour le Tonnetz (--margen 2 :\nplus de table autour)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <accord> [--voces 2]",
        descripcionVecinos: "accords à un demi-ton (septièmes :\nde dominante, mineure, semi-diminuée\net diminuée ; triades : majeure,\nmineure et augmentée ; --ampliada :\naussi avec les maj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <accord> <accord> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d'un accord à l'autre en bougeant\nune voix (ou deux) d'un demi-ton à\nchaque étape",
        sintaxisConduccionMinima: "conduccion-minima <accord> <accord>",
        descripcionConduccionMinima: "la conduite avec le moins de demi-\ntons",
        sintaxisPlr: "plr <triade> <P, L, R…>",
        descripcionPlr: "transformations néo-riemanniennes",
        sintaxisPlrCamino: "plr <triade> <triade>",
        descripcionPlrCamino: "le chemin le plus court par P, L et\nR",
        sintaxisPlrCiclo: "plr <triade> <cycle>",
        descripcionPlrCiclo: "un cycle : hexatonico (P, L),\noctatonico (P, R) ou « ciclo LR »",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <événements> [options]",
        descripcionMusicxmlMelodia: "partition MusicXML d'une mélodie",
        sintaxisMusicxmlCoral: "musicxml coral <accords> [options]",
        descripcionMusicxmlCoral: "choral à quatre voix en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <chiffrages> [options]",
        descripcionMusicxmlAcordes: "progression avec chiffrages et\nanalyse",
        notasMusicxmlAcordes: "options : --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (ou --tempo 60 4.), --titulo Mon choral,\n--duracion 2 (la durée de chaque accord ; noire dans le choral\net blanche dans les accords sinon), --cifrados et --analisis\n(dans le choral : chiffrage américain au-dessus, romain et\nfonction au-dessous)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes <…> [options]",
        descripcionMeiMelodia: "la même chose en MEI 5, le format des\néditions critiques (avec les mêmes\noptions)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes <…> [options]",
        descripcionMidiMelodia: "la même chose en fichier MIDI, pour\nl'écouter (sans --clave ni\n--cifrados ; avec --programa 0…127,\nGeneral MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <chiffrage>… [options]",
        descripcionDigitaciones: "façons de jouer un accord, de la\nplus commode à la moins commode, sur\nun instrument à cordes et à frettes\noptions : --instrumento guitarra|bajo|ukelele|mandolina|… (aussi\n« guitarra de siete cuerdas », « bajo de 5 cuerdas », « drop D\n»), --limite 5, --traste 12 (la case la plus haute utilisée),\n--dedos 4 (ceux qu'on peut utiliser), --completo (avec toutes\nles notes : par défaut la quinte peut manquer), --diagrama (une\nligne par corde)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia : théorie musicale en ligne de commande.

        Utilisation : armonia <commande> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Commandes (les commandes et les options s'écrivent en espagnol ou en anglais) :
        """,
        pieDeLaAyuda: """
        Les noms de note s'écrivent en espagnol, catalan, galicien, basque, portugais ou anglais
        (Do, C, Sib, Bb, si bemol, ré). Avec --idioma fr, la réponse utilise la notation française
        et les messages en français ; avec --ingles, en anglais.
        Avec --textos, les textes sont dans une autre langue que les notes : --idioma en --textos fr.
        En espagnol et en anglais, --escritura palabras|ascii|unicode écrit les notes Fa sostenido,
        Fa# ou Fa♯ (en anglais, F sharp, F# ou F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "cette aide",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "il manque les accords : " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "il faut deux accords : " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "il manque les notes de la mélodie : " + ejemplo },
        propuestasFueraDeRango: "--propuestas va de 1 à 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "il manque le cantus firmus et le contrepoint, séparés par / : " + ejemplo },
        especieFueraDeRango: "--especie va de 1 à 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "il manque les accords : " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "il manque le chiffrage : armonia acorde Sol7",
        faltaCifradoDelArpegio: "il manque le chiffrage : armonia arpegio Do7",
        patronDesconocido: { patron in "motif inconnu : « \(patron) » (ascendente, descendente, ida-y-vuelta ou alberti)" },
        faltanNotas: "il manque les notes : armonia identificar Do Mi Sol",
        dosNotas: "il faut deux notes : armonia intervalo Do Mi",
        faltaEscala: "il manque la gamme : armonia escala Re dórico",
        faltaTonalidad: "il manque la tonalité : armonia tonalidad La menor",
        faltaTonalidadTrasEn: "il manque la tonalité après --en",
        faltanAcordesDelAnalisis: { ejemplo in "il manque les accords : " + ejemplo },
        archivoIlegible: { nombre in "impossible de lire le fichier « \(nombre) »" },
        archivoConAcordes: "avec --archivo, n'écrivez pas d'accords",
        archivoSinAcordes: "le fichier ne contient aucun accord",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "la marge est un nombre de 0 à 6 : --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "il manque les notes : " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "il manque l'accord : " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "il manque la gamme : " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "les classes de hauteur sont des nombres de 0 à 11 : " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "il manque les triades : " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "le cycle est hexatonique, octatonique ou LR, depuis une triade : " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "le parcours est fait de triades majeures et mineures : " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "le chemin va d'une triade majeure ou mineure à une autre : " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "le cycle commence sur une triade majeure ou mineure : " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "les voix qui bougent sont 1 ou 2 : --voces 2",
        unAcordeDeVecinos: { ejemplo in "il faut un accord : " + ejemplo },
        vecinosSinFamilia: "les voisins se cherchent parmi les septièmes de dominante, mineures, semi-diminuées, diminuées et maj7, ou parmi les triades majeures, mineures et augmentées",
        dosAcordesDeCamino: { ejemplo in "il faut deux accords : " + ejemplo },
        caminoSinConexion: "les deux accords doivent être de la même famille (septièmes, avec ou sans maj7, ou triades) et être reliés",
        faltanPasosDePLR: { ejemplo in "il faut une triade et des étapes ou une autre triade : " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L et R s'appliquent aux triades majeures et mineures : " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "il manque « melodia », « coral » ou « acordes » : " + ejemplo },
        instrumentoMIDI: "le programme est un nombre General MIDI de 0 à 127 : --programa 52",
        marcasSoloMusicXML: "--cifrados et --analisis sont pour MusicXML et MEI",
        faltaValor: { opcion in "il manque la valeur de --\(opcion)" },
        tempoMalEscrito: "le tempo s'écrit « --tempo 90 » ou « --tempo 60 4. »",
        faltanNotasDeLaMelodia: { ejemplo, orden in "il manque les notes : " + ejemplo },
        marcasSoloCoral: "--cifrados et --analisis sont pour « coral »",
        duracionSoloCoral: "--duracion n'est que pour « coral »",
        claveDesconocida: { clave, claves in "clé inconnue : « \(clave) » " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "il manque les accords : " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) n'est que pour « melodia »" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "il manque les accords : " + ejemplo },
        acordesConCifradosYAnalisis: "les accords ont toujours chiffrages et analyse",
        tipoDePartituraDesconocido: { tipo in "« \(tipo) » : on exporte une « melodia », un « coral » ou des « acordes »" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "il manque l'instrument : \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument inconnu : « \(nombre) » (\(lista(.frances)))" },
        faltaLimite: "il manque le nombre de doigtés : --limite 5",
        limiteFueraDeRango: "la limite est un nombre de 1 à 200 : --limite 5",
        faltanDedos: "il manque le nombre de doigts : --dedos 3",
        dedosFueraDeRango: "les doigts sont un nombre de 1 à 4 : --dedos 3",
        faltaTraste: "il manque la case la plus haute : --traste 12",
        trasteFueraDeRango: "la case la plus haute est un nombre de 0 à 24 : --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "il manque le chiffrage : \(d)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Essayez « armonia ayuda ».",
        ordenDesconocida: { orden in "commande inconnue : « \(orden) »" },
        opcionDesconocida: { opcion in "option inconnue : « \(opcion) »" },
        idiomaDesconocido: { idioma in "langue inconnue : « \(idioma) » (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el ou ru)" },
        escrituraNoValida: { escritura in "écriture non valide : « \(escritura) » (palabras/words, ascii ou unicode ; seulement avec es et en)" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "accords",
        mensajeEscalas: "gammes",
        mensajeArmadura: "armure",
        mensajeRelativa: "relative",
        mensajeHomonima: "homonyme",
        mensajeBajo: { nota in "basse \(nota)" },
        mensajeBajoAjeno: "basse étrangère à l'accord",
        mensajeSinAcordes: "Aucun accord connu.",
        mensajeSin: { notas in "sans \(notas)" },
        mensajeSemitonos: { n in "\(n) demi-tons" },
        mensajeSinAlteraciones: "sans altérations",
        mensajeSostenidos: { n in n == 1 ? "1 dièse" : "\(n) dièses" },
        mensajeBemoles: { n in n == 1 ? "1 bémol" : "\(n) bémols" },
        mensajeACuatroVoces: "À quatre voix (basse, ténor, alto, soprano) :",
        mensajeSinDigitaciones: "aucun doigté confortable",
        mensajeDedos: { n in n == 1 ? "1 doigt" : "\(n) doigts" },
        mensajeCejilla: { traste in "barré à la case \(traste)" },
        mensajeNingunPaso: "aucune étape",
        mensajeUnPaso: "1 étape",
        mensajePasos: { n in "\(n) étapes" },
        mensajeTriadas: { n in n == 1 ? "1 triade" : "\(n) triades" }
    )
}
