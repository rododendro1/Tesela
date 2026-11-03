import ArmoniaNucleo
import ArmoniaTeoria

// Lo que dibuja un pentagrama en SVG: escalas, acordes y arpegios. El dibujo está en `PentagramaSVG.swift`.

extension Escala {
    /// La escala en un pentagrama, como SVG: `Escala("Re dórico").svgPentagrama()`. Si la escala tiene microtonos
    /// (`TipoDeEscala.microtonal`), sus notas llevan los signos de Bravura: el medio bemol de un maqam, el koron de un
    /// dastgāh, las comas de Arel-Ezgi-Uzdilek de un makam, los moria de un echos bizantino (con los signos de
    /// Wyschnegradsky) o la flecha de Helmholtz-Ellis de un śruti.
    ///
    /// - Parameters:
    ///   - octava: la octava de la tónica.
    ///   - octavas: cuántas octavas sube (y baja) la escala: 2, de la tónica de `octava` a la de dos octavas más
    ///     arriba.
    ///   - sentido: si se da, solo la subida o la bajada; si es `nil`, la subida y, en las escalas que bajan con
    ///     otras notas (la menor melódica), también la bajada.
    ///   - opciones: clave, armadura, notación, tamaño y color.
    public func svgPentagrama(
        octava: Int = 4, octavas: Int = 1, sentido: SentidoDelIntervalo? = nil,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let alturas = alturasMicrotonales(octava: octava, octavas: octavas, sentido: sentido)
        let armadura = opciones.armadura.notas(propia: notasDeLaArmadura)
        // Los microtonos, con su signo: el medio bemol de un maqam, el koron de un dastgāh, las comas de un makam, los
        // moria de un echos, la flecha de un śruti.
        let microtonos = alturas.map { altura -> [PentagramaSVG.Microtono?] in
            guard let nota = altura.nota, altura.desvio != 0 else { return [nil] }
            let signo = SignoMicrotonal(
                nota: nota, semitonos: altura.altura.nota.alteracion.semitonos, desvio: altura.desvio)
            return [PentagramaSVG.Microtono(signo: signo, nombre: nota.nombre(en: opciones.notacion))]
        }
        return PentagramaSVG(
            columnas: alturas.map { [$0.altura] }, armadura: armadura, cifrado: nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones, microtonos: microtonos,
            referencias: [0: PentagramaSVG.Referencia(tonica)]
        ).svg()
    }
}

extension Acorde {
    /// El acorde en un pentagrama, como SVG: `Acorde("Sol7").svgPentagrama()`. Las notas van apiladas desde el bajo,
    /// en posición cerrada y a partir de `octava` (el bajo, en la primera octava en que su nota alcanza el Do de esa
    /// octava), con el cifrado encima. Los acordes muy extensos y `disposicionDelAcorde: .abierta` ponen el bajo una
    /// octava más grave y el resto encima, y con eso suelen pasar al pentagrama doble. Sin armadura, salvo la de
    /// `.tonalidad`.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = true,
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        let cerrada = Altura.posicionCerrada(notasDesdeElBajo, desde: Altura(.do, octava: octava).midi)
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
                Altura.posicionCerrada([bajo], desde: Altura(.do, octava: octava - 1).midi)
                + Altura.posicionCerrada(
                    Array(notasDesdeElBajo.dropFirst()), desde: Altura(.do, octava: octava).midi)
        }
        let texto = cifrado(en: opciones.notacion)
        return PentagramaSVG(
            columnas: [alturas], armadura: opciones.armadura.notas(), cifrado: conCifrado ? texto : nil,
            titulo: texto, opciones: opciones, referencias: [0: PentagramaSVG.Referencia(self)]
        ).svg()
    }
}

extension Arpegio {
    /// El arpegio en un pentagrama, como SVG: `Arpegio("Do7").svgPentagrama()`. Cada nota, en el orden del patrón y
    /// a partir de `octava` (la del bajo), va en su columna, con las alteraciones que le hagan falta (sin armadura,
    /// salvo la de una tonalidad: `OpcionesDePentagrama(armadura: .tonalidad(…))`) y su nombre en un `<title>`; el
    /// título de la imagen es el nombre del arpegio. Con `cifrado`, el del acorde va encima de la primera nota.
    public func svgPentagrama(
        octava: Int = 4, cifrado conCifrado: Bool = false, opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        PentagramaSVG(
            columnas: alturas(octava: octava).map { [$0] }, armadura: opciones.armadura.notas(),
            cifrado: conCifrado ? acorde.cifrado(en: opciones.notacion) : nil,
            titulo: nombre(en: opciones.notacion), opciones: opciones,
            referencias: [0: PentagramaSVG.Referencia(acorde)]
        ).svg()
    }
}

extension DisposicionDeAcorde {
    /// Acordes con sus alturas escritas (las disposiciones de `Acorde.disposiciones(_:en:)` o de
    /// `DisposicionDeAcorde.conducir(_:en:)`), uno por columna, sin armadura (salvo la de `.tonalidad`): en dos
    /// pentagramas si las notas pasan a los dos lados del Do central y con uno harían falta más de tres líneas
    /// adicionales.
    ///
    ///     let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
    ///     let voces = DisposicionDeAcorde.drop2.conducir(progresion) ?? []
    ///     let svg = DisposicionDeAcorde.svgPentagrama(voces, titulo: "ii–V–I", cifrados: progresion)
    ///
    /// Con `cifrados` (un acorde por columna), cada columna lleva encima su cifrado, y los intervalos de las notas
    /// (`intervalosDeLasNotas`) se cuentan desde la fundamental de su acorde.
    public static func svgPentagrama(
        _ acordes: [[Altura]], titulo: String, cifrados: [Acorde] = [],
        opciones: OpcionesDePentagrama = OpcionesDePentagrama()
    ) -> String {
        var textos: [Int: String] = [:]
        var referencias: [Int: PentagramaSVG.Referencia] = [:]
        for (columna, acorde) in zip(acordes.indices, cifrados) {
            textos[columna] = acorde.cifrado(en: opciones.notacion)
            referencias[columna] = PentagramaSVG.Referencia(acorde)
        }
        return PentagramaSVG(
            columnas: acordes, armadura: opciones.armadura.notas(), cifrado: nil, titulo: titulo, opciones: opciones,
            cifrados: textos, referencias: referencias
        ).svg()
    }
}
