import Armonia
import Exposicion

/// Lo que se elige en la pestaña de análisis de Ars Harmonica y lo que sale de ello: la progresión escrita o abierta
/// de un fichero, su análisis, la transposición y los ficheros para exportar. No usa SwiftUI, así que se prueba
/// también en Linux; la vista lo guarda en un `@State` y solo lo dibuja.
///
/// Lo abierto de un fichero conserva su ritmo armónico mientras el campo diga lo mismo; si se retoca, se analiza
/// lo escrito.
public struct ModeloDeAnalisis: Sendable {
    /// La progresión escrita. Al cambiarla se olvida el error del último fichero que no se pudo abrir.
    public var texto: String {
        didSet { if texto != oldValue { errorAlAbrir = nil } }
    }
    /// Por qué no se pudo abrir el último fichero; se borra al abrir otro o al cambiar el texto.
    public private(set) var errorAlAbrir: (any Error)?
    /// La progresión del último fichero abierto, con su ritmo armónico: se usa mientras el campo diga lo mismo.
    public private(set) var importada: ProgresionImportada?
    public var patron = Arpegio.Patron.ascendente
    public var figura = Figura.corchea
    /// Si cada arpegio empieza por la nota más cercana a la última del anterior.
    public var enlazados = false
    /// La disposición de la progresión dispuesta (drop 2, shell…).
    public var disposicion = DisposicionDeAcorde.drop2
    /// Otra versión de la progresión (rearmonizada…), para compararlas acorde a acorde.
    public var contra = ""

    /// Las figuras que se ofrecen para las notas de la progresión arpegiada.
    public static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// Un modelo con la progresión `texto` y lo demás como al abrir la app.
    public init(texto: String = "Do Fa Sol7 Do Lam Re7 Sol") {
        self.texto = texto
    }

    /// Lo abierto de un fichero, si el campo aún dice lo mismo.
    public var abierta: ProgresionImportada? {
        importada?.texto == texto ? importada : nil
    }

    /// Cuándo hay que rehacer el análisis: al cambiar el texto, la notación o el fichero abierto.
    public func claveDelAnalisis(en notacion: Notacion) -> String {
        "\(texto)|\(notacion.clave)|\(importada?.hashValue ?? 0)"
    }

    /// El análisis de lo abierto, con el ritmo de la pieza, mientras no se retoque; si no, el de lo escrito.
    public func analizar(en notacion: Notacion) -> Result<AnalisisPresentado, any Error> {
        if let abierta, let analisis = PresentacionDeAnalisis.analizar(abierta, notacion: notacion) {
            return .success(analisis)
        }
        return Result { try PresentacionDeAnalisis.analizar(texto, notacion: notacion) }
    }

