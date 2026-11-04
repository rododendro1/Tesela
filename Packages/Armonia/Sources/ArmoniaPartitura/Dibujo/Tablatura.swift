// La tablatura que puede ir debajo de un pentagrama (`Partitura.Pentagrama.cuerdas`): el número de cuerdas y,
// por nota, la cuerda y el traste. Las posiciones las da el mástil (`ArmoniaTrastes`); aquí solo se dibujan.

/// Una tablatura alineada con las notas de un pentagrama.
///
///     // Do Mi Sol en la guitarra: 5.ª cuerda, traste 3; 4.ª, 2; 3.ª, al aire.
///     let tablatura = Tablatura(cuerdas: 6, notas: [
///         0: [.init(cuerda: 4, traste: 3)], 1: [.init(cuerda: 3, traste: 2)], 2: [.init(cuerda: 2, traste: 0)],
///     ])
public struct Tablatura: Hashable, Sendable, Codable {
    /// Una nota en la tablatura: la cuerda, contada desde la línea de arriba (la cuerda más aguda, la 1.ª de la
    /// guitarra, es la 0), y el traste (0, al aire).
    public struct Pulsacion: Hashable, Sendable, Codable {
        public let cuerda: Int
        public let traste: Int

        /// Una nota en esa cuerda (0 es la más grave) y en ese traste (0 al aire).
        public init(cuerda: Int, traste: Int) {
            self.cuerda = cuerda
            self.traste = traste
        }
    }

    /// Cuántas líneas tiene: una por cuerda.
    public let cuerdas: Int
    /// Lo que se pulsa en cada nota (o acorde), por su índice: el del evento en una voz, el de la columna en unas
    /// disposiciones.
    public let notas: [Int: [Pulsacion]]

    /// Una tablatura de `cuerdas` líneas con lo que se pulsa en cada nota, por su índice (ver `notas`).
    public init(cuerdas: Int, notas: [Int: [Pulsacion]]) {
        self.cuerdas = cuerdas
        self.notas = notas
    }
}
