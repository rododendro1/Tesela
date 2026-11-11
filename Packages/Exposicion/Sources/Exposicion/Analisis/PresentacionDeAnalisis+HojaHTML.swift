import Armonia

extension PresentacionDeAnalisis {
    // MARK: Las hojas de una progresión en HTML

    /// La hoja de estudio de la progresión como página HTML: lo mismo que `hojaDeEstudio(_:disposicion:en:)` (los
    /// acordes y su tonalidad, el pentagrama, el análisis en una tabla, la conducción de las voces, las cadencias y
    /// las líneas de notas guía), con los textos en HTML y los dibujos como SVG dentro. Se adapta a la pantalla,
    /// sigue el modo oscuro y se imprime en A4. `armonia hoja acordes Rem7 Sol7 Do7M --html` la escribe.
    ///
    ///     let analisis = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", notacion: .compacta(.espanol))
    ///     let hoja = PresentacionDeAnalisis.hojaDeEstudioHTML(analisis, en: .compacta(.espanol))
    ///     hoja.hasPrefix("<!doctype html>")   // true
    public static func hojaDeEstudioHTML(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let cifrados = cifrados(analisis.acordes, en: notacion)
        var cuerpo = [Hoja.encabezadoHTML(cifrados, [analisis.titulo])]
        if let pentagrama = pentagrama(analisis.acordes, disposicion: disposicion, en: notacion) {
            cuerpo.append(Hoja.figura(pentagrama, clase: "pentagrama"))
        }

        // El análisis: cifrado, grado, función y escala, con la modulación que abre cada tramo.
        var filas: [(celdas: [String], clase: String?)] = []
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera { filas.append(([cabecera], "tramo")) }
            for fila in tramo.filas {
                filas.append(([fila.cifrado, fila.grado, fila.funcion, fila.escala?.nombre ?? ""], nil))
            }
        }
        cuerpo.append(Hoja.seccionHTML(notacion.texto(\.analisis), Hoja.tablaHTML(filas)))

        // La conducción de las voces, paso a paso, en la misma disposición que el pentagrama.
        if let voces = conduccion(analisis.acordes, disposicion: disposicion, en: notacion) {
            let pasos = voces.pasos.map { paso in
                "<h3>" + Hoja.html(paso.titulo + " · " + paso.comunes) + "</h3><p>"
                    + Hoja.html(paso.voces.joined(separator: " · ")) + "</p>"
            }
            let total = "<p class=\"sub\">" + Hoja.html(voces.movimientoTotal) + "</p>"
            cuerpo.append(
                Hoja.seccionHTML(
                    notacion.texto(\.conduccionDeVoces) + " · " + voces.disposicion, pasos.joined() + total))
        }

        // Las cadencias, si las hay.
        if !analisis.cadencias.isEmpty {
            cuerpo.append(Hoja.seccionHTML(notacion.texto(\.cadencias), Hoja.listaHTML(analisis.cadencias)))
        }

        // Las líneas de notas guía, cada una con sus notas y su pentagrama.
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, en: notacion)
        if !lineas.isEmpty {
            let contenido = lineas.map { linea in
                "<p>" + Hoja.html(linea.titulo + ": " + linea.notas) + "</p>"
                    + Hoja.figura(linea.pentagrama.svg, clase: "pentagrama")
            }
            cuerpo.append(Hoja.seccionHTML(notacion.texto(\.lineasDeNotasGuia), contenido.joined()))
        }
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + cifrados, idioma: notacion.textos.codigo, cuerpo)
    }

    /// La progresión en las doce tonalidades como página HTML (lo de `hojaEnLasDoceTonalidades`): en cada una, su
    /// nombre, los cifrados y el pentagrama.
    ///
    ///     let hoja = PresentacionDeAnalisis.hojaEnLasDoceTonalidadesHTML(
    ///         [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], tonalidad: Tonalidad(.do), en: .compacta(.espanol))
    ///     hoja.contains("<h2>Sol mayor</h2>")   // true
    public static func hojaEnLasDoceTonalidadesHTML(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let original = cifrados(acordes, en: notacion)
        var cuerpo = [Hoja.encabezadoHTML(original, [notacion.texto(\.enLasDoceTonalidades)])]
        for progresion in enLasDoceTonalidades(acordes, tonalidad: tonalidad, en: notacion) {
            let figura = pentagrama(progresion.acordes, disposicion: disposicion, en: notacion).map {
                Hoja.figura($0, clase: "pentagrama")
            }
            let contenido = "<p>" + Hoja.html(progresion.cifrados) + "</p>" + (figura ?? "")
            cuerpo.append(Hoja.seccionHTML(progresion.titulo, contenido))
        }
        let titulo = notacion.texto(\.hojaDeEstudio) + " · " + notacion.texto(\.enLasDoceTonalidades)
        return Hoja.paginaHTML(titulo: titulo, idioma: notacion.textos.codigo, cuerpo)
    }

    /// Las dos progresiones comparadas como página HTML (lo de `hojaDeLaComparacion`): el pentagrama de cada una y
    /// la tabla posición a posición, con lo que cambia resaltado. `nil` si alguna está vacía.
    ///
    ///     let hoja = PresentacionDeAnalisis.hojaDeLaComparacionHTML(
    ///         [Acorde("Do"), Acorde("Lam")], con: [Acorde("Do"), Acorde("La7")], notacion: .compacta(.espanol))
    ///     hoja?.contains("class=\"cambia\"")   // true
    public static func hojaDeLaComparacionHTML(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> String? {
        guard let comparacion = comparar(original, con: nueva, en: tonalidad, notacion: notacion) else { return nil }
        typealias Hoja = PresentacionDeEstudioDeEscala
        let antes = cifrados(original, en: notacion)
        let despues = cifrados(nueva, en: notacion)
        var cuerpo = [
            "<header><h1>" + Hoja.html(antes) + "</h1><h1 class=\"destino\">" + Hoja.html(despues) + "</h1>"
                + "<p class=\"sub\">" + Hoja.html(comparacion.tonalidad) + "</p></header>"
        ]
        for acordes in [original, nueva] {
            if let svg = pentagrama(acordes, disposicion: disposicion, en: notacion) {
                cuerpo.append(Hoja.figura(svg, clase: "pentagrama"))
            }
        }
        let filas = comparacion.filas.map { fila in
            let acordes = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
            return (
                celdas: [String(fila.posicion), acordes, fila.grados, fila.comunes], clase: fila.cambia ? "cambia" : nil
            )
        }
        cuerpo.append(Hoja.tablaHTML(filas))
        cuerpo.append("<p><strong>" + Hoja.html(comparacion.resumen) + "</strong></p>")
        let titulo = notacion.texto(\.hojaDeEstudio) + " · " + antes + " → " + despues
        return Hoja.paginaHTML(titulo: titulo, idioma: notacion.textos.codigo, cuerpo)
    }

    /// «Rem7 – Sol7 – Do7M».
    private static func cifrados(_ acordes: [Acorde], en notacion: Notacion) -> String {
        acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
    }

    /// El pentagrama de la progresión con una disposición de cada acorde: la pedida o, si no se puede, cerrada.
    private static func pentagrama(
        _ acordes: [Acorde], disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String? {
        let dispuesta =
            PresentacionDeDisposiciones.progresion(acordes, disposicion, en: notacion)
            ?? PresentacionDeDisposiciones.progresion(acordes, .cerrada, en: notacion)
        return dispuesta?.pentagrama.svg
    }
}
