import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: escalas y su catálogo

extension LineaDeComandos {
    /// Lo que pide `escala`: la escala y sus opciones, lo mismo para el texto y para `--json`.
    struct PedidoDeEscala {
        let escala: Escala
        /// `--acordes`: todos los acordes que caben en cada grado (y, con `--doce`, los de cada grado en las doce).
        let conAcordes: Bool
        /// `--secuencia`, a lo largo de `--octavas` octavas, bajando con `--bajando`.
        let secuencia: SecuenciaDeEscala?
        let octavas: Int
        let bajando: Bool
        let piano: Bool
        let modos: Bool
        let simetria: Bool
        let vecinas: Bool
        /// `--estadisticas`.
        let estadisticas: Bool
        /// `--escalera`.
        let escalera: Bool
        let doce: Bool
        /// `--triadas`: con `--doce` y `--acordes`, tríadas en lugar de cuatríadas.
        let triadas: Bool
        /// `--comparar`.
        let otra: Escala?
        /// `--parecidas`: las escalas con más notas en común.
        let parecidas: Bool
        /// `--progresiones`: progresiones con sus tríadas.
        let progresiones: Bool

        var sentido: SentidoDelIntervalo { bajando ? .descendente : .ascendente }
    }

    /// Lee la escala y las opciones de `escala`, o lanza el `ErrorDeUso` de lo que está mal escrito.
    static func pedidoDeEscala(_ textos: [String]) throws -> PedidoDeEscala {
        // `--dedos piano` es `--dedos`, la digitación de piano.
        var textos = textos
        if let i = textos.firstIndex(where: OpcionDeOrden.piano.leidos.contains), textos.indices.contains(i + 1),
            instrumentosDeLosDedos.piano.contains(textos[i + 1].lowercased())
        {
            textos.remove(at: i + 1)
        }
        var argumentos = Argumentos(textos)
        let conAcordes = argumentos.quitarMarca(.acordes)
        let bajando = argumentos.quitarMarca(.bajando)
        let piano = argumentos.quitarMarca(.piano)
        let modos = argumentos.quitarMarca(.modos)
        let simetria = argumentos.quitarMarca(.simetria)
        let vecinas = argumentos.quitarMarca(.vecinas)
        let parecidas = argumentos.quitarMarca(.parecidas)
        let progresiones = argumentos.quitarMarca(.progresiones)
        let estadisticas = argumentos.quitarMarca(.estadisticas)
        let escalera = argumentos.quitarMarca(.escalera)
        let doce = argumentos.quitarMarca(.doce)
        let triadas = argumentos.quitarMarca(.triadas)
        guard let octavas = argumentos.quitarNumero(.octavas, en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        var secuencia: SecuenciaDeEscala?
        if let texto = try argumentos.valor(.secuencia) {
            guard let elegida = secuenciaDeEscala(texto) else { throw ErrorDeUso.secuenciaDesconocida(texto) }
            secuencia = elegida
        }
        var otra: Escala?
        if let texto = try argumentos.valorConPalabras(.comparar) { otra = try Escala(leyendoEnLaOrden: texto) }
        if let desconocida = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(desconocida) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscala }
        return PedidoDeEscala(
            escala: try Escala(leyendoEnLaOrden: argumentos.unidos), conAcordes: conAcordes, secuencia: secuencia,
            octavas: octavas, bajando: bajando, piano: piano, modos: modos, simetria: simetria, vecinas: vecinas,
            estadisticas: estadisticas, escalera: escalera, doce: doce, triadas: triadas, otra: otra,
            parecidas: parecidas, progresiones: progresiones)
    }

