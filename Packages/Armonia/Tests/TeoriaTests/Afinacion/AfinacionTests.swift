import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct AfinacionTests {
    @Test func temperamentosRegulares() {
        let igual = TemperamentoRegular.igual
        #expect(abs(igual.frecuencia(de: "La4") - (440)) <= 1e-9)
        #expect(abs(igual.frecuencia(de: "Do4") - (261.625_565_3)) <= 1e-6)
        #expect(abs(igual.cents(de: Intervalo.terceraMayor) - (400)) <= 1e-9)

        #expect(abs(TemperamentoRegular.pitagorico.frecuencia(de: "Mi5") - (660)) <= 1e-6)
        #expect(
            abs(TemperamentoRegular.mesotonicoCuartoDeComa.cents(de: .terceraMayor) - (1200 * log2(5.0 / 4.0))) <= 1e-9)
        #expect(
            abs(TemperamentoRegular.mesotonicoTercioDeComa.cents(de: .terceraMenor) - (1200 * log2(6.0 / 5.0))) <= 1e-9)
        #expect(abs(TemperamentoRegular.mesotonicoCuartoDeComa.frecuencia(de: "La4") - (440)) <= 1e-9)
        // En el mesotónico, Sol♯ y La♭ no coinciden.
        let meso = TemperamentoRegular.mesotonicoCuartoDeComa
        #expect(meso.frecuencia(de: "Sol#4") < meso.frecuencia(de: "Lab4"))

        #expect(abs(TemperamentoRegular.igual(divisiones: 12).quinta - (700)) <= 1e-9)
        #expect(abs(TemperamentoRegular.igual(divisiones: 31).quinta - (1200 * 18 / 31)) <= 1e-9)
        #expect(abs(TemperamentoRegular.igual(divisiones: 53).quinta - (1200 * 31 / 53)) <= 1e-9)
        #expect(abs(TemperamentoRegular.igual(divisiones: 19).quinta - (1200 * 11 / 19)) <= 1e-9)
        #expect(abs(TemperamentoRegular.igual.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4") - (415)) <= 1e-9)
    }

    @Test func temperamentosCirculares() {
        func redondear(_ valores: [Double]) -> [Double] { valores.map { ($0 * 100).rounded() / 100 } }
        // Las desviaciones de cada clase de altura respecto al temperamento igual, con Do como referencia.
        #expect(
            redondear(TemperamentoCircular.werckmeisterIII.desviaciones) == [
                0, -9.78, -7.82, -5.87, -9.78, -1.96, -11.73, -3.91, -7.82, -11.73, -3.91, -7.82,
            ])
        #expect(
            redondear(TemperamentoCircular.kirnbergerIII.desviaciones) == [
                0, -9.78, -6.84, -5.87, -13.69, -1.96, -9.78, -3.42, -7.82, -10.26, -3.91, -11.73,
            ])
        #expect(
            redondear(TemperamentoCircular.vallotti.desviaciones) == [
                0, -5.87, -3.91, -1.96, -7.82, 1.96, -7.82, -1.96, -3.91, -5.87, 0, -9.78,
            ])
        #expect(
            redondear(TemperamentoCircular.young.desviaciones) == [
                0, -9.78, -3.91, -5.87, -7.82, -1.96, -11.73, -1.96, -7.82, -5.87, -3.91, -9.78,
            ])
        // En Kirnberger III la tercera Do–Mi es pura.
        let kirnberger = TemperamentoCircular.kirnbergerIII
        #expect(abs(kirnberger.cents(desde: "Do4", hasta: "Mi4") - (RazonDeFrecuencias(5, 4).cents)) <= 1e-9)
        // Doce sonidos por octava: las enarmónicas suenan igual, y las octavas son puras.
        let werckmeister = TemperamentoCircular.werckmeisterIII
        #expect(abs(werckmeister.frecuencia(de: "Sol#4") - (werckmeister.frecuencia(de: "Lab4"))) <= 1e-9)
        #expect(abs(werckmeister.frecuencia(de: "Si#3") - (werckmeister.frecuencia(de: "Do4"))) <= 1e-9)
        #expect(abs(werckmeister.frecuencia(de: "Re5") / werckmeister.frecuencia(de: "Re4") - (2)) <= 1e-12)
        #expect(abs(werckmeister.frecuencia(de: "La4") - (440)) <= 1e-9)
        #expect(abs(werckmeister.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4") - (415)) <= 1e-9)
        #expect(abs(werckmeister.cents(de: "Sol4") - (696.09)) <= 0.01)
        // Si las quintas no cierran el círculo, no es un temperamento circular.
        #expect(
            TemperamentoCircular(nombre: "pitagórico", quintas: Array(repeating: 1200 * log2(1.5), count: 12)) == nil)
        #expect(TemperamentoCircular(nombre: "corto", quintas: [700]) == nil)
        #expect(TemperamentoCircular(nombre: "igual", quintas: Array(repeating: 700, count: 12)) != nil)
    }

    @Test func temperamentosParaEscuchar() throws {
        let paraEscuchar = TemperamentoConNombre.paraEscuchar
        #expect(paraEscuchar.count == 8)
        for temperamento in paraEscuchar {
            // Todos con el La4 de referencia en su sitio y la octava pura.
            let afinacion = try #require(temperamento.afinacion(tonica: .la))
            #expect(abs(afinacion.frecuencia(de: "La4") - (440)) <= 1e-9, "\(temperamento)")
            #expect(abs(afinacion.frecuencia(de: "Mi5") / afinacion.frecuencia(de: "Mi4") - (2)) <= 1e-12)
        }
        let distinguen = paraEscuchar.filter(\.distingueEnarmonicas)
        #expect(distinguen == [.pitagorico, .mesotonicoCuartoDeComa, .afinacionJusta])
        #expect(TemperamentoConNombre.divisiones31.distingueEnarmonicas)
        #expect(!TemperamentoConNombre.comas53.distingueEnarmonicas)
        let igual = try #require(TemperamentoConNombre.temperamentoIgual.afinacion())
        #expect(abs(igual.desviacion(de: "Fa#3") - (0)) <= 1e-9)
        let justa = try #require(TemperamentoConNombre.afinacionJusta.afinacion(tonica: .re))
        #expect(abs(justa.desviacion(de: "Fa#4") - (-13.69)) <= 0.01)
        let mesotonico = try #require(TemperamentoConNombre.mesotonicoCuartoDeComa.afinacion())
        #expect(abs(mesotonico.cents(desde: "Do4", hasta: "Mi4") - (RazonDeFrecuencias(5, 4).cents)) <= 1e-9)
        for idioma in Idioma.allCases {
            let nombres = paraEscuchar.map { $0.nombre(en: Notacion.delIdioma(idioma)) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }

    @Test func razonesJustas() {
        let esperadas: [(Intervalo, String)] = [
            (.segundaMenor, "16/15"), (.segundaMayor, "9/8"), (.terceraMenor, "6/5"), (.terceraMayor, "5/4"),
            (.cuartaJusta, "4/3"), (.cuartaAumentada, "45/32"), (.quintaDisminuida, "36/25"),
            (.quintaJusta, "3/2"), (.sextaMenor, "8/5"), (.sextaMayor, "5/3"), (.septimaMenor, "9/5"),
            (.septimaMayor, "15/8"), (.octava, "2/1"), (.unisonoAumentado, "25/24"), (.novenaMayor, "9/4"),
        ]
        for (intervalo, razon) in esperadas {
            #expect(intervalo.razonJusta.description == razon, Comment(rawValue: intervalo.nombre))
        }
        #expect((-Intervalo.terceraMayor).razonJusta.description == "4/5")
        #expect(abs(Intervalo.terceraMayor.razonJusta.cents - (386.313_7)) <= 1e-3)
        #expect(abs(RazonDeFrecuencias.comaSintonica.cents - (21.506)) <= 1e-3)
        #expect(abs(RazonDeFrecuencias.comaPitagorica.cents - (23.460)) <= 1e-3)
    }

    @Test func afinacionJusta() {
        let justa = AfinacionJusta(tonica: .do)
        let do4 = Altura("Do4").frecuencia()
        #expect(abs(justa.frecuencia(de: "Do4") - (do4)) <= 1e-9)
        #expect(abs(justa.frecuencia(de: "Mi4") - (do4 * 5 / 4)) <= 1e-9)
        #expect(abs(justa.frecuencia(de: "La4") - (do4 * 5 / 3)) <= 1e-9)
        #expect(abs(justa.frecuencia(de: "Re5") - (do4 * 9 / 4)) <= 1e-9)
        #expect(abs(justa.frecuencia(de: "Si3") - (do4 * 15 / 16)) <= 1e-9)
        #expect(abs(justa.desviacion(de: "Mi4") - (1200 * log2(5.0 / 4.0) - 400)) <= 1e-9)
        #expect(abs(justa.cents(desde: "Do4", hasta: "Sol4") - (1200 * log2(1.5))) <= 1e-9)
        #expect(abs(Altura("Mi4").frecuencia(en: justa) - (do4 * 5 / 4)) <= 1e-9)
        // La escala mayor de Ptolomeo.
        let razones = Escala(.do).alturas(octava: 4).map { justa.frecuencia(de: $0) / do4 }
        for (r, esperada) in zip(razones, [1, 9.0 / 8, 5.0 / 4, 4.0 / 3, 1.5, 5.0 / 3, 15.0 / 8, 2]) {
            #expect(abs(r - (esperada)) <= 1e-12)
        }
    }
}

@Suite struct BaseDeHewlettTests {
    @Test func bases() {
        #expect(BaseDeHewlett.base40.base == 40)
        #expect(BaseDeHewlett.base54.base == 54)
        #expect(BaseDeHewlett.base600.base == 600)
        #expect(BaseDeHewlett(base: 40) == .base40)
        #expect(BaseDeHewlett(base: 54).alteracionMaxima == 3)
        #expect(BaseDeHewlett(base: 600).alteracionMaxima == 42)
        #expect(BaseDeHewlett(base: 12).alteracionMaxima == 0)
        #expect(BaseDeHewlett(comprobando: 41) == nil)
        #expect(BaseDeHewlett(comprobando: 40) == .base40)
        #expect(BaseDeHewlett(comprobando: 7) == nil)
        #expect(BaseDeHewlett.base40.description == "base 40")
    }

    @Test func base40() {
        // Valores de Hewlett y Humdrum: Do4 = 162, quinta justa = 23.
        let casos: [(Altura, Int)] = [
            ("Do4", 162), ("Sol4", 185), ("Fa#4", 180), ("Solb4", 184),
            ("Do5", 202), ("Dobb4", 160), ("Six4", 199), ("Dob4", 161), ("Si#3", 158),
        ]
        for (nota, numero) in casos {
            #expect(nota.numero(en: .base40) == numero, Comment(rawValue: nota.description))
            #expect(Altura(numero: numero, en: .base40) == nota, Comment(rawValue: nota.description))
        }
        #expect(Altura(Nota(.fa, 3), octava: 4).numero(en: .base40) == nil)
        #expect(Altura(numero: 162 + 20, en: .base40) == nil) // hueco entre Fa𝄪 y Sol𝄫
        #expect(Nota.do.numero(en: .base40) == 2)
        #expect(Nota("Si#").numero(en: .base40) == 38)
        #expect(Nota("Dob").numero(en: .base40) == 1)
        #expect(Nota(numero: 42, en: .base40) == .do)
        #expect(Nota(numero: 5, en: .base40) == nil)
    }

    @Test func intervalosEnBase40() {
        let casos: [(Intervalo, Int)] = [
            (.unisono, 0), (.segundaMenor, 5), (.segundaMayor, 6), (.terceraMenor, 11), (.terceraMayor, 12),
            (.cuartaJusta, 17), (.cuartaAumentada, 18), (.quintaDisminuida, 22), (.quintaJusta, 23),
            (.sextaMenor, 28), (.sextaMayor, 29), (.septimaMenor, 34), (.septimaMayor, 35), (.octava, 40),
            (.novenaMayor, 46), (-Intervalo.quintaJusta, -23), (-Intervalo.terceraMayor, -12),
        ]
        for (intervalo, numero) in casos {
            #expect(intervalo.numero(en: .base40) == numero, Comment(rawValue: intervalo.description))
            #expect(Intervalo(numero: numero, en: .base40) == intervalo, Comment(rawValue: intervalo.description))
        }
        #expect(Intervalo(numero: 20, en: .base40) == nil) // entre la 4ª doble aumentada y la 5ª doble disminuida
        // Los intervalos son diferencias de números.
        let re: Altura = "Re4"
        let sib: Altura = "Sib3"
        #expect((re.numero(en: .base40)! - sib.numero(en: .base40)!) == (re - sib).numero(en: .base40))
    }

    @Test func base54YBase600() {
        let faTripleSostenido = Altura(Nota(.fa, 3), octava: 4)
        #expect(faTripleSostenido.numero(en: .base54) == 245)
        #expect(Altura(numero: 245, en: .base54) == faTripleSostenido)
        #expect(Altura("Do4").numero(en: .base54) == 219)
        #expect(Intervalo.quintaJusta.numero(en: .base54) == 31)
        #expect(Altura("Do4").numero(en: .base600) == 2442)
        #expect(Intervalo.quintaJusta.numero(en: .base600) == 343)
        #expect(Intervalo.octava.numero(en: .base600) == 600)
        let muyAlterada = Altura(Nota(.la, -42), octava: 2)
        #expect(Altura(numero: muyAlterada.numero(en: .base600)!, en: .base600) == muyAlterada)
        #expect(Altura(Nota(.la, 43), octava: 2).numero(en: .base600) == nil)
    }
}
