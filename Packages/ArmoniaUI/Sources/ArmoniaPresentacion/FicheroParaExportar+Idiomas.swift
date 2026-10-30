import Armonia
// Los nombres de los formatos de exportación en los catorce idiomas de los textos (`Traduccion`).

extension FicheroParaExportar.Formato {
    /// Cómo se llama el formato en el menú: «Partitura MusicXML», «MusicXML score»…
    public func titulo(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .musicXML:
            traduccion = Traduccion("Partitura MusicXML", "MusicXML score", ca: "Partitura MusicXML",
                                    gl: "Partitura MusicXML", ast: "Partitura MusicXML", an: "Partitura MusicXML",
                                    eu: "MusicXML partitura", pt: "Partitura MusicXML",
                                    fr: "Partition MusicXML", oc: "Particion MusicXML", it: "Partitura MusicXML",
                                    de: "MusicXML-Partitur",
                                    el: "Παρτιτούρα MusicXML", ru: "Партитура MusicXML")
        case .mei:
            traduccion = Traduccion("Partitura MEI", "MEI score", ca: "Partitura MEI",
                                    gl: "Partitura MEI", ast: "Partitura MEI", an: "Partitura MEI",
                                    eu: "MEI partitura", pt: "Partitura MEI",
                                    fr: "Partition MEI", oc: "Particion MEI", it: "Partitura MEI",
                                    de: "MEI-Partitur",
                                    el: "Παρτιτούρα MEI", ru: "Партитура MEI")
        case .midi:
            return "MIDI"
        case .svg:
            traduccion = Traduccion("Dibujo SVG", "SVG drawing", ca: "Dibuix SVG", gl: "Debuxo SVG", ast: "Dibuxu SVG",
                                    an: "Dibuixo SVG", eu: "SVG marrazkia", pt: "Desenho SVG",
                                    fr: "Dessin SVG", oc: "Dessenh SVG", it: "Disegno SVG", de: "SVG-Zeichnung",
                                    el: "Σχέδιο SVG", ru: "Рисунок SVG")
        }
        return traduccion.en(notacion)
    }
}
