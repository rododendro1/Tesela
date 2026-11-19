import Armonia

extension HojaDeEstudio {
    // MARK: Un acorde

    /// La hoja de un acorde: el cifrado y sus notas, con el pentagrama a la derecha; sus otros nombres, sus
    /// disposiciones (cerrada, drop 2 y fundamental, tercera y séptima, las que tenga), el acorde en el teclado, las
    /// digitaciones más cómodas en el mástil de `mastil` (la guitarra, si no se da), las escalas compatibles con sus
    /// tensiones y las sustituciones. `armonia hoja acorde Sol7` la escribe.
    ///
    ///     let hoja = HojaDeEstudio.acorde(Acorde("Sol7"), en: .compacta(.espanol), formato: .html)
    ///     hoja.contains("<h1>Sol7</h1>")   // true
    public static func acorde(
        _ acorde: Acorde, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 12), en notacion: Notacion,
        formato: Formato = .svg
    ) -> String {
        typealias Relaciones = PresentacionDeRelacionesDeAcorde
        let datos = RelacionesPresentadas(acorde, notacion: notacion)
        var nombres: [String] = []
        if !datos.otrosNombres.isEmpty {
            nombres.append(
                notacion.texto(\.otrosNombres) + ": " + datos.otrosNombres.prefix(6).joined(separator: " · "))
        }
        if let sinFundamental = datos.sinFundamental {
            nombres.append(notacion.texto(\.sinLaFundamental) + ": " + sinFundamental)
        }
        // Las disposiciones: cada una con su nombre y todas sus inversiones en un pentagrama.
        let disposiciones = [DisposicionDeAcorde.cerrada, .drop2, .shell].flatMap { disposicion in
            PresentacionDeDisposiciones.acorde(acorde, disposicion, en: notacion).map {
                [
                    HojaCompuesta.Pieza.subtitulo(disposicion.nombre(en: notacion)),
                    .dibujo($0.pentagrama.svg, fraccion: 1),
                ]
            } ?? []
        }
        let formas = mastil.digitaciones(de: acorde, exigirQuinta: false, limite: 5)
        let escalas = PresentacionDeEscalaYAcorde.escalas(de: acorde, notacion: notacion).prefix(6).map {
            HojaCompuesta.Elemento(etiqueta: PresentacionDeEscalaYAcorde.nombreConMotivo($0), texto: $0.resumen)
        }
        let hoja = HojaCompuesta(
            titulo: acorde.cifrado(en: notacion),
            subtitulos: [acorde.notasDesdeElBajo.map { $0.nombre(en: notacion) }.joined(separator: " ")],
            dibujoDelEncabezado: PentagramaPresentado(acorde, en: notacion, nombresDeLasNotas: true).svg,
            secciones: [
                .init(titulo: "", piezas: [.lineas(nombres)]),
                .init(
                    titulo: notacion.texto(\.disposicion),
                    piezas: disposiciones),
                .init(
                    titulo: notacion.texto(\.teclado),
                    piezas: [.dibujo(Relaciones.teclado(de: acorde, en: notacion), fraccion: 0.5)]),
                .init(
                    titulo: notacion.texto(\.digitaciones) + " · " + mastil.encordado.nombre(en: notacion),
                    piezas: [.dibujos(formas.map { ("", Relaciones.diagramaSVG(de: $0)) }, porFila: 5)]),
                .init(
                    titulo: notacion.texto(\.escalasCompatibles), piezas: [.lista(escalas, porFila: 1, clase: nil)]),
                .init(
                    titulo: notacion.texto(\.sustituciones) + " · " + datos.tonalidad.nombre(en: notacion),
                    piezas: [.lineas(datos.sustituciones.prefix(8).map(\.descripcion))]),
            ])
        return escribir(hoja, formato, notacion)
    }
}
