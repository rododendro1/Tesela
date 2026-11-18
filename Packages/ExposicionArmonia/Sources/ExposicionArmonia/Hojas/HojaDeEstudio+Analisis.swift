import Armonia

extension HojaDeEstudio {
    // MARK: Una progresión analizada

    /// La hoja de una progresión analizada: los acordes y su tonalidad, el pentagrama con una disposición de cada uno
    /// (la `disposicion`, o cerrada si no se puede), el análisis (grado, función y escala de cada acorde, con las
    /// modulaciones), la conducción de las voces, el coral a cuatro voces (el de `armonia realizar`, con su
    /// pentagrama y sus faltas), las cadencias y las líneas de notas guía con su pentagrama. `armonia hoja acordes
    /// Rem7 Sol7 Do7M` la escribe.
    ///
    ///     let analisis = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", notacion: .compacta(.espanol))
    ///     let hoja = HojaDeEstudio.analisis(analisis, en: .compacta(.espanol))
    ///     hoja.hasPrefix("<svg")   // true
    public static func analisis(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion,
        formato: Formato = .svg
    ) -> String {
        // El análisis: cifrado, grado, función y escala, con la modulación que abre cada tramo.
        var filas: [[String]] = []
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera { filas.append([cabecera]) }
            filas += tramo.filas.map { [$0.cifrado, $0.grado, $0.funcion, $0.escala?.nombre ?? ""] }
        }
        // La conducción de las voces, paso a paso, en la misma disposición que el pentagrama.
        let voces = PresentacionDeAnalisis.conduccion(analisis.acordes, disposicion: disposicion, en: notacion)
        let pasos: [HojaCompuesta.Pieza] =
            voces.map { voces in
                voces.pasos.flatMap { paso -> [HojaCompuesta.Pieza] in
                    [.subtitulo(paso.titulo + " · " + paso.comunes), .lineas([paso.voces.joined(separator: " · ")])]
                } + [.apartes([voces.movimientoTotal])]
            } ?? []
        let coral = PresentacionDeAnalisis.coralDeLaHoja(analisis, en: notacion)
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, en: notacion)
        let hoja = HojaCompuesta(
            titulo: cifrados(analisis.acordes, en: notacion), subtitulos: [analisis.titulo],
            secciones: [
                .init(titulo: "", piezas: pentagrama(analisis.acordes, disposicion, en: notacion)),
                .init(titulo: notacion.texto(\.analisis), piezas: [.tabla(filas)]),
                .init(
                    titulo: notacion.texto(\.conduccionDeVoces) + (voces.map { " · " + $0.disposicion } ?? ""),
                    piezas: pasos),
                // El coral a cuatro voces (lo de `armonia realizar`): un acorde por fila, el pentagrama y las faltas.
                .init(
                    titulo: notacion.texto(\.coral),
                    piezas: [.tabla(coral.filas.map { [$0.cifrado, $0.grado, $0.voces] })]
                        + (coral.pentagrama.map { [.dibujo($0.svg, fraccion: 1)] } ?? []) + [.apartes(coral.avisos)]),
                .init(titulo: notacion.texto(\.cadencias), piezas: [.lineas(analisis.cadencias)]),
                .init(
                    titulo: notacion.texto(\.lineasDeNotasGuia),
                    piezas: lineas.flatMap { linea -> [HojaCompuesta.Pieza] in
                        [.lineas([linea.titulo + ": " + linea.notas]), .dibujo(linea.pentagrama.svg, fraccion: 1)]
                    }),
            ])
        return escribir(hoja, formato, notacion)
    }

    // MARK: Una progresión en las doce tonalidades

    /// La progresión en las doce tonalidades, para practicarla: en cada una, su nombre, los cifrados y el pentagrama
    /// con una disposición de cada acorde (la `disposicion`, o cerrada si no se puede). `armonia hoja acordes … --doce`
    /// la escribe.
    ///
    ///     let hoja = HojaDeEstudio.enLasDoceTonalidades(
    ///         [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], tonalidad: Tonalidad(.do), en: .compacta(.espanol),
    ///         formato: .html)
    ///     hoja.contains("<h2>Sol mayor</h2>")   // true
    public static func enLasDoceTonalidades(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion,
        formato: Formato = .svg
    ) -> String {
        let doce = PresentacionDeAnalisis.enLasDoceTonalidades(acordes, tonalidad: tonalidad, en: notacion)
        let hoja = HojaCompuesta(
            titulo: cifrados(acordes, en: notacion), subtitulos: [notacion.texto(\.enLasDoceTonalidades)],
            secciones: doce.map { progresion in
                .init(
                    titulo: progresion.titulo,
                    piezas: [.lineas([progresion.cifrados])] + pentagrama(progresion.acordes, disposicion, en: notacion)
                )
            })
        return escribir(hoja, formato, notacion)
    }

    // MARK: Dos progresiones comparadas

    /// Dos progresiones comparadas: el pentagrama de cada una, con una disposición de cada acorde, y la tabla
    /// posición a posición, con lo que cambia en rojo (en HTML, resaltado). `nil` si alguna está vacía. `armonia hoja
    /// acordes … --comparar …` la escribe.
    ///
    ///     let hoja = HojaDeEstudio.comparacion(
    ///         [Acorde("Do"), Acorde("Lam")], con: [Acorde("Do"), Acorde("La7")], notacion: .compacta(.espanol),
    ///         formato: .html)
    ///     hoja?.contains("class=\"cambia\"")   // true
    public static func comparacion(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion, formato: Formato = .svg
    ) -> String? {
        formato == .svg
            ? PresentacionDeAnalisis.comparacionSVG(
                original, con: nueva, en: tonalidad, disposicion: disposicion, notacion: notacion)
            : PresentacionDeAnalisis.comparacionHTML(
                original, con: nueva, en: tonalidad, disposicion: disposicion, notacion: notacion)
    }

    /// «Rem7 – Sol7 – Do7M».
    static func cifrados(_ acordes: [Acorde], en notacion: Notacion) -> String {
        acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
    }

    /// El pentagrama de los acordes con una disposición de cada uno, la pedida o, si no se puede, cerrada; nada si
    /// tampoco.
    static func pentagrama(
        _ acordes: [Acorde], _ disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> [HojaCompuesta.Pieza] {
        let dispuesta =
            PresentacionDeDisposiciones.progresion(acordes, disposicion, en: notacion)
            ?? PresentacionDeDisposiciones.progresion(acordes, .cerrada, en: notacion)
        return dispuesta.map { [.dibujo($0.pentagrama.svg, fraccion: 1)] } ?? []
    }
}
