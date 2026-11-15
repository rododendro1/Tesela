import Armonia
import Foundation
import Testing

@testable import ExposicionArmonia

@Suite struct CaracterPresentadoTests {
    private let espanol = Notacion.compacta(.espanol)

    /// Una fuente, con sus afectos por su clave, sus palabras y su cita.
    @Test func unaFuente() {
        let fa = CaracterPresentado(Tonalidad(.fa).caracter[0], en: espanol)
        #expect(fa.descripcion == "colérico" && fa.afectos == ["colerico"])
        #expect(fa.texto == "Furieux et emporté" && fa.cita == "Charpentier (Cessac 1988)" && fa.anio == 1690)
        #expect(fa.enUnaLinea == "colérico · “Furieux et emporté” (Charpentier (Cessac 1988))")
        #expect(CaracterPresentado.de([], en: espanol) == nil)
        #expect(CaracterPresentado.discrepancias(Tonalidad(.fa).caracter, en: espanol) == ["Charpentier · Schubart"])
        #expect(CaracterPresentado.discrepancias(Tonalidad(Nota(.si, .bemol), .menor).caracter, en: espanol) == nil)
    }

    /// La escala presentada lleva su carácter, lo que se mide de ella y su sonoridad; en el JSON, por sus claves.
    @Test func enLaEscala() throws {
        let saba = EscalaPresentada(Escala(.re, .saba), en: espanol)
        #expect(saba.caracter?.first?.texto == "sadness and pain" && saba.sonoridad == nil && saba.medidas == nil)
        let frigio = EscalaPresentada(Escala(.mi, .frigio), en: espanol)
        #expect(frigio.caracter == nil && frigio.sonoridad == "oscura")
        #expect(frigio.medidas?.first?.enUnaLinea == "alegre: 21 % (Temperley & Tan 2013: 248)")
        let json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(frigio)) as? [String: Any]
        #expect(json?["caracter"] == nil && json?["sonoridad"] as? String == "oscura")
    }

    /// Las filas de las apps: una por fuente y, al final, lo que se calcula.
    @Test func lasFilasDeLasApps() {
        let doria = PresentacionDeEstudioDeEscala.caracter(de: .harmoniaDoria, en: espanol)
        #expect(doria.map(\.nombre).last == "Las fuentes no coinciden")
        #expect(doria.first?.nombre == "Heraclides Póntico XIV 624–625 (Monro 1894: 9–11)")
        let mayor = PresentacionDeEstudioDeEscala.caracter(de: .mayor, en: espanol)
        #expect(mayor.map(\.nombre) == ["Afecto medido", "Sonoridad (calculada)"])
        #expect(PresentacionDeEstudioDeEscala.caracter(de: Tonalidad(.do), en: espanol).count == 3)
        #expect(PresentacionDeEstudioDeEscala.caracter(de: Tonalidad(Nota(.do, .sostenido)), en: espanol).isEmpty)
    }

    /// Las hojas HTML llevan la sección del carácter si hay algo que decir.
    @Test func enLasHojas() {
        let fa = PresentacionDeTonalidad.hojaDeEstudioHTML(de: Tonalidad(.fa), en: espanol)
        #expect(fa.contains("<h2>Carácter</h2>") && fa.contains("<q>Furieux et emporté</q>"))
        #expect(fa.contains("Las fuentes no coinciden"))
        let doSostenido = PresentacionDeTonalidad.hojaDeEstudioHTML(de: Tonalidad(Nota(.do, .sostenido)), en: espanol)
        #expect(!doSostenido.contains("Carácter"))
        let saba = PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(de: Escala(.re, .saba), en: espanol)
        #expect(saba.contains("<q>sadness and pain</q>"))
    }

    /// El reloj de los rāgas: los ocho prahar, cada rāga en el suyo.
    @Test func elRelojDeLosRagas() {
        let prahar = PresentacionDelRelojDeLosRagas.ragasPorMomento(en: espanol)
        #expect(prahar.map(\.momento.horaDeInicio) == [0, 3, 6, 9, 12, 15, 18, 21])
        #expect(prahar.first { $0.momento == .anochecer }?.ragas == ["Yaman", "Bhūpālī"])
        #expect(prahar.flatMap(\.ragas).count == 19) // Megh no tiene hora, solo estación
        let svg = PresentacionDelRelojDeLosRagas.svg(en: .compacta(.ingles))
        #expect(svg.hasPrefix("<svg") && svg.contains(">Rāga clock<") && svg.contains(">Darbārī Kānaḍa<"))
    }
}
