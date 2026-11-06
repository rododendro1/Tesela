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
        #expect((tetracordos.count + harmoniai.count) == TipoDeEscala.griegasAntiguas.count + nuevas.count)
        #expect(
            tetracordos
                == TipoDeEscala.tetracordosGriegos + TipoDeEscala.generosDeArquitasYPtolomeo
                + TipoDeEscala.generosDeDidimoYEratostenes + TipoDeEscala.coloresDeAristoxeno)
        #expect(
            harmoniai
                == TipoDeEscala.harmoniai + TipoDeEscala.harmoniaiCromaticas + TipoDeEscala.harmoniaiEnarmonicas
                + TipoDeEscala.harmoniaiDeAristides)
        #expect(TipoDeEscala.harmoniai.count == 8 && harmoniai.count == 8 + 6 + 7 + 6)
        #expect(TipoDeEscala.tradicionales(categoria: .hexacordo) == TipoDeEscala.hexacordos)
        #expect(TipoDeEscala.hexacordoBlando.tradicion == .gregoriano)
        #expect(TipoDeEscala.hexacordoBlando.clase == .fragmento)
        #expect((try? TipoDeEscala(leyendo: "hexacordo duro")) == .hexacordoDuro)
        // Las siete afinaciones babilónicas y las equidistantes de África y del sudeste asiático.
        let afinaciones = TipoDeEscala.mesopotamicas + TipoDeEscala.africanas + TipoDeEscala.sudesteAsiaticas
        #expect(TipoDeEscala.tradicionales(categoria: .afinacion) == afinaciones)
        #expect(TipoDeEscala.tradicionales(tradicion: .africa).map(\.nombre) == TipoDeEscala.africanas.map(\.nombre))
        #expect(TipoDeEscala.africanas.count == 7 && TipoDeEscala.sauta == .lidio)
        #expect(TipoDeEscala.tomoraMesengo.microtonal?.desvios == [0, 30, 25, 0, 0, 30, 25])
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
        #expect(CategoriaTradicional.maqam.nombre(en: frances) == "maqām")
        #expect(CategoriaTradicional.mugam.nombre == "muğam")
        #expect(CategoriaTradicional.dromos.nombre == "drómos" && CategoriaTradicional.echos.nombre == "échos")
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

    /// Las listas de `listasTradicionales` reparten todas las escalas de otras tradiciones, cada una en la suya, y
    /// cada una dice en su declaración su categoría, su versión microtonal y, los janya, su mēḷa.
    @Test func lasListasRepartenLasTradicionales() {
        var vistas = Set<String>()
        for lista in TipoDeEscala.listasTradicionales {
            for tipo in lista.tipos {
                #expect(vistas.insert(tipo.nombre).inserted, "\(tipo.nombre) está en dos listas")
                #expect(tipo.tradicion == lista.tradicion, Comment(rawValue: tipo.nombre))
                #expect(tipo.ficha.categoria != nil, Comment(rawValue: tipo.nombre))
                #expect(tipo.categoria == tipo.ficha.categoria, Comment(rawValue: tipo.nombre))
                #expect(tipo.ficha.usos.isEmpty, Comment(rawValue: tipo.nombre))
                if let mela = tipo.ficha.mela {
                    #expect(tipo.categoria == .janya, Comment(rawValue: tipo.nombre))
                    #expect(tipo.padre == TipoDeEscala.melakarta(mela), Comment(rawValue: tipo.nombre))
                }
            }
        }
        #expect(vistas.count == TipoDeEscala.tradicionales.count)
        // Cada tradición tiene al menos una lista.
        #expect(Set(TipoDeEscala.listasTradicionales.map(\.tradicion)) == Set(Tradicion.allCases))
        // Las occidentales no tienen categoría ni tradición.
        for tipo in TipoDeEscala.todos {
            #expect(tipo.ficha.categoria == nil && tipo.ficha.mela == nil, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == nil, Comment(rawValue: tipo.nombre))
        }
    }

    /// Las clases: los fragmentos tienen menos de una octava de notas (de tres a seis), las afinaciones son las
    /// babilónicas y las escalas madre, los mēḷa, los thāṭ, los grāma y los laras.
    @Test func clasesDeLasTradicionales() {
        let fragmentos = TipoDeEscala.tradicionales(clase: .fragmento)
        let griegos = TipoDeEscala.tetracordosGriegos + TipoDeEscala.generosDeArquitasYPtolomeo
        #expect(
            fragmentos
                == griegos + TipoDeEscala.ajnas + TipoDeEscala.cesniler + TipoDeEscala.generosDeDidimoYEratostenes
                + TipoDeEscala.hexacordos + TipoDeEscala.coloresDeAristoxeno)
        #expect(fragmentos.allSatisfy { (3...6).contains($0.intervalos.count) })
        let afinaciones = TipoDeEscala.tradicionales(clase: .afinacion)
        #expect(afinaciones == TipoDeEscala.mesopotamicas + TipoDeEscala.africanas + TipoDeEscala.sudesteAsiaticas)
        let madres = TipoDeEscala.tradicionales(clase: .escalaMadre)
        let thaatsGramasYLaras = TipoDeEscala.thaats + TipoDeEscala.gramas + TipoDeEscala.indonesias
        #expect(madres.count == 72 + thaatsGramasYLaras.count)
        let modos = TipoDeEscala.tradicionales(clase: .modo)
        #expect(modos.count + madres.count + fragmentos.count + afinaciones.count == TipoDeEscala.tradicionales.count)
        for tipo in TipoDeEscala.tradicionales {
            #expect(tipo.clase == tipo.categoria?.clase, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.todos.allSatisfy { $0.clase == nil })
    }

    /// El catálogo son las occidentales y después las de otras tradiciones, y su orden decide quién gana.
    @Test func catalogoConPrioridad() {
        let todas = TipoDeEscala.todos + TipoDeEscala.tradicionales
        #expect(TipoDeEscala.catalogo.map(\.nombre) == todas.map(\.nombre))
        #expect(TipoDeEscala.propio(TipoDeEscala.bilaval.intervalos).nombre == "mayor")
        #expect(TipoDeEscala.propio(TipoDeEscala.hiyaz.intervalos).nombre == TipoDeEscala.frigioDominante.nombre)
        #expect((try? TipoDeEscala(leyendo: "Hijaz"))?.nombre == TipoDeEscala.hiyaz.nombre)
        #expect(TipoDeEscala.bilaval.equivalentes.first?.nombre == "mayor")
    }

    /// Cada tradición tiene nombre en los quince idiomas, y en español es también su `nombre`.
    @Test func losNombresDeLasTradicionesSeTraducen() {
        for tradicion in Tradicion.allCases {
            #expect(tradicion.nombre(en: .espanolCompacto) == tradicion.nombre)
            for idioma in Idioma.allCases {
                #expect(
                    !tradicion.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma)).isEmpty,
                    Comment(rawValue: "\(tradicion) en \(idioma)"))
            }
        }
        #expect(Tradicion.japon.nombre(en: Notacion.espanolCompacto.conTextos(en: .euskera)) == "Japonia")
        #expect(Tradicion.mundoArabe.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Arab world")
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
        let ingles = Notacion.espanolCompacto.conTextos(en: .ingles)
        #expect(TipoDeEscala.mohanam.nombreCompleto(en: ingles) == "rāga Mohanam")
        let griego = Notacion.espanolCompacto.conTextos(en: .griego)
        #expect(TipoDeEscala.mohanam.nombreCompleto(en: griego).hasPrefix("ράγκα "))
    }

    /// Los colores de Aristóxeno, en doceavos de tono, y los adwār de Ṣafī al-Dīn, pitagóricos.
    @Test func aristoxenoYSafiAlDin() throws {
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.tradicion == .greciaAntigua })
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.categoria == .tetracordo })
        #expect(TipoDeEscala.tetracordoCromaticoBlandoDeAristoxeno.microtonal?.desvios == [0, -33, 33, 0])
        #expect(TipoDeEscala.tetracordoCromaticoHemiolico.microtonal?.desvios == [0, -25, -50, 0])
        #expect(try TipoDeEscala(leyendo: "cromático tónico") == .tetracordoCromatico)
        #expect(TipoDeEscala.adwar.allSatisfy { $0.tradicion == .mundoArabe && $0.categoria == .maqam })
        #expect(TipoDeEscala.shaddNawa == .menorNatural)
        #expect(TipoDeEscala.shaddRast.microtonal?.desvios == [0, 4, -16, -2, 2, -18, -4])
        #expect((try? TipoDeEscala(leyendo: "Rast de Safi al-Din"))?.nombre == "shadd Rāst")
    }

    /// El folklore europeo: tres escalas populares, dos instrumentos de afinación natural y el canto georgiano, con
    /// sus cents.
    @Test func elFolkloreEuropeo() throws {
        #expect(TipoDeEscala.tradicionales(tradicion: .europa) == TipoDeEscala.europeas)
        #expect(TipoDeEscala.europeas.allSatisfy { $0.categoria == .escala })
        #expect(TipoDeEscala.doricoUcraniano == .doricoCuartaAumentada)
        #expect(TipoDeEscala.podhalanska == .lidioDominante)
        #expect(TipoDeEscala.pentatonicaHungara == .pentatonicaMenor)
        #expect(TipoDeEscala.gaitaEscocesa == .mixolidio)
        // El nombre gana al alias: «dórico ucraniano» es ya la escala europea, igual que el dórico ♯4.
        let ucraniano = try TipoDeEscala(leyendo: "dórico ucraniano")
        #expect(ucraniano.nombre == "dórico ucraniano" && ucraniano.tradicion == .europa)
        #expect((try? TipoDeEscala(leyendo: "Podhale"))?.nombre == "podhalańska")
        #expect((try? TipoDeEscala(leyendo: "Alphorn"))?.nombre == "cuerno alpino")
        let alpino = Escala("Do cuerno alpino").notas.map(\.nombre)
        #expect(alpino == ["Do", "Re", "Mi", "Fa♯", "Sol", "La♭", "Si♭", "Si"])
        // El 11.º armónico, 49 cents bajo Fa♯; la 7ª natural de la gaita, 31 bajo Si♭.
        #expect(TipoDeEscala.cuernoAlpino.microtonal?.desvios[3] == -49)
        #expect(TipoDeEscala.gaitaEscocesa.microtonal?.desvios[6] == -31)
        #expect(TipoDeEscala.mixolidio.microtonal == nil)
        // El canto georgiano: la segunda, 37 cents baja; la tercera, neutra, 32 sobre Mi♭.
        #expect(TipoDeEscala.georgiana == .dorico)
        #expect(TipoDeEscala.georgiana.microtonal?.desvios == [0, -37, 32, 9, -7, -32, 18])
        #expect((try? TipoDeEscala(leyendo: "Svaneti"))?.nombre == "georgiana")
        #expect(TipoDeEscala.georgiana.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Georgian")
        #expect(Tradicion.europa.nombre == "Folklore europeo")
        #expect(Tradicion.europa.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "European folk")
    }

    /// Los nombres de la menor de los conservatorios españoles: bachiana, dórica y antigua.
    @Test func losNombresDeConservatorioDeLaMenor() {
        #expect((try? TipoDeEscala(leyendo: "menor bachiana"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "bachiana"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "de Bach"))?.nombre == "menor melódica de jazz")
        #expect((try? TipoDeEscala(leyendo: "menor dórica"))?.nombre == "dórico")
        #expect((try? TipoDeEscala(leyendo: "menor antigua"))?.nombre == "menor natural")
        #expect(Escala("La bachiana").tipo == .menorMelodicaJazz)
    }

    /// Vietnam, Brasil y el arpa birmana.
    @Test func vietnamBrasilYMyanmar() {
        #expect(TipoDeEscala.tradicionales(tradicion: .vietnam).map(\.nombre) == ["Bắc", "Vọng cổ"])
        #expect(TipoDeEscala.bac.microtonal?.cents == [0, 189, 501, 698, 891])
        #expect((try? TipoDeEscala(leyendo: "hoi oan"))?.nombre == "Vọng cổ")
        #expect(TipoDeEscala.tradicionales(tradicion: .brasil).count == 3)
        #expect(TipoDeEscala.lidioNordestino == .lidioDominante)
        #expect((try? TipoDeEscala(leyendo: "nordestina"))?.nombre == "lidio dominante")
        #expect(TipoDeEscala.saung.tradicion == .sudesteAsiatico && TipoDeEscala.saung.clase == .afinacion)
        #expect(TipoDeEscala.saung.microtonal?.desvios == [0, -18, -36, -9, -27])
        #expect(Tradicion.vietnam.nombre(en: Notacion.espanolCompacto.conTextos(en: .portugues)) == "Vietname")
        #expect(Tradicion.brasil.nombre(en: Notacion.espanolCompacto.conTextos(en: .ingles)) == "Brazil")
    }
}
