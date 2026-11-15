import Armonia

// Lo que se consulta de una escala, sin darle forma: lo mismo para el texto de `armonia`, para su salida `--json` y
// para las apps, así que se calcula en un solo sitio. Los nombres van en la notación pedida y, al lado, lo que no
// depende de ella (las clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Una escala: su nombre, sus notas, de qué escala es modo, los acordes de sus grados, su origen y su carácter.
public struct EscalaPresentada: Hashable, Sendable, Codable {
    /// El acorde de un grado, con su cifrado romano: «ii» «Rem7».
    public struct AcordeDelGrado: Hashable, Sendable, Codable {
        public let grado: String
        public let cifrado: String
    }

    public let nombre: String
    /// El nombre en la escritura de su tradición, si la escala lo tiene: «حجاز» para Ḥijāz.
    public let nombresOriginales: [NombreOriginalPresentado]?
    public let notas: [String]
    /// En los rāgas vakra, las notas en el orden en que se tocan al subir y al bajar (`TipoDeEscala.recorrido`):
    /// Do Ānandabhairavi sube «Do Mi♭ Re Mi♭ Fa Sol La Sol Do». `nil` si sube o baja en línea recta.
    public let recorrido: [String]?
    public let recorridoDescendente: [String]?
    /// En un rāga bhāṣāṅga, las notas que no son de su mēḷa (`TipoDeEscala.notasExternas`), desde la tónica: Do
    /// Mukhāri lleva «La♭». `nil` si no tiene.
    public let notasExternas: [String]?
    /// La escala madre de la que sale por su tradición (`TipoDeEscala.madre`), con la palabra de su categoría: Do
    /// Mukhāri sale del «mēḷa Kharaharapriyā», y Do Yaman, del «thāṭ Kalyāṇ». `nil` si no tiene.
    public let madre: String?
    /// Las escalas del catálogo que salen de esta (`TipoDeEscala.derivadas`), por su nombre: los janya de un mēḷa
    /// («Mukhāri», «Kāpi»…), los rāgas de un thāṭ. `nil` si no sale ninguna.
    public let derivadas: [String]?
    /// Las notas con función de la escala (`TipoDeEscala.funciones`): el vādī y el saṃvādī de Do Yaman son Mi y Si, y
    /// el qarār y el ghammāz de Re Bayātī, Re y Sol. `nil` si no tiene.
    public let funciones: [NotaConFuncionPresentada]?
    public let clases: [Int]
    /// De qué escala es modo («Modo 2 de Do mayor»), si lo es de alguna conocida.
    public let modo: String?
    /// Las cuatríadas de cada grado, si la escala es heptatónica y todas forman un acorde conocido.
    public let acordes: [AcordeDelGrado]?
    /// De cuándo y de dónde es (`OrigenDeEscalaPresentado`), si se sabe algo.
    public let origen: OrigenDeEscalaPresentado?
    /// Si es un fragmento de menos de una octava (`TipoDeEscala.esFragmento`), lo que abarca: «4ª justa».
    public let ambito: String?
    /// El carácter de su afinación, si tiene una propia: «microtonal», «justa», «octava en 5 partes iguales».
    public let afinacion: String?
    /// Lo que dicen sus fuentes de su carácter, en orden cronológico (`TipoDeEscala.caracter`). `nil` si ninguna.
    public let caracter: [CaracterPresentado]?
    /// Los pares de fuentes de su carácter que no coinciden en nada: «Heraclides · Aristóteles». `nil` si coinciden.
    public let discrepancias: [String]?
    /// Lo que miden de su afecto los estudios con oyentes (`TipoDeEscala.medidasDelAfecto`). `nil` si ninguno.
    public let medidas: [MedidaDelAfectoPresentada]?
    /// En las occidentales, la sonoridad que calcula Tesela por el brillo (`TipoDeEscala.sonoridad`): «clara».
    public let sonoridad: String?

