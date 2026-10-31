import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Las notaciones y los textos en alemán, francés, italiano, occitano, griego y ruso.
final class NotacionesEuropeasTests: XCTestCase {
    func testAleman() {
        let casos: [(String, String)] = [
            ("Do", "C"), ("Fa#", "Fis"), ("Dob", "Ces"), ("Mib", "Es"), ("Mibb", "Eses"),
            ("Lab", "As"), ("Labb", "Asas"), ("Sib", "B"), ("Sibb", "Heses"), ("Si", "H"),
            ("Si#", "His"), ("Rex", "Disis"), ("Solb", "Ges"),
        ]
        for (espanol, aleman) in casos {
            let nombre = Nota(texto: espanol)!
            XCTAssertEqual(nombre.nombre(en: .aleman), aleman, espanol)
            XCTAssertEqual(try Nota(leyendo: aleman, en: .aleman), nombre, aleman)
        }
        XCTAssertEqual(try Nota(leyendo: "fis", en: .aleman), Nota("Fa#"))
        XCTAssertEqual(Altura("Fa#4").nombre(en: .aleman), "Fis4")
        XCTAssertEqual(try Altura(leyendo: "B3", en: .aleman), Altura("Sib3"))
        XCTAssertEqual(Acorde("Sib7").cifrado(en: .aleman), "B7")
        XCTAssertEqual(Acorde("Sim7").cifrado(en: .aleman), "Hm7")
        XCTAssertEqual(Acorde("Fa#7(b9)").cifrado(en: .aleman), "Fis7(b9)")
        XCTAssertEqual(Tonalidad("Fa# mayor").nombre(en: .aleman), "Fis-Dur")
        XCTAssertEqual(Tonalidad("La menor").nombre(en: .aleman), "a-Moll")
        XCTAssertEqual(Tonalidad("Sib mayor").nombre(en: .aleman), "B-Dur")
        XCTAssertEqual(Tonalidad("Fis-Dur"), Tonalidad("Fa# mayor"))
        XCTAssertEqual(Tonalidad("es-Moll"), Tonalidad("Mib menor"))
        XCTAssertEqual(Alteracion(2).nombre(en: .aleman), "Doppelkreuz")
        XCTAssertEqual(Alteracion(-1).nombre(en: .aleman), "Be")
        XCTAssertThrowsError(try Nota(leyendo: "Xis", en: .aleman))
    }

