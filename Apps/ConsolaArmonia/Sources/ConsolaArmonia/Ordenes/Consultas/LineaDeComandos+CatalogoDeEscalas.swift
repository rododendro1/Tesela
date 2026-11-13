import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: el catálogo de escalas
//
// `escalas` y `tradiciones`: el catálogo, sus filtros y búsquedas, la comparación y el mapa de brillo.

extension LineaDeComandos {
    /// Cómo se escribe cada tradición en `--tradicion`, con los nombres españoles y con los ingleses (se aceptan los
    /// dos en cualquier idioma): `--tradicion mundo-arabe`, `--tradition arab-world`.
    static let nombresDeLasTradiciones: [(tradicion: Tradicion, espanol: String, ingles: String)] = [
        (.india, "india", "india"), (.grecia, "grecia", "greece"), (.greciaAntigua, "grecia-antigua", "ancient-greece"),
        (.mundoArabe, "mundo-arabe", "arab-world"), (.persia, "persia", "persia"), (.turquia, "turquia", "turkey"),
        (.azerbaiyan, "azerbaiyan", "azerbaijan"), (.china, "china", "china"), (.japon, "japon", "japan"),
        (.corea, "corea", "korea"), (.etiopia, "etiopia", "ethiopia"), (.indonesia, "indonesia", "indonesia"),
        (.klezmer, "klezmer", "klezmer"), (.andes, "andes", "andes"), (.bizancio, "bizancio", "byzantium"),
        (.mesopotamia, "mesopotamia", "mesopotamia"), (.africa, "africa", "africa"),
        (.sudesteAsiatico, "sudeste-asiatico", "southeast-asia"), (.gregoriano, "gregoriano", "gregorian"),
        (.europa, "europa", "europe"), (.vietnam, "vietnam", "vietnam"), (.brasil, "brasil", "brazil"),
        (.renacimiento, "renacimiento", "renaissance"),
    ]

    /// Cómo se escribe cada estilo occidental en `--uso`, en español y en inglés (se aceptan los dos en cualquier
    /// idioma): `--uso de-compositor`, `--use composer`. `popular` da los tres populares, y `siglo-xx`, el nombre de
    /// antes, las de compositor.
    static let nombresDeLosUsos: [(usos: [Estilo], espanol: String, ingles: String)] = [
        ([.clasica], "clasica", "classical"), ([.jazz], "jazz", "jazz"), ([.blues], "blues", "blues"),
        ([.deCompositor], "de-compositor", "composer"), ([.folclore], "folclore", "folk"),
        ([.flamenco], "flamenco", "flamenco"), ([.popRock], "pop-rock", "pop-rock"),
        (Estilo.populares, "popular", "popular"), ([.sintetica], "sintetica", "synthetic"),
        ([.deCompositor], "siglo-xx", "20th-century"),
    ]

    /// Cómo se escribe cada corriente en `escalas --uso`, en español y en inglés: `--uso bebop`, `--use
    /// neoclassical-metal`.
    static let nombresDeLasCorrientes: [(corriente: Corriente, espanol: String, ingles: String)] = [
        (.bebop, "bebop", "bebop"), (.modal, "modal", "modal"), (.impresionismo, "impresionismo", "impressionism"),
        (.rock, "rock", "rock"), (.heavyMetal, "heavy-metal", "heavy-metal"),
        (.metalNeoclasico, "metal-neoclasico", "neoclassical-metal"),
    ]

