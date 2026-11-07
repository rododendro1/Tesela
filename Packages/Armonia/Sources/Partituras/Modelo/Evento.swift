import Elementos
import Teoria

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
///     Evento("Mi♭4(50¢,persa,1):4")       // el mismo, escrito con el koron de un dastgāh
///     Evento("Sol4:8{f,staccato}")        // forte y picada
public struct Evento: Hashable, Sendable {
    /// Las notas que suenan, cada una con su altura y lo que se aparta de la temperada; vacío si es un silencio.
    public let notas: [NotaDelEvento]
    /// Las alturas de `notas`, en el mismo orden.
    public let alturas: [Altura]
    public let duracion: Duracion
    public let ligada: Bool
    /// La dinámica que se marca en este evento, si se marca alguna (`Expresion.swift`).
    public let dinamica: Dinamica?
    /// Sus articulaciones, sin repetir y en el orden de `Articulacion.allCases`.
    public let articulaciones: [Articulacion]

    /// Un evento con sus notas, cada una con su desvío: `[Evento.NotaDelEvento("Do4"), Evento.NotaDelEvento("Mi♭4",
    /// desvio: 50)]`.
    public init(
        notas: [NotaDelEvento], duracion: Duracion, ligada: Bool = false, dinamica: Dinamica? = nil,
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
            notas: alturas.map { NotaDelEvento($0) }, duracion: duracion, ligada: ligada, dinamica: dinamica,
            articulaciones: articulaciones)
    }

    /// Una nota sola con esa duración, ligada a la siguiente si `ligada`, y apartada `desvio` cents de su altura
    /// temperada.
    public init(_ nota: Altura, _ duracion: Duracion, ligada: Bool = false, desvio: Double = 0) {
        self.init(notas: [NotaDelEvento(nota, desvio: desvio)], duracion: duracion, ligada: ligada)
    }

    /// Un silencio de esa duración: `Evento.silencio(.negra)`.
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

    /// Lee "notas:duración", con las notas de un acorde unidas por "+", "-" (o "silencio") para un silencio y "~" al
    /// final si está ligada: "Do4:4", "C4+E4:2.", "-:8", "Re4:2~". Una nota que se aparta de la temperada lleva los
    /// cents entre paréntesis: "Mi♭4(50¢):4", "Si4(-22.64c):4"; y, si se sabe, su sistema y los pasos que se aparta en
    /// él (`Evento.NotaDelEvento.sistema`): "Mi♭4(50¢,persa,1):4". La dinámica y las articulaciones van al final, entre
    /// llaves: "Do4:4{mf}", "Re4:2~{acento,tenuto}" (`Expresion.swift`).
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
        var notas: [NotaDelEvento] = []
        var inicio = 0
        for trozo in parteNotas.split(separator: "+", omittingEmptySubsequences: false) {
            var nota = String(trozo)
            var desvio = 0.0
            var sistema: SistemaMicrotonal?
            var ajuste = 0
            if let parentesis = nota.firstIndex(of: "("), nota.trimmingEspacios().hasSuffix(")") {
                let dentro = String(String(nota[nota.index(after: parentesis)...]).trimmingEspacios().dropLast())
                    .split(separator: ",", omittingEmptySubsequences: false).map { String($0).trimmingEspacios() }
                let cifra = dentro[0].replacingOccurrences(of: "¢", with: "").replacingOccurrences(of: "c", with: "")
                // Los cents (como mucho un semitono arriba o abajo) y, si los hay, el sistema y los pasos que se
                // aparta en él: «50¢,persa,1».
                let leidos: (SistemaMicrotonal?, Int?) =
                    dentro.count == 3 ? (SistemaMicrotonal(rawValue: dentro[1]), Int(dentro[2])) : (nil, nil)
                guard let cents = Double(cifra.trimmingEspacios()), cents.isFinite, abs(cents) <= 100,
                    dentro.count == 1 || (leidos.0 != nil && leidos.1 != nil)
                else {
                    throw ErrorDeLectura(
                        texto: texto, posicion: inicio + nota.distance(from: nota.startIndex, to: parentesis),
                        motivo: .caracteresSobrantes(String(nota[parentesis...])))
                }
                desvio = cents
                sistema = leidos.0
                ajuste = leidos.1 ?? 0
                nota = String(nota[..<parentesis])
            }
            do {
                notas.append(NotaDelEvento(try Altura(leyendo: nota), desvio: desvio, sistema: sistema, ajuste: ajuste))
            } catch let e as any ErrorAlLeer {
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
            notas: notas.map { $0.con(altura: $0.altura.transponer(intervalo)) }, duracion: duracion,
            ligada: ligada, dinamica: dinamica, articulaciones: articulaciones)
    }
}

