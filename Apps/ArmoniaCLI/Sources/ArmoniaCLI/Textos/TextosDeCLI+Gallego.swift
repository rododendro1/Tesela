// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en gallego. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let gallego = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidade>]",
        descripcionAnalizar: "cifrado romano, funcións, cadencias\ne modulacións (co seu acorde pivote;\nsen --en)",
        sintaxisAnalizarArchivo: "analizar --archivo <ficheiro> [--ventana <duración>]",
        descripcionAnalizarArchivo: "o mesmo, cos acordes dun ficheiro\nMIDI ou MusicXML (un por pulso;\n--ventana 2: un por branca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidade>] [--propuestas 3]",
        descripcionArmonizar: "acordes para unha melodía, de mellor\na peor; con oitavas (Mi4), tamén o\ncoral a catro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidade>]",
        descripcionRealizar: "os acordes a catro voces, sen erros\nde condución",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "erros de condución (quintas\nparalelas…); acordes de grave a\nagudo, separados por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "erros dun contrapunto de especies\n(1 a 5) sobre un cantus firmus en\nredondas; notas sen duración: a da\nespecie",
        sintaxisTransponer: "transponer <intervalo|tónica> <acordes ou notas>",
        descripcionTransponer: "leva uns acordes, unha melodía ou un\ncoral a outro ton: un intervalo (2M,\n-3m) ou a nova tónica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidade>]",
        descripcionRearmonizar: "outras harmonías para cada acorde:\nsubstituto de trítono, dominantes\nsecundarias, préstamo modal e\nsubstitutos diatónicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrado>…",
        descripcionAcorde: "notas, tipo e papel de cada nota",
        sintaxisArpegio: "arpegio <cifrado> [--patron <padrón>]",
        descripcionArpegio: "notas do arpexo e escalas do\nacorde (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unhas notas",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dúas notas ou\nalturas",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notas e acordes dunha escala",
        sintaxisTonalidad: "tonalidad <tonalidade>",
        descripcionTonalidad: "armadura, relativas e graos",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG dunhas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "dun acorde, unha escala ou un\nconxunto de clases de altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríades> | --camino <tríade> <tríade>",
        descripcionTonnetzRecorrido: "un percorrido de tríades, con\nfrechas, ou o camiño máis curto por\nP, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríade>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico ou\nLR (--margen 2: máis rede arredor)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notas ou alturas>",
        descripcionTabla: "táboa harmónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "como no Tonnetz (--margen 2: máis\ntáboa arredor)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semiton (sétimas:\ndominante, menor, semidiminuída e\ndiminuída; tríades: maior, menor e\naumentada; --ampliada: tamén cos\nmaj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "dun acorde a outro movendo unha voz\n(ou dúas) un semiton en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "a condución con menos semitons",
        sintaxisPlr: "plr <tríade> <P, L, R…>",
        descripcionPlr: "transformacións neorriemannianas",
        sintaxisPlrCamino: "plr <tríade> <tríade>",
        descripcionPlrCamino: "o camiño máis curto por P, L e R",
        sintaxisPlrCiclo: "plr <tríade> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L),\noctatonico (P, R) ou \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opcións]",
        descripcionMusicxmlMelodia: "partitura MusicXML dunha melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opcións]",
        descripcionMusicxmlCoral: "coral a catro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifrados> [opcións]",
        descripcionMusicxmlAcordes: "progresión con cifrados e análise",
        notasMusicxmlAcordes: "opcións: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (ou --tempo 60 4.), --titulo O meu coral,\n--duracion 2 (o que dura cada acorde; negra no coral e branca\nnos acordes se non), --cifrados e --analisis (no coral: cifrado\namericano enriba, romano e función debaixo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifrados> [opcións]",
        descripcionMusicxmlArpegios: "os acordes arpexados, nota a nota",
        notasMusicxmlArpegios: "opcións: --patron alberti (ou ascendente, descendente, ida y\nvuelta), --figura 16 (o que dura cada nota; corchea se non),\n--duracion 1 (o que dura cada acorde: o patrón repítese ata\nenchelo) e as demais de «acordes»",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <ficheiro>",
        descripcionMusicxmlArchivo: "a progresión dun ficheiro MIDI ou\nMusicXML, co que dura cada acorde\n(tamén arpegios, mei e midi)",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opcións]",
        descripcionMeiMelodia: "o mesmo en MEI 5, o formato das\nedicións críticas (coas mesmas\nopcións)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios <…> [opcións]",
        descripcionLilypondMelodia: "o mesmo en LilyPond, para gravar a\npartitura en PDF",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios <…> [opcións]",
        descripcionAbcMelodia: "o mesmo en ABC, a notación en texto\nda música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opcións]",
        descripcionMidiMelodia: "o mesmo como ficheiro MIDI, para\nescoitalo (sen --clave nin\n--cifrados; con --programa 0…127,\nGeneral MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrado>… [opcións]",
        descripcionDigitaciones: "formas de tocar un acorde, da máis\ncómoda á menos, nun instrumento de\ncorda con trastes\nopcións: --instrumento guitarra|bajo|ukelele|mandolina|… (tamén\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (o máis alto que se usa), --dedos 4 (os\nque se poden usar), --completo (con todas as notas: por defecto\na quinta pode faltar), --diagrama (unha liña por corda),\n--capo 2 (os trastes, desde o capo), --musicxml (a primeira forma\nde cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "a escala por posicións na guitarra:\ntres notas por corda (dúas nas\npentatónicas) ou CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical desde a liña de comandos.

        Uso: armonia <orde> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Ordes (as ordes e as opcións escríbense en castelán ou en inglés):
        """,
        pieDeLaAyuda: """
        Acéptanse nomes de nota en castelán, catalán, galego, éuscaro ou inglés (Do, C, Sib, Bb, si
        bemol). Con --idioma gl, a resposta usa a notación galega e as mensaxes en galego; con
        --ingles, en inglés.
        Con --textos, os textos van noutro idioma ca as notas: --idioma en --textos gl.
        En castelán e inglés, --escritura palabras|ascii|unicode escribe as notas como Fa sostenido,
        Fa# ou Fa♯ (en inglés, F sharp, F# ou F♯).
        Con --subindices, a oitava vai en subíndice: La₄, Fa♯₃ (lense as dúas formas, La4 e La₄).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "esta axuda",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "o autocompletado das ordes e\nopcións para o terminal",
        sintaxisManual: "manual",
        descripcionManual: "esta axuda como páxina de manual",
        manualNombre: "NOME",
        manualNotas: "NOTAS",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "faltan os acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "fan falta dous acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "faltan as notas da melodía: " + ejemplo },
        propuestasFueraDeRango: "--propuestas vai de 1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "faltan o cantus firmus e o contrapunto, separados por /: " + ejemplo },
        especieFueraDeRango: "--especie vai de 1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "falta o cifrado: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta o cifrado: armonia arpegio Do7",
        patronDesconocido: { patron in "padrón descoñecido: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado ou alberti)" },
        faltanNotas: "faltan as notas: armonia identificar Do Mi Sol",
        dosNotas: "fan falta dúas notas: armonia intervalo Do Mi",
        faltaEscala: "falta a escala: armonia escala Re dórico",
        faltaTonalidad: "falta a tonalidade: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta a tonalidade despois de --en",
        faltanAcordesDelAnalisis: { ejemplo in "faltan os acordes: " + ejemplo },
        archivoIlegible: { nombre in "non se pode ler o ficheiro «\(nombre)»" },
        archivoConAcordes: "con --archivo non se escriben acordes",
        archivoSinAcordes: "o ficheiro non ten ningún acorde",
        faltaTransporte: { ejemplo in "faltan o intervalo (ou a nova tónica) e o que se transporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "a marxe é un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan as notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta o acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta a escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "as clases de altura son números de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan as tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "o ciclo é hexatónico, octatónico ou LR, desde unha tríade: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "o percorrido é de tríades maiores e menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "o camiño vai dunha tríade maior ou menor a outra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "o ciclo comeza nunha tríade maior ou menor: " + ejemplo },

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "as voces que se moven son 1 ou 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "fai falta un acorde: " + ejemplo },
        vecinosSinFamilia: "os veciños búscanse entre sétimas de dominante, menores, semidiminuídas, diminuídas e maj7, ou entre tríades maiores, menores e aumentadas",
        dosAcordesDeCamino: { ejemplo in "fan falta dous acordes: " + ejemplo },
        caminoSinConexion: "os dous acordes teñen que ser da mesma familia (sétimas, con ou sen maj7, ou tríades) e estar conectados",
        faltanPasosDePLR: { ejemplo in "fan falta unha tríade e uns pasos ou outra tríade: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L e R aplícanse a tríades maiores e menores: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» ou «acordes»: " + ejemplo },
        instrumentoMIDI: "o programa é un número General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados e --analisis son para MusicXML, MEI, LilyPond e ABC",
        faltaValor: { opcion in "falta o valor de --\(opcion)" },
        tempoMalEscrito: "o tempo escríbese «--tempo 90» ou «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "faltan as notas: " + ejemplo },
        marcasSoloCoral: "--cifrados e --analisis son para «coral»",
        duracionSoloCoral: "--duracion só é para «coral»",
        claveDesconocida: { clave, claves in "clave descoñecida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) só é para «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) só é para «arpegios»" },
        archivoSoloParaAcordes: "--archivo só é para «acordes» e «arpegios»",
        ventanaSinArchivo: "--ventana vai con --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "faltan os acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "os acordes levan sempre cifrados e análise",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: expórtase unha «melodia», un «coral», uns «acordes» ou os seus «arpegios»" },

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta o instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento descoñecido: «\(nombre)» (\(lista(.gallego)))" },
        faltaLimite: "falta o número de dixitacións: --limite 5",
        limiteFueraDeRango: "o límite é un número de 1 a 200: --limite 5",
        faltanDedos: "falta o número de dedos: --dedos 3",
        dedosFueraDeRango: "os dedos son un número de 1 a 4: --dedos 3",
        faltaTraste: "falta o traste máis alto: --traste 12",
        trasteFueraDeRango: "o traste máis alto é un número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta o cifrado: \(d)" },
        faltaEscalaDePosiciones: "falta a escala: armonia posiciones Sol mayor",
        capoFueraDeRango: "o capo é un número de 0 a 12: --capo 2",

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Proba «armonia ayuda».",
        ordenDesconocida: { orden in "orde descoñecida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción descoñecida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma descoñecido: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el ou ru)" },
        terminalDesconocida: { t in "terminal descoñecido: «\(t)» (bash, zsh ou fish)" },
        escrituraNoValida: { escritura in "escritura non válida: «\(escritura)» (palabras/words, ascii ou unicode; só con es e en)" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeEscalas: "escalas",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "baixo \(nota)" },
        mensajeBajoAjeno: "baixo alleo ao acorde",
        mensajeSinAcordes: "Non forman ningún acorde coñecido.",
        mensajeSin: { notas in "sen \(notas)" },
        mensajeSemitonos: { n in "\(n) semitons" },
        mensajeSinAlteraciones: "sen alteracións",
        mensajeSostenidos: { n in Idioma.gallego.contar(n, "sostido", "sostidos") },
        mensajeBemoles: { n in Idioma.gallego.contar(n, "bemol", "bemois") },
        mensajeACuatroVoces: "A catro voces (baixo, tenor, contralto, soprano):",
        mensajeSinDigitaciones: "non hai dixitacións cómodas",
        mensajeDedos: { n in Idioma.gallego.contar(n, "dedo", "dedos") },
        mensajeCejilla: { traste in "pestana no traste \(traste)" },
        mensajeNingunPaso: "ningún paso",
        mensajeUnPaso: "1 paso",
        mensajePasos: { n in "\(n) pasos" },
        mensajeTriadas: { n in Idioma.gallego.contar(n, "tríade", "tríades") }
    )
}
