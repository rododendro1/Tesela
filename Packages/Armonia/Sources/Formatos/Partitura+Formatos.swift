import Elementos
import Foundation
import PartituraArmonia
import Teoria

// La `Partitura` en cada formato, y la de una voz, un coral, una progresión y un contrapunto: cada tipo hace la suya
// con `partitura(…)`, y de ella sale cualquier formato (`voz.partitura().musicXML()`,
// `coral.partitura(duracion: .blanca).midi()`, `analisis.partitura().exportar(como: .lilyPond)`).

extension Partitura {
    /// La partitura en MusicXML 4.0 (`score-partwise`), en una parte con todos sus pentagramas, para MuseScore,
    /// Finale, Sibelius, Dorico o cualquier editor de partituras.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let xml = voz.partitura(encabezado: Encabezado(titulo: "Escala")).musicXML()
    public func musicXML() -> String { Exportacion.documento(EscritorMusicXML.self, de: self) }

    /// La partitura en MEI 5, para Verovio, mei-friend o MuseScore 4.
    public func mei() -> String { Exportacion.documento(EscritorMEI.self, de: self) }

    /// La partitura en LilyPond (`.ly`): `lilypond coral.ly` la graba en PDF.
    public func lilyPond() -> String { Exportacion.documento(EscritorLilyPond.self, de: self) }

    /// La partitura en GUIDO Music Notation (`.gmn`), para Guido Engine.
    public func guido() -> String { Exportacion.documento(EscritorGUIDO.self, de: self) }

    /// La partitura en ABC 2.1, para abcjs, abcm2ps o EasyABC.
    public func abc() -> String { Exportacion.documento(EscritorABC.self, de: self) }

