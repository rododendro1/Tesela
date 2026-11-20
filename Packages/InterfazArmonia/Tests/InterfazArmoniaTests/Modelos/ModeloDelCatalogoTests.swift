import Armonia
import ExposicionArmonia
import Testing

@testable import InterfazArmonia

@Suite struct ModeloDelCatalogoTests {
    private let espanol = Notacion.compacta(.espanol)

    @Test func alAbrirEnsenaTodasLasProgresionesSobreDo() throws {
        let modelo = ModeloDelCatalogo()
        let tarjetas = modelo.tarjetas(en: espanol)
        #expect(tarjetas.count == ProgresionConNombre.catalogo.count)
        let perfecta = try #require(tarjetas.first)
        #expect(perfecta.nombre == "cadencia perfecta")
        #expect(perfecta.detalle == "V7 I · Sol7 Do")
        #expect(perfecta.estilos == "clásica · Barroco")
        #expect(perfecta.referencias == ["Aldwell et al. 2011"])
        #expect(perfecta.destino == .analisis("Sol7 Do"))
        #expect(perfecta.sonido == .acordes(ProgresionConNombre.catalogo[0].acordes(sobre: .do)))
    }

    @Test func cadaListaTieneSuTituloYSuCatalogo() {
        var modelo = ModeloDelCatalogo()
        let titulos = ModeloDelCatalogo.Lista.allCases.map { $0.titulo(en: espanol) }
        #expect(titulos == ["Progresiones", "Acordes con nombre", "Ritmos", "Ornamentos", "Instrumentos"])
        #expect(ModeloDelCatalogo.Lista.allCases.filter(\.usaLaTonica) == [.progresiones, .acordes, .ornamentos])
        modelo.lista = .acordes
        #expect(modelo.tarjetas(en: espanol).count == AcordeConNombre.catalogo.count)
        modelo.lista = .ritmos
        #expect(modelo.tarjetas(en: espanol).count == RitmoConNombre.catalogo.count)
        #expect(ModeloDelCatalogo.Lista.ritmos.id == .ritmos)
    }

    @Test func seBuscaEnCualquierIdiomaYSinTildes() {
        var modelo = ModeloDelCatalogo()
        modelo.texto = "andaluza"
        #expect(modelo.tarjetas(en: espanol).map(\.id) == ["cadencia andaluza"])
        modelo.lista = .acordes
        modelo.texto = "TRISTAN"
        #expect(modelo.tarjetas(en: espanol).map(\.id) == ["acorde de Tristán"])
        modelo.lista = .ritmos
        modelo.texto = "son clave"
        #expect(modelo.tarjetas(en: espanol).map(\.id).contains("clave de son"))
        modelo.texto = "zzzz"
        #expect(modelo.tarjetas(en: espanol).isEmpty)
    }

    @Test func laTonicaMueveLasProgresionesYLosAcordes() {
        var modelo = ModeloDelCatalogo()
        modelo.tonica = Nota(.la)
        let andaluza = modelo.tarjeta(de: .andaluza, en: espanol)
        #expect(andaluza.detalle.hasSuffix(" · Lam Sol Fa Mi"))
        #expect(andaluza.destino == .analisis("Lam Sol Fa Mi"))
        let dominante = modelo.tarjeta(de: .dominanteSeptima, en: espanol)
        #expect(dominante.detalle == "La7 · La Do♯ Mi Sol")
        #expect(dominante.sonido.notas.map(\.midi) == [69, 73, 76, 79])
    }

    @Test func unAcordeDeNombrePropioSuenaComoSeEscribeYSeAbreEnAcordes() throws {
        let modelo = ModeloDelCatalogo()
        let mistico = modelo.tarjeta(de: .mistico, en: espanol)
        #expect(mistico.nombre == "acorde místico")
        // No nombra a su tipo: no lleva cifrado delante de las notas.
        #expect(mistico.detalle == "Do Fa♯ Si♭ Mi La Re")
        #expect(mistico.estilos == "de compositor · siglo XX (1910)")
        #expect(mistico.sonido.notas.map(\.midi) == [60, 66, 70, 76, 81, 86])
        let tipo = try #require(AcordeConNombre.mistico.tipo)
        #expect(mistico.destino == .acordes(Acorde(.do, tipo)))
    }

