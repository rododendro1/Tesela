import Armonia
import Foundation

// MARK: - Más hojas de estudio

/// Las hojas de estudio: la de una escala, un acorde, una progresión analizada (también en las doce tonalidades), una
/// tonalidad, un ritmo, una progresión con nombre, una serie dodecafónica, un arpegio y un instrumento, y la
/// comparación de dos escalas o dos progresiones. Cada una se da en SVG, del ancho de un A4 para imprimir, o como
/// página HTML, que se adapta a la pantalla, sigue el modo oscuro y se imprime en A4. `armonia hoja …` las escribe y
/// `armonia grabar hoja …` las pasa a PDF.
///
///     let hoja = HojaDeEstudio.ritmo(.tresillo, en: .compacta(.espanol))
///     hoja.hasPrefix("<svg")   // true
public enum HojaDeEstudio {
    /// Cómo se escribe la hoja.
    public enum Formato: Hashable, Sendable {
        /// Un SVG del ancho de un A4, para imprimir o pasar a PDF.
        case svg
        /// Una página HTML que se adapta a la pantalla, sigue el modo oscuro y se imprime en A4.
        case html
    }

    /// La hoja en el formato pedido.
    static func escribir(_ hoja: HojaCompuesta, _ formato: Formato, _ notacion: Notacion) -> String {
        formato == .svg ? hoja.svg(en: notacion) : hoja.html(en: notacion)
    }

    // MARK: Un ritmo

    /// La hoja de un ritmo del catálogo: su patrón en el collar (los pulsos en un círculo, con el polígono de los
    /// golpes) y en la rejilla, su ficha, lo que se mide de él, su carácter, las obras que lo citan y los ritmos del
    /// catálogo con los mismos pulsos y golpes, del más parecido al menos (por la distancia de intercambio).
    public static func ritmo(_ ritmo: RitmoConNombre, en notacion: Notacion, formato: Formato = .svg) -> String {
        let presentado = RitmoPresentado(ritmo, en: notacion)
        let parecidos = RitmoConNombre.catalogo.filter { $0 != ritmo }.compactMap { otro in
            ritmo.distanciaDeIntercambio(a: otro).map { (otro, $0) }
        }.sorted { $0.1 < $1.1 }.prefix(8)
        let hoja = HojaCompuesta(
            titulo: presentado.nombre, subtitulos: [presentado.compas + " · " + presentado.patron],
            secciones: [
                .init(
                    titulo: notacion.texto(\.ritmo),
                    piezas: [
                        .dibujos(
                            [
                                (notacion.texto(\.ritmo), collar(ritmo.patron)),
                                (notacion.texto(\.rejilla), rejilla(ritmo.patron, agrupacion: ritmo.agrupacion)),
                            ], porFila: 2)
                    ]),
                .init(titulo: notacion.texto(\.informacion), piezas: [.datos(presentado.ficha(en: notacion))]),
                .init(titulo: notacion.texto(\.estadisticas), piezas: [.datos(presentado.datos(en: notacion))]),
                .init(
                    titulo: notacion.texto(\.caracterDeLaFuente),
                    piezas: [.caracter(ritmo.caracter, medidas: [], sonoridad: nil)]),
                .init(
                    titulo: notacion.texto(\.ritmosParecidos),
                    piezas: [
                        .tabla(
                            parecidos.map { otro, distancia in
                                [
                                    otro.nombre(en: notacion), otro.patron,
                                    notacion.texto(\.distanciaDeIntercambio) + ": \(distancia)",
                                ]
                            })
                    ]),
                .init(titulo: notacion.texto(\.fuentes), piezas: [.lineas(presentado.referencias)]),
            ])
        return escribir(hoja, formato, notacion)
    }

