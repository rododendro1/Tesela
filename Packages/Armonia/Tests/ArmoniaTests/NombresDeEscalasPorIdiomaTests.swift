import XCTest
@testable import ArmoniaTeoria
@testable import ArmoniaNucleo

/// Los ficheros por idioma de `Escalas/Nombres/`.
final class NombresDeEscalasPorIdiomaTests: XCTestCase {
    func testTodosLosIdiomasCubrenElCatalogoOccidental() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.todos {
                XCTAssertNotNil(nombres.porTipo[tipo], "\(idioma): \(tipo.nombre)")
            }
        }
    }

    func testElNombreDeCadaTipoSeLeeEnSuIdioma() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.todos {
                guard let entrada = nombres.porTipo[tipo] else { continue }
                XCTAssertNotNil(nombres.indice[TipoDeEscala.normalizar(entrada.nombre)], "\(idioma): \(entrada.nombre)")
                for alias in entrada.alias {
                    XCTAssertNotNil(nombres.indice[TipoDeEscala.normalizar(alias)], "\(idioma): \(alias)")
                }
            }
        }
    }

    func testNombreEnUsaElFicheroDeCadaIdioma() {
        for idioma in Idioma.allCases where idioma != .espanol {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for tipo in TipoDeEscala.todos {
                XCTAssertEqual(tipo.nombre(en: notacion), NombresDeEscalas.de(idioma).porTipo[tipo]?.nombre, "\(idioma): \(tipo.nombre)")
            }
        }
        // Un tipo propio, con los intervalos de uno del catálogo, conserva su nombre en español.
        let propio = TipoDeEscala(nombre: "mi modo", intervalos: TipoDeEscala.dorico.intervalos)
        XCTAssertEqual(propio.nombre(en: .espanolUnicode), "mi modo")
    }

    /// Cada alias se lee como su tipo: ningún alias es el nombre de otro tipo ni el alias de otro de su idioma.
    func testCadaAliasSeLeeComoSuTipo() {
        let sinAlias: Set<Idioma> = [.espanol, .ruso, .griego]
        for idioma in Idioma.allCases where !sinAlias.contains(idioma) {
            let nombres = NombresDeEscalas.de(idioma)
            for (tipo, entrada) in nombres.porTipo {
                for alias in entrada.alias {
                    XCTAssertEqual(nombres.indice[TipoDeEscala.normalizar(alias)], tipo, "\(idioma): \(alias) (\(entrada.nombre))")
                }
            }
        }
    }

    /// Los idiomas con alias los tienen en todas las familias de tipos más comunes: los modos con otro nombre
    /// («jónico», «eólico») y los modos con alteraciones.
    func testLosModosTienenSusSinonimosEnTodosLosIdiomas() {
        for idioma in Idioma.allCases where idioma != .espanol {
            let nombres = NombresDeEscalas.de(idioma)
            XCTAssertFalse(nombres.porTipo[.mayor]?.alias.isEmpty ?? true, "\(idioma): mayor")
            XCTAssertFalse(nombres.porTipo[.menorNatural]?.alias.isEmpty ?? true, "\(idioma): menor natural")
        }
    }

    /// Un tipo con alias en español (que no sean solo el mismo nombre sin tildes) los tiene en los idiomas
    /// románicos. Euskera, alemán, ruso y griego tienen menos: algunos alias no se traducen bien a su gramática.
    func testLosTiposConAliasEnEspanolLosTienenEnLosIdiomasRomanicos() {
        let romanicos: [Idioma] = [.catalan, .gallego, .asturiano, .aragones, .portugues, .frances, .occitano, .italiano]
        for tipo in TipoDeEscala.todos {
            let nombre = TipoDeEscala.normalizar(tipo.nombre)
            guard tipo.alias.contains(where: { TipoDeEscala.normalizar($0) != nombre }) else { continue }
            for idioma in romanicos {
                XCTAssertFalse(NombresDeEscalas.de(idioma).porTipo[tipo]?.alias.isEmpty ?? true, "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// El español tiene los alias del catálogo en el registro.
    func testElEspanolTieneLosAliasDelCatalogo() {
        for tipo in TipoDeEscala.todos {
            XCTAssertEqual(NombresDeEscalas.de(.espanol).porTipo[tipo]?.alias, tipo.alias, tipo.nombre)
        }
    }

    // MARK: Escalas de otras tradiciones

    func testTodosLosIdiomasTienenLasEscalasDeOtrasTradiciones() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.tradicionales {
                XCTAssertNotNil(nombres.tradicionales[tipo.nombre], "\(idioma): \(tipo.nombre)")
                XCTAssertNotNil(nombres.nombre(de: tipo), "\(idioma): \(tipo.nombre)")
            }
        }
    }

    /// Los nombres propios se escriben igual en todos los idiomas; solo cambian los que se traducen.
    func testSoloSeTraducenLosNombresDescriptivosDeLasTradicionales() {
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
                XCTAssertEqual(tipo.nombre(en: notacion), tipo.nombre, "\(idioma): \(tipo.nombre)")
            }
        }
        let catalan = Notacion.espanolUnicode.conTextos(en: .catalan)
        XCTAssertEqual(TipoDeEscala.andina.nombre(en: catalan), "pentatònica andina")
        XCTAssertEqual(TipoDeEscala.tetracordoCromatico.nombre(en: catalan), "tetracord cromàtic")
        XCTAssertEqual(TipoDeEscala.tezetaMenor.nombre(en: Notacion.espanolUnicode.conTextos(en: .frances)), "Təzəta mineur")
        XCTAssertEqual(TipoDeEscala.andina.nombre(en: .espanolUnicode), "pentatónica andina")
    }

    /// En ruso y griego los nombres propios van en su alfabeto (salvo los 72 melakarta, que siguen en IAST) y
    /// se leen de vuelta; el nombre original, en latino, sigue valiendo.
    func testRusoYGriegoTranscribenLosNombresPropiosDeLasTradicionales() {
        for (idioma, ejemplo, original) in [(Idioma.ruso, "Хиджаз", "Ḥijāz"), (.ruso, "Бхайрав", "Bhairav"),
                                           (.griego, "Ραστ", "Rast"), (.griego, "Μπιλαβάλ", "Bilāval")] {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            let tipo = TipoDeEscala.buscar(nombre: original)
            XCTAssertEqual(tipo?.nombre(en: notacion), ejemplo, "\(idioma)")
            XCTAssertEqual(NombresDeEscalas.de(idioma).indice[TipoDeEscala.normalizar(ejemplo)], tipo, "\(idioma)")
        }
        for idioma in [Idioma.ruso, .griego] {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            for tipo in TipoDeEscala.melakartas { XCTAssertEqual(tipo.nombre(en: notacion), tipo.nombre, "\(idioma)") }
        }
        let notacion = Notacion.espanolUnicode.conTextos(en: .griego)
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "Hitzáz")?.nombre(en: notacion), "Χιτζάζ")
    }

    /// Āsāvarī es la escala menor natural por sus intervalos (`TipoDeEscala` se compara por ellos): por eso las
    /// tradicionales se buscan por su nombre y no por el tipo. En ruso y griego va transcrito (Асавари, Ασαβαρί).
    func testUnaEscalaTradicionalIgualAUnaOccidentalConservaSuNombre() {
        XCTAssertEqual(TipoDeEscala.asavari, TipoDeEscala.menorNatural)
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            if idioma != .ruso && idioma != .griego {
                XCTAssertEqual(nombres.nombre(de: .asavari), TipoDeEscala.asavari.nombre, "\(idioma)")
            }
            XCTAssertNotEqual(nombres.nombre(de: .asavari), nombres.nombre(de: .menorNatural), "\(idioma)")
        }
    }

    /// Un nombre traducido de una tradicional se lee en su idioma (el alemán, con la tónica en alemán).
    func testLosNombresTraducidosDeLasTradicionalesSeLeen() {
        XCTAssertEqual(Escala("Fis andine Pentatonik").tipo.nombre, "pentatónica andina")
        XCTAssertEqual(Escala("do tetracord cromàtic").tipo.nombre, "tetracordo cromático")
    }

    // MARK: Alias escritos y alias normalizados

    /// `alias` guarda solo grafías correctas; las simplificadas (sin diacríticos, `#`/`b`) las da `aliasNormalizados`.
    func testLosAliasGuardadosNoSonSoloFormasNormalizadas() {
        for tipo in TipoDeEscala.todos + TipoDeEscala.tradicionales {
            let escritas = [tipo.nombre] + tipo.alias
            for alias in tipo.alias where alias.unicodeScalars.allSatisfy(\.isASCII) {
                let redundante = escritas.contains {
                    $0 != alias && TipoDeEscala.normalizar($0) == TipoDeEscala.normalizar(alias)
                        && (!$0.unicodeScalars.allSatisfy(\.isASCII) || $0 == tipo.nombre)
                }
                XCTAssertFalse(redundante, "\(tipo.nombre): «\(alias)» se deduce de otra grafía")
            }
        }
    }

    /// Las formas normalizadas encuentran el tipo, escritas como se escriban.
    func testLasFormasNormalizadasLeenElMismoTipo() {
        for tipo in TipoDeEscala.todos {
            for clave in tipo.aliasNormalizados {
                XCTAssertEqual(TipoDeEscala.buscar(nombre: clave, aceptarIngles: false)?.intervalos, tipo.intervalos, clave)
            }
        }
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "dorico b2"), TipoDeEscala.buscar(nombre: "dórico ♭2"))
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "jonico sin 4"), TipoDeEscala.jonicoSinCuarta)
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "doble armonica"), TipoDeEscala.dobleArmonica)
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "Hanumatodi")?.nombre, "Hanumattoḍī")
    }

    func testAliasNormalizadosNoTienenRepetidos() {
        let t = TipoDeEscala(nombre: "Dórico", intervalos: [.unisono, .terceraMenor], alias: ["dórico", "Dorico", "Jónico"])
        XCTAssertEqual(t.aliasNormalizados, ["dorico", "jonico"])
    }

    func testNormalizarPliegaOrdinalesYMenos() {
        XCTAssertEqual(TipoDeEscala.normalizar("jónico sin 4ª"), "jonico sin 4")
        XCTAssertEqual(TipoDeEscala.normalizar("cromática −5…6"), "cromatica 5..6")
        XCTAssertEqual(TipoDeEscala.buscar(nombre: "cromatica -5..6"), TipoDeEscala.buscar(nombre: "cromática −5…6"))
    }

    /// Las filas `.tradicional(.miembro)` apuntan al tipo, y las escalas sin fila (los melakarta) conservan su nombre.
    func testLasTradicionalesSinFilaConservanSuNombreOriginal() {
        for idioma in Idioma.allCases {
            let nombres = NombresDeEscalas.de(idioma)
            for tipo in TipoDeEscala.melakartas {
                XCTAssertEqual(nombres.nombre(de: tipo), tipo.nombre, "\(idioma)")
                XCTAssertEqual(nombres.indice[TipoDeEscala.normalizar(tipo.nombre)]?.intervalos, tipo.intervalos, "\(idioma)")
            }
        }
        XCTAssertEqual(NombresDeEscalas.de(.ruso).nombre(de: .`in`), "Ин")
    }
}
