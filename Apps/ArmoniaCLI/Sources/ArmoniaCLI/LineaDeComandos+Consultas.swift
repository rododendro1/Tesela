import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Consultas: acordes, notas, escalas, tonalidades y análisis

extension LineaDeComandos {
    static func describir(acorde: Acorde, _ notacion: Notacion) -> String {
        var lineas = ["\(acorde.cifrado(en: notacion)): \(acorde.tipo.nombre(en: notacion))"]
        let notas = acorde.notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        if acorde.bajo != acorde.fundamental {
            let bajo = t(.bajo(acorde.bajo.nombre(en: notacion)))
            let inversion = acorde.inversion.map { t(.inversion($0)) } ?? t(.bajoAjeno)
            lineas.append("  \(t(.notas)): \(notas)  (\(bajo), \(inversion))")
        } else {
            lineas.append("  \(t(.notas)): \(notas)")
        }
        lineas.append(
            "  "
                + acorde.componentes.map { "\($0.nota.nombre(en: notacion)) \($0.papel.nombre(en: notacion))" }
                .joined(separator: " · "))
        return lineas.joined(separator: "\n")
    }

    static func identificar(_ textos: [String], _ notacion: Notacion) throws -> String {
        // Con octava se tiene en cuenta el bajo; sin ella, solo las notas.
        let candidatos: [Candidato<Acorde>]
        if let alturas = try? textos.map({ try Altura(leyendo: $0) }) {
            candidatos = Acorde.candidatos(alturas)
        } else {
            candidatos = Acorde.candidatos(try textos.map { try Nota(leyendo: $0) })
        }
        guard !candidatos.isEmpty else { return Mensaje.sinAcordes.texto(en: notacion) }
        return candidatos.prefix(5).map { candidato in
            var linea = "\(candidato.valor.cifrado(en: notacion))  \(candidato.valor.tipo.nombre(en: notacion))"
            if !candidato.omitidas.isEmpty {
                let omitidas = candidato.omitidas.map { $0.nombre(en: notacion) }.joined(separator: ", ")
                linea += "  (\(Mensaje.sin(omitidas).texto(en: notacion)))"
            }
            return linea
        }.joined(separator: "\n")
    }

