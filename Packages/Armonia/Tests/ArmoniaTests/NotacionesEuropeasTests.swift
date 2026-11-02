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
            let nombre = Nota(texto: espanol)!
            #expect(nombre.nombre(en: .alemanCompacto) == aleman, Comment(rawValue: espanol))
            #expect(nombre.nombreCompacto(en: .alemanPalabras) == aleman, Comment(rawValue: espanol))
            #expect(try (Nota(leyendo: aleman, en: .alemanCompacto)) == nombre, Comment(rawValue: aleman))
            #expect(try (Nota(leyendo: aleman, en: .alemanPalabras)) == nombre, Comment(rawValue: aleman))
            let conPalabras = nombre.nombre(en: .alemanPalabras)
            #expect(try (Nota(leyendo: conPalabras, en: .alemanPalabras)) == nombre, Comment(rawValue: conPalabras))
            #expect(try (Nota(leyendo: conPalabras, en: .alemanCompacto)) == nombre, Comment(rawValue: conPalabras))
        }
        #expect(try (Nota(leyendo: "fis", en: .alemanCompacto)) == Nota("Fa#"))
        #expect(Altura("Fa#4").nombre(en: .alemanCompacto) == "Fis₄")
        #expect(Altura("Fa#4").nombre(en: .alemanCompacto.conOctavas(.cifras)) == "Fis4")
        #expect(try (Altura(leyendo: "B3", en: .alemanCompacto)) == Altura("Sib3"))
        #expect(try (Altura(leyendo: "Fis₄", en: .alemanCompacto)) == Altura("Fa#4"))
        // Con palabras: la letra y «Kreuz» o «Be», como «Fa sostenido».
        #expect(Nota("Fa#").nombre(en: .alemanPalabras) == "F Kreuz")
        // El Si♭ es B también con palabras, y «H Be» se sigue leyendo.
        #expect(Nota("Sib").nombre(en: .alemanPalabras) == "B")
        #expect(Nota("Sibb").nombre(en: .alemanPalabras) == "H Doppel-Be")
        #expect(try (Nota(leyendo: "H Be", en: .alemanPalabras)) == Nota("Sib"))
        #expect(Altura("Sib3").nombre(en: .alemanPalabras) == "B3")
        #expect(Nota("Mibb").nombre(en: .alemanPalabras) == "E Doppel-Be")
        #expect(Nota("Do").nombre(en: .alemanPalabras) == "C")
        #expect(Altura("Fa#4").nombre(en: .alemanPalabras) == "F Kreuz 4")
        #expect(try (Altura(leyendo: "F Kreuz 4", en: .alemanPalabras)) == Altura("Fa#4"))
        #expect(Tonalidad("Fa# mayor").nombre(en: .alemanCompacto) == "Fis-Dur")
        #expect(Escala("Fa# dórico").nombre(en: .alemanCompacto) == "Fis dorisch")
        #expect(Acorde("Sib7").cifrado(en: .alemanPalabras) == "B7")
        #expect(Acorde("Sim7").cifrado(en: .alemanPalabras) == "Hm7")
        #expect(Acorde("Fa#7(b9)").cifrado(en: .alemanPalabras) == "Fis7(b9)")
        #expect(Tonalidad("Fa# mayor").nombre(en: .alemanPalabras) == "Fis-Dur")
        #expect(Tonalidad("La menor").nombre(en: .alemanPalabras) == "a-Moll")
        #expect(Tonalidad("Sib mayor").nombre(en: .alemanPalabras) == "B-Dur")
        #expect(Tonalidad("Fis-Dur") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad("es-Moll") == Tonalidad("Mib menor"))
        #expect(Alteracion(2).nombre(en: .alemanPalabras) == "Doppelkreuz")
        #expect(Alteracion(-1).nombre(en: .alemanPalabras) == "Be")
        #expect(throws: (any Error).self) { try Nota(leyendo: "Xis", en: .alemanPalabras) }
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
        #expect(Nota("Fa#").nombre(en: .hungaroPalabras) == "F kereszt")
        #expect(Nota("Sib").nombre(en: .hungaroPalabras) == "H bé")
        #expect(Acorde("Fa#7").cifrado(en: .hungaroPalabras) == "Fisz7")
        #expect(Tonalidad("Fa# mayor").nombre(en: .hungaroPalabras) == "Fisz-dúr")
        #expect(try (Nota(leyendo: "Fisz", en: .hungaroPalabras)) == Nota("Fa#"))
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
        #expect(Alteracion(1).nombre(en: .hungaroPalabras) == "kereszt")
        #expect(Alteracion(-2).nombre(en: .hungaroPalabras) == "kettős bé")
        #expect(Idioma(codigo: "hu-HU") == .hungaro)
        #expect(Idioma(nombre: "magyar") == .hungaro)
        #expect(Idioma(nombre: "húngaro") == .hungaro)
        #expect(Idioma.hungaro.nombrePropio == "Magyar")
        // Los textos.
        #expect(Intervalo.terceraMayor.nombre(en: .hungaroPalabras) == "nagy terc")
        #expect(Intervalo("P5").nombre(en: .hungaroPalabras) == "tiszta kvint")
        #expect(Intervalo("-m6").nombre(en: .hungaroPalabras) == "lefelé kis szext")
        #expect(Acorde("Sol7").nombre(en: .hungaroPalabras) == "G domináns szeptimakkord, alaphelyzet")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .hungaroPalabras) == "I–IV–V7–I C-dúrban")
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
        #expect(Nota("Re").nombre(en: .francesPalabras) == "ré")
        #expect(Nota("Mib").nombre(en: .francesPalabras) == "mi bémol")
        #expect(Nota("Fa#").nombre(en: .francesPalabras) == "fa dièse")
        #expect(Nota("Dox").nombre(en: .francesPalabras) == "do double dièse")
        #expect(Nota("Mib").nombre(en: .italianoPalabras) == "mi bemolle")
        #expect(Nota("Re#").nombre(en: .italianoPalabras) == "re diesis")
        #expect(Nota("Sibb").nombre(en: .italianoPalabras) == "si doppio bemolle")
        #expect(Nota("Reb").nombreCompacto(en: .francesPalabras) == "Ré♭")
        #expect(Nota("Reb").nombreCompacto(en: .italianoPalabras) == "Re♭")
        #expect(Altura("Fa#3").nombre(en: .francesPalabras) == "fa dièse 3")
        #expect(Altura("Re4").nombre(en: .francesPalabras) == "ré4")
        #expect(try (Altura(leyendo: "fa dièse 3", en: .francesPalabras)) == Altura("Fa#3"))
        #expect(try (Altura(leyendo: "re diesis 5", en: .italianoPalabras)) == Altura("Re#5"))
        #expect(try (Nota(leyendo: "RE BEMOL", en: .francesPalabras)) == Nota("Reb"))
        #expect(try (Nota(leyendo: "Ré♭", en: .francesPalabras)) == Nota("Reb"))
        #expect(Acorde("Fa#m7").cifrado(en: .francesPalabras) == "Fa♯m7")
        #expect(Acorde("Rebmaj7").cifrado(en: .francesPalabras) == "Ré♭maj7")
        #expect(Tonalidad("Reb mayor").nombre(en: .francesPalabras) == "ré bémol majeur")
        #expect(Tonalidad("Fa# menor").nombre(en: .italianoPalabras) == "fa diesis minore")
        #expect(Tonalidad("ré bémol majeur") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("la minore") == Tonalidad("La menor"))
        #expect(Alteracion(-2).nombre(en: .francesPalabras) == "double bémol")
        #expect(Alteracion(1).nombre(en: .italianoPalabras) == "diesis")
        #expect(Alteracion.natural.nombre(en: .italianoPalabras) == "bequadro")
        #expect(Alteracion("bémol") == .bemol)
        #expect(Alteracion("doppio diesis") == .dobleSostenido)
    }

    /// Los textos del motor y los catálogos en portugués, francés e italiano.
    @Test func textosEnPortuguesFrancesItaliano() throws {
        #expect(Notacion.francesPalabras.textos == .frances)
        #expect(Notacion.italianoPalabras.textos == .italiano)

        let sexta = try Intervalo(leyendo: "-6m")
        #expect(sexta.nombre(en: .portuguesPalabras) == "6ª menor descendente")
        #expect(sexta.nombre(en: .francesPalabras) == "sixte mineure descendante")
        #expect(sexta.nombre(en: .italianoPalabras) == "sesta minore discendente")
        #expect(Intervalo.terceraMayor.nombre(en: .portuguesPalabras) == "3ª maior")
        #expect(Intervalo.quintaJusta.nombre(en: .francesPalabras) == "quinte juste")
        #expect(Intervalo.terceraMayor.nombre(en: .italianoPalabras) == "terza maggiore")
        // El unísono es masculino.
        let unisono = try Intervalo(leyendo: "1A")
        #expect(unisono.nombre(en: .francesPalabras) == "unisson augmenté")
        #expect(unisono.nombre(en: .italianoPalabras) == "unisono aumentato")
        #expect(CalidadDeIntervalo.disminuida(2).nombre(en: .francesPalabras) == "doublement diminuée")
        #expect(Consonancia.perfecta.nombre(en: .italianoPalabras) == "consonanza perfetta")
        #expect(PapelEnAcorde.fundamental.nombre(en: .francesPalabras) == "fondamentale")
        #expect(NombreDeGrado.sensible.nombre(en: .portuguesPalabras) == "sensível")
        #expect(Clave.sol.nombre(en: .italianoPalabras) == "chiave di violino")
        #expect(Duracion(.negra, puntillos: 1).nombre(en: .francesPalabras) == "noire pointée")
        #expect(Duracion(.corchea, puntillos: 2).nombre(en: .italianoPalabras) == "croma doppiamente puntata")
        #expect(Figura.blanca.nombre(en: .portuguesPalabras) == "mínima")
        #expect(Cadencia.Tipo.rota.nombre(en: .francesPalabras) == "cadence rompue")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .portuguesPalabras)
                == "I–IV–V7–I em dó maior")
        #expect(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .italianoPalabras)
                == "i–V7–i in la minore")

        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .francesPalabras) == "septième de dominante")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .italianoPalabras) == "settima di dominante")
        #expect(Acorde("Sol7/Si").nombre(en: .portuguesPalabras) == "sol sétima de dominante, primeira inversão")
        #expect(Acorde("Sol7/Si").nombre(en: .francesPalabras) == "sol septième de dominante, premier renversement")
        #expect(Acorde("Sol7/Si").nombre(en: .italianoPalabras) == "sol settima di dominante, primo rivolto")
        #expect(Acorde("Do/Re").nombre(en: .italianoPalabras) == "do maggiore, con il basso in re")
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            #expect(
                !(nombre.portugues.isEmpty || nombre.frances.isEmpty || nombre.italiano.isEmpty),
                Comment(rawValue: nombre.espanol))
        }

        #expect(Escala(.re, .dorico).nombre(en: .francesPalabras) == "ré dorien")
        #expect(Escala(.la, .menorArmonica).nombre(en: .italianoPalabras) == "la minore armonica")
        #expect(Escala("dó maior") == Escala("Do mayor"))
        #expect(Escala(.re, .hirajoshi).nombre(en: .francesPalabras) == ("ré " + TipoDeEscala.hirajoshi.nombre))
        // Cada escala del catálogo tiene nombre en los tres idiomas; la portuguesa se vuelve a leer igual.
        for tipo in TipoDeEscala.todos {
            for idioma in [Idioma.portugues, .frances, .italiano] {
                #expect(NombresDeEscalas.de(idioma).porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            let nombre = escala.nombre(en: .portuguesPalabras)
            #expect(Escala(texto: nombre) == escala, "\(nombre) (\(tipo.nombre))")
        }

        #expect(InstrumentoDePartitura.clarineteEnSib.nombre(en: .francesPalabras) == "clarinette en si♭")
        #expect(InstrumentoDePartitura.violin.nombre(en: .portuguesPalabras) == "violino")
        #expect(InstrumentoDePartitura.saxofonAlto.nombre(en: .italianoPalabras) == "sassofono contralto")
        for instrumento in InstrumentoDePartitura.todos {
            #expect(
                InstrumentoDePartitura.traducciones[instrumento.nombre] != nil, Comment(rawValue: instrumento.nombre))
        }
        #expect(InstrumentoDePartitura.traducciones.count == InstrumentoDePartitura.todos.count)
        // Un instrumento propio usa su nombre español o, en alemán, su nombre inglés.
        let propio = InstrumentoDePartitura(nombre: "laúd", nombreEnIngles: "lute")
        #expect(propio.nombre(en: .francesPalabras) == "laúd")
        #expect(propio.nombre(en: .alemanPalabras) == "lute")
        #expect(CicloNeorriemanniano.hexatonico.nombre(en: .italianoPalabras) == "ciclo esatonico")
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
            for (notacion, nombre) in [
                (Notacion.occitanoPalabras, occitano), (.rusoPalabras, ruso), (.griegoPalabras, griego),
            ] {
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
        #expect(Nota("Reb").nombreCompacto(en: .rusoPalabras) == "Ре♭")
        #expect(Nota("Reb").nombreCompacto(en: .griegoPalabras) == "Ρε♭")
        #expect(Nota("Sol#").nombreCompacto(en: .occitanoPalabras) == "Sòl♯")
        #expect(Acorde("Fa#m7").cifrado(en: .rusoPalabras) == "Фа♯m7")
        #expect(Altura("Fa#3").nombre(en: .griegoPalabras) == "φα δίεση 3")
        #expect(Altura("Fa#3").nombre(en: .rusoPalabras) == "фа-диез3")
        #expect(Altura("фа-диез3") == Altura("Fa#3"))
        #expect(Altura("σι ύφεση 4") == Altura("Sib4"))
        #expect(Altura("sòl dièsi 2") == Altura("Sol#2"))
        #expect(Alteracion(-1).nombre(en: .griegoPalabras) == "ύφεση")
        #expect(Alteracion(2).nombre(en: .rusoPalabras) == "дубль-диез")
        #expect(Alteracion(0).nombre(en: .occitanoPalabras) == "becarre")
        // Tonalidades.
        #expect(Tonalidad("Fa# mayor").nombre(en: .rusoPalabras) == "фа-диез мажор")
        #expect(Tonalidad("La menor").nombre(en: .rusoPalabras) == "ля минор")
        #expect(Tonalidad("Re mayor").nombre(en: .griegoPalabras) == "ρε μείζονα")
        #expect(Tonalidad("Sib menor").nombre(en: .griegoPalabras) == "σι ύφεση ελάσσονα")
        #expect(Tonalidad("Sol mayor").nombre(en: .occitanoPalabras) == "sòl major")
        #expect(Tonalidad("ре мажор") == Tonalidad("Re mayor"))
        #expect(Tonalidad("σι ύφεση ελάσσονα") == Tonalidad("Sib menor"))
        #expect(Tonalidad("fa dièsi menor") == Tonalidad("Fa# menor"))
        // Los demás textos, en el idioma de las notas.
        #expect(Notacion.rusoPalabras.textos == .ruso)
        #expect(Intervalo.terceraMayor.nombre(en: .griegoPalabras) == "μεγάλη τρίτη")
        #expect(Acorde("Sol7/Si").nombre(en: .rusoPalabras) == "доминантсептаккорд от соль, первое обращение")
        #expect(Escala(.re, .dorico).nombre(en: .occitanoPalabras) == "re dorian")
    }
}
