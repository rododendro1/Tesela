// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en gallego. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let gallego = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <acordes> [--en <tonalidade>] [--escalas]",
        descripcionAnalizar: "cifrado romano, funcións, cadencias e modulacións (co seu acorde pivote; sen --en)\n--escalas: a escala de cada acorde, coas tensións e notas que evitar",
        notasAnalizar: "--notas-guia: dúas liñas de notas guía, desde a terceira e desde a sétima",
        sintaxisAnalizarArchivo: "analizar --archivo <ficheiro> [--ventana <duración>]",
        descripcionAnalizarArchivo: "o mesmo, cos acordes dun ficheiro MIDI, MusicXML, MEI ou ABC (un por pulso; --ventana 2: un por branca)",
        sintaxisArmonizar: "armonizar <melodía> [--en <tonalidade>] [--propuestas 3]",
        descripcionArmonizar: "acordes para unha melodía, de mellor a peor; con oitavas (Mi4), tamén o coral a catro voces",
        sintaxisRealizar: "realizar <acordes> [--en <tonalidade>]",
        descripcionRealizar: "os acordes a catro voces, sen erros de condución",
        sintaxisRevisar: "revisar <acordes>",
        descripcionRevisar: "erros de condución (quintas paralelas…); acordes de grave a agudo, separados por comas",
        sintaxisContrapunto: "contrapunto <cantus> / <contrapunto> [--especie 1]",
        descripcionContrapunto: "erros dun contrapunto de especies (1 a 5) sobre un cantus firmus en redondas; notas sen duración: a da especie",
        sintaxisTransponer: "transponer <intervalo|tónica> <acordes ou notas>",
        descripcionTransponer: "leva uns acordes, unha melodía ou un coral a outro ton: un intervalo (2M, -3m) ou a nova tónica (Re)",
        sintaxisRearmonizar: "rearmonizar <acordes> [--en <tonalidade>]",
        descripcionRearmonizar: "outras harmonías para cada acorde: substituto de trítono, dominantes secundarias, préstamo modal e substitutos diatónicos",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <cifrado>…",
        descripcionAcorde: "notas, tipo e papel de cada nota",
        notasAcorde: "opcións: --disposiciones, --nombres, --tonalidades, --sustituciones (na tonalidade de --en Do mayor, ao final) e --comparar Do (notas comúns e condución das voces); --bebop e --pentatonicas (escalas para improvisar enriba)",
        sintaxisArpegio: "arpegio <cifrado> [--patron <padrón>]",
        descripcionArpegio: "notas do arpexo e escalas do acorde (--patron ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado, alberti)",
        notasArpegio: "opcións: --octavas 2 (de 1 a 4), --sin-octava, --desde Mi (ou 3: empeza por esa nota), --tensiones 9,13, --grados 1-5-3-8 (un percorrido propio) e --aproximacion abajo, arriba ou encierro (notas cromáticas que levan a cada unha)",
        sintaxisIdentificar: "identificar <notas>",
        descripcionIdentificar: "acordes que forman unhas notas",
        notasIdentificar: "opcións: --escalas (as escalas que conteñen as notas, no canto de acordes) e --archivo melodia.mid (as notas dun ficheiro MIDI, MusicXML, MEI ou ABC, con --escalas)",
        sintaxisIntervalo: "intervalo <nota> <nota>",
        descripcionIntervalo: "intervalo entre dúas notas ou alturas",
        sintaxisEscala: "escala <escala> [--acordes]",
        descripcionEscala: "notas e acordes dunha escala\n--acordes: todos os que caben en cada grao, non só os de terceiras",
        notasEscala: "opcións: --secuencia terceras (ou cuartas, grupos-de-3, grupos-de-4, triadas, cuatriadas), --bajando, --octavas 2 (de 1 a 4), --piano (dixitación), --modos (paralelos e relativos) e --comparar Do lidio (ao final); --simetria (cada canto se repite e os seus acordes); --vecinas (as que saen de mover unha nota) e --doce (nas doce tonalidades); --doce --acordes (os acordes de cada grao; --triadas, sen sétima); --estadisticas (número de notas, brillo, vector interválico…)",
        sintaxisEscalas: "escalas [<texto>] [opcións]",
        descripcionEscalas: "o catálogo de escalas: as habituais e as doutras tradicións, por categorías, coas súas notas desde Do",
        notasEscalas: "opcións: --tradicion turquia (ou india, grecia, grecia-antigua, mundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia, africa, sudeste-asiatico, gregoriano, europa, vietnam, brasil) e --categoria maqam (ou rāga, makam, dastgah, dromos…); --uso jazz (ou clasica, blues, siglo-xx, popular, sintetica) filtra as habituais; --notas 5 deixa só as de cinco notas; --orden brillo (ou notas) ordénaas, e --sin-semitonos e --regulares deixan as anhemitónicas e as maximamente regulares; un texto busca nos nomes",
        sintaxisTradiciones: "tradiciones [<tradición>]",
        descripcionTradiciones: "as tradicións do catálogo, coas súas categorías e cantas escalas hai en cada unha; cunha, as súas escalas",
        sintaxisTonalidad: "tonalidad <tonalidade>",
        descripcionTonalidad: "armadura, relativas e graos",
        sintaxisConjunto: "conjunto <clases>",
        descripcionConjunto: "forma prima, número de Forte, vectores, simetrías e notas",
        sintaxisSerie: "serie <serie>",
        descripcionSerie: "matriz, formas e combinatoriedade dunha serie dodecafónica",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notas>",
        descripcionTonnetz: "Tonnetz en SVG dunhas notas",
        sintaxisTonnetzAcorde: "tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>",
        descripcionTonnetzAcorde: "dun acorde, unha escala ou un conxunto de clases de altura",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <tríades> | --camino <tríade> <tríade>",
        descripcionTonnetzRecorrido: "un percorrido de tríades, con frechas, ou o camiño máis curto por P, L e R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <ciclo> <tríade>",
        descripcionTonnetzCiclo: "un ciclo hexatónico, octatónico ou LR (--margen 2: máis rede arredor)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notas ou alturas>",
        descripcionTabla: "táboa harmónica en SVG (hexágonos)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "como no Tonnetz (--margen 2: máis táboa arredor)",
        sintaxisCuadricula: "cuadricula <notas ou alturas> | --acorde | --escala | --clases",
        descripcionCuadricula: "teclado de cuadrícula en SVG (pads), co contorno e a primeira nota",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <altura>\ncuadricula --giro 0-3 --espejo --en-tono --escala <escala>",
        descripcionCuadriculaOpciones: "eixos (1,5: en cuartas), grella do controlador (8x8), nota da esquina, cuartos de volta, espello e en ton",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <acorde> [--voces 2]",
        descripcionVecinos: "acordes a un semiton (sétimas: dominante, menor, semidiminuída e diminuída; tríades: maior, menor e aumentada; --ampliada: tamén cos maj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <acorde> <acorde> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "dun acorde a outro movendo unha voz (ou dúas) un semiton en cada paso",
        sintaxisConduccionMinima: "conduccion-minima <acorde> <acorde>",
        descripcionConduccionMinima: "a condución con menos semitons",
        sintaxisPlr: "plr <tríade> <P, L, R…>",
        descripcionPlr: "transformacións neorriemannianas",
        sintaxisPlrCamino: "plr <tríade> <tríade>",
        descripcionPlrCamino: "o camiño máis curto por P, L e R",
        sintaxisPlrCiclo: "plr <tríade> <ciclo>",
        descripcionPlrCiclo: "un ciclo: hexatonico (P, L), octatonico (P, R) ou \"ciclo LR\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <eventos> [opcións]",
        descripcionMusicxmlMelodia: "partitura MusicXML dunha melodía",
        sintaxisMusicxmlCoral: "musicxml coral <acordes> [opcións]",
        descripcionMusicxmlCoral: "coral a catro voces en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <cifrados> [opcións]",
        descripcionMusicxmlAcordes: "progresión con cifrados e análise",
        notasMusicxmlAcordes: "opcións: --compas 6/8, --anacrusa 8, --tonalidad Sol mayor, --clave fa, --tempo 90 (ou --tempo 60 4.), --titulo O meu coral, --duracion 2 (o que dura cada acorde; negra se non), --cifrados e --analisis (no coral: cifrado americano enriba, romano e función debaixo)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <cifrados> [opcións]",
        descripcionMusicxmlArpegios: "os acordes arpexados, nota a nota",
        notasMusicxmlArpegios: "opcións: --patron alberti (ou ascendente, descendente, ida y vuelta), --figura 16 (o que dura cada nota; corchea se non), --duracion 1 (o que dura cada acorde: o patrón repítese ata enchelo) e as demais de «acordes»\n--enlazar: cada arpexo empeza pola nota máis próxima á última do anterior",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <ficheiro>",
        descripcionMusicxmlArchivo: "a progresión dun ficheiro MIDI, MusicXML, MEI ou ABC, co que dura cada acorde (tamén arpegios, mei e midi)",
        sintaxisMusicxmlEscala: "musicxml escala <escala> [opcións]",
        descripcionMusicxmlEscala: "unha escala en negras, cos seus microtons: o medio bemol dun maqam, o koron, as comas dun makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [opcións]",
        descripcionMeiMelodia: "o mesmo en MEI 5, o formato das edicións críticas (coas mesmas opcións)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [opcións]",
        descripcionLilypondMelodia: "o mesmo en LilyPond, para gravar a partitura en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [opcións]",
        descripcionGuidoMelodia: "o mesmo en GUIDO (.gmn), para velo con GuidoLib ou INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [opcións]",
        descripcionAbcMelodia: "o mesmo en ABC, a notación en texto da música tradicional",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [opcións]",
        descripcionMidiMelodia: "o mesmo como ficheiro MIDI, para escoitalo (sen --clave nin --cifrados; con --programa 0…127, General MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [opcións]",
        descripcionGrabar: "a partitura en PDF, SVG ou PNG con LilyPond, MuseScore, Verovio ou Guido, ou o debuxo con rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio, --formato pdf|svg|png; Verovio e Guido dan SVG, que rsvg-convert pasa a PDF ou PNG; armonia motores di cales están instalados",
        sintaxisMotores: "motores",
        descripcionMotores: "os motores de armonia grabar: onde está cada programa e a súa versión, ou a variable (ARMONIA_…) que dá a súa ruta",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <cifrado>… [opcións]",
        descripcionDigitaciones: "formas de tocar un acorde, da máis cómoda á menos, nun instrumento de corda con trastes\nopcións: --instrumento guitarra|bajo|ukelele|mandolina|… (tamén «guitarra de siete cuerdas», «bajo de 5 cuerdas», «drop D»), --limite 5, --traste 12 (o máis alto que se usa), --dedos 4 (os que se poden usar), --completo (con todas as notas: por defecto a quinta pode faltar), --diagrama (unha liña por corda), --capo 2 (os trastes, desde o capo), --musicxml (a primeira forma de cada acorde, como tablatura MusicXML)",
        sintaxisPosiciones: "posiciones <escala> [--caged]",
        descripcionPosiciones: "a escala por posicións na guitarra: tres notas por corda (dúas nas pentatónicas) ou CAGED",
        notasPosiciones: "opcións: --secuencia terceras (ou outra: a secuencia en cada posición; con --bajando, baixando) e --formas (as cinco formas da pentatónica e as notas comúns); --instrumento bajo (ou outro; tamén re-abierto, sol-abierto, dadgad) e --capo 2",
        sintaxisTeclado: "teclado <escala> [--mano derecha]",
        descripcionTeclado: "a escala nun teclado de piano (SVG): as notas ou, con --mano derecha ou izquierda, os dedos; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "a escala nun reloxo de doce horas (SVG): o círculo cromático ou, con --quintas, o de quintas",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "unha escala, un acorde, un arpexo (con ritmo: --figura 16, --tresillos) ou uns acordes co seu cifrado nun pentagrama (SVG); --nombres, --intervalos, --semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <que> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "os graos en números romanos debaixo dos acordes; os dedos do piano (--mano derecha) ou da guitarra (--tab --dedos); a escala por terceiras ou en grupos (--secuencia terceras); a tablatura debaixo (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <que> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "a oitava (--octava 2), a clave (--clave fa), o pentagrama dobre, os cambios de clave segundo o rexistro e o baixo cifrado dos acordes (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <notas> --sobre <acordes>",
        descripcionPentagramaMelodia: "unha melodía (Do4:8 Re4:8…) cun acorde por compás enriba; as notas que non son do acorde, en verde (ou en vermello se son cromáticas); --ajenas faino nas demais",
        sintaxisPosicionesArpegio: "posiciones --arpegio <cifrado> [--caged|--barrido]",
        descripcionPosicionesArpegio: "o arpexo dun acorde en cada posición do mástil, en tablatura e cos dedos; --ida-y-vuelta, sobe e baixa",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: teoría musical desde a liña de comandos.

        Uso: armonia <orde> <argumentos> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Ordes (as ordes e as opcións escríbense en castelán ou en inglés):
        """,
        pieDeLaAyuda: """
        Acéptanse nomes de nota en castelán, catalán, galego, éuscaro ou inglés (Do, C, Sib, Bb, si
        bemol). Con --idioma gl, a resposta usa a notación galega e as mensaxes en galego; con
        --ingles, en inglés.
        Con --textos, os textos van noutro idioma ca as notas: --idioma en --textos gl.
        En castelán e inglés, --escritura palabras|ascii|unicode escribe as notas como Fa sostenido,
        Fa# ou Fa♯ (en inglés, F sharp, F# ou F♯).
        Nos demais idiomas, --escritura palabras|compacto escolle as palabras ou a forma compacta:
        fa dièse ou Fa♯, F Kreuz ou Fis.
        Nas escrituras compactas a oitava vai en subíndice (La₄) e nas demais, con cifras (La4);
        --subindices ou --cifras fíxana (lense as dúas formas).
        Con --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones e tradiciones dan os seus datos en JSON.
        Con --json tamén armonizar, realizar, revisar, contrapunto e transponer. Se a saída non é
        o terminal, o JSON vai nunha soa liña.
        ARMONIA_IDIOMA=eu fixa o idioma sen --idioma; con ARMONIA_IDIOMA=sistema, o de LANG.
        Códigos de saída: 0 ben, 1 texto que non se le, 2 orde mal escrita e 3 faltas (revisar,
        contrapunto).
        Sen argumentos e no terminal, armonia abre unha sesión: unha orde por liña.
        Coa entrada nun ficheiro (armonia < exercicios.txt), executa as súas liñas igual; unha liña
        só con opcións (--idioma eu) déixaas postas para as seguintes.
        Con -o ficheiro, o que dá a orde escríbese nese ficheiro, tamén na sesión.
        Con --idioma, as notas lense tamén nese idioma: H7 e Fis en alemán, ré en francés.
        """,
        sintaxisAyuda: "ayuda [<orde>]",
        descripcionAyuda: "esta axuda, ou a dunha orde (tamén <orde> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "o autocompletado das ordes e opcións para o terminal",
        sintaxisManual: "manual",
        descripcionManual: "esta axuda como páxina de manual",
        manualNombre: "NOME",
        manualNotas: "NOTAS",
        manualEntorno: "CONTORNO",
        manualEstadoDeSalida: "ESTADO DE SAÍDA",
        manualIdiomaDelEntorno: "O idioma, como --idioma (que a anula): es, en, eu…; con sistema, o de LC_ALL, LC_MESSAGES ou LANG.",
        manualRutaDelPrograma: { p in "A ruta de \(p), se non está no PATH." },
        manualCodigosDeSalida: ["Todo foi ben.", "Un texto ou un ficheiro que non se pode ler, ou nada que dar.", "A orde está mal escrita.", "revisar ou contrapunto atoparon faltas."],

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
        tradicionDesconocida: { tradicion in "«\(tradicion)»: non é unha tradición (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: non é unha categoría de escalas (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: non é un uso de escalas (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        ordenDeEscalasDesconocido: { orden in "«\(orden)»: as escalas ordénanse por brillo ou por notas: --orden brillo" },
        faltanNotas: "faltan as notas: armonia identificar Do Mi Sol",
        dosNotas: "fan falta dúas notas: armonia intervalo Do Mi",
        faltaEscala: "falta a escala: armonia escala Re dórico",
        faltaTonalidad: "falta a tonalidade: armonia tonalidad La menor",
        faltaTonalidadTrasEn: "falta a tonalidade despois de --en",
        faltaConjunto: "falta o conxunto: armonia conjunto 0 4 7",
        faltaSerie: "falta a serie: armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "faltan os acordes: " + ejemplo },
        archivoIlegible: { nombre in "non se pode ler o ficheiro «\(nombre)»" },
        archivoNoEscrito: { nombre in "non se pode escribir o ficheiro «\(nombre)»" },
        archivoConAcordes: "con --archivo non se escriben acordes",
        archivoSinAcordes: "o ficheiro non ten ningún acorde",
        faltaTransporte: { ejemplo in "faltan o intervalo (ou a nova tónica) e o que se transporta: " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "faltan os acordes: " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "a marxe é un número de 0 a 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "faltan as notas: " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "falta o acorde: " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "falta a escala: " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "faltan as clases de altura: " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "faltan as tríades: " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "o ciclo é hexatónico, octatónico ou LR, desde unha tríade: " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "o percorrido é de tríades maiores e menores: " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "o camiño vai dunha tríade maior ou menor a outra: " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "o ciclo comeza nunha tríade maior ou menor: " + ejemplo },
        opcionesDeCuadricula: "opcións da cuadrícula: --ejes H,V (1,5), --rejilla CxF (8x8), --origen <altura> (Do2), --giro 0-3",

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
        marcasSoloMusicXML: "--cifrados e --analisis son para MusicXML, MEI, LilyPond, GUIDO e ABC",
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
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: expórtase unha «melodia», un «coral», uns «acordes», os seus «arpegios» ou unha «escala»" },
        faltaLoQueSeGraba: "falta o que se grava: armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "«\(motor)»: os motores son lilypond, musescore, verovio, guido e propio" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: grávase en «pdf», «svg» ou «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: grávase unha partitura (melodia, coral, acordes, arpegios, escala) ou un debuxo (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "non se atopa «\(programa)»: instálao ou pon a súa ruta en \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» rematou co código \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» non rematou a tempo e parouse" },
        motorNoInstalado: { variable in "non instalado (ou pon a súa ruta en \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "falta o instrumento: \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrumento descoñecido: «\(nombre)» (\(lista(.gallegoPalabras)))" },
        faltaLimite: "falta o número de dixitacións: --limite 5",
        limiteFueraDeRango: "o límite é un número de 1 a 200: --limite 5",
        faltanDedos: "falta o número de dedos: --dedos 3",
        dedosFueraDeRango: "os dedos son un número de 1 a 4: --dedos 3",
        faltaTraste: "falta o traste máis alto: --traste 12",
        trasteFueraDeRango: "o traste máis alto é un número de 0 a 24: --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "falta o cifrado: \(d)" },
        faltaEscalaDePosiciones: "falta a escala: armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "falta a escala: armonia teclado Re mayor",
        manoDesconocida: { texto in "man descoñecida: «\(texto)» (derecha ou izquierda)" },
        archivoConNotas: "con --archivo non se escriben notas",
        noEsPentatonica: "as formas son dunha escala de cinco notas: armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "falta a escala: armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "falta que debuxar: armonia pentagrama escala Re dórico",
        capoFueraDeRango: "o capo é un número de 0 a 12: --capo 2",
        octavasFueraDeRango: "as oitavas son un número de 1 a 4: --octavas 2",
        notasFueraDeRango: "as notas son un número de 1 a 24: --notas 5",
        octavaFueraDeRango: "a oitava é un número de 0 a 7: --octava 3",
        desdeNoValido: { desde in "«\(desde)» non é unha nota nin un grao do acorde: --desde Mi ou --desde 3" },
        tensionesMalEscritas: "as tensións son 9, 11 ou 13: --tensiones 9,13",
        gradosMalEscritos: "os graos son números de 1 a 22: --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "aproximación descoñecida: «\(aproximacion)» (abajo, arriba ou encierro)" },
        secuenciaDesconocida: { secuencia in "secuencia descoñecida: «\(secuencia)» (terceras, cuartas, grupos-de-3, grupos-de-4, triadas ou cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Proba «armonia ayuda».",
        ordenDesconocida: { orden in "orde descoñecida: «\(orden)»" },
        opcionDesconocida: { opcion in "opción descoñecida: «\(opcion)»" },
        idiomaDesconocido: { idioma in "idioma descoñecido: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru ou hu)" },
        terminalDesconocida: { t in "terminal descoñecido: «\(t)» (bash, zsh ou fish)" },
        escrituraNoValida: { escritura in "escritura non válida: «\(escritura)» (palabras/words ou compacto/compact; ascii ou unicode, só con es e en)" },
        sinSalidaJSON: { orden in "«\(orden)» non dá saída en JSON" },

        // Mensaje.swift
        mensajeNotas: "notas",
        mensajeAcordes: "acordes",
        mensajeMicrotonos: "microtons",
        mensajeEscalas: "escalas",
        mensajeHabituales: "habituais",
        mensajeNingunaEscala: "non hai ningunha escala así",
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
        mensajeTriadas: { n in Idioma.gallego.contar(n, "tríade", "tríades") },
        mensajeFormaNormal: "forma normal",
        mensajeFormaPrima: "forma prima",
        mensajeVectorIntervalico: "vector interválico",
        mensajeVectorDeIndice: "vector de índice",
        mensajeEjesDeSimetria: "eixes de simetría",
        mensajeIntervalos: "intervalos",
        mensajeDeTodosLosIntervalos: "de todos os intervalos",
        mensajeFormasDistintas: { n in "\(n) formas distintas" },
        mensajeHexacordos: "hexacordos",
        mensajeFormasCombinatorias: "formas combinatorias",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "a versión de armonia",
        quisoDecir: { x in "Querías dicir «\(x)»?" },
        pruebaLaAyudaDe: { o in "Proba «armonia ayuda \(o)»." },
        salidaBinaria: "a saída é un ficheiro binario (MIDI, PDF ou PNG); gárdaa con > ficheiro",
        escalasPorNotas: { e in "non hai ningunha escala con ese nome; para buscala polas súas notas: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» xa escribe a partitura; «grabar» dáa en PDF, SVG ou PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultas", "Harmonía e voces", "Partituras e gravado", "Debuxos (SVG)", "Neorriemanniana", "Instrumentos de trastes", "O terminal e a axuda"],
        pieDelIndice: """
        A axuda dunha orde: armonia ayuda <orde> (ou armonia <orde> --help).
        Toda a axuda, coas opcións de cada orde: armonia ayuda --todo.
        Para todas as ordes: --ingles, --idioma, --textos, --escritura, --subindices, --cifras e --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Escribe unha orde por liña, sen «armonia» (ayuda: as ordes; salir: rematar)." }
    )
}
