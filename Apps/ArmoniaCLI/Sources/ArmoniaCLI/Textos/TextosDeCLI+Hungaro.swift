// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let hungaro = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <akkordok> [--in <hangnem>] [--scales]",
        descripcionAnalizar: "fokszámok, funkciók, zárlatok és modulációk (közvetítő akkordjukkal; --in nélkül)\n--scales: minden akkord skálája, a feszültségekkel és kerülendő hangokkal",
        notasAnalizar: "--guide-tones: két vezetőhang-vonal, a terctől és a szeptimtől; --voice-leading: hogyan halad minden szólam egyik akkordról a következőre (drop 2-ben), a közös hangokkal; --against: a másik változat akkordról akkordra, azzal, ami változik, a fokaival és a közös hangokkal; --walking-bass: walking basszus negyedekben, akkordonként egy ütem",
        sintaxisAnalizarArchivo: "analyze --file <fájl> [--window <időtartam>]",
        descripcionAnalizarArchivo: "ugyanez egy MIDI-, MusicXML-, MEI- vagy ABC-fájl akkordjaival (ütésenként egy; --window 2: félhangonként egy)",
        sintaxisArmonizar: "harmonize <dallam> [--in <hangnem>] [--proposals 3]",
        descripcionArmonizar: "akkordok egy dallamhoz, a legjobb elöl; oktávokkal (E4) a négyszólamú korál is",
        sintaxisRealizar: "realize <akkordok> [--in <hangnem>]",
        descripcionRealizar: "az akkordok négy szólamban, szólamvezetési hibák nélkül",
        sintaxisRevisar: "check <akkordok>",
        descripcionRevisar: "szólamvezetési hibák (párhuzamos kvintek…); akkordok mélytől magasig, vesszővel elválasztva",
        sintaxisContrapunto: "counterpoint <cantus> / <ellenpont> [--species 1]",
        descripcionContrapunto: "hibák a fajtás ellenpontban (1–5) egész hangokban írt cantus firmus fölött; az időtartam nélküli hangok a fajtáét kapják",
        sintaxisTransponer: "transpose <hangköz|alaphang> <akkordok vagy hangok>",
        descripcionTransponer: "akkordokat, dallamot vagy korált visz át másik hangnembe: hangköz (M2, -m3) vagy az új alaphang (D)",
        sintaxisRearmonizar: "reharmonize <akkordok> [--in <hangnem>]",
        descripcionRearmonizar: "más harmóniák minden akkordhoz: tritónuszhelyettesítés, mellékdominánsok, modális kölcsönzés és diatonikus helyettesítések",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <akkordjelzés>…",
        descripcionAcorde: "hangok, típus és minden hang szerepe",
        notasAcorde: "opciók: --voicings, --names, --keys, --substitutions (a --in C major hangnemében, a végén) és --compare C (közös hangok és szólamvezetés); --bebop és --pentatonics (skálák az improvizációhoz)",
        sintaxisArpegio: "arpeggio <akkordjelzés> [--pattern <minta>]",
        descripcionArpegio: "a felbontás hangjai és az akkordhoz illő skálák (--pattern ascending, descending, up-down, down-up, broken, alberti)",
        notasArpegio: "opciók: --octaves 2 (1-től 4-ig), --no-octave, --from E (vagy 3: ezzel a hanggal kezd), --tensions 9,13, --degrees 1-5-3-8 (saját menet) és --approach below, above vagy enclosure (kromatikus hangok, amelyek mindegyikhez vezetnek)",
        sintaxisIdentificar: "identify <hangok>",
        descripcionIdentificar: "a hangokból alkotható akkordok",
        notasIdentificar: "opciók: --scales (a hangokat tartalmazó skálák akkordok helyett) és --file melody.mid (egy MIDI-, MusicXML-, MEI- vagy ABC-fájl hangjai, --scales mellett)",
        sintaxisIntervalo: "interval <hang> <hang>",
        descripcionIntervalo: "két hang vagy hangmagasság közötti hangköz",
        sintaxisEscala: "scale <skála> [--chords]",
        descripcionEscala: "egy skála hangjai és akkordjai\n--chords: minden fokon minden beleillő akkord, nem csak a terces",
        notasEscala: "opciók: --sequence thirds (vagy fourths, groups-of-3, groups-of-4, triads, sevenths), --descending, --octaves 2 (1-től 4-ig), --piano (ujjrend), --modes (párhuzamos és rokon) és --compare C lydian (a végén); --symmetry (milyen gyakran ismétlődik, és az akkordjai); --neighbors (egy hang elmozdításával) és --all-keys (mind a tizenkét hangnemben); --all-keys --chords (minden fok akkordjai; --triads, szeptim nélkül); --statistics (hangok száma, fényesség, hangközvektor…); --brightness-ladder (a legsötétebbtől a legfényesebbig, mindig egy hangot emelve); --against C dorian (hangonkénti összehasonlítás, kottán és órán, SVG-ben); --closest (amelyeknek a legtöbb közös hangjuk van vele, a legkevésbé eltérőtől); --progressions (akkordmenetek a hármashangzataival, a fokokkal és a dúron vagy mollon kívüli hangokkal)",
        sintaxisEscalas: "scales [<szöveg>] [opciók]",
        descripcionEscalas: "a skálák katalógusa: a szokásosak és más hagyományokéi, kategóriánként, C-től induló hangjaikkal",
        notasEscalas: "opciók: --tradition turkey (vagy india, greece, ancient-greece, arab-world, persia, azerbaijan, china, japan, korea, ethiopia, indonesia, klezmer, andes, byzantium, mesopotamia, africa, southeast-asia, gregorian, europe, vietnam, brazil) és --category maqam (vagy rāga, makam, dastgah, dromos…); --source ptolemy (vagy archytas, aristoxenus, didymus, glarean…) csak egy teoretikus skáláit hagyja meg; --use jazz (vagy classical, blues, 20th-century, folk, synthetic) szűri a szokásosakat; --notes 5 csak az öthangúakat hagyja meg; --sort brightness (vagy notes) rendezi őket, a --anhemitonic és a --maximally-even pedig az anhemiton és a maximálisan egyenletes skálákat hagyja meg; --with-interval tritone és --without-interval semitone (vagy egy szám 1 és 6 között) és --with-step 3 hangközök szerint keres; --compare C major, C lydian táblázatba rendezi őket; --map fényességtérképre rajzolja őket (SVG); a szöveg a nevekben keres",
        sintaxisTradiciones: "traditions [<hagyomány>]",
        descripcionTradiciones: "a katalógus hagyományai a kategóriáikkal és skáláik számával; eggyel: annak skálái",
        sintaxisTonalidad: "key <hangnem>",
        descripcionTonalidad: "előjegyzés, rokon hangnemek és fokok; --modulations: hogyan jutunk el minden rokon hangnembe (vagy --modulations G major, abba), a közös akkorddal",
        sintaxisConjunto: "set <osztályok>",
        descripcionConjunto: "prímforma, Forte-szám, vektorok, szimmetriák és hangok",
        sintaxisSerie: "row <sor>",
        descripcionSerie: "tizenkétfokú sor mátrixa, formái és kombinatorikája",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <hangok>",
        descripcionTonnetz: "néhány hang Tonnetze SVG-ben",
        sintaxisTonnetzAcorde: "tonnetz --chord <jelzés> | --scale <skála> | --pcs <számok>",
        descripcionTonnetzAcorde: "egy akkordé, egy skáláé vagy egy hangosztályhalmazé",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <hármashangzatok> | --shortest <hármashangzat> <hármashangzat>",
        descripcionTonnetzRecorrido: "hármashangzatok sora nyilakkal, vagy a legrövidebb út P, L és R mentén",
        sintaxisTonnetzCiclo: "tonnetz --cycle <ciklus> <hármashangzat>",
        descripcionTonnetzCiclo: "hexatonikus, oktatonikus vagy LR-ciklus",
        notasTonnetzCiclo: "(--margen 2: több rács körülötte)",
        sintaxisTabla: "tabla <hangok vagy hangmagasságok>",
        descripcionTabla: "harmonikus tábla SVG-ben (hatszögek)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "mint a Tonnetznél (--margen 2: több tábla körülötte)",
        sintaxisCuadricula: "cuadricula <hangok vagy hangmagasságok> | --chord | --scale | --pcs",
        descripcionCuadricula: "rácsos billentyűzet SVG-ben (padek), körvonallal és az első hanggal",
        sintaxisCuadriculaOpciones: "cuadricula --axes H,V --grid CxR --origin <hangmagasság>\ncuadricula --rotate 0-3 --mirror --in-key --scale <skála>",
        descripcionCuadriculaOpciones: "tengelyek (1,5: kvartokban), a vezérlő rácsa (8x8), sarokhang, negyedfordulat, tükrözés és hangnemben",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <akkord> [--voices 2]",
        descripcionVecinos: "félhangnyira lévő akkordok (szeptimakkordok: domináns, moll, félszűkített és szűkített; hármashangzatok: dúr, moll és bővített; egy maj7 a szeptimakkordok és a maj7-ek között;\n--extended: a maj7-ekkel is)",
        sintaxisConduccionParsimoniosa: "smooth-path <akkord> <akkord> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "egyik akkordtól a másikig, minden lépésben egy (vagy két) szólam mozog félhangot",
        sintaxisConduccionMinima: "minimal-voice-leading <akkord> <akkord>",
        descripcionConduccionMinima: "a legkevesebb félhangú szólamvezetés",
        sintaxisPlr: "plr <hármashangzat> <P, L, R…>",
        descripcionPlr: "neo-riemanni transzformációk",
        sintaxisPlrCamino: "plr <hármashangzat> <hármashangzat>",
        descripcionPlrCamino: "a legrövidebb út P, L és R mentén",
        sintaxisPlrCiclo: "plr <hármashangzat> <ciklus>",
        descripcionPlrCiclo: "ciklus: hexatonic (P, L), octatonic (P, R) vagy \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <események> [opciók]",
        descripcionMusicxmlMelodia: "egy dallam MusicXML-kottája",
        sintaxisMusicxmlCoral: "musicxml chorale <akkordok> [opciók]",
        descripcionMusicxmlCoral: "négyszólamú korál MusicXML-ben",
        sintaxisMusicxmlAcordes: "musicxml chords <jelzések> [opciók]",
        descripcionMusicxmlAcordes: "akkordmenet jelzésekkel és elemzéssel",
        notasMusicxmlAcordes: "opciók: --compas 6/8 (ütemmutató), --anacrusa 8 (felütés), --tonalidad G major (hangnem), --clave fa (kulcs), --tempo 90 (vagy --tempo 60 4.), --titulo Korálom (cím), --duracion 2 (az akkordok hossza; alapból negyed), --cifrados és --analisis (a korálban: fölül akkordjelzések, alul fokszámok és funkció)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <jelzések> [opciók]",
        descripcionMusicxmlArpegios: "az akkordok felbontva, hangról hangra",
        notasMusicxmlArpegios: "opciók: --patron alberti (vagy up, down, up-down), --figura 16 (a hangok hossza; alapból nyolcad), --duracion 1 (az akkordok hossza: a minta ismétlődik, amíg ki nem tölti) és a \"chords\" többi opciója\n--connect: minden felbontás az előző utolsó hangjához legközelebbi hanggal kezdődik",
        sintaxisMusicxmlArchivo: "musicxml chords --file <fájl>",
        descripcionMusicxmlArchivo: "egy MIDI-, MusicXML-, MEI- vagy ABC-fájl akkordmenete az akkordok hosszával (arpeggios, mei és midi is)",
        sintaxisMusicxmlEscala: "musicxml scale <skála> [opciók]",
        descripcionMusicxmlEscala: "egy skála negyedekben, a mikrohangjaival: egy makám negyedhangos bé-je, a koron, egy makam kommái",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios|scale <…> [opciók]",
        descripcionMeiMelodia: "ugyanez MEI 5-ben, a kritikai kiadások formátumában (ugyanazokkal az opciókkal)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios|scale <…> [opciók]",
        descripcionLilypondMelodia: "ugyanez LilyPondban, hogy PDF-be szedd a kottát",
        sintaxisGuidoMelodia: "guido melody|chorale|chords|arpeggios|scale <…> [opciók]",
        descripcionGuidoMelodia: "ugyanez GUIDO-ban (.gmn), hogy GuidoLibbel vagy INScore-ral nézd meg",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios|scale <…> [opciók]",
        descripcionAbcMelodia: "ugyanez ABC-ben, a népzene szöveges kottaírásában",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios|scale <…> [opciók]",
        descripcionMidiMelodia: "ugyanez MIDI-fájlként, meghallgatásra (--clave és --cifrados nélkül; --program 0…127, General MIDI)",
        sintaxisGrabar: "engrave melody|chorale|chords|arpeggios|scale <…>\nengrave staff|tonnetz|harmonic-table|keyboard|clock <…> [opciók]",
        descripcionGrabar: "a kotta PDF-ben, SVG-ben vagy PNG-ben LilyPonddal, MuseScore-ral, Verovióval vagy Guidóval, vagy a rajz rsvg-converttel",
        notasGrabar: "--engine lilypond|musescore|verovio|guido|own, --format pdf|svg|png; a Verovio és a Guido SVG-t ad, amit az rsvg-convert PDF-be vagy PNG-be alakít; az armonia engines megmutatja, melyek vannak telepítve",
        sintaxisMotores: "engines",
        descripcionMotores: "az armonia engrave motorjai: hol vannak a programok és mi a verziójuk, vagy a változó (ARMONIA_…), amely megadja az útvonalukat",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <akkordjelzés>… [opciók]",
        descripcionDigitaciones: "egy akkord fogásai a legkényelmesebbtől a legkevésbé kényelmesig, bundos húros hangszeren (a húrok mélytől magasig)\nopciók: --instrument guitar|bass|ukulele|mandolin|… (\"seven-string guitar\", \"five-string bass\", \"drop D\" is), --limit 5, --fret 12 (a legmagasabb használt bund), --fingers 4 (hány ujj használható), --complete (minden hanggal: alapból a kvint elhagyható), --diagram (húronként egy sor), --capo 2 (a bundok a kapodasztertől számítva), --musicxml (minden akkord első fogása MusicXML-tabulatúraként)",
        sintaxisPosiciones: "positions <skála> [--caged]",
        descripcionPosiciones: "a skála fekvésenként a gitáron: húronként három hang (a pentatonnál kettő) vagy CAGED",
        notasPosiciones: "opciók: --sequence thirds (vagy más: a szekvencia minden fekvésben; a --descending lefelé) és --shapes (a pentaton öt formája és közös hangjaik); --instrument bass (vagy más; open-d, open-g, dadgad is) és --capo 2",
        sintaxisTeclado: "keyboard <skála> [--hand right]",
        descripcionTeclado: "a skála zongora-billentyűzeten (SVG): a hangjai vagy --hand right vagy left mellett az ujjak; --octaves 2",
        sintaxisReloj: "clock <scale> [--fifths]",
        descripcionReloj: "a skála egy tizenkét órás számlapon (SVG): a kromatikus kör vagy --fifths mellett a kvintkör",
        sintaxisHoja: "sheet <scale>",
        descripcionHoja: "a skála nyomtatható gyakorlólapon (SVG): kottasor, billentyűzet ujjrenddel, óra, statisztika, akkordok és fényességlétra; az armonia engrave sheet … PDF-be alakítja",
        sintaxisHojaDeAcorde: "sheet --chord <symbol>",
        descripcionHojaDeAcorde: "az akkord nyomtatható gyakorlólapon (SVG): hangok és más nevek, kottasor, fekvések, gitárfogások, illeszkedő skálák és helyettesítések",
        sintaxisHojaDeAcordes: "sheet --chords <chords> [--in <key>] [--all-keys] [--against <chords>]",
        descripcionHojaDeAcordes: "az akkordmenet nyomtatható gyakorlólapon (SVG): kottasor minden akkord egy fekvésével, elemzés fokokkal, funkciókkal és skálákkal, zárlatok és vezérhangvonalak; a szólamvezetés is. --all-keys esetén a sor mind a tizenkét hangnemben, mindegyik a saját kottájával. --against esetén akkordról akkordra összevetve egy másik változattal (újraharmonizálás…): ami változik, pirossal",
        sintaxisHojaDeTonalidad: "sheet --key <key>",
        descripcionHojaDeTonalidad: "a hangnem nyomtatható gyakorlólapon (SVG): előjegyzés, párhuzamos és azonos alaphangú hangnem, a skála a kottasoron, minden fok akkordja a funkciójával, a jellegzetes zárlatok és a moduláció a rokon hangnemekbe",
        sintaxisPentagrama: "staff scale|chord|arpeggio|chords <hangok>",
        descripcionPentagrama: "egy skála, egy akkord, egy arpeggio (ritmussal: --figure 16, --triplets) vagy akkordok a jelölésükkel egy kottasoron (SVG); --names, --intervals, --semitones, --tonic, --in <key>",
        sintaxisPentagramaEstudio: "staff <mit> --roman|--hand|--sequence|--tab",
        descripcionPentagramaEstudio: "a fokok római számokkal az akkordok alatt; a zongora ujjrendje (--hand right) vagy a gitáré (--tab --fingers); a skála terceken vagy csoportokban (--sequence thirds); alatta a tabulatúra (--tab, --instrument)",
        sintaxisPentagramaRegistro: "staff <mit> --octave|--clef|--grand-staff|--clef-changes|--figured-bass",
        descripcionPentagramaRegistro: "az oktáv (--octave 2), a kulcs (--clef bass), a kettős kottasor, a kulcsváltás a fekvés szerint és az akkordok számozott basszusa (6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "staff melody <hangok> --over <akkordok>",
        descripcionPentagramaMelodia: "egy dallam (C4:8 D4:8…) ütemenként egy akkorddal fölötte; az akkordidegen hangok zölddel (kromatikusak pirossal); a --non-chord máshol is ezt teszi",
        sintaxisPentagramaBajo: "staff bass <chords> [--tab]",
        descripcionPentagramaBajo: "walking basszus negyedekben az akkordmenet alatt, basszuskulcsban: az alaphang az első ütemrészen, akkordhangok a másodikon és a harmadikon, és kromatikus átmenőhang a következő akkord felé; --tab esetén a basszus tabulatúrájával",
        sintaxisPosicionesArpegio: "positions --arpeggio <akkordjelzés> [--caged|--sweep]",
        descripcionPosicionesArpegio: "egy akkord arpeggiója a fogólap minden fekvésében, tabulatúrával és ujjakkal; --up-and-down, fel és vissza",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: zeneelmélet a parancssorban.

        Használat: armonia <parancs> <argumentumok> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Parancsok (a parancsok és az opciók spanyolul vagy angolul íródnak):
        """,
        pieDeLaAyuda: """
        A hangneveket spanyolul, katalánul, galíciaiul, baszkul, portugálul vagy angolul fogadja el
        (Do, C, Sib, Bb, si bemol). A --idioma hu kapcsolóval a válasz magyar hangneveket (B, H, Fisz)
        és magyar üzeneteket használ; a --ingles kapcsolóval angolt.
        A --textos kapcsolóval a szövegek más nyelven vannak, mint a hangok: --idioma en --textos hu.
        Spanyolul és angolul a --escritura palabras|ascii|unicode így írja a hangokat:
        Fa sostenido, Fa# vagy Fa♯ (angolul F sharp, F# vagy F♯).
        A többi nyelven a --escritura palabras|compacto a szavas vagy a tömör írásmódot választja:
        fa dièse vagy Fa♯, F Kreuz vagy Fis.
        A tömör írásmódokban az oktáv alsó indexbe kerül (La₄), a többiben számjeggyel (La4);
        a --subindices vagy a --cifras rögzíti (mindkettőt olvassa).
        A --json kapcsolóval a chord, identify, arpeggio, interval, scale, key, analyze, set, row,
        fingerings és traditions JSON-ban adja az adatait.
        A --json kapcsolóval a harmonize, realize, check, counterpoint és transpose is. Ha a kimenet
        nem terminál, a JSON egyetlen sorban jelenik meg.
        Az ARMONIA_IDIOMA=eu --idioma nélkül állítja be a nyelvet; az ARMONIA_IDIOMA=system a LANG-ét veszi.
        Kilépési kódok: 0 rendben, 1 olvashatatlan szöveg, 2 hibásan írt parancs és 3 hibák (check,
        counterpoint).
        Argumentumok nélkül, terminálban az armonia munkamenetet nyit: soronként egy parancs.
        Ha a bemenet fájlból jön (armonia < gyakorlatok.txt), a sorait ugyanígy futtatja; a csak
        kapcsolókat tartalmazó sor (--idioma eu) a következő sorokra is érvényes marad.
        A -o fájl a parancs kimenetét ebbe a fájlba írja, a munkamenetben is.
        A --idioma mellett a hangok azon a nyelven is olvashatók: H7 és Fis németül, ré franciául.
        """,
        sintaxisAyuda: "help [<parancs>]",
        descripcionAyuda: "ez a súgó, vagy egy parancs súgója (<parancs> --help is)",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "a parancsok és az opciók kiegészítése a parancsértelmezőben",
        sintaxisManual: "manual",
        descripcionManual: "ez a súgó kézikönyvoldalként",
        manualNombre: "NÉV",
        manualNotas: "MEGJEGYZÉSEK",
        manualEntorno: "KÖRNYEZET",
        manualEstadoDeSalida: "KILÉPÉSI ÁLLAPOT",
        manualIdiomaDelEntorno: "A nyelv, mint a --idioma (amely felülírja): es, en, eu…; a system értékkel a LC_ALL, LC_MESSAGES vagy LANG szerinti.",
        manualRutaDelPrograma: { p in "A(z) \(p) elérési útja, ha nincs a PATH-ban." },
        manualCodigosDeSalida: ["Minden rendben ment.", "Olvashatatlan szöveg vagy fájl, vagy nincs mit kiadni.", "A parancs hibásan van megírva.", "A check vagy a counterpoint hibát talált."],

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "hiányoznak az akkordok: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "két akkord kell: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "hiányoznak a dallam hangjai: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "a --proposals értéke 1 és 20 között lehet",
        faltanVocesDelContrapunto: { ejemplo, ingles in "hiányzik a cantus firmus és az ellenpont, /-rel elválasztva: " + ingles },
        especieFueraDeRango: "a --species értéke 1 és 5 között lehet",
        faltanAcordesDeLaRealizacion: { ejemplo in "hiányoznak az akkordok: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "hiányzik az akkordjelzés: armonia chord G7",
        faltaCifradoDelArpegio: "hiányzik az akkordjelzés: armonia arpeggio C7",
        patronDesconocido: { patron in "ismeretlen minta: „\(patron)” (ascending, descending, up-down, down-up, broken vagy alberti)" },
        tradicionDesconocida: { tradicion in "„\(tradicion)”: ez nem hagyomány (india, greece, arab-world, persia, turkey…)" },
        categoriaDesconocida: { categoria in "„\(categoria)”: ez nem skálakategória (rāga, maqam, makam, dastgah…)" },
        fuenteDesconocida: { fuente in "„\(fuente)”: ez nem a katalógus teoretikusa (ptolemy, aristoxenus, guido, glarean…)" },
        usoDesconocido: { uso in "„\(uso)”: ez nem skálahasználat (classical, jazz, blues, 20th-century, folk, synthetic)" },
        ordenDeEscalasDesconocido: { orden in "„\(orden)”: a skálák brightness vagy notes szerint rendezhetők: --sort brightness" },
        intervaloDeEscalasDesconocido: { intervalo in "„\(intervalo)”: a hangköz 1 és 6 közötti szám, vagy semitone, tone, minor-third, major-third, fourth vagy tritone: --with-interval tritone" },
        pasoFueraDeRango: "a lépés 1 és 11 közötti félhangszám: --with-step 3",
        faltanNotas: "hiányoznak a hangok: armonia identify C E G",
        dosNotas: "két hang kell: armonia interval C E",
        faltaEscala: "hiányzik a skála: armonia scale D dorian",
        faltaTonalidad: "hiányzik a hangnem: armonia key A minor",
        faltaTonalidadTrasEn: "hiányzik a hangnem a --in után",
        faltaConjunto: "hiányzik a halmaz: armonia set 0 4 7",
        faltaSerie: "hiányzik a sor: armonia row 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "hiányoznak az akkordok: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "nem olvasható a fájl: „\(nombre)”" },
        archivoNoEscrito: { nombre in "nem írható a fájl: „\(nombre)”" },
        archivoConAcordes: "a --file mellett ne írj akkordokat",
        archivoSinAcordes: "a fájlban nincsenek akkordok",
        faltaTransporte: { ejemplo in "hiányzik a hangköz (vagy az új alaphang) és az, amit transzponálni kell: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "hiányoznak az akkordok: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "a margó 0 és 6 közötti szám: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "hiányoznak a hangok: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "hiányzik az akkord: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "hiányzik a skála: armonia \(orden) --scale D dorian" },
        faltanClasesDelDibujo: { ejemplo, orden in "hiányoznak a hangosztályok: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "hiányoznak a hármashangzatok: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "a ciklus hexatonikus, oktatonikus vagy LR, egy hármashangzattól indulva: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "a sor dúr és moll hármashangzatokból áll: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "a legrövidebb út egy dúr vagy moll hármashangzattól egy másikig vezet: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "a ciklus dúr vagy moll hármashangzaton kezdődik: armonia \(orden) --cycle hexatonic C" },
        opcionesDeCuadricula: "a rács beállításai: --axes H,V (1,5), --grid CxR (8x8), --origin <hangmagasság> (C2), --rotate 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "1 vagy 2 szólam mozog: --voices 2",
        unAcordeDeVecinos: { ejemplo in "egy akkord kell: armonia neighbors G7" },
        vecinosSinFamilia: "a szomszédokat domináns, moll, félszűkített, szűkített és maj7 szeptimakkordok, vagy dúr, moll és bővített hármashangzatok között keresi",
        dosAcordesDeCamino: { ejemplo in "két akkord kell: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "a két akkordnak ugyanabba a családba kell tartoznia (szeptimakkordok, maj7-tel vagy anélkül, vagy hármashangzatok), és összeköthetőnek kell lennie",
        faltanPasosDePLR: { ejemplo in "egy hármashangzat és lépések vagy egy másik hármashangzat kell: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "a P, L és R dúr és moll hármashangzatokra vonatkozik: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "hiányzik a „melody”, „chorale” vagy „chords”: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "a program 0 és 127 közötti General MIDI-szám: --program 52",
        marcasSoloMusicXML: "a --cifrados és a --analisis a MusicXML, a MEI, a LilyPond, a GUIDO és az ABC számára van",
        faltaValor: { opcion in "hiányzik a --\(opcion) értéke" },
        tempoMalEscrito: "a tempó írásmódja „--tempo 90” vagy „--tempo 60 4.”",
        faltanNotasDeLaMelodia: { ejemplo, orden in "hiányoznak a hangok: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "a --cifrados és a --analisis a „chorale” számára van",
        duracionSoloCoral: "a --duracion csak a „chorale” számára van",
        claveDesconocida: { clave, claves in "ismeretlen kulcs: „\(clave)” (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "hiányoznak az akkordok: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "a --\(opcion) csak a „melody” számára van" },
        soloParaArpegios: { opcion in "a --\(opcion) csak az „arpeggios” számára van" },
        archivoSoloParaAcordes: "a --file csak a „chords” és az „arpeggios” számára van",
        ventanaSinArchivo: "a --window a --file mellé tartozik",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "hiányoznak az akkordok: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "az akkordok mindig akkordjelzéssel és elemzéssel jelennek meg",
        tipoDePartituraDesconocido: { tipo in "„\(tipo)”: az export lehet „melody”, „chorale”, „chords”, ezek „arpeggios” változata vagy „scale”" },
        faltaLoQueSeGraba: "hiányzik, mit kell szedni: armonia engrave chorale C3 E4 G4 C5 > chorale.pdf",
        motorDesconocido: { motor in "„\(motor)”: a motorok: lilypond, musescore, verovio, guido és own" },
        formatoDeGrabadoDesconocido: { formato in "„\(formato)”: a kimenet „pdf”, „svg” vagy „png”" },
        nadaQueGrabar: { orden in "„\(orden)”: kotta (melody, chorale, chords, arpeggios, scale) vagy rajz (staff, tonnetz, harmonic-table, keyboard, grid, clock) szedhető" },
        motorNoEncontrado: { programa, variable in "nem található: „\(programa)”; telepítsd, vagy add meg az útvonalát a(z) \(variable) változóban" },
        motorFallo: { programa, codigo in "a(z) „\(programa)” \(codigo) kóddal lépett ki:" },
        motorSinTerminar: { programa in "a(z) „\(programa)” nem végzett időben, ezért leállt" },
        motorNoInstalado: { variable in "nincs telepítve (vagy add meg az útvonalát: \(variable))" },
        motorPropio: "own",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "hiányzik a hangszer: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "ismeretlen hangszer: „\(nombre)” (\(lista(.conPalabras(.hungaro))))" },
        faltaLimite: "hiányzik a fogások száma: --limit 5",
        limiteFueraDeRango: "a korlát 1 és 200 közötti szám: --limit 5",
        faltanDedos: "hiányzik az ujjak száma: --fingers 3",
        dedosFueraDeRango: "az ujjak száma 1 és 4 között lehet: --fingers 3",
        faltaTraste: "hiányzik a legmagasabb bund: --fret 12",
        trasteFueraDeRango: "a legmagasabb bund 0 és 24 közötti szám: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "hiányzik az akkordjelzés: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "hiányzik a skála: armonia positions G major",
        faltaEscalaDelTeclado: "hiányzik a skála: armonia keyboard D major",
        manoDesconocida: { texto in "ismeretlen kéz: „\(texto)” (right vagy left)" },
        archivoConNotas: "a --file mellett ne írj hangokat",
        noEsPentatonica: "a formák ötfokú skálához tartoznak: armonia positions A minor pentatonic --shapes",
        faltaEscalaDelReloj: "hiányzik a skála: armonia clock D major",
        faltaEscalaDeLaHoja: "hiányzik a skála: armonia sheet D major",
        faltanLosAcordesDeLaHoja: "hiányoznak az akkordok: armonia sheet --chords Dm7 G7 Cmaj7",
        faltaElAcordeDeLaHoja: "hiányzik az akkord: armonia sheet --chord G7",
        faltaLoQueDibujaElPentagrama: "hiányzik, mit kell rajzolni: armonia staff scale D dorian",
        capoFueraDeRango: "a kapodaszter 0 és 12 közötti szám: --capo 2",
        octavasFueraDeRango: "az oktávok száma 1 és 4 közötti: --octaves 2",
        notasFueraDeRango: "a hangok száma 1 és 24 közötti: --notes 5",
        octavaFueraDeRango: "az oktáv 0 és 7 közötti szám: --octave 3",
        desdeNoValido: { desde in "„\(desde)” nem hangja és nem foka az akkordnak: --from E vagy --from 3" },
        tensionesMalEscritas: "a feszültséghangok 9, 11 vagy 13: --tensions 9,13",
        gradosMalEscritos: "a fokok 1 és 22 közötti számok: --degrees 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "ismeretlen közelítés: „\(aproximacion)” (below, above vagy enclosure)" },
        secuenciaDesconocida: { secuencia in "ismeretlen szekvencia: „\(secuencia)” (thirds, fourths, groups-of-3, groups-of-4, triads vagy sevenths)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Próbáld ki: „armonia help”.",
        ordenDesconocida: { orden in "ismeretlen parancs: „\(orden)”" },
        opcionDesconocida: { opcion in "ismeretlen opció: „\(opcion)”" },
        idiomaDesconocido: { idioma in "ismeretlen nyelv: „\(idioma)” (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru vagy hu)" },
        terminalDesconocida: { t in "ismeretlen parancsértelmező: „\(t)” (bash, zsh vagy fish)" },
        escrituraNoValida: { escritura in "érvénytelen írásmód: „\(escritura)” (palabras/words vagy compacto/compact; ascii vagy unicode, csak es és en mellett)" },
        sinSalidaJSON: { orden in "a(z) „\(orden)” parancsnak nincs JSON-kimenete" },

        // Mensaje.swift
        mensajeNotas: "hangok",
        mensajeAcordes: "akkordok",
        mensajeMicrotonos: "mikrohangok",
        mensajeEscalas: "skálák",
        mensajeHabituales: "szokásos",
        mensajeNingunaEscala: "nincs ilyen skála",
        mensajeArmadura: "előjegyzés",
        mensajeRelativa: "párhuzamos hangnem",
        mensajeHomonima: "azonos alaphangú hangnem",
        mensajeBajo: { nota in "basszus: \(nota)" },
        mensajeBajoAjeno: "a basszus nincs az akkordban",
        mensajeSinAcordes: "Nem található ismert akkord.",
        mensajeSin: { notas in "\(notas) nélkül" },
        mensajeSemitonos: { n in "\(n) félhang" },
        mensajeSinAlteraciones: "nincs előjegyzés",
        mensajeSostenidos: { n in Idioma.hungaro.contar(n, "kereszt") },
        mensajeBemoles: { n in Idioma.hungaro.contar(n, "bé") },
        mensajeACuatroVoces: "Négy szólamban (basszus, tenor, alt, szoprán):",
        mensajeSinDigitaciones: "nem található kényelmes fogás",
        mensajeDedos: { n in Idioma.hungaro.contar(n, "ujj") },
        mensajeCejilla: { traste in "barré: \(traste). bund" },
        mensajeNingunPaso: "nincs lépés",
        mensajeUnPaso: "1 lépés",
        mensajePasos: { n in "\(n) lépés" },
        mensajeTriadas: { n in Idioma.hungaro.contar(n, "hármashangzat") },
        mensajeFormaNormal: "normálforma",
        mensajeFormaPrima: "prímforma",
        mensajeVectorIntervalico: "intervallumvektor",
        mensajeVectorDeIndice: "indexvektor",
        mensajeEjesDeSimetria: "szimmetriatengelyek",
        mensajeIntervalos: "hangközök",
        mensajeDeTodosLosIntervalos: "minden hangközös",
        mensajeFormasDistintas: { n in "\(n) különböző forma" },
        mensajeHexacordos: "hexachordok",
        mensajeFormasCombinatorias: "kombinatorikus formák",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "az armonia verziója",
        quisoDecir: { x in "Erre gondoltál: „\(x)”?" },
        pruebaLaAyudaDe: { o in "Próbáld ki: „armonia help \(o)”." },
        salidaBinaria: "a kimenet bináris fájl (MIDI, PDF vagy PNG); mentsd el így: > fájl",
        escalasPorNotas: { e in "nincs ilyen nevű skála; hangok alapján így keresheted: \(e)" },
        grabarUnaPartitura: { o, e in "az „armonia \(o)” már megírja a kottát; az „engrave” PDF-be, SVG-be vagy PNG-be szedi: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Lekérdezések", "Harmónia és szólamok", "Kották és kottaszedés", "Rajzok (SVG)", "Neo-riemanni elmélet", "Bundozott hangszerek", "Terminál és súgó"],
        pieDelIndice: """
        Egy parancs súgója: armonia help <parancs> (vagy armonia <parancs> --help).
        A teljes súgó, minden parancs kapcsolóival: armonia help --all.
        Minden parancshoz: --ingles, --idioma, --textos, --escritura, --subindices, --cifras és --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Soronként egy parancs, „armonia” nélkül (help: a parancsok; exit: kilépés)." }
    )
}
