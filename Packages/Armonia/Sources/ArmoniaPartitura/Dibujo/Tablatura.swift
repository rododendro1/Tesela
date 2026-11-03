// La tablatura que puede ir debajo de un pentagrama (`Voz.svgPentagrama(…, tablatura:)`): el número de cuerdas y,
// por nota, la cuerda y el traste. Las posiciones las da el mástil (`ArmoniaTrastes`); aquí solo se dibujan.

/// Una tablatura alineada con las notas de un pentagrama.
///
///     // Do Mi Sol en la guitarra: 5.ª cuerda, traste 3; 4.ª, 2; 3.ª, al aire.
///     let tablatura = Tablatura(cuerdas: 6, notas: [
///         0: [.init(cuerda: 4, traste: 3)], 1: [.init(cuerda: 3, traste: 2)], 2: [.init(cuerda: 2, traste: 0)],
///     ])
public struct Tablatura: Hashable, Sendable {
    /// Una nota en la tablatura: la cuerda, contada desde la línea de arriba (la cuerda más aguda, la 1.ª de la
    /// guitarra, es la 0), y el traste (0, al aire).
    public struct Pulsacion: Hashable, Sendable {
        public let cuerda: Int
        public let traste: Int

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

    public init(cuerdas: Int, notas: [Int: [Pulsacion]]) {
        self.cuerdas = cuerdas
        self.notas = notas
    }
}
