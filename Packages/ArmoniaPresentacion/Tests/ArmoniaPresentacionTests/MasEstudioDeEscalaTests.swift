import Armonia
import Testing

@testable import ArmoniaPresentacion

// Buscar escalas por sus notas, la simetría, las líneas de notas guía, el mástil y el teclado de piano.
@Suite struct MasEstudioDeEscalaTests {
    let notacion = Notacion.espanolCompacto

    @Test func buscarEscalasPorSusNotas() throws {
        let notas: [Nota] = [.do, .mi, .sol, .si, try Nota(leyendo: "Fa#")]
        let escalas = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, notacion: notacion)
        #expect(escalas.count == 10)
        let primera = try #require(escalas.first)
        #expect(primera.nombre == "Do pentatónica lidia")
        #expect(primera.ademas == "")
        #expect(escalas.contains { $0.ademas == "además: Re, La" })
        let dos = PresentacionDeEstudioDeEscala.escalas(conLasNotas: notas, limite: 2, notacion: .inglesASCII)
        #expect(dos.count == 2)
        // Sin ortografía, de un mástil: Fa♯ en el teclado, 78 en MIDI.
        let deClases = PresentacionDeEstudioDeEscala.escalas(conLasClases: [60, 64, 67, 71, 78], notacion: notacion)
        #expect(deClases.first?.nombre == "Do pentatónica lidia")
        // De una pieza: Re Mi Fa Sol La Si Do Re, en Re menor.
        let notasDeLaPieza = [62, 64, 65, 67, 69, 71, 72, 74].enumerated().map { i, midi in
            NotaDeLaPieza(altura: Altura(midi: midi), inicio: .negra * i, duracion: .negra)
        }
        let pieza = PiezaImportada(tonalidad: Tonalidad(.re, .menor), notas: notasDeLaPieza)
        let deLaPieza = PresentacionDeEstudioDeEscala.escalas(de: pieza, notacion: notacion)
        #expect(deLaPieza.first?.nombre == "Re dórico")
        #expect(deLaPieza.first?.sonido.notas.isEmpty == false)
    }

    @Test func simetria() throws {
        let tonosEnteros = try #require(
            PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .tonosEnteros), notacion: notacion))
        #expect(tonosEnteros.resumen == "Se repite cada 2 semitonos: 2 transposiciones distintas")
        #expect(tonosEnteros.tonicas.hasPrefix("Do, Re, Mi"))
        #expect(tonosEnteros.ciclos.count == 2)
        let disminuida = try #require(
            PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .disminuidaSemitonoTono), notacion: notacion))
        #expect(disminuida.tonicas == "Do, Mi♭, Fa♯, La")
        #expect(disminuida.ciclos.contains { $0.detalle == "Do7 · Mi♭7 · Fa♯7 · La7" })
        #expect(PresentacionDeEstudioDeEscala.simetria(de: Escala(.do), notacion: notacion) == nil)
        #expect(PresentacionDeEstudioDeEscala.simetria(de: Escala(.do, .cromatica), notacion: notacion) == nil)
    }

    @Test func estadisticas() {
        let mayor = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do), notacion: notacion)
        #expect(
            mayor.map(\.nombre) == [
                "Número de notas", "Brillo", "Brillo por quintas", "Pasos en semitonos", "Vector interválico",
                "Número de Forte", "Transposiciones distintas", "Rasgos",
            ])
        #expect(
            mayor.map(\.valor) == [
                "7 (heptatónica)", "0", "+2", "2 2 1 2 2 2 1", "[2, 5, 4, 3, 6, 1]", "7-35", "12",
                "máximamente regular",
            ])
        // La pentatónica menor: sin brillo de siete notas, más oscura que la mayor y sin semitonos.
        let pentatonica = PresentacionDeEstudioDeEscala.estadisticas(
            de: Escala(.la, .pentatonicaMenor), notacion: notacion)
        #expect(!pentatonica.map(\.nombre).contains("Brillo"))
        #expect(pentatonica.first?.valor == "5 (pentatónica)")
        #expect(pentatonica.contains { $0.nombre == "Brillo por quintas" && $0.valor == "-1" })
        #expect(pentatonica.last?.valor == "anhemitónica (sin semitonos) · máximamente regular")
        let tonosEnteros = PresentacionDeEstudioDeEscala.estadisticas(
            de: Escala(.do, .tonosEnteros), notacion: notacion)
        #expect(tonosEnteros.contains { $0.nombre == "Transposiciones distintas" && $0.valor == "2" })
        let ingles = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do), notacion: .inglesASCII)
        #expect(ingles.first == DatoDeEscalaPresentado(nombre: "Number of notes", valor: "7 (heptatonic)"))
        #expect(PresentacionDeEstudioDeEscala.conSigno(3) == "+3")
        #expect(PresentacionDeEstudioDeEscala.conSigno(-3) == "-3")
        #expect(PresentacionDeEstudioDeEscala.conSigno(0.4286) == "+0.43")
        #expect(PresentacionDeEstudioDeEscala.conSigno(-0.001) == "0")
    }

    @Test func tablaDeEstadisticas() {
        let tabla = PresentacionDeEstudioDeEscala.tablaDeEstadisticas(
            [Escala(.do), Escala(.do, .lidio)], notacion: notacion)
        #expect(tabla.encabezados.count == 7)
        #expect(tabla.filas.count == 2)
        #expect(tabla.filas[0][0] == "Do mayor")
        #expect(tabla.filas[0][2] == "+2")
        #expect(tabla.filas[1][2] == "+3")
        #expect(tabla.filas[0][5] == "7-35")
        #expect(tabla.filas.allSatisfy { $0.count == tabla.encabezados.count })
    }

    @Test func escaleraDeBrillo() throws {
        let escalera = PresentacionDeEstudioDeEscala.escaleraDeBrillo(de: Escala(.do), notacion: notacion)
        let mayor = try #require(escalera.firstIndex { $0.esLaDePartida })
        #expect(escalera[mayor].nombre == "Do mayor")
        #expect(escalera[mayor].brillo == "+2")
        #expect(escalera[mayor + 1].nombre == "Do lidio")
        #expect(escalera[mayor + 1].cambio == "Fa → Fa♯")
        #expect(escalera[mayor - 1].nombre == "Do mixolidio")
        #expect(escalera[mayor].cambio == "Si♭ → Si")
        #expect(escalera.first?.cambio == "")
        #expect(escalera.filter(\.esLaDePartida).count == 1)
    }

    @Test func hojaDeEstudio() {
        let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudio(de: Escala(.re, .dorico), notacion: notacion)
        #expect(hoja.hasPrefix("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"595\""))
        #expect(hoja.hasSuffix("</svg>"))
        #expect(hoja.contains(">Re dórico</text>"))
        #expect(hoja.contains(">Estadísticas</text>"))
        #expect(hoja.contains(">Escalera de brillo</text>"))
        #expect(hoja.contains(">Brillo por quintas: 0</text>"))
        // El pentagrama, el reloj y los dos teclados, dentro, cada uno con su viewBox.
        #expect(hoja.components(separatedBy: "<svg x=").count - 1 == 4)
        #expect(hoja.components(separatedBy: "<svg").count == hoja.components(separatedBy: "</svg>").count)
        // Sin acordes de los grados si la escala no los forma.
        let cromatica = PresentacionDeEstudioDeEscala.hojaDeEstudio(de: Escala(.do, .cromatica), notacion: notacion)
        #expect(!cromatica.contains(">Acordes de la escala</text>"))
        var cuerpo: [String] = []
        #expect(PresentacionDeEstudioDeEscala.incrustar("<svg/>", x: 0, y: 0, ancho: 10, en: &cuerpo) == 0)
        #expect(cuerpo.isEmpty)
    }

    /// La hoja con solo algunas secciones: sin las que no se piden, y más corta.
    @Test func hojaDeEstudioConSecciones() throws {
        let entera = PresentacionDeEstudioDeEscala.hojaDeEstudio(de: Escala(.do), notacion: notacion)
        let corta = PresentacionDeEstudioDeEscala.hojaDeEstudio(
            de: Escala(.do), notacion: notacion, secciones: [.reloj, .acordes])
        #expect(corta.contains(">Do mayor</text>"))
        #expect(!corta.contains(">Estadísticas</text>"))
        #expect(!corta.contains(">Escalera de brillo</text>"))
        #expect(corta.contains(">Acordes de la escala</text>"))
        // Solo el reloj, dentro, y a la izquierda.
        #expect(corta.components(separatedBy: "<svg x=").count - 1 == 1)
        #expect(corta.contains("<svg x=\"40\" y="))
        let altoEntera = try #require(PresentacionDeEstudioDeEscala.tamano(deUnSVG: entera)?.alto)
        let altoCorta = try #require(PresentacionDeEstudioDeEscala.tamano(deUnSVG: corta)?.alto)
        #expect(altoCorta < altoEntera)
        let soloElNombre = PresentacionDeEstudioDeEscala.hojaDeEstudio(
            de: Escala(.do), notacion: notacion, secciones: [])
        #expect(!soloElNombre.contains("<svg x="))
        #expect(SeccionDeLaHoja.teclados.nombre(en: notacion) == "Digitación de piano")
        #expect(PresentacionDeEstudioDeEscala.tamano(deUnSVG: "<svg/>") == nil)
    }

    /// El mapa de brillo en SVG: el título con la tónica, una caja por escala y la resaltada en otro color.
    @Test func mapaDeBrillo() {
        let mapa = PresentacionDeEstudioDeEscala.mapaDeBrillo(notacion: notacion)
        #expect(mapa.hasPrefix("<svg xmlns="))
        #expect(mapa.contains(">Mapa de brillo · Do</text>"))
        #expect(mapa.contains(">lidio</text>"), Comment(rawValue: String(mapa.prefix(600))))
        #expect(mapa.contains(">+3</text>") && mapa.contains(">-3</text>"))
        #expect(mapa.contains("<title>Fa → Fa♯</title>"))
        #expect(!mapa.contains("#ffe8a3"))
        let cajas = mapa.components(separatedBy: "<rect x=").count - 1
        #expect(cajas == Escala.mapaDeBrillo().escalas.count)
        let dorico = PresentacionDeEstudioDeEscala.mapaDeBrillo(resaltada: Escala(.re, .dorico), notacion: notacion)
        #expect(dorico.contains(">Mapa de brillo · Re</text>"))
        #expect(dorico.components(separatedBy: "#ffe8a3").count - 1 == 1)
    }

    @Test func lineasDeNotasGuia() {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            acordes, tonalidad: Tonalidad(.do), notacion: notacion)
        #expect(lineas.map(\.titulo) == ["Desde la tercera", "Desde la séptima"])
        #expect(lineas.map(\.notas) == ["Fa₄ Fa₄ Mi₄", "Do₄ Si₃ Si₃"])
        #expect(lineas[0].ficheros.count == 6)
        #expect(lineas[0].sonido.notas.count == 3)
        let sinTonalidad = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(acordes, notacion: .inglesASCII)
        #expect(sinTonalidad.map(\.titulo) == ["From the third", "From the seventh"])
        #expect(PresentacionDeEstudioDeEscala.lineasDeNotasGuia([], notacion: notacion).isEmpty)
    }

    @Test func formasDeLaPentatonica() {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(
            de: Escala(.la, .pentatonicaMenor), notacion: notacion)
        #expect(formas.count == 5)
        #expect(formas[0].titulo == "Forma 1 · Trastes 5–8")
        #expect(formas[0].comunes == "comparte con la forma 2: 6:8 5:7 4:7 3:7 2:8 1:8")
        #expect(formas[4].comunes.hasPrefix("comparte con la forma 1: "))
        #expect(formas[0].tablatura.count == 6)
        #expect(formas[0].tablatura.last == "Mi |--5--8-------------------------------")
        #expect(formas[0].fichero.nombre.hasPrefix("Forma 1"))
        #expect(formas[0].sonido.notas.count == 12)
        #expect(PresentacionDeEstudioDeEscala.formasPentatonicas(de: Escala(.do), notacion: notacion).isEmpty)
    }

    @Test func secuenciaEnLasPosiciones() {
        let caged = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            Escala(.do), .terceras, caged: true, notacion: notacion)
        #expect(caged.count == 5)
        #expect(caged[0].titulo == "Forma C · Trastes 0–4")
        #expect(caged[0].comunes.isEmpty)
        #expect(caged[0].notas.count == caged[0].sonido.notas.count)
        let porCuerda = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            Escala(.do), .gruposDeTres, caged: false, sentido: .descendente, notacion: .inglesASCII)
        #expect(porCuerda.count >= 6)
        #expect(porCuerda[0].titulo == "Frets 0–5")
        #expect(porCuerda[0].notas.count == 48)
    }

    @Test func tablatura() {
        let mastil = Mastil(.guitarra)
        let notas = [PosicionEnElMastil(cuerda: 2, traste: 0), PosicionEnElMastil(cuerda: 3, traste: 12)]
        let lineas = PresentacionDeEstudioDeEscala.tablatura(notas, en: mastil, notacion: notacion)
        #expect(lineas.count == 6)
        #expect(lineas[2] == "Sol|----12-")
        #expect(lineas[3] == "Re |--0----")
    }

    @Test func teclado() {
        let doMayor = PresentacionDeEstudioDeEscala.teclado(de: Escala(.do), notacion: notacion)
        #expect(doMayor.contains("<title>Do mayor</title>"))
        #expect(doMayor.contains(">Sol</text>"))
        #expect(doMayor.components(separatedBy: "<circle").count - 1 == 8)
        let dosOctavas = PresentacionDeEstudioDeEscala.teclado(de: Escala(.do), octavas: 2, notacion: notacion)
        #expect(dosOctavas.components(separatedBy: "<circle").count - 1 == 15)
        let derecha = PresentacionDeEstudioDeEscala.teclado(de: Escala(.re), mano: .derecha, notacion: notacion)
        #expect(derecha.contains("<title>Re mayor · Mano derecha</title>"))
        #expect(derecha.contains(">5</text>"))
        let izquierda = PresentacionDeEstudioDeEscala.teclado(
            de: Escala(.re), mano: .izquierda, octavas: 2, notacion: .inglesASCII)
        #expect(izquierda.contains("Left hand"))
    }

    @Test func vecinas() {
        let vecinas = PresentacionDeEstudioDeEscala.vecinas(de: Escala(.do), notacion: notacion)
        #expect(vecinas.contains { $0.nombre == "Do lidio" && $0.detalle == "Fa → Fa♯" })
        #expect(vecinas.allSatisfy { !$0.sonido.notas.isEmpty })
    }

    @Test func reloj() {
        let cromatico = PresentacionDeEstudioDeEscala.reloj(de: Escala(.re), notacion: notacion)
        #expect(cromatico.contains("<title>Re mayor · Círculo cromático</title>"))
        #expect(cromatico.contains(">Fa♯</text>") && cromatico.contains(">Do♯</text>"))
        // Las que no son de la escala, con el nombre más sencillo.
        #expect(cromatico.contains(">Fa</text>"))
        let quintas = PresentacionDeEstudioDeEscala.reloj(de: Escala(.re), orden: .quintas, notacion: .inglesASCII)
        #expect(quintas.contains("Circle of fifths"))
    }

    @Test func enLasDoceTonalidades() {
        let hoja = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(Escala(.do), notacion: notacion)
        #expect(hoja.titulo == "Do mayor · En las doce tonalidades")
        #expect(hoja.tonalidades.count == 12)
        #expect(hoja.tonalidades.map(\.titulo).prefix(3) == ["Do mayor", "Sol mayor", "Re mayor"])
        #expect(hoja.tonalidades[0].notas.hasPrefix("Do₄ Re₄ Mi₄"))
        // Sol empieza en la octava 3, para no subir demasiado.
        #expect(hoja.tonalidades[1].notas.hasPrefix("Sol₃ La₃"))
        #expect(hoja.sonido.notas.count == 12 * 8)
        #expect(hoja.ficheros.count == 6)
        let terceras = PresentacionDeEstudioDeEscala.enLasDoceTonalidades(
            Escala(.do), secuencia: .terceras, notacion: notacion)
        #expect(terceras.titulo == "Do mayor por terceras · En las doce tonalidades")
        #expect(terceras.tonalidades[0].notas.hasPrefix("Do₄ Mi₄ Re₄ Fa₄"))
    }

    @Test func acordesEnLasDoceTonalidades() throws {
        let tabla = try #require(
            PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(Escala(.do), notacion: notacion))
        #expect(tabla.titulo == "Do mayor · Acordes en las doce tonalidades")
        #expect(tabla.grados.count == 7)
        #expect(tabla.grados[4] == "V7")
        #expect(tabla.filas.count == 12)
        #expect(tabla.filas.map(\.tonalidad).prefix(2) == ["Do mayor", "Sol mayor"])
        #expect(tabla.filas[1].acordes[4] == "Re7")
        #expect(tabla.filas.allSatisfy { $0.acordes.count == 7 })
        #expect(tabla.filas[0].sonido.notas.count == 7 * 4)
        #expect(tabla.sonido.notas.count == 12 * 7 * 4)
        #expect(tabla.ficheros.count == 6)
        let triadas = try #require(
            PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                Escala(.la, .menorArmonica), cuatriadas: false, notacion: notacion))
        #expect(triadas.grados.count == 7)
        #expect(triadas.sonido.notas.count == 12 * 7 * 3)
        #expect(triadas.filas[0].acordes[4] == "Mi")
        // Una pentatónica no forma un acorde en cada grado.
        #expect(
            PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(
                Escala(.do, .pentatonicaMayor), notacion: notacion) == nil)
    }
}

