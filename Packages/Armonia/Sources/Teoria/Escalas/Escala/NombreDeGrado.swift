import Elementos
import Foundation

// MARK: - Funciones de grado

/// Nombre funcional de cada grado de una escala heptatónica.
public enum NombreDeGrado: Hashable, Sendable, CustomStringConvertible {
    case tonica, supertonica, mediante, subdominante, dominante, superdominante
    /// 7.º grado a un semitono de la tónica (Si en Do mayor, Sol♯ en La menor armónica).
    case sensible
    /// 7.º grado a un tono de la tónica (Sol en La menor natural).
    case subtonica

    public var description: String { nombre }

    /// Lee el nombre de una función en español o en inglés, sin distinguir mayúsculas ni tildes:
    /// "Dominante", "superdominante", "submediante", "sensible", "leading tone"… Si no es ninguna, lanza
    /// `ErrorDeLecturaDeTeoria` con sus nombres (`.nombreNoReconocido`).
    public init(leyendo texto: String) throws {
        let clave = texto.claveDeBusqueda
        let alias: [String: NombreDeGrado] = [
            "submediante": .superdominante, "sub mediante": .superdominante,
            "superdominant": .superdominante, "leading note": .sensible,
        ]
        if let funcion = alias[clave] {
            self = funcion
            return
        }
        let todas: [NombreDeGrado] = [
            .tonica, .supertonica, .mediante, .subdominante, .dominante,
            .superdominante, .sensible, .subtonica,
        ]
        guard
            let funcion = todas.first(where: { f in
                f.nombre.claveDeBusqueda == clave || f.nombre(en: .ascii(.ingles)).claveDeBusqueda == clave
            })
        else {
            throw ErrorDeLecturaDeTeoria(
                texto: texto, posicion: nil, motivo: .nombreNoReconocido(texto, opciones: todas.map(\.nombre)))
        }
        self = funcion
    }
}

extension NombreDeGrado: Nombrable {}

extension Escala {
    /// Función del grado `grado` (contado desde 1) en una escala heptatónica; `nil` en otras escalas.
    public func nombreDeGrado(_ grado: Int) -> NombreDeGrado? {
        guard tipo.intervalos.count == 7 else { return nil }
        let i = modulo(grado - 1, 7)
        let funciones: [NombreDeGrado] = [
            .tonica, .supertonica, .mediante, .subdominante,
            .dominante, .superdominante,
        ]
        if i < 6 { return funciones[i] }
        return tipo.intervalos[6].semitonos == 11 ? .sensible : .subtonica
    }

    /// Función de una nota en la escala, si pertenece a ella.
    public func nombreDeGrado(de nota: Nota) -> NombreDeGrado? {
        grado(de: nota).flatMap { nombreDeGrado($0) }
    }
}

// MARK: - Idiomas
//
// Nombres de los grados de la escala en los trece idiomas de los textos (`Traduccion`). El resto de nombres que
// dependen del idioma, en `Fundamentos/Nota.swift` y `Fundamentos/Intervalo.swift`.

// MARK: - NombreDeGrado

extension NombreDeGrado {
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .tonica: return TextosDeTeoria.traduccion(\.gradoTonica)
        case .supertonica: return TextosDeTeoria.traduccion(\.gradoSupertonica)
        case .mediante: return TextosDeTeoria.traduccion(\.gradoMediante)
        case .subdominante:
            return TextosDeTeoria.traduccion(\.gradoSubdominante)
        case .dominante: return TextosDeTeoria.traduccion(\.gradoDominante)
        case .superdominante:
            return TextosDeTeoria.traduccion(\.gradoSuperdominante)
        case .sensible: return TextosDeTeoria.traduccion(\.gradoSensible)
        case .subtonica: return TextosDeTeoria.traduccion(\.gradoSubtonica)
        }
    }
}