    /// Los datos de la escala, escritos en la notación.
    public init(_ escala: Escala, en notacion: Notacion) {
        nombre = escala.nombre(en: notacion)
        let originales = NombreOriginalPresentado.de(escala.tipo, en: notacion)
        nombresOriginales = originales.isEmpty ? nil : originales
        notas = escala.notas.map { $0.nombre(en: notacion) }
        func enOrden(_ sentido: SentidoDelIntervalo) -> [String] {
            escala.alturas(octava: 4, sentido: sentido).map { $0.nota.nombre(en: notacion) }
        }
        recorrido = escala.tipo.recorrido == nil ? nil : enOrden(.ascendente)
        recorridoDescendente = escala.tipo.recorridoDescendente == nil ? nil : enOrden(.descendente)
        let externas = escala.tipo.notasExternas.map { (escala.tonica + $0).nombre(en: notacion) }
        notasExternas = externas.isEmpty ? nil : externas
        madre = escala.tipo.madre?.nombreCompleto(en: notacion)
        let derivadas = escala.tipo.derivadas.map { $0.nombre(en: notacion) }
        self.derivadas = derivadas.isEmpty ? nil : derivadas
        let funciones = escala.tipo.funciones.map {
            NotaConFuncionPresentada(
                funcion: $0.funcion.nombre(en: notacion), nota: (escala.tonica + $0.intervalo).nombre(en: notacion))
        }
        self.funciones = funciones.isEmpty ? nil : funciones
        clases = escala.notas.map(\.claseDeAltura)
        modo = PresentacionDeEscalaYAcorde.modo(de: escala, en: notacion)
        let cuatriadas = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        if cuatriadas.count == escala.notas.count, romanos.count == cuatriadas.count {
            acordes = zip(romanos, cuatriadas).map { AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion)) }
        } else {
            acordes = nil
        }
        origen = OrigenDeEscalaPresentado(escala.tipo, en: notacion)
        ambito = escala.tipo.ambito?.nombre(en: notacion)
        afinacion = PresentacionDeEstudioDeEscala.afinacion(de: escala.tipo, en: notacion)
        caracter = CaracterPresentado.de(escala.tipo.caracter, en: notacion)
        discrepancias = CaracterPresentado.discrepancias(escala.tipo.caracter, en: notacion)
        let medidas = escala.tipo.medidasDelAfecto.map { MedidaDelAfectoPresentada($0, en: notacion) }
        self.medidas = medidas.isEmpty ? nil : medidas
        sonoridad = escala.tipo.sonoridad?.nombre(en: notacion)
    }
}

/// Una nota de la escala con su función: «vādī» «Mi».
public struct NotaConFuncionPresentada: Hashable, Sendable, Codable {
    /// El nombre de la función en la notación: «vādī», «ghammāz».
    public let funcion: String
    public let nota: String
}

/// Un nombre de la escala en su escritura original, con su idioma.
///
/// En JSON (`armonia escala Re Ḥijāz --json`), `{"texto": "حجاز", "completo": "مقام حجاز", "idioma": "ar",
/// "nombreDelIdioma": "árabe", "derechaAIzquierda": true}`, con `lectura` si la tiene y `completo` si es otro.
public struct NombreOriginalPresentado: Hashable, Sendable, Codable {
    /// «حجاز», «陽音階».
    public let texto: String
    /// Con la palabra de su categoría (`TipoDeEscala.nombresOriginalesCompletos`), si la lleva: «مقام حجاز».
    public let completo: String?
    /// La etiqueta BCP 47 del idioma, para el `lang` del HTML: «ar», «zh-Hant».
    public let idioma: String
    /// El nombre del idioma en la notación: «árabe», «chino tradicional».
    public let nombreDelIdioma: String
    /// Cómo se lee, si no es el nombre de la escala: «Yō onkai».
    public let lectura: String?
    /// ¿Se escribe de derecha a izquierda (el árabe, el persa)?
    public let derechaAIzquierda: Bool

    /// `completo`, el mismo nombre con la palabra de su categoría, si es distinto.
    public init(_ original: NombreOriginal, completo: NombreOriginal? = nil, en notacion: Notacion) {
        texto = original.texto
        self.completo = completo.map(\.texto).flatMap { $0 == original.texto ? nil : $0 }
        idioma = original.idioma.codigo
        nombreDelIdioma = original.idioma.nombre(en: notacion)
        lectura = original.lectura
        derechaAIzquierda = original.idioma.deDerechaAIzquierda
    }

    /// Los nombres originales de la escala, cada uno con su forma completa.
    public static func de(_ tipo: TipoDeEscala, en notacion: Notacion) -> [NombreOriginalPresentado] {
        zip(tipo.nombresOriginales, tipo.nombresOriginalesCompletos).map {
            NombreOriginalPresentado($0, completo: $1, en: notacion)
        }
    }

    /// Para una línea de texto: el nombre entre aislantes bidireccionales (U+2068 y U+2069), para que un nombre de
    /// derecha a izquierda no se lleve el paréntesis a su lado, y después el idioma y la lectura.
    ///
    ///     "⁨陽音階⁩ (japonés, Yō onkai)"
    public var enUnaLinea: String {
        "\u{2068}" + texto + "\u{2069} (" + ([nombreDelIdioma] + (lectura.map { [$0] } ?? [])).joined(separator: ", ")
            + ")"
    }
}
