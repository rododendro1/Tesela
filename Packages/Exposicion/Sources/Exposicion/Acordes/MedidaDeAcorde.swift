import Armonia

// MARK: - Cada medida de un acorde, descrita una sola vez

/// Una medida de un acorde (`EstadisticasDeAcorde`), descrita una sola vez: su clave en el JSON y en el TSV, su título
/// en `TextosDeApps` y cómo se escribe su valor, en texto y en JSON. La lista de la consola y de la app
/// (`PresentacionDeEstadisticasDeAcorde.estadisticas(_:sobre:en:)`), la tabla, el JSON (`EstadisticasDeAcordePresentadas`) y el
/// TSV de acordes de `EjemploCatalogos` recorren `MedidaDeAcorde.todas`, así que una medida nueva se añade aquí y sale
/// en todas partes.
///
/// Unas medidas solo van al JSON (`porTerceras`, `cardinal`…: en el texto se leen en «Rasgos» o junto al número de
/// notas) y otras solo al texto (`rasgos`): las primeras no tienen título y las segundas no tienen valor.
///
///     let consonancia = MedidaDeAcorde.medida("consonanciaDiadica")!
///     consonancia.titulo(en: .compacta(.espanol))                                       // "Consonancia diádica (Huron)"
///     consonancia.texto(de: TipoDeAcorde.mayor.estadisticas, en: .compacta(.espanol))  // "2.22"
public struct MedidaDeAcorde: Sendable {
    /// La clave en el JSON y la columna del TSV: «consonanciaDiadica».
    public let clave: String
    let campo: (@Sendable (TextosDeApps) -> String)?
    let escribir: (@Sendable (EstadisticasDeAcorde, Contexto) -> String?)?
    let enJSON: (@Sendable (EstadisticasDeAcorde, Contexto) -> ValorDeMedida?)?

    /// La nota sobre la que se escriben las fundamentales (o ninguna, y van como intervalos) y la notación.
    struct Contexto {
        let sobre: Nota?
        let notacion: Notacion

        func nota(_ intervalo: Intervalo) -> String {
            sobre.map { ($0 + intervalo).nombre(en: notacion) } ?? intervalo.abreviatura(en: notacion)
        }
    }

    /// Si se escribe en texto: si tiene título.
    public var enTexto: Bool { campo != nil }

    /// Si va al JSON.
    public var vaAlJSON: Bool { enJSON != nil }

    /// Su título en la notación: «Consonancia diádica (Huron)»; `nil` si solo va al JSON.
    public func titulo(en notacion: Notacion) -> String? { campo.map { notacion.texto($0) } }

    /// Su valor escrito para leerlo: «2.22», «+0.75», «Sol (20) · Fa (11)»; `nil` si el acorde no la tiene o si solo
    /// va al JSON. Con `sobre`, las fundamentales son notas sobre esa; sin ella, intervalos.
    public func texto(de estadisticas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion) -> String? {
        escribir?(estadisticas, Contexto(sobre: sobre, notacion: notacion))
    }

    /// Su valor para el JSON, con los decimales exactos; `nil` si el acorde no la tiene o si solo va al texto.
    public func valor(de estadisticas: EstadisticasDeAcorde, sobre: Nota? = nil, en notacion: Notacion)
        -> ValorDeMedida?
    {
        enJSON?(estadisticas, Contexto(sobre: sobre, notacion: notacion))
    }

    /// La medida de esa clave.
    public static func medida(_ clave: String) -> MedidaDeAcorde? { todas.first { $0.clave == clave } }

