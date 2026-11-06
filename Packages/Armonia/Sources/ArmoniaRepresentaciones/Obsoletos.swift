import ArmoniaNucleo
import ArmoniaTeoria

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension Tonnetz {
    /// La forma de antes de `Acorde.caminoNeorriemanniano(hasta:enarmonico:)`, que está en ArmoniaTeoria con el
    /// resto de la teoría neorriemanniana.
    @available(*, deprecated, renamed: "Acorde.caminoNeorriemanniano(hasta:enarmonico:)")
    public static func camino(
        desde origen: Acorde, hasta destino: Acorde, enarmonico: Bool = false
    ) -> [TransformacionNeorriemanniana]? {
        origen.caminoNeorriemanniano(hasta: destino, enarmonico: enarmonico)
    }

    /// La forma de antes de `Acorde.caminoParsimonioso(hasta:voces:tipos:)`, que está en ArmoniaTeoria.
    @available(*, deprecated, renamed: "Acorde.caminoParsimonioso(hasta:voces:tipos:)")
    public static func caminoParsimonioso(
        desde origen: Acorde, hasta destino: Acorde, voces: Int = 1, tipos: [TipoDeAcorde]? = nil
    ) -> [PasoParsimonioso]? {
        origen.caminoParsimonioso(hasta: destino, voces: voces, tipos: tipos)
    }
}