    /// El collar de un ritmo: los pulsos en un círculo, empezando arriba y en el sentido del reloj, los golpes
    /// marcados (los fuertes, más grandes) y unidos por un polígono.
    static func collar(_ patron: String) -> String {
        let pulsos = Array(patron)
        let (centro, radio) = (100.0, 78.0)
        func punto(_ i: Int) -> (x: Double, y: Double) {
            let angulo = 2 * Double.pi * Double(i) / Double(max(pulsos.count, 1)) - Double.pi / 2
            return (centro + radio * cos(angulo), centro + radio * sin(angulo))
        }
        var cuerpo = [
            "<circle cx=\"100\" cy=\"100\" r=\"78\" fill=\"none\" stroke=\"#bbbbbb\" stroke-width=\"1\"/>"
        ]
        let golpes = pulsos.indices.filter { pulsos[$0] != "." }
        if golpes.count > 1 {
            let puntos = golpes.map { "\(Hoja.numero(punto($0).x)),\(Hoja.numero(punto($0).y))" }
            cuerpo.append(
                "<polygon points=\"" + puntos.joined(separator: " ") + "\" fill=\"#dbe4f3\" stroke=\""
                    + DibujoDeLaHoja.nota + "\" stroke-width=\"1.5\"/>")
        }
        for (i, pulso) in pulsos.enumerated() {
            let (x, y) = punto(i)
            let radio = pulso == "x" ? 7.0 : pulso == "o" ? 5.0 : 2.5
            let color = pulso == "." ? "#999999" : i == 0 ? DibujoDeLaHoja.tonica : DibujoDeLaHoja.nota
            cuerpo.append(
                "<circle cx=\"\(Hoja.numero(x))\" cy=\"\(Hoja.numero(y))\" r=\"\(Hoja.numero(radio))\" fill=\"\(color)\"/>"
            )
        }
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 200 200\">" + cuerpo.joined() + "</svg>"
    }

    /// La rejilla de un ritmo: una casilla por pulso, llena en los golpes fuertes, a medias en los débiles y vacía en
    /// los silencios, con una raya más gruesa al empezar cada grupo de la agrupación.
    static func rejilla(_ patron: String, agrupacion: [Int]) -> String {
        let pulsos = Array(patron)
        let lado = min(24.0, 380.0 / Double(max(pulsos.count, 1)))
        var inicios: Set<Int> = [0]
        var suma = 0
        for grupo in agrupacion {
            suma += grupo
            inicios.insert(suma)
        }
        var cuerpo: [String] = []
        for (i, pulso) in pulsos.enumerated() {
            let x = 10 + Double(i) * lado
            let relleno = pulso == "x" ? DibujoDeLaHoja.nota : pulso == "o" ? "#9fb6dd" : "#ffffff"
            cuerpo.append(
                "<rect x=\"\(Hoja.numero(x))\" y=\"10\" width=\"\(Hoja.numero(lado))\" height=\"\(Hoja.numero(lado))\" "
                    + "fill=\"\(relleno)\" stroke=\"#555555\" stroke-width=\"1\"/>")
            if inicios.contains(i) {
                cuerpo.append(
                    "<line x1=\"\(Hoja.numero(x))\" y1=\"6\" x2=\"\(Hoja.numero(x))\" y2=\"\(Hoja.numero(14 + lado))\" "
                        + "stroke=\"#222222\" stroke-width=\"2.5\"/>")
            }
            cuerpo.append(
                Hoja.texto("\(i + 1)", x: x + lado / 2 - 3, y: 24 + lado, tamano: 8, color: "#777777"))
        }
        let ancho = 20 + Double(pulsos.count) * lado
        return
            "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Hoja.numero(ancho)) \(Hoja.numero(34 + lado))\" "
            + "font-family=\"Helvetica, Arial, sans-serif\">" + cuerpo.joined() + "</svg>"
    }

    // MARK: Una progresión con nombre

