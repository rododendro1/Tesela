// MARK: - Idiomas
//
// Las letras, las alteraciones y los nombres de nota en las catorce lenguas de `Notacion`. Siguen el idioma
// de las notas (`Notacion.idiomaDeLasNotas`), no el de los textos. Los intervalos, en `Intervalo+Idiomas.swift`.

// MARK: - NotaNatural

extension NotaNatural {
    public var nombre: String { ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"][rawValue] }

    /// Nombre en cada idioma: Do (español), C (inglés), H para el Si en alemán, ré (francés),
    /// re (italiano), sòl (occitano), соль (ruso), σολ (griego). En las lenguas que usan sílabas,
    /// salvo el español, en minúscula, como se escriben en el texto. Las sílabas de cada idioma están
    /// en ``ReglasDeIdioma``.
    public func nombre(en notacion: Notacion) -> String {
        notacion.idiomaDeLasNotas.reglas.naturales[rawValue]
    }
}

// MARK: - Alteracion

extension Alteracion {
    /// "natural", "sostenido", "doble bemol", "triple sostenido", "5 bemoles"…
    public var nombre: String { nombre(en: .espanolUnicode) }

    /// Nombre en cada idioma: "double sharp", "Doppelkreuz", "double dièse", "doppio diesis"…
    public func nombre(en notacion: Notacion) -> String {
        let idioma = notacion.idiomaDeLasNotas
        if semitonos == 0 { return Alteracion.palabraNatural.texto(en: idioma) }
        let base = (esSostenido ? Alteracion.palabraSostenido : Alteracion.palabraBemol).texto(en: idioma)
        let n = numeroDeSignos
        if n == 1 { return base }
        let multiplicadores = Alteracion.multiplicadores.texto(en: idioma)
        switch idioma.reglas.multiplicador {
        case .unido:
            // En alemán las palabras se unen: Doppelkreuz, Doppel-Be.
            let unida = esSostenido ? "kreuz" : "-Be"
            if n <= 4 { return multiplicadores[n - 2] + unida }
            return "\(n)" + (esSostenido ? " Kreuze" : " Be")
        case .detras:
            // En euskera el adjetivo va detrás, y el sustantivo no cambia con el número: diesa bikoitza, 5 diesa.
            if n <= 4 { return base + " " + multiplicadores[n - 2] }
            return "\(n) \(base)"
        case .delante:
            if n <= 4 { return multiplicadores[n - 2] + base }
            return "\(n) " + (esSostenido ? Alteracion.palabraSostenidos : Alteracion.palabraBemoles).texto(en: idioma)
        }
    }

    private static let palabraNatural = TextosDeNucleo.traducidos.map(\.palabraNatural)
    private static let palabraSostenido = TextosDeNucleo.traducidos.map(\.palabraSostenido)
    private static let palabraBemol = TextosDeNucleo.traducidos.map(\.palabraBemol)
    /// «Doble», «triple» y «cuádruple», para 2, 3 y 4 signos. Dónde se ponen y cómo se pegan a la palabra
    /// lo dice `ReglasDeIdioma.multiplicador`: delante y separados, detrás (euskera) o unidos (alemán).
    private static let multiplicadores = TextosDeNucleo.traducidos.map(\.multiplicadores)
    /// Para 5 signos o más: "5 sostenidos".
    private static let palabraSostenidos = TextosDeNucleo.traducidos.map(\.palabraSostenidos)
    private static let palabraBemoles = TextosDeNucleo.traducidos.map(\.palabraBemoles)
}

// MARK: - Nota

extension Nota {
    /// Nombre con símbolos tipográficos: "Fa♯", "Si♭".
    public var nombre: String { natural.nombre + alteracion.simbolo }

    /// Nombre en ASCII: "Fa#", "Sib".
    public var nombreASCII: String { natural.nombre + alteracion.simboloASCII }

    /// Nombre en la notación indicada: `.espanol` → "Fa sostenido", `.espanolASCII` → "Fa#",
    /// `.espanolUnicode` → "Fa♯", `.ingles` → "F sharp", `.inglesASCII` → "F#", `.inglesUnicode` → "F♯",
    /// `.aleman` → "Fis", `.frances` → "fa dièse",
    /// `.italiano` → "fa diesis", `.ruso` → "фа-диез", `.griego` → "φα δίεση".
    public func nombre(en notacion: Notacion) -> String {
        let base = natural.nombre(en: notacion)
        switch notacion.escritura.escrituraDeLaAlteracion {
        case .alemana:
            return nombreAleman
        case .signos:
            return base + (notacion.usaASCII ? alteracion.simboloASCII : alteracion.simbolo)
        case .palabras:
            // El separador lo pone el idioma: un espacio en casi todos, un guion en ruso (фа-диез).
            guard !alteracion.esNatural else { return base }
            return base + notacion.idiomaDeLasNotas.reglas.separador + alteracion.nombre(en: notacion)
        }
    }

    /// Nombre alemán: sostenidos con -is (Fis, Cisis), bemoles con -es (Des, Ges), con Es y As
    /// para Mi♭ y La♭ (Eses, Asas), B para Si♭ y H para Si (His, Heses).
    package var nombreAleman: String {
        let n = alteracion.numeroDeSignos
        if alteracion.esNatural { return natural.nombre(en: .aleman) }
        if alteracion.esSostenido { return natural.nombre(en: .aleman) + String(repeating: "is", count: n) }
        switch natural {
        case .si: return n == 1 ? "B" : "H" + String(repeating: "es", count: n)
        case .mi: return "Es" + String(repeating: "es", count: n - 1)
        case .la: return "As" + String(repeating: "as", count: n - 1)
        default: return natural.nombre(en: .aleman) + String(repeating: "es", count: n)
        }
    }

    /// Nombre compacto para cifrados: igual que `nombre(en:)` salvo en las notaciones que escriben
    /// las alteraciones con palabras, que usan la sílaba con mayúscula y el símbolo (Fa♯, F♯, Ré♭, Фа♯, Φα♯).
    public func nombreCompacto(en notacion: Notacion) -> String {
        let notacion = notacion.notas
        switch notacion.escritura.escrituraDeLaAlteracion {
        case .palabras:
            return natural.nombre(en: notacion).conMayusculaInicial + alteracion.simbolo
        case .signos, .alemana:
            return nombre(en: notacion)
        }
    }
}
