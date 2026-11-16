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
        #expect(mal.contains(#""isError":true"#))
        let fallo = try #require(try estructurado(mal)["error"] as? [String: Any])
        #expect(fallo["tipo"] as? String == "notaNoReconocida")
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
        // Las opciones, cada una en su propiedad: las marcas como booleanos y las de valor como texto, con sus
        // valores en `enum` y su explicación de la ayuda.
        let escalas = try #require(ServidorMCP.herramientas.first { $0.nombres[0] == "escalas" })
        let esquema = try #require(servidor.descripcion(de: escalas)["inputSchema"] as? [String: Any])
        #expect(esquema["additionalProperties"] as? Bool == false)
        let propiedades = try #require(esquema["properties"] as? [String: [String: Any]])
        #expect(propiedades["argumentos"]?["type"] as? String == "string")
        #expect(propiedades["vakra"]?["type"] as? String == "boolean")
        #expect(propiedades["tradicion"]?["type"] as? String == "string")
        #expect((propiedades["agrupar"]?["enum"] as? [String])?.contains("epoca") == true)
        let madre = try #require(propiedades["madre"]?["description"] as? String)
        #expect(madre.hasPrefix("--madre Kharaharapriyā"), Comment(rawValue: madre))
        #expect(Set(propiedades.keys) == Set(escalas.conJSON.map(ServidorMCP.propiedad)).union(["argumentos"]))
        // Toda orden con opciones ofrece las que dan JSON, y cada una con su explicación.
        for orden in ServidorMCP.herramientas {
            let suyas = try #require(
                (servidor.descripcion(de: orden)["inputSchema"] as? [String: Any])?["properties"]
                    as? [String: [String: Any]])
            for opcion in orden.conJSON {
                let propiedad = ServidorMCP.propiedad(opcion)
                #expect(suyas[propiedad]?["description"] != nil, "\(orden.nombres[0]) \(propiedad)")
            }
            for opcion in orden.sinJSON {
                #expect(suyas[ServidorMCP.propiedad(opcion)] == nil, "\(orden.nombres[0]) \(opcion.nombres[0])")
            }
        }
        // Dar las opciones como propiedades es lo mismo que escribirlas detrás.
        func datos(_ argumentos: String) throws -> String {
            let respuesta = try #require(
                servidor.responder(
                    a: #"{"jsonrpc":"2.0","id":10,"method":"tools/call","params":{"name":"escalas","arguments":"#
                        + argumentos + "}}"))
            #expect(respuesta.contains(#""isError":false"#), Comment(rawValue: respuesta))
            return respuesta
        }
        #expect(
            try datos(#"{"tradicion":"india","vakra":true,"notas":5}"#)
                == datos(#"{"argumentos":"--tradicion india --vakra --notas 5"}"#))
        #expect(
            try datos(#"{"argumentos":"--tradicion india","vakra":false}"#)
                == datos(#"{"argumentos":"--tradicion india"}"#))
        let ajena = try #require(
            servidor.responder(
                a:
                    #"{"jsonrpc":"2.0","id":11,"method":"tools/call","params":{"name":"escalas","arguments":{"nada":1}}}"#
            ))
        #expect(ajena.contains(#""code":-32602"#) && ajena.contains("nada"), Comment(rawValue: ajena))
        // El bucle: una respuesta por mensaje con id.
        var lineas = [#"{"jsonrpc":"2.0","id":1,"method":"ping"}"#, #"{"jsonrpc":"2.0","method":"x"}"#]
        var escritas: [String] = []
        LineaDeComandos.servidorMCP(
            leerLinea: { lineas.isEmpty ? nil : lineas.removeFirst() }, escribir: { escritas.append($0) })
        #expect(escritas.count == 1)
        let sesion = resultado("mcp")
        #expect(sesion.codigo == 2 && sesion.error.contains("mcp se ejecuta solo"))
    }

    /// Las opciones que solo dan texto están declaradas en su orden, y con `--json` dan `sinSalidaJSON`, no «opción
    /// desconocida»; las que no, se leen también con `--json`.
    @Test func lasOpcionesSinJSON() {
        for orden in LineaDeComandos.ordenes where orden.json != nil {
            for opcion in orden.sinJSON {
                let nombre = "\(orden.nombres[0]) \(opcion.nombres[0])"
                #expect(orden.declaradas.contains(opcion), Comment(rawValue: nombre))
                let palabras = [orden.nombres[0], opcion.nombres[0]] + (opcion.llevaValor ? ["Do"] : []) + ["--json"]
                let resultado = LineaDeComandos.ejecutar(palabras)
                #expect(resultado.codigo == 2 && resultado.error.contains("sinSalidaJSON"), Comment(rawValue: nombre))
            }
        }
        #expect(resultado("analizar", "Do", "Fa", "Sol7", "Do", "--escalas", "--json").error.contains("sinSalidaJSON"))
        #expect(resultado("analizar", "Do", "Fa", "Sol7", "Do", "--estadisticas", "--json").codigo == 0)
        // --bajo-cifrado es de realizar, también en su ayuda.
        let realizar = LineaDeComandos.ordenes.first { $0.nombres[0] == "realizar" }
        let analizar = LineaDeComandos.ordenes.first { $0.nombres[0] == "analizar" }
        #expect(realizar?.declaradas.contains(.bajoCifrado) == true)
        #expect(analizar?.declaradas.contains(.bajoCifrado) == false)
        #expect(salida("ayuda realizar").contains("--bajo-cifrado"))
        #expect(!salida("ayuda analizar").contains("--bajo-cifrado"))
        #expect(
            resultado("realizar", "La", "Fa:6", "Mi:#", "La", "--bajo-cifrado", "--en", "La menor", "--json").codigo
                == 0)
    }
}