    /// La hoja de una progresión del catálogo sobre una tónica: su cifrado y sus acordes, el pentagrama, su ficha
    /// (otros nombres, origen, lugares, épocas y estilos), su carácter, el coral a cuatro voces, la progresión en
    /// las doce tonalidades y las obras que la citan.
    public static func progresion(
        _ progresion: ProgresionConNombre, sobre tonica: Nota = .do, en notacion: Notacion, formato: Formato = .svg
    ) -> String {
        let presentada = ProgresionConNombrePresentada(progresion, sobre: tonica, en: notacion)
        let acordes = progresion.acordes(sobre: tonica)
        let tonalidad = progresion.tonalidad(sobre: tonica)
        var ficha = presentada.datosDelCatalogo(en: notacion)
        ficha += presentada.datosDelLugar(progresion.lugaresDeOrigen.map { $0.nombre(en: notacion) }, en: notacion)
        if !presentada.epocasDeUso.isEmpty {
            ficha.append(
                DatoPresentado(
                    nombre: notacion.texto(\.epocasDeUso), valor: presentada.epocasDeUso.joined(separator: " · ")))
        }
        if !presentada.estilos.isEmpty {
            ficha.append(
                DatoPresentado(nombre: notacion.texto(\.estilos), valor: presentada.estilos.joined(separator: " · ")))
        }
        // El coral, con los acordes analizados en la tonalidad de la progresión.
        var coral: [HojaCompuesta.Pieza] = []
        if let analisis = PresentacionDeAnalisis.analizar(acordes, en: tonalidad, notacion: notacion) {
            let realizado = PresentacionDeAnalisis.coralDeLaHoja(analisis, en: notacion)
            coral.append(.tabla(realizado.filas.map { [$0.cifrado, $0.grado, $0.voces] }))
            if let pentagrama = realizado.pentagrama { coral.append(.dibujo(pentagrama.svg, fraccion: 1)) }
            coral.append(.apartes(realizado.avisos))
        }
        let doce = ConjuntoDeClasesDeAltura(0..<12).notas().map { nota in
            [Tonalidad(nota, progresion.modo).nombre(en: notacion)]
                + [progresion.acordes(sobre: nota).map { $0.cifrado(en: notacion) }.joined(separator: " ")]
        }
        let hoja = HojaCompuesta(
            titulo: presentada.nombre,
            subtitulos: [
                presentada.cifrado + " · " + presentada.acordes.joined(separator: " – "),
                tonalidad.nombre(en: notacion),
            ],
            secciones: [
                .init(titulo: notacion.texto(\.pentagrama), piezas: pentagrama(acordes, .drop2, en: notacion)),
                .init(titulo: notacion.texto(\.informacion), piezas: [.datos(ficha)]),
                .init(
                    titulo: notacion.texto(\.caracterDeLaFuente),
                    piezas: [.caracter(progresion.caracter, medidas: [], sonoridad: nil)]),
                .init(titulo: notacion.texto(\.coral), piezas: coral),
                .init(titulo: notacion.texto(\.enLasDoceTonalidades), piezas: [.tabla(doce)]),
                .init(titulo: notacion.texto(\.fuentes), piezas: [.lineas(presentada.referencias)]),
            ])
        return escribir(hoja, formato, notacion)
    }

    // MARK: Una serie dodecafónica

    /// La hoja de una serie dodecafónica: sus notas, sus intervalos, sus hexacordos y sus formas combinatorias, la
    /// matriz de doce por doce con las formas originales (P) a la izquierda, las inversiones (I) arriba, los
    /// retrógrados (R) a la derecha y los retrógrados de la inversión (RI) abajo, y la forma original en el
    /// pentagrama.
    public static func serie(_ serie: SerieDodecafonica, en notacion: Notacion, formato: Formato = .svg) -> String {
        let forma = FormaDeSerie(.original, serie.clases[0])
        // La serie ya está leída: su texto siempre se vuelve a leer.
        let matriz = try! PresentacionDeSerie.presentar(serie.description, forma: forma, en: notacion)
        let datos = matriz.datos.map { DatoPresentado(nombre: $0.titulo, valor: $0.valor) }
        let hoja = HojaCompuesta(
            titulo: notacion.texto(\.serieDodecafonica), subtitulos: [serie.description, matriz.formasDistintas],
            secciones: [
                .init(titulo: notacion.texto(\.informacion), piezas: [.datos(datos)]),
                .init(titulo: notacion.texto(\.matriz), piezas: [.dibujo(matrizSVG(matriz), fraccion: 0.75)]),
                .init(
                    titulo: notacion.texto(\.pentagrama) + " · " + forma.description,
                    piezas: [.dibujo(matriz.pentagrama.svg, fraccion: 1)]),
            ])
        return escribir(hoja, formato, notacion)
    }

