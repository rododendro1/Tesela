import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Digitaciones: cómo tocar un acorde en un instrumento de cuerda con trastes

extension LineaDeComandos {
    /// `digitaciones Sol7/Si --instrumento ukelele`: formas de tocar el acorde, de la más cómoda a la menos.
    static func digitaciones(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)

        // `--tab` era el nombre anterior de `--diagrama`.
        let conDiagrama = argumentos.quitarMarca("--diagrama", "--diagram", "--tab")
        // Por defecto la quinta puede faltar en los acordes de cuatro notas o más (el Do7 `x32310`): es lo normal en
        // una guitarra. Con --completo se exigen todas las notas.
        let completo = argumentos.quitarMarca("--completo", "--complete")
        // La primera forma de cada acorde como tablatura MusicXML, en lugar del texto.
        let comoMusicXML = argumentos.quitarMarca("--musicxml")

        var encordado = Encordado.guitarra
        switch argumentos.quitarOpcion("--instrumento", "--instrument") {
        case .ausente:
            break
        case .sinValor:
            return uso(.faltaInstrumento, notacion)
        case .valor(let nombre):
            guard let encontrado = Encordado(nombre: nombre) else {
                return uso(.instrumentoDesconocido(nombre), notacion)
            }
            encordado = encontrado
        }

        var limite = 5
        switch argumentos.quitarOpcion("--limite", "--limit") {
        case .ausente:
            break
        case .sinValor:
            return uso(.faltaLimite, notacion)
        case .valor(let texto):
            guard let n = Int(texto), (1...200).contains(n) else {
                return uso(.limiteFueraDeRango, notacion)
            }
            limite = n
        }

        var maximoDeDedos = 4
        switch argumentos.quitarOpcion("--dedos", "--fingers") {
        case .ausente:
            break
        case .sinValor:
            return uso(.faltanDedos, notacion)
        case .valor(let texto):
            guard let n = Int(texto), (1...4).contains(n) else {
                return uso(.dedosFueraDeRango, notacion)
            }
            maximoDeDedos = n
        }

        var maximoTraste = 12
        switch argumentos.quitarOpcion("--traste", "--fret") {
        case .ausente:
            break
        case .sinValor:
            return uso(.faltaTraste, notacion)
        case .valor(let texto):
            guard let n = Int(texto), (0...24).contains(n) else {
                return uso(.trasteFueraDeRango, notacion)
            }
            maximoTraste = n
        }

        // Con capo, los trastes se cuentan desde él.
        var capo = 0
        switch argumentos.quitarOpcion("--capo") {
        case .ausente:
            break
        case .sinValor:
            return uso(.capoFueraDeRango, notacion)
        case .valor(let texto):
            guard let n = Int(texto), (0...12).contains(n) else { return uso(.capoFueraDeRango, notacion) }
            capo = n
        }

