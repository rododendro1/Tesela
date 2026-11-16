import Testing

@testable import Elementos
@testable import Teoria

/// El carácter de las escalas (`Caracter`, `TipoDeEscala.caracter`).
@Suite struct CaracterTests {
    private let espanol = Notacion.compacta(.espanol)

    /// Cada escala con carácter es del catálogo, está una vez en la tabla y cada carácter dice algo.
    @Test func cadaCaracterEsDeUnaEscalaDelCatalogoYDiceAlgo() {
        let identidades = TipoDeEscala.caracteres.map(\.tipo.identidad)
        #expect(Set(identidades).count == identidades.count)
        for (tipo, caracteres) in TipoDeEscala.caracteres {
            #expect(TipoDeEscala.delCatalogo[tipo.identidad] != nil, "\(tipo.nombre)")
            #expect(!caracteres.isEmpty, "\(tipo.nombre)")
            for caracter in caracteres {
                let dice =
                    !caracter.afectos.isEmpty || caracter.momento != nil || caracter.estacion != nil
                    || caracter.ocasion != nil || caracter.papel != nil || caracter.fase != nil
                #expect(dice, "\(tipo.nombre)")
                #expect(Set(caracter.afectos).count == caracter.afectos.count, "\(tipo.nombre)")
                #expect(caracter.pasaje == nil || caracter.testigo != nil, "\(tipo.nombre)")
            }
        }
    }

    /// La fuente del carácter está en las referencias de la escala.
    @Test func laFuenteEstaEnLasReferencias() {
        for (tipo, caracteres) in TipoDeEscala.caracteres {
            let claves = Set(tipo.referencias.map(\.clave))
            for caracter in caracteres { #expect(claves.contains(caracter.referencia.clave), "\(tipo.nombre)") }
        }
    }

    /// Es del nombre, no de las notas: el jónico y Bilāval tienen las mismas, pero solo Bilāval tiene carácter.
    @Test func esDelNombreYNoDeLasNotas() {
        #expect(TipoDeEscala.bilaval == TipoDeEscala.mayor)
        #expect(!TipoDeEscala.bilaval.caracter.isEmpty)
        #expect(TipoDeEscala.mayor.caracter.isEmpty)
        #expect(TipoDeEscala.dorico.caracter.isEmpty)
        #expect(TipoDeEscala(nombre: "otra", intervalos: TipoDeEscala.bhairav.intervalos).caracter.isEmpty)
    }

    /// Las escalas sin fuente no tienen carácter: los mēḷa y las sintéticas.
    @Test func sinFuenteNoHayCaracter() {
        for tipo in TipoDeEscala.catalogo where tipo.categoria == .melakarta { #expect(tipo.caracter.isEmpty) }
        #expect(TipoDeEscala.alterada.caracter.isEmpty)
    }

    /// Lo que dice cada tradición, fijado.
    @Test func losDeCadaTradicion() {
        let doria = TipoDeEscala.harmoniaDoria.caracter
        #expect(doria.map(\.testigo) == [.heraclides, .aristoteles])
        #expect(TipoDeEscala.harmoniaDoria.afectos == [.valiente, .majestuoso, .severo, .grave, .sereno])
        #expect(TipoDeEscala.harmoniaMixolidiaDeAristides.caracter.first?.ocasion == .lamento)
        #expect(TipoDeEscala.harmoniaFrigia.caracter.first?.afectos == [.entusiasta])
        #expect(TipoDeEscala.harmoniaFrigia.caracter.first?.referencia.cita == "Monro 1894: 12–13")
        #expect(TipoDeEscala.tritusPlagalis.afectos == [.lastimero])
        #expect(TipoDeEscala.bhairav.momentos == [.manana])
        #expect(TipoDeEscala.darbariKanada.momentos == [.medianoche])
        #expect(TipoDeEscala.megh.caracter.first?.estacion == .lluvias)
        #expect(TipoDeEscala.slendroManyura.momentos == [.madrugada])
        #expect(TipoDeEscala.jue.caracter.compactMap(\.fase) == [.madera])
        #expect(TipoDeEscala.jue.caracter.compactMap(\.estacion) == [.primavera])
        #expect(TipoDeEscala.gong.caracter.compactMap(\.papel) == [.soberano])
    }

    /// Van en orden cronológico, por el año del testigo o, si no hay, el de la fuente.
    @Test func vanEnOrdenCronologico() {
        for (tipo, _) in TipoDeEscala.caracteres {
            let anios = tipo.caracter.map { $0.anio ?? .max }
            #expect(anios == anios.sorted(), "\(tipo.nombre)")
        }
        #expect(TestigoDelCaracter.allCases.map(\.anio) == TestigoDelCaracter.allCases.map(\.anio).sorted())
    }

    /// La cita y la descripción, en español y en inglés.
    @Test func laCitaYLaDescripcion() {
        let lidia = TipoDeEscala.harmoniaLidiaDeAristides.caracter[0]
        #expect(lidia.cita(en: espanol) == "Platón 398e (Monro 1894: 7–8)")
        #expect(lidia.descripcion(en: espanol) == "banquete · blando")
        #expect(lidia.descripcion(en: .compacta(.ingles)) == "banquet · soft")
        let bhairav = TipoDeEscala.bhairav.caracter[0]
        #expect(bhairav.cita(en: espanol) == Referencia.bor1999.cita)
        #expect(bhairav.descripcion(en: espanol) == "mañana · devoto, solemne, grave")
    }

    /// Cada nombre está en los trece idiomas y no se repite dentro de su vocabulario.
    @Test func losNombresEnLosTreceIdiomas() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.compacta(idioma)
            let vocabularios: [[String]] = [
                Afecto.allCases.map { $0.nombre(en: notacion) },
                MomentoDelDia.allCases.map { $0.nombre(en: notacion) },
                Estacion.allCases.map { $0.nombre(en: notacion) },
                Ocasion.allCases.map { $0.nombre(en: notacion) },
                PapelDeLaNota.allCases.map { $0.nombre(en: notacion) },
                FaseDeLaNaturaleza.allCases.map { $0.nombre(en: notacion) },
                TestigoDelCaracter.allCases.map { $0.nombre(en: notacion) },
            ]
            for nombres in vocabularios {
                #expect(nombres.allSatisfy { !$0.isEmpty }, "\(idioma)")
                #expect(Set(nombres).count == nombres.count, "\(idioma): \(nombres)")
            }
        }
        #expect(Afecto.lastimero.nombre(en: .compacta(.aleman)) == "klagend")
    }

