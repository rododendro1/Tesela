import Armonia

// MARK: - Un instrumento de cuerda del catálogo, escrito

/// Un instrumento de cuerda del catálogo (`Encordado.todos`) con su ficha, con los nombres de las claves del JSON.
///
///     let charango = EncordadoPresentado(.charango, en: .compacta(.espanol))
///     charango.afinacion      // ["Sol4", "Do5", "Mi5", "La4", "Mi5"]
///     charango.cuerdasReales  // 10
public struct EncordadoPresentado: Hashable, Sendable, Codable {
    /// El nombre en la notación: «charango», «Cuban tres»…
    public let nombre: String
    /// Los encordados no tienen otros nombres traducidos: siempre vacío, como en los demás catálogos sin alias.
    public let alias: [String]
    /// Las cuerdas al aire, de la de arriba a la de abajo, escritas en la notación.
    public let afinacion: [String]
    /// Cuántos órdenes tiene (las cuerdas o los pares de cuerdas que se pisan juntos).
    public let ordenes: Int
    /// Cuántas cuerdas tiene de verdad, contando las de cada orden.
    public let cuerdasReales: Int
    /// Las cuerdas de cada orden, en el orden de `afinacion`.
    public let cuerdasPorOrden: [Int]
    /// Las alturas de las cuerdas de los órdenes que van en octavas, por su número desde arriba (1 es el primero):
    /// `["3": ["Mi5", "Mi4"]]` en el charango.
    public let ordenesEnOctavas: [String: [String]]
    /// Sus trastes, por su nombre: «cromáticos», «diatónicos» o «sin trastes».
    public let trastes: String
    /// Los mismos, sin traducir: `cromaticos`, `diatonicos` o `sinTrastes` (`TrastesDeEncordado`).
    public let trastesId: String
    /// Su familia, por su nombre: «guitarras», «laúdes y mandolinas»…; `nil` si no es del catálogo.
    public let familia: String?
    /// La misma, sin traducir (`FamiliaDeEncordado`): `guitarras`, `laudes`…
    public let familiaId: String?
    /// Si una cuerda está más aguda que la siguiente (el Sol del ukelele).
    public let reentrante: Bool
    /// La tradición, por su clave (`andes`, `mundoArabe`); `nil` en los occidentales.
    public let tradicion: String?
    /// Los lugares de origen, por su nombre.
    public let lugaresDeOrigen: [String]
    /// Los estilos en que se usa, de más a menos importante, por su nombre.
    public let estilos: [String]
    /// Las citas de las obras donde se lee.
    public let referencias: [String]
    /// El año, la época y la obra que lo documenta; `nil` si no se sabe ninguno.
    public let origen: OrigenPresentado?

    public init(_ encordado: Encordado, en notacion: Notacion) {
        nombre = encordado.nombre(en: notacion)
        alias = []
        afinacion = encordado.afinacion.map { $0.nombre(en: notacion) }
        ordenes = encordado.numeroDeCuerdas
        cuerdasReales = encordado.cuerdasReales
        cuerdasPorOrden = encordado.cuerdasPorOrden
        var enOctavas: [String: [String]] = [:]
        for cuerda in encordado.afinacion.indices {
            let alturas = encordado.alturasDelOrden(cuerda)
            if Set(alturas).count > 1 { enOctavas["\(cuerda + 1)"] = alturas.map { $0.nombre(en: notacion) } }
        }
        ordenesEnOctavas = enOctavas
        trastes = encordado.trastes.nombre(en: notacion)
        trastesId = encordado.trastes.rawValue
        familia = encordado.familia?.nombre(en: notacion)
        familiaId = encordado.familia?.rawValue
        reentrante = encordado.esReentrante
        tradicion = encordado.tradicion?.rawValue
        lugaresDeOrigen = encordado.lugaresDeOrigen.map { $0.nombre(en: notacion) }
        estilos = encordado.estilos.map { $0.nombre(en: notacion) }
        referencias = encordado.referencias.map(\.cita)
        origen = OrigenPresentado(
            anio: encordado.anioDeOrigen, epoca: encordado.epocaDeOrigen, documentada: nil, en: notacion)
    }

    /// Las cuerdas en una línea: «6» si cada orden es una cuerda, «4 órdenes, 8 cuerdas» si no.
    public func cuerdas(en notacion: Notacion) -> String {
        ordenes == cuerdasReales ? "\(ordenes)" : notacion.texto { $0.ordenesYCuerdas(ordenes, cuerdasReales) }
    }

