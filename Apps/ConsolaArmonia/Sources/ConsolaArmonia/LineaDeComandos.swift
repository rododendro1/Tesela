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
            return uso(error, .compacta(.espanol))
        }
        if opciones.quitarMarca(.ingles) { notacion = .ascii(.ingles) }
        switch opciones.quitarOpcion(.idioma) {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = notacionDelIdioma(texto) else { return uso(.idiomaDesconocido(texto), notacion) }
            notacion = elegida
        }
        switch opciones.quitarOpcion(.textos) {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = notacionDelIdioma(texto) else { return uso(.idiomaDesconocido(texto), notacion) }
            notacion = notacion.conTextos(en: elegida.idiomaDeLasNotas)
            if elegida.grafia != .original { notacion = notacion.conGrafia(elegida.grafia) }
        }
        switch opciones.quitarOpcion(.escritura) {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let escritura = escritura(texto, en: notacion.escritura.idioma) else {
                return uso(.escrituraNoValida(texto), notacion)
            }
            notacion = Notacion(escritura: escritura, textos: notacion.textos, grafia: notacion.grafia)
        }
        // Con --sistema, los nombres de otra tradición: los fijos (bizantino, japonés, lü) en toda la orden, como
        // una escritura más; los móviles (sargam, jianpu), solo en `escala`, que tiene tónica (SistemaMovil).
        // Con --grafia, la de los sistemas y, en ruso y en griego, la de las notas y los textos (--idioma ru
        // --grafia transliterada es --idioma ru-latn).
        var grafiaElegida: Grafia?
        switch opciones.quitarOpcion(.grafia) {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = grafia(texto) else { return uso(.grafiaNoValida(texto), notacion) }
            grafiaElegida = elegida
        }
        var movil: SistemaMovil?
        switch opciones.quitarOpcion(.sistema) {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let sistema = SistemaDeNombres(nombre: texto) else {
                return uso(.sistemaDesconocido(texto), notacion)
            }
            if let conSistema = Notacion.sistema(
                sistema, grafia: grafiaElegida ?? .transliterada, textos: notacion.textos)
            {
                notacion = conSistema
            } else {
                movil = SistemaMovil(sistema: sistema, grafia: grafiaElegida ?? .transliterada, nombre: texto)
            }
        }
        // La octava va como la escriba la notación (en subíndice en las compactas, con cifras en las demás), salvo
        // con --subindices o --cifras.
        let subindices = opciones.quitarMarca(.subindices)
        let cifras = opciones.quitarMarca(.cifras)
        if subindices {
            notacion = notacion.conOctavas(.subindices)
        } else if cifras {
            notacion = notacion.conOctavas(.cifras)
        }
        if let grafiaElegida, notacion.sistemaDeNombres == nil { notacion = notacion.conGrafia(grafiaElegida) }
        // Con --json, las órdenes que lo admiten dan sus datos en JSON (LineaDeComandos+JSON.swift y Ordenes/*/+JSON).
        let json = opciones.quitarMarca(.json)
        // Con -o, lo que da la orden va a ese fichero (`-o -`, a la salida estándar, aunque sea un fichero binario).
        var destino: String?
        switch opciones.quitarOpcion(.salida) {
        case .ausente:
            break
        case .sinValor(let nombre):
            // «-o» a secas, con su nombre largo.
            return uso(.faltaValor(nombre.isEmpty ? "salida" : nombre), notacion)
        case .valor(let ruta):
            destino = ruta
        }
        let argumentos = opciones.restantes

        guard let nombre = argumentos.first?.lowercased() else {
            return bien(indiceDeAyuda(en: notacion.textos, grafia: notacion.grafiaDeLosTextos))
        }
        guard let orden = orden(llamada: nombre) else { return uso(.ordenDesconocida(nombre), notacion) }
        var resto = Array(argumentos.dropFirst())

        // Toda la ayuda (`armonia ayuda --todo`) y la de una orden: `armonia ayuda acorde`, `armonia acorde --help`.
        if orden.nombres.contains("ayuda"), let pedida = resto.first?.lowercased() {
            if marcasDeToda.contains(pedida) { return bien(ayuda(en: notacion)) }
            guard let otra = self.orden(llamada: pedida) else { return uso(.ordenDesconocida(pedida), notacion) }
            return bien(ayuda(de: otra, en: notacion))
        }
        if resto.contains(where: marcasDeAyuda.contains) { return bien(ayuda(de: orden, en: notacion)) }
        // Un sistema móvil nombra grados: solo `escala`, que tiene tónica, sabe qué nombre lleva cada nota.
        if let movil, !orden.nombres.contains("escala") { return uso(.sistemaMovil(movil.nombre), notacion) }

        let estandar = entrada.map(EntradaEstandar.init)
        if let estandar {
            resto = conLaEntrada(resto, de: orden, estandar, entradaEsTerminal: entradaEsTerminal)
        }

        // Los errores de uso de la orden remiten a su ayuda y proponen sus opciones (ErrorDeUso.mensajeDeUso(en:enCurso:)).
        let enCurso = orden.nombres.contains("ayuda") ? nil : OrdenEnCurso(orden: orden, nombre: nombre)
        let contexto = ContextoDeOrden(notacion: notacion, entrada: estandar, movil: movil)
        let resultado = conLasNotasDelIdioma(resto, en: notacion) { resto in
            ejecutar(
                orden, nombre: nombre, resto, json: json, salidaEsTerminal: salidaEsTerminal, contexto,
                enCurso: enCurso)
        }
        if let destino, destino != "-", resultado.codigo == 0 || resultado.codigo == 3 {
            return escribir(resultado, en: destino, notacion)
        }
        // Un fichero binario no se escribe en la terminal.
        if resultado.datos != nil, salidaEsTerminal, destino == nil {
            return ResultadoDeOrden(
                salida: "", error: "armonia: " + TextosDeConsola.en(notacion, \.salidaBinaria) + "\n", codigo: 2)
        }
        return resultado
    }

    /// Ejecuta la orden ya elegida, con sus argumentos, y recoge sus errores.
    static func ejecutar(
        _ orden: Orden, nombre: String, _ resto: [String], json: Bool, salidaEsTerminal: Bool,
        _ contexto: ContextoDeOrden, enCurso: OrdenEnCurso?
    ) -> ResultadoDeOrden {
        let notacion = contexto.notacion
        do {
            guard json else { return try orden.ejecutar(resto, contexto) }
            guard let salida = orden.json else {
                return uso(.sinSalidaJSON(nombre), notacion, enCurso: enCurso)
            }
            let datos = try salida(resto, contexto)
            let texto = try textoJSON(datos, enUnaLinea: !salidaEsTerminal)
            let conFaltas = (datos as? any ConFaltas)?.hayFaltas ?? false
            return ResultadoDeOrden(salida: texto + "\n", error: "", codigo: conFaltas ? 3 : 0)
        } catch let error as ErrorDeUso {
            return uso(error, notacion, enCurso: enCurso)
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
            let texto = TextosDeConsola.en(notacion) { $0.archivoNoEscrito(ruta) }
            return ResultadoDeOrden(salida: "", error: resultado.error + "armonia: " + texto + "\n", codigo: 1)
        }
        return ResultadoDeOrden(salida: "", error: resultado.error, codigo: resultado.codigo)
    }

    /// La orden que se llama así (en minúsculas), con cualquiera de sus nombres y con tildes o sin ellas
    /// (`cuadrícula`, `conducción-mínima`).
    static func orden(llamada nombre: String) -> Orden? {
        let nombre = Argumentos.sinTildes(nombre)
        return ordenes.first { $0.nombres.contains(nombre) }
    }

    /// Lo que pide toda la ayuda tras `ayuda`, en lugar del índice: `armonia ayuda --todo`.
    static let marcasDeToda: Set = ["--todo", "--all", "todo", "all"]

    /// Lo que pide la ayuda de una orden en lugar de ejecutarla: `armonia acorde --help`.
    static let marcasDeAyuda: Set = ["--help", "-h", "--ayuda"]

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
        guard argumentos.isEmpty, !entradaEsTerminal, orden.leeLaEntrada else {
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

    }

    /// Lo que una orden recibe además de sus argumentos: la notación, la entrada estándar (la de `--archivo -`) y el
    /// sistema móvil de `--sistema`, si lo hay.
    struct ContextoDeOrden: Sendable {
        let notacion: Notacion
        var entrada: EntradaEstandar? = nil
        var movil: SistemaMovil? = nil
    }

    /// Lo que hay en un fichero de `--archivo`: la entrada estándar si es `-`. Lanza `ArchivoIlegible` si no se puede
    /// leer, y `ejecutar` lo escribe como un error de lectura (código 1), sin remitir a la ayuda.
    static func datos(deArchivo ruta: String, _ contexto: ContextoDeOrden) throws -> Data {
        guard let leidos = ruta == "-" ? contexto.entrada?.datos : FileManager.default.contents(atPath: ruta)
        else { throw ArchivoIlegible(ruta: ruta) }
        return leidos
    }

    /// La orden que se está ejecutando y el nombre con que se ha llamado, para que sus errores de uso remitan a su
    /// ayuda (`armonia ayuda acorde`) y propongan sus opciones.
    struct OrdenEnCurso: Sendable {
        let orden: Orden
        let nombre: String
    }

    // MARK: Órdenes

    /// Una orden de `armonia`: los nombres con que se escribe (en minúsculas), sus entradas de la ayuda, sus opciones,
    /// lo que da con `--json` y lo que hace con el resto de los argumentos. Una orden nueva es una entrada más en uno
    /// de los `ordenesDe…`, y de ahí salen a la vez su ejecución, su ayuda, su autocompletado y las propuestas ante
    /// una opción mal escrita.
    struct Orden: Sendable {
        let nombres: [String]
        let ayuda: [EntradaDeAyuda]
        /// Sus opciones, sin las generales (`generales`): las de sus entradas de la ayuda (`EntradaDeAyuda.opciones`),
        /// salvo que se den otras.
        let declaradas: [OpcionDeOrden]
        /// Los nombres de sus opciones que se enseñan y se completan, en español y en inglés.
        let opciones: [String]
        /// Lo que da con `--json`; `nil` si no lo admite.
        let json: SalidaJSON?
        /// Si, sin argumentos y con la entrada estándar de un fichero o de otro programa, toma de ella sus palabras
        /// (`conLaEntrada`). Las que no leen nada (la ayuda, la versión, los motores, el completado y el manual) no
        /// la esperan.
        let leeLaEntrada: Bool
        let ejecutar: @Sendable (_ argumentos: [String], _ contexto: ContextoDeOrden) throws -> ResultadoDeOrden

        init(
            nombres: [String], ayuda: [EntradaDeAyuda], opciones: [OpcionDeOrden]? = nil, json: SalidaJSON? = nil,
            leeLaEntrada: Bool = true,
            ejecutar:
                @escaping @Sendable (_ argumentos: [String], _ contexto: ContextoDeOrden) throws -> ResultadoDeOrden
        ) {
            self.nombres = nombres
            self.ayuda = ayuda
            var unicas: [OpcionDeOrden] = []
            for opcion in opciones ?? ayuda.flatMap(\.opciones) where !unicas.contains(opcion) { unicas.append(opcion) }
            declaradas = unicas
            var visibles: [String] = []
            for nombre in unicas.flatMap(\.nombres) where !visibles.contains(nombre) { visibles.append(nombre) }
            self.opciones = visibles
            self.json = json
            self.leeLaEntrada = leeLaEntrada
            self.ejecutar = ejecutar
        }
    }

    /// Las órdenes por grupos, como salen en el índice de la ayuda; los títulos están en
    /// `TextosDeConsola.gruposDeLaAyuda`, en el mismo orden.
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

    /// Un fichero de `--archivo` que no se puede leer (`datos(deArchivo:)`). No es un error de uso, sino de lectura:
    /// sale con el código 1, como los del motor.
    struct ArchivoIlegible: ErrorDeArmonia {
        let ruta: String

        func descripcion(en notacion: Notacion) -> String {
            TextosDeConsola.en(notacion) { $0.archivoIlegible(ruta) }
        }
    }

    /// El error de uso, con la ayuda de la orden en curso si la hay.
    static func uso(_ error: ErrorDeUso, _ notacion: Notacion, enCurso: OrdenEnCurso? = nil) -> ResultadoDeOrden {
        ResultadoDeOrden(salida: "", error: error.mensajeDeUso(en: notacion, enCurso: enCurso), codigo: 2)
    }

    /// La ayuda en el idioma de los textos de la notación (`Notacion.textos`).
    /// Todas salen de la tabla de `Ayuda.swift`: `ayuda(en: .delIdioma(.catalan))` es la de
    /// `armonia ayuda --idioma ca`.
    public static func ayuda(en notacion: Notacion) -> String {
        if notacion.grafiaDeLosTextos != .original {
            return textoDeAyuda(en: notacion.textos, grafia: notacion.grafiaDeLosTextos)
        }
        return ayudas[notacion.textos] ?? textoDeAyuda(en: notacion.textos)
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
        if t == "ascii" && idioma.reglas.tieneVariantes { return .ascii(idioma) }
        return nil
    }

    static let escriturasConPalabras = ["palabras", "words", "worte", "szavak"]
    static let escriturasCompactas = ["compacto", "compact", "unicode", "kompakt", "tomor"]
    /// Lo que se puede escribir tras `--escritura`, para proponerlo ante una errata.
    /// Los nombres de `--grafia`, en español y en inglés.
    static let nombresDeLasGrafias: [(String, Grafia)] = [
        ("original", .original), ("transliterada", .transliterada), ("transliterated", .transliterada),
        ("ascii", .ascii),
    ]

    /// La grafía de `--grafia`, sin importar las mayúsculas ni las tildes.
    static func grafia(_ texto: String) -> Grafia? {
        let clave = texto.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        return nombresDeLasGrafias.first { $0.0 == clave }?.1
    }

    static var nombresDeLasEscrituras: [String] { escriturasConPalabras + escriturasCompactas + ["ascii"] }

    /// La notación de `ARMONIA_IDIOMA`: la de su idioma, como `--idioma`; con `sistema` (o `system`), la del idioma
    /// de `LC_ALL`, `LC_MESSAGES` o `LANG` (el primero que haya), o la española si no es ninguno de los trece
    /// (`C`, `POSIX`); sin la variable, la española. Un idioma que no se conoce es un error de uso.
    static func notacionDelEntorno(_ entorno: [String: String]) -> Result<Notacion, ErrorDeUso> {
        guard let valor = entorno["ARMONIA_IDIOMA"]?.trimmingCharacters(in: .whitespaces), !valor.isEmpty else {
            return .success(.compacta(.espanol))
        }
        if ["sistema", "system"].contains(valor.lowercased()) {
            let local = ["LC_ALL", "LC_MESSAGES", "LANG"].lazy.compactMap { entorno[$0] }.first { !$0.isEmpty }
            return .success(local.flatMap(Idioma.init(codigo:)).map(Notacion.delIdioma) ?? .compacta(.espanol))
        }
        guard let notacion = notacionDelIdioma(valor) else {
            return .failure(ErrorDeUso.idiomaDesconocido("ARMONIA_IDIOMA=" + valor))
        }
        return .success(notacion)
    }

    /// La notación de `--idioma`: es, en, ca, gl, eu, pt, fr, it, de, el, ru, hu o sv, o el nombre del idioma. Con
    /// «-latn» detrás (ru-latn, el-latn, como en las etiquetas de idioma), en el alfabeto latino: con la grafía
    /// transliterada.
    static func notacionDelIdioma(_ texto: String) -> Notacion? {
        let sufijos = ["-latn", "_latn", "-latin", "-latino"]
        if let sufijo = sufijos.first(where: { texto.lowercased().hasSuffix($0) }) {
            return notacionDelIdioma(String(texto.dropLast(sufijo.count)))?.conGrafia(.transliterada)
        }
        return (try? Idioma(leyendo: texto)).map(Notacion.delIdioma)
    }
}

/// El sistema móvil de `--sistema` (sargam, jianpu…), que no va en la notación porque nombra grados: `escala` escribe
/// con él los de la escala, desde su tónica.
struct SistemaMovil: Sendable {
    let sistema: SistemaDeNombres
    let grafia: Grafia
    /// Como se ha escrito, para los errores.
    let nombre: String
}
