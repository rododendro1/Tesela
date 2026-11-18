import Armonia
import Foundation

extension PresentacionDeRelacionesDeAcorde {
    // MARK: La hoja de estudio de un acorde

    /// Una hoja de estudio del acorde, para imprimir: un SVG del ancho de un A4 con el cifrado, sus notas y sus otros
    /// nombres, el pentagrama, sus disposiciones (cerrada, drop 2 y fundamental, tercera y séptima, las que tenga),
    /// el acorde en el teclado, las digitaciones más cómodas en el mástil de `mastil` (la guitarra, si no se da), las
    /// escalas compatibles con sus tensiones y las sustituciones. El alto es el que ocupa. `armonia grabar hoja acorde
    /// Sol7` la pasa a PDF.
    ///
    ///     let hoja = PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: Acorde("Sol7"), en: .compacta(.espanol))
    ///     hoja.hasPrefix("<svg")   // true
    public static func hojaDeEstudio(
        de acorde: Acorde, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 12), en notacion: Notacion
    ) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen
        func titulo(_ texto: String) {
            cuerpo.append(Hoja.texto(texto, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
        }
        func linea(_ texto: String) {
            cuerpo.append(Hoja.texto(texto, x: margen, y: y, tamano: 11))
            y += 16
        }

        // El cifrado, sus notas y sus otros nombres; a la derecha, el pentagrama.
        let datos = RelacionesPresentadas(acorde, notacion: notacion)
        let arriba = y
        y += 22
        cuerpo.append(Hoja.texto(acorde.cifrado(en: notacion), x: margen, y: y, tamano: 24, negrita: true))
        y += 20
        let notas = acorde.notasDesdeElBajo.map { $0.nombre(en: notacion) }.joined(separator: " ")
        cuerpo.append(Hoja.texto(notas, x: margen, y: y, tamano: 13, color: "#555555"))
        y += 22
        if !datos.otrosNombres.isEmpty {
            linea(notacion.texto(\.otrosNombres) + ": " + datos.otrosNombres.prefix(6).joined(separator: " · "))
        }
        if let sinFundamental = datos.sinFundamental {
            linea(notacion.texto(\.sinLaFundamental) + ": " + sinFundamental)
        }
        let anchoDelPentagrama = 170.0
        let pentagrama = PentagramaPresentado(acorde, en: notacion, nombresDeLasNotas: true).svg
        let altoDelPentagrama = Hoja.incrustar(
            pentagrama, x: ancho - margen - anchoDelPentagrama, y: arriba, ancho: anchoDelPentagrama, en: &cuerpo)
        y = max(y, arriba + altoDelPentagrama) + 12

        // Las disposiciones: cada una con todas sus inversiones en un pentagrama.
        let disposiciones = [DisposicionDeAcorde.cerrada, .drop2, .shell].compactMap {
            PresentacionDeDisposiciones.acorde(acorde, $0, en: notacion)
        }
        if !disposiciones.isEmpty {
            titulo(notacion.texto(\.disposicion))
            for dispuesta in disposiciones {
                y += Hoja.incrustar(dispuesta.pentagrama.svg, x: margen, y: y, ancho: util, en: &cuerpo) + 8
            }
            y += 4
        }

        // El acorde en el teclado, en posición cerrada desde el bajo.
        titulo(notacion.texto(\.teclado))
        y += Hoja.incrustar(teclado(de: acorde, en: notacion), x: margen, y: y - 8, ancho: util / 2, en: &cuerpo) + 4

        // Las digitaciones más cómodas en el instrumento, una al lado de otra.
        let formas = mastil.digitaciones(de: acorde, exigirQuinta: false, limite: 5)
        if !formas.isEmpty {
            titulo(notacion.texto(\.digitaciones) + " · " + mastil.encordado.nombre(en: notacion))
            var altoDeLasFormas = 0.0
            for (i, forma) in formas.enumerated() {
                let x = margen + Double(i) * (util / 5)
                altoDeLasFormas = max(altoDeLasFormas, diagrama(de: forma, x: x, y: y, en: &cuerpo))
            }
            y += altoDeLasFormas + 12
        }

        // Las escalas compatibles, con sus tensiones y las notas a evitar.
        let escalas = PresentacionDeEscalaYAcorde.escalas(de: acorde, notacion: notacion).prefix(6)
        if !escalas.isEmpty {
            titulo(notacion.texto(\.escalasCompatibles))
            for presentada in escalas {
                let nombre = PresentacionDeEscalaYAcorde.nombreConMotivo(presentada)
                linea(nombre + (presentada.resumen.isEmpty ? "" : " — " + presentada.resumen))
            }
            y += 8
        }

        // Las sustituciones, en la tonalidad del acorde.
        let sustituciones = datos.sustituciones.prefix(8)
        if !sustituciones.isEmpty {
            titulo(notacion.texto(\.sustituciones) + " · " + datos.tonalidad.nombre(en: notacion))
            for sustitucion in sustituciones { linea(sustitucion.descripcion) }
        }
        let alto = (y + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: alto, cuerpo)
    }

    /// El diagrama de una digitación, como en los cancioneros: una línea por cuerda (la más grave a la izquierda),
    /// cuatro trastes, un punto en cada nota pisada, «x» en las que no suenan y «o» en las que suenan al aire, el
    /// traste de partida si no es el primero y la tablatura debajo. Da el alto que ocupa.
    static func diagrama(de forma: Digitacion, x: Double, y: Double, en cuerpo: inout [String]) -> Double {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let cuerdas = forma.trastes.count
        let entreCuerdas = 11.0
        let entreTrastes = 15.0
        let filas = 4
        let izquierda = x + 16
        let arriba = y + 14
        let anchoDeLaRejilla = Double(max(cuerdas - 1, 1)) * entreCuerdas
        let pisados = forma.trastesPisados
        let primero = (pisados.max() ?? 0) <= filas ? 1 : (pisados.min() ?? 1)
        // La cejuela, gruesa, si se empieza en el primer traste.
        if primero == 1 {
            cuerpo.append(
                "<line x1=\"\(Hoja.numero(izquierda))\" y1=\"\(Hoja.numero(arriba))\" "
                    + "x2=\"\(Hoja.numero(izquierda + anchoDeLaRejilla))\" y2=\"\(Hoja.numero(arriba))\" "
                    + "stroke=\"#222222\" stroke-width=\"3\"/>")
        } else {
            cuerpo.append(Hoja.texto("\(primero)", x: x, y: arriba + entreTrastes * 0.7, tamano: 10, color: "#555555"))
        }
        for fila in 0...filas {
            let altura = arriba + Double(fila) * entreTrastes
            cuerpo.append(
                "<line x1=\"\(Hoja.numero(izquierda))\" y1=\"\(Hoja.numero(altura))\" "
                    + "x2=\"\(Hoja.numero(izquierda + anchoDeLaRejilla))\" y2=\"\(Hoja.numero(altura))\" "
                    + "stroke=\"#888888\" stroke-width=\"1\"/>")
        }
        for (i, traste) in forma.trastes.enumerated() {
            let cuerda = izquierda + Double(i) * entreCuerdas
            cuerpo.append(
                "<line x1=\"\(Hoja.numero(cuerda))\" y1=\"\(Hoja.numero(arriba))\" x2=\"\(Hoja.numero(cuerda))\" "
                    + "y2=\"\(Hoja.numero(arriba + Double(filas) * entreTrastes))\" stroke=\"#888888\" "
                    + "stroke-width=\"1\"/>")
            switch traste {
            case nil:
                cuerpo.append(Hoja.texto("x", x: cuerda - 3, y: arriba - 4, tamano: 10))
            case 0?:
                cuerpo.append(Hoja.texto("o", x: cuerda - 3, y: arriba - 4, tamano: 10))
            case let traste?:
                let fila = traste - primero
                guard (0..<filas).contains(fila) else { continue }
                let centro = arriba + (Double(fila) + 0.5) * entreTrastes
                cuerpo.append(
                    "<circle cx=\"\(Hoja.numero(cuerda))\" cy=\"\(Hoja.numero(centro))\" r=\"4.5\" fill=\"#222222\"/>")
            }
        }
        let abajo = arriba + Double(filas) * entreTrastes + 14
        cuerpo.append(Hoja.texto(forma.tablatura, x: izquierda - 4, y: abajo, tamano: 10, color: "#555555"))
        return abajo + 4 - y
    }

    /// El acorde en un teclado de piano (SVG), en posición cerrada desde el bajo en la octava 4, con el nombre de cada
    /// nota; la fundamental, con el borde naranja.
    ///
    ///     let svg = PresentacionDeRelacionesDeAcorde.teclado(de: Acorde("Sol7"), en: .compacta(.espanol))
    public static func teclado(de acorde: Acorde, en notacion: Notacion) -> String {
        var alturas: [Altura] = []
        for nota in acorde.notasDesdeElBajo {
            var altura = Altura(nota, octava: 4)
            while let anterior = alturas.last, altura.midi <= anterior.midi {
                altura = Altura(nota, octava: altura.octava + 1)
            }
            alturas.append(altura)
        }
        var rotulos: [Int: String] = [:]
        for altura in alturas { rotulos[altura.midi] = altura.nota.nombre(en: notacion) }
        let fundamental = acorde.fundamental.claseDeAltura
        let primeras = Set(alturas.map(\.midi).filter { (($0 % 12) + 12) % 12 == fundamental })
        return TecladoDePiano(cubriendo: alturas).svg(
            marcadas: MarcasDeDiagrama(rotulos: rotulos), primeras: primeras,
            opciones: .init(titulo: acorde.cifrado(en: notacion)))
    }
}
