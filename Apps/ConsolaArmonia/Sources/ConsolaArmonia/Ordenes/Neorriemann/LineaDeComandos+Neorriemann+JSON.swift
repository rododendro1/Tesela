import Armonia
import Exposicion
import Foundation

// `--json` de la teoría neorriemanniana: vecinos, caminos, conducción mínima y plr. Lo común a todas las órdenes
// está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Teoría neorriemanniana

    /// Una voz que se mueve: «Si→Do», en semitonos (+ hacia arriba).
    struct MovimientoJSON: Encodable {
        let desde: String
        let hasta: String
        let semitonos: Int

        init(_ movimiento: MovimientoDeVoz, _ notacion: Notacion) {
            desde = movimiento.desde.nombre(en: notacion)
            hasta = movimiento.hasta.nombre(en: notacion)
            semitonos = movimiento.semitonos
        }
    }

    /// Un paso de `vecinos` o de `camino-parsimonioso`: el acorde al que se llega y las voces que se mueven.
    struct PasoJSON: Encodable {
        let acorde: String
        let movimientos: [MovimientoJSON]

        init(_ paso: PasoParsimonioso, _ notacion: Notacion) {
            acorde = paso.acorde.cifrado(en: notacion)
            movimientos = paso.movimientos.map { MovimientoJSON($0, notacion) }
        }
    }

    /// La familia de `--ampliada` y las voces de `--voces`, comunes a `vecinos` y `camino-parsimonioso`.
    private static func conduccionPedida(_ textos: [String]) throws -> (
        voces: Int, tipos: [TipoDeAcorde]?, acordes: [String]
    ) {
        var argumentos = Argumentos(textos)
        guard let voces = argumentos.quitarNumero(.voces, en: 1...2, porDefecto: 1) else {
            throw ErrorDeUso.vocesFueraDeRango
        }
        let tipos = argumentos.quitarMarca(.ampliada) ? TipoDeAcorde.familiaDeSeptimasAmpliada : nil
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        return (voces, tipos, argumentos.restantes)
    }

    /// `vecinos Sol7 --json`: los vecinos, cada uno con las voces que se mueven.
    static func vecinosJSON(_ textos: [String], _ notacion: Notacion) throws -> [PasoJSON] {
        let (voces, tipos, acordes) = try conduccionPedida(textos)
        guard acordes.count == 1 else { throw ErrorDeUso.unAcordeDeVecinos }
        let acorde = try Acorde(leyendoEnLaOrden: acordes[0])
        let pasos =
            tipos.map { $0.contains(acorde.tipo) ? acorde.vecinosParsimoniosos(voces: voces, tipos: $0) : [] }
            ?? acorde.vecinosParsimoniosos(voces: voces)
        guard !pasos.isEmpty else { throw ErrorDeUso.vecinosSinFamilia }
        return pasos.map { PasoJSON($0, notacion) }
    }

    struct CaminoJSON: Encodable {
        let desde: String
        let pasos: [PasoJSON]
    }

    /// `camino-parsimonioso Sol7 Rem7 --json`: el acorde de partida y cada paso.
    static func caminoParsimoniosoJSON(_ textos: [String], _ notacion: Notacion) throws -> CaminoJSON {
        let (voces, tipos, acordes) = try conduccionPedida(textos)
        guard acordes.count == 2 else { throw ErrorDeUso.dosAcordesDeCamino }
        let origen = try Acorde(leyendoEnLaOrden: acordes[0])
        let destino = try Acorde(leyendoEnLaOrden: acordes[1])
        guard let camino = origen.caminoParsimonioso(hasta: destino, voces: voces, tipos: tipos) else {
            throw ErrorDeUso.caminoSinConexion
        }
        return CaminoJSON(
            desde: Acorde(origen.fundamental, origen.tipo).cifrado(en: notacion),
            pasos: camino.map { PasoJSON($0, notacion) })
    }

    struct ConduccionMinimaJSON: Encodable {
        let movimientos: [MovimientoJSON]
        let semitonos: Int
    }

    /// `conduccion-minima Sol7 Do --json`: cada voz y los semitonos que se mueven en total.
    static func conduccionMinimaJSON(_ textos: [String], _ notacion: Notacion) throws -> ConduccionMinimaJSON {
        let acordes = try palabras(Argumentos(textos), siFaltan: .dosAcordesDeConduccion)
        guard acordes.count == 2 else { throw ErrorDeUso.dosAcordesDeConduccion }
        let conduccion = try Acorde(leyendoEnLaOrden: acordes[0]).conduccionMinima(
            hasta: try Acorde(leyendoEnLaOrden: acordes[1]))
        return ConduccionMinimaJSON(
            movimientos: conduccion.movimientos.map { MovimientoJSON($0, notacion) },
            semitonos: conduccion.semitonosMovidos)
    }

    /// Un paso de `plr --json`: la transformación (P, L, R…) y la tríada a la que lleva.
    struct TransformacionJSON: Encodable {
        let transformacion: String
        let acorde: String
    }

    struct PLRJSON: Encodable {
        let desde: String
        let pasos: [TransformacionJSON]
        /// `hexatonico`, `octatonico` o `lr`, si es un ciclo.
        let ciclo: String?
    }

    /// `plr Do PLR --json`, `plr camino Do Mibm --json`, `plr ciclo hexatonico Do --json`: los pasos, como en el texto.
    static func plrJSON(_ argumentos: [String], _ notacion: Notacion) throws -> PLRJSON {
        let (origen, pasos): (Acorde, [TransformacionNeorriemanniana])
        switch try pedidoDePLR(argumentos) {
        case .ciclo(let triada, let ciclo):
            let acordes = triada.ciclo(ciclo)!
            return PLRJSON(
                desde: acordes[0].cifrado(en: notacion),
                pasos: acordes.dropFirst().enumerated().map { i, acorde in
                    TransformacionJSON(
                        transformacion: "\(ciclo.transformaciones[i % 2])", acorde: acorde.cifrado(en: notacion))
                },
                ciclo: ciclo.rawValue)
        case .pasos(let triada, let leidos): (origen, pasos) = (triada, leidos)
        }
        var acorde = origen.transformar([])!
        let desde = acorde.cifrado(en: notacion)
        var transformaciones: [TransformacionJSON] = []
        for paso in pasos {
            acorde = acorde.transformar(paso)!
            transformaciones.append(TransformacionJSON(transformacion: "\(paso)", acorde: acorde.cifrado(en: notacion)))
        }
        return PLRJSON(desde: desde, pasos: transformaciones, ciclo: nil)
    }
}
