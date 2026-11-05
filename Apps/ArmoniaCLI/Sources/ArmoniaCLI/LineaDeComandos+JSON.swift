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
    /// Lo que hace una orden con `--json` (`Orden.json`): sus datos, a partir del resto de los argumentos.
    typealias SalidaJSON = @Sendable (_ argumentos: [String], _ notacion: Notacion) throws -> any Encodable

    /// Los datos en JSON con las claves ordenadas, para que la salida no cambie de una vez a otra: con sangría para
    /// leerlos en la terminal, o en una sola línea para un programa (`enUnaLinea`).
    static func textoJSON(_ datos: any Encodable, enUnaLinea: Bool = false) throws -> String {
        let codificador = JSONEncoder()
        codificador.outputFormatting =
            enUnaLinea
            ? [.sortedKeys, .withoutEscapingSlashes]
            : [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return String(decoding: try codificador.encode(datos), as: UTF8.self)
    }

    /// Los datos de una orden que comprueba algo (`revisar`, `contrapunto`): con faltas, la orden sale con código 3.
    protocol ConFaltas {
        var hayFaltas: Bool { get }
    }

    /// Las palabras de la orden, sin opciones: lanza el `ErrorDeUso` si queda alguna opción sin leer o si no hay
    /// ninguna palabra.
    private static func palabras(_ argumentos: Argumentos, siFaltan error: ErrorDeUso) throws -> [String] {
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw error }
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

    /// `escala Re dórico --json`: la escala con sus notas y los acordes de sus grados (las claves de
    /// `DatosDeEscala`) y, con las opciones del texto, lo que añaden: cada una, su clave.
    struct EscalaJSON: Encodable {
        struct Grado: Encodable {
            let grado: String
            let acordes: [String]
        }
        struct Secuencia: Encodable {
            let nombre: String
            /// Desde la octava 4, con su octava: «Do4».
            let notas: [String]
            let midi: [Int]
        }
        struct ManoDelPiano: Encodable {
            let mano: String
            let notas: [String]
            let dedos: [Int]
        }
        struct Modo: Encodable {
            let nombre: String
            let brillo: String
            /// Lo que cambia respecto a la escala; vacío en la suya.
            let cambios: String
        }
        struct Detalle: Encodable {
            let nombre: String
            let detalle: String
        }
        struct Simetria: Encodable {
            let resumen: String
            /// Las tónicas desde las que empieza igual; no está si la escala solo se repite a la octava.
            let tonicas: String?
            let ciclos: [Detalle]
        }
        /// `EstadisticasDeEscala`, con el cardinal por su nombre.
        struct Estadisticas: Encodable {
            let numeroDeNotas: Int
            let cardinal: String?
            let brillo: Int?
            let brilloPorQuintas: Double
            let pasos: [Int]
            let vectorIntervalico: [Int]
            let anhemitonica: Bool
            let cohemitonica: Bool
            let transposicionesDistintas: Int
            let numeroDeForte: String?
            let maximamenteRegular: Bool
            let aproximada: Bool
        }
        struct Tonalidad: Encodable {
            let tonalidad: String
            let notas: String
        }
        struct AcordesEnLasDoce: Encodable {
            let grados: [String]
            let filas: [Fila]
            struct Fila: Encodable {
                let tonalidad: String
                let acordes: [String]
            }
        }
        struct Comparacion: Encodable {
            let con: String
            let comunes: String
            let soloEnOrigen: String
            let soloEnDestino: String
            let cambios: [String]
            let distancia: String?
        }

        // Las de `DatosDeEscala`, como sin opciones.
        let nombre: String
        let notas: [String]
        let clases: [Int]
        let modo: String?
        let acordes: [DatosDeEscala.AcordeDelGrado]?
        /// `--acordes`.
        var acordesQueCaben: [Grado]?
        /// `--secuencia`.
        var secuencia: Secuencia?
        /// `--piano`: la mano derecha primero.
        var piano: [ManoDelPiano]?
        /// `--modos`.
        var modosParalelos: [Modo]?
        var modosRelativos: [String]?
        /// `--simetria`.
        var simetria: Simetria?
        /// `--vecinas`.
        var vecinas: [Detalle]?
        /// `--estadisticas`.
        var estadisticas: Estadisticas?
        /// `--doce`, con la secuencia de `--secuencia` si se da; con `--acordes`, también los acordes de cada grado.
        var doceTonalidades: [Tonalidad]?
        var acordesEnLasDoceTonalidades: AcordesEnLasDoce?
        /// `--comparar`.
        var comparacion: Comparacion?

        init(_ datos: DatosDeEscala) {
            nombre = datos.nombre
            notas = datos.notas
            clases = datos.clases
            modo = datos.modo
            acordes = datos.acordes
        }
    }

    /// `escala Re dórico --json`, con las mismas opciones que el texto (`pedidoDeEscala`).
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> EscalaJSON {
        let pedido = try pedidoDeEscala(textos)
        let escala = pedido.escala
        var datos = EscalaJSON(DatosDeEscala(escala, notacion: notacion))
        if pedido.conAcordes {
            datos.acordesQueCaben = PresentacionDeEscalaYAcorde.acordesQueCaben(escala, notacion: notacion).map {
                EscalaJSON.Grado(grado: $0.grado, acordes: $0.acordes.map { $0.cifrado(en: notacion) })
            }
        }
        if let secuencia = pedido.secuencia {
            let alturas = escala.secuencia(secuencia, octavas: pedido.octavas, sentido: pedido.sentido)
            datos.secuencia = EscalaJSON.Secuencia(
                nombre: secuencia.nombre(en: notacion), notas: alturas.map { $0.nombre(en: notacion) },
                midi: alturas.map(\.midi))
        }
        if pedido.piano {
            datos.piano = Mano.allCases.map { mano in
                let digitacion = escala.digitacionDePiano(mano, octavas: pedido.octavas)
                return EscalaJSON.ManoDelPiano(
                    mano: notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda },
                    notas: digitacion.alturas.map { $0.nota.nombre(en: notacion) }, dedos: digitacion.dedos)
            }
        }
        if pedido.modos {
            datos.modosParalelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, notacion: notacion).map {
                EscalaJSON.Modo(nombre: $0.nombre, brillo: $0.brillo, cambios: $0.cambios)
            }
            datos.modosRelativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, notacion: notacion)
                .map(\.nombre)
        }
        if pedido.simetria {
            if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, notacion: notacion) {
                datos.simetria = EscalaJSON.Simetria(
                    resumen: simetria.resumen, tonicas: simetria.tonicas,
                    ciclos: simetria.ciclos.map { EscalaJSON.Detalle(nombre: $0.nombre, detalle: $0.detalle) })
            } else {
                let veces = escala.transposicionesDistintas
                datos.simetria = EscalaJSON.Simetria(
                    resumen: notacion.texto { $0.repiteCada(veces, veces) }, tonicas: nil, ciclos: [])
            }
        }
        if pedido.vecinas {
            datos.vecinas = PresentacionDeEstudioDeEscala.vecinas(de: escala, notacion: notacion).map {
                EscalaJSON.Detalle(nombre: $0.nombre, detalle: $0.detalle)
            }
        }
        if pedido.estadisticas {
            let medidas = escala.estadisticas
            datos.estadisticas = EscalaJSON.Estadisticas(
                numeroDeNotas: medidas.numeroDeNotas, cardinal: medidas.cardinal?.nombre(en: notacion),
                brillo: medidas.brillo, brilloPorQuintas: (medidas.brilloPorQuintas * 100).rounded() / 100,
                pasos: medidas.pasos, vectorIntervalico: medidas.vectorIntervalico, anhemitonica: medidas.anhemitonica,
                cohemitonica: medidas.cohemitonica, transposicionesDistintas: medidas.transposicionesDistintas,
                numeroDeForte: medidas.numeroDeForte, maximamenteRegular: medidas.maximamenteRegular,
                aproximada: medidas.aproximada)
        }
        if pedido.doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: pedido.secuencia, notacion: notacion)
            datos.doceTonalidades = hoja.tonalidades.map { EscalaJSON.Tonalidad(tonalidad: $0.titulo, notas: $0.notas) }
            if pedido.conAcordes,
                let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !pedido.triadas, notacion: notacion)
            {
                datos.acordesEnLasDoceTonalidades = EscalaJSON.AcordesEnLasDoce(
                    grados: tabla.grados,
                    filas: tabla.filas.map { .init(tonalidad: $0.tonalidad, acordes: $0.acordes) })
            }
        }
        if let otra = pedido.otra {
            let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, notacion: notacion)
            datos.comparacion = EscalaJSON.Comparacion(
                con: otra.nombre(en: notacion), comunes: comparacion.comunes, soloEnOrigen: comparacion.soloEnOrigen,
                soloEnDestino: comparacion.soloEnDestino, cambios: comparacion.cambios,
                distancia: comparacion.distancia)
        }
        return datos
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
        guard palabras.count == 2 else { throw ErrorDeUso.dosNotas }
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
            throw ErrorDeUso.sinSalidaJSON("tradiciones " + primera)
        }
        if let opcion = Argumentos(textos).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
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
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
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

    // MARK: Armonización y conducción de las voces

    /// Un acorde de un coral: su cifrado, su grado (vacío si no lo tiene) y las alturas de grave a agudo.
    struct AcordeDelCoral: Encodable {
        let cifrado: String
        let grado: String
        let voces: [String]

        init(_ fila: CoralPresentado.Fila) {
            cifrado = fila.cifrado
            grado = fila.grado
            voces = fila.voces.split(separator: " ").map(String.init)
        }
    }

    struct ArmonizacionJSON: Encodable {
        let titulo: String
        /// Las armonizaciones, de mejor a peor, como en el texto.
        let propuestas: [String]
        /// El coral a cuatro voces de la mejor; `nil` si las notas no llevan octava.
        let coral: [AcordeDelCoral]?
        /// Lo que se dice en lugar del resultado (no hay armonización, no hay coral…).
        let avisos: [String]
    }

    /// `armonizar Mi4 Re4 Do4 --json`.
    static func armonizarJSON(_ textos: [String], _ notacion: Notacion) throws -> ArmonizacionJSON {
        let coral = try coralArmonizado(textos, notacion)
        let sinCoral = coral.avisos.contains(.faltanOctavas) || coral.avisos.contains(.sinArmonizacion)
        return ArmonizacionJSON(
            titulo: coral.titulo, propuestas: coral.propuestas,
            coral: sinCoral ? nil : coral.filas.map(AcordeDelCoral.init),
            avisos: coral.avisos.filter { $0 != .faltanOctavas }.map { $0.texto(en: notacion) })
    }

    struct RealizacionJSON: Encodable {
        let titulo: String
        let coral: [AcordeDelCoral]
        let avisos: [String]
    }

    /// `realizar Do Fa Sol7 Do --json`.
    static func realizarJSON(_ textos: [String], _ notacion: Notacion) throws -> RealizacionJSON {
        let coral = try coralRealizado(textos, notacion)
        return RealizacionJSON(
            titulo: coral.titulo, coral: coral.filas.map(AcordeDelCoral.init),
            avisos: coral.avisos.map { $0.texto(en: notacion) })
    }

    struct RevisionJSON: Encodable, ConFaltas {
        /// Una falta de conducción. `tipo` es el nombre de la regla (`quintasParalelas`, `cruceDeVoces`…), el mismo en
        /// todos los idiomas; las voces se cuentan desde 1, la más grave; el acorde, desde 1 (en las faltas entre dos
        /// acordes, el primero de los dos).
        struct Falta: Encodable {
            let tipo: String
            let texto: String
            let acorde: Int
            let voces: [Int]
        }

        let acordes: [AcordeDelCoral]
        let faltas: [Falta]
        var hayFaltas: Bool { !faltas.isEmpty }
    }

    /// `revisar Do3 Mi4 Sol4 Do5, Re3 Fa4 La4 Re5 --json`: sale con código 3 si hay faltas.
    static func revisarJSON(_ textos: [String], _ notacion: Notacion) throws -> RevisionJSON {
        let coral = try coralRevisado(textos, notacion)
        return RevisionJSON(
            acordes: coral.filas.map(AcordeDelCoral.init),
            faltas: faltas(de: coral).map {
                RevisionJSON.Falta(
                    tipo: clave(de: $0.tipo), texto: $0.descripcion(en: notacion), acorde: $0.acorde + 1,
                    voces: $0.voces.map { $0 + 1 })
            })
    }

    struct ContrapuntoJSON: Encodable, ConFaltas {
        /// Una falta del contrapunto. `tipo` es el nombre de la regla (`quintasParalelas`, `notaRepetida`…), el mismo
        /// en todos los idiomas; los compases de la primera y la última nota se cuentan desde 1.
        struct Falta: Encodable {
            let tipo: String
            let texto: String
            let compases: [Int]
        }

        let especie: Int
        /// Si el contrapunto va encima del cantus firmus.
        let encima: Bool
        let faltas: [Falta]
        var hayFaltas: Bool { !faltas.isEmpty }
    }

    /// `contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5 --json`: sale con código 3 si hay faltas.
    static func contrapuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> ContrapuntoJSON {
        let ejercicio = try ejercicioDeContrapunto(textos)
        return ContrapuntoJSON(
            especie: ejercicio.especie.rawValue, encima: ejercicio.contrapuntoArriba,
            faltas: ejercicio.faltas.map {
                ContrapuntoJSON.Falta(
                    tipo: clave(de: $0.tipo), texto: $0.descripcion(en: notacion),
                    compases: [$0.compases.lowerBound + 1, $0.compases.upperBound + 1])
            })
    }

    struct TransposicionJSON: Encodable {
        let intervalo: IntervaloJSON
        /// `acordes` o `notas`: cómo se ha leído lo que se transporta.
        let contenido: String
        /// Lo transportado, como en el texto.
        let texto: String
    }

    /// `transponer 2M Do Fa Sol7 --json`.
    static func transponerJSON(_ textos: [String], _ notacion: Notacion) throws -> TransposicionJSON {
        let hecho = try transporte(textos, notacion)
        let intervalo = hecho.intervalo
        return TransposicionJSON(
            intervalo: IntervaloJSON(
                nombre: intervalo.nombre(en: notacion), abreviatura: intervalo.texto(en: notacion),
                semitonos: intervalo.semitonos, numero: intervalo.numero,
                descendente: intervalo.sentido == .descendente),
            contenido: hecho.contenido == .acordes ? "acordes" : "notas", texto: hecho.texto)
    }

    /// La clave de una falta de conducción en el JSON: el nombre de su caso, que no cambia con el idioma. El `switch`
    /// no tiene `default`: una falta nueva no compila sin la suya.
    static func clave(de tipo: FaltaDeConduccion.Tipo) -> String {
        switch tipo {
        case .quintasParalelas: "quintasParalelas"
        case .octavasParalelas: "octavasParalelas"
        case .quintasDirectas: "quintasDirectas"
        case .octavasDirectas: "octavasDirectas"
        case .cruceDeVoces: "cruceDeVoces"
        case .superposicion: "superposicion"
        case .separacionExcesiva: "separacionExcesiva"
        case .saltoNoMelodico: "saltoNoMelodico"
        case .fueraDeTesitura: "fueraDeTesitura"
        }
    }

    /// La clave de una falta de contrapunto en el JSON, como la de `clave(de:)` de las de conducción.
    static func clave(de tipo: FaltaDeContrapunto.Tipo) -> String {
        switch tipo {
        case .ritmoDeLaEspecie: "ritmoDeLaEspecie"
        case .comienzoImperfecto: "comienzoImperfecto"
        case .finalImperfecto: "finalImperfecto"
        case .finalSinGradoConjunto: "finalSinGradoConjunto"
        case .disonanciaEnParteFuerte: "disonanciaEnParteFuerte"
        case .disonanciaMalTratada: "disonanciaMalTratada"
        case .retardoMalResuelto: "retardoMalResuelto"
        case .quintasParalelas: "quintasParalelas"
        case .octavasParalelas: "octavasParalelas"
        case .quintasDirectas: "quintasDirectas"
        case .octavasDirectas: "octavasDirectas"
        case .unisono: "unisono"
        case .cruceDeVoces: "cruceDeVoces"
        case .saltoNoMelodico: "saltoNoMelodico"
        case .saltoSinCompensar: "saltoSinCompensar"
        case .notaRepetida: "notaRepetida"
        }
    }
}
