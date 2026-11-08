import Armonia

/// Los acordes de cada grado de una escala en las doce tonalidades, de quinta en quinta: una fila por tonalidad y una
/// columna por grado, para estudiarlos y escucharlos, y la partitura con todos.
public struct TablaDeAcordesPresentada: Hashable, Sendable {
    /// Los acordes de una tonalidad.
    public struct Fila: Hashable, Sendable {
        /// «Sol mayor».
        public let tonalidad: String
        /// Un cifrado por grado: «Lam7», «Re7»…
        public let acordes: [String]
        /// Los acordes de la fila, uno detrás de otro.
        public let sonido: Escucha
    }

    /// «Do mayor · Acordes en las doce tonalidades».
    public let titulo: String
    /// El cifrado romano de cada grado, igual en todas las tonalidades: «ii7», «V7»…
    public let grados: [String]
    public let filas: [Fila]
    /// Todas las filas seguidas.
    public let sonido: Escucha
    public let ficheros: [FicheroParaExportar]
}

extension PresentacionDeEstudioDeEscala {
    /// Los acordes de cada grado de la escala (cuatriadas o tríadas) en las doce tonalidades, de quinta en quinta
    /// desde la suya, cada uno en posición cerrada desde Do3. `nil` si algún grado no forma un acorde conocido (una
    /// pentatónica, por ejemplo).
    ///
    ///     let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(Escala(.do),
    ///         en: .compacta(.espanol))
    ///     tabla?.grados[4]              // "V7"
    ///     tabla?.filas[1].acordes[4]    // "Re7": el V7 de Sol mayor
    public static func acordesEnLasDoceTonalidades(
        _ escala: Escala, cuatriadas: Bool = true, en notacion: Notacion
    ) -> TablaDeAcordesPresentada? {
        let grados = escala.cifradosRomanos(cuatriadas: cuatriadas).compactMap { $0 }
        let tonalidades = escala.enLasDoceTonalidades.map { transportada in
            (escala: transportada, acordes: transportada.armonizar(cuatriadas: cuatriadas).compactMap { $0 })
        }
        let voces = tonalidades.flatMap { $0.acordes.map { Escucha.cerrada($0.notasDesdeElBajo, desde: 48) } }
        guard grados.count == escala.notas.count, tonalidades.allSatisfy({ $0.acordes.count == grados.count }),
            let coral = try? Coral(voces)
        else { return nil }
        let titulo = escala.nombre(en: notacion) + " · " + notacion.texto(\.acordesEnLasDoceTonalidades)
        let filas = tonalidades.map { tonalidad in
            TablaDeAcordesPresentada.Fila(
                tonalidad: tonalidad.escala.nombre(en: notacion),
                acordes: tonalidad.acordes.map { $0.cifrado(en: notacion) },
                sonido: .acordes(tonalidad.acordes))
        }
        return TablaDeAcordesPresentada(
            titulo: titulo, grados: grados, filas: filas, sonido: .coral(voces),
            ficheros: PresentacionDeCoral.ficheros(coral, nil, notacion, nombre: titulo))
    }
}