    /// La ficha, un dato por fila: la familia, la afinación, las cuerdas, los órdenes en octavas, los trastes, los
    /// estilos, los lugares y la época.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        var datos = familia.map { [DatoPresentado(nombre: notacion.texto(\.familiaDelInstrumento), valor: $0)] } ?? []
        datos += [
            DatoPresentado(nombre: notacion.texto(\.afinacion), valor: afinacion.joined(separator: " ")),
            DatoPresentado(nombre: notacion.texto(\.cuerdasDelInstrumento), valor: cuerdas(en: notacion)),
        ]
        if !ordenesEnOctavas.isEmpty {
            let ordenados = ordenesEnOctavas.keys.sorted { Int($0)! < Int($1)! }
            let valor = ordenados.map { "\($0): " + ordenesEnOctavas[$0]!.joined(separator: " ") }
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.ordenesEnOctavas), valor: valor.joined(separator: " · ")))
        }
        datos.append(DatoPresentado(nombre: notacion.texto(\.trastesDelInstrumento), valor: trastes))
        if !estilos.isEmpty {
            datos.append(DatoPresentado(nombre: notacion.texto(\.estilos), valor: estilos.joined(separator: " · ")))
        }
        return datos + datosDelLugar(lugaresDeOrigen, en: notacion) + datosDelCatalogo(en: notacion)
    }
}

// MARK: - Un ornamento del catálogo, escrito

/// Un ornamento del catálogo (`OrnamentoConNombre`), con lo que suena sobre una nota de una escala si se pide.
///
///     let grupeto = OrnamentoPresentado(.grupeto, sobre: Altura(.re, octava: 4), escala: Escala(.do), en: .compacta(.espanol))
///     grupeto.alturas   // ["Mi4", "Re4", "Do4", "Re4"]
public struct OrnamentoPresentado: Hashable, Sendable, Codable {
    /// El nombre en la notación: «grupeto», «turn»…
    public let nombre: String
    /// Los otros nombres en el idioma de la notación.
    public let alias: [String]
    /// Los pasos por grados de la escala desde la nota principal, en el orden en que suenan.
    public let pasos: [Int]
    /// Las alturas que suenan, si se ha dado una nota principal de la escala; `nil` si no.
    public let alturas: [String]?
    /// Las mismas, cada una con su figura (`Mi4:16`), si se ha dado también la duración de la nota; `nil` si no.
    public let tocado: [String]?
    /// Los estilos en que se usa, por su nombre.
    public let estilos: [String]
    /// Las citas de las obras donde se lee.
    public let referencias: [String]
    /// El año, la época y la obra que lo documenta; `nil` si no se sabe ninguno.
    public let origen: OrigenPresentado?

    /// El ornamento y, con `principal` y `escala`, lo que suena sobre esa nota
    /// (`OrnamentoConNombre.alturas(sobre:en:)`); con `duracion`, también con qué figura suena cada una
    /// (`OrnamentoConNombre.tocado(sobre:en:duracion:)`).
    public init(
        _ ornamento: OrnamentoConNombre, sobre principal: Altura? = nil, escala: Escala? = nil,
        duracion: Duracion? = nil, en notacion: Notacion
    ) {
        nombre = ornamento.nombre(en: notacion)
        alias = ornamento.alias(en: notacion)
        pasos = ornamento.pasos
        if let principal, let escala {
            alturas = ornamento.alturas(sobre: principal, en: escala)?.map { $0.nombre(en: notacion) }
        } else {
            alturas = nil
        }
        if let principal, let escala, let duracion {
            tocado = ornamento.tocado(sobre: principal, en: escala, duracion: duracion)?.map {
                Evento($0.altura, $0.duracion).texto(en: notacion)
            }
        } else {
            tocado = nil
        }
        estilos = ornamento.estilos.map { $0.nombre(en: notacion) }
        referencias = ornamento.referencias.map(\.cita)
        origen = OrigenPresentado(ornamento, en: notacion)
    }

    /// Los pasos en una línea, con signo: «+1 0 −1 0».
    public var textoDeLosPasos: String {
        pasos.map { $0 > 0 ? "+\($0)" : $0 < 0 ? "−\(-$0)" : "0" }.joined(separator: " ")
    }

    /// La ficha, un dato por fila: los pasos, lo que suena y con qué figuras (si se ha pedido), los otros nombres y la
    /// época.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [DatoPresentado(nombre: notacion.texto(\.pasosDelOrnamento), valor: textoDeLosPasos)]
        if let alturas {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.suenaElOrnamento), valor: alturas.joined(separator: " ")))
        }
        if let tocado {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.ritmoDelOrnamento), valor: tocado.joined(separator: " ")))
        }
        return datos + datosDelCatalogo(en: notacion)
    }
}