    /// Los maqāmāt de Touma.
    @Test func losMaqamatDeTouma() {
        #expect(TipoDeEscala.maqamRast.afectos == [.majestuoso, .energico, .templado])
        #expect(TipoDeEscala.saba.caracter.first?.referencia.cita == "Touma 1996: 44")
        #expect(TipoDeEscala.sikah.afectos == [.amoroso])
        #expect(TipoDeEscala.hiyaz.caracter.isEmpty) // «el desierto lejano» no es un afecto
    }

    /// Los momentos cubren el día en tramos de tres horas, sin huecos.
    @Test func losMomentosCubrenElDia() {
        #expect(Set(MomentoDelDia.allCases.map(\.horaDeInicio)) == Set(stride(from: 0, to: 24, by: 3)))
    }
}

/// El carácter de las tonalidades, de Charpentier, Mattheson, Rameau y Schubart.
@Suite struct CaracterDeLasTonalidadesTests {
    private func de(_ referencia: Referencia, _ testigo: TestigoDelCaracter? = nil) -> [Tonalidad] {
        Tonalidad.caracteres.filter { fila in
            fila.caracter.allSatisfy { $0.referencia == referencia && $0.testigo == testigo }
        }.map(\.tonalidad)
    }

    /// Schubart describe 24 tonalidades, Charpentier 18, Mattheson 14 (las que se resumen en un afecto) y Rameau 14,
    /// cada una una vez, con su obra y sus afectos; todos menos Mattheson, con sus palabras.
    @Test func lasDeCadaFuente() {
        let schubart = de(.steblin1983, .schubart)
        #expect(schubart.count == 24 && Set(schubart).count == 24)
        #expect(schubart.filter { $0.modo == .mayor }.count == 12)
        let charpentier = de(.cessac1988, .charpentier)
        #expect(charpentier.count == 18 && Set(charpentier).count == 18)
        let mattheson = de(.steblin1983, .mattheson)
        #expect(mattheson.count == 14 && Set(mattheson).count == 14)
        let rameau = de(.rameau1722)
        #expect(rameau.count == 14 && Set(rameau).count == 14)
        #expect(schubart.count + charpentier.count + mattheson.count + rameau.count == Tonalidad.caracteres.count)
        for (tonalidad, caracter) in Tonalidad.caracteres {
            for fuente in caracter {
                #expect(!fuente.afectos.isEmpty, "\(tonalidad)")
                #expect((fuente.texto.map { !$0.isEmpty } ?? false) == (fuente.testigo != .mattheson), "\(tonalidad)")
            }
        }
        // Mi♭ menor solo la describe Charpentier; Re♯ menor, solo Schubart. Fa menor está en dos grupos de Rameau.
        #expect(Tonalidad.conCaracter.count == 25)
        #expect(Tonalidad(Nota(.mi, .bemol), .menor).caracter.map(\.testigo) == [.charpentier])
        #expect(Tonalidad(Nota(.re, .sostenido), .menor).caracter.map(\.testigo) == [.schubart])
        #expect(Tonalidad(.fa, .menor).caracter.filter { $0.referencia == .rameau1722 }.count == 2)
    }

