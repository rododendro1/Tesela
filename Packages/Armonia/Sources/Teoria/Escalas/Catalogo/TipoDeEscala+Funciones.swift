import Elementos

// MARK: - Las notas con función de cada escala
//
// El vādī y el saṃvādī de los rāgas indostánicos, y el qarār y el ghammāz de los maqāmāt y los makamlar.
//
// Los de los rāgas son los de la Wikipedia en inglés, en el cuadro o en el texto del artículo de cada uno (noviembre de
// 2026), y solo donde los dos no se contradicen: faltan Ahir Bhairav y Naṭ Bhairav, que dan dos parejas distintas, y
// Bhairavī, que da «Ma/Pa». Mārvā lleva la del texto (re y Dha), aunque recuerda que Patwardhan prefiere Dha y Ga. Los
// que no tienen artículo, o no la dan (Bhūpālī, Śivarañjanī, Lalit, Madhuvantī…), van sin ella. Los janya carnáticos
// no tienen vādī en su teoría. Se escriben en la declaración de cada rāga (`vadi: .terceraMayor, samvadi:
// .septimaMayor`), en TipoDeEscala+India+Indostanica.swift.
//
// El ghammāz no se escribe: es la nota en que empieza el segundo jins o çeşni de la escala (`ajnas`), como lo definen
// Maqam World y la TDV İslâm Ansiklopedisi, y el qarār es la tónica.

/// Una nota de una escala con el papel que hace en ella: el vādī de Yaman es su Ga (la 3ª mayor) y el ghammāz de
/// Bayātī, su 4ª.
public struct NotaConFuncion: Hashable, Sendable {
    /// Lo que hace la nota: `.vadi`, `.samvadi`, `.nyasa`, `.qarar`, `.ghammaz`…
    public let funcion: FuncionDeNota
    /// Lo que la separa de la tónica.
    public let intervalo: Intervalo
    /// De dónde sale; `nil` si es de la Wikipedia en inglés, que no es una referencia del catálogo.
    public let referencia: Referencia?

    /// Una nota a `intervalo` de la tónica que hace `funcion`.
    public init(_ funcion: FuncionDeNota, _ intervalo: Intervalo, referencia: Referencia? = nil) {
        self.funcion = funcion
        self.intervalo = intervalo
        self.referencia = referencia
    }
}

extension TipoDeEscala {
    /// Las notas de la escala con nombre propio por su función, de la tónica hacia arriba: el vādī y el saṃvādī de un
    /// rāga indostánico, el qarār y el ghammāz de un maqām o un makam. Son del catálogo, como `madre`: no cuentan para
    /// `==` ni van en el JSON. Vacía en las demás escalas.
    ///
    ///     TipoDeEscala.yaman.funciones.map(\.funcion.nombre)   // ["vādī", "saṃvādī"]
    ///     TipoDeEscala.yaman.funciones.map(\.intervalo)        // [.terceraMayor, .septimaMayor]
    public var funciones: [NotaConFuncion] {
        let datos = datosDelCatalogo
        if let vadi = datos.vadi, let samvadi = datos.samvadi {
            return [NotaConFuncion(.vadi, vadi), NotaConFuncion(.samvadi, samvadi)]
        }
        let fragmentos = ajnas
        guard fragmentos.count >= 2, let fuente = fuenteDeLosAjnas else { return [] }
        let intervalos = self.intervalos
        guard intervalos.indices.contains(fragmentos[1].grado - 1) else { return [] }
        return [
            NotaConFuncion(.qarar, .unisono, referencia: fuente),
            NotaConFuncion(.ghammaz, intervalos[fragmentos[1].grado - 1], referencia: fuente),
        ]
    }

    /// La nota que hace `funcion` en la escala, desde la tónica; `nil` si no la tiene.
    ///
    ///     TipoDeEscala.bayati.intervalo(de: .ghammaz)   // .cuartaJusta
    public func intervalo(de funcion: FuncionDeNota) -> Intervalo? {
        funciones.first { $0.funcion == funcion }?.intervalo
    }

    /// Lo que hace un intervalo de la escala, si hace algo con nombre: el Ga de Yaman es su vādī.
    public func funciones(de intervalo: Intervalo) -> [FuncionDeNota] {
        funciones.filter { $0.intervalo == intervalo }.map(\.funcion)
    }
}
