import Armonia
import Foundation

// `armonia mcp`: el motor como servidor del Model Context Protocol (MCP), para que un asistente lo use como
// herramienta en lugar de adivinar la teoría. Habla JSON-RPC 2.0 por la entrada y la salida estándar, un mensaje por
// línea, y ofrece como herramienta cada orden que da JSON: `acorde`, `escala`, `analizar`, `identificar`… Cada
// herramienta recibe lo que se escribiría detrás del nombre de la orden y responde con su JSON.
//
//     → {"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"acorde","arguments":{"argumentos":"Sol7/Si"}}}
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
            return Self.resultado(id: id, llamar(orden, argumentos["argumentos"]))
        default:
            return Self.error(id: id, codigo: -32601, "Method not found: \(metodo)")
        }
    }

    /// Una herramienta: el nombre de la orden, su ayuda y un solo argumento, lo que va detrás del nombre.
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
        return [
            "name": orden.nombres[0],
            "description": ayuda,
            "inputSchema": [
                "type": "object",
                "properties": [
                    "argumentos": [
                        "type": "string",
                        "description": TextosDeConsola.en(notacion, \.argumentosDeLaHerramienta),
                    ]
                ],
                "required": ["argumentos"],
            ],
        ]
    }

    /// Ejecuta la orden con `--json` y da su salida como texto y, como datos, en `structuredContent`; si falla, el
    /// error en JSON, marcado como error. `structuredContent` tiene que ser un objeto: lo que da una lista (`acorde`, que
    /// puede llevar varios cifrados) va en `{"resultados": […]}`.
    func llamar(_ orden: LineaDeComandos.Orden, _ argumentos: Any?) -> [String: Any] {
        let palabras: [String]
        if let lista = argumentos as? [String] {
            palabras = lista
        } else {
            palabras = LineaDeComandos.palabras(deLaLinea: argumentos as? String ?? "")
        }
        let resultado = LineaDeComandos.ejecutar(
            [orden.nombres[0]] + palabras + opciones + ["--json"], salidaEsTerminal: false, entorno: entorno)
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
