import Armonia
import Exposicion
import Testing

@testable import Interfaz

@Suite struct ModeloDeAcordesTests {
    private let espanol = Notacion.compacta(.espanol)

    @Test func alAbrirLeeElSolSieteSobreSi() throws {
        let modelo = ModeloDeAcordes()
        let acorde = try #require(modelo.acorde)
        #expect(acorde.cifrado(en: espanol) == "Sol7/Si")
    }

    @Test func alCambiarElTextoSeVuelveALeerYElArpegioEmpiezaPorElBajo() {
        var modelo = ModeloDeAcordes()
        modelo.inicio = 2
        modelo.texto = "Lam7"
        #expect(modelo.acorde?.cifrado(en: espanol) == "Lam7")
        #expect(modelo.inicio == 0)
    }

    @Test func elMismoTextoNoReiniciaElArpegio() {
        var modelo = ModeloDeAcordes()
        modelo.inicio = 2
        modelo.texto = "Sol7/Si"
        #expect(modelo.inicio == 2)
    }

    @Test func unTextoQueNoSeLeeDaElErrorYNingunFichero() {
        var modelo = ModeloDeAcordes()
        modelo.texto = "Xq"
        #expect(modelo.acorde == nil)
        #expect(throws: (any Error).self) { try modelo.lectura.get() }
        #expect(modelo.ficheros(digitaciones: nil, en: espanol).isEmpty)
        #expect(modelo.digitaciones().isEmpty)
    }

    @Test func unAcordePedidoSeEscribeEnLaNotacionDeLaApp() throws {
        var modelo = ModeloDeAcordes()
        modelo.mostrar(try Acorde(leyendo: "Fa#m7b5"), en: .compacta(.ingles))
        #expect(modelo.texto == "F♯m7(♭5)")
        #expect(modelo.acorde?.cifrado(en: espanol) == "Fa♯m7(♭5)")
    }

    @Test func laClaveDeLasDigitacionesCambiaConElInstrumentoYElCapo() {
        var modelo = ModeloDeAcordes()
        let antes = modelo.claveDeLasDigitaciones
        modelo.capo = 2
        #expect(modelo.claveDeLasDigitaciones != antes)
        let conCapo = modelo.claveDeLasDigitaciones
        modelo.encordado = .ukelele
        #expect(modelo.claveDeLasDigitaciones != conCapo)
    }

    @Test func losTresillosAcortanLaFigura() {
        var modelo = ModeloDeAcordes()
        modelo.figura = .corchea
        #expect(modelo.duracion == Figura.corchea.duracion)
        modelo.tresillos = true
        #expect(modelo.duracion == Figura.corchea.duracion.grupoIrregular(3, en: 2))
    }

    @Test func losGradosEscritosMandanSobreElPatron() throws {
        var modelo = ModeloDeAcordes(texto: "Do")
        let acorde = try #require(modelo.acorde)
        #expect(modelo.arpegio(de: acorde).grados.isEmpty)
        modelo.grados = "1 5 3 8"
        #expect(!modelo.arpegio(de: acorde).grados.isEmpty)
        modelo.grados = "esto no"
        #expect(modelo.arpegio(de: acorde).grados.isEmpty)
    }

    @Test func elMastilDelArpegioSubeMasConLasFormasCAGED() {
        var modelo = ModeloDeAcordes()
        #expect(modelo.trastesDelArpegio == 12)
        modelo.formas = .caged
        #expect(modelo.trastesDelArpegio == 15)
    }

    @Test func lasDigitacionesSonDelInstrumentoElegido() {
        var modelo = ModeloDeAcordes(texto: "Do")
        let guitarra = modelo.digitaciones()
        #expect(!guitarra.isEmpty)
        #expect(guitarra.count <= 6)
        #expect(guitarra.allSatisfy { $0.trastes.count == 6 })
        modelo.encordado = .ukelele
        #expect(modelo.digitaciones().allSatisfy { $0.trastes.count == 4 })
    }

    @Test func lasTablaturasSeExportanCuandoYaHayDigitaciones() {
        let modelo = ModeloDeAcordes(texto: "Do")
        let sin = modelo.ficheros(digitaciones: nil, en: espanol)
        let con = modelo.ficheros(digitaciones: modelo.digitaciones(), en: espanol)
        #expect(!sin.isEmpty)
        #expect(con.count == sin.count + 1)
    }

    @Test func seComparaConElOtroAcordeSiSeLee() {
        var modelo = ModeloDeAcordes(texto: "Do")
        modelo.otroAcorde = "Lam"
        #expect(modelo.comparacion(en: espanol) != nil)
        modelo.otroAcorde = "Xq"
        #expect(modelo.comparacion(en: espanol) == nil)
    }

    @Test func losNombresDelCatalogoVanConElGenericoPrimero() {
        var modelo = ModeloDeAcordes(texto: "Doadd9")
        #expect(modelo.nombresDelCatalogo(en: espanol) == "novena añadida, acorde mu")
        modelo.texto = "Sol7"
        #expect(modelo.nombresDelCatalogo(en: espanol) == "séptima de dominante")
        modelo.texto = "Do7(b9,#11)"
        #expect(modelo.nombresDelCatalogo(en: espanol) == nil)
        modelo.texto = "Xq"
        #expect(modelo.nombresDelCatalogo(en: espanol) == nil)
    }
}
