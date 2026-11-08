import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de Asia oriental y del sudeste asiático: China, Japón, Vietnam y Myanmar.
@Suite struct EscalasDeAsiaOrientalTests {
    @Test func escalasChinas() {
        #expect(
            TipoDeEscala.chinas.map(\.nombre) == ["Gōng", "Shāng", "Jué", "Zhǐ", "Yǔ", "Qīngyuè", "Yǎyuè", "Yànyuè"])
        // Los cinco modos son las rotaciones de la pentatónica: gōng, shāng, jué, zhǐ y yǔ
        // empiezan en Do, Re, Mi, Sol y La.
        let pentatonica = Escala(.do, .gong)
        for (tipo, tonica) in zip([TipoDeEscala.gong, .shang, .jue, .zhi, .yu], [Nota.do, .re, .mi, .sol, .la]) {
            #expect(Set(Escala(tonica, tipo).notas) == Set(pentatonica.notas), Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.gong == .pentatonicaMayor)
        #expect(TipoDeEscala.yu == .pentatonicaMenor)
        #expect(TipoDeEscala.qingyue == .mayor)
        #expect(TipoDeEscala.yayue == .lidio)
        #expect(TipoDeEscala.yanyue == .mixolidio)
        #expect(Escala(.re, .zhi).notas.map(\.description) == ["Re", "Mi", "Sol", "La", "Si"])
        // Se leen con tonos, sin ellos y en caracteres chinos; el nombre no se traduce.
        for texto in ["Do Gōng", "Do gong", "Do GONG", "Do 宫", "Do 宮", "C gong"] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == "Gōng", Comment(rawValue: texto))
        }
        #expect(Escala("Sol zhi").tipo.nombre == "Zhǐ")
        #expect(Escala("Mi jiao").tipo.nombre == "Jué")
        #expect(Escala("Do yayue").tipo.nombre == "Yǎyuè")
        #expect(Escala(.la, .yu).nombre(en: .ascii(.ingles)) == "A Yǔ")
        #expect(TipoDeEscala.pentatonicaMayor.equivalentes.contains { $0.nombre == "Gōng" })
    }

    /// Los doce lü, por sanfen sunyi desde huángzhōng: once quintas pitagóricas, con los sostenidos.
    @Test func losDoceLu() throws {
        #expect(TipoDeEscala.lus.map(\.nombre) == ["Shí'èr lǜ", "Yánglǜ", "Yīnlǜ"])
        #expect(TipoDeEscala.shierLu.tradicion == .china)
        #expect(TipoDeEscala.shierLu.categoria == .afinacion)
        #expect(TipoDeEscala.shierLu.fuente == .lushiChunqiu)
        #expect(
            Escala(.do, .shierLu).notas.map(\.description)
                == ["Do", "Do♯", "Re", "Re♯", "Mi", "Mi♯", "Fa♯", "Sol", "Sol♯", "La", "La♯", "Si"])
        // Cada lü, a un número de quintas de huángzhōng: zhònglǚ, a once, no vuelve a Fa (la coma pitagórica).
        let quinta = 1200 * log2(1.5)
        let pitagoricos = TipoDeEscala.shierLu.intervalos.map { intervalo -> Int in
            let cents = (Double(intervalo.pasosDeQuinta) * quinta).truncatingRemainder(dividingBy: 1200)
            return Int((cents < 0 ? cents + 1200 : cents).rounded())
        }
        let afinaciones = TipoDeEscala.shierLu.afinaciones
        #expect(afinaciones.map(\.fuente) == [nil, .zhuZaiyu])
        #expect(afinaciones[0].pasos == pitagoricos)
        #expect(afinaciones[0].pasos[5] - 498 == 24)
        #expect(afinaciones[1].desvios.allSatisfy { $0 == 0 })
        // Las dos mitades: tonos enteros con un paso de 180 cents.
        for tipo in [TipoDeEscala.yanglu, .yinlu] {
            let semitonos = Set(TipoDeEscala.tonosEnteros.intervalos.map(\.semitonos))
            #expect(Set(tipo.intervalos.map(\.semitonos)) == semitonos, Comment(rawValue: tipo.nombre))
            let pasos = try #require(tipo.microtonal).pasos + [1200]
            let saltos = zip(pasos.dropFirst(), pasos).map { $0 - $1 }
            #expect(saltos.sorted() == [180, 204, 204, 204, 204, 204], Comment(rawValue: tipo.nombre))
        }
        #expect(
            Escala(Nota(.do, .sostenido), .yinlu).notas.map(\.description) == ["Do♯", "Re♯", "Mi♯", "Sol", "La", "Si"])
        #expect((try? Escala(leyendo: "Do 十二律"))?.tipo.nombre == "Shí'èr lǜ")
        #expect((try? Escala(leyendo: "Do 六律"))?.tipo.nombre == "Yánglǜ")
        #expect((try? Escala(leyendo: "Do 六吕"))?.tipo.nombre == "Yīnlǜ")
        // En ruso y griego, transcritos; en los demás idiomas, en pinyin.
        let ruso = Notacion.compacta(.espanol).conTextos(en: .ruso)
        #expect(TipoDeEscala.shierLu.nombre(en: ruso) == "Шиэр люй")
        #expect(TipoDeEscala.yinlu.nombre(en: Notacion.compacta(.espanol).conTextos(en: .griego)) == "Γινλιου")
        #expect(TipoDeEscala.yanglu.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Yánglǜ")
    }

    /// Las chinas suenan por sanfen sunyi: cada nota, a un número de quintas pitagóricas de gōng.
    @Test func lasChinasPorSanfenSunyi() throws {
        #expect(TipoDeEscala.chinas.allSatisfy { $0.microtonal != nil })
        #expect(try #require(TipoDeEscala.gong.microtonal).pasos == [0, 204, 408, 702, 906])
        #expect(try #require(TipoDeEscala.qingyue.microtonal).desvios[3] == 22)
        #expect(TipoDeEscala.tradicionales(fuente: .guanzi) == [.gong, .shang, .jue, .zhi, .yu])
    }

    @Test func escalasJaponesas() {
        #expect(
            TipoDeEscala.japonesas.map(\.nombre) == [
                "Ritsu", "Ryo", "Yō", "Min'yō", "Miyakobushi", "In", "Insen", "Iwato", "Hirajōshi", "Kumoijōshi",
                "Ryūkyū",
                "Akebono", "Kokin-jōshi",
            ])
        func notas(_ tonica: Nota, _ tipo: TipoDeEscala) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        #expect(notas(.do, .hirajoshi) == "Do Re Mi♭ Sol La♭")
        #expect(notas(.do, .kumoijoshi) == "Do Re Mi♭ Sol La")
        #expect(notas(.do, .iwato) == "Do Re♭ Fa Sol♭ Si♭")
        #expect(notas(.do, .insen) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(.mi, .miyakobushi) == "Mi Fa La Si Do")
        #expect(notas(.re, .minyo) == "Re Fa Sol La Do")
        #expect(notas(.do, .ryukyu) == "Do Mi Fa Sol Si")
        #expect(notas(.re, .ritsu) == "Re Mi Sol La Si")
        #expect(notas(.re, .ryo) == "Re Mi Fa♯ La Si")
        // Varias coinciden en notas con otras: in y miyakobushi, yō y ritsu, min'yō y la
        // pentatónica menor, ryo y la mayor.
        #expect(TipoDeEscala.in == .miyakobushi)
        #expect(TipoDeEscala.yo == .ritsu)
        #expect(TipoDeEscala.minyo == .pentatonicaMenor)
        #expect(TipoDeEscala.ryo == .pentatonicaMayor)
        #expect(Set(TipoDeEscala.in.equivalentes.map(\.nombre)) == ["Miyakobushi", "Ambassäl", "Pélog pathet nem"])
        // Con macrones, sin ellos y en japonés.
        for (texto, nombre) in [
            ("Do Hirajōshi", "Hirajōshi"), ("Do hirajoshi", "Hirajōshi"), ("Do 平調子", "Hirajōshi"),
            ("Do Ryūkyū", "Ryūkyū"), ("Do ryukyu", "Ryūkyū"), ("Do okinawa", "Ryūkyū"),
            ("Re min'yō", "Min'yō"), ("Re minyo", "Min'yō"), ("Re yo", "Yō"), ("Mi in", "In"),
            ("Mi miyako-bushi", "Miyakobushi"), ("Do kumoi", "Kumoijōshi"), ("Do 岩戸", "Iwato"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        #expect(Escala(.do, .hirajoshi).nombre(en: .ascii(.ingles)) == "C Hirajōshi")
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "Hirajōshi" }))
    }

    /// Vietnam, Brasil y el arpa birmana.
    @Test func vietnamBrasilYMyanmar() {
        #expect(
            TipoDeEscala.tradicionales(tradicion: .vietnam).map(\.nombre) == [
                "Bắc", "Vọng cổ", "Hò mái nhì", "Sa mạc", "Dân ca",
            ])
        #expect(TipoDeEscala.hoMaiNhi == .bac && !TipoDeEscala.hoMaiNhi.esIdentico(a: .bac))
        #expect(TipoDeEscala.saMac.microtonal?.cents == [0, 338, 504, 699, 1026])
        #expect(TipoDeEscala.danCa == .pentatonicaMayorTerceraMenor)
        #expect(TipoDeEscala.bac.microtonal?.cents == [0, 189, 501, 698, 891])
        #expect((try? TipoDeEscala(leyendo: "hoi oan"))?.nombre == "Vọng cổ")
        #expect(TipoDeEscala.tradicionales(tradicion: .brasil).count == 3)
        #expect(TipoDeEscala.lidioNordestino == .lidioDominante)
        #expect((try? TipoDeEscala(leyendo: "nordestina"))?.nombre == "lidio dominante")
        #expect(TipoDeEscala.saung.tradicion == .sudesteAsiatico && TipoDeEscala.saung.clase == .afinacion)
        #expect(TipoDeEscala.saung.microtonal?.desvios == [0, -18, -36, -9, -27])
        #expect(Tradicion.vietnam.nombre(en: Notacion.compacta(.espanol).conTextos(en: .portugues)) == "Vietname")
        #expect(Tradicion.brasil.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "Brazil")
    }
}
