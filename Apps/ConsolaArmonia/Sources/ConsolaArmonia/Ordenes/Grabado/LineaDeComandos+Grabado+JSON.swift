import Armonia
import Exposicion
import Foundation

// `--json` de `grabar --motores`. Lo común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Motores de grabado

    /// Un motor de `grabar`: su programa y su versión, o la variable que da su ruta si no está instalado.
    struct MotorJSON: Encodable {
        let motor: String
        let instalado: Bool
        let ruta: String?
        let version: String?
        let variable: String
    }

    /// `motores --json`: cada motor de `grabar`.
    static func motoresJSON(_ textos: [String], _ notacion: Notacion) throws -> [MotorJSON] {
        if let sobrante = textos.first { throw ErrorDeUso.opcionDesconocida(sobrante) }
        return try MotorDeGrabado.allCases.map { motor in
            let variable = EjecutorDelSistema.variable(de: motor.programas[0])
            guard let ruta = programaDelMotor(motor) else {
                return MotorJSON(motor: motor.rawValue, instalado: false, ruta: nil, version: nil, variable: variable)
            }
            return MotorJSON(
                motor: motor.rawValue, instalado: true, ruta: ruta, version: try versionDelMotor(motor, en: ruta),
                variable: variable)
        }
    }
}
