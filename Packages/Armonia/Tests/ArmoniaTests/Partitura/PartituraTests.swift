import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct MelodiaTests {
    let arpegio: Melodia = ["Do4", "Mi4", "Sol4"]

    @Test func propiedades() {
        #expect(arpegio.count == 3)
        #expect(arpegio[1] == Altura("Mi4"))
        #expect(arpegio.intervalos == [.terceraMayor, .terceraMenor])
        #expect(Melodia(["Do4", "Re4", "Re4", "Si3"]).contorno == [1, 0, -1])
        #expect(arpegio.ambito == .quintaJusta)
        #expect(arpegio.alturaMasGrave == Altura("Do4"))
        #expect(arpegio.midi == [60, 64, 67])
        #expect(arpegio.conjuntoDeClases.numeroDeForte == "3-11")
        #expect(Melodia([]).ambito == nil)
    }

    @Test func transformaciones() {
        #expect(arpegio.transponer(.segundaMayor).description == "Re4 Fa♯4 La4")
        #expect(arpegio.invertir().description == "Do4 La♭3 Fa3")
        #expect(arpegio.invertir(alrededorDe: "Mi4").description == "Sol♯4 Mi4 Do♯4")
        #expect(arpegio.retrogradar().description == "Sol4 Mi4 Do4")
        #expect(arpegio.retrogradarInversion().description == "Fa3 La♭3 Do4")
        #expect(arpegio.invertir().invertir() == arpegio)
    }

    @Test func transposicionTonal() {
        let doMayor = Escala(.do)
        #expect(arpegio.transponer(grados: 1, en: doMayor)?.description == "Re4 Fa4 La4")
        #expect(arpegio.transponer(grados: -1, en: doMayor)?.description == "Si3 Re4 Fa4")
        #expect(arpegio.transponer(grados: 7, en: doMayor)?.description == "Do5 Mi5 Sol5")
        #expect(Melodia(["Do4", "Do#4", "Re4"]).transponer(grados: 2, en: doMayor)?.description == "Mi4 Mi♯4 Fa4")
        let armonica = Escala(.la, .menorArmonica)
        #expect(Melodia(["La4", "Do5", "Mi5"]).transponer(grados: 1, en: armonica)?.description == "Si4 Re5 Fa5")
        #expect(Melodia(["Mi5", "Fa5", "Mi5"]).transponer(grados: -1, en: armonica)?.description == "Re5 Mi5 Re5")
        // Una nota ajena a la escala conserva su alteración relativa: Sol♮ es el 7.º grado
        // rebajado de La menor armónica, y cuatro grados más arriba se convierte en el 4.º rebajado.
        #expect(Melodia(["Sol4"]).transponer(grados: 4, en: armonica)?.description == "Re♭5")
        #expect(arpegio.transponer(grados: 1, en: Escala(.do, .pentatonicaMayor)) == nil)
    }

    @Test func desdeMidiYCodable() throws {
        let melodia = Melodia(midi: [69, 71, 72, 74, 76, 77, 80, 81])
        #expect(melodia.description == "La4 Si4 Do5 Re5 Mi5 Fa5 Sol♯5 La5")
        #expect(Melodia(midi: [70], escala: Escala(.fa)).description == "Si♭4")
        #expect(melodia.candidatosDeTonalidad.first?.valor == Tonalidad(.la, .menor))

        let datos = try JSONEncoder().encode(arpegio)
        #expect(String(decoding: datos, as: UTF8.self) == "[\"Do4\",\"Mi4\",\"Sol4\"]")
        #expect(try (JSONDecoder().decode(Melodia.self, from: datos)) == arpegio)
    }
}

@Suite struct RitmoTests {
    @Test func figuras() {
        #expect(Figura.negra.duracion == Duracion(1, 4))
        #expect(Figura.cuadrada.duracion == Duracion(2))
        #expect(Figura.garrapatea.duracion == Duracion(1, 128))
        #expect(Figura.semicorchea.nombre == "semicorchea")
        #expect(Figura.corchea.nombre(en: .inglesASCII) == "eighth note")
    }

