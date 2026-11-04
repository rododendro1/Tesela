import ArmoniaNucleo
import ArmoniaTeoria

// La partitura en SVG (`Partitura.svg(opciones:)`): con un pentagrama, el de su voz (o sus dos voces), con lo que se
// anota en ella; con varios, un sistema, sin anotaciones. Es la única puerta pública al pentagrama con ritmo: los
// dibujos de cada caso (`Voz.svgPentagrama`, `svgPentagrama(junto:)`, `Voz.svgSistema`) son internos.

extension Partitura {
    /// La partitura en SVG, con el título del encabezado (o el nombre de la parte) y su armadura si las opciones no
    /// fijan otra. Un solo pentagrama con una voz lleva lo que se anota en ella: los cifrados encima, los dedos
    /// encima de las notas, el grado debajo (el de `grados` o, si no, el cifrado romano del análisis), el bajo
    /// cifrado más abajo y, si el pentagrama tiene `cuerdas`, la tablatura con sus pulsaciones. Con dos voces, las
    /// dos en el pentagrama, con los cifrados de la primera. Varios pentagramas van en un sistema, unidos por la
    /// llave si la lleva; los que no tienen voces no se dibujan.
    ///
    ///     let partitura = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2").partitura(encabezado: Encabezado(titulo: "Do"))
    ///     let svg = partitura.svg()
    public func svg(opciones: OpcionesDePentagrama = OpcionesDePentagrama()) -> String {
        let titulo = encabezado.titulo ?? parte
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
        let inicios = primera.voz.inicios
        func porEvento<Valor>(_ porInicio: [Duracion: Valor]) -> [Int: Valor] {
            var resultado: [Int: Valor] = [:]
            for (i, inicio) in inicios.enumerated() { resultado[i] = porInicio[inicio] }
            return resultado
        }
        let acordes = porEvento(primera.cifrados)
        if pentagrama.voces.count > 1 {
            return primera.voz.svgPentagrama(
                junto: pentagrama.voces[1].voz, titulo: titulo, acordes: acordes, opciones: suyas)
        }
        var grados = porEvento(primera.analisis.mapValues(\.cifrado))
        grados.merge(porEvento(primera.grados)) { _, propio in propio }
        let tablatura = pentagrama.cuerdas.map { Tablatura(cuerdas: $0, notas: porEvento(primera.pulsaciones)) }
        return primera.voz.svgPentagrama(
            titulo: titulo, acordes: acordes, grados: grados, bajoCifrado: porEvento(primera.bajoCifrado),
            digitos: porEvento(primera.digitos), tablatura: tablatura, tonica: nil, armadura: nil, opciones: suyas)
    }
}
