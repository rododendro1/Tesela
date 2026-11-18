import Armonia
import ExposicionArmonia
import Foundation

// MARK: - La hoja de estudio: acordes, un acorde o una escala

extension LineaDeComandos {
    /// `hoja Re dórico` (o `hoja escala Re dórico`): la escala en una hoja de estudio para imprimir, en SVG (con
    /// `--secciones pentagrama,mastil`, solo esas partes, y con `--instrumento ukelele`, en su mástil) y, con
    /// `--comparar Do dórico`, comparada nota a nota con otra; `hoja acorde Sol7 [--instrumento bajo]`, la de un
    /// acorde; `hoja tonalidad Do mayor`, la de una tonalidad, y `hoja acordes Rem7 Sol7 Do7M [--en Do mayor] [--doce]
    /// [--comparar …]`, la de una progresión, en las doce tonalidades o comparada con otra. Y las de `otraHoja` (un
    /// ritmo, una progresión con nombre, una serie, un arpegio) y `hoja instrumento laúd`. Con `--formato html`,
    /// cualquiera de ellas como página HTML. `grabar hoja …` la pasa a PDF.
    static func hoja(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        // `hoja instrumento laúd`: no pasa por `conLaSuborden`, porque `--instrumento` es también una opción de las
        // demás.
        if let primera = argumentos.first?.lowercased(), ["instrumento", "instrument"].contains(primera) {
            return try hojaDeUnInstrumento(Array(argumentos.dropFirst()), notacion)
        }
        var argumentos = Argumentos(
            try conLaSuborden(
                argumentos, entre: [.acorde, .acordes, .tonalidad, .ritmo, .progresion, .serie, .arpegio],
                sinNada: ["escala", "scale"]))
        // Con --formato html, cualquiera de ellas como página HTML.
        let formato: HojaDeEstudio.Formato = try argumentos.pideElFormato("html") ? .html : .svg
        if let hoja = try otraHoja(&argumentos, formato: formato, notacion) { return bien(hoja) }
        if let cifrado = try argumentos.valor(.acorde, siFalta: .faltaElAcordeDeLaHoja) {
            // Con --instrumento, las digitaciones en ese mástil (en la guitarra, si no).
            let mastil = Mastil(try encordadoDeLaHoja(&argumentos), numeroDeTrastes: 12)
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendo: cifrado, enLaOrden: notacion)
            return bien(HojaDeEstudio.acorde(acorde, mastil: mastil, en: notacion, formato: formato))
        }
        // Los acordes antes que la tonalidad: en `hoja acordes … --en Do mayor`, es la de los acordes.
        if argumentos.quitarMarca(.acordes) {
            // --doce y --comparar se quitan antes que la tonalidad, que se lleva todo lo que va detrás de --en.
            let doce = argumentos.quitarMarca(.doce)
            let contra = try argumentos.valorConPalabras(.comparar)
            guard let tonalidad = try argumentos.quitarTonalidad(en: notacion) else {
                throw ErrorDeUso.faltaValor("en")
            }
            try argumentos.sinOpcionesDesconocidas()
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanLosAcordesDeLaHoja }
            let analisis = try PresentacionDeAnalisis.analizar(
                argumentos.restantes.joined(separator: " "), en: tonalidad, notacion: notacion)
            // Con --comparar, las dos progresiones comparadas acorde a acorde.
            if let contra {
                let otra = try contra.split(separator: " ").map { try Acorde(leyendo: String($0), enLaOrden: notacion) }
                if let hoja = HojaDeEstudio.comparacion(
                    analisis.acordes, con: otra, en: tonalidad, notacion: notacion, formato: formato)
                {
                    return bien(hoja)
                }
            }
            // Con --doce, la progresión en las doce tonalidades, desde la dada o la del análisis.
            if doce, let propia = tonalidad ?? analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia {
                return bien(
                    HojaDeEstudio.enLasDoceTonalidades(
                        analisis.acordes, tonalidad: propia, en: notacion, formato: formato))
            }
            return bien(HojaDeEstudio.analisis(analisis, en: notacion, formato: formato))
        }
        if let texto = try argumentos.valorConPalabras(.tonalidad, siFalta: .faltaTonalidad) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
            let tonalidad = try LineaDeComandos.tonalidad(texto, en: notacion)
            return bien(HojaDeEstudio.tonalidad(tonalidad, en: notacion, formato: formato))
        }
        // `hoja Do mayor --comparar Do dórico`: las dos escalas nota a nota, en el pentagrama y en el reloj.
        let otra = try argumentos.valorConPalabras(.comparar)
        // Con --secciones, solo esas partes; con --instrumento, el mástil de ese instrumento.
        let secciones = try argumentos.valor(.secciones).map(seccionesDeLaHoja) ?? Set(SeccionDeLaHoja.allCases)
        let mastil = Mastil(try encordadoDeLaHoja(&argumentos), numeroDeTrastes: 15)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDeLaHoja }
        let escala = try Escala(leyendo: argumentos.unidos, enLaOrden: notacion)
        if let otra {
            let otra = try Escala(leyendo: otra, enLaOrden: notacion)
            return bien(HojaDeEstudio.comparacion(escala, con: otra, en: notacion, formato: formato))
        }
        return bien(HojaDeEstudio.escala(escala, secciones: secciones, mastil: mastil, en: notacion, formato: formato))
    }

    /// Las hojas de `HojaDeEstudio`: `hoja ritmo tresillo`, `hoja progresion folía [--en La]`, `hoja serie 0 1 2 …` y
    /// `hoja arpegio Sol7 [--instrumento bajo]`; `nil` si no se pide ninguna de ellas.
    static func otraHoja(
        _ argumentos: inout Argumentos, formato: HojaDeEstudio.Formato, _ notacion: Notacion
    ) throws -> String? {
        if let nombre = try argumentos.valorConPalabras(.ritmo) {
            try argumentos.sinOpcionesDesconocidas()
            // Por su nombre o, si no, el primero que lo lleva en el nombre: «andaluza» es la cadencia andaluza.
            guard let ritmo = RitmoConNombre.buscar(nombre: nombre) ?? RitmoConNombre.buscar(conteniendo: nombre).first
            else { throw ErrorDeUso.ritmoDesconocido(nombre) }
            return HojaDeEstudio.ritmo(ritmo, en: notacion, formato: formato)
        }
        if let nombre = try argumentos.valorConPalabras(.progresion) {
            // Con --en, sobre esa tónica (Do, si no).
            let tonica = try argumentos.valor(.en).map { try Nota(leyendo: $0, enLaOrden: notacion) } ?? .do
            try argumentos.sinOpcionesDesconocidas()
            guard
                let progresion = ProgresionConNombre.buscar(nombre: nombre)
                    ?? ProgresionConNombre.buscar(conteniendo: nombre).first
            else { throw ErrorDeUso.progresionDesconocida(nombre) }
            return HojaDeEstudio.progresion(progresion, sobre: tonica, en: notacion, formato: formato)
        }
        if let texto = try argumentos.valorConPalabras(.serie) {
            try argumentos.sinOpcionesDesconocidas()
            return HojaDeEstudio.serie(try SerieDodecafonica(leyendo: texto), en: notacion, formato: formato)
        }
        if argumentos.quitarMarca(.arpegio) {
            let mastil = Mastil(try encordadoDeLaHoja(&argumentos), numeroDeTrastes: 15)
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.count == 1 else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendo: argumentos.restantes[0], enLaOrden: notacion)
            return HojaDeEstudio.arpegio(acorde, mastil: mastil, en: notacion, formato: formato)
        }
        return nil
    }

    /// `hoja instrumento laúd [--formato html]`: la hoja de un instrumento de cuerda.
    static func hojaDeUnInstrumento(_ textos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(textos)
        let formato: HojaDeEstudio.Formato = try argumentos.pideElFormato("html") ? .html : .svg
        try argumentos.sinOpcionesDesconocidas()
        let nombre = argumentos.unidos
        guard !nombre.isEmpty else { throw ErrorDeUso.faltaInstrumento }
        guard let encordado = Encordado.buscar(nombre: nombre) else { throw ErrorDeUso.instrumentoDesconocido(nombre) }
        return bien(HojaDeEstudio.instrumento(encordado, en: notacion, formato: formato))
    }

    /// El instrumento de `--instrumento` (la guitarra, si no se da), o `ErrorDeUso.instrumentoDesconocido`.
    static func encordadoDeLaHoja(_ argumentos: inout Argumentos) throws -> Encordado {
        guard let nombre = try argumentos.valor(.instrumento, siFalta: .faltaInstrumento) else { return .guitarra }
        guard let encordado = try? Encordado(leyendo: nombre) else { throw ErrorDeUso.instrumentoDesconocido(nombre) }
        return encordado
    }

    /// Las secciones de `--secciones pentagrama,teclados`, separadas por comas, por su nombre en español (con
    /// tildes o sin ellas) o en inglés; `ErrorDeUso.seccionDesconocida` si alguna no se conoce.
    ///
    ///     try LineaDeComandos.seccionesDeLaHoja("mástil,staff")   // [.mastil, .pentagrama]
    static func seccionesDeLaHoja(_ texto: String) throws -> Set<SeccionDeLaHoja> {
        let enIngles: [String: SeccionDeLaHoja] = [
            "staff": .pentagrama, "stats": .estadisticas, "statistics": .estadisticas, "clock": .reloj,
            "keyboards": .teclados, "fretboard": .mastil, "sequences": .secuencias, "chords": .acordes,
            "ladder": .escalera,
        ]
        var secciones: Set<SeccionDeLaHoja> = []
        for nombre in texto.split(separator: ",") {
            let leido = Argumentos.sinTildes(nombre.trimmingCharacters(in: .whitespaces).lowercased())
            guard let seccion = SeccionDeLaHoja(rawValue: leido) ?? enIngles[leido] else {
                throw ErrorDeUso.seccionDesconocida(String(nombre))
            }
            secciones.insert(seccion)
        }
        return secciones
    }
}
