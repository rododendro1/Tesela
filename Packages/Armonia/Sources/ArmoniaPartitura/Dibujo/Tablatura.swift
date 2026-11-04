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
    ///
    /// El mástil (`PosicionEnElMastil.cuerda`, en `ArmoniaTrastes`) las cuenta al revés, desde la más grave:
    /// `init(cuerdaDesdeLaGrave:de:traste:)` convierte de una cuenta a la otra.
    ///
    ///     // El Do3 de la guitarra: 5.ª cuerda (la 1 del mástil, desde la grave), traste 3.
    ///     Tablatura.Pulsacion(cuerdaDesdeLaGrave: 1, de: 6, traste: 3).cuerda   // 4
    public struct Pulsacion: Hashable, Sendable, Codable {
        /// La cuerda, desde la más aguda (la línea de arriba): 0 es la 1.ª de la guitarra.
        public let cuerda: Int
        public let traste: Int

        /// Una nota en esa cuerda (0 es la más aguda, la línea de arriba) y en ese traste (0 al aire).
        public init(cuerda: Int, traste: Int) {
            self.cuerda = cuerda
            self.traste = traste
        }

        /// Una nota en la cuerda `cuerdaDesdeLaGrave` de un instrumento de `cuerdas` cuerdas, contada como en el
        /// mástil (0 es la más grave), y en ese traste.
        public init(cuerdaDesdeLaGrave: Int, de cuerdas: Int, traste: Int) {
            self.init(cuerda: cuerdas - 1 - cuerdaDesdeLaGrave, traste: traste)
        }

        /// La cuerda contada como en el mástil, desde la más grave, en un instrumento de `cuerdas` cuerdas.
        public func cuerdaDesdeLaGrave(de cuerdas: Int) -> Int { cuerdas - 1 - cuerda }
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

    /// Una tablatura de `cuerdas` líneas con lo que se pulsa en cada nota, por su índice, con las cuerdas contadas
    /// como en el mástil (0 es la más grave, como `PosicionEnElMastil.cuerda`).
    ///
    ///     // Do Mi Sol en la guitarra, con las posiciones del mástil.
    ///     let tablatura = Tablatura(cuerdas: 6, desdeLaGrave: [0: [(1, 3)], 1: [(2, 2)], 2: [(3, 0)]])
    ///     tablatura.notas[0]?.first?.cuerda   // 4
    public init(cuerdas: Int, desdeLaGrave notas: [Int: [(cuerda: Int, traste: Int)]]) {
        self.init(
            cuerdas: cuerdas,
            notas: notas.mapValues { pulsaciones in
                pulsaciones.map { Pulsacion(cuerdaDesdeLaGrave: $0.cuerda, de: cuerdas, traste: $0.traste) }
            })
    }
}
