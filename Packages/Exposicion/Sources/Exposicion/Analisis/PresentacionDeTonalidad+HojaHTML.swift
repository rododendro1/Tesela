import Armonia

extension PresentacionDeTonalidad {
    // MARK: La hoja de estudio de una tonalidad en HTML

    /// La hoja de estudio de la tonalidad como página HTML: lo mismo que `hojaDeEstudio(de:en:)` (la armadura y las
    /// relativas, el pentagrama de su escala, los acordes de cada grado con su función, las cadencias típicas y las
    /// modulaciones a los tonos vecinos), con los textos en HTML y el pentagrama como SVG dentro. Se adapta a la
    /// pantalla, sigue el modo oscuro y se imprime en A4. `armonia hoja tonalidad Re mayor --html` la escribe.
    ///
    ///     let hoja = PresentacionDeTonalidad.hojaDeEstudioHTML(de: Tonalidad(.re), en: .compacta(.espanol))
    ///     hoja.contains("<h1>Re mayor</h1>")   // true
    public static func hojaDeEstudioHTML(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let nombre = tonalidad.nombre(en: notacion)
        var cuerpo = [
            Hoja.encabezadoHTML(
                nombre, [armadura(de: tonalidad, en: notacion), relativas(de: tonalidad, en: notacion)]),
            Hoja.figura(PentagramaPresentado(tonalidad.escala, en: notacion).svg, clase: "pentagrama"),
        ]

        // Los acordes de cada grado: el cifrado romano, el acorde y su función.
        let acordes = tonalidad.armonizar(cuatriadas: true)
        let analizados = tonalidad.analizar(acordes).acordes
        let grados = acordes.enumerated().map { i, acorde in
            let funcion = i < analizados.count ? analizados[i].funcion?.nombre(en: notacion) ?? "" : ""
            return "<li><strong>" + Hoja.html(tonalidad.cifradoRomano(grado: i + 1, cuatriada: true)) + "</strong>"
                + "<span>" + Hoja.html(acorde.cifrado(en: notacion)) + "</span>"
                + "<small>" + Hoja.html(funcion) + "</small></li>"
        }
        cuerpo.append(
            Hoja.seccionHTML(
                notacion.texto(\.acordesDeLaEscala), "<ul class=\"grados\">" + grados.joined() + "</ul>"))

        // Las cadencias típicas: su nombre, sus grados y sus acordes.
        let cadencias = cadenciasTipicas(de: tonalidad, en: notacion).map {
            (celdas: [$0.nombre, $0.grados, $0.acordes], clase: String?.none)
        }
        cuerpo.append(Hoja.seccionHTML(notacion.texto(\.cadenciasTipicas), Hoja.tablaHTML(cadencias)))

        // Las modulaciones a los tonos vecinos, cada una con la progresión y el pivote.
        let modulaciones = PresentacionDeModulaciones.modulaciones(desde: tonalidad, en: notacion).map { modulacion in
            "<h3>" + Hoja.html(modulacion.destino + " · " + modulacion.tecnica) + "</h3>"
                + "<p>" + Hoja.html(modulacion.acordes) + "</p>"
                + (modulacion.pivote.map { "<p class=\"sub\">" + Hoja.html($0) + "</p>" } ?? "")
        }
        cuerpo.append(Hoja.seccionHTML(notacion.texto(\.modulaciones), modulaciones.joined()))
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + nombre, idioma: notacion.textos.codigo, cuerpo)
    }
}