    @Test func unRitmoSuenaSinLlevarANingunaPestana() {
        let modelo = ModeloDelCatalogo()
        let clave = modelo.tarjeta(de: .claveDeSon, en: espanol)
        #expect(clave.detalle == "x..x..x...x.x... · 4+4+4+4")
        #expect(clave.estilos == RitmoConNombre.claveDeSon.familia.nombre(en: espanol))
        #expect(clave.sonido == .ritmo(.claveDeSon))
        #expect(clave.destino == nil)
        #expect(!clave.referencias.isEmpty)
    }

    @Test func losOrnamentosSobreLaTonica() throws {
        var modelo = ModeloDelCatalogo()
        modelo.lista = .ornamentos
        #expect(modelo.tarjetas(en: espanol).count == OrnamentoConNombre.catalogo.count)
        modelo.texto = "grupeto invertido"
        modelo.tonica = .re
        let grupeto = try #require(modelo.tarjetas(en: espanol).first)
        #expect(grupeto.nombre == "grupeto invertido")
        #expect(grupeto.detalle == "−1 0 +1 0 · Do♯₄:16 Re₄:16 Mi₄:16 Re₄:16")
        #expect(!grupeto.referencias.isEmpty && grupeto.destino == nil)
        #expect(grupeto.sonido.notas.map(\.midi) == [61, 62, 64, 62])
        // La apoyatura, con la mitad de la negra.
        modelo.texto = "apoyatura superior"
        let apoyatura = try #require(modelo.tarjetas(en: espanol).first)
        #expect(apoyatura.detalle.hasSuffix("Mi₄:8 Re₄:8"))
    }

    @Test func losInstrumentosConSuFamilia() throws {
        var modelo = ModeloDelCatalogo()
        modelo.lista = .instrumentos
        #expect(modelo.tarjetas(en: espanol).count == Encordado.todos.count)
        modelo.texto = "MANDOLINA"
        let mandolina = try #require(modelo.tarjetas(en: espanol).first)
        #expect(mandolina.detalle == "Sol₃ Re₄ La₄ Mi₅ · 4 órdenes, 8 cuerdas")
        #expect(mandolina.estilos == "laúdes y mandolinas · cromáticos")
        #expect(mandolina.sonido.notas.map(\.midi) == [55, 62, 69, 76] && mandolina.destino == nil)
        // El ukelele suena de grave a agudo, aunque su cuerda de Sol vaya arriba.
        modelo.texto = "ukelele barítono"
        #expect(modelo.tarjetas(en: espanol).map(\.id) == ["ukelele barítono"])
        modelo.texto = "ukulele"
        #expect(modelo.tarjetas(en: .compacta(.ingles)).first?.sonido.notas.map(\.midi) == [60, 64, 67, 69])
    }

    @Test func cadaTarjetaTieneSuHojaDeEstudio() {
        var modelo = ModeloDelCatalogo()
        // Una progresión, sobre la tónica elegida.
        modelo.tonica = .la
        let folia = modelo.ficheros(deLaTarjeta: "folía", en: espanol)
        #expect(folia.map(\.formato) == [.svg, .html])
        #expect(folia.first?.esUnaHojaEnSVG == true)
        #expect(folia.first?.nombreDeFichero.hasPrefix("Hoja de estudio") == true)
        // Un ritmo y un instrumento.
        modelo.lista = .ritmos
        #expect(
            modelo.ficheros(deLaTarjeta: "tresillo", en: espanol).map(\.nombreDeFichero)
                == ["Hoja de estudio tresillo.svg", "Hoja de estudio tresillo.html"])
        modelo.lista = .instrumentos
        #expect(modelo.ficheros(deLaTarjeta: "laúd", en: espanol).count == 2)
        // Un acorde con nombre que se cifra, sobre la tónica; los ornamentos, sin hoja.
        modelo.lista = .acordes
        let conTipo = modelo.tarjetas(en: espanol).first { tarjeta in
            !modelo.ficheros(deLaTarjeta: tarjeta.id, en: espanol).isEmpty
        }
        #expect(conTipo != nil)
        modelo.lista = .ornamentos
        #expect(modelo.tarjetas(en: espanol).allSatisfy { modelo.ficheros(deLaTarjeta: $0.id, en: espanol).isEmpty })
        // Lo que no está en la lista, sin hoja.
        modelo.lista = .ritmos
        #expect(modelo.ficheros(deLaTarjeta: "inventado", en: espanol).isEmpty)
    }
}
