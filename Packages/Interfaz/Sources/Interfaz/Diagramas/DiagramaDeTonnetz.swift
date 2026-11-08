#if canImport(SwiftUI) && canImport(WebKit)
    import SwiftUI
    import Armonia

    /// El Tonnetz de unas notas, un acorde o una escala, dibujado por el motor.
    ///
    ///     DiagramaDeTonnetz(Tonnetz(try Acorde(leyendo: "Dom7")), notacion: .compacta(.espanol))
    ///     DiagramaDeTonnetz(Tonnetz(Escala(.re, .dorico)), notacion: .ascii(.ingles))
    public struct DiagramaDeTonnetz: View {
        public let tonnetz: Tonnetz
        public let notacion: Notacion
        public let leyenda: Bool

        /// El Tonnetz con sus notas en la notación y, si `leyenda`, la explicación de los ejes.
        public init(_ tonnetz: Tonnetz, notacion: Notacion, leyenda: Bool = true) {
            self.tonnetz = tonnetz
            self.notacion = notacion
            self.leyenda = leyenda
        }

        public var body: some View {
            VistaSVG(svg: tonnetz.svg(opciones: .init(notacion: notacion), leyenda: leyenda))
                .clipShape(RoundedRectangle(cornerRadius: TemaDeLasApps.radioDeEsquina))
                .accessibilityLabel(
                    Text("Tonnetz: " + tonnetz.notas.map { $0.nombre(en: notacion) }.joined(separator: ", ")))
        }
    }

#endif
