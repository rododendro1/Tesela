import Armonia
import ArmoniaUI
import SwiftUI

@main
struct TonnetzApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { VistaDeTonnetz() }
                .notacionGuardada()
        }
    }
}
