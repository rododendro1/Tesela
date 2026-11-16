#if canImport(SwiftUI)
    import SwiftUI
    import Armonia
    import ExposicionArmonia

    /// Un menú de la barra con los favoritos y lo último visto en una pestaña (`MemoriaDeLasApps`), para volver a
    /// ello, y un botón para marcar como favorito lo que hay escrito:
    ///
    ///     .toolbar {
    ///         ToolbarItem { MenuDeRecuerdos(.acordes, texto: $modelo.texto) }
    ///     }
    public struct MenuDeRecuerdos: View {
        let lugar: MemoriaDeLasApps.Lugar
        @Binding var texto: String
        @Environment(\.notacion) private var notacion
        /// La memoria guardada, para que el menú cambie cuando otra vista la escribe.
        @AppStorage(AjustesDeLasApps.claveDeMemoria) private var guardada = ""

        public init(_ lugar: MemoriaDeLasApps.Lugar, texto: Binding<String>) {
            self.lugar = lugar
            _texto = texto
        }

        public var body: some View {
            let memoria = MemoriaDeLasApps(guardada: guardada)
            let favorito = memoria.esFavorito(texto, en: lugar)
            Menu {
                Button {
                    var nueva = memoria
                    nueva.alternarFavorito(texto, en: lugar)
                    guardada = nueva.guardada
                } label: {
                    if favorito {
                        Label(notacion.texto(\.quitarDeFavoritos), systemImage: "star.slash")
                    } else {
                        Label(notacion.texto(\.anadirAFavoritos), systemImage: "star")
                    }
                }
                .disabled(MemoriaDeLasApps.limpio(texto).isEmpty)
                let favoritos = memoria.favoritos(de: lugar)
                if !favoritos.isEmpty {
                    Section(notacion.texto(\.favoritos)) { botones(favoritos) }
                }
                let recientes = memoria.historial(de: lugar)
                if !recientes.isEmpty {
                    Section(notacion.texto(\.recientes)) {
                        botones(recientes)
                        Button(role: .destructive) {
                            var nueva = memoria
                            nueva.borrarHistorial(de: lugar)
                            guardada = nueva.guardada
                        } label: {
                            Label(notacion.texto(\.borrarElHistorial), systemImage: "trash")
                        }
                    }
                }
            } label: {
                Label(notacion.texto(\.recientes), systemImage: favorito ? "star.fill" : "clock.arrow.circlepath")
            }
            .accessibilityIdentifier("recuerdos")
        }

        private func botones(_ recuerdos: [MemoriaDeLasApps.Recuerdo]) -> some View {
            ForEach(recuerdos) { recuerdo in
                Button(MemoriaDeLasApps.titulo(de: recuerdo, en: notacion)) { texto = recuerdo.texto }
            }
        }
    }

    /// Anota en la memoria de las apps lo escrito en una pestaña cuando se deja de escribir un momento y se lee
    /// (`valido`), y al salir de ella.
    struct Recordando: ViewModifier {
        let texto: String
        let lugar: MemoriaDeLasApps.Lugar
        let valido: Bool
        @AppStorage(AjustesDeLasApps.claveDeMemoria) private var guardada = ""

        func body(content: Content) -> some View {
            content
                .task(id: texto) {
                    // Lo que se escribe a medias no entra en el historial: solo lo que se queda un segundo.
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    guard !Task.isCancelled else { return }
                    anotar()
                }
                .onDisappear(perform: anotar)
        }

        private func anotar() {
            guard valido else { return }
            var memoria = MemoriaDeLasApps(guardada: guardada)
            memoria.anotar(texto, en: lugar)
            let nueva = memoria.guardada
            if nueva != guardada { guardada = nueva }
        }
    }

    extension View {
        /// Recuerda lo escrito en una pestaña, si se lee, para volver a ello al abrir la app y en `MenuDeRecuerdos`:
        ///
        ///     Form { … }.recordando(modelo.texto, en: .acordes, valido: modelo.acorde != nil)
        public func recordando(_ texto: String, en lugar: MemoriaDeLasApps.Lugar, valido: Bool) -> some View {
            modifier(Recordando(texto: texto, lugar: lugar, valido: valido))
        }
    }
#endif