    @Test func duraciones() {
        #expect(Duracion(2, 8) == .negra)
        #expect(Duracion(.negra, puntillos: 1) == Duracion(3, 8))
        #expect(Duracion(.negra, puntillos: 2) == Duracion(7, 16))
        #expect(Duracion.corchea.grupoIrregular(3, en: 2) == Duracion(1, 12))
        #expect(Duracion.semicorchea.grupoIrregular(5, en: 4) == Duracion(1, 20))
        #expect((Duracion.blanca + .corchea) == Duracion(5, 8))
        #expect((Duracion.blanca - .corchea) == Duracion(3, 8))
        #expect((Duracion.negra * 3) == Duracion(3, 4))
        #expect((Duracion.blanca / .negra) == Duracion(2))
        #expect([Duracion.negra, .corchea, .corchea].sumar() == .blanca)
        #expect(Duracion.negra < .blanca)
        #expect(Duracion.negra.enRedondas == 0.25)
    }

    @Test func escrituraDeDuraciones() {
        #expect(Duracion(3, 8).figuraYPuntillos?.figura == .negra)
        #expect(Duracion(3, 8).figuraYPuntillos?.puntillos == 1)
        #expect(Duracion(5, 8).figuraYPuntillos == nil)
        #expect(Duracion(5, 8).descomposicion == [.blanca, .corchea])
        #expect(Duracion(11, 16).descomposicion == [.blanca, .corchea, .semicorchea])
        #expect(Duracion(7, 8).descomposicion == [Duracion(7, 8)])
        #expect(Duracion(1, 12).descomposicion == nil)
        #expect(Duracion(3, 8).nombre == "negra con puntillo")
        #expect(Duracion(7, 8).nombre == "blanca con doble puntillo")
        #expect(Duracion(5, 8).nombre == "5/8 de redonda")
        #expect(Duracion(3, 8).nombre(en: .inglesASCII) == "dotted quarter note")
        #expect(Duracion.corchea.ticks(porNegra: 480) == 240)
        #expect(Duracion(1, 12).ticks(porNegra: 480) == 160)
        #expect(Duracion(1, 7).ticks(porNegra: 480) == nil)
    }

