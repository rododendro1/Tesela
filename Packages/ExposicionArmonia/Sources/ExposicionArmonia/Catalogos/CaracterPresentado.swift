import Armonia

// MARK: - El carácter, presentado
//
// Lo que dicen las fuentes del carácter de una escala o de una tonalidad (`Caracter`), y lo que mide un estudio
// (`MedidaDelAfecto`), escritos en la notación: lo mismo para el texto de `armonia`, su `--json`, las hojas HTML y las
// apps. Los afectos, el momento, la estación y la ocasión van también por su clave, que no cambia con el idioma.

/// Lo que dice una fuente del carácter, escrito: «colérico», «Furieux et emporté», «Charpentier (Cessac 1988)».
///
/// En JSON (`armonia tonalidad Fa mayor --json`), `{"descripcion": "colérico", "afectos": ["colerico"], "texto":
/// "Furieux et emporté", "cita": "Charpentier (Cessac 1988)", "anio": 1690}`.
public struct CaracterPresentado: Hashable, Sendable, Codable {
    /// Todo lo que dice, en una línea: «banquete · blando», «amanecer · devoto, solemne».
    public let descripcion: String
    /// Los afectos, por su clave (`Afecto.rawValue`): «colerico», «lastimero».
    public let afectos: [String]
    /// El momento del día, la estación y la ocasión, por su clave: «anochecer», «lluvias», «lamento».
    public let momento: String?
    public let estacion: String?
    public let ocasion: String?
    /// Lo que dice con sus palabras, en la lengua de la obra donde se lee (`Caracter.texto`).
    public let texto: String?
    /// Quién lo dice y dónde: «Platón 398e (Monro 1894: 7–8)».
    public let cita: String
    /// El año de lo que dice (`Caracter.anio`), negativo antes de Cristo.
    public let anio: Int?

    public init(_ caracter: Caracter, en notacion: Notacion) {
        descripcion = caracter.descripcion(en: notacion)
        afectos = caracter.afectos.map(\.rawValue)
        momento = caracter.momento?.rawValue
        estacion = caracter.estacion?.rawValue
        ocasion = caracter.ocasion?.rawValue
        texto = caracter.texto
        cita = caracter.cita(en: notacion)
        anio = caracter.anio
    }

    /// Los de una lista, o `nil` si está vacía (y así no sale en el JSON).
    public static func de(_ lista: [Caracter], en notacion: Notacion) -> [CaracterPresentado]? {
        lista.isEmpty ? nil : lista.map { CaracterPresentado($0, en: notacion) }
    }

    /// En una línea, con sus palabras entre comillas inglesas, que no son de ningún idioma de la notación:
    /// «colérico · “Furieux et emporté” (Charpentier (Cessac 1988))».
    public var enUnaLinea: String {
        [descripcion, texto.map { "“" + $0 + "”" }].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · ")
            + " (" + cita + ")"
    }

    /// Los pares de fuentes que no coinciden en nada (`Caracter.discrepancias(_:)`), cada uno por quién lo dice:
    /// «Charpentier · Schubart». `nil` si coinciden todas.
    public static func discrepancias(_ lista: [Caracter], en notacion: Notacion) -> [String]? {
        let pares = Caracter.discrepancias(lista).map { quien($0.0, en: notacion) + " · " + quien($0.1, en: notacion) }
        return pares.isEmpty ? nil : pares
    }

    /// El testigo, si lo hay; si no, la obra: «Charpentier», «Bor 1999».
    private static func quien(_ caracter: Caracter, en notacion: Notacion) -> String {
        caracter.testigo?.nombre(en: notacion) ?? caracter.referencia.cita
    }
}

/// Lo que mide un estudio del afecto de una escala, escrito: «alegre: 83 %», «Temperley & Tan 2013: 248».
public struct MedidaDelAfectoPresentada: Hashable, Sendable, Codable {
    /// El afecto, por su clave: «alegre».
    public let afecto: String
    /// De 0 a 1.
    public let proporcion: Double
    /// «alegre: 83 %».
    public let descripcion: String
    public let cita: String

    public init(_ medida: MedidaDelAfecto, en notacion: Notacion) {
        afecto = medida.afecto.rawValue
        proporcion = medida.proporcion
        descripcion = medida.descripcion(en: notacion)
        cita = medida.referencia.cita
    }

    /// «alegre: 83 % (Temperley & Tan 2013: 248)».
    public var enUnaLinea: String { descripcion + " (" + cita + ")" }
}

extension PresentacionDeEstudioDeEscala {
    /// Las filas del carácter de una escala, para una lista de las apps: una por fuente (quién lo dice, y lo que dice
    /// con sus palabras), y después las fuentes que no coinciden, lo que mide un estudio y la sonoridad calculada.
    /// Vacío si no hay nada que decir.
    ///
    ///     let filas = PresentacionDeEstudioDeEscala.caracter(de: .saba, en: .compacta(.espanol))
    ///     filas[0].valor   // "triste, lastimero · “sadness and pain”"
    public static func caracter(de tipo: TipoDeEscala, en notacion: Notacion) -> [DatoPresentado] {
        filasDelCaracter(
            tipo.caracter, medidas: tipo.medidasDelAfecto, sonoridad: tipo.sonoridad, en: notacion)
    }

    /// Las filas del carácter de una tonalidad: las de Charpentier y Schubart, y si no coinciden.
    public static func caracter(de tonalidad: Tonalidad, en notacion: Notacion) -> [DatoPresentado] {
        filasDelCaracter(tonalidad.caracter, en: notacion)
    }

    static func filasDelCaracter(
        _ caracter: [Caracter], medidas: [MedidaDelAfecto] = [], sonoridad: Sonoridad? = nil, en notacion: Notacion
    ) -> [DatoPresentado] {
        var filas = caracter.map { fuente in
            let presentado = CaracterPresentado(fuente, en: notacion)
            let valor = [presentado.descripcion, presentado.texto.map { "“" + $0 + "”" }].compactMap { $0 }
                .filter { !$0.isEmpty }.joined(separator: " · ")
            return DatoPresentado(nombre: presentado.cita, valor: valor)
        }
        if let pares = CaracterPresentado.discrepancias(caracter, en: notacion) {
            filas.append(
                DatoPresentado(nombre: notacion.texto(\.fuentesQueNoCoinciden), valor: pares.joined(separator: "; ")))
        }
        for medida in medidas {
            filas.append(
                DatoPresentado(
                    nombre: notacion.texto(\.afectoMedido),
                    valor: MedidaDelAfectoPresentada(medida, en: notacion).enUnaLinea))
        }
        if let sonoridad {
            filas.append(
                DatoPresentado(nombre: notacion.texto(\.sonoridadCalculada), valor: sonoridad.nombre(en: notacion)))
        }
        return filas
    }
}
