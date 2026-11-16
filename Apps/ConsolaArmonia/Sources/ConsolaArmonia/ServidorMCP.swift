import Armonia
import Foundation

// `armonia mcp`: el motor como servidor del Model Context Protocol (MCP), para que un asistente lo use como
// herramienta en lugar de adivinar la teoría. Habla JSON-RPC 2.0 por la entrada y la salida estándar, un mensaje por
// línea, y ofrece como herramienta cada orden que da JSON: `acorde`, `escala`, `analizar`, `identificar`… Cada
// herramienta recibe lo que se escribiría detrás del nombre de la orden y responde con su JSON. Sus opciones van
// también, si se quiere, cada una en su propiedad, con su nombre en español sin los guiones: una marca es un booleano
// (`"acordes": true`) y una opción con valor, un texto, con sus valores en `enum` cuando se conocen
// (`"tradicion": "india"`).
//
//     → {"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"acorde","arguments":{"argumentos":"Sol7/Si"}}}
//     → {…"params":{"name":"escalas","arguments":{"tradicion":"india","vakra":true}}}
//     ← {"jsonrpc":"2.0","id":1,"result":{"content":[{"type":"text","text":"[{…}]"}],"isError":false}}

extension LineaDeComandos {
    /// Atiende los mensajes de `leerLinea` (que da `nil` al cerrarse la entrada) y escribe cada respuesta, en una
    /// línea, con `escribir`. Las opciones generales de `opciones` (`--idioma en`) valen para todas las herramientas.
    public static func servidorMCP(
        _ opciones: [String] = [], entorno: [String: String] = [:], leerLinea: () -> String?,
        escribir: (String) -> Void
    ) {
        let servidor = ServidorMCP(opciones: opciones, entorno: entorno)
        while let linea = leerLinea() {
            if let respuesta = servidor.responder(a: linea) { escribir(respuesta) }
        }
    }

    /// La orden `mcp`, para su ayuda: el ejecutable la atiende antes de llegar aquí (`servidorMCP`). Desde una sesión
    /// o un lote no se puede, porque la entrada ya es de las órdenes.
    static let ordenesDelServidor: [Orden] = [
        Orden(nombres: ["mcp"], ayuda: ayudaDelServidor, leeLaEntrada: false) { _, _ in
            throw ErrorDeUso.mcpSoloComoServidor
        }
    ]

    static let ayudaDelServidor: [EntradaDeAyuda] = [
        // mcp
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMCP),
            descripcion: TextosDeConsola.traduccion(\.descripcionMCP),
            ejemplo: ejemplo("claude mcp add armonia -- armonia mcp", "claude mcp add armonia -- armonia mcp"))
    ]
}

/// El servidor MCP: responde a cada mensaje JSON-RPC sin guardar nada entre uno y otro.
struct ServidorMCP {
    /// Las opciones generales que se añaden a cada orden.
    let opciones: [String]
    let entorno: [String: String]
    /// El idioma de las descripciones de las herramientas.
    let notacion: Notacion

    /// La versión del protocolo que se da si el cliente no pide ninguna.
    static let versionDelProtocolo = "2025-06-18"

    init(opciones: [String], entorno: [String: String]) {
        self.opciones = opciones
        self.entorno = entorno
        var argumentos = Argumentos(opciones)
        notacion =
            (try? LineaDeComandos.opcionesGenerales(&argumentos, entorno: entorno).notacion) ?? .compacta(.espanol)
    }

    /// Las órdenes que se ofrecen: las que dan JSON.
    static var herramientas: [LineaDeComandos.Orden] { LineaDeComandos.ordenes.filter { $0.json != nil } }

