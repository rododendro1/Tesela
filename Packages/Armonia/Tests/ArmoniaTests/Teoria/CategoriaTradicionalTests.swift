import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct CategoriaTradicionalTests {
    /// Toda escala de otra tradición tiene tradición y categoría.
    @Test func todasLasTradicionalesTienenClaseYTradicion() {
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.categoria != nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion != nil, Comment(rawValue: tipo.nombre))
        }
    }

    /// Las occidentales y las escalas propias no tienen categoría.
    @Test func lasOccidentalesYLasPropiasNoTienenClase() {
        for tipo in TipoDeEscala.todos {
            #expect(tipo.categoria == nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == nil, Comment(rawValue: tipo.nombre))
        }
        let propia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta])
        #expect(propia.categoria == nil)
        #expect(!propia.esRaga)
    }

    @Test func lasClasesCoincidenConLasListas() {
        #expect(TipoDeEscala.tradicionales(categoria: .melakarta).count == 72)
        #expect(TipoDeEscala.tradicionales(categoria: .thaat).count == TipoDeEscala.thaats.count)
        #expect(TipoDeEscala.tradicionales(categoria: .dromos).count == TipoDeEscala.dromoi.count)
        #expect(TipoDeEscala.tradicionales(categoria: .maqam).count == TipoDeEscala.maqamat.count)
        #expect(TipoDeEscala.tradicionales(categoria: .janya).count == TipoDeEscala.janyas.count)
        #expect(TipoDeEscala.tradicionales(categoria: .raga).count == TipoDeEscala.ragasIndostanicos.count)
        let tetracordos = TipoDeEscala.tradicionales(categoria: .tetracordo)
        let harmoniai = TipoDeEscala.tradicionales(categoria: .harmonia)
        #expect((tetracordos.count + harmoniai.count) == TipoDeEscala.griegasAntiguas.count)
        // Todas las escalas de la India son de una de las cuatro categorías indias.
        let indias = TipoDeEscala.tradicionales(tradicion: .india)
        #expect(indias.allSatisfy { [.thaat, .melakarta, .janya, .raga].contains($0.categoria) })
        #expect(indias.count == TipoDeEscala.tradicionales.filter { $0.tradicion == .india }.count)
    }

    @Test func ragasMelakartasYThaats() {
        #expect(TipoDeEscala.melakarta(15)?.categoria == .melakarta)
        #expect(TipoDeEscala.melakarta(15)?.tradicion == .india)
        #expect(TipoDeEscala.hitzaz.categoria == .dromos)
        #expect(TipoDeEscala.hitzaz.tradicion == .grecia)
        #expect(TipoDeEscala.hiyaz.categoria == .maqam)
        // Un melakarta y un janya son ragas; un thaat, no.
        #expect(TipoDeEscala.melakarta(15)?.esRaga ?? false)
        let janyas = TipoDeEscala.janyas.allSatisfy(\.esRaga)
        let ragas = TipoDeEscala.ragasIndostanicos.allSatisfy(\.esRaga)
        let thaats = TipoDeEscala.thaats.contains(where: \.esRaga)
        #expect(janyas)
        #expect(ragas)
        #expect(!thaats)
        #expect(!TipoDeEscala.hitzaz.esRaga)
    }

    /// Āsāvarī (un thaat) tiene los intervalos de la menor natural, que no tiene categoría: se busca por el nombre.
    @Test func asavariTieneClaseAunqueSeaIgualALaMenorNatural() {
        #expect(TipoDeEscala.asavari == TipoDeEscala.menorNatural)
        #expect(TipoDeEscala.asavari.categoria == .thaat)
        #expect(TipoDeEscala.menorNatural.categoria == nil)
    }

    @Test func losNombresDeLasClasesSeTraducen() {
        let ruso = Notacion.espanolUnicode.conTextos(en: .ruso)
        let griego = Notacion.espanolUnicode.conTextos(en: .griego)
        let frances = Notacion.espanolUnicode.conTextos(en: .frances)
        #expect(CategoriaTradicional.raga.nombre == "raga")
        #expect(CategoriaTradicional.raga.nombre(en: ruso) == "рага")
        #expect(CategoriaTradicional.dromos.nombre(en: griego) == "δρόμος")
        #expect(CategoriaTradicional.escala.nombre(en: frances) == "gamme")
        #expect(CategoriaTradicional.tetracordo.nombre(en: frances) == "tétracorde")
        #expect(CategoriaTradicional.maqam.nombre(en: frances) == "maqam")
        #expect(CategoriaTradicional.raga.nombre(en: Notacion.espanolUnicode.conTextos(en: .aleman)) == "Raga")
        // Cada fichero de idioma da el nombre de todas las categorías.
        for categoria in CategoriaTradicional.allCases {
            for idioma in Idioma.allCases {
                #expect(NombresDeEscalas.de(idioma).nombre(de: categoria) != nil, "\(categoria) \(idioma)")
                #expect(
                    !(categoria.nombre(en: Notacion.espanolUnicode.conTextos(en: idioma)).isEmpty),
                    "\(categoria) \(idioma)")
            }
        }
    }

    /// Una escala propia con el nombre de una tradicional, pero otros intervalos, no es de esa categoría.
    @Test func unaEscalaPropiaConNombreDeTradicionalNoTieneClase() {
        let falsa = TipoDeEscala(nombre: "Kāfī", intervalos: [.unisono, .quintaJusta])
        #expect(falsa.categoria == nil)
        #expect(falsa.tradicion == nil)
        #expect(TipoDeEscala.kafi.categoria == .thaat)
        let igual = TipoDeEscala(nombre: TipoDeEscala.kafi.nombre, intervalos: TipoDeEscala.kafi.intervalos)
        #expect(igual.categoria == .thaat)
    }

    /// El padre de un janya es un melakarta que contiene todas sus notas; Revati no tiene uno único.
    @Test func elPadreDeUnJanyaEsUnMelakartaCompatible() {
        #expect(TipoDeEscala.mohanam.padre?.numeroDeMelakarta == 28)
        #expect(TipoDeEscala.hindolam.padre?.nombre == "Naṭabhairavī")
        #expect(TipoDeEscala.revati.padre == nil)
        for janya in TipoDeEscala.janyas {
            guard let padre = janya.padre, let numero = padre.numeroDeMelakarta else { continue }
            #expect(padre.categoria == .melakarta, Comment(rawValue: janya.nombre))
            #expect(janya.melakartasCompatibles.contains(numero), "\(janya.nombre) ↛ \(numero)")
        }
        #expect(TipoDeEscala.mayor.padre == nil)
        #expect(TipoDeEscala.thaats[0].padre == nil)
    }
}
