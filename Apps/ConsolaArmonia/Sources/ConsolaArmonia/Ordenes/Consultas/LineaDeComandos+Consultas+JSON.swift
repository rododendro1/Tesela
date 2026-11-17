import Armonia
import ExposicionArmonia
import Foundation

// `--json` de las consultas: acordes, escalas, arpegios, intervalos, tonalidades, tradiciones, teoría postonal y el
// catálogo. Lo común a todas las órdenes está en LineaDeComandos+JSON.swift.

extension LineaDeComandos {
    // MARK: Acordes y escalas
    //
    // Los datos son los de `ExposicionArmonia` (`AcordePresentado`, `EscalaPresentada`…), los mismos que da el
    // texto: sus nombres son las claves del JSON.

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
        let conEscalas = argumentos.quitarMarca(.escalas)
        return try palabras(argumentos, siFaltan: .faltaCifrado).map {
            let acorde = try Acorde(leyendo: $0, enLaOrden: notacion)
            return AcordeJSON(
                acorde: AcordePresentado(acorde, en: notacion),
                escalas: conEscalas
                    ? PresentacionDeEscalaYAcorde.escalas(de: acorde, en: tonalidad, notacion: notacion).map {
                        EscalaDelAcordeJSON($0)
                    } : nil,
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

    /// Un acorde de `acorde --json`: las claves de `AcordePresentado` y, con `--escalas`, `escalas` (en la
    /// tonalidad de `--en`); con `--estadisticas`, `estadisticas` y `enLaTonalidad`; con `--comparar`, `relacion`.
    struct AcordeJSON: Encodable {
        let acorde: AcordePresentado
        let escalas: [EscalaDelAcordeJSON]?
        let estadisticas: EstadisticasDeAcordePresentadas?
        let enLaTonalidad: AcordeEnLaTonalidadPresentado?
        let relacion: RelacionEntreAcordesPresentada?

        private enum Clave: String, CodingKey { case escalas, estadisticas, enLaTonalidad, relacion }

        func encode(to encoder: any Encoder) throws {
            try acorde.encode(to: encoder)
            var contenedor = encoder.container(keyedBy: Clave.self)
            try contenedor.encodeIfPresent(escalas, forKey: .escalas)
            try contenedor.encodeIfPresent(estadisticas, forKey: .estadisticas)
            try contenedor.encodeIfPresent(enLaTonalidad, forKey: .enLaTonalidad)
            try contenedor.encodeIfPresent(relacion, forKey: .relacion)
        }
    }

    /// Una escala para el acorde, en `acorde --escalas --json`: su nombre, su motivo («del cifrado»; no sale si
    /// solo es compatible), sus notas con su grado sobre el acorde, las tensiones y las notas a evitar.
    struct EscalaDelAcordeJSON: Encodable {
        let nombre: String
        let motivo: String?
        let notas: [String]
        let tensiones: [String]
        let aEvitar: [String]

        init(_ presentada: EscalaSobreAcordePresentada) {
            func lista(_ texto: String) -> [String] {
                texto.isEmpty ? [] : texto.components(separatedBy: " · ")
            }
            nombre = presentada.nombre
            motivo = presentada.motivo
            notas = lista(presentada.notas)
            tensiones = lista(presentada.tensiones)
            aEvitar = lista(presentada.aEvitar)
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

        /// Las claves de `EscalaPresentada`, como sin opciones: cada dato nuevo de la escala sale aquí sin tocar nada.
        let escala: EscalaPresentada
        /// Lo que añaden las opciones, en las mismas claves del objeto.
        var opciones = Opciones()

        func encode(to encoder: any Encoder) throws {
            try escala.encode(to: encoder)
            try opciones.encode(to: encoder)
        }

        /// Lo que añaden las opciones. Son los tipos de ExposicionArmonia que enseña el texto, cuando el JSON lleva lo
        /// mismo (`ModoPresentado`, `TablaDeAcordesPresentada`…, que saben qué campos van en JSON), o, si lleva otra
        /// cosa (números en lugar de textos), los de aquí.
        struct Opciones: Encodable {
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
            /// `--tetracordos` en un maqām o un makam: sus ajnas o çeşni y la obra que los da.
            var ajnas: [FragmentoDeLaEscalaPresentado]?
            var fuenteDeLosAjnas: String?
            /// `--vecinas`.
            var vecinas: [EscalaConDetallePresentada]?
            /// `--estadisticas`.
            var estadisticas: EstadisticasDeEscalaPresentadas?
            /// `--tensiones-disponibles`: la cuatríada de cada grado con sus tensiones.
            var tensionesDisponibles: [TensionesDelGradoPresentadas]?
            /// `--cuartas`: el acorde por cuartas de cada grado.
            var acordesPorCuartas: [AcordePorCuartasPresentado]?
            /// `--progresiones`: progresiones con sus tríadas.
            var progresiones: [ProgresionDeLaEscala]?
            /// `--parecidas`: las escalas con más notas en común.
            var parecidas: [EscalaConDetallePresentada]?
            /// `--escalera`: de la más oscura a la más brillante.
            var escaleraDeBrillo: [Peldano]?
            /// `--doce`, con la secuencia de `--secuencia` si se da; con `--acordes`, también los acordes de cada
            /// grado.
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
            var referencias: [ReferenciaPresentada]?
        }
    }

    /// `escala Re dórico --json`, con las mismas opciones que el texto (`pedidoDeEscala`).
    static func escalaJSON(_ textos: [String], _ notacion: Notacion) throws -> EscalaJSON {
        let pedido = try pedidoDeEscala(textos, en: notacion)
        if pedido.bibtex { throw ErrorDeUso.sinSalidaJSON("escala --formato bibtex") }
        let escala = pedido.escala
        var opciones = EscalaJSON.Opciones()
        if escala.tipo.categoria == .melakarta {
            opciones.mela = escala.tipo.numeroDeMelakarta
            opciones.cakra = escala.tipo.cakra?.nombre
            opciones.mnemonico = escala.tipo.mnemonicoDeMela
            opciones.solfa = escala.tipo.solfaDeMela
        }
        let referencias = escala.tipo.referencias
        if !referencias.isEmpty {
            opciones.referencias = referencias.map(ReferenciaPresentada.init)
        }
        if pedido.conAcordes {
            opciones.acordesQueCaben = PresentacionDeEscalaYAcorde.acordesQueCaben(escala, en: notacion).map {
                EscalaJSON.Grado(grado: $0.grado, acordes: $0.acordes.map { $0.cifrado(en: notacion) })
            }
        }
        if let secuencia = pedido.secuencia {
            let alturas = escala.secuencia(secuencia, octavas: pedido.octavas, sentido: pedido.sentido)
            opciones.secuencia = EscalaJSON.Secuencia(
                nombre: secuencia.nombre(en: notacion), notas: alturas.map { $0.nombre(en: notacion) },
                midi: alturas.map(\.midi))
        }
        if pedido.piano {
            opciones.piano = Mano.allCases.map { mano in
                let digitacion = escala.digitacionDePiano(mano, octavas: pedido.octavas)
                return EscalaJSON.ManoDelPiano(
                    mano: notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda },
                    notas: digitacion.alturas.map { $0.nota.nombre(en: notacion) }, dedos: digitacion.dedos)
            }
        }
        if pedido.modos {
            opciones.modosParalelos = PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion)
            opciones.modosRelativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, en: notacion)
                .map(\.nombre)
        }
        if pedido.simetria {
            if let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, en: notacion) {
                opciones.simetria = EscalaJSON.Simetria(
                    resumen: simetria.resumen, tonicas: simetria.tonicas, ciclos: simetria.ciclos)
            } else {
                let veces = escala.transposicionesDistintas
                opciones.simetria = EscalaJSON.Simetria(
                    resumen: notacion.texto { $0.repiteCada(veces, veces) }, tonicas: nil, ciclos: [])
            }
        }
        if pedido.tetracordos {
            opciones.tetracordos = piezasDeTetracordos(de: escala, notacion)
            let ajnas = PresentacionDeEstudioDeEscala.ajnas(de: escala, en: notacion)
            opciones.ajnas = ajnas?.fragmentos
            opciones.fuenteDeLosAjnas = ajnas?.fuente
        }
        if pedido.vecinas {
            opciones.vecinas = PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion)
        }
        if pedido.estadisticas {
            opciones.estadisticas = EstadisticasDeEscalaPresentadas(escala, en: notacion)
        }
        if pedido.tensionesDeLosGrados {
            opciones.tensionesDisponibles = PresentacionDeEstudioDeEscala.tensionesDisponibles(de: escala, en: notacion)
        }
        if pedido.cuartas {
            opciones.acordesPorCuartas = PresentacionDeEstudioDeEscala.acordesPorCuartas(de: escala, en: notacion)
        }
        if pedido.progresiones {
            opciones.progresiones = PresentacionDeEstudioDeEscala.progresiones(de: escala, en: notacion)
        }
        if pedido.parecidas {
            opciones.parecidas = PresentacionDeEstudioDeEscala.parecidas(a: escala, en: notacion)
        }
        if pedido.escalera {
            let peldanos = PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, en: notacion)
            opciones.escaleraDeBrillo = peldanos.map {
                let brillo = Redondeo.valor($0.escala.estadisticas.brilloPorQuintas, decimales: 2)
                return EscalaJSON.Peldano(
                    nombre: $0.nombre, brilloPorQuintas: brillo, cambio: $0.cambio.isEmpty ? nil : $0.cambio,
                    dePartida: $0.esLaDePartida)
            }
        }
        if pedido.doce {
            let hoja = HojaDeEstudioPresentada(
                escala, secuencia: pedido.secuencia, en: notacion)
            opciones.doceTonalidades = hoja.tonalidades.map {
                EscalaJSON.Tonalidad(tonalidad: $0.titulo, notas: $0.notas)
            }
            if pedido.conAcordes {
                opciones.acordesEnLasDoceTonalidades = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, deNotas: pedido.triadas ? 3 : 4, en: notacion)
            }
        }
        if let otra = pedido.otra {
            let comparacion = ComparacionDeEscalasPresentada(escala, con: otra, en: notacion)
            opciones.comparacion = EscalaJSON.Comparacion(
                con: otra.nombre(en: notacion), comunes: comparacion.comunes, soloEnOrigen: comparacion.soloEnOrigen,
                soloEnDestino: comparacion.soloEnDestino, cambios: comparacion.cambios,
                distancia: comparacion.distancia,
                relacion: RelacionEntreEscalasPresentada(escala.relacion(con: otra), en: notacion))
        }
        return EscalaJSON(escala: EscalaPresentada(escala, en: notacion), opciones: opciones)
    }

    // MARK: Arpegios, intervalos y tonalidades
    //
    // Los datos son los mismos que da el texto (`NotasDeArpegioPresentadas`, `IntervaloPresentado`,
    // `TonalidadPresentada`): sus nombres son las claves del JSON.

    /// `arpegio Do7 --patron alberti --json`: cada arpegio con sus notas, una lista aunque sea uno solo. Admite las
    /// mismas opciones que el texto.
    static func arpegioJSON(_ textos: [String], _ notacion: Notacion) throws -> [NotasDeArpegioPresentadas] {
        try arpegios(textos, en: notacion).map { NotasDeArpegioPresentadas($0, en: notacion) }
    }

    /// `intervalo Do4 Mi5 --json`.
    static func intervaloJSON(_ textos: [String], _ notacion: Notacion) throws -> IntervaloPresentado {
        let escritas = try palabras(Argumentos(textos), siFaltan: .dosNotas)
        guard escritas.count == 2 else { throw ErrorDeUso.dosNotas }
        return IntervaloPresentado(try intervalo(escritas[0], escritas[1], en: notacion), en: notacion)
    }

    /// `tonalidad La menor --json`.
    static func tonalidadJSON(_ textos: [String], _ notacion: Notacion) throws -> TonalidadPresentada {
        let texto = try palabras(Argumentos(textos), siFaltan: .faltaTonalidad).joined(separator: " ")
        return TonalidadPresentada(try LineaDeComandos.tonalidad(texto, en: notacion), en: notacion)
    }

    // MARK: Tradiciones

    /// `tradiciones --json`: cada tradición con sus categorías y cuántas escalas tiene de cada una. Las escalas de una
    /// tradición (`tradiciones japon`) no dan JSON, como `escalas`.
    static func tradicionesJSON(_ textos: [String], _ notacion: Notacion) throws -> [TradicionPresentada] {
        if let primera = textos.first, !Argumentos.pareceUnaOpcion(primera) {
            throw ErrorDeUso.sinSalidaJSON("tradiciones " + primera)
        }
        try Argumentos(textos).sinOpcionesDesconocidas()
        return catalogoDeTradiciones(en: notacion).map(\.datos)
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

    /// `escalas --tradicion japon --json`: los grupos del catálogo, los mismos que da el texto. Vacío si no hay
    /// ninguna. `--comparar`, `--mapa`, `--vecinas`, `--parecidas` y `--escalera` no dan JSON.
    static func escalasJSON(_ textos: [String], _ notacion: Notacion) throws -> [GrupoDeEscalasPresentado] {
        switch try catalogoDeEscalas(textos, notacion) {
        case .otraCosa(_, let opcion): throw ErrorDeUso.sinSalidaJSON("escalas " + opcion)
        case .ninguna: return []
        case .grupos(let grupos, _):
            return grupos.map { GrupoDeEscalasPresentado(titulo: $0.titulo, tipos: $0.tipos, en: notacion) }
        }
    }
}
