#if canImport(SwiftUI)
    import SwiftUI
    import Armonia
    import ArmoniaPresentacion

    /// El menú para elegir la notación de las notas y, aparte, el idioma de los textos. Guarda la `clave`
    /// de la `Notacion` (combinada si los textos van en otro idioma). Con `temperamento`, también elige con qué
    /// afinación suena «Escuchar» (el `rawValue` de una `AfinacionHistorica`), y con `octavasEnSubindice`, si la
    /// octava se escribe como subíndice (La₄). Lo habitual es ponerlo en la barra
    /// con `selectorDeNotacionEnLaBarra()`, que lo guarda todo en los ajustes que leen `notacionGuardada()` y el
    /// `Reproductor`.
    public struct SelectorDeNotacion: View {
        @Binding var clave: String
        private let temperamento: Binding<String>?
        private let octavasEnSubindice: Binding<Bool>?

        public init(
            clave: Binding<String>, temperamento: Binding<String>? = nil, octavasEnSubindice: Binding<Bool>? = nil
        ) {
            self._clave = clave
            self.temperamento = temperamento
            self.octavasEnSubindice = octavasEnSubindice
        }

        public var body: some View {
            Menu {
                Picker(notacion.texto(\.notas), selection: notas) {
                    ForEach(Notacion.allCases, id: \.self) { notacion in
                        Text(notacion.titulo).tag(notacion.clave)
                    }
                }
                Picker(notacion.texto(\.textos), selection: textos) {
                    Text(notacion.texto(\.comoLasNotas)).tag("")
                    ForEach(Idioma.traducidos, id: \.self) { idioma in
                        Text(idioma.titulo).tag(idioma.clave)
                    }
                }
                if let octavasEnSubindice {
                    Toggle(notacion.texto(\.octavaEnSubindice), isOn: octavasEnSubindice)
                }
                if let temperamento {
                    Picker(notacion.texto(\.afinacionAlEscuchar), selection: temperamento) {
                        ForEach(AfinacionHistorica.allCases, id: \.self) { opcion in
                            Text(opcion.nombre(en: notacion)).tag(opcion.rawValue)
                        }
                    }
                }
            } label: {
                Text(notacion.titulo)
            }
            // Para las pruebas de interfaz, que no pueden buscarlo por su título (cambia con la notación).
            .accessibilityIdentifier("selectorDeNotacion")
        }

        private var notacion: Notacion { .desde(clave: clave) }

        /// La notación de las notas; al cambiarla se conserva el idioma de los textos.
        private var notas: Binding<String> {
            Binding(
                get: { Notacion.desde(clave: clave).notas.clave },
                set: { clave = Notacion.desde(clave: clave).conNotas(Notacion.desde(clave: $0)).clave })
        }

        /// El idioma de los textos, o "" si van en el de las notas.
        private var textos: Binding<String> {
            Binding(
                get: { Notacion.desde(clave: clave).idiomaElegidoParaLosTextos?.clave ?? "" },
                set: { nuevo in
                    let idioma = Idioma.allCases.first { $0.clave == nuevo }
                    clave = Notacion.desde(clave: clave).conTextosElegidos(idioma).clave
                })
        }
    }

    /// El selector, guardando la notación, la octava en subíndice y el temperamento en los ajustes de las apps.
    struct SelectorDeNotacionGuardada: View {
        @AppStorage(AjustesDeLasApps.claveDeNotacion) private var clave = Notacion.delSistema().clave
        @AppStorage(AjustesDeLasApps.claveDeOctavasEnSubindice) private var octavasEnSubindice = false
        @AppStorage(AjustesDeLasApps.claveDeTemperamento) private var temperamento = AfinacionHistorica.igual.rawValue

        var body: some View {
            SelectorDeNotacion(clave: $clave, temperamento: $temperamento, octavasEnSubindice: $octavasEnSubindice)
        }
    }

    extension View {
        /// Pone en la barra de herramientas el selector de notación, que guarda la elegida en los ajustes
        /// (`notacionGuardada()` la pone en el entorno).
        public func selectorDeNotacionEnLaBarra() -> some View {
            toolbar {
                ToolbarItem {
                    SelectorDeNotacionGuardada()
                }
            }
        }

        /// Pone el selector de notación en la barra de herramientas, guardando la clave en `clave`.
        public func selectorDeNotacionEnLaBarra(clave: Binding<String>) -> some View {
            toolbar {
                ToolbarItem {
                    SelectorDeNotacion(clave: clave)
                }
            }
        }

        /// Un campo de texto para cifrados y escalas: sin autocorrección y, en iOS, sin mayúscula inicial
        /// (los cifrados distinguen `M` de `m`).
        public func comoCampoDeCifrado() -> some View {
            #if os(iOS)
                return self.autocorrectionDisabled().textInputAutocapitalization(.never)
            #else
                return self.autocorrectionDisabled()
            #endif
        }
    }
#endif
