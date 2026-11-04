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
///     Evento("Mi♭4(50¢):4")               // Mi♭4 cincuenta cents más alto: el Mi𝄳 de un maqam
///     Evento("Sol4:8{f,staccato}")        // forte y picada
public struct Evento: Hashable, Sendable {
    /// Las notas que suenan, cada una con su altura y lo que se aparta de la temperada; vacío si es un silencio.
    public let notas: [Nota]
    /// Las alturas de `notas`, en el mismo orden.
    public let alturas: [Altura]
    public let duracion: Duracion
    public let ligada: Bool
    /// La dinámica que se marca en este evento, si se marca alguna (`Expresion.swift`).
    public let dinamica: Dinamica?
    /// Sus articulaciones, sin repetir y en el orden de `Articulacion.allCases`.
    public let articulaciones: [Articulacion]

    /// Un evento con sus notas, cada una con su desvío: `[Evento.Nota("Do4"), Evento.Nota("Mi♭4", desvio: 50)]`.
    public init(
        notas: [Nota], duracion: Duracion, ligada: Bool = false, dinamica: Dinamica? = nil,
        articulaciones: [Articulacion] = []
    ) {
        self.notas = notas
        self.alturas = notas.map(\.altura)
        self.duracion = duracion
        self.ligada = ligada && !notas.isEmpty
        self.dinamica = dinamica
        self.articulaciones = Articulacion.allCases.filter(articulaciones.contains)
    }

    /// Un evento con alturas temperadas, sin desvíos.
    public init(
        alturas: [Altura], duracion: Duracion, ligada: Bool = false, dinamica: Dinamica? = nil,
        articulaciones: [Articulacion] = []
    ) {
        self.init(
            notas: alturas.map { Nota($0) }, duracion: duracion, ligada: ligada, dinamica: dinamica,
            articulaciones: articulaciones)
    }

    public init(_ nota: Altura, _ duracion: Duracion, ligada: Bool = false, desvio: Double = 0) {
        self.init(notas: [Nota(nota, desvio: desvio)], duracion: duracion, ligada: ligada)
    }

    public static func silencio(_ duracion: Duracion) -> Evento { Evento(notas: [], duracion: duracion) }

    /// ¿Se aparta alguna nota de su nota temperada?
    public var esMicrotonal: Bool { notas.contains { $0.desvio != 0 } }

    /// Las mismas alturas (con sus desvíos, su dinámica y sus articulaciones) con otra duración y otra ligadura.
    public func con(duracion: Duracion, ligada: Bool) -> Evento {
        Evento(
            notas: notas, duracion: duracion, ligada: ligada, dinamica: dinamica, articulaciones: articulaciones)
    }

    /// El mismo evento con otra dinámica y otras articulaciones.
    ///
    ///     ("Do4:4" as Evento).con(dinamica: .p, articulaciones: [.tenuto])   // Do4:4{p,tenuto}
    public func con(dinamica: Dinamica?, articulaciones: [Articulacion]) -> Evento {
        Evento(
            notas: notas, duracion: duracion, ligada: ligada, dinamica: dinamica, articulaciones: articulaciones)
    }

    /// Si lleva dinámica o articulaciones.
    public var tieneExpresion: Bool { dinamica != nil || !articulaciones.isEmpty }

    /// El mismo evento sin dinámica ni articulaciones: lo que sigue de una nota que se parte en varias ligadas, que
    /// las lleva solo en la primera.
    package var sinExpresion: Evento { con(dinamica: nil, articulaciones: []) }

