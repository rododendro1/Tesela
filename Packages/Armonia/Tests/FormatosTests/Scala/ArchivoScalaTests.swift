import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import Teoria

@Suite struct ArchivoScalaTests {
    @Test func leeCentsRazonesYComentarios() throws {
        let texto = """
            ! meantone.scl
            !
            Mesotónico de prueba
             4
            !
             386.3137 tercera
             3/2
            ! un comentario en medio
             5/3
             2
            """
        let scl = try ArchivoScala(leyendo: texto)
        #expect(scl.descripcion == "Mesotónico de prueba")
        #expect(scl.pasos == [.cents(386.3137), .razon(3, 2), .razon(5, 3), .razon(2, 1)])
        #expect(scl.notasPorPeriodo == 4)
        #expect(abs(scl.periodo - 1200) < 1e-9)
        #expect(scl.cents.count == 4)
        #expect(abs(scl.cents[2] - 701.955) < 1e-3)
        // Los finales de línea de Windows.
        let windows = try ArchivoScala(leyendo: texto.replacingOccurrences(of: "\n", with: "\r\n"))
        #expect(windows == scl)
    }

    @Test func avisaDeLoQueNoSePuedeLeer() {
        #expect(throws: ErrorDeLecturaDeScala.sinDescripcion) { try ArchivoScala(leyendo: "! solo\n! comentarios") }
        #expect(throws: ErrorDeLecturaDeScala.sinCuenta) { try ArchivoScala(leyendo: "Una escala") }
        #expect(throws: ErrorDeLecturaDeScala.cuentaNoValida(linea: 2, "doce")) {
            try ArchivoScala(leyendo: "Una escala\ndoce\n")
        }
        #expect(throws: ErrorDeLecturaDeScala.faltanPasos(esperados: 3, hallados: 2)) {
            try ArchivoScala(leyendo: "Una escala\n3\n100.0\n2/1")
        }
        #expect(throws: ErrorDeLecturaDeScala.pasoNoValido(linea: 4, "-3/2")) {
            try ArchivoScala(leyendo: "Una escala\n2\n100.0\n-3/2")
        }
        #expect(throws: ErrorDeLecturaDeScala.pasoNoValido(linea: 3, "3/0")) {
            try ArchivoScala(leyendo: "Una escala\n1\n3/0")
        }
        // Los mensajes, en el idioma de la notación.
        let error = ErrorDeLecturaDeScala.faltanPasos(esperados: 3, hallados: 2)
        #expect(error.description == "El fichero de Scala dice 3 pasos y solo tiene 2.")
        #expect(error.descripcion(en: .compacta(.ingles)) == "The Scala file says 3 steps but has only 2.")
    }

    @Test func escribeUnTemperamentoYLoVuelveALeer() throws {
        let scl = ArchivoScala(.werckmeisterIII)
        #expect(scl.pasos.count == 12)
        #expect(scl.pasos.last == .razon(2, 1))
        let texto = scl.texto(nombreDeArchivo: scl.nombreDeArchivo)
        #expect(texto.hasPrefix("! werckmeister-iii.scl\n!\nWerckmeister III\n 12\n!\n 90.22"))
        #expect(texto.hasSuffix(" 2/1\n"))
        let leido = try ArchivoScala(leyendo: texto)
        #expect(leido.descripcion == "Werckmeister III")
        #expect(ArchivoScala.desviacion(leido.cents, TemperamentoConNombre.werckmeisterIII.pasos) < 1e-5)
        // En inglés, con su nombre en inglés.
        #expect(ArchivoScala(.mesotonicoCuartoDeComa, en: .compacta(.ingles)).descripcion == "1/4 comma meantone")
    }

    @Test func laJustaYLosSrutiVanEnRazones() {
        let justa = ArchivoScala(.afinacionJusta)
        #expect(justa.pasos.first == .razon(25, 24))
        #expect(justa.pasos.contains(.razon(5, 4)))
        #expect(justa.pasos.contains(.razon(3, 2)))
        #expect(justa.pasos.contains(.razon(15, 8)))
        let sruti = ArchivoScala(.sruti22)
        #expect(sruti.pasos.count == 22)
        #expect(sruti.pasos.first == .razon(256, 243))
        #expect(sruti.pasos[20] == .razon(243, 128))
        // Los de 53 comas, en cents.
        let comas = ArchivoScala(.comas53)
        #expect(comas.pasos.count == 53)
        if case .cents(let cents) = comas.pasos[0] { #expect(abs(cents - 1200.0 / 53) < 1e-9) }
    }

    @Test func escribeUnaEscala() {
        let bayati = ArchivoScala(Escala(.re, .bayati))
        #expect(bayati.cents == [0, 150, 300, 500, 700, 800, 1000])
        #expect(bayati.descripcion == "Re Bayātī")
        let mayor = ArchivoScala(Escala(.do, .mayor))
        #expect(mayor.cents == [0, 200, 400, 500, 700, 900, 1100])
        // En un temperamento que afina las notas.
        let justa = ArchivoScala(Escala(.do, .mayor), temperamento: .afinacionJusta)
        #expect(abs(justa.cents[2] - 386.3137) < 1e-3)
        #expect(justa.descripcion.hasSuffix("(afinación justa)"))
    }

    @Test func buscaLoQueSeLeParece() throws {
        // Werckmeister III empezando en La: es el mismo temperamento, desde el paso 9.
        let pasos = TemperamentoConNombre.werckmeisterIII.pasos
        let desdeLa = ArchivoScala.rotados(pasos, desde: 9)
        let scl = ArchivoScala(
            descripcion: "desde La", pasos: desdeLa.dropFirst().map { .cents($0) } + [.razon(2, 1)])
        let primero = try #require(scl.parecidos(tolerancia: 0.01).first)
        #expect(primero.elemento == .temperamento(.werckmeisterIII))
        #expect(primero.desde == 9)
        // Una escala de siete notas: la mayor en temperamento igual.
        let mayor = ArchivoScala(Escala(.do, .mayor))
        #expect(mayor.parecidos(tolerancia: 0.01).map(\.elemento).contains(.escala(.mayor)))
        // Bayātī con sus cuartos de tono.
        let bayati = try ArchivoScala(leyendo: ArchivoScala(Escala(.re, .bayati)).texto())
        #expect(bayati.parecidos(tolerancia: 0.01).map(\.elemento).contains(.escala(.bayati)))
        // Un periodo que no es la octava no se parece a nada.
        let tritava = ArchivoScala(descripcion: "Bohlen-Pierce", pasos: [.cents(146.3), .razon(3, 1)])
        #expect(tritava.parecidos().isEmpty)
        #expect(mayor.parecidos(tolerancia: 0.01, limite: 1).count == 1)
    }

    @Test func nombraElFichero() {
        #expect(ArchivoScala(descripcion: "Re Bayātī", pasos: [.razon(2, 1)]).nombreDeArchivo == "re-bayati.scl")
        #expect(ArchivoScala(descripcion: "¿?", pasos: [.razon(2, 1)]).nombreDeArchivo == "escala.scl")
    }

    @Test func escribeElMapaDeTeclado() {
        let igual = MapaDeTeclado(.temperamentoIgual)
        #expect(igual.teclas == Array(0..<12).map { Optional($0) })
        #expect(abs(igual.frecuencia - 261.6256) < 1e-3)
        let texto = igual.texto(nombreDeArchivo: "igual.kbm")
        #expect(texto.hasPrefix("! igual.kbm\n!\n! Map size:\n12\n! First MIDI note number to retune:\n0\n"))
        #expect(texto.contains("! Frequency to tune the above note to:\n261.625565\n"))
        #expect(texto.hasSuffix("! Mapping.\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n"))
        // Uno de 53 comas, lineal.
        let comas = MapaDeTeclado(.comas53)
        #expect(comas.teclas.isEmpty)
        #expect(comas.gradoDelPeriodo == 53)
        // Una escala: sus grados en sus teclas, y las demás no suenan.
        let bayati = MapaDeTeclado(Escala(.re, .bayati))
        #expect(bayati.central == 62)
        #expect(bayati.gradoDelPeriodo == 7)
        #expect(bayati.teclas == [0, 1, nil, 2, nil, 3, nil, 4, 5, nil, 6, nil])
        #expect(bayati.texto().hasSuffix("! Mapping.\n0\n1\nx\n2\nx\n3\nx\n4\n5\nx\n6\nx\n"))
        // En Werckmeister III, el Do4 no está a la frecuencia del temperamento igual.
        #expect(abs(MapaDeTeclado(.werckmeisterIII).frecuencia - 261.6256) > 0.1)
    }
}
