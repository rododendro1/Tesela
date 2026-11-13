import Armonia

/// Un dato con su nombre, de una escala o de un acorde: «Brillo por quintas: +2».
public struct DatoPresentado: Hashable, Sendable {
    public let nombre: String
    public let valor: String
}

/// El nombre de antes de `DatoPresentado`, cuando solo lo daban las escalas.
public typealias DatoDeEscalaPresentado = DatoPresentado

/// Un peldaño de la escalera de brillo: la escala, su brillo por quintas y la nota que sube desde el anterior.
public struct PeldanoDeBrilloPresentado: Hashable, Sendable {
    public let escala: Escala
    /// «Do lidio».
    public let nombre: String
    /// Su brillo por quintas: «+3».
    public let brillo: String
    /// La nota que sube desde el peldaño anterior: «Fa → Fa♯»; vacío en el primero.
    public let cambio: String
    /// Es la escala de la que se parte.
    public let esLaDePartida: Bool
    public let sonido: Escucha
}

extension PresentacionDeEstudioDeEscala {
    // MARK: Estadísticas

    /// Lo que se mide de una escala (`EstadisticasDeEscala`), un dato por fila, escrito en la notación: el número de
    /// notas con su cardinal, el brillo (solo en las de siete notas), el brillo por quintas, los pasos, el vector
    /// interválico, el número de Forte (si lo tiene), las transposiciones distintas y sus rasgos (si tiene alguno).
    ///
    ///     let datos = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do, .mayor),
    ///         en: .compacta(.espanol))
    ///     datos.prefix(8).map(\.valor)   // ["7 (heptatónica)", "0", "+2", "2 2 1 2 2 2 1", "[2, 5, 4, 3, 6, 1]", "7-35",
    ///                                    //  "12", "máximamente regular"]
    public static func estadisticas(de escala: Escala, en notacion: Notacion) -> [DatoPresentado] {
        let estadisticas = escala.estadisticas
        func dato(_ campo: (TextosDeApps) -> String, _ valor: String) -> DatoPresentado {
            DatoPresentado(nombre: notacion.texto(campo), valor: valor)
        }
        let cardinal = estadisticas.cardinal.map { " (" + $0.nombre(en: notacion) + ")" } ?? ""
        var datos = [dato(\.numeroDeNotas, "\(estadisticas.numeroDeNotas)" + cardinal)]
        // Un fragmento, con lo que abarca: «Fragmento: 4ª justa». Lo demás lo mide como si se repitiera a la octava.
        if let ambito = escala.tipo.ambito { datos.append(dato(\.fragmento, ambito.nombre(en: notacion))) }
        // Su afinación, si tiene una propia: «Afinación: microtonal», «octava en 5 partes iguales».
        if let afinacion = afinacion(de: escala.tipo, en: notacion) { datos.append(dato(\.afinacion, afinacion)) }
        if let brillo = estadisticas.brillo { datos.append(dato(\.brillo, conSigno(Double(brillo)))) }
        datos.append(dato(\.brilloPorQuintas, conSigno(estadisticas.brilloPorQuintas)))
        datos.append(dato(\.pasosEnSemitonos, estadisticas.pasos.map(String.init).joined(separator: " ")))
        let vector = estadisticas.vectorIntervalico.map(String.init).joined(separator: ", ")
        datos.append(dato(\.vectorIntervalico, "[" + vector + "]"))
        if let forte = estadisticas.numeroDeForte { datos.append(dato(\.numeroDeForte, forte)) }
        datos.append(dato(\.transposicionesDistintas, "\(estadisticas.transposicionesDistintas)"))
        let rasgos = [
            estadisticas.anhemitonica ? notacion.texto(\.anhemitonica) : nil,
            estadisticas.cohemitonica ? notacion.texto(\.cohemitonica) : nil,
            estadisticas.maximamenteRegular ? notacion.texto(\.maximamenteRegular) : nil,
            estadisticas.aproximada ? notacion.texto(\.medidaAproximada) : nil,
        ].compactMap { $0 }
        if !rasgos.isEmpty { datos.append(dato(\.rasgos, rasgos.joined(separator: " · "))) }
        return datos + teorias(estadisticas, en: notacion)
    }