    /// Es del nombre: Re♭ mayor tiene carácter, y Do♯ mayor no. Van por orden: Charpentier (hacia 1690), Mattheson
    /// (1713), Rameau (1722) y Schubart (1806).
    @Test func esDelNombre() {
        #expect(Tonalidad(.do).caracter.map(\.testigo) == [.charpentier, nil, .schubart])
        #expect(Tonalidad(.do).caracter[2].afectos == [.inocente])
        #expect(Tonalidad(.re).caracter.map(\.testigo) == [.charpentier, .mattheson, nil, .schubart])
        #expect(Tonalidad(Nota(.re, .bemol)).caracter.first?.afectos == [.inquieto, .triste])
        #expect(Tonalidad(Nota(.do, .sostenido)).caracter.isEmpty)
        #expect(Tonalidad(Nota(.la, .bemol), .menor).caracter.first?.afectos == [.lastimero, .inquieto])
        #expect(Tonalidad(Nota(.sol, .sostenido), .menor).caracter.isEmpty)
        #expect(Tonalidad(.fa, .menor).caracter.last?.ocasion == .lamento)
    }

    @Test func laCitaYLasPalabras() {
        let espanol = Notacion.compacta(.espanol)
        let re = Tonalidad(.re).caracter
        #expect(re[0].cita(en: espanol) == "Charpentier (Cessac 1988)")
        #expect(re[0].texto == "Joyeux et très guerrier")
        #expect(re[1].cita(en: espanol) == "Mattheson (Steblin 1983)")
        #expect(re[1].descripcion(en: espanol) == "guerra · festivo, enérgico")
        #expect(re[2].cita(en: espanol) == "Rameau 1722")
        #expect(re[2].texto == "Chants d'allégresse et de réjouissance; le grand et le magnifique")
        #expect(re[3].cita(en: espanol) == "Schubart (Steblin 1983)")
        #expect(re[3].descripcion(en: espanol) == "festivo, majestuoso")
        #expect(re[3].descripcion(en: .compacta(.ingles)) == "festive, majestic")
        #expect(TipoDeEscala.saba.caracter[0].texto == "sadness and pain")
    }

    /// Dos fuentes no coinciden si no comparten ningún afecto. En Fa mayor, Charpentier y Rameau lo oyen colérico,
    /// Mattheson noble y amoroso, y Schubart sereno: solo coinciden los dos primeros. En Si♭ menor, todos lo oyen
    /// sombrío.
    @Test func lasFuentesQueNoCoinciden() {
        let fa = Caracter.discrepancias(Tonalidad(.fa).caracter)
        #expect(fa.count == 5 && fa[0].0.testigo == .charpentier && fa[0].1.testigo == .mattheson)
        #expect(!fa.contains { $0.0.testigo == .charpentier && $0.1.referencia == .rameau1722 })
        #expect(Caracter.discrepancias(Tonalidad(Nota(.si, .bemol), .menor).caracter).isEmpty)
        #expect(Caracter.discrepancias(Tonalidad(.do).caracter.prefix(1).map { $0 }).isEmpty)
        // En la doria, Heraclides (valiente, majestuosa, severa) y Aristóteles (grave, serena) no coinciden.
        #expect(Caracter.discrepancias(TipoDeEscala.harmoniaDoria.caracter).count == 1)
    }
}

/// Lo que mide un estudio con oyentes: Temperley y Tan.
@Suite struct MedidaDelAfectoTests {
    @Test func losSeisModos() {
        let modos: [TipoDeEscala] = [.mayor, .mixolidio, .lidio, .dorico, .menorNatural, .frigio]
        let proporciones = modos.map { $0.medidasDelAfecto.first?.proporcion }
        #expect(proporciones == [0.83, 0.64, 0.58, 0.40, 0.34, 0.21])
        #expect(modos.allSatisfy { $0.medidasDelAfecto.allSatisfy { $0.afecto == .alegre } })
        #expect(TipoDeEscala.locrio.medidasDelAfecto.isEmpty)
        #expect(TipoDeEscala.bilaval.medidasDelAfecto.isEmpty)
        #expect(TipoDeEscala.mayor.medidasDelAfecto[0].descripcion(en: .compacta(.espanol)) == "alegre: 83 %")
    }

    /// No es el brillo: el lidio, el más claro por quintas, sale menos alegre que el mixolidio.
    @Test func noEsElBrillo() {
        let lidio = TipoDeEscala.lidio.medidasDelAfecto[0].proporcion
        #expect(lidio < TipoDeEscala.mixolidio.medidasDelAfecto[0].proporcion)
        #expect(TipoDeEscala.lidio.sonoridad == .clara)
    }
}

