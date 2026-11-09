#if canImport(SwiftUI) && canImport(WebKit)
    import SwiftUI
    import Armonia

    /// El pentagrama de una escala o de un acorde, dibujado por el motor.
    ///
    ///     DiagramaDePentagrama(Escala("Re dórico"), en: .compacta(.espanol))
    ///     DiagramaDePentagrama(Acorde("Sol7"), en: .ascii(.ingles))
    ///
    /// Para ofrecerlo como fichero SVG: `BotonDeExportar([pentagrama.fichero])`, con la `PentagramaPresentado`.
    public struct DiagramaDePentagrama: View {
        public let presentacion: PentagramaPresentado
        /// Lo más alto que llega el dibujo, en puntos; el pentagrama doble y las escalas largas piden más que los demás.
        public let alturaMaxima: CGFloat

        /// El pentagrama ya presentado, como mucho de esa altura.
        public init(_ presentacion: PentagramaPresentado, alturaMaxima: CGFloat = 260) {
            self.presentacion = presentacion
            self.alturaMaxima = alturaMaxima
        }

        /// El pentagrama de una escala, como `PentagramaPresentado(_:octava:sentido:en:nombresDeLasNotas:resaltada:)`.
        public init(
            _ escala: Escala, octava: Int = 4, sentido: SentidoDelIntervalo? = nil,
            en notacion: Notacion, nombresDeLasNotas: Bool = true, alturaMaxima: CGFloat = 260
        ) {
            self.init(
                PentagramaPresentado(
                    escala, octava: octava, sentido: sentido, en: notacion,
                    nombresDeLasNotas: nombresDeLasNotas), alturaMaxima: alturaMaxima)
        }

        /// El pentagrama de un acorde, como `PentagramaPresentado(_:octava:en:nombresDeLasNotas:)`.
        public init(
            _ acorde: Acorde, octava: Int = 4, en notacion: Notacion,
            nombresDeLasNotas: Bool = false, alturaMaxima: CGFloat = 260
        ) {
            self.init(
                PentagramaPresentado(
                    acorde, octava: octava, en: notacion,
                    nombresDeLasNotas: nombresDeLasNotas), alturaMaxima: alturaMaxima)
        }

        public var body: some View {
            // Adaptable: el dibujo usa `currentColor`, así que sigue el modo claro u oscuro del sistema.
            VistaSVG(svg: presentacion.svg, adaptable: true)
                .aspectRatio(presentacion.relacionDeAspecto, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: alturaMaxima)
                .clipShape(RoundedRectangle(cornerRadius: TemaDeLasApps.radioDeEsquina))
                .accessibilityLabel(Text(presentacion.descripcion))
        }
    }

#endif