        if let desconocida = argumentos.opcionDesconocida {
            return uso(.opcionDesconocida(desconocida), notacion)
        }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaCifradoDeDigitaciones, notacion) }

        let mastil = Mastil(encordado.conCapo(capo), trastes: 24 - capo)
        if comoMusicXML {
            let acordes = try argumentos.restantes.map { try Acorde(leyendo: $0) }
            var formas: [Digitacion] = []
            var conForma: [Acorde] = []
            for acorde in acordes {
                guard
                    let forma = mastil.digitaciones(
                        de: acorde, maximoDeDedos: maximoDeDedos, maximoTraste: maximoTraste,
                        exigirQuinta: completo, limite: 1
                    ).first
                else { continue }
                formas.append(forma)
                conForma.append(acorde)
            }
            let titulo = conForma.map { $0.cifrado(en: notacion) }.joined(separator: " ")
            let xml = PresentacionDeTablatura.musicXML(
                digitaciones: formas, acordes: conForma, titulo: titulo, notacion: notacion)
            return bien(xml.trimmingCharacters(in: "\n"))
        }
        // «Do · guitarra», y con capo, «Do · guitarra · Capo en el traste 2».
        var instrumento = Mensaje.instrumento(encordado).texto(en: notacion)
        if capo > 0 { instrumento += " · " + notacion.texto { $0.capo(capo) } }
        let bloques = try argumentos.restantes.map { texto -> String in
            let acorde = try Acorde(leyendo: texto)
            var lineas = ["\(acorde.cifrado(en: notacion)) · \(instrumento)"]
            let formas = mastil.digitaciones(
                de: acorde, maximoDeDedos: maximoDeDedos, maximoTraste: maximoTraste,
                exigirQuinta: completo, limite: limite)
            guard !formas.isEmpty else {
                lineas.append("  " + Mensaje.sinDigitaciones.texto(en: notacion))
                return lineas.joined(separator: "\n")
            }
            for forma in formas {
                let notas = forma.notas(para: acorde).map { $0.nombre(en: notacion) }.joined(separator: " ")
                lineas.append(
                    "  " + forma.tablatura.padding(hasta: 17) + notas.padding(hasta: 18)
                        + descripcion(de: forma, notacion))
                if conDiagrama { lineas += diagrama(de: forma, notacion) }
            }
            return lineas.joined(separator: "\n")
        }
        return bien(bloques.joined(separator: "\n\n"))
    }

    /// «(3 dedos)», o «(4 dedos, cejilla en el traste 1)».
    static func descripcion(de forma: Digitacion, _ notacion: Notacion) -> String {
        var texto = Mensaje.dedos(forma.dedos).texto(en: notacion)
        if let cejilla = forma.cejilla {
            texto += ", " + Mensaje.cejilla(cejilla).texto(en: notacion)
        }
        return "(\(texto))"
    }

    /// La digitación con una línea por cuerda: la más aguda arriba, con su traste (o «x»).
    static func diagrama(de forma: Digitacion, _ notacion: Notacion) -> [String] {
        let cuerdas = forma.mastil.encordado.cuerdas
        let nombres = cuerdas.map { $0.nota.nombre(en: notacion) }
        let ancho = nombres.map(\.count).max() ?? 0
        return cuerdas.indices.reversed().map { i in
            let traste = forma.trastes[i].map(String.init) ?? "x"
            let relleno = String(repeating: " ", count: max(0, 2 - traste.count))
            return "      " + nombres[i].padding(hasta: ancho + 1) + "|-" + relleno + traste + "-"
        }
    }

    /// `posiciones Sol mayor [--caged]`: la escala por posiciones en la guitarra, de tres (o dos) notas por cuerda o
    /// en las cinco formas CAGED, con los trastes de cada cuerda, la más aguda arriba como en una tablatura.
    static func posiciones(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        let caged = argumentos.quitarMarca("--caged")
        let bajando = argumentos.quitarMarca("--bajando", "--descending")
        let formas = argumentos.quitarMarca("--formas", "--shapes")
        let arpegio = argumentos.quitarMarca("--arpegio", "--arpeggio")
        let barrido = argumentos.quitarMarca("--barrido", "--sweep")
        let idaYVuelta = argumentos.quitarMarca("--ida-y-vuelta", "--up-and-down")
        var encordado = Encordado.guitarra
        switch argumentos.quitarOpcion("--instrumento", "--instrument") {
        case .ausente: break
        case .sinValor: return uso(.faltaInstrumento, notacion)
        case .valor(let nombre):
            guard let encontrado = Encordado(nombre: nombre) else {
                return uso(.instrumentoDesconocido(nombre), notacion)
            }
            encordado = encontrado
        }
        var capo = 0
        switch argumentos.quitarOpcion("--capo") {
        case .ausente: break
        case .sinValor: return uso(.capoFueraDeRango, notacion)
        case .valor(let texto):
            guard let n = Int(texto), (0...12).contains(n) else { return uso(.capoFueraDeRango, notacion) }
            capo = n
        }
        var secuencia: SecuenciaDeEscala?
        switch argumentos.quitarOpcion("--secuencia", "--sequence") {
        case .ausente: break
        case .sinValor(let nombre): return uso(.faltaValor(nombre), notacion)
        case .valor(let texto):
            guard let elegida = secuenciaDeEscala(texto) else { return uso(.secuenciaDesconocida(texto), notacion) }
            secuencia = elegida
        }
        if let desconocida = argumentos.opcionDesconocida {
            return uso(.opcionDesconocida(desconocida), notacion)
        }
        let mastil = Mastil(encordado.conCapo(capo), trastes: 15)
        if arpegio {
            guard !argumentos.restantes.isEmpty else { return uso(.faltaCifradoDelArpegio, notacion) }
            let reparto: FormasDeArpegio = barrido ? .unaNotaPorCuerda : caged ? .caged : .porPosiciones
            return arpegioEnElMastil(
                try Acorde(leyendo: argumentos.unidos), formas: reparto, idaYVuelta: idaYVuelta, en: mastil, notacion)
        }
        guard !argumentos.restantes.isEmpty else { return uso(.faltaEscalaDePosiciones, notacion) }
        let escala = try Escala(leyendo: argumentos.unidos)
        if formas { return formasPentatonicas(de: escala, en: mastil, notacion) }
        if let secuencia {
            return secuenciaEnLasPosiciones(escala, secuencia, caged: caged, bajando: bajando, en: mastil, notacion)
        }
        let porCuerda = escala.notas.count >= 6 ? 3 : 2
        let sistema = caged ? "CAGED" : notacion.texto { $0.notasPorCuerda(porCuerda) }
        var lineas = [escala.nombre(en: notacion) + " · " + sistema + instrumento(de: mastil, notacion)]
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        let cuerdas = mastil.encordado.cuerdas
        let nombres = cuerdas.map { $0.nota.nombre(en: notacion) }
        let ancho = nombres.map(\.count).max() ?? 0
        for posicion in posiciones {
            let franja = posicion.trastes
            let trastes = notacion.texto { $0.trastes(franja.lowerBound, franja.upperBound) }
            lineas.append("")
            let nombreDeLaForma =
                posicion.forma.map { forma in notacion.texto { $0.forma(forma.rawValue) } + " · " } ?? ""
            lineas.append("  " + nombreDeLaForma + trastes)
            for cuerda in cuerdas.indices.reversed() {
                let usados = posicion.posiciones.filter { $0.cuerda == cuerda }.map(\.traste)
                let celdas = usados.map { traste -> String in
                    String(repeating: "-", count: max(0, 2 - String(traste).count)) + String(traste)
                }
                let nombre = nombres[cuerda].padding(hasta: ancho + 1)
                lineas.append("    " + nombre + "|-" + celdas.joined(separator: "-") + "-")
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `posiciones La pentatónica menor --formas`: las cinco formas, cada una con su tablatura y las notas que
    /// comparte con la siguiente.
    static func formasPentatonicas(de escala: Escala, en mastil: Mastil, _ notacion: Notacion) -> ResultadoDeOrden {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(de: escala, mastil: mastil, notacion: notacion)
        guard !formas.isEmpty else { return uso(.noEsPentatonica, notacion) }
        let titulo = notacion.texto(\.formasDeLaPentatonica) + instrumento(de: mastil, notacion)
        var lineas = [escala.nombre(en: notacion) + " · " + titulo]
        for forma in formas {
            lineas += ["", "  " + forma.titulo] + forma.tablatura.map { "    " + $0 } + ["    " + forma.comunes]
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `posiciones Do mayor --secuencia terceras [--caged] [--bajando]`: la secuencia tocada en cada posición, sin
    /// salir de ella, en tablatura.
    static func secuenciaEnLasPosiciones(
        _ escala: Escala, _ secuencia: SecuenciaDeEscala, caged: Bool, bajando: Bool, en mastil: Mastil,
        _ notacion: Notacion
    ) -> ResultadoDeOrden {
        let posiciones = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            escala, secuencia, caged: caged, sentido: bajando ? .descendente : .ascendente, mastil: mastil,
            notacion: notacion)
        let titulo = notacion.texto(\.secuencia) + " " + secuencia.nombre(en: notacion)
        var lineas = [escala.nombre(en: notacion) + " · " + titulo + instrumento(de: mastil, notacion)]
        for posicion in posiciones where !posicion.notas.isEmpty {
            lineas += ["", "  " + posicion.titulo] + posicion.tablatura.map { "    " + $0 }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `posiciones --arpegio Sol7 [--caged | --barrido] [--ida-y-vuelta]`: el arpegio del acorde en cada posición
    /// del mástil, en tablatura y con los dedos que pisan cada nota.
    static func arpegioEnElMastil(
        _ acorde: Acorde, formas: FormasDeArpegio, idaYVuelta: Bool, en mastil: Mastil, _ notacion: Notacion
    ) -> ResultadoDeOrden {
        let arpegios = PresentacionDeArpegios.enElMastil(
            acorde, formas: formas, idaYVuelta: idaYVuelta, mastil: mastil, notacion: notacion)
        let sistema: String
        switch formas {
        case .porPosiciones: sistema = notacion.texto(\.porPosiciones)
        case .caged: sistema = "CAGED"
        case .unaNotaPorCuerda: sistema = notacion.texto { $0.notasPorCuerda(1) }
        }
        let titulo = notacion.texto(\.arpegioEnElMastil) + " · " + sistema + instrumento(de: mastil, notacion)
        var lineas = [acorde.cifrado(en: notacion) + " · " + titulo]
        for presentado in arpegios {
            lineas += ["", "  " + presentado.titulo] + presentado.tablatura.map { "    " + $0 }
            lineas.append("    " + notacion.texto(\.dedosSugeridos) + ": " + presentado.dedos)
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// « · bajo», « · guitarra · Capo en el traste 2»; vacío en la guitarra sin capo.
    static func instrumento(de mastil: Mastil, _ notacion: Notacion) -> String {
        let encordado = mastil.encordado
        guard encordado != .guitarra else { return "" }
        var texto = " · " + encordado.nombre(en: notacion)
        if encordado.capo > 0 { texto += " · " + notacion.texto { $0.capo(encordado.capo) } }
        return texto
    }
}
