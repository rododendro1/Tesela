import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Los nombres que dependen de la octava (notas árabes, perde turcas, cuerdas griegas), los de los 22 śruti y los
/// del gamelan javanés.
@Suite struct NombresPorOctavaTests {
    @Test func notasArabes() throws {
        let arabe = NombresPorOctava.arabe
        #expect(arabe.nombre(de: Altura(.do, octava: 4)) == "Rāst")
        #expect(arabe.nombre(de: Altura(.mi, octava: 4), ajuste: -1) == "Sīkāh")
        // Mi𝄳 también se escribe como Mi♭ un cuarto de tono alto.
        #expect(arabe.nombre(de: Altura(Nota("Mib"), octava: 4), ajuste: 1) == "Sīkāh")
        #expect(arabe.nombre(de: Altura(.sol, octava: 3)) == "Yakāh")
        #expect(arabe.nombre(de: Altura(.sol, octava: 4), grafia: .original) == "نوى")
        #expect(arabe.nombre(de: Altura(.la, octava: 3), grafia: .ascii) == "Ushayran")
        // Do♯ y Re♭ son el mismo Zīrkūlāh.
        #expect(arabe.nombre(de: Altura(Nota("Do#"), octava: 4)) == "Zīrkūlāh")
        #expect(arabe.nombre(de: Altura(.do, octava: 7)) == nil)
        let sikah = try arabe.leer("sikah")
        #expect(sikah.altura == Altura(.mi, octava: 4))
        #expect(sikah.ajuste == -1)
        #expect(sikah.description == "Sīkāh (Mi𝄳4)")
        #expect(try arabe.leer("ʿUshayrān").altura == Altura(.la, octava: 3))
        #expect(try arabe.leer("راست").altura == Altura(.do, octava: 4))
        #expect(throws: ErrorDeLectura.self) { try arabe.leer("Segâh") }
    }

    @Test func maqamRast() {
        let rast = Escala(.do, .maqamRast)
        #expect(
            rast.nombres(en: .arabe, octava: 4) == ["Rāst", "Dūkāh", "Sīkāh", "Jahārkāh", "Nawā", "Ḥusaynī", "Awj"])
        // Una octava abajo empieza en Qarār Rāst, que no tiene nombre en la tabla: desde Sol3, Yakāh.
        #expect(Escala(.sol, .maqamRast).nombres(en: .arabe, octava: 3).first == "Yakāh")
    }

    @Test func perdesTurcas() throws {
        let turco = NombresPorOctava.turco
        #expect(turco.nombre(de: Altura(.sol, octava: 4)) == "Rast")
        #expect(turco.nombre(de: Altura(.si, octava: 4), ajuste: -1) == "Segâh")
        #expect(turco.nombre(de: Altura(.si, octava: 4), ajuste: -1, grafia: .ascii) == "Segah")
        #expect(turco.nombre(de: Altura(.re, octava: 5)) == "Nevâ")
        #expect(turco.nombre(de: Altura(.re, octava: 4)) == "Yegâh")
        // Kürdi es el Si♭ pitagórico, cinco comas bajo Si.
        #expect(turco.nombre(de: Altura(.si, octava: 4), ajuste: -5) == "Kürdi")
        #expect(turco.alturas.count == 49)
        let pasos = turco.alturas.map { turco.pasos(de: $0.altura, ajuste: $0.ajuste) }
        #expect(pasos == pasos.sorted())
        #expect(pasos.first == 0)
        #expect(pasos.last == 106)
        let huseyniAsiran = try turco.leer("huseyni asiran")
        #expect(huseyniAsiran.altura == Altura(.mi, octava: 4))
        #expect(try turco.leer("evic").ajuste == -1)
        #expect(try turco.leer("Irak").altura == Altura(Nota("Fa#"), octava: 4))
    }

    @Test func rastMakami() {
        let rast = Escala(.sol, .rastMakami)
        #expect(
            rast.nombres(en: .turco, octava: 4) == ["Rast", "Dügâh", "Segâh", "Çârgâh", "Nevâ", "Hüseynî", "Eviç"])
    }

    @Test func cuerdasGriegas() throws {
        let griego = NombresPorOctava.griegoAntiguo
        #expect(griego.sistemaMicrotonal == nil)
        #expect(griego.nombre(de: Altura(.la, octava: 3)) == "mésē")
        #expect(griego.nombre(de: Altura(.la, octava: 2), grafia: .original) == "προσλαμβανόμενος")
        #expect(griego.nombre(de: Altura(.la, octava: 4), grafia: .ascii) == "nete hyperbolaion")
        // Do4 es la trítē diezeugménōn y la paranḗtē synēmménōn: se escribe con la primera y se leen las dos.
        #expect(griego.nombre(de: Altura(.do, octava: 4)) == "trítē diezeugménōn")
        #expect(try griego.leer("paranete synemmenon").altura == Altura(.do, octava: 4))
        #expect(try griego.leer("ὑπάτη μέσων").altura == Altura(.mi, octava: 3))
        #expect(griego.nombre(de: Altura(Nota("Sib"), octava: 3)) == "trítē synēmménōn")
        let dorio = Escala(.mi, .frigio)
        #expect(dorio.nombres(en: .griegoAntiguo, octava: 3).first == "hypátē mésōn")
    }

    @Test func sruti() throws {
        let nombres = SistemaMicrotonal.nombresDeLosSruti()
        #expect(nombres.count == 22)
        #expect(nombres.first == "tīvrā")
        #expect(SistemaMicrotonal.nombresDeLosSruti(en: .ascii)[13] == "kshiti")
        let bilaval = try #require(Escala(.do, .bilaval).notasMicrotonales())
        #expect(
            bilaval.compactMap { $0.nombreDelSruti() }
                == ["tīvrā", "chandovatī", "raudrī", "vajrikā", "kṣiti", "ālāpinī", "ugrā"])
        let bayati = try #require(Escala(.re, .bayati).notasMicrotonales())
        #expect(bayati.first?.nombreDelSruti() == nil)
    }

    @Test func gamelan() {
        #expect(TipoDeEscala.pelogNem.gamelan?.laras == .pelog)
        #expect(Escala(.sol, .pelogNem).nombresDelGamelan() == ["lima", "nem", "bem", "gulu", "dhadha"])
        #expect(Escala(.sol, .pelogNem).nombresDelGamelan(grafia: .original) == ["5", "6", "1", "2", "3"])
        #expect(Escala(.do, .slendroSanga).nombresDelGamelan() == ["lima", "nem", "barang", "gulu", "dhadha"])
        #expect(Laras.pelog.nombre(deLaCifra: 4, grafia: .ascii) == "pelog")
        #expect(Laras.slendro.nombre(deLaCifra: 4) == nil)
        #expect(Escala(.do, .mayor).nombresDelGamelan() == nil)
    }
}
