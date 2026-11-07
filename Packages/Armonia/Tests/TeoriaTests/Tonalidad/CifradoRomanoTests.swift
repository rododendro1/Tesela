import Testing

@testable import Elementos
@testable import Teoria

@Suite struct CifradoRomanoTests {
    private let doMayor = Tonalidad(.do)
    private let laMenor = Tonalidad(.la, .menor)

    // MARK: Un acorde

    @Test func diatonicosEInversiones() throws {
        #expect(try doMayor.acorde(romano: "I") == Acorde("Do"))
        #expect(try doMayor.acorde(romano: "vi") == Acorde("Lam"))
        #expect(try doMayor.acorde(romano: "vii°") == Acorde("Si°"))
        #expect(try doMayor.acorde(romano: "I6") == Acorde("Do/Mi"))
        #expect(try doMayor.acorde(romano: "I64") == Acorde("Do/Sol"))
        #expect(try doMayor.acorde(romano: "V7") == Acorde("Sol7"))
        #expect(try doMayor.acorde(romano: "V65") == Acorde("Sol7/Si"))
        #expect(try doMayor.acorde(romano: "V43") == Acorde("Sol7/Re"))
        #expect(try doMayor.acorde(romano: "V42") == Acorde("Sol7/Fa"))
        #expect(try doMayor.acorde(romano: "V2") == Acorde("Sol7/Fa"))
        #expect(try doMayor.acorde(romano: "ii65") == Acorde("Rem7/Fa"))
        #expect(try doMayor.acorde(romano: "Imaj7") == Acorde("Domaj7"))
        #expect(try doMayor.acorde(romano: "viiø7") == Acorde(.si, .semidisminuido))
        #expect(try doMayor.acorde(romano: " V7 ") == Acorde("Sol7"))
    }

    @Test func enMenor() throws {
        #expect(try laMenor.acorde(romano: "i") == Acorde("Lam"))
        #expect(try laMenor.acorde(romano: "V7") == Acorde("Mi7"))
        #expect(try laMenor.acorde(romano: "VII") == Acorde("Sol"))
        #expect(try laMenor.acorde(romano: "vii°7") == Acorde("Sol#°7"))
        #expect(try laMenor.acorde(romano: "VI") == Acorde("Fa"))
        #expect(try laMenor.acorde(romano: "iiø7") == Acorde(.si, .semidisminuido))
    }

    @Test func alteradosYPrestados() throws {
        #expect(try doMayor.acorde(romano: "♭VI") == Acorde("Lab"))
        #expect(try doMayor.acorde(romano: "bVII") == Acorde("Sib"))
        #expect(try doMayor.acorde(romano: "♭III") == Acorde("Mib"))
        #expect(try doMayor.acorde(romano: "iv") == Acorde("Fam"))
        #expect(try doMayor.acorde(romano: "#iv°7") == Acorde("Fa#°7"))
        #expect(try doMayor.acorde(romano: "♭II6") == Acorde("Reb/Fa"))
        #expect(try doMayor.acorde(romano: "N6") == Acorde("Reb/Fa"))
        #expect(try doMayor.acorde(romano: "N") == Acorde("Reb"))
    }

