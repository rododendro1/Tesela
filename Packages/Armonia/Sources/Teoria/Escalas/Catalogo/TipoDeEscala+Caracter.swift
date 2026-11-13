import Elementos

// MARK: - El carácter de las escalas del catálogo
//
// Lo que cada fuente dice de cada escala (`CaracterDeEscala`), por tradición. Solo entran las escalas con una fuente;
// las demás no tienen carácter. Va por el nombre: el jónico no toma el de Bilāval aunque tengan las mismas notas. Los
// thāṭ llevan el del rāga que les da nombre (Bhairav, Toḍī), que es el que describen las fuentes.

extension TipoDeEscala {
    /// Cada escala con lo que dicen de ella sus fuentes.
    package static let caracteres: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] =
        caracteresGriegos + caracteresGregorianos + caracteresIndios + caracteresJavaneses + caracteresChinos

    // MARK: Grecia antigua
    //
    // Platón habla de las harmoniai antiguas, las de Arístides; Aristóteles, los Problemas y Heraclides, de las
    // especies de octava. Se leen en Monro 1894, que las reúne y las traduce.

    private static let platon = Referencia.monro1894.paginas("7–8")
    private static let heraclides = Referencia.monro1894.paginas("9–11")
    private static let aristoteles = Referencia.monro1894.paginas("12–13")
    private static let problemas = Referencia.monro1894.paginas("14–15")

    private static let caracteresGriegos: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] = [
        (
            .harmoniaMixolidiaDeAristides,
            [.init([.lastimero], ocasion: .lamento, testigo: .platon, pasaje: "398e", fuente: platon)]
        ),
        (
            .harmoniaSintonolidiaDeAristides,
            [.init([.lastimero], ocasion: .lamento, testigo: .platon, pasaje: "398e", fuente: platon)]
        ),
        (
            .harmoniaLidiaDeAristides,
            [.init([.blando], ocasion: .banquete, testigo: .platon, pasaje: "398e", fuente: platon)]
        ),
        (
            .harmoniaIastiaDeAristides,
            [
                .init([.blando], ocasion: .banquete, testigo: .platon, pasaje: "398e", fuente: platon),
                .init([.severo], testigo: .heraclides, pasaje: "XIV 624–625", fuente: heraclides),
            ]
        ),
        (
            .harmoniaDoriaDeAristides,
            [.init([.valiente], ocasion: .guerra, testigo: .platon, pasaje: "399a", fuente: platon)]
        ),
        (.harmoniaFrigiaDeAristides, [.init([.templado], testigo: .platon, pasaje: "399a–c", fuente: platon)]),
        (
            .harmoniaMixolidia,
            [.init([.lastimero, .triste], testigo: .aristoteles, pasaje: "1340a–b", fuente: aristoteles)]
        ),
        (
            .harmoniaDoria,
            [
                .init(
                    [.valiente, .majestuoso, .severo], testigo: .heraclides, pasaje: "XIV 624–625", fuente: heraclides),
                .init([.grave, .sereno], testigo: .aristoteles, pasaje: "1340b, 1342b", fuente: aristoteles),
            ]
        ),
        (
            .harmoniaFrigia,
            [.init([.entusiasta], testigo: .aristoteles, pasaje: "1340b, 1342b", fuente: aristoteles)]
        ),
        (
            .harmoniaHipodoria,
            [
                .init([.alegre, .majestuoso], testigo: .heraclides, pasaje: "XIV 624–625", fuente: heraclides),
                .init([.majestuoso, .sereno], testigo: .problemas, pasaje: "XIX.48", fuente: problemas),
            ]
        ),
        (.harmoniaHipofrigia, [.init([.energico], testigo: .problemas, pasaje: "XIX.48", fuente: problemas)]),
    ]

    // MARK: Canto gregoriano
    //
    // Cotón (Johannes Afflighemensis) da a cada tono su carácter en el De musica, hacia 1100.

    private static func coton(_ afectos: [Afecto]) -> [CaracterDeEscala] {
        [.init(afectos, testigo: .coton, fuente: .babb1978)]
    }

    private static let caracteresGregorianos: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] = [
        (.protusAuthenticus, coton([.grave, .noble])),
        (.protusPlagalis, coton([.grave])),
        (.deuterusAuthenticus, coton([.severo])),
        (.deuterusPlagalis, coton([.tierno])),
        (.tritusAuthenticus, coton([.alegre])),
        (.tritusPlagalis, coton([.lastimero])),
        (.tetrardusAuthenticus, coton([.festivo])),
        (.tetrardusPlagalis, coton([.noble, .sereno])),
    ]

    // MARK: India
    //
    // La hora (en prahar de tres horas), la estación y el carácter de cada rāga, de The Raga Guide.

    private static func bor(
        _ momento: MomentoDelDia?, _ afectos: [Afecto], estacion: Estacion? = nil
    ) -> [CaracterDeEscala] {
        [.init(afectos, momento: momento, estacion: estacion, fuente: .bor1999)]
    }

    private static let caracteresIndios: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] = [
        (.lalit, bor(.madrugada, [.inquieto, .contemplativo])),
        (.bhairav, bor(.manana, [.devoto, .solemne, .grave])),
        (.bhairavi, bor(.manana, [.devoto, .tierno])),
        (.bilaval, bor(.manana, [.sereno])),
        (.todi, bor(.finalDeLaManana, [.lastimero, .tierno])),
        (.asavari, bor(.finalDeLaManana, [.lastimero])),
        (.bhimpalasi, bor(.primeraHoraDeLaTarde, [.tierno, .nostalgico])),
        (.marva, bor(.tarde, [.inquieto, .grave])),
        (.purvi, bor(.tarde, [.grave, .devoto])),
        (.puriyaDhanasri, bor(.tarde, [.devoto])),
        (.yaman, bor(.anochecer, [.amoroso, .devoto, .sereno])),
        (.bhupali, bor(.anochecer, [.sereno, .devoto])),
        (.bihag, bor(.noche, [.amoroso])),
        (.des, bor(.noche, [.amoroso], estacion: .lluvias)),
        (.khamaj, bor(.noche, [.amoroso])),
        (.durga, bor(.noche, [.alegre])),
        (.darbariKanada, bor(.medianoche, [.majestuoso, .grave])),
        (.malkauns, bor(.medianoche, [.grave, .contemplativo])),
        (.bagesri, bor(.medianoche, [.nostalgico, .amoroso])),
        (.megh, bor(nil, [.grave], estacion: .lluvias)),
    ]

    // MARK: Java
    //
    // En el wayang kulit, cada pathet del sléndro tiene su parte de la noche.

    private static let caracteresJavaneses: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] = [
        (.slendroNem, [.init([.sereno, .grave], momento: .noche, fuente: .hood1954)]),
        (.slendroSanga, [.init([.energico], momento: .medianoche, fuente: .hood1954)]),
        (.slendroManyura, [.init([.alegre], momento: .madrugada, fuente: .hood1954)]),
    ]

    // MARK: China
    //
    // Lo que representa cada modo en el Yueji y su fase y su estación en el Lüshi Chunqiu, en DeWoskin 1982.

    private static func chino(
        _ papel: PapelDeLaNota, _ fase: FaseDeLaNaturaleza, _ estacion: Estacion?
    ) -> [CaracterDeEscala] {
        [
            .init(estacion: estacion, fase: fase, testigo: .lushiChunqiu, fuente: .dewoskin1982),
            .init(papel: papel, testigo: .yueji, fuente: .dewoskin1982),
        ]
    }

    private static let caracteresChinos: [(tipo: TipoDeEscala, caracter: [CaracterDeEscala])] = [
        (.gong, chino(.soberano, .tierra, nil)),
        (.shang, chino(.ministro, .metal, .otono)),
        (.jue, chino(.pueblo, .madera, .primavera)),
        (.zhi, chino(.asuntos, .fuego, .verano)),
        (.yu, chino(.cosas, .agua, .invierno)),
    ]

    /// Identidad → lo que dicen sus fuentes, en orden cronológico.
    package static let caracterPorIdentidad: [IdentidadDeEscala: [CaracterDeEscala]] = {
        var tabla: [IdentidadDeEscala: [CaracterDeEscala]] = [:]
        for (tipo, caracter) in caracteres { tabla[tipo.identidad, default: []] += caracter }
        return tabla.mapValues { lista in
            lista.enumerated().sorted { ($0.element.anio ?? .max, $0.offset) < ($1.element.anio ?? .max, $1.offset) }
                .map(\.element)
        }
    }()

    /// Lo que dicen las fuentes del carácter de la escala, en orden cronológico; vacío si ninguna dice nada (los
    /// mēḷa, las sintéticas, casi todas las occidentales). Es del nombre, no de las notas: va por su identidad, y el
    /// jónico no tiene el de Bilāval.
    ///
    ///     TipoDeEscala.harmoniaDoria.caracter.map(\.testigo)   // [.heraclides, .aristoteles]
    ///     TipoDeEscala.bhairav.caracter[0].momento             // .manana
    ///     TipoDeEscala.mayor.caracter                          // []
    public var caracter: [CaracterDeEscala] { TipoDeEscala.caracterPorIdentidad[identidad] ?? [] }

    /// Los afectos de todas sus fuentes, sin repetir, en el orden en que salen.
    ///
    ///     TipoDeEscala.harmoniaDoria.afectos   // [.valiente, .majestuoso, .severo, .grave, .sereno]
    public var afectos: [Afecto] {
        var vistos = Set<Afecto>()
        return caracter.flatMap(\.afectos).filter { vistos.insert($0).inserted }
    }

    /// Los momentos del día en que se toca, sin repetir.
    public var momentos: [MomentoDelDia] {
        var vistos = Set<MomentoDelDia>()
        return caracter.compactMap(\.momento).filter { vistos.insert($0).inserted }
    }
}
