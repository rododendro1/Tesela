import Armonia

// El catálogo de progresiones (`ProgresionConNombre.catalogo`: las cadencias, el barroco, el galante y las danzas, el
// jazz y el blues, y el pop, en su orden), una fila por progresión con lo que dice de ella la API pública: nombres (y
// su traducción a los otros doce idiomas), modo, cifrado romano, acordes sobre Do, si `EsquemaArmonico` la reconoce en
// sus propios acordes, estilos y las obras que la citan.

let columnasDeProgresiones: [String] =
    columnasDeNombres + columnasDeAliasYVariantes() + [
        "modo", "numero_de_acordes", "cifrado", "acordes_sobre_do", "se_reconoce",
    ] + columnasDeLaFecha + [
        "estilos", "referencias",
    ]

/// La fila de una progresión, en el orden de `columnasDeProgresiones`.
func filaDeProgresion(_ progresion: ProgresionConNombre) -> [String] {
    let comoSeLlama = nombres(de: progresion)
    let acordes = progresion.acordes(sobre: .do)
    let reconocida = EsquemaArmonico.buscar(en: acordes).contains { $0.progresion == progresion && $0.inicio == 0 }
    let otros: [String] = aliasYVariantes(de: progresion)
    let resto: [String] = [
        progresion.modo.nombre,
        String(progresion.grados.count),
        progresion.cifrado,
        acordes.map(\.cifrado).joined(separator: " "),
        siONo(reconocida),
    ]
    let alFinal: [String] = [
        progresion.estilos.map(\.nombre).joined(separator: " · "),
        progresion.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + otros + resto + fecha(de: progresion) + alFinal
}

let progresiones = Catalogo(
    fichero: "progresiones.tsv", columnas: columnasDeProgresiones,
    filas: ProgresionConNombre.catalogo.map(filaDeProgresion),
    obras: ProgresionConNombre.catalogo.flatMap(\.referencias))
