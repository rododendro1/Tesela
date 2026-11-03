import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Dibujos: Tonnetz, tabla armónica y teclados de cuadrícula

extension LineaDeComandos {
    /// Lo que piden dibujar `tonnetz`, `tabla` y `cuadricula`.
    enum Dibujo {
        case notas([String])
        case acorde(Acorde)
        case escala(Escala)
        case clases(ConjuntoDeClases)
        case recorrido([Acorde])
        case camino(Acorde, Acorde)
        case ciclo(CicloNeorriemanniano, Acorde)
    }

    /// Lo leído: qué se dibuja y con qué margen, o el error que se responde.
    enum Lectura {
        case dibujo(Dibujo, margen: Int?)
        case error(ResultadoDeOrden)
    }

    /// Lee los argumentos comunes de `tonnetz` y `tabla`: `--margen N` y lo que se dibuja
    /// (notas, `--acorde`, `--escala`, `--clases`, `--recorrido`, `--camino` o `--ciclo`).
    static func leerDibujo(_ argumentos: [String], orden: String, _ notacion: Notacion) throws -> Lectura {
        var lectura = Argumentos(argumentos)
        var margen: Int?
        switch lectura.quitarOpcion("--margen") {
        case .ausente:
            break
        case .sinValor:
            return .error(uso(.margenFueraDeRango, notacion))
        case .valor(let texto):
            guard let n = Int(texto), (0...6).contains(n) else { return .error(uso(.margenFueraDeRango, notacion)) }
            margen = n
        }
        let argumentos = lectura.restantes
        guard let primero = argumentos.first else { return .error(uso(.faltanNotasDelDibujo(orden: orden), notacion)) }
        let resto = argumentos.dropFirst().joined(separator: " ")
        let dibujo: Dibujo
        switch primero {
        case "--acorde", "--chord":
            guard !resto.isEmpty else { return .error(uso(.faltaAcordeDelDibujo(orden: orden), notacion)) }
            dibujo = .acorde(try Acorde(leyendo: resto))
        case "--escala", "--scale":
            guard !resto.isEmpty else { return .error(uso(.faltaEscalaDelDibujo(orden: orden), notacion)) }
            dibujo = .escala(try Escala(leyendo: resto))
        case "--clases", "--pcs":
            // Como `armonia conjunto`: «0 4 7», «047», «01t», «Do Mi Sol» o «3-11».
            guard !resto.isEmpty else { return .error(uso(.faltanClasesDelDibujo(orden: orden), notacion)) }
            dibujo = .clases(try ConjuntoDeClases(leyendo: resto))
        case "--recorrido", "--sequence":
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendo: $0) }
            guard !acordes.isEmpty else { return .error(uso(.faltanTriadasDelRecorrido(orden: orden), notacion)) }
            dibujo = .recorrido(acordes)
        case "--camino", "--shortest":
            let acordes = try argumentos.dropFirst().map { try Acorde(leyendo: $0) }
            guard acordes.count == 2 else { return .error(errorDeCamino(orden, notacion)) }
            dibujo = .camino(acordes[0], acordes[1])
        case "--ciclo", "--cycle":
            let partes = Array(argumentos.dropFirst())
            guard partes.count >= 2, let ciclo = CicloNeorriemanniano(leyendo: partes.dropLast().joined(separator: " "))
            else {
                return .error(uso(.cicloMalEscrito(orden: orden), notacion))
            }
            dibujo = .ciclo(ciclo, try Acorde(leyendo: partes.last!))
        default:
            if primero.hasPrefix("--") { return .error(uso(.opcionDesconocida(primero), notacion)) }
            dibujo = .notas(argumentos)
        }
        return .dibujo(dibujo, margen: margen)
    }

    static func errorDeRecorrido(_ orden: String, _ notacion: Notacion) -> ResultadoDeOrden {
        uso(.recorridoSoloTriadas(orden: orden), notacion)
    }

    static func errorDeCamino(_ orden: String, _ notacion: Notacion) -> ResultadoDeOrden {
        uso(.caminoSoloTriadas(orden: orden), notacion)
    }

    static func errorDeCiclo(_ orden: String, _ notacion: Notacion) -> ResultadoDeOrden {
        uso(.cicloSoloTriadas(orden: orden), notacion)
    }

    /// `tonnetz Do Mi Sol`, `tonnetz --acorde Domaj7`, `tonnetz --ciclo hexatonico Do`…
    static func tonnetz(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (dibujo, margen): (Dibujo, Int?)
        switch try leerDibujo(argumentos, orden: "tonnetz", notacion) {
        case .error(let error): return error
        case .dibujo(let leido, let n): (dibujo, margen) = (leido, n)
        }
        let tonnetz: Tonnetz
        switch dibujo {
        case .notas(let textos): tonnetz = Tonnetz(try textos.map { try Nota(leyendo: $0) })
        case .acorde(let acorde): tonnetz = Tonnetz(acorde)
        case .escala(let escala): tonnetz = Tonnetz(escala)
        case .clases(let conjunto): tonnetz = Tonnetz(conjunto)
        case .recorrido(let acordes):
            guard let recorrido = Tonnetz(recorrido: acordes) else { return errorDeRecorrido("tonnetz", notacion) }
            tonnetz = recorrido
        case .camino(let origen, let destino):
            guard let camino = Tonnetz(caminoDesde: origen, hasta: destino) else {
                return errorDeCamino("tonnetz", notacion)
            }
            tonnetz = camino
        case .ciclo(let ciclo, let acorde):
            guard let dibujo = Tonnetz(ciclo: ciclo, desde: acorde) else { return errorDeCiclo("tonnetz", notacion) }
            tonnetz = dibujo
        }
        return bien(tonnetz.svg(notacion: notacion, margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `tabla Do Mi Sol`, `tabla Do3 Sol3 Mi4` (con octava, alturas), `tabla --acorde Domaj7`,
    /// `tabla --ciclo octatonico Do`…
    static func tablaArmonica(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let (dibujo, margen): (Dibujo, Int?)
        switch try leerDibujo(argumentos, orden: "tabla", notacion) {
        case .error(let error): return error
        case .dibujo(let leido, let n): (dibujo, margen) = (leido, n)
        }
        let tabla: TablaArmonica
        switch dibujo {
        case .notas(let textos):
            // Con un número de octava, alturas; sin él, notas.
            if textos.contains(where: { $0.contains(where: \.isNumber) }) {
                tabla = TablaArmonica(try textos.map { try Altura(leyendo: $0) })
            } else {
                tabla = TablaArmonica(try textos.map { try Nota(leyendo: $0) })
            }
        case .acorde(let acorde): tabla = TablaArmonica(acorde)
        case .escala(let escala): tabla = TablaArmonica(escala)
        case .clases(let conjunto): tabla = TablaArmonica(conjunto)
        case .recorrido(let acordes):
            guard let recorrido = TablaArmonica(recorrido: acordes) else { return errorDeRecorrido("tabla", notacion) }
            tabla = recorrido
        case .camino(let origen, let destino):
            guard let camino = TablaArmonica(caminoDesde: origen, hasta: destino) else {
                return errorDeCamino("tabla", notacion)
            }
            tabla = camino
        case .ciclo(let ciclo, let acorde):
            guard let dibujo = TablaArmonica(ciclo: ciclo, desde: acorde) else {
                return errorDeCiclo("tabla", notacion)
            }
            tabla = dibujo
        }
        return bien(tabla.svg(notacion: notacion, margen: margen).trimmingCharacters(in: "\n"))
    }

    /// `teclado Re mayor [--mano derecha|izquierda] [--octavas 2]`: la escala en un teclado de piano, en SVG, con
    /// el nombre de cada nota o, con una mano, sus dedos.
    static func teclado(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let octavas = argumentos.quitarNumero("--octavas", "--octaves", en: 1...4, porDefecto: 1) else {
            return uso(.octavasFueraDeRango, notacion)
        }
        var mano: Mano?
        switch argumentos.quitarOpcion("--mano", "--hand") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = manoDePiano(texto) else { return uso(.manoDesconocida(texto), notacion) }
            mano = elegida
        }
        if let desconocida = argumentos.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaEscalaDelTeclado, notacion) }
        let escala = try Escala(leyendo: argumentos.unidos)
        let svg = PresentacionDeEstudioDeEscala.teclado(de: escala, mano: mano, octavas: octavas, notacion: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// La mano de `--mano`, en español o en inglés.
    static func manoDePiano(_ texto: String) -> Mano? {
        let manos: [String: Mano] = [
            "derecha": .derecha, "right": .derecha, "izquierda": .izquierda, "left": .izquierda,
        ]
        return manos[texto.lowercased()]
    }

    /// `cuadricula Do Mi Sol`, `cuadricula --ejes 2,5 --acorde Sol7`,
    /// `cuadricula --rejilla 8x8 --origen Do2 --en-tono --escala Re dórico`… Un teclado de cuadrícula con las notas
    /// marcadas en todas las octavas, su contorno y la primera nota con borde naranja. Por defecto, en cuartas (1,5) y
    /// en una ventana de 12 × 7 alrededor del Do4.
    static func cuadricula(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var lectura = Argumentos(argumentos)
        let espejo = lectura.quitarMarca("--espejo", "--mirror")
        let enTono = lectura.quitarMarca("--en-tono", "--in-key")
        guard
            let ejes = valorDe(lectura.quitarOpcion("--ejes", "--axes"), porDefecto: "1,5"),
            let rejillaEscrita = valorDe(lectura.quitarOpcion("--rejilla", "--grid"), porDefecto: "12x7"),
            let origenEscrito = valorDe(lectura.quitarOpcion("--origen", "--origin"), porDefecto: ""),
            let giros = lectura.quitarNumero("--giro", "--rotate", en: 0...3, porDefecto: 0),
            var teclado = TecladoCuadrado.conEjes(ejes),
            let rejilla = leerRejilla(rejillaEscrita)
        else {
            return uso(.opcionesDeCuadricula, notacion)
        }
        let origen = try origenEscrito.isEmpty ? rejilla.origenPorDefecto : Altura(leyendo: origenEscrito).midi

        let dibujo: Dibujo
        switch try leerDibujo(lectura.restantes, orden: "cuadricula", notacion) {
        case .error(let error): return error
        case .dibujo(let leido, _): dibujo = leido
        }
        var escala: Escala?
        let notas: [Nota]
        switch dibujo {
        case .notas(let textos):
            // Con un número de octava, alturas; sin él, notas.
            if textos.contains(where: { $0.contains(where: \.isNumber) }) {
                notas = try textos.map { try Altura(leyendo: $0).nota }
            } else {
                notas = try textos.map { try Nota(leyendo: $0) }
            }
        case .acorde(let acorde): notas = acorde.notas
        case .escala(let leida):
            notas = leida.notas
            escala = leida
        case .clases(let conjunto): notas = conjunto.clases.map { Altura(midi: 60 + $0).nota }
        case .recorrido(let acordes): notas = acordes.flatMap(\.notas)
        case .camino(let desde, let hasta):
            guard let camino = Tonnetz(caminoDesde: desde, hasta: hasta) else {
                return errorDeCamino("cuadricula", notacion)
            }
            notas = camino.puntos.map(\.nota)
        case .ciclo(let ciclo, let acorde):
            guard let vuelta = Tonnetz(ciclo: ciclo, desde: acorde) else { return errorDeCiclo("cuadricula", notacion) }
            notas = vuelta.puntos.map(\.nota)
        }

        teclado = teclado.girado(cuartos: giros)
        if espejo { teclado = teclado.reflejado }
        teclado = teclado.conOrigen(origen)
        if enTono, let escala { teclado = teclado.enTono(escala) }
        let clases = Set(notas.map(\.claseDeAltura))
        let primera = notas.first?.claseDeAltura
        let marcadas = Set((0...127).filter { clases.contains($0 % 12) })
        let primeras = Set((0...127).filter { $0 % 12 == primera })
        let svg = teclado.svg(
            rejilla.casillas, marcadas: marcadas, primeras: primeras, contorno: true, notacion: notacion,
            preferirBemoles: notas.contains { $0.pasosDeQuinta < -1 })
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
        return RejillaDeControlador(columnas: medidas[0], filas: medidas[1])
    }
}
