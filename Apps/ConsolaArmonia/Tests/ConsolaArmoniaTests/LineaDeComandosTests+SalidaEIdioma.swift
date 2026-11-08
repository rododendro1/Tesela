import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de `-o fichero` y de las notas escritas en el idioma de `--idioma`.

extension LineaDeComandosTests {
    /// Con `-o`, lo que da la orden va al fichero, también un fichero binario y también en la sesión.
    @Test func salidaAUnFichero() throws {
        let texto = try fichero(Data(), extension: "txt")
        let conO = resultado("acorde", "Sol7", "-o", texto)
        #expect(conO == ResultadoDeOrden(salida: "", error: "", codigo: 0))
        #expect(try String(contentsOfFile: texto, encoding: .utf8) == salida("acorde Sol7"))

        // Un MIDI se escribe aunque la salida sea la terminal.
        let midi = try fichero(Data(), extension: "mid")
        let grabado = LineaDeComandos.ejecutar(
            ["midi", "acordes", "Do", "Sol", "--salida", midi], salidaEsTerminal: true)
        #expect(grabado.codigo == 0 && grabado.salida.isEmpty)
        #expect(try Data(contentsOf: URL(fileURLWithPath: midi)).starts(with: Data("MThd".utf8)))

        // `-o -` es la salida estándar, aunque sea la terminal.
        let alTerminal = LineaDeComandos.ejecutar(["midi", "acordes", "Do", "-o", "-"], salidaEsTerminal: true)
        #expect(alTerminal.codigo == 0 && alTerminal.datos != nil)

        // Con una orden que falla, el fichero no se toca.
        try Data("antes".utf8).write(to: URL(fileURLWithPath: texto))
        #expect(resultado("acorde", "Xx", "-o", texto).codigo == 1)
        #expect(try String(contentsOfFile: texto, encoding: .utf8) == "antes")

        // Un fichero que no se puede escribir, código 1; sin la ruta, error de uso.
        let malo = resultado("acorde", "Sol7", "-o", "/no/existe/acorde.txt")
        #expect(malo.codigo == 1 && malo.error.contains("no se puede escribir el fichero «/no/existe/acorde.txt»"))
        #expect(resultado("acorde", "Sol7", "-o").codigo == 2)
        #expect(LineaDeComandos.opcionesGenerales.contains("-o"))
        for idioma in Idioma.allCases {
            #expect(TextosDeConsola.en(.delIdioma(idioma)) { $0.archivoNoEscrito("x") }.contains("x"))
        }

        // En la sesión, sin «>».
        let enLaSesion = try fichero(Data(), extension: "mid")
        var lineas = ["midi acordes Do Fa Sol Do -o \(enLaSesion)"]
        var escritos: [ResultadoDeOrden] = []
        LineaDeComandos.sesion(
            leerLinea: { lineas.isEmpty ? nil : lineas.removeFirst() }, escribir: { escritos.append($0) })
        #expect(escritos.count == 2 && escritos[1].codigo == 0)
        #expect(try Data(contentsOf: URL(fileURLWithPath: enLaSesion)).starts(with: Data("MThd".utf8)))
    }

    /// Con `--idioma`, las notas se leen también en ese idioma.
    @Test func notasEnElIdiomaElegido() {
        #expect(salida("acorde H7 --idioma de").hasPrefix("H7: Dominantseptakkord\n  Noten: H Dis Fis A"))
        #expect(salida("acorde Fis7 --idioma de").hasPrefix("Fis7:"))
        #expect(salida("acorde B7 --idioma de").contains("Noten: B D F As"))
        #expect(salida("acorde H7/Fis --idioma de").hasPrefix("H7/Fis:"))
        #expect(salida("acorde Ré7 --idioma fr").hasPrefix("Ré7: septième de dominante"))
        #expect(salida("acorde ре7 --idioma ru").hasPrefix("Ре7:"))
        #expect(salida("intervalo H Fis --idioma de").hasPrefix("reine Quinte"))
        // Lo que ya se leía sigue igual.
        #expect(salida("acorde Do7 --idioma de").hasPrefix("C7:"))
        #expect(salida("acorde Asus4 --idioma de").hasPrefix("Asus4:"))
        #expect(salida("escala Fis dorisch --idioma de").hasPrefix("Fis dorisch\n"))
        #expect(salida("escala ré dorien --idioma fr").hasPrefix("ré dorien\n"))
        #expect(salida("tonalidad C dur --idioma de").hasPrefix("C-Dur\n"))
        // Sin --idioma, H no es una nota.
        #expect(resultado("acorde", "H7").codigo == 1)

        let aleman = Notacion.delIdioma(.aleman)
        #expect(LineaDeComandos.notasEnEspanol("H7", en: aleman) == "Si7")
        #expect(LineaDeComandos.notasEnEspanol("B", en: aleman) == "Sib")
        #expect(LineaDeComandos.notasEnEspanol("dur", en: aleman) == "dur")
        #expect(LineaDeComandos.notasEnEspanol("--json", en: aleman) == "--json")
        #expect(LineaDeComandos.notasEnEspanol("H7", en: .compacta(.espanol)) == "H7")
    }
}
