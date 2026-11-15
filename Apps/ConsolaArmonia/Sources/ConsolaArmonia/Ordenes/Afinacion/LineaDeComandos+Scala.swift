import Armonia
import Foundation

// MARK: - Los ficheros de Scala: escribir un .scl o un .kbm y leer un .scl

extension LineaDeComandos {
    /// `scala temperamento Werckmeister III`, `scala escala Re bayati [--temperamento …]`: el `.scl` (o, con `--kbm`,
    /// el `.kbm`) de un temperamento o una escala del catálogo. `scala --archivo f.scl`: lo que hay en un `.scl` y lo
    /// que se le parece en el catálogo.
    static func scala(_ argumentos: [String], _ contexto: ContextoDeOrden) throws -> ResultadoDeOrden {
        let notacion = contexto.notacion
        var argumentos = Argumentos(argumentos)
        if let leido = try scalaLeido(&argumentos, contexto) {
            return bien(lineas(de: leido, en: notacion).joined(separator: "\n"))
        }
        let kbm = argumentos.quitarMarca(.kbm)
        let temperamentoDeLaEscala = try argumentos.valorConPalabras(.temperamento)
        try argumentos.sinOpcionesDesconocidas()
        guard let que = argumentos.restantes.first.map({ Argumentos.sinTildes($0.lowercased()) }),
            argumentos.restantes.count > 1
        else { throw ErrorDeUso.faltaLoQueSeEscribeEnScala }
        let nombre = argumentos.restantes.dropFirst().joined(separator: " ")
        switch que {
        case "temperamento", "temperament":
            if temperamentoDeLaEscala != nil { throw ErrorDeUso.temperamentoSoloDeEscala }
            guard
                let temperamento = TemperamentoConNombre.buscar(nombre: nombre)
                    ?? TemperamentoConNombre.buscar(conteniendo: nombre).first
            else {
                return ResultadoDeOrden(
                    salida: "", error: "armonia: " + Mensaje.ningunTemperamento.texto(en: notacion) + "\n", codigo: 1)
            }
            let scl = ArchivoScala(temperamento, en: notacion)
            let archivo = String(scl.nombreDeArchivo.dropLast(4)) // sin «.scl»
            let texto =
                kbm
                ? MapaDeTeclado(temperamento).texto(nombreDeArchivo: archivo + ".kbm")
                : scl.texto(nombreDeArchivo: archivo + ".scl")
            return bien(texto.trimmingCharacters(in: "\n"))
        case "escala", "scale":
            let escala = try Escala(leyendo: nombre, enLaOrden: notacion)
            var temperamento: TemperamentoQueAfina?
            if let texto = temperamentoDeLaEscala {
                guard
                    let hallado = TemperamentoConNombre.buscar(nombre: texto)
                        ?? TemperamentoConNombre.buscar(conteniendo: texto).first
                else {
                    return ResultadoDeOrden(
                        salida: "", error: "armonia: " + Mensaje.ningunTemperamento.texto(en: notacion) + "\n",
                        codigo: 1)
                }
                guard let queAfina = TemperamentoQueAfina(hallado) else {
                    throw ErrorDeUso.temperamentoQueNoAfina(hallado.nombre(en: notacion))
                }
                temperamento = queAfina
            }
            let scl = ArchivoScala(escala, temperamento: temperamento, en: notacion)
            let archivo = String(scl.nombreDeArchivo.dropLast(4)) // sin «.scl»
            let texto =
                kbm
                ? MapaDeTeclado(escala).texto(nombreDeArchivo: archivo + ".kbm")
                : scl.texto(nombreDeArchivo: archivo + ".scl")
            return bien(texto.trimmingCharacters(in: "\n"))
        default:
            throw ErrorDeUso.faltaLoQueSeEscribeEnScala
        }
    }

