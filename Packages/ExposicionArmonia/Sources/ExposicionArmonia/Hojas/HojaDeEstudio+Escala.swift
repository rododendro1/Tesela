import Armonia

/// Una parte de la hoja de estudio de una escala, para elegir cuáles lleva: el nombre y las notas van siempre.
public enum SeccionDeLaHoja: String, CaseIterable, Hashable, Sendable {
    case pentagrama, estadisticas, reloj, teclados, mastil, secuencias, acordes, escalera

    /// Su título, en la notación: «Pentagrama», «Reloj de la escala», «Digitación de piano»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .pentagrama: notacion.texto(\.pentagrama)
        case .estadisticas: notacion.texto(\.estadisticas)
        case .reloj: notacion.texto(\.relojDeLaEscala)
        case .teclados: notacion.texto(\.digitacionDePiano)
        case .mastil: notacion.texto(\.posicionesEnElMastil)
        case .secuencias: notacion.texto(\.secuencias)
        case .acordes: notacion.texto(\.acordesDeLaEscala)
        case .escalera: notacion.texto(\.escaleraDeBrillo)
        }
    }
}

extension HojaDeEstudio {
    // MARK: Una escala

    /// La hoja de una escala: su nombre, sus notas y sus nombres originales, el pentagrama, su origen y su carácter,
    /// las estadísticas con el reloj al lado (y, si la escala tiene microtonos, el círculo de su afinación), el
    /// teclado de piano con los dedos de cada mano, la escala en el mástil de `mastil` (entero y por posiciones), las
    /// secuencias de estudio, los acordes de sus grados y la escalera de brillo, o solo las `secciones` que se pidan
    /// (el origen y el carácter van con las estadísticas). `armonia hoja Do mayor` la escribe y `armonia grabar hoja
    /// Do mayor` la pasa a PDF.
    ///
    ///     let hoja = HojaDeEstudio.escala(Escala(.re, .dorico), en: .compacta(.espanol))
    ///     hoja.hasPrefix("<svg")   // true
    public static func escala(
        _ escala: Escala, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases),
        mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15), en notacion: Notacion, formato: Formato = .svg
    ) -> String {
        typealias Estudio = PresentacionDeEstudioDeEscala
        let presentada = EscalaPresentada(escala, en: notacion)
        /// Las piezas de una sección, si se pide.
        func si(_ seccion: SeccionDeLaHoja, _ piezas: () -> [HojaCompuesta.Pieza]) -> [HojaCompuesta.Pieza] {
            secciones.contains(seccion) ? piezas() : []
        }
        func seccion(
            _ cual: SeccionDeLaHoja, alLado: [HojaCompuesta.Seccion] = [], _ piezas: () -> [HojaCompuesta.Pieza]
        ) -> HojaCompuesta.Seccion {
            .init(
                titulo: cual.nombre(en: notacion), piezas: si(cual, piezas), clase: "seccion-" + cual.rawValue,
                alLado: alLado)
        }
        let reloj = seccion(.reloj) {
            [.dibujo(Estudio.reloj(de: escala, en: notacion), fraccion: 1)]
                + (Estudio.relojDeLaAfinacionPropia(de: escala, en: notacion).map { [.dibujo($0, fraccion: 1)] } ?? [])
        }
        let peldanos = Estudio.escaleraDeBrillo(de: escala, en: notacion)
        let hoja = HojaCompuesta(
            titulo: escala.nombre(en: notacion), notas: escala.notas.map { $0.nombre(en: notacion) },
            originales: presentada.nombresOriginales ?? [],
            secciones: [
                seccion(.pentagrama) { [.dibujo(PentagramaPresentado(escala, en: notacion).svg, fraccion: 1)] },
                .init(
                    titulo: notacion.texto(\.origen),
                    piezas: si(.estadisticas) {
                        [.datos(OrigenDeEscalaPresentado(escala.tipo, en: notacion)?.datos(en: notacion) ?? [])]
                    }, clase: "seccion-origen"),
                .init(
                    titulo: notacion.texto(\.caracterDeLaFuente),
                    piezas: si(.estadisticas) {
                        [
                            .caracter(
                                escala.tipo.caracter, medidas: escala.tipo.medidasDelAfecto,
                                sonoridad: escala.tipo.sonoridad)
                        ]
                    }, clase: "seccion-caracter"),
                // Las estadísticas, con el reloj al lado.
                seccion(.estadisticas, alLado: [reloj]) { [.datos(Estudio.estadisticas(de: escala, en: notacion))] },
                seccion(.teclados) {
                    [
                        .dibujos(
                            Mano.allCases.map { ("", Estudio.teclado(de: escala, mano: $0, en: notacion)) }, porFila: 2)
                    ]
                },
                // El mástil entero, de lado a lado, y debajo cada posición, de dos en dos.
                seccion(.mastil) {
                    let dibujos = Estudio.mastilDeLaHoja(de: escala, mastil: mastil, en: notacion)
                    return [
                        .dibujos(Array(dibujos.prefix(1)), porFila: 1),
                        .dibujos(Array(dibujos.dropFirst()), porFila: 2),
                    ]
                },
                seccion(.secuencias) {
                    Estudio.secuenciasDeLaHoja(de: escala, en: notacion).flatMap { secuencia in
                        [
                            .subtitulo(secuencia.titulo), .apartes([secuencia.notas]),
                            .dibujo(secuencia.pentagrama.svg, fraccion: 1),
                        ]
                    }
                },
                seccion(.acordes) {
                    let acordes = presentada.acordes ?? []
                    return [
                        .lista(
                            acordes.map { .init(etiqueta: $0.grado, texto: $0.cifrado) }, porFila: 4, clase: "acordes")
                    ]
                },
                // La escalera de brillo, de la más oscura a la más brillante, con la de partida resaltada.
                seccion(.escalera) {
                    guard peldanos.count > 1 else { return [] }
                    let elementos = peldanos.map {
                        HojaCompuesta.Elemento(etiqueta: $0.brillo, texto: $0.nombre, resaltado: $0.esLaDePartida)
                    }
                    return [.lista(elementos, porFila: 3, clase: "escalera")]
                },
            ])
        return escribir(hoja, formato, notacion)
    }

    // MARK: Dos escalas comparadas

    /// Dos escalas comparadas nota a nota: los dos pentagramas, una tabla grado a grado con los grados que cambian
    /// resaltados, un reloj con las dos escalas encima y la leyenda de lo común y lo distinto. Lo común va en azul; lo
    /// que solo está en la primera, en verde; lo de la segunda, en rojo. `armonia hoja Do mayor --comparar Do dórico`
    /// la escribe.
    ///
    ///     let hoja = HojaDeEstudio.comparacion(Escala(.do), con: Escala(.do, .dorico), en: .compacta(.espanol))
    ///     hoja.contains(">Do mayor → Do dórico</text>")   // true
    public static func comparacion(
        _ escala: Escala, con otra: Escala, en notacion: Notacion, formato: Formato = .svg
    ) -> String {
        formato == .svg
            ? PresentacionDeEstudioDeEscala.comparacionSVG(escala, con: otra, en: notacion)
            : PresentacionDeEstudioDeEscala.comparacionHTML(escala, con: otra, en: notacion)
    }

    // MARK: El tamaño de una hoja

    /// El ancho y el alto de una hoja (o de cualquier SVG) por su `viewBox`, para mostrarla con su proporción; `nil`
    /// si no lo tiene.
    ///
    ///     HojaDeEstudio.tamano(deUnSVG: "<svg viewBox=\"0 0 595 800\"></svg>")?.alto   // 800
    public static func tamano(deUnSVG svg: String) -> (ancho: Double, alto: Double)? {
        Hoja.cajaDeVision(svg).map { ($0.ancho, $0.alto) }
    }
}
