import Elementos
import Teoria

// MARK: - Los ornamentos, tocados
//
// Un ornamento se escribe con su signo encima de la nota (`Articulacion.trino`, `.grupeto`…), pero suena como varias
// notas: las de `OrnamentoConNombre.alturas(sobre:en:)`, por los grados de la escala, cada una con su duración. Aquí
// se reparten así, como se suelen tocar en el Barroco:
//
// - los trinos alternan la nota de encima y la principal en fusas (o en cuartos de la nota, si es más corta que una
//   corchea) todo lo que dura, empezando por la de encima; el trino acaba en la principal, que se queda con lo que
//   sobre, y el trino con terminación acaba en la de debajo y la principal;
// - las apoyaturas se quedan con la mitad de la nota (con dos tercios, si lleva puntillo) y la principal, con el
//   resto;
// - los grupetos tocan sus tres primeras notas en semicorcheas (o en cuartos de la nota) y la principal el resto;
// - los demás (los mordentes, el trino corto y el Schleifer) tocan sus notas rápidas en fusas (o en cuartos de la
//   nota) y la principal se sostiene el resto.
//
// La primera nota lleva la dinámica y las demás articulaciones, y la última, la ligadura.

extension OrnamentoConNombre {
    /// Las notas que suenan de este ornamento sobre `principal` en `escala`, cada una con su duración, que suman
    /// `duracion`; `nil` si la nota principal no es de la escala.
    ///
    ///     OrnamentoConNombre.apoyaturaSuperior.tocado(sobre: Altura(.re, octava: 4), en: Escala(.do), duracion: .negra)
    ///     // Mi4 en corchea y Re4 en corchea
    public func tocado(sobre principal: Altura, en escala: Escala, duracion: Duracion) -> [(
        altura: Altura, duracion: Duracion
    )]? {
        guard let sonidos = alturas(sobre: principal, en: escala) else { return nil }
        let ultima = sonidos[sonidos.count - 1]
        if self == .trino || self == .trinoConTerminacion {
            let unidad = min(Duracion.fusa, duracion / 4)
            let caben = duracion / unidad
            let final = self == .trino ? [sonidos[1]] : [sonidos[sonidos.count - 2], ultima]
            let cuantas = max(4, caben.numerador / caben.denominador / 2 * 2)
            let alternadas = (0..<(cuantas - final.count)).map { sonidos[$0 % 2] }
            let rapidas = (alternadas + final.dropLast()).map { ($0, unidad) }
            return rapidas + [(ultima, duracion - unidad * rapidas.count)]
        }
        if sonidos.count == 2 {
            let apoyo = duracion.numerador == 3 ? duracion * Duracion(2, 3) : duracion / 2
            return [(sonidos[0], apoyo), (ultima, duracion - apoyo)]
        }
        let esGrupeto = self == .grupeto || self == .grupetoInvertido
        let unidad = min(esGrupeto ? Duracion.semicorchea : .fusa, duracion / 4)
        let rapidas = sonidos.dropLast().map { ($0, unidad) }
        return rapidas + [(ultima, duracion - unidad * rapidas.count)]
    }
}

extension Articulacion {
    /// El ornamento del catálogo que suena con este signo; `nil` si no es un ornamento.
    ///
    ///     Articulacion.mordenteInferior.ornamento   // .mordente: la principal, la de debajo y la principal
    public var ornamento: OrnamentoConNombre? {
        switch self {
        case .trino: return .trino
        case .mordenteSuperior: return .mordenteSuperior
        case .mordenteInferior: return .mordente
        case .grupeto: return .grupeto
        case .grupetoInvertido: return .grupetoInvertido
        case .schleifer: return .schleifer
        case .trinoConTerminacion: return .trinoConTerminacion
        default: return nil
        }
    }
}

extension Evento {
    /// Las notas que suenan del ornamento de este evento en `escala`, cada una con su duración, que suman la del
    /// evento. Un evento sin ornamento, un silencio, un acorde o una nota que no es de la escala quedan tal cual.
    ///
    ///     let grupeto = try Evento(leyendo: "Re4:4{grupeto}")
    ///     grupeto.realizandoElOrnamento(en: Escala(.do))   // Mi4:16 Re4:16 Do4:16 Re4:16
    public func realizandoElOrnamento(en escala: Escala) -> [Evento] {
        guard notas.count == 1, let signo = articulaciones.first(where: \.esOrnamento),
            let partes = signo.ornamento?.tocado(sobre: alturas[0], en: escala, duracion: duracion)
        else { return [self] }
        let principal = notas[0]
        let resto = articulaciones.filter { $0 != signo }
        return partes.enumerated().map { indice, parte in
            let nota = parte.altura == principal.altura ? principal : NotaDelEvento(parte.altura)
            let primera = indice == 0
            return Evento(
                notas: [nota], duracion: parte.duracion, ligada: indice == partes.count - 1 && ligada,
                dinamica: primera ? dinamica : nil, articulaciones: primera ? resto : [])
        }
    }
}

extension Voz {
    /// La misma voz con cada ornamento tocado en sus notas (`Evento.realizandoElOrnamento(en:)`), en `escala`.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:4{mordenteInferior} Mi4:2")
    ///     voz.conLosOrnamentosRealizados(en: Escala(.do)).eventos.count   // 5
    public func conLosOrnamentosRealizados(en escala: Escala) -> Voz {
        Voz(eventos.flatMap { $0.realizandoElOrnamento(en: escala) }, compas: compas, anacrusa: anacrusa)
    }
}

extension Partitura {
    /// La misma partitura con los ornamentos de todas las voces tocados en sus notas, en la escala de la tonalidad
    /// del encabezado (la mayor o la menor natural) o, si no la da, en `escala`. Para oírlos en el MIDI:
    /// `partitura.conLosOrnamentosRealizados().midi()`. Lo que se anota en un momento (cifrados, marcadores…) sigue en
    /// su sitio, porque los ornamentos no cambian cuándo empieza cada nota escrita.
    public func conLosOrnamentosRealizados(en escala: Escala = Escala(.do)) -> Partitura {
        let deLaTonalidad = encabezado.tonalidad?.escala ?? escala
        var realizada = self
        for p in realizada.pentagramas.indices {
            for v in realizada.pentagramas[p].voces.indices {
                realizada.pentagramas[p].voces[v].voz =
                    realizada.pentagramas[p].voces[v].voz.conLosOrnamentosRealizados(en: deLaTonalidad)
            }
        }
        return realizada
    }
}
