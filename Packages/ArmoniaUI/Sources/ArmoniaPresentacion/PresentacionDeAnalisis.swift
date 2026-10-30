import Armonia

/// El análisis de una progresión tal como lo enseñan la app y la línea de comandos: en tramos (uno por
/// tonalidad, con la modulación que lo abre), las cadencias y los ficheros para exportar.
public struct AnalisisPresentado: Hashable, Sendable {
    public struct Fila: Hashable, Sendable {
        /// El cifrado americano («Re7»).
        public let cifrado: String
        /// El cifrado romano («V7/V»).
        public let grado: String
        /// La función tonal, o "" si no tiene.
        public let funcion: String
    }

    /// La tonalidad, o el recorrido de tonalidades si modula («Do mayor → Sol mayor»).
    public let titulo: String
    public let tramos: [TramoPresentado]
    public let cadencias: [String]
    public let ficheros: [FicheroParaExportar]
    /// Los acordes uno detrás de otro, para «Escuchar».
    public internal(set) var sonido: Sonido = .silencio
    /// Los acordes analizados y la tonalidad de la partitura, para arpegiarlos.
    public internal(set) var acordes: [Acorde] = []
    public internal(set) var tonalidad: Tonalidad?

    /// La progresión arpegiada con un patrón, en la tonalidad de la partitura.
    public func arpegiada(_ patron: Arpegio.Patron, notacion: Notacion) -> ArpegioPresentado? {
        PresentacionDeArpegios.progresion(acordes, patron: patron, tonalidad: tonalidad, notacion: notacion)
    }
}

/// Un tramo del análisis en una tonalidad: la modulación que lo abre y sus acordes.
public struct TramoPresentado: Hashable, Sendable {
    /// La modulación que abre el tramo; `nil` en el primero.
    public let cabecera: String?
    public let filas: [AnalisisPresentado.Fila]
}

/// La parte de la vista de análisis que no es dibujo, y la salida de `armonia analizar`. No usa SwiftUI,
/// así que se prueba en Linux.
public enum PresentacionDeAnalisis {
    /// Analiza «Do Lam Re7 Sol7 Do», con las modulaciones y sus acordes pivote. Con una tonalidad dada,
    /// la analiza entera en ella, sin modulaciones.
    ///
    /// La partitura y el MIDI se escriben en una sola tonalidad, la que mejor explica toda la
    /// progresión, porque los dos formatos solo anotan una.
    public static func analizar(_ texto: String, en tonalidad: Tonalidad? = nil,
                                notacion: Notacion) throws -> AnalisisPresentado {
        if let tonalidad {
            return presentar(try AnalisisArmonico.analizar(leyendo: texto, en: tonalidad), recorrido: nil, notacion)
        }
        let recorrido = try RecorridoTonal(leyendo: texto)
        return presentar(try AnalisisArmonico.analizar(leyendo: texto), recorrido: recorrido, notacion)
    }

    /// Igual, con los acordes ya leídos (los de un fichero MIDI o MusicXML, por ejemplo). `nil` si no hay ninguno.
    public static func analizar(_ acordes: [Acorde], en tonalidad: Tonalidad? = nil,
                                notacion: Notacion) -> AnalisisPresentado? {
        guard !acordes.isEmpty else { return nil }
        if let tonalidad { return presentar(tonalidad.analizar(acordes), recorrido: nil, notacion) }
        guard let analisis = AnalisisArmonico.analizar(acordes), let recorrido = RecorridoTonal(acordes) else { return nil }
        return presentar(analisis, recorrido: recorrido, notacion)
    }

    /// El análisis en una sola tonalidad (`analisis`, para la partitura y el MIDI) y, si se da, el
    /// recorrido con sus modulaciones, que es entonces lo que se muestra.
    private static func presentar(_ analisis: AnalisisArmonico, recorrido: RecorridoTonal?,
                                  _ notacion: Notacion) -> AnalisisPresentado {
        let titulo: String
        let tramos: [TramoPresentado]
        let cadencias: [Cadencia]
        if let recorrido {
            let cabeceras = [nil] + recorrido.modulaciones.map { Optional($0.descripcion(en: notacion)) }
            titulo = recorrido.nombre(en: notacion)
            tramos = zip(cabeceras, recorrido.tramos).map { cabecera, tramo in
                TramoPresentado(cabecera: cabecera, filas: tramo.analisis.acordes.map { fila($0, notacion) })
            }
            cadencias = recorrido.cadencias
        } else {
            titulo = analisis.nombre(en: notacion)
            tramos = [TramoPresentado(cabecera: nil, filas: analisis.acordes.map { fila($0, notacion) })]
            cadencias = analisis.cadencias
        }
        let nombre = "Progresión"
        return AnalisisPresentado(
            titulo: titulo,
            tramos: tramos,
            cadencias: cadencias.map { $0.descripcion(en: notacion) },
            ficheros: [
                .musicXML(analisis.musicXML(titulo: nombre, notacion: notacion), nombre: nombre),
                .mei(analisis.mei(titulo: nombre, notacion: notacion), nombre: nombre),
                .midi(analisis.midi(titulo: nombre, notacion: notacion), nombre: nombre),
            ],
            sonido: Sonido.acordes(analisis.acordes.map(\.acorde)).conTonica(analisis.tonalidad.tonica),
            acordes: analisis.acordes.map(\.acorde),
            tonalidad: analisis.tonalidad)
    }

    static func fila(_ analizado: AcordeAnalizado, _ notacion: Notacion) -> AnalisisPresentado.Fila {
        AnalisisPresentado.Fila(cifrado: analizado.acorde.cifrado(en: notacion), grado: analizado.cifrado,
                                funcion: analizado.funcion?.nombre(en: notacion) ?? "")
    }
}
