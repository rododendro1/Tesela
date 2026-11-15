import Foundation
import Testing

@testable import ConsolaArmonia

// El retículo de la entonación justa en la consola: `reticulo`, en SVG, en texto y en JSON.

extension LineaDeComandosTests {
    @Test func reticuloDeLaEntonacionJusta() {
        let svg = salida("reticulo Do Lam Rem Sol Do")
        #expect(svg.hasPrefix("<svg"), Comment(rawValue: svg))
        #expect(svg.contains("<title>Do – Lam – Rem – Sol – Do · deriva de -21.506 cents</title>"))
        let resumen = salida("reticulo Do Lam Rem Sol Do --resumen")
        #expect(resumen.hasPrefix("Do: Do 1/1 · 0 ¢\nLam: La 5/3 · -15.641 ¢\n"), Comment(rawValue: resumen))
        #expect(resumen.hasSuffix("Do: Do 160/81 · -21.506 ¢\nderiva: -21.506 cents\n"))
        #expect(
            salida("lattice C F G --summary --ingles") == "C: C 1/1 · 0 ¢\nF: F 4/3 · -1.955 ¢\nG: G 3/2 · 1.955 ¢\n")
        let json = salida("reticulo Do Sol Do --json")
        #expect(json.contains(#""deriva":0"#) && json.contains(#""razon":"3/2""#), Comment(rawValue: json))
        let vacio = resultado("reticulo")
        #expect(vacio.codigo == 2 && vacio.error.contains("armonia reticulo Do Lam Rem Sol Do"))
    }

    /// `armonia mcp`: el servidor responde a cada mensaje JSON-RPC, y no se ejecuta desde una sesión.
    @Test func servidorMCP() throws {
        let servidor = ServidorMCP(opciones: [], entorno: [:])
        let inicio = try #require(
            servidor.responder(
                a: #"{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}"#))
        #expect(inicio.contains(#""protocolVersion":"2025-03-26""#) && inicio.contains(#""name":"armonia""#))
        #expect(servidor.responder(a: #"{"jsonrpc":"2.0","method":"notifications/initialized"}"#) == nil)
        #expect(servidor.responder(a: "   ") == nil)
        let lista = try #require(servidor.responder(a: #"{"jsonrpc":"2.0","id":2,"method":"tools/list"}"#))
        #expect(lista.contains(#""name":"acorde""#) && lista.contains(#""name":"reticulo""#), Comment(rawValue: lista))
        #expect(!lista.contains(#""name":"tonnetz""#))
        let llamada = try #require(
            servidor.responder(
                a:
                    #"{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"acorde","arguments":{"argumentos":"Sol7/Si"}}}"#
            ))
        #expect(
            llamada.contains(#""isError":false"#) && llamada.contains(#"\"bajo\":\"Si\""#), Comment(rawValue: llamada))
        let lista2 = try #require(
            servidor.responder(
                a:
                    #"{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"escala","arguments":{"argumentos":["Re","dórico"]}}}"#
            ))
        #expect(lista2.contains(#""isError":false"#), Comment(rawValue: lista2))
        // Los datos, también como objeto: el de `escala` tal cual, la lista de `acorde` en `resultados`.
        func estructurado(_ respuesta: String) throws -> [String: Any] {
            let mensaje = try #require(try JSONSerialization.jsonObject(with: Data(respuesta.utf8)) as? [String: Any])
            let resultado = try #require(mensaje["result"] as? [String: Any])
            return try #require(resultado["structuredContent"] as? [String: Any])
        }
        #expect(try estructurado(lista2)["nombre"] as? String == "Re dórico")
        let acordes = try #require(try estructurado(llamada)["resultados"] as? [[String: Any]])
        #expect(acordes.first?["bajo"] as? String == "Si")
        let mal = try #require(
            servidor.responder(
                a:
                    #"{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"acorde","arguments":{"argumentos":"Xyz"}}}"#
            ))
        #expect(mal.contains(#""isError":true"#) && !mal.contains("structuredContent"))
        let desconocida = try #require(
            servidor.responder(a: #"{"jsonrpc":"2.0","id":6,"method":"tools/call","params":{"name":"nada"}}"#))
        #expect(desconocida.contains(#""code":-32602"#))
        #expect(servidor.responder(a: #"{"jsonrpc":"2.0","id":7,"method":"otra"}"#)?.contains("-32601") == true)
        #expect(servidor.responder(a: "no es JSON")?.contains("-32700") == true)
        #expect(
            servidor.responder(a: #"{"jsonrpc":"2.0","id":8,"method":"ping"}"#)
                == #"{"id":8,"jsonrpc":"2.0","result":{}}"#)
        // En inglés, con sus opciones generales.
        let ingles = ServidorMCP(opciones: ["--ingles"], entorno: [:])
        let enIngles = try #require(
            ingles.responder(
                a:
                    #"{"jsonrpc":"2.0","id":9,"method":"tools/call","params":{"name":"acorde","arguments":{"argumentos":"G7/B"}}}"#
            ))
        #expect(enIngles.contains(#"\"bajo\":\"B\""#), Comment(rawValue: enIngles))
        // El bucle: una respuesta por mensaje con id.
        var lineas = [#"{"jsonrpc":"2.0","id":1,"method":"ping"}"#, #"{"jsonrpc":"2.0","method":"x"}"#]
        var escritas: [String] = []
        LineaDeComandos.servidorMCP(
            leerLinea: { lineas.isEmpty ? nil : lineas.removeFirst() }, escribir: { escritas.append($0) })
        #expect(escritas.count == 1)
        let sesion = resultado("mcp")
        #expect(sesion.codigo == 2 && sesion.error.contains("mcp se ejecuta solo"))
    }
}
