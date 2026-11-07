import Foundation
import Testing

@testable import Elementos
@testable import PartituraArmonia
@testable import Teoria

/// El ritmo y la armadura de una tonalidad en el pentagrama en SVG.
@Suite struct PentagramaConRitmoTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    private func veces(_ glifo: Glifo, en svg: String) -> Int { contar("d=\"\(glifo.trazado)\"", en: svg) }

    // MARK: Armadura

    /// El arpegio de Sol7 en Do mayor no lleva alteraciones; el de Mi7 en La menor, solo el sostenido del Sol.
    @Test func elArpegioEnUnaTonalidadSoloLlevaLasAlteracionesQueFaltan() {
        let enDo = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.do, .mayor)))
        let enLaMenor = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.la, .menor)))
        #expect(veces(GlifosSMuFL.sostenido, en: Arpegio(Acorde("Sol7")).svgPentagrama(opciones: enDo)) == 0)
        let mi7 = Arpegio(Acorde("Mi7")).svgPentagrama(opciones: enLaMenor)
        #expect(veces(GlifosSMuFL.sostenido, en: mi7) == 1)
        #expect(mi7.contains("<title>Sol♯₄</title>"))
    }

    /// Con la armadura de Sol mayor, el Fa♯ de Re7 no lleva sostenido delante pero la armadura sí lo escribe; el
    /// Fa natural de Re menor lleva becuadro.
    @Test func elAcordeEnUnaTonalidadLlevaSuArmadura() {
        let enSol = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.sol, .mayor)))
        #expect(veces(GlifosSMuFL.sostenido, en: Acorde("Re7").svgPentagrama(opciones: enSol)) == 1)
        #expect(veces(GlifosSMuFL.sostenido, en: Acorde("Re7").svgPentagrama()) == 1)
        #expect(veces(GlifosSMuFL.becuadro, en: Acorde("Rem").svgPentagrama(opciones: enSol)) == 1)
        #expect(veces(GlifosSMuFL.becuadro, en: Acorde("Rem").svgPentagrama()) == 0)
    }

    /// La armadura de una tonalidad manda también en las escalas: la menor armónica en La menor lleva el Sol♯
    /// delante de su nota; Re mayor en Do mayor, el Fa♯ y el Do♯.
    @Test func laEscalaPuedeLlevarLaArmaduraDeOtraTonalidad() {
        let enLaMenor = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.la, .menor)))
        #expect(veces(GlifosSMuFL.sostenido, en: Escala("La menor armónica").svgPentagrama(opciones: enLaMenor)) == 1)
        let enDo = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.do, .mayor)))
        #expect(veces(GlifosSMuFL.sostenido, en: Escala(.re).svgPentagrama(opciones: enDo)) == 2)
        #expect(veces(GlifosSMuFL.sostenido, en: Escala(.re).svgPentagrama()) == 2)
    }

    /// Las disposiciones (una progresión) llevan la armadura que se les dé.
    @Test func lasDisposicionesLlevanLaArmaduraQueSeLesDe() {
        let acordes = [[Altura("Re4"), Altura("Fa♯4"), Altura("La4")]]
        let enSol = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.sol, .mayor)))
        let svg = Partitura(acordes: acordes, titulo: "Re").svg(opciones: enSol)
        #expect(veces(GlifosSMuFL.sostenido, en: svg) == 1)
        #expect(veces(GlifosSMuFL.sostenido, en: Partitura(acordes: acordes, titulo: "Re").svg()) == 1)
    }

    // MARK: Ritmo

    /// Ocho corcheas en 4/4: cabezas negras, la cifra del compás, cuatro grupos de dos con su barra y ningún corchete.
    @Test func lasCorcheasVanUnidasDeDosEnDos() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:8 La4:8 Si4:8 Do5:8")
        let svg = voz.svgPentagrama(titulo: "Escala")
        #expect(veces(GlifosSMuFL.negra, en: svg) == 8)
        #expect(veces(GlifosSMuFL.redonda, en: svg) == 0)
        #expect(veces(GlifosSMuFL.cifraDeCompas4, en: svg) == 2)
        let corchetes = [GlifosSMuFL.corcheteDeCorcheaArriba, GlifosSMuFL.corcheteDeCorcheaAbajo]
        #expect(corchetes.map { veces($0, en: svg) } == [0, 0])
        // Ocho plicas y cuatro barras de unión (trazados sin `transform`, a diferencia de los glifos).
        // (El grupo de la marca de octava lleva también ese grosor.)
        #expect(contar("stroke-width=\"0.12\"", en: svg) == 8 + 1)
        #expect(contar("<path d=\"M", en: svg) == 4)
        #expect(svg == voz.svgPentagrama(titulo: "Escala"))
    }

    /// Una corchea suelta lleva corchete; una blanca, cabeza blanca; una redonda, sin plica.
    @Test func lasFigurasSueltas() throws {
        let svg = try Voz(leyendo: "Do5:8 -:8 Re4:4 Mi4:2 Fa4:1").svgPentagrama(titulo: "Figuras")
        #expect(veces(GlifosSMuFL.corcheteDeCorcheaAbajo, en: svg) == 1)
        #expect(veces(GlifosSMuFL.silencioDeCorchea, en: svg) == 1)
        #expect(veces(GlifosSMuFL.blanca, en: svg) == 1)
        #expect(veces(GlifosSMuFL.redonda, en: svg) == 1)
        #expect(veces(GlifosSMuFL.negra, en: svg) == 2)
    }

    /// Una nota que cruza la barra se divide y se liga, y la barra de compás va entre las dos; el puntillo se
    /// escribe detrás de la cabeza.
    @Test func lasLigadurasYLasBarrasDeCompas() throws {
        let svg = try Voz(leyendo: "Do4:4 Re4:2. Mi4:2.", compas: Compas(3, 4)).svgPentagrama(titulo: "Ligada")
        #expect(veces(GlifosSMuFL.cifraDeCompas3, en: svg) == 1)
        // Las dos blancas con puntillo empiezan en el 2.º tiempo: blanca ligada a negra (`Voz.grafia`), y Mi4 cruza
        // la barra.
        #expect(contar("<title>Re₄</title>", en: svg) == 2)
        #expect(contar("<title>Mi₄</title>", en: svg) == 2)
        #expect(contar("Q", en: svg) == 4) // dos ligaduras, de dos curvas cada una
        #expect(veces(GlifosSMuFL.puntillo, en: svg) == 0)
        let conPuntillo = try Voz(leyendo: "Sol4:2.", compas: Compas(3, 4)).svgPentagrama(titulo: "Puntillo")
        #expect(veces(GlifosSMuFL.puntillo, en: conPuntillo) == 1)
    }

    /// Una nota ligada a la anterior no repite su alteración; después de la barra, la siguiente sí la lleva.
    @Test func lasAlteracionesValenHastaLaBarra() throws {
        let svg = try Voz(leyendo: "Fa♯4:4 Fa♯4:2. Fa♯4:4 Fa♯4:2", compas: Compas(3, 4)).svgPentagrama(titulo: "Fa♯")
        // Compás 1: Fa♯ (con sostenido), Fa♯ blanca ligada (vale el de antes). Compás 2: la continuación ligada (sin
        // él), Fa♯ (con él: la barra lo ha anulado), Fa♯ ligada. Compás 3: la continuación (sin él).
        #expect(veces(GlifosSMuFL.sostenido, en: svg) == 2)
    }

    /// Las corcheas de tresillo van en grupos de tres, unidas por una barra y con el 3, sin corchete.
    @Test func losTresillos() {
        let figura = Duracion.corchea.grupoIrregular(3, en: 2)
        let voz = Voz(Arpegio(Acorde("Do"), patron: .idaYVuelta, conOctava: false), figura: figura)
        // Do Mi Sol Mi Do: dos grupos, uno de tres y otro de dos (incompleto).
        let svg = voz.svgPentagrama(titulo: "Tresillos")
        #expect(veces(GlifosSMuFL.cifraDeTresillo, en: svg) == 2)
        let ritmo = PentagramaSVG.Ritmo.de(voz, resaltada: nil).ritmo
        #expect(ritmo.tresillos == [[0, 1, 2], [3, 4]])
        #expect(ritmo.vigas == [[0, 1, 2], [3, 4]])
        #expect(ritmo.figuras.allSatisfy { $0.figura == .corchea })
    }

    /// Una negra de tresillo que cruza el pulso no se parte, y no lleva barra.
    @Test func lasNegrasDeTresilloNoSeParten() {
        let voz = Voz(Arpegio(Acorde("Fa"), conOctava: false), figura: Duracion.negra.grupoIrregular(3, en: 2))
        let (ritmo, columnas, _) = PentagramaSVG.Ritmo.de(voz, resaltada: nil)
        #expect(columnas.count == 3)
        #expect(ritmo.vigas.isEmpty)
        #expect(ritmo.tresillos == [[0, 1, 2]])
        #expect(ritmo.figuras.allSatisfy { $0.figura == .negra })
    }

    /// La nota resaltada cuenta las que se oyen: los silencios y las continuaciones ligadas no cuentan, y una nota
    /// partida en dos se resalta entera.
    @Test func laNotaResaltadaCuentaLoQueSuena() throws {
        let voz = try Voz(leyendo: "-:4 Do4:4 Re4:2. Mi4:4", compas: Compas(3, 4))
        // Columnas: silencio, Do4, Re4 (blanca, ligada), Re4 (negra), Mi4.
        #expect(PentagramaSVG.Ritmo.de(voz, resaltada: 1).ritmo.resaltadas == [2, 3])
        #expect(PentagramaSVG.Ritmo.de(voz, resaltada: 2).ritmo.resaltadas == [4])
        var opciones = OpcionesDePentagrama()
        opciones.marcas.resaltada = 1
        #expect(contar("fill=\"#E8590C\"", en: voz.svgPentagrama(titulo: "Re", opciones: opciones)) == 2)
    }

    /// Las semicorcheas llevan dos barras; los acordes con ritmo, una plica por columna.
    @Test func lasSemicorcheasYLosAcordes() throws {
        let semicorcheas = try Voz(leyendo: "Do4:16 Re4:16 Mi4:16 Fa4:16")
        #expect(PentagramaSVG.Ritmo.de(semicorcheas, resaltada: nil).ritmo.barras(0) == 2)
        #expect(contar("<path d=\"M", en: semicorcheas.svgPentagrama(titulo: "Semicorcheas")) == 2)
        let acordes = try Voz(leyendo: "Do4+Mi4+Sol4:4 Re4+Fa4+La4:4 Mi4+Sol4+Si4:2")
        let conAcordes = acordes.svgPentagrama(titulo: "Acordes")
        #expect(contar("<g><title>", en: conAcordes) == 9)
        #expect(contar("stroke-width=\"0.12\"", en: conAcordes) == 3 + 1)
    }

    /// Sin ritmo nada cambia: las escalas y los acordes siguen en redondas y sin compás.
    @Test func sinRitmoNoHayCompas() {
        let svg = Escala(.do).svgPentagrama()
        #expect(veces(GlifosSMuFL.cifraDeCompas4, en: svg) == 0)
        #expect(veces(GlifosSMuFL.negra, en: svg) == 0)
        #expect(veces(GlifosSMuFL.redonda, en: svg) == 8)
    }
}
