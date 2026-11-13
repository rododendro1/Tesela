import Elementos
import Foundation

// MARK: - El carácter de una afinación

/// Qué es una afinación (`AfinacionPropia`) frente a los doce semitonos iguales: temperada, justa, microtonal
/// o una octava partida en otro número de partes iguales. No se escribe: sale de su sistema y de cuánto se aparta
/// cada grado de su nota temperada.
///
///     TipoDeEscala.bayati.caracterDeLaAfinacion     // .microtonal: Mi𝄳, un cuarto de tono
///     TipoDeEscala.kalyan.caracterDeLaAfinacion     // .justa: los śruti, razones justas
///     TipoDeEscala.slendro.caracterDeLaAfinacion    // .partesIguales(5)
///     TipoDeEscala.mayor.caracterDeLaAfinacion      // nil: no tiene afinación propia
public enum CaracterDeLaAfinacion: Hashable, Sendable {
    /// Los doce semitonos iguales: ningún grado se aparta más de un cent.
    case temperada
    /// Razones justas o pitagóricas, que no cambian cuál de las doce notas es cada grado: se apartan menos de
    /// `umbralMicrotonal` (la coma sintónica es de 21,5 cents). Los śruti indios, Zarlino, las afinaciones chinas.
    case justa
    /// Notas que los doce semitonos no tienen: los cuartos de tono árabes, el koron persa, los moria bizantinos, la
    /// tercera neutra del blues, el género enarmónico griego. También los makamlar en sus 53 comas, que por tradición
    /// se tienen por microtonales aunque se aparten menos.
    case microtonal
    /// La octava en otro número de partes iguales: el sléndro y el amadinda en cinco, el timbila y el piphat en siete,
    /// el pélog en nueve.
    case partesIguales(Int)

    /// Desde cuántos cents se aparta un grado para que la afinación sea microtonal: más que la coma pitagórica
    /// (23,5), menos que un sexto de tono.
    public static let umbralMicrotonal: Double = 30

    /// El nombre de la clave, como en `--afinacion`: «temperada», «justa», «microtonal», «partes-iguales».
    public var clave: String {
        switch self {
        case .temperada: "temperada"
        case .justa: "justa"
        case .microtonal: "microtonal"
        case .partesIguales: "partes-iguales"
        }
    }

    /// ¿Tiene notas fuera de los doce semitonos (microtonal o en otras partes iguales)?
    public var tieneMicrotonos: Bool {
        switch self {
        case .microtonal, .partesIguales: true
        case .temperada, .justa: false
        }
    }
}

extension AfinacionPropia {
    /// El carácter de esta afinación: en las 53 comas, microtonal; en los śruti, justa; si sus cents caen todos en
    /// una octava partida en 5 a 11 partes iguales, esas partes; y si no, por lo que más se aparta un grado de su nota
    /// temperada, al subir o al bajar: hasta un cent, temperada; desde `umbralMicrotonal`, microtonal; entre medias,
    /// justa.
    public var caracter: CaracterDeLaAfinacion {
        switch sistema {
        case .comas53: return .microtonal
        case .sruti: return .justa
        case .cuartosDeTono, .persa, .moria72, .razones: break
        }
        let todos = cents(sentido: .ascendente) + cents(sentido: .descendente)
        if sistema == .razones,
            let partes = (5...11).first(where: { partes in
                let paso = 1200 / Double(partes)
                return todos.allSatisfy { abs($0 / paso - ($0 / paso).rounded()) * paso <= 1.5 }
            })
        {
            return .partesIguales(partes)
        }
        let desvio = (desvios(sentido: .ascendente) + desvios(sentido: .descendente)).map(abs).max() ?? 0
        if desvio <= 1 { return .temperada }
        return desvio >= CaracterDeLaAfinacion.umbralMicrotonal ? .microtonal : .justa
    }
}

extension TipoDeEscala {
    /// El carácter de su afinación propia (`afinacionPropia`, la de su teoría de hoy); `nil` si no tiene una, como las
    /// occidentales, que se tocan en los doce semitonos iguales.
    public var caracterDeLaAfinacion: CaracterDeLaAfinacion? { afinacionPropia?.caracter }

    /// ¿Tiene notas que los doce semitonos no tienen: es microtonal o parte la octava en otras partes iguales?
    public var esMicrotonal: Bool { caracterDeLaAfinacion?.tieneMicrotonos ?? false }
}