    /// Todas, en el orden en que se leen.
    public static let todas: [MedidaDeAcorde] = [
        MedidaDeAcorde(
            "numeroDeNotas", { $0.numeroDeNotas },
            texto: { m, c in "\(m.numeroDeNotas)" + (m.cardinal.map { " (" + $0.nombre(en: c.notacion) + ")" } ?? "") },
            valor: { m, _ in .entero(m.numeroDeNotas) }),
        MedidaDeAcorde("cardinal", valor: { m, c in m.cardinal.map { .texto($0.nombre(en: c.notacion)) } }),
        MedidaDeAcorde("porTerceras", valor: { m, _ in .booleano(m.porTerceras) }),
        MedidaDeAcorde("tensiones", { $0.tensiones }, entero: { m in m.tensiones }),
        MedidaDeAcorde(
            "brilloPorQuintas", { $0.brilloPorQuintas },
            texto: { m, _ in m.brilloPorQuintas.map(PresentacionDeEstudioDeEscala.conSigno) },
            valor: { m, _ in m.brilloPorQuintas.map { .decimal(Redondeo.valor($0, decimales: 2)) } }),
        MedidaDeAcorde("amplitudEnQuintas", { $0.amplitudEnQuintas }, entero: { m in m.amplitudEnQuintas }),
        MedidaDeAcorde(
            "vectorIntervalico", { $0.vectorIntervalico }, texto: { m, _ in "[" + lista(m.vectorIntervalico) + "]" },
            valor: { m, _ in .enteros(m.vectorIntervalico) }),
        MedidaDeAcorde(
            "formaPrima", { $0.formaPrima }, texto: { m, _ in "(" + lista(m.formaPrima) + ")" },
            valor: { m, _ in .enteros(m.formaPrima) }),
        MedidaDeAcorde("numeroDeForte", { $0.numeroDeForte }, cadena: { m in m.numeroDeForte }),
        MedidaDeAcorde(
            "transposicionesDistintas", { $0.transposicionesDistintas }, entero: { m in m.transposicionesDistintas }),
        MedidaDeAcorde("simetricoPorInversion", valor: { m, _ in .booleano(m.simetricoPorInversion) }),
        MedidaDeAcorde("anhemitonico", valor: { m, _ in .booleano(m.anhemitonico) }),
        MedidaDeAcorde("conTritono", valor: { m, _ in .booleano(m.conTritono) }),
        MedidaDeAcorde("ambito", { $0.ambito }, entero: { m in m.ambito }),
        MedidaDeAcorde(
            "rasgos", { $0.rasgos },
            texto: { m, c in
                let rasgos = PresentacionDeEstadisticasDeAcorde.rasgos(m, en: c.notacion)
                return rasgos.isEmpty ? nil : rasgos
            }, valor: nil),
        MedidaDeAcorde(
            "consonanciaDiadica", { $0.consonanciaDiadica }, decimal: { m in m.conjunto.consonanciaDiadica }),
        MedidaDeAcorde(
            "grupoDeHindemith", { $0.grupoDeHindemith },
            cadena: { m in m.disposicionDeVoces.grupoDeHindemith.description }),
        MedidaDeAcorde(
            "fundamentalDeHindemith", { $0.fundamentalDeHindemith },
            nota: { m in m.disposicionDeVoces.fundamentalDeHindemith }),
        MedidaDeAcorde(
            "prominenciasDeParncutt", { $0.fundamentalDeParncutt },
            texto: { m, c in
                let prominencias = m.psicoacustica.prominenciasDeParncutt
                return prominencias.isEmpty
                    ? nil : prominencias.map { c.nota($0.intervalo) + " (\($0.peso))" }.joined(separator: " · ")
            },
            valor: { m, c in
                .lista(
                    m.psicoacustica.prominenciasDeParncutt.map {
                        .objeto([.init("nota", .texto(c.nota($0.intervalo))), .init("peso", .entero($0.peso))])
                    })
            }),
        MedidaDeAcorde(
            "intervalosEntreVoces", { $0.intervalosEntreVoces },
            texto: { m, _ in
                let intervalos = m.disposicionDeVoces.intervalosEntreVoces
                return intervalos.isEmpty ? nil : intervalos.map(String.init).joined(separator: " ")
            }, valor: { m, _ in .enteros(m.disposicionDeVoces.intervalosEntreVoces) }),
        MedidaDeAcorde("gradoDeSuavidad", { $0.gradoDeSuavidad }, entero: { m in m.afinacion.gradoDeSuavidad }),
        MedidaDeAcorde(
            "magnitudesDeFourier", { $0.coeficientesDeFourier },
            texto: { m, _ in m.conjunto.magnitudesDeFourier.map { Redondeo.texto($0) }.joined(separator: " · ") },
            valor: { m, _ in .decimales(m.conjunto.magnitudesDeFourier) }),
        MedidaDeAcorde(
            "distanciaALaUniformidad", { $0.distanciaALaUniformidad },
            decimal: { m in m.conjunto.distanciaALaUniformidad }),
        MedidaDeAcorde(
            "triadasContenidas", { $0.triadasContenidas },
            texto: { m, _ in PresentacionDeEstadisticasDeAcorde.triadas(m.conjunto.triadasContenidas) },
            valor: { m, _ in
                let triadas = m.conjunto.triadasContenidas
                return .objeto([
                    .init("mayores", .entero(triadas.mayores)), .init("menores", .entero(triadas.menores)),
                    .init("disminuidas", .entero(triadas.disminuidas)),
                    .init("aumentadas", .entero(triadas.aumentadas)),
                ])
            }),
        MedidaDeAcorde("tensionDeCook", { $0.tensionDeCook }, decimal: { m in m.psicoacustica.tensionDeCook }),
        MedidaDeAcorde(
            "modalidadDeCook", { $0.modalidadDeCook },
            texto: { m, _ in PresentacionDeEstudioDeEscala.conSigno(m.psicoacustica.modalidadDeCook) },
            valor: { m, _ in .decimal(m.psicoacustica.modalidadDeCook) }),
        MedidaDeAcorde("rugosidad", { $0.rugosidad }, decimal: { m in m.psicoacustica.rugosidad }),
        MedidaDeAcorde(
            "rugosidadDeVassilakis", { $0.rugosidadDeVassilakis },
            decimal: { m in m.psicoacustica.rugosidadDeVassilakis }),
        MedidaDeAcorde(
            "rugosidadDeHutchinsonKnopoff", { $0.rugosidadDeHutchinsonKnopoff },
            decimal: { m in m.psicoacustica.rugosidadDeHutchinsonKnopoff }),
        MedidaDeAcorde("fusionTonal", { $0.fusionTonal }, decimal: { m in m.psicoacustica.fusionTonal }),
        MedidaDeAcorde("alturaDeTenney", { $0.alturaDeTenney }, decimal: { m in m.afinacion.alturaDeTenney }),
        MedidaDeAcorde("limiteImpar", { $0.limiteImpar }, entero: { m in m.afinacion.limiteImpar }),
        MedidaDeAcorde("limitePrimo", { $0.limitePrimo }, entero: { m in m.afinacion.limitePrimo }),
        MedidaDeAcorde(
            "armonicidad", { $0.armonicidad },
            texto: { m, _ in Redondeo.texto(m.afinacion.armonicidad, decimales: 1) },
            valor: { m, _ in .decimal(m.afinacion.armonicidad) }),
        MedidaDeAcorde(
            "entropiaArmonica", { $0.entropiaArmonica }, decimal: { m in m.psicoacustica.entropiaArmonica }),
        MedidaDeAcorde(
            "fundamentalVirtual", { $0.fundamentalVirtual }, nota: { m in m.psicoacustica.fundamentalVirtual }),
        MedidaDeAcorde("parejaZ", { $0.parejaZ }, cadena: { m in m.conjunto.parejaZ }),
        MedidaDeAcorde("complemento", { $0.complementoDeForte }, cadena: { m in m.conjunto.complemento }),
        MedidaDeAcorde(
            "disposicion", { $0.disposicion },
            texto: { m, c in PresentacionDeEstadisticasDeAcorde.disposicion(m, en: c.notacion) },
            valor: { m, c in
                .texto(
                    m.disposicionDeVoces.disposicion?.nombre(en: c.notacion)
                        ?? c.notacion.texto(\.disposicionAbierta))
            }),
        MedidaDeAcorde(
            "respetaLaSerieArmonica", valor: { m, _ in .booleano(m.disposicionDeVoces.respetaLaSerieArmonica) }),
    ]

