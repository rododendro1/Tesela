import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Las notaciones y los textos en alemán, húngaro, francés, italiano, occitano, griego y ruso.
@Suite struct NotacionesEuropeasTests {
    @Test func aleman() throws {
        let casos: [(String, String)] = [
            ("Do", "C"), ("Fa#", "Fis"), ("Dob", "Ces"), ("Mib", "Es"), ("Mibb", "Eses"),
            ("Lab", "As"), ("Labb", "Asas"), ("Sib", "B"), ("Sibb", "Heses"), ("Si", "H"),
            ("Si#", "His"), ("Rex", "Disis"), ("Solb", "Ges"),
        ]
        for (espanol, aleman) in casos {
            let nombre = Nota(texto: espanol)!
            #expect(nombre.nombre(en: .alemanCompacto) == aleman, Comment(rawValue: espanol))
            #expect(nombre.nombreCompacto(en: .aleman) == aleman, Comment(rawValue: espanol))
            #expect(try (Nota(leyendo: aleman, en: .alemanCompacto)) == nombre, Comment(rawValue: aleman))
            #expect(try (Nota(leyendo: aleman, en: .aleman)) == nombre, Comment(rawValue: aleman))
            let conPalabras = nombre.nombre(en: .aleman)
            #expect(try (Nota(leyendo: conPalabras, en: .aleman)) == nombre, Comment(rawValue: conPalabras))
            #expect(try (Nota(leyendo: conPalabras, en: .alemanCompacto)) == nombre, Comment(rawValue: conPalabras))
        }
        #expect(try (Nota(leyendo: "fis", en: .alemanCompacto)) == Nota("Fa#"))
        #expect(Altura("Fa#4").nombre(en: .alemanCompacto) == "Fis₄")
        #expect(Altura("Fa#4").nombre(en: .alemanCompacto.conOctavas(.cifras)) == "Fis4")
        #expect(try (Altura(leyendo: "B3", en: .alemanCompacto)) == Altura("Sib3"))
        #expect(try (Altura(leyendo: "Fis₄", en: .alemanCompacto)) == Altura("Fa#4"))
        // Con palabras: la letra y «Kreuz» o «Be», como «Fa sostenido».
        #expect(Nota("Fa#").nombre(en: .aleman) == "F Kreuz")
        #expect(Nota("Sib").nombre(en: .aleman) == "H Be")
        #expect(Nota("Mibb").nombre(en: .aleman) == "E Doppel-Be")
        #expect(Nota("Do").nombre(en: .aleman) == "C")
        #expect(Altura("Fa#4").nombre(en: .aleman) == "F Kreuz 4")
        #expect(try (Altura(leyendo: "F Kreuz 4", en: .aleman)) == Altura("Fa#4"))
        #expect(Tonalidad("Fa# mayor").nombre(en: .alemanCompacto) == "Fis-Dur")
        #expect(Escala("Fa# dórico").nombre(en: .alemanCompacto) == "Fis dorisch")
        #expect(Acorde("Sib7").cifrado(en: .aleman) == "B7")
        #expect(Acorde("Sim7").cifrado(en: .aleman) == "Hm7")
        #expect(Acorde("Fa#7(b9)").cifrado(en: .aleman) == "Fis7(b9)")
        #expect(Tonalidad("Fa# mayor").nombre(en: .aleman) == "Fis-Dur")
        #expect(Tonalidad("La menor").nombre(en: .aleman) == "a-Moll")
        #expect(Tonalidad("Sib mayor").nombre(en: .aleman) == "B-Dur")
        #expect(Tonalidad("Fis-Dur") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad("es-Moll") == Tonalidad("Mib menor"))
        #expect(Alteracion(2).nombre(en: .aleman) == "Doppelkreuz")
        #expect(Alteracion(-1).nombre(en: .aleman) == "Be")
        #expect(throws: (any Error).self) { try Nota(leyendo: "Xis", en: .aleman) }
    }

