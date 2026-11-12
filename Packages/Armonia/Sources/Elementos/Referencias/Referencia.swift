import Foundation

// MARK: - Referencia bibliográfica

/// Una obra donde se lee una escala, una afinación o un acorde del catálogo: un libro, un artículo, un capítulo, una
/// tesis o un tratado antiguo. La `fuente` de una escala (`FuenteTeorica`) dice quién la definió; sus `referencias`,
/// dónde la hemos leído.
///
/// Las obras del catálogo son constantes (`Referencia.west1992`, `.touma1996`…), y una cita es la obra con las páginas
/// que se citan: `Referencia.west1992.paginas("160–172")`. Los títulos no se traducen.
///
///     Referencia.west1992.cita                        // "West 1992"
///     Referencia.west1992.paginas("160–172").cita     // "West 1992: 160–172"
///     Referencia.west1992.descripcion
///     // "West, M. L. (1992). Ancient Greek Music. Oxford: Clarendon Press."
///     TipoDeEscala.bayati.referencias.map(\.clave)
///     // ["maqamWorld", "touma1996", "farraj2019", "rechberger2008"]
public struct Referencia: Hashable, Sendable, Identifiable {
    /// La clase de obra, que decide cómo se escribe y su tipo en BibTeX y en CSL-JSON.
    public enum Clase: String, Hashable, Sendable, Codable, CaseIterable {
        /// Un libro, con su editorial.
        case libro
        /// Un artículo de una revista (`publicadoEn`), con su volumen y sus páginas.
        case articulo
        /// Un capítulo o una entrada de un libro o de un diccionario (`publicadoEn`), como el New Grove.
        case capitulo
        /// Una tesis doctoral, con su universidad (`editorial`).
        case tesis
        /// Un tratado anterior a la imprenta moderna, en su edición original (Zarlino, Chrysanthos).
        case tratado
        /// Una página web.
        case web
        /// Una partitura, con su compositor en `autores` y el año en que se compuso.
        case partitura
    }

    /// La clave de la obra, la de su constante y la de BibTeX: «west1992».
    public let clave: String
    public let clase: Clase
    /// Los autores, con el apellido delante: «West, M. L.», «Farraj, Johnny».
    public let autores: [String]
    public let titulo: String
    /// El año de la edición que se cita (en un tratado, el de su primera edición); `nil` en una web que no lo da.
    public let anio: Int?
    /// La revista, el libro o el diccionario donde está, en un artículo o un capítulo.
    public let publicadoEn: String?
    /// La editorial (en una tesis, la universidad).
    public let editorial: String?
    /// La ciudad de la editorial.
    public let lugar: String?
    /// El volumen y el número de una revista: «115 (2)».
    public let volumen: String?
    /// Las páginas de un artículo o de un capítulo en su revista o en su libro.
    public let paginasDeLaObra: String?
    public let doi: String?
    public let url: String?
    /// Las páginas que se citan, si es una cita: «160–172». `nil` en la obra.
    public let paginasCitadas: String?

    public var id: String { clave + (paginasCitadas.map { ":" + $0 } ?? "") }

    public init(
        _ clave: String, _ clase: Clase, autores: [String], titulo: String, anio: Int?, publicadoEn: String? = nil,
        editorial: String? = nil, lugar: String? = nil, volumen: String? = nil, paginas: String? = nil,
        doi: String? = nil, url: String? = nil
    ) {
        self.clave = clave
        self.clase = clase
        self.autores = autores
        self.titulo = titulo
        self.anio = anio
        self.publicadoEn = publicadoEn
        self.editorial = editorial
        self.lugar = lugar
        self.volumen = volumen
        self.paginasDeLaObra = paginas
        self.doi = doi
        self.url = url
        self.paginasCitadas = nil
    }

    /// La cita de estas páginas de la obra: `Referencia.west1992.paginas("160–172")`.
    public func paginas(_ paginas: String) -> Referencia { Referencia(copiando: self, paginasCitadas: paginas) }

    private init(copiando otra: Referencia, paginasCitadas: String?) {
        self.clave = otra.clave
        self.clase = otra.clase
        self.autores = otra.autores
        self.titulo = otra.titulo
        self.anio = otra.anio
        self.publicadoEn = otra.publicadoEn
        self.editorial = otra.editorial
        self.lugar = otra.lugar
        self.volumen = otra.volumen
        self.paginasDeLaObra = otra.paginasDeLaObra
        self.doi = otra.doi
        self.url = otra.url
        self.paginasCitadas = paginasCitadas
    }

    /// La obra, sin las páginas citadas.
    public var obra: Referencia { paginasCitadas == nil ? self : Referencia(copiando: self, paginasCitadas: nil) }

    /// Los apellidos de los autores: «West», «Farraj & Abu Shumays», «Surjodiningrat et al.».
    public var apellidos: String {
        let suyos = autores.map { $0.split(separator: ",").first.map(String.init) ?? $0 }
        switch suyos.count {
        case 0: return ""
        case 1: return suyos[0]
        case 2: return suyos[0] + " & " + suyos[1]
        default: return suyos[0] + " et al."
        }
    }

