import Armonia

extension LineaDeComandos {
    /// Los dibujos del Tonnetz, de la tabla armónica y de los teclados de cuadrícula, en el orden en que salen en la
    /// ayuda.
    static let ordenesDeDibujos: [Orden] = [
        Orden(nombres: ["tonnetz"], ayuda: ayudaDeTonnetz) { try tonnetz($0, $1) },
        Orden(nombres: ["tabla", "harmonic-table"], ayuda: ayudaDeTabla) { try tablaArmonica($0, $1) },
        Orden(nombres: ["teclado", "keyboard"], ayuda: ayudaDeTeclado) { try teclado($0, $1) },
        Orden(nombres: ["cuadricula", "grid"], ayuda: ayudaDeCuadricula) { try cuadricula($0, $1) },
        Orden(nombres: ["reloj", "clock"], ayuda: ayudaDeReloj) { try reloj($0, $1) },
        Orden(nombres: ["pentagrama", "staff"], ayuda: ayudaDePentagrama) { try pentagrama($0, $1) },
    ]

    static let ayudaDeTeclado: [EntradaDeAyuda] = [
        // teclado <escala> [--mano derecha|izquierda] [--octavas 2]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTeclado),
            descripcion: TextosDeCLI.traduccion(\.descripcionTeclado),
            ejemplo: ejemplo(
                "armonia teclado Re mayor --mano derecha > re.svg",
                "armonia keyboard D major --hand right > d.svg"))
    ]

    static let ayudaDeReloj: [EntradaDeAyuda] = [
        // reloj <escala> [--quintas]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisReloj),
            descripcion: TextosDeCLI.traduccion(\.descripcionReloj),
            ejemplo: ejemplo(
                "armonia reloj Do disminuida --quintas > disminuida.svg",
                "armonia clock C diminished --fifths > diminished.svg"))
    ]

    static let ayudaDePentagrama: [EntradaDeAyuda] = [
        // pentagrama escala|acorde|arpegio|acordes <…>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPentagrama),
            descripcion: TextosDeCLI.traduccion(\.descripcionPentagrama),
            ejemplo: ejemplo(
                "armonia pentagrama escala Re dórico --octavas 2 --semitonos > dorico.svg",
                "armonia staff scale D dorian --octaves 2 --semitones > dorian.svg"))
    ]

    static let ayudaDeTonnetz: [EntradaDeAyuda] = [
        // tonnetz <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetz),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetz),
            ejemplo: ejemplo(
                "armonia tonnetz Do Mi Sol Si > tonnetz.svg",
                "armonia tonnetz C E G B > tonnetz.svg")),
        // tonnetz --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzAcorde),
            ejemplo: ejemplo(
                "armonia tonnetz --escala Re dórico > dorico.svg",
                "armonia tonnetz --scale D dorian > dorian.svg")),
        // tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzRecorrido),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzRecorrido),
            ejemplo: ejemplo(
                "armonia tonnetz --recorrido Do Lam Fa Rem > recorrido.svg",
                "armonia tonnetz --sequence C Am F Dm > sequence.svg")),
        // tonnetz --ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzCiclo),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzCiclo),
            ejemplo: ejemplo(
                "armonia tonnetz --ciclo hexatonico Do > ciclo.svg",
                "armonia tonnetz --cycle hexatonic C > cycle.svg"),
            notas: TextosDeCLI.traduccion(\.notasTonnetzCiclo)),
    ]

    static let ayudaDeTabla: [EntradaDeAyuda] = [
        // tabla <notas o alturas>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTabla),
            descripcion: TextosDeCLI.traduccion(\.descripcionTabla),
            ejemplo: ejemplo(
                "armonia tabla Do3 Sol3 Mi4 > tabla.svg",
                "armonia tabla C3 G3 E4 > table.svg")),
        // tabla --acorde <cifrado> | --escala <escala> | --clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTablaAcorde),
            descripcion: TextosDeCLI.traduccion(\.descripcionTablaAcorde),
            ejemplo: ejemplo(
                "armonia tabla --acorde Domaj7 > domaj7.svg",
                "armonia tabla --chord Cmaj7 > cmaj7.svg")),
    ]

    static let ayudaDeCuadricula: [EntradaDeAyuda] = [
        // cuadricula <notas o alturas> | --acorde | --escala | --clases
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisCuadricula),
            descripcion: TextosDeCLI.traduccion(\.descripcionCuadricula),
            ejemplo: ejemplo(
                "armonia cuadricula --ejes 2,5 --acorde Sol7 > sol7.svg",
                "armonia cuadricula --axes 2,5 --chord G7 > g7.svg")),
        // cuadricula --ejes H,V --rejilla CxF --origen <altura> --giro 0-3 --espejo --en-tono
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisCuadriculaOpciones),
            descripcion: TextosDeCLI.traduccion(\.descripcionCuadriculaOpciones),
            ejemplo: ejemplo(
                "armonia cuadricula --rejilla 8x8 --en-tono --escala Re dórico > pads.svg",
                "armonia cuadricula --grid 8x8 --in-key --scale D dorian > pads.svg")),
    ]
}