    /// El húngaro escribe las notas como el alemán, con «isz» y «esz»: Fisz, Esz, Asz, B, H.
    @Test func hungaro() throws {
        let casos: [(String, String)] = [
            ("Do", "C"), ("Fa#", "Fisz"), ("Dob", "Cesz"), ("Mib", "Esz"), ("Mibb", "Eszesz"),
            ("Lab", "Asz"), ("Labb", "Aszasz"), ("Sib", "B"), ("Sibb", "Heszesz"), ("Si", "H"),
            ("Si#", "Hisz"), ("Rex", "Diszisz"), ("Solb", "Gesz"),
        ]
        for (espanol, hungaro) in casos {
            let nombre = Nota(texto: espanol)!
            #expect(nombre.nombre(en: .hungaroCompacto) == hungaro, Comment(rawValue: espanol))
            #expect(try (Nota(leyendo: hungaro, en: .hungaroCompacto)) == nombre, Comment(rawValue: hungaro))
        }
        // Con palabras, como el alemán: los cifrados y las tonalidades siguen a la alemana, y se leen las dos formas.
        #expect(Nota("Fa#").nombre(en: .hungaro) == "F kereszt")
        #expect(Nota("Sib").nombre(en: .hungaro) == "H bé")
        #expect(Acorde("Fa#7").cifrado(en: .hungaro) == "Fisz7")
        #expect(Tonalidad("Fa# mayor").nombre(en: .hungaro) == "Fisz-dúr")
        #expect(try (Nota(leyendo: "Fisz", en: .hungaro)) == Nota("Fa#"))
        #expect(try (Nota(leyendo: "F kereszt", en: .hungaroCompacto)) == Nota("Fa#"))
        #expect(Notacion.delIdioma(.hungaro) == .hungaroCompacto)
        // El alemán no cambia.
        #expect(Nota("Mibb").nombreAleman == "Eses")
        #expect(try (Nota(leyendo: "fisz", en: .hungaroCompacto)) == Nota("Fa#"))
        #expect(Altura("Fa#4").nombre(en: .hungaroCompacto) == "Fisz₄")
        #expect(try (Altura(leyendo: "B3", en: .hungaroCompacto)) == Altura("Sib3"))
        #expect(Acorde("Sib7").cifrado(en: .hungaroCompacto) == "B7")
        #expect(Acorde("Sim7").cifrado(en: .hungaroCompacto) == "Hm7")
        #expect(Acorde("Fa#7").cifrado(en: .hungaroCompacto) == "Fisz7")
        #expect(Tonalidad("Fa# mayor").nombre(en: .hungaroCompacto) == "Fisz-dúr")
        #expect(Tonalidad("La menor").nombre(en: .hungaroCompacto) == "a-moll")
        #expect(Tonalidad("Mib menor").nombre(en: .hungaroCompacto) == "esz-moll")
        #expect(Tonalidad("Fisz-dúr") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad("esz-moll") == Tonalidad("Mib menor"))
        #expect(Escala("Re dórico").nombre(en: .hungaroCompacto) == "D dór")
        #expect(Escala("Fisz dór") == Escala("Fa# dórico"))
        #expect(Escala("A összhangzatos moll") == Escala("La menor armónica"))
        #expect(Alteracion(1).nombre(en: .hungaro) == "kereszt")
        #expect(Alteracion(-2).nombre(en: .hungaro) == "kettős bé")
        #expect(Idioma(codigo: "hu-HU") == .hungaro)
        #expect(Idioma(nombre: "magyar") == .hungaro)
        #expect(Idioma(nombre: "húngaro") == .hungaro)
        #expect(Idioma.hungaro.nombrePropio == "Magyar")
        // Los textos.
        #expect(Intervalo.terceraMayor.nombre(en: .hungaro) == "nagy terc")
        #expect(Intervalo("P5").nombre(en: .hungaro) == "tiszta kvint")
        #expect(Intervalo("-m6").nombre(en: .hungaro) == "lefelé kis szext")
        #expect(Acorde("Sol7").nombre(en: .hungaro) == "G domináns szeptimakkord, alaphelyzet")
        #expect(Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .hungaro) == "I–IV–V7–I C-dúrban")
        // Con un número, el nombre va en singular.
        #expect(Idioma.hungaro.contar(5, "félhang") == "5 félhang")
        #expect(throws: (any Error).self) { try Nota(leyendo: "Xisz", en: .hungaroCompacto) }
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
        #expect(Nota("Re").nombre(en: .frances) == "ré")
        #expect(Nota("Mib").nombre(en: .frances) == "mi bémol")
        #expect(Nota("Fa#").nombre(en: .frances) == "fa dièse")
        #expect(Nota("Dox").nombre(en: .frances) == "do double dièse")
        #expect(Nota("Mib").nombre(en: .italiano) == "mi bemolle")
        #expect(Nota("Re#").nombre(en: .italiano) == "re diesis")
        #expect(Nota("Sibb").nombre(en: .italiano) == "si doppio bemolle")
        #expect(Nota("Reb").nombreCompacto(en: .frances) == "Ré♭")
        #expect(Nota("Reb").nombreCompacto(en: .italiano) == "Re♭")
        #expect(Altura("Fa#3").nombre(en: .frances) == "fa dièse 3")
        #expect(Altura("Re4").nombre(en: .frances) == "ré4")
        #expect(try (Altura(leyendo: "fa dièse 3", en: .frances)) == Altura("Fa#3"))
        #expect(try (Altura(leyendo: "re diesis 5", en: .italiano)) == Altura("Re#5"))
        #expect(try (Nota(leyendo: "RE BEMOL", en: .frances)) == Nota("Reb"))
        #expect(try (Nota(leyendo: "Ré♭", en: .frances)) == Nota("Reb"))
        #expect(Acorde("Fa#m7").cifrado(en: .frances) == "Fa♯m7")
        #expect(Acorde("Rebmaj7").cifrado(en: .frances) == "Ré♭maj7")
        #expect(Tonalidad("Reb mayor").nombre(en: .frances) == "ré bémol majeur")
        #expect(Tonalidad("Fa# menor").nombre(en: .italiano) == "fa diesis minore")
        #expect(Tonalidad("ré bémol majeur") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("la minore") == Tonalidad("La menor"))
        #expect(Alteracion(-2).nombre(en: .frances) == "double bémol")
        #expect(Alteracion(1).nombre(en: .italiano) == "diesis")
        #expect(Alteracion.natural.nombre(en: .italiano) == "bequadro")
        #expect(Alteracion("bémol") == .bemol)
        #expect(Alteracion("doppio diesis") == .dobleSostenido)
    }

