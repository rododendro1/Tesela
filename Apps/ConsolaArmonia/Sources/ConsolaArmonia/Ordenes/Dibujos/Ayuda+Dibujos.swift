import Armonia

extension LineaDeComandos {
    /// Los dibujos del Tonnetz, de la tabla armónica y de los teclados de cuadrícula, en el orden en que salen en la
    /// ayuda.
    static let ordenesDeDibujos: [Orden] = [
        Orden(nombres: ["tonnetz"], ayuda: ayudaDeTonnetz) { try tonnetz($0, $1.notacion) },
        Orden(nombres: ["tabla", "harmonic-table"], ayuda: ayudaDeTabla) { try tablaArmonica($0, $1.notacion) },
        Orden(nombres: ["teclado", "keyboard"], ayuda: ayudaDeTeclado) { try teclado($0, $1.notacion) },
        Orden(nombres: ["cuadricula", "grid"], ayuda: ayudaDeCuadricula) { try cuadricula($0, $1.notacion) },
        Orden(nombres: ["reloj", "clock"], ayuda: ayudaDeReloj) { try reloj($0, $1.notacion) },
        Orden(nombres: ["hoja", "sheet"], ayuda: ayudaDeHoja) { try hoja($0, $1.notacion) },
        Orden(nombres: ["pentagrama", "staff"], ayuda: ayudaDePentagrama) { try pentagrama($0, $1.notacion) },
    ]

