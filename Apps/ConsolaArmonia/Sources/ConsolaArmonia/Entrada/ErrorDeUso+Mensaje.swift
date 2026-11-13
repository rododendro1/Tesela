import Armonia

// Lo que escribe la terminal ante un error de uso: el texto (ErrorDeUso+Textos.swift), lo que se quiso escribir
// (Sugerencias.swift) y dónde buscar en la ayuda.

extension ErrorDeUso {
    /// El mensaje que escribe la terminal: el error, lo que se quiso escribir si se parece a una orden o una opción
    /// conocida, y la línea que remite a la ayuda, la de la orden si se está ejecutando una
    /// (`enCurso`).
    func mensajeDeUso(en notacion: Notacion, enCurso: LineaDeComandos.OrdenEnCurso? = nil) -> String {
        var lineas = ["armonia: " + descripcion(en: notacion)]
        if let propuesta = propuesta(enCurso: enCurso) {
            lineas.append(TextosDeConsola.traduccion { $0.quisoDecir(propuesta) }.en(notacion))
        }
        if let enCurso {
            lineas.append(TextosDeConsola.traduccion { $0.pruebaLaAyudaDe(enCurso.nombre) }.en(notacion))
        } else {
            lineas.append(TextosDeConsola.en(notacion, \.pruebaLaAyuda))
        }
        return lineas.joined(separator: "\n") + "\n"
    }

    /// La orden o la opción conocida que más se parece a la desconocida (Sugerencias.swift).
    /// Las opciones que se proponen son las de la orden en curso, si la hay.
    private func propuesta(enCurso: LineaDeComandos.OrdenEnCurso?) -> String? {
        switch self {
        case .ordenDesconocida(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: LineaDeComandos.nombresDeLasOrdenes)
        case .opcionDesconocida(let opcion):
            return LineaDeComandos.propuesta(para: opcion, entre: LineaDeComandos.opcionesConocidas(enCurso: enCurso))
        case .idiomaDesconocido(let idioma):
            let nombres = Idioma.allCases.flatMap { [$0.codigo] + $0.nombres }
            return LineaDeComandos.propuesta(para: idioma, entre: nombres)
        case .tradicionDesconocida(let tradicion):
            let claves = LineaDeComandos.nombresDeLasTradiciones.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: tradicion, entre: claves)
        case .familiaDeTemperamentoDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia,
                entre: LineaDeComandos.nombresDeLasFamiliasDeTemperamento.flatMap { [$0.espanol, $0.ingles] })
        case .familiaDeNotaDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeNota.flatMap { [$0.espanol, $0.ingles] })
        case .familiaDeFuncionDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeFuncion.flatMap { [$0.espanol, $0.ingles] })
        case .ritmoDesconocido(let ritmo):
            return LineaDeComandos.propuesta(para: ritmo, entre: RitmoConNombre.catalogo.map(\.nombre))
        case .familiaDeRitmoDesconocida(let familia):
            return LineaDeComandos.propuesta(
                para: familia, entre: LineaDeComandos.nombresDeLasFamiliasDeRitmo.flatMap { [$0.espanol, $0.ingles] })
        case .categoriaDesconocida(let categoria):
            return LineaDeComandos.propuesta(para: categoria, entre: CategoriaTradicional.allCases.map(\.rawValue))
        case .fuenteDesconocida(let fuente):
            return LineaDeComandos.propuesta(para: fuente, entre: FuenteTeorica.allCases.map(\.rawValue))
        case .estiloDesconocido(let estilo):
            let claves =
                LineaDeComandos.nombresDeLosEstilos.flatMap { [$0.espanol, $0.ingles] }
                + LineaDeComandos.nombresDeLasCorrientes.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: estilo, entre: claves)
        case .lugarDesconocido(let lugar):
            return LineaDeComandos.propuesta(para: lugar, entre: Lugar.todos.map(\.clave))
        case .epocaDesconocida(let epoca):
            return LineaDeComandos.propuesta(
                para: epoca, entre: LineaDeComandos.nombresDeLasEpocas.flatMap { [$0.espanol, $0.ingles] })
        case .afectoDesconocido(let afecto):
            return LineaDeComandos.propuesta(
                para: afecto, entre: Afecto.allCases.flatMap { [$0.rawValue, $0.nombre(en: .compacta(.ingles))] })
        case .escuelaDesconocida(let escuela):
            return LineaDeComandos.propuesta(
                para: escuela, entre: LineaDeComandos.nombresDeLasEscuelas.flatMap { [$0.espanol, $0.ingles] })
        case .afinacionDesconocida(let afinacion):
            return LineaDeComandos.propuesta(
                para: afinacion, entre: LineaDeComandos.nombresDeLasAfinaciones.flatMap { [$0.espanol, $0.ingles] })
        case .agrupacionDesconocida(let agrupacion):
            let claves = LineaDeComandos.nombresDeLasAgrupaciones.flatMap { [$0.espanol, $0.ingles] }
            return LineaDeComandos.propuesta(para: agrupacion, entre: claves)
        case .intervaloDeEscalasDesconocido(let intervalo):
            return LineaDeComandos.propuesta(
                para: intervalo, entre: Array(LineaDeComandos.clasesIntervalicasPorNombre.keys))
        case .ordenDeEscalasDesconocido(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: Array(LineaDeComandos.ordenesDeEscalas.keys))
        case .ordenDeAcordesDesconocido(let orden):
            return LineaDeComandos.propuesta(para: orden, entre: Array(LineaDeComandos.ordenesDeAcordes.keys))
        case .escrituraNoValida(let escritura):
            return LineaDeComandos.propuesta(para: escritura, entre: LineaDeComandos.nombresDeLasEscrituras)
        case .sistemaDesconocido(let sistema):
            return LineaDeComandos.propuesta(
                para: sistema, entre: SistemaDeNombres.allCases.flatMap { [$0.rawValue] + $0.nombres })
        case .grafiaNoValida(let grafia):
            return LineaDeComandos.propuesta(para: grafia, entre: LineaDeComandos.nombresDeLasGrafias.map(\.0))
        default:
            return nil
        }
    }
}
