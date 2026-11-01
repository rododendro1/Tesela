import Armonia

/// Transportar lo escrito en los campos de las apps y en la línea de comandos: una progresión («Do Lam Re7 Sol7»),
/// una melodía («Mi4:4 Re4:8») o un coral («Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4»), palabra a palabra. No usa
/// SwiftUI, así que se prueba en Linux.
///
///     try PresentacionDeTransposicion.transponer("Do Lam Re7 Sol7", .segundaMayor, notacion: .espanolCompacto)
///     // "Re Sim Mi7 La7"
public enum PresentacionDeTransposicion {
    /// Lo que hay escrito: acordes (Sol7 es el acorde) o notas (Sol7 es el Sol de la octava 7).
    public enum Contenido: Hashable, Sendable {
        /// Cifrados: «Do Lam Re7 Sol7».
        case acordes
        /// Alturas, notas sin octava o eventos con duración: «Do3 Mi4 Sol4», «Mi Fa Re Do», «Mi4:4 Re4:8».
        case notas
    }

    /// Los intervalos del menú «Transponer», de menor a mayor; cada uno se ofrece subiendo y bajando.
    public static let intervalos: [Intervalo] = [
        .segundaMenor, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta, .quintaJusta,
    ]

    /// Las tonalidades a las que se puede llevar una progresión: las doce del modo de `tonalidad` (de Re♭ a Fa♯
    /// en mayor, de Si♭ a Re♯ en menor), sin ella.
    public static func destinos(desde tonalidad: Tonalidad) -> [Tonalidad] {
        (-5...6).map { Tonalidad(armadura: $0, modo: tonalidad.modo) }.filter { $0.tonica != tonalidad.tonica }
    }

    /// El texto con cada altura, nota, evento o acorde transportado, y lo demás (barras, comas, silencios) tal
    /// cual. Lanza el error de lectura de la primera palabra que no se entiende.
    public static func transponer(
        _ texto: String, _ intervalo: Intervalo, contenido: Contenido = .acordes, notacion: Notacion
    ) throws -> String {
        var resultado = ""
        var palabra = ""
        func cerrar() throws {
            guard !palabra.isEmpty else { return }
            resultado += try transponer(palabra: palabra, intervalo, contenido: contenido, notacion: notacion)
            palabra = ""
        }
        for caracter in texto {
            if caracter.isWhitespace || caracter == "," || caracter == "|" {
                try cerrar()
                resultado.append(caracter)
            } else {
                palabra.append(caracter)
            }
        }
        try cerrar()
        return resultado
    }

    /// El texto llevado de una tonalidad a otra por el camino más corto (de Do a La, una tercera menor abajo).
    public static func transponer(
        _ texto: String, de origen: Tonalidad, a destino: Tonalidad, contenido: Contenido = .acordes,
        notacion: Notacion
    ) throws -> String {
        let intervalo = origen.tonica.intervaloMasCorto(hasta: destino.tonica)
        return try transponer(texto, intervalo, contenido: contenido, notacion: notacion)
    }

    /// La tonalidad de lo escrito, para llevarlo a otra tónica: la del análisis de los acordes, o la que mejor
    /// encaja con las notas. `nil` si no se lee nada.
    public static func tonalidad(de texto: String, contenido: Contenido = .acordes) -> Tonalidad? {
        let palabras = texto.split(whereSeparator: { $0.isWhitespace || $0 == "," || $0 == "|" }).map(String.init)
        switch contenido {
        case .acordes:
            return AnalisisArmonico.analizar(palabras.compactMap { try? Acorde(leyendo: $0) })?.tonalidad
        case .notas:
            let notas = palabras.flatMap { palabra -> [Nota] in
                if let evento = try? Evento(leyendo: palabra) { return evento.alturas.map(\.nota) }
                if let altura = try? Altura(leyendo: palabra) { return [altura.nota] }
                return (try? Nota(leyendo: palabra)).map { [$0] } ?? []
            }
            return notas.isEmpty ? nil : Tonalidad.identificar(notas: notas).first
        }
    }

    /// Unos acordes como se escriben en el campo de la progresión, en la notación si se vuelven a leer igual.
    public static func texto(de acordes: [Acorde], notacion: Notacion) -> String {
        acordes.map { escribir($0, notacion) }.joined(separator: " ")
    }

    /// Una progresión abierta de un fichero, con su ritmo armónico y su título, en otra tonalidad.
    public static func transponer(_ progresion: ProgresionImportada, _ intervalo: Intervalo) -> ProgresionImportada {
        ProgresionImportada(
            acordes: progresion.acordes.map { $0.transponer(intervalo) }, ritmo: progresion.ritmo,
            titulo: progresion.titulo)
    }

    /// Una palabra: un acorde (Sol7/Si) o, en las notas, un evento con duración (Do4:8, Do4+Mi4:2, -:4), una
    /// altura (Do4) o una nota sin octava (Mi). Un guion o una tilde sueltos se dejan.
    static func transponer(
        palabra: String, _ intervalo: Intervalo, contenido: Contenido, notacion: Notacion
    ) throws -> String {
        if palabra.allSatisfy({ "-~".contains($0) }) { return palabra }
        switch contenido {
        case .acordes:
            let acorde = try Acorde(leyendo: palabra)
            return escribir(acorde.transponer(intervalo), notacion)
        case .notas:
            if palabra.contains(":") {
                let evento = try Evento(leyendo: palabra)
                return escribir(evento.transponer(intervalo), notacion)
            }
            if let altura = try? Altura(leyendo: palabra) { return escribir(altura.transponer(intervalo), notacion) }
            let nota = try Nota(leyendo: palabra)
            return escribir(nota.transponer(intervalo), notacion)
        }
    }

    /// El valor escrito en la notación si se vuelve a leer igual; si no (una notación que las lecturas no
    /// entienden), en la española, con la octava escrita como en la notación.
    private static func escribir<T: RepresentableComoTexto & Equatable>(_ valor: T, _ notacion: Notacion) -> String {
        let escrito = valor.texto(en: notacion)
        return (try? T(leyendo: escrito)) == valor
            ? escrito : valor.texto(en: Notacion.espanolCompacto.conOctavas(notacion.octavas))
    }
}
