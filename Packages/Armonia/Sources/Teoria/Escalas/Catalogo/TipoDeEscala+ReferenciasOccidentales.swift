import Elementos

// MARK: - Dónde se leen las escalas occidentales
//
// Las occidentales no llevan las obras en su declaración: van aquí, por obras, y `TipoDeEscala.referencias` las junta.
// Una escala puede estar en varias. Las sintéticas de siete notas (`Estilo.sintetica`, las que salen de
// alterar los grados de otra) se citan por Busoni, que las cuenta todas sin nombrarlas. Las demás variantes que no
// trata ninguna obra general (las cromáticas con alteraciones, las pentatónicas y hexatónicas alteradas, las de ocho
// notas) no tienen.

extension TipoDeEscala {
    /// Cada obra con las escalas occidentales que trata.
    package static let referenciasOccidentales: [(obra: Referencia, tipos: [TipoDeEscala])] = [
        (.aldwell2011, [.mayor, .menorNatural, .menorArmonica, .menorMelodica, .cromatica]),
        (.powers2001, [.mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio]),
        (
            .levine1995,
            [
                .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio, .menorMelodicaJazz,
                .doricoSegundaMenor, .lidioAumentado, .lidioDominante, .mixolidioSextaMenor, .locrioSegundaNatural,
                .alterada, .pentatonicaMayor, .pentatonicaMenor, .blues, .tonosEnteros, .disminuida,
                .disminuidaSemitonoTono, .bebopDominante, .bebopMayor, .bebopDorico, .bebopMenorMelodica,
            ]
        ),
        (.messiaen1944, [.tonosEnteros, .disminuida, .messiaen3, .messiaen4, .messiaen5, .messiaen6, .messiaen7]),
        (
            .persichetti1961,
            [
                .pentatonicaMayor, .tonosEnteros, .lidioDominante, .mayorLocria, .lidioMenor, .napolitanaMayor,
                .napolitanaMenor, .menorHungara, .mayorHungara, .enigmatica, .oriental, .alterada,
                .lidioAumentadoSextaAumentada, .dobleArmonica, .prometeo, .prometeoNapolitano,
            ]
        ),
        (.lendvai1971, [.lidioDominante, .disminuidaSemitonoTono, .aumentadaSemitonoTercera]),
        (.slonimsky1947, [.aumentadaSemitonoTercera, .petrushkaMenor]),
        (.slonimsky1968, [.tcherepnin]),
        (.burke2015, [.enigmatica]),
        (.tymoczko2011, [.lidioDominante, .tonosEnteros, .disminuida, .aumentada, .menorArmonica, .mayorArmonica]),
        (.cohn1996, [.aumentada]),
        (.taruskin1987, [.disminuida, .petrushka]),
        (.samson1977, [.prometeo]),
        (.manuel1989, [.flamenca, .frigioDominante]),
        (.vanDerMerwe1989, [.pentatonicaMayor, .pentatonicaMenor, .blues, .bluesMayor]),
        (.apel1958, [.hexacordo]),
        (
            .rechberger2008,
            [
                .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio, .pentatonicaMayor,
                .pentatonicaMenor, .menorHungara, .eolicoCuartaAumentada, .dobleArmonica,
            ]
        ),
        (
            .busoni1916,
            [
                .locrioSextaNatural, .jonicoAumentado, .doricoCuartaAumentada, .lidioSegundaAumentada, .ultralocrio,
                .doricoQuintaDisminuida, .frigioCuartaDisminuida, .lidioTerceraMenor, .mixolidioSegundaMenor,
                .lidioAumentadoSegundaAumentada, .locrioSeptimaDisminuida, .persa, .lidioSegundaSextaAumentadas,
                .ultrafrigio, .jonicoSegundaQuintaAumentadas, .locrioTerceraSeptimaDisminuidas,
                .lidioAumentadoSextaAumentada, .lidioDominanteAumentado, .locrioSegundaNaturalCuartaDisminuida,
                .superlocrioTerceraDisminuida, .lidioSextaAumentada, .mixolidioAumentado, .locrioDominante,
                .jonicoSegundaAumentada, .ultralocrioTerceraDisminuida, .mayorRumana, .ultralocrioSextaDisminuida,
                .menorArmonicaQuintaDisminuida, .superlocrioSextaNatural, .menorMelodicaQuintaAumentada,
                .doricoSegundaMenorCuartaAumentada, .lidioAumentadoTerceraAumentada, .jonicoSegundaMenor,
                .jonicoQuintaDisminuida, .jonicoSextaAumentada,
            ]
        ),
    ]
}
