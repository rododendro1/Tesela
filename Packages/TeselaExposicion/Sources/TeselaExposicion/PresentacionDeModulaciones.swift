import Armonia

/// Una manera de modular de una tonalidad a otra, lista para mostrar: a dónde, cómo, por qué acorde y la progresión
/// entera, para escucharla.
public struct ModulacionPresentada: Hashable, Sendable {
    public let plan: PlanDeModulacion
    /// «Sol mayor».
    public let destino: String
    /// «acorde común», «séptima disminuida enarmónica» o «directa».
    public let tecnica: String
    /// «Lam = vi en Do mayor = ii en Sol mayor»; `nil` en la directa.
    public let pivote: String?
    /// «Do Fa Sol7 Do Lam Re7 Sol».
    public let acordes: String
    public let sonido: Escucha
}

/// Las modulaciones desde una tonalidad de `armonia tonalidad --modulaciones` y de la vista de análisis: a sus
/// tonos vecinos o a la que se pida, con el acorde pivote y una progresión de ejemplo. No usa SwiftUI, así que se
/// prueba en Linux.
///
///     let aSol = PresentacionDeModulaciones.modulaciones(
///         desde: Tonalidad(.do), hasta: Tonalidad(.sol), en: .espanolCompacto)
///     aSol.first?.pivote   // "Lam = vi en Do mayor = ii en Sol mayor"
public enum PresentacionDeModulaciones {
    /// Sin `hasta`, la manera más suave de llegar a cada tono vecino (``Tonalidad/vecinas``); con ella, todas las
    /// maneras de llegar a esa, de la más suave a la más brusca.
    public static func modulaciones(
        desde tonalidad: Tonalidad, hasta destino: Tonalidad? = nil, en notacion: Notacion
    ) -> [ModulacionPresentada] {
        let planes =
            destino.map { tonalidad.modulaciones(hasta: $0) }
            ?? tonalidad.vecinas.compactMap { tonalidad.modulaciones(hasta: $0).first }
        return planes.map { presentar($0, en: notacion) }
    }

    /// Un plan de modulación, escrito en la notación.
    public static func presentar(_ plan: PlanDeModulacion, en notacion: Notacion) -> ModulacionPresentada {
        let tecnica =
            switch plan.tecnica {
            case .acordeComun: notacion.texto(\.modulacionPorAcordeComun)
            case .disminuidaEnarmonica: notacion.texto(\.modulacionPorDisminuida)
            case .directa: notacion.texto(\.modulacionDirecta)
            }
        return ModulacionPresentada(
            plan: plan, destino: plan.hasta.nombre(en: notacion), tecnica: tecnica,
            pivote: plan.pivote?.descripcion(en: notacion),
            acordes: plan.acordes.map { $0.cifrado(en: notacion) }.joined(separator: " "),
            sonido: Escucha.acordes(plan.acordes).conTonica(plan.desde.tonica))
    }
}
