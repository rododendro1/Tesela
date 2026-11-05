// La herramienta de línea de comandos `armonia`: el motor sin escribir código.
//
//     armonia acorde Sol7/Si
//     armonia identificar Do Mi Sol Sib
//     armonia arpegio Do7 --patron alberti
//     armonia analizar Do Lam Re7 Sol7 Do
//
// Toda la lógica está aquí, separada del ejecutable, para poder probarla.

import Armonia
import Foundation

/// Lo que produce una orden: el texto de la salida estándar, el de la salida de errores y el
/// código de salida (0 bien, 1 texto que no se puede leer, 2 orden mal escrita). Una orden que
/// produce un fichero binario (MIDI) lo deja en `datos`, que va a la salida estándar en lugar
/// del texto.
public struct ResultadoDeOrden: Equatable, Sendable {
    public var salida: String
    public var error: String
    public var codigo: Int32
    public var datos: Data? = nil
}

public enum LineaDeComandos {
    /// Ejecuta una orden con sus argumentos (sin el nombre del programa).
    ///
    /// - Parameters:
    ///   - entrada: lee la entrada estándar entera. Con `-` entre los argumentos (`armonia identificar -`), sus
    ///     palabras van en su lugar; si la orden no lleva ningún argumento y la entrada no es la terminal
    ///     (`echo "Do Mi Sol" | armonia identificar`), van detrás del nombre de la orden. Sin ella, `-` se queda como
    ///     está.
    ///   - entradaEsTerminal: si la entrada estándar es la terminal: entonces solo se lee con `-`.
    ///   - salidaEsTerminal: si la salida estándar es la terminal: entonces una orden que da un fichero binario
    ///     (MIDI, PDF, PNG) no lo escribe y lo dice.
    public static func ejecutar(
        _ argumentos: [String], entrada: (() -> String)? = nil, entradaEsTerminal: Bool = true,
        salidaEsTerminal: Bool = false
    ) -> ResultadoDeOrden {
        var opciones = Argumentos(argumentos)
        var notacion: Notacion = opciones.quitarMarca("--ingles", "--english") ? .inglesASCII : .espanolCompacto
        switch opciones.quitarOpcion("--idioma", "--language") {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = notacionDelIdioma(texto) else { return uso(.idiomaDesconocido(texto), notacion) }
            notacion = elegida
        }
        switch opciones.quitarOpcion("--textos", "--texts") {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let textos = notacionDelIdioma(texto)?.idiomaDeLasNotas else {
                return uso(.idiomaDesconocido(texto), notacion)
            }
            notacion = notacion.conTextos(en: textos)
        }
        switch opciones.quitarOpcion("--escritura", "--writing") {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let escritura = escritura(texto, en: notacion.escritura.idioma) else {
                return uso(.escrituraNoValida(texto), notacion)
            }
            notacion = Notacion(escritura: escritura, textos: notacion.textos)
        }
        // La octava va como la escriba la notación (en subíndice en las compactas, con cifras en las demás), salvo
        // con --subindices o --cifras.
        let subindices = opciones.quitarMarca("--subindices", "--subscripts")
        let cifras = opciones.quitarMarca("--cifras", "--digits")
        if subindices {
            notacion = notacion.conOctavas(.subindices)
        } else if cifras {
            notacion = notacion.conOctavas(.cifras)
        }
        // Con --json, las órdenes que lo admiten dan sus datos en JSON (LineaDeComandos+JSON.swift).
        let json = opciones.quitarMarca("--json")
        let argumentos = opciones.restantes

        guard let nombre = argumentos.first?.lowercased() else { return bien(ayuda(en: notacion)) }
        guard let orden = orden(llamada: nombre) else { return uso(.ordenDesconocida(nombre), notacion) }
        var resto = Array(argumentos.dropFirst())

        // La ayuda de una orden: `armonia ayuda acorde`, `armonia acorde --help`.
        if orden.nombres.contains("ayuda"), let pedida = resto.first?.lowercased() {
            guard let otra = self.orden(llamada: pedida) else { return uso(.ordenDesconocida(pedida), notacion) }
            return bien(ayuda(de: otra, en: notacion))
        }
        if resto.contains(where: marcasDeAyuda.contains) { return bien(ayuda(de: orden, en: notacion)) }

        if let entrada {
            resto = conLaEntrada(resto, de: orden, entrada, entradaEsTerminal: entradaEsTerminal)
        }

        // Los errores de uso de la orden remiten a su ayuda y proponen sus opciones (ErrorDeUso.texto(en:)).
        let enCurso = OrdenEnCurso(orden: orden, nombre: nombre)
        let resultado = OrdenEnCurso.$actual.withValue(orden.nombres.contains("ayuda") ? nil : enCurso) {
            do {
                guard json else { return try orden.ejecutar(resto, notacion) }
                guard let salida = salidasJSON[orden.nombres[0]] else { return uso(.sinSalidaJSON(nombre), notacion) }
                return bien(try textoJSON(salida(resto, notacion)))
            } catch let fallo as FalloDeUso {
                return uso(fallo.error, notacion)
            } catch let error as any ErrorDeArmonia {
                return ResultadoDeOrden(
                    salida: "", error: "armonia: " + error.descripcion(en: notacion) + "\n", codigo: 1)
            } catch {
                return ResultadoDeOrden(salida: "", error: "armonia: \(error)\n", codigo: 1)
            }
        }
        // Un fichero binario no se escribe en la terminal.
        if resultado.datos != nil, salidaEsTerminal {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + TextosDeCLI.en(notacion, \.salidaBinaria) + "\n", codigo: 2)
        }
        return resultado
    }

    /// La orden que se llama así (en minúsculas), con cualquiera de sus nombres.
    static func orden(llamada nombre: String) -> Orden? {
        ordenes.first { $0.nombres.contains(nombre) }
    }

    /// Lo que pide la ayuda de una orden en lugar de ejecutarla: `armonia acorde --help`.
    static let marcasDeAyuda: Set = ["--help", "-h", "--ayuda"]

    /// Las órdenes que no leen nada: sin argumentos, no esperan a la entrada estándar.
    static let ordenesSinEntrada: Set = ["ayuda", "version", "motores", "completado", "manual"]

    /// Los argumentos de una orden con las palabras de la entrada estándar: en lugar de `-`, o detrás del nombre de
    /// la orden si no lleva ningún argumento y la entrada no es la terminal. Las líneas son palabras como las demás:
    /// «Do Mi Sol» en una línea o en tres es lo mismo.
    static func conLaEntrada(
        _ argumentos: [String], de orden: Orden, _ entrada: () -> String, entradaEsTerminal: Bool
    ) -> [String] {
        func palabras() -> [String] { entrada().split(whereSeparator: \.isWhitespace).map(String.init) }
        if let i = argumentos.firstIndex(of: "-") {
            var conEntrada = argumentos
            conEntrada.replaceSubrange(i...i, with: palabras())
            return conEntrada
        }
        guard argumentos.isEmpty, !entradaEsTerminal, ordenesSinEntrada.isDisjoint(with: orden.nombres) else {
            return argumentos
        }
        return palabras()
    }

    /// La orden que se está ejecutando y el nombre con que se ha llamado, para que sus errores de uso remitan a su
    /// ayuda (`armonia ayuda acorde`) y propongan sus opciones.
    struct OrdenEnCurso: Sendable {
        let orden: Orden
        let nombre: String
        @TaskLocal static var actual: OrdenEnCurso?
    }

    // MARK: Órdenes

    /// Una orden de `armonia`: los nombres con que se escribe (en minúsculas), sus entradas de la ayuda y lo que
    /// hace con el resto de los argumentos. Una orden nueva es una entrada más en uno de los `ordenesDe…`, y de
    /// ahí salen a la vez su ejecución y su ayuda.
    struct Orden: Sendable {
        let nombres: [String]
        let ayuda: [EntradaDeAyuda]
        let ejecutar: @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden
    }

    /// Todas las órdenes, en el orden en que salen en la ayuda.
    static let ordenes: [Orden] =
        ordenesDeConsultas + ordenesDeArmonizacion + ordenesDePartituras + ordenesDeGrabado
        + ordenesDeDibujos + ordenesDeNeorriemann + ordenesDeTrastes + ordenesDeLaTerminal + ordenesDeAyuda

    // MARK: Auxiliares

    static func binario(_ datos: Data) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: "", codigo: 0, datos: datos)
    }

    static func bien(_ texto: String) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: texto + "\n", error: "", codigo: 0)
    }

    static func uso(_ error: ErrorDeUso, _ notacion: Notacion) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: error.texto(en: notacion), codigo: 2)
    }

    /// La ayuda en el idioma de los textos de la notación (`Notacion.textos`).
    /// Todas salen de la tabla de `Ayuda.swift`: `ayuda(en: .delIdioma(.catalan))` es la de
    /// `armonia ayuda --idioma ca`.
    public static func ayuda(en notacion: Notacion) -> String {
        ayudas[notacion.textos] ?? textoDeAyuda(en: notacion.textos)
    }

    /// La ayuda en cada idioma, montada una sola vez.
    static let ayudas: [Idioma: String] = Dictionary(
        uniqueKeysWithValues: Idioma.allCases.map { ($0, textoDeAyuda(en: $0)) })

    /// La escritura de `--escritura`: palabras (o words) o compacto (compact o unicode) en todos los idiomas, y ascii
    /// en español e inglés. `nil` si no es ninguna de esas.
    static func escritura(_ texto: String, en idioma: Idioma) -> EscrituraDeNotas? {
        let t = texto.lowercased()
        if ["palabras", "words", "worte", "szavak"].contains(t) { return .conPalabras(idioma) }
        if ["compacto", "compact", "unicode", "kompakt", "tomor"].contains(t) { return .compacta(idioma) }
        if t == "ascii" && idioma.reglas.tieneVariantes { return EscrituraDeNotas(idioma: idioma, ascii: true) }
        return nil
    }

    /// La notación de `--idioma`: es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu, o el nombre del idioma.
    static func notacionDelIdioma(_ texto: String) -> Notacion? {
        (try? Idioma(leyendo: texto)).map(Notacion.delIdioma)
    }
}
