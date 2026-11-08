// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// MARK: - Textos de Elementos
//
// Un idioma por fichero: `TextosDeElementos+Espanol.swift`, `TextosDeElementos+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Elementos en un idioma.
struct TextosDeElementos: TextosTraducidos {
    // MARK: Intervalo.swift
    let calidadJusta: String
    let calidadMayor: String
    let calidadMenor: String
    let calidadAumentada: String
    let calidadDisminuida: String
    let multiplicidadSimple: String
    let multiplicidadDoble: String
    let multiplicidadTriple: String
    let multiplicidad: Plantilla  // {1} n
    let plantillaDescendente: Plantilla  // {1} intervalo
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
    let noSePuedeLeer: Plantilla  // {1} texto
    let caracter: @Sendable (Int) -> String
    let textoVacio: String
    let caracteresSobrantes: Plantilla  // {1} resto

    // MARK: ErrorDeLectura.swift (notas)
    let notaNoReconocida: String
    let faltaLaOctava: String
    let octavaNoValida: Plantilla  // {1} resto
    let faltaElNumeroDeIntervalo: String
    let numeroDeIntervaloNoValido: Plantilla  // {1} resto
    let faltaLaCalidad: String
    let calidadNoValida: Plantilla  // {1} resto
    let unisonoDisminuido: String
    let reglaDeLasJustas: String
    let reglaDeLasMayores: String
    let intervaloInexistente: @Sendable (Int, CalidadDeIntervalo, Notacion, Traduccion) -> String
    let alteracionNoReconocida: Plantilla  // {1} signo

    // MARK: ErrorDeLectura.swift (conjuntos y series)
    let claseDeAlturaNoValida: Plantilla  // {1} texto
    let numeroDeForteDesconocido: Plantilla  // {1} texto
    let faltaElCierre: Plantilla  // {1} signo
    let serieNoDodecafonica: String
    let faltanEnLaSerie: Plantilla  // {1} clases
    let repetidasEnLaSerie: Plantilla  // {1} clases

    // MARK: ErrorDeLectura.swift (idiomas)
    let idiomaNoReconocido: Plantilla  // {1} nombre, {2} opciones

    // MARK: Gramática (Intervalo.swift, ErrorDeLectura.swift)
    /// El nombre de un intervalo con su calidad y su número: «3ª mayor», «major third».
    let nombreDeIntervalo: Plantilla  // {1} calidad, {2} ordinal
    /// La calidad del unísono, que en francés e italiano es masculino: «unisson augmenté».
    let unisonoEnMasculino: @Sendable (String) -> String
    /// Los nombres de los intervalos del unísono a la doble octava; vacío si se escriben con número.
    let ordinales: [String]
    /// El número de un intervalo en cifras: «3ª», «3a», «3.», «16e», «21st», «16-я».
    let ordinalEnCifras: @Sendable (Int) -> String
    /// Los dos puntos de un mensaje: «: », y « : » en francés.
    let dosPuntos: String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeElementos>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
