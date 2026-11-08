import Armonia
import Exposicion
import Foundation

// MARK: - El teclado de piano y el reloj de una escala

extension LineaDeComandos {
    /// `teclado Re mayor [--dedos [derecha|izquierda]] [--octavas 2]`: la escala en un teclado de piano, en SVG, con
    /// el nombre de cada nota o, con una mano, sus dedos.
    static func teclado(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(try conLosDedos(argumentos, soloPiano: true))
        guard let octavas = argumentos.quitarNumero(.octavas, en: 1...4, porDefecto: 1) else {
            throw ErrorDeUso.octavasFueraDeRango
        }
        var mano: Mano?
        if let texto = try argumentos.valor(.mano) {
            guard let elegida = manoDePiano(texto) else { throw ErrorDeUso.manoDesconocida(texto) }
            mano = elegida
        }
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelTeclado }
        let escala = try Escala(leyendo: argumentos.unidos, enLaOrden: notacion)
        let svg = PresentacionDeEstudioDeEscala.teclado(de: escala, mano: mano, octavas: octavas, en: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// `reloj Do disminuida [--quintas]`: la escala en un reloj de doce horas, en SVG.
    static func reloj(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        let quintas = argumentos.quitarMarca(.quintas)
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaEscalaDelReloj }
        let escala = try Escala(leyendo: argumentos.unidos, enLaOrden: notacion)
        let svg = PresentacionDeEstudioDeEscala.reloj(
            de: escala, orden: quintas ? .quintas : .cromatico, en: notacion)
        return bien(svg.trimmingCharacters(in: "\n"))
    }

    /// La mano de `teclado … --dedos`, en español o en inglés.
    static func manoDePiano(_ texto: String) -> Mano? {
        let manos: [String: Mano] = [
            "derecha": .derecha, "right": .derecha, "izquierda": .izquierda, "left": .izquierda,
        ]
        return manos[texto.lowercased()]
    }
}
