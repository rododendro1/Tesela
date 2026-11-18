import Armonia
import Foundation

// MARK: - El mástil y las secuencias de la hoja de estudio

extension PresentacionDeEstudioDeEscala {
    /// La escala en el mástil, para la hoja: primero todo el mástil, del traste 0 al 12, con todas sus notas; después
    /// cada posición. En la guitarra afinada como siempre, las cinco formas de una pentatónica
    /// (`formasPentatonicas(de:mastil:en:)`) o las cinco posiciones CAGED; en otro instrumento, las de tres notas por
    /// cuerda (`Mastil.posicionesPorCuerda(de:notasPorCuerda:)`), si sus cuerdas van de grave a aguda. Cada dibujo es
    /// un SVG suelto, con su título.
    ///
    ///     let dibujos = PresentacionDeEstudioDeEscala.mastilDeLaHoja(de: Escala(.sol), en: .compacta(.espanol))
    ///     dibujos.count   // 6: el mástil entero y las cinco posiciones CAGED
    public static func mastilDeLaHoja(
        de escala: Escala, mastil: Mastil = Mastil(.guitarra, numeroDeTrastes: 15), en notacion: Notacion
    ) -> [(titulo: String, svg: String)] {
        let hasta = min(12, mastil.numeroDeTrastes)
        let todo = notacion.texto { $0.mastilDe(mastil.encordado.nombre(en: notacion), 0, hasta) }
        var dibujos = [
            (
                todo,
                mastilSVG(
                    mastil.posiciones(de: escala, en: 0...hasta), en: mastil, trastes: 0...hasta, escala: escala,
                    notacion: notacion)
            )
        ]
        let posiciones: [EscalaEnElMastil]
        if escala.notas.count == 5, !mastil.formasPentatonicas(de: escala).isEmpty {
            posiciones = mastil.formasPentatonicas(de: escala)
        } else if !mastil.posicionesCAGED(de: escala).isEmpty {
            posiciones = mastil.posicionesCAGED(de: escala)
        } else {
            posiciones = mastil.posicionesPorCuerda(de: escala)
        }
        for posicion in posiciones {
            let forma = posicion.forma.map { forma in notacion.texto { $0.forma(forma.rawValue) } + " · " } ?? ""
            let rango = posicion.rangoDeTrastes
            let titulo = forma + notacion.texto { $0.trastes(rango.lowerBound, rango.upperBound) }
            dibujos.append(
                (titulo, mastilSVG(posicion.posiciones, en: mastil, trastes: rango, escala: escala, notacion: notacion))
            )
        }
        return dibujos
    }

    /// Las secuencias de estudio de la hoja, en una octava y subiendo: por terceras y en grupos de cuatro, cada una
    /// con sus notas y su pentagrama (lo de `armonia escala --secuencia`).
    public static func secuenciasDeLaHoja(de escala: Escala, en notacion: Notacion) -> [SecuenciaPresentada] {
        [SecuenciaDeEscala.terceras, .gruposDeCuatro].map { SecuenciaPresentada(escala, $0, en: notacion) }
    }

    /// Un trozo del mástil en SVG, como en los métodos de guitarra: las cuerdas en horizontal (la más aguda arriba,
    /// como en la tablatura) con el nombre de la nota al aire a la izquierda, los trastes en vertical con su número
    /// debajo, la cejuela gruesa si se empieza al aire, y un punto en cada nota con su nombre escrito como en la
    /// escala; la tónica, en naranja.
    static func mastilSVG(
        _ notas: [PosicionEnElMastil], en mastil: Mastil, trastes: ClosedRange<Int>, escala: Escala,
        notacion: Notacion
    ) -> String {
        mastilSVG(
            notas, en: mastil, trastes: trastes, ortografia: escala.notas, tonica: escala.tonica, notacion: notacion)
    }

