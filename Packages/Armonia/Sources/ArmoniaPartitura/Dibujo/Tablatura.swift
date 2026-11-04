// La tablatura que puede ir debajo de un pentagrama (`Partitura.Pentagrama.cuerdas`): el número de cuerdas y,
// por nota, la cuerda y el traste. Las posiciones las da el mástil (`ArmoniaTrastes`); aquí solo se dibujan.

/// Una tablatura alineada con las notas de un pentagrama. Las cuerdas se cuentan como en el mástil
/// (`PosicionEnElMastil.cuerda`, en `ArmoniaTrastes`): 0 es la más grave. Al dibujarla, la más aguda va arriba.
///
///     // Do Mi Sol en la guitarra: 5.ª cuerda (la 1 desde la grave), traste 3; 4.ª, 2; 3.ª, al aire.
///     let tablatura = Tablatura(cuerdas: 6, notas: [
///         0: [.init(cuerda: 1, traste: 3)], 1: [.init(cuerda: 2, traste: 2)], 2: [.init(cuerda: 3, traste: 0)],
///     ])
public struct Tablatura: Hashable, Sendable, Codable {
    /// Una nota en la tablatura: la cuerda, contada desde la más grave como en el mástil (la 6.ª de la guitarra es
    /// la 0), y el traste (0, al aire).
    ///
    ///     // El Do3 de la guitarra: 5.ª cuerda (la 1 desde la grave), traste 3.
    ///     Tablatura.Pulsacion(cuerda: 1, traste: 3)
    public struct Pulsacion: Hashable, Sendable, Codable {
        /// La cuerda, desde la más grave: 0 es la 6.ª de la guitarra.
        public let cuerda: Int
        public let traste: Int

        /// Una nota en esa cuerda (0 es la más grave) y en ese traste (0 al aire).
        public init(cuerda: Int, traste: Int) {
            self.cuerda = cuerda
            self.traste = traste
        }

        /// La línea en que se dibuja en una tablatura de `cuerdas` cuerdas, desde arriba: la cuerda más aguda es la 0.
        func linea(de cuerdas: Int) -> Int { cuerdas - 1 - cuerda }
    }

    /// Cuántas líneas tiene: una por cuerda.
    public let cuerdas: Int
    /// Lo que se pulsa en cada nota (o acorde), por su índice: el del evento en una voz, el de la columna en unas
    /// disposiciones.
    public let notas: [Int: [Pulsacion]]

    /// Una tablatura de `cuerdas` líneas con lo que se pulsa en cada nota, por su índice (ver `notas`), con las
    /// cuerdas contadas desde la más grave.
    public init(cuerdas: Int, notas: [Int: [Pulsacion]]) {
        self.cuerdas = cuerdas
        self.notas = notas
    }
}
