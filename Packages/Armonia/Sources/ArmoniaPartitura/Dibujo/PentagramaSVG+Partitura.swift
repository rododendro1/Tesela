import ArmoniaNucleo
import ArmoniaTeoria

// La partitura en SVG (`Partitura.svg(opciones:)`): con un pentagrama, el de su voz (o sus dos voces), con lo que se
// anota en ella; con varios, un sistema, sin anotaciones. Es la única puerta pública al pentagrama con ritmo: los
// dibujos de cada caso (`Voz.svgPentagrama`, `svgPentagrama(junto:)`, `Voz.svgSistema`) son internos.

extension Partitura {
    /// La partitura en SVG, en su notación (``notacion``) y con su armadura si las opciones no fijan otras, y con el
    /// título de las opciones o, si no lo dan, el del encabezado en esa notación (``Encabezado/titulo(en:)``) o el
    /// nombre de la parte. Un solo pentagrama con una voz lleva lo que se anota en ella: los cifrados encima, los dedos
    /// encima de las notas, el grado debajo (el de `grados` o, si no, el cifrado romano del análisis), el bajo cifrado
    /// más abajo y, si el pentagrama tiene `cuerdas`, la tablatura con sus pulsaciones. Con dos voces, las dos en el
    /// pentagrama, con los cifrados de la primera. Varios pentagramas van en un sistema, unidos por la llave si la
    /// lleva; los que no tienen voces no se dibujan.
    ///
    ///     let partitura = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2").partitura(encabezado: Encabezado(titulo: "Do"))
    ///     let svg = partitura.svg()
    public func svg(opciones: OpcionesDePentagrama = OpcionesDePentagrama()) -> String {
        var suyas = opciones
        if suyas.notacionFijada == nil { suyas.notacionFijada = notacion }
        let titulo = suyas.titulo ?? encabezado.titulo(en: suyas.notacion) ?? parte
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
        if let clave = pentagrama.clave { suyas.maquetacion.clave = clave }
        let primera = pentagrama.voces[0]
        let porNota = primera.porNota
        let acordes = porNota.cifrados
        if pentagrama.voces.count > 1 {
            return primera.voz.svgPentagrama(
                junto: pentagrama.voces[1].voz, titulo: titulo, acordes: acordes, opciones: suyas)
        }
        var grados = porNota.analisis.mapValues(\.cifrado)
        grados.merge(porNota.grados) { _, propio in propio }
        let tablatura = pentagrama.cuerdas.map { Tablatura(cuerdas: $0, notas: porNota.pulsaciones) }
        let armadura = pentagrama.armadura.map { suyas.armadura.notas(propia: $0) }
        if !ritmo {
            return columnas(
                primera.voz, titulo: titulo, acordes: acordes, grados: grados,
                bajoCifrado: porNota.bajoCifrado, digitos: porNota.digitos, tablatura: tablatura,
                tonica: primera.tonica, armadura: armadura ?? suyas.armadura.notas(), opciones: suyas)
        }
        return primera.voz.svgPentagrama(
            titulo: titulo, acordes: acordes, grados: grados, bajoCifrado: porNota.bajoCifrado,
            digitos: porNota.digitos, tablatura: tablatura, tonica: primera.tonica, armadura: armadura,
            opciones: suyas)
    }

    /// La voz sin ritmo: cada evento en su columna, con sus microtonos y lo que se anota en ella.
    private func columnas(
        _ voz: Voz, titulo: String, acordes: [Int: Acorde], grados: [Int: String], bajoCifrado: [Int: [String]],
        digitos: [Int: [Int]], tablatura: Tablatura?, tonica: Nota?, armadura: [Nota], opciones: OpcionesDePentagrama
    ) -> String {
        var cifrados: [Int: String] = [:]
        var referencias: [Int: PentagramaSVG.Referencia] = [:]
        if let tonica { referencias[0] = PentagramaSVG.Referencia(tonica) }
        for (columna, acorde) in acordes {
            if opciones.marcas.cifrados { cifrados[columna] = acorde.cifrado(en: opciones.notacion) }
            referencias[columna] = PentagramaSVG.Referencia(acorde)
        }
        var dibujo = PentagramaSVG(
            columnas: voz.eventos.map(\.alturas), armadura: armadura, cifrado: nil, titulo: titulo,
            opciones: opciones, cifrados: cifrados, referencias: referencias)
        dibujo.grados = grados
        dibujo.bajosCifrados = bajoCifrado
        dibujo.digitos = digitos
        dibujo.tablatura = tablatura
        dibujo.microtonos = voz.eventos.map { evento in
            evento.notas.map { PentagramaSVG.Microtono.de($0, notacion: opciones.notacion) }
        }
        return dibujo.svg()
    }
}
