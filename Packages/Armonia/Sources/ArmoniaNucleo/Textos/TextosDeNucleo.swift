// MARK: - Textos de ArmoniaNucleo
//
// Un idioma por fichero: `TextosDeNucleo+Espanol.swift`, `TextosDeNucleo+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaNucleo en un idioma.
struct TextosDeNucleo: Sendable {
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

    // MARK: ErrorDeLectura.swift (acordes)
    let simboloNoReconocido: @Sendable (String) -> String
    let tensionNoValida: @Sendable (String) -> String
    let numeroDeAcordeNoValido: @Sendable (Int) -> String
    let numeroRepetido: @Sendable (Int) -> String
    let disminuidoYSemidisminuido: String
    let quintaConCalidad: String
    let fundamentalNoOmitible: String
    let gradoNoOmitible: @Sendable (Int) -> String
    let faltaLaFundamental: String
    let intervaloSinPapel: @Sendable (Intervalo, Notacion) -> String
    let terceraMayorYMenor: String
    let variasSeptimas: String
    let septimaDisminuidaFueraDelDisminuido: String
    let noEsPorTerceras: String
    let bajoNoValido: @Sendable (String) -> String
    let idiomasMezclados: @Sendable (String) -> String

    // MARK: ErrorDeLectura.swift (escalas)
    let modoNoReconocido: @Sendable (String) -> String
    let faltaElTipoDeEscala: String
    let tipoDeEscalaNoReconocido: @Sendable (String) -> String

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

    // MARK: ErrorDeLectura.swift (partitura)
    let duracionNoValida: @Sendable (String) -> String
    let compasNoValido: @Sendable (String) -> String
    let vocesDistintas: String
    let contrapuntoDeOtraDuracion: @Sendable (Int) -> String

    /// Los textos en los catorce idiomas: `traducidos.map(\.campo)` es la `Traduccion` de un campo.
    static let traducidos = Traducido<TextosDeNucleo>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
