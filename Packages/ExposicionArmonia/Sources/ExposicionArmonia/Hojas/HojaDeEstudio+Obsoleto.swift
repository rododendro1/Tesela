import Armonia

// MARK: - Los nombres de antes de las hojas de estudio
//
// Publicados en la 0.6: las hojas de una escala, un acorde, una progresión y una tonalidad, y las comparaciones, con
// una función para el SVG y otra para el HTML. Ahora están todas en `HojaDeEstudio`, con su `formato`.

extension PresentacionDeEstudioDeEscala {
    @available(*, deprecated, message: "Usa HojaDeEstudio.escala(_:secciones:mastil:en:formato:).")
    public static func hojaDeEstudio(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases),
        mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15)
    ) -> String {
        HojaDeEstudio.escala(escala, secciones: secciones, mastil: mastil, en: notacion)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.escala(_:secciones:mastil:en:formato:) con formato: .html.")
    public static func hojaDeEstudioHTML(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases),
        mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15)
    ) -> String {
        HojaDeEstudio.escala(escala, secciones: secciones, mastil: mastil, en: notacion, formato: .html)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.comparacion(_:con:en:formato:).")
    public static func comparacionNotaANota(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        HojaDeEstudio.comparacion(escala, con: otra, en: notacion)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.comparacion(_:con:en:formato:) con formato: .html.")
    public static func comparacionNotaANotaHTML(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        HojaDeEstudio.comparacion(escala, con: otra, en: notacion, formato: .html)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.tamano(deUnSVG:).")
    public static func tamano(deUnSVG svg: String) -> (ancho: Double, alto: Double)? {
        HojaDeEstudio.tamano(deUnSVG: svg)
    }
}

extension PresentacionDeRelacionesDeAcorde {
    @available(*, deprecated, message: "Usa HojaDeEstudio.acorde(_:mastil:en:formato:).")
    public static func hojaDeEstudio(
        de acorde: Acorde, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 12), en notacion: Notacion
    ) -> String {
        HojaDeEstudio.acorde(acorde, mastil: mastil, en: notacion)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.acorde(_:mastil:en:formato:) con formato: .html.")
    public static func hojaDeEstudioHTML(
        de acorde: Acorde, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 12), en notacion: Notacion
    ) -> String {
        HojaDeEstudio.acorde(acorde, mastil: mastil, en: notacion, formato: .html)
    }
}

extension PresentacionDeAnalisis {
    @available(*, deprecated, message: "Usa HojaDeEstudio.analisis(_:disposicion:en:formato:).")
    public static func hojaDeEstudio(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        HojaDeEstudio.analisis(analisis, disposicion: disposicion, en: notacion)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.analisis(_:disposicion:en:formato:) con formato: .html.")
    public static func hojaDeEstudioHTML(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        HojaDeEstudio.analisis(analisis, disposicion: disposicion, en: notacion, formato: .html)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.enLasDoceTonalidades(_:tonalidad:disposicion:en:formato:).")
    public static func hojaEnLasDoceTonalidades(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        HojaDeEstudio.enLasDoceTonalidades(acordes, tonalidad: tonalidad, disposicion: disposicion, en: notacion)
    }

    @available(
        *, deprecated,
        message: "Usa HojaDeEstudio.enLasDoceTonalidades(_:tonalidad:disposicion:en:formato:) con formato: .html."
    )
    public static func hojaEnLasDoceTonalidadesHTML(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        HojaDeEstudio.enLasDoceTonalidades(
            acordes, tonalidad: tonalidad, disposicion: disposicion, en: notacion, formato: .html)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.comparacion(_:con:en:disposicion:notacion:formato:).")
    public static func hojaDeLaComparacion(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> String? {
        HojaDeEstudio.comparacion(original, con: nueva, en: tonalidad, disposicion: disposicion, notacion: notacion)
    }

    @available(
        *, deprecated,
        message: "Usa HojaDeEstudio.comparacion(_:con:en:disposicion:notacion:formato:) con formato: .html."
    )
    public static func hojaDeLaComparacionHTML(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> String? {
        HojaDeEstudio.comparacion(
            original, con: nueva, en: tonalidad, disposicion: disposicion, notacion: notacion, formato: .html)
    }
}

extension PresentacionDeTonalidad {
    @available(*, deprecated, message: "Usa HojaDeEstudio.tonalidad(_:en:formato:).")
    public static func hojaDeEstudio(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        HojaDeEstudio.tonalidad(tonalidad, en: notacion)
    }

    @available(*, deprecated, message: "Usa HojaDeEstudio.tonalidad(_:en:formato:) con formato: .html.")
    public static func hojaDeEstudioHTML(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        HojaDeEstudio.tonalidad(tonalidad, en: notacion, formato: .html)
    }
}
