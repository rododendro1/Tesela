import Armonia
import Exposicion
import Foundation

// `--json` del análisis, la armonización, la revisión, el contrapunto, la transposición y la rearmonización. Lo
// común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Análisis

    struct AnalisisJSON: Encodable {
        struct Tramo: Encodable {
            /// «en Sol mayor» al modular; `nil` en el primer tramo si no hay modulaciones.
            let cabecera: String?
            let acordes: [Fila]
        }
        struct Fila: Encodable {
            let cifrado: String
            let grado: String
            /// Vacío si el acorde no tiene función en la tonalidad.
            let funcion: String
        }
        let titulo: String
        let tramos: [Tramo]
        let cadencias: [String]
    }

    /// `analizar Do Fa Sol7 Do [--en Do mayor] --json`: el análisis por tramos, como en el texto.
    static func analizarJSON(_ textos: [String], _ notacion: Notacion) throws -> AnalisisJSON {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let acordes = try palabras(argumentos, siFaltan: .faltanAcordesDelAnalisis)
        let analisis = try PresentacionDeAnalisis.analizar(
            acordes.joined(separator: " "), en: tonalidad, notacion: notacion)
        return AnalisisJSON(
            titulo: analisis.titulo,
            tramos: analisis.tramos.map { tramo in
                AnalisisJSON.Tramo(
                    cabecera: tramo.cabecera,
                    acordes: tramo.filas.map {
                        AnalisisJSON.Fila(cifrado: $0.cifrado, grado: $0.grado, funcion: $0.funcion)
                    })
            },
            cadencias: analisis.cadencias)
    }

    // MARK: Armonización y conducción de las voces

    /// Un acorde de un coral: su cifrado, su grado (vacío si no lo tiene) y las alturas de grave a agudo.
    struct AcordeDelCoral: Encodable {
        let cifrado: String
        let grado: String
        let voces: [String]

        init(_ fila: CoralPresentado.Fila) {
            cifrado = fila.cifrado
            grado = fila.grado
            voces = fila.voces.split(separator: " ").map(String.init)
        }
    }

    struct ArmonizacionJSON: Encodable {
        let titulo: String
        /// Las armonizaciones, de mejor a peor, como en el texto.
        let propuestas: [String]
        /// El coral a cuatro voces de la mejor; `nil` si las notas no llevan octava.
        let coral: [AcordeDelCoral]?
        /// Lo que se dice en lugar del resultado (no hay armonización, no hay coral…).
        let avisos: [String]
    }

    /// `armonizar Mi4 Re4 Do4 --json`.
    static func armonizarJSON(_ textos: [String], _ notacion: Notacion) throws -> ArmonizacionJSON {
        let coral = try coralArmonizado(textos, notacion)
        let sinCoral = coral.avisos.contains(.faltanOctavas) || coral.avisos.contains(.sinArmonizacion)
        return ArmonizacionJSON(
            titulo: coral.titulo, propuestas: coral.propuestas,
            coral: sinCoral ? nil : coral.filas.map(AcordeDelCoral.init),
            avisos: coral.avisos.filter { $0 != .faltanOctavas }.map { $0.texto(en: notacion) })
    }

    struct RealizacionJSON: Encodable {
        let titulo: String
        let coral: [AcordeDelCoral]
        let avisos: [String]
    }

    /// `realizar Do Fa Sol7 Do --json`.
    static func realizarJSON(_ textos: [String], _ notacion: Notacion) throws -> RealizacionJSON {
        let coral = try coralRealizado(textos, notacion)
        return RealizacionJSON(
            titulo: coral.titulo, coral: coral.filas.map(AcordeDelCoral.init),
            avisos: coral.avisos.map { $0.texto(en: notacion) })
    }

    struct RevisionJSON: Encodable, ConFaltas {
        /// Una falta de conducción. `tipo` es el nombre de la regla (`quintasParalelas`, `cruceDeVoces`…), el mismo en
        /// todos los idiomas; las voces se cuentan desde 1, la más grave; el acorde, desde 1 (en las faltas entre dos
        /// acordes, el primero de los dos).
        struct Falta: Encodable {
            let tipo: String
            let texto: String
            let acorde: Int
            let voces: [Int]
        }

        let acordes: [AcordeDelCoral]
        let faltas: [Falta]
        var hayFaltas: Bool { !faltas.isEmpty }
    }

    /// `revisar Do3 Mi4 Sol4 Do5, Re3 Fa4 La4 Re5 --json`: sale con código 3 si hay faltas.
    static func revisarJSON(_ textos: [String], _ notacion: Notacion) throws -> RevisionJSON {
        let coral = try coralRevisado(textos, notacion)
        return RevisionJSON(
            acordes: coral.filas.map(AcordeDelCoral.init),
            faltas: faltas(de: coral).map {
                RevisionJSON.Falta(
                    tipo: clave(de: $0.tipo), texto: $0.descripcion(en: notacion), acorde: $0.acorde + 1,
                    voces: $0.voces.map { $0 + 1 })
            })
    }

    struct ContrapuntoJSON: Encodable, ConFaltas {
        /// Una falta del contrapunto. `tipo` es el nombre de la regla (`quintasParalelas`, `notaRepetida`…), el mismo
        /// en todos los idiomas; los compases de la primera y la última nota se cuentan desde 1.
        struct Falta: Encodable {
            let tipo: String
            let texto: String
            let compases: [Int]
        }

        let especie: Int
        /// Si el contrapunto va encima del cantus firmus.
        let encima: Bool
        let faltas: [Falta]
        var hayFaltas: Bool { !faltas.isEmpty }
    }

    /// `contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5 --json`: sale con código 3 si hay faltas.
    static func contrapuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> ContrapuntoJSON {
        let ejercicio = try ejercicioDeContrapunto(textos)
        return ContrapuntoJSON(
            especie: ejercicio.especie.rawValue, encima: ejercicio.contrapuntoArriba,
            faltas: ejercicio.faltas.map {
                ContrapuntoJSON.Falta(
                    tipo: clave(de: $0.tipo), texto: $0.descripcion(en: notacion),
                    compases: [$0.compases.lowerBound + 1, $0.compases.upperBound + 1])
            })
    }

    struct TransposicionJSON: Encodable {
        let intervalo: IntervaloJSON
        /// `acordes` o `notas`: cómo se ha leído lo que se transporta.
        let contenido: String
        /// Lo transportado, como en el texto.
        let texto: String
    }

    /// `transponer 2M Do Fa Sol7 --json`.
    static func transponerJSON(_ textos: [String], _ notacion: Notacion) throws -> TransposicionJSON {
        let hecho = try transporte(textos, notacion)
        let intervalo = hecho.intervalo
        return TransposicionJSON(
            intervalo: IntervaloJSON(
                nombre: intervalo.nombre(en: notacion), abreviatura: intervalo.texto(en: notacion),
                semitonos: intervalo.semitonos, numero: intervalo.numero,
                descendente: intervalo.sentido == .descendente),
            contenido: hecho.contenido == .acordes ? "acordes" : "notas", texto: hecho.texto)
    }

    /// La clave de una falta de conducción en el JSON: el nombre de su caso, que no cambia con el idioma. El `switch`
    /// no tiene `default`: una falta nueva no compila sin la suya.
    static func clave(de tipo: FaltaDeConduccion.Tipo) -> String {
        switch tipo {
        case .quintasParalelas: "quintasParalelas"
        case .octavasParalelas: "octavasParalelas"
        case .quintasDirectas: "quintasDirectas"
        case .octavasDirectas: "octavasDirectas"
        case .cruceDeVoces: "cruceDeVoces"
        case .superposicion: "superposicion"
        case .separacionExcesiva: "separacionExcesiva"
        case .saltoNoMelodico: "saltoNoMelodico"
        case .fueraDeTesitura: "fueraDeTesitura"
        }
    }

    /// La clave de una falta de contrapunto en el JSON, como la de `clave(de:)` de las de conducción.
    static func clave(de tipo: FaltaDeContrapunto.Tipo) -> String {
        switch tipo {
        case .ritmoDeLaEspecie: "ritmoDeLaEspecie"
        case .comienzoImperfecto: "comienzoImperfecto"
        case .finalImperfecto: "finalImperfecto"
        case .finalSinGradoConjunto: "finalSinGradoConjunto"
        case .disonanciaEnParteFuerte: "disonanciaEnParteFuerte"
        case .disonanciaMalTratada: "disonanciaMalTratada"
        case .retardoMalResuelto: "retardoMalResuelto"
        case .quintasParalelas: "quintasParalelas"
        case .octavasParalelas: "octavasParalelas"
        case .quintasDirectas: "quintasDirectas"
        case .octavasDirectas: "octavasDirectas"
        case .unisono: "unisono"
        case .cruceDeVoces: "cruceDeVoces"
        case .saltoNoMelodico: "saltoNoMelodico"
        case .saltoSinCompensar: "saltoSinCompensar"
        case .notaRepetida: "notaRepetida"
        }
    }

    // MARK: Rearmonización

    /// Una propuesta de `rearmonizar --json`.
    struct PropuestaJSON: Encodable {
        /// El acorde que cambia, desde 1, como en el texto.
        let posicion: Int
        /// `sustitutoTritonal`, `dominanteSecundaria`, `prestamoModal`…: siempre igual, sea cual sea el idioma.
        let recurso: String
        let original: String
        let acordes: [String]
        let descripcion: String
    }

    struct RearmonizacionJSON: Encodable {
        let tonalidad: String
        let propuestas: [PropuestaJSON]
    }

    /// `rearmonizar Do Lam Rem7 Sol7 Do --json`: la tonalidad y cada propuesta.
    static func rearmonizarJSON(_ textos: [String], _ notacion: Notacion) throws -> RearmonizacionJSON {
        var acordes = Argumentos(textos)
        guard let tonalidad = try acordes.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let leidos = try palabras(acordes, siFaltan: .faltanAcordesDeLaRearmonizacion).map {
            try Acorde(leyendoEnLaOrden: $0)
        }
        guard let resultado = PresentacionDeRearmonizacion.proponer(leidos, en: tonalidad, notacion: notacion) else {
            throw ErrorDeUso.faltanAcordesDeLaRearmonizacion
        }
        return RearmonizacionJSON(
            tonalidad: resultado.tonalidad.nombre(en: notacion),
            propuestas: resultado.propuestas.map { propuesta in
                let cambio = propuesta.rearmonizacion
                return PropuestaJSON(
                    posicion: cambio.posicion + 1, recurso: cambio.recurso.rawValue,
                    original: cambio.original.cifrado(en: notacion),
                    acordes: cambio.acordes.map { $0.cifrado(en: notacion) },
                    descripcion: propuesta.descripcion)
            })
    }
}
