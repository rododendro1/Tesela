import Armonia
import ExposicionArmonia
import Foundation

// MARK: - La hoja de estudio: acordes, un acorde o una escala

extension LineaDeComandos {
    /// `hoja Re dórico` (o `hoja escala Re dórico`): la escala en una hoja de estudio para imprimir, en SVG (con
    /// `--secciones pentagrama,mastil`, solo esas partes, y con `--instrumento ukelele`, en su mástil) y, con
    /// `--comparar Do dórico`, comparada nota a nota con otra; `hoja acorde Sol7 [--instrumento bajo]`, la de un
    /// acorde; `hoja tonalidad Do mayor`, la de una tonalidad, y `hoja acordes Rem7 Sol7 Do7M [--en Do mayor] [--doce]
    /// [--comparar …]`, la de una progresión, en las doce tonalidades o comparada con otra. Con `--formato html`,
    /// cualquiera de ellas como página HTML. `grabar hoja …` la pasa a PDF.
    static func hoja(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(
            try conLaSuborden(argumentos, entre: [.acorde, .acordes, .tonalidad], sinNada: ["escala", "scale"]))
        // Con --formato html, cualquiera de ellas como página HTML.
        let html = try argumentos.pideElFormato("html")
        if let cifrado = try argumentos.valor(.acorde, siFalta: .faltaElAcordeDeLaHoja) {
            // Con --instrumento, las digitaciones en ese mástil (en la guitarra, si no).
            let mastil = Mastil(try encordadoDeLaHoja(&argumentos), numeroDeTrastes: 12)
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendo: cifrado, enLaOrden: notacion)
            return bien(
                html
                    ? PresentacionDeRelacionesDeAcorde.hojaDeEstudioHTML(de: acorde, mastil: mastil, en: notacion)
                    : PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: acorde, mastil: mastil, en: notacion))
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
                let hoja =
                    html
                    ? PresentacionDeAnalisis.hojaDeLaComparacionHTML(
                        analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
                    : PresentacionDeAnalisis.hojaDeLaComparacion(
                        analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
                if let hoja {
                    return bien(hoja)
                }
            }
            // Con --doce, la progresión en las doce tonalidades, desde la dada o la del análisis.
            if doce, let propia = tonalidad ?? analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia {
                return bien(
                    html
                        ? PresentacionDeAnalisis.hojaEnLasDoceTonalidadesHTML(
                            analisis.acordes, tonalidad: propia, en: notacion)
                        : PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
                            analisis.acordes, tonalidad: propia, en: notacion))
            }
            return bien(
                html
                    ? PresentacionDeAnalisis.hojaDeEstudioHTML(analisis, en: notacion)
                    : PresentacionDeAnalisis.hojaDeEstudio(analisis, en: notacion))
        }
        if let texto = try argumentos.valorConPalabras(.tonalidad, siFalta: .faltaTonalidad) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
            let tonalidad = try LineaDeComandos.tonalidad(texto, en: notacion)
            return bien(
                html
                    ? PresentacionDeTonalidad.hojaDeEstudioHTML(de: tonalidad, en: notacion)
                    : PresentacionDeTonalidad.hojaDeEstudio(de: tonalidad, en: notacion))
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
            return bien(
                html
                    ? PresentacionDeEstudioDeEscala.comparacionNotaANotaHTML(escala, con: otra, en: notacion)
                    : PresentacionDeEstudioDeEscala.comparacionNotaANota(escala, con: otra, en: notacion))
        }
        return bien(
            html
                ? PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(
                    de: escala, en: notacion, secciones: secciones, mastil: mastil)
                : PresentacionDeEstudioDeEscala.hojaDeEstudio(
                    de: escala, en: notacion, secciones: secciones, mastil: mastil))
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
