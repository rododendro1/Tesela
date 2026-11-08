import Armonia
import Foundation

// MARK: - Las notas en el idioma de --idioma
//
// Las órdenes leen las notas, los acordes, las escalas y las tonalidades primero en la notación de `--idioma`, con
// `leyendo:en:` de la biblioteca, y si no, en español o en inglés (`init(leyendoEnLaOrden:)`): `armonia acorde B7/D
// --idioma de` es Si♭7/Re, `escala re dòric --idioma ca` es Re dórico y `acorde Do7 --idioma de` sigue siendo Do7.
//
// Lo que no se lee así, sino con los lectores de la biblioteca que leen varias cosas a la vez (voces, corales,
// progresiones), se lee con las palabras pasadas a español: cada palabra que empieza por una nota del idioma y que,
// escrita en español, se lee como nota, altura o acorde, pero no se leía o se leía otra cosa con la misma nota, se pasa
// a la orden en español (`H7` → `Si7` en alemán). Si así la orden no va bien, se ejecuta con las palabras como estaban.

/// Lo que se lee en una notación concreta (`leyendo:en:`) o, sin ella, en español o en inglés (`leyendo:`).
protocol LegibleEnUnaNotacion {
    init(leyendo texto: String) throws
    init(leyendo texto: String, en notacion: Notacion) throws
}

extension Nota: LegibleEnUnaNotacion {}
extension Altura: LegibleEnUnaNotacion {}
extension Acorde: LegibleEnUnaNotacion {}
extension Escala: LegibleEnUnaNotacion {}
extension Tonalidad: LegibleEnUnaNotacion {}

/// La notación de la orden que se está ejecutando, en la que se leen sus notas (la de `--idioma`).
enum NotacionDeLectura {
    @TaskLocal static var actual: Notacion?
}

extension LegibleEnUnaNotacion {
    /// En la notación de la orden (`--idioma de`: «B7» es Si♭7) o en español o en inglés, con el error de esta
    /// lectura si no se lee de ninguna forma. Si se lee de las dos y da otra cosa, gana la que lee una nota más larga
    /// al principio: «Do7» en alemán es Do7 (con «Do»), no D°7 (con «D»).
    init(leyendoEnLaOrden texto: String) throws {
        guard let notacion = NotacionDeLectura.actual, let enLaNotacion = try? Self(leyendo: texto, en: notacion) else {
            try self.init(leyendo: texto)
            return
        }
        guard let general = try? Self(leyendo: texto) else {
            self = enLaNotacion
            return
        }
        let largoEnLaNotacion = LineaDeComandos.largoDeLaNota(texto, en: notacion) ?? 0
        let largoGeneral = LineaDeComandos.largoDeLaNota(texto) ?? 0
        self = largoGeneral > largoEnLaNotacion ? general : enLaNotacion
    }
}

extension LineaDeComandos {
    /// Ejecuta `ejecutar` con las notas del idioma de `notacion` en español; si así no va bien, con `argumentos` tal
    /// cual.
    static func conLasNotasDelIdioma(
        _ argumentos: [String], en notacion: Notacion, _ ejecutar: ([String]) -> ResultadoDeOrden
    ) -> ResultadoDeOrden {
        let enEspanol = argumentos.map { notasEnEspanol($0, en: notacion) }
        guard enEspanol != argumentos else { return ejecutar(argumentos) }
        let resultado = ejecutar(enEspanol)
        return resultado.codigo == 0 || resultado.codigo == 3 ? resultado : ejecutar(argumentos)
    }

    /// La palabra con sus notas del idioma de `notacion` en español (`H7/Fis` → `Si7/Fa#`, `B` → `Sib` en alemán), o
    /// tal cual si no empieza por una nota del idioma, si en español no se lee o si ya se leía igual. Una palabra que
    /// ya se lee no cambia si la nota del idioma es otro trozo: «Do7» en alemán sigue siendo Do7, no D°7.
    static func notasEnEspanol(_ palabra: String, en notacion: Notacion) -> String {
        let idioma = notacion.idiomaDeLasNotas
        // Con un sistema de otra tradición (--sistema bizantino) también: Ga♯7 → Fa#7.
        let otroSistema = notacion.sistemaDeNombres != nil
        guard otroSistema || (idioma != .espanol && idioma != .ingles), !palabra.hasPrefix("-"), !palabra.contains(" ")
        else {
            return palabra
        }
        // La tabla con palabras tiene también los nombres compactos (Fis, Ré♭).
        let notaciones = [notacion, Notacion(escritura: .conPalabras(idioma))]
        // Cada nota del idioma con que empieza la parte, de la más larga a la más corta («As» y «A» en «Asus4»), y
        // los caracteres que ocupa.
        func enEspanol(_ parte: String) -> [(texto: String, largo: Int)] {
            let caracteres = Array(parte)
            return stride(from: caracteres.count, through: 1, by: -1).compactMap { largo in
                let inicio = String(caracteres[..<largo])
                guard let nota = notaciones.lazy.compactMap({ try? Nota(leyendo: inicio, en: $0) }).first else {
                    return nil
                }
                return (nota.nombreASCII + String(caracteres[largo...]), largo)
            }
        }
        let partes = palabra.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
        guard partes.count <= 2 else { return palabra }
        var candidatas = enEspanol(partes[0]).map { candidata in
            (texto: ([candidata.texto] + partes.dropFirst()).joined(separator: "/"), largo: candidata.largo)
        }
        // El bajo, tras la barra: Si7/Fa#.
        if partes.count == 2 {
            candidatas = candidatas.flatMap { candidata in
                let primera = candidata.texto.split(separator: "/", maxSplits: 1)[0]
                return enEspanol(partes[1]).map { (texto: primera + "/" + $0.texto, largo: candidata.largo) }
                    + [candidata]
            }
        }
        let original = LecturaDeLaPalabra(palabra)
        let largoEnEspanol = original.seLee ? largoDeLaNota(palabra) : nil
        for candidata in candidatas where candidata.texto != palabra {
            if let largoEnEspanol, largoEnEspanol != candidata.largo { continue }
            let leida = LecturaDeLaPalabra(candidata.texto)
            if leida.seLee, leida != original { return candidata.texto }
        }
        return palabra
    }

    /// Los caracteres de la nota más larga, en español o en inglés (o en `notacion`), con que empieza la palabra
    /// («Do7» → 2; en alemán, 1).
    static func largoDeLaNota(_ palabra: String, en notacion: Notacion? = nil) -> Int? {
        let caracteres = Array(palabra)
        return stride(from: min(caracteres.count, 24), through: 1, by: -1).first { largo in
            let inicio = String(caracteres[..<largo])
            guard let notacion else { return (try? Nota(leyendo: inicio)) != nil }
            return (try? Nota(leyendo: inicio, en: notacion)) != nil
        }
    }

    /// Lo que se lee en una palabra en español o en inglés: una altura, una nota o un acorde. «Ré7» se lee como
    /// altura (Re en la séptima octava), pero no como acorde; «Re7», como las dos cosas.
    struct LecturaDeLaPalabra: Equatable {
        let altura: Altura?
        let nota: Nota?
        let acorde: Acorde?

        init(_ palabra: String) {
            altura = try? Altura(leyendo: palabra)
            nota = try? Nota(leyendo: palabra)
            acorde = try? Acorde(leyendo: palabra)
        }

        var seLee: Bool { altura != nil || nota != nil || acorde != nil }
    }
}