/// El arpegio de un acorde en el mástil, con su tablatura y sus dedos.
@Suite struct ArpegiosEnElMastilTests {
    let notacion = Notacion.espanolCompacto

    @Test func barrido() throws {
        let barrido = PresentacionDeArpegios.enElMastil(Acorde("Lam"), formas: .unaNotaPorCuerda, notacion: notacion)
        let primero = try #require(barrido.first)
        #expect(primero.dedos == "0 0 2 2 1 0")
        #expect(primero.notas.count == 6)
        #expect(primero.tablatura.count == 6)
        #expect(primero.tablatura[0].hasPrefix("Mi |") && primero.tablatura[0].hasSuffix("-0-"))
        #expect(primero.sonido.notas.count == 6)
        #expect(primero.fichero.formato == .musicXML)
        #expect(primero.fichero.nombre.hasPrefix("Lam · Trastes "))
        // Subiendo y bajando, sin repetir la nota de arriba.
        let idaYVuelta = PresentacionDeArpegios.enElMastil(
            Acorde("Lam"), formas: .unaNotaPorCuerda, idaYVuelta: true, notacion: notacion)
        #expect(idaYVuelta[0].dedos == "0 0 2 2 1 0 1 2 2 0 0")
        #expect(idaYVuelta[0].sonido.notas.count == 11)
    }

    @Test func formasYPosiciones() {
        let caged = PresentacionDeArpegios.enElMastil(Acorde("Do"), formas: .caged, notacion: notacion)
        #expect(caged.count == 5)
        #expect(caged[0].titulo.hasPrefix("Forma C · Trastes "), Comment(rawValue: caged[0].titulo))
        let posiciones = PresentacionDeArpegios.enElMastil(Acorde("Sol7"), notacion: notacion)
        #expect(!posiciones.isEmpty)
        #expect(posiciones.allSatisfy { $0.titulo.hasPrefix("Trastes ") && $0.arpegio.forma == nil })
        let bajo = PresentacionDeArpegios.enElMastil(
            Acorde("Do"), mastil: Mastil(.bajoElectrico, numeroDeTrastes: 12), notacion: notacion)
        #expect(bajo.allSatisfy { $0.tablatura.count == 4 })
        #expect(FormasDeArpegio.allCases.count == 3)
    }
}
