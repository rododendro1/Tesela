import Elementos
import Teoria

// MARK: - Un ritmo del catálogo, para tocarlo

extension RitmoConNombre {
    /// La duración de cada pulso: una semicorchea si la unidad es 16.
    public var pulso: Duracion { Duracion(1, unidad) }

    /// El compás de un ciclo, con su agrupación, reducido mientras se pueda: la clave (16 semicorcheas en grupos de
    /// 4) es un 4/4; el bembé, un 12/8; la ruchenitsa, un 2+2+3/8; el tīntāl, un 4+4+4+4/4.
    ///
    ///     RitmoConNombre.claveDeSon.compas.description   // "4/4"
    public var compas: Compas {
        var numerador = pulsos
        var denominador = unidad
        var grupos = agrupacion
        while denominador > 4, grupos.allSatisfy({ $0.isMultiple(of: 2) }) {
            numerador /= 2
            denominador /= 2
            grupos = grupos.map { $0 / 2 }
        }
        return Compas(comprobando: numerador, denominador, agrupacion: grupos) ?? Compas(pulsos, 4)
    }

    /// Lo que dura cada golpe hasta el siguiente, dando la vuelta: [3, 3, 2] corcheas en el tresillo.
    ///
    ///     RitmoConNombre.tresillo.duraciones   // [3/8, 3/8, 1/4]
    public var duraciones: [Duracion] { intervalos.map { Duracion($0, unidad) } }

    /// El ritmo tocado en una nota, `ciclos` veces, en su compás: un silencio hasta el primer golpe si no empieza en
    /// él, y cada golpe hasta el siguiente. Los fuertes llevan acento.
    ///
    ///     RitmoConNombre.tresillo.voz().eventos.count   // 3
    public func voz(en nota: Altura = Altura(.do, octava: 4), ciclos: Int = 1) -> Voz {
        let ataques = self.ataques
        guard let primero = ataques.first, ciclos > 0 else { return Voz([], compas: compas) }
        var eventos: [Evento] = []
        if primero > 0 { eventos.append(.silencio(Duracion(primero, unidad))) }
        let golpes = self.golpes
        for ciclo in 0..<ciclos {
            for (i, ataque) in ataques.enumerated() {
                let ultimo = ciclo == ciclos - 1 && i == ataques.count - 1
                // El último golpe acaba con el ciclo; los demás, en el golpe siguiente.
                let fin = i + 1 < ataques.count ? ataques[i + 1] : (ultimo ? pulsos : pulsos + primero)
                eventos.append(
                    Evento(
                        alturas: [nota], duracion: Duracion(fin - ataque, unidad),
                        articulaciones: golpes[ataque] == .fuerte ? [.acento] : []))
            }
        }
        return Voz(eventos, compas: compas)
    }
}
