import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

/// Las notaciones y los textos en alemán, húngaro, francés, italiano, occitano, griego y ruso.
@Suite struct NotacionesEuropeasTests {
    @Test func aleman() throws {
        let casos: [(String, String)] = [
            ("Do", "C"), ("Fa#", "Fis"), ("Dob", "Ces"), ("Mib", "Es"), ("Mibb", "Eses"),
            ("Lab", "As"), ("Labb", "Asas"), ("Sib", "B"), ("Sibb", "Heses"), ("Si", "H"),
            ("Si#", "His"), ("Rex", "Disis"), ("Solb", "Ges"),
        ]
        for (espanol, aleman) in casos {
            let nombre = try! Nota(leyendo: espanol)
            #expect(nombre.nombre(en: .compacta(.aleman)) == aleman, Comment(rawValue: espanol))
            #expect(nombre.nombreCompacto(en: .conPalabras(.aleman)) == aleman, Comment(rawValue: espanol))
            #expect(try (Nota(leyendo: aleman, en: .compacta(.aleman))) == nombre, Comment(rawValue: aleman))
            #expect(try (Nota(leyendo: aleman, en: .conPalabras(.aleman))) == nombre, Comment(rawValue: aleman))
            let conPalabras = nombre.nombre(en: .conPalabras(.aleman))
            #expect(
                try (Nota(leyendo: conPalabras, en: .conPalabras(.aleman))) == nombre, Comment(rawValue: conPalabras))
            #expect(try (Nota(leyendo: conPalabras, en: .compacta(.aleman))) == nombre, Comment(rawValue: conPalabras))
        }
        #expect(try (Nota(leyendo: "fis", en: .compacta(.aleman))) == Nota("Fa#"))
        #expect(Altura("Fa#4").nombre(en: .compacta(.aleman)) == "Fis₄")
        #expect(Altura("Fa#4").nombre(en: .compacta(.aleman).conOctavas(.cifras)) == "Fis4")
        #expect(try (Altura(leyendo: "B3", en: .compacta(.aleman))) == Altura("Sib3"))
        #expect(try (Altura(leyendo: "Fis₄", en: .compacta(.aleman))) == Altura("Fa#4"))
        // Con palabras: la letra y «Kreuz» o «Be», como «Fa sostenido».
        #expect(Nota("Fa#").nombre(en: .conPalabras(.aleman)) == "F Kreuz")
        // El Si♭ es B también con palabras, y «H Be» se sigue leyendo.
        #expect(Nota("Sib").nombre(en: .conPalabras(.aleman)) == "B")
        #expect(Nota("Sibb").nombre(en: .conPalabras(.aleman)) == "H Doppel-Be")
        #expect(try (Nota(leyendo: "H Be", en: .conPalabras(.aleman))) == Nota("Sib"))
        #expect(Altura("Sib3").nombre(en: .conPalabras(.aleman)) == "B3")
        #expect(Nota("Mibb").nombre(en: .conPalabras(.aleman)) == "E Doppel-Be")
        #expect(Nota("Do").nombre(en: .conPalabras(.aleman)) == "C")
        #expect(Altura("Fa#4").nombre(en: .conPalabras(.aleman)) == "F Kreuz 4")
        #expect(try (Altura(leyendo: "F Kreuz 4", en: .conPalabras(.aleman))) == Altura("Fa#4"))
        #expect(Tonalidad("Fa# mayor").nombre(en: .compacta(.aleman)) == "Fis-Dur")
        #expect(Escala("Fa# dórico").nombre(en: .compacta(.aleman)) == "Fis dorisch")
        #expect(Acorde("Sib7").cifrado(en: .conPalabras(.aleman)) == "B7")
        #expect(Acorde("Sim7").cifrado(en: .conPalabras(.aleman)) == "Hm7")
        #expect(Acorde("Fa#7(b9)").cifrado(en: .conPalabras(.aleman)) == "Fis7(b9)")
        #expect(Tonalidad("Fa# mayor").nombre(en: .conPalabras(.aleman)) == "Fis-Dur")
        #expect(Tonalidad("La menor").nombre(en: .conPalabras(.aleman)) == "a-Moll")
        #expect(Tonalidad("Sib mayor").nombre(en: .conPalabras(.aleman)) == "B-Dur")
        #expect(Tonalidad("Fis-Dur") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad("es-Moll") == Tonalidad("Mib menor"))
        #expect(Alteracion(2).nombre(en: .conPalabras(.aleman)) == "Doppelkreuz")
        #expect(Alteracion(-1).nombre(en: .conPalabras(.aleman)) == "Be")
        #expect(throws: (any Error).self) { try Nota(leyendo: "Xis", en: .conPalabras(.aleman)) }
    }

    /// El húngaro escribe las notas como el alemán, con «isz» y «esz»: Fisz, Esz, Asz, B, H.
    @Test func hungaro() throws {
        let casos: [(String, String)] = [
            ("Do", "C"), ("Fa#", "Fisz"), ("Dob", "Cesz"), ("Mib", "Esz"), ("Mibb", "Eszesz"),
            ("Lab", "Asz"), ("Labb", "Aszasz"), ("Sib", "B"), ("Sibb", "Heszesz"), ("Si", "H"),
            ("Si#", "Hisz"), ("Rex", "Diszisz"), ("Solb", "Gesz"),
        ]
        for (espanol, hungaro) in casos {
            let nombre = try! Nota(leyendo: espanol)
            #expect(nombre.nombre(en: .compacta(.hungaro)) == hungaro, Comment(rawValue: espanol))
            #expect(try (Nota(leyendo: hungaro, en: .compacta(.hungaro))) == nombre, Comment(rawValue: hungaro))
        }
        // Con palabras, como el alemán: los cifrados y las tonalidades siguen a la alemana, y se leen las dos formas.
        #expect(Nota("Fa#").nombre(en: .conPalabras(.hungaro)) == "F kereszt")
        #expect(Nota("Sib").nombre(en: .conPalabras(.hungaro)) == "H bé")
        #expect(Acorde("Fa#7").cifrado(en: .conPalabras(.hungaro)) == "Fisz7")
        #expect(Tonalidad("Fa# mayor").nombre(en: .conPalabras(.hungaro)) == "Fisz-dúr")
        #expect(try (Nota(leyendo: "Fisz", en: .conPalabras(.hungaro))) == Nota("Fa#"))
        #expect(try (Nota(leyendo: "F kereszt", en: .compacta(.hungaro))) == Nota("Fa#"))
        #expect(Notacion.delIdioma(.hungaro) == .compacta(.hungaro))
        // El alemán no cambia.
        #expect(Nota("Mibb").nombreAleman == "Eses")
        #expect(try (Nota(leyendo: "fisz", en: .compacta(.hungaro))) == Nota("Fa#"))
        #expect(Altura("Fa#4").nombre(en: .compacta(.hungaro)) == "Fisz₄")
        #expect(try (Altura(leyendo: "B3", en: .compacta(.hungaro))) == Altura("Sib3"))
        #expect(Acorde("Sib7").cifrado(en: .compacta(.hungaro)) == "B7")
        #expect(Acorde("Sim7").cifrado(en: .compacta(.hungaro)) == "Hm7")
        #expect(Acorde("Fa#7").cifrado(en: .compacta(.hungaro)) == "Fisz7")
        #expect(Tonalidad("Fa# mayor").nombre(en: .compacta(.hungaro)) == "Fisz-dúr")
        #expect(Tonalidad("La menor").nombre(en: .compacta(.hungaro)) == "a-moll")
        #expect(Tonalidad("Mib menor").nombre(en: .compacta(.hungaro)) == "esz-moll")
        #expect(Tonalidad("Fisz-dúr") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad("esz-moll") == Tonalidad("Mib menor"))
        #expect(Escala("Re dórico").nombre(en: .compacta(.hungaro)) == "D dór")
        #expect(Escala("Fisz dór") == Escala("Fa# dórico"))
        #expect(Escala("A összhangzatos moll") == Escala("La menor armónica"))
        #expect(Alteracion(1).nombre(en: .conPalabras(.hungaro)) == "kereszt")
        #expect(Alteracion(-2).nombre(en: .conPalabras(.hungaro)) == "kettős bé")
        #expect(Idioma(codigo: "hu-HU") == .hungaro)
        #expect(try Idioma(leyendo: "magyar") == .hungaro)
        #expect(try Idioma(leyendo: "húngaro") == .hungaro)
        #expect(Idioma.hungaro.nombrePropio == "Magyar")
        // Los textos.
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.hungaro)) == "nagy terc")
        #expect(Intervalo("P5").nombre(en: .conPalabras(.hungaro)) == "tiszta kvint")
        #expect(Intervalo("-m6").nombre(en: .conPalabras(.hungaro)) == "lefelé kis szext")
        #expect(Acorde("Sol7").nombre(en: .conPalabras(.hungaro)) == "G domináns szeptimakkord, alaphelyzet")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .conPalabras(.hungaro))
                == "I–IV–V7–I C-dúrban")
        // Con un número, el nombre va en singular.
        #expect(Idioma.hungaro.contar(5, "félhang") == "5 félhang")
        #expect(throws: (any Error).self) { try Nota(leyendo: "Xisz", en: .compacta(.hungaro)) }
    }

    /// El artículo húngaro: «az» ante vocal o ante 1, 5, 1000…; «a» si no.
    @Test func articuloHungaro() {
        #expect("alt".conArticuloHungaro == "az alt")
        #expect("basszus".conArticuloHungaro == "a basszus")
        #expect("5. szólam".conArticuloHungaro == "az 5. szólam")
        #expect("1. szólam".conArticuloHungaro == "az 1. szólam")
        #expect("10. szólam".conArticuloHungaro == "a 10. szólam")
        #expect("3. szólam".conArticuloHungaro == "a 3. szólam")
        #expect("Esz".conArticuloHungaro == "az Esz")
    }

    @Test func francesEItaliano() throws {
        #expect(Nota("Re").nombre(en: .conPalabras(.frances)) == "ré")
        #expect(Nota("Mib").nombre(en: .conPalabras(.frances)) == "mi bémol")
        #expect(Nota("Fa#").nombre(en: .conPalabras(.frances)) == "fa dièse")
        #expect(Nota("Dox").nombre(en: .conPalabras(.frances)) == "do double dièse")
        #expect(Nota("Mib").nombre(en: .conPalabras(.italiano)) == "mi bemolle")
        #expect(Nota("Re#").nombre(en: .conPalabras(.italiano)) == "re diesis")
        #expect(Nota("Sibb").nombre(en: .conPalabras(.italiano)) == "si doppio bemolle")
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.frances)) == "Ré♭")
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.italiano)) == "Re♭")
        #expect(Altura("Fa#3").nombre(en: .conPalabras(.frances)) == "fa dièse 3")
        #expect(Altura("Re4").nombre(en: .conPalabras(.frances)) == "ré4")
        #expect(try (Altura(leyendo: "fa dièse 3", en: .conPalabras(.frances))) == Altura("Fa#3"))
        #expect(try (Altura(leyendo: "re diesis 5", en: .conPalabras(.italiano))) == Altura("Re#5"))
        #expect(try (Nota(leyendo: "RE BEMOL", en: .conPalabras(.frances))) == Nota("Reb"))
        #expect(try (Nota(leyendo: "Ré♭", en: .conPalabras(.frances))) == Nota("Reb"))
        #expect(Acorde("Fa#m7").cifrado(en: .conPalabras(.frances)) == "Fa♯m7")
        #expect(Acorde("Rebmaj7").cifrado(en: .conPalabras(.frances)) == "Ré♭maj7")
        #expect(Tonalidad("Reb mayor").nombre(en: .conPalabras(.frances)) == "ré bémol majeur")
        #expect(Tonalidad("Fa# menor").nombre(en: .conPalabras(.italiano)) == "fa diesis minore")
        #expect(Tonalidad("ré bémol majeur") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("la minore") == Tonalidad("La menor"))
        #expect(Alteracion(-2).nombre(en: .conPalabras(.frances)) == "double bémol")
        #expect(Alteracion(1).nombre(en: .conPalabras(.italiano)) == "diesis")
        #expect(Alteracion.natural.nombre(en: .conPalabras(.italiano)) == "bequadro")
        #expect(Alteracion("bémol") == .bemol)
        #expect(Alteracion("doppio diesis") == .dobleSostenido)
    }

    /// Los textos del motor y los catálogos en portugués, francés e italiano.
    @Test func textosEnPortuguesFrancesItaliano() throws {
        #expect(Notacion.conPalabras(.frances).textos == .frances)
        #expect(Notacion.conPalabras(.italiano).textos == .italiano)

        let sexta = try Intervalo(leyendo: "-6m")
        #expect(sexta.nombre(en: .conPalabras(.portugues)) == "6ª menor descendente")
        #expect(sexta.nombre(en: .conPalabras(.frances)) == "sixte mineure descendante")
        #expect(sexta.nombre(en: .conPalabras(.italiano)) == "sesta minore discendente")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.portugues)) == "3ª maior")
        #expect(Intervalo.quintaJusta.nombre(en: .conPalabras(.frances)) == "quinte juste")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.italiano)) == "terza maggiore")
        // El unísono es masculino.
        let unisono = try Intervalo(leyendo: "1A")
        #expect(unisono.nombre(en: .conPalabras(.frances)) == "unisson augmenté")
        #expect(unisono.nombre(en: .conPalabras(.italiano)) == "unisono aumentato")
        #expect(CalidadDeIntervalo.disminuida(2).nombre(en: .conPalabras(.frances)) == "doublement diminuée")
        #expect(Consonancia.perfecta.nombre(en: .conPalabras(.italiano)) == "consonanza perfetta")
        #expect(PapelEnAcorde.fundamental.nombre(en: .conPalabras(.frances)) == "fondamentale")
        #expect(NombreDeGrado.sensible.nombre(en: .conPalabras(.portugues)) == "sensível")
        #expect(Clave.sol.nombre(en: .conPalabras(.italiano)) == "chiave di violino")
        #expect(Duracion(.negra, puntillos: 1).nombre(en: .conPalabras(.frances)) == "noire pointée")
        #expect(Duracion(.corchea, puntillos: 2).nombre(en: .conPalabras(.italiano)) == "croma doppiamente puntata")
        #expect(Figura.blanca.nombre(en: .conPalabras(.portugues)) == "mínima")
        #expect(Cadencia.Tipo.rota.nombre(en: .conPalabras(.frances)) == "cadence rompue")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .conPalabras(.portugues))
                == "I–IV–V7–I em dó maior")
        #expect(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .conPalabras(.italiano))
                == "i–V7–i in la minore")

        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.frances)) == "septième de dominante")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.italiano)) == "settima di dominante")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.portugues)) == "sol sétima de dominante, primeira inversão")
        #expect(
            Acorde("Sol7/Si").nombre(en: .conPalabras(.frances)) == "sol septième de dominante, premier renversement")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.italiano)) == "sol settima di dominante, primo rivolto")
        #expect(Acorde("Do/Re").nombre(en: .conPalabras(.italiano)) == "do maggiore, con il basso in re")
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            #expect(
                !(nombre.portugues.isEmpty || nombre.frances.isEmpty || nombre.italiano.isEmpty),
                Comment(rawValue: nombre.espanol))
        }

        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.frances)) == "ré dorien")
        #expect(Escala(.la, .menorArmonica).nombre(en: .conPalabras(.italiano)) == "la minore armonica")
        #expect(Escala("dó maior") == Escala("Do mayor"))
        #expect(Escala(.re, .hirajoshi).nombre(en: .conPalabras(.frances)) == ("ré " + TipoDeEscala.hirajoshi.nombre))
        // Cada escala del catálogo tiene nombre en los tres idiomas; la portuguesa se vuelve a leer igual.
        for tipo in TipoDeEscala.occidentales {
            for idioma in [Idioma.portugues, .frances, .italiano] {
                #expect(NombresDeEscalas.de(idioma).porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            let nombre = escala.nombre(en: .conPalabras(.portugues))
            #expect((try? Escala(leyendo: nombre)) == escala, "\(nombre) (\(tipo.nombre))")
        }

        #expect(InstrumentoDePartitura.clarineteEnSib.nombre(en: .conPalabras(.frances)) == "clarinette en si♭")
        #expect(InstrumentoDePartitura.violin.nombre(en: .conPalabras(.portugues)) == "violino")
        #expect(InstrumentoDePartitura.saxofonAlto.nombre(en: .conPalabras(.italiano)) == "sassofono contralto")
        for instrumento in InstrumentoDePartitura.todos {
            #expect(
                InstrumentoDePartitura.traducciones[instrumento.nombre] != nil, Comment(rawValue: instrumento.nombre))
        }
        #expect(InstrumentoDePartitura.traducciones.count == InstrumentoDePartitura.todos.count)
        // Un instrumento propio usa su nombre español o, en alemán, su nombre inglés.
        let propio = InstrumentoDePartitura(nombre: "laúd", nombreEnIngles: "lute")
        #expect(propio.nombre(en: .conPalabras(.frances)) == "laúd")
        #expect(propio.nombre(en: .conPalabras(.aleman)) == "lute")
        #expect(CicloNeorriemanniano.hexatonico.nombre(en: .conPalabras(.italiano)) == "ciclo esatonico")
    }

    /// Los nombres de nota en occitano, griego y ruso: se escriben y se leen, también sin indicar
    /// la notación; los demás textos salen en el idioma de las notas.
    @Test func occitanoRusoGriego() throws {
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
            let nota = try! Nota(leyendo: espanol)
            for (notacion, nombre) in [
                (Notacion.conPalabras(.occitano), occitano), (.conPalabras(.ruso), ruso),
                (.conPalabras(.griego), griego),
            ] {
                #expect(nota.nombre(en: notacion) == nombre)
                #expect(try (Nota(leyendo: nombre, en: notacion)) == nota, Comment(rawValue: nombre))
                #expect((try? Nota(leyendo: nombre)) == nota, Comment(rawValue: nombre))
                #expect((try? Nota(leyendo: nota.nombreCompacto(en: notacion))) == nota, Comment(rawValue: nombre))
            }
        }
        // Sin tildes y con o sin guion.
        #expect((try? Nota(leyendo: "σι υφεση")) == Nota("Sib"))
        #expect((try? Nota(leyendo: "фа диез")) == Nota("Fa#"))
        #expect((try? Nota(leyendo: "sol diesi")) == Nota("Sol#"))
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.ruso)) == "Ре♭")
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.griego)) == "Ρε♭")
        #expect(Nota("Sol#").nombreCompacto(en: .conPalabras(.occitano)) == "Sòl♯")
        #expect(Acorde("Fa#m7").cifrado(en: .conPalabras(.ruso)) == "Фа♯m7")
        #expect(Altura("Fa#3").nombre(en: .conPalabras(.griego)) == "φα δίεση 3")
        #expect(Altura("Fa#3").nombre(en: .conPalabras(.ruso)) == "фа-диез3")
        #expect(Altura("фа-диез3") == Altura("Fa#3"))
        #expect(Altura("σι ύφεση 4") == Altura("Sib4"))
        #expect(Altura("sòl dièsi 2") == Altura("Sol#2"))
        #expect(Alteracion(-1).nombre(en: .conPalabras(.griego)) == "ύφεση")
        #expect(Alteracion(2).nombre(en: .conPalabras(.ruso)) == "дубль-диез")
        #expect(Alteracion(0).nombre(en: .conPalabras(.occitano)) == "becarre")
        // Tonalidades.
        #expect(Tonalidad("Fa# mayor").nombre(en: .conPalabras(.ruso)) == "фа-диез мажор")
        #expect(Tonalidad("La menor").nombre(en: .conPalabras(.ruso)) == "ля минор")
        #expect(Tonalidad("Re mayor").nombre(en: .conPalabras(.griego)) == "ρε μείζονα")
        #expect(Tonalidad("Sib menor").nombre(en: .conPalabras(.griego)) == "σι ύφεση ελάσσονα")
        #expect(Tonalidad("Sol mayor").nombre(en: .conPalabras(.occitano)) == "sòl major")
        #expect(Tonalidad("ре мажор") == Tonalidad("Re mayor"))
        #expect(Tonalidad("σι ύφεση ελάσσονα") == Tonalidad("Sib menor"))
        #expect(Tonalidad("fa dièsi menor") == Tonalidad("Fa# menor"))
        // Los demás textos, en el idioma de las notas.
        #expect(Notacion.conPalabras(.ruso).textos == .ruso)
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.griego)) == "μεγάλη τρίτη")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.ruso)) == "доминантсептаккорд от соль, первое обращение")
        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.occitano)) == "re dorian")
    }
}
