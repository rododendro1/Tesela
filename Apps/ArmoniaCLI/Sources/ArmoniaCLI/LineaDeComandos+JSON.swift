import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - La salida en JSON
//
// Con `--json`, las consultas que lo admiten dan sus datos en JSON en lugar de texto, para leerlos desde un script o
// desde otro programa:
//
//     armonia acorde Sol7/Si --json | jq '.[0].notas'
//
// Las claves son siempre las mismas, en español y sin tildes, sea cual sea el idioma, y cambiarlas rompe a quien las
// lea. Los nombres de notas, acordes y escalas van en la notación elegida (`--ingles`, `--idioma`…), como en el
// texto, y al lado van los datos que no dependen de ella: las clases de altura (0 = Do … 11 = Si). Los errores no
// cambian: van en texto a la salida de errores, con el mismo código de salida.

extension LineaDeComandos {
    /// Un error de uso dentro de una salida en JSON: `ejecutar` lo escribe como cualquier otro (`uso(_:_:)`).
    struct FalloDeUso: Error {
        let error: ErrorDeUso
    }

    /// Lo que hace una orden con `--json`: sus datos, a partir del resto de los argumentos.
    typealias SalidaJSON = @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> any Encodable

    /// Lo que da cada orden con `--json`, por el primero de sus nombres (`Orden.nombres`).
    static let salidasJSON: [String: SalidaJSON] = [
        "acorde": { try acordeJSON($0, $1) },
        "identificar": { try identificarJSON($0, $1) },
        "arpegio": { try arpegioJSON($0, $1) },
        "intervalo": { try intervaloJSON($0, $1) },
        "escala": { try escalaJSON($0, $1) },
        "tonalidad": { try tonalidadJSON($0, $1) },
        "digitaciones": { try digitacionesJSON($0, $1) },
        "tradiciones": { try tradicionesJSON($0, $1) },
        "analizar": { try analizarJSON($0, $1) },
        "conjunto": { try conjuntoJSON($0, $1) },
        "serie": { try serieJSON($0, $1) },
    ]

    /// Los datos en JSON con las claves ordenadas y sangría de dos espacios, para que la salida no cambie de una vez
    /// a otra.
    static func textoJSON(_ datos: any Encodable) throws -> String {
        let codificador = JSONEncoder()
        codificador.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return String(decoding: try codificador.encode(datos), as: UTF8.self)
    }

    /// Las palabras de la orden, sin opciones: lanza `FalloDeUso` si queda alguna opción sin leer o si no hay
    /// ninguna palabra.
    private static func palabras(_ argumentos: Argumentos, siFaltan error: ErrorDeUso) throws -> [String] {
        if let desconocida = argumentos.opcionDesconocida { throw FalloDeUso(error: .opcionDesconocida(desconocida)) }
        guard !argumentos.restantes.isEmpty else { throw FalloDeUso(error: error) }
        return argumentos.restantes
    }

    // MARK: Acordes y escalas
    //
    // Los datos son los de `ArmoniaPresentacion` (DatosDeConsultas.swift), los mismos que da el texto: sus nombres
    // son las claves del JSON.