    /// La matriz de la serie en SVG: cada clase en cifra (t y e para 10 y 11), con el nombre de cada forma en los
    /// cuatro lados; la fila y la columna de la serie, en negrita.
    static func matrizSVG(_ matriz: MatrizDeSeriePresentada) -> String {
        let lado = 24.0
        let borde = 34.0
        var cuerpo: [String] = []
        func centrado(_ texto: String, _ x: Double, _ y: Double, negrita: Bool = false, color: String = "#222222")
            -> String
        {
            "<text x=\"\(Hoja.numero(x))\" y=\"\(Hoja.numero(y))\" font-size=\"11\" text-anchor=\"middle\" fill=\""
                + color + "\"" + (negrita ? " font-weight=\"bold\"" : "") + ">" + EscrituraXML.escapar(texto)
                + "</text>"
        }
        for (f, fila) in matriz.matriz.enumerated() {
            let y = borde + Double(f) * lado
            for (c, clase) in fila.enumerated() {
                let x = borde + Double(c) * lado
                cuerpo.append(
                    "<rect x=\"\(Hoja.numero(x))\" y=\"\(Hoja.numero(y))\" width=\"\(Hoja.numero(lado))\" "
                        + "height=\"\(Hoja.numero(lado))\" fill=\"" + (f == 0 || c == 0 ? "#eef2f9" : "#ffffff")
                        + "\" stroke=\"#cccccc\" stroke-width=\"0.5\"/>")
                cuerpo.append(
                    centrado(
                        MatrizDeSeriePresentada.cifra(clase), x + lado / 2, y + lado / 2 + 4, negrita: f == 0 || c == 0)
                )
            }
            let indice = matriz.formasDeLasFilas[f].indice
            cuerpo.append(centrado("P\(indice)", borde / 2, y + lado / 2 + 4, color: "#555555"))
            cuerpo.append(centrado("R\(indice)", borde + 12 * lado + borde / 2, y + lado / 2 + 4, color: "#555555"))
        }
        for (c, forma) in matriz.formasDeLasColumnas.enumerated() {
            let x = borde + Double(c) * lado + lado / 2
            cuerpo.append(centrado("I\(forma.indice)", x, borde - 10, color: "#555555"))
            cuerpo.append(centrado("RI\(forma.indice)", x, borde + 12 * lado + 18, color: "#555555"))
        }
        let total = 2 * borde + 12 * lado
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Hoja.numero(total)) \(Hoja.numero(total))\" "
            + "font-family=\"Helvetica, Arial, sans-serif\">" + cuerpo.joined() + "</svg>"
    }

    // MARK: Un arpegio

    /// La hoja del arpegio de un acorde: sus notas y sus intervalos, el arpegio en el pentagrama (dos octavas,
    /// subiendo y bajando), en el teclado y en el mástil de `mastil` (entero, del traste 0 al 12, y por posiciones:
    /// CAGED en la guitarra) y las escalas que le van.
    public static func arpegio(
        _ acorde: Acorde, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15), en notacion: Notacion,
        formato: Formato = .svg
    ) -> String {
        let cifrado = acorde.cifrado(en: notacion)
        let notas = acorde.notasDesdeElBajo
        // Dos octavas desde el bajo, en la 3, y de vuelta.
        var subida: [Altura] = []
        for octava in 0..<2 {
            for nota in notas {
                var altura = Altura(nota, octava: 3 + octava)
                while let anterior = subida.last, altura.midi <= anterior.midi {
                    altura = Altura(nota, octava: altura.octava + 1)
                }
                subida.append(altura)
            }
        }
        if let bajo = notas.first, let ultima = subida.last {
            var arriba = Altura(bajo, octava: ultima.octava)
            if arriba.midi <= ultima.midi { arriba = Altura(bajo, octava: ultima.octava + 1) }
            subida.append(arriba)
        }
        let alturas = subida + subida.reversed().dropFirst()
        let pentagrama = PentagramaPresentado(alturas.map { [$0] }, titulo: cifrado, en: notacion)
        let hasta = min(12, mastil.numeroDeTrastes)
        var dibujos = [
            (
                "",
                PresentacionDeEstudioDeEscala.mastilSVG(
                    mastil.posiciones(de: acorde, en: 0...hasta), en: mastil, trastes: 0...hasta,
                    ortografia: acorde.notas,
                    tonica: acorde.fundamental, notacion: notacion)
            )
        ]
        let formas: FormasDeArpegio = mastil.encordado == .guitarra ? .caged : .porPosiciones
        for posicion in PresentacionDeArpegios.enElMastil(acorde, formas: formas, mastil: mastil, en: notacion) {
            dibujos.append(
                (
                    posicion.titulo,
                    PresentacionDeEstudioDeEscala.mastilSVG(
                        posicion.notas, en: mastil, trastes: posicion.arpegio.rangoDeTrastes,
                        ortografia: acorde.notas, tonica: acorde.fundamental, notacion: notacion)
                ))
        }
        let intervalos = acorde.tipo.intervalos.map(\.abreviatura).joined(separator: " ")
        let escalas = PresentacionDeEscalaYAcorde.escalas(de: acorde, notacion: notacion).prefix(5).map {
            PresentacionDeEscalaYAcorde.nombreConMotivo($0) + ($0.resumen.isEmpty ? "" : " — " + $0.resumen)
        }
        let hoja = HojaCompuesta(
            titulo: notacion.texto(\.arpegio) + " · " + cifrado,
            subtitulos: [notas.map { $0.nombre(en: notacion) }.joined(separator: " "), intervalos],
            secciones: [
                .init(titulo: notacion.texto(\.pentagrama), piezas: [.dibujo(pentagrama.svg, fraccion: 1)]),
                .init(
                    titulo: notacion.texto(\.teclado),
                    piezas: [.dibujo(PresentacionDeRelacionesDeAcorde.teclado(de: acorde, en: notacion), fraccion: 0.5)]
                ),
                .init(
                    titulo: notacion.texto(\.arpegioEnElMastil) + " · " + mastil.encordado.nombre(en: notacion),
                    piezas: [.dibujo(dibujos[0].1, fraccion: 1)]),
                .init(
                    titulo: notacion.texto(\.posicionesEnElMastil),
                    piezas: [.dibujos(Array(dibujos.dropFirst()), porFila: 2)]),
                .init(titulo: notacion.texto(\.escalasCompatibles), piezas: [.lineas(Array(escalas))]),
            ])
        return escribir(hoja, formato, notacion)
    }

    // MARK: Un instrumento

    /// Los acordes de la hoja de un instrumento: los mayores, menores y de séptima de las tonalidades más fáciles.
    static let acordesBasicos = ["Do", "Re", "Mi", "Fa", "Sol", "La", "Rem", "Mim", "Lam", "Re7", "Mi7", "Sol7"]

    /// La hoja de un instrumento de cuerda: su ficha (familia, afinación, cuerdas, trastes, estilos, lugares y
    /// época), la afinación en el pentagrama, el mástil con todas las notas del traste 0 al 12 y la digitación más
    /// cómoda de los acordes básicos.
    public static func instrumento(_ encordado: Encordado, en notacion: Notacion, formato: Formato = .svg) -> String {
        let presentado = EncordadoPresentado(encordado, en: notacion)
        let mastil = Mastil(encordado, numeroDeTrastes: 12)
        let hasta = min(12, mastil.numeroDeTrastes)
        let cromatica = Escala(.do, .cromatica)
        let todas = (0..<encordado.numeroDeCuerdas).flatMap { cuerda in
            mastil.trastes(deCuerda: cuerda).filter { $0 <= hasta }.map {
                PosicionEnElMastil(cuerda: cuerda, traste: $0)
            }
        }
        let todoElMastil = PresentacionDeEstudioDeEscala.mastilSVG(
            todas, en: mastil, trastes: 0...hasta, ortografia: cromatica.notas, tonica: nil, notacion: notacion)
        let afinacion = PentagramaPresentado(
            encordado.afinacion.map { [$0] }, titulo: notacion.texto(\.afinacion), en: notacion)
        let diagramas = acordesBasicos.compactMap { cifrado -> (titulo: String, svg: String)? in
            guard let acorde = try? Acorde(leyendo: cifrado),
                let forma = mastil.digitaciones(de: acorde, exigirQuinta: false, limite: 1).first
            else { return nil }
            return (acorde.cifrado(en: notacion), PresentacionDeRelacionesDeAcorde.diagramaSVG(de: forma))
        }
        let hoja = HojaCompuesta(
            titulo: presentado.nombre, subtitulos: [presentado.afinacion.joined(separator: " ")],
            secciones: [
                .init(titulo: notacion.texto(\.fichaDelInstrumento), piezas: [.datos(presentado.ficha(en: notacion))]),
                .init(titulo: notacion.texto(\.afinacion), piezas: [.dibujo(afinacion.svg, fraccion: 0.6)]),
                .init(
                    titulo: notacion.texto { $0.mastilDe(presentado.nombre, 0, hasta) },
                    piezas: [.dibujo(todoElMastil, fraccion: 1)]),
                .init(titulo: notacion.texto(\.digitaciones), piezas: [.dibujos(diagramas, porFila: 6)]),
                .init(titulo: notacion.texto(\.fuentes), piezas: [.lineas(presentado.referencias)]),
            ])
        return escribir(hoja, formato, notacion)
    }
}
