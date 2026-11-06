import Armonia
import Foundation
import Testing

@testable import TeselaPresentacion

// La vista de contrapunto de la app de armonía.
@Suite struct PresentacionDeContrapuntoTests {
    @Test func losEjemplosSeLeen() throws {
        for especie in Contrapunto.Especie.allCases {
            let ejemplo = PresentacionDeContrapunto.ejemplo(especie)
            let presentado = try PresentacionDeContrapunto.presentar(
                cantus: ejemplo.cantus, contrapunto: ejemplo.contrapunto, especie: especie, notacion: .espanolCompacto)
            #expect(presentado.filas.count == ejemplo.cantus.split(separator: " ").count, "especie \(especie.rawValue)")
            #expect(presentado.ficheros.count == 6)
        }
        // Los de la documentación del motor, que se sabe que no tienen faltas.
        for especie in [Contrapunto.Especie.primera, .segunda, .cuarta] {
            let ejemplo = PresentacionDeContrapunto.ejemplo(especie)
            let presentado = try PresentacionDeContrapunto.presentar(
                cantus: ejemplo.cantus, contrapunto: ejemplo.contrapunto, especie: especie, notacion: .espanolCompacto)
            #expect(presentado.esCorrecto, "especie \(especie.rawValue)")
            #expect(presentado.informe == ["Sin faltas."])
        }
    }

    @Test func unaFilaPorCompasConSusFaltas() throws {
        // Quintas paralelas del primer compás al segundo.
        let presentado = try PresentacionDeContrapunto.presentar(
            cantus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera,
            notacion: .espanolCompacto)
        #expect(!presentado.esCorrecto)
        #expect(presentado.cabecera == "Especie 1, con el contrapunto encima del cantus firmus")
        #expect(presentado.informe.contains("Quintas paralelas (compases 1 → 2)"))
        let primera = presentado.filas[0]
        #expect(primera.titulo == "Compás 1")
        #expect(primera.cantus == "Do₄")
        #expect(primera.contrapunto == "Sol₄")
        #expect(primera.intervalos == "5")
        #expect(primera.faltas.contains("Quintas paralelas"))
        #expect(presentado.filas[1].faltas.contains("Quintas paralelas"))
        #expect(presentado.filas.last?.intervalos == "8")
    }

    @Test func losSilenciosYLasLigaduras() throws {
        let ejemplo = PresentacionDeContrapunto.ejemplo(.cuarta)
        let presentado = try PresentacionDeContrapunto.presentar(
            cantus: ejemplo.cantus, contrapunto: ejemplo.contrapunto, especie: .cuarta, notacion: .espanolCompacto)
        #expect(presentado.filas[0].contrapunto == "– Re₅~")
        #expect(presentado.filas[0].intervalos == "– 8")
    }

    @Test func elCompasQueSuena() throws {
        let ejemplo = PresentacionDeContrapunto.ejemplo(.segunda)
        let presentado = try PresentacionDeContrapunto.presentar(
            cantus: ejemplo.cantus, contrapunto: ejemplo.contrapunto, especie: .segunda, notacion: .espanolCompacto)
        // Pasos: el cantus en el 0 y el contrapunto en la segunda blanca, luego dos por compás y el final.
        #expect(presentado.compas(enElPaso: 0) == 0)
        #expect(presentado.compas(enElPaso: 1) == 0)
        #expect(presentado.compas(enElPaso: 2) == 1)
        #expect(presentado.compas(enElPaso: presentado.sonido.inicios.count - 1) == 3)
        #expect(presentado.compas(enElPaso: nil) == nil)
        #expect(presentado.compas(enElPaso: 99) == nil)
        // Suenan las dos voces: cuatro redondas del cantus y seis notas del contrapunto.
        #expect(presentado.sonido.notas.count == 10)
    }