    /// Lo que se lee de un `.scl` con `--archivo`, con sus parecidos; `nil` si no hay `--archivo`.
    private static func scalaLeido(_ argumentos: inout Argumentos, _ contexto: ContextoDeOrden) throws
        -> ScalaLeido?
    {
        guard let archivo = try argumentos.valor(.archivo) else {
            for opcion in [OpcionDeOrden.tolerancia, .limite]
            where argumentos.restantes.contains(where: opcion.seEscribe) {
                throw ErrorDeUso.soloConArchivoDeScala(opcion.nombres[0])
            }
            return nil
        }
        let tolerancia = try argumentos.valor(.tolerancia).map { texto -> Double in
            guard let valor = Double(texto.replacingOccurrences(of: ",", with: ".")), valor >= 0, valor.isFinite
            else { throw ErrorDeUso.toleranciaNoValida(texto) }
            return valor
        }
        guard let limite = argumentos.quitarNumero(.limite, en: 1...1000, porDefecto: 10) else {
            throw ErrorDeUso.faltaValor("limite")
        }
        try argumentos.sinOpcionesDesconocidas()
        guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConAcordes }
        let datos = try datos(deArchivo: archivo, contexto)
        let scl = try ArchivoScala(leyendo: String(decoding: datos, as: UTF8.self))
        return ScalaLeido(
            scl, parecidos: scl.parecidos(tolerancia: tolerancia ?? 10, limite: limite),
            tolerancia: tolerancia ?? 10, en: contexto.notacion)
    }

    /// `scala --archivo f.scl --json`: lo mismo, en JSON.
    static func scalaJSON(_ argumentos: [String], _ contexto: ContextoDeOrden) throws -> ScalaLeido {
        var argumentos = Argumentos(argumentos)
        guard let leido = try scalaLeido(&argumentos, contexto) else { throw ErrorDeUso.sinSalidaJSON("scala") }
        return leido
    }

    /// Las líneas de lo leído: el resumen, los cents y lo que se le parece.
    static func lineas(de leido: ScalaLeido, en notacion: Notacion) -> [String] {
        func texto(_ campo: (TextosDeConsola) -> String) -> String { TextosDeConsola.en(notacion, campo) }
        var lineas = [
            texto { $0.sclResumen(leido.descripcion, leido.notas, Redondeo.texto(leido.periodo)) },
            "  " + leido.cents.map { Redondeo.texto($0) }.joined(separator: " "),
        ]
        guard !leido.parecidos.isEmpty else {
            lineas.append(texto { $0.sclSinParecidos(Redondeo.texto(leido.tolerancia)) })
            return lineas
        }
        lineas.append(texto(\.sclParecidos))
        for parecido in leido.parecidos {
            let clase = texto(parecido.clase == "temperamento" ? \.sclTemperamento : \.sclEscala)
            var linea = "  " + parecido.nombre + " (" + clase + ") · " + Redondeo.texto(parecido.desviacion) + " ¢"
            if parecido.desde > 0 { linea += " · " + texto { $0.sclDesdeElPaso(parecido.desde) } }
            lineas.append(linea)
        }
        return lineas
    }
}

/// Lo que hay en un `.scl` leído con `scala --archivo`, y lo que se le parece en el catálogo.
struct ScalaLeido: Encodable, Sendable {
    let descripcion: String
    let notas: Int
    let periodo: Double
    let cents: [Double]
    let tolerancia: Double
    let parecidos: [Parecido]

    /// Un temperamento o una escala del catálogo que se le parece.
    struct Parecido: Encodable, Sendable {
        /// `temperamento` o `escala`.
        let clase: String
        let nombre: String
        /// Lo que más se aparta una nota, en cents.
        let desviacion: Double
        /// El paso del temperamento desde el que empieza el fichero.
        let desde: Int
    }

    init(_ scl: ArchivoScala, parecidos: [ParecidoDeScala], tolerancia: Double, en notacion: Notacion) {
        descripcion = scl.descripcion
        notas = scl.notasPorPeriodo
        periodo = Redondeo.valor(scl.periodo)
        cents = scl.cents.map { Redondeo.valor($0) }
        self.tolerancia = tolerancia
        self.parecidos = parecidos.map { parecido in
            switch parecido.elemento {
            case .temperamento(let temperamento):
                return Parecido(
                    clase: "temperamento", nombre: temperamento.nombre(en: notacion),
                    desviacion: Redondeo.valor(parecido.desviacionMaxima), desde: parecido.desde)
            case .escala(let tipo):
                return Parecido(
                    clase: "escala", nombre: tipo.nombre(en: notacion),
                    desviacion: Redondeo.valor(parecido.desviacionMaxima), desde: parecido.desde)
            }
        }
    }
}
