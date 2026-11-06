import ArmoniaNucleo

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension TipoDeEscala {
    /// El nombre de antes de `occidentales`: no son todas las escalas, sino las occidentales (todas están en
    /// `catalogo`).
    @available(*, deprecated, renamed: "occidentales")
    public static var todos: [TipoDeEscala] { occidentales }

    /// El nombre de antes de `occidentales(uso:)`.
    @available(*, deprecated, renamed: "occidentales(uso:)")
    public static func todos(uso: UsoDeEscala) -> [TipoDeEscala] { occidentales(uso: uso) }
}

extension Acorde {
    /// El nombre de antes de `cambiarInversion(_:)`, que se confundía con la inversión en espejo de las melodías y los
    /// conjuntos de clases de altura.
    @available(*, deprecated, renamed: "cambiarInversion(_:)")
    public func invertir(_ inversion: Int) -> Acorde { cambiarInversion(inversion) }
}

extension EscalaVecina {
    /// El nombre de antes de `desde`.
    @available(*, deprecated, renamed: "desde")
    public var de: Nota { desde }
    /// El nombre de antes de `hasta`.
    @available(*, deprecated, renamed: "hasta")
    public var a: Nota { hasta }

    /// El inicializador de antes, con `de` y `a` en lugar de `desde` y `hasta`.
    @available(*, deprecated, renamed: "init(escala:desde:hasta:)")
    public init(escala: Escala, de: Nota, a: Nota) { self.init(escala: escala, desde: de, hasta: a) }
}

extension MapaDeBrillo.Enlace {
    /// El nombre de antes de `desde`.
    @available(*, deprecated, renamed: "desde")
    public var de: Nota { desde }
    /// El nombre de antes de `hasta`.
    @available(*, deprecated, renamed: "hasta")
    public var a: Nota { hasta }
}

extension Acorde {
    /// La forma de antes de `candidatos(notas:)`, sin etiqueta: ahora las tres consultas (acordes, escalas y
    /// tonalidades) se escriben igual, con `notas:`, `alturas:`, `clasesDeAltura:` o `midi:`.
    @available(*, deprecated, renamed: "candidatos(notas:)")
    public static func candidatos(_ notas: [Nota]) -> [Candidato<Acorde>] { candidatos(notas: notas) }

    /// La forma de antes de `identificar(notas:)`.
    @available(*, deprecated, renamed: "identificar(notas:)")
    public static func identificar(_ notas: [Nota]) -> [Acorde] { identificar(notas: notas) }

    /// La forma de antes de `candidatos(alturas:)`.
    @available(*, deprecated, renamed: "candidatos(alturas:)")
    public static func candidatos(_ alturas: [Altura]) -> [Candidato<Acorde>] { candidatos(alturas: alturas) }

    /// La forma de antes de `identificar(alturas:)`.
    @available(*, deprecated, renamed: "identificar(alturas:)")
    public static func identificar(_ alturas: [Altura]) -> [Acorde] { identificar(alturas: alturas) }
}

extension Escala {
    /// La forma de antes de `candidatos(notas:tipos:)`, sin etiqueta.
    @available(*, deprecated, renamed: "candidatos(notas:tipos:)")
    public static func candidatos(
        _ notas: [Nota], tipos: [TipoDeEscala] = TipoDeEscala.occidentales
    ) -> [Candidato<Escala>] { candidatos(notas: notas, tipos: tipos) }

    /// La forma de antes de `identificar(notas:tipos:)`.
    @available(*, deprecated, renamed: "identificar(notas:tipos:)")
    public static func identificar(_ notas: [Nota], tipos: [TipoDeEscala] = TipoDeEscala.occidentales) -> [Escala] {
        identificar(notas: notas, tipos: tipos)
    }
}

extension TipoDeEscala {
    /// El nombre de antes de `modo(grado:)`: el modo que empieza en ese grado.
    @available(*, deprecated, renamed: "modo(grado:)")
    public func rotacion(_ grado: Int) -> TipoDeEscala { modo(grado: grado) }
}

extension Escala {
    /// El nombre de antes de `modo(grado:)`: `Escala(.do).modo(grado: 2)` es Re dórico.
    @available(*, deprecated, renamed: "modo(grado:)")
    public func rotacion(_ grado: Int) -> Escala { modo(grado: grado) }
}

extension NotaMicrotonal {
    /// La forma de antes, con la notación española por omisión: ahora se da siempre, como en el resto de la API.
    @available(*, deprecated, message: "usa nombre(en: .espanolCompacto)")
    public func nombre() -> String { nombre(en: .espanolCompacto) }
}
