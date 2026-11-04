import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// La `Partitura` en cada formato, y la de una voz, un coral, una progresión y un contrapunto. Las funciones de cada
// tipo (`voz.musicXML(…)`, `coral.midi(…)`…) son atajos de `partitura(…)` y el formato: las dos dan lo mismo.

extension Partitura {
    /// La partitura en MusicXML (`score-partwise`), en una parte con todos sus pentagramas.
    public func musicXML() -> String { Exportacion.documento(EscritorMusicXML.self, de: self) }

    /// La partitura en MEI.
    public func mei() -> String { Exportacion.documento(EscritorMEI.self, de: self) }

    /// La partitura en LilyPond (`.ly`).
    public func lilyPond() -> String { Exportacion.documento(EscritorLilyPond.self, de: self) }

    /// La partitura en GUIDO (`.gmn`).
    public func guido() -> String { Exportacion.documento(EscritorGUIDO.self, de: self) }

    /// La partitura en ABC.
    public func abc() -> String { Exportacion.documento(EscritorABC.self, de: self) }

    /// La partitura como fichero MIDI estándar: una pista por voz, de arriba abajo, con su nombre (o el de la
    /// parte), el instrumento del encabezado y sus marcadores. Con `afinacion`, las notas suenan en ella.
    public func midi(afinacion: (any Afinacion)? = nil) -> Data {
        var archivo = ArchivoMIDI(
            compas: compas, tonalidad: encabezado.tonalidad, tempo: encabezado.tempo, titulo: encabezado.titulo,
            afinacion: afinacion)
        for (linea, _) in lineas {
            var inicio = Duracion.cero
            let marcadores = linea.voz.eventos.map { evento in
                defer { inicio = inicio + evento.duracion }
                return linea.marcadores[inicio] ?? ""
            }
            archivo.anadir(
                linea.voz.eventos, nombre: linea.nombre ?? encabezado.parte, instrumento: encabezado.instrumento,
                marcadores: linea.marcadores.isEmpty ? [] : marcadores)
        }
        return archivo.datos
    }

    /// La partitura en el formato pedido: los formatos de texto, en UTF-8. La afinación solo cuenta en MIDI.
    ///
    ///     let partitura = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2").partitura()
    ///     for formato in FormatoDePartitura.allCases {
    ///         let datos = partitura.exportar(como: formato)
    ///         // …se guarda con `formato.extensionDeFichero`
    ///     }
    public func exportar(como formato: FormatoDePartitura, afinacion: (any Afinacion)? = nil) -> Data {
        switch formato {
        case .musicXML: return Data(musicXML().utf8)
        case .mei: return Data(mei().utf8)
        case .lilyPond: return Data(lilyPond().utf8)
        case .guido: return Data(guido().utf8)
        case .abc: return Data(abc().utf8)
        case .midi: return midi(afinacion: afinacion)
        }
    }
}

// MARK: - La partitura de cada tipo

extension Voz {
    /// La voz en un pentagrama. Si el encabezado no da tonalidad, se estima a partir de las notas; sin `clave`, la
    /// de sol o la de fa, según el registro.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let partitura = voz.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90)))
    ///     partitura.musicXML() == voz.musicXML(tempo: Tempo(90), titulo: "Escala")   // true
    public func partitura(clave: Clave? = nil, encabezado: Encabezado = Encabezado()) -> Partitura {
        var cabecera = encabezado
        cabecera.tonalidad = encabezado.tonalidad ?? Exportacion.tonalidad(de: self)
        return Partitura(
            pentagramas: [.init(clave: clave, voces: [.init(self)])], encabezado: cabecera, compas: compas,
            anacrusa: anacrusa)
    }
}

extension Coral {
    /// El coral en dos pentagramas, cada acorde de `duracion` y el último alargado hasta la barra: las voces agudas
    /// (soprano y contralto) en clave de sol y las graves (tenor y bajo) en clave de fa, con las plicas de la de
    /// arriba hacia arriba y las de la de abajo hacia abajo, y cada una con su nombre. Con `cifrados`, cada acorde
    /// lleva su cifrado americano encima del soprano; con `analisis`, su cifrado romano y su función debajo del
    /// bajo, y la tonalidad al principio. Si el encabezado no da tonalidad, se estima (a partir de los acordes si se
    /// analiza; si no, de las notas).
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let partitura = coral.partitura(duracion: .blanca, compas: "3/2", analisis: true)
    public func partitura(
        duracion: Duracion = .negra, compas: Compas = .compasillo,
        encabezado: Encabezado = Encabezado(parte: "Coro", instrumento: 52), cifrados: Bool = false,
        analisis: Bool = false, notacion: Notacion = .espanolCompacto
    ) -> Partitura {
        partitura(
            duracion: duracion, compas: compas, encabezado: encabezado, cifrados: cifrados, analisis: analisis,
            notacion: notacion, alargarElUltimo: true)
    }

