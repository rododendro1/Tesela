// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en húngaro. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let hungaro = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in nombres.map(\.conArticuloHungaro).joined(separator: " és ") + " között" },
        enLaVoz: { primera in primera.conArticuloHungaro + "ban" },
        enLosAcordes: "(akkordok: {1})",
        enElAcorde: { acorde in "(\(acorde + 1). akkord)" },
        quintasParalelas: "Párhuzamos kvintek",
        octavasParalelas: "Párhuzamos oktávok",
        quintasDirectas: "Rejtett kvintek",
        octavasDirectas: "Rejtett oktávok",
        cruceDeVoces: "Szólamkeresztezés",
        superposicion: "Szólamátfedés",
        separacionExcesiva: "Egy oktávnál nagyobb távolság",
        saltoNoMelodico: "Dallamtalan ugrás",
        fueraDeTesitura: "Hangterjedelmen kívül",
        vozBajo: "basszus",
        vozTenor: "tenor",
        vozContralto: "alt",
        vozSoprano: "szoprán",
        vozNumero: "{1}. szólam",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["átmenőhang", "váltóhang", "appoggiatura", "késleltetés", "anticipáció", "szökőhang", "orgonapont", "szabad hang"],

        // Contrapunto.swift
        enElCompas: "({1}. ütem)",
        enLosCompases: "(ütemek: {1})",
        ritmoDeLaEspecie: "A fajtától eltérő ritmus",
        comienzoImperfecto: "Kezdés tökéletes konszonancia nélkül",
        finalImperfecto: "Befejezés prím vagy oktáv nélkül",
        finalSinGradoConjunto: "A befejezést nem lépés vezeti be",
        disonanciaEnParteFuerte: "Disszonancia súlyos ütemrészen",
        disonanciaMalTratada: "Helytelenül kezelt disszonancia",
        retardoMalResuelto: "Rosszul feloldott késleltetés",
        unisono: "Prím a darab közepén",
        saltoSinCompensar: "Kiegyenlítetlen ugrás",
        notaRepetida: "Ismételt hang",
        especieConElContrapuntoEncima: "{1}. fajta, ellenpont a cantus firmus fölött",
        especieConElContrapuntoDebajo: "{1}. fajta, ellenpont a cantus firmus alatt",
        contrapuntoAVariasVoces: "{1} szólamú ellenpont",
        vozDelContrapunto: "{1}. szólam",
        sinFaltas: "Nincs hiba.",
        realizacionSinNotas: "Nincsenek leírandó akkordok vagy hangok.",
        realizacionSopranoDeOtraLongitud: "A szopránnak akkordonként egy hangja kell legyen (hangok: {1}; akkordok: {2}).",
        realizacionNotaAjena: "A szoprán hangja nem tartozik a(z) {1}. akkordhoz.",
        realizacionSopranoFueraDeTesitura: "A(z) {1}. akkord szopránhangja kívül esik a hangterjedelmén.",
        realizacionDemasiadasNotas: "A(z) {1}. akkordnak négynél több elhagyhatatlan hangja van.",
        realizacionSinDisposicion: "A(z) {1}. akkord nem írható le hibátlanul négy szólamban.",
        realizacionNotaSinAcorde: "A hangnem egyik akkordja sem tartalmazza a dallam {1}. hangját.",
        realizacionSinEnlaceSinFaltas: "Az akkordok nem köthetők össze hibátlanul négy szólamban.",
        realizacionOtraMelodia: "A szoprán nem a harmonizálás dallama."
    )
}
