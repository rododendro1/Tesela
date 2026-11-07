import Armonia
import Exposicion
import Foundation

// MARK: - Digitaciones: cómo tocar un acorde en un instrumento de cuerda con trastes

extension LineaDeComandos {
    /// Lo que pide `digitaciones`: el instrumento, los límites de las formas y los acordes, para el texto y para
    /// `--json`.
    struct PedidoDeDigitaciones {
        var conDiagrama: Bool
        var completo: Bool
        var comoMusicXML: Bool
        var encordado: Encordado
        var limite: Int
        var maximoDeDedos: Int
        var maximoTraste: Int
        var capo: Int
        /// Los cifrados, tal como se han escrito.
        var acordes: [String]

        var mastil: Mastil { Mastil(encordado.conCapo(capo), numeroDeTrastes: 24 - capo) }

        /// Las formas de un acorde, de la más cómoda a la menos, como mucho `limite`.
        func formas(de acorde: Acorde, limite: Int? = nil) -> [Digitacion] {
            mastil.digitaciones(
                de: acorde, maximoDeDedos: maximoDeDedos, maximoTraste: maximoTraste, exigirQuinta: completo,
                limite: limite ?? self.limite)
        }
    }

    /// Lee las opciones y los acordes de `digitaciones`, o lanza el `ErrorDeUso` de lo que está mal escrito.
    static func pedidoDeDigitaciones(_ argumentos: [String]) throws -> PedidoDeDigitaciones {
        var argumentos = Argumentos(argumentos)

        // `--tab` era el nombre anterior de `--diagrama`.
        let conDiagrama = argumentos.quitarMarca(.diagrama)
        // Por defecto la quinta puede faltar en los acordes de cuatro notas o más (el Do7 `x32310`): es lo normal en
        // una guitarra. Con --completo se exigen todas las notas.
        let completo = argumentos.quitarMarca(.completo)
        // La primera forma de cada acorde como tablatura MusicXML, en lugar del texto.
        let comoMusicXML = argumentos.quitarMarca(.musicxml)

        var encordado = Encordado.guitarra
        if let nombre = try argumentos.valor(.instrumento, siFalta: .faltaInstrumento) {
            guard let encontrado = try? Encordado(leyendo: nombre) else {
                throw ErrorDeUso.instrumentoDesconocido(nombre)
            }
            encordado = encontrado
        }

        var limite = 5
        if let texto = try argumentos.valor(.limite, siFalta: .faltaLimite) {
            guard let n = Int(texto), (1...200).contains(n) else {
                throw ErrorDeUso.limiteFueraDeRango
            }
            limite = n
        }

        var maximoDeDedos = 4
        if let texto = try argumentos.valor(.dedosDeLaDigitacion, siFalta: .faltanDedos) {
            guard let n = Int(texto), (1...4).contains(n) else {
                throw ErrorDeUso.dedosFueraDeRango
            }
            maximoDeDedos = n
        }

        var maximoTraste = 12
        if let texto = try argumentos.valor(.traste, siFalta: .faltaTraste) {
            guard let n = Int(texto), (0...24).contains(n) else {
                throw ErrorDeUso.trasteFueraDeRango
            }
            maximoTraste = n
        }

        // Con capo, los trastes se cuentan desde él.
        var capo = 0
        if let texto = try argumentos.valor(.capo, siFalta: .capoFueraDeRango) {
            guard let n = Int(texto), (0...12).contains(n) else { throw ErrorDeUso.capoFueraDeRango }
            capo = n
        }

        if let desconocida = argumentos.opcionDesconocida {
            throw ErrorDeUso.opcionDesconocida(desconocida)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifradoDeDigitaciones }

        return PedidoDeDigitaciones(
            conDiagrama: conDiagrama, completo: completo, comoMusicXML: comoMusicXML, encordado: encordado,
            limite: limite, maximoDeDedos: maximoDeDedos, maximoTraste: maximoTraste, capo: capo,
            acordes: argumentos.restantes)
    }