    private static func lista(_ numeros: [Int]) -> String { numeros.map(String.init).joined(separator: ", ") }
}

// MARK: - Cómo se construyen

extension MedidaDeAcorde {
    /// Con título, texto y valor.
    init(
        _ clave: String, _ campo: @escaping @Sendable (TextosDeApps) -> String,
        texto: @escaping @Sendable (EstadisticasDeAcorde, Contexto) -> String?,
        valor: (@Sendable (EstadisticasDeAcorde, Contexto) -> ValorDeMedida?)?
    ) {
        self.clave = clave
        self.campo = campo
        self.escribir = texto
        self.enJSON = valor
    }

    /// Solo para el JSON: sin título ni texto.
    init(_ clave: String, valor: @escaping @Sendable (EstadisticasDeAcorde, Contexto) -> ValorDeMedida?) {
        self.clave = clave
        self.campo = nil
        self.escribir = nil
        self.enJSON = valor
    }

    /// Un entero, que se escribe tal cual.
    init(
        _ clave: String, _ campo: @escaping @Sendable (TextosDeApps) -> String,
        entero: @escaping @Sendable (EstadisticasDeAcorde) -> Int?
    ) {
        self.init(
            clave, campo, texto: { m, _ in entero(m).map(String.init) },
            valor: { m, _ in entero(m).map { .entero($0) } })
    }

    /// Un decimal: exacto en el JSON y con tres decimales como mucho en el texto.
    init(
        _ clave: String, _ campo: @escaping @Sendable (TextosDeApps) -> String,
        decimal: @escaping @Sendable (EstadisticasDeAcorde) -> Double
    ) {
        self.init(clave, campo, texto: { m, _ in Redondeo.texto(decimal(m)) }, valor: { m, _ in .decimal(decimal(m)) })
    }

    /// Un texto que no cambia con la notación: «4-27», «II a».
    init(
        _ clave: String, _ campo: @escaping @Sendable (TextosDeApps) -> String,
        cadena: @escaping @Sendable (EstadisticasDeAcorde) -> String?
    ) {
        self.init(clave, campo, texto: { m, _ in cadena(m) }, valor: { m, _ in cadena(m).map { .texto($0) } })
    }

    /// Una fundamental: una nota sobre la dada o un intervalo.
    init(
        _ clave: String, _ campo: @escaping @Sendable (TextosDeApps) -> String,
        nota: @escaping @Sendable (EstadisticasDeAcorde) -> Intervalo?
    ) {
        self.init(
            clave, campo, texto: { m, c in nota(m).map(c.nota) }, valor: { m, c in nota(m).map { .texto(c.nota($0)) } })
    }
}
