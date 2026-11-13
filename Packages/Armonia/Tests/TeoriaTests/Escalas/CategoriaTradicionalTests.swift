import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las categorías de las escalas de otras tradiciones (rāga, mēḷa, maqam…), sus clases y `nombreCompleto`.
@Suite struct CategoriaTradicionalTests {
    /// Toda escala de otra tradición tiene tradición y categoría.
    @Test func todasLasTradicionalesTienenClaseYTradicion() {
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.categoria != nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion != nil && tipo.tradicion != .occidental, Comment(rawValue: tipo.nombre))
        }
    }

    /// Las occidentales y las escalas propias no tienen categoría; las occidentales son de la tradición occidental.
    @Test func lasOccidentalesYLasPropiasNoTienenClase() {
        for tipo in TipoDeEscala.occidentales {
            #expect(tipo.categoria == nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        let propia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta])
        #expect(propia.categoria == nil)
        #expect(!propia.esRaga)
    }

    @Test func lasClasesCoincidenConLasListas() {
        #expect(TipoDeEscala.tradicionales(categoria: .melakarta).count == 72)
        #expect(TipoDeEscala.tradicionales(categoria: .thaat).count == TipoDeEscala.thaats.count)
        #expect(TipoDeEscala.tradicionales(categoria: .dromos).count == TipoDeEscala.dromoi.count)
        let maqamat = TipoDeEscala.tradicionales(categoria: .maqam)
        #expect(maqamat.count == TipoDeEscala.maqamat.count + TipoDeEscala.adwar.count)
        #expect(TipoDeEscala.tradicionales(categoria: .dastgah).count == TipoDeEscala.dastgah.count)
        #expect(TipoDeEscala.tradicionales(categoria: .makam).count == TipoDeEscala.makamlar.count)
        #expect(TipoDeEscala.tradicionales(categoria: .mugam).count == TipoDeEscala.mugamlar.count)
        #expect(TipoDeEscala.tradicionales(tradicion: .turquia) == TipoDeEscala.makamlar + TipoDeEscala.cesniler)
        #expect(TipoDeEscala.tradicionales(categoria: .jins) == TipoDeEscala.ajnas)
        #expect(TipoDeEscala.tradicionales(categoria: .cesni) == TipoDeEscala.cesniler)
        #expect(TipoDeEscala.ajnas.count == 9 && TipoDeEscala.cesniler.count == 12)
        #expect(TipoDeEscala.jinsHijaz.tradicion == .mundoArabe && TipoDeEscala.jinsHijaz.clase == .fragmento)
        #expect((try? TipoDeEscala(leyendo: "jins Hijaz")) == .jinsHijaz)
        #expect((try? TipoDeEscala(leyendo: "Hicaz dörtlüsü"))?.categoria == .cesni)
        #expect(TipoDeEscala.tradicionales(tradicion: .azerbaiyan) == TipoDeEscala.mugamlar)
        #expect(TipoDeEscala.tradicionales(categoria: .janya).count == TipoDeEscala.janyas.count)
        #expect(TipoDeEscala.tradicionales(categoria: .raga).count == TipoDeEscala.ragasIndostanicos.count)
        let tetracordos = TipoDeEscala.tradicionales(categoria: .tetracordo)
        let harmoniai = TipoDeEscala.tradicionales(categoria: .harmonia)
        let nuevas =
            TipoDeEscala.generosDeDidimoYEratostenes + TipoDeEscala.harmoniaiCromaticas
            + TipoDeEscala.harmoniaiEnarmonicas + TipoDeEscala.harmoniaiDeAristides + TipoDeEscala.coloresDeAristoxeno
            + TipoDeEscala.generosDeVicentino
        #expect((tetracordos.count + harmoniai.count) == TipoDeEscala.griegasAntiguas.count + nuevas.count)
        #expect(
            tetracordos
                == TipoDeEscala.tetracordosGriegos + TipoDeEscala.generosDeArquitasYPtolomeo
                + TipoDeEscala.generosDeDidimoYEratostenes + TipoDeEscala.coloresDeAristoxeno
                + TipoDeEscala.generosDeVicentino)
        #expect(
            harmoniai
                == TipoDeEscala.harmoniai + TipoDeEscala.harmoniaiCromaticas + TipoDeEscala.harmoniaiEnarmonicas
                + TipoDeEscala.harmoniaiDeAristides)
        #expect(TipoDeEscala.harmoniai.count == 8 && harmoniai.count == 8 + 6 + 7 + 6)
        #expect(TipoDeEscala.tradicionales(categoria: .hexacordo) == TipoDeEscala.hexacordos)
        #expect(TipoDeEscala.hexacordoBlando.tradicion == .gregoriano)
        #expect(TipoDeEscala.hexacordoBlando.clase == .fragmento)
        #expect((try? TipoDeEscala(leyendo: "hexacordo duro")) == .hexacordoDuro)
        // Las siete afinaciones babilónicas, las equidistantes de África y del sudeste asiático y los doce lü.
        let afinaciones =
            TipoDeEscala.mesopotamicas + TipoDeEscala.africanas + TipoDeEscala.sudesteAsiaticas + [.shierLu]
        #expect(TipoDeEscala.tradicionales(categoria: .afinacion) == afinaciones)
        #expect(TipoDeEscala.tradicionales(tradicion: .africa).map(\.nombre) == TipoDeEscala.africanas.map(\.nombre))
        #expect(TipoDeEscala.africanas.count == 7 && TipoDeEscala.sauta == .lidio)
        #expect(TipoDeEscala.tomoraMesengo.afinacionPropia?.desvios == [0, 30, 25, 0, 0, 30, 25])
        #expect(TipoDeEscala.piphat.tradicion == .sudesteAsiatico && TipoDeEscala.piphat.clase == .afinacion)
        // Los ocho modos gregorianos (y los tres hexacordos), desde su final, enlazados con `ModoGregoriano`.
        #expect(TipoDeEscala.tradicionales(categoria: .modoGregoriano) == TipoDeEscala.modosGregorianos)
        #expect(TipoDeEscala.tradicionales(tradicion: .gregoriano).count == 8 + 3 + 4)
        // Los modos 9 a 12 de Glareano, desde su final.
        #expect(TipoDeEscala.modosDeGlareano.map(\.nombre) == ["aeolius", "hypoaeolius", "ionicus", "hypoionicus"])
        #expect((try? TipoDeEscala(leyendo: "hipojónico"))?.nombre == "hypoionicus")
        #expect(TipoDeEscala.aeolius == .menorNatural && TipoDeEscala.aeolius.categoria == .escala)
        #expect(ModoGregoriano.todos.map(\.tipoDeEscala) == TipoDeEscala.modosGregorianos)
        #expect(ModoGregoriano.todos.allSatisfy { $0.tipoDeEscala.intervalos == $0.maneria.tipo.intervalos })
        #expect((try? TipoDeEscala(leyendo: "hipodórico")) == .protusPlagalis)
        #expect(TipoDeEscala.protusPlagalis.nombre == "protus plagalis" && TipoDeEscala.protusPlagalis.clase == .modo)
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
        #expect(TipoDeEscala.tradicionales(tradicion: .indonesia).count == 11)
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
        let ruso = Notacion.compacta(.espanol).conTextos(en: .ruso)
        let griego = Notacion.compacta(.espanol).conTextos(en: .griego)
        let frances = Notacion.compacta(.espanol).conTextos(en: .frances)
        #expect(CategoriaTradicional.raga.nombre == "rāga")
        #expect(CategoriaTradicional.melakarta.nombre == "mēḷa")
        #expect(CategoriaTradicional.thaat.nombre == "thāṭ")
        #expect(CategoriaTradicional.raga.nombre(en: ruso) == "рага")
        #expect(CategoriaTradicional.dromos.nombre(en: griego) == "δρόμος")
        #expect(CategoriaTradicional.escala.nombre(en: frances) == "gamme")
        #expect(CategoriaTradicional.tetracordo.nombre(en: frances) == "tétracorde")
        #expect(CategoriaTradicional.maqam.nombre(en: frances) == "maqām")
        #expect(CategoriaTradicional.mugam.nombre == "muğam")
        #expect(CategoriaTradicional.dromos.nombre == "drómos" && CategoriaTradicional.echos.nombre == "échos")
        #expect(CategoriaTradicional.mugam.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "mugham")
        #expect(CategoriaTradicional.makam.nombre(en: ruso) == "макам")
        #expect(CategoriaTradicional.raga.nombre(en: Notacion.compacta(.espanol).conTextos(en: .aleman)) == "Rāga")
        #expect(CategoriaTradicional.thaat.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)) == "thāṭ")
        // Cada fichero de idioma da el nombre de todas las categorías.
        for categoria in CategoriaTradicional.allCases {
            for idioma in Idioma.allCases {
                #expect(NombresDeEscalas.de(idioma).nombre(de: categoria) != nil, "\(categoria) \(idioma)")
                #expect(
                    !(categoria.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)).isEmpty),
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

    /// Un padre es siempre una escala madre de la misma tradición, y la escala sale de él: sus notas son las del padre
    /// (los rāgas en su thāṭ, desde la misma tónica) o las de uno de sus modos (las mūrchanā, los pathet). Salvo
    /// Deś, en Khamāj por la tradición aunque sube con una nota que no es del thāṭ.
    @Test func elPadreEsUnaEscalaMadreDeLaQueSale() {
        func clases(_ tipo: TipoDeEscala) -> Set<Int> {
            Set((tipo.intervalos + (tipo.intervalosDescendentes ?? [])).map { $0.semitonos % 12 })
        }
        var conPadre = 0
        for tipo in TipoDeEscala.catalogo {
            guard let padre = tipo.padre else { continue }
            conPadre += 1
            #expect(padre.clase == .escalaMadre, Comment(rawValue: tipo.nombre))
            #expect(padre.tradicion == tipo.tradicion, Comment(rawValue: tipo.nombre))
            #expect(padre.derivadas.contains { $0.esIdentico(a: tipo) }, Comment(rawValue: tipo.nombre))
            // Deś sube con el Ni natural y baja con el komal, y Bhatkhande lo pone en Khamāj, que solo tiene el komal.
            guard !tipo.esIdentico(a: .des) else { continue }
            let suyas = clases(tipo)
            let delPadre = clases(padre)
            let modos = delPadre.map { tonica in Set(delPadre.map { ($0 - tonica + 12) % 12 }) }
            #expect(modos.contains { suyas.isSubset(of: $0) }, "\(tipo.nombre) ↛ \(padre.nombre)")
            if padre.categoria == .thaat { #expect(suyas.isSubset(of: delPadre), "\(tipo.nombre) ↛ \(padre.nombre)") }
        }
        #expect(conPadre == 19 + 13 + 14 + 3)
        #expect(TipoDeEscala.yaman.padre == .kalyan && TipoDeEscala.yaman.padre?.categoria == .thaat)
        #expect(TipoDeEscala.darbariKanada.padre?.nombre == TipoDeEscala.asavari.nombre)
        #expect(TipoDeEscala.candrakauns.padre == nil)
        #expect(TipoDeEscala.sadjaGrama.derivadas.map(\.nombre) == TipoDeEscala.murchanas.prefix(7).map(\.nombre))
        #expect(TipoDeEscala.madhyamaGrama.derivadas.map(\.nombre) == TipoDeEscala.murchanas.suffix(7).map(\.nombre))
        #expect(
            TipoDeEscala.slendro.derivadas.map(\.nombre) == [
                "Sléndro pathet nem", "Sléndro pathet sanga", "Sléndro pathet manyura",
            ])
        #expect(TipoDeEscala.kalyan.derivadas.map(\.nombre) == ["Bhūpālī", "Yaman"])
        #expect(TipoDeEscala.mayor.derivadas.isEmpty)
        // Una escala propia con los intervalos del sléndro no tiene sus pathet.
        #expect(TipoDeEscala(nombre: "mía", intervalos: TipoDeEscala.slendro.intervalos).derivadas.isEmpty)
    }

    /// Las clases: los fragmentos tienen menos de una octava de notas (de tres a seis), las afinaciones son las
    /// babilónicas y las escalas madre, los mēḷa, los thāṭ, los grāma y los laras.
    @Test func clasesDeLasTradicionales() {
        let fragmentos = TipoDeEscala.tradicionales(clase: .fragmento)
        let griegos = TipoDeEscala.tetracordosGriegos + TipoDeEscala.generosDeArquitasYPtolomeo
        #expect(
            fragmentos
                == griegos + TipoDeEscala.ajnas + TipoDeEscala.cesniler + TipoDeEscala.generosDeDidimoYEratostenes
                + TipoDeEscala.hexacordos + TipoDeEscala.coloresDeAristoxeno + TipoDeEscala.generosDeVicentino)
        #expect(fragmentos.allSatisfy { (3...6).contains($0.intervalos.count) })
        let afinaciones = TipoDeEscala.tradicionales(clase: .afinacion)
        #expect(
            afinaciones
                == TipoDeEscala.mesopotamicas + TipoDeEscala.africanas + TipoDeEscala.sudesteAsiaticas + [.shierLu])
        let madres = TipoDeEscala.tradicionales(clase: .escalaMadre)
        let thaatsGramasYLaras = TipoDeEscala.thaats + TipoDeEscala.gramas + TipoDeEscala.indonesias
        #expect(madres.count == 72 + thaatsGramasYLaras.count)
        let modos = TipoDeEscala.tradicionales(clase: .modo)
        #expect(modos.count + madres.count + fragmentos.count + afinaciones.count == TipoDeEscala.tradicionales.count)
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.clase == tipo.categoria?.clase, Comment(rawValue: tipo.nombre))
        }
        // De las occidentales, solo el hexacordo tiene clase: es un fragmento.
        #expect(TipoDeEscala.occidentales.filter { $0.clase != nil }.map(\.nombre) == ["hexacordo"])
    }

    /// `llevaLaCategoria` se deduce del nombre: la palabra puede ir dentro de otra («makamı», «muğamı»,
    /// «ṣaḍja-grāma») o, en los jo coreanos, al final («P'yŏngjo»); los shadd llevan «shadd» en lugar de «maqām».
    /// Así una escala nueva no sale «makam Rast makamı» ni pierde «rāga».
    @Test func llevaLaCategoriaCuandoElNombreLaTiene() throws {
        #expect(TipoDeEscala.tradicionales.filter(\.llevaLaCategoria).count == 71)
        #expect(TipoDeEscala.rastMakami.llevaLaCategoria && TipoDeEscala.rastMakami.nombreCompleto == "Rast makamı")
        #expect(TipoDeEscala.surMugami.llevaLaCategoria)
        #expect(TipoDeEscala.jinsHijaz.llevaLaCategoria)
        #expect(TipoDeEscala.echosProtos.llevaLaCategoria)
        #expect(TipoDeEscala.pelogLima.llevaLaCategoria)
        #expect(!TipoDeEscala.mohanam.llevaLaCategoria && TipoDeEscala.mohanam.nombreCompleto == "rāga Mohanam")
        #expect(!TipoDeEscala.pelogTembung.llevaLaCategoria)
        let shadd = try #require(TipoDeEscala.tradicionales.first { $0.nombre.hasPrefix("shadd") })
        #expect(shadd.llevaLaCategoria && shadd.nombreCompleto == shadd.nombre)
        let jo = try #require(TipoDeEscala.tradicionales.first { $0.categoria == .jo && $0.nombre.hasSuffix("jo") })
        #expect(jo.llevaLaCategoria)
        // Las que no anteponen palabra (tetracordo, escala…) y las occidentales, nunca.
        for tipo in TipoDeEscala.catalogo where tipo.categoria?.palabraDelNombre == nil {
            #expect(!tipo.llevaLaCategoria, Comment(rawValue: tipo.nombre))
        }
    }

    /// En ningún idioma sale la palabra de la categoría dos veces.
    @Test func nombreCompletoSinLaPalabraDosVecesEnNingunIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            for tipo in TipoDeEscala.tradicionales {
                guard let palabra = tipo.categoria?.palabraDelNombre?.nombre(en: notacion) else { continue }
                // Por palabras: «рага» está dentro de «Кедарагаула», y no cuenta.
                let completo = tipo.nombreCompleto(en: notacion)
                let veces = completo.lowercased().split(separator: " ").filter { $0.hasPrefix(palabra.lowercased()) }
                #expect(veces.count <= 1, "\(idioma): \(completo)")
            }
        }
    }

    /// El nombre con la palabra de la categoría: delante si es un préstamo y no la lleva ya.
    @Test func nombreCompleto() {
        #expect(TipoDeEscala.kafi.nombreCompleto == "thāṭ Kāfī")
        #expect(TipoDeEscala.melakarta(15)?.nombreCompleto == "mēḷa Māyāmālavagauḷa")
        #expect(TipoDeEscala.mohanam.nombreCompleto == "rāga Mohanam")
        #expect(TipoDeEscala.hitzaz.nombreCompleto == "drómos Hitzáz")
        #expect(TipoDeEscala.bayati.nombreCompleto == "maqām Bayātī")
        // Los que ya la llevan, delante o detrás.
        #expect(TipoDeEscala.jinsHijaz.nombreCompleto == "jins Ḥijāz")
        #expect(TipoDeEscala.rastMakami.nombreCompleto == "Rast makamı")
        #expect(TipoDeEscala.echosProtos.nombreCompleto == TipoDeEscala.echosProtos.nombre)
        #expect(TipoDeEscala.shaddRast.nombreCompleto == "shadd Rāst")
        #expect(TipoDeEscala.adwar.allSatisfy { $0.nombreCompleto == $0.nombre })
        // Las categorías que se traducen y las occidentales, a secas.
        #expect(TipoDeEscala.tetracordoDiatonico.nombreCompleto == "tetracordo diatónico")
        #expect(TipoDeEscala.georgiana.nombreCompleto == "georgiana")
        #expect(TipoDeEscala.mayor.nombreCompleto == "mayor")
        // Ninguno repite la palabra.
        for tipo in TipoDeEscala.tradicionales {
            let palabras = tipo.nombreCompleto.split(separator: " ")
            #expect(palabras.count < 2 || palabras[0] != palabras[1], Comment(rawValue: tipo.nombreCompleto))
        }
        let ingles = Notacion.compacta(.espanol).conTextos(en: .ingles)
        #expect(TipoDeEscala.mohanam.nombreCompleto(en: ingles) == "rāga Mohanam")
        let griego = Notacion.compacta(.espanol).conTextos(en: .griego)
        #expect(TipoDeEscala.mohanam.nombreCompleto(en: griego).hasPrefix("ράγκα "))
    }
}
