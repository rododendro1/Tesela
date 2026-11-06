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

    /// `conduccion-parsimoniosa Sol7 Rem7`: Sol7 –Si→Do→ … paso a paso.
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

    /// `plr Do PLR`: la tríada tras cada paso. `plr Do Mibm`: el camino más corto.
    static func plr(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        guard argumentos.count >= 2 else { throw ErrorDeUso.faltanPasosDePLR }
        let origen = try Acorde(leyendoEnLaOrden: argumentos[0])
        guard Tonnetz.Triada(origen) != nil else { throw ErrorDeUso.plrSoloTriadas(camino: false) }
        let resto = argumentos.dropFirst().joined(separator: " ")
        let pasos: [TransformacionNeorriemanniana]
        if let secuencia = try? TransformacionNeorriemanniana.secuencia(leyendo: resto) {
            pasos = secuencia
        } else if let ciclo = try? CicloNeorriemanniano(leyendo: resto) {
            // Do –P→ Dom –L→ La♭ … –L→ Do, con la ortografía más sencilla.
            let acordes = origen.ciclo(ciclo)!
            var texto = acordes[0].cifrado(en: notacion)
            for (i, acorde) in acordes.dropFirst().enumerated() {
                texto += " –\(ciclo.transformaciones[i % 2])→ " + acorde.cifrado(en: notacion)
            }
            return bien(
                texto + "\n" + Mensaje.ciclo(ciclo).texto(en: notacion) + ", "
                    + Mensaje.triadas(ciclo.longitud).texto(en: notacion))
        } else {
            let destino = try Acorde(leyendoEnLaOrden: resto)
            guard let camino = origen.caminoNeorriemanniano(hasta: destino) else {
                throw ErrorDeUso.plrSoloTriadas(camino: true)
            }
            pasos = camino
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
