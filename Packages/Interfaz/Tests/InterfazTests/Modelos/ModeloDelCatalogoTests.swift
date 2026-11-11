import Armonia
import Exposicion
import Testing

@testable import Interfaz

@Suite struct ModeloDelCatalogoTests {
    private let espanol = Notacion.compacta(.espanol)

    @Test func alAbrirEnsenaTodasLasProgresionesSobreDo() throws {
        let modelo = ModeloDelCatalogo()
        let fichas = modelo.fichas(en: espanol)
        #expect(fichas.count == ProgresionConNombre.catalogo.count)
        let perfecta = try #require(fichas.first)
        #expect(perfecta.nombre == "cadencia perfecta")
        #expect(perfecta.detalle == "V7 I · Sol7 Do")
        #expect(perfecta.estilos == "clásica")
        #expect(perfecta.fuentes == ["Aldwell et al. 2011"])
        #expect(perfecta.destino == .analisis("Sol7 Do"))
        #expect(perfecta.sonido == .acordes(ProgresionConNombre.catalogo[0].acordes(sobre: .do)))
    }

    @Test func cadaListaTieneSuTituloYSuCatalogo() {
        var modelo = ModeloDelCatalogo()
        let titulos = ModeloDelCatalogo.Lista.allCases.map { $0.titulo(en: espanol) }
        #expect(titulos == ["Progresiones", "Acordes con nombre", "Ritmos"])
        modelo.lista = .acordes
        #expect(modelo.fichas(en: espanol).count == AcordeConNombre.catalogo.count)
        modelo.lista = .ritmos
        #expect(modelo.fichas(en: espanol).count == RitmoConNombre.catalogo.count)
        #expect(ModeloDelCatalogo.Lista.ritmos.id == .ritmos)
    }

    @Test func seBuscaEnCualquierIdiomaYSinTildes() {
        var modelo = ModeloDelCatalogo()
        modelo.texto = "andaluza"
        #expect(modelo.fichas(en: espanol).map(\.id) == ["cadencia andaluza"])
        modelo.lista = .acordes
        modelo.texto = "TRISTAN"
        #expect(modelo.fichas(en: espanol).map(\.id) == ["acorde de Tristán"])
        modelo.lista = .ritmos
        modelo.texto = "son clave"
        #expect(modelo.fichas(en: espanol).map(\.id).contains("clave de son"))
        modelo.texto = "zzzz"
        #expect(modelo.fichas(en: espanol).isEmpty)
    }

    @Test func laTonicaMueveLasProgresionesYLosAcordes() {
        var modelo = ModeloDelCatalogo()
        modelo.tonica = Nota(.la)
        let andaluza = modelo.ficha(de: .andaluza, en: espanol)
        #expect(andaluza.detalle.hasSuffix(" · Lam Sol Fa Mi"))
        #expect(andaluza.destino == .analisis("Lam Sol Fa Mi"))
        let dominante = modelo.ficha(de: .dominanteSeptima, en: espanol)
        #expect(dominante.detalle == "La7 · La Do♯ Mi Sol")
        #expect(dominante.sonido.notas.map(\.midi) == [69, 73, 76, 79])
    }

    @Test func unAcordeDeNombrePropioSuenaComoSeEscribeYSeAbreEnAcordes() throws {
        let modelo = ModeloDelCatalogo()
        let mistico = modelo.ficha(de: .mistico, en: espanol)
        #expect(mistico.nombre == "acorde místico")
        // No nombra a su tipo: no lleva cifrado delante de las notas.
        #expect(mistico.detalle == "Do Fa♯ Si♭ Mi La Re")
        #expect(mistico.estilos == "siglo XX")
        #expect(mistico.sonido.notas.map(\.midi) == [60, 66, 70, 76, 81, 86])
        let tipo = try #require(AcordeConNombre.mistico.tipo)
        #expect(mistico.destino == .acordes(Acorde(.do, tipo)))
    }

    @Test func unRitmoSuenaSinLlevarANingunaPestana() {
        let modelo = ModeloDelCatalogo()
        let clave = modelo.ficha(de: .claveDeSon, en: espanol)
        #expect(clave.detalle == "x..x..x...x.x... · 4+4+4+4")
        #expect(clave.estilos == RitmoConNombre.claveDeSon.familia.nombre(en: espanol))
        #expect(clave.sonido == .ritmo(.claveDeSon))
        #expect(clave.destino == nil)
        #expect(!clave.fuentes.isEmpty)
    }
}
