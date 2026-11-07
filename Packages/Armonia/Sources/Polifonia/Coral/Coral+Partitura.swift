import Elementos
import Partituras
import Teoria

// La partitura de un coral: sus voces en dos pentagramas, con los cifrados encima y el análisis debajo. De ella sale
// cualquier formato (`coral.partitura(duracion: .blanca).midi()`, con Formatos).

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
        let anotado = Coral.anotaciones(
            de: self, duracion: duracion, tonalidad: encabezado.tonalidad, cifrados: conCifrados,
            analisis: conAnalisis)
        var cabecera = encabezado
        cabecera.tonalidad = anotado.tonalidad
        cabecera.nombreDeLaParte = encabezado.nombreDeLaParte ?? "Coro"
        cabecera.instrumento = encabezado.instrumento ?? 52
        var pentagramas = [Partitura.Pentagrama(clave: .sol, voces: []), Partitura.Pentagrama(clave: .fa, voces: [])]
        let n = numeroDeVoces
        for linea in Coral.voces(de: self, duracion: duracion, compas: compas) {
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

extension Coral {
    /// Las voces de un coral repartidas en dos pentagramas, como se escriben: las de la mitad
    /// aguda arriba y las de la grave abajo, de aguda a grave en cada uno. Si comparten
    /// pentagrama, la plica de la de arriba va hacia arriba y la de la de abajo, hacia abajo.
    /// `indice` es el de la voz en el coral (0, el bajo), y el último acorde se alarga hasta la barra.
    fileprivate static func voces(de coral: Coral, duracion: Duracion, compas: Compas)
        -> [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)]
    {
        let n = coral.numeroDeVoces
        let agudas = Array((n / 2..<n).reversed())
        let graves = Array((0..<n / 2).reversed())
        let final = compas.hastaLaBarra(duracion, coral.acordes.count)
        var voces: [(voz: Voz, pentagrama: Int, plicaArriba: Bool?, indice: Int)] = []
        for (pentagrama, indices) in [(1, agudas), (2, graves)] {
            for (k, v) in indices.enumerated() {
                let linea = Voz(
                    coral.voz(v).enumerated().map { Evento($1, $0 == coral.acordes.count - 1 ? final : duracion) },
                    compas: compas)
                voces.append((linea, pentagrama, indices.count == 1 ? nil : k == 0, v))
            }
        }
        return voces
    }

    /// Las anotaciones de un coral. Los acordes se identifican por sus notas (con el bajo) entre
    /// los tipos de `TipoDeAcorde.todos`; los que no forman ninguno se quedan sin cifrar. Sin
    /// `tonalidad`, se estima: a partir de los acordes si se analiza, si no, de las notas.
    fileprivate static func anotaciones(
        de coral: Coral, duracion: Duracion, tonalidad: Tonalidad?,
        cifrados: Bool, analisis: Bool
    ) -> AnotacionesDeAcordes {
        // Los acordes que se pueden identificar, con su posición en el coral.
        var identificados: [(indice: Int, acorde: Acorde)] = []
        if cifrados || analisis {
            for (i, alturas) in coral.acordes.enumerated() {
                // Solo los tipos del catálogo: un acorde con notas de paso no se cifra como «add♭9».
                if let acorde = Acorde.candidatos(alturas: alturas).first(where: {
                    TipoDeAcorde.todos.contains($0.valor.tipo)
                })?
                .valor {
                    identificados.append((i, acorde))
                }
            }
        }
        let analizado: AnalisisArmonico? =
            analisis
            ? (tonalidad.map { $0.analizar(identificados.map(\.acorde)) }
                ?? AnalisisArmonico.analizar(identificados.map(\.acorde)))
            : nil
        var resultado = AnotacionesDeAcordes()
        resultado.tonalidad =
            tonalidad ?? analizado?.tonalidad ?? Tonalidad.identificar(alturas: coral.acordes.flatMap { $0 }).first
        resultado.tonalidadDelAnalisis = analizado?.tonalidad
        for (k, (i, acorde)) in identificados.enumerated() {
            if cifrados { resultado.cifrados[duracion * i] = acorde }
            if let analizado, k < analizado.acordes.count { resultado.analisis[duracion * i] = analizado.acordes[k] }
        }
        return resultado
    }
}
