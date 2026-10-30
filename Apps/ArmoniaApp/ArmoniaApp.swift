import SwiftUI
import Armonia
import ArmoniaUI

@main
struct ArmoniaApp: App {
    var body: some Scene {
        WindowGroup {
            VistaRaiz()
                .notacionGuardada()
        }
    }
}

/// Las cinco vistas de la app. Cada una tiene en su barra el selector de notación; la elegida está en el
/// entorno (`notacionGuardada()`) y decide también el idioma de la interfaz. La pestaña elegida y lo que unas
/// le piden a otras van en `Navegacion`.
struct VistaRaiz: View {
    @Environment(\.notacion) private var notacion
    @StateObject private var navegacion = Navegacion()

    var body: some View {
        TabView(selection: $navegacion.pestana) {
            NavigationStack { VistaDeAcordes() }
                .tabItem { Label(notacion.texto(.acordes), systemImage: "music.note.list") }
                .tag(Navegacion.Pestana.acordes)
            NavigationStack { VistaDeEscalas() }
                .tabItem { Label(notacion.texto(.escalas), systemImage: "chart.bar.xaxis") }
                .tag(Navegacion.Pestana.escalas)
            NavigationStack { VistaDeAnalisis() }
                .tabItem { Label(notacion.texto(.analisis), systemImage: "waveform.path.ecg") }
                .tag(Navegacion.Pestana.analisis)
            NavigationStack { VistaDeCoral() }
                .tabItem { Label(notacion.texto(.coral), systemImage: "music.quarternote.3") }
                .tag(Navegacion.Pestana.coral)
            NavigationStack { VistaDeIdentificar() }
                .tabItem { Label(notacion.texto(.identificar), systemImage: "hand.tap") }
                .tag(Navegacion.Pestana.identificar)
        }
        .environmentObject(navegacion)
    }
}
