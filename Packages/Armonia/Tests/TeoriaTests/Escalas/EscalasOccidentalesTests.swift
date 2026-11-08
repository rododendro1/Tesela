import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas occidentales del catálogo: modos, cromáticas, Messiaen, bebop, blues y hexacordos.
@Suite struct EscalasOccidentalesTests {
    @Test func escalasOccidentalesNuevas() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.dobleArmonica) == "Do Re♭ Mi Fa Sol La♭ Si")
        #expect(notas(.menorHungara) == "Do Re Mi♭ Fa♯ Sol La♭ Si")
        #expect(notas(.mayorHungara) == "Do Re♯ Mi Fa♯ Sol La Si♭")
        #expect(notas(.napolitanaMenor) == "Do Re♭ Mi♭ Fa Sol La♭ Si")
        #expect(notas(.napolitanaMayor) == "Do Re♭ Mi♭ Fa Sol La Si")
        #expect(notas(.enigmatica) == "Do Re♭ Mi Fa♯ Sol♯ La♯ Si")
        #expect(notas(.persa) == "Do Re♭ Mi Fa Sol♭ La♭ Si")
        #expect(notas(.mayorLocria) == "Do Re Mi Fa Sol♭ La♭ Si♭")
        #expect(notas(.lidioMenor) == "Do Re Mi Fa♯ Sol La♭ Si♭")
        #expect(notas(.prometeo) == "Do Re Mi Fa♯ La Si♭")
        #expect(notas(.prometeoNapolitano) == "Do Re♭ Mi Fa♯ La Si♭")
        #expect(notas(.tritonoDeDosSemitonos) == "Do Re♭ Re Fa♯ Sol La♭")
        #expect(notas(.hexatonicaDeArmonicos) == "Do Mi♭ Mi Fa Sol La")
        #expect(notas(.bebopLocrio) == "Do Re♭ Mi♭ Fa Sol♭ Sol La♭ Si♭")
        #expect(notas(.bebopLidio) == "Do Re Mi Fa♯ Sol Sol♯ La Si")
        #expect(notas(.pentatonicaMayorTerceraMenor) == "Do Re Mi♭ Sol La")
        #expect(notas(.pentatonicaMenorSextaMenor) == "Do Mi♭ Fa Sol La♭")
        #expect(TipoDeEscala.pentatonicaMayorTerceraMenor.equivalentes.contains { $0.esIdentico(a: .kumoijoshi) })
        #expect(notas(.disminuidaSemitonoTono) == "Do Re♭ Mi♭ Mi Fa♯ Sol La Si♭")
        #expect(notas(.aumentada) == "Do Mi♭ Mi Sol Sol♯ Si")
        #expect(notas(.bluesMayor) == "Do Re Mi♭ Mi Sol La")
        #expect(notas(.egipcia) == "Do Re Fa Sol Si♭")
        #expect(notas(.cromatica) == "Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si")
        #expect(Set(Escala(.do, .cromatica).notas.map(\.claseDeAltura)).count == 12)

        // Los modos de la mayor armónica son sus rotaciones.
        let modos: [TipoDeEscala] = [
            .mayorArmonica, .doricoQuintaDisminuida, .frigioCuartaDisminuida, .lidioTerceraMenor,
            .mixolidioSegundaMenor, .lidioAumentadoSegundaAumentada, .locrioSeptimaDisminuida,
        ]
        for (i, modo) in modos.enumerated() {
            #expect(TipoDeEscala.mayorArmonica.modo(grado: i + 1).esIdentico(a: modo), Comment(rawValue: modo.nombre))
        }
        // Las disminuidas suenan como rotaciones la una de la otra (la ortografía cambia).
        #expect(
            TipoDeEscala.disminuida.modo(grado: 2).intervalos.map(\.semitonos)
                == TipoDeEscala.disminuidaSemitonoTono.intervalos.map(\.semitonos))

        // Nombres en inglés y alias.
        #expect(Escala("E hungarian minor").tipo == .menorHungara)
        #expect(Escala("C double harmonic").tipo.nombre == "doble armónica")
        #expect(Escala(.do, .enigmatica).nombre(en: .ascii(.ingles)) == "C enigmatic")
        #expect(Escala("G half-whole diminished").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Mi española").tipo == .frigioDominante)
        #expect(Escala("Do modo 1 de Messiaen").tipo == .tonosEnteros)
        #expect(Escala("Do modo 2 de Messiaen").tipo == .disminuidaSemitonoTono)
        #expect(Escala("Do gitana menor").tipo == .menorHungara)
        #expect(Escala("Do Skriabin").tipo == .prometeo)
        #expect(Escala("Do Prometeo napolitano").tipo == .prometeoNapolitano)
        #expect(Escala("Do de Verdi").tipo == .enigmatica)
        #expect(Escala("Do Stravinski").tipo == .disminuidaSemitonoTono)

        // Con el mismo contenido que escalas de otras tradiciones.
        #expect(TipoDeEscala.dobleArmonica == .bhairav)
        #expect(TipoDeEscala.menorHungara == .niavent)
        #expect(TipoDeEscala.egipcia == .shang)
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count) // sin repetidos en el catálogo
        #expect(
            Escala.identificar(notas: ["Do", "Re♭", "Mi", "Fa", "Sol", "La♭", "Si"]).contains(
                Escala(.do, .dobleArmonica)))
    }

    @Test func cromaticasPorVentanaDeQuintas() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        let seis = TipoDeEscala.cromaticasPorQuintas
        #expect(
            seis == [
                .cromaticaConCincoBemoles, .cromaticaConCuatroBemoles, .cromaticaConTresBemoles,
                .cromaticaConDosBemoles, .cromaticaConUnBemol, .cromaticaConCincoSostenidos,
            ])
        #expect(TipoDeEscala.cromatica(ventana: .masSimple) == .cromatica)
        #expect(TipoDeEscala.cromatica(ventana: .bemoles) == .cromaticaConCincoBemoles)
        #expect(TipoDeEscala.cromaticaConCuatroBemoles.nombre == "cromática")
        #expect(notas(.cromaticaConCincoBemoles) == "Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si")
        #expect(notas(.cromaticaConDosBemoles) == "Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si")
        #expect(notas(.cromaticaConCincoSostenidos) == "Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si")
        #expect(notas(.cromaticaConCincoSostenidos, .re) == "Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯")
        #expect(notas(.cromaticaConCincoBemoles, .re) == "Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si Do Do♯")

        // La regla, no solo los casos: doce clases de altura, desde el unísono, con la escala mayor dentro.
        let mayor = Set(TipoDeEscala.mayor.intervalos)
        for tipo in seis {
            #expect(tipo.intervalos.count == 12, Comment(rawValue: tipo.nombre))
            #expect(Set(tipo.intervalos.map(\.semitonos)) == Set(0..<12), Comment(rawValue: tipo.nombre))
            #expect(tipo.intervalos.first == .unisono, Comment(rawValue: tipo.nombre))
            #expect(mayor.isSubset(of: tipo.intervalos), Comment(rawValue: tipo.nombre))
            // Doce quintas seguidas.
            let quintas = tipo.intervalos.map(\.pasosDeQuinta).sorted()
            #expect(quintas == Array(quintas[0]..<(quintas[0] + 12)), Comment(rawValue: tipo.nombre))
        }
        // Dos vecinas difieren en una sola nota, que pasa de bemol a sostenido: Sol♭, Re♭, La♭, Mi♭ y Si♭.
        let cambian: [(Nota, Nota)] = [
            ("Solb", "Fa#"), ("Reb", "Do#"), ("Lab", "Sol#"), ("Mib", "Re#"), ("Sib", "La#"),
        ]
        for (k, (bemol, sostenido)) in cambian.enumerated() {
            let antes = Set(Escala(.do, seis[k]).notas)
            let despues = Set(Escala(.do, seis[k + 1]).notas)
            #expect(antes.subtracting(despues) == [bemol], "\(k)")
            #expect(despues.subtracting(antes) == [sostenido], "\(k)")
        }

        // Se leen por su nombre y por su ventana.
        #expect((try? Escala(leyendo: "Do cromática con dos bemoles")) == Escala(.do, .cromaticaConDosBemoles))
        #expect((try? Escala(leyendo: "Re cromatica -1..10")) == Escala(.re, .cromaticaConCincoSostenidos))
        #expect((try? Escala(leyendo: "Re cromática −6…5")) == Escala(.re, .cromaticaConCincoBemoles))
        #expect((try? Escala(leyendo: "Do cromática con cuatro bemoles")) == Escala(.do, .cromatica))
        #expect((try? Escala(leyendo: "C chromatic with one flat")) == Escala(.do, .cromaticaConUnBemol))
        for tipo in seis {
            #expect(TipoDeEscala.occidentales.contains(tipo), Comment(rawValue: tipo.nombre))
            for idioma in Idioma.allCases {
                let notacion = Notacion.delIdioma(idioma)
                let escala = Escala(Nota("Fa#"), tipo)
                #expect(
                    (try? Escala(leyendo: escala.nombre(en: notacion))) == escala,
                    "\(idioma): \(escala.nombre(en: notacion))")
            }
        }
        // Las seis tienen nombres distintos en cada idioma.
        for idioma in Idioma.allCases {
            let nombres = seis.map {
                $0.nombre(en: Notacion.delIdioma(idioma))
            }
            #expect(Set(nombres).count == 6, "\(idioma)")
        }
        // Con una de ellas, cada clase de altura se escribe como dice su ventana.
        #expect(Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10) == "La#")
        #expect(Escala(.do, .cromaticaConCincoBemoles).nombre(claseDeAltura: 6) == "Solb")
    }

    @Test func messiaenFlamencaBebopYAlias() {
        func notas(_ tipo: TipoDeEscala) -> String { Escala(.do, tipo).notas.map(\.description).joined(separator: " ") }
        #expect(notas(.messiaen3) == "Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si")
        #expect(notas(.messiaen4) == "Do Re♭ Re Fa Fa♯ Sol La♭ Si")
        #expect(notas(.messiaen5) == "Do Re♭ Fa Fa♯ Sol Si")
        #expect(notas(.messiaen6) == "Do Re Mi Fa Fa♯ Sol♯ La♯ Si")
        #expect(notas(.messiaen7) == "Do Re♭ Re Mi♭ Fa Fa♯ Sol La♭ La Si")
        #expect(notas(.flamenca) == "Do Re♭ Mi♭ Mi Fa Sol La♭ Si♭")
        #expect(notas(.petrushka) == "Do Re♭ Mi Fa♯ Sol Si♭")
        #expect(notas(.bebopMenorMelodica) == "Do Re Mi♭ Fa Sol Sol♯ La Si")
        #expect(notas(.bebopMenorArmonica) == "Do Re Mi♭ Fa Sol La♭ Si♭ Si")

        // Transposición limitada: cuántas transposiciones distintas tiene cada modo.
        func transposiciones(_ tipo: TipoDeEscala) -> Int {
            let clases = tipo.intervalos.map { modulo($0.semitonos, 12) }
            return Set((0..<12).map { t in Set(clases.map { modulo($0 + t, 12) }) }).count
        }
        #expect(
            [TipoDeEscala.tonosEnteros, .disminuida, .messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7]
                .map(transposiciones) == [2, 3, 4, 6, 6, 6, 6])
        // Petrushka: los acordes mayores de Do y de Fa♯ (con Re♭ por Do♯ y Si♭ por La♯).
        #expect(
            Set(Escala(.do, .petrushka).notas.map(\.claseDeAltura))
                == Set((Acorde("Do").notas + Acorde("Fa#").notas).map(\.claseDeAltura)))

        // Nombres y alias.
        #expect(Escala("Do modo 3 de Messiaen").tipo == .messiaen3)
        #expect(Escala("Do Tcherepnin").tipo == .messiaen3)
        #expect(Escala("C Messiaen mode 7").tipo == .messiaen7)
        #expect(Escala("Mi andaluza").tipo == .flamenca)
        #expect(Escala("E flamenco").tipo == .flamenca)
        #expect(Escala("Do bebop menor armónica").tipo == .bebopMenorArmonica)
        #expect(Escala("C bebop melodic minor").tipo == .bebopMenorMelodica)
        #expect(Escala("Re menor rumana").tipo == .doricoCuartaAumentada)
        #expect(Escala("D Romanian minor").tipo == .doricoCuartaAumentada)
        #expect(Escala("Mi Freygish").tipo.nombre == "Freygish")
        #expect(Escala("Mi Ahavah Rabbah").tipo == .frigioDominante) // mismo contenido
        #expect(Escala("Do de Bartók").tipo == .lidioDominante)
        #expect(Escala("C overtone").tipo == .lidioDominante)
        #expect(Escala("Do disminuida auxiliar blues").tipo == .disminuidaSemitonoTono)
        #expect(Escala("C auxiliary augmented").tipo == .tonosEnteros)
        #expect(Escala(.do, .messiaen3).nombre(en: .ascii(.ingles)) == "C Messiaen mode 3")
        #expect(Escala(.mi, .flamenca).nombre(en: .ascii(.ingles)) == "E flamenco")
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
    }

    @Test func modosDeLaDobleArmonicaYDeLasNapolitanas() {
        func modos(
            _ base: TipoDeEscala, _ esperados: [TipoDeEscala], sourceLocation: SourceLocation = #_sourceLocation
        ) {
            for (i, modo) in esperados.enumerated() {
                #expect(
                    base.modo(grado: i + 1).esIdentico(a: modo),
                    "\(base.nombre) \(i + 1): \(base.modo(grado: i + 1).nombre)",
                    sourceLocation: sourceLocation)
            }
        }
        modos(
            .dobleArmonica,
            [
                .dobleArmonica, .lidioSegundaSextaAumentadas, .ultrafrigio, .menorHungara, .oriental,
                .jonicoSegundaQuintaAumentadas, .locrioTerceraSeptimaDisminuidas,
            ])
        modos(
            .napolitanaMayor,
            [
                .napolitanaMayor, .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .lidioMenor,
                .mayorLocria, .locrioSegundaNaturalCuartaDisminuida, .superlocrioTerceraDisminuida,
            ])
        modos(
            .napolitanaMenor,
            [
                .napolitanaMenor, .lidioSextaAumentada, .mixolidioAumentado, .eolicoCuartaAumentada,
                .locrioDominante, .jonicoSegundaAumentada, .ultralocrioTerceraDisminuida,
            ])
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        #expect(notas(Escala(.do, .oriental)) == "Do Re♭ Mi Fa Sol♭ La Si♭")
        #expect(notas(Escala(.do, .ultrafrigio)) == "Do Re♭ Mi♭ Fa♭ Sol La♭ Si𝄫")
        #expect(Escala("C leading whole tone").tipo == .lidioAumentadoSextaAumentada)
        #expect(Escala("La gitana húngara").tipo == .eolicoCuartaAumentada)
    }

    @Test func pentatonicasBluesYHexacordos() {
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        #expect(notas(Escala(.do, .pentatonicaDominante)) == "Do Re Mi Sol Si♭")
        #expect(notas(Escala(.do, .pentatonicaMenorSexta)) == "Do Mi♭ Fa Sol La")
        #expect(notas(Escala(.do, .pentatonicaMayorSextaMenor)) == "Do Re Mi Sol La♭")
        #expect(notas(Escala(.do, .pentatonicaMenorQuintaDisminuida)) == "Do Mi♭ Fa Sol♭ Si♭")
        #expect(notas(Escala(.do, .bluesDeNueveNotas)) == "Do Re Mi♭ Mi Fa Sol♭ Sol La Si♭")
        #expect(notas(Escala(.do, .bluesMenorConSegunda)) == "Do Re Mi♭ Fa Sol♭ Sol Si♭")
        #expect(notas(.hexacordoNatural) == "Do Re Mi Fa Sol La")
        #expect(notas(.hexacordoDuro) == "Sol La Si Do Re Mi")
        #expect(notas(.hexacordoBlando) == "Fa Sol La Si♭ Do Re")
        #expect(Escala("Do pentatónica de Coltrane").tipo == .pentatonicaMayorSextaMenor)
        #expect(Escala("C dominant pentatonic").tipo == .pentatonicaDominante)
        #expect(Escala("Sol hexacordo").tipo == .hexacordo)
        #expect(Escala(.do, .bluesDeNueveNotas).nombre(en: .ascii(.ingles)) == "C nine tone blues")
        // Alias de escalas que ya estaban.
        #expect(Escala("Do mayor melódica").tipo == .mixolidioSextaMenor)
        #expect(Escala("Sol dominante b9 b13").tipo == .frigioDominante)
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
    }

    @Test func modosDeLaMayorHungaraPentatonicasYAliasDeCompositor() {
        func notas(_ escala: Escala) -> String { escala.notas.map(\.description).joined(separator: " ") }
        // Las rotaciones de la mayor húngara (Do Re♯ Mi Fa♯ Sol La Si♭) dan sus seis modos.
        let hungara = Escala(.do, .mayorHungara)
        let modos: [(TipoDeEscala, String)] = [
            (.ultralocrioSextaDisminuida, "Re♯ Mi Fa♯ Sol La Si♭ Do"),
            (.menorArmonicaQuintaDisminuida, "Mi Fa♯ Sol La Si♭ Do Re♯"),
            (.superlocrioSextaNatural, "Fa♯ Sol La Si♭ Do Re♯ Mi"),
            (.menorMelodicaQuintaAumentada, "Sol La Si♭ Do Re♯ Mi Fa♯"),
            (.doricoSegundaMenorCuartaAumentada, "La Si♭ Do Re♯ Mi Fa♯ Sol"),
            (.lidioAumentadoTerceraAumentada, "Si♭ Do Re♯ Mi Fa♯ Sol La"),
        ]
        for (i, (tipo, esperado)) in modos.enumerated() {
            #expect(hungara.modo(grado: i + 2).tipo.nombre == tipo.nombre)
            #expect(notas(Escala(hungara.grado(i + 2), tipo)) == esperado)
        }
        // Pentatónicas.
        #expect(notas(Escala(.do, .pentatonicaMixolidia)) == "Do Mi Fa Sol Si♭")
        #expect(notas(Escala(.do, .pentatonicaLidia)) == "Do Mi Fa♯ Sol Si")
        #expect(notas(Escala(.do, .pentatonicaEscocesa)) == "Do Re Fa Sol La")
        #expect(Escala(.do, .pentatonicaMayor).modo(grado: 4).tipo.nombre == "pentatónica escocesa")
        #expect(TipoDeEscala.egipcia.equivalentes.contains { $0.nombre == "Sléndro" })
        #expect(TipoDeEscala.pentatonicaLidia.equivalentes.contains { $0.nombre == "Amṛtavarṣiṇī" })
        #expect(TipoDeEscala.egipcia.equivalentes.contains { $0.nombre == "Megh" })
        // Otras.
        #expect(notas(Escala(.do, .mayorRumana)) == "Do Re♭ Mi Fa♯ Sol La Si♭")
        #expect(Set(Escala(.re, .hexatonicaMenorDeDosTriadas).notas) == Set(Acorde("Rem").notas + Acorde("Mim").notas))
        #expect(notas(Escala(.do, .sivaranjani)) == "Do Re Mi♭ Sol La")
        #expect(notas(Escala(.do, .kalavati)) == "Do Mi Sol La Si♭")
        #expect(notas(Escala(.do, .revati)) == "Do Re♭ Fa Sol Si♭")
        #expect(notas(Escala(.do, .candrakauns)) == "Do Mi♭ Fa La♭ Si")
        #expect(TipoDeEscala.occidentales.count == Set(TipoDeEscala.occidentales).count)
        // Nombres de compositor y otros alias.
        for (texto, nombre) in [
            ("La de Liszt", "menor húngara"), ("Do Rimski-Kórsakov", "disminuida semitono-tono"),
            ("Do de Debussy", "tonos enteros"), ("Do Weitzmann", "aumentada"),
            ("Do nordestina", "lidio dominante"), ("Do hindú", "mixolidio ♭6"),
            ("Do escocesa", "pentatónica escocesa"), ("Do superlocrio ♮6", "superlocrio ♮6"),
            ("C Romanian major", "mayor rumana"), ("Do Shivaranjani", "Śivarañjanī"),
            ("Do Chandrakauns", "Candrakauns"), ("Do Amritavarshini", "Amṛtavarṣiṇī"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
    }
}
