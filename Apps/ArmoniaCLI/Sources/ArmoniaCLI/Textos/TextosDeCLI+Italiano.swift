// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en italiano. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let italiano = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <accordi> [--en <tonalità>]",
        descripcionAnalizar: "numeri romani, funzioni, cadenze e\nmodulazioni (con l'accordo perno;\nsenza --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <file> [--ventana <durata>]",
        descripcionAnalizarArchivo: "lo stesso, con gli accordi di un file\nMIDI o MusicXML (uno per pulsazione;\n--ventana 2: uno per minima)",
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
        sintaxisArpegio: "arpegio <sigla> [--patron <schema>]",
        descripcionArpegio: "note dell'arpeggio e scale\ndell'accordo (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <note>",
        descripcionIdentificar: "accordi che formano alcune note",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervallo tra due note o altezze",
        sintaxisEscala: "escala <scala>",
        descripcionEscala: "note e accordi di una scala",
        sintaxisTonalidad: "tonalidad <tonalità>",
        descripcionTonalidad: "armatura, relative e gradi",

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
        notasMusicxmlAcordes: "opzioni: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo Il mio\ncorale, --duracion 2 (quanto dura ogni accordo; semiminima nel\ncorale e minima negli accordi, altrimenti), --cifrados e\n--analisis (nel corale: sigla americana sopra, numero romano e\nfunzione sotto)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <sigle> [opzioni]",
        descripcionMusicxmlArpegios: "gli accordi arpeggiati, nota per nota",
        notasMusicxmlArpegios: "opzioni: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (quanto dura ogni nota; croma,\naltrimenti), --duracion 1 (quanto dura ogni accordo: lo schema\nsi ripete fino a riempirlo) e le altre di «acordes»",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <file>",
        descripcionMusicxmlArchivo: "la progressione di un file MIDI o\nMusicXML, con quanto dura ogni accordo\n(anche arpegios, mei e midi)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opzioni]",
        descripcionMeiMelodia: "lo stesso in MEI 5, il formato delle\nedizioni critiche (con le stesse\nopzioni)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios <…> [opzioni]",
        descripcionLilypondMelodia: "lo stesso in LilyPond, per incidere\nla partitura in PDF",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios <…> [opzioni]",
        descripcionAbcMelodia: "lo stesso in ABC, la notazione\ntestuale della musica tradizionale",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opzioni]",
        descripcionMidiMelodia: "lo stesso come file MIDI, per\nascoltarlo (senza --clave né\n--cifrados; con --programa 0…127,\nGeneral MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <sigla>… [opzioni]",
        descripcionDigitaciones: "modi di suonare un accordo, dal più\ncomodo al meno comodo, su uno\nstrumento a corde con tasti\nopzioni: --instrumento guitarra|bajo|ukelele|mandolina|… (anche\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (il tasto più alto usato), --dedos 4\n(quelle che si possono usare), --completo (con tutte le note: di\nsolito la quinta può mancare), --diagrama (una riga per corda),\n--capo 2 (i tasti, contati dal capotasto), --musicxml (la prima\nforma di ogni accordo, come intavolatura MusicXML)",
        sintaxisPosiciones: "posiciones <scala> [--caged]",
        descripcionPosiciones: "la scala per posizioni sulla chitarra:\ntre note per corda (due nelle\npentatoniche) o CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musicale dalla riga di comando.

        Uso: armonia <comando> <argomenti> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Comandi (i comandi e le opzioni si scrivono in spagnolo o in inglese):
        """,
        pieDeLaAyuda: """
        I nomi delle note si scrivono in spagnolo, catalano, galiziano, basco, portoghese o inglese
        (Do, C, Sib, Bb, si bemol, ré). Con --idioma it, la risposta usa la notazione italiana e i
        messaggi in italiano; con --ingles, in inglese.
        Con --textos, i testi sono in un'altra lingua rispetto alle note: --idioma en --textos it.
        In spagnolo e inglese, --escritura palabras|ascii|unicode scrive le note come Fa sostenido,
        Fa# o Fa♯ (in inglese, F sharp, F# o F♯).
        Con --subindices, l'ottava va in pedice: La₄, Fa♯₃ (si leggono entrambe le forme, La4 e La₄).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "questo aiuto",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "il completamento di comandi e\nopzioni per il terminale",
        sintaxisManual: "manual",
        descripcionManual: "questo aiuto come pagina di manuale",
        manualNombre: "NOME",
        manualNotas: "NOTE",

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
        faltanNotas: "mancano le note: armonia identificar Do Mi Sol",
        dosNotas: "servono due note: armonia intervalo Do Mi",
        faltaEscala: "manca la scala: armonia escala Re dórico",
        faltaTonalidad: "manca la tonalità: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "manca la tonalità dopo --en",
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
        clasesFueraDeRango: { ejemplo, orden in "le classi di altezza sono numeri da 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "mancano le triadi: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "il ciclo è esatonico, ottatonico o LR, da una triade: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "il percorso è di triadi maggiori e minori: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "il cammino va da una triade maggiore o minore a un'altra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "il ciclo inizia su una triade maggiore o minore: " + ejemplo },

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
        marcasSoloMusicXML: "--cifrados e --analisis sono per MusicXML, MEI, LilyPond e ABC",
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
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: si esporta una «melodia», un «coral», degli «acordes» o i loro «arpegios»" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "manca lo strumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "strumento sconosciuto: «\(nombre)» (\(lista(.italiano)))" },
        faltaLimite: "manca il numero di diteggiature: --limite 5",
        limiteFueraDeRango: "il limite è un numero da 1 a 200: --limite 5",
        faltanDedos: "manca il numero di dita: --dedos 3",
        dedosFueraDeRango: "le dita sono un numero da 1 a 4: --dedos 3",
        faltaTraste: "manca il tasto più alto: --traste 12",
        trasteFueraDeRango: "il tasto più alto è un numero da 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "manca la sigla: \(d)" },
        faltaEscalaDePosiciones: "manca la scala: armonia posiciones Sol mayor",
        capoFueraDeRango: "il capotasto è un numero da 0 a 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prova «armonia ayuda».",
        ordenDesconocida: { orden in "comando sconosciuto: «\(orden)»" },
        opcionDesconocida: { opcion in "opzione sconosciuta: «\(opcion)»" },
        idiomaDesconocido: { idioma in "lingua sconosciuta: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)" },
        terminalDesconocida: { t in "terminale sconosciuto: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "scrittura non valida: «\(escritura)» (palabras/words, ascii o unicode; solo con es ed en)" },

        // Mensaje.swift
        mensajeNotas: "note",
        mensajeAcordes: "accordi",
        mensajeEscalas: "scale",
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
        mensajeTriadas: { n in Idioma.italiano.contar(n, "triade", "triadi") }
    )
}
