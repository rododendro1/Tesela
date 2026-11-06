import Armonia
import SwiftUI
import TeselaInterfaz

@main
struct TonnetzApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { VistaDeTonnetz() }
                .notacionGuardada()
        }
        #if os(macOS)
            // Sin un tamaño, la ventana se abre tan alta como su contenido y puede no caber en la pantalla.
            .defaultSize(width: 1000, height: 760)
        #endif
    }
}
