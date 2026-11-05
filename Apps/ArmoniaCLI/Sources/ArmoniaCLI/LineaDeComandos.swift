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
/// código de salida (0 bien, 1 texto que no se puede leer o nada que dar, 2 orden mal escrita, 3 faltas en lo que
/// `revisar` o `contrapunto` comprueban). Una orden que
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
    ///   - entrada: lee la entrada estándar entera, una sola vez. Con `-` entre los argumentos
    ///     (`armonia identificar -`), sus palabras van en su lugar; si la orden no lleva ningún argumento y la entrada
    ///     no es la terminal (`echo "Do Mi Sol" | armonia identificar`), van detrás del nombre de la orden. Con
    ///     `--archivo -`, es el fichero (`armonia analizar --archivo - < coral.mid`). Sin ella, `-` se queda como
    ///     está.
    ///   - entradaEsTerminal: si la entrada estándar es la terminal: entonces solo se lee con `-`.
    ///   - salidaEsTerminal: si la salida estándar es la terminal: entonces una orden que da un fichero binario
    ///     (MIDI, PDF, PNG) no lo escribe y lo dice, y el JSON de `--json` va con sangría (fuera de la terminal, en
    ///     una sola línea).
    ///   - entorno: las variables de entorno. `ARMONIA_IDIOMA` da el idioma como `--idioma` (que, con `--ingles` y
    ///     `--textos`, la anula); `ARMONIA_IDIOMA=sistema` toma el de `LC_ALL`, `LC_MESSAGES` o `LANG`.
    public static func ejecutar(
        _ argumentos: [String], entrada: (@Sendable () -> Data)? = nil, entradaEsTerminal: Bool = true,
        salidaEsTerminal: Bool = false, entorno: [String: String] = [:]
    ) -> ResultadoDeOrden {
        var opciones = Argumentos(argumentos)
        var notacion: Notacion
        switch notacionDelEntorno(entorno) {
        case .success(let delEntorno):
            notacion = delEntorno
        case .failure(let error):
            return uso(error, .espanolCompacto)
        }
        if opciones.quitarMarca("--ingles", "--english") { notacion = .inglesASCII }
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
        // Con -o, lo que da la orden va a ese fichero (`-o -`, a la salida estándar, aunque sea un fichero binario).
        var destino: String?
        switch opciones.quitarOpcion("-o", "--salida", "--output") {
        case .ausente:
            break
        case .sinValor(let nombre):
            // «-o» a secas, con su nombre largo.
            return uso(.faltaValor(nombre.isEmpty ? "salida" : nombre), notacion)
        case .valor(let ruta):
            destino = ruta
        }
        let argumentos = opciones.restantes

        guard let nombre = argumentos.first?.lowercased() else { return bien(indiceDeAyuda(en: notacion.textos)) }
        guard let orden = orden(llamada: nombre) else { return uso(.ordenDesconocida(nombre), notacion) }
        var resto = Array(argumentos.dropFirst())

        // Toda la ayuda (`armonia ayuda --todo`) y la de una orden: `armonia ayuda acorde`, `armonia acorde --help`.
        if orden.nombres.contains("ayuda"), let pedida = resto.first?.lowercased() {
            if marcasDeToda.contains(pedida) { return bien(ayuda(en: notacion)) }
            guard let otra = self.orden(llamada: pedida) else { return uso(.ordenDesconocida(pedida), notacion) }
            return bien(ayuda(de: otra, en: notacion))
        }
        if resto.contains(where: marcasDeAyuda.contains) { return bien(ayuda(de: orden, en: notacion)) }

        let estandar = entrada.map(EntradaEstandar.init)
        if let estandar {
            resto = conLaEntrada(resto, de: orden, estandar, entradaEsTerminal: entradaEsTerminal)
        }

        // Los errores de uso de la orden remiten a su ayuda y proponen sus opciones (ErrorDeUso.texto(en:)).
        let enCurso = OrdenEnCurso(orden: orden, nombre: nombre)
        let resultado = OrdenEnCurso.$actual.withValue(orden.nombres.contains("ayuda") ? nil : enCurso) {
            EntradaEstandar.$actual.withValue(estandar) {
                conLasNotasDelIdioma(resto, en: notacion) { resto in
                    ejecutar(orden, nombre: nombre, resto, json: json, salidaEsTerminal: salidaEsTerminal, notacion)
                }
            }
        }
        if let destino, destino != "-", resultado.codigo == 0 || resultado.codigo == 3 {
            return escribir(resultado, en: destino, notacion)
        }
        // Un fichero binario no se escribe en la terminal.
        if resultado.datos != nil, salidaEsTerminal, destino == nil {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + TextosDeCLI.en(notacion, \.salidaBinaria) + "\n", codigo: 2)
        }
        return resultado
    }

    /// Ejecuta la orden ya elegida, con sus argumentos, y recoge sus errores.
    static func ejecutar(
        _ orden: Orden, nombre: String, _ resto: [String], json: Bool, salidaEsTerminal: Bool, _ notacion: Notacion
    ) -> ResultadoDeOrden {
        do {
            guard json else { return try orden.ejecutar(resto, notacion) }
            guard let salida = orden.json else {
                return uso(.sinSalidaJSON(nombre), notacion)
            }
            let datos = try salida(resto, notacion)
            let texto = try textoJSON(datos, enUnaLinea: !salidaEsTerminal)
            let conFaltas = (datos as? any ConFaltas)?.hayFaltas ?? false
            return ResultadoDeOrden(salida: texto + "\n", error: "", codigo: conFaltas ? 3 : 0)
        } catch let error as ErrorDeUso {
            return uso(error, notacion)
        } catch let error as any ErrorDeArmonia {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + error.descripcion(en: notacion) + "\n", codigo: 1)
        } catch {
            return ResultadoDeOrden(salida: "", error: "armonia: \(error)\n", codigo: 1)
        }
    }

    /// Escribe lo que ha dado una orden en el fichero de `-o` (`~` es la carpeta personal) y no da nada más que
    /// sus avisos; si no se puede escribir, da el error con el código 1.
    static func escribir(_ resultado: ResultadoDeOrden, en ruta: String, _ notacion: Notacion) -> ResultadoDeOrden {
        let datos = resultado.datos ?? Data(resultado.salida.utf8)
        let url = URL(fileURLWithPath: (ruta as NSString).expandingTildeInPath)
        do {
            try datos.write(to: url)
        } catch {
            let texto = TextosDeCLI.en(notacion) { $0.archivoNoEscrito(ruta) }
            return ResultadoDeOrden(salida: "", error: resultado.error + "armonia: " + texto + "\n", codigo: 1)
        }
        return ResultadoDeOrden(salida: "", error: resultado.error, codigo: resultado.codigo)
    }

    /// La orden que se llama así (en minúsculas), con cualquiera de sus nombres.
    static func orden(llamada nombre: String) -> Orden? {
        ordenes.first { $0.nombres.contains(nombre) }
    }

    /// Lo que pide toda la ayuda tras `ayuda`, en lugar del índice: `armonia ayuda --todo`.
    static let marcasDeToda: Set = ["--todo", "--all", "todo", "all"]

    /// Lo que pide la ayuda de una orden en lugar de ejecutarla: `armonia acorde --help`.
    static let marcasDeAyuda: Set = ["--help", "-h", "--ayuda"]

    /// Las órdenes que no leen nada: sin argumentos, no esperan a la entrada estándar.
    static let ordenesSinEntrada: Set = ["ayuda", "version", "motores", "completado", "manual"]

    /// Los argumentos de una orden con las palabras de la entrada estándar: en lugar de `-`, o detrás del nombre de
    /// la orden si no lleva ningún argumento y la entrada no es la terminal. Las líneas son palabras como las demás:
    /// «Do Mi Sol» en una línea o en tres es lo mismo.
    static func conLaEntrada(
        _ argumentos: [String], de orden: Orden, _ entrada: EntradaEstandar, entradaEsTerminal: Bool
    ) -> [String] {
        func palabras() -> [String] {
            String(decoding: entrada.datos, as: UTF8.self).split(whereSeparator: \.isWhitespace).map(String.init)
        }
        // El `-` de `--archivo -` es el fichero, no unas palabras.
        let delArchivo: Set = ["--archivo", "--file"]
        if let i = argumentos.indices.first(where: {
            argumentos[$0] == "-" && ($0 == 0 || !delArchivo.contains(argumentos[$0 - 1]))
        }) {
            var conEntrada = argumentos
            conEntrada.replaceSubrange(i...i, with: palabras())
            return conEntrada
        }
        guard argumentos.isEmpty, !entradaEsTerminal, ordenesSinEntrada.isDisjoint(with: orden.nombres) else {
            return argumentos
        }
        return palabras()
    }

    /// La entrada estándar de la orden en curso, leída la primera vez que se pide y guardada.
    final class EntradaEstandar: @unchecked Sendable {
        private let leer: @Sendable () -> Data
        private var leidos: Data?
        private let cerrojo = NSLock()

        init(_ leer: @escaping @Sendable () -> Data) { self.leer = leer }

        var datos: Data {
            cerrojo.lock()
            defer { cerrojo.unlock() }
            if let leidos { return leidos }
            let datos = leer()
            leidos = datos
            return datos
        }

        @TaskLocal static var actual: EntradaEstandar?
    }

    /// Lo que hay en un fichero de `--archivo`: la entrada estándar si es `-`. `nil` si no se puede leer.
    static func contenido(deArchivo ruta: String) -> Data? {
        guard ruta == "-" else { return FileManager.default.contents(atPath: ruta) }
        return EntradaEstandar.actual?.datos
    }

    /// La orden que se está ejecutando y el nombre con que se ha llamado, para que sus errores de uso remitan a su
    /// ayuda (`armonia ayuda acorde`) y propongan sus opciones.
    struct OrdenEnCurso: Sendable {
        let orden: Orden
        let nombre: String
        @TaskLocal static var actual: OrdenEnCurso?
    }

    // MARK: Órdenes

    /// Una orden de `armonia`: los nombres con que se escribe (en minúsculas), sus entradas de la ayuda, sus opciones,
    /// lo que da con `--json` y lo que hace con el resto de los argumentos. Una orden nueva es una entrada más en uno
    /// de los `ordenesDe…`, y de ahí salen a la vez su ejecución, su ayuda, su autocompletado y las propuestas ante
    /// una opción mal escrita.
    struct Orden: Sendable {
        let nombres: [String]
        let ayuda: [EntradaDeAyuda]
        /// Sus opciones, en español y en inglés, sin las generales (`opcionesGenerales`): las de sus entradas de la
        /// ayuda (`EntradaDeAyuda.opciones`), salvo que se den otras.
        let opciones: [String]
        /// Lo que da con `--json`; `nil` si no lo admite.
        let json: SalidaJSON?
        let ejecutar: @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden

        init(
            nombres: [String], ayuda: [EntradaDeAyuda], opciones: [String]? = nil, json: SalidaJSON? = nil,
            ejecutar: @escaping @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden
        ) {
            self.nombres = nombres
            self.ayuda = ayuda
            var unicas: [String] = []
            for opcion in opciones ?? ayuda.flatMap(\.opciones) where !unicas.contains(opcion) { unicas.append(opcion) }
            self.opciones = unicas
            self.json = json
            self.ejecutar = ejecutar
        }
    }

    /// Las órdenes por grupos, como salen en el índice de la ayuda; los títulos están en
    /// `TextosDeCLI.gruposDeLaAyuda`, en el mismo orden.
    static let gruposDeOrdenes: [[Orden]] = [
        ordenesDeConsultas, ordenesDeArmonizacion, ordenesDePartituras + ordenesDeGrabado, ordenesDeDibujos,
        ordenesDeNeorriemann, ordenesDeTrastes, ordenesDeLaTerminal + ordenesDeAyuda,
    ]

    /// Todas las órdenes, en el orden en que salen en la ayuda.
    static let ordenes: [Orden] = gruposDeOrdenes.flatMap { $0 }

    // MARK: Auxiliares

    static func binario(_ datos: Data) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: "", codigo: 0, datos: datos)
    }

    static func bien(_ texto: String) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: texto + "\n", error: "", codigo: 0)
    }

    /// Un fichero de `--archivo` que no se puede leer: no es un error de uso, sino de lectura (código 1).
    static func archivoIlegible(_ ruta: String, _ notacion: Notacion) -> ResultadoDeOrden {
        let texto = TextosDeCLI.en(notacion) { $0.archivoIlegible(ruta) }
        return ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1)
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
        if escriturasConPalabras.contains(t) { return .conPalabras(idioma) }
        if escriturasCompactas.contains(t) { return .compacta(idioma) }
        if t == "ascii" && idioma.reglas.tieneVariantes { return EscrituraDeNotas(idioma: idioma, ascii: true) }
        return nil
    }

    static let escriturasConPalabras = ["palabras", "words", "worte", "szavak"]
    static let escriturasCompactas = ["compacto", "compact", "unicode", "kompakt", "tomor"]
    /// Lo que se puede escribir tras `--escritura`, para proponerlo ante una errata.
    static var nombresDeLasEscrituras: [String] { escriturasConPalabras + escriturasCompactas + ["ascii"] }

    /// La notación de `ARMONIA_IDIOMA`: la de su idioma, como `--idioma`; con `sistema` (o `system`), la del idioma
    /// de `LC_ALL`, `LC_MESSAGES` o `LANG` (el primero que haya), o la española si no es ninguno de los quince
    /// (`C`, `POSIX`); sin la variable, la española. Un idioma que no se conoce es un error de uso.
    static func notacionDelEntorno(_ entorno: [String: String]) -> Result<Notacion, ErrorDeUso> {
        guard let valor = entorno["ARMONIA_IDIOMA"]?.trimmingCharacters(in: .whitespaces), !valor.isEmpty else {
            return .success(.espanolCompacto)
        }
        if ["sistema", "system"].contains(valor.lowercased()) {
            let local = ["LC_ALL", "LC_MESSAGES", "LANG"].lazy.compactMap { entorno[$0] }.first { !$0.isEmpty }
            return .success(local.flatMap(Idioma.init(codigo:)).map(Notacion.delIdioma) ?? .espanolCompacto)
        }
        guard let notacion = notacionDelIdioma(valor) else {
            return .failure(ErrorDeUso.idiomaDesconocido("ARMONIA_IDIOMA=" + valor))
        }
        return .success(notacion)
    }

    /// La notación de `--idioma`: es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu, o el nombre del idioma.
    static func notacionDelIdioma(_ texto: String) -> Notacion? {
        (try? Idioma(leyendo: texto)).map(Notacion.delIdioma)
    }
}
