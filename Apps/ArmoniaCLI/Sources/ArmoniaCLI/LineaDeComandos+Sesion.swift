import Armonia
import Foundation

// MARK: - La sesión
//
// `armonia` sin argumentos, con la entrada y la salida en la terminal, abre una sesión: se escribe una orden por
// línea, sin «armonia» delante, y cada una se ejecuta como si se hubiera escrito en la línea de comandos. Termina con
// `salir` (o `exit`, `quit`) o al cerrar la entrada (Ctrl-D).
//
//     armonia> acorde Sol7
//     Sol7: séptima de dominante
//     armonia> salir

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
        case .failure(let fallo):
            escribir(uso(fallo.error, .espanolCompacto))
            return
        }
        while let linea = leerLinea() {
            var palabras = palabras(deLaLinea: linea)
            if palabras.first == "armonia" { palabras.removeFirst() }
            guard let primera = palabras.first else { continue }
            if finesDeLaSesion.contains(primera.lowercased()) { return }
            escribir(ejecutar(palabras, salidaEsTerminal: true, entorno: entorno))
        }
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
