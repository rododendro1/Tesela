//
//  LecturaEnUnaNotacion.swift
//  Teoria
//
//  Leer un acorde, una escala o una tonalidad escritos en una notación concreta: lo que escriben `cifrado(en:)` y
//  `nombre(en:)` se lee de vuelta en los doce idiomas.
//

import Elementos

extension Acorde {
    /// Lee un cifrado escrito en una notación concreta, como lo escribe `cifrado(en:)`:
    /// `Acorde(leyendo: "B7/D", en: .compacta(.aleman))` es Si♭7/Re (y no Si7), `Acorde(leyendo: "Rém7", en:
    /// .compacta(.frances))`, `Acorde(leyendo: "Фа♯m7(♭5)", en: .compacta(.ruso))`. La fundamental y el bajo se leen
    /// como en `Nota(leyendo:en:)`; el resto, como en `init(leyendo:)`. En español e inglés, igual que
    /// `init(leyendo:)`.
    public init(leyendo cifrado: String, en notacion: Notacion) throws {
        let idioma = notacion.idiomaDeLasNotas
        guard idioma != .espanol && idioma != .ingles else {
            try self.init(leyendo: cifrado)
            return
        }
        var inicio = Lector(cifrado)
        try inicio.exigirContenido()
        let texto = cifrado
        // La fundamental es el nombre de nota más largo del principio que deja detrás un cifrado: «As» y «us4» no lo
        // dejan, «A» y «sus4» sí.
        var primerError: (any ErrorAlLeer)?
        for largo in stride(from: min(texto.count, 20), through: 1, by: -1) {
            let corte = texto.index(texto.startIndex, offsetBy: largo)
            let nombre = String(texto[..<corte]).trimmingEspacios()
            guard !nombre.isEmpty, let fundamental = try? Nota(leyendo: nombre, en: notacion) else { continue }
            let resto = texto[corte...]
            var simbolo = resto
            var bajo = fundamental
            // La barra del bajo es la última seguida de un nombre de nota (así "6/9" no se confunde).
            if let barra = resto.lastIndex(of: "/"),
                let nota = try? Nota(
                    leyendo: String(resto[resto.index(after: barra)...]).trimmingEspacios(), en: notacion)
            {
                bajo = nota
                simbolo = resto[..<barra]
            }
            do {
                let tipo = try TipoDeAcorde(lector: Lector(texto: texto, fragmento: simbolo))
                self.init(fundamental, tipo, bajo: bajo)
                return
            } catch let error as any ErrorAlLeer {
                if primerError == nil { primerError = error }
            }
        }
        throw primerError ?? inicio.error(.notaNoReconocida)
    }
}

extension Escala {
    /// Lee una escala escrita en una notación concreta, como la escribe `nombre(en:)`: `Escala(leyendo: "B dorisch",
    /// en: .compacta(.aleman))` es Si♭ dórico, `Escala(leyendo: "re dòric", en: .conPalabras(.catalan))`,
    /// `Escala(leyendo: "фа-диез гармонический минор", en: .conPalabras(.ruso))`. La tónica se lee como en
    /// `Nota(leyendo:en:)` y el tipo, en el idioma de los textos de la notación (o con su nombre en español, el de
    /// las escalas que no tienen otro). En español e inglés, igual que `init(leyendo:)`.
    public init(leyendo texto: String, en notacion: Notacion) throws {
        let idioma = notacion.idiomaDeLasNotas
        guard idioma != .espanol && idioma != .ingles else {
            try self.init(leyendo: texto)
            return
        }
        var lector = Lector(texto)
        try lector.exigirContenido()
        // La tónica puede ocupar varias palabras («si bemol bikoitza», «F Kreuz»); se prueba de más a menos.
        let palabras = texto.split(separator: " ").map(String.init)
        var tipoSinLeer: String?
        for cuantas in stride(from: min(4, palabras.count - 1), through: 1, by: -1) {
            let nombre = palabras[..<cuantas].joined(separator: " ")
            guard let tonica = try? Nota(leyendo: nombre, en: notacion) else { continue }
            let tipo = palabras[cuantas...].joined(separator: " ")
            if let encontrado = Escala.tipo(tipo, en: notacion) {
                self.init(tonica, encontrado)
                return
            }
            if tipoSinLeer == nil { tipoSinLeer = tipo }
        }
        guard let tipo = tipoSinLeer else { throw lector.error(.notaNoReconocida) }
        throw ErrorDeLecturaDeTeoria(texto: texto, posicion: nil, motivo: .tipoDeEscalaNoReconocido(tipo))
    }

    /// El tipo por su nombre en el idioma de los textos de la notación o, si no, por el de su tónica, por su nombre
    /// en español (el de las escalas sin traducción) o en inglés.
    private static func tipo(_ nombre: String, en notacion: Notacion) -> TipoDeEscala? {
        let normalizado = TipoDeEscala.normalizar(nombre)
        if notacion.textos != .espanol, let tipo = NombresDeEscalas.de(notacion.textos).indice[normalizado] {
            return tipo
        }
        return TipoDeEscala.buscar(nombre: nombre, conTonicaEn: .conPalabras(notacion.idiomaDeLasNotas))
            ?? TipoDeEscala.buscar(nombre: nombre, aceptarIngles: true)
    }
}

extension Tonalidad {
    /// Lee una tonalidad escrita en una notación concreta, como la escribe `nombre(en:)`: `Tonalidad(leyendo:
    /// "B-Dur", en: .compacta(.aleman))` es Si♭ mayor, `Tonalidad(leyendo: "H bé-dúr", en: .conPalabras(.hungaro))`,
    /// `Tonalidad(leyendo: "фа-диез минор", en: .conPalabras(.ruso))`. La tónica se lee como en `Nota(leyendo:en:)`.
    /// En español e inglés, igual que `init(leyendo:)`.
    public init(leyendo texto: String, en notacion: Notacion) throws {
        let idioma = notacion.idiomaDeLasNotas
        guard idioma != .espanol && idioma != .ingles else {
            try self.init(leyendo: texto)
            return
        }
        var lector = Lector(texto)
        try lector.exigirContenido()
        let limpio = texto.trimmingEspacios()
        let separador = idioma.reglas.separadorDelModo
        for modo in [Modo.mayor, .menor] {
            let palabra = modo.nombre(en: notacion)
            guard limpio.claveDeBusqueda.hasSuffix((separador + palabra).claveDeBusqueda) else { continue }
            let tonica = String(limpio.dropLast(separador.count + palabra.count)).trimmingEspacios()
            self.init(try Nota(leyendo: tonica, en: notacion), modo)
            return
        }
        throw ErrorDeLecturaDeTeoria(texto: texto, posicion: nil, motivo: .modoNoReconocido(limpio))
    }
}
