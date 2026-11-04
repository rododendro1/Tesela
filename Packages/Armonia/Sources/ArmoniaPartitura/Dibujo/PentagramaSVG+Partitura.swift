import ArmoniaNucleo
import ArmoniaTeoria

// La partitura en SVG (`Partitura.svg(opciones:)`): con un pentagrama, como el de su voz (o sus dos voces), con los
// cifrados encima y el análisis debajo; con varios, como un sistema (`Voz.svgSistema`), sin anotaciones.

extension Partitura {
    /// La partitura en SVG, con el título del encabezado (o el nombre de la parte) y su armadura si las opciones no
    /// fijan otra. Un solo pentagrama se dibuja como `Voz.svgPentagrama(titulo:acordes:grados:…)`, con los cifrados
    /// de su primera voz encima y su análisis debajo, o, con dos voces, como `svgPentagrama(junto:…)`; varios, como
    /// `Voz.svgSistema(_:titulo:claves:llave:opciones:)`, unidos por la llave si la lleva. Los pentagramas sin voces
    /// no se dibujan.
    ///
    ///     let partitura = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2").partitura(encabezado: Encabezado(titulo: "Do"))
    ///     let svg = partitura.svg()
    public func svg(opciones: OpcionesDePentagrama = OpcionesDePentagrama()) -> String {
        let titulo = encabezado.titulo ?? encabezado.parte
        var suyas = opciones
        if suyas.armadura == .automatica, let tonalidad = encabezado.tonalidad {
            suyas.armadura = .tonalidad(tonalidad)
        }
        let llenos = pentagramas.filter { !$0.voces.isEmpty }
        guard llenos.count == 1 else {
            return Voz.svgSistema(
                llenos.map { $0.voces.map(\.voz) }, titulo: titulo, claves: llenos.map(\.clave), llave: llave,
                opciones: suyas)
        }
        let pentagrama = llenos[0]
        if let clave = pentagrama.clave { suyas.clave = clave }
        let primera = pentagrama.voces[0]
        let inicios = Voz.LineaDeLaVoz(eventos: primera.voz.eventos, inicio: .cero).inicios
        var acordes: [Int: Acorde] = [:]
        var grados: [Int: String] = [:]
        for (i, inicio) in inicios.enumerated() {
            acordes[i] = primera.cifrados[inicio]
            grados[i] = primera.analisis[inicio]?.cifrado
        }
        if pentagrama.voces.count > 1 {
            return primera.voz.svgPentagrama(
                junto: pentagrama.voces[1].voz, titulo: titulo, acordes: acordes, opciones: suyas)
        }
        return primera.voz.svgPentagrama(titulo: titulo, acordes: acordes, grados: grados, opciones: suyas)
    }
}
