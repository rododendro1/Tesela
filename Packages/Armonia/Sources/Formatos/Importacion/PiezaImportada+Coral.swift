import Elementos
import Partituras
import Polifonia
import Teoria

// Un coral leído de un fichero (un ejercicio de armonía escrito en MuseScore, Finale o Dorico, o un MIDI), para
// revisar su conducción de voces con `Coral.faltas`.

extension PiezaImportada {
    /// La pieza como coral: un acorde cada vez que empieza una nota, con lo que suena entonces en cada voz.
    ///
    /// Si cada voz del fichero va aparte (una parte, un pentagrama o una voz de MusicXML por cada una, como se
    /// escribe un coral a cuatro voces en dos pentagramas) y en ninguna suenan dos notas a la vez, las voces del
    /// coral son esas, de la más grave a la más aguda por su altura media: así se ven los cruces. Si no (un MIDI en
    /// una sola pista, por ejemplo), son las notas que suenan, de la grave a la aguda. Los momentos en que alguna voz
    /// calla no dan acorde, y un acorde igual al anterior (una voz que repite su nota) tampoco.
    ///
    ///     let pieza = try PiezaImportada(leyendo: Data(contentsOf: URL(fileURLWithPath: "ejercicio.musicxml")))
    ///     let coral = try pieza.coral()
    ///     coral.faltas.map(\.description)   // ["Quintas paralelas entre el bajo y el tenor (acordes 3 → 4)"]
    ///
    /// Lanza `ErrorDeLecturaDeFichero.sinNotas` si no suena nada, y `ErrorDeLecturaDeTeoria.Motivo.vocesDistintas` si
    /// no suenan siempre las mismas voces.
    public func coral() throws -> Coral {
        let comienzos = Array(Set(notas.map(\.inicio))).sorted()
        var acordes: [[Altura]] = []
        func anadir(_ acorde: [Altura]) {
            if !acorde.isEmpty, acordes.last != acorde { acordes.append(acorde) }
        }
        if let lineas = lineasDelCoral() {
            for momento in comienzos {
                let suenan = lineas.compactMap { linea in linea.first { $0.inicio <= momento && $0.fin > momento } }
                if suenan.count == lineas.count { anadir(suenan.map(\.altura)) }
            }
        } else {
            for momento in comienzos {
                anadir(
                    notas.filter { $0.inicio <= momento && $0.fin > momento }.map(\.altura).sorted { $0.midi < $1.midi }
                )
            }
        }
        guard !acordes.isEmpty else { throw ErrorDeLecturaDeFichero.sinNotas }
        return try Coral(acordes)
    }

    /// Las voces del fichero, de la más grave a la más aguda por su altura media, si son al menos dos y en ninguna
    /// suenan dos notas a la vez; `nil` si no.
    private func lineasDelCoral() -> [[NotaDeLaPieza]]? {
        let lineas = self.lineas
        guard lineas.count >= 2 else { return nil }
        for linea in lineas {
            for (a, b) in zip(linea, linea.dropFirst()) where b.inicio < a.fin { return nil }
        }
        return lineas
    }
}
