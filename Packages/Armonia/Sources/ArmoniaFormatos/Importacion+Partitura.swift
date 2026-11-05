import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// De la pieza importada a una partitura: lo que se lee de un fichero se puede dibujar y exportar otra vez.

extension PiezaImportada {
    /// La pieza como partitura, para dibujarla o exportarla otra vez: un pentagrama por parte (en el orden de las
    /// partes) y, si el fichero los dice (``NotaDeLaPieza/pentagrama``, como el piano en MusicXML), uno por cada
    /// pentagrama de la parte, con el título, la tonalidad, el tempo y el compás del fichero. Si todas las notas de
    /// un pentagrama dicen su voz (``NotaDeLaPieza/voz``), cada voz del fichero es una voz de la partitura. Dentro de
    /// cada una, las notas que empiezan y acaban a la vez van juntas, en un acorde; las que se solapan de otra forma,
    /// en otra voz del pentagrama, y los huecos son silencios. Cada nota lleva su microtono y su sistema
    /// (``NotaDeLaPieza/nota``), su dinámica y sus articulaciones. Las notas de adorno se quedan fuera.
    ///
    ///     let pieza = try PiezaImportada(leyendo: Data(contentsOf: URL(fileURLWithPath: "coral.mid")))
    ///     pieza.partitura().musicXML()   // el mismo coral, en MusicXML
    public func partitura() -> Partitura {
        let compas = self.compas ?? .compasillo
        let partes = Set(notas.map(\.parte)).sorted()
        let pentagramas = partes.flatMap { parte -> [Partitura.Pentagrama] in
            let porPentagrama = Dictionary(grouping: notas.filter { $0.parte == parte }) { $0.pentagrama ?? 1 }
            return porPentagrama.keys.sorted().map { pentagrama in
                Partitura.Pentagrama(
                    voces: PiezaImportada.voces(deUnPentagrama: porPentagrama[pentagrama] ?? [], compas: compas).map {
                        Partitura.Linea($0)
                    })
            }
        }
        return Partitura(
            pentagramas: pentagramas, encabezado: Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo),
            compas: compas)
    }

    /// Las voces de un pentagrama: las del fichero, si todas sus notas dicen la suya, en orden; si no, las que salen
    /// de cómo se solapan las notas.
    static func voces(deUnPentagrama notas: [NotaDeLaPieza], compas: Compas) -> [Voz] {
        guard notas.allSatisfy({ $0.voz != nil }) else { return voces(de: notas, compas: compas) }
        let porVoz = Dictionary(grouping: notas) { $0.voz ?? 0 }
        return porVoz.keys.sorted().flatMap { voces(de: porVoz[$0] ?? [], compas: compas) }
    }

    /// Las voces de una parte: cada una, una sucesión de acordes (las notas que empiezan y acaban a la vez) que no se
    /// solapan, con silencios en los huecos. Cada acorde va en la primera voz que ya ha acabado cuando empieza.
    static func voces(de notas: [NotaDeLaPieza], compas: Compas) -> [Voz] {
        // Las notas llegan ordenadas por su comienzo: los acordes, también.
        var acordes: [(inicio: Duracion, duracion: Duracion, notas: [NotaDeLaPieza])] = []
        var delMomento: [Duracion: Int] = [:]
        for nota in notas where nota.duracion > .cero {
            if acordes.last?.inicio != nota.inicio { delMomento = [:] }
            if let i = delMomento[nota.duracion] {
                acordes[i].notas.append(nota)
            } else {
                delMomento[nota.duracion] = acordes.count
                acordes.append((nota.inicio, nota.duracion, [nota]))
            }
        }
        var voces: [(fin: Duracion, eventos: [Evento])] = []
        for acorde in acordes {
            let evento = Evento(
                notas: acorde.notas.map(\.nota), duracion: acorde.duracion,
                dinamica: acorde.notas.lazy.compactMap(\.dinamica).first,
                articulaciones: acorde.notas.flatMap(\.articulaciones))
            let fin = acorde.inicio + acorde.duracion
            if let v = voces.firstIndex(where: { $0.fin <= acorde.inicio }) {
                if voces[v].fin < acorde.inicio { voces[v].eventos.append(.silencio(acorde.inicio - voces[v].fin)) }
                voces[v].eventos.append(evento)
                voces[v].fin = fin
            } else {
                let silencio = acorde.inicio > .cero ? [Evento.silencio(acorde.inicio)] : []
                voces.append((fin, silencio + [evento]))
            }
        }
        return voces.map { Voz($0.eventos, compas: compas) }
    }
}
