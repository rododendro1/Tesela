import ArmoniaNucleo
import ArmoniaTeoria
// Los textos del contrapunto de especies en los catorce idiomas de los textos (`Traduccion`).

extension FaltaDeContrapunto {
    /// "Quintas paralelas (compases 3 → 4)", "Parallel fifths (bars 3 → 4)". Los compases se cuentan desde 1.
    public func descripcion(en notacion: Notacion) -> String {
        let lugar: Traduccion
        if compases.count == 1 {
            let n = compases.lowerBound + 1
            lugar = TextosDePartitura.traducidos.map { $0.enElCompas(n) }
        } else {
            let pasos = "\(compases.lowerBound + 1) → \(compases.upperBound + 1)"
            lugar = TextosDePartitura.traducidos.map { $0.enLosCompases(pasos) }
        }
        return tipo.nombre(en: notacion) + " " + lugar.en(notacion)
    }
}

extension FaltaDeContrapunto.Tipo: Nombrable, CustomStringConvertible {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .quintasParalelas: return FaltaDeConduccion.Tipo.quintasParalelas.nombre(en: notacion)
        case .octavasParalelas: return FaltaDeConduccion.Tipo.octavasParalelas.nombre(en: notacion)
        case .quintasDirectas: return FaltaDeConduccion.Tipo.quintasDirectas.nombre(en: notacion)
        case .octavasDirectas: return FaltaDeConduccion.Tipo.octavasDirectas.nombre(en: notacion)
        case .cruceDeVoces: return FaltaDeConduccion.Tipo.cruceDeVoces.nombre(en: notacion)
        case .saltoNoMelodico: return FaltaDeConduccion.Tipo.saltoNoMelodico.nombre(en: notacion)
        case .ritmoDeLaEspecie:
            traduccion = TextosDePartitura.traducidos.map(\.ritmoDeLaEspecie)
        case .comienzoImperfecto:
            traduccion = TextosDePartitura.traducidos.map(\.comienzoImperfecto)
        case .finalImperfecto:
            traduccion = TextosDePartitura.traducidos.map(\.finalImperfecto)
        case .finalSinGradoConjunto:
            traduccion = TextosDePartitura.traducidos.map(\.finalSinGradoConjunto)
        case .disonanciaEnParteFuerte:
            traduccion = TextosDePartitura.traducidos.map(\.disonanciaEnParteFuerte)
        case .disonanciaMalTratada:
            traduccion = TextosDePartitura.traducidos.map(\.disonanciaMalTratada)
        case .retardoMalResuelto:
            traduccion = TextosDePartitura.traducidos.map(\.retardoMalResuelto)
        case .unisono:
            traduccion = TextosDePartitura.traducidos.map(\.unisono)
        case .saltoSinCompensar:
            traduccion = TextosDePartitura.traducidos.map(\.saltoSinCompensar)
        case .notaRepetida:
            traduccion = TextosDePartitura.traducidos.map(\.notaRepetida)
        }
        return traduccion.en(notacion)
    }

    public var description: String { nombre }
}

extension Contrapunto {
    /// La especie y dónde va el contrapunto, y una falta por línea (o «Sin faltas.»):
    ///
    ///     Especie 1, con el contrapunto encima del cantus firmus
    ///     Quintas paralelas (compases 1 → 2)
    public func informe(en notacion: Notacion = .espanolUnicode) -> String {
        let n = especie.rawValue
        let cabecera = contrapuntoArriba
            ? TextosDePartitura.traducidos.map { $0.especieConElContrapuntoEncima(n) }
            : TextosDePartitura.traducidos.map { $0.especieConElContrapuntoDebajo(n) }
        let faltas = self.faltas
        let lineas = faltas.isEmpty ? [TextosDePartitura.traducidos.map(\.sinFaltas).en(notacion)] : faltas.map { $0.descripcion(en: notacion) }
        return ([cabecera.en(notacion)] + lineas).joined(separator: "\n")
    }
}
