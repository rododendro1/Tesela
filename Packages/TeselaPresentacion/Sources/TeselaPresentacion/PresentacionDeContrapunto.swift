import Armonia
import Foundation

/// Un contrapunto de especies tal como lo enseña la app: la especie y dónde va el contrapunto, una fila por compás
/// con sus notas, los intervalos con el cantus y las faltas que lo tocan, las faltas una a una, lo que suena al
/// escucharlo y los ficheros para exportar.
public struct ContrapuntoPresentado: Hashable, Sendable {
    /// Un compás: la nota del cantus, las del contrapunto y el intervalo de cada una con el cantus.
    public struct Fila: Hashable, Sendable {
        /// Contado desde 0, como en `FaltaDeContrapunto.compases`.
        public let compas: Int
        /// «Compás 3», contado desde 1.
        public let titulo: String
        public let cantus: String
        /// Las notas del compás separadas por espacios: «–» un silencio y «~» detrás, una nota ligada a la siguiente.
        public let contrapunto: String
        /// El número del intervalo de cada nota con el cantus («8 6 5»), «–» en un silencio.
        public let intervalos: String
        /// Los nombres de las faltas que tocan este compás, sin repetir.
        public let faltas: [String]

        public var esCorrecta: Bool { faltas.isEmpty }
    }

    /// «Especie 1, con el contrapunto encima del cantus firmus».
    public let cabecera: String
    public let filas: [Fila]
    /// Cada falta con sus compases («Quintas paralelas (compases 3 → 4)»), o «Sin faltas.».
    public let informe: [String]
    public let esCorrecto: Bool
    public let ficheros: [FicheroParaExportar]
    /// Las dos voces, para «Escuchar».
    public let sonido: Escucha
    /// El compás (contado desde 0) en que empieza cada paso de `sonido`, para resaltarlo mientras suena.
    let compasDePaso: [Int]

    /// El compás que está sonando en el paso `paso` de `sonido` (`Reproductor.paso(de:)`), o `nil`.
    public func compas(enElPaso paso: Int?) -> Int? {
        guard let paso, compasDePaso.indices.contains(paso) else { return nil }
        return compasDePaso[paso]
    }
}

/// La parte de la vista de contrapunto que no es dibujo. No usa SwiftUI, así que se prueba en Linux.
///
///     let fux = try PresentacionDeContrapunto.presentar(
///         cantus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1", especie: .segunda,
///         notacion: .espanolCompacto)
///     fux.esCorrecto   // true
public enum PresentacionDeContrapunto {
    /// El tempo al que suena: negra a 120, una redonda cada dos segundos.
    public static let tempo = Tempo(120)

