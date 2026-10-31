// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en catalán. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let catalan = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acords> [--en <tonalitat>]",
        descripcionAnalizar: "xifrat romà, funcions, cadències i\nmodulacions (amb l'acord pivot;\nsense --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <fitxer> [--ventana <durada>]",
        descripcionAnalizarArchivo: "el mateix, amb els acords d'un fitxer\nMIDI o MusicXML (un per pols;\n--ventana 2: un per blanca)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalitat>] [--propuestas 3]",
        descripcionArmonizar: "acords per a una melodia, de millor\na pitjor; amb octaves (Mi4), també\nel coral a quatre veus",
        sintaxisRealizar: "realizar <acords> [--en <tonalitat>]",
        descripcionRealizar: "els acords a quatre veus, sense\nerrors de conducció",
        sintaxisRevisar: "revisar <acords>",
        descripcionRevisar: "errors de conducció (quintes\nparal·leles…); acords de greu a\nagut, separats per comes",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunt> [--especie 1]",
        descripcionContrapunto: "errors d'un contrapunt d'espècies\n(1 a 5) sobre un cantus firmus en\nrodones; notes sense durada: la de\nl'espècie",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <xifrat>…",
        descripcionAcorde: "notes, tipus i paper de cada nota",
        sintaxisArpegio: "arpegio <xifrat> [--patron <patró>]",
        descripcionArpegio: "notes de l'arpegi i escales de\nl'acord (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notes>",
        descripcionIdentificar: "acords que formen unes notes",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "interval entre dues notes o altures",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notes i acords d'una escala",
        sintaxisTonalidad: "tonalidad <tonalitat>",
        descripcionTonalidad: "armadura, relatives i graus",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "Tonnetz en SVG d'unes notes",
        sintaxisTonnetzAcorde: "tonnetz --acorde <xifrat> | --escala <escala> | --clases <nombres>",
        descripcionTonnetzAcorde: "d'un acord, una escala o un conjunt\nde classes d'altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríades> | --camino <tríada> <tríada>",
        descripcionTonnetzRecorrido: "un recorregut de tríades, amb\nfletxes, o el camí més curt per P, L\ni R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <cicle> <tríada>",
        descripcionTonnetzCiclo: "un cicle hexatònic, octatònic o LR\n(--margen 2: més xarxa al voltant)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notes o altures>",
        descripcionTabla: "taula harmònica en SVG (hexàgons)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "com al Tonnetz (--margen 2: més\ntaula al voltant)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acord> [--voces 2]",
        descripcionVecinos: "acords a un semitò (sèptimes:\ndominant, menor, semidisminuïda i\ndisminuïda; tríades: major, menor i\naugmentada; --ampliada: amb els maj7\ntambé)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acord> <acord> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d'un acord a un altre movent una veu\n(o dues) un semitò a cada pas",
        sintaxisConduccionMinima: "conduccion-minima <acord> <acord>",
        descripcionConduccionMinima: "la conducció amb menys semitons",
        sintaxisPlr: "plr <tríada> <P, L, R…>",
        descripcionPlr: "transformacions neoriemannianes",
        sintaxisPlrCamino: "plr <tríada> <tríada>",
        descripcionPlrCamino: "el camí més curt per P, L i R",
        sintaxisPlrCiclo: "plr <tríada> <cicle>",
        descripcionPlrCiclo: "un cicle: hexatonico (P, L),\noctatonico (P, R) o \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <esdeveniments> [opcions]",
        descripcionMusicxmlMelodia: "partitura MusicXML d'una melodia",
        sintaxisMusicxmlCoral: "musicxml coral <acords> [opcions]",
        descripcionMusicxmlCoral: "coral a quatre veus en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <xifrats> [opcions]",
        descripcionMusicxmlAcordes: "progressió amb xifrats i anàlisi",
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo El meu coral,\n--duracion 2 (el que dura cada acord; negra al coral i blanca\nals acords si no), --cifrados i --analisis (al coral: xifrat\namericà a dalt, romà i funció a baix)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <xifrats> [opcions]",
        descripcionMusicxmlArpegios: "els acords arpegiats, nota a nota",
        notasMusicxmlArpegios: "opcions: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (el que dura cada nota; corxera si no),\n--duracion 1 (el que dura cada acord: el patró es repeteix fins\na omplir-lo) i les altres d'«acordes»",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opcions]",
        descripcionMeiMelodia: "el mateix en MEI 5, el format de les\nedicions crítiques (amb les mateixes\nopcions)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opcions]",
        descripcionMidiMelodia: "el mateix com a fitxer MIDI, per\nescoltar-lo (sense --clave ni\n--cifrados; amb --programa 0…127,\nGeneral MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <xifrat>… [opcions]",
        descripcionDigitaciones: "maneres de tocar un acord, de la més\ncòmoda a la menys, en un instrument\nde corda amb trasts\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|… (també\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (el més alt que es fa servir), --dedos 4\n(els que es poden fer servir), --completo (amb totes les notes:\nper defecte la quinta pot faltar), --diagrama (una línia per\ncorda)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musical des de la línia d'ordres.

        Ús: armonia <ordre> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Ordres (les ordres i les opcions s'escriuen en castellà o en anglès):
        """,
        pieDeLaAyuda: """
        S'accepten noms de nota en castellà, català, gallec, basc o anglès (Do, C, Sib, Bb, si
        bemoll). Amb --idioma ca, la resposta fa servir la notació catalana i els missatges en
        català; amb --ingles, en anglès.
        Amb --textos, els textos van en un altre idioma que les notes: --idioma en --textos ca.
        En castellà i anglès, --escritura palabras|ascii|unicode escriu les notes com a Fa sostenido,
        Fa# o Fa♯ (en anglès, F sharp, F# o F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "aquesta ajuda",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "falten els acords: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "calen dos acords: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "falten les notes de la melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "falten el cantus firmus i el contrapunt, separats per /: " + ejemplo },
        especieFueraDeRango: "--especie va d'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "falten els acords: " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "falta el xifrat: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta el xifrat: armonia arpegio Do7",
        patronDesconocido: { patron in "patró desconegut: «\(patron)» (ascendente, descendente, ida-y-vuelta o alberti)" },
        faltanNotas: "falten les notes: armonia identificar Do Mi Sol",
        dosNotas: "calen dues notes: armonia intervalo Do Mi",
        faltaEscala: "falta l'escala: armonia escala Re dórico",
        faltaTonalidad: "falta la tonalitat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta la tonalitat després de --en",
        faltanAcordesDelAnalisis: { ejemplo in "falten els acords: " + ejemplo },
        archivoIlegible: { nombre in "no es pot llegir el fitxer «\(nombre)»" },
        archivoConAcordes: "amb --archivo no s'escriuen acords",
        archivoSinAcordes: "el fitxer no té cap acord",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "el marge és un nombre de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "falten les notes: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta l'acord: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta l'escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "les classes d'altura són nombres de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "falten les tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "el cicle és hexatònic, octatònic o LR, des d'una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "el recorregut és de tríades majors i menors: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "el camí va d'una tríada major o menor a una altra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "el cicle comença en una tríada major o menor: " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "les veus que es mouen són 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "cal un acord: " + ejemplo },
        vecinosSinFamilia: "els veïns es busquen entre sèptimes de dominant, menors, semidisminuïdes, disminuïdes i maj7, o entre tríades majors, menors i augmentades",
        dosAcordesDeCamino: { ejemplo in "calen dos acords: " + ejemplo },
        caminoSinConexion: "els dos acords han de ser de la mateixa família (sèptimes, amb maj7 o sense, o tríades) i estar connectats",
        faltanPasosDePLR: { ejemplo in "calen una tríada i uns passos o una altra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L i R s'apliquen a tríades majors i menors: " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "el programa és un nombre General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados i --analisis són per a MusicXML i MEI",
        faltaValor: { opcion in "falta el valor de --\(opcion)" },
        tempoMalEscrito: "el tempo s'escriu «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "falten les notes: " + ejemplo },
        marcasSoloCoral: "--cifrados i --analisis són per a «coral»",
        duracionSoloCoral: "--duracion només és per a «coral»",
        claveDesconocida: { clave, claves in "clau desconeguda: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "falten els acords: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) només és per a «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) només és per a «arpegios»" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "falten els acords: " + ejemplo },
        acordesConCifradosYAnalisis: "els acords porten sempre xifrats i anàlisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s'exporta una «melodia», un «coral», uns «acordes» o els seus «arpegios»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "falta l'instrument: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument desconegut: «\(nombre)» (\(lista(.catalan)))" },
        faltaLimite: "falta el nombre de digitacions: --limite 5",
        limiteFueraDeRango: "el límit és un nombre d'1 a 200: --limite 5",
        faltanDedos: "falta el nombre de dits: --dedos 3",
        dedosFueraDeRango: "els dits són un nombre d'1 a 4: --dedos 3",
        faltaTraste: "falta el trast més alt: --traste 12",
        trasteFueraDeRango: "el trast més alt és un nombre de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta el xifrat: \(d)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Prova «armonia ayuda».",
        ordenDesconocida: { orden in "ordre desconeguda: «\(orden)»" },
        opcionDesconocida: { opcion in "opció desconeguda: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconegut: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        escrituraNoValida: { escritura in "escriptura no vàlida: «\(escritura)» (palabras/words, ascii o unicode; només amb es i en)" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "acords",
        mensajeEscalas: "escales",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homònima",
        mensajeBajo: { nota in "baix \(nota)" },
        mensajeBajoAjeno: "baix aliè a l'acord",
        mensajeSinAcordes: "No formen cap acord conegut.",
        mensajeSin: { notas in "sense \(notas)" },
        mensajeSemitonos: { n in "\(n) semitons" },
        mensajeSinAlteraciones: "sense alteracions",
        mensajeSostenidos: { n in n == 1 ? "1 sostingut" : "\(n) sostinguts" },
        mensajeBemoles: { n in n == 1 ? "1 bemoll" : "\(n) bemolls" },
        mensajeACuatroVoces: "A quatre veus (baix, tenor, contralt, soprano):",
        mensajeSinDigitaciones: "no hi ha digitacions còmodes",
        mensajeDedos: { n in n == 1 ? "1 dit" : "\(n) dits" },
        mensajeCejilla: { traste in "celleta al trast \(traste)" },
        mensajeNingunPaso: "cap pas",
        mensajeUnPaso: "1 pas",
        mensajePasos: { n in "\(n) passos" },
        mensajeTriadas: { n in n == 1 ? "1 tríada" : "\(n) tríades" }
    )
}