    @Test func lecturaDeDuraciones() throws {
        let casos: [(String, Duracion)] = [
            ("1", .redonda), ("4", .negra), ("16", .semicorchea), ("8.", Duracion(3, 16)),
            ("2..", Duracion(7, 8)), ("1/12", Duracion(1, 12)), ("5/8", Duracion(5, 8)),
            ("2/1", .cuadrada), ("128", .garrapatea),
        ]
        for (texto, duracion) in casos {
            #expect(Duracion(texto: texto) == duracion, Comment(rawValue: texto))
            #expect(duracion.texto == texto, Comment(rawValue: texto))
        }
        for malo in ["3", "0", "4.x", "1/0", "", "256", "-4"] {
            #expect(Duracion(texto: malo) == nil, Comment(rawValue: malo))
        }
        do {
            _ = try Duracion(leyendo: "3")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.motivo == .duracionNoValida("3"))

        }
    }

    @Test func compases() {
        let seisOcho: Compas = "6/8"
        #expect(seisOcho.tipo == .compuesto)
        #expect(seisOcho.pulsos == 2)
        #expect(seisOcho.pulso == Duracion(.negra, puntillos: 1))
        #expect(Compas("12/8").pulsos == 4)
        #expect(Compas("3/4").tipo == .simple)
        #expect(Compas("3/4").duracion == Duracion(.blanca, puntillos: 1))
        #expect(Compas("7/8").tipo == .amalgama)
        #expect(Compas("7/8").pulsos == 3) // 2+2+3
        #expect(Compas("C") == .compasillo)
        #expect(Compas("¢") == .partido)
        #expect(Compas.compasillo.duracion == .redonda)
        #expect(Compas(texto: "4/3") == nil)
        #expect(Compas(texto: "0/4") == nil)
        #expect(seisOcho.texto == "6/8")
    }

    @Test func tempo() {
        #expect(abs(Tempo(120).segundos(de: .blanca) - (1)) <= 1e-12)
        #expect(abs(Tempo(60, unidad: Duracion(.negra, puntillos: 1)).negrasPorMinuto - (90)) <= 1e-12)
        #expect(Tempo(100).indicacion == "Andante")
        #expect(Tempo(130).indicacion == "Allegro")
        #expect(Tempo(30).indicacion == "Grave")
        #expect(Tempo(220).indicacion == "Prestissimo")
        #expect(Tempo(120).description == "♩ = 120")
    }

    @Test func eventos() throws {
        let e: Evento = "Do4:4."
        #expect(e.alturas == [Altura("Do4")])
        #expect(e.duracion == Duracion(3, 8))
        #expect(Evento("Do4+Mi4+Sol4:2").alturas.count == 3)
        #expect(Evento("-:8") == .silencio(.corchea))
        #expect(Evento("silencio:8") == .silencio(.corchea))
        #expect(Evento("Re4:2~").ligada)
        #expect(!(Evento.silencio(.negra).ligada))
        for texto in ["Do4:4.", "Do4+Mi4+Sol4:2", "-:8", "Re4:2~", "Fa♯3:1/12"] {
            #expect(Evento(texto: texto)?.texto == texto, Comment(rawValue: texto))
        }
        do {
            _ = try Evento(leyendo: "Do4:3")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.motivo == .duracionNoValida("3"))
            #expect((error as? ErrorDeLectura)?.posicion == 4)

        }
        #expect(Evento(texto: "Do4") == nil)
        #expect(Evento("Do4:4").transponer(.quintaJusta) == Evento("Sol4:4"))
    }

    @Test func voces() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4", compas: "3/4")
        #expect(voz.duracion == Duracion(3, 2))
        #expect(voz.ritmo.map(\.texto) == ["4", "8", "8", "2.", "4"])
        #expect(voz.melodia.alturas.map(\.description) == ["Do4", "Re4", "Mi4", "Fa4", "Sol4"])
        #expect(abs(voz.segundos(tempo: Tempo(90)) - (4)) <= 1e-12)
        #expect(voz.terminaEnBarra)
        let compases = voz.compases
        #expect(compases.map { $0.map(\.texto) } == [["Do4:4", "Re4:8", "Mi4:8", "Fa4:4~"], ["Fa4:2", "Sol4:4"]])
        // Repartir en compases no cambia la melodía: la nota ligada cuenta una vez.
        #expect(Voz(compases.flatMap { $0 }, compas: voz.compas).melodia == voz.melodia)
        #expect(voz.description == "3/4 Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4")
    }

    @Test func anacrusaYSilencios() throws {
        let himno = try Voz(leyendo: "Sol3:4 Do4:2. Re4:4", compas: "3/4", anacrusa: .negra)
        #expect(himno.compases.map { $0.map(\.texto) } == [["Sol3:4"], ["Do4:2."], ["Re4:4"]])
        #expect(!himno.terminaEnBarra)
        let silencio = try Voz(leyendo: "-:1", compas: "3/4")
        #expect(silencio.compases.map { $0.map(\.texto) } == [["-:2."], ["-:4"]])
        do {
            _ = try Voz(leyendo: "Do4:4 Re4:3")
            Issue.record("Se esperaba un error")
        } catch {
            #expect((error as? ErrorDeLectura)?.posicion == 10)

        }
    }

    @Test func transformacionesYMelodia() throws {
        let voz = try Voz(leyendo: "Do4:2~ Do4:4 Re4:4")
        #expect(voz.retrogradar().texto() == "Re4:4 Do4:4~ Do4:2")
        #expect(voz.aumentar(2).ritmo == [.redonda, .blanca, .blanca])
        #expect(voz.disminuir(2).ritmo == [.negra, .corchea, .corchea])
        #expect(voz.transponer(.segundaMayor).melodia.alturas.first == Altura("Re4"))
        #expect(voz.melodia.alturas.count == 2)
        let unida = Voz(melodia: ["Do4", "Mi4", "Sol4"], ritmo: [.negra, .negra, .blanca], compas: "3/4")
        #expect(unida?.texto(en: .inglesASCII) == "C4:4 E4:4 G4:2")
        #expect(Voz(melodia: ["Do4", "Mi4"], ritmo: [.negra]) == nil)
        // Se codifica en JSON y vuelve igual.
        let datos = try JSONEncoder().encode(voz)
        #expect(try (JSONDecoder().decode(Voz.self, from: datos)) == voz)
    }

    /// Al imprimir, una duración da su nombre; `texto` da la forma corta que se lee.
    @Test func descripcionDeDuracion() {
        let d = Duracion(.negra, puntillos: 1)
        #expect("\(d)" == "negra con puntillo")
        #expect(d.texto == "4.")
        #expect(Duracion(texto: d.texto) == d)
        #expect("\(Duracion.blanca + .corchea)" == "5/8 de redonda")
        #expect((Duracion.blanca + .corchea).texto == "5/8")
        #expect(Duracion.corchea.nombre(en: .inglesASCII) == "eighth note")
        #expect("\(Duracion.cero)" == "cero")
    }
}