    /// Un ejercicio de ejemplo de cada especie, sin faltas, sobre el cantus en re de Fux (el primero, el suyo).
    public static func ejemplo(_ especie: Contrapunto.Especie) -> Ejemplo {
        switch especie {
        case .primera:
            return Ejemplo(
                cantus: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4",
                contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5")
        case .segunda:
            return Ejemplo(cantus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1")
        case .tercera:
            return Ejemplo(
                cantus: "Re4 Fa4 Mi4 Re4", contrapunto: "Re5 Do5 Si4 Do5 Re5 Do5 Si4 La4 Sol4 La4 Si4 Do#5 Re5:1")
        case .cuarta:
            return Ejemplo(cantus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1")
        case .quinta:
            return Ejemplo(
                cantus: "Re4 Fa4 Mi4 Re4",
                contrapunto: "-:2 La4:2 Re5:2 Do5:4 Re5:4 Sol4:4 La4:4 Si4:4 Do#5:4 Re5:1")
        }
    }

    /// Un ejercicio de ejemplo: el cantus firmus y el contrapunto, en el texto que lee
    /// ``presentar(cantus:contrapunto:especie:notacion:)``.
    public struct Ejemplo: Hashable, Sendable {
        public let cantus: String
        public let contrapunto: String

        /// Un ejemplo con el cantus y el contrapunto escritos como se leen.
        public init(cantus: String, contrapunto: String) {
            self.cantus = cantus
            self.contrapunto = contrapunto
        }
    }

    /// Comprueba el ejercicio y lo prepara para enseñarlo. Lanza el error de lectura si el cantus o el contrapunto
    /// no se leen, o si el contrapunto no dura una redonda por nota del cantus.
    public static func presentar(
        cantus: String, contrapunto: String, especie: Contrapunto.Especie, notacion: Notacion
    ) throws -> ContrapuntoPresentado {
        let ejercicio = try Contrapunto(cantusFirmus: cantus, contrapunto: contrapunto, especie: especie)
        let faltas = ejercicio.faltas
        let lineas = ejercicio.informe(en: notacion).split(separator: "\n").map(String.init)
        var filas: [ContrapuntoPresentado.Fila] = []
        for (c, eventos) in ejercicio.contrapunto.compases.enumerated() where c < ejercicio.cantusFirmus.count {
            let cantus = ejercicio.cantusFirmus[c]
            var vistas = Set<FaltaDeContrapunto.Tipo>()
            let nombres = faltas.filter { $0.compases.contains(c) && vistas.insert($0.tipo).inserted }
                .map { $0.tipo.nombre(en: notacion) }
            filas.append(
                ContrapuntoPresentado.Fila(
                    compas: c, titulo: notacion.texto { $0.compasNumero(c + 1) },
                    cantus: cantus.nombre(en: notacion),
                    contrapunto: eventos.map { texto(de: $0, notacion) }.joined(separator: " "),
                    intervalos: eventos.map { intervalo(de: $0, con: cantus) }.joined(separator: " "),
                    faltas: nombres))
        }
        let sonido = Escucha(
            notas: (Escucha.voz(ejercicio.vozDelCantus, tempo: tempo).notas
                + Escucha.voz(ejercicio.contrapunto, tempo: tempo).notas),
            tonica: ejercicio.cantusFirmus.last?.nota)
        let redonda = tempo.segundos(de: .redonda)
        let nombre = notacion.texto(\.contrapunto)
        return ContrapuntoPresentado(
            cabecera: lineas.first ?? "", filas: filas, informe: Array(lineas.dropFirst()),
            esCorrecto: faltas.isEmpty,
            ficheros: FicheroParaExportar.partituras(nombre: nombre) { formato in
                ejercicio.partitura(encabezado: Encabezado(titulo: nombre, tempo: tempo)).exportar(como: formato)
            },
            sonido: sonido,
            compasDePaso: sonido.inicios.map { Int(($0 / redonda + 1e-6).rounded(.down)) })
    }

    /// «La₄», «Do₅~» si se liga a la siguiente, «–» si es un silencio.
    static func texto(de evento: Evento, _ notacion: Notacion) -> String {
        guard let altura = evento.alturas.first else { return "–" }
        return altura.nombre(en: notacion) + (evento.ligada ? "~" : "")
    }

    /// El número del intervalo entre la nota y el cantus, del grave al agudo: «8», «6», «10»; «–» si es un silencio.
    static func intervalo(de evento: Evento, con cantus: Altura) -> String {
        guard let nota = evento.alturas.first else { return "–" }
        let intervalo = nota.midi < cantus.midi ? nota.intervalo(hasta: cantus) : cantus.intervalo(hasta: nota)
        return "\(intervalo.numero)"
    }
}

// MARK: - Idiomas

extension PresentacionDeContrapunto {
    /// Qué se escribe en el campo del cantus, con un ejemplo en la notación: «Cantus firmus (Re₄ Fa₄ Mi₄ Re₄)».
    public static func indicacionDelCantus(en notacion: Notacion) -> String {
        let e = notacion.alturasDeEjemplo("Re4 Fa4 Mi4 Re4")
        return notacion.texto { $0.indicacionCantus(e) }
    }

    /// Qué se escribe en el campo del contrapunto: las notas, con la figura de la especie si no llevan duración.
    public static func indicacionDelContrapunto(en notacion: Notacion) -> String {
        let e = "-:2 " + notacion.alturasDeEjemplo("La4 Re5") + " …"
        return notacion.texto { $0.indicacionContrapunto(e) }
    }
}
