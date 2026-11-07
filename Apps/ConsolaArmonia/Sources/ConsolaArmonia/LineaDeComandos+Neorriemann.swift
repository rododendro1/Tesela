import Armonia
import Foundation

// MARK: - Neorriemanniano y conducción parsimoniosa

extension LineaDeComandos {
    /// `vecinos Sol7`: los acordes de su familia a un semitono.
    static func vecinos(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let voces = argumentos.quitarNumero(.voces, en: 1...2, porDefecto: 1) else {
            throw ErrorDeUso.vocesFueraDeRango
        }
        // `--ampliada`: la familia de las séptimas con los maj7, para un acorde de las séptimas.
        let tipos = argumentos.quitarMarca(.ampliada) ? TipoDeAcorde.familiaDeSeptimasAmpliada : nil
        let acordes = argumentos.restantes
        guard acordes.count == 1 else { throw ErrorDeUso.unAcordeDeVecinos }
        let acorde = try Acorde(leyendoEnLaOrden: acordes[0])
        let pasos =
            tipos.map { $0.contains(acorde.tipo) ? acorde.vecinosParsimoniosos(voces: voces, tipos: $0) : [] }
            ?? acorde.vecinosParsimoniosos(voces: voces)
        guard !pasos.isEmpty else {
            throw ErrorDeUso.vecinosSinFamilia
        }
        return bien(pasos.map { $0.texto(en: notacion) }.joined(separator: "\n"))
    }

    /// `camino-parsimonioso Sol7 Rem7`: Sol7 –Si→Do→ … paso a paso.
    static func caminoParsimonioso(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let voces = argumentos.quitarNumero(.voces, en: 1...2, porDefecto: 1) else {
            throw ErrorDeUso.vocesFueraDeRango
        }
        // `--ampliada`: la familia de las séptimas con los maj7, para un acorde de las séptimas.
        let tipos = argumentos.quitarMarca(.ampliada) ? TipoDeAcorde.familiaDeSeptimasAmpliada : nil
        let acordes = argumentos.restantes
        guard acordes.count == 2 else { throw ErrorDeUso.dosAcordesDeCamino }
        let origen = try Acorde(leyendoEnLaOrden: acordes[0])
        let destino = try Acorde(leyendoEnLaOrden: acordes[1])
        guard let camino = origen.caminoParsimonioso(hasta: destino, voces: voces, tipos: tipos) else {
            throw ErrorDeUso.caminoSinConexion
        }
        var texto = Acorde(origen.fundamental, origen.tipo).cifrado(en: notacion)
        for paso in camino {
            texto +=
                " –" + paso.movimientos.map { $0.texto(en: notacion) }.joined(separator: ", ") + "→ "
                + paso.acorde.cifrado(en: notacion)
        }
        return bien(texto + "\n" + Mensaje.pasos(camino.count).texto(en: notacion))
    }

    /// Lo que pide `plr`: unos pasos desde una tríada (`plr Do PLR`), el camino más corto entre dos (`plr camino Do
    /// Mibm`) o un ciclo desde una (`plr ciclo hexatonico Do`, como en `tonnetz`).
    enum PedidoDePLR {
        case pasos(Acorde, [TransformacionNeorriemanniana])
        case ciclo(Acorde, CicloNeorriemanniano)
    }

    /// Lee lo que pide `plr`; el camino se da ya como sus pasos.
    static func pedidoDePLR(_ argumentos: [String]) throws -> PedidoDePLR {
        if let desconocida = Argumentos(argumentos).opcionDesconocida {
            throw ErrorDeUso.opcionDesconocida(desconocida)
        }
        guard let primera = argumentos.first?.lowercased() else { throw ErrorDeUso.faltanPasosDePLR }
        let resto = Array(argumentos.dropFirst())
        if OpcionDeOrden.camino.leidos.contains("--" + primera) {
            guard resto.count == 2 else { throw ErrorDeUso.faltanPasosDePLR }
            let origen = try Acorde(leyendoEnLaOrden: resto[0])
            guard let camino = origen.caminoNeorriemanniano(hasta: try Acorde(leyendoEnLaOrden: resto[1])) else {
                throw ErrorDeUso.plrSoloTriadas(camino: true)
            }
            return .pasos(origen, camino)
        }
        if OpcionDeOrden.ciclo.leidos.contains("--" + primera) {
            guard let triada = resto.last, resto.count >= 2,
                let ciclo = try? CicloNeorriemanniano(leyendo: resto.dropLast().joined(separator: " "))
            else { throw ErrorDeUso.cicloMalEscrito(orden: "plr") }
            let origen = try Acorde(leyendoEnLaOrden: triada)
            guard Tonnetz.Triada(origen) != nil else { throw ErrorDeUso.cicloSoloTriadas(orden: "plr") }
            return .ciclo(origen, ciclo)
        }
        guard resto.count >= 1 else { throw ErrorDeUso.faltanPasosDePLR }
        let origen = try Acorde(leyendoEnLaOrden: argumentos[0])
        guard Tonnetz.Triada(origen) != nil else { throw ErrorDeUso.plrSoloTriadas(camino: false) }
        return .pasos(origen, try TransformacionNeorriemanniana.secuencia(leyendo: resto.joined(separator: " ")))
    }

    /// `plr Do PLR`: la tríada tras cada paso. `plr camino Do Mibm`: el camino más corto. `plr ciclo hexatonico Do`:
    /// el ciclo entero.
    static func plr(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (origen, pasos): (Acorde, [TransformacionNeorriemanniana])
        switch try pedidoDePLR(argumentos) {
        case .ciclo(let triada, let ciclo):
            // Do –P→ Dom –L→ La♭ … –L→ Do, con la ortografía más sencilla.
            let acordes = triada.ciclo(ciclo)!
            var texto = acordes[0].cifrado(en: notacion)
            for (i, acorde) in acordes.dropFirst().enumerated() {
                texto += " –\(ciclo.transformaciones[i % 2])→ " + acorde.cifrado(en: notacion)
            }
            return bien(
                texto + "\n" + Mensaje.ciclo(ciclo).texto(en: notacion) + ", "
                    + Mensaje.triadas(ciclo.longitud).texto(en: notacion))
        case .pasos(let triada, let leidos): (origen, pasos) = (triada, leidos)
        }
        // Do –P→ Dom –L→ La♭
        var acorde = origen.transformar([])!
        var texto = acorde.cifrado(en: notacion)
        for paso in pasos {
            acorde = acorde.transformar(paso)!
            texto += " –\(paso)→ " + acorde.cifrado(en: notacion)
        }
        let cuantos = Mensaje.pasos(pasos.count).texto(en: notacion)
        return bien(texto + "\n" + (pasos.isEmpty ? cuantos : pasos.map(\.rawValue).joined() + ", " + cuantos))
    }
}