@Suite struct MetricaTests {
    @Test func agrupaciones() {
        #expect(Compas.compasillo.agrupacion == [1, 1, 1, 1])
        #expect(Compas("6/8").agrupacion == [3, 3])
        #expect(Compas("12/8").agrupacion == [3, 3, 3, 3])
        #expect(Compas("5/8").agrupacion == [2, 3])
        #expect(Compas("7/8").agrupacion == [2, 2, 3])
        let siete = Compas("3+2+2/8")
        #expect(siete.agrupacion == [3, 2, 2])
        #expect(siete.numerador == 7)
        #expect(siete.texto == "3+2+2/8")
        #expect(Compas("7/8").texto == "7/8")
        #expect(siete != Compas("7/8"))
        #expect(Compas("2+2+3/8") == Compas("7/8"))
        #expect(siete.duracionesDePulso == [Duracion(.negra, puntillos: 1), .negra, .negra])
        #expect(Compas("7/8").pulso == .corchea)
        #expect(Compas("6/8").iniciosDePulso == [.cero, Duracion(3, 8)])
        #expect(Compas(texto: "2+0/8") == nil)
        #expect(Compas(texto: "+/8") == nil)
    }

    @Test func acentos() {
        let cuatro = Compas.compasillo
        #expect((0..<4).map { cuatro.acento(pulso: $0) } == [.fuerte, .debil, .semifuerte, .debil])
        #expect((0..<3).map { Compas("3/4").acento(pulso: $0) } == [.fuerte, .debil, .debil])
        #expect((0..<2).map { Compas("6/8").acento(pulso: $0) } == [.fuerte, .debil])
        #expect((0..<4).map { Compas("12/8").acento(pulso: $0) } == [.fuerte, .debil, .semifuerte, .debil])
        #expect((0..<3).map { Compas("7/8").acento(pulso: $0) } == [.fuerte, .debil, .semifuerte])
        #expect(cuatro.acento(en: .blanca) == .semifuerte)
        #expect(cuatro.acento(en: .corchea) == nil)
        #expect(Compas.Acento.fuerte > .semifuerte)
    }

    @Test func escrituraEnCompasillo() throws {
        func escrito(_ texto: String, _ compas: Compas = .compasillo) throws -> [[String]] {
            try Voz(leyendo: texto, compas: compas).grafia.map { $0.map(\.texto) }
        }
        // La blanca del 2.º tiempo no oculta la mitad del compás.
        #expect(try (escrito("Do4:4 Re4:2 Mi4:4")) == [["Do4:4", "Re4:4~", "Re4:4", "Mi4:4"]])
        // En el 1.er tiempo sí puede durar hasta la mitad o más.
        #expect(try (escrito("Do4:2 Re4:2")) == [["Do4:2", "Re4:2"]])
        #expect(try (escrito("Do4:2. Re4:4")) == [["Do4:2.", "Re4:4"]])
        #expect(try (escrito("Do4:1")) == [["Do4:1"]])
        // La negra con puntillo del 1.er o del 3.er tiempo se escribe entera.
        #expect(try (escrito("Do4:4. Re4:8 Mi4:4. Fa4:8")) == [["Do4:4.", "Re4:8", "Mi4:4.", "Fa4:8"]])
        #expect(try (escrito("Do4:4.. Re4:16 Mi4:2")) == [["Do4:4..", "Re4:16", "Mi4:2"]])
        #expect(try (escrito("Do4:4. Re4:8", Compas(3, 4))) == [["Do4:4.", "Re4:8"]])
        #expect(try (escrito("Do4:4 Re4:4. Mi4:8", Compas(3, 4))) == [["Do4:4", "Re4:4.", "Mi4:8"]])
        #expect(try (escrito("Do4:2. Re4:4", .partido)) == [["Do4:2.", "Re4:4"]])
        // La corchea con puntillo a contratiempo no: empieza fuera del pulso.
        #expect(try (escrito("Do4:8 Re4:4. Mi4:2")) == [["Do4:8", "Re4:8~", "Re4:4", "Mi4:2"]])
        // Negra con puntillo en el 2.º tiempo de 4/4: se ve el 3.º.
        #expect(try (escrito("Do4:4 Re4:4. Mi4:8 Fa4:4")) == [["Do4:4", "Re4:4~", "Re4:8", "Mi4:8", "Fa4:4"]])
        // Una síncopa de corchea: la negra a contratiempo se parte en el pulso.
        #expect(try (escrito("Do4:8 Re4:4 Mi4:8 Fa4:2")) == [["Do4:8", "Re4:8~", "Re4:8", "Mi4:8", "Fa4:2"]])
        // 5/8 de redonda se escribe con figuras ligadas; la negra a contratiempo se parte en el 4.º tiempo.
        #expect(try (escrito("Do4:5/8 Re4:4 Mi4:8")) == [["Do4:2~", "Do4:8", "Re4:8~", "Re4:8", "Mi4:8"]])
        // Los silencios se dividen sin ligaduras.
        #expect(try (escrito("Do4:4 -:2 Re4:4")) == [["Do4:4", "-:4", "-:4", "Re4:4"]])
        // Una nota que cruza la barra se liga al compás siguiente y se escribe según la métrica
        // (la blanca con puntillo del 2.º tiempo no oculta la mitad).
        #expect(try (escrito("Do4:2. Re4:2 Mi4:2.")) == [["Do4:2.", "Re4:4~"], ["Re4:4", "Mi4:4~", "Mi4:2"]])
    }