    /// El carácter de la afinación de un tipo (`TipoDeEscala.caracterDeLaAfinacion`), escrito: «microtonal»,
    /// «justa», «octava en 5 partes iguales»; `nil` si no tiene una propia.
    ///
    ///     PresentacionDeEstudioDeEscala.afinacion(de: .bayati, en: .compacta(.espanol))   // "microtonal"
    public static func afinacion(de tipo: TipoDeEscala, en notacion: Notacion) -> String? {
        switch tipo.caracterDeLaAfinacion {
        case nil: nil
        case .temperada: notacion.texto(\.afinacionTemperada)
        case .justa: notacion.texto(\.afinacionJusta)
        case .microtonal: notacion.texto(\.afinacionMicrotonal)
        case .partesIguales(let partes): notacion.texto { $0.afinacionEnPartesIguales(partes) }
        }
    }

    /// Lo que dicen de la escala las teorías, un dato por fila: Myhill, Rothenberg, Carey, Hanson, Messiaen, Forte,
    /// Zeitler, la armonización por grados, Babbitt, Fourier, Tymoczko, la afinación justa, Sethares, Krumhansl y
    /// Kessler, y sus propiedades.
    static func teorias(_ estadisticas: EstadisticasDeEscala, en notacion: Notacion) -> [DatoPresentado] {
        func dato(_ campo: (TextosDeApps) -> String, _ valor: String) -> DatoPresentado {
            DatoPresentado(nombre: notacion.texto(campo), valor: valor)
        }
        let decimal = { (valor: Double) in Redondeo.texto(valor) }
        var datos = [dato(\.consonanciaDiadica, decimal(estadisticas.conjunto.consonanciaDiadica))]
        if let generador = estadisticas.intervalosGenericos.generador {
            datos.append(dato(\.generador, "\(generador)"))
        }
        datos.append(
            dato(
                \.propiedadDeRothenberg, propiedad(estadisticas.intervalosGenericos.propiedadDeRothenberg, en: notacion)
            ))
        datos.append(
            dato(
                \.ambiguedades,
                "\(estadisticas.intervalosGenericos.ambiguedades) · \(estadisticas.intervalosGenericos.contradicciones)"
            ))
        datos.append(dato(\.estabilidad, decimal(estadisticas.intervalosGenericos.estabilidad)))
        datos.append(dato(\.cocienteDeIgualdad, decimal(estadisticas.intervalosGenericos.cocienteDeIgualdad)))
        datos.append(dato(\.anchuraDelEspectro, decimal(estadisticas.intervalosGenericos.anchuraDelEspectro)))
        datos.append(dato(\.analisisDeHanson, estadisticas.conjunto.analisisDeHanson))
        if let modo = estadisticas.conjunto.modoDeMessiaen { datos.append(dato(\.modoDeMessiaen, "\(modo)")) }
        if let pareja = estadisticas.conjunto.parejaZ { datos.append(dato(\.parejaZ, pareja)) }
        if let complemento = estadisticas.conjunto.complemento { datos.append(dato(\.complementoDeForte, complemento)) }
        datos.append(dato(\.imperfecciones, "\(estadisticas.conjunto.imperfecciones)"))
        if let triadas = estadisticas.tonal.triadas {
            datos.append(dato(\.triadasPorGrados, grados(triadas).joined(separator: " ")))
        }
        if let cuatriadas = estadisticas.tonal.cuatriadas {
            datos.append(dato(\.cuatriadasPorGrados, grados(cuatriadas).joined(separator: " ")))
        }
        if let combinatoriedad = estadisticas.conjunto.combinatoriedad {
            datos.append(dato(\.combinatoriedadHexacordal, self.combinatoriedad(combinatoriedad)))
        }
        datos.append(
            dato(
                \.coeficientesDeFourier, estadisticas.conjunto.magnitudesDeFourier.map(decimal).joined(separator: " · ")
            ))
        datos.append(dato(\.distanciaALaUniformidad, decimal(estadisticas.conjunto.distanciaALaUniformidad)))
        datos.append(
            dato(
                \.triadasContenidas, PresentacionDeEstadisticasDeAcorde.triadas(estadisticas.conjunto.triadasContenidas)
            ))
        datos.append(dato(\.entropiaIntervalica, decimal(estadisticas.conjunto.entropiaIntervalica)))
        datos.append(dato(\.parsimonia, "\(estadisticas.conjunto.parsimonia)"))
        datos.append(dato(\.gradoDeSuavidad, "\(estadisticas.afinacion.gradoDeSuavidad)"))
        datos.append(dato(\.alturaDeTenney, decimal(estadisticas.afinacion.alturaDeTenney)))
        datos.append(dato(\.limiteImpar, "\(estadisticas.afinacion.limiteImpar)"))
        datos.append(dato(\.entropiaArmonica, decimal(estadisticas.psicoacustica.entropiaArmonica)))
        datos.append(dato(\.rugosidadMedia, decimal(estadisticas.psicoacustica.rugosidadMedia)))
        datos.append(
            dato(
                \.perfilTonal,
                "M \(decimal(estadisticas.tonal.perfilMayor)) · m \(decimal(estadisticas.tonal.perfilMenor))"))
        let propiedades = self.propiedades(estadisticas, en: notacion)
        if !propiedades.isEmpty { datos.append(dato(\.propiedades, propiedades)) }
        return datos
    }

