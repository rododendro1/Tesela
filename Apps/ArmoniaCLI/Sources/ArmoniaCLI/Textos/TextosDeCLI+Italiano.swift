// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en italiano. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let italiano = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <accordi> [--en <tonalità>] [--escalas]",
        descripcionAnalizar: "numeri romani, funzioni, cadenze e\nmodulazioni (con l'accordo perno;\nsenza --en)\n--escalas: la scala di ogni accordo,\ncon tensioni e note da evitare",
        notasAnalizar: "--notas-guia: due linee di note guida,\ndalla terza e dalla settima",
        sintaxisAnalizarArchivo: "analizar --archivo <file> [--ventana <durata>]",
        descripcionAnalizarArchivo: "lo stesso, con gli accordi di un file\nMIDI, MusicXML, MEI o ABC (uno per\npulsazione; --ventana 2: uno per\nminima)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalità>] [--propuestas 3]",
        descripcionArmonizar: "accordi per una melodia, dal\nmigliore al peggiore; con le ottave\n(Mi4), anche il corale a quattro\nvoci",
        sintaxisRealizar: "realizar <accordi> [--en <tonalità>]",
        descripcionRealizar: "gli accordi a quattro voci, senza\nerrori di condotta delle parti",
        sintaxisRevisar: "revisar <accordi>",
        descripcionRevisar: "errori di condotta delle parti\n(quinte parallele…); accordi dal\ngrave all'acuto, separati da virgole",
        sintaxisContrapunto: "contrapunto <cantus> / <contrappunto> [--especie 1]",
        descripcionContrapunto: "errori di un contrappunto di specie\n(da 1 a 5) su un cantus firmus in\nsemibrevi; note senza durata: quella\ndella specie",
        sintaxisTransponer: "transponer <intervallo|tonica> <accordi o note>",
        descripcionTransponer: "porta accordi, una melodia o un\ncorale in un altro tono: un intervallo\n(2M, -3m) o la nuova tonica (Re)",
        sintaxisRearmonizar: "rearmonizar <accordi> [--en <tonalità>]",
        descripcionRearmonizar: "altre armonie per ogni accordo:\nsostituzione di tritono, dominanti\nsecondarie, prestito modale e\nsostituzioni diatoniche",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <sigla>…",
        descripcionAcorde: "note, tipo e ruolo di ogni nota",
        notasAcorde: "opzioni: --disposiciones, --nombres,\n--tonalidades, --sustituciones\n(nella tonalità di --en Do mayor, alla fine) e --comparar Do\n(note comuni e condotta delle voci); --bebop e --pentatonicas\n(scale per improvvisarci sopra)",
        sintaxisArpegio: "arpegio <sigla> [--patron <schema>]",
        descripcionArpegio: "note dell'arpeggio e scale\ndell'accordo (--patron ascendente,\ndescendente, ida-y-vuelta,\nbaja-y-sube, quebrado, alberti)",
        notasArpegio: "opzioni: --octavas 2 (da 1 a 4), --sin-octava, --desde Mi\n(o 3: comincia da quella nota), --tensiones 9,13, --grados\n1-5-3-8 (un percorso proprio) e --aproximacion abajo, arriba\no encierro (note cromatiche che portano a ciascuna)",
        sintaxisIdentificar: "identificar <note>",
        descripcionIdentificar: "accordi che formano alcune note",
        notasIdentificar: "opzioni: --escalas (le scale che contengono\nle note, invece degli accordi) e --archivo\nmelodia.mid (le note di un file MIDI,\nMusicXML, MEI o ABC, con --escalas)",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervallo tra due note o altezze",
        sintaxisEscala: "escala <scala> [--acordes]",
        descripcionEscala: "note e accordi di una scala\n--acordes: tutti quelli che stanno\nsu ogni grado, non solo per terze",
        notasEscala: "opzioni: --secuencia terceras (o cuartas, grupos-de-3,\ngrupos-de-4, triadas, cuatriadas), --bajando, --octavas 2\n(da 1 a 4), --piano (diteggiatura), --modos (paralleli e relativi)\ne --comparar Do lidio (alla fine); --simetria (ogni quanto\nsi ripete e i suoi accordi);\n--vecinas (quelle che si ottengono spostando\nuna nota) e --doce (in tutte le dodici tonalità);\n--doce --acordes (gli accordi di ogni\ngrado; --triadas, senza settima)",
        sintaxisEscalas: "escalas [<testo>] [opzioni]",
        descripcionEscalas: "il catalogo delle scale: le consuete e\nquelle di altre tradizioni, per\ncategorie, con le note a partire da Do",
        notasEscalas: "opzioni: --tradicion turquia (o india, grecia, grecia-antigua,\nmundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia,\nindonesia, klezmer, andes,\nbizancio, mesopotamia, africa,\nsudeste-asiatico, gregoriano, europa,\nvietnam, brasil) e --categoria maqam (o rāga, makam,\ndastgah, dromos…);\n--uso jazz (o clasica, blues, siglo-xx, popular, sintetica)\nfiltra quelle abituali; un testo cerca nei nomi",
        sintaxisTradiciones: "tradiciones [<tradizione>]",
        descripcionTradiciones: "le tradizioni del catalogo, con\nle loro categorie e quante scale\nha ognuna; con una, le sue scale",
        sintaxisTonalidad: "tonalidad <tonalità>",
        descripcionTonalidad: "armatura, relative e gradi",
        sintaxisConjunto: "conjunto <classi>",
        descripcionConjunto: "forma primaria, numero di Forte,\nvettori, simmetrie e note",
        sintaxisSerie: "serie <serie>",
        descripcionSerie: "matrice, forme e combinatorietà\ndi una serie dodecafonica",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <note>",
        descripcionTonnetz: "Tonnetz in SVG di alcune note",
        sintaxisTonnetzAcorde: "tonnetz --acorde <sigla> | --escala <scala> | --clases <numeri>",
        descripcionTonnetzAcorde: "di un accordo, una scala o un\ninsieme di classi di altezza",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triadi> | --camino <triade> <triade>",
        descripcionTonnetzRecorrido: "un percorso di triadi, con frecce, o\nil cammino più breve per P, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <triade>",
        descripcionTonnetzCiclo: "un ciclo esatonico, ottatonico o LR\n(--margen 2: più rete intorno)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <note o altezze>",
        descripcionTabla: "tabella armonica in SVG (esagoni)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "come nel Tonnetz (--margen 2: più\ntabella intorno)",
        sintaxisCuadricula: "cuadricula <note o altezze> | --acorde | --escala | --clases",
        descripcionCuadricula: "tastiera a griglia in SVG (pad),\ncon il contorno e la prima nota",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <altezza>\ncuadricula --giro 0-3 --espejo --en-tono --escala <scala>",
        descripcionCuadriculaOpciones: "assi (1,5: per quarte), griglia del\ncontroller (8x8), nota dell'angolo,\nquarti di giro, specchio e in tonalità",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <accordo> [--voces 2]",
        descripcionVecinos: "accordi a un semitono (settime: di\ndominante, minore, semidiminuita e\ndiminuita; triadi: maggiore, minore\ne aumentata; --ampliada: anche con\nle maj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <accordo> <accordo> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "da un accordo all'altro muovendo una\nvoce (o due) di un semitono a ogni\npasso",
        sintaxisConduccionMinima: "conduccion-minima <accordo> <accordo>",
        descripcionConduccionMinima: "la condotta con meno semitoni",
        sintaxisPlr: "plr <triade> <P, L, R…>",
        descripcionPlr: "trasformazioni neoriemanniane",
        sintaxisPlrCamino: "plr <triade> <triade>",
        descripcionPlrCamino: "il cammino più breve per P, L e R",
        sintaxisPlrCiclo: "plr <triade> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L),\noctatonico (P, R) o «ciclo LR»",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventi> [opzioni]",
        descripcionMusicxmlMelodia: "partitura MusicXML di una melodia",
        sintaxisMusicxmlCoral: "musicxml coral <accordi> [opzioni]",
        descripcionMusicxmlCoral: "corale a quattro voci in MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <sigle> [opzioni]",
        descripcionMusicxmlAcordes: "progressione con sigle e analisi",
        notasMusicxmlAcordes: "opzioni: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo Il mio\ncorale, --duracion 2 (quanto dura ogni accordo; semiminima,\naltrimenti), --cifrados e --analisis (nel corale: sigla\namericana sopra, numero romano e funzione sotto)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <sigle> [opzioni]",
        descripcionMusicxmlArpegios: "gli accordi arpeggiati, nota per nota",
        notasMusicxmlArpegios: "opzioni: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (quanto dura ogni nota; croma,\naltrimenti), --duracion 1 (quanto dura ogni accordo: lo schema\nsi ripete fino a riempirlo) e le altre di «acordes»\n--enlazar: ogni arpeggio comincia dalla nota più vicina\nall'ultima del precedente",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <file>",
        descripcionMusicxmlArchivo: "la progressione di un file MIDI,\nMusicXML, MEI o ABC, con quanto dura\nogni accordo (anche arpegios, mei e\nmidi)",
        sintaxisMusicxmlEscala: "musicxml escala <scala> [opzioni]",
        descripcionMusicxmlEscala: "una scala in semiminime, con i suoi\nmicrotoni: il mezzo bemolle di un\nmaqam, il koron, i comma di un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opzioni]",
        descripcionMeiMelodia: "lo stesso in MEI 5, il formato delle\nedizioni critiche (con le stesse\nopzioni)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opzioni]",
        descripcionLilypondMelodia: "lo stesso in LilyPond, per incidere\nla partitura in PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opzioni]",
        descripcionGuidoMelodia: "lo stesso in GUIDO (.gmn), per\nvederlo con GuidoLib o INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opzioni]",
        descripcionAbcMelodia: "lo stesso in ABC, la notazione\ntestuale della musica tradizionale",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opzioni]",
        descripcionMidiMelodia: "lo stesso come file MIDI, per\nascoltarlo (senza --clave né\n--cifrados; con --programa 0…127,\nGeneral MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opzioni]",
        descripcionGrabar: "la partitura in PDF, SVG o PNG con\nLilyPond, MuseScore, Verovio o Guido,\no il disegno con rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio,\n--formato pdf|svg|png; Verovio e Guido danno SVG,\nche rsvg-convert converte in PDF o PNG; armonia\nmotores dice quali sono installati",
        sintaxisMotores: "motores",
        descripcionMotores: "i motori di armonia grabar: dove si\ntrova ogni programma e la sua\nversione, o la variabile (ARMONIA_…)\nche dà il percorso",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <sigla>… [opzioni]",
        descripcionDigitaciones: "modi di suonare un accordo, dal più\ncomodo al meno comodo, su uno\nstrumento a corde con tasti\nopzioni: --instrumento guitarra|bajo|ukelele|mandolina|… (anche\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (il tasto più alto usato), --dedos 4\n(quelle che si possono usare), --completo (con tutte le note: di\nsolito la quinta può mancare), --diagrama (una riga per corda),\n--capo 2 (i tasti, contati dal capotasto), --musicxml (la prima\nforma di ogni accordo, come intavolatura MusicXML)",
        sintaxisPosiciones: "posiciones <scala> [--caged]",
        descripcionPosiciones: "la scala per posizioni sulla chitarra:\ntre note per corda (due nelle\npentatoniche) o CAGED",
        notasPosiciones: "opzioni: --secuencia terceras (o un'altra:\nla sequenza in ogni posizione; con\n--bajando, scendendo) e --formas (le cinque\nforme della pentatonica e le note comuni);\n--instrumento bajo (o un altro;\nanche re-abierto, sol-abierto, dadgad) e --capo 2",
        sintaxisTeclado: "teclado <scala> [--mano derecha]",
        descripcionTeclado: "la scala su una tastiera di pianoforte\n(SVG): le note o, con --mano derecha\no izquierda, le dita; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "la scala su un orologio di dodici ore\n(SVG): il cerchio cromatico o, con\n--quintas, il circolo delle quinte",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "una scala, un accordo, un arpeggio (con\nritmo: --figura 16, --tresillos) o degli\naccordi con la sigla su un pentagramma\n(SVG); --nombres, --intervalos,\n--semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <cosa> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "i gradi in numeri romani sotto gli\naccordi; la diteggiatura del pianoforte\n(--mano derecha) o della chitarra (--tab\n--dedos); la scala per terze o a gruppi\n(--secuencia terceras); l'intavolatura\nsotto (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <cosa> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "l'ottava (--octava 2), la chiave (--clave\nfa), il doppio pentagramma, i cambi di\nchiave secondo il registro e il basso\ncifrato degli accordi (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <note> --sobre <accordi>",
        descripcionPentagramaMelodia: "una melodia (Do4:8 Re4:8…) con un accordo\nper battuta sopra; le note estranee\nall'accordo in verde (in rosso se\ncromatiche); --ajenas lo fa negli altri",
        sintaxisPosicionesArpegio: "posiciones --arpegio <sigla> [--caged|--barrido]",
        descripcionPosicionesArpegio: "l'arpeggio di un accordo in ogni\nposizione del manico, in intavolatura\ncon le dita; --ida-y-vuelta, sale e scende",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musicale dalla riga di comando.

        Uso: armonia <comando> <argomenti> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Comandi (i comandi e le opzioni si scrivono in spagnolo o in inglese):
        """,
        pieDeLaAyuda: """
        I nomi delle note si scrivono in spagnolo, catalano, galiziano, basco, portoghese o inglese
        (Do, C, Sib, Bb, si bemol, ré). Con --idioma it, la risposta usa la notazione italiana e i
        messaggi in italiano; con --ingles, in inglese.
        Con --textos, i testi sono in un'altra lingua rispetto alle note: --idioma en --textos it.
        In spagnolo e inglese, --escritura palabras|ascii|unicode scrive le note come Fa sostenido,
        Fa# o Fa♯ (in inglese, F sharp, F# o F♯).
        Nelle altre lingue, --escritura palabras|compacto sceglie le parole o la forma compatta:
        fa dièse o Fa♯, F Kreuz o Fis.
        Nelle scritture compatte l'ottava va in pedice (La₄) e nelle altre in cifre (La4);
        --subindices o --cifras la fissano (si leggono entrambe le forme).
        Con --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones e tradiciones danno i loro dati in JSON.
        Con --json anche armonizar, realizar, revisar, contrapunto e transponer. Se l'uscita non è
        il terminale, il JSON sta su una sola riga.
        ARMONIA_IDIOMA=eu fissa la lingua senza --idioma; con ARMONIA_IDIOMA=sistema, quella di LANG.
        Codici di uscita: 0 bene, 1 testo illeggibile, 2 comando scritto male e 3 errori (revisar,
        contrapunto).
        Senza argomenti e nel terminale, armonia apre una sessione: un comando per riga.
        Con l'ingresso da un file (armonia < esercizi.txt), ne esegue le righe allo stesso modo; una riga
        con sole opzioni (--idioma eu) le mantiene per le successive.
        """,
        sintaxisAyuda: "ayuda [<comando>]",
        descripcionAyuda: "questo aiuto, o quello di un comando\n(anche <comando> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "il completamento di comandi e\nopzioni per il terminale",
        sintaxisManual: "manual",
        descripcionManual: "questo aiuto come pagina di manuale",
        manualNombre: "NOME",
        manualNotas: "NOTE",
        manualEntorno: "AMBIENTE",
        manualEstadoDeSalida: "STATO DI USCITA",
        manualIdiomaDelEntorno: "La lingua, come --idioma (che la annulla): es, en, eu…; con sistema, quella di LC_ALL, LC_MESSAGES o LANG.",
        manualRutaDelPrograma: { p in "Il percorso di \(p), se non è nel PATH." },
        manualCodigosDeSalida: ["È andato tutto bene.", "Un testo o un file illeggibile, o niente da dare.", "Il comando è scritto male.", "revisar o contrapunto hanno trovato errori."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "mancano gli accordi: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "servono due accordi: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "mancano le note della melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va da 1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "mancano il cantus firmus e il contrappunto, separati da /: " + ejemplo },
        especieFueraDeRango: "--especie va da 1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "mancano gli accordi: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "manca la sigla: armonia acorde Sol7",
        faltaCifradoDelArpegio: "manca la sigla: armonia arpegio Do7",
        patronDesconocido: { patron in "schema sconosciuto: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado o alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: non è una tradizione (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: non è una categoria di scale (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: non è un uso di scale (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        faltanNotas: "mancano le note: armonia identificar Do Mi Sol",
        dosNotas: "servono due note: armonia intervalo Do Mi",
        faltaEscala: "manca la scala: armonia escala Re dórico",
        faltaTonalidad: "manca la tonalità: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "manca la tonalità dopo --en",
        faltaConjunto: "manca l'insieme: armonia conjunto 0 4 7",
        faltaSerie: "manca la serie: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "mancano gli accordi: " + ejemplo },
        archivoIlegible: { nombre in "impossibile leggere il file «\(nombre)»" },
        archivoConAcordes: "con --archivo non si scrivono accordi",
        archivoSinAcordes: "il file non contiene accordi",
        faltaTransporte: { ejemplo in "mancano l'intervallo (o la nuova tonica) e ciò che si traspone: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "mancano gli accordi: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "il margine è un numero da 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "mancano le note: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "manca l'accordo: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "manca la scala: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "mancano le classi di altezza: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "mancano le triadi: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "il ciclo è esatonico, ottatonico o LR, da una triade: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "il percorso è di triadi maggiori e minori: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "il cammino va da una triade maggiore o minore a un'altra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "il ciclo inizia su una triade maggiore o minore: " + ejemplo },
        opcionesDeCuadricula: "opzioni della griglia: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <altezza> (Do2), --giro 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "le voci che si muovono sono 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "serve un accordo: " + ejemplo },
        vecinosSinFamilia: "i vicini si cercano tra settime di dominante, minori, semidiminuite, diminuite e maj7, o tra triadi maggiori, minori e aumentate",
        dosAcordesDeCamino: { ejemplo in "servono due accordi: " + ejemplo },
        caminoSinConexion: "i due accordi devono essere della stessa famiglia (settime, con o senza maj7, o triadi) ed essere collegati",
        faltanPasosDePLR: { ejemplo in "servono una triade e alcuni passi o un'altra triade: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L e R si applicano a triadi maggiori e minori: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "manca «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "il programma è un numero General MIDI da 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados e --analisis sono per MusicXML, MEI, LilyPond, GUIDO e ABC",
        faltaValor: { opcion in "manca il valore di --\(opcion)" },
        tempoMalEscrito: "il tempo si scrive «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "mancano le note: " + ejemplo },
        marcasSoloCoral: "--cifrados e --analisis sono per «coral»",
        duracionSoloCoral: "--duracion è solo per «coral»",
        claveDesconocida: { clave, claves in "chiave sconosciuta: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "mancano gli accordi: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) è solo per «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) è solo per «arpegios»" },
        archivoSoloParaAcordes: "--archivo è solo per «acordes» e «arpegios»",
        ventanaSinArchivo: "--ventana va con --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "mancano gli accordi: " + ejemplo },
        acordesConCifradosYAnalisis: "gli accordi hanno sempre sigle e analisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: si esporta una «melodia», un «coral», degli «acordes», i loro «arpegios» o una «escala»" },
        faltaLoQueSeGraba: "manca ciò che si incide: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: i motori sono lilypond, musescore, verovio, guido e propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: si incide in «pdf», «svg» o «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: si incide una partitura (melodia, coral, acordes, arpegios, escala) o un disegno (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "impossibile trovare «\(programa)»: installalo o indica il suo percorso in \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» è terminato con il codice \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» non è terminato in tempo ed è stato fermato" },
        motorNoInstalado: { variable in "non installato (o metti il percorso in \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "manca lo strumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "strumento sconosciuto: «\(nombre)» (\(lista(.italianoPalabras)))" },
        faltaLimite: "manca il numero di diteggiature: --limite 5",
        limiteFueraDeRango: "il limite è un numero da 1 a 200: --limite 5",
        faltanDedos: "manca il numero di dita: --dedos 3",
        dedosFueraDeRango: "le dita sono un numero da 1 a 4: --dedos 3",
        faltaTraste: "manca il tasto più alto: --traste 12",
        trasteFueraDeRango: "il tasto più alto è un numero da 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "manca la sigla: \(d)" },
        faltaEscalaDePosiciones: "manca la scala: armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "manca la scala: armonia teclado Re mayor",
        manoDesconocida: { texto in "mano sconosciuta: «\(texto)» (derecha o izquierda)" },
        archivoConNotas: "con --archivo non si scrivono note",
        noEsPentatonica: "le forme sono di una scala di cinque note: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "manca la scala: armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "manca cosa disegnare: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "il capotasto è un numero da 0 a 12: --capo 2",
        octavasFueraDeRango: "le ottave sono un numero da 1 a 4: --octavas 2",
        octavaFueraDeRango: "l'ottava è un numero da 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» non è una nota né un grado dell'accordo: --desde Mi o --desde 3" },
        tensionesMalEscritas: "le tensioni sono 9, 11 o 13: --tensiones 9,13",
        gradosMalEscritos: "i gradi sono numeri da 1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "approccio sconosciuto: «\(aproximacion)» (abajo, arriba o encierro)" },
        secuenciaDesconocida: { secuencia in "sequenza sconosciuta: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas o cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prova «armonia ayuda».",
        ordenDesconocida: { orden in "comando sconosciuto: «\(orden)»" },
        opcionDesconocida: { opcion in "opzione sconosciuta: «\(opcion)»" },
        idiomaDesconocido: { idioma in "lingua sconosciuta: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)" },
        terminalDesconocida: { t in "terminale sconosciuto: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "scrittura non valida: «\(escritura)» (palabras/words o compacto/compact; ascii o unicode, solo con es ed en)" },
        sinSalidaJSON: { orden in "«\(orden)» non dà un'uscita in JSON" },

        // Mensaje.swift
        mensajeNotas: "note",
        mensajeAcordes: "accordi",
        mensajeMicrotonos: "microtoni",
        mensajeEscalas: "scale",
        mensajeHabituales: "consuete",
        mensajeNingunaEscala: "non c'è nessuna scala così",
        mensajeArmadura: "armatura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "omonima",
        mensajeBajo: { nota in "basso \(nota)" },
        mensajeBajoAjeno: "basso estraneo all'accordo",
        mensajeSinAcordes: "Non formano nessun accordo conosciuto.",
        mensajeSin: { notas in "senza \(notas)" },
        mensajeSemitonos: { n in "\(n) semitoni" },
        mensajeSinAlteraciones: "senza alterazioni",
        mensajeSostenidos: { n in Idioma.italiano.contar(n, "diesis", "diesis") },
        mensajeBemoles: { n in Idioma.italiano.contar(n, "bemolle", "bemolli") },
        mensajeACuatroVoces: "A quattro voci (basso, tenore, contralto, soprano):",
        mensajeSinDigitaciones: "nessuna diteggiatura comoda",
        mensajeDedos: { n in Idioma.italiano.contar(n, "dito", "dita") },
        mensajeCejilla: { traste in "barré al tasto \(traste)" },
        mensajeNingunPaso: "nessun passo",
        mensajeUnPaso: "1 passo",
        mensajePasos: { n in "\(n) passi" },
        mensajeTriadas: { n in Idioma.italiano.contar(n, "triade", "triadi") },
        mensajeFormaNormal: "forma normale",
        mensajeFormaPrima: "forma primaria",
        mensajeVectorIntervalico: "vettore intervallare",
        mensajeVectorDeIndice: "vettore d'indice",
        mensajeEjesDeSimetria: "assi di simmetria",
        mensajeIntervalos: "intervalli",
        mensajeDeTodosLosIntervalos: "di tutti gli intervalli",
        mensajeFormasDistintas: { n in "\(n) forme distinte" },
        mensajeHexacordos: "esacordi",
        mensajeFormasCombinatorias: "forme combinatorie",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "la versione di armonia",
        quisoDecir: { x in "Intendevi «\(x)»?" },
        pruebaLaAyudaDe: { o in "Prova «armonia ayuda \(o)»." },
        salidaBinaria: "l'uscita è un file binario (MIDI, PDF o PNG); salvala con > file",
        escalasPorNotas: { e in "nessuna scala ha questo nome; per cercarla dalle note: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» scrive già la partitura; «grabar» la dà in PDF, SVG o PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultazioni", "Armonia e voci", "Partiture e incisione", "Disegni (SVG)", "Neoriemanniana", "Strumenti con tasti", "Il terminale e l'aiuto"],
        pieDelIndice: """
        L'aiuto di un comando: armonia ayuda <comando> (o armonia <comando> --help).
        Tutto l'aiuto, con le opzioni di ogni comando: armonia ayuda --todo.
        Per tutti i comandi: --ingles, --idioma, --textos, --escritura, --subindices, --cifras e --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Scrivi un comando per riga, senza «armonia» (ayuda: i comandi; salir: uscire)." }
    )
}