    /// `escala Do mayor [--acordes] [--secuencia terceras] [--bajando] [--octavas 2] [--dedos] [--modos]
    /// [--estadisticas] [--escalera] [--comparar Do lidio]`: la escala y, si se piden, todos los acordes que caben en
    /// cada grado, una secuencia de estudio, la digitación de piano, los modos paralelos y relativos, lo que se mide de
    /// ella, su escalera de brillo y la comparación con otra escala.
    static func escala(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let pedido = try pedidoDeEscala(textos)
        let escala = pedido.escala
        var lineas = [describir(escala: escala, conTodosSusAcordes: pedido.conAcordes, notacion)]
        if let secuencia = pedido.secuencia {
            let presentada = PresentacionDeEstudioDeEscala.secuencia(
                escala, secuencia, octavas: pedido.octavas, sentido: pedido.sentido, en: notacion)
            lineas.append(notacion.texto(\.secuencia) + " " + secuencia.nombre(en: notacion) + ":")
            lineas.append("  " + presentada.notas)
        }
        if pedido.piano {
            lineas.append(notacion.texto(\.digitacionDePiano) + ":")
            let digitaciones = PresentacionDeEstudioDeEscala.digitaciones(
                escala, octavas: pedido.octavas, en: notacion)
            for mano in digitaciones {
                let pares = zip(mano.notas.split(separator: " "), mano.dedos.split(separator: " "))
                lineas.append("  " + mano.mano + ": " + pares.map { "\($0) \($1)" }.joined(separator: " · "))
            }
        }
        if pedido.modos {
            lineas.append(notacion.texto(\.modosParalelos) + ":")
            lineas += PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion).map { modo in
                "  " + modo.nombre + " (" + modo.brillo + ")" + (modo.cambios.isEmpty ? "" : ": " + modo.cambios)
            }
            let relativos = PresentacionDeEstudioDeEscala.modosRelativos(de: escala, en: notacion)
            lineas.append(notacion.texto(\.modosRelativos) + ":")
            lineas.append("  " + relativos.map(\.nombre).joined(separator: " · "))
        }
        if pedido.simetria { lineas += lineasDeSimetria(de: escala, notacion) }
        if pedido.vecinas { lineas += escalasQueSalen(de: escala, .vecinas, notacion) }
        if pedido.parecidas { lineas += escalasQueSalen(de: escala, .parecidas, notacion) }
        if pedido.progresiones {
            lineas.append(notacion.texto(\.progresionesEnLaEscala) + ":")
            for progresion in PresentacionDeEstudioDeEscala.progresiones(de: escala, en: notacion) {
                let fuera = progresion.fuera.isEmpty ? "" : " · " + progresion.fuera
                lineas.append("  " + progresion.grados + ": " + progresion.cifrados + fuera)
            }
        }
        if pedido.estadisticas {
            lineas.append(notacion.texto(\.estadisticas) + ":")
            lineas += PresentacionDeEstudioDeEscala.estadisticas(de: escala, en: notacion).map {
                "  " + $0.nombre + ": " + $0.valor
            }
        }
        if pedido.escalera { lineas += escalasQueSalen(de: escala, .escalera, notacion) }
        if pedido.doce {
            let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
                escala, secuencia: pedido.secuencia, en: notacion)
            lineas.append(hoja.titulo + ":")
            lineas += hoja.tonalidades.map { "  " + $0.titulo + ": " + $0.notas }
            // Con --acordes, también los acordes de cada grado en las doce, si la escala los forma.
            if pedido.conAcordes,
                let tabla = PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                    escala, cuatriadas: !pedido.triadas, en: notacion)
            {
                lineas.append(tabla.titulo + ":")
                lineas.append("  " + tabla.grados.joined(separator: " · "))
                lineas += tabla.filas.map { "  " + $0.tonalidad + ": " + $0.acordes.joined(separator: " · ") }
            }
        }
        if let otra = pedido.otra {
            let comparacion = PresentacionDeEstudioDeEscala.comparar(escala, con: otra, en: notacion)
            lineas.append(notacion.texto(\.compararCon) + " " + otra.nombre(en: notacion) + ":")
            lineas.append("  " + notacion.texto(\.notasComunes) + ": " + comparacion.comunes)
            let resto = [comparacion.soloEnOrigen, comparacion.soloEnDestino] + comparacion.cambios
            lineas += (resto + [comparacion.distancia ?? ""]).filter { !$0.isEmpty }.map { "  " + $0 }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// Las líneas de `--vecinas`, `--parecidas` o `--escalera` (`opcion`) de una escala, con su título: las mismas en
    /// `escala Re dórico --vecinas` y en `escalas --vecinas Re dórico`.
    static func escalasQueSalen(de escala: Escala, _ opcion: OpcionDeOrden, _ notacion: Notacion) -> [String] {
        switch opcion {
        case .vecinasDe, .vecinas:
            return [notacion.texto(\.escalasVecinas) + ":"]
                + PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion).map {
                    "  " + $0.nombre + ": " + $0.detalle
                }
        case .parecidasA, .parecidas:
            return [notacion.texto(\.escalasParecidas) + ":"]
                + PresentacionDeEstudioDeEscala.parecidas(a: escala, en: notacion).map {
                    "  " + $0.nombre + ": " + $0.detalle
                }
        default:
            // `--escalera`: de la más oscura a la más brillante, «  +3  Do lidio · Fa → Fa♯», con «←» en la de partida.
            return [notacion.texto(\.escaleraDeBrillo) + ":"]
                + PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: escala, en: notacion).map { peldano in
                    let cambio = peldano.cambio.isEmpty ? "" : " · " + peldano.cambio
                    return "  " + peldano.brillo + "  " + peldano.nombre + cambio + (peldano.esLaDePartida ? " ←" : "")
                }
        }
    }

    /// `escala … --simetria`: cada cuánto se repite, desde qué notas empieza igual y los acordes que se repiten. Una
    /// escala que no es simétrica se repite a la octava, con sus doce transposiciones.
    static func lineasDeSimetria(de escala: Escala, _ notacion: Notacion) -> [String] {
        var lineas = [notacion.texto(\.simetria) + ":"]
        guard let simetria = PresentacionDeEstudioDeEscala.simetria(de: escala, en: notacion) else {
            let veces = escala.transposicionesDistintas
            return lineas + ["  " + notacion.texto { $0.repiteCada(veces, veces) }]
        }
        lineas.append("  " + simetria.resumen)
        lineas.append("  " + notacion.texto(\.tonicasEquivalentes) + ": " + simetria.tonicas)
        lineas += simetria.ciclos.map { "  " + $0.nombre + ": " + $0.detalle }
        return lineas
    }

    /// La secuencia de `--secuencia`, por su nombre en español o en inglés.
    static func secuenciaDeEscala(_ texto: String) -> SecuenciaDeEscala? {
        let nombres: [String: SecuenciaDeEscala] = [
            "terceras": .terceras, "thirds": .terceras, "cuartas": .cuartas, "fourths": .cuartas,
            "grupos-de-3": .gruposDeTres, "groups-of-3": .gruposDeTres, "grupos-de-4": .gruposDeCuatro,
            "groups-of-4": .gruposDeCuatro, "triadas": .triadas, "tríadas": .triadas, "triads": .triadas,
            "cuatriadas": .cuatriadas, "sevenths": .cuatriadas,
        ]
        return nombres[texto.lowercased()]
    }

    /// La escala con los datos de `--json` (`DatosDeEscala`) y, además, sus microtonos y, si se piden, todos los
    /// acordes que caben en ella.
    static func describir(escala: Escala, conTodosSusAcordes: Bool = false, _ notacion: Notacion) -> String {
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let datos = DatosDeEscala(escala, notacion: notacion)
        var lineas = [datos.nombre, "  \(traducir(.notas)): " + datos.notas.joined(separator: " ")]
        // Con un sistema móvil (--sistema sargam), los grados con sus nombres, desde la tónica: Sā Re ga ma Pa Dha ni.
        if let movil = SistemaMovil.actual {
            let nombres = escala.nombres(en: movil.sistema, grafia: movil.grafia)
            lineas.append("  \(movil.sistema.nombres[0]): " + nombres.joined(separator: " "))
        }
        // De qué escala es modo: Re dórico → modo 2 de Do mayor.
        if let modo = datos.modo { lineas.append("  " + modo) }
        // La versión microtonal (Re Bayātī: Re Mi𝄳 Fa…) y los cents de cada grado, si la escala la tiene.
        if let subida = escala.notasMicrotonales() {
            let bajada = escala.notasMicrotonales(sentido: .descendente) ?? subida
            func nombres(_ notas: [NotaMicrotonal]) -> String {
                notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
            }
            func cents(_ notas: [NotaMicrotonal]) -> String {
                notas.map { "\(Int($0.cents.rounded()))" }.joined(separator: " ")
            }
            lineas.append("  \(traducir(.microtonos)): " + nombres(subida))
            lineas.append("  ¢: " + cents(subida))
            if bajada != subida {
                lineas.append("  \(traducir(.microtonos)) ↓: " + nombres(bajada))
                lineas.append("  ¢ ↓: " + cents(bajada))
            }
        }
        // Los acordes de cada grado, si la escala es heptatónica y todos forman un acorde conocido.
        if let acordes = datos.acordes {
            let pares = acordes.map { "\($0.grado) \($0.cifrado)" }
            lineas.append("  \(traducir(.acordes)): " + pares.joined(separator: " · "))
        }
        let grados = conTodosSusAcordes ? PresentacionDeEscalaYAcorde.acordesQueCaben(escala, en: notacion) : []
        if !grados.isEmpty {
            lineas.append("  " + notacion.texto(\.acordesQueCaben) + ":")
            lineas += grados.map { "    \($0.grado): \($0.cifrados)" }
        }
        return lineas.joined(separator: "\n")
    }

    // MARK: Catálogo de escalas

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

    /// Cómo se escribe cada uso en `--uso`, en español y en inglés (se aceptan los dos en cualquier idioma):
    /// `--uso siglo-xx`, `--use 20th-century`.
    static let nombresDeLosUsos: [(uso: UsoDeEscala, espanol: String, ingles: String)] = [
        (.clasica, "clasica", "classical"), (.jazz, "jazz", "jazz"), (.blues, "blues", "blues"),
        (.sigloXX, "siglo-xx", "20th-century"), (.popular, "popular", "folk"), (.sintetica, "sintetica", "synthetic"),
    ]

    /// Un texto para comparar nombres: sin mayúsculas, tildes, guiones ni espacios («Mundo árabe» → «mundoarabe»).
    private static func claveDeBusqueda(_ texto: String) -> String {
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
        if let opcion = Argumentos(argumentos).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
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

    /// Las tradiciones, en el orden de `Tradicion.allCases`, con sus categorías en el de `TipoDeEscala.tradicionales`.
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

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>] [--fuente <fuente>] [--uso <uso>] [--notas <n>]
    /// [--orden brillo] [--con-intervalo tritono] [--comparar Do mayor, Do lidio]`: el
    /// catálogo de escalas, las habituales y las de otras tradiciones agrupadas por tradición y categoría, cada una
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

    /// Lee los argumentos de `escalas` y da sus grupos, para el texto y para `--json`.
    static func catalogoDeEscalas(_ argumentos: [String], _ notacion: Notacion) throws -> CatalogoPedido {
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var entrada = Argumentos(argumentos)
        // `--comparar Do mayor, Do dórico, Do lidio`: las escalas en una tabla, con lo que se mide de cada una.
        if let texto = try entrada.valorConPalabras(.comparar) {
            if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
            let nombres = texto.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            guard !nombres.isEmpty else { throw ErrorDeUso.faltaValor("--comparar") }
            let escalas = try nombres.map { try Escala(leyendoEnLaOrden: $0) }
            let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(escalas, en: notacion)
            return .otraCosa(bien(columnas([tabla.encabezados] + tabla.filas)), opcion: "--comparar")
        }
        // `--vecinas Re dórico`, `--parecidas Re dórico`, `--escalera Re dórico`: las escalas que salen de una, como
        // `escala Re dórico --vecinas`, pero sin la escala de partida.
        let deUna = try [
            (OpcionDeOrden.vecinasDe, entrada.valorConPalabras(.vecinasDe)),
            (OpcionDeOrden.parecidasA, entrada.valorConPalabras(.parecidasA)),
            (OpcionDeOrden.escaleraDe, entrada.valorConPalabras(.escaleraDe)),
        ].compactMap { opcion, texto in texto.map { (opcion, $0) } }
        if !deUna.isEmpty {
            if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
            guard entrada.restantes.isEmpty else { throw ErrorDeUso.opcionDesconocida(entrada.restantes[0]) }
            let lineas = try deUna.flatMap { opcion, texto in
                try escalasQueSalen(de: Escala(leyendoEnLaOrden: texto), opcion, notacion)
            }
            return .otraCosa(bien(lineas.joined(separator: "\n")), opcion: deUna[0].0.nombres[0])
        }
        // `--mapa [Re dórico] [--notas 7]`: el mapa de brillo en SVG, resaltando la escala que se dé.
        if entrada.quitarMarca(.mapa) {
            var numeroDeNotas = 7
            if let texto = try entrada.valor(.notas, siFalta: .notasFueraDeRango) {
                guard let n = Int(texto), (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
                numeroDeNotas = n
            }
            if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
            let resaltada = entrada.restantes.isEmpty ? nil : try Escala(leyendoEnLaOrden: entrada.unidos)
            let mapa = PresentacionDeEstudioDeEscala.mapaDeBrillo(
                numeroDeNotas: numeroDeNotas, resaltada: resaltada, en: notacion)
            return .otraCosa(bien(mapa), opcion: "--mapa")
        }
        var tradicion: Tradicion?
        if let texto = try entrada.valor(.tradicion) {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.tradicionDesconocida(texto) }
            tradicion = encontrada.tradicion
        }
        var categoria: CategoriaTradicional?
        if let texto = try entrada.valor(.categoria) {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.categoriaDesconocida(texto)
            }
            categoria = encontrada
        }
        // `--fuente ptolomeo`, `--source ptolemy`: las escalas de un teórico, por su clave o por su nombre en español,
        // en inglés o en el idioma de la notación.
        var fuente: FuenteTeorica?
        if let texto = try entrada.valor(.fuente) {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: FuenteTeorica) in
                [
                    candidata.rawValue, candidata.nombre, candidata.nombre(en: .inglesCompacto),
                    candidata.nombre(en: notacion),
                ].map(claveDeBusqueda)
            }
            guard let encontrada = FuenteTeorica.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.fuenteDesconocida(texto)
            }
            fuente = encontrada
        }
        var usoPedido: UsoDeEscala?
        if let texto = try entrada.valor(.uso) {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidato: UsoDeEscala) -> [String] in
                let claves = nombresDeLosUsos.first { $0.uso == candidato }.map { [$0.espanol, $0.ingles] } ?? []
                return (claves + [candidato.nombre, candidato.nombre(en: notacion)]).map(claveDeBusqueda)
            }
            guard let encontrado = UsoDeEscala.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.usoDesconocido(texto)
            }
            usoPedido = encontrado
        }
        // `--notas 5`: solo las de cinco notas (las pentatónicas).
        var numeroDeNotas: Int?
        if let texto = try entrada.valor(.notas, siFalta: .notasFueraDeRango) {
            guard let n = Int(texto), (1...24).contains(n) else { throw ErrorDeUso.notasFueraDeRango }
            numeroDeNotas = n
        }
        // `--orden brillo`, `--sin-semitonos`, `--regulares`: por lo que se mide de cada escala.
        var orden: OrdenDeEscalas?
        if let texto = try entrada.valor(.orden) {
            guard let elegido = ordenesDeEscalas[claveDeBusqueda(texto)] else {
                throw ErrorDeUso.ordenDeEscalasDesconocido(texto)
            }
            orden = elegido
        }
        let sinSemitonos = entrada.quitarMarca(.sinSemitonos)
        // `--con-intervalo tritono`, `--sin-intervalo 1`, `--con-paso 3`: por el vector interválico y los pasos.
        var conIntervalo: Int?
        if let texto = try entrada.valor(.conIntervalo) {
            conIntervalo = try claseIntervalica(texto)
        }
        var sinIntervalo: Int?
        if let texto = try entrada.valor(.sinIntervalo) {
            sinIntervalo = try claseIntervalica(texto)
        }
        var conPaso: Int?
        if let texto = try entrada.valor(.conPaso, siFalta: .pasoFueraDeRango) {
            guard let n = Int(texto), (1...11).contains(n) else { throw ErrorDeUso.pasoFueraDeRango }
            conPaso = n
        }
        let regulares = entrada.quitarMarca(.regulares)
        if let opcion = entrada.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        let buscado = claveDeBusqueda(entrada.unidos)
        func estadisticas(_ tipo: TipoDeEscala) -> EstadisticasDeEscala { Escala(.do, tipo).estadisticas }
        func cumple(_ tipo: TipoDeEscala) -> Bool {
            guard numeroDeNotas == nil || tipo.numeroDeNotas == numeroDeNotas else { return false }
            guard !sinSemitonos || estadisticas(tipo).anhemitonica else { return false }
            guard !regulares || estadisticas(tipo).maximamenteRegular else { return false }
            if conIntervalo != nil || sinIntervalo != nil || conPaso != nil {
                let medidas = estadisticas(tipo)
                if let conIntervalo, medidas.vectorIntervalico[conIntervalo - 1] == 0 { return false }
                if let sinIntervalo, medidas.vectorIntervalico[sinIntervalo - 1] > 0 { return false }
                if let conPaso, !medidas.pasos.contains(conPaso) { return false }
            }
            return buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
                || claveDeBusqueda(tipo.nombre).contains(buscado)
        }

        // Los grupos, en el orden del catálogo: las habituales (si no se filtra por tradición ni por categoría) y,
        // después, cada tradición con su categoría.
        var grupos: [(titulo: String, tipos: [TipoDeEscala])] = []
        if tradicion == nil && categoria == nil && fuente == nil {
            if let usoPedido {
                let delUso = TipoDeEscala.occidentales(uso: usoPedido).filter(cumple)
                if !delUso.isEmpty {
                    grupos.append((traducir(.habituales) + " · " + usoPedido.nombre(en: notacion), delUso))
                }
            } else {
                let habituales = TipoDeEscala.occidentales.filter(cumple)
                if !habituales.isEmpty { grupos.append((traducir(.habituales), habituales)) }
            }
        }
        for tipo in TipoDeEscala.tradicionales where usoPedido == nil && cumple(tipo) {
            guard let suya = tipo.tradicion, let deTipo = tipo.categoria else { continue }
            guard tradicion == nil || tradicion == suya, categoria == nil || categoria == deTipo,
                fuente == nil || fuente == tipo.fuente
            else { continue }
            let titulo = suya.nombre(en: notacion) + " · " + deTipo.nombre(en: notacion)
            if let i = grupos.firstIndex(where: { $0.titulo == titulo }) {
                grupos[i].tipos.append(tipo)
            } else {
                grupos.append((titulo, [tipo]))
            }
        }
        guard !grupos.isEmpty else {
            // `escalas` busca por el nombre: con unas notas, lo que se quería era `identificar --escalas`.
            let palabras = entrada.restantes
            let sonNotas = !palabras.isEmpty && palabras.allSatisfy { (try? Nota(leyendoEnLaOrden: $0)) != nil }
            let texto =
                sonNotas
                ? TextosDeConsola.en(notacion) {
                    $0.escalasPorNotas(
                        ejemplo(
                            "armonia identificar --escalas " + entrada.unidos,
                            "armonia identify --scales " + entrada.unidos
                        ).en(notacion))
                } : traducir(.ningunaEscala)
            return .ninguna(ResultadoDeOrden(salida: "", error: "armonia: " + texto + "\n", codigo: 1))
        }
        // Con `--orden`, cada grupo de la más brillante a la más oscura, o de menos a más notas; a igualdad, en el
        // orden del catálogo.
        func ordenados(_ tipos: [TipoDeEscala]) -> [TipoDeEscala] {
            guard let orden else { return tipos }
            // La clave de cada una, de menor a mayor: el brillo, cambiado de signo, o el número de notas.
            let claves = tipos.map { orden == .brillo ? -estadisticas($0).brilloPorQuintas : Double($0.numeroDeNotas) }
            return tipos.indices.sorted { (claves[$0], $0) < (claves[$1], $1) }.map { tipos[$0] }
        }
        return .grupos(grupos.map { ($0.titulo, ordenados($0.tipos)) }, orden: orden)
    }
}
