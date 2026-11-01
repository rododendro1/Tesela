import ArmoniaNucleo
import ArmoniaTeoria

// Lo que dibuja un pentagrama en SVG: escalas, acordes y arpegios. El dibujo está en `PentagramaSVG.swift`.

extension Escala {
    /// La escala en un pentagrama, como SVG: `Escala("Re dórico").svgPentagrama()`.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas (la menor melódica), también la bajada.
    ///   - opciones: clave, armadura, notación, tamaño y color.
    public func svgPentagrama(
        octava: Int = 4, sentido: SentidoDelIntervalo? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let alturas: [Altura]
        switch sentido {
        case .ascendente?: alturas = self.alturas(octava: octava)
        case .descendente?: alturas = self.alturas(octava: octava, sentido: .descendente)
        case nil:
            let subida = self.alturas(octava: octava)
            alturas =
                tipo.esDireccional ? subida + self.alturas(octava: octava, sentido: .descendente).dropFirst() : subida
        }
        var armadura: [Nota] = []
        if opciones.armadura == .automatica, let propia = notasDeLaArmadura, propia.count <= 7 { armadura = propia }
        return PentagramaSVG(
            columnas: alturas.map { [$0] }, armadura: armadura, cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones
        ).svg()
    }
}

extension Acorde {
    /// El acorde en un pentagrama, como SVG: `Acorde("Sol7").svgPentagrama()`. Las notas van apiladas desde el bajo,
    /// en posición cerrada y a partir de `octava` (el bajo, en la primera octava en que su nota alcanza el Do de esa
    /// octava), con el cifrado encima. Los acordes muy extensos y `disposicionDelAcorde: .abierta` ponen el bajo una
    /// octava más grave y el resto encima, y con eso suelen pasar al pentagrama doble.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = true,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let cerrada = Exportacion.posicionCerrada(notasDesdeElBajo, desde: Altura(.do, octava: octava).midi)
        let abierta: Bool
        switch opciones.disposicionDelAcorde {
        case .cerrada: abierta = false
        case .abierta: abierta = true
        case .automatica:
            let ambito = cerrada.map(\.midi).extremosOSi(noHay: 0...0)
            abierta = ambito.upperBound - ambito.lowerBound >= 17
        }
        var alturas = cerrada
        if abierta, let bajo = notasDesdeElBajo.first, notasDesdeElBajo.count > 1 {
            alturas =
                Exportacion.posicionCerrada([bajo], desde: Altura(.do, octava: octava - 1).midi)
                + Exportacion.posicionCerrada(
                    Array(notasDesdeElBajo.dropFirst()), desde: Altura(.do, octava: octava).midi)
        }
        let texto = cifrado(en: opciones.notacion)
        return PentagramaSVG(
            columnas: [alturas], armadura: [], cifrado: conCifrado ? texto : nil,
            titulo: texto, opciones: opciones
        ).svg()
    }
}

extension Arpegio {
    /// El arpegio en un pentagrama, como SVG: `Arpegio("Do7").svgPentagrama()`. Cada nota, en el orden del patrón y
    /// a partir de `octava` (la del bajo), va en su columna, con las alteraciones que le hagan falta (no lleva
    /// armadura) y su nombre en un `<title>`; el título de la imagen es el nombre del arpegio.
    public func svgPentagrama(octava: Int = 4, opciones: OpcionesDePentagrama = OpcionesDePentagrama()) -> String {
        PentagramaSVG(
            columnas: alturas(octava: octava).map { [$0] }, armadura: [], cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones
        ).svg()
    }
}