    @Test func lasIndicacionesVanEnLaNotacion() {
        #expect(PresentacionDeContrapunto.indicacionDelCantus(en: .inglesASCII) == "Cantus firmus (D4 F4 E4 D4)")
        #expect(PresentacionDeContrapunto.indicacionDelContrapunto(en: .inglesASCII) == "Counterpoint (-:2 A4 D5 …)")
    }

    @Test func unTextoQueNoSeLeeEsUnError() {
        #expect(throws: (any Error).self) {
            try PresentacionDeContrapunto.presentar(
                cantus: "Re4 Fa4", contrapunto: "La4", especie: .primera, notacion: .espanolCompacto)
        }
        #expect(throws: (any Error).self) {
            try PresentacionDeContrapunto.presentar(
                cantus: "Re4 Xx", contrapunto: "La4 La4", especie: .primera, notacion: .espanolCompacto)
        }
    }
}

// «Partitura» en la app del Tonnetz: los acordes de un fichero, con las transformaciones entre ellos.
@Suite struct RecorridoDePartituraTests {
    private func recorrido(_ texto: String) throws -> RecorridoDePartitura {
        let analisis = try AnalisisArmonico.analizar(leyendo: texto)
        // En MusicXML, que guarda la ortografía (un MIDI la estima).
        return try RecorridoDePartitura.leer(Data(analisis.partitura().musicXML().utf8), notacion: .espanolCompacto)
    }

    @Test func lasTransformacionesEntreTriadas() throws {
        let leido = try recorrido("Do Lam Fa Fam Lab Sol7 Do")
        #expect(leido.pasos.map(\.cifrado) == ["Do", "Lam", "Fa", "Fam", "La♭", "Sol7", "Do"])
        #expect(leido.pasos.map(\.transformacion) == ["", "R", "L", "P", "R", "–", "–"])
        // Una negra cada uno; el último, hasta la barra.
        #expect(leido.pasos.dropLast().allSatisfy { $0.duracion == .negra })
        #expect(leido.sonido.inicios.count == 7)
    }

    @Test func laTransformacionDeCadaPar() throws {
        #expect(RecorridoDePartitura.transformacion(desde: Acorde("Do"), hasta: Acorde("Do/Mi")) == "=")
        #expect(RecorridoDePartitura.transformacion(desde: Acorde("Do"), hasta: Acorde("Lab")) == "PL")
        // Basta que suenen igual.
        #expect(RecorridoDePartitura.transformacion(desde: Acorde("Mi"), hasta: Acorde("Lab")) == "LP")
    }

    @Test func elTramoQueSeDibuja() throws {
        let leido = try recorrido("Do Lam Fa Sol7 Do Mim")
        func tramo(_ i: Int, _ longitud: Int = 4) -> [String] {
            leido.tramo(hasta: i, longitud: longitud).map { $0.cifrado(en: .espanolCompacto) }
        }
        #expect(tramo(0) == ["Do"])
        #expect(tramo(2) == ["Do", "Lam", "Fa"])
        #expect(tramo(2, 2) == ["Lam", "Fa"])
        #expect(tramo(3) == ["Sol7"])
        #expect(tramo(5) == ["Do", "Mim"])
        #expect(tramo(9).isEmpty)
    }

    @Test func avanzarYRetroceder() throws {
        let leido = try recorrido("Do Fa Sol Do")
        #expect(leido.paso(desde: nil, avanzando: true) == 0)
        #expect(leido.paso(desde: 0, avanzando: true) == 1)
        #expect(leido.paso(desde: 3, avanzando: true) == 3)
        #expect(leido.paso(desde: 0, avanzando: false) == 0)
    }

    @Test func unFicheroSinAcordesEsUnError() throws {
        let melodia = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4").partitura().midi()
        #expect(throws: ErrorDeLecturaDeFichero.sinAcordes) {
            try RecorridoDePartitura.leer(melodia, notacion: .espanolCompacto)
        }
    }
}