    @Test func escrituraEnSeisPorOcho() throws {
        func escrito(_ texto: String) throws -> [[String]] {
            try Voz(leyendo: texto, compas: "6/8").grafia.map { $0.map(\.texto) }
        }
        #expect(try (escrito("Do4:4. Re4:4.")) == [["Do4:4.", "Re4:4."]])
        #expect(try (escrito("Do4:8 Re4:4 Mi4:4.")) == [["Do4:8", "Re4:4", "Mi4:4."]])
        // La negra que empieza en la 3.ª corchea cruza el pulso: se parte.
        #expect(try (escrito("Do4:4 Re4:4 Mi4:4")) == [["Do4:4", "Re4:8~", "Re4:8", "Mi4:4"]])
        #expect(try (escrito("Do4:2.")) == [["Do4:2."]])
        // En 6/8 la negra con puntillo no cruza el grupo de tres corcheas.
        #expect(try (escrito("Do4:8 Re4:4. Mi4:4")) == [["Do4:8", "Re4:4~", "Re4:8", "Mi4:4"]])
    }

    @Test func escrituraEnAmalgama() throws {
        func escrito(_ texto: String, _ compas: Compas) throws -> [[String]] {
            try Voz(leyendo: texto, compas: compas).grafia.map { $0.map(\.texto) }
        }
        // Una figura puede abarcar grupos iguales (la blanca de 2+2), pero no el paso a uno distinto.
        #expect(try (escrito("Do4:2 Mi4:4.", "7/8")) == [["Do4:2", "Mi4:4."]])
        #expect(try (escrito("Do4:2..", "7/8")) == [["Do4:2~", "Do4:4."]])
        #expect(try (escrito("Do4:2..", "3+2+2/8")) == [["Do4:4.~", "Do4:2"]])
        #expect(try (escrito("Do4:2. Re4:8", "7/8")) == [["Do4:2~", "Do4:4", "Re4:8"]])
        #expect(try (escrito("Do4:2. Re4:4", "3+3+2/8")) == [["Do4:2.", "Re4:4"]])
        // Las notas que cruzan el comienzo de un grupo se parten en él.
        #expect(try (escrito("Do4:4. Re4:4 Mi4:4", "7/8")) == [["Do4:4~", "Do4:8", "Re4:8~", "Re4:8", "Mi4:4"]])
        #expect(try (escrito("Do4:2 Re4:4.", "3+2+2/8")) == [["Do4:4.~", "Do4:8", "Re4:8~", "Re4:4"]])
        #expect(try (escrito("Do4:4. Re4:4", "5/8")) == [["Do4:4~", "Do4:8", "Re4:4"]])
        #expect(try (escrito("Do4:5/8", "5/8")) == [["Do4:4~", "Do4:4."]])
        // El silencio de todo el compás queda entero.
        #expect(try (escrito("-:7/8 Do4:2..", "7/8")) == [["-:2.."], ["Do4:2~", "Do4:4."]])
        #expect(try (escrito("-:5/8", "5/8")) == [["-:5/8"]])
        // Las barras siguen los grupos: 2+2+3.
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:8 La4:8 Si4:8", compas: "7/8")
        #expect(voz.barrasDeAgrupacion == [[[0, 1], [2, 3], [4, 5, 6]]])
    }