    /// El trozo del mástil con las notas escritas como en `ortografia` (la escala, el acorde) y `tonica` en naranja;
    /// sin tónica, todas iguales.
    static func mastilSVG(
        _ notas: [PosicionEnElMastil], en mastil: Mastil, trastes: ClosedRange<Int>, ortografia: [Nota], tonica: Nota?,
        notacion: Notacion
    ) -> String {
        let cuerdas = mastil.encordado.numeroDeCuerdas
        let entreCuerdas = 16.0
        let anchoDelTraste = 34.0
        let izquierda = 30.0
        let arriba = 12.0
        // El traste 0 va en su columna, a la izquierda de la cejuela.
        let primero = max(1, trastes.lowerBound)
        let columnas = Double(trastes.upperBound - primero + 1)
        let alAire = trastes.lowerBound == 0 ? anchoDelTraste * 0.7 : 0
        let inicio = izquierda + alAire
        let ancho = inicio + columnas * anchoDelTraste + 10
        let fondo = arriba + Double(max(cuerdas - 1, 1)) * entreCuerdas
        let alto = fondo + 26
        func fila(_ cuerda: Int) -> Double { arriba + Double(cuerdas - 1 - cuerda) * entreCuerdas }
        func linea(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ color: String, _ grosor: Double) -> String
        {
            "<line x1=\"\(Hoja.numero(x1))\" y1=\"\(Hoja.numero(y1))\" x2=\"\(Hoja.numero(x2))\" y2=\"\(Hoja.numero(y2))\" "
                + "stroke=\"\(color)\" stroke-width=\"\(Hoja.numero(grosor))\"/>"
        }
        var cuerpo: [String] = []
        // Los trastes, con el número debajo; la cejuela, gruesa.
        for traste in (primero - 1)...trastes.upperBound {
            let x = inicio + Double(traste - primero + 1) * anchoDelTraste
            let cejuela = traste == 0
            cuerpo.append(linea(x, arriba, x, fondo, cejuela ? "#222222" : "#999999", cejuela ? 3 : 1))
            if traste >= primero {
                let centro = x - anchoDelTraste / 2
                cuerpo.append(Hoja.texto("\(traste)", x: centro - 3, y: fondo + 18, tamano: 9, color: "#777777"))
            }
        }
        // Las cuerdas, con su nota al aire.
        for cuerda in 0..<cuerdas {
            let y = fila(cuerda)
            cuerpo.append(linea(izquierda, y, ancho - 10, y, "#555555", 1))
            let alAire = mastil.encordado.afinacion[cuerda].nota.nombre(en: notacion)
            cuerpo.append(Hoja.texto(alAire, x: 4, y: y + 3.5, tamano: 9, color: "#555555"))
        }
        // Las notas: un punto con su nombre, como se escribe en la escala.
        let tonica = tonica?.claseDeAltura
        for nota in notas where trastes.contains(nota.traste) && (0..<cuerdas).contains(nota.cuerda) {
            let x =
                nota.traste == 0
                ? izquierda + alAire / 2 : inicio + (Double(nota.traste - primero) + 0.5) * anchoDelTraste
            let altura = mastil.altura(en: nota)
            let clase = altura.nota.claseDeAltura
            let escrita = ortografia.first { $0.claseDeAltura == clase } ?? altura.nota
            let color = clase == tonica ? DibujoDeLaHoja.tonica : DibujoDeLaHoja.nota
            cuerpo.append(
                "<circle cx=\"\(Hoja.numero(x))\" cy=\"\(Hoja.numero(fila(nota.cuerda)))\" r=\"7\" fill=\"\(color)\"/>")
            cuerpo.append(
                "<text x=\"\(Hoja.numero(x))\" y=\"\(Hoja.numero(fila(nota.cuerda) + 3))\" font-size=\"7.5\" fill=\"#ffffff\" "
                    + "text-anchor=\"middle\">" + EscrituraXML.escapar(escrita.nombre(en: notacion)) + "</text>")
        }
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Hoja.numero(ancho)) \(Hoja.numero(alto))\" "
            + "font-family=\"Helvetica, Arial, sans-serif\">" + cuerpo.joined() + "</svg>"
    }
}

/// Los colores de los dibujos propios de las hojas (el mástil): los de las notas y la tónica de los otros dibujos.
enum DibujoDeLaHoja {
    static let nota = "#1f4e9c"
    static let tonica = "#f39c12"
}
