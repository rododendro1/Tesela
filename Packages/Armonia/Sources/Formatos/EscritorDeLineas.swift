import Elementos
import PartituraArmonia
import Teoria

// Lo que comparten los escritores que guardan cada voz como una `Exportacion.LineaAnotada` (ABC, LilyPond, GUIDO y
// MEI) y, entre ellos, los de los formatos de texto (ABC, LilyPond y GUIDO): recorren cada voz compás a compás
// (`Exportacion.compases(de:)`) y escriben debajo de cada nota su análisis, con el rótulo de la tonalidad delante en
// la primera nota de su línea. Cada uno escribe solo su sintaxis.

// MARK: - Escritor de líneas

/// Un escritor que guarda cada voz como una `Exportacion.LineaAnotada`, con sus cifrados y su análisis ya escritos
/// en la notación: los de texto y `EscritorMEI`. (`EscritorMusicXML` guarda además el número y la tablatura de cada
/// línea.)
package protocol EscritorDeLineas: EscritorDePartitura {
    var lineas: [Exportacion.LineaAnotada] { get set }
}

extension EscritorDeLineas {
    package mutating func anadir(
        _ voz: Voz, pentagrama: Int, plicaArriba: Bool?,
        cifrados: [Duracion: Acorde], analisis: [Duracion: AcordeAnalizado], notacion: Notacion
    ) {
        lineas.append(
            Exportacion.LineaAnotada(
                voz, pentagrama: pentagrama, plicaArriba: plicaArriba, cifrados: cifrados, analisis: analisis,
                notacion: notacion))
    }
}

// MARK: - Escritor de texto

/// Un escritor de un formato de texto: ver `EscritorABC`, `EscritorLilyPond` y `EscritorGUIDO`.
package protocol EscritorDeTexto: EscritorDeLineas {
    var compas: Compas { get }
    var anacrusa: Duracion { get }
    var claves: [Clave] { get }
}

extension EscritorDeTexto {
    /// La clave de un pentagrama (contados desde 1); la de sol si no tiene.
    func clave(delPentagrama pentagrama: Int) -> Clave {
        claves.indices.contains(pentagrama - 1) ? claves[pentagrama - 1] : .sol
    }

    /// Las líneas de texto que van debajo de un evento de la línea `l`: su análisis, si es nuevo, y en el primero de
    /// la línea que lleva el rótulo, el rótulo delante. Sin líneas vacías.
    func debajo(enLaLinea l: Int, compas c: Int, evento i: Int, inicio: Duracion, nuevo: Bool) -> [String] {
        var debajo = (nuevo ? lineas[l].letras[inicio] ?? [] : []).filter { !$0.isEmpty }
        if c == 0 && i == 0, let rotulo, rotulo.pentagrama == lineas[l].pentagrama,
            lineaDelRotulo(rotulo.pentagrama) == l
        {
            debajo.insert(rotulo.texto, at: 0)
        }
        return debajo
    }

    /// La línea que lleva el rótulo de un pentagrama: la que tiene el análisis o, si no, la primera.
    private func lineaDelRotulo(_ pentagrama: Int) -> Int? {
        let suyas = lineas.indices.filter { lineas[$0].pentagrama == pentagrama }
        return suyas.first { !lineas[$0].letras.isEmpty } ?? suyas.first
    }

    /// Si el compás `c` es un silencio que lo llena entero (el de la anacrusa no cuenta), que ABC y LilyPond
    /// escriben como silencio de compás (`Z`, `R2.`).
    func esSilencioDeCompas(_ eventos: [(evento: Evento, inicio: Duracion, nuevo: Bool)], compas c: Int) -> Bool {
        eventos.count == 1 && eventos[0].evento.esSilencio && !(c == 0 && anacrusa > .cero)
            && eventos[0].evento.duracion == compas.duracion
    }

    /// Un texto entre comillas, con `"` y `\` escapadas, como lo escriben LilyPond y GUIDO.
    package static func cadena(_ texto: String) -> String {
        "\"" + String(texto.flatMap { $0 == "\\" || $0 == "\"" ? "\\\($0)" : "\($0)" }) + "\""
    }
}

extension Exportacion {
    /// Las piezas de un compás con cada grupo irregular envuelto (`\tuplet 3/2 { … }`, `\tuplet<"-3-">( … )`):
    /// `abrir` da lo que va delante del grupo y `cerrar`, lo que va detrás.
    static func envolviendo(
        _ piezas: [String], grupos: [(rango: ClosedRange<Int>, reales: Int, normales: Int)],
        abrir: (_ reales: Int, _ normales: Int) -> String, cerrar: String
    ) -> [String] {
        var resultado: [String] = []
        for (i, pieza) in piezas.enumerated() {
            guard let grupo = grupos.first(where: { $0.rango.contains(i) }) else {
                resultado.append(pieza)
                continue
            }
            if grupo.rango.upperBound == i {
                let dentro = piezas[grupo.rango].joined(separator: " ")
                resultado.append(abrir(grupo.reales, grupo.normales) + " " + dentro + " " + cerrar)
            }
        }
        return resultado
    }
}
