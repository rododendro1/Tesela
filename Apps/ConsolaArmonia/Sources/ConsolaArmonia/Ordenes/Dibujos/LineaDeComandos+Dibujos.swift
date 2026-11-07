import Armonia
import Exposicion
import Foundation

// MARK: - Dibujos: Tonnetz, tabla armónica y teclados de cuadrícula, y lo que comparten con los demás dibujos

extension LineaDeComandos {
    /// Una suborden como `acorde` en `tonnetz acorde Sol7` o `hoja acordes Rem7 Sol7`, cambiada por la opción con que
    /// se lee (`--acorde`): los argumentos con la primera palabra cambiada si es el nombre, sin los guiones, de una de
    /// `opciones`, o sin ella si es una de `sinNada` (`hoja escala Re dórico` es `hoja Re dórico`). Esas opciones no se
    /// escriben: `tonnetz --acorde Sol7` es una opción desconocida.
    static func conLaSuborden(
        _ argumentos: [String], entre opciones: [OpcionDeOrden], sinNada: Set<String> = []
    ) throws -> [String] {
        if let escrita = argumentos.first(where: { texto in opciones.contains { $0.leidos.contains(texto) } }) {
            throw ErrorDeUso.opcionDesconocida(escrita)
        }
        guard let primera = argumentos.first?.lowercased(), !primera.hasPrefix("-") else { return argumentos }
        if sinNada.contains(primera) { return Array(argumentos.dropFirst()) }
        guard let opcion = opciones.first(where: { $0.leidos.contains("--" + primera) }) else { return argumentos }
        return [opcion.nombres[0]] + argumentos.dropFirst()
    }

    /// `--dedos piano` y `--dedos guitarra`, cambiados por las opciones con que se leen: `--mano derecha` y `--tab
    /// --dedos`. Con `soloPiano` (en `teclado`), `--dedos` a secas es también `--mano derecha` (y `--dedos izquierda`,
    /// `--mano izquierda`); si no, `--dedos` lleva detrás el instrumento. `--mano` no se escribe.
    static func conLosDedos(_ argumentos: [String], soloPiano: Bool) throws -> [String] {
        if let escrita = argumentos.first(where: OpcionDeOrden.mano.leidos.contains) {
            throw ErrorDeUso.opcionDesconocida(escrita)
        }
        let nombres = OpcionDeOrden.dedos.leidos
        guard let i = argumentos.firstIndex(where: nombres.contains) else { return argumentos }
        let siguiente = argumentos.indices.contains(i + 1) ? argumentos[i + 1].lowercased() : nil
        var cambiados = argumentos
        if let siguiente, instrumentosDeLosDedos.piano.contains(siguiente) {
            cambiados.replaceSubrange(i...(i + 1), with: ["--mano", "derecha"])
        } else if !soloPiano, let siguiente, instrumentosDeLosDedos.guitarra.contains(siguiente) {
            cambiados.replaceSubrange(i...(i + 1), with: ["--tab", "--dedos"])
        } else if soloPiano {
            // `teclado … --dedos izquierda` es `--mano izquierda`; `--dedos` a secas, la derecha.
            cambiados[i] = "--mano"
            if siguiente.flatMap(manoDePiano) == nil { cambiados.insert("derecha", at: i + 1) }
        } else {
            throw ErrorDeUso.faltaValor(String(argumentos[i].dropFirst(2)))
        }
        return cambiados
    }

    /// Lo que puede ir tras `--dedos`.
    static let instrumentosDeLosDedos = (piano: Set(["piano"]), guitarra: Set(["guitarra", "guitar"]))

    /// Las subórdenes de `tonnetz`, `tabla` y `cuadricula`.
    static let subordenesDeLosDibujos: [OpcionDeOrden] = [.acorde, .escala, .clases, .recorrido, .camino, .ciclo]

    /// Las palabras que dicen que lo que sigue son unas notas: `tonnetz notas Do Mi Sol` es `tonnetz Do Mi Sol`.
    static let subordenDeNotas: Set = ["notas", "notes"]