/// Las escalas con carácter, de donde salen `escalas --momento` y el reloj de los rāgas.
@Suite struct EscalasConCaracterTests {
    @Test func cadaUnaUnaVez() {
        let identidades = TipoDeEscala.conCaracter.map(\.identidad)
        #expect(Set(identidades).count == identidades.count)
        #expect(TipoDeEscala.conCaracter.allSatisfy { !$0.caracter.isEmpty })
        let alAnochecer = TipoDeEscala.conCaracter.filter { $0.momentos.contains(.anochecer) }
        #expect(alAnochecer.map(\.nombre) == ["Yaman", "Bhūpālī", "Kalyāṇ", "Pūriyā", "Śrī", "Kedār"])
    }
}

/// La sonoridad calculada de las escalas occidentales.
@Suite struct SonoridadTests {
    /// Los modos de la mayor, del más claro al más oscuro, como los ordena Persichetti.
    @Test func losModosDeLaMayor() {
        let sonoridades = TipoDeEscala.modosPorBrillo.map(\.sonoridad)
        #expect(sonoridades == [.clara, .clara, .clara, .intermedia, .oscura, .oscura, .oscura])
        #expect(sonoridades.compactMap { $0 } == sonoridades.compactMap { $0 }.sorted())
    }

    @Test func soloLasOccidentales() {
        #expect(TipoDeEscala.pentatonicaMayor.sonoridad == .clara)
        #expect(TipoDeEscala.pentatonicaMenor.sonoridad == .oscura)
        #expect(TipoDeEscala.bilaval.sonoridad == nil) // las mismas notas que la mayor, pero de la India
        #expect(TipoDeEscala.bayati.sonoridad == nil)
        #expect(TipoDeEscala.occidentales.allSatisfy { $0.sonoridad != nil })
    }

    @Test func losNombres() {
        for idioma in Idioma.allCases {
            let nombres = Sonoridad.allCases.map { $0.nombre(en: .compacta(idioma)) }
            #expect(Set(nombres).count == 3 && nombres.allSatisfy { !$0.isEmpty }, "\(idioma)")
        }
        #expect(Sonoridad.clara.nombre(en: .compacta(.ingles)) == "bright")
    }
}

/// El carácter de los acordes, las progresiones y los ritmos.
@Suite struct CaracterDeLosCatalogosTests {
    /// Comprueba lo que comparten todos: cada uno del catálogo, una vez, con algo que decir, en orden cronológico y con
    /// su fuente entre sus referencias.
    private func comprobar<E: ElementoConNombre>(_ filas: [(E, [Caracter])]) {
        let nombres = filas.map(\.0.nombre)
        #expect(Set(nombres).count == nombres.count)
        for (elemento, caracteres) in filas {
            #expect(E.catalogo.contains(elemento), "\(elemento.nombre)")
            #expect(elemento.caracter == Caracter.enOrdenCronologico(caracteres), "\(elemento.nombre)")
            let claves = Set(elemento.referencias.map(\.clave))
            for caracter in caracteres {
                #expect(!caracter.afectos.isEmpty || caracter.ocasion != nil, "\(elemento.nombre)")
                #expect(claves.contains(caracter.referencia.clave), "\(elemento.nombre)")
            }
        }
    }

    @Test func losAcordes() {
        comprobar(AcordeConNombre.caracteres.map { ($0.acorde, $0.caracter) })
        #expect(AcordeConNombre.mayor.caracter.map(\.referencia) == [.zarlino1558, .rameau1722])
        #expect(AcordeConNombre.menor.afectos == [.triste, .tierno, .lastimero])
        #expect(AcordeConNombre.tristan.caracter.isEmpty)
    }

    @Test func lasProgresiones() {
        comprobar(ProgresionConNombre.caracteres.map { ($0.progresion, $0.caracter) })
        #expect(ProgresionConNombre.bajoDeLamento.ocasiones == [.lamento])
        #expect(ProgresionConNombre.chacona.ocasiones == [.danza])
        #expect(ProgresionConNombre.iiVI.caracter.isEmpty)
    }

    @Test func losRitmos() {
        comprobar(RitmoConNombre.caracteres.map { ($0.ritmo, $0.caracter) })
        #expect(RitmoConNombre.seguiriya.afectos == [.lastimero, .grave])
        #expect(RitmoConNombre.tresillo.caracter.isEmpty)
    }

    /// Los catálogos sin carácter no tienen ninguno.
    @Test func losDemasNoTienen() {
        #expect(TemperamentoConNombre.catalogo.allSatisfy { $0.caracter.isEmpty })
        #expect(NotaConNombre.catalogo.allSatisfy { $0.caracter.isEmpty })
        #expect(FuncionDeNota.catalogo.allSatisfy { $0.caracter.isEmpty })
    }
}