    /// `acorde Sol7 Do --json`: cada acorde con sus notas, una lista aunque sea uno solo.
    static func acordeJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeAcorde] {
        try palabras(Argumentos(textos), siFaltan: .faltaCifrado).map {
            DatosDeAcorde(try Acorde(leyendo: $0), notacion: notacion)
        }
    }

    /// `identificar Do Mi Sol Sib --json`: los acordes que pueden formar las notas, del más probable al menos (como
    /// mucho cinco, como en el texto); vacío si no forman ninguno.
    static func identificarJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeCandidato] {
        try DatosDeCandidato.identificar(palabras(Argumentos(textos), siFaltan: .faltanNotas), notacion: notacion)
    }

    /// `escala Re dórico --json`: la escala con sus notas y los acordes de sus grados.
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeEscala {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaEscala).joined(separator: " ")
        return DatosDeEscala(try Escala(leyendo: texto), notacion: notacion)
    }

    // MARK: Arpegios, intervalos y tonalidades

    struct ArpegioJSON: Encodable {
        /// «Do7 arpegiado», como en el texto.
        let nombre: String
        let acorde: String
        /// El nombre del patrón, o los grados del recorrido propio («1-5-3-8»).
        let recorrido: String
        /// Desde la octava 4, con su octava: «Do4».
        let notas: [String]
        /// Las mismas, en números MIDI (60 = Do4).
        let midi: [Int]
        /// Las escalas que encajan con el acorde, de las que tienen menos notas a evitar a las que más.
        let escalas: [String]
    }

    /// `arpegio Do7 --patron alberti --json`: cada arpegio con sus notas, una lista aunque sea uno solo. Admite las
    /// mismas opciones que el texto.
    static func arpegioJSON(_ textos: [String], _ notacion: Notacion) throws -> [ArpegioJSON] {
        try arpegios(textos).map { arpegio in
            let alturas = arpegio.alturas(octava: 4)
            return ArpegioJSON(
                nombre: arpegio.nombre(en: notacion),
                acorde: arpegio.acorde.cifrado(en: notacion),
                recorrido: arpegio.grados.isEmpty
                    ? arpegio.patron.nombre(en: notacion) : arpegio.grados.map(String.init).joined(separator: "-"),
                notas: alturas.map { $0.nombre(en: notacion) },
                midi: alturas.map(\.midi),
                escalas: arpegio.acorde.escalasCompatibles().map { $0.nombre(en: notacion) })
        }
    }

    struct IntervaloJSON: Encodable {
        let nombre: String
        /// «3M», en la notación.
        let abreviatura: String
        let semitonos: Int
        /// 3 en una tercera, 10 en una décima.
        let numero: Int
        let descendente: Bool
    }

    /// `intervalo Do4 Mi5 --json`.
    static func intervaloJSON(_ textos: [String], _ notacion: Notacion) throws -> IntervaloJSON {
        let palabras = try palabras(Argumentos(textos), siFaltan: .dosNotas)
        guard palabras.count == 2 else { throw FalloDeUso(error: .dosNotas) }
        let intervalo = try intervalo(palabras[0], palabras[1])
        return IntervaloJSON(
            nombre: intervalo.nombre(en: notacion), abreviatura: intervalo.texto(en: notacion),
            semitonos: intervalo.semitonos, numero: intervalo.numero, descendente: intervalo.sentido == .descendente)
    }

    struct TonalidadJSON: Encodable {
        let nombre: String
        let tonica: String
        /// «mayor» o «menor», siempre en español: es un dato, no un texto.
        let modo: String
        /// Las alteraciones de la armadura: positivas los sostenidos y negativas los bemoles.
        let armadura: Int
        let alteraciones: [String]
        let notas: [String]
        let clases: [Int]
        let relativa: String
        let homonima: String
        /// Las cuatríadas de cada grado, con su cifrado romano.
        let acordes: [AcordeDelGrado]
    }

    /// Como `DatosDeEscala.AcordeDelGrado`: «ii» «Rem7».
    struct AcordeDelGrado: Encodable {
        let grado: String
        let cifrado: String
    }

    /// `tonalidad La menor --json`.
    static func tonalidadJSON(_ textos: [String], _ notacion: Notacion) throws -> TonalidadJSON {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaTonalidad).joined(separator: " ")
        let tonalidad = try Tonalidad(leyendo: texto)
        let notas = tonalidad.escala.notas
        return TonalidadJSON(
            nombre: tonalidad.nombre(en: notacion),
            tonica: tonalidad.tonica.nombre(en: notacion),
            modo: tonalidad.modo == .mayor ? "mayor" : "menor",
            armadura: tonalidad.armadura,
            alteraciones: tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) },
            notas: notas.map { $0.nombre(en: notacion) },
            clases: notas.map(\.claseDeAltura),
            relativa: tonalidad.relativa.nombre(en: notacion),
            homonima: tonalidad.homonima.nombre(en: notacion),
            acordes: zip(tonalidad.cifradosRomanos(cuatriadas: true), tonalidad.armonizar(cuatriadas: true)).map {
                AcordeDelGrado(grado: $0, cifrado: $1.cifrado(en: notacion))
            })
    }

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
            let acorde = try Acorde(leyendo: texto)
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

    // MARK: Tradiciones

    struct TradicionJSON: Encodable {
        struct Categoria: Encodable {
            /// «maqam», «raga»…: como se escribe en `--categoria`, siempre igual.
            let clave: String
            let nombre: String
            let escalas: Int
        }
        /// Como se escribe en `--tradicion`, en español: «japon», «mundo-arabe».
        let clave: String
        let nombre: String
        let escalas: Int
        let categorias: [Categoria]
    }

    /// `tradiciones --json`: cada tradición con sus categorías y cuántas escalas tiene de cada una. Las escalas de una
    /// tradición (`tradiciones japon`) no dan JSON, como `escalas`.
    static func tradicionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [TradicionJSON] {
        if let primera = textos.first, !Argumentos.pareceUnaOpcion(primera) {
            throw FalloDeUso(error: .sinSalidaJSON("tradiciones " + primera))
        }
        if let opcion = Argumentos(textos).opcionDesconocida { throw FalloDeUso(error: .opcionDesconocida(opcion)) }
        return catalogoDeTradiciones().map { ficha in
            TradicionJSON(
                clave: ficha.claves.espanol, nombre: ficha.tradicion.nombre(en: notacion),
                escalas: ficha.categorias.map(\.escalas).reduce(0, +),
                categorias: ficha.categorias.map {
                    TradicionJSON.Categoria(
                        clave: $0.categoria.rawValue, nombre: $0.categoria.nombre(en: notacion), escalas: $0.escalas)
                })
        }
    }

    // MARK: Análisis

    struct AnalisisJSON: Encodable {
        struct Tramo: Encodable {
            /// «en Sol mayor» al modular; `nil` en el primer tramo si no hay modulaciones.
            let cabecera: String?
            let acordes: [Fila]
        }
        struct Fila: Encodable {
            let cifrado: String
            let grado: String
            /// Vacío si el acorde no tiene función en la tonalidad.
            let funcion: String
        }
        let titulo: String
        let tramos: [Tramo]
        let cadencias: [String]
    }

    /// `analizar Do Fa Sol7 Do [--en Do mayor] --json`: el análisis por tramos, como en el texto.
    static func analizarJSON(_ textos: [String], _ notacion: Notacion) throws -> AnalisisJSON {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw FalloDeUso(error: .faltaTonalidadTrasEn) }
        let acordes = try palabras(argumentos, siFaltan: .faltanAcordesDelAnalisis)
        let analisis = try PresentacionDeAnalisis.analizar(
            acordes.joined(separator: " "), en: tonalidad, notacion: notacion)
        return AnalisisJSON(
            titulo: analisis.titulo,
            tramos: analisis.tramos.map { tramo in
                AnalisisJSON.Tramo(
                    cabecera: tramo.cabecera,
                    acordes: tramo.filas.map {
                        AnalisisJSON.Fila(cifrado: $0.cifrado, grado: $0.grado, funcion: $0.funcion)
                    })
            },
            cadencias: analisis.cadencias)
    }

    // MARK: Teoría postonal

    /// `conjunto 0 4 7 --json`: el conjunto con sus formas y sus vectores.
    static func conjuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeConjunto {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaConjunto).joined(separator: " ")
        return DatosDeConjunto(try ConjuntoDeClases(leyendo: texto), notacion: notacion)
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6 --json`: la serie con sus intervalos, sus hexacordos, sus formas y la matriz.
    static func serieJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeSerie {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaSerie).joined(separator: " ")
        return DatosDeSerie(try SerieDodecafonica(leyendo: texto), notacion: notacion)
    }
}
