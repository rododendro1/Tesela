import Armonia
import Foundation

// MARK: - La sesión y las órdenes de un fichero
//
// `armonia` sin argumentos, con la entrada y la salida en la terminal, abre una sesión: se escribe una orden por
// línea, sin «armonia» delante, y cada una se ejecuta como si se hubiera escrito en la línea de comandos. Termina con
// `salir` (o `exit`, `quit`) o al cerrar la entrada (Ctrl-D).
//
//     armonia> acorde Sol7
//     Sol7: séptima de dominante
//     armonia> --idioma eu
//     armonia> acorde Sol7
//     Sol7: dominanteko zazpigarrena
//     armonia> salir
//
// Sin argumentos y con la entrada en un fichero o una tubería (`armonia < ejercicios.txt`), se ejecutan sus líneas
// igual, sin bienvenida, y el código de salida es el mayor de todos. En los dos casos, una línea con solo opciones
// generales (`--idioma eu`, `--json`) las deja puestas para las siguientes, y las que empiezan por `#` no cuentan.

extension LineaDeComandos {
    /// Lo que se escribe antes de cada orden.
    public static let indicadorDeLaSesion = "armonia> "

    /// Las palabras que terminan la sesión.
    static let finesDeLaSesion: Set = ["salir", "exit", "quit"]

    /// Ejecuta una sesión: escribe la bienvenida, lee una línea tras otra con `leerLinea` (que da `nil` al cerrarse
    /// la entrada) y escribe el resultado de cada orden con `escribir`. Las órdenes se ejecutan con la salida en la
    /// terminal (un fichero binario no se escribe) y con el idioma de `entorno`, como `ejecutar`.
    public static func sesion(
        entorno: [String: String] = [:], leerLinea: () -> String?, escribir: (ResultadoDeOrden) -> Void
    ) {
        switch notacionDelEntorno(entorno) {
        case .success(let notacion):
            escribir(bien(TextosDeCLI.en(notacion) { $0.bienvenidaDeLaSesion(version) }))
        case .failure(let error):
            escribir(uso(error, .espanolCompacto))
            return
        }
        _ = ejecutarLineas(entorno: entorno, salidaEsTerminal: true, leerLinea: leerLinea, escribir: escribir)
    }

    /// Ejecuta las órdenes de un fichero, una por línea, como en la sesión pero sin bienvenida, y da el código de
    /// salida: el mayor de todas (0 si todas van bien). Sin ninguna orden, escribe el índice de la ayuda, como
    /// `armonia` a secas.
    public static func lote(
        entorno: [String: String] = [:], salidaEsTerminal: Bool = false, leerLinea: () -> String?,
        escribir: (ResultadoDeOrden) -> Void
    ) -> Int32 {
        guard
            let codigo = ejecutarLineas(
                entorno: entorno, salidaEsTerminal: salidaEsTerminal, leerLinea: leerLinea, escribir: escribir)
        else {
            let resultado = ejecutar([], salidaEsTerminal: salidaEsTerminal, entorno: entorno)
            escribir(resultado)
            return resultado.codigo
        }
        return codigo
    }

    /// Lee y ejecuta las líneas hasta el final o hasta `salir`, con las opciones generales que haya dejado puestas
    /// una línea de solo opciones. Da el mayor código de salida, o `nil` si no había ninguna orden.
    static func ejecutarLineas(
        entorno: [String: String], salidaEsTerminal: Bool, leerLinea: () -> String?,
        escribir: (ResultadoDeOrden) -> Void
    ) -> Int32? {
        var puestas: [String] = []
        var codigo: Int32?
        while let linea = leerLinea() {
            var palabras = palabras(deLaLinea: linea)
            if palabras.first == "armonia" { palabras.removeFirst() }
            guard let primera = palabras.first, !primera.hasPrefix("#") else { continue }
            if finesDeLaSesion.contains(primera.lowercased()) { break }
            let resultado: ResultadoDeOrden
            if let opciones = soloOpcionesGenerales(palabras) {
                // Se comprueban con una orden que no escribe nada si van bien.
                let prueba = ejecutar(
                    opciones.filter { $0 != "--json" } + ["version"], salidaEsTerminal: salidaEsTerminal,
                    entorno: entorno)
                if prueba.codigo == 0 {
                    puestas = opciones
                    continue
                }
                resultado = prueba
            } else {
                resultado = ejecutar(
                    palabras + opciones(puestas, queNoEstanEn: palabras), salidaEsTerminal: salidaEsTerminal,
                    entorno: entorno)
            }
            escribir(resultado)
            codigo = max(codigo ?? 0, resultado.codigo)
        }
        return codigo
    }

    /// Las opciones generales, por grupos: las de un grupo se excluyen entre sí (`--ingles` y `--idioma`), y las que
    /// llevan un valor detrás.
    static let gruposDeOpcionesGenerales: [(opciones: Set<String>, conValor: Set<String>)] =
        ([[.ingles, .idioma], [.textos], [.escritura], [.subindices, .cifras], [.json]] as [[OpcionDeOrden]]).map {
            (Set($0.flatMap(\.nombres)), Set($0.filter(\.llevaValor).flatMap(\.nombres)))
        }

    /// Las palabras, si todas son opciones generales con sus valores (`--idioma eu --json`); `nil` si hay otra cosa.
    static func soloOpcionesGenerales(_ palabras: [String]) -> [String]? {
        var i = palabras.startIndex
        while i < palabras.endIndex {
            let palabra = palabras[i].lowercased()
            guard let grupo = gruposDeOpcionesGenerales.first(where: { $0.opciones.contains(palabra) }) else {
                return nil
            }
            i += grupo.conValor.contains(palabra) ? 2 : 1
        }
        return palabras
    }

    /// Las opciones puestas de los grupos que la línea no trae: `--idioma eu` no se añade a una línea con `--ingles`.
    static func opciones(_ puestas: [String], queNoEstanEn palabras: [String]) -> [String] {
        let suyas = Set(palabras.map { $0.lowercased() })
        var resultado: [String] = []
        var i = puestas.startIndex
        while i < puestas.endIndex {
            let palabra = puestas[i].lowercased()
            guard let grupo = gruposDeOpcionesGenerales.first(where: { $0.opciones.contains(palabra) }) else {
                i += 1
                continue
            }
            let largo = grupo.conValor.contains(palabra) ? 2 : 1
            if suyas.isDisjoint(with: grupo.opciones) { resultado += puestas[i..<min(i + largo, puestas.endIndex)] }
            i += largo
        }
        return resultado
    }

    /// Las palabras de una línea, separadas por espacios como en la terminal: lo que va entre comillas, simples o
    /// dobles, es una sola palabra («escala "Re dórico"»).
    static func palabras(deLaLinea linea: String) -> [String] {
        var palabras: [String] = []
        var actual = ""
        var enPalabra = false
        var comilla: Character?
        for caracter in linea {
            if let abierta = comilla {
                if caracter == abierta { comilla = nil } else { actual.append(caracter) }
            } else if caracter == "\"" || caracter == "'" {
                comilla = caracter
                enPalabra = true
            } else if caracter.isWhitespace {
                if enPalabra { palabras.append(actual) }
                actual = ""
                enPalabra = false
            } else {
                actual.append(caracter)
                enPalabra = true
            }
        }
        if enPalabra { palabras.append(actual) }
        return palabras
    }
}