    /// Lee "notas:duración", con las notas de un acorde unidas por "+", "-" (o "silencio")
    /// para un silencio y "~" al final si está ligada: "Do4:4", "C4+E4:2.", "-:8", "Re4:2~". Una nota que se aparta
    /// de la temperada lleva los cents entre paréntesis: "Mi♭4(50¢):4", "Si4(-22.64c):4". La dinámica y las
    /// articulaciones van al final, entre llaves: "Do4:4{mf}", "Re4:2~{acento,tenuto}" (`Expresion.swift`).
    public init(leyendo texto: String) throws {
        let caracteres = Array(texto)
        guard let dosPuntos = caracteres.lastIndex(of: ":") else {
            throw ErrorDeLecturaDePartitura(
                texto: texto, posicion: nil, motivo: .duracionNoValida(texto.trimmingEspacios()))
        }
        var parteDuracion = String(caracteres[(dosPuntos + 1)...]).trimmingEspacios()
        var dinamica: Dinamica?
        var articulaciones: [Articulacion] = []
        if parteDuracion.hasSuffix("}"), let llave = parteDuracion.firstIndex(of: "{") {
            let posicionDeLaLlave = texto.count - parteDuracion.distance(from: llave, to: parteDuracion.endIndex)
            let marcas = parteDuracion[parteDuracion.index(after: llave)...].dropLast()
            for marca in marcas.split(separator: ",") {
                let clave = String(marca).trimmingEspacios().claveDeBusqueda
                if let leida = Dinamica(rawValue: clave), dinamica == nil {
                    dinamica = leida
                } else if let leida = Articulacion(clave: clave) {
                    articulaciones.append(leida)
                } else {
                    throw ErrorDeLectura(
                        texto: texto, posicion: posicionDeLaLlave, motivo: .caracteresSobrantes(String(marca)))
                }
            }
            parteDuracion = String(parteDuracion[..<llave]).trimmingEspacios()
        }
        let ligada = parteDuracion.hasSuffix("~")
        if ligada { parteDuracion.removeLast() }
        let duracion: Duracion
        do { duracion = try Duracion(leyendo: parteDuracion) } catch let e as any ErrorAlLeer {
            throw e.situado(en: texto, posicion: dosPuntos + 1)
        }
        let parteNotas = String(caracteres[..<dosPuntos])
        let limpia = parteNotas.trimmingEspacios()
        if limpia == "-" || limpia.claveDeBusqueda == "silencio" {
            self.init(notas: [], duracion: duracion, dinamica: dinamica, articulaciones: articulaciones)
            return
        }
        var notas: [Nota] = []
        var inicio = 0
        for trozo in parteNotas.split(separator: "+", omittingEmptySubsequences: false) {
            var nota = String(trozo)
            var desvio = 0.0
            if let parentesis = nota.firstIndex(of: "("), nota.trimmingEspacios().hasSuffix(")") {
                let dentro = String(String(nota[nota.index(after: parentesis)...]).trimmingEspacios().dropLast())
                    .replacingOccurrences(of: "¢", with: "").replacingOccurrences(of: "c", with: "")
                guard let cents = Double(dentro.trimmingEspacios()), cents.isFinite else {
                    throw ErrorDeLectura(
                        texto: texto, posicion: inicio + nota.distance(from: nota.startIndex, to: parentesis),
                        motivo: .caracteresSobrantes(String(nota[parentesis...])))
                }
                desvio = cents
                nota = String(nota[..<parentesis])
            }
            do { notas.append(Nota(try Altura(leyendo: nota), desvio: desvio)) } catch let e as any ErrorAlLeer {
                throw e.situado(en: texto, posicion: inicio + (e.posicion ?? 0))
            }
            inicio += trozo.count + 1
        }
        self.init(
            notas: notas, duracion: duracion, ligada: ligada, dinamica: dinamica, articulaciones: articulaciones)
    }

    public var esSilencio: Bool { notas.isEmpty }

    public func transponer(_ intervalo: Intervalo) -> Evento {
        Evento(
            notas: notas.map { Nota($0.altura.transponer(intervalo), desvio: $0.desvio) }, duracion: duracion,
            ligada: ligada, dinamica: dinamica, articulaciones: articulaciones)
    }
}

extension Evento {
    /// Una nota que suena: su altura y cuántos cents se aparta de su nota temperada (los microtonos de un maqam o un
    /// makam), redondeados a la centésima de cent.
    ///
    ///     Evento.Nota("Mi♭4", desvio: 50).description   // "Mi♭4(50¢)": el Mi𝄳 de un maqam
    public struct Nota: Hashable, Sendable {
        public let altura: Altura
        public let desvio: Double

        public init(_ altura: Altura, desvio: Double = 0) {
            self.altura = altura
            let redondeado = (desvio * 100).rounded() / 100
            self.desvio = redondeado == 0 ? 0 : redondeado  // sin -0
        }

        /// La altura con sus cents, si se aparta de la temperada: «Mi♭4(50¢)», «Mib4(50c)» en ASCII.
        public func texto(en notacion: Notacion) -> String {
            let nota = altura.texto(en: notacion)
            guard desvio != 0 else { return nota }
            let cifra = desvio == desvio.rounded() ? String(Int(desvio)) : String(desvio)
            return nota + "(" + cifra + (notacion.usaASCII ? "c" : "¢") + ")"
        }
    }
}

extension Evento.Nota: CustomStringConvertible {
    public var description: String { texto(en: .deCodificacion) }
}

extension Evento: CustomStringConvertible {
    public var description: String { texto }
}

extension Evento: RepresentableComoTexto, Transponible {
    public func texto(en notacion: Notacion) -> String {
        let notasTexto = esSilencio ? "-" : notas.map { $0.texto(en: notacion) }.joined(separator: "+")
        let marcas = (dinamica.map { [$0.rawValue] } ?? []) + articulaciones.map(\.rawValue)
        return notasTexto + ":" + duracion.texto(en: notacion) + (ligada ? "~" : "")
            + (marcas.isEmpty ? "" : "{" + marcas.joined(separator: ",") + "}")
    }
}