    static let ayudaDeTeclado: [EntradaDeAyuda] = [
        // teclado <escala> [--dedos [derecha|izquierda]] [--octavas 2]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTeclado),
            descripcion: TextosDeConsola.traduccion(\.descripcionTeclado),
            ejemplo: ejemplo(
                "armonia teclado Re mayor --dedos > re.svg",
                "armonia keyboard D major --fingers > d.svg"),
            opciones: [.dedos, .octavas])
    ]

    static let ayudaDeHoja: [EntradaDeAyuda] = [
        // hoja <escala> [--comparar <escala>] [--html]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisHoja),
            descripcion: TextosDeConsola.traduccion(\.descripcionHoja),
            ejemplo: ejemplo(
                "armonia hoja Re dórico > dorico.svg",
                "armonia sheet D dorian > dorian.svg"),
            opciones: [.comparar, .html]),
        // hoja acorde <cifrado> [--html]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisHojaDeAcorde),
            descripcion: TextosDeConsola.traduccion(\.descripcionHojaDeAcorde),
            ejemplo: ejemplo(
                "armonia hoja acorde Sol7 > sol7.svg",
                "armonia sheet chord G7 > g7.svg"),
            opciones: [.html]),
        // hoja acordes <acordes> [--en <tonalidad>] [--doce] [--comparar <acordes>] [--html]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisHojaDeAcordes),
            descripcion: TextosDeConsola.traduccion(\.descripcionHojaDeAcordes),
            ejemplo: ejemplo(
                "armonia hoja acordes Rem7 Sol7 Do7M --en Do mayor > ii-V-I.svg",
                "armonia sheet chords Dm7 G7 Cmaj7 --in C major > ii-V-I.svg"),
            opciones: [.en, .doce, .comparar, .html]),
        // hoja tonalidad <tonalidad> [--html]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisHojaDeTonalidad),
            descripcion: TextosDeConsola.traduccion(\.descripcionHojaDeTonalidad),
            ejemplo: ejemplo(
                "armonia hoja tonalidad Re mayor > re.svg",
                "armonia sheet key D major > d.svg"),
            opciones: [.html]),
    ]

    static let ayudaDeReloj: [EntradaDeAyuda] = [
        // reloj <escala> [--quintas | --microtonal [--fuente <teórico>]] [--colores]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisReloj),
            descripcion: TextosDeConsola.traduccion(\.descripcionReloj),
            ejemplo: ejemplo(
                "armonia reloj Do disminuida --quintas > disminuida.svg",
                "armonia clock C diminished --fifths > diminished.svg"),
            opciones: [.quintas, .microtonal, .fuente, .colores])
    ]

    static let ayudaDePentagrama: [EntradaDeAyuda] = [
        // pentagrama escala|acorde|arpegio|acordes <…>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPentagrama),
            descripcion: TextosDeConsola.traduccion(\.descripcionPentagrama),
            ejemplo: ejemplo(
                "armonia pentagrama escala Re dórico --octavas 2 --semitonos > dorico.svg",
                "armonia staff scale D dorian --octaves 2 --semitones > dorian.svg"),
            opciones: [.figura, .tresillos, .nombres, .intervalos, .semitonos, .tonica, .en]),
        // pentagrama <qué> --romanos|--dedos|--secuencia|--tab
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPentagramaEstudio),
            descripcion: TextosDeConsola.traduccion(\.descripcionPentagramaEstudio),
            ejemplo: ejemplo(
                "armonia pentagrama escala Sol mayor --dedos guitarra > sol.svg",
                "armonia staff scale G major --fingers guitar > g.svg"),
            opciones: [.romanos, .dedos, .secuencia, .tab, .instrumento]),
        // pentagrama <qué> --registro|--clave|--doble|--cambiar-clave|--bajo-cifrado
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPentagramaRegistro),
            descripcion: TextosDeConsola.traduccion(\.descripcionPentagramaRegistro),
            ejemplo: ejemplo(
                "armonia pentagrama acordes Do Fa/La Sol7/Si Do --bajo-cifrado > bajo.svg",
                "armonia staff chords C F/A G7/B C --figured-bass > bass.svg"),
            opciones: [.registro, .clave, .doble, .cambiarClave, .bajoCifrado]),
        // pentagrama melodia <notas> --sobre <acordes>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPentagramaMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionPentagramaMelodia),
            ejemplo: ejemplo(
                "armonia pentagrama melodia Mi4:8 Re4:8 Do4:4 Si3:4 Do4:4 --sobre Do > melodia.svg",
                "armonia staff melody E4:8 D4:8 C4:4 B3:4 C4:4 --over C > melody.svg"),
            opciones: [.sobre, .ajenas]),
        // pentagrama bajo <acordes> [--tab]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisPentagramaBajo),
            descripcion: TextosDeConsola.traduccion(\.descripcionPentagramaBajo),
            ejemplo: ejemplo(
                "armonia pentagrama bajo Rem7 Sol7 Do7M --tab > bajo.svg",
                "armonia staff bass Dm7 G7 Cmaj7 --tab > bass.svg"),
            opciones: [.tab]),
    ]

    static let ayudaDeTonnetz: [EntradaDeAyuda] = [
        // tonnetz <notas>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTonnetz),
            descripcion: TextosDeConsola.traduccion(\.descripcionTonnetz),
            ejemplo: ejemplo(
                "armonia tonnetz Do Mi Sol Si > tonnetz.svg",
                "armonia tonnetz C E G B > tonnetz.svg")),
        // tonnetz acorde <cifrado> | escala <escala> | clases <números>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTonnetzAcorde),
            descripcion: TextosDeConsola.traduccion(\.descripcionTonnetzAcorde),
            ejemplo: ejemplo(
                "armonia tonnetz escala Re dórico > dorico.svg",
                "armonia tonnetz scale D dorian > dorian.svg")),
        // tonnetz recorrido <tríadas> | camino <tríada> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTonnetzRecorrido),
            descripcion: TextosDeConsola.traduccion(\.descripcionTonnetzRecorrido),
            ejemplo: ejemplo(
                "armonia tonnetz recorrido Do Lam Fa Rem > recorrido.svg",
                "armonia tonnetz sequence C Am F Dm > sequence.svg")),
        // tonnetz ciclo <ciclo> <tríada>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTonnetzCiclo),
            descripcion: TextosDeConsola.traduccion(\.descripcionTonnetzCiclo),
            ejemplo: ejemplo(
                "armonia tonnetz ciclo hexatonico Do > ciclo.svg",
                "armonia tonnetz cycle hexatonic C > cycle.svg"),
            notas: TextosDeConsola.traduccion(\.notasTonnetzCiclo),
            opciones: [.margen]),
    ]

    static let ayudaDeTabla: [EntradaDeAyuda] = [
        // tabla <notas o alturas>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTabla),
            descripcion: TextosDeConsola.traduccion(\.descripcionTabla),
            ejemplo: ejemplo(
                "armonia tabla Do3 Sol3 Mi4 > tabla.svg",
                "armonia tabla C3 G3 E4 > table.svg")),
        // tabla acorde <cifrado> | escala <escala> | clases <números> | recorrido | camino | ciclo
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTablaAcorde),
            descripcion: TextosDeConsola.traduccion(\.descripcionTablaAcorde),
            ejemplo: ejemplo(
                "armonia tabla acorde Domaj7 > domaj7.svg",
                "armonia tabla chord Cmaj7 > cmaj7.svg"),
            opciones: [.margen]),
    ]

    static let ayudaDeCuadricula: [EntradaDeAyuda] = [
        // cuadricula <notas o alturas> | acorde | escala | clases
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisCuadricula),
            descripcion: TextosDeConsola.traduccion(\.descripcionCuadricula),
            ejemplo: ejemplo(
                "armonia cuadricula acorde Sol7 --ejes 2,5 > sol7.svg",
                "armonia cuadricula chord G7 --axes 2,5 > g7.svg")),
        // cuadricula --ejes H,V --rejilla CxF --origen <altura> --giro 0-3 --espejo --en-tono
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisCuadriculaOpciones),
            descripcion: TextosDeConsola.traduccion(\.descripcionCuadriculaOpciones),
            ejemplo: ejemplo(
                "armonia cuadricula escala Re dórico --rejilla 8x8 --en-tono > pads.svg",
                "armonia cuadricula scale D dorian --grid 8x8 --in-key > pads.svg"),
            opciones: [.ejes, .rejilla, .origen, .giro, .espejo, .enTono]),
    ]
}
