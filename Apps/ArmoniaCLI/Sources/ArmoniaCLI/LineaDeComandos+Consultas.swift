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
        // Las escalas del acorde, de las que tienen menos notas a evitar a las que más; con ocho basta para orientarse.
        let escalas = arpegio.acorde.escalasCompatibles()
        if !escalas.isEmpty {
            let nombres = escalas.prefix(8).map { $0.nombre(en: notacion) }.joined(separator: ", ")
            lineas.append("  \(t(.escalas)): \(nombres)" + (escalas.count > 8 ? "…" : ""))
        }
        return lineas.joined(separator: "\n")
    }

    /// El patrón de `--patron`, como lo lee `Arpegio.Patron(leyendo:)`: `alberti`, `ida-y-vuelta`, `up-down` o su
    /// nombre en cualquiera de los quince idiomas («bajo de Alberti»).
    static func patronDeArpegio(_ texto: String) -> Arpegio.Patron? { Arpegio.Patron(leyendo: texto) }

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

    /// Con `conTodosSusAcordes` (`--acordes`), también los acordes que caben sobre cada grado, no solo los de
    /// terceras.
    static func describir(escala: Escala, conTodosSusAcordes: Bool = false, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var lineas = [
            escala.nombre(en: notacion),
            "  \(t(.notas)): " + escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " "),
        ]
        // De qué escala es modo: Re dórico → modo 2 de Do mayor.
        if let modo = PresentacionDeEscalaYAcorde.modo(de: escala, notacion: notacion) { lineas.append("  " + modo) }
        // La versión microtonal (Re Bayātī: Re Mi𝄳 Fa…) y los cents de cada grado, si la escala la tiene.
        if let subida = escala.notasMicrotonales() {
            let bajada = escala.notasMicrotonales(sentido: .descendente) ?? subida
            func nombres(_ notas: [NotaMicrotonal]) -> String {
                notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
            }
            func cents(_ notas: [NotaMicrotonal]) -> String {
                notas.map { "\(Int($0.cents.rounded()))" }.joined(separator: " ")
            }
            lineas.append("  \(t(.microtonos)): " + nombres(subida))
            lineas.append("  ¢: " + cents(subida))
            if bajada != subida {
                lineas.append("  \(t(.microtonos)) ↓: " + nombres(bajada))
                lineas.append("  ¢ ↓: " + cents(bajada))
            }
        }
        // Los acordes de cada grado, si la escala es heptatónica y todos forman un acorde conocido.
        let acordes = escala.armonizar(cuatriadas: true).compactMap { $0 }
        let romanos = escala.cifradosRomanos(cuatriadas: true).compactMap { $0 }
        if acordes.count == escala.notas.count, romanos.count == acordes.count {
            let pares = zip(romanos, acordes).map { "\($0) \($1.cifrado(en: notacion))" }
            lineas.append("  \(t(.acordes)): " + pares.joined(separator: " · "))
        }
        let grados = conTodosSusAcordes ? PresentacionDeEscalaYAcorde.acordesQueCaben(escala, notacion: notacion) : []
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
    ]

    /// Un texto para comparar nombres: sin mayúsculas, tildes, guiones ni espacios («Mundo árabe» → «mundoarabe»).
    private static func claveDeBusqueda(_ texto: String) -> String {
        texto.replacingOccurrences(of: "ı", with: "i")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .filter { $0.isLetter || $0.isNumber }
    }

    /// `escalas [<texto>] [--tradicion <tradición>] [--categoria <categoría>]`: el catálogo de escalas, las habituales
    /// y las de otras tradiciones agrupadas por tradición y categoría, cada una con sus notas desde Do (y la marca de
    /// los microtonos, si los tiene). Un texto suelto busca en los nombres.
    static func escalas(_ argumentos: [String], _ notacion: Notacion) -> ResultadoDeOrden {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        var entrada = Argumentos(argumentos)
        var tradicion: Tradicion?
        switch entrada.quitarOpcion("--tradicion", "--tradición", "--tradition") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { return uso(.tradicionDesconocida(texto), notacion) }
            tradicion = encontrada.tradicion
        }
        var categoria: CategoriaTradicional?
        switch entrada.quitarOpcion("--categoria", "--categoría", "--category") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                return uso(.categoriaDesconocida(texto), notacion)
            }
            categoria = encontrada
        }
        if let opcion = entrada.opcionDesconocida { return uso(.opcionDesconocida(opcion), notacion) }
        let buscado = claveDeBusqueda(entrada.unidos)
        func cumple(_ tipo: TipoDeEscala) -> Bool {
            buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
                || claveDeBusqueda(tipo.nombre).contains(buscado)
        }

        // Los grupos, en el orden del catálogo: las habituales (si no se filtra por tradición ni por categoría) y,
        // después, cada tradición con su categoría.
        var grupos: [(titulo: String, tipos: [TipoDeEscala])] = []
        if tradicion == nil && categoria == nil {
            let habituales = TipoDeEscala.todos.filter(cumple)
            if !habituales.isEmpty { grupos.append((t(.habituales), habituales)) }
        }
        for tipo in TipoDeEscala.tradicionales where cumple(tipo) {
            guard let suya = tipo.tradicion, let deTipo = tipo.categoria else { continue }
            guard tradicion == nil || tradicion == suya, categoria == nil || categoria == deTipo else { continue }
            let nombres = nombresDeLasTradiciones.first(where: { $0.tradicion == suya })
            let nombre = nombres.map { ejemplo($0.espanol, $0.ingles).en(notacion) } ?? suya.rawValue
            let titulo = nombre + " · " + deTipo.nombre(en: notacion)
            if let i = grupos.firstIndex(where: { $0.titulo == titulo }) {
                grupos[i].tipos.append(tipo)
            } else {
                grupos.append((titulo, [tipo]))
            }
        }
        guard !grupos.isEmpty else { return bien(t(.ningunaEscala)) }
        var lineas: [String] = []
        for grupo in grupos {
            if !lineas.isEmpty { lineas.append("") }
            lineas.append("\(grupo.titulo) (\(grupo.tipos.count))")
            for tipo in grupo.tipos {
                let notas = Escala(.do, tipo).notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
                let microtonos = tipo.microtonal == nil ? "" : " · " + t(.microtonos)
                lineas.append("  \(tipo.nombre(en: notacion)): \(notas)\(microtonos)")
            }
        }
        return bien(lineas.joined(separator: "\n"))
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
        // Con --escalas, debajo de cada acorde, su escala con sus tensiones y sus notas a evitar. Se quita antes que
        // la tonalidad, que se lleva todo lo que va detrás de --en.
        let conEscalas = acordes.quitarMarca("--escalas", "--scales")
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
                if conEscalas, let escala = fila.escala {
                    let resumen = escala.resumen.isEmpty ? "" : " — " + escala.resumen
                    lineas.append("    " + escala.nombre + resumen)
                    if !escala.estructurasSuperiores.isEmpty {
                        let etiqueta = notacion.texto(\.estructurasSuperiores)
                        lineas.append("      " + etiqueta + ": " + escala.estructurasSuperiores)
                    }
                }
            }
        }
        lineas += analisis.cadencias
        return bien(lineas.joined(separator: "\n"))
    }

    // MARK: Teoría postonal

    /// `conjunto 0 4 7`: el conjunto con sus notas, sus formas, sus vectores y sus ejes de simetría.
    static func describir(conjunto: ConjuntoDeClases, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        func lista(_ numeros: [Int]) -> String { "[" + numeros.map(String.init).joined(separator: ", ") + "]" }
        let ejes = conjunto.ejesDeSimetria.map(\.description).joined(separator: " · ")
        return [
            [conjunto.description, conjunto.numeroDeForte].compactMap { $0 }.joined(separator: "  "),
            "  \(t(.notas)): " + conjunto.notas().map { $0.nombre(en: notacion) }.joined(separator: " "),
            "  \(t(.formaNormal)): \(lista(conjunto.formaNormal))",
            "  \(t(.formaPrima)): \(lista(conjunto.formaPrima))",
            "  \(t(.vectorIntervalico)): \(lista(conjunto.vectorIntervalico))",
            "  \(t(.vectorDeIndice)): \(lista(conjunto.vectorDeIndice))",
            "  \(t(.ejesDeSimetria)): " + (ejes.isEmpty ? "—" : ejes),
        ].joined(separator: "\n")
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6`: la serie con sus notas, sus intervalos, sus hexacordos, sus formas
    /// combinatorias y la matriz, con las P a la izquierda, las R a la derecha, las I arriba y las RI abajo.
    static func describir(serie: SerieDodecafonica, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        // Una nota por clase, escritas todas a la vez para que no se repita ninguna.
        let total = ConjuntoDeClases(0..<12)
        let nombres = Dictionary(uniqueKeysWithValues: zip(total.clases, total.notas()))
        let notas = serie.clases.compactMap { nombres[$0]?.nombre(en: notacion) }.joined(separator: " ")
        var intervalos = "  \(t(.intervalos)): " + serie.intervalos.map(String.init).joined(separator: " ")
        if serie.esDeTodosLosIntervalos { intervalos += "  (\(t(.deTodosLosIntervalos)))" }
        let (primero, segundo) = serie.hexacordos
        let hexacordos = [primero, segundo].map { $0.numeroDeForte ?? $0.description }.joined(separator: " · ")
        var lineas = [
            serie.description,
            "  \(t(.notas)): \(notas)",
            intervalos,
            "  \(t(.hexacordos)): \(hexacordos)",
            "  \(t(.formasCombinatorias)): "
                + serie.formasCombinatorias.map(\.description).joined(separator: " "),
            "  " + t(.formasDistintas(serie.numeroDeFormasDistintas)),
            "",
        ]
        func celda(_ texto: String) -> String { texto + String(repeating: " ", count: max(1, 5 - texto.count)) }
        func cifra(_ clase: Int) -> String { clase == 10 ? "t" : clase == 11 ? "e" : String(clase) }
        let matriz = serie.matriz
        let margen = "  " + celda("")
        func cabecera(_ tipo: TipoDeFormaDeSerie) -> String {
            margen + matriz[0].map { celda(FormaDeSerie(tipo, $0).description) }.joined()
        }
        lineas.append(cabecera(.inversion))
        for fila in matriz {
            let p = FormaDeSerie(.original, fila[0]).description
            let r = FormaDeSerie(.retrogrado, fila[0]).description
            lineas.append("  " + celda(p) + fila.map { celda(cifra($0)) }.joined() + r)
        }
        lineas.append(cabecera(.retrogradoDeLaInversion))
        return lineas.map { String($0.reversed().drop(while: { $0 == " " }).reversed()) }.joined(separator: "\n")
    }
}
