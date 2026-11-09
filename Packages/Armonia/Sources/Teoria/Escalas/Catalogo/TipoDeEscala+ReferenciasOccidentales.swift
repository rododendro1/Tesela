// MARK: - Dónde se leen las escalas occidentales
//
// Las occidentales no llevan las obras en su declaración: van aquí, por obras, y `TipoDeEscala.referencias` las junta.
// Una escala puede estar en varias. Las que solo salen de rotar o alterar otra (`EstiloDeEscala.sintetica`) y las
// variantes de otras que no trata ninguna obra general (las cromáticas con alteraciones, las pentatónicas alteradas)
// no tienen.

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
                .napolitanaMenor, .menorHungara, .mayorHungara, .enigmatica, .oriental,
            ]
        ),
        (.lendvai1971, [.lidioDominante]),
        (.tymoczko2011, [.lidioDominante, .tonosEnteros, .disminuida, .aumentada, .menorArmonica, .mayorArmonica]),
        (.cohn1996, [.aumentada]),
        (.taruskin1987, [.disminuida, .petrushka]),
        (.samson1977, [.prometeo]),
        (.manuel1989, [.flamenca, .frigioDominante]),
        (.vanDerMerwe1989, [.pentatonicaMayor, .pentatonicaMenor, .blues, .bluesMayor]),
        (.apel1958, [.hexacordo]),
    ]
}
