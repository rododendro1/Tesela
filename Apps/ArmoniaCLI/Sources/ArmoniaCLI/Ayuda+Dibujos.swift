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
        Orden(nombres: ["hoja", "sheet"], ayuda: ayudaDeHoja) { try hoja($0, $1) },
        Orden(nombres: ["pentagrama", "staff"], ayuda: ayudaDePentagrama) { try pentagrama($0, $1) },
    ]

    static let ayudaDeTeclado: [EntradaDeAyuda] = [
        // teclado <escala> [--mano derecha|izquierda] [--octavas 2]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTeclado),
            descripcion: TextosDeCLI.traduccion(\.descripcionTeclado),
            ejemplo: ejemplo(
                "armonia teclado Re mayor --mano derecha > re.svg",
                "armonia keyboard D major --hand right > d.svg"),
            opciones: ["--mano", "--octavas", "--hand", "--octaves"])
    ]

    static let ayudaDeHoja: [EntradaDeAyuda] = [
        // hoja <escala>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisHoja),
            descripcion: TextosDeCLI.traduccion(\.descripcionHoja),
            ejemplo: ejemplo(
                "armonia hoja Re dórico > dorico.svg",
                "armonia sheet D dorian > dorian.svg"))
    ]

    static let ayudaDeReloj: [EntradaDeAyuda] = [
        // reloj <escala> [--quintas]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisReloj),
            descripcion: TextosDeCLI.traduccion(\.descripcionReloj),
            ejemplo: ejemplo(
                "armonia reloj Do disminuida --quintas > disminuida.svg",
                "armonia clock C diminished --fifths > diminished.svg"),
            opciones: ["--quintas", "--fifths"])
    ]

    static let ayudaDePentagrama: [EntradaDeAyuda] = [
        // pentagrama escala|acorde|arpegio|acordes <…>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPentagrama),
            descripcion: TextosDeCLI.traduccion(\.descripcionPentagrama),
            ejemplo: ejemplo(
                "armonia pentagrama escala Re dórico --octavas 2 --semitonos > dorico.svg",
                "armonia staff scale D dorian --octaves 2 --semitones > dorian.svg"),
            opciones: [
                "--figura", "--tresillos", "--nombres", "--intervalos", "--semitonos", "--tonica", "--en", "--figure",
                "--triplets", "--names", "--intervals", "--semitones", "--tonic", "--in",
            ]),
        // pentagrama <qué> --romanos|--mano|--secuencia|--tab
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPentagramaEstudio),
            descripcion: TextosDeCLI.traduccion(\.descripcionPentagramaEstudio),
            ejemplo: ejemplo(
                "armonia pentagrama escala Sol mayor --tab --dedos > sol.svg",
                "armonia staff scale G major --tab --fingers > g.svg"),
            opciones: [
                "--romanos", "--mano", "--secuencia", "--tab", "--dedos", "--instrumento", "--roman", "--hand",
                "--sequence", "--fingers", "--instrument",
            ]),
        // pentagrama <qué> --octava|--clave|--doble|--cambiar-clave|--bajo-cifrado
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPentagramaRegistro),
            descripcion: TextosDeCLI.traduccion(\.descripcionPentagramaRegistro),
            ejemplo: ejemplo(
                "armonia pentagrama acordes Do Fa/La Sol7/Si Do --bajo-cifrado > bajo.svg",
                "armonia staff chords C F/A G7/B C --figured-bass > bass.svg"),
            opciones: [
                "--octava", "--clave", "--doble", "--cambiar-clave", "--bajo-cifrado", "--octave", "--clef",
                "--grand-staff", "--clef-changes", "--figured-bass",
            ]),
        // pentagrama melodia <notas> --sobre <acordes>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisPentagramaMelodia),
            descripcion: TextosDeCLI.traduccion(\.descripcionPentagramaMelodia),
            ejemplo: ejemplo(
                "armonia pentagrama melodia Mi4:8 Re4:8 Do4:4 Si3:4 Do4:4 --sobre Do > melodia.svg",
                "armonia staff melody E4:8 D4:8 C4:4 B3:4 C4:4 --over C > melody.svg"),
            opciones: ["--sobre", "--ajenas", "--over", "--non-chord"]),
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
                "armonia tonnetz --scale D dorian > dorian.svg"),
            opciones: ["--acorde", "--escala", "--clases", "--chord", "--scale", "--pcs"]),
        // tonnetz --recorrido <tríadas> | --camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzRecorrido),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzRecorrido),
            ejemplo: ejemplo(
                "armonia tonnetz --recorrido Do Lam Fa Rem > recorrido.svg",
                "armonia tonnetz --sequence C Am F Dm > sequence.svg"),
            opciones: ["--recorrido", "--camino", "--sequence", "--shortest"]),
        // tonnetz --ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisTonnetzCiclo),
            descripcion: TextosDeCLI.traduccion(\.descripcionTonnetzCiclo),
            ejemplo: ejemplo(
                "armonia tonnetz --ciclo hexatonico Do > ciclo.svg",
                "armonia tonnetz --cycle hexatonic C > cycle.svg"),
            notas: TextosDeCLI.traduccion(\.notasTonnetzCiclo),
            opciones: ["--ciclo", "--margen", "--cycle"]),
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
                "armonia tabla --chord Cmaj7 > cmaj7.svg"),
            opciones: [
                "--acorde", "--escala", "--clases", "--recorrido", "--camino", "--ciclo", "--margen", "--chord",
                "--scale", "--pcs", "--sequence", "--shortest", "--cycle",
            ]),
    ]

    static let ayudaDeCuadricula: [EntradaDeAyuda] = [
        // cuadricula <notas o alturas> | --acorde | --escala | --clases
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisCuadricula),
            descripcion: TextosDeCLI.traduccion(\.descripcionCuadricula),
            ejemplo: ejemplo(
                "armonia cuadricula --ejes 2,5 --acorde Sol7 > sol7.svg",
                "armonia cuadricula --axes 2,5 --chord G7 > g7.svg"),
            opciones: ["--acorde", "--escala", "--clases", "--chord", "--scale", "--pcs"]),
        // cuadricula --ejes H,V --rejilla CxF --origen <altura> --giro 0-3 --espejo --en-tono
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traduccion(\.sintaxisCuadriculaOpciones),
            descripcion: TextosDeCLI.traduccion(\.descripcionCuadriculaOpciones),
            ejemplo: ejemplo(
                "armonia cuadricula --rejilla 8x8 --en-tono --escala Re dórico > pads.svg",
                "armonia cuadricula --grid 8x8 --in-key --scale D dorian > pads.svg"),
            opciones: [
                "--ejes", "--rejilla", "--origen", "--giro", "--espejo", "--en-tono", "--escala", "--axes", "--grid",
                "--origin", "--rotate", "--mirror", "--in-key", "--scale",
            ]),
    ]
}