    /// Lo mismo, con el último acorde alargado hasta la barra o no (en MIDI, suena lo que dura).
    package func partitura(
        duracion: Duracion, compas: Compas, encabezado: Encabezado, cifrados: Bool, analisis: Bool,
        notacion: Notacion, alargarElUltimo: Bool
    ) -> Partitura {
        let anotado = Exportacion.anotaciones(
            de: self, duracion: duracion, tonalidad: encabezado.tonalidad, cifrados: cifrados, analisis: analisis)
        var cabecera = encabezado
        cabecera.tonalidad = anotado.tonalidad
        var pentagramas = [Partitura.Pentagrama(clave: .sol, voces: []), Partitura.Pentagrama(clave: .fa, voces: [])]
        let n = numeroDeVoces
        let voces = Exportacion.voces(de: self, duracion: duracion, compas: compas, alargarElUltimo: alargarElUltimo)
        for linea in voces {
            // Los cifrados, con la voz más aguda; el análisis, con la más grave (si no es también la más aguda).
            let esLaMasAguda = linea.indice == n - 1
            pentagramas[linea.pentagrama - 1].voces.append(
                Partitura.Linea(
                    linea.voz, nombre: Coral.nombreDeVoz(linea.indice, de: n, en: notacion),
                    plicaArriba: linea.plicaArriba, cifrados: esLaMasAguda ? anotado.cifrados : [:],
                    analisis: linea.indice == 0 && !esLaMasAguda ? anotado.analisis : [:]))
        }
        return Partitura(
            pentagramas: pentagramas, encabezado: cabecera, compas: compas, anacrusa: .cero,
            tonalidadDelAnalisis: anotado.tonalidadDelAnalisis, notacion: notacion)
    }
}

extension AnalisisArmonico {
    /// La progresión en dos pentagramas, con lo que dura cada acorde (el último, alargado hasta la barra): los
    /// acordes en posición cerrada en clave de sol, con su cifrado americano encima si `cifrados`, y el bajo en
    /// clave de fa, con el cifrado romano y la función debajo si `analisis`, y la tonalidad al principio. La
    /// armadura es la de la tonalidad del análisis, y cada acorde lleva en MIDI un marcador con sus dos cifrados
    /// («Re7 · V7/V»).
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let partitura = analisis.partitura(duraciones: Array(repeating: .blanca, count: 5))
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func partitura(
        duraciones: [Duracion], compas: Compas = .compasillo,
        encabezado: Encabezado = Encabezado(parte: "Piano"), cifrados: Bool = true, analisis: Bool = true,
        notacion: Notacion = .espanolCompacto
    ) -> Partitura {
        partitura(
            duraciones: duraciones, compas: compas, encabezado: encabezado, cifrados: cifrados, analisis: analisis,
            notacion: notacion, alargarElUltimo: true)
    }

    /// Lo mismo, con el último acorde alargado hasta la barra o no (en MIDI, suena lo que dura).
    package func partitura(
        duraciones: [Duracion], compas: Compas, encabezado: Encabezado, cifrados: Bool, analisis: Bool,
        notacion: Notacion, alargarElUltimo: Bool
    ) -> Partitura {
        Exportacion.comprobar(duraciones, acordes: acordes.count)
        let (superior, grave) = Exportacion.progresion(
            acordes.map(\.acorde),
            duraciones: alargarElUltimo ? Exportacion.hastaLaBarra(duraciones, compas) : duraciones)
        let anotado = Exportacion.anotaciones(
            de: self, duraciones: duraciones, cifrados: cifrados, analisis: analisis)
        var marcadores: [Duracion: String] = [:]
        for (inicio, analizado) in zip(Exportacion.inicios(duraciones), acordes) {
            marcadores[inicio] = analizado.acorde.cifrado(en: notacion) + " · " + analizado.cifrado
        }
        var cabecera = encabezado
        cabecera.tonalidad = tonalidad
        let deLosAcordes = Partitura.Linea(
            Voz(superior, compas: compas), nombre: TextosDeFormatos.en(notacion, \.pistaDeAcordes),
            cifrados: anotado.cifrados, marcadores: marcadores)
        let delBajo = Partitura.Linea(
            Voz(grave, compas: compas), nombre: TextosDeFormatos.en(notacion, \.pistaDelBajo),
            analisis: anotado.analisis)
        return Partitura(
            pentagramas: [.init(clave: .sol, voces: [deLosAcordes]), .init(clave: .fa, voces: [delBajo])],
            encabezado: cabecera, compas: compas, anacrusa: .cero,
            tonalidadDelAnalisis: anotado.tonalidadDelAnalisis, notacion: notacion, llave: true)
    }
}

extension Contrapunto {
    /// El contrapunto en dos pentagramas, cada voz en el suyo (la de arriba encima) con su nombre latino y la clave
    /// que necesite menos líneas adicionales. La parte se llama como las dos voces («Cantus firmus ·
    /// Contrapunctus»). Si el encabezado no da tonalidad, ninguna, como en los ejemplos modales de Fux.
    public func partitura(encabezado: Encabezado = Encabezado(instrumento: 52)) -> Partitura {
        let lineas = vocesDeArribaAbajo
        var cabecera = encabezado
        cabecera.parte = lineas.map(\.nombre).joined(separator: " · ")
        return Partitura(
            pentagramas: lineas.map { Partitura.Pentagrama(voces: [Partitura.Linea($0.voz, nombre: $0.nombre)]) },
            encabezado: cabecera, compas: contrapunto.compas, anacrusa: .cero)
    }
}
