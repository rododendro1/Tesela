import Elementos

// MARK: - De dónde vienen los ritmos y los temperamentos
//
// Lo que las escalas saben de su lugar (TipoDeEscala+Lugar.swift), en los ritmos y los temperamentos: su tradición y
// sus lugares de origen, de sus datos (`DatosDelCatalogo.lugaresDeOrigen`).

extension RitmoConNombre {
    /// La tradición de la que es: la India en los tāla, el mundo árabe en los iqāʿāt; `nil` en los de los estilos
    /// occidentales (el flamenco, el jazz).
    public var tradicion: Tradicion? { datos.tradicion }

    /// Los lugares de donde viene, los más concretos que se saben: Andalucía en la soleá, Cuba en la clave de son, la
    /// India en el tīntāl.
    public var lugaresDeOrigen: [Lugar] { datos.lugaresDeOrigen }

    /// Los países de donde viene, con los que contienen sus lugares: España en la soleá, por Andalucía.
    public var paisesDeOrigen: [Pais] { datos.paisesDeOrigen }

    /// Los continentes de donde viene: Europa en la soleá, América en la clave de son.
    public var continentesDeOrigen: [Continente] { datos.continentesDeOrigen }
}

extension TemperamentoConNombre {
    /// La tradición de la que es: Turquía en las 53 comas, la India en los 22 śruti; `nil` en los de la occidental.
    public var tradicion: Tradicion? { datos.tradicion }

    /// Los lugares de donde viene: el país de quien lo propuso (Alemania en Werckmeister III, China en el temperamento
    /// igual de Zhu Zaiyu) o los de su tradición.
    public var lugaresDeOrigen: [Lugar] { datos.lugaresDeOrigen }

    /// Los países de donde viene, con los que contienen sus lugares.
    public var paisesDeOrigen: [Pais] { datos.paisesDeOrigen }

    /// Los continentes de donde viene.
    public var continentesDeOrigen: [Continente] { datos.continentesDeOrigen }

    /// En qué estilos se usa, de más a menos importante: la música clásica en los del Barroco.
    public var estilos: [Estilo] { datos.estilos }
}