    /// Los textos del motor y los catálogos en portugués, francés e italiano.
    @Test func textosEnPortuguesFrancesItaliano() throws {
        #expect(Notacion.frances.textos == .frances)
        #expect(Notacion.italiano.textos == .italiano)

        let sexta = try Intervalo(leyendo: "-6m")
        #expect(sexta.nombre(en: .portugues) == "6ª menor descendente")
        #expect(sexta.nombre(en: .frances) == "sixte mineure descendante")
        #expect(sexta.nombre(en: .italiano) == "sesta minore discendente")
        #expect(Intervalo.terceraMayor.nombre(en: .portugues) == "3ª maior")
        #expect(Intervalo.quintaJusta.nombre(en: .frances) == "quinte juste")
        #expect(Intervalo.terceraMayor.nombre(en: .italiano) == "terza maggiore")
        // El unísono es masculino.
        let unisono = try Intervalo(leyendo: "1A")
        #expect(unisono.nombre(en: .frances) == "unisson augmenté")
        #expect(unisono.nombre(en: .italiano) == "unisono aumentato")
        #expect(CalidadDeIntervalo.disminuida(2).nombre(en: .frances) == "doublement diminuée")
        #expect(Consonancia.perfecta.nombre(en: .italiano) == "consonanza perfetta")
        #expect(PapelEnAcorde.fundamental.nombre(en: .frances) == "fondamentale")
        #expect(NombreDeGrado.sensible.nombre(en: .portugues) == "sensível")
        #expect(Clave.sol.nombre(en: .italiano) == "chiave di violino")
        #expect(Duracion(.negra, puntillos: 1).nombre(en: .frances) == "noire pointée")
        #expect(Duracion(.corchea, puntillos: 2).nombre(en: .italiano) == "croma doppiamente puntata")
        #expect(Figura.blanca.nombre(en: .portugues) == "mínima")
        #expect(Cadencia.Tipo.rota.nombre(en: .frances) == "cadence rompue")
        #expect(Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .portugues) == "I–IV–V7–I em dó maior")
        #expect(Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .italiano) == "i–V7–i in la minore")

        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .frances) == "septième de dominante")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .italiano) == "settima di dominante")
        #expect(Acorde("Sol7/Si").nombre(en: .portugues) == "sol sétima de dominante, primeira inversão")
        #expect(Acorde("Sol7/Si").nombre(en: .frances) == "sol septième de dominante, premier renversement")
        #expect(Acorde("Sol7/Si").nombre(en: .italiano) == "sol settima di dominante, primo rivolto")
        #expect(Acorde("Do/Re").nombre(en: .italiano) == "do maggiore, con il basso in re")
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            #expect(
                !(nombre.portugues.isEmpty || nombre.frances.isEmpty || nombre.italiano.isEmpty),
                Comment(rawValue: nombre.espanol))
        }

        #expect(Escala(.re, .dorico).nombre(en: .frances) == "ré dorien")
        #expect(Escala(.la, .menorArmonica).nombre(en: .italiano) == "la minore armonica")
        #expect(Escala("dó maior") == Escala("Do mayor"))
        #expect(Escala(.re, .hirajoshi).nombre(en: .frances) == ("ré " + TipoDeEscala.hirajoshi.nombre))
        // Cada escala del catálogo tiene nombre en los tres idiomas; la portuguesa se vuelve a leer igual.
        for tipo in TipoDeEscala.todos {
            for idioma in [Idioma.portugues, .frances, .italiano] {
                #expect(NombresDeEscalas.de(idioma).porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            let nombre = escala.nombre(en: .portugues)
            #expect(Escala(texto: nombre) == escala, "\(nombre) (\(tipo.nombre))")
        }

        #expect(InstrumentoDePartitura.clarineteEnSib.nombre(en: .frances) == "clarinette en si♭")
        #expect(InstrumentoDePartitura.violin.nombre(en: .portugues) == "violino")
        #expect(InstrumentoDePartitura.saxofonAlto.nombre(en: .italiano) == "sassofono contralto")
        for instrumento in InstrumentoDePartitura.todos {
            #expect(
                InstrumentoDePartitura.traducciones[instrumento.nombre] != nil, Comment(rawValue: instrumento.nombre))
        }
        #expect(InstrumentoDePartitura.traducciones.count == InstrumentoDePartitura.todos.count)
        // Un instrumento propio usa su nombre español o, en alemán, su nombre inglés.
        let propio = InstrumentoDePartitura(nombre: "laúd", nombreEnIngles: "lute")
        #expect(propio.nombre(en: .frances) == "laúd")
        #expect(propio.nombre(en: .aleman) == "lute")
        #expect(CicloNeorriemanniano.hexatonico.nombre(en: .italiano) == "ciclo esatonico")
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
            let nota = Nota(texto: espanol)!
            for (notacion, nombre) in [(Notacion.occitano, occitano), (.ruso, ruso), (.griego, griego)] {
                #expect(nota.nombre(en: notacion) == nombre)
                #expect(try (Nota(leyendo: nombre, en: notacion)) == nota, Comment(rawValue: nombre))
                #expect(Nota(texto: nombre) == nota, Comment(rawValue: nombre))
                #expect(Nota(texto: nota.nombreCompacto(en: notacion)) == nota, Comment(rawValue: nombre))
            }
        }
        // Sin tildes y con o sin guion.
        #expect(Nota(texto: "σι υφεση") == Nota("Sib"))
        #expect(Nota(texto: "фа диез") == Nota("Fa#"))
        #expect(Nota(texto: "sol diesi") == Nota("Sol#"))
        #expect(Nota("Reb").nombreCompacto(en: .ruso) == "Ре♭")
        #expect(Nota("Reb").nombreCompacto(en: .griego) == "Ρε♭")
        #expect(Nota("Sol#").nombreCompacto(en: .occitano) == "Sòl♯")
        #expect(Acorde("Fa#m7").cifrado(en: .ruso) == "Фа♯m7")
        #expect(Altura("Fa#3").nombre(en: .griego) == "φα δίεση 3")
        #expect(Altura("Fa#3").nombre(en: .ruso) == "фа-диез3")
        #expect(Altura("фа-диез3") == Altura("Fa#3"))
        #expect(Altura("σι ύφεση 4") == Altura("Sib4"))
        #expect(Altura("sòl dièsi 2") == Altura("Sol#2"))
        #expect(Alteracion(-1).nombre(en: .griego) == "ύφεση")
        #expect(Alteracion(2).nombre(en: .ruso) == "дубль-диез")
        #expect(Alteracion(0).nombre(en: .occitano) == "becarre")
        // Tonalidades.
        #expect(Tonalidad("Fa# mayor").nombre(en: .ruso) == "фа-диез мажор")
        #expect(Tonalidad("La menor").nombre(en: .ruso) == "ля минор")
        #expect(Tonalidad("Re mayor").nombre(en: .griego) == "ρε μείζονα")
        #expect(Tonalidad("Sib menor").nombre(en: .griego) == "σι ύφεση ελάσσονα")
        #expect(Tonalidad("Sol mayor").nombre(en: .occitano) == "sòl major")
        #expect(Tonalidad("ре мажор") == Tonalidad("Re mayor"))
        #expect(Tonalidad("σι ύφεση ελάσσονα") == Tonalidad("Sib menor"))
        #expect(Tonalidad("fa dièsi menor") == Tonalidad("Fa# menor"))
        // Los demás textos, en el idioma de las notas.
        #expect(Notacion.ruso.textos == .ruso)
        #expect(Intervalo.terceraMayor.nombre(en: .griego) == "μεγάλη τρίτη")
        #expect(Acorde("Sol7/Si").nombre(en: .ruso) == "доминантсептаккорд от соль, первое обращение")
        #expect(Escala(.re, .dorico).nombre(en: .occitano) == "re dorian")
    }
}
