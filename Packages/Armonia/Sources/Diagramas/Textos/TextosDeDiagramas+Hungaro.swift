// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// Los textos de Diagramas en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeDiagramas.swift`.

extension TextosDeDiagramas {
    static let hungaro = TextosDeDiagramas(
        // CorrespondenciaDeColores.swift
        circuloDeQuintas: "kvintkör",

        // DibujoSVG.swift
        conjunto: "Halmaz ",
        cicloDesde: "{1}, kezdete: {2}",
        primeraClase: "első hangosztály",
        primeraNota: "első hang",
        leyendaNota: "hang",
        leyendaClaseDeAltura: "hangosztály (minden példánya)",
        leyendaAltura: "hangmagasság (minden billentyű)",
        leyendaIntervalos: "kvint vagy terc a hangok között",
        leyendaContorno: "az alakzat körvonala",
        leyendaTriadaMayor: "dúr hármashangzat",
        leyendaTriadaMenor: "moll hármashangzat",
        leyendaPasoDelRecorrido: "a menet lépése (P, L, R)",
        leyendaFundamentalDelPrimerAcorde: "az első akkord alaphangja",

        // TecladoIsomorfico.swift
        tablaArmonica: "Harmonikus tábla",
        wickiHaydenEspejo: "Wicki–Hayden (tükrözött)",
        wickiHaydenPlano: "Wicki–Hayden (lapos tetejű)",
        acordeonC: "C-rendszerű harmonika",
        acordeonB: "B-rendszerű harmonika",
        // TecladoCuadrado.swift
        cuadriculaEnCuartas: "Kvartrács",
        cuadriculaEnTercerasMayores: "Nagytercrács",
        cuadriculaEnQuintas: "Kvintrács",
        wickiHaydenCuadrado: "Wicki–Hayden (rács)",
        cuadriculaDeTonosEnteros: "Egészhangú rács",
        tonnetzDeEuler: "Euler-féle Tonnetz",
        cuadriculaEnTercerasMenores: "Kistercrács",
        cuadriculaEnTritonos: "Tritónuszrács",
        cuadriculaEnOctavas: "Oktávrács",
        cuadriculaSecuencial: "Sorfolytonos rács",
        // FormatoUIL.swift
        uilNoValido: "Érvénytelen UIL: „{1}”. A várt alak L,G,D;R<fok>[M], például 2,7,5;R30M.",
        intervalosIncoherentes: "Ellentmondó hangközök: {1},{2},{3}. Teljesülnie kell: 0 < L ≤ D és G = L + D.",
        giroNoValido: "A {1}°-os elforgatás nem többszöröse a 30°-nak.",
        afinacionNoSoportada: "Csak 12 hangú billentyűzet rajzolható, {1} hangú nem.",
        cizallaNoSoportada: "Az S{1} nyírás nem támogatott."
    )
}
