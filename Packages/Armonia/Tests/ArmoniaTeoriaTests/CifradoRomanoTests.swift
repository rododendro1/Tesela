import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct CifradoRomanoTests {
    private let doMayor = Tonalidad(.do)
    private let laMenor = Tonalidad(.la, .menor)

    // MARK: Un acorde

    @Test func diatonicosEInversiones() {
        #expect(doMayor.acorde(romano: "I") == Acorde("Do"))
        #expect(doMayor.acorde(romano: "vi") == Acorde("Lam"))
        #expect(doMayor.acorde(romano: "vii°") == Acorde("Si°"))
        #expect(doMayor.acorde(romano: "I6") == Acorde("Do/Mi"))
        #expect(doMayor.acorde(romano: "I64") == Acorde("Do/Sol"))
        #expect(doMayor.acorde(romano: "V7") == Acorde("Sol7"))
        #expect(doMayor.acorde(romano: "V65") == Acorde("Sol7/Si"))
        #expect(doMayor.acorde(romano: "V43") == Acorde("Sol7/Re"))
        #expect(doMayor.acorde(romano: "V42") == Acorde("Sol7/Fa"))
        #expect(doMayor.acorde(romano: "V2") == Acorde("Sol7/Fa"))
        #expect(doMayor.acorde(romano: "ii65") == Acorde("Rem7/Fa"))
        #expect(doMayor.acorde(romano: "Imaj7") == Acorde("Domaj7"))
        #expect(doMayor.acorde(romano: "viiø7") == Acorde(.si, .semidisminuido))
        #expect(doMayor.acorde(romano: " V7 ") == Acorde("Sol7"))
    }

    @Test func enMenor() {
        #expect(laMenor.acorde(romano: "i") == Acorde("Lam"))
        #expect(laMenor.acorde(romano: "V7") == Acorde("Mi7"))
        #expect(laMenor.acorde(romano: "VII") == Acorde("Sol"))
        #expect(laMenor.acorde(romano: "vii°7") == Acorde("Sol#°7"))
        #expect(laMenor.acorde(romano: "VI") == Acorde("Fa"))
        #expect(laMenor.acorde(romano: "iiø7") == Acorde(.si, .semidisminuido))
    }

    @Test func alteradosYPrestados() {
        #expect(doMayor.acorde(romano: "♭VI") == Acorde("Lab"))
        #expect(doMayor.acorde(romano: "bVII") == Acorde("Sib"))
        #expect(doMayor.acorde(romano: "♭III") == Acorde("Mib"))
        #expect(doMayor.acorde(romano: "iv") == Acorde("Fam"))
        #expect(doMayor.acorde(romano: "#iv°7") == Acorde("Fa#°7"))
        #expect(doMayor.acorde(romano: "♭II6") == Acorde("Reb/Fa"))
        #expect(doMayor.acorde(romano: "N6") == Acorde("Reb/Fa"))
        #expect(doMayor.acorde(romano: "N") == Acorde("Reb"))
    }

    @Test func secundariasYSustitutos() {
        #expect(doMayor.acorde(romano: "V7/V") == Acorde("Re7"))
        #expect(doMayor.acorde(romano: "V/vi") == Acorde("Mi"))
        #expect(doMayor.acorde(romano: "V65/ii") == Acorde("La7/Do#"))
        #expect(doMayor.acorde(romano: "vii°7/V") == Acorde("Fa#°7"))
        #expect(doMayor.acorde(romano: "V/V/V") == Acorde("La"))
        #expect(doMayor.acorde(romano: "subV7") == Acorde("Reb7"))
        #expect(doMayor.acorde(romano: "subV7/ii") == Acorde("Mib7"))
        // El destino ha de ser una tríada mayor o menor.
        #expect(doMayor.acorde(romano: "V/vii°") == nil)
    }

    @Test func sextasAumentadas() {
        #expect(doMayor.acorde(romano: "It+6") == Acorde("Lab(#6,omit5)"))
        #expect(doMayor.acorde(romano: "Fr+6") == Acorde("Lab(#6,#11,omit5)"))
        #expect(doMayor.acorde(romano: "Ger+6") == Acorde("Lab(#6)"))
        #expect(laMenor.acorde(romano: "It+6") == Acorde("Fa(#6,omit5)"))
    }

    @Test func cifradosQueNoSeLeen() {
        #expect(doMayor.acorde(romano: "") == nil)
        #expect(doMayor.acorde(romano: "X") == nil)
        #expect(doMayor.acorde(romano: "Vi") == nil)
        #expect(doMayor.acorde(romano: "V7/") == nil)
        #expect(doMayor.acorde(romano: "Vzz") == nil)
    }

    // MARK: Una progresión

    @Test func progresiones() {
        #expect(doMayor.acordes(romanos: "I vi ii65 V7 I") == ["Do", "Lam", "Rem7/Fa", "Sol7", "Do"])
        #expect(doMayor.acordes(romanos: "I - IV - V7 - I") == ["Do", "Fa", "Sol7", "Do"])
        #expect(doMayor.acordes(romanos: "I | V7/V | V7 | I") == ["Do", "Re7", "Sol7", "Do"])
        #expect(laMenor.acordes(romanos: "i iv V7 i") == ["Lam", "Rem", "Mi7", "Lam"])
        #expect(doMayor.acordes(romanos: "") == nil)
        #expect(doMayor.acordes(romanos: "I X V") == nil)
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
            let acordes = try #require(tonalidad.acordes(romanos: texto), "\(texto)")
            let cifrados = texto.split(separator: " ").map(String.init)
            #expect(tonalidad.analizar(acordes).cifrados == cifrados, "\(texto)")
        }
    }
}
