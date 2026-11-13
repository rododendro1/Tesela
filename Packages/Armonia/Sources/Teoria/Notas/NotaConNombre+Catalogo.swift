import Elementos
import Foundation

// MARK: - El catálogo de notas
//
// Las notas con nombre propio: los diapasones y las notas de referencia, escritos aquí uno a uno, y las posiciones de
// la mano guidoniana y las alturas con nombre de las tradiciones árabe, turca y griega, que salen de
// `ManoGuidoniana.gamut` y de `NombresPorOctava`. Los nombres en los otros idiomas están en `Notas/Nombres/`.

extension NotaConNombre {
    // MARK: Diapasones

    /// El La4 a 440 Hz, el de la conferencia de Londres de 1939 y la norma ISO 16.
    public static let la440 = diapason(
        "La 440", Altura(.la, octava: 4), 440, anio: 1939, alias: ["diapasón estándar"], variantes: ["La 440 Hz"])
    /// El La4 a 442 Hz, el de muchas orquestas europeas.
    public static let la442 = diapason("La 442", Altura(.la, octava: 4), 442)
    /// El La4 a 432 Hz, el que pidió Verdi en 1884 para las bandas militares italianas.
    public static let la432 = diapason(
        "La 432", Altura(.la, octava: 4), 432, anio: 1884, alias: ["diapasón de Verdi"])
    /// El La4 a 415 Hz, un semitono bajo el 440: el de la música barroca en instrumentos de época.
    public static let la415 = diapason("La 415", Altura(.la, octava: 4), 415, alias: ["diapasón barroco"])
    /// El La4 a 430 Hz, el de la música clásica en instrumentos de época.
    public static let la430 = diapason("La 430", Altura(.la, octava: 4), 430, alias: ["diapasón clásico"])
    /// El La4 a 422,5 Hz, el del diapasón de Händel, de 1751.
    public static let la4225 = diapason(
        "La 422,5", Altura(.la, octava: 4), 422.5, anio: 1751, alias: ["diapasón de Händel"],
        variantes: ["La 422.5"])
    /// El La4 a 435 Hz, el diapasón normal que fijó Francia en 1859.
    public static let la435 = diapason(
        "La 435", Altura(.la, octava: 4), 435, anio: 1859, alias: ["diapasón normal francés"])
    /// El La4 a unos 466 Hz, el Chorton de los órganos alemanes del Barroco, un semitono sobre el 440.
    public static let la466 = diapason("La 466", Altura(.la, octava: 4), 466, alias: ["Chorton"])
    /// El La4 a 452,5 Hz, el de la Sociedad Filarmónica de Londres en el siglo XIX.
    public static let la4525 = diapason(
        "La 452,5", Altura(.la, octava: 4), 452.5, alias: ["diapasón filarmónico antiguo"], variantes: ["La 452.5"])
    /// El Do4 a 256 Hz, una potencia de dos: el de Sauveur, con el La4 a unos 430,5 Hz.
    public static let do256 = diapason(
        "Do 256", Altura(.do, octava: 4), 256, alias: ["afinación científica", "diapasón de Sauveur"])

    // MARK: Notas de referencia

    /// El Do4, el del centro del piano: MIDI 60.
    public static let doCentral = NotaConNombre(
        nombre: "Do central", altura: Altura(.do, octava: 4), familia: .referencia)
    /// El La0, la tecla más grave del piano de 88 teclas.
    public static let laMasGraveDelPiano = NotaConNombre(
        nombre: "La más grave del piano", altura: Altura(.la, octava: 0), familia: .referencia)
    /// El Do8, la tecla más aguda del piano de 88 teclas.
    public static let doMasAgudoDelPiano = NotaConNombre(
        nombre: "Do más agudo del piano", altura: Altura(.do, octava: 8), familia: .referencia)
    /// El Do-1, la nota MIDI más grave.
    public static let notaMidi0 = NotaConNombre(
        nombre: "nota MIDI 0", altura: Altura(midi: 0), familia: .referencia)
    /// El Sol9, la nota MIDI más aguda.
    public static let notaMidi127 = NotaConNombre(
        nombre: "nota MIDI 127", altura: Altura(midi: 127), familia: .referencia)

