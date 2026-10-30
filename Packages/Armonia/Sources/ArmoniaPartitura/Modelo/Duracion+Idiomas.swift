import ArmoniaNucleo
import ArmoniaTeoria
// Nombres de las figuras y de las duraciones en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - Figura

extension Figura {
    public var nombre: String { nombre(en: .espanolUnicode) }

    /// En español, "negra"; en inglés, el nombre estadounidense ("quarter note").
    public func nombre(en notacion: Notacion) -> String { Figura.nombres[rawValue + 1].en(notacion) }

    private static let nombres: [Traduccion] = [
        TextosDePartitura.traducidos.map(\.cuadrada),
        TextosDePartitura.traducidos.map(\.redonda),
        TextosDePartitura.traducidos.map(\.blanca),
        TextosDePartitura.traducidos.map(\.negra),
        TextosDePartitura.traducidos.map(\.corchea),
        TextosDePartitura.traducidos.map(\.semicorchea),
        TextosDePartitura.traducidos.map(\.fusa),
        TextosDePartitura.traducidos.map(\.semifusa),
        TextosDePartitura.traducidos.map(\.garrapatea),
    ]
}

// MARK: - Duracion

extension Duracion {
    /// "negra", "corchea con puntillo", "blanca con doble puntillo"; si no es una figura,
    /// la fracción: "5/8 de redonda". La duración nula es "cero".
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String {
        if esCero { return TextosDePartitura.traducidos.map(\.cero).en(notacion) }
        guard let escritura = figuraYPuntillos else {
            let fraccion = "\(numerador)/\(denominador)"
            return TextosDePartitura.traducidos.map { $0.fraccionDeRedonda(fraccion) }.en(notacion)
        }
        let figura = escritura.figura.nombre(en: notacion)
        let puntillos = escritura.puntillos
        guard puntillos > 0 else { return figura }
        return Duracion.conPuntillos.en(notacion)[puntillos - 1].rellenada(con: figura)
    }
}

extension Duracion {
    /// La figura con uno, dos, tres o cuatro puntillos, en el sitio de `_`.
    private static let conPuntillos = TextosDePartitura.traducidos.map(\.conPuntillos)
}