    @Test func barrasYAcentosDeLaVoz() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:8 La4:8", compas: "6/8")
        #expect(voz.barrasDeAgrupacion == [[[0, 1, 2], [3, 4, 5]]])
        #expect(voz.acentos == [[.fuerte, nil, nil, .debil, nil, nil]])
        let cuatro = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4 Fa4:16 Sol4:16 La4:8 -:8 Si4:8")
        #expect(cuatro.barrasDeAgrupacion == [[[0, 1], [3, 4, 5]]])
        #expect(cuatro.acentos.first?.first == .fuerte)
        // Con anacrusa, la primera nota cae en el último pulso del compás.
        let himno = try Voz(leyendo: "Sol3:4 Do4:2. Re4:4", compas: "3/4", anacrusa: .negra)
        #expect(himno.acentos == [[.debil], [.fuerte], [.fuerte]])
    }
}

@Suite struct PentagramaTests {
    @Test func claveDeSol() {
        let casos: [(Altura, Int, String)] = [
            ("Mi4", 0, "1.ª línea"), ("Fa4", 1, "1.er espacio"), ("Sol4", 2, "2.ª línea"),
            ("Do5", 5, "3.er espacio"), ("Fa5", 8, "5.ª línea"), ("Sol5", 9, "encima de la 5.ª línea"),
            ("La5", 10, "1.ª línea adicional superior"), ("Si5", 11, "encima de la 1.ª línea adicional superior"),
            ("Re4", -1, "debajo de la 1.ª línea"), ("Do4", -2, "1.ª línea adicional inferior"),
            ("Si3", -3, "debajo de la 1.ª línea adicional inferior"), ("La3", -4, "2.ª línea adicional inferior"),
        ]
        for (nota, lugar, descripcion) in casos {
            let posicion = Clave.sol.posicion(de: nota)
            #expect(posicion.lugar == lugar, Comment(rawValue: nota.description))
            #expect(posicion.descripcion == descripcion, Comment(rawValue: nota.description))
        }
        #expect(Clave.sol.posicion(de: "Do4").lineasAdicionales == -1)
        #expect(Clave.sol.posicion(de: "La3").lineasAdicionales == -2)
        #expect(Clave.sol.posicion(de: "Do6").lineasAdicionales == 2)
        #expect(Clave.sol.posicion(de: "Fa#4").description == "1.er espacio (♯)")
        #expect(Clave.sol.posicion(de: "Fa#4").lugar == Clave.sol.posicion(de: "Fa4").lugar)
    }

    @Test func otrasClaves() {
        #expect(Clave.fa.posicion(de: "Sol2").lugar == 0)
        #expect(Clave.fa.posicion(de: "La3").lugar == 8)
        #expect(Clave.fa.posicion(de: "Do4").lineasAdicionales == 1)
        #expect(Clave.doEnPrimera.posicion(de: "Do4").lugar == 0)
        #expect(Clave.doEnSegunda.posicion(de: "Do4").lugar == 2)
        #expect(Clave.doEnTercera.posicion(de: "Do4").lugar == 4)
        #expect(Clave.doEnCuarta.posicion(de: "Do4").lugar == 6)
        #expect(Clave.faEnTercera.posicion(de: "Fa3").lugar == 4)
        #expect(Clave.solOctavaBaja.posicion(de: "Mi3").lugar == 0)
        #expect(Clave.sol.alturaCentral == Altura("Si4"))
        #expect(Clave.fa.alturaCentral == Altura("Re3"))
        #expect(Clave.doEnTercera.alturaCentral == Altura("Do4"))
        #expect(Clave.fa.altura(lugar: 8) == Altura("La3"))
        #expect(Clave.sol.altura(lugar: 4, alteracion: -1) == Altura("Sib4"))
        #expect(Clave.doEnTercera.nombre(en: .inglesASCII) == "alto clef")
    }