    /// La cita breve, de autor y año, con las páginas si las tiene: «West 1992: 160–172». Una web sin año se cita por
    /// su título: «Maqam World».
    public var cita: String {
        (anio.map { "\(apellidos) \($0)" } ?? titulo) + (paginasCitadas.map { ": " + $0 } ?? "")
    }

    /// La referencia completa, en el estilo autor-año: «West, M. L. (1992). Ancient Greek Music. Oxford: Clarendon
    /// Press.». Sin las páginas citadas, que van en `cita`.
    public var descripcion: String {
        var partes = [autores.joined(separator: "; ") + (anio.map { " (\($0))." } ?? ".") + " " + titulo + "."]
        if let publicadoEn {
            var dentro = (clase == .capitulo ? "En " : "") + publicadoEn
            if let volumen { dentro += " " + volumen }
            if let paginasDeLaObra { dentro += ": " + paginasDeLaObra }
            partes.append(dentro + ".")
        }
        switch (lugar, editorial) {
        case (let lugar?, let editorial?): partes.append(lugar + ": " + editorial + ".")
        case (nil, let editorial?): partes.append(editorial + ".")
        case (let lugar?, nil): partes.append(lugar + ".")
        case (nil, nil): break
        }
        if let doi { partes.append("doi:" + doi) } else if let url { partes.append(url) }
        return partes.joined(separator: " ")
    }
}

// MARK: - Exportación

extension Referencia {
    /// Las obras en BibTeX, una entrada por obra (sin repetir), en el orden en que llegan.
    ///
    ///     Referencia.bibtex([.west1992])
    ///     // @book{west1992,
    ///     //   author = {West, M. L.},
    ///     //   title = {Ancient Greek Music},
    ///     //   …
    public static func bibtex(_ referencias: [Referencia]) -> String {
        sinRepetir(referencias).map(\.entradaBibTeX).joined(separator: "\n\n")
    }

    /// Las obras en CSL-JSON (el formato de Zotero y de Pandoc), una por obra, sin repetir.
    public static func cslJSON(_ referencias: [Referencia]) -> String {
        let objetos = sinRepetir(referencias).map(\.objetoCSL)
        let datos =
            (try? JSONSerialization.data(withJSONObject: objetos, options: [.prettyPrinted, .sortedKeys])) ?? Data()
        return String(decoding: datos, as: UTF8.self)
    }

    /// Unas citas sin repetir, en su orden: la misma obra sin páginas no se repite si también se cita con ellas.
    public static func unicas(_ referencias: [Referencia]) -> [Referencia] {
        let conPaginas = Set(referencias.filter { $0.paginasCitadas != nil }.map(\.clave))
        var vistas = Set<String>()
        return referencias.filter {
            ($0.paginasCitadas != nil || !conPaginas.contains($0.clave)) && vistas.insert($0.id).inserted
        }
    }

    /// Las obras de unas citas, en su orden, sin repetir ninguna.
    public static func sinRepetir(_ referencias: [Referencia]) -> [Referencia] {
        var vistas = Set<String>()
        return referencias.map(\.obra).filter { vistas.insert($0.clave).inserted }
    }

    private var entradaBibTeX: String {
        let tipo: String =
            switch clase {
            case .libro, .tratado: "book"
            case .articulo: "article"
            case .capitulo: "incollection"
            case .tesis: "phdthesis"
            case .web: "online"
            case .partitura: "misc"
            }
        var campos: [(String, String)] = [("author", autores.joined(separator: " and ")), ("title", titulo)]
        if let publicadoEn { campos.append((clase == .articulo ? "journal" : "booktitle", publicadoEn)) }
        if let volumen { campos.append(("volume", volumen)) }
        if let paginasDeLaObra { campos.append(("pages", paginasDeLaObra.replacingOccurrences(of: "–", with: "--"))) }
        if let editorial { campos.append((clase == .tesis ? "school" : "publisher", editorial)) }
        if let lugar { campos.append(("address", lugar)) }
        if let anio { campos.append(("year", String(anio))) }
        if let doi { campos.append(("doi", doi)) }
        if let url { campos.append(("url", url)) }
        return "@\(tipo){\(clave),\n" + campos.map { "  \($0.0) = {\($0.1)}" }.joined(separator: ",\n") + "\n}"
    }

    private var objetoCSL: [String: Any] {
        let tipo: String =
            switch clase {
            case .libro, .tratado: "book"
            case .articulo: "article-journal"
            case .capitulo: "chapter"
            case .tesis: "thesis"
            case .web: "webpage"
            case .partitura: "musical_score"
            }
        var objeto: [String: Any] = [
            "id": clave, "type": tipo, "title": titulo,
            "author": autores.map { autor -> [String: String] in
                let partes = autor.split(separator: ",", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
                return partes.count == 2 ? ["family": partes[0], "given": partes[1]] : ["literal": autor]
            },
        ]
        if let anio { objeto["issued"] = ["date-parts": [[anio]]] }
        if let publicadoEn { objeto["container-title"] = publicadoEn }
        if let volumen { objeto["volume"] = volumen }
        if let paginasDeLaObra { objeto["page"] = paginasDeLaObra }
        if let editorial { objeto["publisher"] = editorial }
        if let lugar { objeto["publisher-place"] = lugar }
        if let doi { objeto["DOI"] = doi }
        if let url { objeto["URL"] = url }
        return objeto
    }
}
