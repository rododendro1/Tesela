import ArmoniaNucleo
import ArmoniaTeoria

// Lo que comparten las exportaciones a MusicXML (MusicXML.swift), a MEI (MEI.swift) y a MIDI
// (ArchivoMIDI.swift).

/// Lo que comparten las exportaciones a MusicXML, MEI y MIDI: la tonalidad que se estima, las
/// divisiones del tiempo, las figuras, cómo se preparan las voces de un coral y de una
/// progresión y lo que se anota en ellas.
package enum Exportacion {
    /// La tonalidad que se estima para una voz, por sus notas y lo que duran.
    package static func tonalidad(de voz: Voz) -> Tonalidad? {
        let alturas = voz.eventos.flatMap(\.alturas)
        let duraciones = voz.eventos.flatMap { e in e.alturas.map { _ in e.duracion.enRedondas } }
        return Tonalidad.identificar(alturas: alturas, duraciones: duraciones).first
    }

    /// Divisiones por negra: lo mínimo para que todas las duraciones sean enteras.
    package static func divisiones(_ duraciones: [Duracion]) -> Int {
        duraciones.reduce(1) { resultado, d in
            guard d.numerador > 0 else { return resultado }
            // d en negras = 4·num/den; hace falta que divisiones·4·num/den sea entero.
            let necesario = d.denominador / maximoComunDivisor(4 * d.numerador, d.denominador)
            return resultado / maximoComunDivisor(resultado, necesario) * necesario
        }
    }

    /// Lo que dura el último de `cuantos` acordes de `duracion` para que acabe en la barra.
    package static func hastaLaBarra(_ duracion: Duracion, _ cuantos: Int, _ compas: Compas) -> Duracion {
        let total = duracion * cuantos
        let enCompases = total / compas.duracion
        let resto = total - compas.duracion * (enCompases.numerador / enCompases.denominador)
        return resto.esCero ? duracion : duracion + compas.duracion - resto
    }

    /// Las notas apiladas en posición cerrada: la primera, en la primera octava en que su MIDI
    /// llegue a `minimo`, y cada una, en la primera octava por encima de la anterior.
    package static func posicionCerrada(_ notas: [Nota], desde minimo: Int) -> [Altura] {
        var alturas: [Altura] = []
        for nota in notas {
            let limite = alturas.last.map { $0.midi + 1 } ?? minimo
            var octava = 0
            while Altura(nota, octava: octava).midi < limite { octava += 1 }
            alturas.append(Altura(nota, octava: octava))
        }
        return alturas
    }

    /// Una voz de un coral: una nota por acorde, de `duracion`, y la última de `final`.
    package static func eventos(de alturas: [Altura], duracion: Duracion, final: Duracion) -> [Evento] {
        alturas.enumerated().map { Evento($1, $0 == alturas.count - 1 ? final : duracion) }
    }

    /// Las dos voces de una progresión: los acordes en posición cerrada desde La3 y el bajo
    /// desde Fa2, de `duracion` cada uno, y el último de `final`.
    package static func progresion(_ acordes: [Acorde], duracion: Duracion, final: Duracion) -> (
        acordes: [Evento], bajo: [Evento]
    ) {
        var superior: [Evento] = []
        var grave: [Evento] = []
        for (i, acorde) in acordes.enumerated() {
            let figura = i == acordes.count - 1 ? final : duracion
            superior.append(Evento(alturas: posicionCerrada(acorde.notas, desde: 57), duracion: figura))
            grave.append(Evento(posicionCerrada([acorde.bajo], desde: 41)[0], figura))
        }
        return (superior, grave)
    }

    /// La figura con que se escribe una duración y, si es de un grupo irregular, la proporción:
    /// 1/12 → corchea de tresillo (3 en el tiempo de 2). Sin figura si no se puede escribir así.
    package static func figura(de duracion: Duracion) -> (
        figura: Figura?, puntillos: Int, irregular: (reales: Int, normales: Int)?
    ) {
        if let (figura, puntillos) = duracion.figuraYPuntillos { return (figura, puntillos, nil) }
        var impar = duracion.denominador
        while impar % 2 == 0 { impar /= 2 }
        guard impar > 1 else { return (nil, 0, nil) }
        var normales = 1
        while normales * 2 < impar { normales *= 2 }
        if let (figura, puntillos) = (duracion * Duracion(impar, normales)).figuraYPuntillos {
            return (figura, puntillos, (impar, normales))
        }
        return (nil, 0, nil)
    }

    /// Las voces de un coral repartidas en dos pentagramas, como se escriben: las de la mitad
    /// aguda arriba y las de la grave abajo, de aguda a grave en cada uno. Si comparten
    /// pentagrama, la plica de la de arriba va hacia arriba y la de la de abajo, hacia abajo.
    /// `indice` es el de la voz en el coral (0, el bajo), y el último acorde se alarga hasta la barra.
    package static func voces(de coral: Coral, duracion: Duracion, compas: Compas)
        -> [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)]
    {
        let n = coral.numeroDeVoces
        let agudas = Array((n / 2..<n).reversed())
        let graves = Array((0..<n / 2).reversed())
        let final = hastaLaBarra(duracion, coral.acordes.count, compas)
        var voces: [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)] = []
        for (pentagrama, indices) in [(1, agudas), (2, graves)] {
            for (k, v) in indices.enumerated() {
                let linea = Voz(eventos(de: coral.voz(v), duracion: duracion, final: final), compas: compas)
                voces.append((linea, pentagrama, indices.count == 1 ? nil : k == 0, v))
            }
        }
        return voces
    }

    // MARK: Anotaciones

    /// Lo que se anota en un coral o en una progresión, por el punto en que empieza cada acorde
    /// (contado desde el principio): el acorde que se cifra encima de la voz más aguda y el
    /// análisis que se escribe debajo de la más grave.
    package struct Anotaciones {
        /// La de la armadura.
        package var tonalidad: Tonalidad?
        /// La que se escribe al principio, debajo del bajo, si se analiza.
        package var tonalidadDelAnalisis: Tonalidad?
        package var cifrados: [Duracion: Acorde] = [:]
        package var analisis: [Duracion: AcordeAnalizado] = [:]
    }

    /// Las anotaciones de un coral. Los acordes se identifican por sus notas (con el bajo) entre
    /// los tipos de `TipoDeAcorde.todos`; los que no forman ninguno se quedan sin cifrar. Sin
    /// `tonalidad`, se estima: a partir de los acordes si se analiza, si no, de las notas.
    package static func anotaciones(
        de coral: Coral, duracion: Duracion, tonalidad: Tonalidad?,
        cifrados: Bool, analisis: Bool
    ) -> Anotaciones {
        // Los acordes que se pueden identificar, con su posición en el coral.
        var identificados: [(indice: Int, acorde: Acorde)] = []
        if cifrados || analisis {
            for (i, alturas) in coral.acordes.enumerated() {
                // Solo los tipos del catálogo: un acorde con notas de paso no se cifra como «add♭9».
                if let acorde = Acorde.candidatos(alturas).first(where: { TipoDeAcorde.todos.contains($0.valor.tipo) })?
                    .valor
                {
                    identificados.append((i, acorde))
                }
            }
        }
        let analizado: AnalisisArmonico? =
            analisis
            ? (tonalidad.map { $0.analizar(identificados.map(\.acorde)) }
                ?? AnalisisArmonico.analizar(identificados.map(\.acorde)))
            : nil
        var resultado = Anotaciones()
        resultado.tonalidad =
            tonalidad ?? analizado?.tonalidad ?? Tonalidad.identificar(alturas: coral.acordes.flatMap { $0 }).first
        resultado.tonalidadDelAnalisis = analizado?.tonalidad
        for (k, (i, acorde)) in identificados.enumerated() {
            if cifrados { resultado.cifrados[duracion * i] = acorde }
            if let analizado, k < analizado.acordes.count { resultado.analisis[duracion * i] = analizado.acordes[k] }
        }
        return resultado
    }

    /// Las anotaciones de una progresión ya analizada.
    package static func anotaciones(
        de progresion: AnalisisArmonico, duracion: Duracion,
        cifrados: Bool, analisis: Bool
    ) -> Anotaciones {
        var resultado = Anotaciones()
        resultado.tonalidad = progresion.tonalidad
        if analisis { resultado.tonalidadDelAnalisis = progresion.tonalidad }
        for (i, analizado) in progresion.acordes.enumerated() {
            if cifrados { resultado.cifrados[duracion * i] = analizado.acorde }
            if analisis { resultado.analisis[duracion * i] = analizado }
        }
        return resultado
    }

    /// Los textos de análisis de un acorde: el cifrado romano y la abreviatura de la función.
    package static func letras(_ analizado: AcordeAnalizado) -> [String] {
        [analizado.cifrado, analizado.funcion?.abreviatura ?? ""]
    }

    /// El texto con `&`, `<`, `>` y `"` escritos como entidades, para ponerlo en XML.
    package static func escapar(_ texto: String) -> String {
        var resultado = ""
        for caracter in texto {
            switch caracter {
            case "&": resultado += "&amp;"
            case "<": resultado += "&lt;"
            case ">": resultado += "&gt;"
            case "\"": resultado += "&quot;"
            default: resultado.append(caracter)
            }
        }
        return resultado
    }

    /// Un número sin decimales si es entero: 90 → "90", 92.5 → "92.5".
    package static func formatear(_ valor: Double) -> String {
        valor == valor.rounded() ? String(Int(valor)) : String(valor)
    }
}