    func testFrancesEItaliano() {
        XCTAssertEqual(Nota("Re").nombre(en: .frances), "ré")
        XCTAssertEqual(Nota("Mib").nombre(en: .frances), "mi bémol")
        XCTAssertEqual(Nota("Fa#").nombre(en: .frances), "fa dièse")
        XCTAssertEqual(Nota("Dox").nombre(en: .frances), "do double dièse")
        XCTAssertEqual(Nota("Mib").nombre(en: .italiano), "mi bemolle")
        XCTAssertEqual(Nota("Re#").nombre(en: .italiano), "re diesis")
        XCTAssertEqual(Nota("Sibb").nombre(en: .italiano), "si doppio bemolle")
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .frances), "Ré♭")
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .italiano), "Re♭")
        XCTAssertEqual(Altura("Fa#3").nombre(en: .frances), "fa dièse 3")
        XCTAssertEqual(Altura("Re4").nombre(en: .frances), "ré4")
        XCTAssertEqual(try Altura(leyendo: "fa dièse 3", en: .frances), Altura("Fa#3"))
        XCTAssertEqual(try Altura(leyendo: "re diesis 5", en: .italiano), Altura("Re#5"))
        XCTAssertEqual(try Nota(leyendo: "RE BEMOL", en: .frances), Nota("Reb"))
        XCTAssertEqual(try Nota(leyendo: "Ré♭", en: .frances), Nota("Reb"))
        XCTAssertEqual(Acorde("Fa#m7").cifrado(en: .frances), "Fa♯m7")
        XCTAssertEqual(Acorde("Rebmaj7").cifrado(en: .frances), "Ré♭maj7")
        XCTAssertEqual(Tonalidad("Reb mayor").nombre(en: .frances), "ré bémol majeur")
        XCTAssertEqual(Tonalidad("Fa# menor").nombre(en: .italiano), "fa diesis minore")
        XCTAssertEqual(Tonalidad("ré bémol majeur"), Tonalidad("Reb mayor"))
        XCTAssertEqual(Tonalidad("la minore"), Tonalidad("La menor"))
        XCTAssertEqual(Alteracion(-2).nombre(en: .frances), "double bémol")
        XCTAssertEqual(Alteracion(1).nombre(en: .italiano), "diesis")
        XCTAssertEqual(Alteracion.natural.nombre(en: .italiano), "bequadro")
        XCTAssertEqual(Alteracion("bémol"), .bemol)
        XCTAssertEqual(Alteracion("doppio diesis"), .dobleSostenido)
    }

    /// Los textos del motor y los catálogos en portugués, francés e italiano.
    func testTextosEnPortuguesFrancesItaliano() throws {
        XCTAssertEqual(Notacion.frances.textos, .frances)
        XCTAssertEqual(Notacion.italiano.textos, .italiano)

        let sexta = try Intervalo(leyendo: "-6m")
        XCTAssertEqual(sexta.nombre(en: .portugues), "6ª menor descendente")
        XCTAssertEqual(sexta.nombre(en: .frances), "sixte mineure descendante")
        XCTAssertEqual(sexta.nombre(en: .italiano), "sesta minore discendente")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .portugues), "3ª maior")
        XCTAssertEqual(Intervalo.quintaJusta.nombre(en: .frances), "quinte juste")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .italiano), "terza maggiore")
        // El unísono es masculino.
        let unisono = try Intervalo(leyendo: "1A")
        XCTAssertEqual(unisono.nombre(en: .frances), "unisson augmenté")
        XCTAssertEqual(unisono.nombre(en: .italiano), "unisono aumentato")
        XCTAssertEqual(CalidadDeIntervalo.disminuida(2).nombre(en: .frances), "doublement diminuée")
        XCTAssertEqual(Consonancia.perfecta.nombre(en: .italiano), "consonanza perfetta")
        XCTAssertEqual(PapelEnAcorde.fundamental.nombre(en: .frances), "fondamentale")
        XCTAssertEqual(NombreDeGrado.sensible.nombre(en: .portugues), "sensível")
        XCTAssertEqual(Clave.sol.nombre(en: .italiano), "chiave di violino")
        XCTAssertEqual(Duracion(.negra, puntillos: 1).nombre(en: .frances), "noire pointée")
        XCTAssertEqual(Duracion(.corchea, puntillos: 2).nombre(en: .italiano), "croma doppiamente puntata")
        XCTAssertEqual(Figura.blanca.nombre(en: .portugues), "mínima")
        XCTAssertEqual(Cadencia.Tipo.rota.nombre(en: .frances), "cadence rompue")
        XCTAssertEqual(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .portugues), "I–IV–V7–I em dó maior")
        XCTAssertEqual(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .italiano),
            "i–V7–i in la minore")

        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .frances), "septième de dominante")
        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .italiano), "settima di dominante")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .portugues), "sol sétima de dominante, primeira inversão")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .frances), "sol septième de dominante, premier renversement")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .italiano), "sol settima di dominante, primo rivolto")
        XCTAssertEqual(Acorde("Do/Re").nombre(en: .italiano), "do maggiore, con il basso in re")
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            XCTAssertFalse(
                nombre.portugues.isEmpty || nombre.frances.isEmpty || nombre.italiano.isEmpty, nombre.espanol)
        }

        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .frances), "ré dorien")
        XCTAssertEqual(Escala(.la, .menorArmonica).nombre(en: .italiano), "la minore armonica")
        XCTAssertEqual(Escala("dó maior"), Escala("Do mayor"))
        XCTAssertEqual(Escala(.re, .hirajoshi).nombre(en: .frances), "ré " + TipoDeEscala.hirajoshi.nombre)
        // Cada escala del catálogo tiene nombre en los tres idiomas; la portuguesa se vuelve a leer igual.
        for tipo in TipoDeEscala.todos {
            for idioma in [Idioma.portugues, .frances, .italiano] {
                XCTAssertNotNil(NombresDeEscalas.de(idioma).porTipo[tipo], "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            let nombre = escala.nombre(en: .portugues)
            XCTAssertEqual(Escala(texto: nombre), escala, "\(nombre) (\(tipo.nombre))")
        }

        XCTAssertEqual(InstrumentoDePartitura.clarineteEnSib.nombre(en: .frances), "clarinette en si♭")
        XCTAssertEqual(InstrumentoDePartitura.violin.nombre(en: .portugues), "violino")
        XCTAssertEqual(InstrumentoDePartitura.saxofonAlto.nombre(en: .italiano), "sassofono contralto")
        for instrumento in InstrumentoDePartitura.todos {
            XCTAssertNotNil(InstrumentoDePartitura.nombresRomanicos[instrumento.nombre], instrumento.nombre)
        }
        XCTAssertEqual(CicloNeorriemanniano.hexatonico.nombre(en: .italiano), "ciclo esatonico")
    }

    /// Los nombres de nota en occitano, griego y ruso: se escriben y se leen, también sin indicar
    /// la notación; los demás textos salen en el idioma de las notas.
    func testOccitanoRusoGriego() throws {
        let casos: [(String, String, String, String)] = [
            ("Fa#", "fa dièsi", "фа-диез", "φα δίεση"),
            ("Sib", "si bemòl", "си-бемоль", "σι ύφεση"),
            ("Sol", "sòl", "соль", "σολ"),
            ("La", "la", "ля", "λα"),
            ("Do", "do", "до", "ντο"),
            ("Dox", "do doble dièsi", "до-дубль-диез", "ντο διπλή δίεση"),
            ("Mibb", "mi doble bemòl", "ми-дубль-бемоль", "μι διπλή ύφεση"),
        ]
        for (espanol, occitano, ruso, griego) in casos {
            let nota = Nota(texto: espanol)!
            for (notacion, nombre) in [(Notacion.occitano, occitano), (.ruso, ruso), (.griego, griego)] {
                XCTAssertEqual(nota.nombre(en: notacion), nombre)
                XCTAssertEqual(try Nota(leyendo: nombre, en: notacion), nota, nombre)
                XCTAssertEqual(Nota(texto: nombre), nota, nombre)
                XCTAssertEqual(Nota(texto: nota.nombreCompacto(en: notacion)), nota, nombre)
            }
        }
        // Sin tildes y con o sin guion.
        XCTAssertEqual(Nota(texto: "σι υφεση"), Nota("Sib"))
        XCTAssertEqual(Nota(texto: "фа диез"), Nota("Fa#"))
        XCTAssertEqual(Nota(texto: "sol diesi"), Nota("Sol#"))
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .ruso), "Ре♭")
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .griego), "Ρε♭")
        XCTAssertEqual(Nota("Sol#").nombreCompacto(en: .occitano), "Sòl♯")
        XCTAssertEqual(Acorde("Fa#m7").cifrado(en: .ruso), "Фа♯m7")
        XCTAssertEqual(Altura("Fa#3").nombre(en: .griego), "φα δίεση 3")
        XCTAssertEqual(Altura("Fa#3").nombre(en: .ruso), "фа-диез3")
        XCTAssertEqual(Altura("фа-диез3"), Altura("Fa#3"))
        XCTAssertEqual(Altura("σι ύφεση 4"), Altura("Sib4"))
        XCTAssertEqual(Altura("sòl dièsi 2"), Altura("Sol#2"))
        XCTAssertEqual(Alteracion(-1).nombre(en: .griego), "ύφεση")
        XCTAssertEqual(Alteracion(2).nombre(en: .ruso), "дубль-диез")
        XCTAssertEqual(Alteracion(0).nombre(en: .occitano), "becarre")
        // Tonalidades.
        XCTAssertEqual(Tonalidad("Fa# mayor").nombre(en: .ruso), "фа-диез мажор")
        XCTAssertEqual(Tonalidad("La menor").nombre(en: .ruso), "ля минор")
        XCTAssertEqual(Tonalidad("Re mayor").nombre(en: .griego), "ρε μείζονα")
        XCTAssertEqual(Tonalidad("Sib menor").nombre(en: .griego), "σι ύφεση ελάσσονα")
        XCTAssertEqual(Tonalidad("Sol mayor").nombre(en: .occitano), "sòl major")
        XCTAssertEqual(Tonalidad("ре мажор"), Tonalidad("Re mayor"))
        XCTAssertEqual(Tonalidad("σι ύφεση ελάσσονα"), Tonalidad("Sib menor"))
        XCTAssertEqual(Tonalidad("fa dièsi menor"), Tonalidad("Fa# menor"))
        // Los demás textos, en el idioma de las notas.
        XCTAssertEqual(Notacion.ruso.textos, .ruso)
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .griego), "μεγάλη τρίτη")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .ruso), "доминантсептаккорд от соль, первое обращение")
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .occitano), "re dorian")
    }
}
