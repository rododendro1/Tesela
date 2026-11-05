import ArmoniaNucleo

// La ventana de quintas de una escala: las doce quintas seguidas que tienen sus notas y nombran las demás como lo hace
// la escala con un cromatismo suelto. Es lo que necesita un dibujo que no sabe nada de la escala (un teclado, el
// reloj, un mástil) para nombrar todas las notas como las escribiría ella.

extension Escala {
    /// Las doce quintas seguidas que contienen las notas de la escala (al subir y al bajar), lo más centradas posible
    /// en ellas; si hay dos igual de centradas, la más cercana a la dominante de la tónica. Con ella, una nota que no
    /// es de la escala se nombra como en ``nombre(claseDeAltura:alturaActual:siguiente:)`` sin nota siguiente, al
    /// menos en las mayores, las menores armónicas y melódicas y los modos dórico, lidio y mixolidio:
    ///
    ///     Escala("Do mayor").ventanaDeQuintas          // La♭–Do♯
    ///     Escala("La menor armónica").ventanaDeQuintas // Si♭–Re♯
    ///     Escala("Fa mayor").ventanaDeQuintas          // Re♭–Fa♯
    ///
    /// `nil` si las notas no caben en doce quintas: si la escala tiene, por ejemplo, Re♭ y Do♯.
    public var ventanaDeQuintas: VentanaDeQuintas? {
        let propias = notasEnAmbasDirecciones.map(\.pasosDeQuinta)
        guard let menor = propias.min(), let mayor = propias.max(), mayor - menor <= 11 else { return nil }
        let centro = centroDeQuintas
        let dominante = Double(tonica.pasosDeQuinta + 1)
        func coste(_ inicio: Int) -> [Double] {
            let medio = Double(inicio) + 5.5
            return [abs(medio - centro), abs(medio - dominante), Double(-inicio)]
        }
        let inicio = ((mayor - 11)...menor).min { coste($0).lexicographicallyPrecedes(coste($1)) } ?? menor
        return VentanaDeQuintas(inicio: inicio)
    }
}

extension Tonalidad {
    /// La de su escala de referencia (en menor, la armónica, con la sensible): Do mayor, de La♭ a Do♯; La menor, de
    /// Si♭ a Re♯. Ver `Escala.ventanaDeQuintas`.
    public var ventanaDeQuintas: VentanaDeQuintas {
        escalaDeReferencia.ventanaDeQuintas ?? .armadura(armadura)
    }
}