    @Test func idaYVueltaDePosiciones() {
        for clave in Clave.allCases {
            for lugar in -12...20 {
                for alteracion in -2...2 {
                    let nota = clave.altura(lugar: lugar, alteracion: Alteracion(alteracion))
                    #expect(
                        clave.posicion(de: nota)
                            == PosicionEnPentagrama(lugar: lugar, alteracion: Alteracion(alteracion)),
                        "\(clave) \(lugar)")
                }
            }
        }
    }

    @Test func claveMasAdecuada() {
        #expect(Clave.masAdecuada(para: ["Do2", "Mi2", "Sol2"]) == .fa)
        #expect(Clave.masAdecuada(para: ["Do5", "Mi5", "Sol5"]) == .sol)
        #expect(Clave.masAdecuada(para: ["Do4", "Re4", "Mi4"], entre: [.sol, .fa, .doEnTercera]) == .doEnTercera)
    }
}

@Suite struct InstrumentosTests {
    @Test func transposicion() {
        #expect(InstrumentoDePartitura.clarineteEnSib.sonido(de: Altura("Do5")) == Altura("Sib4"))
        #expect(InstrumentoDePartitura.clarineteEnSib.escritura(de: Altura("Sib4")) == Altura("Do5"))
        #expect(InstrumentoDePartitura.clarineteEnLa.sonido(de: Altura("Do5")) == Altura("La4"))
        #expect(InstrumentoDePartitura.clarineteEnMib.sonido(de: Altura("Do5")) == Altura("Mib5"))
        #expect(InstrumentoDePartitura.trompaEnFa.sonido(de: Altura("Do5")) == Altura("Fa4"))
        #expect(InstrumentoDePartitura.saxofonAlto.sonido(de: Altura("Do5")) == Altura("Mib4"))
        #expect(InstrumentoDePartitura.saxofonTenor.sonido(de: Altura("Do5")) == Altura("Sib3"))
        #expect(InstrumentoDePartitura.saxofonBaritono.sonido(de: Altura("Do5")) == Altura("Mib3"))
        #expect(InstrumentoDePartitura.contrabajo.sonido(de: Altura("Do3")) == Altura("Do2"))
        #expect(InstrumentoDePartitura.guitarra.sonido(de: Altura("Mi4")) == Altura("Mi3"))
        #expect(InstrumentoDePartitura.flautin.sonido(de: Altura("Do5")) == Altura("Do6"))
        #expect(InstrumentoDePartitura.glockenspiel.sonido(de: Altura("Do5")) == Altura("Do7"))
        #expect(!InstrumentoDePartitura.piano.esTranspositor)
        #expect(InstrumentoDePartitura.trompetaEnSib.esTranspositor)
        #expect(InstrumentoDePartitura.todos.count == 30)
        #expect(InstrumentoDePartitura.viola.clave == .doEnTercera)
    }

    @Test func tonalidadesYAcordesEscritos() {
        #expect(InstrumentoDePartitura.clarineteEnSib.escritura(de: Escala("Mib mayor")) == Escala(.fa))
        #expect(InstrumentoDePartitura.saxofonAlto.escritura(de: Acorde("Do7")).cifrado == "La7")
        #expect(InstrumentoDePartitura.saxofonAlto.escritura(de: Escala("Si mayor")).nombre == "La♭ mayor")
        #expect(
            InstrumentoDePartitura.saxofonAlto.escritura(de: Escala("Si mayor"), simplificar: false).nombre
                == "Sol♯ mayor")
        #expect(InstrumentoDePartitura.trompaEnFa.escritura(de: Nota.fa) == .do)

        let melodia: Melodia = ["Do4", "Mi4", "Sol4"]
        let escrita = InstrumentoDePartitura.trompetaEnSib.escritura(de: melodia)
        #expect(escrita.description == "Re4 Fa♯4 La4")
        #expect(InstrumentoDePartitura.trompetaEnSib.sonido(de: escrita) == melodia)
        for instrumento in InstrumentoDePartitura.todos {
            for nota in ["Do4", "Fa#3", "Sib5"] as [Altura] {
                #expect(
                    instrumento.sonido(de: instrumento.escritura(de: nota)) == nota,
                    Comment(rawValue: instrumento.nombre))
            }
        }
    }
}
