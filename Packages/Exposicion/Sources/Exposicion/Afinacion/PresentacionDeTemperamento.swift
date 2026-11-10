import Armonia

// MARK: - Un temperamento del catálogo, escrito

/// Lo que se aparta de una razón justa el paso más cercano de un temperamento, para el JSON.
public struct AproximacionJustaPresentada: Hashable, Sendable, Codable {
    /// «3/2».
    public let razon: String
    public let cents: Double
    public let error: Double
}

/// Un temperamento del catálogo y lo que se mide de él (`EstadisticasDeTemperamento`), con los nombres de las claves
/// del JSON.
///
///     let meso = TemperamentoPresentado(.mesotonicoCuartoDeComa, en: .compacta(.espanol))
///     meso.pasosPorOctava   // 12
///     meso.autor            // "Pietro Aron"
public struct TemperamentoPresentado: Hashable, Sendable, Codable {
    /// El nombre en la notación: «mesotónico de 1/4 de coma», «quarter-comma meantone»…
    public let nombre: String
    public let familia: String
    public let autor: String?
    public let anio: Int?
    public let pasosPorOctava: Int
    /// Los cents de cada paso desde el primero.
    public let pasos: [Double]
    /// En los regulares y en los de divisiones iguales.
    public let quinta: Double?
    public let uniforme: Bool
    public let pasoMenor: Double
    public let pasoMayor: Double
    public let aproximaciones: [AproximacionJustaPresentada]
    /// En los de doce notas.
    public let quintas: [Double]?
    public let tercerasMayores: [Double]?
    public let desviacionesDelIgual: [Double]?
    public let quintaDelLobo: Double?
    public let terceraMasPura: Double?
    public let terceraMasLejana: Double?

    public init(_ temperamento: TemperamentoConNombre, en notacion: Notacion) {
        let estadisticas = temperamento.estadisticas
        nombre = temperamento.nombre(en: notacion)
        familia = temperamento.familia.nombre(en: notacion)
        autor = temperamento.autor
        anio = temperamento.anio
        pasosPorOctava = estadisticas.pasosPorOctava
        pasos = temperamento.pasos
        quinta = temperamento.quinta
        uniforme = estadisticas.uniforme
        pasoMenor = estadisticas.pasoMenor
        pasoMayor = estadisticas.pasoMayor
        aproximaciones = estadisticas.aproximaciones.map {
            AproximacionJustaPresentada(
                razon: "\(Int($0.razon.numerador))/\(Int($0.razon.denominador))", cents: $0.cents, error: $0.error)
        }
        quintas = estadisticas.quintas
        tercerasMayores = estadisticas.tercerasMayores
        desviacionesDelIgual = estadisticas.desviacionesDelIgual
        quintaDelLobo = estadisticas.quintaDelLobo
        terceraMasPura = estadisticas.terceraMasPura
        terceraMasLejana = estadisticas.terceraMasLejana
    }

    /// Unos cents con tres decimales como mucho: «696.578».
    static func cents(_ valor: Double) -> String { PresentacionDeEstadisticasDeAcorde.decimal(valor) }

    /// Unos cents con su signo: «+13.686», «−1.955», «0».
    static func conSigno(_ valor: Double) -> String {
        let texto = cents(abs(valor))
        if texto == "0" { return texto }
        return (valor < 0 ? "−" : "+") + texto
    }

    /// La ficha, un dato por fila: la familia, el autor, el año, los pasos por octava y la quinta, los que tenga.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [DatoPresentado(nombre: notacion.texto(\.familiaDeTemperamento), valor: familia)]
        if let autor { datos.append(DatoPresentado(nombre: notacion.texto(\.autorDelTemperamento), valor: autor)) }
        if let anio { datos.append(DatoPresentado(nombre: notacion.texto(\.anioDelTemperamento), valor: "\(anio)")) }
        datos.append(DatoPresentado(nombre: notacion.texto(\.pasosPorOctava), valor: "\(pasosPorOctava)"))
        if let quinta {
            datos.append(DatoPresentado(nombre: notacion.texto(\.quintaDelTemperamento), valor: Self.cents(quinta)))
        }
        return datos
    }

    /// Lo que se mide, un dato por fila: el tamaño de los pasos, lo que se apartan de las razones justas y, en los de
    /// doce notas, la quinta del lobo, las terceras y las desviaciones del igual.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        let pasosMedidos =
            uniforme
            ? Self.cents(pasoMenor) + " (" + notacion.texto(\.pasosIguales) + ")"
            : Self.cents(pasoMenor) + " · " + Self.cents(pasoMayor)
        var datos = [
            DatoPresentado(nombre: notacion.texto(\.pasoMenorYMayor), valor: pasosMedidos),
            DatoPresentado(
                nombre: notacion.texto(\.aproximacionesJustas),
                valor: aproximaciones.map { $0.razon + ": " + Self.conSigno($0.error) }.joined(separator: " · ")),
        ]
        if let quintaDelLobo {
            datos.append(DatoPresentado(nombre: notacion.texto(\.quintaDelLobo), valor: Self.cents(quintaDelLobo)))
        }
        if let terceraMasPura, let terceraMasLejana {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.terceraMasPuraYMasLejana),
                    valor: Self.cents(terceraMasPura) + " · " + Self.cents(terceraMasLejana)))
        }
        if let desviacionesDelIgual {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.desviacionesDelIgual),
                    valor: desviacionesDelIgual.map(Self.conSigno).joined(separator: " ")))
        }
        return datos
    }
}
