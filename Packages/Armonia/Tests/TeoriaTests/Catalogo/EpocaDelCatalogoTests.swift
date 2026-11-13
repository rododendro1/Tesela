import Testing

@testable import Elementos
@testable import Teoria

// La época de los acordes y las progresiones del catálogo, con la misma regla que las escalas.
@Suite struct EpocaDelCatalogoTests {
    /// La obra que documenta un acorde le da su año y su época, y va entre sus referencias.
    @Test func losAcordesDeNombrePropio() {
        #expect(AcordeConNombre.tristan.anioDeOrigen == 1859)
        #expect(AcordeConNombre.tristan.epocaDeOrigen == .romanticismo)
        #expect(AcordeConNombre.tristan.referencias.first == .wagner1859)
        #expect(AcordeConNombre.tristan.epocasDeUso.isEmpty) // la clásica no se usa después del Romanticismo
        #expect(AcordeConNombre.mistico.epocaDeOrigen == .sigloXX)
        #expect(AcordeConNombre.augures.anioDeOrigen == 1913)
        #expect(AcordeConNombre.salmos.referencias == [.stravinski1930])
        // Sin obra, la de su estilo: el So What, del jazz, del siglo XX y usado también en el XXI.
        #expect(AcordeConNombre.soWhat.anioDeOrigen == nil)
        #expect(AcordeConNombre.soWhat.epocaDeOrigen == .sigloXX)
        #expect(AcordeConNombre.soWhat.epocasDeUso == [.sigloXXI])
        #expect(AcordeConNombre.soWhat.epocas == [.sigloXX, .sigloXXI])
    }

    /// Los genéricos, por sus estilos: los de la música clásica nacen en el Barroco y se usan en las tres tonales.
    @Test func losGenericos() {
        #expect(AcordeConNombre.sextaAumentadaAlemana.epocaDeOrigen == .barroco)
        #expect(AcordeConNombre.sextaAumentadaAlemana.epocasDeUso == [.clasicismo, .romanticismo])
        let propio = AcordeConNombre(nombre: "mío", intervalos: [.unisono, .segundaMenor])
        #expect(propio.epocaDeOrigen == nil && propio.epocas.isEmpty)
        let fechado = AcordeConNombre(
            nombre: "fechado", intervalos: [.unisono, .terceraMayor], estilos: [.jazz], documentada: .wagner1859)
        #expect(fechado.epocaDeOrigen == .romanticismo && fechado.epocasDeUso == [.sigloXX, .sigloXXI])
    }

    /// Las progresiones: el monte, por Riepel; la folía y los passamezzi, por Ortiz; las de jazz, del siglo XX.
    @Test func lasProgresiones() throws {
        #expect(
            ProgresionConNombre.monte.anioDeOrigen == 1755 && ProgresionConNombre.monte.epocaDeOrigen == .clasicismo)
        #expect(ProgresionConNombre.monte.epocasDeUso == [.romanticismo])
        #expect(ProgresionConNombre.folia.epocaDeOrigen == .renacimiento)
        #expect(ProgresionConNombre.folia.epocasDeUso == Epoca.tonales)
        #expect(ProgresionConNombre.passamezzoAntico.documentada == .ortiz1553)
        #expect(ProgresionConNombre.iiVI.epocaDeOrigen == .sigloXX)
        #expect(ProgresionConNombre.cadenciaPerfecta.epocaDeOrigen == .barroco)
        let propia = try ProgresionConNombre(nombre: "mía", leyendo: "I IV I", documentada: .riepel1755)
        #expect(propia.epocaDeOrigen == .clasicismo && propia.referencias == [.riepel1755])
    }

    /// Todos los del catálogo con estilo de época tienen la suya, y las de uso van después de la de origen.
    @Test func todoElCatalogo() {
        for acorde in AcordeConNombre.catalogo where acorde.estilos.contains(where: { !$0.epocasDeUso.isEmpty }) {
            #expect(acorde.epocaDeOrigen != nil, Comment(rawValue: acorde.nombre))
            if let origen = acorde.epocaDeOrigen { #expect(acorde.epocasDeUso.allSatisfy { origen < $0 }) }
        }
        for progresion in ProgresionConNombre.catalogo {
            #expect(progresion.epocaDeOrigen != nil, Comment(rawValue: progresion.nombre))
            if let origen = progresion.epocaDeOrigen { #expect(progresion.epocasDeUso.allSatisfy { origen < $0 }) }
        }
    }
}
