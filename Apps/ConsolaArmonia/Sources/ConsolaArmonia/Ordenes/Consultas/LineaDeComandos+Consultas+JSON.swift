import Armonia
import Exposicion
import Foundation

// `--json` de las consultas: acordes, escalas, arpegios, intervalos, tonalidades, tradiciones, teoría postonal y el
// catálogo. Lo común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Acordes y escalas
    //
    // Los datos son los de `Exposicion` (DatosDeConsultas.swift), los mismos que da el texto: sus nombres
    // son las claves del JSON.

    /// `acorde Sol7 Do --json`: cada acorde con sus notas, una lista aunque sea uno solo.
    static func acordeJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeAcorde] {
        try palabras(Argumentos(textos), siFaltan: .faltaCifrado).map {
            DatosDeAcorde(try Acorde(leyendoEnLaOrden: $0), notacion: notacion)
        }
    }

    /// `identificar Do Mi Sol Sib --json`: los acordes que pueden formar las notas, del más probable al menos (como
    /// mucho cinco, como en el texto); vacío si no forman ninguno.
    static func identificarJSON(_ textos: [String], _ notacion: Notacion) throws -> [DatosDeCandidato] {
        try DatosDeCandidato.identificar(palabras(Argumentos(textos), siFaltan: .faltanNotas), en: notacion)
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
        struct Peldano: Encodable {
            let nombre: String
            let brilloPorQuintas: Double
            /// La nota que sube desde el peldaño anterior; no está en el primero.
            let cambio: String?
            let dePartida: Bool
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
        /// `--dedos`: la mano derecha primero.
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
        /// `--escalera`: de la más oscura a la más brillante.
        var escaleraDeBrillo: [Peldano]?
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
            datos.acordesQueCaben = PresentacionDeEscalaYAcorde.acordesQueCaben(escala, en: notacion).map {
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
            datos.modosParalelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion).map {
                EscalaJSON.Modo(nombre: $0.nombre, brillo: $0.brillo, cambios: $0.cambios)
            }
            datos.modosRelativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, en: notacion)
                .map(\.nombre)
        }
        if pedido.simetria {
            if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, en: notacion) {
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
            datos.vecinas = PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion).map {
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
        if pedido.escalera {
            let peldanos = PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, en: notacion)
            datos.escaleraDeBrillo = peldanos.map {
                let brillo = ($0.escala.estadisticas.brilloPorQuintas * 100).rounded() / 100
                return EscalaJSON.Peldano(
                    nombre: $0.nombre, brilloPorQuintas: brillo, cambio: $0.cambio.isEmpty ? nil : $0.cambio,
                    dePartida: $0.esLaDePartida)
            }
        }
        if pedido.doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: pedido.secuencia, en: notacion)
            datos.doceTonalidades = hoja.tonalidades.map { EscalaJSON.Tonalidad(tonalidad: $0.titulo, notas: $0.notas) }
            if pedido.conAcordes,
                let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !pedido.triadas, en: notacion)
            {
                datos.acordesEnLasDoceTonalidades = EscalaJSON.AcordesEnLasDoce(
                    grados: tabla.grados,
                    filas: tabla.filas.map { .init(tonalidad: $0.tonalidad, acordes: $0.acordes) })
            }
        }
        if let otra = pedido.otra {
            let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, en: notacion)
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
        let tonalidad = try Tonalidad(leyendoEnLaOrden: texto)
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

    // MARK: Teoría postonal

    /// `conjunto 0 4 7 --json`: el conjunto con sus formas y sus vectores.
    static func conjuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeConjunto {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaConjunto).joined(separator: " ")
        return DatosDeConjunto(try ConjuntoDeClasesDeAltura(leyendo: texto), notacion: notacion)
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6 --json`: la serie con sus intervalos, sus hexacordos, sus formas y la matriz.
    static func serieJSON(_ textos: [String], _ notacion: Notacion) throws -> DatosDeSerie {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaSerie).joined(separator: " ")
        return DatosDeSerie(try SerieDodecafonica(leyendo: texto), notacion: notacion)
    }

    // MARK: El catálogo de escalas

    /// Una escala del catálogo de `escalas --json`: su nombre, sus notas desde Do y sus clases, y de dónde es.
    struct EscalaDelCatalogoJSON: Encodable {
        let nombre: String
        let notas: [String]
        let clases: [Int]
        let microtonal: Bool
        let brilloPorQuintas: Double
        /// Las claves de `--tradicion`, `--categoria` y `--fuente`, o `nil` en las occidentales.
        let tradicion: String?
        let categoria: String?
        let fuente: String?
    }

    /// Un grupo de `escalas --json`: «Japón · escala» y sus escalas, en el orden de `--orden`.
    struct GrupoDeEscalasJSON: Encodable {
        let titulo: String
        let escalas: [EscalaDelCatalogoJSON]
    }

    /// `escalas --tradicion japon --json`: los grupos del catálogo, los mismos que da el texto. Vacío si no hay
    /// ninguna. `--comparar`, `--mapa`, `--vecinas`, `--parecidas` y `--escalera` no dan JSON.
    static func escalasJSON(_ textos: [String], _ notacion: Notacion) throws -> [GrupoDeEscalasJSON] {
        switch try catalogoDeEscalas(textos, notacion) {
        case .otraCosa(_, let opcion): throw ErrorDeUso.sinSalidaJSON("escalas " + opcion)
        case .ninguna: return []
        case .grupos(let grupos, _):
            return grupos.map { grupo in
                GrupoDeEscalasJSON(
                    titulo: grupo.titulo,
                    escalas: grupo.tipos.map { tipo in
                        let escala = Escala(.do, tipo)
                        return EscalaDelCatalogoJSON(
                            nombre: tipo.nombre(en: notacion), notas: escala.notas.map { $0.nombre(en: notacion) },
                            clases: escala.notas.map(\.claseDeAltura), microtonal: tipo.microtonal != nil,
                            brilloPorQuintas: escala.estadisticas.brilloPorQuintas, tradicion: tipo.tradicion?.rawValue,
                            categoria: tipo.categoria?.rawValue, fuente: tipo.fuente?.rawValue)
                    })
            }
        }
    }
}