    /// La respuesta a una línea, en JSON y en una línea; `nil` si es una notificación (que no se responde) o si la
    /// línea está en blanco.
    func responder(a linea: String) -> String? {
        guard !linea.allSatisfy(\.isWhitespace) else { return nil }
        guard let datos = linea.data(using: .utf8),
            let mensaje = try? JSONSerialization.jsonObject(with: datos) as? [String: Any]
        else { return Self.error(id: NSNull(), codigo: -32700, "Parse error") }
        guard let metodo = mensaje["method"] as? String else {
            return mensaje["id"].map { Self.error(id: $0, codigo: -32600, "Invalid Request") }
        }
        // Una notificación no lleva id y no se responde.
        guard let id = mensaje["id"] else { return nil }
        let parametros = mensaje["params"] as? [String: Any] ?? [:]
        switch metodo {
        case "initialize":
            let pedida = parametros["protocolVersion"] as? String
            return Self.resultado(
                id: id,
                [
                    "protocolVersion": pedida ?? Self.versionDelProtocolo,
                    "capabilities": ["tools": [String: Any]()],
                    "serverInfo": ["name": "armonia", "version": LineaDeComandos.version],
                ])
        case "ping":
            return Self.resultado(id: id, [String: Any]())
        case "tools/list":
            return Self.resultado(id: id, ["tools": Self.herramientas.map(descripcion(de:))])
        case "tools/call":
            guard let nombre = parametros["name"] as? String,
                let orden = Self.herramientas.first(where: { $0.nombres[0] == nombre })
            else {
                return Self.error(id: id, codigo: -32602, "Unknown tool: \(parametros["name"] ?? "")")
            }
            let argumentos = parametros["arguments"] as? [String: Any] ?? [:]
            if let ajena = argumentos.keys.sorted().first(where: {
                Self.opcion($0, de: orden) == nil && $0 != "argumentos"
            }) {
                return Self.error(id: id, codigo: -32602, "Unknown argument: \(ajena)")
            }
            return Self.resultado(id: id, llamar(orden, argumentos))
        default:
            return Self.error(id: id, codigo: -32601, "Method not found: \(metodo)")
        }
    }

    /// Una herramienta: el nombre de la orden, su ayuda, lo que va detrás del nombre (`argumentos`) y una propiedad
    /// por cada una de sus opciones (`propiedades(de:)`).
    func descripcion(de orden: LineaDeComandos.Orden) -> [String: Any] {
        // Cada forma de escribirla, con lo que hace, su ejemplo y sus notas, sin las columnas de la terminal.
        let (idioma, grafia) = (notacion.textos, notacion.grafiaDeLosTextos)
        let ayuda = orden.ayuda.map { entrada in
            var partes = [
                entrada.sintaxis.texto(en: idioma, grafia: grafia) + ": "
                    + entrada.descripcion.texto(en: idioma, grafia: grafia)
            ]
            if let ejemplo = entrada.ejemplo?.texto(en: idioma, grafia: grafia), !ejemplo.isEmpty {
                partes.append(ejemplo)
            }
            if let notas = entrada.notas?.texto(en: idioma, grafia: grafia), !notas.isEmpty { partes.append(notas) }
            return partes.joined(separator: "\n")
        }.joined(separator: "\n\n")
        var propiedades = propiedades(de: orden)
        propiedades["argumentos"] = [
            "type": "string",
            "description": TextosDeConsola.en(notacion, \.argumentosDeLaHerramienta),
        ]
        return [
            "name": orden.nombres[0],
            "description": ayuda,
            "inputSchema": ["type": "object", "properties": propiedades, "additionalProperties": false],
        ]
    }

    /// El nombre de la propiedad de una opción: el español, sin los guiones (`--limite` → `limite`).
    static func propiedad(_ opcion: OpcionDeOrden) -> String {
        String(opcion.nombres[0].drop(while: { $0 == "-" }))
    }

    /// La opción de la orden que lleva esa propiedad; `nil` si no es ninguna.
    static func opcion(_ propiedad: String, de orden: LineaDeComandos.Orden) -> OpcionDeOrden? {
        orden.declaradas.first { Self.propiedad($0) == propiedad }
    }

    /// Una propiedad por opción de la orden: un booleano si es una marca y un texto si lleva valor, con los valores
    /// que propone el autocompletado (`LineaDeComandos.valores(de:en:)`) en `enum`, y lo que dice de ella su ayuda,
    /// en el idioma de la notación, como descripción. Toda opción declarada sale en alguna parte de su ayuda: lo
    /// comprueban las pruebas del servidor.
    func propiedades(de orden: LineaDeComandos.Orden) -> [String: Any] {
        let (idioma, grafia) = (notacion.textos, notacion.grafiaDeLosTextos)
        // Primero las partes que explican opciones («--madre Kharaharapriyā … deja las que salen de esa escala»); si
        // la opción solo sale en la prosa («con --afecto, las que tienen ese afecto»), la frase que la nombra, y si
        // solo sale en la sintaxis («analizar --archivo <fichero> [--ventana <duración>]»), esa línea.
        let partes = orden.ayuda.map { LineaDeComandos.partes(de: $0, en: idioma, grafia: grafia) }
        let frases = partes.flatMap(\.prosa).flatMap { $0.components(separatedBy: "; ") }
        let sintaxis = orden.ayuda.flatMap {
            $0.sintaxis.texto(en: idioma, grafia: grafia).components(separatedBy: "\n")
        }
        let explicaciones = (partes.flatMap(\.opciones) + frases + sintaxis).map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        var propiedades: [String: Any] = [:]
        for opcion in orden.declaradas {
            var propiedad: [String: Any] = ["type": opcion.llevaValor ? "string" : "boolean"]
            if opcion.llevaValor, let valores = LineaDeComandos.valores(de: opcion, en: orden) {
                propiedad["enum"] = valores
            }
            if let explicacion = explicaciones.first(where: { Self.nombra($0, opcion) }) {
                propiedad["description"] = explicacion
            }
            propiedades[Self.propiedad(opcion)] = propiedad
        }
        return propiedades
    }