    /// `digitaciones Sol7/Si --instrumento ukelele`: formas de tocar el acorde, de la más cómoda a la menos.
    static func digitaciones(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let pedido = try pedidoDeDigitaciones(argumentos)
        let acordes = try pedido.acordes.map { try Acorde(leyendoEnLaOrden: $0) }
        if pedido.comoMusicXML {
            var formas: [Digitacion] = []
            var conForma: [Acorde] = []
            for acorde in acordes {
                guard let forma = pedido.formas(de: acorde, limite: 1).first else { continue }
                formas.append(forma)
                conForma.append(acorde)
            }
            let titulo = conForma.map { $0.cifrado(en: notacion) }.joined(separator: " ")
            let xml = PresentacionDeTablatura.musicXML(
                digitaciones: formas, acordes: conForma, titulo: titulo, en: notacion)
            return bien(xml.trimmingCharacters(in: "\n"))
        }
        // «Do · guitarra», y con capo, «Do · guitarra · Capo en el traste 2».
        var instrumento = Mensaje.instrumento(pedido.encordado).texto(en: notacion)
        if pedido.capo > 0 { instrumento += " · " + notacion.texto { $0.capo(pedido.capo) } }
        let bloques = acordes.map { acorde -> String in
            var lineas = ["\(acorde.cifrado(en: notacion)) · \(instrumento)"]
            let formas = pedido.formas(de: acorde)
            guard !formas.isEmpty else {
                lineas.append("  " + Mensaje.sinDigitaciones.texto(en: notacion))
                return lineas.joined(separator: "\n")
            }
            for forma in formas {
                let notas = forma.notas(para: acorde).map { $0.nombre(en: notacion) }.joined(separator: " ")
                lineas.append(
                    "  " + forma.tablatura.padding(hasta: 17) + notas.padding(hasta: 18)
                        + descripcion(de: forma, notacion))
                if pedido.conDiagrama { lineas += diagrama(de: forma, notacion) }
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
        let cuerdas = forma.mastil.encordado.afinacion
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
        let caged = argumentos.quitarMarca(.caged)
        let bajando = argumentos.quitarMarca(.bajando)
        let formas = argumentos.quitarMarca(.formas)
        let arpegio = argumentos.quitarMarca(.arpegio)
        let barrido = argumentos.quitarMarca(.barrido)
        let idaYVuelta = argumentos.quitarMarca(.idaYVuelta)
        let mastil = try mastilDeLasPosiciones(&argumentos)
        var secuencia: SecuenciaDeEscala?
        if let texto = try argumentos.valor(.secuencia) {
            guard let elegida = secuenciaDeEscala(texto) else { throw ErrorDeUso.secuenciaDesconocida(texto) }
            secuencia = elegida
        }
        if let desconocida = argumentos.opcionDesconocida {
            throw ErrorDeUso.opcionDesconocida(desconocida)
        }
        if arpegio {
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaCifradoDelArpegio }
            let reparto: FormasDeArpegio = barrido ? .unaNotaPorCuerda : caged ? .caged : .porPosiciones
            return arpegioEnElMastil(
                try Acorde(leyendoEnLaOrden: argumentos.unidos), formas: reparto, idaYVuelta: idaYVuelta, en: mastil,
                notacion)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDePosiciones }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
        if formas { return try formasPentatonicas(de: escala, en: mastil, notacion) }
        if let secuencia {
            return secuenciaEnLasPosiciones(escala, secuencia, caged: caged, bajando: bajando, en: mastil, notacion)
        }
        let porCuerda = escala.notas.count >= 6 ? 3 : 2
        let sistema = caged ? "CAGED" : notacion.texto { $0.notasPorCuerda(porCuerda) }
        var lineas = [escala.nombre(en: notacion) + " · " + sistema + instrumento(de: mastil, notacion)]
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        let cuerdas = mastil.encordado.afinacion
        let nombres = cuerdas.map { $0.nota.nombre(en: notacion) }
        let ancho = nombres.map(\.count).max() ?? 0
        for posicion in posiciones {
            let franja = posicion.rangoDeTrastes
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

    /// El mástil de `posiciones`: el de `--instrumento` (la guitarra, si no) con el capo de `--capo`, en 15 trastes.
    static func mastilDeLasPosiciones(_ argumentos: inout Argumentos) throws -> Mastil {
        var encordado = Encordado.guitarra
        if let nombre = try argumentos.valor(.instrumento, siFalta: .faltaInstrumento) {
            guard let encontrado = try? Encordado(leyendo: nombre) else {
                throw ErrorDeUso.instrumentoDesconocido(nombre)
            }
            encordado = encontrado
        }
        var capo = 0
        if let texto = try argumentos.valor(.capo, siFalta: .capoFueraDeRango) {
            guard let n = Int(texto), (0...12).contains(n) else { throw ErrorDeUso.capoFueraDeRango }
            capo = n
        }
        return Mastil(encordado.conCapo(capo), numeroDeTrastes: 15)
    }

    /// `posiciones La pentatónica menor --formas`: las cinco formas, cada una con su tablatura y las notas que
    /// comparte con la siguiente.
    static func formasPentatonicas(de escala: Escala, en mastil: Mastil, _ notacion: Notacion)
        throws -> ResultadoDeOrden
    {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(de: escala, mastil: mastil, en: notacion)
        guard !formas.isEmpty else { throw ErrorDeUso.noEsPentatonica }
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
            en: notacion)
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
            acorde, formas: formas, idaYVuelta: idaYVuelta, mastil: mastil, en: notacion)
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