    /// «estrictamente propia», «propia», «impropia».
    public static func propiedad(_ propiedad: PropiedadDeRothenberg, en notacion: Notacion) -> String {
        switch propiedad {
        case .estrictamentePropia: return notacion.texto(\.estrictamentePropia)
        case .propia: return notacion.texto(\.propia)
        case .impropia: return notacion.texto(\.impropia)
        }
    }

    /// Los acordes de cada grado en números romanos, en minúscula los menores y disminuidos: «I ii iii IV V vi vii°»,
    /// «Imaj7 ii7 iii7 IVmaj7 V7 vi7 viiø7». Un grado sin acorde conocido lleva «?».
    public static func grados(_ acordes: [TipoDeAcorde?]) -> [String] {
        let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
        return acordes.enumerated().map { i, acorde in
            let romano = i < romanos.count ? romanos[i] : "\(i + 1)"
            guard let acorde else { return romano + "?" }
            return (acorde.esMenor ? romano.lowercased() : romano) + acorde.sufijoRomano
        }
    }

    /// Lo mismo, desde los cifrados de los acordes: «m7» en el 2.º grado es «ii7».
    public static func grados(_ cifrados: [String]) -> [String] {
        let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
        return cifrados.enumerated().map { i, cifrado in
            let romano = i < romanos.count ? romanos[i] : "\(i + 1)"
            if cifrado.hasPrefix("m") && !cifrado.hasPrefix("maj") { return romano.lowercased() + cifrado.dropFirst(1) }
            if cifrado.hasPrefix("°") || cifrado.hasPrefix("ø") { return romano.lowercased() + cifrado }
            return romano + cifrado
        }
    }

    /// «T6 · I3 · I9 (A)»: las transposiciones y las inversiones que la completan, y la letra de Babbitt.
    public static func combinatoriedad(_ combinatoriedad: CombinatoriedadHexacordal) -> String {
        let operaciones =
            combinatoriedad.transposiciones.map { "T\($0)" } + combinatoriedad.inversiones.map { "I\($0)" }
        return operaciones.joined(separator: " · ") + (combinatoriedad.tipo.map { " (\($0))" } ?? "")
    }

    /// Sus propiedades, separadas por « · »: «propiedad de Myhill · bien formada (MOS) · profunda (Gamer)…»; vacío si
    /// no tiene ninguna.
    public static func propiedades(_ estadisticas: EstadisticasDeEscala, en notacion: Notacion) -> String {
        [
            estadisticas.intervalosGenericos.propiedadDeMyhill ? notacion.texto(\.propiedadDeMyhill) : nil,
            estadisticas.intervalosGenericos.bienFormada ? notacion.texto(\.bienFormada) : nil,
            estadisticas.conjunto.profundo ? notacion.texto(\.escalaProfunda) : nil,
            estadisticas.conjunto.equilibrado ? notacion.texto(\.equilibrada) : nil,
            estadisticas.conjunto.simetricoPorInversion ? notacion.texto(\.simetricaPorInversion) : nil,
            estadisticas.conjunto.unicidad ? notacion.texto(\.unicidad) : nil,
            estadisticas.conjunto.simplicidad ? notacion.texto(\.simplicidad) : nil,
            estadisticas.tonal.conSensible ? notacion.texto(\.conSensible) : nil,
            estadisticas.tonal.tetracordosIguales ? notacion.texto(\.tetracordosIguales) : nil,
        ].compactMap { $0 }.joined(separator: " · ")
    }