extension Evento {
    /// Una nota que suena: su altura y cuántos cents se aparta de su nota temperada (los microtonos de un maqam o un
    /// makam), redondeados a la centésima de cent. Si se da, `sistema` es la teoría en que se escribe ese microtono
    /// y `ajuste`, cuántos pasos de ella se aparta (como ``NotaMicrotonal/ajuste``): con ellos, el Mi koron de un
    /// dastgāh se escribe con el koron, y no con el medio bemol de un maqam, en el pentagrama y en los formatos.
    ///
    ///     Evento.NotaDelEvento("Mi♭4", desvio: 50).description   // "Mi♭4(50¢)": el Mi𝄳 de un maqam
    ///     Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1).description
    ///     // "Mi♭4(50¢,persa,1)": el koron
    public struct NotaDelEvento: Hashable, Sendable {
        public let altura: Altura
        public let desvio: Double
        /// La teoría en que se escribe el microtono; `nil` si no se aparta de la temperada o si no se sabe (su signo
        /// se deduce entonces de los cents).
        public let sistema: SistemaMicrotonal?
        /// Los pasos de `sistema` que se aparta (``NotaMicrotonal/ajuste``); 0 si no hay sistema.
        public let ajuste: Int

        /// La altura apartada `desvio` cents de la temperada, redondeado a la centésima, y escrita en `sistema`,
        /// `ajuste` pasos apartada. Una nota que no se aparta no tiene sistema.
        public init(_ altura: Altura, desvio: Double = 0, sistema: SistemaMicrotonal? = nil, ajuste: Int = 0) {
            self.altura = altura
            let redondeado = (desvio * 100).rounded() / 100
            self.desvio = redondeado == 0 ? 0 : redondeado // sin -0
            self.sistema = self.desvio == 0 ? nil : sistema
            self.ajuste = self.sistema == nil ? 0 : ajuste
        }

        /// La nota de una escala, con su microtono y su sistema.
        package init(_ altura: AlturaMicrotonal) {
            self.init(
                altura.altura, desvio: altura.desvio, sistema: altura.nota?.sistema, ajuste: altura.nota?.ajuste ?? 0)
        }

        /// La misma nota en otra altura, con el mismo desvío y el mismo sistema.
        package func con(altura: Altura) -> NotaDelEvento {
            NotaDelEvento(altura, desvio: desvio, sistema: sistema, ajuste: ajuste)
        }

        /// El signo del microtono, escrito con `semitonos` de alteración (los de la altura, si no se dan): el de su
        /// sistema o, sin él, el que dan los cents. `nil` si no se aparta o si lo que se aparta no tiene signo.
        public func signo(semitonos: Int? = nil) -> SignoMicrotonal? {
            let semitonos = semitonos ?? altura.nota.alteracion.semitonos
            guard let sistema else { return SignoMicrotonal(semitonos: semitonos, desvio: desvio) }
            return SignoMicrotonal(sistema: sistema, ajuste: ajuste, semitonos: semitonos, desvio: desvio)
        }

        /// La altura con sus cents, si se aparta de la temperada, y su sistema, si lo tiene: «Mi♭4(50¢)»,
        /// «Mi♭4(50¢,persa,1)», «Mib4(50c)» en ASCII.
        public func texto(en notacion: Notacion) -> String {
            let nota = altura.texto(en: notacion)
            guard desvio != 0 else { return nota }
            let cifra = Int(exactly: desvio).map(String.init) ?? String(desvio)
            let enSistema = sistema.map { ",\($0.rawValue),\(ajuste)" } ?? ""
            return nota + "(" + cifra + (notacion.usaASCII ? "c" : "¢") + enSistema + ")"
        }
    }
}

extension Evento.NotaDelEvento: CustomStringConvertible {
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
