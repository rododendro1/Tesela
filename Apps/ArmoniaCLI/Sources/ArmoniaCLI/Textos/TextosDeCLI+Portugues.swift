// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en portugués. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let portugues = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidade>]",
        descripcionAnalizar: "cifra romana, funções, cadências e\nmodulações (com o acorde pivô; sem\n--en)",
        sintaxisAnalizarArchivo: "analizar --archivo <ficheiro> [--ventana <duração>]",
        descripcionAnalizarArchivo: "o mesmo, com os acordes de um ficheiro\nMIDI ou MusicXML (um por pulsação;\n--ventana 2: um por mínima)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalidade>] [--propuestas 3]",
        descripcionArmonizar: "acordes para uma melodia, do melhor\npara o pior; com oitavas (Mi4),\ntambém o coral a quatro vozes",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidade>]",
        descripcionRealizar: "os acordes a quatro vozes, sem erros\nde condução",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "erros de condução (quintas\nparalelas…); acordes do grave ao\nagudo, separados por vírgulas",
        sintaxisContrapunto: "contrapunto <cantus> / <contraponto> [--especie 1]",
        descripcionContrapunto: "erros de um contraponto de espécies\n(1 a 5) sobre um cantus firmus em\nsemibreves; notas sem duração: a da\nespécie",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifra>…",
        descripcionAcorde: "notas, tipo e papel de cada nota",
        sintaxisArpegio: "arpegio <cifra> [--patron <padrão>]",
        descripcionArpegio: "notas do arpejo e escalas do\nacorde (--patron ascendente,\ndescendente, ida-y-vuelta, alberti)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que algumas notas formam",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre duas notas ou\nalturas",
        sintaxisEscala: "escala <escala>",
        descripcionEscala: "notas e acordes de uma escala",
        sintaxisTonalidad: "tonalidad <tonalidade>",
        descripcionTonalidad: "armadura, relativas e graus",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz em SVG de algumas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifra> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "de um acorde, uma escala ou um\nconjunto de classes de altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríades> | --camino <tríade> <tríade>",
        descripcionTonnetzRecorrido: "um percurso de tríades, com setas,\nou o caminho mais curto por P, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríade>",
        descripcionTonnetzCiclo: "um ciclo hexatónico, octatónico ou\nLR (--margen 2: mais rede em volta)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notas ou alturas>",
        descripcionTabla: "tabela harmónica em SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "como no Tonnetz (--margen 2: mais\ntabela em volta)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a um meio-tom (sétimas:\ndominante, menor, meio-diminuta e\ndiminuta; tríades: maior, menor e\naumentada; --ampliada: também com os\nmaj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "de um acorde a outro movendo uma voz\n(ou duas) um meio-tom em cada passo",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "a condução com menos meios-tons",
        sintaxisPlr: "plr <tríade> <P, L, R…>",
        descripcionPlr: "transformações neorriemannianas",
        sintaxisPlrCamino: "plr <tríade> <tríade>",
        descripcionPlrCamino: "o caminho mais curto por P, L e R",
        sintaxisPlrCiclo: "plr <tríade> <ciclo>",
        descripcionPlrCiclo: "um ciclo: hexatonico (P, L),\noctatonico (P, R) ou \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opções]",
        descripcionMusicxmlMelodia: "partitura MusicXML de uma melodia",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opções]",
        descripcionMusicxmlCoral: "coral a quatro vozes em MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifras> [opções]",
        descripcionMusicxmlAcordes: "progressão com cifras e análise",
        notasMusicxmlAcordes: "opções: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (ou --tempo 60 4.), --titulo O meu coral,\n--duracion 2 (o que dura cada acorde; semínima no coral e mínima\nnos acordes, se não), --cifrados e --analisis (no coral: cifra\namericana em cima, romana e função em baixo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifras> [opções]",
        descripcionMusicxmlArpegios: "os acordes arpejados, nota a nota",
        notasMusicxmlArpegios: "opções: --patron alberti (ou ascendente, descendente, ida y\nvuelta), --figura 16 (o que dura cada nota; colcheia se não),\n--duracion 1 (o que dura cada acorde: o padrão repete-se até o\npreencher) e as outras de «acordes»",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios <…> [opções]",
        descripcionMeiMelodia: "o mesmo em MEI 5, o formato das\nedições críticas (com as mesmas\nopções)",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios <…> [opções]",
        descripcionMidiMelodia: "o mesmo como ficheiro MIDI, para\nouvir (sem --clave nem --cifrados;\ncom --programa 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifra>… [opções]",
        descripcionDigitaciones: "formas de tocar um acorde, da mais\ncómoda à menos, num instrumento de\ncordas com trastes\nopções: --instrumento guitarra|bajo|ukelele|mandolina|… (também\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (o traste mais alto usado), --dedos 4 (os\nque se podem usar), --completo (com todas as notas: por omissão a\nquinta pode faltar), --diagrama (uma linha por corda)",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musical a partir da linha de comandos.

        Uso: armonia <comando> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Comandos (os comandos e as opções escrevem-se em espanhol ou em inglês):
        """,
        pieDeLaAyuda: """
        Aceitam-se nomes de nota em espanhol, catalão, galego, basco, português ou inglês (Do, C,
        Sib, Bb, si bemol, ré). Com --idioma pt, a resposta usa a notação portuguesa e as mensagens
        em português; com --ingles, em inglês.
        Com --textos, os textos saem noutra língua que as notas: --idioma en --textos pt.
        Em espanhol e inglês, --escritura palabras|ascii|unicode escreve as notas como Fa sostenido,
        Fa# ou Fa♯ (em inglês, F sharp, F# ou F♯).
        """,
        sintaxisAyuda: "ayuda",
        descripcionAyuda: "esta ajuda",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "faltam os acordes: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "são necessários dois acordes: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "faltam as notas da melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas vai de 1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "faltam o cantus firmus e o contraponto, separados por /: " + ejemplo },
        especieFueraDeRango: "--especie vai de 1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "faltam os acordes: " + ejemplo },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "falta o cifrado: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta o cifrado: armonia arpegio Do7",
        patronDesconocido: { patron in "padrão desconhecido: «\(patron)» (ascendente, descendente, ida-y-vuelta ou alberti)" },
        faltanNotas: "faltam as notas: armonia identificar Do Mi Sol",
        dosNotas: "são necessárias duas notas: armonia intervalo Do Mi",
        faltaEscala: "falta a escala: armonia escala Re dórico",
        faltaTonalidad: "falta a tonalidade: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta a tonalidade depois de --en",
        faltanAcordesDelAnalisis: { ejemplo in "faltam os acordes: " + ejemplo },
        archivoIlegible: { nombre in "não se pode ler o ficheiro «\(nombre)»" },
        archivoConAcordes: "com --archivo não se escrevem acordes",
        archivoSinAcordes: "o ficheiro não tem nenhum acorde",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "a margem é um número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltam as notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta o acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta a escala: " + ejemplo },
        clasesFueraDeRango: { ejemplo, orden in "as classes de altura são números de 0 a 11: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltam as tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "o ciclo é hexatónico, octatónico ou LR, a partir de uma tríade: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "o percurso é de tríades maiores e menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "o caminho vai de uma tríade maior ou menor a outra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "o ciclo começa numa tríade maior ou menor: " + ejemplo },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "as vozes que se movem são 1 ou 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "é necessário um acorde: " + ejemplo },
        vecinosSinFamilia: "os vizinhos são procurados entre sétimas de dominante, menores, meio-diminutas, diminutas e maj7, ou entre tríades maiores, menores e aumentadas",
        dosAcordesDeCamino: { ejemplo in "são necessários dois acordes: " + ejemplo },
        caminoSinConexion: "os dois acordes têm de ser da mesma família (sétimas, com ou sem maj7, ou tríades) e estar ligados",
        faltanPasosDePLR: { ejemplo in "são necessários uma tríade e alguns passos ou outra tríade: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L e R aplicam-se a tríades maiores e menores: " + ejemplo },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» ou «acordes»: " + ejemplo },
        instrumentoMIDI: "o programa é um número General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados e --analisis são para MusicXML e MEI",
        faltaValor: { opcion in "falta o valor de --\(opcion)" },
        tempoMalEscrito: "o tempo escreve-se «--tempo 90» ou «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "faltam as notas: " + ejemplo },
        marcasSoloCoral: "--cifrados e --analisis são para «coral»",
        duracionSoloCoral: "--duracion é só para «coral»",
        claveDesconocida: { clave, claves in "clave desconhecida: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "faltam os acordes: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) é só para «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) é só para «arpegios»" },
        faltanAcordesDeLaProgresion: { ejemplo, orden in "faltam os acordes: " + ejemplo },
        acordesConCifradosYAnalisis: "os acordes levam sempre cifrados e análise",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: exporta-se uma «melodia», um «coral», uns «acordes» ou os seus «arpegios»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "falta o instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento desconhecido: «\(nombre)» (\(lista(.portugues)))" },
        faltaLimite: "falta o número de dedilhações: --limite 5",
        limiteFueraDeRango: "o limite é um número de 1 a 200: --limite 5",
        faltanDedos: "falta o número de dedos: --dedos 3",
        dedosFueraDeRango: "os dedos são um número de 1 a 4: --dedos 3",
        faltaTraste: "falta o traste mais alto: --traste 12",
        trasteFueraDeRango: "o traste mais alto é um número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta o cifrado: \(d)" },

        // ErrorDeUso.swift
        pruebaLaAyuda: "Experimente «armonia ayuda».",
        ordenDesconocida: { orden in "comando desconhecido: «\(orden)»" },
        opcionDesconocida: { opcion in "opção desconhecida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconhecido: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el ou ru)" },
        escrituraNoValida: { escritura in "escrita inválida: «\(escritura)» (palabras/words, ascii ou unicode; só com es e en)" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeEscalas: "escalas",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homónima",
        mensajeBajo: { nota in "baixo \(nota)" },
        mensajeBajoAjeno: "baixo fora do acorde",
        mensajeSinAcordes: "Não formam nenhum acorde conhecido.",
        mensajeSin: { notas in "sem \(notas)" },
        mensajeSemitonos: { n in "\(n) meios-tons" },
        mensajeSinAlteraciones: "sem alterações",
        mensajeSostenidos: { n in n == 1 ? "1 sustenido" : "\(n) sustenidos" },
        mensajeBemoles: { n in n == 1 ? "1 bemol" : "\(n) bemóis" },
        mensajeACuatroVoces: "A quatro vozes (baixo, tenor, contralto, soprano):",
        mensajeSinDigitaciones: "não há dedilhações confortáveis",
        mensajeDedos: { n in n == 1 ? "1 dedo" : "\(n) dedos" },
        mensajeCejilla: { traste in "pestana no traste \(traste)" },
        mensajeNingunPaso: "nenhum passo",
        mensajeUnPaso: "1 passo",
        mensajePasos: { n in "\(n) passos" },
        mensajeTriadas: { n in n == 1 ? "1 tríade" : "\(n) tríades" }
    )
}
