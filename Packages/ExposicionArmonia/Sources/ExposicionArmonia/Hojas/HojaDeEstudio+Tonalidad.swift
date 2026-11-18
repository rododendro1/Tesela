import Armonia

extension HojaDeEstudio {
    // MARK: Una tonalidad

    /// La hoja de una tonalidad: la armadura y las relativas, el pentagrama de su escala, lo que dicen las fuentes de
    /// su carácter, los acordes de cada grado (cuatríadas) con su función, las cadencias típicas, las modulaciones a
    /// los tonos vecinos, las dominantes secundarias y los acordes prestados del modo homónimo. `armonia hoja
    /// tonalidad Re mayor` la escribe.
    ///
    ///     let hoja = HojaDeEstudio.tonalidad(Tonalidad(.re), en: .compacta(.espanol))
    ///     hoja.contains(">Re mayor</text>")   // true
    public static func tonalidad(_ tonalidad: Tonalidad, en notacion: Notacion, formato: Formato = .svg) -> String {
        typealias Presentacion = PresentacionDeTonalidad
        let acordes = tonalidad.acordesDeLosGrados(deNotas: 4).compactMap { $0 }
        let analizados = tonalidad.analizar(acordes).acordes
        let grados = acordes.enumerated().map { i, acorde in
            (
                grado: tonalidad.romano(grado: i + 1, deNotas: 4)?.description ?? "",
                acorde: acorde.cifrado(en: notacion),
                funcion: i < analizados.count ? analizados[i].funcion?.nombre(en: notacion) ?? "" : ""
            )
        }
        let modulaciones = PresentacionDeModulaciones.modulaciones(desde: tonalidad, en: notacion)
        let deFuera = Presentacion.acordesDeFuera(de: tonalidad, en: notacion).map { titulo, acordes in
            HojaCompuesta.Seccion(titulo: titulo, piezas: [.tabla(acordes.map { [$0.grados, $0.acordes] })])
        }
        let hoja = HojaCompuesta(
            titulo: tonalidad.nombre(en: notacion),
            subtitulos: [
                Presentacion.armadura(de: tonalidad, en: notacion), Presentacion.relativas(de: tonalidad, en: notacion),
            ],
            secciones: [
                .init(
                    titulo: "", piezas: [.dibujo(PentagramaPresentado(tonalidad.escala, en: notacion).svg, fraccion: 1)]
                ),
                .init(
                    titulo: notacion.texto(\.caracterDeLaFuente),
                    piezas: [.caracter(tonalidad.caracter, medidas: [], sonoridad: nil)]),
                .init(titulo: notacion.texto(\.acordesDeLaEscala), piezas: [.grados(grados)]),
                .init(
                    titulo: notacion.texto(\.cadenciasTipicas),
                    piezas: [
                        .tabla(
                            Presentacion.cadenciasTipicas(de: tonalidad, en: notacion).map {
                                [$0.nombre, $0.grados, $0.acordes]
                            })
                    ]),
                // Las modulaciones a los tonos vecinos, cada una con la progresión y el pivote.
                .init(
                    titulo: notacion.texto(\.modulaciones),
                    piezas: modulaciones.flatMap { modulacion -> [HojaCompuesta.Pieza] in
                        [
                            .subtitulo(modulacion.destino + " · " + modulacion.tecnica), .lineas([modulacion.acordes]),
                            .apartes(modulacion.pivote.map { [$0] } ?? []),
                        ]
                    }),
            ] + deFuera)
        return escribir(hoja, formato, notacion)
    }
}
