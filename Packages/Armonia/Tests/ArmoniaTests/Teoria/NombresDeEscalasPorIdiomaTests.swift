import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Los ficheros por idioma de `Escalas/Nombres/`.
@Suite struct NombresDeEscalasPorIdiomaTests {
    @Test func todosLosIdiomasCubrenElCatalogoOccidental() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.todos {
                #expect(nombres.porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    @Test func elNombreDeCadaTipoSeLeeEnSuIdioma() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.todos {
                guard let entrada = nombres.porTipo[tipo] else { continue }
                #expect(nombres.indice[TipoDeEscala.normalizar(entrada.nombre)] != nil, "\(idioma): \(entrada.nombre)")
                for alias in entrada.alias {
                    #expect(nombres.indice[TipoDeEscala.normalizar(alias)] != nil, "\(idioma): \(alias)")
                }
            }
        }
    }

    @Test func nombreEnUsaElFicheroDeCadaIdioma() {
        for idioma in Idioma.allCases where idioma != .espanol {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for tipo in TipoDeEscala.todos {
                #expect(
                    tipo.nombre(en: notacion) == NombresDeEscalas.de(idioma).porTipo[tipo]?.nombre,
                    "\(idioma): \(tipo.nombre)")
            }
        }
        // Un tipo propio, con los intervalos de uno del catálogo, conserva su nombre en español.
        let propio = TipoDeEscala(nombre: "mi modo", intervalos: TipoDeEscala.dorico.intervalos)
        #expect(propio.nombre(en: .espanolUnicode) == "mi modo")
    }

    /// Cada alias se lee como su tipo: ningún alias es el nombre de otro tipo ni el alias de otro de su idioma.
    @Test func cadaAliasSeLeeComoSuTipo() {
        let sinAlias: Set<Idioma> = [.espanol, .ruso, .griego]
        for idioma in Idioma.allCases where !sinAlias.contains(idioma) {
            let nombres = NombresDeEscalas.de(idioma)
            for (tipo, entrada) in nombres.porTipo {
                for alias in entrada.alias {
                    #expect(
                        nombres.indice[TipoDeEscala.normalizar(alias)] == tipo,
                        "\(idioma): \(alias) (\(entrada.nombre))")
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

    /// Un tipo con alias en español (que no sean solo el mismo nombre sin tildes) los tiene en los idiomas
    /// románicos. Euskera, alemán, ruso y griego tienen menos: algunos alias no se traducen bien a su gramática.
    @Test func losTiposConAliasEnEspanolLosTienenEnLosIdiomasRomanicos() {
        let romanicos: [Idioma] = [
            .catalan, .gallego, .asturiano, .aragones, .portugues, .frances, .occitano, .italiano,
        ]
        for tipo in TipoDeEscala.todos {
            let nombre = TipoDeEscala.normalizar(tipo.nombre)
            guard tipo.alias.contains(where: { TipoDeEscala.normalizar($0) != nombre }) else { continue }
            for idioma in romanicos {
                #expect(
                    !(NombresDeEscalas.de(idioma).porTipo[tipo]?.alias.isEmpty ?? true), "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// El español tiene los alias del catálogo en el registro.
    @Test func elEspanolTieneLosAliasDelCatalogo() {
        for tipo in TipoDeEscala.todos {
            #expect(NombresDeEscalas.de(.espanol).porTipo[tipo]?.alias == tipo.alias, Comment(rawValue: tipo.nombre))
        }
    }

    // MARK: Escalas de otras tradiciones

    @Test func todosLosIdiomasTienenLasEscalasDeOtrasTradiciones() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.tradicionales {
                #expect(nombres.tradicionales[tipo.nombre] != nil, "\(idioma): \(tipo.nombre)")
                #expect(nombres.nombre(de: tipo) != nil, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// Los nombres propios se escriben igual en todos los idiomas; solo cambian los que se traducen.
    @Test func soloSeTraducenLosNombresDescriptivosDeLasTradicionales() {
        let traducidos: Set<String> = [
            "pentatónica andina", "tritónica andina", "tetracordo diatónico", "tetracordo cromático", "harmonía doria",
            "harmonía doria cromática", "harmonía frigia", "harmonía lidia",
            "Təzəta mayor", "Təzəta menor", "Bati mayor", "Bati menor",
        ]
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            // El ruso y el griego, que usan otro alfabeto, transcriben también los nombres propios.
            if idioma == .ruso || idioma == .griego { continue }
            for tipo in TipoDeEscala.tradicionales where !traducidos.contains(tipo.nombre) {
                #expect(tipo.nombre(en: notacion) == tipo.nombre, "\(idioma): \(tipo.nombre)")
            }
        }
        let catalan = Notacion.espanolUnicode.conTextos(en: .catalan)
        #expect(TipoDeEscala.andina.nombre(en: catalan) == "pentatònica andina")
        #expect(TipoDeEscala.tetracordoCromatico.nombre(en: catalan) == "tetracord cromàtic")
        #expect(TipoDeEscala.tezetaMenor.nombre(en: Notacion.espanolUnicode.conTextos(en: .frances)) == "Təzəta mineur")
        #expect(TipoDeEscala.andina.nombre(en: .espanolUnicode) == "pentatónica andina")
    }

    /// En ruso y griego los nombres propios van en su alfabeto (salvo los 72 melakarta, que siguen en IAST) y
    /// se leen de vuelta; el nombre original, en latino, sigue valiendo.
    @Test func rusoYGriegoTranscribenLosNombresPropiosDeLasTradicionales() {
        for (idioma, ejemplo, original) in [
            (Idioma.ruso, "Хиджаз", "Ḥijāz"), (.ruso, "Бхайрав", "Bhairav"),
            (.griego, "Ραστ", "Rast"), (.griego, "Μπιλαβάλ", "Bilāval"),
        ] {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            let tipo = TipoDeEscala.buscar(nombre: original)
            #expect(tipo?.nombre(en: notacion) == ejemplo, "\(idioma)")
            #expect(NombresDeEscalas.de(idioma).indice[TipoDeEscala.normalizar(ejemplo)] == tipo, "\(idioma)")
        }
        for idioma in [Idioma.ruso, .griego] {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for tipo in TipoDeEscala.melakartas { #expect(tipo.nombre(en: notacion) == tipo.nombre, "\(idioma)") }
        }
        let notacion = Notacion.espanolUnicode.conTextos(en: .griego)
        #expect(TipoDeEscala.buscar(nombre: "Hitzáz")?.nombre(en: notacion) == "Χιτζάζ")
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
    }

    // MARK: Alias escritos y alias normalizados

    /// `alias` guarda solo grafías correctas; las simplificadas (sin diacríticos, `#`/`b`) las da `aliasNormalizados`.
    @Test func losAliasGuardadosNoSonSoloFormasNormalizadas() {
        for tipo in TipoDeEscala.todos + TipoDeEscala.tradicionales {
            let escritas = [tipo.nombre] + tipo.alias
            for alias in tipo.alias where alias.unicodeScalars.allSatisfy(\.isASCII) {
                let redundante = escritas.contains {
                    $0 != alias && TipoDeEscala.normalizar($0) == TipoDeEscala.normalizar(alias)
                        && (!$0.unicodeScalars.allSatisfy(\.isASCII) || $0 == tipo.nombre)
                }
                #expect(!redundante, "\(tipo.nombre): «\(alias)» se deduce de otra grafía")
            }
        }
    }

    /// Las formas normalizadas encuentran el tipo, escritas como se escriban.
    @Test func lasFormasNormalizadasLeenElMismoTipo() {
        for tipo in TipoDeEscala.todos {
            for clave in tipo.aliasNormalizados {
                #expect(
                    TipoDeEscala.buscar(nombre: clave, aceptarIngles: false)?.intervalos == tipo.intervalos,
                    Comment(rawValue: clave))
            }
        }
        #expect(TipoDeEscala.buscar(nombre: "dorico b2") == TipoDeEscala.buscar(nombre: "dórico ♭2"))
        #expect(TipoDeEscala.buscar(nombre: "jonico sin 4") == TipoDeEscala.jonicoSinCuarta)
        #expect(TipoDeEscala.buscar(nombre: "doble armonica") == TipoDeEscala.dobleArmonica)
        #expect(TipoDeEscala.buscar(nombre: "Hanumatodi")?.nombre == "Hanumattoḍī")
    }

    @Test func aliasNormalizadosNoTienenRepetidos() {
        let t = TipoDeEscala(
            nombre: "Dórico", intervalos: [.unisono, .terceraMenor], alias: ["dórico", "Dorico", "Jónico"])
        #expect(t.aliasNormalizados == ["dorico", "jonico"])
    }

    @Test func normalizarPliegaOrdinalesYMenos() {
        #expect(TipoDeEscala.normalizar("jónico sin 4ª") == "jonico sin 4")
        #expect(TipoDeEscala.normalizar("cromática −5…6") == "cromatica 5..6")
        #expect(TipoDeEscala.buscar(nombre: "cromatica -5..6") == TipoDeEscala.buscar(nombre: "cromática −5…6"))
    }

    /// Las filas `.tradicional(.miembro)` apuntan al tipo, y las escalas sin fila (los melakarta) conservan su nombre.
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