    @Test func secundariasYSustitutos() throws {
        #expect(try doMayor.acorde(romano: "V7/V") == Acorde("Re7"))
        #expect(try doMayor.acorde(romano: "V/vi") == Acorde("Mi"))
        #expect(try doMayor.acorde(romano: "V65/ii") == Acorde("La7/Do#"))
        #expect(try doMayor.acorde(romano: "vii°7/V") == Acorde("Fa#°7"))
        #expect(try doMayor.acorde(romano: "V/V/V") == Acorde("La"))
        #expect(try doMayor.acorde(romano: "subV7") == Acorde("Reb7"))
        #expect(try doMayor.acorde(romano: "subV7/ii") == Acorde("Mib7"))
        // El destino ha de ser una tríada mayor o menor.
        #expect(
            throws: ErrorDeLecturaDeTeoria(texto: "V/vii°", posicion: 2, motivo: .destinoNoTonicalizable("vii°"))
        ) { try doMayor.acorde(romano: "V/vii°") }
    }

    @Test func sextasAumentadas() throws {
        #expect(try doMayor.acorde(romano: "It+6") == Acorde("Lab(#6,omit5)"))
        #expect(try doMayor.acorde(romano: "Fr+6") == Acorde("Lab(#6,#11,omit5)"))
        #expect(try doMayor.acorde(romano: "Ger+6") == Acorde("Lab(#6)"))
        #expect(try laMenor.acorde(romano: "It+6") == Acorde("Fa(#6,omit5)"))
    }

    @Test func cifradosQueNoSeLeen() throws {
        #expect(throws: ErrorDeLectura(texto: " ", posicion: nil, motivo: .textoVacio)) {
            try doMayor.acorde(romano: " ")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "X", posicion: 0, motivo: .cifradoRomanoNoValido("X"))) {
            try doMayor.acorde(romano: "X")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "Vi", posicion: 0, motivo: .cifradoRomanoNoValido("Vi"))) {
            try doMayor.acorde(romano: "Vi")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "V7/", posicion: 2, motivo: .cifradoRomanoNoValido("V7/"))) {
            try doMayor.acorde(romano: "V7/")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "Vzz", posicion: 0, motivo: .cifradoRomanoNoValido("Vzz"))) {
            try doMayor.acorde(romano: "Vzz")
        }
        // El error está donde empieza lo que no se lee: tras la barra, en el destino.
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "V7/X", posicion: 3, motivo: .cifradoRomanoNoValido("X"))) {
            try doMayor.acorde(romano: "V7/X")
        }
        // El mensaje dice dónde y por qué.
        let error = ErrorDeLecturaDeTeoria(texto: "V/vii°", posicion: 2, motivo: .destinoNoTonicalizable("vii°"))
        #expect(error.description.hasPrefix("No se puede leer «V/vii°» (carácter 3): «vii°» no puede ir tras la barra"))
    }

    // MARK: Una progresión

    @Test func progresiones() throws {
        #expect(try doMayor.acordes(romanos: "I vi ii65 V7 I") == ["Do", "Lam", "Rem7/Fa", "Sol7", "Do"])
        #expect(try doMayor.acordes(romanos: "I - IV - V7 - I") == ["Do", "Fa", "Sol7", "Do"])
        #expect(try doMayor.acordes(romanos: "I | V7/V | V7 | I") == ["Do", "Re7", "Sol7", "Do"])
        #expect(try laMenor.acordes(romanos: "i iv V7 i") == ["Lam", "Rem", "Mi7", "Lam"])
        #expect(throws: ErrorDeLectura(texto: " | ", posicion: nil, motivo: .textoVacio)) {
            try doMayor.acordes(romanos: " | ")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "I X V", posicion: 2, motivo: .cifradoRomanoNoValido("X"))) {
            try doMayor.acordes(romanos: "I X V")
        }
        #expect(
            throws: ErrorDeLecturaDeTeoria(texto: "I V7/vii° I", posicion: 5, motivo: .destinoNoTonicalizable("vii°"))
        ) { try doMayor.acordes(romanos: "I V7/vii° I") }
    }

    /// Leer los cifrados del análisis y analizar sus acordes da los mismos cifrados.
    @Test func idaYVueltaConElAnalisis() throws {
        let progresiones: [(Tonalidad, String)] = [
            (doMayor, "I vi ii65 V7 I"),
            (doMayor, "I V7/V V7 I"),
            (doMayor, "I ♭VI ♭VII I"),
            (doMayor, "I ♭II6 V I"),
            (doMayor, "I subV7/ii ii V7 I"),
            (doMayor, "I Ger+6 I64 V7 I"),
            (doMayor, "I V/vi vi"),
            (doMayor, "I vii°7/V V I"),
            (doMayor, "IV V43 I6"),
            (laMenor, "i iiø65 V7 i"),
            (laMenor, "i VI III VII"),
            (laMenor, "i iv6 V i"),
        ]
        for (tonalidad, texto) in progresiones {
            let acordes = try tonalidad.acordes(romanos: texto)
            let cifrados = texto.split(separator: " ").map(String.init)
            #expect(tonalidad.analizar(acordes).cifrados == cifrados, "\(texto)")
        }
    }
}
