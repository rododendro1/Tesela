import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// Las articulaciones y los ornamentos en el pentagrama, los grupos irregulares con su cifra y los sistemas de
/// varios pentagramas.
@Suite struct OrnamentosYSistemasTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    private func veces(_ glifo: Glifo, en svg: String) -> Int { contar("d=\"\(glifo.trazado)\"", en: svg) }

    // MARK: Ornamentos y articulaciones

    /// Los ornamentos se leen en el texto de un evento, con su nombre o con el inglés.
    @Test func losOrnamentosSeLeen() throws {
        let evento = try Evento(leyendo: "Do5:4{trino,grupeto}")
        #expect(evento.articulaciones == [.trino, .grupeto])
        let alias = try Evento(leyendo: "Re5:4{trill,prall,mordent,reverseturn}")
        #expect(alias.articulaciones == [.trino, .mordenteSuperior, .mordenteInferior, .grupetoInvertido])
        #expect(evento.texto == "Do5:4{trino,grupeto}")
        #expect(Articulacion.trino.esOrnamento && !Articulacion.calderon.esOrnamento)
        #expect(Articulacion.trino.proporcionQueSuena == Duracion(1, 1))
    }

    /// Cada articulación y cada ornamento se dibuja con su glifo; las de la cabeza, del lado contrario a la plica.
    @Test func lasArticulacionesSeDibujan() throws {
        let voz = try Voz(
            leyendo: "Do5:4{staccato} Re5:4{tenuto,acento} Mi4:4{marcato} Fa4:4{staccatissimo} "
                + "Sol4:4{trino} La4:4{mordenteSuperior} Si4:4{mordenteInferior} Do5:4{grupeto} "
                + "Re5:2{grupetoInvertido} -:2{calderon}")
        let svg = voz.svgPentagrama(titulo: "Adornos")
        #expect(veces(GlifosSMuFL.staccatoArriba, en: svg) == 1)
        #expect(veces(GlifosSMuFL.tenuto, en: svg) == 1)
        #expect(veces(GlifosSMuFL.acento, en: svg) == 1)
        // Mi4 y Fa4 llevan la plica hacia arriba: sus articulaciones van debajo.
        #expect(veces(GlifosSMuFL.marcatoAbajo, en: svg) == 1)
        #expect(veces(GlifosSMuFL.staccatissimoAbajo, en: svg) == 1)
        for glifo in [
            GlifosSMuFL.trino, GlifosSMuFL.mordenteSuperior, GlifosSMuFL.mordenteInferior, GlifosSMuFL.grupeto,
            GlifosSMuFL.grupetoInvertido, GlifosSMuFL.calderonArriba,
        ] {
            #expect(veces(glifo, en: svg) == 1)
        }
        // Sin articulaciones, ninguno.
        let sin = try Voz(leyendo: "Do5:4 Re5:4").svgPentagrama(titulo: "Sin")
        #expect(veces(GlifosSMuFL.staccatoArriba, en: sin) == 0)
    }

    /// Con dos voces, las articulaciones de la de arriba van encima y las de la de abajo, debajo.
    @Test func lasArticulacionesDeDosVoces() throws {
        let arriba = try Voz(leyendo: "Mi5:2{marcato} Re5:2{calderon}")
        let abajo = try Voz(leyendo: "Do5:2{marcato} Si4:2{calderon}")
        let svg = arriba.svgPentagrama(junto: abajo, titulo: "Dos")
        #expect(veces(GlifosSMuFL.marcatoArriba, en: svg) == 1)
        #expect(veces(GlifosSMuFL.marcatoAbajo, en: svg) == 1)
        #expect(veces(GlifosSMuFL.calderonArriba, en: svg) == 1)
        #expect(veces(GlifosSMuFL.calderonAbajo, en: svg) == 1)
    }

    // MARK: Grupos irregulares

    /// El cinquillo, el septillo y el seisillo llevan su cifra y su figura.
    @Test func losGruposIrregularesLlevanSuCifra() {
        let cinquillo = Voz((0..<5).map { _ in Evento("Do5", Duracion.semicorchea.grupoIrregular(5, en: 4)) })
        let ritmo = PentagramaSVG.Ritmo.de(cinquillo, resaltada: nil).ritmo
        #expect(ritmo.tresillos == [[0, 1, 2, 3, 4]])
        #expect(ritmo.cifrasDeLosGrupos == [5])
        #expect(ritmo.figuras.allSatisfy { $0.figura == .semicorchea })
        let svg = cinquillo.svgPentagrama(titulo: "Cinquillo")
        #expect(veces(GlifosSMuFL.cifraDeGrupo5, en: svg) == 1)
        let septillo = Voz((0..<7).map { _ in Evento("Re5", Duracion.semicorchea.grupoIrregular(7, en: 4)) })
        let deSiete = PentagramaSVG.Ritmo.de(septillo, resaltada: nil).ritmo
        #expect(deSiete.cifrasDeLosGrupos == [7])
        // Los tresillos siguen con su 3.
        let tresillo = Voz((0..<3).map { _ in Evento("Mi5", Duracion.corchea.grupoIrregular(3, en: 2)) })
        #expect(PentagramaSVG.Ritmo.de(tresillo, resaltada: nil).ritmo.cifrasDeLosGrupos == [3])
        #expect(PentagramaSVG.Ritmo.grupoIrregular(.negra) != nil)
        #expect(PentagramaSVG.Ritmo.grupoIrregular(Duracion(1, 17)) == nil)
    }

    /// Un grupo de once lleva las dos cifras.
    @Test func unGrupoDeOnceLlevaDosCifras() {
        let once = Voz((0..<11).map { _ in Evento("Do5", Duracion.fusa.grupoIrregular(11, en: 8)) })
        let svg = once.svgPentagrama(titulo: "Once")
        #expect(veces(GlifosSMuFL.cifraDeGrupo1, en: svg) == 2)
    }

    // MARK: Sistemas

    /// El piano: dos pentagramas con su clave, unidos por la llave, con las barras atravesándolos y lo que suena a
    /// la vez en la misma vertical.
    @Test func elPianoEnDosPentagramas() throws {
        let derecha = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2 Re5:4 Mi5:4 Re5:2")
        let izquierda = try Voz(leyendo: "Do3:2 Sol2:2 Sol2:2 Do3:2")
        let svg = Voz.svgSistema([[derecha], [izquierda]], titulo: "Piano", claves: [.sol, .fa], llave: true)
        #expect(veces(GlifosSMuFL.claveDeSol, en: svg) == 1)
        #expect(veces(GlifosSMuFL.claveDeFa, en: svg) == 1)
        #expect(veces(GlifosSMuFL.llave, en: svg) == 1)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 10)
        #expect(contar("<title id=", en: svg) == 1)
        let coro = Voz.svgSistema([[derecha], [izquierda]], titulo: "Coro")
        #expect(veces(GlifosSMuFL.llave, en: coro) == 0)
        #expect(contar("stroke-width=\"0.5\"", en: coro) >= 2)
    }

    /// Un coral a cuatro voces: soprano y contralto en el de sol, tenor y bajo en el de fa.
    @Test func elCoralEnDosPentagramas() throws {
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4 | Do3 Sol3 Mi4 Do5")
        let svg = coral.svgPentagrama(titulo: "Cadencia")
        #expect(veces(GlifosSMuFL.blanca, en: svg) == 12)
        #expect(veces(GlifosSMuFL.claveDeSol, en: svg) == 1)
        #expect(veces(GlifosSMuFL.claveDeFa, en: svg) == 1)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 10)
        #expect(svg.contains("<title>Sol₂</title>") && svg.contains("<title>Si₄</title>"))
        var lineas = OpcionesDePentagrama()
        lineas.compasesPorLinea = 1
        let partido = coral.svgPentagrama(titulo: "Cadencia", figura: .redonda, opciones: lineas)
        #expect(contar("stroke-width=\"0.13\"", en: partido) == 30)
        #expect(veces(GlifosSMuFL.cifraDeCompas4, en: partido) == 4)
    }

    /// Sin pentagramas no hay nada roto, y un pentagrama vacío se salta.
    @Test func losSistemasRaros() throws {
        #expect(Voz.svgSistema([], titulo: "Nada").contains("viewBox=\"0 0 0 0\""))
        let una = try Voz(leyendo: "Do5:1")
        let sola = Voz.svgSistema([[una], []], titulo: "Sola")
        #expect(contar("stroke-width=\"0.13\"", en: sola) == 5)
    }

    /// Dos voces en el pentagrama de arriba y una más corta en el de abajo, partido en líneas: la de abajo se
    /// acaba antes y las líneas que le faltan solo llevan el de arriba.
    @Test func unSistemaConDosVocesYLineasDesiguales() throws {
        let soprano = try Voz(leyendo: "Mi5:1 Re5:1 Do5:1")
        let contralto = try Voz(leyendo: "Do5:1 Si4:1 Do5:1")
        let bajo = try Voz(leyendo: "Do3:1")
        var opciones = OpcionesDePentagrama()
        opciones.compasesPorLinea = 1
        let svg = Voz.svgSistema([[soprano, contralto], [bajo]], titulo: "Desigual", opciones: opciones)
        #expect(veces(GlifosSMuFL.redonda, en: svg) == 7)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 20)
    }
}
