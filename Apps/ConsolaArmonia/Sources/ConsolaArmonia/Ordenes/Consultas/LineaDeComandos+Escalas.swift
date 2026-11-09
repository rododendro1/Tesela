import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: una escala
//
// `escala`: una escala con todo lo que se pide de ella. El catálogo (`escalas`, `tradiciones`) está en
// LineaDeComandos+CatalogoDeEscalas.swift.

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
        /// `--tetracordos`: sus divisiones en dos tetracordos.
        let tetracordos: Bool
        /// `--bibtex`: solo sus referencias, en BibTeX.
        let bibtex: Bool

        var sentido: SentidoDelIntervalo { bajando ? .descendente : .ascendente }
    }

    /// Lee la escala y las opciones de `escala`, o lanza el `ErrorDeUso` de lo que está mal escrito.
    static func pedidoDeEscala(_ textos: [String], en notacion: Notacion) throws -> PedidoDeEscala {
        // `--dedos piano` es `--dedos`, la digitación de piano.
        var textos = textos
        if let i = textos.firstIndex(where: OpcionDeOrden.piano.seEscribe), textos.indices.contains(i + 1),
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
        let tetracordos = argumentos.quitarMarca(.tetracordos)
        let bibtex = argumentos.quitarMarca(.bibtex)
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
        if let texto = try argumentos.valorConPalabras(.comparar) {
            otra = try Escala(leyendo: texto, enLaOrden: notacion)
        }
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscala }
        return PedidoDeEscala(
            escala: try Escala(leyendo: argumentos.unidos, enLaOrden: notacion), conAcordes: conAcordes,
            secuencia: secuencia,
            octavas: octavas, bajando: bajando, piano: piano, modos: modos, simetria: simetria, vecinas: vecinas,
            estadisticas: estadisticas, escalera: escalera, doce: doce, triadas: triadas, otra: otra,
            parecidas: parecidas, progresiones: progresiones, tetracordos: tetracordos, bibtex: bibtex)
    }

    /// `escala Do mayor [--acordes] [--secuencia terceras] [--bajando] [--octavas 2] [--dedos] [--modos]
    /// [--estadisticas] [--escalera] [--comparar Do lidio]`: la escala y, si se piden, todos los acordes que caben en
    /// cada grado, una secuencia de estudio, la digitación de piano, los modos paralelos y relativos, lo que se mide de
    /// ella, su escalera de brillo y la comparación con otra escala.
    static func escala(_ textos: [String], _ contexto: ContextoDeOrden) throws -> ResultadoDeOrden {
        let notacion = contexto.notacion
        let pedido = try pedidoDeEscala(textos, en: notacion)
        let escala = pedido.escala
        // `--bibtex`: solo las referencias de la escala, que se pueden guardar en un .bib.
        if pedido.bibtex { return bien(Referencia.bibtex(escala.tipo.referencias)) }
        var lineas = [describir(escala: escala, conTodosSusAcordes: pedido.conAcordes, movil: contexto.movil, notacion)]
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
        if pedido.tetracordos { lineas += lineasDeTetracordos(de: escala, notacion) }
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

    /// `escala … --tetracordos`: una línea por cada forma de partirla en dos tetracordos, de grave a agudo, con los
    /// nombres de cada uno entre paréntesis (primero su lugar en el sistema perfecto griego, si lo tiene) y el
    /// intervalo que los separa entre barras: «Do Re Mi Fa (jins ʿAjam, Çârgâh dörtlüsü) | 2ª mayor | Sol La Si Do
    /// (…)» en Do mayor. Si es un maqām o un makam, antes, los ajnas o çeşni que le da su teoría
    /// (`TipoDeEscala.ajnas`).
    static func lineasDeTetracordos(de escala: Escala, _ notacion: Notacion) -> [String] {
        let titulo = Mensaje.tetracordos.texto(en: notacion) + ":"
        let divisiones = piezasDeTetracordos(de: escala, notacion)
        var ajnas: [String] = []
        if let fuente = escala.tipo.fuenteDeLosAjnas {
            let fragmentos = escala.tipo.ajnas.map { fragmento in
                fragmento.fragmento.nombre(en: notacion) + " (" + escala.grado(fragmento.grado).nombre(en: notacion)
                    + ")"
            }
            ajnas = [
                "  " + Mensaje.ajnas.texto(en: notacion) + " (" + fuente.cita + "): "
                    + fragmentos.joined(separator: " · ")
            ]
        }
        guard !divisiones.isEmpty else {
            return [titulo, "  " + Mensaje.sinTetracordos.texto(en: notacion)] + ajnas
        }
        return [titulo]
            + ajnas
            + divisiones.map { piezas in
                "  "
                    + piezas.map { pieza in
                        if let separacion = pieza.separacion { return separacion }
                        let notas = (pieza.notas ?? []).joined(separator: " ")
                        let nombres = pieza.nombres ?? []
                        return nombres.isEmpty ? notas : notas + " (" + nombres.joined(separator: ", ") + ")"
                    }.joined(separator: " | ")
            }
    }

    /// Una pieza de una división en tetracordos, para el texto y para `--json`: un tetracordo, con sus notas y sus
    /// nombres, o el intervalo que separa dos.
    struct PiezaDeTetracordos: Encodable {
        var notas: [String]?
        var nombres: [String]?
        var separacion: String?
    }

    /// Un jins o un çeşni de un maqām o un makam, para `--json`: su nombre y sus notas.
    struct FragmentoJSON: Encodable {
        let nombre: String
        let notas: [String]
    }

    /// Los ajnas o çeşni de un maqām o un makam (`TipoDeEscala.ajnas`), para `--json`; `nil` si no tiene.
    static func ajnasJSON(de escala: Escala, _ notacion: Notacion) -> [FragmentoJSON]? {
        guard escala.tipo.fuenteDeLosAjnas != nil else { return nil }
        return escala.tipo.ajnas.map {
            FragmentoJSON(
                nombre: $0.fragmento.nombre(en: notacion), notas: escala.notas(de: $0).map { $0.nombre(en: notacion) })
        }
    }

    /// Las divisiones en tetracordos de una escala, pieza a pieza.
    static func piezasDeTetracordos(de escala: Escala, _ notacion: Notacion) -> [[PiezaDeTetracordos]] {
        escala.divisionesEnTetracordos.map { division in
            division.piezas.map { pieza in
                switch pieza {
                case .tetracordo(let tetracordo):
                    PiezaDeTetracordos(
                        notas: escala.notas(de: tetracordo).map { $0.nombre(en: notacion) },
                        nombres: escala.tetracordosGriegos(de: tetracordo).map { $0.nombre(en: notacion) }
                            + tetracordo.fragmentos.map { $0.nombre(en: notacion) })
                case .separacion(_, let intervalo):
                    PiezaDeTetracordos(separacion: intervalo.nombre(en: notacion))
                }
            }
        }
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

    /// La escala con los datos de `--json` (`EscalaPresentada`) y, además, sus microtonos y, si se piden, todos los
    /// acordes que caben en ella; con un sistema móvil (`--sistema sargam`), también los nombres de sus grados.
    static func describir(
        escala: Escala, conTodosSusAcordes: Bool = false, movil: SistemaMovil? = nil, _ notacion: Notacion
    ) -> String {
        let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let datos = EscalaPresentada(escala, en: notacion)
        var lineas = [datos.nombre, "  \(traducir(.notas)): " + datos.notas.joined(separator: " ")]
        // Con un sistema móvil (--sistema sargam), los grados con sus nombres, desde la tónica: Sā Re ga ma Pa Dha ni.
        if let movil {
            let nombres = escala.nombres(en: movil.sistema, grafia: movil.grafia)
            lineas.append("  \(movil.sistema.nombres[0]): " + nombres.joined(separator: " "))
        }
        // De qué escala es modo: Re dórico → modo 2 de Do mayor.
        if let modo = datos.modo { lineas.append("  " + modo) }
        // El número del mēḷa, su cakra, su mnemónico y su solfa: «mēḷa 15, cakra 3 (Agni), Agni-go: sa ra gu ma pa
        // dha nu».
        let tipo = escala.tipo
        if tipo.categoria == .melakarta, let numero = tipo.numeroDeMelakarta, let cakra = CakraDeMela(mela: numero),
            let mnemonico = tipo.mnemonicoDeMela, let solfa = tipo.solfaDeMela
        {
            lineas.append(
                "  " + traducir(.mela(numero, cakra, mnemonico: mnemonico, solfa: solfa.joined(separator: " "))))
        }
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
        // Dónde se lee la escala: «West 1992; Barker 1989».
        let referencias = escala.tipo.referencias
        if !referencias.isEmpty {
            lineas.append("  \(traducir(.referencias)): " + referencias.map(\.cita).joined(separator: "; "))
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
}
