import Armonia
import Exposicion
import Foundation

// `--json` de las consultas: acordes, escalas, arpegios, intervalos, tonalidades, tradiciones, teoría postonal y el
// catálogo. Lo común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Acordes y escalas
    //
    // Los datos son los de `Exposicion` (`AcordePresentado`, `EscalaPresentada`…), los mismos que da el texto: sus
    // nombres son las claves del JSON.

    /// `acorde Sol7 Do --json`: cada acorde con sus notas, una lista aunque sea uno solo; con `--estadisticas`, cada
    /// uno lleva también la clave `estadisticas` (`EstadisticasDeAcordePresentadas`).
    /// Con `--estadisticas`, también `enLaTonalidad` (`AcordeEnLaTonalidadPresentado`, en la de `--en` o en la suya), y
    /// con `--comparar`, `relacion` (`RelacionEntreAcordesPresentada`).
    static func acordeJSON(_ textos: [String], _ notacion: Notacion) throws -> [AcordeJSON] {
        var argumentos = Argumentos(textos)
        guard let tonalidad = try argumentos.quitarTonalidad(en: notacion) else {
            throw ErrorDeUso.faltaTonalidadTrasEn
        }
        var otro: Acorde?
        if let texto = try argumentos.valor(.comparar) { otro = try Acorde(leyendo: texto, enLaOrden: notacion) }
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        return try palabras(argumentos, siFaltan: .faltaCifrado).map {
            let acorde = try Acorde(leyendo: $0, enLaOrden: notacion)
            return AcordeJSON(
                acorde: AcordePresentado(acorde, en: notacion),
                estadisticas: estadisticas
                    ? EstadisticasDeAcordePresentadas(acorde.estadisticas, sobre: acorde.fundamental, en: notacion)
                    : nil,
                enLaTonalidad: estadisticas
                    ? AcordeEnLaTonalidadPresentado(
                        acorde, en: tonalidad ?? acorde.tonalidadPropia, notacion: notacion) : nil,
                relacion: otro.map {
                    RelacionEntreAcordesPresentada(acorde.relacion(con: $0, en: tonalidad), en: notacion)
                })
        }
    }

    /// Un acorde de `acorde --json`: las claves de `AcordePresentado` y, con `--estadisticas`, `estadisticas` y
    /// `enLaTonalidad`; con `--comparar`, `relacion`.
    struct AcordeJSON: Encodable {
        let acorde: AcordePresentado
        let estadisticas: EstadisticasDeAcordePresentadas?
        let enLaTonalidad: AcordeEnLaTonalidadPresentado?
        let relacion: RelacionEntreAcordesPresentada?

        private enum Clave: String, CodingKey { case estadisticas, enLaTonalidad, relacion }

        func encode(to encoder: any Encoder) throws {
            try acorde.encode(to: encoder)
            var contenedor = encoder.container(keyedBy: Clave.self)
            try contenedor.encodeIfPresent(estadisticas, forKey: .estadisticas)
            try contenedor.encodeIfPresent(enLaTonalidad, forKey: .enLaTonalidad)
            try contenedor.encodeIfPresent(relacion, forKey: .relacion)
        }
    }

    /// `identificar Do Mi Sol Sib --json`: los acordes que pueden formar las notas, del más probable al menos (como
    /// mucho cinco, como en el texto); vacío si no forman ninguno.
    static func identificarJSON(_ textos: [String], _ notacion: Notacion) throws -> [CandidatoPresentado] {
        try CandidatoPresentado.identificar(palabras(Argumentos(textos), siFaltan: .faltanNotas), en: notacion)
    }

    /// `escala Re dórico --json`: la escala con sus notas y los acordes de sus grados (las claves de
    /// `EscalaPresentada`) y, con las opciones del texto, lo que añaden: cada una, su clave.
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
        struct Simetria: Encodable {
            let resumen: String
            /// Las tónicas desde las que empieza igual; no está si la escala solo se repite a la octava.
            let tonicas: String?
            let ciclos: [EscalaConDetallePresentada]
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
            /// Lo que dicen las teorías: Myhill, Rothenberg, Hanson, Messiaen, Balzano…
            let teoria: MedidasDeEscalaPresentadas
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
        struct Comparacion: Encodable {
            let con: String
            let comunes: String
            let soloEnOrigen: String
            let soloEnDestino: String
            let cambios: [String]
            let distancia: String?
            /// Lo que separa a las dos escalas: quintas, conducción mínima, Fourier, Isaacson, Morris y Forte.
            let relacion: RelacionEntreEscalasPresentada
        }

        // Las de `EscalaPresentada`, como sin opciones. Las de las opciones son los tipos de Exposicion que enseña el
        // texto, cuando el JSON lleva lo mismo (`ModoPresentado`, `TablaDeAcordesPresentada`…, que saben qué
        // campos van en JSON), o, si lleva otra cosa (números en lugar de textos), los de aquí.
        let nombre: String
        let notas: [String]
        let clases: [Int]
        let modo: String?
        let acordes: [EscalaPresentada.AcordeDelGrado]?
        /// De cuándo y de dónde es: su año, su época, su período, sus lugares, sus estilos y sus escuelas.
        let origen: OrigenDeEscalaPresentado?
        /// `--acordes`.
        var acordesQueCaben: [Grado]?
        /// `--secuencia`.
        var secuencia: Secuencia?
        /// `--dedos`: la mano derecha primero.
        var piano: [ManoDelPiano]?
        /// `--modos`.
        var modosParalelos: [ModoPresentado]?
        var modosRelativos: [String]?
        /// `--simetria`.
        var simetria: Simetria?
        /// `--tetracordos`: cada división, pieza a pieza.
        var tetracordos: [[PiezaDeTetracordos]]?
        /// `--tetracordos` en un maqām o un makam: sus ajnas o çeşni.
        var ajnas: [FragmentoJSON]?
        /// `--vecinas`.
        var vecinas: [EscalaConDetallePresentada]?
        /// `--estadisticas`.
        var estadisticas: Estadisticas?
        /// `--escalera`: de la más oscura a la más brillante.
        var escaleraDeBrillo: [Peldano]?
        /// `--doce`, con la secuencia de `--secuencia` si se da; con `--acordes`, también los acordes de cada grado.
        var doceTonalidades: [Tonalidad]?
        var acordesEnLasDoceTonalidades: TablaDeAcordesPresentada?
        /// `--comparar`.
        var comparacion: Comparacion?
        /// En un mēḷa, su número y su cakra.
        var mela: Int?
        var cakra: String?
        var mnemonico: String?
        var solfa: [String]?
        /// Dónde se lee la escala, si es de otra tradición; `nil` en las demás.
        var referencias: [ReferenciaJSON]?

        /// Una obra o una cita: su clave de BibTeX, la cita breve («West 1992: 160–172») y la referencia completa.
        struct ReferenciaJSON: Encodable {
            let clave: String
            let cita: String
            let descripcion: String
            let paginas: String?
            let doi: String?
            let url: String?
        }

        init(_ datos: EscalaPresentada) {
            nombre = datos.nombre
            notas = datos.notas
            clases = datos.clases
            modo = datos.modo
            acordes = datos.acordes
            origen = datos.origen
        }
    }

    /// `escala Re dórico --json`, con las mismas opciones que el texto (`pedidoDeEscala`).
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> EscalaJSON {
        let pedido = try pedidoDeEscala(textos, en: notacion)
        if pedido.bibtex { throw ErrorDeUso.sinSalidaJSON("escala --bibtex") }
        let escala = pedido.escala
        var datos = EscalaJSON(EscalaPresentada(escala, en: notacion))
        if escala.tipo.categoria == .melakarta {
            datos.mela = escala.tipo.numeroDeMelakarta
            datos.cakra = escala.tipo.cakra?.nombre
            datos.mnemonico = escala.tipo.mnemonicoDeMela
            datos.solfa = escala.tipo.solfaDeMela
        }
        let referencias = escala.tipo.referencias
        if !referencias.isEmpty {
            datos.referencias = referencias.map {
                EscalaJSON.ReferenciaJSON(
                    clave: $0.clave, cita: $0.cita, descripcion: $0.descripcion, paginas: $0.paginasCitadas,
                    doi: $0.doi, url: $0.url)
            }
        }
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
            datos.modosParalelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion)
            datos.modosRelativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, en: notacion)
                .map(\.nombre)
        }
        if pedido.simetria {
            if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, en: notacion) {
                datos.simetria = EscalaJSON.Simetria(
                    resumen: simetria.resumen, tonicas: simetria.tonicas, ciclos: simetria.ciclos)
            } else {
                let veces = escala.transposicionesDistintas
                datos.simetria = EscalaJSON.Simetria(
                    resumen: notacion.texto { $0.repiteCada(veces, veces) }, tonicas: nil, ciclos: [])
            }
        }
        if pedido.tetracordos {
            datos.tetracordos = piezasDeTetracordos(de: escala, notacion)
            datos.ajnas = ajnasJSON(de: escala, notacion)
        }
        if pedido.vecinas {
            datos.vecinas = PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion)
        }
        if pedido.estadisticas {
            let medidas = escala.estadisticas
            datos.estadisticas = EscalaJSON.Estadisticas(
                numeroDeNotas: medidas.numeroDeNotas, cardinal: medidas.cardinal?.nombre(en: notacion),
                brillo: medidas.brillo, brilloPorQuintas: Redondeo.valor(medidas.brilloPorQuintas, decimales: 2),
                pasos: medidas.pasos, vectorIntervalico: medidas.vectorIntervalico, anhemitonica: medidas.anhemitonica,
                cohemitonica: medidas.cohemitonica, transposicionesDistintas: medidas.transposicionesDistintas,
                numeroDeForte: medidas.numeroDeForte, maximamenteRegular: medidas.maximamenteRegular,
                aproximada: medidas.aproximada, teoria: MedidasDeEscalaPresentadas(medidas, en: notacion))
        }
        if pedido.escalera {
            let peldanos = PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, en: notacion)
            datos.escaleraDeBrillo = peldanos.map {
                let brillo = Redondeo.valor($0.escala.estadisticas.brilloPorQuintas, decimales: 2)
                return EscalaJSON.Peldano(
                    nombre: $0.nombre, brilloPorQuintas: brillo, cambio: $0.cambio.isEmpty ? nil : $0.cambio,
                    dePartida: $0.esLaDePartida)
            }
        }
        if pedido.doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: pedido.secuencia, en: notacion)
            datos.doceTonalidades = hoja.tonalidades.map { EscalaJSON.Tonalidad(tonalidad: $0.titulo, notas: $0.notas) }
            if pedido.conAcordes {
                datos.acordesEnLasDoceTonalidades = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !pedido.triadas, en: notacion)
            }
        }
        if let otra = pedido.otra {
            let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, en: notacion)
            datos.comparacion = EscalaJSON.Comparacion(
                con: otra.nombre(en: notacion), comunes: comparacion.comunes, soloEnOrigen: comparacion.soloEnOrigen,
                soloEnDestino: comparacion.soloEnDestino, cambios: comparacion.cambios,
                distancia: comparacion.distancia,
                relacion: RelacionEntreEscalasPresentada(escala.relacion(con: otra), en: notacion))
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
        try arpegios(textos, en: notacion).map { arpegio in
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
        let escritas = try palabras(Argumentos(textos), siFaltan: .dosNotas)
        guard escritas.count == 2 else { throw ErrorDeUso.dosNotas }
        let medido = try intervalo(escritas[0], escritas[1], en: notacion)
        return IntervaloJSON(
            nombre: medido.nombre(en: notacion), abreviatura: medido.texto(en: notacion),
            semitonos: medido.semitonos, numero: medido.numero, descendente: medido.sentido == .descendente)
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

    /// Como `EscalaPresentada.AcordeDelGrado`: «ii» «Rem7».
    struct AcordeDelGrado: Encodable {
        let grado: String
        let cifrado: String
    }

    /// `tonalidad La menor --json`.
    static func tonalidadJSON(_ textos: [String], _ notacion: Notacion) throws -> TonalidadJSON {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaTonalidad).joined(separator: " ")
        let tonalidad = try Tonalidad(leyendo: texto, enLaOrden: notacion)
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
        try Argumentos(textos).sinOpcionesDesconocidas()
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
    static func conjuntoJSON(_ textos: [String], _ notacion: Notacion) throws -> ConjuntoPresentado {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaConjunto).joined(separator: " ")
        return ConjuntoPresentado(try ConjuntoDeClasesDeAltura(leyendo: texto), en: notacion)
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6 --json`: la serie con sus intervalos, sus hexacordos, sus formas y la matriz.
    static func serieJSON(_ textos: [String], _ notacion: Notacion) throws -> SeriePresentada {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaSerie).joined(separator: " ")
        return SeriePresentada(try SerieDodecafonica(leyendo: texto), en: notacion)
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
        /// Los nombres de sus lugares de origen y de uso (`TipoDeEscala.lugaresDeOrigen`, `lugaresDeUso`), los
        /// códigos ISO de sus países de origen y las claves de sus continentes de origen.
        let lugaresDeOrigen: [String]
        let lugaresDeUso: [String]
        let paises: [String]
        let continentes: [String]
        /// Las claves de su época de origen (`TipoDeEscala.epocaDeOrigen`) y de las de uso, su año de origen, la de
        /// su período, las de sus estilos (de más a menos importante), sus corrientes y sus escuelas.
        let anio: Int?
        let epoca: String?
        let epocasDeUso: [String]
        let periodo: String?
        let estilos: [String]
        let corrientes: [String]
        let escuelas: [String]
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
                            categoria: tipo.categoria?.rawValue, fuente: tipo.fuente?.rawValue,
                            lugaresDeOrigen: tipo.lugaresDeOrigen.map { $0.nombre(en: notacion) },
                            lugaresDeUso: tipo.lugaresDeUso.map { $0.nombre(en: notacion) },
                            paises: tipo.paisesDeOrigen.map(\.codigoISO),
                            continentes: tipo.continentesDeOrigen.map(\.rawValue), anio: tipo.anioDeOrigen,
                            epoca: tipo.epocaDeOrigen?.rawValue, epocasDeUso: tipo.epocasDeUso.map(\.rawValue),
                            periodo: tipo.periodo?.rawValue, estilos: tipo.estilos.map(\.rawValue),
                            corrientes: tipo.corrientes.map(\.rawValue), escuelas: tipo.escuelas.map(\.rawValue))
                    })
            }
        }
    }
}
