import Armonia

/// Una progresión hecha con los acordes de una escala (la húngara menor, la doble armónica…), con su análisis: los
/// grados en números romanos frente a la mayor o la menor de la misma tónica y las notas que no son de esa.
public struct ProgresionDeLaEscala: Hashable, Sendable {
    /// «i–♯vii–i».
    public let grados: String
    public let acordes: [Acorde]
    /// «Lam – Sol♯m – Lam».
    public let cifrados: String
    /// «Fuera de La menor: Re♯, Sol♯»; vacío si todas son de ella.
    public let fuera: String
    public let sonido: Escucha
}

extension PresentacionDeEstudioDeEscala {
    /// Los grados de las progresiones de ejemplo: I–IV–V–I, ii–V–I, I–vi–IV–V, I–ii–I y I–vii–I.
    static let progresionesDeEjemplo = [[1, 4, 5, 1], [2, 5, 1], [1, 6, 4, 5], [1, 2, 1], [1, 7, 1]]

    /// Progresiones con las tríadas de la escala, para oír cómo suena: las de ``progresionesDeEjemplo`` que se
    /// pueden hacer con ella (si un grado no da una tríada conocida, la progresión no está). Solo de las escalas de
    /// siete notas; vacío en las demás.
    ///
    ///     let progresiones = PresentacionDeEstudioDeEscala.progresiones(
    ///         de: Escala(.la, .menorHungara), en: .espanolCompacto)
    ///     progresiones.last?.cifrados   // "Lam – Sol♯m – Lam"
    public static func progresiones(de escala: Escala, en notacion: Notacion) -> [ProgresionDeLaEscala] {
        guard escala.notas.count == 7 else { return [] }
        // Frente a la menor natural si tiene la tercera menor; si no, frente a la mayor.
        let clases = Set(escala.notas.map(\.claseDeAltura))
        let tonica = escala.tonica.claseDeAltura
        let esMenor = clases.contains((tonica + 3) % 12) && !clases.contains((tonica + 4) % 12)
        let referencia = Escala(escala.tonica, esMenor ? .menorNatural : .mayor)
        let deLaReferencia = Set(referencia.notas.map(\.claseDeAltura))
        return progresionesDeEjemplo.compactMap { grados in
            let acordes = grados.compactMap { escala.acorde(grado: $0) }
            guard acordes.count == grados.count else { return nil }
            var romanos: [String] = []
            for grado in grados {
                if let romano = escala.cifradoRomano(grado: grado, referencia: referencia.tipo) {
                    romanos.append(romano)
                } else {
                    romanos.append(String(grado))
                }
            }
            var ajenas: [Nota] = []
            for nota in acordes.flatMap(\.notas)
            where !deLaReferencia.contains(nota.claseDeAltura) && !ajenas.contains(nota) {
                ajenas.append(nota)
            }
            let lista = ajenas.map { $0.nombre(en: notacion) }.joined(separator: ", ")
            let nombre = referencia.nombre(en: notacion)
            return ProgresionDeLaEscala(
                grados: romanos.joined(separator: "–"), acordes: acordes,
                cifrados: acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – "),
                fuera: ajenas.isEmpty ? "" : notacion.texto { $0.notasFueraDe(nombre, lista) },
                sonido: Escucha.acordes(acordes).conTonica(escala.tonica))
        }
    }
}