    /// Varias escalas en una tabla, una por fila: el nombre, las notas, el brillo por quintas, los pasos, el vector
    /// interválico, el número de Forte y los rasgos, para compararlas de un vistazo.
    ///
    ///     let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(
    ///         [Escala(.do), Escala(.do, .lidio)], en: .compacta(.espanol))
    ///     tabla.filas[1][2]   // "+3"
    public static func tablaDeEstadisticas(
        _ escalas: [Escala], en notacion: Notacion
    ) -> (encabezados: [String], filas: [[String]]) {
        let encabezados = [
            notacion.texto(\.escala), notacion.texto(\.notas), notacion.texto(\.brilloPorQuintas),
            notacion.texto(\.pasosEnSemitonos), notacion.texto(\.vectorIntervalico), notacion.texto(\.numeroDeForte),
            notacion.texto(\.rasgos),
        ]
        let filas = escalas.map { escala -> [String] in
            let datos = estadisticas(de: escala, en: notacion)
            func valor(_ campo: (TextosDeApps) -> String) -> String {
                datos.first { $0.nombre == notacion.texto(campo) }?.valor ?? "—"
            }
            return [
                escala.nombre(en: notacion), escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " "),
                valor(\.brilloPorQuintas), valor(\.pasosEnSemitonos), valor(\.vectorIntervalico),
                valor(\.numeroDeForte), valor(\.rasgos),
            ]
        }
        return (encabezados, filas)
    }

    /// «+2», «0», «-1», «+0.43»: con signo, sin decimales si es entero y con dos como mucho si no.
    public static func conSigno(_ valor: Double) -> String {
        let redondeado = Redondeo.valor(valor, decimales: 2)
        let cifras = Redondeo.texto(abs(redondeado), decimales: 2)
        if redondeado > 0 { return "+" + cifras }
        if redondeado < 0 { return "-" + cifras }
        return "0"
    }

    // MARK: La escalera de brillo

    /// Las escalas con la misma tónica de la más oscura a la más brillante, a una nota cada una de la siguiente
    /// (`Escala.escaleraDeBrillo`), con su brillo por quintas y la nota que sube.
    ///
    ///     PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: Escala(.do), en: .compacta(.espanol))
    ///         .first { $0.nombre == "Do lidio" }?.cambio   // "Fa → Fa♯"
    public static func escaleraDeBrillo(de escala: Escala, en notacion: Notacion) -> [PeldanoDeBrilloPresentado] {
        let escalera = escala.escaleraDeBrillo()
        return escalera.peldanos.enumerated().map { i, peldano in
            let subida = i == 0 ? nil : escalera.subidas[i - 1]
            return PeldanoDeBrilloPresentado(
                escala: peldano, nombre: peldano.nombre(en: notacion),
                brillo: conSigno(peldano.estadisticas.brilloPorQuintas),
                cambio: subida.map { $0.desde.nombre(en: notacion) + " → " + $0.hasta.nombre(en: notacion) } ?? "",
                esLaDePartida: i == escalera.posicion, sonido: .escala(peldano))
        }
    }
}