    /// La partitura como fichero MIDI estándar (formato 1): una pista de control con el título, el tempo (negra =
    /// 120 si no se da), el compás y la armadura, y una por voz, de arriba abajo, con su nombre (o el de la parte),
    /// el instrumento y sus marcadores. Con `afinacion`, las notas suenan en ella
    /// (`TemperamentoRegular.mesotonicoCuartoDeComa`, `AfinacionHistorica.werckmeisterIII.afinacion()`…).
    ///
    ///     let datos = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2").partitura().midi()
    ///     try datos.write(to: URL(fileURLWithPath: "escala.mid"))
    public func midi(afinacion: (any SistemaDeAfinacion)? = nil) -> Data {
        var archivo = ArchivoMIDI(
            compas: compas, tonalidad: encabezado.tonalidad, tempo: encabezado.tempo,
            titulo: encabezado.titulo(en: notacion),
            afinacion: afinacion)
        for linea in lineas.map(\.linea) {
            var inicio = Duracion.cero
            let marcadores = linea.voz.eventos.map { evento in
                defer { inicio = inicio + evento.duracion }
                return linea.marcadores[inicio] ?? ""
            }
            archivo.anadir(
                linea.voz.eventos, nombre: linea.nombre ?? nombreDeLaParte, instrumento: instrumento,
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
    public func exportar(como formato: FormatoDePartitura, afinacion: (any SistemaDeAfinacion)? = nil) -> Data {
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
    /// de sol o la de fa, según el registro. La parte se llama «Voz» si el encabezado no le da nombre, y suena con
    /// el piano si no da instrumento.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
    ///     let partitura = voz.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90)))
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
    /// arriba hacia arriba y las de la de abajo hacia abajo, y cada una con su nombre (su pista en MIDI). Con
    /// `cifrados`, cada acorde lleva su cifrado americano encima del soprano; con `analisis`, su cifrado romano y su
    /// función debajo del bajo, y la tonalidad al principio. Los acordes se identifican por sus notas (con el bajo)
    /// entre los tipos de `TipoDeAcorde.todos`; los que no forman ninguno se quedan sin cifrar. Si el encabezado no
    /// da tonalidad, se estima (a partir de los acordes si se analiza; si no, de las notas); la parte se llama
    /// «Coro» si no le da nombre, y suena con el coro (52) si no da instrumento.
    ///
    ///     let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
    ///     let xml = coral.partitura(duracion: .blanca, compas: "3/2", conAnalisis: true).musicXML()
    public func partitura(
        duracion: Duracion = .negra, compas: Compas = .compasillo, encabezado: Encabezado = Encabezado(),
        conCifrados: Bool = false, conAnalisis: Bool = false, notacion: Notacion = .espanolCompacto
    ) -> Partitura {
        let anotado = Exportacion.anotaciones(
            de: self, duracion: duracion, tonalidad: encabezado.tonalidad, cifrados: conCifrados,
            analisis: conAnalisis)
        var cabecera = encabezado
        cabecera.tonalidad = anotado.tonalidad
        cabecera.nombreDeLaParte = encabezado.nombreDeLaParte ?? "Coro"
        cabecera.instrumento = encabezado.instrumento ?? 52
        var pentagramas = [Partitura.Pentagrama(clave: .sol, voces: []), Partitura.Pentagrama(clave: .fa, voces: [])]
        let n = numeroDeVoces
        for linea in Exportacion.voces(de: self, duracion: duracion, compas: compas) {
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
    /// La progresión en dos pentagramas, cada acorde de `duracion` (negras, si no se pide otra; el último,
    /// alargado hasta la barra): los acordes en posición cerrada en clave de sol, con su cifrado americano encima si
    /// `cifrados`, y el bajo en clave de fa, con el cifrado romano y la función debajo si `analisis`, y la tonalidad
    /// al principio. La armadura es la de la tonalidad del análisis; la parte se llama «Piano» si el encabezado no
    /// le da nombre. En MIDI, cada acorde lleva un marcador con sus dos cifrados («Re7 · V7/V»), que los
    /// secuenciadores muestran al sonar.
    ///
    ///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
    ///     let xml = analisis.partitura(encabezado: Encabezado(titulo: "Progresión")).musicXML()
    ///
    /// Detiene el programa si `duracion` no es positiva, como `Duracion(_:_:)` con un denominador 0. Con lo que
    /// dura cada acorde (el ritmo de una pieza importada), `RitmoArmonico.partitura(en:…)`.
    public func partitura(
        duracion: Duracion = .negra, compas: Compas = .compasillo, encabezado: Encabezado = Encabezado(),
        conCifrados: Bool = true, conAnalisis: Bool = true, notacion: Notacion = .espanolCompacto
    ) -> Partitura {
        precondition(duracion > .cero, "cada acorde tiene que durar algo")
        return conDuraciones(
            Array(repeating: duracion, count: acordes.count), compas: compas, encabezado: encabezado,
            conCifrados: conCifrados, conAnalisis: conAnalisis, notacion: notacion)
    }

    /// La partitura, con una duración positiva por acorde.
    fileprivate func conDuraciones(
        _ duraciones: [Duracion], compas: Compas, encabezado: Encabezado, conCifrados: Bool,
        conAnalisis: Bool,
        notacion: Notacion
    ) -> Partitura {
        let (superior, grave) = Exportacion.progresion(
            acordes.map(\.acorde), duraciones: Exportacion.hastaLaBarra(duraciones, compas))
        let anotado = Exportacion.anotaciones(
            de: self, duraciones: duraciones, cifrados: conCifrados, analisis: conAnalisis)
        var marcadores: [Duracion: String] = [:]
        for (inicio, analizado) in zip(Exportacion.inicios(duraciones), acordes) {
            marcadores[inicio] = analizado.acorde.cifrado(en: notacion) + " · " + analizado.cifrado
        }
        var cabecera = encabezado
        cabecera.tonalidad = tonalidad
        cabecera.nombreDeLaParte = encabezado.nombreDeLaParte ?? "Piano"
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

extension RitmoArmonico {
    /// La progresión con su ritmo en dos pentagramas, analizada en `tonalidad` o, si no se da, en la que mejor la
    /// explica: como `AnalisisArmonico.partitura(duracion:…)`, con lo que dura cada acorde (el último, alargado
    /// hasta la barra), en el compás del ritmo y, si el encabezado no da otro, a su tempo.
    ///
    ///     let ritmo = RitmoArmonico([AcordeConDuracion("Do", .blanca), AcordeConDuracion("Sol7", .negra)])
    ///     let datos = ritmo.partitura(encabezado: Encabezado(titulo: "Cadencia")).midi()
    public func partitura(
        en tonalidad: Tonalidad? = nil, encabezado: Encabezado = Encabezado(), conCifrados: Bool = true,
        conAnalisis: Bool = true, notacion: Notacion = .espanolCompacto
    ) -> Partitura {
        let acordes = self.acordes.map(\.acorde)
        // Sin acordes no hay tonalidad que los explique: el análisis, vacío, en Do mayor.
        let suTonalidad = tonalidad ?? AnalisisArmonico.analizar(acordes)?.tonalidad ?? Tonalidad(.do)
        let analizado = suTonalidad.analizar(acordes)
        var cabecera = encabezado
        cabecera.tempo = encabezado.tempo ?? tempo
        return analizado.conDuraciones(
            duraciones, compas: compas, encabezado: cabecera, conCifrados: conCifrados,
            conAnalisis: conAnalisis,
            notacion: notacion)
    }
}

extension Contrapunto {
    /// El contrapunto en dos pentagramas, cada voz en el suyo (la de arriba encima) con su nombre latino
    /// («Cantus firmus» y «Contrapunctus», como en el Gradus ad Parnassum de Fux) y la clave que necesite menos
    /// líneas adicionales. La parte se llama como las dos voces («Cantus firmus · Contrapunctus»). Si el encabezado
    /// no da tonalidad, ninguna, como en los ejemplos modales de Fux; si no da instrumento, el coro (52).
    ///
    ///     let ejercicio = try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "La4 La4 Sol4 Fa4",
    ///                                     especie: .primera)
    ///     let xml = ejercicio.partitura(encabezado: Encabezado(titulo: "Primera especie")).musicXML()
    public func partitura(encabezado: Encabezado = Encabezado()) -> Partitura {
        let lineas = vocesDeArribaAbajo
        var cabecera = encabezado
        cabecera.nombreDeLaParte = lineas.map(\.nombre).joined(separator: " · ")
        cabecera.instrumento = encabezado.instrumento ?? 52
        return Partitura(
            pentagramas: lineas.map { Partitura.Pentagrama(voces: [Partitura.Linea($0.voz, nombre: $0.nombre)]) },
            encabezado: cabecera, compas: contrapunto.compas, anacrusa: .cero)
    }
}
