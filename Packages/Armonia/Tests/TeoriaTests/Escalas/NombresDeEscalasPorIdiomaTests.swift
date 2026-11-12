import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Los ficheros por idioma de `Escalas/Nombres/`.
@Suite struct NombresDeEscalasPorIdiomaTests {
    @Test func todosLosIdiomasCubrenElCatalogoOccidental() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.occidentales {
                #expect(nombres.porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    @Test func elNombreDeCadaTipoSeLeeEnSuIdioma() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.occidentales {
                guard let entrada = nombres.porTipo[tipo] else { continue }
                #expect(nombres.indice[TipoDeEscala.normalizar(entrada.nombre)] != nil, "\(idioma): \(entrada.nombre)")
                for alias in entrada.alias + entrada.variantes {
                    #expect(nombres.indice[TipoDeEscala.normalizar(alias)] != nil, "\(idioma): \(alias)")
                }
            }
        }
    }

    @Test func nombreEnUsaElFicheroDeCadaIdioma() {
        for idioma in Idioma.allCases where idioma != .espanol {
            let notacion = Notacion.compacta(.espanol).conTextos(en: idioma)
            for tipo in TipoDeEscala.occidentales {
                #expect(
                    tipo.nombre(en: notacion) == NombresDeEscalas.de(idioma).porTipo[tipo]?.nombre,
                    "\(idioma): \(tipo.nombre)")
            }
        }
        // Un tipo propio, con los intervalos de uno del catálogo, conserva su nombre en español.
        let propio = TipoDeEscala(nombre: "mi modo", intervalos: TipoDeEscala.dorico.intervalos)
        #expect(propio.nombre(en: .compacta(.espanol)) == "mi modo")
    }

    /// Una escala de otra tradición sin fila en un idioma hereda sus alias y sus variantes, menos los que están en
    /// español: «Hicaz» y «बिलावल» se leen también en alemán, «modo gregoriano 1» no.
    @Test func lasTradicionalesSinFilaHeredanSusAlias() throws {
        let aleman = NombresDeEscalas.de(.aleman)
        let hitzaz = try #require(aleman.tradicionales[TipoDeEscala.hitzaz.identidad])
        #expect(hitzaz.nombre == "Hitzáz" && hitzaz.variantes.contains("Hicaz"))
        #expect(aleman.tradicionales[TipoDeEscala.yaman.identidad]?.alias == ["Yaman Kalyāṇ"])
        #expect(TipoDeEscala.buscar(nombre: "Hicaz", conTonicaEn: .conPalabras(.aleman)) != nil)
        #expect(TipoDeEscala.buscar(nombre: "बिलावल", conTonicaEn: .conPalabras(.sueco)) != nil)
        let protus = try #require(aleman.tradicionales[TipoDeEscala.protusAuthenticus.identidad])
        #expect(!protus.alias.contains("modo gregoriano 1"))
        #expect(TipoDeEscala.buscar(nombre: "modo gregoriano 1", conTonicaEn: .conPalabras(.aleman)) == nil)
        // La lista de los que no se heredan no tiene ninguno que no esté en el catálogo.
        let todos = Set(TipoDeEscala.tradicionales.flatMap { $0.alias + $0.variantes })
        #expect(NombresDeEscalas.aliasEnEspanol.subtracting(todos).isEmpty)
    }

    /// Cada alias o variante se lee como su tipo: ninguno es el nombre de otro tipo ni el alias de otro de su idioma.
    @Test func cadaAliasSeLeeComoSuTipo() {
        let sinAlias: Set<Idioma> = [.espanol, .ruso, .griego]
        for idioma in Idioma.allCases where !sinAlias.contains(idioma) {
            let nombres = NombresDeEscalas.de(idioma)
            for (tipo, entrada) in nombres.porTipo {
                for alias in entrada.alias + entrada.variantes {
                    #expect(
                        nombres.indice[TipoDeEscala.normalizar(alias)] == tipo,
                        "\(idioma): \(alias) (\(entrada.nombre))")
                }
            }
        }
    }

    /// Lo mismo en las escalas de otras tradiciones, también en español: un alias o una variante que es el nombre de
    /// otra escala no se lee nunca como la suya («Yaman» es una escala; «Kalyāṇ» no puede llamarse así).
    @Test func cadaAliasDeLasTradicionalesSeLeeComoSuEscala() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.tradicionales {
                guard let entrada = nombres.tradicionales[tipo.identidad] else { continue }
                for alias in [entrada.nombre] + entrada.alias + entrada.variantes {
                    let leido = nombres.indice[TipoDeEscala.normalizar(alias)]
                    #expect(
                        leido?.esIdentico(a: tipo) == true,
                        "\(idioma): \(alias) (\(entrada.nombre)) se lee \(leido?.nombre ?? "-")")
                }
            }
        }
    }

    /// Los idiomas con alias los tienen en todas las familias de tipos más comunes: los modos con otro nombre
    /// («jónico», «eólico») y los modos con alteraciones.
    @Test func losModosTienenSusSinonimosEnTodosLosIdiomas() {
        for idioma in Idioma.allCases where idioma != .espanol {
            let nombres = NombresDeEscalas.de(idioma)
            #expect(!(nombres.porTipo[.mayor]?.alias.isEmpty ?? true), "\(idioma): mayor")
            #expect(!(nombres.porTipo[.menorNatural]?.alias.isEmpty ?? true), "\(idioma): menor natural")
        }
    }

    /// Un tipo con alias en español tiene alias o variantes en los idiomas románicos («menor dórica» es en catalán
    /// solo «dòrica»). Euskera, alemán, ruso y griego tienen menos: algunos alias no se traducen bien a su gramática.
    @Test func losTiposConAliasEnEspanolLosTienenEnLosIdiomasRomanicos() {
        let romanicos: [Idioma] = [.catalan, .gallego, .portugues, .frances, .italiano]
        for tipo in TipoDeEscala.occidentales where !tipo.alias.isEmpty {
            for idioma in romanicos {
                let entrada = NombresDeEscalas.de(idioma).porTipo[tipo]
                let otros = (entrada?.alias ?? []) + (entrada?.variantes ?? [])
                #expect(!otros.isEmpty, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// El español tiene los alias y las variantes del catálogo en el registro.
    @Test func elEspanolTieneLosAliasDelCatalogo() {
        for tipo in TipoDeEscala.occidentales {
            let entrada = NombresDeEscalas.de(.espanol).porTipo[tipo]
            #expect(entrada?.alias == tipo.alias, Comment(rawValue: tipo.nombre))
            #expect(entrada?.variantes == tipo.variantes, Comment(rawValue: tipo.nombre))
        }
    }

    // MARK: Escalas de otras tradiciones

    @Test func todosLosIdiomasTienenLasEscalasDeOtrasTradiciones() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.tradicionales {
                #expect(nombres.tradicionales[tipo.identidad] != nil, "\(idioma): \(tipo.nombre)")
                #expect(nombres.nombre(de: tipo) != nil, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// Los nombres propios se escriben igual en todos los idiomas; solo cambian los que se traducen.
    @Test func soloSeTraducenLosNombresDescriptivosDeLasTradicionales() {
        var traducidos: Set<String> = [
            "pentatónica andina", "tritónica andina", "tetracordo diatónico", "tetracordo cromático", "harmonía doria",
            "harmonía doria cromática", "harmonía frigia", "harmonía lidia", "tetracordo enarmónico",
            "harmonía mixolidia", "harmonía hipolidia", "harmonía hipofrigia", "harmonía hipodoria",
            "Təzəta mayor", "Təzəta menor", "Bati mayor", "Bati menor",
            "tetracordo cromático de Arquitas", "tetracordo diatónico de Arquitas", "tetracordo enarmónico de Ptolomeo",
            "tetracordo cromático blando", "tetracordo cromático tenso", "tetracordo diatónico blando",
            "tetracordo diatónico ditónico", "tetracordo diatónico tenso", "tetracordo diatónico igual",
            "tetracordo enarmónico de Arquitas", "tetracordo cromático de Dídimo", "tetracordo diatónico de Dídimo",
            "tetracordo enarmónico de Dídimo", "tetracordo cromático de Eratóstenes",
            "tetracordo enarmónico de Eratóstenes", "dórico ucraniano", "pentatónica húngara", "cuerno alpino",
            "gaita escocesa", "georgiana", "tetracordo cromático blando de Aristóxeno",
            "tetracordo cromático hemiólico", "tetracordo diatónico blando de Aristóxeno", "dórico con ficta",
            "mixolidio con ficta", "lidio con si bemol", "tetracordo diatónico de Vicentino",
            "tetracordo cromático de Vicentino", "tetracordo enarmónico de Vicentino", "dórico nordestino",
            "lídio nordestino", "mixolídio nordestino",
        ]
        let especies = ["mixolidia", "lidia", "frigia", "doria", "hipolidia", "hipofrigia", "hipodoria"]
        traducidos.formUnion(especies.filter { $0 != "doria" }.map { "harmonía \($0) cromática" })
        traducidos.formUnion(especies.map { "harmonía \($0) enarmónica" })
        let deAristides = ["lidia", "doria", "frigia", "iastia", "mixolidia", "sintonolidia"]
        traducidos.formUnion(deAristides.map { "harmonía \($0) de Arístides" })
        for idioma in Idioma.allCases {
            let notacion = Notacion.compacta(.espanol).conTextos(en: idioma)
            // El ruso y el griego, que usan otro alfabeto, transcriben también los nombres propios.
            if idioma == .ruso || idioma == .griego { continue }
            for tipo in TipoDeEscala.tradicionales where !traducidos.contains(tipo.nombre) {
                #expect(tipo.nombre(en: notacion) == tipo.nombre, "\(idioma): \(tipo.nombre)")
            }
        }
        let catalan = Notacion.compacta(.espanol).conTextos(en: .catalan)
        #expect(TipoDeEscala.andina.nombre(en: catalan) == "pentatònica andina")
        #expect(TipoDeEscala.tetracordoCromatico.nombre(en: catalan) == "tetracord cromàtic")
        #expect(
            TipoDeEscala.tezetaMenor.nombre(en: Notacion.compacta(.espanol).conTextos(en: .frances)) == "Təzəta mineur")
        #expect(TipoDeEscala.andina.nombre(en: .compacta(.espanol)) == "pentatónica andina")
    }

    /// En ruso y griego los nombres propios van en su alfabeto (salvo los 72 mēḷa, que siguen en IAST) y
    /// se leen de vuelta; el nombre original, en latino, sigue valiendo.
    @Test func rusoYGriegoTranscribenLosNombresPropiosDeLasTradicionales() {
        for (idioma, ejemplo, original) in [
            (Idioma.ruso, "Хиджаз", "Ḥijāz"), (.ruso, "Бхайрав", "Bhairav"),
            (.griego, "Ραστ", "Rast"), (.griego, "Μπιλαβάλ", "Bilāval"),
        ] {
            let notacion = Notacion.compacta(.espanol).conTextos(en: idioma)
            let tipo = (try? TipoDeEscala(leyendo: original))
            #expect(tipo?.nombre(en: notacion) == ejemplo, "\(idioma)")
            #expect(NombresDeEscalas.de(idioma).indice[TipoDeEscala.normalizar(ejemplo)] == tipo, "\(idioma)")
        }
        for idioma in [Idioma.ruso, .griego] {
            let notacion = Notacion.compacta(.espanol).conTextos(en: idioma)
            for tipo in TipoDeEscala.melakartas { #expect(tipo.nombre(en: notacion) == tipo.nombre, "\(idioma)") }
        }
        let notacion = Notacion.compacta(.espanol).conTextos(en: .griego)
        #expect((try? TipoDeEscala(leyendo: "Hitzáz"))?.nombre(en: notacion) == "Χιτζάζ")
    }

    /// Āsāvarī es la escala menor natural por sus intervalos (`TipoDeEscala` se compara por ellos): por eso las
    /// tradicionales se buscan por su nombre y no por el tipo. En ruso y griego va transcrito (Асавари, Ασαβαρί).
    @Test func unaEscalaTradicionalIgualAUnaOccidentalConservaSuNombre() {
        #expect(TipoDeEscala.asavari == TipoDeEscala.menorNatural)
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            if idioma != .ruso && idioma != .griego {
                #expect(nombres.nombre(de: .asavari) == TipoDeEscala.asavari.nombre, "\(idioma)")
            }
            #expect(nombres.nombre(de: .asavari) != nombres.nombre(de: .menorNatural), "\(idioma)")
        }
    }

    /// Un nombre traducido de una tradicional se lee en su idioma (el alemán, con la tónica en alemán).
    @Test func losNombresTraducidosDeLasTradicionalesSeLeen() {
        #expect(Escala("Fis andine Pentatonik").tipo.nombre == "pentatónica andina")
        #expect(Escala("do tetracord cromàtic").tipo.nombre == "tetracordo cromático")
        #expect(Escala("E enharmonic tetrachord").tipo.nombre == "tetracordo enarmónico")
        #expect(Escala("Si harmonie mixolydienne").tipo.nombre == "harmonía mixolidia")
    }

    // MARK: Alias escritos y alias normalizados

    /// `alias` y `variantes` guardan solo grafías correctas; las simplificadas (sin diacríticos, `#`/`b`) las da
    /// `aliasNormalizados`: ni «dorico» ni «dórico b5» junto a «dórico ♭5».
    @Test func losAliasGuardadosNoSonSoloFormasNormalizadas() {
        for tipo in TipoDeEscala.occidentales + TipoDeEscala.tradicionales {
            let escritas = [tipo.nombre] + tipo.alias + tipo.variantes
            for alias in tipo.alias + tipo.variantes {
                let conAlteracionesASCII = alias.replacing("♯", with: "#").replacing("♭", with: "b")
                let redundante = escritas.contains {
                    guard $0 != alias, TipoDeEscala.normalizar($0) == TipoDeEscala.normalizar(alias) else {
                        return false
                    }
                    if alias.unicodeScalars.allSatisfy(\.isASCII) {
                        return !$0.unicodeScalars.allSatisfy(\.isASCII) || $0 == tipo.nombre
                    }
                    // Solo cambia ♯ y ♭ por # y b.
                    return $0.replacing("♯", with: "#").replacing("♭", with: "b") == conAlteracionesASCII
                }
                #expect(!redundante, "\(tipo.nombre): «\(alias)» se deduce de otra grafía")
            }
        }
    }

    /// Las formas normalizadas encuentran el tipo, escritas como se escriban.
    @Test func lasFormasNormalizadasLeenElMismoTipo() {
        for tipo in TipoDeEscala.occidentales {
            for clave in tipo.aliasNormalizados {
                #expect(
                    TipoDeEscala.buscar(nombre: clave, aceptarIngles: false)?.intervalos == tipo.intervalos,
                    Comment(rawValue: clave))
            }
        }
        #expect((try? TipoDeEscala(leyendo: "dorico b2")) == (try? TipoDeEscala(leyendo: "dórico ♭2")))
        #expect((try? TipoDeEscala(leyendo: "jonico sin 4")) == TipoDeEscala.jonicoSinCuarta)
        #expect((try? TipoDeEscala(leyendo: "doble armonica")) == TipoDeEscala.dobleArmonica)
        #expect((try? TipoDeEscala(leyendo: "Hanumatodi"))?.nombre == "Hanumattoḍī")
    }

    @Test func aliasNormalizadosNoTienenRepetidos() {
        let t = TipoDeEscala(
            nombre: "Dórico", intervalos: [.unisono, .terceraMenor], alias: ["dórico", "Dorico", "Jónico"],
            variantes: ["Jonico", "dórica"])
        #expect(t.aliasNormalizados == ["dorico", "jonico", "dorica"])
    }

    // MARK: Alias y variantes

    /// Un alias es otro nombre de la escala; otra forma de escribir un nombre que ya está (el femenino de un modo)
    /// va en `variantes`.
    @Test func ningunAliasEsSoloOtroGeneroDeUnNombreAnterior() {
        func sinGenero(_ texto: String) -> String {
            var palabras: [String] = []
            for palabra in TipoDeEscala.normalizar(texto).split(separator: " ") {
                let fin = ["os", "as", "o", "a"].first { palabra.count > $0.count + 2 && palabra.hasSuffix($0) }
                palabras.append(String(palabra.dropLast(fin?.count ?? 0)))
            }
            return palabras.joined(separator: " ")
        }
        for tipo in TipoDeEscala.catalogo {
            var anteriores = [sinGenero(tipo.nombre)]
            for alias in tipo.alias {
                #expect(!anteriores.contains(sinGenero(alias)), "\(tipo.nombre): «\(alias)» es una variante")
                anteriores.append(sinGenero(alias))
            }
        }
    }

    /// Las variantes se leen como los alias, pero no son otro nombre.
    @Test func lasVariantesSeLeenComoLosAlias() throws {
        #expect(TipoDeEscala.dorico.alias == ["menor dórica"])
        #expect(TipoDeEscala.dorico.variantes == ["dórica"])
        #expect(TipoDeEscala.hitzaz.alias.isEmpty)
        #expect(TipoDeEscala.hitzaz.variantes == ["Hicaz", "Χιτζάζ"])
        #expect(try TipoDeEscala(leyendo: "dórica") == .dorico)
        #expect(try TipoDeEscala(leyendo: "Χιτζάζ").esIdentico(a: .hitzaz))
        #expect(NombresDeEscalas.de(.catalan).porTipo[.dorico]?.variantes == ["dòrica"])
        #expect(NombresDeEscalas.de(.catalan).indice["dorica"] == .dorico)
    }

    @Test func normalizarPliegaOrdinalesYMenos() {
        #expect(TipoDeEscala.normalizar("jónico sin 4ª") == "jonico sin 4")
        #expect(TipoDeEscala.normalizar("cromática −5…6") == "cromatica 5..6")
        #expect((try? TipoDeEscala(leyendo: "cromatica -5..6")) == (try? TipoDeEscala(leyendo: "cromática −5…6")))
    }

    /// Las filas `.tradicional(.miembro, "…")` apuntan al tipo, y las escalas sin fila (los mēḷa) conservan su nombre.
    @Test func lasTradicionalesSinFilaConservanSuNombreOriginal() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.melakartas {
                #expect(nombres.nombre(de: tipo) == tipo.nombre, "\(idioma)")
                #expect(
                    nombres.indice[TipoDeEscala.normalizar(tipo.nombre)]?.intervalos == tipo.intervalos, "\(idioma)")
            }
        }
        #expect(NombresDeEscalas.de(.ruso).nombre(de: .`in`) == "Ин")
    }
}
