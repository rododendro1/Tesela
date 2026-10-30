import Armonia
import ArmoniaPresentacion

/// La parte de `DiagramaDeMastil` que no es dibujo: qué trastes se enseñan, qué cuerdas se apagan, cómo se
/// escriben las notas y cómo se describe el mástil a VoiceOver. No usa SwiftUI, así que se prueba
/// también en Linux.
enum PresentacionDeMastil {
    /// Cuántos trastes se enseñan como mínimo cuando la mano está lejos de la cejilla.
    static let trastesMinimosEnVentana = 4

    /// Los trastes que se dibujan para una digitación.
    ///
    /// Con la mano cerca de la cejilla (hasta el traste 4) se ve desde la cejilla hasta el 5. Más arriba,
    /// una ventana con un traste de margen por cada lado. En una ventana que no incluye el 0 las cuerdas
    /// al aire se dibujan en un canal a la izquierda, no se pierden.
    static func rango(de digitacion: Digitacion) -> ClosedRange<Int> {
        let pisados = digitacion.trastesPisados
        guard let menor = pisados.min(), let mayor = pisados.max(), mayor > 4 else { return 0...5 }
        let desde = max(0, menor - 1)
        let hasta = max(mayor + 1, desde + trastesMinimosEnVentana - 1)
        return desde...hasta
    }

    /// Los márgenes del dibujo, en puntos: a los lados, encima de la cuerda más aguda y debajo de la más
    /// grave (donde van los números de traste). Los usan el dibujo y `posicion(enX:y:…)`.
    static let margenX = 8.0
    static let margenSuperior = 8.0
    static let margenInferior = 22.0

    /// La posición que se toca en un dibujo de `ancho` por `alto`: el traste es la columna del toque, y la cuerda,
    /// la más cercana (la 0, la grave, abajo). `nil` en los márgenes, en el canal de las cuerdas al aire
    /// (`conCanal`) o lejos de cualquier cuerda.
    static func posicion(enX x: Double, y: Double, ancho: Double, alto: Double, cuerdas: Int,
                         rango: ClosedRange<Int>, conCanal: Bool) -> PosicionEnElMastil? {
        guard cuerdas > 0 else { return nil }
        let anchoCasilla = (ancho - 2 * margenX) / Double(rango.count + (conCanal ? 1 : 0))
        let inicioX = margenX + (conCanal ? anchoCasilla : 0)
        guard anchoCasilla > 0, x >= inicioX, x < ancho - margenX else { return nil }
        let traste = rango.lowerBound + Int((x - inicioX) / anchoCasilla)
        guard rango.contains(traste) else { return nil }
        let yMaximo = alto - margenInferior
        let separacion = cuerdas > 1 ? (alto - margenSuperior - margenInferior) / Double(cuerdas - 1) : 0
        let cuerda = separacion > 0 ? Int(((yMaximo - y) / separacion).rounded()) : 0
        guard (0..<cuerdas).contains(cuerda) else { return nil }
        // Con una sola cuerda, hasta 12 puntos por encima o por debajo.
        guard abs(yMaximo - Double(cuerda) * separacion - y) <= max(separacion / 2, 12) else { return nil }
        return PosicionEnElMastil(cuerda: cuerda, traste: traste)
    }

    /// Las cuerdas (índices desde 0) que no suenan en la digitación.
    static func apagadas(de digitacion: Digitacion) -> Set<Int> {
        Set(digitacion.trastes.indices.filter { digitacion.trastes[$0] == nil })
    }

    /// La nota con que se escribe cada clase de altura (0…11): la ortografía del acorde o de la escala,
    /// y no la de `Altura(midi:)`, que usa siempre sostenidos (Si♭ saldría como La♯). Si dos notas
    /// comparten clase, gana la primera.
    static func ortografia(de notas: [Nota]) -> [Int: Nota] {
        Dictionary(notas.map { ($0.claseDeAltura, $0) }, uniquingKeysWith: { primera, _ in primera })
    }

    /// Una descripción corta para VoiceOver, en el idioma de los textos.
    static func descripcion(marcas: [PosicionEnElMastil], apagadas: Set<Int>, en notacion: Notacion = .espanolUnicode) -> String {
        var partes: [String] = []
        if marcas.count > 12 {
            partes.append(notacion.texto(.marcas(marcas.count)))
        } else {
            partes += marcas.sorted { ($0.cuerda, $0.traste) < ($1.cuerda, $1.traste) }
                .map { notacion.texto(.posicion(cuerda: $0.cuerda + 1, traste: $0.traste)) }
        }
        if !apagadas.isEmpty {
            partes.append(notacion.texto(.cuerdasApagadas(apagadas.sorted().map { String($0 + 1) }.joined(separator: ", "))))
        }
        return partes.isEmpty ? notacion.texto(.sinMarcas) : partes.joined(separator: "; ")
    }

    /// Lo que es el diagrama, para VoiceOver: «Mástil de guitarra, trastes 0 a 5».
    static func etiqueta(de mastil: Mastil, rango: ClosedRange<Int>, en notacion: Notacion = .espanolUnicode) -> String {
        notacion.texto(.mastilDe(mastil.encordado.nombre(en: notacion), desde: rango.lowerBound, hasta: rango.upperBound))
    }
}
