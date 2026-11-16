import Armonia

extension LineaDeComandos {
    /// Los ficheros de afinación de Scala, que salen en la ayuda con las partituras.
    static let ordenesDeAfinacion: [Orden] = [
        Orden(
            nombres: ["scala"], ayuda: ayudaDeScala, json: { try scalaJSON($0, $1) }, sinJSON: [.kbm, .temperamento],
            ejecutar: { try scala($0, $1) })
    ]

    static let ayudaDeScala: [EntradaDeAyuda] = [
        // scala temperamento <temperamento> [--kbm]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisScalaTemperamento),
            descripcion: TextosDeConsola.traduccion(\.descripcionScalaTemperamento),
            ejemplo: ejemplo(
                "armonia scala temperamento Werckmeister III > werckmeister.scl",
                "armonia scala temperament Werckmeister III > werckmeister.scl"),
            opciones: [.kbm]),
        // scala escala <escala> [--temperamento <temperamento>] [--kbm]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisScalaEscala),
            descripcion: TextosDeConsola.traduccion(\.descripcionScalaEscala),
            ejemplo: ejemplo(
                "armonia scala escala Re bayati > bayati.scl", "armonia scala scale D bayati > bayati.scl"),
            opciones: [.temperamento, .kbm]),
        // scala --archivo <fichero.scl> [--tolerancia <cents>] [--limite <n>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisScalaArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionScalaArchivo),
            ejemplo: ejemplo(
                "armonia scala --archivo werckmeister.scl --tolerancia 1",
                "armonia scala --file werckmeister.scl --tolerance 1"),
            opciones: [.archivo, .tolerancia, .limite]),
    ]
}
