import ArmoniaNucleo
import Foundation

// Dónde cae cada cosa en el pentagrama y cómo se escribe en SVG, para `PentagramaSVG.svg()`.

extension PentagramaSVG {
    // MARK: Geometría

    /// Altura en el dibujo de una posición del pentagrama: la línea de abajo (lugar 0) está en y = 4.
    static func y(deLugar lugar: Int, pentagrama: Int = 0) -> Double {
        4 - Double(lugar) / 2 + Double(pentagrama) * separacionDelPentagramaDoble
    }

    /// Líneas adicionales que necesita una nota: por debajo, desde el −2 hasta su posición; por encima, desde el 10.
    static func lugaresDeLasLineasAdicionales(de lugar: Int) -> [Int] {
        if lugar <= -2 { return stride(from: -2, through: lugar, by: -2).map { $0 } }
        if lugar >= 10 { return stride(from: 10, through: lugar, by: 2).map { $0 } }
        return []
    }

    /// El glifo de una clave y la posición de su línea de referencia.
    static func glifoYLugar(de clave: Clave) -> (Glifo, Int) {
        switch clave {
        case .sol: return (GlifosSMuFL.claveDeSol, 2)
        case .solOctavaBaja: return (GlifosSMuFL.claveDeSolOctavaBaja, 2)
        case .solOctavaAlta: return (GlifosSMuFL.claveDeSolOctavaAlta, 2)
        case .fa: return (GlifosSMuFL.claveDeFa, 6)
        case .faEnTercera: return (GlifosSMuFL.claveDeFa, 4)
        case .doEnPrimera: return (GlifosSMuFL.claveDeDo, 0)
        case .doEnSegunda: return (GlifosSMuFL.claveDeDo, 2)
        case .doEnTercera: return (GlifosSMuFL.claveDeDo, 4)
        case .doEnCuarta: return (GlifosSMuFL.claveDeDo, 6)
        }
    }

    /// Dónde se escribe cada alteración de la armadura: como en la clave de sol (Fa♯ en la 5.ª línea, Si♭ en la 3.ª),
    /// desplazada según la clave. Los sostenidos suben hasta el Sol de encima del pentagrama y los bemoles hasta el Mi
    /// de la 5.ª línea; cada uno, en la octava más alta que no pase de ahí.
    static func lugarEnLaArmadura(_ nota: Nota, clave: Clave, sostenidos: Bool) -> Int {
        let base = clave.alturaDeLaPrimeraLinea.pasos
        var desplazamiento = modulo(Altura(.mi, octava: 4).pasos - base, 7)
        if desplazamiento > 2 { desplazamiento -= 7 }
        let limite = (sostenidos ? 9 : 7) + desplazamiento
        let lugar = Altura(Nota(nota.natural), octava: 4).pasos - base
        return limite - modulo(limite - lugar, 7)
    }

    static func glifoDeAlteracion(_ semitonos: Int) -> Glifo {
        switch semitonos {
        case 0: return GlifosSMuFL.becuadro
        case 1: return GlifosSMuFL.sostenido
        case -1: return GlifosSMuFL.bemol
        case ..<(-1): return GlifosSMuFL.dobleBemol
        default: return GlifosSMuFL.dobleSostenido
        }
    }

    // MARK: Escritura

    /// Un glifo con su origen en `x` y en la altura de una posición del pentagrama.
    static func glifo(_ glifo: Glifo, x: Double, lugar: Int, pentagrama: Int = 0) -> String {
        "<path transform=\"translate(\(n(x)) \(n(y(deLugar: lugar, pentagrama: pentagrama))))\" d=\"\(glifo.trazado)\"/>"
    }

    /// Un número con tres decimales como mucho y sin ceros de más.
    static func n(_ valor: Double) -> String {
        let redondeado = (valor * 1000).rounded() / 1000
        var texto = "\(redondeado)"
        if texto.hasSuffix(".0") { texto.removeLast(2) }
        return texto == "-0" ? "0" : texto
    }
}
