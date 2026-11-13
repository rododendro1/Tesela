import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: el catálogo de escalas
//
// `escalas` y `tradiciones`: el catálogo, sus búsquedas, la comparación y el mapa de brillo. Los valores de las
// opciones están en LineaDeComandos+CatalogoDeEscalas+Valores.swift y el filtro en +Filtro.swift.

extension LineaDeComandos {
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
    /// sin la occidental, que no tiene `--tradicion` (sus escalas son las habituales, por estilos con `--estilo`).
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

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>] [--fuente <fuente>] [--estilo <estilo>]
    /// [--lugar <lugar>] [--epoca <época>] [--escuela <escuela>] [--orden brillo] [--con-intervalo tritono] [--comparar
    /// Do mayor, Do lidio]`: el catálogo de escalas, las habituales y las de otras tradiciones agrupadas por tradición
    /// y categoría, cada una con sus notas desde Do (y la marca de los microtonos, si los tiene). Un texto suelto busca
    /// en los nombres. `--estilo jazz` deja solo las habituales de ese uso (las de otras tradiciones no tienen), y
    /// `--notas 5`, las de cinco notas. `--comparar` deja el catálogo y pone las escalas que se le dan en una tabla,
    /// una por fila, y `--mapa` lo dibuja en un mapa de brillo (SVG).
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
                let microtonos = tipo.esMicrotonal ? " · " + traducir(.microtonos) : ""
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
