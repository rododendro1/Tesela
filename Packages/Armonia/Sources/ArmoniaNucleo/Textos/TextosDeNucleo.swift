// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// MARK: - Textos de ArmoniaNucleo
//
// Un idioma por fichero: `TextosDeNucleo+Espanol.swift`, `TextosDeNucleo+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los quince y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaNucleo en un idioma.
struct TextosDeNucleo: TextosTraducidos {
    // MARK: Intervalo.swift
    let calidadJusta: String
    let calidadMayor: String
    let calidadMenor: String
    let calidadAumentada: String
    let calidadDisminuida: String
    let multiplicidadSimple: String
    let multiplicidadDoble: String
    let multiplicidadTriple: String
    let multiplicidad: @Sendable (Int) -> String
    let plantillaDescendente: String
    let consonanciaPerfecta: String
    let consonanciaImperfecta: String
    let disonancia: String

    // MARK: Nota.swift
    let palabraNatural: String
    let palabraSostenido: String
    let palabraBemol: String
    let multiplicadores: [String]
    let palabraSostenidos: String
    let palabraBemoles: String

    // MARK: ErrorDeLectura.swift (generales)
    let valorNoValido: String
    let noSePuedeLeer: @Sendable (String) -> String
    let caracter: @Sendable (Int) -> String
    let textoVacio: String
    let caracteresSobrantes: @Sendable (String) -> String

    // MARK: ErrorDeLectura.swift (notas)
    let notaNoReconocida: String
    let faltaLaOctava: String
    let octavaNoValida: @Sendable (String) -> String
    let faltaElNumeroDeIntervalo: String
    let numeroDeIntervaloNoValido: @Sendable (String) -> String
    let faltaLaCalidad: String
    let calidadNoValida: @Sendable (String) -> String
    let unisonoDisminuido: String
    let reglaDeLasJustas: String
    let reglaDeLasMayores: String
    let intervaloInexistente: @Sendable (Int, CalidadDeIntervalo, Notacion, Traduccion) -> String
    let alteracionNoReconocida: @Sendable (String) -> String

    // MARK: ErrorDeLectura.swift (conjuntos y series)
    let claseDeAlturaNoValida: @Sendable (String) -> String
    let numeroDeForteDesconocido: @Sendable (String) -> String
    let faltaElCierre: @Sendable (String) -> String
    let serieNoDodecafonica: String
    let faltanEnLaSerie: @Sendable (String) -> String
    let repetidasEnLaSerie: @Sendable (String) -> String

    // MARK: ErrorDeLectura.swift (idiomas)
    let idiomaNoReconocido: @Sendable (_ nombre: String, _ opciones: String) -> String

    // MARK: Gramática (Intervalo.swift, ErrorDeLectura.swift)
    /// El nombre de un intervalo con su calidad y su número: «3ª mayor», «major third».
    let nombreDeIntervalo: @Sendable (_ calidad: String, _ ordinal: String) -> String
    /// La calidad del unísono, que en francés, occitano e italiano es masculino: «unisson augmenté».
    let unisonoEnMasculino: @Sendable (String) -> String
    /// Los nombres de los intervalos del unísono a la doble octava; vacío si se escriben con número.
    let ordinales: [String]
    /// El número de un intervalo en cifras: «3ª», «3a», «3.», «16e», «21st», «16-я».
    let ordinalEnCifras: @Sendable (Int) -> String
    /// Los dos puntos de un mensaje: «: », y « : » en francés.
    let dosPuntos: String

    /// Los textos en los quince idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeNucleo>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro)
}