    /// Si el texto nombra la opción por alguno de sus nombres, como palabra entera: «--escala» no está en
    /// «--escalas».
    static func nombra(_ texto: String, _ opcion: OpcionDeOrden) -> Bool {
        opcion.nombres.contains { nombre in
            var resto = texto[...]
            while let rango = resto.range(of: nombre) {
                let siguiente = resto[rango.upperBound...].first
                let anterior = rango.lowerBound == texto.startIndex ? nil : texto[texto.index(before: rango.lowerBound)]
                let aparte = { (caracter: Character?) in
                    caracter.map { !$0.isLetter && !$0.isNumber && $0 != "-" } ?? true
                }
                if aparte(anterior), aparte(siguiente) { return true }
                resto = resto[rango.upperBound...]
            }
            return false
        }
    }

    /// Lo que se escribe tras el nombre de la orden: lo de `argumentos` (un texto, que se parte como en la terminal,
    /// o una lista de palabras) y, detrás, cada opción de su propiedad. Una marca va si es `true`; una opción con
    /// valor, con su valor, sea texto o número.
    static func palabras(de orden: LineaDeComandos.Orden, _ argumentos: [String: Any]) -> [String] {
        var palabras: [String]
        if let lista = argumentos["argumentos"] as? [String] {
            palabras = lista
        } else {
            palabras = LineaDeComandos.palabras(deLaLinea: argumentos["argumentos"] as? String ?? "")
        }
        for opcion in orden.declaradas {
            guard let valor = argumentos[propiedad(opcion)] else { continue }
            if !opcion.llevaValor {
                if valor as? Bool == true { palabras.append(opcion.nombres[0]) }
            } else if let texto = valor as? String {
                palabras += [opcion.nombres[0], texto]
            } else if let numero = valor as? NSNumber {
                palabras += [opcion.nombres[0], numero.stringValue]
            }
        }
        return palabras
    }

    /// Ejecuta la orden con `--json` y da su salida como texto y, como datos, en `structuredContent`; si falla, el
    /// error en JSON, marcado como error. `structuredContent` tiene que ser un objeto: lo que da una lista
    /// (`acorde`, que puede llevar varios cifrados) va en `{"resultados": […]}`.
    func llamar(_ orden: LineaDeComandos.Orden, _ argumentos: [String: Any]) -> [String: Any] {
        let resultado = LineaDeComandos.ejecutar(
            [orden.nombres[0]] + Self.palabras(de: orden, argumentos) + opciones + ["--json"], salidaEsTerminal: false,
            entorno: entorno)
        let bien = resultado.codigo == 0 || resultado.codigo == 3
        let texto = (bien ? resultado.salida : resultado.error).trimmingCharacters(in: .newlines)
        var respuesta: [String: Any] = [
            "content": [["type": "text", "text": texto]],
            "isError": !bien,
        ]
        // El error también, que con --json sale en JSON (`ErrorEnJSON`).
        if let datos = Self.datos(texto) { respuesta["structuredContent"] = datos }
        return respuesta
    }

    /// El JSON de una orden como objeto, para `structuredContent`: una lista va en `resultados`.
    static func datos(_ texto: String) -> [String: Any]? {
        guard let leido = try? JSONSerialization.jsonObject(with: Data(texto.utf8), options: [.fragmentsAllowed])
        else { return nil }
        if let objeto = leido as? [String: Any] { return objeto }
        return ["resultados": leido]
    }

    static func resultado(id: Any, _ valor: Any) -> String {
        linea(["jsonrpc": "2.0", "id": id, "result": valor])
    }

    static func error(id: Any, codigo: Int, _ mensaje: String) -> String {
        linea(["jsonrpc": "2.0", "id": id, "error": ["code": codigo, "message": mensaje]])
    }

    /// Un mensaje en una línea, con las claves ordenadas y sin escapar las barras.
    static func linea(_ objeto: [String: Any]) -> String {
        let datos =
            (try? JSONSerialization.data(withJSONObject: objeto, options: [.sortedKeys, .withoutEscapingSlashes]))
            ?? Data()
        return String(decoding: datos, as: UTF8.self)
    }
}
