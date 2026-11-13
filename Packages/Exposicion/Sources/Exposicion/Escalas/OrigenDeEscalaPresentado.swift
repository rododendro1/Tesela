import Armonia

// MARK: - El origen de una escala

/// De cuándo y de dónde es una escala, escrito: su año y su época de origen, las épocas en que se usa, el período de
/// su tradición, sus lugares de origen y de uso, sus estilos (con sus corrientes) y sus escuelas. Lo mismo para el
/// texto de `armonia escala`, su `--json`, la hoja de estudio y la pestaña de escalas. No se calcula aquí: todo sale
/// de `TipoDeEscala` (`epocaDeOrigen`, `periodo`, `lugaresDeOrigen`, `estilos`, `escuelas`…).
///
///     let origen = OrigenDeEscalaPresentado(.menorHungara, en: .compacta(.espanol))
///     origen?.epoca      // "Romanticismo"
///     origen?.anio       // 1859
public struct OrigenDeEscalaPresentado: Hashable, Sendable, Codable {
    /// El año en que aparece (`TipoDeEscala.anioDeOrigen`), si se sabe. Los de antes de Cristo son negativos.
    public let anio: Int?
    /// La época de origen y las de uso, por su nombre.
    public let epoca: String?
    public let epocasDeUso: [String]
    /// El período de su tradición en que aparece y en los que se sigue usando, por su nombre.
    public let periodo: String?
    public let periodosDeUso: [String]
    /// Los nombres de sus lugares de origen y de uso.
    public let lugaresDeOrigen: [String]
    public let lugaresDeUso: [String]
    /// Sus estilos, de más a menos importante, cada uno con sus corrientes entre paréntesis: «jazz (modal)».
    public let estilos: [String]
    /// Sus escuelas: «Carnática».
    public let escuelas: [String]

    /// El origen de la escala, o `nil` si no se sabe nada de él (las propias).
    public init?(_ tipo: TipoDeEscala, en notacion: Notacion) {
        anio = tipo.anioDeOrigen
        epoca = tipo.epocaDeOrigen?.nombre(en: notacion)
        epocasDeUso = tipo.epocasDeUso.map { $0.nombre(en: notacion) }
        periodo = tipo.periodo?.nombre(en: notacion)
        periodosDeUso = tipo.periodosDeUso.map { $0.nombre(en: notacion) }
        lugaresDeOrigen = tipo.lugaresDeOrigen.map { $0.nombre(en: notacion) }
        lugaresDeUso = tipo.lugaresDeUso.map { $0.nombre(en: notacion) }
        let corrientes = tipo.corrientes
        estilos = tipo.estilos.map { estilo in
            let suyas = corrientes.filter { $0.estilo == estilo }.map { $0.nombre(en: notacion) }
            return estilo.nombre(en: notacion) + (suyas.isEmpty ? "" : " (" + suyas.joined(separator: ", ") + ")")
        }
        escuelas = tipo.escuelas.map { $0.nombre(en: notacion) }
        let listas = [epocasDeUso, periodosDeUso, lugaresDeOrigen, lugaresDeUso, estilos, escuelas]
        if anio == nil, epoca == nil, periodo == nil, listas.allSatisfy(\.isEmpty) { return nil }
    }

    /// Un dato por fila, solo los que tiene: la época (con el año, si se sabe), las épocas de uso, el período, los de
    /// uso, los lugares, los estilos y las escuelas.
    ///
    ///     OrigenDeEscalaPresentado(.menorHungara, en: notacion)?.datos(en: notacion).first
    ///     // Época: Romanticismo (1859)
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        var datos: [DatoPresentado] = []
        func lista(_ nombre: (TextosDeApps) -> String, _ valores: [String]) {
            if !valores.isEmpty {
                datos.append(DatoPresentado(nombre: notacion.texto(nombre), valor: valores.joined(separator: " · ")))
            }
        }
        if let epoca {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.epocaDeOrigen), valor: epoca + (anio.map { " (\($0))" } ?? "")))
        } else if let anio {
            datos.append(DatoPresentado(nombre: notacion.texto(\.epocaDeOrigen), valor: "\(anio)"))
        }
        lista(\.epocasDeUso, epocasDeUso)
        if let periodo { datos.append(DatoPresentado(nombre: notacion.texto(\.periodo), valor: periodo)) }
        lista(\.periodosDeUso, periodosDeUso)
        lista(\.lugaresDeOrigen, lugaresDeOrigen)
        lista(\.lugaresDeUso, lugaresDeUso)
        lista(\.estilos, estilos)
        lista(\.escuelas, escuelas)
        return datos
    }
}
