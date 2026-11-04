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
        /// La escala del acorde en su tonalidad (Re7 en V7/V → Re mixolidio), con sus tensiones y sus notas a
        /// evitar; `nil` si ninguna tiene todas sus notas.
        public let escala: EscalaSobreAcordePresentada?
    }

    /// La tonalidad, o el recorrido de tonalidades si modula («Do mayor → Sol mayor»).
    public let titulo: String
    public let tramos: [TramoPresentado]
    public let cadencias: [String]
    public let ficheros: [FicheroParaExportar]
    /// Los acordes uno detrás de otro, para «Escuchar».
    public internal(set) var sonido: Escucha = .silencio
    /// Los acordes analizados y la tonalidad de la partitura, para arpegiarlos.
    public internal(set) var acordes: [Acorde] = []
    public internal(set) var tonalidad: Tonalidad?
    /// Lo que dura cada acorde, si viene de una pieza importada; si no, `nil` (una blanca cada uno).
    public internal(set) var ritmo: RitmoArmonico?

    /// La progresión arpegiada con un patrón, en la tonalidad de la partitura y con su ritmo armónico; las notas,
    /// en corcheas o en la figura que se diga.
    public func arpegiada(
        _ patron: Arpegio.Patron, figura: Duracion = .corchea, enlazados: Bool = false, notacion: Notacion
    ) -> ArpegioPresentado? {
        PresentacionDeArpegios.progresion(
            acordes, patron: patron, tonalidad: tonalidad, ritmo: ritmo, figura: figura, enlazados: enlazados,
            notacion: notacion)
    }
}

/// El ritmo armónico de una progresión: lo que dura cada acorde, en el compás y el tempo de la pieza de la que
/// sale (un fichero MIDI, MusicXML, MEI o ABC).
public struct RitmoArmonico: Hashable, Sendable {
    public let duraciones: [Duracion]
    public let compas: Compas
    public let tempo: Tempo?

    public init(duraciones: [Duracion], compas: Compas = .compasillo, tempo: Tempo? = nil) {
        self.duraciones = duraciones
        self.compas = compas
        self.tempo = tempo
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
    public static func analizar(
        _ texto: String, en tonalidad: Tonalidad? = nil,
        notacion: Notacion
    ) throws -> AnalisisPresentado {
        if let tonalidad {
            return presentar(try AnalisisArmonico.analizar(leyendo: texto, en: tonalidad), recorrido: nil, notacion)
        }
        let recorrido = try RecorridoTonal(leyendo: texto)
        return presentar(try AnalisisArmonico.analizar(leyendo: texto), recorrido: recorrido, notacion)
    }

    /// Igual, con los acordes ya leídos (los de un fichero MIDI o MEI, por ejemplo). `nil` si no hay ninguno.
    /// Con su ritmo armónico (una duración por acorde), la partitura, el MIDI, «Escuchar» y la progresión
    /// arpegiada lo siguen; si no, cada acorde dura una blanca.
    public static func analizar(
        _ acordes: [Acorde], ritmo: RitmoArmonico? = nil, en tonalidad: Tonalidad? = nil,
        notacion: Notacion
    ) -> AnalisisPresentado? {
        guard !acordes.isEmpty else { return nil }
        let ritmo = ritmo.flatMap { r in
            r.duraciones.count == acordes.count && r.duraciones.allSatisfy { $0 > .cero } ? r : nil
        }
        if let tonalidad { return presentar(tonalidad.analizar(acordes), recorrido: nil, ritmo: ritmo, notacion) }
        guard let analisis = AnalisisArmonico.analizar(acordes), let recorrido = RecorridoTonal(acordes) else {
            return nil
        }
        return presentar(analisis, recorrido: recorrido, ritmo: ritmo, notacion)
    }

    /// Una progresión importada, con su ritmo armónico y su título.
    public static func analizar(
        _ importada: ProgresionImportada, en tonalidad: Tonalidad? = nil,
        notacion: Notacion
    ) -> AnalisisPresentado? {
        analizar(importada.acordes, ritmo: importada.ritmo, en: tonalidad, notacion: notacion)
    }

    /// El análisis en una sola tonalidad (`analisis`, para la partitura y el MIDI) y, si se da, el
    /// recorrido con sus modulaciones, que es entonces lo que se muestra.
    private static func presentar(
        _ analisis: AnalisisArmonico, recorrido: RecorridoTonal?,
        ritmo: RitmoArmonico? = nil, _ notacion: Notacion
    ) -> AnalisisPresentado {
        let titulo: String
        let tramos: [TramoPresentado]
        let cadencias: [Cadencia]
        if let recorrido {
            let cabeceras = [nil] + recorrido.modulaciones.map { Optional($0.descripcion(en: notacion)) }
            titulo = recorrido.nombre(en: notacion)
            tramos = zip(cabeceras, recorrido.tramos).map { cabecera, tramo in
                let tonalidad = tramo.analisis.tonalidad
                return TramoPresentado(
                    cabecera: cabecera, filas: tramo.analisis.acordes.map { fila($0, en: tonalidad, notacion) })
            }
            cadencias = recorrido.cadencias
        } else {
            titulo = analisis.nombre(en: notacion)
            let filas = analisis.acordes.map { fila($0, en: analisis.tonalidad, notacion) }
            tramos = [TramoPresentado(cabecera: nil, filas: filas)]
            cadencias = analisis.cadencias
        }
        let nombre = "Progresión"
        let acordes = analisis.acordes.map(\.acorde)
        // El análisis da un acorde por cada uno leído; si no, no se puede seguir el ritmo.
        let ritmo = ritmo.flatMap { $0.duraciones.count == acordes.count ? $0 : nil }
        let ficheros: [FicheroParaExportar]
        let sonido: Escucha
        if let ritmo {
            let d = ritmo.duraciones
            let compas = ritmo.compas
            let tempo = ritmo.tempo
            ficheros = FicheroParaExportar.partituras(nombre: nombre) { formato in
                analisis.partitura(
                    duraciones: d, compas: compas, encabezado: Encabezado(titulo: nombre, tempo: tempo),
                    notacion: notacion
                ).exportar(como: formato)
            }
            sonido = Escucha.acordes(acordes, duraciones: d, tempo: tempo ?? Escucha.tempo)
        } else {
            ficheros = FicheroParaExportar.partituras(nombre: nombre) { formato in
                analisis.partitura(encabezado: Encabezado(titulo: nombre), notacion: notacion).exportar(como: formato)
            }
            sonido = Escucha.acordes(acordes)
        }
        return AnalisisPresentado(
            titulo: titulo,
            tramos: tramos,
            cadencias: cadencias.map { $0.descripcion(en: notacion) },
            ficheros: ficheros,
            sonido: sonido.conTonica(analisis.tonalidad.tonica),
            acordes: acordes,
            tonalidad: analisis.tonalidad,
            ritmo: ritmo)
    }

    static func fila(
        _ analizado: AcordeAnalizado, en tonalidad: Tonalidad, _ notacion: Notacion
    ) -> AnalisisPresentado.Fila {
        AnalisisPresentado.Fila(
            cifrado: analizado.acorde.cifrado(en: notacion), grado: analizado.cifrado,
            funcion: analizado.funcion?.nombre(en: notacion) ?? "",
            escala: PresentacionDeEscalaYAcorde.escala(de: analizado, en: tonalidad, notacion: notacion))
    }
}
