import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

/// Transportar lo escrito en los campos: progresiones, melodías y corales.
@Suite struct TransposicionTests {
    @Test func unaProgresion() throws {
        let re = try PresentacionDeTransposicion.transponer(
            "Do Lam Re7 Sol7/Si", .segundaMayor, notacion: .espanolUnicode)
        #expect(re == "Re Sim Mi7 La7/Do♯")
        let abajo = try PresentacionDeTransposicion.transponer("Do  Fa | Sol7", -.terceraMenor, notacion: .inglesASCII)
        #expect(abajo == "A  D | E7")
        #expect(throws: (any Error).self) {
            try PresentacionDeTransposicion.transponer("Do zzz", .segundaMayor, notacion: .espanolUnicode)
        }
    }

    @Test func deUnaTonalidadAOtra() throws {
        // De Do a La por el camino más corto: una tercera menor abajo.
        let texto = try PresentacionDeTransposicion.transponer(
            "Do Sol7", de: Tonalidad(.do), a: Tonalidad(.la), notacion: .espanolUnicode)
        #expect(texto == "La Mi7")
        let destinos = PresentacionDeTransposicion.destinos(desde: Tonalidad(.do))
        #expect(destinos.count == 11)
        #expect(!destinos.contains(Tonalidad(.do)))
        let enMenor = PresentacionDeTransposicion.destinos(desde: Tonalidad(.la, .menor))
        #expect(enMenor.allSatisfy { $0.modo == .menor })
    }

    @Test func notasYCorales() throws {
        let coral = try PresentacionDeTransposicion.transponer(
            "Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4", .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        #expect(coral == "Re3 Fa♯4 La4 Re5, La2 Mi4 La4 Do♯5")
        // Sol7 es aquí la nota Sol de la octava 7, no el acorde.
        func comoNotas(_ texto: String) throws -> String {
            try PresentacionDeTransposicion.transponer(
                texto, .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        }
        #expect(try (comoNotas("Sol7")) == "La7")
        #expect(try (comoNotas("Si7")) == "Do♯8")
        let melodia = try PresentacionDeTransposicion.transponer(
            "Mi4:4 Re4:8 -:8 Mi Fa", .cuartaJusta, contenido: .notas, notacion: .espanolUnicode)
        #expect(melodia.hasPrefix("La4:"), Comment(rawValue: melodia))
        #expect(melodia.hasSuffix(" La Si♭"), Comment(rawValue: melodia))
        #expect(melodia.contains(" -:"), Comment(rawValue: melodia))
    }

    @Test func unaProgresionAbierta() {
        let abierta = ProgresionImportada(
            acordes: [Acorde("Do"), Acorde("Sol")], ritmo: RitmoArmonico(duraciones: [.blanca, .blanca]),
            titulo: "Pieza")
        let enRe = PresentacionDeTransposicion.transponer(abierta, .segundaMayor)
        #expect(enRe.acordes == [Acorde("Re"), Acorde("La")])
        #expect(enRe.ritmo == abierta.ritmo)
        #expect(enRe.titulo == "Pieza")
    }

    @Test func laTonalidadDeLoEscrito() throws {
        #expect(PresentacionDeTransposicion.tonalidad(de: "Do Fa | Sol7 Do") == Tonalidad(.do))
        let enRe = PresentacionDeTransposicion.tonalidad(de: "Re4:4 Mi4 Fa# Sol La4+Si4:2 Do#5", contenido: .notas)
        let tonica = try #require(enRe).tonica
        #expect([Nota.re, Nota.si].contains(tonica), "\(tonica)")
        #expect(PresentacionDeTransposicion.tonalidad(de: "", contenido: .notas) == nil)
        #expect(PresentacionDeTransposicion.tonalidad(de: "zzz", contenido: .notas) == nil)
        #expect(PresentacionDeTransposicion.tonalidad(de: "") == nil)
    }

    @Test func losSilenciosYLasNotacionesQueNoSeLeen() throws {
        // Un guion o una tilde sueltos se dejan como están.
        let conSilencios = try PresentacionDeTransposicion.transponer(
            "Mi - ~ Fa", .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        #expect(conSilencios == "Fa♯ - ~ Sol")
        // En cualquier notación, lo transportado se vuelve a leer como lo que es.
        for notacion in Notacion.allCases {
            let acorde = try PresentacionDeTransposicion.transponer("Sol7", .segundaMenor, notacion: notacion)
            #expect(try (Acorde(leyendo: acorde)) == Acorde("Lab7"), "\(notacion)")
            let altura = try PresentacionDeTransposicion.transponer(
                "Do4", .segundaMenor, contenido: .notas, notacion: notacion)
            #expect(try (Altura(leyendo: altura)) == Altura(Nota.re.bemol, octava: 4), "\(notacion)")
        }
        #expect(PresentacionDeTransposicion.texto(de: [], notacion: .espanolUnicode) == "")
        #expect(PresentacionDeTransposicion.intervalos.count == 6)
    }
}