/// Lo que dicen de una escala las teorías (`EstadisticasDeEscala`), para `--json`: las propiedades de Myhill,
/// Rothenberg y Balzano, los análisis de Hanson y de Forte, la armonización por grados, la afinación justa y el perfil
/// tonal.
public struct MedidasDeEscalaPresentadas: Hashable, Sendable, Codable {
    public let propiedadDeMyhill: Bool
    public let generador: Int?
    public let bienFormada: Bool
    /// «estrictamente propia», «propia», «impropia».
    public let propiedadDeRothenberg: String
    public let ambiguedades: Int
    public let contradicciones: Int
    public let estabilidad: Double
    public let cocienteDeIgualdad: Double
    public let anchuraDelEspectro: Double
    public let profunda: Bool
    public let consonanciaDiadica: Double
    public let magnitudesDeFourier: [Double]
    public let equilibrada: Bool
    public let distanciaALaUniformidad: Double
    public let triadasContenidas: TriadasContenidas
    public let analisisDeHanson: String
    public let modoDeMessiaen: Int?
    public let simetricaPorInversion: Bool
    public let parejaZ: String?
    public let complemento: String?
    public let imperfecciones: Int
    public let unicidad: Bool
    public let simplicidad: Bool
    /// En números romanos: «I ii iii IV V vi vii°».
    public let triadasPorGrados: [String]?
    public let cuatriadasPorGrados: [String]?
    public let combinatoriedad: CombinatoriedadHexacordal?
    public let entropiaIntervalica: Double
    public let parsimonia: Int
    public let gradoDeSuavidad: Int
    public let alturaDeTenney: Double
    public let limiteImpar: Int
    public let entropiaArmonica: Double
    public let rugosidadMedia: Double
    public let perfilMayor: Double
    public let perfilMenor: Double
    public let conSensible: Bool
    public let tetracordosIguales: Bool

    public init(_ medidas: EstadisticasDeEscala, en notacion: Notacion) {
        propiedadDeMyhill = medidas.intervalosGenericos.propiedadDeMyhill
        generador = medidas.intervalosGenericos.generador
        bienFormada = medidas.intervalosGenericos.bienFormada
        propiedadDeRothenberg = PresentacionDeEstudioDeEscala.propiedad(
            medidas.intervalosGenericos.propiedadDeRothenberg, en: notacion)
        ambiguedades = medidas.intervalosGenericos.ambiguedades
        contradicciones = medidas.intervalosGenericos.contradicciones
        estabilidad = medidas.intervalosGenericos.estabilidad
        cocienteDeIgualdad = medidas.intervalosGenericos.cocienteDeIgualdad
        anchuraDelEspectro = medidas.intervalosGenericos.anchuraDelEspectro
        profunda = medidas.conjunto.profundo
        consonanciaDiadica = medidas.conjunto.consonanciaDiadica
        magnitudesDeFourier = medidas.conjunto.magnitudesDeFourier
        equilibrada = medidas.conjunto.equilibrado
        distanciaALaUniformidad = medidas.conjunto.distanciaALaUniformidad
        triadasContenidas = medidas.conjunto.triadasContenidas
        analisisDeHanson = medidas.conjunto.analisisDeHanson
        modoDeMessiaen = medidas.conjunto.modoDeMessiaen
        simetricaPorInversion = medidas.conjunto.simetricoPorInversion
        parejaZ = medidas.conjunto.parejaZ
        complemento = medidas.conjunto.complemento
        imperfecciones = medidas.conjunto.imperfecciones
        unicidad = medidas.conjunto.unicidad
        simplicidad = medidas.conjunto.simplicidad
        triadasPorGrados = medidas.tonal.triadas.map(PresentacionDeEstudioDeEscala.grados)
        cuatriadasPorGrados = medidas.tonal.cuatriadas.map(PresentacionDeEstudioDeEscala.grados)
        combinatoriedad = medidas.conjunto.combinatoriedad
        entropiaIntervalica = medidas.conjunto.entropiaIntervalica
        parsimonia = medidas.conjunto.parsimonia
        gradoDeSuavidad = medidas.afinacion.gradoDeSuavidad
        alturaDeTenney = medidas.afinacion.alturaDeTenney
        limiteImpar = medidas.afinacion.limiteImpar
        entropiaArmonica = medidas.psicoacustica.entropiaArmonica
        rugosidadMedia = medidas.psicoacustica.rugosidadMedia
        perfilMayor = medidas.tonal.perfilMayor
        perfilMenor = medidas.tonal.perfilMenor
        conSensible = medidas.tonal.conSensible
        tetracordosIguales = medidas.tonal.tetracordosIguales
    }
}
