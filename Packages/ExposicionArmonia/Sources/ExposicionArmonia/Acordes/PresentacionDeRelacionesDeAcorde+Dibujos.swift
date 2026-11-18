import Armonia

extension PresentacionDeRelacionesDeAcorde {
    // MARK: Los dibujos de la hoja de un acorde

    /// El diagrama de una digitación como SVG suelto, con su margen: el de `diagrama(de:x:y:en:)`, del ancho de sus
    /// cuerdas.
    static func diagramaSVG(de forma: Digitacion) -> String {
        var dibujo: [String] = []
        let alto = diagrama(de: forma, x: 4, y: 4, en: &dibujo) + 8
        let ancho = 30 + Double(max(forma.trastes.count - 1, 1)) * 11
        return Hoja.dibujoSVG(ancho: max(ancho, 70), alto: alto, dibujo)
    }

    /// El diagrama de una digitación, como en los cancioneros: una línea por cuerda (la más grave a la izquierda),
    /// cuatro trastes, un punto en cada nota pisada, «x» en las que no suenan y «o» en las que suenan al aire, el
    /// traste de partida si no es el primero y la tablatura debajo. Da el alto que ocupa.
    static func diagrama(de forma: Digitacion, x: Double, y: Double, en cuerpo: inout [String]) -> Double {
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
