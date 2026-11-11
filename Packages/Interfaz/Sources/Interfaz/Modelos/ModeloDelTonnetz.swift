import Armonia
import Exposicion
import Hexagonos

/// Lo que se elige en la app Tonnetz y lo que sale de ello: el modo, la red, el recorrido con P, L y R, las notas
/// tocadas en «Identificar», la partitura abierta y el dibujo para exportar. No usa SwiftUI, así que se prueba
/// también en Linux; la vista lo guarda en un `@State` y solo lo dibuja.
///
/// Lo que depende de lo que está sonando (el acorde de la partitura que se ve) toma el paso que suena, `sonando`, que
/// la vista saca del reproductor.
public struct ModeloDelTonnetz: Sendable {
    /// Lo que se dibuja en la red.
    public enum Contenido: CaseIterable, Identifiable, Hashable, Sendable {
        case recorrido
        case acorde
        case escala
        case identificar
        case partitura
        public var id: Self { self }

        /// Su nombre en el selector de modo.
        public func titulo(en notacion: Notacion) -> String {
            switch self {
            case .recorrido: return notacion.texto(\.recorridoPLR)
            case .acorde: return notacion.texto(\.acorde)
            case .escala: return notacion.texto(\.escala)
            case .identificar: return notacion.texto(\.identificar)
            case .partitura: return notacion.texto(\.partitura)
            }
        }
    }

    public var contenido = Contenido.recorrido
    public var red = RedDeNotas.tonnetz
    public var uil = AjusteUIL()
    public var cuadrado = AjusteCuadrado()
    /// La tríada con que empieza el recorrido; se toma al reiniciarlo.
    public var textoInicial = "Do"
    public var textoAcorde = "Dom7"
    public var textoEscala = "Re dórico"
    /// Las tríadas del recorrido, desde la inicial.
    public private(set) var recorrido: [Acorde] = []
    /// Las transformaciones aplicadas, una menos que tríadas.
    public private(set) var transformaciones: [TransformacionNeorriemanniana] = []
    /// Las clases de altura tocadas en el modo «Identificar», en el orden en que se tocaron: la primera es el bajo.
    public var clasesTocadas: [Int] = []
    /// La pieza abierta en el modo «Partitura».
    public private(set) var partitura: RecorridoDePartitura?
    /// Lo leído del fichero, para volver a escribir los cifrados si cambia la notación.
    public private(set) var importada: ProgresionImportada?
    /// El acorde elegido con «Anterior» y «Siguiente» (el primero al abrir la partitura).
    public private(set) var pasoElegido = 0
    /// Por qué no se pudo abrir el último fichero.
    public private(set) var errorAlAbrir: (any Error)?

    /// Un modelo como al abrir la app: el recorrido empieza en la tríada de `textoInicial`.
    public init() {
        reiniciar()
    }

    // MARK: El recorrido

    /// Vuelve a empezar el recorrido en la tríada escrita, o lo deja vacío si no se lee.
    public mutating func reiniciar() {
        transformaciones = []
        recorrido = (try? Acorde(leyendo: textoInicial)).map { [$0] } ?? []
    }

    /// Añade al recorrido la tríada que sale de la última con `transformacion`.
    public mutating func aplicar(_ transformacion: TransformacionNeorriemanniana) {
        guard let ultimo = recorrido.last, let siguiente = ultimo.transformar(transformacion) else { return }
        recorrido.append(siguiente)
        transformaciones.append(transformacion)
    }

    /// Quita la última tríada, salvo la inicial.
    public mutating func deshacer() {
        guard recorrido.count > 1 else { return }
        recorrido.removeLast()
        transformaciones.removeLast()
    }

    /// El recorrido escrito: «Do → Lam → Fa».
    public func textoDelRecorrido(en notacion: Notacion) -> String {
        recorrido.map { $0.cifrado(en: notacion) }.joined(separator: " → ")
    }

    // MARK: Identificar

    /// La nota que hay en `punto` del dibujo, para que suene. En «Identificar», además, se marca o se desmarca.
    public mutating func tocar(en punto: Punto, de dibujado: ContenidoDeRed) -> Int? {
        guard
            let midi = PresentacionDeRedes.midi(en: punto, de: dibujado, enLaRed: red, uil: uil, cuadrado: cuadrado)
        else { return nil }
        if contenido == .identificar { clasesTocadas = PresentacionDeRedes.alternar(midi, en: clasesTocadas) }
        return midi
    }

    /// Lo que forman las notas tocadas: el acorde más probable con su nombre y, detrás, otras lecturas y el número
    /// de Forte. Sin notas, la indicación; con notas que no forman acorde, sus nombres y el aviso.
    public func identificado(en notacion: Notacion) -> String {
        guard !clasesTocadas.isEmpty else { return notacion.texto(\.tocaNotas) }
        let acordes = PresentacionDeRedes.acordes(de: clasesTocadas)
        guard let primero = acordes.first else {
            let notas = ContenidoDeRed.clases(clasesTocadas).notas.map { $0.nombre(en: notacion) }.joined(
                separator: " ")
            return clasesTocadas.count < 2 ? notas : notas + " · " + notacion.texto(\.sinAcordeConocido)
        }
        var texto = primero.cifrado(en: notacion) + " · " + primero.nombre(en: notacion)
        let otros = acordes.dropFirst().prefix(3).map { $0.cifrado(en: notacion) }
        if !otros.isEmpty { texto += "\n" + otros.joined(separator: ", ") }
        if let forte = AnalisisPostonalPresentado(clases: clasesTocadas).numeroDeForte {
            texto += "\n" + notacion.texto(\.numeroDeForte) + ": " + forte
        }
        return texto
    }

