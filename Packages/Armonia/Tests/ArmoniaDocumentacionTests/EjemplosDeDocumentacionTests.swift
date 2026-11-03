// swift-format-ignore-file
// Generado por Scripts/generadores/generar_pruebas_de_documentacion.py a partir de los bloques ```swift
// del README y del catálogo DocC. No lo edites a mano: cambia el ejemplo y vuelve a generarlo.

import Foundation
import Testing
@testable import Armonia
import Hexagonos

@Suite struct EjemplosDeDocumentacionTests {
    @Test func readme1() throws {
        // README.md, línea 11
        let i = Altura("Re5") - Altura("Do4")
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, #"README.md"#, 14)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, #"README.md"#, 15)
        comprobar(Altura("La4").frecuencia(), #"440.0"#, #"README.md"#, 16)
        comprobar(Altura(midi: 63, preferirBemoles: true), #"Mi♭4"#, #"README.md"#, 17)
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, #"README.md"#, 19)
        comprobar(Acorde.identificar([.mi, .sol, .do]).first, #"Do/Mi"#, #"README.md"#, 20)
        let menor = Escala("La menor armónica")
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, #"README.md"#, 23)
        comprobar(Escala("Mib mayor").armadura, #"-3"#, #"README.md"#, 25)
        comprobar(Escala(.do).rotacion(2), #"Re dórico"#, #"README.md"#, 26)
        _ = i
    }

    @Test func acordes1() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 13
        comprobar(Acorde("G7(b9,#11)").cifrado, #""Sol7(♭9,♯11)""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 13)
        comprobar(TipoDeAcorde("m11").cifrado, #""m11""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 14)
        comprobar(TipoDeAcorde("13sus4").intervalos, #"[1ª justa, 4ª justa, 5ª justa, 7ª menor, 9ª mayor, 13ª mayor]"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 15)
        comprobar(TipoDeAcorde("7alt").cifrado, #""7(♭9,♯9,♯11,♭13)""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 16)
        _ = Acorde("Do6/9/Mi")
        comprobar(Acorde("Do/Re").tieneBajoAjeno, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 18)
    }

    @Test func acordes2() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 41
        let c = Acorde.candidatos([.do, .mi, "Sib"]).first!
        comprobar(c.valor.cifrado, #""Do7""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 42)
        comprobar(c.omitidas, #"[Sol]"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 43)
        comprobar(Acorde.identificar([.do, .mi, "Sib", "Reb"]).first, #"Do7(♭9)"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 44)
    }

    @Test func acordes3() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 55
        comprobar(Acorde("Lab(#6,omit5)").tipo.nombre, #""sexta aumentada italiana""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 55)
        comprobar(Acorde.identificar(["La♭", "Do", "Fa♯"] as [Nota]).first?.cifrado, #""La♭(♯6,omit5)""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 56)
        comprobar(Acorde.identificar(["La♭", "Do", "Mi♭", "Fa♯"] as [Nota]).first?.cifrado, #""La♭(♯6)""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 57)
    }

    @Test func acordes4() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 71
        comprobar(Acorde.identificar(midi: [60, 64, 68]).first, #"Do+"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 71)
        comprobar(Acorde.identificar(midi: [60, 63, 66, 69]).first, #"Do°7"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 72)
        comprobar(Acorde.identificar(midi: [61, 65, 68]).first, #"Re♭"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 73)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 74)
        comprobar(Acorde.identificar(midi: [66, 70, 73], tonalidad: "Solb mayor").first, #"Sol♭"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 75)
        comprobar(Acorde("Do+").ortografiar(midi: [60, 64, 68]), #"[Do4, Mi4, Sol♯4]"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 76)
    }

    @Test func acordes5() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 107
        let a: Acorde = "Sol13(b9)"
        comprobar(a.componentes.map { "\($0.nota) \($0.papel)" }, #"["Sol fundamental", "Si tercera", "Re quinta", "Fa séptima", "La♭ novena", "Mi decimotercera"]"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 108)
        _ = (a.tercera, a.quinta, a.septima)
        comprobar(a.tensiones, #"[La♭, Mi]"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 111)
        comprobarIgual(a.papel(de: "Lab"), .tension(9), #"Sources/Armonia/Armonia.docc/Acordes.md"#, 112)
        comprobarIgual(a.estructura.calidadDeTriada, .mayor, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 113)
        comprobar(TipoDeAcorde("7sus4").estructura.suspension, #"4ª justa"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 114)
    }

    @Test func acordes6() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 133
        comprobar(Acorde("Sol7").vecinosParsimoniosos().map(\.description) == ["Sol♯°7 (Sol→Sol♯)", "Solm7 (Si→Si♭)", "Mim7 (Fa→Mi)"], #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 133)
        comprobar(Acorde("Sol7").vecinosParsimoniosos(voces: 2).contains { $0.acorde == Acorde("Reb7") }, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 134)
        comprobar(Tonnetz.caminoParsimonioso(desde: "Sol7", hasta: "Rem7")?.map(\.acorde.cifrado) == ["Sol♯°7", "Sim7(♭5)", "Rem7"], #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 135)
        comprobar(Tonnetz.caminoParsimonioso(desde: "Sol7", hasta: "Reb7", voces: 2)?.count == 1, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 136)
        comprobar(Acorde("Domaj7").vecinosParsimoniosos().map(\.description) == ["Do♯m7(♭5) (Do→Do♯)", "Do7 (Si→Si♭)"], #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 137)
        comprobar(Tonnetz.caminoParsimonioso(desde: "Domaj7", hasta: "Sol7")?.count == 3, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 138)
    }

    @Test func acordes7() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 152
        comprobar("\(Acorde("Sol7").conduccionMinima(hasta: "Do"))", #""Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos""#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 152)
        comprobar(Acorde("Rem7").conduccionMinima(hasta: "Sol7").semitonosMovidos == 3, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 153)
        comprobar(Acorde("Do").conduccionMinima(hasta: "Lam").semitonosMovidos == 2, #"true"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 154)
    }

    @Test func acordes8() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, línea 183
        comprobar(Acorde("Sol7").disposiciones(.cuartal).isEmpty, #"false"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 183)
        comprobar(DisposicionDeAcorde.cuartal.voces, #"4"#, #"Sources/Armonia/Armonia.docc/Acordes.md"#, 184)
    }

    @Test func afinacionYRepresentaciones1() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 8
        _ = TemperamentoRegular.igual
        _ = TemperamentoRegular.pitagorico
        _ = TemperamentoRegular.mesotonicoCuartoDeComa
        _ = TemperamentoRegular.igual(divisiones: 31)
        _ = AfinacionJusta(tonica: .do)
        _ = Altura("Sol#4").frecuencia(en: TemperamentoRegular.mesotonicoCuartoDeComa)
        comprobar(Intervalo.terceraMayor.razonJusta, #"5/4"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 14)
        comprobar(TemperamentoRegular.igual.cents(de: .terceraMayor), #"400"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 15)
        comprobar(AfinacionJusta(tonica: .do).desviacion(de: "Mi4"), #"−13,69 cents"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 16)
    }

    @Test func afinacionYRepresentaciones2() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 31
        let werckmeister = TemperamentoCircular.werckmeisterIII
        comprobar(werckmeister.desviaciones[4], #"−9,78"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 32)
        comprobar(werckmeister.frecuencia(de: "Sol#4") == werckmeister.frecuencia(de: "Lab4"), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 33)
        comprobar(TemperamentoCircular.kirnbergerIII.cents(desde: "Do4", hasta: "Mi4"), #"386,31"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 34)
        comprobar(TemperamentoCircular.vallotti.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4"), #"415"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 35)
        comprobar(TemperamentoCircular(nombre: "mío", quintas: Array(repeating: 701, count: 12)), #"nil"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 36)
    }

    @Test func afinacionYRepresentaciones3() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 44
        comprobar(AfinacionHistorica.allCases.count, #"8"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 44)
        comprobar(AfinacionHistorica.justa.afinacion(tonica: .re).desviacion(de: "Fa#4"), #"−13,69"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 45)
        comprobar(AfinacionHistorica.mesotonico.distingueEnarmonicas, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 46)
        comprobar(AfinacionHistorica.vallotti.nombre(en: .rusoPalabras), #""Валлотти""#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 47)
    }

    @Test func afinacionYRepresentaciones4() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 60
        comprobar(Altura("Do4").numero(en: .base40), #"162"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 60)
        comprobar(Altura("Fa#4").numero(en: .base40), #"180"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 61)
        comprobar(Altura("Solb4").numero(en: .base40), #"184"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 62)
        comprobar(Altura(numero: 185, en: .base40), #"Sol4"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 63)
        comprobar(Intervalo.quintaJusta.numero(en: .base40), #"23"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 64)
        comprobar(Intervalo(numero: 12, en: .base40), #"3ª mayor"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 65)
        comprobar(Intervalo(numero: 20, en: .base40), #"nil"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 66)
        comprobar(Nota("Si#").numero(en: .base40), #"38"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 67)
        comprobar(Altura(Nota(.fa, 3), octava: 4).numero(en: .base40), #"nil"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 68)
        comprobar(Altura(Nota(.fa, 3), octava: 4).numero(en: .base54), #"245"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 69)
        comprobar(Altura("Do4").numero(en: .base600), #"2442"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 70)
        _ = BaseDeHewlett(base: 96)
    }

    @Test func afinacionYRepresentaciones5() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 90
        comprobar(Nota.re.color(segun: .scriabin), #"#FFFF00"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 90)
        comprobar(CorrespondenciaDeColores.scriabin.nombreDelColor(de: .mi), #""azul cielo (luz de luna o escarcha)""#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 91)
        comprobar(Altura("La4").color(segun: .newton).hexadecimal, ##""#4B0082""##, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 92)
        comprobar(Acorde("Do").colores(segun: .circuloDeQuintas), #"[#FF0000, #00FF00, #FF8000]"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 93)
        _ = Escala(.re, .dorico).colores(segun: .castel)
        _ = (ColorRGB(hexadecimal: "#FF8000"), ColorRGB(tono: 120, saturacion: 1, brillo: 1))
    }

    @Test func afinacionYRepresentaciones6() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 114
        comprobar(PuntoDeLaRed(quintas: 0, terceras: 1).nota, #"Mi"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 114)
        comprobar(PuntoDeLaRed(quintas: 1, terceras: -1).nota, #"Mi♭"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 115)
        comprobar(PuntoDeLaRed(quintas: 4, terceras: -1).claseDeAltura, #"0"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 116)
        comprobar("\(Tonnetz(Acorde("Do")))", #""Do (0, 0) · Mi (0, 1) · Sol (1, 0)""#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 117)
        comprobar(Tonnetz(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 118)
        comprobar(Tonnetz(Escala(.do)).esConexo, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 119)
        comprobar(Tonnetz(Escala(.do, .tonosEnteros)).esConexo, #"false"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 120)
        comprobar("\(Tonnetz(ConjuntoDeClases([0, 4, 7])))", #""0 (0, 0) · 4 (0, 1) · 7 (1, 0)""#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 121)
    }

    @Test func afinacionYRepresentaciones7() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 139
        let dibujo = Tonnetz(Escala(.re, .dorico)).svg()
        let sinLeyenda = Tonnetz(Acorde("Do")).svg(titulo: "Tónica", leyenda: false)
        let ingles = Tonnetz(Acorde("Fa#m7")).svg(notacion: .inglesASCII, margen: 2)
        let toro = Tonnetz(ConjuntoDeClases([0, 4, 7, 11])).svg(margen: 3)
        _ = (dibujo, sinLeyenda, ingles, toro)
    }

    @Test func afinacionYRepresentaciones8() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 161
        comprobar(Acorde("Do").transformar(.r) == Acorde("Lam"), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 161)
        comprobar(Acorde("Mib").transformar(.r) == Acorde("Dom"), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 162)
        comprobar(Acorde("Do").transformar(leyendo: "PLR") == Acorde("Fam"), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 163)
        comprobar(Acorde("Do").transformar(TransformacionNeorriemanniana.s) == Acorde("Do#m"), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 164)
        comprobar(Acorde("Sol7").transformar(.p) == nil, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 165)
        comprobar(TransformacionNeorriemanniana.entre("Do", "Mim") == .l, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 166)
        comprobar(Tonnetz.camino(desde: "Do", hasta: "Mibm") == [.p, .r, .p], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 167)
        comprobar(Tonnetz.camino(desde: "Do", hasta: "Sol#", enarmonico: true) == [.p, .l], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 168)
    }

    @Test func afinacionYRepresentaciones9() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 184
        let recorrido = Tonnetz(recorrido: ["Do", "Lam", "Fa", "Rem"])
        comprobar(recorrido?.recorrido.count == 4, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 185)
        let bomba = Tonnetz(recorrido: ["Do", "Lam", "Rem", "Sol", "Do"])!
        comprobar(bomba.recorrido.first == bomba.recorrido.last, #"false"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 187)
        let dibujo = Tonnetz(caminoDesde: "Do", hasta: "Fa#")?.svg()
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones10() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 205
        comprobar(Acorde("Do").ciclo(.hexatonico)?.map(\.cifrado) == ["Do", "Dom", "La♭", "La♭m", "Mi", "Mim", "Do"], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 205)
        comprobar(Acorde("Do").ciclo(.octatonico)?.map(\.cifrado) == ["Do", "Dom", "Mi♭", "Mi♭m", "Sol♭", "Fa♯m", "La", "Lam", "Do"], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 206)
        comprobar(Acorde("Do").ciclo(.lr)?.count == 25, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 207)
        comprobar(Tonnetz(ciclo: .hexatonico, desde: "Do")?.recorrido.count == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 208)
    }

    @Test func afinacionYRepresentaciones11() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 249
        comprobar(TablaArmonica.midi(de: PuntoDeLaRed(quintas: 1, terceras: 0)) == 67, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 249)
        comprobar(TablaArmonica(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")], #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 250)
        comprobar(TablaArmonica([Altura("Do4"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 1, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 251)
        comprobar(TablaArmonica([Altura("Do3"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 0, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 252)
        comprobar("\(TablaArmonica([Altura("Do4"), Altura("Sol4")]))", #""Do4 (0, 0) · Sol4 (1, 0)""#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 253)
        let dibujo = TablaArmonica(Escala(.re, .dorico)).svg()
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones12() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 277
        comprobar(TablaArmonica(recorrido: ["Do", "Lam", "Fa"])?.recorrido.count == 3, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 277)
        comprobar(TablaArmonica(caminoDesde: "Do", hasta: "Sol7") == nil, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 278)
    }

    @Test func afinacionYRepresentaciones13() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 293
        let mi = PuntoDeLaRed(quintas: 0, terceras: 1)
        comprobar(mi.coordenada == CoordenadaAxial(q: 0, r: 1), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 296)
        comprobar(PuntoDeLaRed(CoordenadaAxial(q: 1, r: 0)).nota == .sol, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 297)
        comprobar(Tonnetz.punto(en: Punto(x: 60, y: 3), paso: 64) == PuntoDeLaRed(quintas: 1, terceras: 0), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 298)
        comprobar(TablaArmonica.coordenada(de: mi) == CoordenadaAxial(q: 1, r: -1), #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 299)
    }

    @Test func afinacionYRepresentaciones14() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 315
        let teclado = TecladoIsomorfico.wickiHayden
        comprobar(teclado.midi(en: CoordenadaAxial(q: 1, r: -1)) == 67, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 318)
        comprobar(teclado.semitonos(hacia: DireccionHexagonal(.noreste, .puntiaguda)!) == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 319)
        comprobar(TecladoIsomorfico.tablaArmonica.semitonos(hacia: .sMasRMenos) == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 320)
        comprobar(TecladoIsomorfico.acordeonC.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 3, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 321)
        comprobar(TecladoIsomorfico.acordeonB.semitonos(hacia: DireccionHexagonal(.noreste, .plana)!) == 2, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 322)
        comprobar(TecladoIsomorfico.wickiHaydenPlano.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 323)
        comprobar(TecladoIsomorfico.gerhard.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 1, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 324)
        comprobar(TecladoIsomorfico.park.semitonos(hacia: DireccionHexagonal(.este, .puntiaguda)!) == 5, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 325)
        let mapa = FormasDeMapa.rectangulo(columnas: 12, filas: 4, .filasImpares)
        let dibujo = TecladoIsomorfico.janko.svg(mapa, marcadas: [60, 64, 67])
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones15() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 340
        let formato = try FormatoUIL(leyendo: "2,7,5;R30M")
        comprobar(formato.esCompleto == true, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 341)
        comprobar(formato.orientacion == .puntiaguda, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 342)
        comprobar(try formato.teclado().semitonos(hacia: .qMasSMenos) == 2, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 343)
        comprobar(try FormatoUIL(leyendo: "M2,P5,P4;R30M").descripcion == "2,7,5;R30M", #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 344)
        comprobar(try TecladoIsomorfico.conUIL("3,7,4;R0").semitonos(hacia: .sMasRMenos) == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 345)
        comprobar(TecladoIsomorfico.wickiHayden.uil?.descripcion == "2,7,5;R30M", #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 346)
        comprobar(TecladoIsomorfico.wickiHayden.rotado(grados: -30)?.uil?.descripcion == "2,7,5;R0M", #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 347)
        comprobar(TecladoIsomorfico.wickiHayden.reflejado.uil?.descripcion == "2,7,5;R330", #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 348)
        comprobar(FormatoUIL.conocidos.count == 8, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 349)
    }

    @Test func afinacionYRepresentaciones16() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 375
        let cuartas = TecladoCuadrado.cuartas
        comprobar(cuartas.midi(en: CasillaCuadrada(columna: 2, fila: 1)) == 67, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 376)
        comprobar(cuartas.semitonosEnDiagonal == 6, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 377)
        comprobar(TecladoCuadrado.wickiHaydenCuadrado.semitonosEnDiagonal == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 378)
        comprobar(cuartas.girado().semitonosEnH == 5, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 379)
        comprobar(cuartas.reflejado.semitonosEnH == -1, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 380)
        comprobar(TecladoCuadrado(nombre: "Tonos", semitonosEnH: 2, semitonosEnV: 4).esCompleto == false, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 381)
        let ventana = CasillaCuadrada.rectangulo(columnas: 0...11, filas: 0...3)
        let dibujo = cuartas.svg(ventana, marcadas: [60, 64, 67])
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones17() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, línea 398
        let enTono = TecladoCuadrado.cuartas.enTono(Escala(.re, .dorico))
        comprobar(enTono.semitonosEnV == 3, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 399)
        comprobar(enTono.midi(en: .origen) == 62, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 400)
        comprobar(TecladoCuadrado.conEjes("2,7")?.semitonosEnV == 7, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 401)
        comprobar(TecladoCuadrado.secuencial.conOrigen(36).midi(en: CasillaCuadrada(columna: 0, fila: 1)) == 44, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 402)
        comprobar(RejillaDeControlador.launchpad.casillas.count == 64, #"true"#, #"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 403)
        let pads = enTono.conOrigen(36).svg(RejillaDeControlador.launchpad.casillas, marcadas: [62], primeras: [62], contorno: true)
        _ = pads
    }

    @Test func armonia1() throws {
        // Sources/Armonia/Armonia.docc/Armonia.md, línea 12
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, #"Sources/Armonia/Armonia.docc/Armonia.md"#, 14)
        _ = Escala("La menor armónica").cifradosRomanos(cuatriadas: true)
        comprobar(Tonalidad.identificar(midi: [69, 71, 72, 74, 76, 77, 80, 81]).first, #"La menor"#, #"Sources/Armonia/Armonia.docc/Armonia.md"#, 16)
    }

    @Test func convenciones1() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, línea 17
        func subirQuinta<T: Transponible>(_ x: T) -> T { x + .quintaJusta }
        comprobar(subirQuinta(Acorde("Do7")), #"Sol7"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 18)
        comprobar(subirQuinta(Escala(.do)), #"Sol mayor"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 19)
        comprobar(Nota.do.secuencia(.quintaJusta, veces: 3), #"Do, Sol, Re, La"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 20)
        comprobar(Acorde("Do").esDeLaMismaClase(que: Acorde("Lam")), #"true"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 21)
        comprobar(Acorde("Sib7(b9)/Re").texto(en: .inglesASCII), #""Bb7(b9)/D""#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 22)
        comprobar(Escala("Re dórico").nombre(en: .inglesASCII), #""D dorian""#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 23)
    }

    @Test func convenciones2() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, línea 32
        let n: Nota = "Fa#";  let i: Intervalo = "3M";  let a: Acorde = "Sol7/Si"
        let e: Escala = "Re dórico";  let t: TipoDeAcorde = "m7(b5)"
        comprobar(Nota.re + "3M", #"Fa♯"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 34)
        comprobar(String(decoding: try JSONEncoder().encode([a]), as: UTF8.self), #"["Sol7\/Si"]"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 35)
        comprobar([Intervalo.quintaJusta, .terceraMayor].sorted(), #"[3ª mayor, 5ª justa]"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 36)
        _ = Escala("La menor melódica").alturas(octava: 4, sentido: .descendente)
        comprobar(Escala(.la, .menorArmonica).cifradosRomanos(referencia: .menorNatural), #"["i", "ii°", "III+", "iv", "V", "VI", "♯vii°"]"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 38)
        _ = (n, e, i, t)
    }

    @Test func convenciones3() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, línea 51
        let entrada = "Sol7"
        let a = Acorde("Sol7")
        let b = Acorde(texto: entrada)
        let c = try Acorde(leyendo: entrada)
        _ = (a, b, c)
    }

    @Test func convenciones4() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, línea 91
        comprobarIgual(NombreDeGrado("submediante"), .superdominante, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 91)
        _ = (NombreDeGrado("Tónica"), NombreDeGrado("leading tone"))
        comprobar(PapelEnAcorde("oncena") == PapelEnAcorde("undécima"), #"true"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 93)
        comprobar(PapelEnAcorde("trecena") == PapelEnAcorde("decimotercera"), #"true"#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 94)
        comprobar(PapelEnAcorde.tension(11).nombre, #""undécima""#, #"Sources/Armonia/Armonia.docc/Convenciones.md"#, 95)
    }

    @Test func elModelo1() throws {
        // Sources/Armonia/Armonia.docc/ElModelo.md, línea 39
        let i = Altura("Re5") - Altura("Do4")
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 42)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 43)
        comprobar(Altura("La4").frecuencia(), #"440.0"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 44)
        comprobar(Altura(midi: 63, preferirBemoles: true), #"Mi♭4"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 45)
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 47)
        comprobar(Acorde.identificar([.mi, .sol, .do]).first, #"Do/Mi"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 48)
        let menor = Escala("La menor armónica")
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 51)
        comprobar(Escala("Mib mayor").armadura, #"-3"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 53)
        comprobar(Escala(.do).rotacion(2), #"Re dórico"#, #"Sources/Armonia/Armonia.docc/ElModelo.md"#, 54)
        _ = i
    }

    @Test func escalas1() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 51
        comprobar(Escala(.do, .dobleArmonica).notas, #"Do Re♭ Mi Fa Sol La♭ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 51)
        comprobar(Escala("Do enigmática").notas, #"Do Re♭ Mi Fa♯ Sol♯ La♯ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 52)
        comprobar(Escala("La menor húngara").nombre(en: .inglesASCII), #""A hungarian minor""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 53)
        comprobar(TipoDeEscala.mayorArmonica.rotacion(4).nombre, #""lidio ♭3""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 54)
        comprobar(TipoDeEscala.dobleArmonica == .hitzazkiar, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 55)
        comprobar(Escala("Mi flamenca").notas, #"Mi Fa Sol Sol♯ La Si Do Re"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 56)
        comprobar(Escala("Do modo 3 de Messiaen").notas, #"Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 57)
        comprobar(Escala("Re menor rumana").tipo.nombre, #""dórico ♯4""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 58)
        comprobar(TipoDeEscala.dobleArmonica.rotacion(5).nombre, #""oriental""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 59)
        comprobar(Escala.hexacordoBlando.notas, #"Fa Sol La Si♭ Do Re"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 60)
        comprobar(TipoDeEscala.mayorHungara.rotacion(4).nombre, #""superlocrio ♮6""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 61)
        comprobar(Escala("Do pentatónica escocesa").notas, #"Do Re Fa Sol La"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 62)
        comprobar(Escala("La de Liszt").tipo.nombre, #""menor húngara""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 63)
    }

    @Test func escalas2() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 95
        comprobar(TipoDeEscala.cromaticasPorQuintas.count, #"6"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 95)
        comprobar(TipoDeEscala.cromatica(desdeLaQuinta: -5) == TipoDeEscala.cromatica, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 96)
        comprobar(Escala(.re, .cromaticaConCincoSostenidos).notas, #"Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 97)
        comprobar(Escala("Do cromática con dos bemoles").notas, #"Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 98)
        comprobar(Escala("Do cromatica -6..5").tipo.nombre, #""cromática con cinco bemoles""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 99)
        comprobar(Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10), #"La♯"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 100)
    }

    @Test func escalas3() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 183
        comprobar(TipoDeEscala.melakarta(15), #"Māyāmālavagauḷa"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 183)
        comprobar(TipoDeEscala.mayor.numeroDeMelakarta, #"29"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 184)
        comprobar(Escala(.re, .hitzaz).notas, #"Re Mi♭ Fa♯ Sol La Si♭ Do"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 185)
        _ = (Escala("Do Kāfī"), Escala("Do kafi"), Escala("Re hijaz"), Escala("Do melakarta 22"))
        comprobar(Escala(.do, .todi).notas, #"Do Re♭ Mi♭ Fa♯ Sol La♭ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 187)
        comprobar(TipoDeEscala.melakarta(15) == .bhairav, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 188)
        comprobar(Escala(.re, .zhi).notas, #"Re Mi Sol La Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 189)
        comprobar(Escala("Do hirajoshi").notas, #"Do Re Mi♭ Sol La♭"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 190)
        comprobar(Escala("Do 平調子").tipo.nombre, #""Hirajōshi""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 191)
        comprobar(Escala("Re Χιτζάζ").tipo.nombre, #""Hitzáz""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 192)
        comprobar(Escala("Do भैरवी").tipo.nombre, #""Bhairavī""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 193)
        comprobar(TipoDeEscala.gong == .pentatonicaMayor, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 194)
        comprobar(Escala("Do Rast muğamı").notas, #"Do Re Mi Fa Sol La Si♭ Si"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 195)
        comprobar(Escala("La hicaz makami").notas, #"La Si♭ Do♯ Re Mi Fa♯ Sol"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 196)
    }

    @Test func escalas4() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 215
        comprobarIgual(TipoDeEscala.kafi.categoria, .thaat, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 215)
        comprobarIgual(TipoDeEscala.melakarta(15)?.categoria, .melakarta, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 216)
        comprobarIgual(TipoDeEscala.hitzaz.tradicion, .grecia, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 217)
        comprobarIgual(TipoDeEscala.rastMakami.categoria, .makam, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 218)
        comprobar(TipoDeEscala.mohanam.esRaga, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 219)
        comprobar(TipoDeEscala.kafi.esRaga, #"false"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 220)
        comprobar(TipoDeEscala.mohanam.padre?.numeroDeMelakarta, #"28"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 221)
        comprobar(TipoDeEscala.menorNatural.categoria, #"nil"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 222)
        comprobar(TipoDeEscala.tradicionales(categoria: .melakarta).count, #"72"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 223)
        comprobar(CategoriaTradicional.escala.nombre(en: Notacion.espanolCompacto.conTextos(en: .frances)), #""gamme""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 224)
    }

    @Test func escalas5() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 252
        comprobar(Escala(.re, .bayati).notas, #"Re Mi♭ Fa Sol La Si♭ Do"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 252)
        comprobar(Escala(.re, .bayati).notasMicrotonales(), #"Re Mi𝄳 Fa Sol La Si♭ Do"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 253)
        comprobar(Escala(.do, .maqamRast).notasMicrotonales(sentido: .descendente), #"Do Re Mi𝄳 Fa Sol La Si♭"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 254)
        comprobar(Escala(.sol, .rastMakami).notasMicrotonales(), #"Sol La Si⁻¹ Do Re Mi Fa♯⁻¹"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 255)
        comprobarIgual(TipoDeEscala.rastMakami.microtonal?.sistema, .comas53, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 256)
        comprobar(Escala(.re, .echosProtos).notasMicrotonales(), #"Re Mi⁻² Fa Sol La Si⁻² Do"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 257)
        comprobar(Escala(.do, .bilaval).notasMicrotonales(), #"Do Re↓ Mi↓ Fa Sol La↓ Si↓"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 258)
        comprobar(TipoDeEscala.frigio.microtonal, #"nil"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 259)
    }

    @Test func escalas6() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 273
        let voz = Escala(.re, .bayati).voz()
        comprobar(voz.eventos[1], #"Mi♭4(50¢):4"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 274)
        comprobar(voz.musicXML().contains("<alter>-0.5</alter>"), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 275)
        comprobar(Evento("Si4(-15.09¢):4").desvios, #"[-15.09]"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 276)
    }

    @Test func escalas7() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 294
        comprobar(TipoDeEscala.buscar(nombre: "dorico b2") == TipoDeEscala.buscar(nombre: "dórico ♭2"), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 294)
        comprobar(TipoDeEscala.dobleArmonica.aliasNormalizados.contains("doble armonica"), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 295)
        comprobar(TipoDeEscala.buscar(nombre: "jonico sin 4") == TipoDeEscala.jonicoSinCuarta, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 296)
    }

    @Test func escalas8() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 319
        comprobar(ModoGregoriano(2)!.description, #""modo 2 (protus plagal, hipodórico): final Re, tenor Fa, ámbito La3–La4""#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 319)
        comprobar(ModoGregoriano(nombre: "hipofrigio")!.tenor, #"La"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 321)
        comprobar(ModoGregoriano(3)!.escala, #"Mi frigio"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 322)
        comprobar(ModoGregoriano(6)!.ambito.first, #"Do4"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 323)
    }

    @Test func escalas9() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 336
        comprobar(TipoDeEscala.menorMelodica.esDireccional, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 336)
        comprobarIgual(TipoDeEscala.menorMelodica.formaDescendente, .menorNatural, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 337)
        comprobar(Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente), #"La5 Sol5 Fa5 … La4"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 338)
        comprobar(TipoDeEscala.rast.formaAscendente == .mayor, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 339)
        comprobarIgual(TipoDeEscala.kiourdi.formaDescendente, .menorNatural, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 340)
        _ = TipoDeEscala.bilahari.intervalosEnAmbasDirecciones
    }

    @Test func escalas10() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 374
        comprobar(TipoDeEscala.kafi.esIdentico(a: .dorico), #"false"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 374)
        comprobar(TipoDeEscala.kafi.equivalentes.contains(.dorico), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 375)
        comprobar(TipoDeEscala.rast == .mayor, #"false"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 376)
    }

    @Test func escalas11() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 389
        comprobar(Arpegio(Acorde("Do7")).alturas(octava: 4).map(\.midi) == [60, 64, 67, 70, 72], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 389)
        comprobar(Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3).map(\.midi) == [48, 55, 52, 55], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 390)
        comprobar(Escala("Do mayor").arpegio(grado: 5, cuatriada: true)?.acorde == Acorde("Sol7"), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 391)
        comprobar(Escala("Do mayor").arpegios().count == 7, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 392)
        comprobar(try Arpegio(leyendo: "arpegio Dom7").acorde == Acorde("Dom7"), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 393)
        comprobar(Acorde("Do7").escalasCompatibles().contains(Escala(.do, .mixolidio)), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 394)
        let dibujo = Arpegio(Acorde("Do7")).svgPentagrama()
        _ = dibujo
    }

    @Test func escalas12() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 417
        comprobar(Escala(.do, .mayor).notasAEvitar(sobre: Acorde("Do7M")) == [.fa], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 417)
        comprobar(Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).map(\.cifra) == ["1", "9", "♭3", "11", "5", "13", "♭7"], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 418)
        comprobar(Escala(.sol, .frigioDominante).tensiones(sobre: Acorde("Sol7")) == [Nota(.la, .bemol), Nota(.mi, .bemol)], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 419)
        comprobar(Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Sol7"]).escalas[1] == Escala(.la, .frigioDominante), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 420)
        comprobar(Tonalidad(.do).escalaDelAcorde(Acorde("Sib7")) == Escala(Nota(.si, .bemol), .lidioDominante), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 421)
        comprobar(Escala(.do, .alterada).escalaMadre?.madre == Escala(Nota(.re, .bemol), .menorMelodicaJazz), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 422)
        comprobar(Escala(.re, .dorico).escalaMadre?.nombre(en: .espanolCompacto) == "modo 2 de Do mayor", #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 423)
        comprobar(Acorde("Do7(#11)").escalasCompatibles().first == Escala(.do, .lidioDominante), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 424)
    }

    @Test func escalas13() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 436
        comprobar(Escala(.do, .mayor).acordesQueCaben(grado: 1).contains(Acorde(.do, .mayorSexta)), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 436)
        comprobar(Escala(.do, .lidio).estructurasSuperiores(sobre: Acorde("Do7M")).first == Acorde(.re, .mayor), #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 437)
    }

    @Test func escalas14() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, línea 449
        comprobar(Escala(.re, .dorico).notaCaracteristica == .si, #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 449)
        comprobar(Escala(.re, .dorico).acordesCaracteristicos == [Acorde("Mim"), Acorde("Sol")], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 450)
        comprobar(Escala(.sol, .mixolidio).cadenciaModal == [Acorde("Fa"), Acorde("Sol")], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 451)
        comprobar(Escala(.mi, .frigio).cadenciaModal == [Acorde("Fa"), Acorde("Mim")], #"true"#, #"Sources/Armonia/Armonia.docc/Escalas.md"#, 452)
    }

    @Test func melodiaYRitmo1() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 8
        let tema: Melodia = ["Do4", "Mi4", "Sol4"]
        comprobar(tema.transponer(.segundaMayor), #"Re4 Fa♯4 La4"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 9)
        comprobar(tema.transponer(grados: 1, en: Escala(.do)), #"Re4 Fa4 La4"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 10)
        comprobar(tema.invertir(), #"Do4 La♭3 Fa3"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 11)
        comprobar(tema.retrogradar(), #"Sol4 Mi4 Do4"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 12)
        _ = (tema.intervalos, tema.contorno, tema.ambito)
        comprobar(Melodia(midi: [69, 71, 72, 74, 76, 77, 80, 81]), #"La4 … Sol♯5 La5"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 14)
    }

    @Test func melodiaYRitmo2() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 24
        comprobar(Duracion(.negra, puntillos: 1), #"negra con puntillo"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 24)
        comprobar(Duracion(.negra, puntillos: 1).texto, #""4.""#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 25)
        comprobar(Duracion.corchea.grupoIrregular(3, en: 2), #"1/12 de redonda"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 26)
        comprobar(Duracion("8."), #"corchea con puntillo"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 27)
        comprobar((Duracion.blanca + .corchea).descomposicion, #"[blanca, corchea]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 28)
        comprobar(Duracion.corchea.ticks(porNegra: 480), #"240"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 29)
        let c: Compas = "6/8"
        _ = (c.tipo, c.pulsos, c.pulso)
        comprobar(Tempo(100).indicacion, #""Andante""#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 33)
        comprobar(Tempo(120).segundos(de: .blanca), #"1"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 34)
    }

    @Test func melodiaYRitmo3() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 42
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4", compas: "3/4")
        comprobar(voz.duracion, #"redonda con puntillo"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 43)
        comprobar(voz.compases, #"[[Do4:4, Re4:8, Mi4:8, Fa4:4~], [Fa4:2, Sol4:4]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 44)
        comprobar(voz.segundos(tempo: Tempo(90)), #"4"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 45)
        _ = (voz.melodia, voz.ritmo)
        _ = (voz.aumentar(2), voz.disminuir(2), voz.retrogradar(), voz + .quintaJusta)
        _ = Voz(melodia: ["Do4", "Mi4", "Sol4"], ritmo: [.negra, .negra, .blanca], compas: "3/4")
    }

    @Test func melodiaYRitmo4() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 61
        comprobar(Compas("7/8").agrupacion, #"[2, 2, 3]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 61)
        comprobar(Compas("7/8").pulsos, #"3"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 62)
        comprobar(Compas("6/8").iniciosDePulso, #"[cero, negra con puntillo]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 63)
        comprobarIgual(Compas.compasillo.acento(pulso: 2), .semifuerte, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 64)
        comprobar(Compas.compasillo.acento(en: .corchea), #"nil"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 65)
    }

    @Test func melodiaYRitmo5() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 85
        comprobar(try Voz(leyendo: "Do4:4 Re4:2 Mi4:4").grafia, #"[[Do4:4, Re4:4~, Re4:4, Mi4:4]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 85)
        comprobar(try Voz(leyendo: "Do4:8 Re4:4 Mi4:8 Fa4:2").grafia, #"[[Do4:8, Re4:8~, Re4:8, Mi4:8, Fa4:2]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 86)
        comprobar(try Voz(leyendo: "Do4:4. Re4:8 Mi4:2").grafia, #"[[Do4:4., Re4:8, Mi4:2]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 87)
        comprobar(try Voz(leyendo: "Do4:4 Re4:4. Mi4:8 Fa4:4").grafia, #"[[Do4:4, Re4:4~, Re4:8, Mi4:8, Fa4:4]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 88)
        comprobar(try Voz(leyendo: "Do4:4 Re4:4 Mi4:4", compas: "6/8").grafia, #"[[Do4:4, Re4:8~, Re4:8, Mi4:4]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 89)
        comprobar(try Voz(leyendo: "Do4:2..", compas: "7/8").grafia, #"[[Do4:2~, Do4:4.]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 90)
        comprobar(try Voz(leyendo: "Do4:2..", compas: "3+2+2/8").grafia, #"[[Do4:4.~, Do4:2]]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 91)
    }

    @Test func melodiaYRitmo6() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 106
        let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
        let xml = escala.musicXML(tonalidad: Tonalidad(.do), tempo: Tempo(90), titulo: "Escala")
        comprobar(xml.contains("<fifths>0</fifths>"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 108)
        comprobar(xml.contains("<actual-notes>3</actual-notes>"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 109)
    }

    @Test func melodiaYRitmo7() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 129
        let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
        let mei = escala.mei(tonalidad: Tonalidad(.do), tempo: Tempo(90), titulo: "Escala")
        comprobar(mei.contains("keysig=\"0\""), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 131)
        comprobar(mei.contains("<tuplet num=\"3\" numbase=\"2\">"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 132)
    }

    @Test func melodiaYRitmo8() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 151
        let tema = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
        let ly = tema.lilyPond(tonalidad: Tonalidad(.sol), titulo: "Tema")
        comprobar(ly.contains("\\key g \\major \\time 3/4 \\partial 4"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 153)
        comprobar(ly.contains("fis''4 g''2"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 154)
        let abc = tema.abc(tonalidad: Tonalidad(.sol), titulo: "Tema")
        comprobar(abc.contains("K:G"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 156)
        comprobar(abc.contains("c2 d/2e/2 | f g2 |]"), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 157)
    }

    @Test func melodiaYRitmo9() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 181
        let melodia = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
        let datos = melodia.midi(tempo: Tempo(90), titulo: "Escala", instrumento: 40)
        comprobar(datos.prefix(4) == Data("MThd".utf8), #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 183)
    }

    @Test func melodiaYRitmo10() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 207
        let arpegio = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        comprobar(arpegio.eventos.count, #"9"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 208)
        let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Sol7")]
        let alberti = Voz(arpegiando: acordes, patron: .alberti, porAcorde: .blanca)
        comprobar(alberti.eventos.count, #"16"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 211)
        comprobar(alberti.eventos.prefix(4).flatMap(\.alturas).map(\.midi) == [48, 55, 52, 55], #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 212)
        let datos = alberti.midi(titulo: "Bajo de Alberti")
        _ = datos
    }

    @Test func melodiaYRitmo11() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, línea 228
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let pieza = try PiezaImportada(leyendo: coral.midi(duracion: .blanca, tonalidad: Tonalidad(.do)))
        comprobar(pieza.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 230)
        comprobar(pieza.notas.count, #"12"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 231)
        comprobar(pieza.acordes().map(\.cifrado), #"["Do", "Sol", "Do"]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 232)
        comprobar(pieza.analisis()?.cifrados, #"["I", "V", "I"]"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 233)
        comprobar(pieza.acordesConDuracion().map(\.duracion) == [.blanca, .blanca, .blanca], #"true"#, #"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 234)
    }

    @Test func notacionYPartitura1() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 51
        comprobar(Nota("Sib").nombre(en: .alemanCompacto), #""B""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 51)
        comprobar(Nota("Mibb").nombre(en: .alemanCompacto), #""Eses""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 52)
        comprobar(Nota("Fa#").nombre(en: .alemanPalabras), #""F Kreuz""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 53)
        comprobar(Altura("Fa#3").nombre(en: .alemanCompacto), #""Fis₃""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 54)
        comprobar(Altura("Fa#3").nombre(en: .francesPalabras), #""fa dièse 3""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 55)
        comprobar(Acorde("Sim7").cifrado(en: .alemanPalabras), #""Hm7""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 56)
        comprobar(Acorde("Rebmaj7").cifrado(en: .francesPalabras), #""Ré♭maj7""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 57)
        comprobar(try Nota(leyendo: "B", en: .alemanCompacto), #"Si♭"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 58)
        comprobar(try Nota(leyendo: "F Kreuz", en: .alemanCompacto), #"Fa♯"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 59)
        comprobar(try Altura(leyendo: "re diesis 5", en: .italianoPalabras), #"Re♯5"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 60)
        _ = (Tonalidad("Fis-Dur"), Tonalidad("ré bémol majeur"), Tonalidad("la minore"))
        comprobar(Alteracion(-2).nombre(en: .francesPalabras), #""double bémol""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 62)
        comprobar(Nota("Fa#").nombre(en: .portuguesPalabras), #""fá sustenido""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 63)
        comprobar(Alteracion(2).nombre(en: .portuguesPalabras), #""duplo sustenido""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 64)
        comprobar(Acorde("Rebmaj7").cifrado(en: .portuguesPalabras), #""Ré♭maj7""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 65)
        comprobar(Altura("fá sustenido 3"), #"Fa♯3"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 66)
        comprobar(Tonalidad("si bemol maior"), #"Si♭ mayor"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 67)
        comprobar(Escala("ré dórico"), #"Re dórico"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 68)
        comprobar(Nota("Fa#").nombre(en: .rusoPalabras), #""фа-диез""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 69)
        comprobar(Tonalidad("Re mayor").nombre(en: .griegoPalabras), #""ρε μείζονα""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 70)
        comprobar(Acorde("Sibm7").cifrado(en: .griegoPalabras), #""Σι♭m7""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 71)
        comprobar(Altura("sòl dièsi 2"), #"Sol♯2"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 72)
        comprobar(Nota("Fa#").nombre(en: .asturianoPalabras), #""fa sosteníu""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 73)
        comprobar(Altura("fa sosteniu 3"), #"Fa♯3"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 74)
        comprobar(Tonalidad("ля минор"), #"La menor"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 75)
    }

    @Test func notacionYPartitura2() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 107
        comprobar(Intervalo.terceraMayor.nombre(en: .catalanPalabras), #""3a major""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 107)
        comprobar(Intervalo.terceraMayor.nombre(en: .gallegoPalabras), #""3ª maior""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 108)
        comprobar(Intervalo.sextaMenor.nombre(en: .euskeraPalabras), #""6. txikia""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 109)
        comprobar(Cadencia.Tipo.rota.nombre(en: .catalanPalabras), #""cadència trencada""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 110)
        comprobar(Escala(.re, .dorico).nombre(en: .euskeraPalabras), #""re doriarra""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 111)
        comprobar(Acorde("Sol7/Si").nombre(en: .catalanPalabras), #""sol sèptima de dominant, primera inversió""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 112)
        comprobar(Intervalo.terceraMayor.nombre(en: .francesPalabras), #""tierce majeure""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 113)
        comprobar(Cadencia.Tipo.rota.nombre(en: .italianoPalabras), #""cadenza d'inganno""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 114)
        comprobar(Escala(.re, .dorico).nombre(en: .francesPalabras), #""ré dorien""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 115)
        comprobar(Acorde("Sol7/Si").nombre(en: .portuguesPalabras), #""sol sétima de dominante, primeira inversão""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 116)
        comprobar(Escala(.re, .dorico).nombre(en: .asturianoPalabras), #""re dóricu""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 117)
        comprobar(Acorde("Sol7/Si").nombre(en: .asturianoPalabras), #""sol séptima de dominante, primer inversión""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 118)
        comprobar(Intervalo.terceraMayor.nombre(en: .alemanPalabras), #""große Terz""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 119)
        comprobar(Cadencia.Tipo.rota.nombre(en: .alemanPalabras), #""Trugschluss""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 120)
        comprobar(Acorde("Sol7/Si").nombre(en: .alemanPalabras), #""Dominantseptakkord auf G, erste Umkehrung""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 121)
        comprobar(Intervalo.terceraMayor.nombre(en: .occitanoPalabras), #""tèrça majora""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 122)
        comprobar(Intervalo.terceraMayor.nombre(en: .rusoPalabras), #""большая терция""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 123)
        comprobar(Escala(.re, .dorico).nombre(en: .rusoPalabras), #""ре дорийский""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 124)
        comprobar(Intervalo.terceraMayor.nombre(en: .griegoPalabras), #""μεγάλη τρίτη""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 125)
    }

    @Test func notacionYPartitura3() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 138
        let notacion = Notacion.rusoPalabras.conTextos(en: .espanol)
        comprobar(Acorde("Sol7/Si").nombre(en: notacion), #""соль séptima de dominante, primera inversión""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 139)
        comprobar(Escala(.re, .dorico).nombre(en: Notacion.inglesASCII.conTextos(en: .euskera)), #""D doriarra""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 140)
        comprobar(Notacion(escritura: .rusoPalabras, textos: .espanol) == notacion, #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 141)
    }

    @Test func notacionYPartitura4() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 152
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: .espanolCompacto), #""Fa♯₃""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 152)
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: .espanolASCII), #""Fa#3""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 153)
        let conCifras = Notacion.espanolCompacto.conOctavas(.cifras)
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: conCifras), #""Fa♯3""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 155)
        comprobar(try Altura(leyendo: "Si♭₋₁") == Altura(Nota.si.bemol, octava: -1), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 156)
    }

    @Test func notacionYPartitura5() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 165
        comprobar(Escala("fa dièse lydien"), #"Fa♯ lidio"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 165)
        comprobar(Escala("si bemolle minore melodica"), #"Si♭ menor melódica"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 166)
        comprobar(Escala("ре дорийский"), #"Re dórico"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 167)
        comprobar(Escala("λα αρμονική ελάσσονα"), #"La menor armónica"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 168)
    }

    @Test func notacionYPartitura6() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 177
        _ = Nota("Sibb").alteracion
        comprobar(Alteracion(3).nombre, #""triple sostenido""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 178)
        comprobar(Alteracion(-1).nombre(en: .inglesASCII), #""flat""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 179)
        comprobar(Alteracion(2).simbolo, #""♯♯""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 180)
        comprobar(Alteracion(3).simboloConDobles, #""𝄪♯""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 181)
        comprobar(Alteracion(-2).simboloASCII, #""bb""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 182)
        comprobar(Alteracion(-2).simbolo(en: .conDobles), #""𝄫""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 183)
        _ = (Alteracion("x"), Alteracion("doble bemol"), Alteracion("♮"))
        _ = Alteracion.sostenido + .sostenido
        comprobar(Alteracion.sostenido.pasosDeQuinta, #"7"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 186)
    }

    @Test func notacionYPartitura7() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 199
        comprobar(Intervalo.sextaMenor.claseIntervalica, #"4"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 199)
        comprobarIgual(Intervalo.segundaAumentada.consonancia(), .disonancia, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 200)
        comprobar(Intervalo(numero: 1, calidad: .disminuida(1)), #"nil"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 201)
        comprobar(Clave.sol.posicion(de: "Do4").descripcion, #""1.ª línea adicional inferior""#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 203)
        comprobar(Clave.doEnTercera.posicion(de: "Do4").lugar, #"4"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 204)
        comprobar(Clave.fa.altura(lugar: 8), #"La3"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 205)
        comprobarIgual(Clave.masAdecuada(para: ["Do2", "Mi2"]), .fa, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 206)
        comprobar(InstrumentoDePartitura.clarineteEnSib.sonido(de: Altura("Do5")), #"Si♭4"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 208)
        comprobar(InstrumentoDePartitura.saxofonAlto.escritura(de: Escala("Si mayor")), #"La♭ mayor"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 209)
        comprobar(InstrumentoDePartitura.saxofonAlto.escritura(de: Acorde("Do7")), #"La7"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 210)
    }

    @Test func notacionYPartitura8() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 224
        comprobar(Escala("Re mayor").svgPentagrama().hasPrefix("<svg"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 224)
        comprobar(Escala("Re mayor").svgPentagrama().contains("<title>Re₄</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 225)
        comprobar(Escala("La menor melódica").svgPentagrama().contains("<title>Sol₅</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 226)
        comprobar(Acorde("Sol7").svgPentagrama().contains(">Sol7</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 227)
        comprobar(Acorde("Sol7").svgPentagrama(cifrado: false).contains("<text"), #"false"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 228)
        comprobar(Escala("Do mayor").svgPentagrama(opciones: OpcionesDePentagrama(notacion: .inglesASCII)).contains("<title>C4</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 229)
    }

    @Test func notacionYPartitura9() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 251
        comprobar(Acorde("Do13").svgPentagrama().contains("<title>Do₃</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 251)
        comprobar(Escala("Do mayor").svgPentagrama(octava: 6).contains("8va"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 252)
        comprobar(Escala("Do mayor").svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(pentagramas: .doble)).contains("<title>Do₃</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 253)
    }

    @Test func notacionYPartitura10() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 264
        let enLaMenor = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.la, .menor)))
        comprobar(Arpegio(Acorde("Mi7")).svgPentagrama(opciones: enLaMenor).contains("<title>Sol♯₄</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 265)
    }

    @Test func notacionYPartitura11() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 276
        let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        comprobar(voz.svgPentagrama(titulo: "Do7").contains("<title>Si♭₄</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 277)
    }

    @Test func notacionYPartitura12() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 300
        let opciones = OpcionesDePentagrama(intervalosDeLasNotas: true, marcarSemitonos: true, marcarTonica: true)
        comprobar(Acorde("Sol9").svgPentagrama(opciones: opciones).contains(">1 3 5 ♭7 9</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 301)
        comprobar(Escala("Re dórico").svgPentagrama(octavas: 2, opciones: opciones).contains("<title>Re₆</title>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 302)
    }

    @Test func notacionYPartitura13() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 318
        let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let voces = DisposicionDeAcorde.drop2.conducir(progresion) ?? []
        let grados = Tonalidad(.do).analizar(progresion).cifrados
        comprobar(DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I", grados: grados).contains(">V7</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 321)
        comprobar(Escala("Re mayor").svgPentagrama(digitacion: .derecha).contains(">5</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 322)
        comprobar(Escala("Do mayor").svgPentagrama(secuencia: .terceras).contains("por terceras"), #"true"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 323)
    }

    @Test func notacionYPartitura14() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, línea 349
        do {
            let acorde = try Acorde(leyendo: "Do7(b3)")
            print(acorde)
        } catch let error as ErrorDeLecturaDeTeoria {
            print(error)
            comprobarIgual(error.motivo, .tensionNoValida("b3"), #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 356)
            comprobar(error.posicion, #"4"#, #"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 357)
            print(error.descripcion(en: .inglesASCII))
        }
        do { _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, -3, 4]) } catch { print(error) }
    }

    @Test func postonal1() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, línea 8
        let c: ConjuntoDeClases = [0, 4, 7]
        comprobar(c.formaPrima, #"[0, 3, 7]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 9)
        comprobar(c.numeroDeForte, #""3-11""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 10)
        comprobar(c.vectorIntervalico, #"[0, 0, 1, 1, 1, 0]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 11)
        comprobar(c.nombreComun, #""tríada mayor o menor""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 12)
        comprobar(ConjuntoDeClases([0, 1, 4, 6]).estaEnRelacionZ(con: [0, 1, 3, 7]), #"true"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 13)
        comprobar(Escala(.re).conjuntoDeClases.numeroDeForte, #""7-35""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 14)
    }

    @Test func postonal2() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, línea 28
        let triada = try ConjuntoDeClases(leyendo: "{0 4 7}")
        comprobar(triada.numeroDeForte, #""3-11""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 29)
        comprobar(try ConjuntoDeClases(leyendo: "01t").clases, #"[0, 1, 10]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 30)
        comprobar(try ConjuntoDeClases(leyendo: "Re Fa La").clases, #"[2, 5, 9]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 31)
        comprobar(try ConjuntoDeClases(leyendo: "4-Z15").clases, #"[0, 1, 4, 6]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 32)
    }

    @Test func postonal3() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, línea 43
        let berg = try SerieDodecafonica(leyendo: "Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si")
        comprobar(berg.description, #""5 4 0 9 7 2 8 1 3 6 t e""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 44)
        comprobar(berg.inversion(5).description, #""5 6 t 1 3 8 2 9 7 4 0 e""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 45)
        comprobar(berg.matriz[1], #"[6, 5, 1, 10, 8, 3, 9, 2, 4, 7, 11, 0]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 46)
        comprobar(berg.esDeTodosLosIntervalos, #"true"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 47)
        comprobar(berg.identificar(berg.retrogrado(5)), #"[P11, R5]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 48)
        comprobar(berg.hexacordos.primero.numeroDeForte, #""6-32""#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 49)
        comprobar(berg.formasCombinatorias, #"[P11, I10, R5, RI4]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 50)
        comprobar(berg.esTotalmenteCombinatoria, #"true"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 51)
    }

    @Test func postonal4() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, línea 65
        let menorConSeptima: ConjuntoDeClases = [0, 3, 7, 10]
        comprobar(menorConSeptima.vectorDeIndice, #"[1, 2, 1, 2, 0, 2, 1, 2, 1, 0, 4, 0]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 66)
        comprobar(menorConSeptima.notasComunes(invirtiendo: 10), #"4"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 67)
        comprobar(menorConSeptima.ejesDeSimetria, #"[5–11]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 68)
        comprobar(ConjuntoDeClases([0, 1]).ejesDeSimetria, #"[0½–6½]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 69)
    }

    @Test func postonal5() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, línea 78
        comprobar(ConjuntoDeClases([1, 5, 8]).notas(), #"[Re♭, Fa, La♭]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 78)
        comprobar(ConjuntoDeClases([1, 5, 8]).notas(con: Nota(.do, .sostenido)), #"[Do♯, Mi♯, Sol♯]"#, #"Sources/Armonia/Armonia.docc/Postonal.md"#, 79)
    }

    @Test func tonalidad1() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 13
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.armadura, #"0"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 14)
        _ = (laMenor.relativa, laMenor.homonima)
        comprobar(laMenor.vecinas, #"[Do mayor, Sol mayor, Mi menor, Fa mayor, Re menor]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 16)
        comprobar(laMenor.armonizar(cuatriadas: true), #"Lam7 Sim7(♭5) Domaj7 Rem7 Mi7 Famaj7 Sol♯°7"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 17)
        _ = laMenor.cifradosRomanos()
        comprobarIgual(laMenor.nombreDeGrado(de: .sol), .subtonica, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 19)
        comprobar(Tonalidad.circuloDeQuintas(.menor), #"La♭ menor … La♯ menor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 20)
        comprobar(Tonalidad(Escala(.re, .dorico)), #"nil"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 21)
    }

    @Test func tonalidad2() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 27
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Escala(.do).ortografiar(midi: [60, 61, 62]), #"Do4 Do♯4 Re4"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 27)
        comprobar(Escala(.do).ortografiar(midi: [62, 61, 60]), #"Re4 Re♭4 Do4"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 28)
        comprobar(Altura(midi: 70, escala: Escala(.fa)), #"Si♭4"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 29)
        comprobar(Altura(midi: 68, tonalidad: "La menor"), #"Sol♯4"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 30)
        comprobar(Escala("Fa# mayor").ortografiar(midi: [65, 60]), #"Mi♯4 Si♯3"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 31)
        comprobar(Tonalidad.candidatos(midi: melodia).first?.valor, #"La menor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 32)
    }

    @Test func tonalidad3() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 48
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 49)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 50)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 51)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 52)
        comprobar(analisis.nombre(en: .inglesASCII), #""I–vi–V7/V–V7–I in C major""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 53)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Fa/La Sol7/Si Do"), #"I–IV6–V65–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 55)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Sim7(b5) Mi7 Lam"), #"iiø7–V7–i en La menor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 56)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Lab Sib Do"), #"I–♭VI–♭VII–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 57)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Reb/Fa Sol7 Do"), #"I–♭II6–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 58)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Fa#°7 Sol Do"), #"I–vii°7/V–V–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 59)
        comprobar(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi7", "La"]).cifrados, #"["i", "iv6", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 60)
        comprobar(Tonalidad(.do).analizar(["Mim6", "Mim/Sol"]).cifrados, #"["iii(add6)", "iii6"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 61)
    }

    @Test func tonalidad4() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 69
        comprobar(Tonalidad(.do).analizar(["Fa6/La", "Fa6/Do", "Do(add9)/Mi"]).cifrados, #"["IV(add6)643", "IV(add6)642", "I(add9)763"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 69)
    }

    @Test func tonalidad5() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 95
        comprobar(Tonalidad(.do).analizar(["Do", "Lab(#6,omit5)", "Sol", "Do"]).cifrados, #"["I", "It+6", "V", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 95)
        comprobar(Tonalidad(.do).analizar(["Fa", "Re7(b5)/Lab", "Sol"]).cifrados, #"["IV", "Fr+6", "V"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 96)
        comprobar(Tonalidad(.do).analizar(["Lab(#6)", "Do/Sol", "Sol7", "Do"]).cifrados, #"["Ger+6", "I64", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 97)
        comprobar(Tonalidad(.do).analizar(["Lab7", "Sol"]).cifrados, #"["Ger+6", "V"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 98)
        comprobar(Tonalidad(.do).analizar(["Reb/Lab", "Sol7", "Do"]).cifrados, #"["♭II64", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 99)
        comprobar(Tonalidad(.do).analizar(["Mib7", "Rem7", "Reb7", "Do"]).cifrados, #"["subV7/ii", "ii7", "subV7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 100)
        comprobar(Tonalidad(.do).analizar(["Do/Sol", "Sol7", "Do"]).funciones.map { $0!.abreviatura }, #"["D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 101)
    }

    @Test func tonalidad6() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 114
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let partituraAnalizada = analisis.musicXML(titulo: "Progresión")
        comprobar(partituraAnalizada.contains("<kind text=\"7\">dominant</kind>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 116)
        comprobar(partituraAnalizada.contains("<text>V7/V</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 117)
        comprobar(analisis.musicXML(notacion: .inglesASCII).contains("C major:"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 118)
    }

    @Test func tonalidad7() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 125
        let progresion = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(progresion.mei(notacion: .inglesASCII).contains(">D7</harm>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 126)
        comprobar(progresion.mei().contains("<syl>V7/V</syl>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 127)
    }

    @Test func tonalidad8() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 145
        let cadencia = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do").cadencias[0]
        comprobarIgual(cadencia.tipo, .autentica, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 146)
        comprobar(cadencia.esPerfecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 147)
        comprobar(cadencia.description, #""Cadencia auténtica V7–I (acordes 3 → 4)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 148)
        comprobar(cadencia.descripcion(en: .inglesASCII), #""Authentic cadence V7–I (chords 3 → 4)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 149)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Fa", "Do"]).cadencias.first?.tipo, .plagal, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 151)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Sol7", "Lam"]).cadencias.first?.tipo, .rota, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 152)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Lam", "Fa", "Sol"]).cadencias.first?.tipo, .semicadencia, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 153)
        comprobar(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi"]).cadencias[0].description, #""Semicadencia frigia iv6–V (acordes 2 → 3)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 154)
        comprobar(Tonalidad(.do).analizar(["Do", "Fam", "Do"]).cadencias[0].description, #""Cadencia plagal menor iv–I (acordes 2 → 3)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 155)
    }

    @Test func tonalidad9() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 169
        let recorrido = try RecorridoTonal(leyendo: "Do Fa Sol7 Do Lam Re7 Sol")
        comprobar(recorrido.tramos.map(\.tonalidad), #"[Do mayor, Sol mayor]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 170)
        comprobar(recorrido.cifrados, #"["I", "IV", "V7", "I", "ii", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 171)
        comprobar(recorrido.description, #""I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 172)
        comprobar(recorrido.modulaciones[0].acorde, #"4"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 173)
        comprobar(recorrido.modulaciones[0].pivote?.description, #""Lam = vi en Do mayor = ii en Sol mayor""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 174)
        comprobar(recorrido.cadencias.map(\.tonalidad), #"[Do mayor, Sol mayor]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 175)
        comprobar(try RecorridoTonal(leyendo: "Do Sol Do Fa Rem Mi7 Lam").modulaciones[0].description, #""De Do mayor a La menor en el acorde 5 (pivote: Rem = ii en Do mayor = iv en La menor)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 177)
    }

    @Test func tonalidad10() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 186
        comprobar(try RecorridoTonal(leyendo: "Do Lam Re7 Sol7 Do").modulaciones.isEmpty, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 186)
    }

    @Test func tonalidad11() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 204
        let planes = Tonalidad(.do).modulaciones(hasta: Tonalidad(.sol))
        comprobarIgual(planes[0].tecnica, .acordeComun, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 205)
        comprobar(planes[0].pivote?.description, #""Lam = vi en Do mayor = ii en Sol mayor""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 206)
        comprobarIgual(Tonalidad(.do).modulaciones(hasta: Tonalidad(Nota.la.bemol))[0].tecnica, .disminuidaEnarmonica, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 207)
    }

    @Test func tonalidad12() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 217
        let c = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5")
        comprobar(c.faltas.map(\.tipo) == [.quintasParalelas, .octavasParalelas], #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 218)
        comprobar(c.faltas[0].voces, #"[0, 1]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 219)
        comprobar(c.faltas[0].description, #""Quintas paralelas entre bajo y tenor (acordes 1 → 2)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 220)
        comprobar(c.faltas[0].descripcion(en: .inglesASCII), #""Parallel fifths between bass and tenor (chords 1 → 2)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 221)
        comprobar(try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5").esCorrecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 223)
        comprobar(Coral(voces: [["Do3", "Sol2"], ["Mi4", "Re4"], ["Sol4", "Sol4"], ["Do5", "Si4"]])?.esCorrecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 224)
    }

    @Test func tonalidad13() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 247
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let partitura = coral.musicXML(duracion: .blanca, titulo: "Cadencia")
        comprobar(partitura.contains("<staves>2</staves>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 249)
    }

    @Test func tonalidad14() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 258
        let cadencia = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        comprobar(cadencia.musicXML(cifrados: true, analisis: true).contains("<text>V</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 259)
    }

    @Test func tonalidad15() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 266
        let cierre = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        comprobar(cierre.mei(cifrados: true, analisis: true).contains("<syl>V</syl>"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 267)
    }

    @Test func tonalidad16() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 280
        let coral = Coral.realizar(["Do", "Fa", "Sol7", "Do"])!
        comprobar(coral.esCorrecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 281)
        comprobar(coral.voz(0).map(\.nota), #"[Do, Fa, Sol, Do]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 282)
        let conSoprano = Coral.realizar(["Do", "Fa", "Sol", "Do"], soprano: ["Mi4", "Fa4", "Re4", "Do4"])!
        comprobar(conSoprano.voz(3), #"[Mi4, Fa4, Re4, Do4]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 285)
        comprobar(Coral.realizar(["Do", "Rem"], soprano: ["Sol4", "La4"]), #"nil"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 286)
    }

    @Test func tonalidad17() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 299
        comprobar(Tonalidad(.do).acordes(para: .sol).prefix(3).map(\.valor), #"[Sol, Do, Sol7]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 299)
        let propuestas = Tonalidad(.do).armonizar(melodia: ["Mi", "Fa", "Re", "Do"], propuestas: 3)
        comprobar(propuestas.map(\.valor.cifrados), #"[["I", "IV", "V", "I"], ["I", "IV", "V7", "I"], ["I", "ii", "V", "I"]]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 302)
        comprobar(propuestas[0].valor.description, #""Do Fa Sol Do (I–IV–V–I)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 303)
        comprobar(Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"])[0].valor.cifrados, #"["I", "V/V", "V", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 304)
    }

    @Test func tonalidad18() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 311
        let armonizada = Tonalidad(.do).armonizarACuatroVoces(["Mi4", "Fa4", "Re4", "Do4"])!
        comprobar(armonizada.armonizacion.cifrados, #"["I", "IV", "V", "I"]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 312)
        comprobar(armonizada.coral.voz(3), #"[Mi4, Fa4, Re4, Do4]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 313)
        comprobar(armonizada.coral.esCorrecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 314)
    }

    @Test func tonalidad19() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 332
        let esquemas = EsquemaArmonico.buscar(en: ["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"])
        comprobar(esquemas.map(\.tipo), #"[turnaround, progresión por quintas, ii–V–I]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 333)
        comprobar(esquemas.map(\.indices), #"[0..<4, 1..<5, 2..<5]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 334)
        comprobarIgual(EsquemaArmonico.buscar(en: ["Fam7", "Sib7", "Do7M"])[0].tipo, .backdoor, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 335)
        comprobar(EsquemaArmonico.Tipo.pachelbel.acordes(en: Tonalidad(.re)), #"[Re, La, Sim, Fa♯m, Sol, Re, Sol, La]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 336)
        comprobar(EsquemaArmonico.Tipo.blues.acordes(en: Tonalidad(.fa)).count, #"12"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 337)
    }

    @Test func tonalidad20() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 353
        comprobar(Tonalidad(.do).acorde(romano: "ii65") == Acorde("Rem7/Fa"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 353)
        comprobar(Tonalidad(.do).acorde(romano: "V7/V") == Acorde("Re7"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 354)
        comprobar(Tonalidad(.la, .menor).acorde(romano: "vii°7") == Acorde("Sol#°7"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 355)
        comprobar(Tonalidad(.do).acordes(romanos: "I ♭VI ♭VII I") == ["Do", "Lab", "Sib", "Do"], #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 356)
    }

    @Test func tonalidad21() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 369
        comprobar(Tonalidad(.do).acorde(sobre: .si, cifras: "65"), #"Sol7/Si"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 369)
        comprobar(Tonalidad(.la, .menor).acorde(sobre: .mi, cifras: "#"), #"Mi"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 370)
        comprobar(Tonalidad(.la, .menor).acordes(bajoCifrado: "La Fa:6 Mi:# La"), #"[Lam, Rem/Fa, Mi, Lam]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 371)
        let realizado = Coral.realizar(bajoCifrado: "Do Fa Sol:7 Do", en: Tonalidad(.do))!
        comprobar(realizado.esCorrecta, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 373)
    }

    @Test func tonalidad22() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 385
        comprobar(Tonalidad(.do).negativa(.mi) == Nota(.mi, .bemol), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 385)
        comprobar(Tonalidad(.do).negativo(Acorde("Do")) == Acorde("Dom"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 386)
        comprobar(Tonalidad(.do).negativo(Acorde("Fa")) == Acorde("Solm"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 387)
    }

    @Test func tonalidad23() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 402
        let melodia: [Altura] = ["Mi5", "Re5", "Do5", "Do5", "Si4", "Do5"]
        let notas = NotaDeLaMelodia.analizar(melodia, sobre: ["Do", "Do", "Fa", "Sol", "Sol", "Do"])!
        comprobar(notas[1].description, #""Re5 (nota de paso)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 404)
        comprobar(notas[3].description, #""Do5 (retardo 4-3)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 405)
        comprobar(notas.notasExtranas.map(\.indice), #"[1, 3]"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 406)
        comprobar(NotaExtrana.apoyatura.nombre(en: .inglesASCII), #""appoggiatura""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 407)
    }

    @Test func tonalidad24() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, línea 419
        let cantus = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"
        let fux = try Contrapunto(cantusFirmus: cantus, contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)
        comprobar(fux.esCorrecto, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 421)
        comprobar(fux.contrapuntoArriba, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 422)
        comprobar(fux.informe().hasPrefix("Especie 1, con el contrapunto encima del cantus firmus\n"), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 423)
        comprobar(fux.informe().hasSuffix("Sin faltas."), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 424)
        let quintas = try Contrapunto(cantusFirmus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera)
        comprobar(quintas.faltas.contains(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1)), #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 427)
        comprobar(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1).description, #""Quintas paralelas (compases 1 → 2)""#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 428)
        comprobar(try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1", especie: .segunda).esCorrecto, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 431)
        comprobar(try Contrapunto(cantusFirmus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1", especie: .cuarta).esCorrecto, #"true"#, #"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 432)
    }

    @Test func trastes1() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, línea 13
        let mastil = Mastil(.guitarra)
        let ukelele = Encordado(nombre: "ukulele")
        let acorde = Acorde("Sol7/Si")
        let formas = mastil.digitaciones(de: acorde, limite: 3)
        let primera = formas.first
        let tablatura = primera?.tablatura
        let notas = primera?.notas(para: acorde)
        let dedos = primera?.dedos
        let cejilla = primera?.cejilla
        let pentatonica = mastil.posiciones(de: Escala(.la, .pentatonicaMenor), trastes: 0...12)
        _ = (ukelele, tablatura, notas, dedos, cejilla, pentatonica)
    }

    @Test func trastes2() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, línea 56
        let mastil = Mastil(.guitarra, trastes: 12)
        let posiciones = mastil.arpegios(de: Acorde("Lam"))
        comprobar(posiciones.count, #"3"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 58)
        comprobar(posiciones[0].trastes == 0...3, #"true"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 59)
        comprobar(posiciones[0].alturas.map(\.midi) == [40, 45, 48, 52, 57, 60, 64], #"true"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 60)
        let todas = mastil.posiciones(de: Acorde("Lam"), trastes: 0...5)
        _ = todas
    }

    @Test func trastes3() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, línea 75
        let mastil = Mastil(.guitarra, trastes: 15)
        let porCuerda = mastil.posicionesPorCuerda(de: Escala(.sol, .mayor))
        comprobar(porCuerda.count, #"7"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 77)
        comprobar(porCuerda[0].trastes == 0...5, #"true"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 78)
        comprobar(porCuerda[0].posiciones.count, #"18"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 79)
        let caged = mastil.posicionesCAGED(de: Escala(.do, .mayor))
        comprobar(caged.map(\.forma) == [.c, .a, .g, .e, .d], #"true"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 81)
        comprobar(caged.map(\.trastes) == [0...4, 2...6, 5...9, 7...11, 9...13], #"true"#, #"Sources/Armonia/Armonia.docc/Trastes.md"#, 82)
    }

    @Test func trastes4() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, línea 96
        let mastil = Mastil(.guitarra)
        let leida = Digitacion(leyendo: "x32010", en: mastil)
        let comprobada = Digitacion(comprobando: [nil, 3, 2, 0, 1, 0], en: mastil)
        let sonido = mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 9, traste: 0))
        _ = (leida, comprobada, sonido)
    }

    @Test func tutorialAcordes01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-01.swift, línea 1
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-01.swift"#, 4)
    }

    @Test func tutorialAcordes01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-02.swift, línea 1
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-02.swift"#, 4)
        comprobar(dominante.posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-02.swift"#, 5)
    }

    @Test func tutorialAcordes01031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift, línea 1
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift"#, 4)
        comprobar(dominante.posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift"#, 5)
        comprobar(dominante.cifrado(estilo: .inglesASCII), #""G7/B""#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift"#, 6)
        comprobar(Acorde("G7(b9,#11)").cifrado, #""Sol7(♭9,♯11)""#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift"#, 7)
    }

    @Test func tutorialAcordes02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-01.swift, línea 1
        comprobar(Acorde.identificar([.mi, .sol, .do]).first, #"Do/Mi"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-01.swift"#, 3)
    }

    @Test func tutorialAcordes02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-02.swift, línea 1
        comprobar(Acorde.identificar([.mi, .sol, .do]).first, #"Do/Mi"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-02.swift"#, 3)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-02.swift"#, 4)
    }

    @Test func tutorialAcordes02031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift, línea 1
        comprobar(Acorde.identificar([.mi, .sol, .do]).first, #"Do/Mi"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift"#, 3)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift"#, 4)
        let candidato = Acorde.candidatos([.do, .mi, "Sib"]).first!
        comprobar(candidato.valor.cifrado, #""Do7""#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift"#, 7)
        comprobar(candidato.omitidas, #"[Sol]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift"#, 8)
    }

    @Test func tutorialAcordes03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-01.swift, línea 1
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-01.swift"#, 4)
    }

    @Test func tutorialAcordes03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-02.swift, línea 1
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-02.swift"#, 4)
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-02.swift"#, 5)
    }

    @Test func tutorialAcordes03031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift, línea 1
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift"#, 4)
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift"#, 5)
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.armonizar(cuatriadas: true), #"Lam7 Sim7(♭5) Domaj7 Rem7 Mi7 Famaj7 Sol♯°7"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift"#, 9)
    }

    @Test func tutorialAnalisis01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-01.swift, línea 1
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Tonalidad.identificar(midi: melodia).first, #"La menor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-01.swift"#, 4)
    }

    @Test func tutorialAnalisis01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-02.swift, línea 1
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Tonalidad.identificar(midi: melodia).first, #"La menor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-02.swift"#, 4)
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.relativa, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-02.swift"#, 7)
        _ = laMenor.cifradosRomanos()
    }

    @Test func tutorialAnalisis02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-01.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-01.swift"#, 4)
    }

    @Test func tutorialAnalisis02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift"#, 6)
    }

    @Test func tutorialAnalisis02031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 8)
    }

    @Test func tutorialAnalisis03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 8)
        let cadencia = analisis.cadencias.last!
        comprobarIgual(cadencia.tipo, .autentica, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 11)
        comprobar(cadencia.esPerfecta, #"true"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 12)
    }

    @Test func tutorialAnalisis03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 8)
        let cadencia = analisis.cadencias.last!
        comprobarIgual(cadencia.tipo, .autentica, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 11)
        comprobar(cadencia.esPerfecta, #"true"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 12)
        comprobarIgual(try AnalisisArmonico.analizar(leyendo: "Do Fa Sol").cadencias.last!.tipo, .semicadencia, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 13)
    }

    @Test func tutorialAnalisis04011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 8)
        let fichero = analisis.midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 12)
    }

    @Test func tutorialAnalisis04021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 8)
        let fichero = analisis.midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 12)
        comprobar(pieza.acordes(), #"[Do, Lam, Re7, Sol7, Do]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 13)
        if let leido = pieza.analisis() {
            comprobar(leido.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 15)
        }
    }

    @Test func tutorialAnalisis04031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift, línea 1
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 4)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 5)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 6)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 7)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 8)
        let fichero = analisis.midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 12)
        comprobar(pieza.acordes(), #"[Do, Lam, Re7, Sol7, Do]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 13)
        if let leido = pieza.analisis() {
            comprobar(leido.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 15)
        }
        let partitura = analisis.musicXML(titulo: "Mi primera progresión")
        comprobar(partitura.contains("<text>V7/V</text>"), #"true"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 19)
    }

    @Test func tutorialNotas01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-01.swift, línea 1
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-01.swift"#, 4)
    }

    @Test func tutorialNotas01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-02.swift, línea 1
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-02.swift"#, 4)
        let solBemol: Nota = "Solb"
        comprobar(fa == solBemol, #"false"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-02.swift"#, 6)
    }

    @Test func tutorialNotas01031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift, línea 1
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift"#, 4)
        let solBemol: Nota = "Solb"
        comprobar(fa == solBemol, #"false"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift"#, 6)
        comprobar(fa.intervalo(hasta: solBemol), #"2ª disminuida"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift"#, 7)
    }

    @Test func tutorialNotas02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-01.swift, línea 1
        let la = Altura("La4")
        comprobar(la.midi, #"69"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-01.swift"#, 4)
        comprobar(la.frecuencia(), #"440.0"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-01.swift"#, 5)
    }

    @Test func tutorialNotas02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift, línea 1
        let la = Altura("La4")
        comprobar(la.midi, #"69"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift"#, 4)
        comprobar(la.frecuencia(), #"440.0"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift"#, 5)
        comprobar(Altura(midi: 63, preferirBemoles: true), #"Mi♭4"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift"#, 6)
        comprobar(Altura(midi: 68, tonalidad: "La menor"), #"Sol♯4"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift"#, 7)
    }

    @Test func tutorialNotas03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-01.swift, línea 1
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-01.swift"#, 3)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-01.swift"#, 4)
    }

    @Test func tutorialNotas03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift, línea 1
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift"#, 3)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift"#, 4)
        comprobar(Nota.re + "3M", #"Fa♯"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift"#, 5)
        comprobar(Altura("Do4") + "5J", #"Sol4"#, #"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift"#, 6)
    }
}
