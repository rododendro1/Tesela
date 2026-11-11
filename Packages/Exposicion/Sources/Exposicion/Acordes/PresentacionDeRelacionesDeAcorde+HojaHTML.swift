import Armonia

extension PresentacionDeRelacionesDeAcorde {
    // MARK: La hoja de estudio de un acorde en HTML

    /// La hoja de estudio del acorde como página HTML: lo mismo que `hojaDeEstudio(de:en:)` (el cifrado, sus notas y
    /// sus otros nombres, el pentagrama, las disposiciones, las digitaciones de guitarra, las escalas compatibles y
    /// las sustituciones), con los textos en HTML y los dibujos como SVG dentro. Se adapta a la pantalla, sigue el
    /// modo oscuro y se imprime en A4. `armonia hoja acorde Sol7 --html` la escribe.
    ///
    ///     let hoja = PresentacionDeRelacionesDeAcorde.hojaDeEstudioHTML(de: Acorde("Sol7"), en: .compacta(.espanol))
    ///     hoja.contains("<h1>Sol7</h1>")   // true
    public static func hojaDeEstudioHTML(de acorde: Acorde, en notacion: Notacion) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let datos = relaciones(de: acorde, notacion: notacion)
        let cifrado = acorde.cifrado(en: notacion)
        let notas = acorde.notasDesdeElBajo.map { $0.nombre(en: notacion) }.joined(separator: " ")
        var cuerpo = [Hoja.encabezadoHTML(cifrado, [notas])]

        // Sus otros nombres y, si se puede, cómo se lee sin la fundamental; el pentagrama con los nombres.
        var nombres: [String] = []
        if !datos.otrosNombres.isEmpty {
            nombres.append(
                notacion.texto(\.otrosNombres) + ": " + datos.otrosNombres.prefix(6).joined(separator: " · "))
        }
        if let sinFundamental = datos.sinFundamental {
            nombres.append(notacion.texto(\.sinLaFundamental) + ": " + sinFundamental)
        }
        cuerpo += nombres.map { "<p>" + Hoja.html($0) + "</p>" }
        let pentagrama = PentagramaPresentado(acorde, en: notacion, nombresDeLasNotas: true).svg
        cuerpo.append(Hoja.figura(pentagrama, clase: "pequena"))

        // Las disposiciones: cada una con todas sus inversiones en un pentagrama.
        let disposiciones = [DisposicionDeAcorde.cerrada, .drop2, .shell].compactMap {
            PresentacionDeDisposiciones.acorde(acorde, $0, en: notacion)
        }
        if !disposiciones.isEmpty {
            let figuras = disposiciones.map { Hoja.figura($0.pentagrama.svg, clase: "pentagrama") }
            cuerpo.append(Hoja.seccionHTML(notacion.texto(\.disposicion), figuras.joined()))
        }

        // Las digitaciones de guitarra más cómodas, cada una en su diagrama.
        let mastil = Mastil(.guitarra, numeroDeTrastes: 12)
        let formas = mastil.digitaciones(de: acorde, exigirQuinta: false, limite: 5)
        if !formas.isEmpty {
            let diagramas = formas.map { forma in
                var dibujo: [String] = []
                let alto = diagrama(de: forma, x: 4, y: 4, en: &dibujo) + 8
                return Hoja.figura(Hoja.dibujoSVG(ancho: 100, alto: alto, dibujo), clase: "diagrama")
            }
            cuerpo.append(
                Hoja.seccionHTML(
                    notacion.texto(\.digitaciones), "<div class=\"digitaciones\">" + diagramas.joined() + "</div>"))
        }

        // Las escalas compatibles, con sus tensiones y las notas a evitar.
        let escalas = acorde.escalasCompatibles().prefix(6).map {
            PresentacionDeEscalaYAcorde.presentar($0, sobre: acorde, en: notacion)
        }
        if !escalas.isEmpty {
            let filas = escalas.map {
                "<li><strong>" + Hoja.html($0.nombre) + "</strong> " + Hoja.html($0.resumen) + "</li>"
            }
            cuerpo.append(Hoja.seccionHTML(notacion.texto(\.escalasCompatibles), "<ul>" + filas.joined() + "</ul>"))
        }

        // Las sustituciones, en la tonalidad del acorde.
        let sustituciones = datos.sustituciones.prefix(8).map(\.descripcion)
        if !sustituciones.isEmpty {
            let titulo = notacion.texto(\.sustituciones) + " · " + datos.tonalidad.nombre(en: notacion)
            cuerpo.append(Hoja.seccionHTML(titulo, Hoja.listaHTML(Array(sustituciones))))
        }
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + cifrado, idioma: notacion.textos.codigo, cuerpo)
    }
}
