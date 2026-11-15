import Foundation
import Testing

@testable import ConsolaArmonia

// Los ficheros de Scala en la consola: `scala temperamento`, `scala escala` y `scala --archivo`.

extension LineaDeComandosTests {
    /// `scala temperamento …`: el .scl de un temperamento; con `--kbm`, su mapa de teclado.
    @Test func scalaDeUnTemperamento() {
        let scl = salida("scala temperamento Werckmeister III")
        #expect(scl.hasPrefix("! werckmeister-iii.scl\n!\nWerckmeister III\n 12\n!\n"), Comment(rawValue: scl))
        #expect(scl.hasSuffix(" 2/1\n"))
        let justa = salida("scala temperament just --ingles")
        #expect(justa.contains("\n 5/4\n") && justa.contains("\n 3/2\n"), Comment(rawValue: justa))
        let kbm = salida("scala temperamento 53 comas --kbm")
        #expect(kbm.contains("! Map size:\n0\n"), Comment(rawValue: kbm))
        #expect(kbm.contains("! Scale degree to consider as formal octave:\n53\n"))
        let ninguno = resultado("scala", "temperamento", "inexistente")
        #expect(ninguno.codigo == 1 && ninguno.error.contains("ningún temperamento"))
    }

    /// `scala escala …`: el .scl de una escala, con sus microtonos o en un temperamento.
    @Test func scalaDeUnaEscala() {
        let bayati = salida("scala escala Re bayati")
        #expect(bayati.hasPrefix("! re-bayati.scl\n!\nRe Bayātī\n 7\n!\n 150.000000\n"), Comment(rawValue: bayati))
        let mapa = salida("scala escala Re bayati --kbm")
        #expect(mapa.hasSuffix("! Mapping.\n0\n1\nx\n2\nx\n3\nx\n4\n5\nx\n6\nx\n"), Comment(rawValue: mapa))
        let justa = salida("scala escala Do mayor --temperamento afinación justa")
        #expect(justa.contains("Do mayor (afinación justa)") && justa.contains(" 386.31"), Comment(rawValue: justa))
        let comas = resultado("scala", "escala", "Re", "mayor", "--temperamento", "53")
        #expect(comas.codigo == 2 && comas.error.contains("no afina las doce notas"), Comment(rawValue: comas.error))
        let sinNada = resultado("scala")
        #expect(sinNada.codigo == 2 && sinNada.error.contains("scala lleva temperamento"))
        let mezclado = resultado("scala", "temperamento", "Vallotti", "--temperamento", "justa")
        #expect(mezclado.codigo == 2 && mezclado.error.contains("--temperamento va con scala escala"))
        let tolerancia = resultado("scala", "escala", "Do", "mayor", "--tolerancia", "3")
        #expect(tolerancia.codigo == 2 && tolerancia.error.contains("--tolerancia va con scala --archivo"))
    }

    /// `scala --archivo …`: lo que hay en un .scl y lo que se le parece; también en JSON.
    @Test func scalaLeeUnFichero() throws {
        let ruta = FileManager.default.temporaryDirectory.appendingPathComponent("tesela-prueba-vallotti.scl")
        try Data(salida("scala temperamento Vallotti").utf8).write(to: ruta)
        defer { try? FileManager.default.removeItem(at: ruta) }
        let leido = salida("scala --archivo \(ruta.path) --tolerancia 0.01")
        #expect(leido.hasPrefix("Vallotti: 12 notas por periodo, de 1200 cents\n  0 "), Comment(rawValue: leido))
        #expect(leido.contains("Se le parece") && leido.contains("  Vallotti (temperamento) · 0 ¢\n"))
        let json = salida("scala --archivo \(ruta.path) --limite 1 --json")
        #expect(
            json.contains(#""parecidos":[{"clase":"temperamento","desde":0,"desviacion":0,"nombre":"Vallotti"}]"#),
            Comment(rawValue: json))
        let nada = salida("scala --archivo \(ruta.path) --tolerancia 0.001 --limite 1")
        #expect(nada.contains("Vallotti (temperamento)"))
        let mala = resultado("scala", "--archivo", ruta.path, "--tolerancia", "mucha")
        #expect(mala.codigo == 2 && mala.error.contains("no es una tolerancia en cents"))
        // Un fichero estropeado es un error de lectura.
        let estropeado = FileManager.default.temporaryDirectory.appendingPathComponent("tesela-prueba-mal.scl")
        try Data("Mal\n3\n100.0\n".utf8).write(to: estropeado)
        defer { try? FileManager.default.removeItem(at: estropeado) }
        let error = resultado("scala", "--archivo", estropeado.path)
        #expect(
            error.codigo == 1 && error.error.contains("dice 3 pasos y solo tiene 1"), Comment(rawValue: error.error))
        #expect(resultado("scala", "temperamento", "Vallotti", "--json").codigo == 2)
    }
}
