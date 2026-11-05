// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en francés. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let frances = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analizar <accords> [--en <tonalité>] [--escalas]",
        descripcionAnalizar: "chiffrage romain, fonctions, cadences et modulations (avec l'accord pivot ; sans --en) --escalas : la gamme de chaque accord, ses tensions et notes à éviter",
        notasAnalizar: "--notas-guia : deux lignes de notes guides, depuis la tierce et depuis la septième",
        sintaxisAnalizarArchivo: "analizar --archivo <fichier> [--ventana <durée>]",
        descripcionAnalizarArchivo: "la même chose, avec les accords d'un fichier MIDI, MusicXML, MEI ou ABC (un par temps ; --ventana 2 : un par blanche)",
        sintaxisArmonizar: "armonizar <mélodie> [--en <tonalité>] [--propuestas 3]",
        descripcionArmonizar: "accords pour une mélodie, du meilleur au moins bon ; avec octaves (Mi4), aussi le choral à quatre voix",
        sintaxisRealizar: "realizar <accords> [--en <tonalité>]",
        descripcionRealizar: "les accords à quatre voix, sans faute de conduite des voix",
        sintaxisRevisar: "revisar <accords>",
        descripcionRevisar: "fautes de conduite des voix (quintes parallèles…) ; accords du grave à l'aigu, séparés par des virgules",
        sintaxisContrapunto: "contrapunto <cantus> / <contrepoint> [--especie 1]",
        descripcionContrapunto: "fautes d'un contrepoint d'espèces (1 à 5) sur un cantus firmus en rondes ; notes sans durée : celle de l'espèce",
        sintaxisTransponer: "transponer <intervalle|tonique> <accords ou notes>",
        descripcionTransponer: "transpose des accords, une mélodie ou un choral dans un autre ton : un intervalle (2M, -3m) ou la nouvelle tonique (Ré)",
        sintaxisRearmonizar: "rearmonizar <accords> [--en <tonalité>]",
        descripcionRearmonizar: "d'autres harmonies pour chaque accord : substitution tritonique, dominantes secondaires, emprunt modal et substitutions diatoniques",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "acorde <chiffrage>…",
        descripcionAcorde: "notes, type et rôle de chaque note",
        notasAcorde: "options : --disposiciones, --nombres, --tonalidades, --sustituciones (dans la tonalité de --en Do mayor, à la fin) et --comparar Do (notes communes et conduite des voix) ; --bebop et --pentatonicas (gammes pour improviser dessus)",
        sintaxisArpegio: "arpegio <chiffrage> [--patron <motif>]",
        descripcionArpegio: "notes de l'arpège et gammes de l'accord (--patron ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado, alberti)",
        notasArpegio: "options : --octavas 2 (de 1 à 4), --sin-octava, --desde Mi (ou 3 : commence par cette note), --tensiones 9,13, --grados 1-5-3-8 (un parcours à soi) et --aproximacion abajo, arriba ou encierro (notes chromatiques qui mènent à chacune)",
        sintaxisIdentificar: "identificar <notes>",
        descripcionIdentificar: "accords que forment des notes",
        notasIdentificar: "options : --escalas (les gammes qui contiennent les notes, au lieu des accords) et --archivo melodia.mid (les notes d'un fichier MIDI, MusicXML, MEI ou ABC, avec --escalas)",
        sintaxisIntervalo: "intervalo <note> <note>",
        descripcionIntervalo: "intervalle entre deux notes ou hauteurs",
        sintaxisEscala: "escala <gamme> [--acordes]",
        descripcionEscala: "notes et accords d'une gamme --acordes : tous ceux qui tiennent sur chaque degré, pas seulement en tierces",
        notasEscala: "options : --secuencia terceras (ou cuartas, grupos-de-3, grupos-de-4, triadas, cuatriadas), --bajando, --octavas 2 (de 1 à 4), --piano (doigté), --modos (parallèles et relatifs) et --comparar Do lidio (à la fin) ; --simetria (tous les combien elle se répète et ses accords); --vecinas (celles qu'on obtient en déplaçant une note) et --doce (dans les douze tonalités); --doce --acordes (les accords de chaque degré ; --triadas, sans septième)",
        sintaxisEscalas: "escalas [<texte>] [options]",
        descripcionEscalas: "le catalogue des gammes : les usuelles et celles d'autres traditions, par catégories, avec leurs notes depuis Do",
        notasEscalas: "options : --tradicion turquia (ou india, grecia, grecia-antigua, mundo-arabe, persia, azerbaiyan, china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia, africa, sudeste-asiatico, gregoriano, europa, vietnam, brasil) et --categoria maqam (ou rāga, makam, dastgah, dromos…) ; --uso jazz (ou clasica, blues, siglo-xx, popular, sintetica) filtre les habituelles ; un texte cherche dans les noms",
        sintaxisTradiciones: "tradiciones [<tradition>]",
        descripcionTradiciones: "les traditions du catalogue, avec leurs catégories et le nombre de gammes de chacune ; avec une, ses gammes",
        sintaxisTonalidad: "tonalidad <tonalité>",
        descripcionTonalidad: "armure, relatives et degrés",
        sintaxisConjunto: "conjunto <classes>",
        descripcionConjunto: "forme primaire, numéro de Forte, vecteurs, symétries et notes",
        sintaxisSerie: "serie <série>",
        descripcionSerie: "matrice, formes et combinatoire d'une série dodécaphonique",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <notes>",
        descripcionTonnetz: "Tonnetz en SVG de quelques notes",
        sintaxisTonnetzAcorde: "tonnetz --acorde <chiffrage> | --escala <gamme> | --clases <nombres>",
        descripcionTonnetzAcorde: "d'un accord, d'une gamme ou d'un ensemble de classes de hauteur",
        sintaxisTonnetzRecorrido: "tonnetz --recorrido <triades> | --camino <triade> <triade>",
        descripcionTonnetzRecorrido: "un parcours de triades, avec des flèches, ou le chemin le plus court par P, L et R",
        sintaxisTonnetzCiclo: "tonnetz --ciclo <cycle> <triade>",
        descripcionTonnetzCiclo: "un cycle hexatonique, octatonique ou LR (--margen 2 : plus de réseau autour)",
        notasTonnetzCiclo: "",
        sintaxisTabla: "tabla <notes ou hauteurs>",
        descripcionTabla: "table harmonique en SVG (hexagones)",
        sintaxisTablaAcorde: "tabla --acorde | --escala | --clases | --recorrido | --camino | --ciclo",
        descripcionTablaAcorde: "comme pour le Tonnetz (--margen 2 : plus de table autour)",
        sintaxisCuadricula: "cuadricula <notes ou hauteurs> | --acorde | --escala | --clases",
        descripcionCuadricula: "clavier en grille en SVG (pads), avec le contour et la première note",
        sintaxisCuadriculaOpciones: "cuadricula --ejes H,V --rejilla CxF --origen <hauteur>\ncuadricula --giro 0-3 --espejo --en-tono --escala <gamme>",
        descripcionCuadriculaOpciones: "axes (1,5 : en quartes), grille du contrôleur (8x8), note du coin, quarts de tour, miroir et dans la tonalité",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "vecinos <accord> [--voces 2]",
        descripcionVecinos: "accords à un demi-ton (septièmes : de dominante, mineure, semi-diminuée et diminuée ; triades : majeure, mineure et augmentée ; --ampliada : aussi avec les maj7)",
        sintaxisConduccionParsimoniosa: "conduccion-parsimoniosa <accord> <accord> [--voces 2] [--ampliada]",
        descripcionConduccionParsimoniosa: "d'un accord à l'autre en bougeant une voix (ou deux) d'un demi-ton à chaque étape",
        sintaxisConduccionMinima: "conduccion-minima <accord> <accord>",
        descripcionConduccionMinima: "la conduite avec le moins de demi- tons",
        sintaxisPlr: "plr <triade> <P, L, R…>",
        descripcionPlr: "transformations néo-riemanniennes",
        sintaxisPlrCamino: "plr <triade> <triade>",
        descripcionPlrCamino: "le chemin le plus court par P, L et R",
        sintaxisPlrCiclo: "plr <triade> <cycle>",
        descripcionPlrCiclo: "un cycle : hexatonico (P, L), octatonico (P, R) ou « ciclo LR »",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melodia <événements> [options]",
        descripcionMusicxmlMelodia: "partition MusicXML d'une mélodie",
        sintaxisMusicxmlCoral: "musicxml coral <accords> [options]",
        descripcionMusicxmlCoral: "choral à quatre voix en MusicXML",
        sintaxisMusicxmlAcordes: "musicxml acordes <chiffrages> [options]",
        descripcionMusicxmlAcordes: "progression avec chiffrages et analyse",
        notasMusicxmlAcordes: "options : --compas 6/8, --anacrusa 8, --tonalidad Sol mayor, --clave fa, --tempo 90 (ou --tempo 60 4.), --titulo Mon choral, --duracion 2 (la durée de chaque accord ; noire sinon), --cifrados et --analisis (dans le choral : chiffrage américain au-dessus, romain et fonction au-dessous)",
        sintaxisMusicxmlArpegios: "musicxml arpegios <chiffrages> [options]",
        descripcionMusicxmlArpegios: "les accords arpégés, note par note",
        notasMusicxmlArpegios: "options : --patron alberti (ou ascendente, descendente, ida y vuelta), --figura 16 (la durée de chaque note ; croche sinon), --duracion 1 (la durée de chaque accord : le motif se répète jusqu'à le remplir) et les autres de « acordes » --enlazar : chaque arpège commence par la note la plus proche de la dernière du précédent",
        sintaxisMusicxmlArchivo: "musicxml acordes --archivo <fichier>",
        descripcionMusicxmlArchivo: "la progression d'un fichier MIDI, MusicXML, MEI ou ABC, avec la durée de chaque accord (aussi arpegios, mei et midi)",
        sintaxisMusicxmlEscala: "musicxml escala <gamme> [options]",
        descripcionMusicxmlEscala: "une gamme en noires, avec ses micro-intervalles : le demi-bémol d'un maqam, le koron, les commas d'un makam",
        sintaxisMeiMelodia: "mei melodia|coral|acordes|arpegios|escala <…> [options]",
        descripcionMeiMelodia: "la même chose en MEI 5, le format des éditions critiques (avec les mêmes options)",
        sintaxisLilypondMelodia: "lilypond melodia|coral|acordes|arpegios|escala <…> [options]",
        descripcionLilypondMelodia: "la même chose en LilyPond, pour graver la partition en PDF",
        sintaxisGuidoMelodia: "guido melodia|coral|acordes|arpegios|escala <…> [options]",
        descripcionGuidoMelodia: "la même chose en GUIDO (.gmn), pour la voir avec GuidoLib ou INScore",
        sintaxisAbcMelodia: "abc melodia|coral|acordes|arpegios|escala <…> [options]",
        descripcionAbcMelodia: "la même chose en ABC, la notation textuelle de la musique traditionnelle",
        sintaxisMidiMelodia: "midi melodia|coral|acordes|arpegios|escala <…> [options]",
        descripcionMidiMelodia: "la même chose en fichier MIDI, pour l'écouter (sans --clave ni --cifrados ; avec --programa 0…127, General MIDI)",
        sintaxisGrabar: "grabar melodia|coral|acordes|arpegios|escala <…>\ngrabar pentagrama|tonnetz|tabla|teclado|reloj <…> [options]",
        descripcionGrabar: "la partition en PDF, SVG ou PNG avec LilyPond, MuseScore, Verovio ou Guido, ou le dessin avec rsvg-convert",
        notasGrabar: "--motor lilypond|musescore|verovio|guido|propio, --formato pdf|svg|png ; Verovio et Guido donnent du SVG, que rsvg-convert passe en PDF ou PNG ; armonia motores dit lesquels sont installés",
        sintaxisMotores: "motores",
        descripcionMotores: "les moteurs d'armonia grabar : où se trouve chaque programme et sa version, ou la variable (ARMONIA_…) qui donne son chemin",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "digitaciones <chiffrage>… [options]",
        descripcionDigitaciones: "façons de jouer un accord, de la plus commode à la moins commode, sur un instrument à cordes et à frettes options : --instrumento guitarra|bajo|ukelele|mandolina|… (aussi « guitarra de siete cuerdas », « bajo de 5 cuerdas », « drop D »), --limite 5, --traste 12 (la case la plus haute utilisée), --dedos 4 (ceux qu'on peut utiliser), --completo (avec toutes les notes : par défaut la quinte peut manquer), --diagrama (une ligne par corde), --capo 2 (cases comptées depuis le capodastre), --musicxml (la première forme de chaque accord, en tablature MusicXML)",
        sintaxisPosiciones: "posiciones <gamme> [--caged]",
        descripcionPosiciones: "la gamme par positions à la guitare : trois notes par corde (deux dans les pentatoniques) ou CAGED",
        notasPosiciones: "options : --secuencia terceras (ou une autre : la séquence dans chaque position ; avec --bajando, en descendant) et --formas (les cinq formes de la pentatonique et leurs notes communes); --instrumento bajo (ou un autre ; aussi re-abierto, sol-abierto, dadgad) et --capo 2",
        sintaxisTeclado: "teclado <gamme> [--mano derecha]",
        descripcionTeclado: "la gamme sur un clavier de piano (SVG) : ses notes ou, avec --mano derecha ou izquierda, les doigts ; --octavas 2",
        sintaxisReloj: "reloj <escala> [--quintas]",
        descripcionReloj: "la gamme sur une horloge de douze heures (SVG) : le cercle chromatique ou, avec --quintas, le cycle des quintes",
        sintaxisPentagrama: "pentagrama escala|acorde|arpegio|acordes <…>",
        descripcionPentagrama: "une gamme, un accord, un arpège (avec rythme : --figura 16, --tresillos) ou des accords avec leur chiffrage sur une portée (SVG) ; --nombres, --intervalos, --semitonos, --tonica, --en <tonalidad>",
        sintaxisPentagramaEstudio: "pentagrama <quoi> --romanos|--mano|--secuencia|--tab",
        descripcionPentagramaEstudio: "les degrés en chiffres romains sous les accords ; les doigtés du piano (--mano derecha) ou de la guitare (--tab --dedos) ; la gamme par tierces ou par groupes (--secuencia terceras) ; la tablature en dessous (--tab, --instrumento)",
        sintaxisPentagramaRegistro: "pentagrama <quoi> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado",
        descripcionPentagramaRegistro: "l'octave (--octava 2), la clé (--clave fa), la double portée, les changements de clé selon le registre et la basse chiffrée des accords (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "pentagrama melodia <notes> --sobre <accords>",
        descripcionPentagramaMelodia: "une mélodie (Do4:8 Re4:8…) avec un accord par mesure au-dessus ; les notes étrangères à l'accord en vert (en rouge si elles sont chromatiques) ; --ajenas pour les autres",
        sintaxisPosicionesArpegio: "posiciones --arpegio <chiffrage> [--caged|--barrido]",
        descripcionPosicionesArpegio: "l'arpège d'un accord dans chaque position du manche, en tablature avec les doigts ; --ida-y-vuelta, monte et descend",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia : théorie musicale en ligne de commande.

        Utilisation : armonia <commande> <arguments> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Commandes (les commandes et les options s'écrivent en espagnol ou en anglais) :
        """,
        pieDeLaAyuda: """
        Les noms de note s'écrivent en espagnol, catalan, galicien, basque, portugais ou anglais
        (Do, C, Sib, Bb, si bemol, ré). Avec --idioma fr, la réponse utilise la notation française
        et les messages en français ; avec --ingles, en anglais.
        Avec --textos, les textes sont dans une autre langue que les notes : --idioma en --textos fr.
        En espagnol et en anglais, --escritura palabras|ascii|unicode écrit les notes Fa sostenido,
        Fa# ou Fa♯ (en anglais, F sharp, F# ou F♯).
        Dans les autres langues, --escritura palabras|compacto choisit les mots ou la forme compacte :
        fa dièse ou Fa♯, F Kreuz ou Fis.
        Dans les écritures compactes, l'octave s'écrit en indice (La₄), et dans les autres en chiffres (La4) ;
        --subindices ou --cifras la fixent (les deux se lisent).
        Avec --json, acorde, identificar, arpegio, intervalo, escala, tonalidad, analizar, conjunto,
        serie, digitaciones et tradiciones donnent leurs données en JSON.
        Avec --json aussi armonizar, realizar, revisar, contrapunto et transponer. Si la sortie n'est
        pas le terminal, le JSON tient sur une seule ligne.
        ARMONIA_IDIOMA=eu fixe la langue sans --idioma ; avec ARMONIA_IDIOMA=sistema, celle de LANG.
        Codes de sortie : 0 bien, 1 texte illisible, 2 commande mal écrite et 3 fautes (revisar,
        contrapunto).
        Sans arguments et dans le terminal, armonia ouvre une session : une commande par ligne.
        Avec l'entrée dans un fichier (armonia < exercices.txt), il exécute ses lignes de même ; une ligne
        faite seulement d'options (--idioma eu) les garde pour les suivantes.
        Avec -o fichier, ce que donne la commande s'écrit dans ce fichier, aussi dans la session.
        Avec --idioma, les notes se lisent aussi dans cette langue : H7 et Fis en allemand, ré en français.
        """,
        sintaxisAyuda: "ayuda [<commande>]",
        descripcionAyuda: "cette aide, ou celle d'une commande (aussi <commande> --help)",
        sintaxisCompletado: "completado bash|zsh|fish",
        descripcionCompletado: "la complétion des commandes et options pour le terminal",
        sintaxisManual: "manual",
        descripcionManual: "cette aide comme page de manuel",
        manualNombre: "NOM",
        manualNotas: "NOTES",
        manualEntorno: "ENVIRONNEMENT",
        manualEstadoDeSalida: "CODE DE RETOUR",
        manualIdiomaDelEntorno: "La langue, comme --idioma (qui l'annule) : es, en, eu… ; avec sistema, celle de LC_ALL, LC_MESSAGES ou LANG.",
        manualRutaDelPrograma: { p in "Le chemin de \(p), s'il n'est pas dans le PATH." },
        manualCodigosDeSalida: ["Tout s'est bien passé.", "Un texte ou un fichier illisible, ou rien à donner.", "La commande est mal écrite.", "revisar ou contrapunto ont trouvé des fautes."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "il manque les accords : " + ejemplo },
        dosAcordesDeConduccion: { ejemplo in "il faut deux accords : " + ejemplo },
        faltanNotasDeLaArmonizacion: { ejemplo in "il manque les notes de la mélodie : " + ejemplo },
        propuestasFueraDeRango: "--propuestas va de 1 à 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "il manque le cantus firmus et le contrepoint, séparés par / : " + ejemplo },
        especieFueraDeRango: "--especie va de 1 à 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "il manque les accords : " + ejemplo },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "il manque le chiffrage : armonia acorde Sol7",
        faltaCifradoDelArpegio: "il manque le chiffrage : armonia arpegio Do7",
        patronDesconocido: { patron in "motif inconnu : « \(patron) » (ascendente, descendente, ida-y-vuelta, baja-y-sube, quebrado ou alberti)" },
        tradicionDesconocida: { tradicion in "« \(tradicion) » n'est pas une tradition (india, grecia, mundo-arabe, persia, turquia…)" },
        categoriaDesconocida: { categoria in "« \(categoria) » n'est pas une catégorie de gammes (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "« \(uso) » n'est pas un usage de gammes (clasica, jazz, blues, siglo-xx, popular, sintetica)" },
        faltanNotas: "il manque les notes : armonia identificar Do Mi Sol",
        dosNotas: "il faut deux notes : armonia intervalo Do Mi",
        faltaEscala: "il manque la gamme : armonia escala Re dórico",
        faltaTonalidad: "il manque la tonalité : armonia tonalidad La menor",
        faltaTonalidadTrasEn: "il manque la tonalité après --en",
        faltaConjunto: "il manque l'ensemble : armonia conjunto 0 4 7",
        faltaSerie: "il manque la série : armonia serie 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "il manque les accords : " + ejemplo },
        archivoIlegible: { nombre in "impossible de lire le fichier « \(nombre) »" },
        archivoNoEscrito: { nombre in "impossible d’écrire le fichier « \(nombre) »" },
        archivoConAcordes: "avec --archivo, n'écrivez pas d'accords",
        archivoSinAcordes: "le fichier ne contient aucun accord",
        faltaTransporte: { ejemplo in "il manque l'intervalle (ou la nouvelle tonique) et ce qu'on transpose : " + ejemplo },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "il manque les accords : " + ejemplo },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "la marge est un nombre de 0 à 6 : --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "il manque les notes : " + ejemplo },
        faltaAcordeDelDibujo: { ejemplo, orden in "il manque l'accord : " + ejemplo },
        faltaEscalaDelDibujo: { ejemplo, orden in "il manque la gamme : " + ejemplo },
        faltanClasesDelDibujo: { ejemplo, orden in "il manque les classes de hauteur : " + ejemplo },
        faltanTriadasDelRecorrido: { ejemplo, orden in "il manque les triades : " + ejemplo },
        cicloMalEscrito: { ejemplo, orden in "le cycle est hexatonique, octatonique ou LR, depuis une triade : " + ejemplo },
        recorridoSoloTriadas: { ejemplo, orden in "le parcours est fait de triades majeures et mineures : " + ejemplo },
        caminoSoloTriadas: { ejemplo, orden in "le chemin va d'une triade majeure ou mineure à une autre : " + ejemplo },
        cicloSoloTriadas: { ejemplo, orden in "le cycle commence sur une triade majeure ou mineure : " + ejemplo },
        opcionesDeCuadricula: "options de la grille : --ejes H,V (1,5), --rejilla CxF (8x8), --origen <hauteur> (Do2), --giro 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "les voix qui bougent sont 1 ou 2 : --voces 2",
        unAcordeDeVecinos: { ejemplo in "il faut un accord : " + ejemplo },
        vecinosSinFamilia: "les voisins se cherchent parmi les septièmes de dominante, mineures, semi-diminuées, diminuées et maj7, ou parmi les triades majeures, mineures et augmentées",
        dosAcordesDeCamino: { ejemplo in "il faut deux accords : " + ejemplo },
        caminoSinConexion: "les deux accords doivent être de la même famille (septièmes, avec ou sans maj7, ou triades) et être reliés",
        faltanPasosDePLR: { ejemplo in "il faut une triade et des étapes ou une autre triade : " + ejemplo },
        plrSoloTriadas: { ejemplo, camino in "P, L et R s'appliquent aux triades majeures et mineures : " + ejemplo },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "il manque « melodia », « coral » ou « acordes » : " + ejemplo },
        instrumentoMIDI: "le programme est un nombre General MIDI de 0 à 127 : --programa 52",
        marcasSoloMusicXML: "--cifrados et --analisis sont pour MusicXML, MEI, LilyPond, GUIDO et ABC",
        faltaValor: { opcion in "il manque la valeur de --\(opcion)" },
        tempoMalEscrito: "le tempo s'écrit « --tempo 90 » ou « --tempo 60 4. »",
        faltanNotasDeLaMelodia: { ejemplo, orden in "il manque les notes : " + ejemplo },
        marcasSoloCoral: "--cifrados et --analisis sont pour « coral »",
        duracionSoloCoral: "--duracion n'est que pour « coral »",
        claveDesconocida: { clave, claves in "clé inconnue : « \(clave) » " + claves },
        faltanAcordesDelCoral: { ejemplo, orden in "il manque les accords : " + ejemplo },
        soloParaMelodia: { opcion in "--\(opcion) n'est que pour « melodia »" },
        soloParaArpegios: { opcion in "--\(opcion) n'est que pour « arpegios »" },
        archivoSoloParaAcordes: "--archivo n'est que pour « acordes » et « arpegios »",
        ventanaSinArchivo: "--ventana va avec --archivo",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "il manque les accords : " + ejemplo },
        acordesConCifradosYAnalisis: "les accords ont toujours chiffrages et analyse",
        tipoDePartituraDesconocido: { tipo in "« \(tipo) » : on exporte une « melodia », un « coral », des « acordes », leurs « arpegios » ou une « escala »" },
        faltaLoQueSeGraba: "il manque ce qu'on grave : armonia grabar coral Do3 Mi4 Sol4 Do5 > coral.pdf",
        motorDesconocido: { motor in "« \(motor) » : les moteurs sont lilypond, musescore, verovio, guido et propio" },
        formatoDeGrabadoDesconocido: { formato in "« \(formato) » : on grave en « pdf », « svg » ou « png »" },
        nadaQueGrabar: { orden in "« \(orden) » : on grave une partition (melodia, coral, acordes, arpegios, escala) ou un dessin (pentagrama, tonnetz, tabla, teclado, cuadricula, reloj)" },
        motorNoEncontrado: { programa, variable in "« \(programa) » introuvable : installez-le ou indiquez son chemin dans \(variable)" },
        motorFallo: { programa, codigo in "« \(programa) » s\'est terminé avec le code \(codigo) :" },
        motorSinTerminar: { programa in "« \(programa) » n\'a pas fini à temps et a été arrêté" },
        motorNoInstalado: { variable in "non installé (ou mets son chemin dans \(variable))" },
        motorPropio: "propio",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "il manque l'instrument : \(d)" },
        instrumentoDesconocido: { nombre, lista in "instrument inconnu : « \(nombre) » (\(lista(.francesPalabras)))" },
        faltaLimite: "il manque le nombre de doigtés : --limite 5",
        limiteFueraDeRango: "la limite est un nombre de 1 à 200 : --limite 5",
        faltanDedos: "il manque le nombre de doigts : --dedos 3",
        dedosFueraDeRango: "les doigts sont un nombre de 1 à 4 : --dedos 3",
        faltaTraste: "il manque la case la plus haute : --traste 12",
        trasteFueraDeRango: "la case la plus haute est un nombre de 0 à 24 : --traste 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "il manque le chiffrage : \(d)" },
        faltaEscalaDePosiciones: "il manque la gamme : armonia posiciones Sol mayor",
        faltaEscalaDelTeclado: "il manque la gamme : armonia teclado Re mayor",
        manoDesconocida: { texto in "main inconnue : « \(texto) » (derecha ou izquierda)" },
        archivoConNotas: "avec --archivo, n'écrivez pas de notes",
        noEsPentatonica: "les formes sont celles d'une gamme de cinq notes : armonia posiciones La pentatónica menor --formas",
        faltaEscalaDelReloj: "il manque la gamme : armonia reloj Re mayor",
        faltaLoQueDibujaElPentagrama: "il manque ce qu'il faut dessiner : armonia pentagrama escala Re dórico",
        capoFueraDeRango: "le capodastre est un nombre de 0 à 12 : --capo 2",
        octavasFueraDeRango: "les octaves sont un nombre de 1 à 4 : --octavas 2",
        octavaFueraDeRango: "l'octave est un nombre de 0 à 7 : --octava 3",
        desdeNoValido: { desde in "« \(desde) » n'est ni une note ni un degré de l'accord : --desde Mi ou --desde 3" },
        tensionesMalEscritas: "les tensions sont 9, 11 ou 13 : --tensiones 9,13",
        gradosMalEscritos: "les degrés sont des nombres de 1 à 22 : --grados 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "approche inconnue : « \(aproximacion) » (abajo, arriba ou encierro)" },
        secuenciaDesconocida: { secuencia in "séquence inconnue : « \(secuencia) » (terceras, cuartas, grupos-de-3, grupos-de-4, triadas ou cuatriadas)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Essayez « armonia ayuda ».",
        ordenDesconocida: { orden in "commande inconnue : « \(orden) »" },
        opcionDesconocida: { opcion in "option inconnue : « \(opcion) »" },
        idiomaDesconocido: { idioma in "langue inconnue : « \(idioma) » (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru ou hu)" },
        terminalDesconocida: { t in "terminal inconnu : « \(t) » (bash, zsh ou fish)" },
        escrituraNoValida: { escritura in "écriture non valide : « \(escritura) » (palabras/words ou compacto/compact ; ascii ou unicode, seulement avec es et en)" },
        sinSalidaJSON: { orden in "« \(orden) » ne donne pas de sortie JSON" },

        // Mensaje.swift
        mensajeNotas: "notes",
        mensajeAcordes: "accords",
        mensajeMicrotonos: "micro-intervalles",
        mensajeEscalas: "gammes",
        mensajeHabituales: "usuelles",
        mensajeNingunaEscala: "aucune gamme ne correspond",
        mensajeArmadura: "armure",
        mensajeRelativa: "relative",
        mensajeHomonima: "homonyme",
        mensajeBajo: { nota in "basse \(nota)" },
        mensajeBajoAjeno: "basse étrangère à l'accord",
        mensajeSinAcordes: "Aucun accord connu.",
        mensajeSin: { notas in "sans \(notas)" },
        mensajeSemitonos: { n in "\(n) demi-tons" },
        mensajeSinAlteraciones: "sans altérations",
        mensajeSostenidos: { n in Idioma.frances.contar(n, "dièse", "dièses") },
        mensajeBemoles: { n in Idioma.frances.contar(n, "bémol", "bémols") },
        mensajeACuatroVoces: "À quatre voix (basse, ténor, alto, soprano) :",
        mensajeSinDigitaciones: "aucun doigté confortable",
        mensajeDedos: { n in Idioma.frances.contar(n, "doigt", "doigts") },
        mensajeCejilla: { traste in "barré à la case \(traste)" },
        mensajeNingunPaso: "aucune étape",
        mensajeUnPaso: "1 étape",
        mensajePasos: { n in "\(n) étapes" },
        mensajeTriadas: { n in Idioma.frances.contar(n, "triade", "triades") },
        mensajeFormaNormal: "forme normale",
        mensajeFormaPrima: "forme primaire",
        mensajeVectorIntervalico: "vecteur d'intervalles",
        mensajeVectorDeIndice: "vecteur d'indices",
        mensajeEjesDeSimetria: "axes de symétrie",
        mensajeIntervalos: "intervalles",
        mensajeDeTodosLosIntervalos: "tous intervalles",
        mensajeFormasDistintas: { n in "\(n) formes distinctes" },
        mensajeHexacordos: "hexacordes",
        mensajeFormasCombinatorias: "formes combinatoires",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "la version d'armonia",
        quisoDecir: { x in "Vouliez-vous dire « \(x) » ?" },
        pruebaLaAyudaDe: { o in "Essayez « armonia ayuda \(o) »." },
        salidaBinaria: "la sortie est un fichier binaire (MIDI, PDF ou PNG) ; enregistrez-la avec > fichier",
        escalasPorNotas: { e in "aucune gamme ne porte ce nom ; pour la chercher par ses notes : \(e)" },
        grabarUnaPartitura: { o, e in "« armonia \(o) » écrit déjà la partition ; « grabar » la donne en PDF, SVG ou PNG : \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Consultations", "Harmonie et voix", "Partitions et gravure", "Dessins (SVG)", "Néo-riemannienne", "Instruments à frettes", "Le terminal et l'aide"],
        pieDelIndice: """
        L'aide d'une commande : armonia ayuda <commande> (ou armonia <commande> --help).
        Toute l'aide, avec les options de chaque commande : armonia ayuda --todo.
        Pour toutes les commandes : --ingles, --idioma, --textos, --escritura, --subindices, --cifras et --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Écrivez une commande par ligne, sans « armonia » (ayuda : les commandes ; salir : terminer)." }
    )
}