    /// Los diapasones y las notas de referencia, en el orden de este fichero.
    static let escritas: [NotaConNombre] = [
        .la440, .la442, .la432, .la415, .la430, .la4225, .la435, .la466, .la4525, .do256, .doCentral,
        .laMasGraveDelPiano, .doMasAgudoDelPiano, .notaMidi0, .notaMidi127,
    ]

    // MARK: Las que salen de sus tablas

    /// Las veinte posiciones de la mano guidoniana, de Γ ut a ee la. En las dobles, «b fa ♮ mi» y «bb fa ♮♮ mi», la
    /// altura es la del fa (Si♭); la del mi está en `posicion`.
    static var guidonianas: [NotaConNombre] {
        ManoGuidoniana.gamut.map { posicion in
            NotaConNombre(
                nombre: posicion.nombre, altura: posicion.alturas[0], familia: .guidoniana, posicion: posicion,
                referencias: [.apel1958])
        }
    }

    /// Las alturas con nombre de una tradición: el nombre transliterado, y de alias el original y de variante el
    /// ASCII, si son otros.
    static func deTradicion(_ sistema: NombresPorOctava) -> [NotaConNombre] {
        let (familia, referencias): (FamiliaDeNota, [Referencia]) =
            switch sistema {
            case .arabe: (.arabe, [.touma1996, .maqamWorld])
            case .turco: (.turca, [.signell1977])
            case .griegoAntiguo: (.griega, [.west1992])
            }
        return sistema.alturas.map { altura in
            let nombre = altura.nombre(en: .transliterada)
            let original = altura.nombre(en: .original)
            let ascii = altura.nombre(en: .ascii)
            return NotaConNombre(
                nombre: nombre, altura: altura.altura, familia: familia, desvio: desvio(de: altura),
                alias: original == nombre ? [] : [original], variantes: ascii == nombre ? [] : [ascii],
                alturaConNombre: altura, referencias: referencias)
        }
    }

    /// Lo que se aparta en cents de su altura temperada: en el árabe, 50 por cuarto de tono; en el turco, la perde en
    /// comas de 1200/53 cents menos el semitono temperado; en el griego, nada.
    static func desvio(de altura: AlturaConNombre) -> Double {
        guard let microtonal = altura.notaMicrotonal else { return 0 }
        let temperada = Double(modulo(altura.altura.midi - 60, 12) * 100)
        var desvio = microtonal.cents - temperada
        if desvio > 600 { desvio -= 1200 }
        if desvio <= -600 { desvio += 1200 }
        return desvio
    }

    /// Las notas en el orden del catálogo, sin dos nombres que se lean igual: si el de una ya es de otra (Rast es la
    /// nota árabe Rāst y la perde turca; E la mi, la posición grave y la aguda), se le añade la altura: «Rast (Sol4)»,
    /// «e la mi (Mi4)»; y sus alias y variantes que ya son de otra no se dan.
    static func sinRepetir(_ notas: [NotaConNombre]) -> [NotaConNombre] {
        var usados = Set<String>()
        func clave(_ texto: String) -> String { NombresDelCatalogo<NotaConNombre>.normalizar(texto) }
        return notas.map { nota in
            let nombre = usados.contains(clave(nota.nombre)) ? "\(nota.nombre) (\(nota.altura))" : nota.nombre
            let alias = nota.alias.filter { !usados.contains(clave($0)) }
            let variantes = nota.variantes.filter { !usados.contains(clave($0)) }
            usados.formUnion(([nombre] + alias + variantes).map(clave))
            return NotaConNombre(
                nombre: nombre, altura: nota.altura, familia: nota.familia, desvio: nota.desvio,
                frecuenciaDelLa4: nota.frecuenciaDelLa4, anio: nota.anioDeOrigen, alias: alias, variantes: variantes,
                alturaConNombre: nota.alturaConNombre, posicion: nota.posicion, referencias: nota.referencias)
        }
    }

    /// Todo el catálogo: los diapasones, las notas de referencia, las posiciones guidonianas, las notas árabes, las
    /// perde turcas y las cuerdas griegas.
    public static let catalogo: [NotaConNombre] = sinRepetir(
        escritas + guidonianas + deTradicion(.arabe) + deTradicion(.turco) + deTradicion(.griegoAntiguo))
}