    /// Pone en el campo los acordes del fichero elegido, que se analizan como si se hubieran escrito, o guarda por
    /// qué no se pudo leer.
    public mutating func abrir(_ elegida: Result<ProgresionImportada, any Error>) {
        do {
            let leida = try elegida.get()
            importada = leida
            texto = leida.texto
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }

    /// Lleva la progresión de `origen` a `destino`. Lo abierto de un fichero conserva su ritmo armónico.
    public mutating func transponer(de origen: Tonalidad, a destino: Tonalidad, en notacion: Notacion) {
        if let abierta {
            let intervalo = origen.tonica.intervaloMasCorto(hasta: destino.tonica)
            let transportada = PresentacionDeTransposicion.transponer(abierta, intervalo)
            importada = transportada
            texto = transportada.texto
        } else if let nuevo = try? PresentacionDeTransposicion.transponer(
            texto, de: origen, a: destino, en: notacion)
        {
            texto = nuevo
        }
    }

    /// Los acordes de la otra versión que se pueden leer.
    public var otraVersion: [Acorde] {
        contra.split(separator: " ").compactMap { try? Acorde(leyendo: String($0)) }
    }

    /// La tonalidad desde la que se lleva la progresión a las doce: la del análisis o, si modula, la del primer
    /// acorde.
    public static func tonalidadDeLasDoce(_ analisis: AnalisisPresentado) -> Tonalidad? {
        analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia
    }

    /// La progresión arpegiada con el patrón, la figura y el enlace elegidos.
    public func arpegiada(_ analisis: AnalisisPresentado, en notacion: Notacion) -> ArpegioPresentado? {
        analisis.arpegiada(patron, figura: figura.duracion, enlazados: enlazados, en: notacion)
    }

    /// Las partituras y el MIDI de la progresión y de la progresión arpegiada con el patrón elegido, las hojas de
    /// estudio en SVG y en HTML (de la progresión, en las doce tonalidades, de la tonalidad y de la comparación), el
    /// bajo caminante, la progresión dispuesta y las líneas de notas guía.
    public func ficheros(de analisis: AnalisisPresentado, en notacion: Notacion) -> [FicheroParaExportar] {
        let dispuesta = PresentacionDeDisposiciones.progresion(analisis.acordes, disposicion, en: notacion)
        let guias = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, en: notacion
        ).flatMap(\.ficheros)
        let hoja = FicheroParaExportar.svg(
            PresentacionDeAnalisis.hojaDeEstudio(analisis, disposicion: disposicion, en: notacion),
            nombre: notacion.texto(\.hojaDeEstudio))
        let hojaHTML = FicheroParaExportar.html(
            PresentacionDeAnalisis.hojaDeEstudioHTML(analisis, disposicion: disposicion, en: notacion),
            nombre: notacion.texto(\.hojaDeEstudio))
        var todos: [FicheroParaExportar] = analisis.ficheros + [hoja, hojaHTML]
        if let tonalidad = Self.tonalidadDeLasDoce(analisis) {
            let svg = PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
                analisis.acordes, tonalidad: tonalidad, disposicion: disposicion, en: notacion)
            let nombre = notacion.texto(\.hojaDeEstudio) + " · " + notacion.texto(\.enLasDoceTonalidades)
            todos.append(FicheroParaExportar.svg(svg, nombre: nombre))
            let html = PresentacionDeAnalisis.hojaEnLasDoceTonalidadesHTML(
                analisis.acordes, tonalidad: tonalidad, disposicion: disposicion, en: notacion)
            todos.append(FicheroParaExportar.html(html, nombre: nombre))
        }
        if let tonalidad = analisis.tonalidad {
            let svg = PresentacionDeTonalidad.hojaDeEstudio(de: tonalidad, en: notacion)
            let nombre = notacion.texto(\.hojaDeEstudio) + " · " + tonalidad.nombre(en: notacion)
            todos.append(FicheroParaExportar.svg(svg, nombre: nombre))
            todos.append(
                FicheroParaExportar.html(
                    PresentacionDeTonalidad.hojaDeEstudioHTML(de: tonalidad, en: notacion), nombre: nombre))
        }
        if let svg = PresentacionDeAnalisis.hojaDeLaComparacion(
            analisis.acordes, con: otraVersion, en: analisis.tonalidad, disposicion: disposicion, notacion: notacion)
        {
            let nombre = notacion.texto(\.hojaDeEstudio) + " · " + notacion.texto(\.compararCon)
            todos.append(FicheroParaExportar.svg(svg, nombre: nombre))
        }
        if let html = PresentacionDeAnalisis.hojaDeLaComparacionHTML(
            analisis.acordes, con: otraVersion, en: analisis.tonalidad, disposicion: disposicion, notacion: notacion)
        {
            let nombre = notacion.texto(\.hojaDeEstudio) + " · " + notacion.texto(\.compararCon)
            todos.append(FicheroParaExportar.html(html, nombre: nombre))
        }
        let bajo = PresentacionDeAnalisis.bajoCaminante(analisis.acordes, en: notacion)
        let partes: [[FicheroParaExportar]?] = [
            bajo?.ficheros, arpegiada(analisis, en: notacion)?.ficheros, dispuesta?.ficheros,
        ]
        return todos + partes.compactMap { $0 }.joined() + guias
    }
}
