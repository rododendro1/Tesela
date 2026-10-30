import SwiftUI
import Armonia

/// La pestaña elegida y lo que una pestaña le pide a otra: «Ver en Acordes» desde Identificar, o una escala
/// compatible desde Acordes. Va en el entorno (`environmentObject`) de todas las vistas de la app.
@MainActor
final class Navegacion: ObservableObject {
    enum Pestana: Hashable {
        case acordes, escalas, analisis, coral, identificar
    }

    @Published var pestana = Pestana.acordes
    /// El acorde que tiene que mostrar la pestaña de acordes; la vista lo recoge y lo vacía.
    @Published var acordePedido: Acorde?
    /// La escala que tiene que mostrar la pestaña de escalas; la vista la recoge y la vacía.
    @Published var escalaPedida: Escala?

    func ver(_ acorde: Acorde) {
        acordePedido = acorde
        pestana = .acordes
    }

    func ver(_ escala: Escala) {
        escalaPedida = escala
        pestana = .escalas
    }
}