    /// `arpegio Do7 --patron alberti`: las notas del arpegio desde la octava 4 y las escalas que encajan con el
    /// acorde (Do7 → Do mixolidio…).
    static func arpegio(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        var patron = Arpegio.Patron.ascendente
        switch argumentos.quitarOpcion("--patron", "--patrón", "--pattern") {
        case .ausente:
            break
        case .sinValor(let nombre):
            return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegido = patronDeArpegio(texto) else { return uso(.patronDesconocido(texto), notacion) }
            patron = elegido
        }
        if let desconocida = argumentos.opcionDesconocida {
            return uso(.opcionDesconocida(desconocida), notacion)
        }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaCifradoDelArpegio, notacion) }
        let bloques = try argumentos.restantes.map { texto in
            describir(arpegio: Arpegio(try Acorde(leyendo: texto), patron: patron), notacion)
        }
        return bien(bloques.joined(separator: "\n\n"))
    }

    static func describir(arpegio: Arpegio, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let notas = arpegio.alturas(octava: 4).map { $0.nombre(en: notacion) }.joined(separator: " ")
        var lineas = [
            "\(arpegio.nombre(en: notacion)) (\(arpegio.patron.nombre(en: notacion)))",
            "  \(t(.notas)): \(notas)",
        ]
        // Las escalas del acorde, de las de menos notas a las de más; con ocho basta para orientarse.
        let escalas = arpegio.acorde.escalasCompatibles()
        if !escalas.isEmpty {
            let nombres = escalas.prefix(8).map { $0.nombre(en: notacion) }.joined(separator: ", ")
            lineas.append("  \(t(.escalas)): \(nombres)" + (escalas.count > 8 ? "…" : ""))
        }
        return lineas.joined(separator: "\n")
    }

    /// El patrón de `--patron`: su nombre en el código (`alberti`, `idaYVuelta`), con guiones (`ida-y-vuelta`),
    /// en inglés (`ascending`, `up-down`, `down-up`, `broken`) o como lo escribe cualquiera de los catorce idiomas
    /// («bajo de Alberti»).
    static func patronDeArpegio(_ texto: String) -> Arpegio.Patron? {
        func plano(_ s: String) -> String {
            s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                .replacingOccurrences(of: "-", with: " ")
                .replacingOccurrences(of: "_", with: " ")
        }
        let buscado = plano(texto)
        let abreviados: [String: Arpegio.Patron] = [
            "ida y vuelta": .idaYVuelta, "up": .ascendente, "down": .descendente, "up down": .idaYVuelta,
            "baja y sube": .bajaYSube, "down up": .bajaYSube, "broken": .quebrado,
        ]
        if let patron = abreviados[buscado] { return patron }
        return Arpegio.Patron.allCases.first { patron in
            plano(patron.rawValue) == buscado
                || Idioma.allCases.contains { plano(patron.nombre(en: .delIdioma($0))) == buscado }
        }
    }

    static func intervalo(_ a: String, _ b: String, _ notacion: Notacion) throws -> String {
        let intervalo: Intervalo
        if let grave = try? Altura(leyendo: a), let aguda = try? Altura(leyendo: b) {
            intervalo = aguda - grave
        } else {
            intervalo = try Nota(leyendo: a).intervalo(hasta: try Nota(leyendo: b))
        }
        let semitonos = Mensaje.semitonos(intervalo.semitonos).texto(en: notacion)
        return "\(intervalo.nombre(en: notacion)) (\(intervalo.texto(en: notacion)), \(semitonos))"
    }

    static func describir(escala: Escala, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var lineas = [
            escala.nombre(en: notacion),
            "  \(t(.notas)): " + escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " "),
        ]
        // Los acordes de cada grado, si la escala es heptatónica y todos forman un acorde conocido.
        let acordes = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        if acordes.count == escala.notas.count, romanos.count == acordes.count {
            let pares = zip(romanos, acordes).map { "\($0) \($1.cifrado(en: notacion))" }
            lineas.append("  \(t(.acordes)): " + pares.joined(separator: " · "))
        }
        return lineas.joined(separator: "\n")
    }

    static func describir(tonalidad: Tonalidad, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let armadura: String
        switch tonalidad.armadura {
        case 0: armadura = t(.sinAlteraciones)
        default:
            let signos = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }.joined(separator: " ")
            armadura = "\(signos) (\(t(.alteraciones(abs(tonalidad.armadura), sostenidos: tonalidad.armadura > 0))))"
        }
        let acordes = zip(tonalidad.cifradosRomanos(cuatriadas: true), tonalidad.armonizar(cuatriadas: true))
            .map { "\($0) \($1.cifrado(en: notacion))" }.joined(separator: " · ")
        return [
            tonalidad.nombre(en: notacion),
            "  \(t(.armadura)): " + armadura,
            "  \(t(.relativa)): " + tonalidad.relativa.nombre(en: notacion)
                + " · \(t(.homonima)): " + tonalidad.homonima.nombre(en: notacion),
            "  \(t(.acordes)): " + acordes,
        ].joined(separator: "\n")
    }

    static func analizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var acordes = Argumentos(argumentos)
        guard let tonalidad = try acordes.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        let archivo: String?
        switch acordes.quitarOpcion("--archivo", "--file") {
        case .ausente: archivo = nil
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let ruta): archivo = ruta
        }
        let ventana: Duracion?
        switch acordes.quitarOpcion("--ventana", "--window") {
        case .ausente: ventana = nil
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto): ventana = try Duracion(leyendo: texto)
        }
        if let opcion = acordes.opcionDesconocida { return uso(.opcionDesconocida(opcion), notacion) }
        let analisis: AnalisisPresentado
        if let archivo {
            guard acordes.restantes.isEmpty else { return uso(.archivoConAcordes, notacion) }
            guard let datos = FileManager.default.contents(atPath: archivo) else {
                return uso(.archivoIlegible(archivo), notacion)
            }
            let pieza = try PiezaImportada(leyendo: datos)
            guard
                let leido = PresentacionDeAnalisis.analizar(
                    pieza.acordes(ventana: ventana), en: tonalidad,
                    notacion: notacion)
            else {
                return uso(.archivoSinAcordes, notacion)
            }
            analisis = leido
        } else {
            guard !acordes.restantes.isEmpty else { return uso(.faltanAcordesDelAnalisis, notacion) }
            // Con la tonalidad dada, sin modulaciones; si no, en tramos.
            analisis = try PresentacionDeAnalisis.analizar(acordes.unidos, en: tonalidad, notacion: notacion)
        }
        var lineas = [analisis.titulo]
        let todas = analisis.tramos.flatMap(\.filas)
        // Columnas de al menos 10 caracteres, más anchas si un cifrado no cabe.
        let anchoDelCifrado = max(10, (todas.map(\.cifrado.count).max() ?? 0) + 2)
        let anchoDelGrado = max(10, (todas.map(\.grado.count).max() ?? 0) + 2)
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera { lineas.append(cabecera) }
            for fila in tramo.filas {
                let funcion = fila.funcion.isEmpty ? "–" : fila.funcion
                lineas.append(
                    "  " + fila.cifrado.padding(hasta: anchoDelCifrado) + fila.grado.padding(hasta: anchoDelGrado)
                        + funcion)
            }
        }
        lineas += analisis.cadencias
        return bien(lineas.joined(separator: "\n"))
    }
}
