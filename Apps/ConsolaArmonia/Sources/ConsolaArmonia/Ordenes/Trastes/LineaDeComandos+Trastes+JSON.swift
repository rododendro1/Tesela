import Armonia
import Exposicion
import Foundation

// `--json` de los trastes: digitaciones y posiciones. Lo común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Digitaciones

    struct DigitacionesJSON: Encodable {
        struct Forma: Encodable {
            /// «x32010», de la cuerda más grave a la más aguda.
            let tablatura: String
            /// El traste de cada cuerda, de la más grave a la más aguda: 0 al aire y `null` si no se toca.
            let trastes: [Int?]
            /// Las notas que suenan, de la cuerda más grave a la más aguda.
            let notas: [String]
            let dedos: Int
            /// El traste de la cejilla, si la hay.
            let cejilla: Int?
        }
        let cifrado: String
        let instrumento: String
        /// El traste del capo; 0 sin capo. Los trastes de las formas se cuentan desde él.
        let capo: Int
        /// De la más cómoda a la menos; vacía si no hay ninguna.
        let formas: [Forma]
    }

    /// `digitaciones Sol7/Si --instrumento ukelele --json`: las formas de cada acorde, una lista aunque sea uno solo.
    /// Admite las mismas opciones que el texto, salvo `--diagrama` y `--musicxml`, que no cambian nada.
    static func digitacionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [DigitacionesJSON] {
        let pedido = try pedidoDeDigitaciones(textos)
        let instrumento = Mensaje.instrumento(pedido.encordado).texto(en: notacion)
        return try pedido.acordes.map { texto in
            let acorde = try Acorde(leyendo: texto, enLaOrden: notacion)
            return DigitacionesJSON(
                cifrado: acorde.cifrado(en: notacion), instrumento: instrumento, capo: pedido.capo,
                formas: pedido.formas(de: acorde).map { forma in
                    DigitacionesJSON.Forma(
                        tablatura: forma.tablatura, trastes: forma.trastes,
                        notas: forma.notas(para: acorde).map { $0.nombre(en: notacion) }, dedos: forma.dedos,
                        cejilla: forma.cejilla)
                })
        }
    }

    // MARK: Posiciones

    /// Una nota de una posición del mástil: la cuerda (con su número tradicional: 1 es la más aguda), el traste y la
    /// nota.
    struct NotaEnElMastilJSON: Encodable {
        let cuerda: Int
        let traste: Int
        let nota: String
    }

    struct PosicionJSON: Encodable {
        /// La forma CAGED (`C`, `A`, `G`, `E`, `D`), con `--caged`.
        let forma: String?
        let desdeElTraste: Int
        let hastaElTraste: Int
        let notas: [NotaEnElMastilJSON]
    }

    struct PosicionesJSON: Encodable {
        let escala: String
        let instrumento: String
        let capo: Int
        let posiciones: [PosicionJSON]
    }

    /// `posiciones Sol mayor [--caged] [--instrumento bajo] [--capo 2] --json`: cada posición con sus notas, de grave a
    /// agudo. `--arpegio`, `--formas` y `--secuencia` no dan JSON.
    static func posicionesJSON(_ textos: [String], _ notacion: Notacion) throws -> PosicionesJSON {
        var argumentos = Argumentos(textos)
        for opcion in [OpcionDeOrden.arpegio, .formas, .bajando, .barrido, .idaYVuelta]
        where argumentos.quitarMarca(opcion) {
            throw ErrorDeUso.sinSalidaJSON("posiciones " + opcion.nombres[0])
        }
        if try argumentos.valor(.secuencia) != nil { throw ErrorDeUso.sinSalidaJSON("posiciones --secuencia") }
        let caged = argumentos.quitarMarca(.caged)
        let mastil = try mastilDeLasPosiciones(&argumentos)
        let escala = try Escala(
            leyendo: palabras(argumentos, siFaltan: .faltaEscalaDePosiciones).joined(separator: " "))
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        let encordado = mastil.encordado
        return PosicionesJSON(
            escala: escala.nombre(en: notacion), instrumento: encordado.nombre(en: notacion), capo: encordado.capo,
            posiciones: posiciones.map { posicion in
                PosicionJSON(
                    forma: posicion.forma?.rawValue, desdeElTraste: posicion.rangoDeTrastes.lowerBound,
                    hastaElTraste: posicion.rangoDeTrastes.upperBound,
                    notas: posicion.posiciones.map {
                        NotaEnElMastilJSON(
                            cuerda: encordado.numeroTradicional(deCuerda: $0.cuerda), traste: $0.traste,
                            nota: mastil.altura(en: $0).nombre(en: notacion))
                    })
            })
    }
}
