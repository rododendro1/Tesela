import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: los valores de las opciones del catálogo de escalas
//
// Cómo se escriben en `escalas` la tradición, el estilo, la corriente, la época, el afecto, la escuela, la afinación,
// el lugar y la fuente, y cómo se leen. El catálogo está en LineaDeComandos+CatalogoDeEscalas.swift y su filtro en
// LineaDeComandos+CatalogoDeEscalas+Filtro.swift.

extension LineaDeComandos {
    /// Cómo se escribe cada tradición en `--tradicion`, con los nombres españoles y con los ingleses (se aceptan los
    /// dos en cualquier idioma): `--tradicion mundo-arabe`, `--tradition arab-world`.
    static let nombresDeLasTradiciones: [(tradicion: Tradicion, espanol: String, ingles: String)] = [
        (.india, "india", "india"), (.grecia, "grecia", "greece"), (.greciaAntigua, "grecia-antigua", "ancient-greece"),
        (.mundoArabe, "mundo-arabe", "arab-world"), (.persia, "persia", "persia"), (.turquia, "turquia", "turkey"),
        (.azerbaiyan, "azerbaiyan", "azerbaijan"), (.china, "china", "china"), (.japon, "japon", "japan"),
        (.corea, "corea", "korea"), (.etiopia, "etiopia", "ethiopia"), (.indonesia, "indonesia", "indonesia"),
        (.klezmer, "klezmer", "klezmer"), (.andes, "andes", "andes"), (.bizancio, "bizancio", "byzantium"),
        (.mesopotamia, "mesopotamia", "mesopotamia"), (.africa, "africa", "africa"),
        (.sudesteAsiatico, "sudeste-asiatico", "southeast-asia"), (.gregoriano, "gregoriano", "gregorian"),
        (.europa, "europa", "europe"), (.vietnam, "vietnam", "vietnam"), (.brasil, "brasil", "brazil"),
        (.renacimiento, "renacimiento", "renaissance"),
    ]

    /// Cómo se escribe cada estilo occidental en `--estilo`, en español y en inglés (se aceptan los dos en cualquier
    /// idioma): `--estilo de-compositor`, `--style composer`. `popular` da los tres populares, y `siglo-xx`, el nombre
    /// de antes, las de compositor.
    static let nombresDeLosEstilos: [(usos: [Estilo], espanol: String, ingles: String)] = [
        ([.clasica], "clasica", "classical"), ([.jazz], "jazz", "jazz"), ([.blues], "blues", "blues"),
        ([.deCompositor], "de-compositor", "composer"), ([.folclore], "folclore", "folk"),
        ([.flamenco], "flamenco", "flamenco"), ([.popRock], "pop-rock", "pop-rock"),
        (Estilo.populares, "popular", "popular"), ([.sintetica], "sintetica", "synthetic"),
        ([.deCompositor], "siglo-xx", "20th-century"),
    ]

    /// Cómo se escribe cada corriente en `escalas --estilo`, en español y en inglés: `--estilo bebop`, `--style
    /// neoclassical-metal`.
    static let nombresDeLasCorrientes: [(corriente: Corriente, espanol: String, ingles: String)] = [
        (.bebop, "bebop", "bebop"), (.modal, "modal", "modal"), (.impresionismo, "impresionismo", "impressionism"),
        (.rock, "rock", "rock"), (.heavyMetal, "heavy-metal", "heavy-metal"),
        (.metalNeoclasico, "metal-neoclasico", "neoclassical-metal"),
    ]

