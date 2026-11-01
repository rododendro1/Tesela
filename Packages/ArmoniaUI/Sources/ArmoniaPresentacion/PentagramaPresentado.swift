import Armonia
import Foundation

/// El pentagrama de una escala o de un acorde, listo para mostrar y exportar: el SVG, su proporción, un texto para
/// los lectores de pantalla y el fichero que se comparte. No usa SwiftUI, así que se prueba en Linux;
/// `DiagramaDePentagrama` lo muestra.
///
///     let pentagrama = PentagramaPresentado(Escala("Re dórico"))
///     pentagrama.fichero.nombreDeFichero   // "Pentagrama Re dórico.svg"
public struct PentagramaPresentado: Hashable, Sendable {
    public let svg: String
    /// Para los lectores de pantalla: el nombre y las notas, con su octava.
    public let descripcion: String
    /// Ancho entre alto del dibujo (la del `viewBox` del SVG); 4 si no se puede leer.
    public let relacionDeAspecto: Double
    /// El dibujo como fichero SVG.
    public let fichero: FicheroParaExportar

    /// - Parameters:
    ///   - sentido: si es `nil`, la subida y, en las escalas que bajan con otras notas, la bajada.
    ///   - nombresDeLasNotas: si se escribe el nombre de cada nota debajo.
    ///   - resaltada: la nota (contada desde 0) que se pinta de otro color, la que está sonando.
    public init(
        _ escala: Escala, octava: Int = 4, sentido: SentidoDelIntervalo? = nil,
        notacion: Notacion = .espanolUnicode, nombresDeLasNotas: Bool = true, resaltada: Int? = nil
    ) {
        var opciones = OpcionesDePentagrama(notacion: notacion, nombresDeLasNotas: nombresDeLasNotas)
        opciones.resaltada = resaltada
        let dibujo = escala.svgPentagrama(octava: octava, sentido: sentido, opciones: opciones)
        let nombre = escala.nombre(en: notacion)
        let notas = escala.alturas(octava: octava).map { $0.nombre(en: notacion) }.joined(separator: ", ")
        self.init(svg: dibujo, descripcion: nombre + ": " + notas, nombre: "Pentagrama " + nombre)
    }

    public init(
        _ acorde: Acorde, octava: Int = 4, notacion: Notacion = .espanolUnicode,
        nombresDeLasNotas: Bool = false
    ) {
        let opciones = OpcionesDePentagrama(notacion: notacion, nombresDeLasNotas: nombresDeLasNotas)
        let dibujo = acorde.svgPentagrama(octava: octava, opciones: opciones)
        let cifrado = acorde.cifrado(en: notacion)
        let notas = acorde.notasDesdeElBajo.map { $0.nombre(en: notacion) }.joined(separator: ", ")
        self.init(svg: dibujo, descripcion: cifrado + ": " + notas, nombre: "Pentagrama " + cifrado)
    }

    /// Las notas del arpegio en el orden del patrón, una por columna; la `resaltada` (contada desde 0), de otro
    /// color.
    public init(
        _ arpegio: Arpegio, octava: Int = 4, notacion: Notacion = .espanolUnicode,
        nombresDeLasNotas: Bool = true, resaltada: Int? = nil
    ) {
        var opciones = OpcionesDePentagrama(notacion: notacion, nombresDeLasNotas: nombresDeLasNotas)
        opciones.resaltada = resaltada
        let dibujo = arpegio.svgPentagrama(octava: octava, opciones: opciones)
        let nombre = arpegio.nombre(en: notacion)
        let notas = arpegio.alturas(octava: octava).map { $0.nombre(en: notacion) }.joined(separator: ", ")
        self.init(svg: dibujo, descripcion: nombre + ": " + notas, nombre: "Pentagrama " + nombre)
    }

    private init(svg: String, descripcion: String, nombre: String) {
        self.svg = svg
        self.descripcion = descripcion
        self.relacionDeAspecto = PentagramaPresentado.relacionDeAspecto(deSVG: svg)
        self.fichero = .svg(svg, nombre: nombre)
    }

    /// El ancho entre el alto del `viewBox` de un SVG (`viewBox="0 -3 20 12"` → 1,67), o 4 si no lo tiene.
    public static func relacionDeAspecto(deSVG svg: String) -> Double {
        guard let inicio = svg.range(of: "viewBox=\"") else { return 4 }
        let resto = svg[inicio.upperBound...]
        guard let fin = resto.firstIndex(of: "\"") else { return 4 }
        let numeros = resto[..<fin].split(separator: " ").compactMap { Double($0) }
        guard numeros.count == 4, numeros[2] > 0, numeros[3] > 0 else { return 4 }
        return numeros[2] / numeros[3]
    }
}