    /// La corriente de `escalas --uso modal`, por su clave, en español o en inglés, o por su nombre en español o en el
    /// idioma de la notación («jazz modal»); `nil` si no es ninguna.
    static func corriente(leyendo texto: String, _ notacion: Notacion) -> Corriente? {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasCorrientes.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.corriente
        }
        return Corriente.allCases.first { [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave) }
    }

    /// Los estilos de `--uso jazz`, por su clave (`de-compositor`), en español o en inglés, o por el nombre de un
    /// estilo en español o en el idioma de la notación; lanza `usoDesconocido` si no es ninguno.
    static func estilosDeUso(leyendo texto: String, _ notacion: Notacion) throws -> [Estilo] {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLosUsos.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.usos
        }
        guard
            let porNombre = Estilo.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.usoDesconocido(texto) }
        return [porNombre]
    }

    /// Cómo se escribe cada forma de agrupar en `--agrupar`, en español y en inglés (se aceptan los dos en cualquier
    /// idioma): `--agrupar pais`, `--group-by country`.
    static let nombresDeLasAgrupaciones: [(agrupacion: AgrupacionDeEscalas, espanol: String, ingles: String)] = [
        (.continente, "continente", "continent"), (.pais, "pais", "country"), (.epoca, "epoca", "era"),
    ]

    /// Cómo se escribe cada época en `--epoca`, en español y en inglés (se aceptan los dos en cualquier idioma):
    /// `--epoca edad-media`, `--era middle-ages`. `tonal` da las tres de la época tonal.
    static let nombresDeLasEpocas: [(epocas: [Epoca], espanol: String, ingles: String)] = [
        ([.antiguedad], "antiguedad", "antiquity"), ([.edadMedia], "edad-media", "middle-ages"),
        ([.renacimiento], "renacimiento", "renaissance"), ([.barroco], "barroco", "baroque"),
        ([.clasicismo], "clasicismo", "classicism"), ([.romanticismo], "romanticismo", "romanticism"),
        ([.sigloXX], "siglo-xx", "20th-century"), ([.sigloXXI], "siglo-xxi", "21st-century"),
        (Epoca.tonales, "tonal", "tonal"),
    ]

    /// Las épocas de `--epoca barroco`, por su clave, en español o en inglés, o por su nombre en español o en el
    /// idioma de la notación («Barroco», «Baroque»); lanza `epocaDesconocida` si no es ninguna.
    static func epocas(leyendo texto: String, _ notacion: Notacion) throws -> [Epoca] {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasEpocas.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.epocas
        }
        guard
            let porNombre = Epoca.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.epocaDesconocida(texto) }
        return [porNombre]
    }

    /// Cómo se escribe cada escuela en `--escuela`, en español y en inglés: `--escuela carnatica`, `--school carnatic`.
    static let nombresDeLasEscuelas: [(escuela: Escuela, espanol: String, ingles: String)] = [
        (.carnatica, "carnatica", "carnatic"), (.indostanica, "indostanica", "hindustani"),
        (.indiaAntigua, "india-antigua", "ancient-india"), (.gagaku, "gagaku", "gagaku"),
    ]

    /// Cómo se escribe cada carácter de afinación en `--afinacion`, en español y en inglés: `--afinacion justa`,
    /// `--tuning just`. `partes-iguales` vale para cualquier número de partes.
    static let nombresDeLasAfinaciones: [(clave: String, espanol: String, ingles: String)] = [
        ("temperada", "temperada", "tempered"), ("justa", "justa", "just"), ("microtonal", "microtonal", "microtonal"),
        ("partes-iguales", "partes-iguales", "equal-divisions"),
    ]

    /// La clave (`CaracterDeLaAfinacion.clave`) de `--afinacion justa`, en español o en inglés; lanza
    /// `afinacionDesconocida` si no es ninguna.
    static func claveDeAfinacion(leyendo texto: String) throws -> String {
        let clave = claveDeBusqueda(texto)
        guard
            let encontrada = nombresDeLasAfinaciones.first(where: {
                claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
            })
        else { throw ErrorDeUso.afinacionDesconocida(texto) }
        return encontrada.clave
    }

    /// La escuela de `--escuela carnatica`, por su clave, en español o en inglés, o por su nombre en español o en el
    /// idioma de la notación; lanza `escuelaDesconocida` si no es ninguna.
    static func escuela(leyendo texto: String, _ notacion: Notacion) throws -> Escuela {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasEscuelas.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.escuela
        }
        guard
            let porNombre = Escuela.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.escuelaDesconocida(texto) }
        return porNombre
    }

    /// Los lugares de `--lugar espana`: los del catálogo (`Lugar.todos`) cuya clave o cuyo nombre, en español, en
    /// inglés o en el idioma de la notación, o el código ISO de un país (`US`), es el texto. Pueden ser varios: «egipto» es la zona y el país, y
    /// «hungria», el país y la región. Lanza `lugarDesconocido` si no es ninguno.
    static func lugares(leyendo texto: String, _ notacion: Notacion) throws -> [Lugar] {
        let clave = claveDeBusqueda(texto)
        let encontrados = Lugar.todos.filter { lugar in
            var nombres = [lugar.clave, lugar.nombre, lugar.nombre(en: .compacta(.ingles)), lugar.nombre(en: notacion)]
            if case .pais(let pais) = lugar { nombres.append(pais.codigoISO) }
            return nombres.map(claveDeBusqueda).contains(clave)
        }
        guard !encontrados.isEmpty else { throw ErrorDeUso.lugarDesconocido(texto) }
        return encontrados
    }

    /// Un texto para comparar nombres: sin mayúsculas, tildes, guiones ni espacios («Mundo árabe» → «mundoarabe»).
    static func claveDeBusqueda(_ texto: String) -> String {
        texto.replacingOccurrences(of: "ı", with: "i")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .filter { $0.isLetter || $0.isNumber }
    }

    /// `tradiciones`: cada tradición del catálogo, con cómo se escribe en `--tradicion` y cuántas escalas tiene de cada
    /// categoría: «Japón (japon): escala 13». `tradiciones japon [--categoria …]` es `escalas --tradicion japon`.
    static func tradiciones(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let primera = argumentos.first, !Argumentos.pareceUnaOpcion(primera) {
            return try escalas(["--tradicion"] + argumentos, notacion)
        }
        try Argumentos(argumentos).sinOpcionesDesconocidas()
        let lineas = catalogoDeTradiciones().map { ficha in
            let clave = ejemplo(ficha.claves.espanol, ficha.claves.ingles).en(notacion)
            let categorias = ficha.categorias.map { "\($0.categoria.nombre(en: notacion)) \($0.escalas)" }
            return "\(ficha.tradicion.nombre(en: notacion)) (\(clave)): " + categorias.joined(separator: " · ")
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// Una tradición del catálogo: cómo se escribe en `--tradicion` y cuántas escalas tiene de cada categoría, en el
    /// orden del catálogo.
    struct TradicionDelCatalogo {
        let tradicion: Tradicion
        let claves: (espanol: String, ingles: String)
        let categorias: [(categoria: CategoriaTradicional, escalas: Int)]
    }

    /// Las tradiciones, en el orden de `Tradicion.allCases`, con sus categorías en el de `TipoDeEscala.tradicionales`;
    /// sin la occidental, que no tiene `--tradicion` (sus escalas son las habituales, por estilos con `--uso`).
    static func catalogoDeTradiciones() -> [TradicionDelCatalogo] {
        Tradicion.allCases.compactMap { tradicion in
            guard let claves = nombresDeLasTradiciones.first(where: { $0.tradicion == tradicion }) else { return nil }
            var categorias: [(categoria: CategoriaTradicional, escalas: Int)] = []
            for tipo in TipoDeEscala.tradicionales where tipo.tradicion == tradicion {
                guard let categoria = tipo.categoria else { continue }
                if let i = categorias.firstIndex(where: { $0.categoria == categoria }) {
                    categorias[i].escalas += 1
                } else {
                    categorias.append((categoria, 1))
                }
            }
            return TradicionDelCatalogo(
                tradicion: tradicion, claves: (claves.espanol, claves.ingles), categorias: categorias)
        }
    }

    /// Cómo ordena `escalas --orden`: de la más brillante a la más oscura (por `brilloPorQuintas`) o de menos a más
    /// notas.
    enum OrdenDeEscalas { case brillo, notas }

    /// Los valores de `escalas --orden`, en español y en inglés.
    static let ordenesDeEscalas: [String: OrdenDeEscalas] = [
        "brillo": .brillo, "brightness": .brillo, "notas": .notas, "notes": .notas,
    ]

    /// Unas filas de texto en columnas alineadas, separadas por dos espacios, sin espacios al final.
    static func columnas(_ filas: [[String]]) -> String {
        let anchos = filas.reduce(into: [Int]()) { anchos, fila in
            for (i, celda) in fila.enumerated() {
                if i < anchos.count { anchos[i] = max(anchos[i], celda.count) } else { anchos.append(celda.count) }
            }
        }
        return filas.map { fila in
            fila.enumerated().map { i, celda in celda + String(repeating: " ", count: anchos[i] - celda.count) }
                .joined(separator: "  ").replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        }.joined(separator: "\n")
    }

    /// Las clases interválicas de `escalas --con-intervalo` y `--sin-intervalo`, por su nombre en español y en inglés
    /// (también valen sus números, del 1 al 6).
    static let clasesIntervalicasPorNombre: [String: Int] = [
        "semitono": 1, "semitone": 1, "tono": 2, "tone": 2, "terceramenor": 3, "minorthird": 3, "terceramayor": 4,
        "majorthird": 4, "cuarta": 5, "fourth": 5, "tritono": 6, "tritone": 6,
    ]

    /// La clase interválica (1…6) de un número o un nombre, o el error de uso.
    static func claseIntervalica(_ texto: String) throws -> Int {
        if let n = Int(texto), (1...6).contains(n) { return n }
        guard let clase = clasesIntervalicasPorNombre[claveDeBusqueda(texto)] else {
            throw ErrorDeUso.intervaloDeEscalasDesconocido(texto)
        }
        return clase
    }

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>] [--fuente <fuente>] [--uso <uso>]
    /// [--lugar <lugar>] [--epoca <época>] [--escuela <escuela>] [--orden brillo] [--con-intervalo tritono]
    /// [--comparar Do mayor, Do lidio]`: el catálogo de escalas, las habituales y las de otras tradiciones agrupadas por tradición y categoría, cada una
    /// con sus notas desde Do (y la marca de los microtonos, si los tiene). Un texto suelto busca en los nombres.
    /// `--uso jazz` deja solo las habituales de ese uso (las de otras tradiciones no tienen), y `--notas 5`, las de
    /// cinco notas. `--comparar` deja el catálogo y pone las escalas que se le dan en una tabla, una por fila, y
    /// `--mapa` lo dibuja en un mapa de brillo (SVG).
    static func escalas(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let grupos: [GrupoDeEscalas]
        let orden: OrdenDeEscalas?
        switch try catalogoDeEscalas(argumentos, notacion) {
        case .otraCosa(let resultado, _), .ninguna(let resultado): return resultado
        case .grupos(let pedidos, let elegido): (grupos, orden) = (pedidos, elegido)
        }
        var lineas: [String] = []
        for grupo in grupos {
            if !lineas.isEmpty { lineas.append("") }
            lineas.append("\(grupo.titulo) (\(grupo.tipos.count))")
            for tipo in grupo.tipos {
                let notas = Escala(.do, tipo).notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
                let microtonos = tipo.microtonal == nil ? "" : " · " + traducir(.microtonos)
                // Ordenadas por brillo, con su brillo por quintas: «lidio: Do Re Mi Fa♯ Sol La Si · +3».
                let brillo =
                    orden == .brillo
                    ? " · " + PresentacionDeEstudioDeEscala.conSigno(Escala(.do, tipo).estadisticas.brilloPorQuintas)
                    : ""
                lineas.append("  \(tipo.nombre(en: notacion)): \(notas)\(microtonos)\(brillo)")
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// Un grupo del catálogo de `escalas`: «Japón · escala» y sus escalas, ya ordenadas.
    typealias GrupoDeEscalas = (titulo: String, tipos: [TipoDeEscala])

    /// Lo que pide `escalas`: los grupos del catálogo, o lo que da otra cosa (`--comparar`, `--mapa`, `--vecinas`…, que
    /// no tiene JSON), o el error de que no hay ninguna.
    enum CatalogoPedido {
        case grupos([GrupoDeEscalas], orden: OrdenDeEscalas?)
        case otraCosa(ResultadoDeOrden, opcion: String)
        case ninguna(ResultadoDeOrden)
    }

    /// Lee los argumentos de `escalas` y da sus grupos, para el texto y para `--json`. `--comparar`, `--vecinas` (y
    /// `--parecidas` y `--escalera`) y `--mapa` dan otra cosa; si no, los filtros eligen las escalas del catálogo.
    static func catalogoDeEscalas(_ argumentos: [String], _ notacion: Notacion) throws -> CatalogoPedido {
        var entrada = Argumentos(argumentos)
        if let texto = try entrada.valorConPalabras(.comparar) {
            return try compararEscalas(texto, &entrada, notacion)
        }
        if let pedido = try escalasQueSalen(&entrada, notacion) { return pedido }
        if entrada.quitarMarca(.mapa) { return try mapaDeBrillo(&entrada, notacion) }
        let filtro = try filtrosDelCatalogo(&entrada, notacion)
        let grupos = filtro.grupos(en: notacion)
        guard !grupos.isEmpty else { return .ninguna(ningunaEscala(entrada, notacion)) }
        return .grupos(grupos.map { ($0.titulo, filtro.ordenados($0.tipos)) }, orden: filtro.orden)
    }

    /// `--comparar Do mayor, Do dórico, Do lidio`: las escalas en una tabla, con lo que se mide de cada una.
    static func compararEscalas(
        _ texto: String, _ entrada: inout Argumentos, _ notacion: Notacion
    ) throws -> CatalogoPedido {
        try entrada.sinOpcionesDesconocidas()
        let nombres = texto.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        guard !nombres.isEmpty else { throw ErrorDeUso.faltaValor("--comparar") }
        let escalas = try nombres.map { try Escala(leyendo: $0, enLaOrden: notacion) }
        let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(escalas, en: notacion)
        return .otraCosa(bien(columnas([tabla.encabezados] + tabla.filas)), opcion: "--comparar")
    }

    /// `--vecinas Re dórico`, `--parecidas Re dórico`, `--escalera Re dórico`: las escalas que salen de una, como
    /// `escala Re dórico --vecinas`, pero sin la escala de partida. `nil` si no se pide ninguna de las tres.
    static func escalasQueSalen(_ entrada: inout Argumentos, _ notacion: Notacion) throws -> CatalogoPedido? {
        let deUna = try [
            (OpcionDeOrden.vecinasDe, entrada.valorConPalabras(.vecinasDe)),
            (OpcionDeOrden.parecidasA, entrada.valorConPalabras(.parecidasA)),
            (OpcionDeOrden.escaleraDe, entrada.valorConPalabras(.escaleraDe)),
        ].compactMap { opcion, texto in texto.map { (opcion, $0) } }
        guard !deUna.isEmpty else { return nil }
        try entrada.sinOpcionesDesconocidas()
        guard entrada.restantes.isEmpty else { throw ErrorDeUso.opcionDesconocida(entrada.restantes[0]) }
        let lineas = try deUna.flatMap { opcion, texto in
            try escalasQueSalen(de: Escala(leyendo: texto, enLaOrden: notacion), opcion, notacion)
        }
        return .otraCosa(bien(lineas.joined(separator: "\n")), opcion: deUna[0].0.nombres[0])
    }

    /// `--mapa [Re dórico] [--notas 7]`: el mapa de brillo en SVG, resaltando la escala que se dé.
    static func mapaDeBrillo(_ entrada: inout Argumentos, _ notacion: Notacion) throws -> CatalogoPedido {
        let numeroDeNotas = try numeroDeNotasPedido(&entrada) ?? 7
        try entrada.sinOpcionesDesconocidas()
        let resaltada = entrada.restantes.isEmpty ? nil : try Escala(leyendo: entrada.unidos, enLaOrden: notacion)
        let mapa = PresentacionDeEstudioDeEscala.mapaDeBrillo(
            numeroDeNotas: numeroDeNotas, resaltada: resaltada, en: notacion)
        return .otraCosa(bien(mapa), opcion: "--mapa")
    }

    /// `--notas 5`: de 1 a 24; `nil` si no se pide.
    static func numeroDeNotasPedido(_ entrada: inout Argumentos) throws -> Int? {
        guard let texto = try entrada.valor(.notas, siFalta: .notasFueraDeRango) else { return nil }
        guard let n = Int(texto), (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
        return n
    }

    /// Cómo agrupa `--agrupar` las escalas: por el continente o por el país de donde vienen, o por su época de
    /// origen.
    enum AgrupacionDeEscalas {
        case continente, pais, epoca
    }

    /// Lo que deja `escalas` del catálogo: la tradición, la categoría, la fuente, el uso, el número de notas, lo que
    /// se mide de cada una y el texto que se busca en los nombres, y el orden en que salen.
    struct FiltroDeEscalas {
        var tradicion: Tradicion?
        var categoria: CategoriaTradicional?
        var fuente: FuenteTeorica?
        /// Los de `--uso`: uno, o los tres populares con `--uso popular`.
        var usos: [Estilo] = []
        /// La de `--uso bebop`: solo las escalas de esa corriente (y `usos`, su estilo).
        var corriente: Corriente?
        /// Los de `--lugar`: la escala pasa si uno de sus lugares de origen o de uso es uno de ellos o está en él.
        var lugares: [Lugar] = []
        /// Las de `--epoca`: la escala pasa si una de sus épocas, de origen o de uso, es una de ellas.
        var epocas: [Epoca] = []
        /// La de `--escuela`: solo las de esa escuela.
        var escuela: Escuela?
        var agrupacion: AgrupacionDeEscalas?
        var numeroDeNotas: Int?
        var orden: OrdenDeEscalas?
        var sinSemitonos = false
        var conIntervalo: Int?
        var sinIntervalo: Int?
        var conPaso: Int?
        var regulares = false
        /// La clave de `--afinacion`: solo las de una afinación de ese carácter.
        var afinacion: String?
        /// `true` con `--fragmentos` (solo ellos), `false` con `--sin-fragmentos`; `nil`, todas.
        var fragmentos: Bool?
        /// El texto suelto, como clave de búsqueda; vacío si no hay.
        var buscado = ""

        private func estadisticas(_ tipo: TipoDeEscala) -> EstadisticasDeEscala { Escala(.do, tipo).estadisticas }

        /// Si una escala pasa los filtros que no son de tradición, categoría, fuente ni uso.
        func cumple(_ tipo: TipoDeEscala, en notacion: Notacion) -> Bool {
            guard numeroDeNotas == nil || tipo.numeroDeNotas == numeroDeNotas else { return false }
            guard !sinSemitonos || estadisticas(tipo).anhemitonica else { return false }
            guard !regulares || estadisticas(tipo).maximamenteRegular else { return false }
            guard fragmentos == nil || tipo.esFragmento == fragmentos else { return false }
            guard afinacion == nil || tipo.caracterDeLaAfinacion?.clave == afinacion else { return false }
            if !lugares.isEmpty {
                let suyos = Set((tipo.lugaresDeOrigen + tipo.lugaresDeUso).flatMap(\.conLosQueLoContienen))
                guard lugares.contains(where: suyos.contains) else { return false }
            }
            if !epocas.isEmpty, !tipo.epocas.contains(where: epocas.contains) { return false }
            if let escuela, !tipo.escuelas.contains(escuela) { return false }
            if conIntervalo != nil || sinIntervalo != nil || conPaso != nil {
                let medidas = estadisticas(tipo)
                if let conIntervalo, medidas.vectorIntervalico[conIntervalo - 1] == 0 { return false }
                if let sinIntervalo, medidas.vectorIntervalico[sinIntervalo - 1] > 0 { return false }
                if let conPaso, !medidas.pasos.contains(conPaso) { return false }
            }
            return buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
                || claveDeBusqueda(tipo.nombre).contains(buscado)
        }

        /// Los grupos, en el orden del catálogo: las habituales (si no se filtra por tradición, categoría ni fuente)
        /// y, después, cada tradición con su categoría.
        func grupos(en notacion: Notacion) -> [GrupoDeEscalas] {
            let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
            var grupos: [GrupoDeEscalas] = []
            if tradicion == nil && categoria == nil && fuente == nil {
                if !usos.isEmpty {
                    let delUso = TipoDeEscala.occidentales.filter { tipo in
                        tipo.estilos.contains(where: usos.contains)
                            && (corriente.map(tipo.corrientes.contains) ?? true) && cumple(tipo, en: notacion)
                    }
                    let nombre =
                        corriente?.nombre(en: notacion)
                        ?? (usos.count == 1 ? usos[0].nombre(en: notacion) : Estilo.nombreDeLosPopulares(en: notacion))
                    if !delUso.isEmpty { grupos.append((traducir(.habituales) + " · " + nombre, delUso)) }
                } else {
                    let habituales = TipoDeEscala.occidentales.filter { cumple($0, en: notacion) }
                    if !habituales.isEmpty { grupos.append((traducir(.habituales), habituales)) }
                }
            }
            for tipo in TipoDeEscala.tradicionales where usos.isEmpty && cumple(tipo, en: notacion) {
                guard let suya = tipo.tradicion, let deTipo = tipo.categoria else { continue }
                guard tradicion == nil || tradicion == suya, categoria == nil || categoria == deTipo,
                    fuente == nil || fuente == tipo.fuente || tipo.afinaciones.contains(where: { $0.fuente == fuente })
                else { continue }
                let titulo = suya.nombre(en: notacion) + " · " + deTipo.nombre(en: notacion)
                if let i = grupos.firstIndex(where: { $0.titulo == titulo }) {
                    grupos[i].tipos.append(tipo)
                } else {
                    grupos.append((titulo, [tipo]))
                }
            }
            guard let agrupacion else { return grupos }
            return agrupados(grupos.flatMap(\.tipos), por: agrupacion, en: notacion)
        }

        /// Con `--agrupar continente`, un grupo por continente de origen, en el orden de `Continente.allCases`; con
        /// `--agrupar pais`, uno por país, y después uno por continente con las que no tienen país (la mayor, en
        /// Europa). Una escala de varios sale en todos los suyos; las que no tienen lugar (las propias), al final. Con
        /// `--agrupar epoca`, uno por época de origen, en orden, y al final las que no tienen.
        func agrupados(
            _ tipos: [TipoDeEscala], por agrupacion: AgrupacionDeEscalas, en notacion: Notacion
        ) -> [GrupoDeEscalas] {
            var grupos: [GrupoDeEscalas] = []
            if agrupacion == .epoca {
                // Por su época de origen, en orden, con sus años: «Barroco · 1600–1750».
                for epoca in Epoca.allCases {
                    let deLaEpoca = tipos.filter { $0.epocaDeOrigen == epoca }
                    let titulo = epoca.nombre(en: notacion) + " · " + epoca.textoDeLosAnios
                    if !deLaEpoca.isEmpty { grupos.append((titulo, deLaEpoca)) }
                }
                let sinEpoca = tipos.filter { $0.epocaDeOrigen == nil }
                if !sinEpoca.isEmpty { grupos.append((Mensaje.sinEpoca.texto(en: notacion), sinEpoca)) }
                return grupos
            }
            if agrupacion == .pais {
                for pais in Pais.allCases {
                    let delPais = tipos.filter { $0.paisesDeOrigen.contains(pais) }
                    if !delPais.isEmpty { grupos.append((pais.nombre(en: notacion), delPais)) }
                }
            }
            for continente in Continente.allCases {
                let delContinente = tipos.filter {
                    $0.continentesDeOrigen.contains(continente)
                        && (agrupacion == .continente || $0.paisesDeOrigen.isEmpty)
                }
                if !delContinente.isEmpty { grupos.append((continente.nombre(en: notacion), delContinente)) }
            }
            let sinLugar = tipos.filter { $0.continentesDeOrigen.isEmpty }
            if !sinLugar.isEmpty { grupos.append((Mensaje.sinLugar.texto(en: notacion), sinLugar)) }
            return grupos
        }

        /// Con `--orden`, de la más brillante a la más oscura, o de menos a más notas; a igualdad, en el orden del
        /// catálogo.
        func ordenados(_ tipos: [TipoDeEscala]) -> [TipoDeEscala] {
            guard let orden else { return tipos }
            // La clave de cada una, de menor a mayor: el brillo, cambiado de signo, o el número de notas.
            let claves = tipos.map { orden == .brillo ? -estadisticas($0).brilloPorQuintas : Double($0.numeroDeNotas) }
            return tipos.indices.sorted { (claves[$0], $0) < (claves[$1], $1) }.map { tipos[$0] }
        }
    }

    /// Lee los filtros de `escalas`, en el orden en que se comprueban, y el texto suelto que queda.
    static func filtrosDelCatalogo(_ entrada: inout Argumentos, _ notacion: Notacion) throws -> FiltroDeEscalas {
        var filtro = FiltroDeEscalas()
        if let texto = try entrada.valor(.tradicion) {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.tradicionDesconocida(texto) }
            filtro.tradicion = encontrada.tradicion
        }
        if let texto = try entrada.valor(.categoria) {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.categoriaDesconocida(texto)
            }
            filtro.categoria = encontrada
        }
        // `--fuente ptolomeo`, `--source ptolemy`: las escalas que definió o afinó un teórico, por su clave o por su
        // nombre en español, en inglés o en el idioma de la notación.
        if let texto = try entrada.valor(.fuente) { filtro.fuente = try fuenteTeorica(leyendo: texto, notacion) }
        // `--uso jazz`, o una corriente de un estilo: `--uso bebop`, `--use neoclassical-metal`.
        if let texto = try entrada.valor(.uso) {
            if let corriente = corriente(leyendo: texto, notacion) {
                filtro.corriente = corriente
                filtro.usos = [corriente.estilo]
            } else {
                filtro.usos = try estilosDeUso(leyendo: texto, notacion)
            }
        }
        // `--lugar espana`, `--place spain`: las de un lugar, de origen o de uso; `--agrupar continente`, por el suyo.
        if let texto = try entrada.valor(.lugar) { filtro.lugares = try lugares(leyendo: texto, notacion) }
        // `--epoca barroco`, `--era baroque`: las de una época, de origen o de uso; `--escuela carnatica`, las de una
        // escuela.
        if let texto = try entrada.valor(.epoca) { filtro.epocas = try epocas(leyendo: texto, notacion) }
        if let texto = try entrada.valor(.escuela) { filtro.escuela = try escuela(leyendo: texto, notacion) }
        // `--afinacion microtonal`, `--tuning just`: por el carácter de su afinación.
        if let texto = try entrada.valor(.afinacion) { filtro.afinacion = try claveDeAfinacion(leyendo: texto) }
        if let texto = try entrada.valor(.agrupar) {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasAgrupaciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.agrupacionDesconocida(texto) }
            filtro.agrupacion = encontrada.agrupacion
        }
        // `--notas 5`: solo las de cinco notas (las pentatónicas).
        filtro.numeroDeNotas = try numeroDeNotasPedido(&entrada)
        // `--orden brillo`, `--sin-semitonos`, `--regulares`: por lo que se mide de cada escala.
        if let texto = try entrada.valor(.orden) {
            guard let elegido = ordenesDeEscalas[claveDeBusqueda(texto)] else {
                throw ErrorDeUso.ordenDeEscalasDesconocido(texto)
            }
            filtro.orden = elegido
        }
        filtro.sinSemitonos = entrada.quitarMarca(.sinSemitonos)
        // `--con-intervalo tritono`, `--sin-intervalo 1`, `--con-paso 3`: por el vector interválico y los pasos.
        if let texto = try entrada.valor(.conIntervalo) { filtro.conIntervalo = try claseIntervalica(texto) }
        if let texto = try entrada.valor(.sinIntervalo) { filtro.sinIntervalo = try claseIntervalica(texto) }
        if let texto = try entrada.valor(.conPaso, siFalta: .pasoFueraDeRango) {
            guard let n = Int(texto), (1...11).contains(n) else { throw ErrorDeUso.pasoFueraDeRango }
            filtro.conPaso = n
        }
        filtro.regulares = entrada.quitarMarca(.regulares)
        // `--fragmentos`: los tetracordos, los ajnas, los hexacordos…; `--sin-fragmentos`, todas menos ellos.
        let soloFragmentos = entrada.quitarMarca(.fragmentos)
        let sinFragmentos = entrada.quitarMarca(.sinFragmentos)
        if soloFragmentos != sinFragmentos { filtro.fragmentos = soloFragmentos }
        try entrada.sinOpcionesDesconocidas()
        filtro.buscado = claveDeBusqueda(entrada.unidos)
        return filtro
    }

    /// El error de que no hay ninguna escala. `escalas` busca por el nombre: si lo que se le dio son notas, lo que se
    /// quería era `identificar --escalas`, y lo dice.
    static func ningunaEscala(_ entrada: Argumentos, _ notacion: Notacion) -> ResultadoDeOrden {
        let palabras = entrada.restantes
        let sonNotas =
            !palabras.isEmpty && palabras.allSatisfy { (try? Nota(leyendo: $0, enLaOrden: notacion)) != nil }
        let texto =
            sonNotas
            ? TextosDeConsola.en(notacion) {
                $0.escalasPorNotas(
                    ejemplo(
                        "armonia identificar --escalas " + entrada.unidos,
                        "armonia identify --scales " + entrada.unidos
                    ).en(notacion))
            } : Mensaje.ningunaEscala.texto(en: notacion)
        return ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1)
    }
}

extension LineaDeComandos {
    /// El teórico de `--fuente ptolomeo` (`--source ptolemy`): por su clave o por su nombre en español, en inglés o
    /// en el idioma de la notación.
    static func fuenteTeorica(leyendo texto: String, _ notacion: Notacion) throws -> FuenteTeorica {
        let clave = claveDeBusqueda(texto)
        let nombres = { (candidata: FuenteTeorica) in
            [
                candidata.rawValue, candidata.nombre, candidata.nombre(en: .compacta(.ingles)),
                candidata.nombre(en: notacion),
            ].map(claveDeBusqueda)
        }
        guard let encontrada = FuenteTeorica.allCases.first(where: { nombres($0).contains(clave) }) else {
            throw ErrorDeUso.fuenteDesconocida(texto)
        }
        return encontrada
    }
}
