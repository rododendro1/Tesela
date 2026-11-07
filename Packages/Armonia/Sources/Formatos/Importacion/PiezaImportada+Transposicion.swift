import Elementos
import Partituras
import Teoria

// Una pieza importada, transportada o reducida a su melodía: para llevar un fichero a otro tono o armonizar su voz
// más aguda.

extension PiezaImportada {
    /// La pieza subida o bajada un intervalo: cada nota (también las de adorno), con su microtono, y la tonalidad.
    ///
    ///     let pieza = try PiezaImportada(leyendo: Data(contentsOf: URL(fileURLWithPath: "tema.mid")))
    ///     pieza.transponer(.segundaMayor).partitura().musicXML()   // un tono más arriba
    public func transponer(_ intervalo: Intervalo) -> PiezaImportada {
        func subida(_ nota: NotaDeLaPieza) -> NotaDeLaPieza {
            NotaDeLaPieza(
                altura: nota.altura.transponer(intervalo), inicio: nota.inicio, duracion: nota.duracion,
                parte: nota.parte, desvio: nota.desvio, sistema: nota.sistema, ajuste: nota.ajuste,
                dinamica: nota.dinamica, articulaciones: nota.articulaciones, pentagrama: nota.pentagrama,
                voz: nota.voz)
        }
        return PiezaImportada(
            titulo: titulo, tonalidad: tonalidad?.transponer(intervalo), compas: compas, tempo: tempo,
            notas: notas.map(subida), notasDeAdorno: notasDeAdorno.map(subida))
    }

    /// La melodía de la pieza: la voz más aguda por su altura media, de las del fichero (cada parte, pentagrama y
    /// voz), con su ritmo y sus silencios. Si en ella suenan varias notas a la vez, la de arriba de la primera voz
    /// que salga de ellas.
    ///
    /// Lanza `ErrorDeLecturaDeFichero.sinNotas` si no suena nada.
    public func melodia() throws -> Voz {
        let porLinea = Dictionary(grouping: notas) { [$0.parte, $0.pentagrama ?? 0, $0.voz ?? 0] }
        func media(_ linea: [NotaDeLaPieza]) -> Double {
            Double(linea.map(\.altura.midi).reduce(0, +)) / Double(linea.count)
        }
        guard let aguda = porLinea.values.max(by: { media($0) < media($1) }),
            let voz = PiezaImportada.voces(deUnPentagrama: aguda, compas: compas ?? .compasillo).first
        else {
            throw ErrorDeLecturaDeFichero.sinNotas
        }
        return voz
    }
}
