import Elementos

// MARK: - Ficha de un elemento del catálogo
//
// Lo que comparten los acordes, las progresiones, los ritmos, los temperamentos, las notas y las funciones con nombre
// además de su nombre: sus estilos, sus referencias, la obra que los documenta y su año, y de ahí sus épocas. Las
// escalas tienen la suya, más grande (`DatosDeEscala`).

/// Lo que el catálogo sabe de un elemento además de su nombre: un acorde, una progresión, un ritmo, un temperamento,
/// una nota o una función. Se escribe en su declaración:
///
///     public static let sextaAumentadaAlemana = AcordeConNombre(
///         nombre: "sexta aumentada alemana", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaAumentada],
///         estilos: [.clasica])
package struct DatosDelCatalogo: Sendable {
    /// En qué estilos se usa, de más a menos importante: el primero es su uso principal.
    package let estilos: [Estilo]
    /// Dónde se lee, con la obra que lo documenta (`documentada`) la primera.
    package let referencias: [Referencia]
    /// La obra más antigua que lo da, con su año: la partitura de «Tristan und Isolde» (1859) en el acorde de
    /// Tristán. De ahí sale su época de origen.
    package let documentada: Referencia?
    /// El año en que aparece, si no lo da `documentada`: el de Werckmeister III (1691), el del La 440 (1939).
    package let anio: Int?
    /// La tradición de la que es, si no es de la occidental de los estilos: la India en los tāla, el mundo árabe en
    /// los iqāʿāt, Turquía en las 53 comas.
    package let tradicion: Tradicion?
    /// De dónde viene, si se sabe más que su tradición: Andalucía en la soleá, Alemania en Werckmeister III.
    package let lugares: [Lugar]

    package init(
        estilos: [Estilo] = [], referencias: [Referencia] = [], documentada: Referencia? = nil, anio: Int? = nil,
        tradicion: Tradicion? = nil, lugares: [Lugar] = []
    ) {
        self.tradicion = tradicion
        self.lugares = lugares.sorted { $0.orden < $1.orden }
        self.estilos = Estilo.sinRepetir(estilos)
        self.referencias = Referencia.unicas([documentada].compactMap { $0 } + referencias)
        self.documentada = documentada
        self.anio = anio
    }
}

extension DatosDelCatalogo {
    /// El año de la obra que lo documenta, si la tiene, o el que se da.
    var anioDeOrigen: Int? { documentada?.anio ?? anio }

    /// La de su año, o si no la más antigua de las de uso de sus estilos; `nil` si ninguna da nada.
    var epocaDeOrigen: Epoca? {
        if let anio = anioDeOrigen { return Epoca(anio: anio) }
        return estilos.flatMap(\.epocasDeUso).min()
    }

    /// Las de uso de sus estilos, en orden, sin la de origen ni las anteriores a ella.
    var epocasDeUso: [Epoca] {
        let origen = epocaDeOrigen
        return Epoca.allCases.filter { epoca in
            epoca != origen && (origen.map { $0 < epoca } ?? true)
                && estilos.contains { $0.epocasDeUso.contains(epoca) }
        }
    }

    /// La de origen y las de uso, en orden.
    var epocas: [Epoca] { ([epocaDeOrigen].compactMap { $0 } + epocasDeUso).sorted() }
}

// MARK: De dónde viene

extension DatosDelCatalogo {
    /// Los lugares de donde viene, los más concretos que se saben, como en las escalas:
    ///
    /// 1. los suyos (la soleá, Andalucía; Werckmeister III, Alemania);
    /// 2. el lugar histórico de su tradición (Bizancio, en los 72 moria);
    /// 3. las zonas de su tradición (los iqāʿāt, el Levante, Egipto, Irak, el Golfo y el Magreb);
    /// 4. los países de sus estilos, si todos son de uno (la bossa nova, del jazz, Estados Unidos), o los de su
    ///    tradición (los tāla, la India);
    /// 5. los continentes de su tradición.
    ///
    /// Vacío si no se sabe nada.
    var lugaresDeOrigen: [Lugar] {
        if !lugares.isEmpty { return lugares }
        if let historico = tradicion?.lugarHistorico { return [.historico(historico)] }
        if let zonas = tradicion?.zonas, !zonas.isEmpty { return zonas.map(Lugar.zona) }
        let deLosEstilos: [Pais] =
            !estilos.isEmpty && estilos.allSatisfy({ !$0.paises.isEmpty })
            ? Pais.allCases.filter { pais in estilos.contains { $0.paises.contains(pais) } } : []
        let paises = tradicion == nil ? deLosEstilos : (tradicion?.paises ?? [])
        if !paises.isEmpty { return Pais.allCases.filter(paises.contains).map(Lugar.pais) }
        return (tradicion?.continentes ?? []).map(Lugar.continente)
    }

    /// Los países de donde viene, en el orden de `Pais.allCases`, con los que contienen sus lugares.
    var paisesDeOrigen: [Pais] {
        let lugares = Set(lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
        return Pais.allCases.filter { lugares.contains(.pais($0)) }
    }

    /// Los continentes de donde viene, en el orden de `Continente.allCases`.
    var continentesDeOrigen: [Continente] {
        let lugares = Set(lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
        return Continente.allCases.filter { lugares.contains(.continente($0)) }
    }
}