    /// Lee los argumentos comunes de `tonnetz`, `tabla` y `cuadricula`: `--margen N` y lo que se dibuja (notas,
    /// `acorde`, `escala`, `clases`, `recorrido`, `camino` o `ciclo`), como en la app Tonnetz. Con
    /// `conOctavas`, unas notas con número de octava se leen como alturas (`Do3 Sol3 Mi4`), que se dan también aparte.
    static func leerDibujo(_ argumentos: [String], orden: String, conOctavas: Bool = true) throws -> (
        contenido: ContenidoDeRed, alturas: [Altura]?, margen: Int?
    ) {
        var lectura = Argumentos(argumentos)
        var margen: Int?
        if let texto = try lectura.valor(.margen, siFalta: .margenFueraDeRango) {
            guard let n = Int(texto), (0...6).contains(n) else { throw ErrorDeUso.margenFueraDeRango }
            margen = n
        }
        let argumentos = try conLaSuborden(lectura.restantes, entre: subordenesDeLosDibujos, sinNada: subordenDeNotas)
        guard let primero = argumentos.first else { throw ErrorDeUso.faltanNotasDelDibujo(orden: orden) }
        // Tras la suborden (`acorde`, `escala`…, que se puede escribir como opción), ninguna opción más.
        try Argumentos(Array(argumentos.dropFirst())).sinOpcionesDesconocidas()
        let resto = argumentos.dropFirst().joined(separator: " ")
        let contenido: ContenidoDeRed
        var alturas: [Altura]?
        switch primero {
        case OpcionDeOrden.acorde:
            guard !resto.isEmpty else { throw ErrorDeUso.faltaAcordeDelDibujo(orden: orden) }
            contenido = .acorde(try Acorde(leyendoEnLaOrden: resto))
        case OpcionDeOrden.escala:
            guard !resto.isEmpty else { throw ErrorDeUso.faltaEscalaDelDibujo(orden: orden) }
            contenido = .escala(try Escala(leyendoEnLaOrden: resto))
        case OpcionDeOrden.clases:
            // Como `armonia conjunto`: «0 4 7», «047», «01t», «Do Mi Sol» o «3-11».
            guard !resto.isEmpty else { throw ErrorDeUso.faltanClasesDelDibujo(orden: orden) }
            contenido = .clases(try ConjuntoDeClasesDeAltura(leyendo: resto).clases)
        case OpcionDeOrden.recorrido:
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendoEnLaOrden: $0) }
            guard !acordes.isEmpty else { throw ErrorDeUso.faltanTriadasDelRecorrido(orden: orden) }
            contenido = .recorrido(acordes)
        case OpcionDeOrden.camino:
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendoEnLaOrden: $0) }
            guard acordes.count == 2 else { throw ErrorDeUso.caminoSoloTriadas(orden: orden) }
            contenido = .camino(acordes[0], acordes[1])
        case OpcionDeOrden.ciclo:
            let partes = Array(argumentos.dropFirst())
            guard partes.count >= 2,
                let ciclo = try? CicloNeorriemanniano(leyendo: partes.dropLast().joined(separator: " "))
            else {
                throw ErrorDeUso.cicloMalEscrito(orden: orden)
            }
            contenido = .ciclo(ciclo, try Acorde(leyendoEnLaOrden: partes.last!))
        default:
            if primero.hasPrefix("--") { throw ErrorDeUso.opcionDesconocida(primero) }
            if conOctavas, argumentos.contains(where: { $0.contains(where: \.isNumber) }) {
                let leidas = try argumentos.map { try Altura(leyendoEnLaOrden: $0) }
                alturas = leidas
                contenido = .notas(leidas.map(\.nota))
            } else {
                contenido = .notas(try argumentos.map { try Nota(leyendoEnLaOrden: $0) })
            }
        }
        return (contenido, alturas, margen)
    }

    /// El contenido en el Tonnetz o en la tabla armónica, o el error de un recorrido, un camino o un ciclo que no son
    /// de tríadas mayores y menores.
    static func red<Red: RedDeTriadas>(_ tipo: Red.Type, de contenido: ContenidoDeRed, orden: String) throws -> Red {
        if let red = contenido.red(tipo) { return red }
        switch contenido {
        case .camino: throw ErrorDeUso.caminoSoloTriadas(orden: orden)
        case .ciclo: throw ErrorDeUso.cicloSoloTriadas(orden: orden)
        default: throw ErrorDeUso.recorridoSoloTriadas(orden: orden)
        }
    }

    /// `tonnetz Do Mi Sol`, `tonnetz acorde Domaj7`, `tonnetz ciclo hexatonico Do`…
    static func tonnetz(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (contenido, _, margen) = try leerDibujo(argumentos, orden: "tonnetz", conOctavas: false)
        let tonnetz = try red(Tonnetz.self, de: contenido, orden: "tonnetz")
        return bien(tonnetz.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `tabla Do Mi Sol`, `tabla Do3 Sol3 Mi4` (con octava, alturas), `tabla acorde Domaj7`,
    /// `tabla ciclo octatonico Do`…
    static func tablaArmonica(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (contenido, alturas, margen) = try leerDibujo(argumentos, orden: "tabla")
        // Con un número de octava, las alturas como en el instrumento; sin él, las notas.
        let tabla = try alturas.map { TablaArmonica($0) } ?? red(TablaArmonica.self, de: contenido, orden: "tabla")
        return bien(tabla.svg(opciones: .init(notacion: notacion), margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `cuadricula Do Mi Sol`, `cuadricula acorde Sol7 --ejes 2,5`,
    /// `cuadricula escala Re dórico --rejilla 8x8 --origen Do2 --en-tono`… Un teclado de cuadrícula con las notas
    /// marcadas en todas las octavas, su contorno y la primera nota con borde naranja. Por defecto, en cuartas (1,5) y
    /// en una ventana de 12 × 7 alrededor del Do4.
    static func cuadricula(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var lectura = Argumentos(argumentos)
        let espejo = lectura.quitarMarca(.espejo)
        let enTono = lectura.quitarMarca(.enTono)
        guard
            let ejes = valorDe(lectura.quitarOpcion(.ejes), porDefecto: "1,5"),
            let rejillaEscrita = valorDe(lectura.quitarOpcion(.rejilla), porDefecto: "12x7"),
            let origenEscrito = valorDe(lectura.quitarOpcion(.origen), porDefecto: ""),
            let giros = lectura.quitarNumero(.giro, en: 0...3, porDefecto: 0),
            var teclado = TecladoCuadrado.conEjes(ejes),
            let rejilla = leerRejilla(rejillaEscrita)
        else {
            throw ErrorDeUso.opcionesDeCuadricula
        }
        let origen = try origenEscrito.isEmpty ? rejilla.origenPorDefecto : Altura(leyendoEnLaOrden: origenEscrito).midi

        let contenido = try leerDibujo(lectura.restantes, orden: "cuadricula").contenido
        // Las notas de un camino o un ciclo son las de sus tríadas en el Tonnetz: sin tríadas, no hay nada que dibujar.
        switch contenido {
        case .camino, .ciclo: _ = try red(Tonnetz.self, de: contenido, orden: "cuadricula")
        default: break
        }

        teclado = teclado.rotado(cuartos: giros)
        if espejo { teclado = teclado.reflejado }
        teclado = teclado.conOrigen(origen)
        if enTono, let escala = contenido.escala { teclado = teclado.enTono(escala) }
        let svg = PresentacionDeRedes.svg(contenido, en: teclado, casillas: rejilla.casillas, notacion: notacion)
        return bien(svg)
    }

    /// El valor de una opción, `porDefecto` si no está, o `nil` si está sin valor.
    private static func valorDe(_ opcion: Argumentos.Opcion, porDefecto: String) -> String? {
        switch opcion {
        case .ausente: return porDefecto
        case .sinValor: return nil
        case .valor(let texto): return texto
        }
    }

    /// Una rejilla escrita «columnas x filas» (`8x8`, `25×8`), o `nil` si no se lee.
    private static func leerRejilla(_ texto: String) -> RejillaDeControlador? {
        let medidas = texto.lowercased().split(whereSeparator: { $0 == "x" || $0 == "×" }).compactMap { Int($0) }
        guard medidas.count == 2 else { return nil }
        return RejillaDeControlador(comprobando: medidas[0], filas: medidas[1])
    }
}
