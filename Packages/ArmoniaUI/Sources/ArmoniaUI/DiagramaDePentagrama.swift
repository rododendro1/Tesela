#if canImport(SwiftUI) && canImport(WebKit)
    import SwiftUI
    import Armonia

    /// El pentagrama de una escala o de un acorde, dibujado por el motor.
    ///
    ///     DiagramaDePentagrama(Escala("Re dórico"))
    ///     DiagramaDePentagrama(Acorde("Sol7"), notacion: .inglesASCII)
    ///
    /// Para ofrecerlo como fichero SVG: `BotonDeExportar([pentagrama.fichero])`, con la `PresentacionDePentagrama`.
    public struct DiagramaDePentagrama: View {
        public let presentacion: PresentacionDePentagrama
        /// Lo más alto que llega el dibujo, en puntos; el pentagrama doble y las escalas largas piden más que los demás.
        public let alturaMaxima: CGFloat

        public init(_ presentacion: PresentacionDePentagrama, alturaMaxima: CGFloat = 260) {
            self.presentacion = presentacion
            self.alturaMaxima = alturaMaxima
        }

        public init(
            _ escala: Escala, octava: Int = 4, sentido: SentidoDelIntervalo? = nil,
            notacion: Notacion = .espanolUnicode, nombresDeLasNotas: Bool = true, alturaMaxima: CGFloat = 260
        ) {
            self.init(
                PresentacionDePentagrama(
                    escala, octava: octava, sentido: sentido, notacion: notacion,
                    nombresDeLasNotas: nombresDeLasNotas), alturaMaxima: alturaMaxima)
        }

        public init(
            _ acorde: Acorde, octava: Int = 4, notacion: Notacion = .espanolUnicode,
            nombresDeLasNotas: Bool = false, alturaMaxima: CGFloat = 260
        ) {
            self.init(
                PresentacionDePentagrama(
                    acorde, octava: octava, notacion: notacion,
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