    /// La corriente de `escalas --estilo modal`, por su clave, en español o en inglés, o por su nombre en español o en
    /// el idioma de la notación («jazz modal»); `nil` si no es ninguna.
    static func corriente(leyendo texto: String, _ notacion: Notacion) -> Corriente? {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasCorrientes.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.corriente
        }
        return Corriente.allCases.first { [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave) }
    }

    /// Los estilos de `--estilo jazz`, por su clave (`de-compositor`), en español o en inglés, o por el nombre de un
    /// estilo en español o en el idioma de la notación; lanza `estiloDesconocido` si no es ninguno.
    static func estilos(leyendo texto: String, _ notacion: Notacion) throws -> [Estilo] {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLosEstilos.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.usos
        }
        guard
            let porNombre = Estilo.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.estiloDesconocido(texto) }
        return [porNombre]
    }

    /// Cómo se escribe cada forma de agrupar en `--agrupar`, en español y en inglés (se aceptan los dos en cualquier
    /// idioma): `--agrupar pais`, `--group-by country`.
    static let nombresDeLasAgrupaciones: [(agrupacion: AgrupacionDeEscalas, espanol: String, ingles: String)] = [
        (.continente, "continente", "continent"), (.pais, "pais", "country"), (.epoca, "epoca", "era"),
    ]

    /// Cómo se escribe cada época en `--epoca`, en español y en inglés (se aceptan los dos en cualquier idioma):
    /// `--epoca edad-media`, `--era middle-ages`. `tonal` da las tres de la época tonal.
    static let nombresDeLasEpocas: [(epocas: [Epoca], espanol: String, ingles: String)] = [
        ([.antiguedad], "antiguedad", "antiquity"), ([.edadMedia], "edad-media", "middle-ages"),
        ([.renacimiento], "renacimiento", "renaissance"), ([.barroco], "barroco", "baroque"),
        ([.clasicismo], "clasicismo", "classicism"), ([.romanticismo], "romanticismo", "romanticism"),
        ([.sigloXX], "siglo-xx", "20th-century"), ([.sigloXXI], "siglo-xxi", "21st-century"),
        (Epoca.tonales, "tonal", "tonal"),
    ]

    /// Las épocas de `--epoca barroco`, por su clave, en español o en inglés, o por su nombre en español o en el
    /// idioma de la notación («Barroco», «Baroque»); lanza `epocaDesconocida` si no es ninguna.
    static func epocas(leyendo texto: String, _ notacion: Notacion) throws -> [Epoca] {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasEpocas.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.epocas
        }
        guard
            let porNombre = Epoca.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.epocaDesconocida(texto) }
        return [porNombre]
    }

    /// El afecto de `--afecto lastimero`, por su clave (la de `Afecto`) o por su nombre en español, en inglés o en el
    /// idioma de la notación («plaintive», «klagend»); lanza `afectoDesconocido` si no es ninguno.
    static func afecto(leyendo texto: String, _ notacion: Notacion) throws -> Afecto {
        let clave = claveDeBusqueda(texto)
        guard
            let afecto = Afecto.allCases.first(where: {
                [$0.rawValue, $0.nombre, $0.nombre(en: .compacta(.ingles)), $0.nombre(en: notacion)]
                    .map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.afectoDesconocido(texto) }
        return afecto
    }

    /// Cómo se escribe cada escuela en `--escuela`, en español y en inglés: `--escuela carnatica`, `--school carnatic`.
    static let nombresDeLasEscuelas: [(escuela: Escuela, espanol: String, ingles: String)] = [
        (.carnatica, "carnatica", "carnatic"), (.indostanica, "indostanica", "hindustani"),
        (.indiaAntigua, "india-antigua", "ancient-india"), (.gagaku, "gagaku", "gagaku"),
    ]

    /// Cómo se escribe cada carácter de afinación en `--afinacion`, en español y en inglés: `--afinacion justa`,
    /// `--tuning just`. `partes-iguales` vale para cualquier número de partes.
    static let nombresDeLasAfinaciones: [(clave: String, espanol: String, ingles: String)] = [
        ("temperada", "temperada", "tempered"), ("justa", "justa", "just"), ("microtonal", "microtonal", "microtonal"),
        ("partes-iguales", "partes-iguales", "equal-divisions"),
    ]

    /// La clave (`CaracterDeLaAfinacion.clave`) de `--afinacion justa`, en español o en inglés; lanza
    /// `afinacionDesconocida` si no es ninguna.
    static func claveDeAfinacion(leyendo texto: String) throws -> String {
        let clave = claveDeBusqueda(texto)
        guard
            let encontrada = nombresDeLasAfinaciones.first(where: {
                claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
            })
        else { throw ErrorDeUso.afinacionDesconocida(texto) }
        return encontrada.clave
    }

    /// La escuela de `--escuela carnatica`, por su clave, en español o en inglés, o por su nombre en español o en el
    /// idioma de la notación; lanza `escuelaDesconocida` si no es ninguna.
    static func escuela(leyendo texto: String, _ notacion: Notacion) throws -> Escuela {
        let clave = claveDeBusqueda(texto)
        if let porClave = nombresDeLasEscuelas.first(where: {
            claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
        }) {
            return porClave.escuela
        }
        guard
            let porNombre = Escuela.allCases.first(where: {
                [$0.nombre, $0.nombre(en: notacion)].map(claveDeBusqueda).contains(clave)
            })
        else { throw ErrorDeUso.escuelaDesconocida(texto) }
        return porNombre
    }

    /// Los lugares de `--lugar espana`: los del catálogo (`Lugar.todos`) cuya clave o cuyo nombre, en español, en
    /// inglés o en el idioma de la notación, o el código ISO de un país (`US`), es el texto. Pueden ser varios:
    /// «egipto» es la zona y el país, y «hungria», el país y la región. Lanza `lugarDesconocido` si no es ninguno.
    static func lugares(leyendo texto: String, _ notacion: Notacion) throws -> [Lugar] {
        let clave = claveDeBusqueda(texto)
        let encontrados = Lugar.todos.filter { lugar in
            var nombres = [lugar.clave, lugar.nombre, lugar.nombre(en: .compacta(.ingles)), lugar.nombre(en: notacion)]
            if case .pais(let pais) = lugar { nombres.append(pais.codigoISO) }
            return nombres.map(claveDeBusqueda).contains(clave)
        }
        guard !encontrados.isEmpty else { throw ErrorDeUso.lugarDesconocido(texto) }
        return encontrados
    }

    /// Un texto para comparar nombres: sin mayúsculas, tildes, guiones ni espacios («Mundo árabe» → «mundoarabe»).
    static func claveDeBusqueda(_ texto: String) -> String {
        texto.replacingOccurrences(of: "ı", with: "i")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .filter { $0.isLetter || $0.isNumber }
    }

    /// El teórico de `--fuente ptolomeo` (`--source ptolemy`): por su clave o por su nombre en español, en inglés o
    /// en el idioma de la notación.
    static func fuenteTeorica(leyendo texto: String, _ notacion: Notacion) throws -> FuenteTeorica {
        let clave = claveDeBusqueda(texto)
        let nombres = { (candidata: FuenteTeorica) in
            [
                candidata.rawValue, candidata.nombre, candidata.nombre(en: .compacta(.ingles)),
                candidata.nombre(en: notacion),
            ].map(claveDeBusqueda)
        }
        guard let encontrada = FuenteTeorica.allCases.first(where: { nombres($0).contains(clave) }) else {
            throw ErrorDeUso.fuenteDesconocida(texto)
        }
        return encontrada
    }
}
