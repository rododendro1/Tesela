import Elementos
import Teoria

// MARK: - Los trastes, como los numera quien toca
//
// El mástil cuenta las posiciones en semitonos desde la cuerda al aire (o desde el capo), porque así se calcula lo
// que suena. Quien toca los numera de otro modo en dos instrumentos del catálogo: el dulcémele numera sus trastes
// diatónicos uno tras otro (el 4 es la quinta, a siete semitonos, y el que se añadió entre el 6 y el 7 es el
// «6½»), y en el banjo de cinco cuerdas la quinta, que es corta y nace en el 5.º traste, se numera con los trastes
// del mástil (pisarla dos trastes por encima de su cejilla es el 7).

extension Mastil {
    /// Cuántos trastes le faltan a una cuerda porque es corta: 5 en la quinta del banjo; 0 en las demás.
    public func trastesQueLeFaltan(aLaCuerda cuerda: Int) -> Int { encordado.ficha?.cuerdasCortas[cuerda] ?? 0 }

    /// El traste del mástil, contado desde la cejilla del instrumento, en que cae una posición: el mismo, salvo en las
    /// cuerdas cortas, que nacen más arriba.
    ///
    ///     Mastil(.banjo).trasteDelMastil(PosicionEnElMastil(cuerda: 0, traste: 2))   // 7
    public func trasteDelMastil(_ posicion: PosicionEnElMastil) -> Int {
        posicion.traste + trastesQueLeFaltan(aLaCuerda: posicion.cuerda)
    }

    /// La posición de una cuerda en un traste del mástil (la inversa de `trasteDelMastil(_:)`); `nil` si la cuerda,
    /// corta, no llega hasta ahí.
    public func posicion(cuerda: Int, enElTrasteDelMastil traste: Int) -> PosicionEnElMastil? {
        let propio = traste - trastesQueLeFaltan(aLaCuerda: cuerda)
        return propio >= 0 ? PosicionEnElMastil(cuerda: cuerda, traste: propio) : nil
    }

    /// Cómo se escribe el traste de una posición en la tablatura, como lo numera quien toca: «6½» en el dulcémele,
    /// «7» en la quinta cuerda del banjo pisada dos trastes por encima de su cejilla, y el número en los demás. Al
    /// aire, siempre «0».
    ///
    ///     Mastil(.dulcemele).rotulo(de: PosicionEnElMastil(cuerda: 0, traste: 11))   // "6½"
    public func rotulo(de posicion: PosicionEnElMastil) -> String {
        guard posicion.traste > 0 else { return "0" }
        if let ficha = encordado.ficha, let deLaOctava = ficha.trastesDeLaOctava {
            return Mastil.rotuloDiatonico(
                posicion.traste + encordado.capo, desde: encordado.capo, trastes: deLaOctava,
                medios: ficha.mediosTrastes)
        }
        return String(trasteDelMastil(posicion))
    }

    /// El número de un traste del mástil, contado desde el capo, en la regla de debajo del dibujo: el del dulcémele
    /// por sus trastes («6½»), `nil` si el instrumento no tiene ese traste en ninguna cuerda (los que le faltan al
    /// dulcémele, todos en los instrumentos sin trastes), y el número en los demás.
    public func rotulo(delTrasteDelMastil traste: Int) -> String? {
        guard traste > 0 else { return nil }
        if encordado.trastes == .sinTrastes { return nil }
        guard let ficha = encordado.ficha, let deLaOctava = ficha.trastesDeLaOctava else { return String(traste) }
        let absoluto = traste + encordado.capo
        guard deLaOctava.contains(absoluto % 12) else { return nil }
        return Mastil.rotuloDiatonico(absoluto, desde: encordado.capo, trastes: deLaOctava, medios: ficha.mediosTrastes)
    }

    /// Si se dibuja la línea de un traste del mástil (contado desde el capo): no en los instrumentos sin trastes ni
    /// en los que le faltan al dulcémele. La cejilla (el 0) siempre.
    public func tieneLineaDeTraste(_ traste: Int) -> Bool {
        traste == 0 || rotulo(delTrasteDelMastil: traste) != nil
    }

    /// El número de un traste diatónico, a `absoluto` semitonos de la cejilla: los trastes de la escala que hay
    /// entre el capo (en `desde`) y él, y «½» detrás si es uno de los añadidos.
    static func rotuloDiatonico(_ absoluto: Int, desde capo: Int, trastes: Set<Int>, medios: Set<Int>) -> String {
        let deLaEscala = trastes.subtracting(medios)
        let cuantos = ((capo + 1)...max(capo + 1, absoluto)).filter { deLaEscala.contains($0 % 12) }.count
        return medios.contains(absoluto % 12) ? "\(cuantos)½" : "\(cuantos)"
    }
}
