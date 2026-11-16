import Elementos

// MARK: - El catálogo de ornamentos
//
// Los ornamentos del Barroco con nombre: los trinos, los mordentes, los grupetos, las apoyaturas y el Schleifer, cada
// uno con su realización en grados de la escala y la tabla que la da (la «Explication» del Clavier-Büchlein de
// J. S. Bach, el Versuch de C. P. E. Bach). Los nombres en los otros idiomas están en `Ornamentos/Nombres/`.

extension OrnamentoConNombre {
    /// La nota superior y la principal, alternadas desde la superior: el «trillo» de la «Explication» de J. S. Bach.
    public static let trino = OrnamentoConNombre(
        nombre: "trino", pasos: [1, 0, 1, 0, 1, 0, 1, 0], alias: ["trillo"], referencias: [.neumann1978, .bachCPE1753],
        documentada: .bach1720)
    /// El trino que acaba en la nota inferior y vuelve a la principal: el «trillo und mordant» de Bach.
    public static let trinoConTerminacion = OrnamentoConNombre(
        nombre: "trino con terminación", pasos: [1, 0, 1, 0, 1, 0, -1, 0], referencias: [.neumann1978],
        documentada: .bach1720)
    /// Dos veces la superior y la principal, rápido y ligado: el Pralltriller de C. P. E. Bach.
    public static let trinoCorto = OrnamentoConNombre(
        nombre: "trino corto", pasos: [1, 0, 1, 0], alias: ["Pralltriller"], referencias: [.neumann1978],
        documentada: .bachCPE1753)
    /// La principal, la inferior y la principal: el «mordant» de Bach.
    public static let mordente = OrnamentoConNombre(
        nombre: "mordente", pasos: [0, -1, 0], alias: ["mordente inferior"], referencias: [.neumann1978, .bachCPE1753],
        documentada: .bach1720)
    /// La principal, la superior y la principal: el Schneller.
    public static let mordenteSuperior = OrnamentoConNombre(
        nombre: "mordente superior", pasos: [0, 1, 0], alias: ["Schneller"], referencias: [.neumann1978])
    /// La superior, la principal, la inferior y la principal: la «cadence» de Bach.
    public static let grupeto = OrnamentoConNombre(
        nombre: "grupeto", pasos: [1, 0, -1, 0], alias: ["gruppetto"], referencias: [.neumann1978, .bachCPE1753],
        documentada: .bach1720)
    /// El grupeto al revés: la inferior, la principal, la superior y la principal.
    public static let grupetoInvertido = OrnamentoConNombre(
        nombre: "grupeto invertido", pasos: [-1, 0, 1, 0], referencias: [.neumann1978, .bachCPE1753])
    /// La nota de arriba, en el tiempo, que resuelve en la principal: el «accent fallend» de Bach.
    public static let apoyaturaSuperior = OrnamentoConNombre(
        nombre: "apoyatura superior", pasos: [1, 0], referencias: [.neumann1978, .bachCPE1753], documentada: .bach1720)
    /// La nota de abajo, en el tiempo, que resuelve en la principal: el «accent steigend» de Bach.
    public static let apoyaturaInferior = OrnamentoConNombre(
        nombre: "apoyatura inferior", pasos: [-1, 0], referencias: [.neumann1978, .bachCPE1753], documentada: .bach1720)
    /// Dos notas por grados desde abajo hasta la principal: el Schleifer de C. P. E. Bach.
    public static let schleifer = OrnamentoConNombre(
        nombre: "Schleifer", pasos: [-2, -1, 0], alias: ["deslizamiento"], referencias: [.neumann1978],
        documentada: .bachCPE1753)

    /// Todo el catálogo, en el orden de este fichero.
    public static let catalogo: [OrnamentoConNombre] = [
        .trino, .trinoConTerminacion, .trinoCorto, .mordente, .mordenteSuperior, .grupeto, .grupetoInvertido,
        .apoyaturaSuperior, .apoyaturaInferior, .schleifer,
    ]
}
