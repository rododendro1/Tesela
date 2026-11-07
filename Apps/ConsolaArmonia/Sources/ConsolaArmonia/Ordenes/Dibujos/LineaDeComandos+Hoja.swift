import Armonia
import Exposicion
import Foundation

// MARK: - La hoja de estudio: acordes, un acorde o una escala

extension LineaDeComandos {
    /// `hoja Re dórico` (o `hoja escala Re dórico`): la escala en una hoja de estudio para imprimir, en SVG, y, con
    /// `--comparar Do dórico`, comparada nota a nota con otra; `hoja acorde Sol7`, la de un acorde; `hoja tonalidad Do
    /// mayor`, la de una tonalidad, y `hoja acordes Rem7 Sol7 Do7M [--en Do mayor] [--doce] [--comparar …]`, la de una
    /// progresión, en las doce tonalidades o comparada con otra. `grabar hoja …` la pasa a PDF.
    static func hoja(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(
            try conLaSuborden(argumentos, entre: [.acorde, .acordes, .tonalidad], sinNada: ["escala", "scale"]))
        if let cifrado = try argumentos.valor(.acorde, siFalta: .faltaElAcordeDeLaHoja) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaElAcordeDeLaHoja }
            let acorde = try Acorde(leyendoEnLaOrden: cifrado)
            return bien(PresentacionDeRelacionesDeAcorde.hojaDeEstudio(de: acorde, en: notacion))
        }
        // Los acordes antes que la tonalidad: en `hoja acordes … --en Do mayor`, es la de los acordes.
        if argumentos.quitarMarca(.acordes) {
            // --doce y --comparar se quitan antes que la tonalidad, que se lleva todo lo que va detrás de --en.
            let doce = argumentos.quitarMarca(.doce)
            let contra = try argumentos.valorConPalabras(.comparar)
            guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaValor("en") }
            try argumentos.sinOpcionesDesconocidas()
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanLosAcordesDeLaHoja }
            let analisis = try PresentacionDeAnalisis.analizar(
                argumentos.restantes.joined(separator: " "), en: tonalidad, notacion: notacion)
            // Con --comparar, las dos progresiones comparadas acorde a acorde.
            if let contra {
                let otra = try contra.split(separator: " ").map { try Acorde(leyendoEnLaOrden: String($0)) }
                if let hoja = PresentacionDeAnalisis.hojaDeLaComparacion(
                    analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
                {
                    return bien(hoja)
                }
            }
            // Con --doce, la progresión en las doce tonalidades, desde la dada o la del análisis.
            if doce, let propia = tonalidad ?? analisis.tonalidad ?? analisis.acordes.first?.tonalidadPropia {
                return bien(
                    PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
                        analisis.acordes, tonalidad: propia, en: notacion))
            }
            return bien(PresentacionDeAnalisis.hojaDeEstudio(analisis, en: notacion))
        }
        if let texto = try argumentos.valorConPalabras(.tonalidad, siFalta: .faltaTonalidad) {
            try argumentos.sinOpcionesDesconocidas()
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
            let tonalidad = try Tonalidad(leyendoEnLaOrden: texto)
            return bien(PresentacionDeTonalidad.hojaDeEstudio(de: tonalidad, en: notacion))
        }
        // `hoja Do mayor --comparar Do dórico`: las dos escalas nota a nota, en el pentagrama y en el reloj.
        let otra = try argumentos.valorConPalabras(.comparar)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDeLaHoja }
        let escala = try Escala(leyendoEnLaOrden: argumentos.unidos)
        if let otra {
            return bien(
                PresentacionDeEstudioDeEscala.comparacionNotaANota(
                    escala, con: try Escala(leyendoEnLaOrden: otra), en: notacion)
            )
        }
        return bien(PresentacionDeEstudioDeEscala.hojaDeEstudio(de: escala, en: notacion))
    }
}
