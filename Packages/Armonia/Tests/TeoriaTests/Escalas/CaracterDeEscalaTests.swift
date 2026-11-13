import Testing

@testable import Elementos
@testable import Teoria

/// El carácter de las escalas (`CaracterDeEscala`, `TipoDeEscala.caracter`).
@Suite struct CaracterDeEscalaTests {
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
            for caracter in caracteres { #expect(claves.contains(caracter.fuente.clave), "\(tipo.nombre)") }
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
        #expect(TipoDeEscala.harmoniaFrigia.caracter.first?.fuente.cita == "Monro 1894: 12–13")
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

    /// Los momentos cubren el día en tramos de tres horas, sin huecos.
    @Test func losMomentosCubrenElDia() {
        #expect(Set(MomentoDelDia.allCases.map(\.horaDeInicio)) == Set(stride(from: 0, to: 24, by: 3)))
    }
}
