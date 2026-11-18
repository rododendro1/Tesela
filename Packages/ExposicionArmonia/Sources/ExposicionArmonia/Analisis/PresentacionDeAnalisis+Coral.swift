import Armonia

extension PresentacionDeAnalisis {
    // MARK: El coral de la hoja de una progresión

    /// El coral de la hoja: los acordes a cuatro voces (`Coral(realizando:en:)`), con el pentagrama y lo que dice
    /// la revisión (sus faltas o que no las tiene), o, si no se pueden escribir, por qué.
    struct CoralDeLaHoja {
        let filas: [CoralPresentado.AcordeDelCoral]
        let pentagrama: PentagramaPresentado?
        let avisos: [String]
    }

    /// Los acordes del análisis a cuatro voces, para las hojas en SVG y en HTML.
    static func coralDeLaHoja(_ analisis: AnalisisPresentado, en notacion: Notacion) -> CoralDeLaHoja {
        let coral: Coral
        do {
            coral = try Coral(realizando: analisis.acordes, en: analisis.tonalidad)
        } catch {
            let avisos: [CoralPresentado.Aviso] = [.sinRealizacion, .motivo(error)]
            return CoralDeLaHoja(filas: [], pentagrama: nil, avisos: avisos.map { $0.texto(en: notacion) })
        }
        let grados = analisis.tramos.flatMap(\.filas).map(\.grado)
        let filas = coral.acordes.indices.map { i in
            CoralPresentado.AcordeDelCoral(
                cifrado: analisis.acordes[i].cifrado(en: notacion),
                grado: grados.count == coral.acordes.count ? grados[i] : "",
                voces: PresentacionDeCoral.voces(coral.acordes[i], notacion))
        }
        let revision = PresentacionDeCoral.revisar(coral, en: notacion).avisos.map { $0.texto(en: notacion) }
        return CoralDeLaHoja(
            filas: filas,
            pentagrama: PentagramaPresentado(coral.acordes, titulo: notacion.texto(\.coral), en: notacion),
            avisos: revision)
    }
}