    // MARK: La partitura

    /// Empieza a seguir la pieza leída de un fichero por su primer acorde, o guarda por qué no se pudo leer.
    public mutating func abrir(_ elegida: Result<ProgresionImportada, any Error>, en notacion: Notacion) {
        do {
            let leida = try elegida.get()
            importada = leida
            partitura = RecorridoDePartitura(leida, en: notacion)
            pasoElegido = 0
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }

    /// Vuelve a escribir los cifrados de la partitura abierta en otra notación.
    public mutating func cambiar(a notacion: Notacion) {
        partitura = importada.map { RecorridoDePartitura($0, en: notacion) }
    }

    /// El acorde de la partitura que se ve: el que suena, si suena; si no, el elegido (el primero al abrirla).
    public func pasoActual(sonando: Int?) -> Int? {
        guard let partitura, !partitura.pasos.isEmpty else { return nil }
        if let sonando { return sonando }
        return min(pasoElegido, partitura.pasos.count - 1)
    }

    /// Pasa al acorde anterior o al siguiente de la partitura y da el acorde, para que suene.
    public mutating func elegirPaso(avanzando: Bool, sonando: Int?) -> Acorde? {
        guard let partitura else { return nil }
        guard let paso = partitura.paso(desde: pasoActual(sonando: sonando), avanzando: avanzando) else { return nil }
        pasoElegido = paso
        return partitura.pasos[paso].acorde
    }

    /// «3/24 · Lam –R→ Fa»: el número del paso, el acorde anterior y el actual y las transformaciones entre ellos.
    public func descripcion(delPaso i: Int) -> String? {
        guard let partitura, partitura.pasos.indices.contains(i) else { return nil }
        let paso = partitura.pasos[i]
        let numero = "\(i + 1)/\(partitura.pasos.count) · "
        guard i > 0 else { return numero + paso.cifrado }
        return numero + partitura.pasos[i - 1].cifrado + " –" + paso.transformacion + "→ " + paso.cifrado
    }

    // MARK: El dibujo

    /// Lo que se dibuja; `nil` si el texto no se puede leer.
    public func dibujado(sonando: Int?) -> ContenidoDeRed? {
        switch contenido {
        case .recorrido:
            return recorrido.isEmpty ? nil : .recorrido(recorrido)
        case .acorde:
            return (try? Acorde(leyendo: textoAcorde)).map { .acorde($0) }
        case .escala:
            return (try? Escala(leyendo: textoEscala)).map { .escala($0) }
        case .identificar:
            return .clases(clasesTocadas)
        case .partitura:
            // El acorde que se ve, con las tríadas que llevan a él y sus flechas.
            guard let partitura, let actual = pasoActual(sonando: sonando) else { return nil }
            let tramo = partitura.tramo(hasta: actual)
            return tramo.count >= 2 ? .recorrido(tramo) : tramo.first.map { .acorde($0) }
        }
    }

    /// Lo que suena al pulsar «Escuchar»: la partitura, el acorde, la escala, el recorrido o las notas tocadas.
    public func sonido(sonando: Int?) -> Escucha {
        if contenido == .partitura { return partitura?.sonido ?? .silencio }
        switch dibujado(sonando: sonando) {
        case .acorde(let acorde): return .acorde(acorde)
        case .escala(let escala): return .escala(escala)
        case .recorrido(let acordes): return .acordes(acordes)
        case .clases(let clases):
            if let acorde = PresentacionDeRedes.acordes(de: clases).first { return .acorde(acorde) }
            return clases.isEmpty ? .silencio : .coral([clases.map { Altura(midi: 60 + $0) }])
        default: return .silencio
        }
    }

    /// El dibujo en la red elegida, con los ajustes del teclado UIL y de la cuadrícula.
    public func dibujo(de dibujado: ContenidoDeRed, en notacion: Notacion) -> String? {
        PresentacionDeRedes.svg(dibujado, en: red, notacion: notacion, uil: uil, cuadrado: cuadrado)
    }

    /// El nombre del dibujo, para exportarlo y para VoiceOver.
    public func nombre(de dibujado: ContenidoDeRed, en notacion: Notacion) -> String {
        PresentacionDeRedes.nombre(dibujado, en: red, notacion: notacion, uil: uil, cuadrado: cuadrado)
    }

    /// El dibujo en SVG, para exportarlo; nada si no se dibuja.
    public func ficheros(sonando: Int?, en notacion: Notacion) -> [FicheroParaExportar] {
        guard let dibujado = dibujado(sonando: sonando), let svg = dibujo(de: dibujado, en: notacion) else {
            return []
        }
        return [.svg(svg, nombre: nombre(de: dibujado, en: notacion))]
    }
}
