import ArmoniaNucleo
import ArmoniaTeoria
// Eventos: una nota, un acorde o un silencio con su duración.

// MARK: - Evento

/// Una nota, un acorde o un silencio con su duración. `ligada` indica que se prolonga en el
/// evento siguiente (las mismas notas).
///
///     let e: Evento = "Do4:4."            // Do4, negra con puntillo
///     Evento("Do4+Mi4+Sol4:2")            // acorde de blancas
///     Evento("-:8")                       // silencio de corchea
///     Evento("Re4:2~")                    // ligada a la siguiente
public struct Evento: Hashable, Sendable {
    /// Alturas que suenan; vacío si es un silencio.
    public let alturas: [Altura]
    public let duracion: Duracion
    public let ligada: Bool

    public init(alturas: [Altura], duracion: Duracion, ligada: Bool = false) {
        self.alturas = alturas
        self.duracion = duracion
        self.ligada = ligada && !alturas.isEmpty
    }

    public init(_ nota: Altura, _ duracion: Duracion, ligada: Bool = false) {
        self.init(alturas: [nota], duracion: duracion, ligada: ligada)
    }

    public static func silencio(_ duracion: Duracion) -> Evento { Evento(alturas: [], duracion: duracion) }

    /// Lee "notas:duración", con las notas de un acorde unidas por "+", "-" (o "silencio")
    /// para un silencio y "~" al final si está ligada: "Do4:4", "C4+E4:2.", "-:8", "Re4:2~".
    public init(leyendo texto: String) throws {
        let caracteres = Array(texto)
        guard let dosPuntos = caracteres.lastIndex(of: ":") else {
            throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto.trimmingEspacios()))
        }
        var parteDuracion = String(caracteres[(dosPuntos + 1)...]).trimmingEspacios()
        let ligada = parteDuracion.hasSuffix("~")
        if ligada { parteDuracion.removeLast() }
        let duracion: Duracion
        do { duracion = try Duracion(leyendo: parteDuracion) } catch let e as ErrorDeLectura {
            throw ErrorDeLectura(texto: texto, posicion: dosPuntos + 1, motivo: e.motivo)
        }
        let parteNotas = String(caracteres[..<dosPuntos])
        let limpia = parteNotas.trimmingEspacios()
        if limpia == "-" || limpia.claveDeBusqueda == "silencio" {
            self.init(alturas: [], duracion: duracion)
            return
        }
        var alturas: [Altura] = []
        var inicio = 0
        for trozo in parteNotas.split(separator: "+", omittingEmptySubsequences: false) {
            do { alturas.append(try Altura(leyendo: String(trozo))) } catch let e as ErrorDeLectura {
                throw ErrorDeLectura(texto: texto, posicion: inicio + (e.posicion ?? 0), motivo: e.motivo)
            }
            inicio += trozo.count + 1
        }
        self.init(alturas: alturas, duracion: duracion, ligada: ligada)
    }

    public var esSilencio: Bool { alturas.isEmpty }

    public func transponer(_ intervalo: Intervalo) -> Evento {
        Evento(alturas: alturas.map { $0.transponer(intervalo) }, duracion: duracion, ligada: ligada)
    }
}

extension Evento: CustomStringConvertible {
    public var description: String { texto }
}

extension Evento: RepresentableComoTexto, Transponible {
    public func texto(en notacion: Notacion) -> String {
        let notasTexto = esSilencio ? "-" : alturas.map { $0.texto(en: notacion) }.joined(separator: "+")
        return notasTexto + ":" + duracion.texto(en: notacion) + (ligada ? "~" : "")
    }
}
