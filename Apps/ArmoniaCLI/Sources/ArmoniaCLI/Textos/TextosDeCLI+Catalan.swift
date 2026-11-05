// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en catalán. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let catalan = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acords> [--en <tonalitat>] [--escalas]",
        descripcionAnalizar: "xifrat romà, funcions, cadències i\nmodulacions (amb l'acord pivot;\nsense --en)\n--escalas: l'escala de cada acord,\namb les tensions i notes a evitar",
        notasAnalizar: "--notas-guia: dues línies de notes guia,\ndes de la tercera i des de la setena",
        sintaxisAnalizarArchivo: "analizar --archivo <fitxer> [--ventana <durada>]",
        descripcionAnalizarArchivo: "el mateix, amb els acords d'un fitxer\nMIDI, MusicXML, MEI o ABC (un per\npols; --ventana 2: un per blanca)",
        sintaxisArmonizar: "armonizar <melodia> [--en <tonalitat>] [--propuestas 3]",
        descripcionArmonizar: "acords per a una melodia, de millor\na pitjor; amb octaves (Mi4), també\nel coral a quatre veus",
        sintaxisRealizar: "realizar <acords> [--en <tonalitat>]",
        descripcionRealizar: "els acords a quatre veus, sense\nerrors de conducció",
        sintaxisRevisar: "revisar <acords>",
        descripcionRevisar: "errors de conducció (quintes\nparal·leles…); acords de greu a\nagut, separats per comes",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunt> [--especie 1]",
        descripcionContrapunto: "errors d'un contrapunt d'espècies\n(1 a 5) sobre un cantus firmus en\nrodones; notes sense durada: la de\nl'espècie",
        sintaxisTransponer: "transponer <interval|tònica> <acords o notes>",
        descripcionTransponer: "porta uns acords, una melodia o un\ncoral a un altre to: un interval (2M,\n-3m) o la nova tònica (Re)",
        sintaxisRearmonizar: "rearmonizar <acords> [--en <tonalitat>]",
        descripcionRearmonizar: "altres harmonies per a cada acord:\nsubstitut de trítò, dominants\nsecundàries, manlleu modal i\nsubstituts diatònics",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <xifrat>…",
        descripcionAcorde: "notes, tipus i paper de cada nota",
        notasAcorde: "opcions: --disposiciones, --nombres,\n--tonalidades, --sustituciones\n(en la tonalitat de --en Do mayor, al final) i --comparar Do\n(notes comunes i conducció de les veus); --bebop i --pentatonicas\n(escales per improvisar-hi)",
        sintaxisArpegio: "arpegio <xifrat> [--patron <patró>]",
        descripcionArpegio: "notes de l'arpegi i escales de\nl'acord (--patron ascendente,\ndescendente, ida-y-vuelta,\nbaja-y-sube, quebrado, alberti)",
        notasArpegio: "opcions: --octavas 2 (d'1 a 4), --sin-octava, --desde Mi\n(o 3: comença per aquesta nota), --tensiones 9,13, --grados\n1-5-3-8 (un recorregut propi) i --aproximacion abajo, arriba\no encierro (notes cromàtiques que porten a cadascuna)",
        sintaxisIdentificar: "identificar <notes>",
        descripcionIdentificar: "acords que formen unes notes",
        notasIdentificar: "opcions: --escalas (les escales que contenen\nles notes, en lloc d'acords) i --archivo\nmelodia.mid (les notes d'un fitxer MIDI,\nMusicXML, MEI o ABC, amb --escalas)",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "interval entre dues notes o altures",
        sintaxisEscala: "escala <escala> [--acordes]",
        descripcionEscala: "notes i acords d'una escala\n--acordes: tots els que hi caben a\ncada grau, no només els de terceres",
        notasEscala: "opcions: --secuencia terceras (o cuartas, grupos-de-3,\ngrupos-de-4, triadas, cuatriadas), --bajando, --octavas 2\n(d'1 a 4), --piano (digitació), --modos (paral·lels i relatius)\ni --comparar Do lidio (al final); --simetria (cada quant\nes repeteix i els seus acords);\n--vecinas (les que surten de moure una\nnota) i --doce (en les dotze tonalitats);\n--doce --acordes (els acords de cada\ngrau; --triadas, sense setena)",
        sintaxisEscalas: "escalas [<text>] [opcions]",
        descripcionEscalas: "el catàleg d'escales: les habituals i\nles d'altres tradicions, per\ncategories, amb les notes des de Do",
        notasEscalas: "opcions: --tradicion turquia (o india, grecia, grecia-antigua,\nmundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia,\nindonesia, klezmer, andes,\nbizancio, mesopotamia, africa,\nsudeste-asiatico, gregoriano, europa) i --categoria maqam (o rāga, makam,\ndastgah, dromos…);\n--uso jazz (o clasica, blues, siglo-xx, popular, sintetica)\nfiltra les habituals; un text cerca en els noms",
        sintaxisTradiciones: "tradiciones [<tradició>]",
        descripcionTradiciones: "les tradicions del catàleg, amb\nles categories i quantes escales\nhi ha en cadascuna; amb una,\nles seves escales",
        sintaxisTonalidad: "tonalidad <tonalitat>",
        descripcionTonalidad: "armadura, relatives i graus",
        sintaxisConjunto: "conjunto <classes>",
        descripcionConjunto: "forma primera, nombre de Forte,\nvectors, simetries i notes",
        sintaxisSerie: "serie <sèrie>",
        descripcionSerie: "matriu, formes i combinatorietat\nd'una sèrie dodecafònica",

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
        sintaxisCuadricula: "cuadricula <notes o altures> | --acorde | --escala | --clases",
        descripcionCuadricula: "teclat de quadrícula en SVG (pads),\namb el contorn i la primera nota",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <altura>\ncuadricula --giro 0-3 --espejo --en-tono --escala <escala>",
        descripcionCuadriculaOpciones: "eixos (1,5: en quartes), graella del\ncontrolador (8x8), nota de la cantonada,\nquarts de volta, mirall i en to",

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
        notasMusicxmlAcordes: "opcions: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor,\n--clave fa, --tempo 90 (o --tempo 60 4.), --titulo El meu coral,\n--duracion 2 (el que dura cada acord; negra si no), --cifrados i\n--analisis (al coral: xifrat americà a dalt, romà i funció a\nbaix)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <xifrats> [opcions]",
        descripcionMusicxmlArpegios: "els acords arpegiats, nota a nota",
        notasMusicxmlArpegios: "opcions: --patron alberti (o ascendente, descendente, ida y\nvuelta), --figura 16 (el que dura cada nota; corxera si no),\n--duracion 1 (el que dura cada acord: el patró es repeteix fins\na omplir-lo) i les altres d'«acordes»\n--enlazar: cada arpegi comença per la nota més propera a\nl'última de l'anterior",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fitxer>",
        descripcionMusicxmlArchivo: "la progressió d'un fitxer MIDI,\nMusicXML, MEI o ABC, amb el que dura\ncada acord (també arpegios, mei i\nmidi)",
        sintaxisMusicxmlEscala: "musicxml escala <escala> [opcions]",
        descripcionMusicxmlEscala: "una escala en negres, amb els seus\nmicrotons: el mig bemoll d'un maqam,\nel koron, les comes d'un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMeiMelodia: "el mateix en MEI 5, el format de les\nedicions crítiques (amb les mateixes\nopcions)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionLilypondMelodia: "el mateix en LilyPond, per gravar la\npartitura en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionGuidoMelodia: "el mateix en GUIDO (.gmn), per\nveure-ho amb GuidoLib o INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionAbcMelodia: "el mateix en ABC, la notació en text\nde la música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opcions]",
        descripcionMidiMelodia: "el mateix com a fitxer MIDI, per\nescoltar-lo (sense --clave ni\n--cifrados; amb --programa 0…127,\nGeneral MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opcions]",
        descripcionGrabar: "la partitura en PDF, SVG o PNG amb\nLilyPond, MuseScore, Verovio o Guido,\no el dibuix amb rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio,\n--formato pdf|svg|png; Verovio i Guido donen SVG,\nque rsvg-convert passa a PDF o PNG; armonia\nmotores diu quins estan instal·lats",
        sintaxisMotores: "motores",
        descripcionMotores: "els motors d'armonia grabar: on és\ncada programa i la seva versió, o la\nvariable (ARMONIA_…) que en dona la\nruta",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <xifrat>… [opcions]",
        descripcionDigitaciones: "maneres de tocar un acord, de la més\ncòmoda a la menys, en un instrument\nde corda amb trasts\nopcions: --instrumento guitarra|bajo|ukelele|mandolina|… (també\n«guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»),\n--limite 5, --traste 12 (el més alt que es fa servir), --dedos 4\n(els que es poden fer servir), --completo (amb totes les notes:\nper defecte la quinta pot faltar), --diagrama (una línia per\ncorda),\n--capo 2 (els trasts, des del capo), --musicxml (la primera forma\nde cada acord, com a tabulatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "l'escala per posicions a la guitarra:\ntres notes per corda (dues a les\npentatòniques) o CAGED",
        notasPosiciones: "opcions: --secuencia terceras (o una altra:\nla seqüència a cada posició; amb\n--bajando, baixant) i --formas (les cinc\nformes de la pentatònica i les notes comunes);\n--instrumento bajo (o un altre;\ntambé re-abierto, sol-abierto, dadgad) i --capo 2",
        sintaxisTeclado: "teclado <escala> [--mano derecha]",
        descripcionTeclado: "l'escala en un teclat de piano\n(SVG): les notes o, amb --mano derecha\no izquierda, els dits; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "l'escala en un rellotge de dotze hores\n(SVG): el cercle cromàtic o, amb\n--quintas, el de quintes",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "una escala, un acord, un arpegi (amb\nritme: --figura 16, --tresillos) o uns\nacords amb el xifrat en un pentagrama\n(SVG); --nombres, --intervalos,\n--semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <què> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "els graus en nombres romans sota els\nacords; els dits del piano (--mano\nderecha) o de la guitarra (--tab --dedos);\nl'escala per terceres o en grups\n(--secuencia terceras); la tabulatura\na sota (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <què> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "l'octava (--octava 2), la clau (--clave\nfa), el pentagrama doble, els canvis de\nclau segons el registre i el baix xifrat\ndels acords (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <notes> --sobre <acords>",
        descripcionPentagramaMelodia: "una melodia (Do4:8 Re4:8…) amb un acord\nper compàs a sobre; les notes que no són\nde l'acord, en verd (o en vermell si són\ncromàtiques); --ajenas ho fa en les altres",
        sintaxisPosicionesArpegio: "posiciones --arpegio <xifrat> [--caged|--barrido]",
        descripcionPosicionesArpegio: "l'arpegi d'un acord a cada\nposició del mànec, en tabulatura i amb\nels dits; --ida-y-vuelta, puja i baixa",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoria musical des de la línia d'ordres.

        Ús: armonia <ordre> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Ordres (les ordres i les opcions s'escriuen en castellà o en anglès):
        """,
        pieDeLaAyuda: """
        S'accepten noms de nota en castellà, català, gallec, basc o anglès (Do, C, Sib, Bb, si
        bemoll). Amb --idioma ca, la resposta fa servir la notació catalana i els missatges en
        català; amb --ingles, en anglès.
        Amb --textos, els textos van en un altre idioma que les notes: --idioma en --textos ca.
        En castellà i anglès, --escritura palabras|ascii|unicode escriu les notes com a Fa sostenido,
        Fa# o Fa♯ (en anglès, F sharp, F# o F♯).
        En els altres idiomes, --escritura palabras|compacto tria les paraules o la forma compacta:
        fa dièse o Fa♯, F Kreuz o Fis.
        En les escriptures compactes l'octava va en subíndex (La₄) i en les altres, amb xifres (La4);
        --subindices o --cifras la fixen (es llegeixen totes dues maneres).
        Amb --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones i tradiciones donen les dades en JSON.
        Amb --json també armonizar, realizar, revisar, contrapunto i transponer. Si la sortida no és
        el terminal, el JSON va en una sola línia.
        ARMONIA_IDIOMA=eu fixa l'idioma sense --idioma; amb ARMONIA_IDIOMA=sistema, el de LANG.
        Codis de sortida: 0 bé, 1 text que no es pot llegir, 2 ordre mal escrita i 3 errors (revisar,
        contrapunto).
        Sense arguments i al terminal, armonia obre una sessió: una ordre per línia.
        """,
        sintaxisAyuda: "ayuda [<ordre>]",
        descripcionAyuda: "aquesta ajuda, o la d'una ordre\n(també <ordre> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "l'autocompleció de les ordres i\nopcions per al terminal",
        sintaxisManual: "manual",
        descripcionManual: "aquesta ajuda com a pàgina de manual",
        manualNombre: "NOM",
        manualNotas: "NOTES",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "falten els acords: " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "calen dos acords: " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "falten les notes de la melodia: " + ejemplo },
        propuestasFueraDeRango: "--propuestas va d'1 a 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "falten el cantus firmus i el contrapunt, separats per /: " + ejemplo },
        especieFueraDeRango: "--especie va d'1 a 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "falten els acords: " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "falta el xifrat: armonia acorde Sol7",
        faltaCifradoDelArpegio: "falta el xifrat: armonia arpegio Do7",
        patronDesconocido: { patron in "patró desconegut: «\(patron)» (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado o alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: no és una tradició (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: no és una categoria d'escales (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: no és un ús d'escales (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        faltanNotas: "falten les notes: armonia identificar Do Mi Sol",
        dosNotas: "calen dues notes: armonia intervalo Do Mi",
        faltaEscala: "falta l'escala: armonia escala Re dórico",
        faltaTonalidad: "falta la tonalitat: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta la tonalitat després de --en",
        faltaConjunto: "falta el conjunt: armonia conjunto 0 4 7",
        faltaSerie: "falta la sèrie: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "falten els acords: " + ejemplo },
        archivoIlegible: { nombre in "no es pot llegir el fitxer «\(nombre)»" },
        archivoConAcordes: "amb --archivo no s'escriuen acords",
        archivoSinAcordes: "el fitxer no té cap acord",
        faltaTransporte: { ejemplo in "falten l'interval (o la nova tònica) i el que es transporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "falten els acords: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "el marge és un nombre de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "falten les notes: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta l'acord: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta l'escala: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "falten les classes d'altura: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "falten les tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "el cicle és hexatònic, octatònic o LR, des d'una tríada: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "el recorregut és de tríades majors i menors: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "el camí va d'una tríada major o menor a una altra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "el cicle comença en una tríada major o menor: " + ejemplo },
        opcionesDeCuadricula: "opcions de la quadrícula: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <altura> (Do2), --giro 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "les veus que es mouen són 1 o 2: --voces 2",
        unAcordeDeVecinos: { ejemplo in "cal un acord: " + ejemplo },
        vecinosSinFamilia: "els veïns es busquen entre sèptimes de dominant, menors, semidisminuïdes, disminuïdes i maj7, o entre tríades majors, menors i augmentades",
        dosAcordesDeCamino: { ejemplo in "calen dos acords: " + ejemplo },
        caminoSinConexion: "els dos acords han de ser de la mateixa família (sèptimes, amb maj7 o sense, o tríades) i estar connectats",
        faltanPasosDePLR: { ejemplo in "calen una tríada i uns passos o una altra tríada: " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L i R s'apliquen a tríades majors i menors: " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "falta «melodia», «coral» o «acordes»: " + ejemplo },
        instrumentoMIDI: "el programa és un nombre General MIDI de 0 a 127: --programa 52",
        marcasSoloMusicXML: "--cifrados i --analisis són per a MusicXML, MEI, LilyPond, GUIDO i ABC",
        faltaValor: { opcion in "falta el valor de --\(opcion)" },
        tempoMalEscrito: "el tempo s'escriu «--tempo 90» o «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "falten les notes: " + ejemplo },
        marcasSoloCoral: "--cifrados i --analisis són per a «coral»",
        duracionSoloCoral: "--duracion només és per a «coral»",
        claveDesconocida: { clave, claves in "clau desconeguda: «\(clave)» " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "falten els acords: " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) només és per a «melodia»" },
        soloParaArpegios: { opcion in "--\(opcion) només és per a «arpegios»" },
        archivoSoloParaAcordes: "--archivo només és per a «acordes» i «arpegios»",
        ventanaSinArchivo: "--ventana va amb --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "falten els acords: " + ejemplo },
        acordesConCifradosYAnalisis: "els acords porten sempre xifrats i anàlisi",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: s'exporta una «melodia», un «coral», uns «acordes», els seus «arpegios» o una «escala»" },
        faltaLoQueSeGraba: "falta el que es grava: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: els motors són lilypond, musescore, verovio, guido i propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: es grava en «pdf», «svg» o «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: es grava una partitura (melodia, coral, acordes, arpegios, escala) o un dibuix (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "no es troba «\(programa)»: instal·la\'l o posa\'n la ruta a \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» ha acabat amb el codi \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» no ha acabat a temps i s\'ha aturat" },
        motorNoInstalado: { variable in "no instal·lat (o posa'n la ruta a \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta l'instrument: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument desconegut: «\(nombre)» (\(lista(.catalanPalabras)))" },
        faltaLimite: "falta el nombre de digitacions: --limite 5",
        limiteFueraDeRango: "el límit és un nombre d'1 a 200: --limite 5",
        faltanDedos: "falta el nombre de dits: --dedos 3",
        dedosFueraDeRango: "els dits són un nombre d'1 a 4: --dedos 3",
        faltaTraste: "falta el trast més alt: --traste 12",
        trasteFueraDeRango: "el trast més alt és un nombre de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta el xifrat: \(d)" },
        faltaEscalaDePosiciones: "falta l'escala: armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "falta l'escala: armonia teclado Re mayor",
        manoDesconocida: { texto in "mà desconeguda: «\(texto)» (derecha o izquierda)" },
        archivoConNotas: "amb --archivo no s'escriuen notes",
        noEsPentatonica: "les formes són d'una escala de cinc notes: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "falta l'escala: armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "falta què dibuixar: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "el capo és un nombre de 0 a 12: --capo 2",
        octavasFueraDeRango: "les octaves són un nombre d'1 a 4: --octavas 2",
        octavaFueraDeRango: "l'octava és un nombre de 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» no és una nota ni un grau de l'acord: --desde Mi o --desde 3" },
        tensionesMalEscritas: "les tensions són 9, 11 o 13: --tensiones 9,13",
        gradosMalEscritos: "els graus són nombres d'1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "aproximació desconeguda: «\(aproximacion)» (abajo, arriba o encierro)" },
        secuenciaDesconocida: { secuencia in "seqüència desconeguda: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas o cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Prova «armonia ayuda».",
        ordenDesconocida: { orden in "ordre desconeguda: «\(orden)»" },
        opcionDesconocida: { opcion in "opció desconeguda: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma desconegut: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)" },
        terminalDesconocida: { t in "terminal desconegut: «\(t)» (bash, zsh o fish)" },
        escrituraNoValida: { escritura in "escriptura no vàlida: «\(escritura)» (palabras/words o compacto/compact; ascii o unicode, només amb es i en)" },
        sinSalidaJSON: { orden in "«\(orden)» no dona sortida en JSON" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "acords",
        mensajeMicrotonos: "microtons",
        mensajeEscalas: "escales",
        mensajeHabituales: "habituals",
        mensajeNingunaEscala: "cap escala no ho compleix",
        mensajeArmadura: "armadura",
        mensajeRelativa: "relativa",
        mensajeHomonima: "homònima",
        mensajeBajo: { nota in "baix \(nota)" },
        mensajeBajoAjeno: "baix aliè a l'acord",
        mensajeSinAcordes: "No formen cap acord conegut.",
        mensajeSin: { notas in "sense \(notas)" },
        mensajeSemitonos: { n in "\(n) semitons" },
        mensajeSinAlteraciones: "sense alteracions",
        mensajeSostenidos: { n in Idioma.catalan.contar(n, "sostingut", "sostinguts") },
        mensajeBemoles: { n in Idioma.catalan.contar(n, "bemoll", "bemolls") },
        mensajeACuatroVoces: "A quatre veus (baix, tenor, contralt, soprano):",
        mensajeSinDigitaciones: "no hi ha digitacions còmodes",
        mensajeDedos: { n in Idioma.catalan.contar(n, "dit", "dits") },
        mensajeCejilla: { traste in "celleta al trast \(traste)" },
        mensajeNingunPaso: "cap pas",
        mensajeUnPaso: "1 pas",
        mensajePasos: { n in "\(n) passos" },
        mensajeTriadas: { n in Idioma.catalan.contar(n, "tríada", "tríades") },
        mensajeFormaNormal: "forma normal",
        mensajeFormaPrima: "forma primera",
        mensajeVectorIntervalico: "vector interval·lic",
        mensajeVectorDeIndice: "vector d'índex",
        mensajeEjesDeSimetria: "eixos de simetria",
        mensajeIntervalos: "intervals",
        mensajeDeTodosLosIntervalos: "de tots els intervals",
        mensajeFormasDistintas: { n in "\(n) formes diferents" },
        mensajeHexacordos: "hexacords",
        mensajeFormasCombinatorias: "formes combinatòries",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "la versió d'armonia",
        quisoDecir: { x in "Volies dir «\(x)»?" },
        pruebaLaAyudaDe: { o in "Prova «armonia ayuda \(o)»." },
        salidaBinaria: "la sortida és un fitxer binari (MIDI, PDF o PNG); desa-la amb > fitxer",
        escalasPorNotas: { e in "no hi ha cap escala amb aquest nom; per cercar-la per les notes: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» ja escriu la partitura; «grabar» la dona en PDF, SVG o PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultes", "Harmonia i veus", "Partitures i gravat", "Dibuixos (SVG)", "Neoriemanniana", "Instruments de trasts", "El terminal i l'ajuda"],
        pieDelIndice: """
        L'ajuda d'una ordre: armonia ayuda <ordre> (o armonia <ordre> --help).
        Tota l'ajuda, amb les opcions de cada ordre: armonia ayuda --todo.
        Per a totes les ordres: --ingles, --idioma, --textos, --escritura, --subindices, --cifras i --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Escriu una ordre per línia, sense «armonia» (ayuda: les ordres; salir: acabar)." }
    )
}
