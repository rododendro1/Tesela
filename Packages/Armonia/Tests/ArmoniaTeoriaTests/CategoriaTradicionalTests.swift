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
        #expect(TipoDeEscala.tradicionales(categoria: .dastgah).count == TipoDeEscala.dastgah.count)
        #expect(TipoDeEscala.tradicionales(categoria: .makam).count == TipoDeEscala.makamlar.count)
        #expect(TipoDeEscala.tradicionales(categoria: .mugam).count == TipoDeEscala.mugamlar.count)
        #expect(TipoDeEscala.tradicionales(tradicion: .turquia) == TipoDeEscala.makamlar)
        #expect(TipoDeEscala.tradicionales(tradicion: .azerbaiyan) == TipoDeEscala.mugamlar)
        #expect(TipoDeEscala.tradicionales(categoria: .janya).count == TipoDeEscala.janyas.count)
        #expect(TipoDeEscala.tradicionales(categoria: .raga).count == TipoDeEscala.ragasIndostanicos.count)
        let tetracordos = TipoDeEscala.tradicionales(categoria: .tetracordo)
        let harmoniai = TipoDeEscala.tradicionales(categoria: .harmonia)
        #expect((tetracordos.count + harmoniai.count) == TipoDeEscala.griegasAntiguas.count)
        #expect(tetracordos == TipoDeEscala.tetracordosGriegos + TipoDeEscala.generosDeArquitasYPtolomeo)
        #expect(harmoniai == TipoDeEscala.harmoniai)
        #expect(harmoniai.count == 8)
        // Las siete afinaciones babilónicas.
        #expect(TipoDeEscala.tradicionales(categoria: .afinacion) == TipoDeEscala.mesopotamicas)
        #expect(TipoDeEscala.tradicionales(tradicion: .mesopotamia) == TipoDeEscala.mesopotamicas)
        #expect(TipoDeEscala.mesopotamicas.count == 7)
        #expect(TipoDeEscala.nidQabli.tradicion == .mesopotamia && TipoDeEscala.nidQabli.categoria == .afinacion)
        // Los grāma y las mūrchanā del Nāṭyaśāstra.
        #expect(TipoDeEscala.tradicionales(categoria: .grama) == TipoDeEscala.gramas)
        #expect(TipoDeEscala.tradicionales(categoria: .murchana) == TipoDeEscala.murchanas)
        #expect(TipoDeEscala.murchanas.count == 14 && TipoDeEscala.sauviri.tradicion == .india)
        #expect(!TipoDeEscala.sadjaGrama.esRaga)
        // Los pathet y los laras de Indonesia.
        #expect(TipoDeEscala.tradicionales(categoria: .pathet) == TipoDeEscala.pathets)
        #expect(TipoDeEscala.tradicionales(categoria: .laras) == TipoDeEscala.indonesias)
        #expect(TipoDeEscala.tradicionales(tradicion: .indonesia).count == 10)
        // Todas las escalas de la India son de una de las seis categorías indias.
        let indias = TipoDeEscala.tradicionales(tradicion: .india)
        #expect(indias.allSatisfy { [.thaat, .melakarta, .janya, .raga, .grama, .murchana].contains($0.categoria) })
        #expect(indias.count == TipoDeEscala.tradicionales.filter { $0.tradicion == .india }.count)
    }

    @Test func ragasMelakartasYThaats() {
        #expect(TipoDeEscala.melakarta(15)?.categoria == .melakarta)
        #expect(TipoDeEscala.melakarta(15)?.tradicion == .india)
        #expect(TipoDeEscala.hitzaz.categoria == .dromos)
        #expect(TipoDeEscala.hitzaz.tradicion == .grecia)
        #expect(TipoDeEscala.hiyaz.categoria == .maqam)
        #expect(TipoDeEscala.bayati.categoria == .maqam)
        #expect(TipoDeEscala.sur.tradicion == .persia)
        #expect(TipoDeEscala.rastMakami.categoria == .makam)
        #expect(TipoDeEscala.rastMakami.tradicion == .turquia)
        #expect(TipoDeEscala.surMugami.categoria == .mugam)
        #expect(TipoDeEscala.surMugami.tradicion == .azerbaiyan)
        // Con los mismos intervalos, cada uno conserva su categoría por el nombre.
        #expect(TipoDeEscala.rastMakami == TipoDeEscala.rast)
        #expect(TipoDeEscala.rast.categoria == .dromos)
        #expect(TipoDeEscala.maqamRast.categoria == .maqam)
        // Un mēḷa y un janya son rāgas; un thāṭ, no.
        #expect(TipoDeEscala.melakarta(15)?.esRaga ?? false)
        let janyas = TipoDeEscala.janyas.allSatisfy(\.esRaga)
        let ragas = TipoDeEscala.ragasIndostanicos.allSatisfy(\.esRaga)
        let thaats = TipoDeEscala.thaats.contains(where: \.esRaga)
        #expect(janyas)
        #expect(ragas)
        #expect(!thaats)
        #expect(!TipoDeEscala.hitzaz.esRaga)
    }

    /// Āsāvarī (un thāṭ) tiene los intervalos de la menor natural, que no tiene categoría: se busca por el nombre.
    @Test func asavariTieneClaseAunqueSeaIgualALaMenorNatural() {
        #expect(TipoDeEscala.asavari == TipoDeEscala.menorNatural)
        #expect(TipoDeEscala.asavari.categoria == .thaat)
        #expect(TipoDeEscala.menorNatural.categoria == nil)
    }

    @Test func losNombresDeLasClasesSeTraducen() {
        let ruso = Notacion.espanolCompacto.conTextos(en: .ruso)
        let griego = Notacion.espanolCompacto.conTextos(en: .griego)
        let frances = Notacion.espanolCompacto.conTextos(en: .frances)
        #expect(CategoriaTradicional.raga.nombre == "rāga")
        #expect(CategoriaTradicional.melakarta.nombre == "mēḷa")
        #expect(CategoriaTradicional.thaat.nombre == "thāṭ")
        #expect(CategoriaTradicional.raga.nombre(en: ruso) == "рага")
        #expect(CategoriaTradicional.dromos.nombre(en: griego) == "δρόμος")
        #expect(CategoriaTradicional.escala.nombre(en: frances) == "gamme")
        #expect(CategoriaTradicional.tetracordo.nombre(en: frances) == "tétracorde")
        #expect(CategoriaTradicional.maqam.nombre(en: frances) == "maqam")
        #expect(CategoriaTradicional.mugam.nombre == "mugam")
        #expect(CategoriaTradicional.mugam.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "mugham")
        #expect(CategoriaTradicional.makam.nombre(en: ruso) == "макам")
        #expect(CategoriaTradicional.raga.nombre(en: Notacion.espanolCompacto.conTextos(en: .aleman)) == "Rāga")
        #expect(CategoriaTradicional.thaat.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "thāṭ")
        // Cada fichero de idioma da el nombre de todas las categorías.
        for categoria in CategoriaTradicional.allCases {
            for idioma in Idioma.allCases {
                #expect(NombresDeEscalas.de(idioma).nombre(de: categoria) != nil, "\(categoria) \(idioma)")
                #expect(
                    !(categoria.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma)).isEmpty),
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

    /// El padre de un janya es un mēḷa que contiene todas sus notas; Revati no tiene uno único.
    @Test func elPadreDeUnJanyaEsUnMelakartaCompatible() {
        #expect(TipoDeEscala.mohanam.padre?.numeroDeMelakarta == 28)
        #expect(TipoDeEscala.hindolam.padre?.nombre == "Naṭabhairavī")
        #expect(TipoDeEscala.revati.padre == nil)
        #expect(TipoDeEscala.mohanakalyani.padre?.numeroDeMelakarta == 65)
        #expect(TipoDeEscala.saveri.padre?.numeroDeMelakarta == 15)
        #expect(TipoDeEscala.nata.padre?.numeroDeMelakarta == 36)
        #expect(TipoDeEscala.lalit.categoria == .raga && TipoDeEscala.lalit.padre == nil)
        for janya in TipoDeEscala.janyas {
            guard let padre = janya.padre, let numero = padre.numeroDeMelakarta else { continue }
            #expect(padre.categoria == .melakarta, Comment(rawValue: janya.nombre))
            #expect(janya.melakartasCompatibles.contains(numero), "\(janya.nombre) ↛ \(numero)")
        }
        #expect(TipoDeEscala.mayor.padre == nil)
        #expect(TipoDeEscala.thaats[0].padre == nil)
    }

    /// Las fichas reparten todas las escalas de otras tradiciones, cada una en la suya, y su versión microtonal y su
    /// padre van en la ficha de su tradición.
    @Test func lasFichasRepartenLasTradicionales() {
        var tipos: [TipoDeEscala] = []
        for ficha in FichaDeTradicion.todas {
            for lista in ficha.listas {
                for tipo in lista.tipos {
                    #expect(tipo.tradicion == ficha.tradicion, Comment(rawValue: tipo.nombre))
                    #expect(tipo.categoria == lista.categoria, Comment(rawValue: tipo.nombre))
                }
                tipos += lista.tipos
            }
            for microtonal in ficha.microtonales {
                let nombre = microtonal.temperada.nombre
                #expect(microtonal.temperada.tradicion == ficha.tradicion, Comment(rawValue: nombre))
            }
            for padre in ficha.padres {
                #expect(padre.janya.categoria == .janya, Comment(rawValue: padre.janya.nombre))
                #expect(padre.janya.padre == TipoDeEscala.melakarta(padre.mela), Comment(rawValue: padre.janya.nombre))
            }
        }
        #expect(tipos.count == TipoDeEscala.tradicionales.count)
        #expect(Set(tipos.map(\.nombre)) == Set(TipoDeEscala.tradicionales.map(\.nombre)))
        #expect(FichaDeTradicion.todas.map(\.tradicion) == Tradicion.allCases)
    }
}
