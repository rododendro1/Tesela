import ArmoniaElementos

// Las notas de una escala con los nombres de otra tradición (`SistemaDeNombres`): el sargam desde la tónica de la
// escala (Re dórico es Sā Re ga ma Pa Dha ni) y el bizantino con Ni en Do (el primer echos, sobre Re, es Pa Vou Ga Di
// Ke Zo Ni), también en su versión microtonal (Pa Vou⁻² Ga Di Ke Zo⁻² Ni, en moria).

extension Escala {
    /// Los nombres de las notas de la escala en un sistema de otra tradición. En los móviles, como el sargam, desde
    /// la tónica de la escala; en los fijos, como el bizantino, los de cada nota.
    ///
    ///     Escala(.re, .dorico).nombres(en: .sargam)       // Sā Re ga ma Pa Dha ni
    ///     Escala(.re, .dorico).nombres(en: .bizantino)    // Pa Vou Ga Di Ke Zo Ni
    ///     Escala(.do, .mayor).nombres(en: .sargam, grafia: .original)     // सा रे ग म प ध नि
    public func nombres(en sistema: SistemaDeNombres, grafia: Grafia = .transliterada) -> [String] {
        sistema.nombres(de: notas, tonica: tonica, grafia: grafia)
    }
}

extension NotaMicrotonal {
    /// El nombre en un sistema de otra tradición, con el signo de su sistema microtonal detrás: «Vou⁻²» (dos moria
    /// bajo Vou), «Ga↓» (una coma bajo el Ga pitagórico). En los móviles, el grado se cuenta desde `tonica`.
    public func nombre(
        en sistemaDeNombres: SistemaDeNombres, tonica: Nota = Nota(.do), grafia: Grafia = .transliterada
    ) -> String {
        let base = sistemaDeNombres.nombre(de: temperada, tonica: tonica, grafia: grafia)
        guard ajuste != 0 else { return base }
        // El signo del ajuste, como lo escribe `nombre(en:)` tras la nota temperada: ⁻², ↓, (−37¢).
        let notacion: Notacion = grafia == .ascii ? .espanolASCII : .espanolCompacto
        let completo = NotaMicrotonal.nombre(temperada, sistema: sistema, ajuste: ajuste, en: notacion)
        let temperado = temperada.nombre(en: notacion)
        guard completo.hasPrefix(temperado) else { return base + "(\(ajuste > 0 ? "+" : "")\(ajuste))" }
        return base + String(completo.dropFirst(temperado.count))
    }
}
