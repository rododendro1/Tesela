import Elementos
import Partituras
import Teoria

// Proponer un contrapunto de primera especie sobre un cantus firmus: una búsqueda en haz por las notas consonantes
// de cada compás, con las reglas de `Contrapunto.faltas` como poda y un coste que prefiere lo que pide Fux (grados
// conjuntos, movimiento contrario, consonancias imperfectas en medio). Lo que sale se comprueba con
// `Contrapunto.faltas`: solo se proponen los que no tienen ninguna.

extension Contrapunto {
    /// Contrapuntos de primera especie (nota contra nota) sobre `cantusFirmus`, sin faltas, del que mejor sigue las
    /// reglas al que peor, como mucho `propuestas`; vacío si no hay ninguno.
    ///
    /// Las notas son las del modo del cantus: las de sus letras con sus alteraciones (las letras que no tiene, sin
    /// alterar), y en el penúltimo compás también la sensible, un semitono debajo de la final. El contrapunto va
    /// encima del cantus o, con `arriba` en falso, debajo, a no más de una duodécima.
    ///
    ///     let propuesta = try Contrapunto.proponer(sobre: "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4").first
    ///     propuesta?.esCorrecto   // true
    /// Lee el cantus como `Contrapunto(cantusFirmus:contrapunto:especie:)`.
    public static func proponer(sobre cantusFirmus: String, arriba: Bool = true, propuestas: Int = 1) throws
        -> [Contrapunto]
    {
        proponer(sobre: try cantus(leyendo: cantusFirmus), arriba: arriba, propuestas: propuestas)
    }

    /// Las de `proponer(sobre:arriba:propuestas:)` con el cantus ya leído.
    public static func proponer(sobre cantusFirmus: [Altura], arriba: Bool = true, propuestas: Int = 1)
        -> [Contrapunto]
    {
        guard !cantusFirmus.isEmpty, propuestas > 0 else { return [] }
        let ultimo = cantusFirmus.count - 1
        // Las alteraciones del modo: las de las letras del cantus.
        var alteraciones: [NotaNatural: Alteracion] = [:]
        for altura in cantusFirmus where alteraciones[altura.nota.natural] == nil {
            alteraciones[altura.nota.natural] = altura.nota.alteracion
        }
        func candidatas(_ compas: Int) -> [Altura] {
            let cantus = cantusFirmus[compas]
            var notas: [Altura] = []
            // Del unísono a la duodécima, en grados del modo.
            for grados in 0...11 {
                let pasos = cantus.pasos + (arriba ? grados : -grados)
                let natural = NotaNatural(rawValue: modulo(pasos, 7))!
                let nota = Nota(natural, alteraciones[natural] ?? .natural)
                let altura = Altura(nota, octava: 4 + divisionEntera(pasos, 7))
                notas.append(altura)
                // La sensible, en el penúltimo compás.
                if compas == ultimo - 1 {
                    let alzada = Altura(Nota(natural, nota.alteracion + .sostenido), octava: altura.octava)
                    if modulo(cantusFirmus[ultimo].midi - alzada.midi, 12) == 1 { notas.append(alzada) }
                }
            }
            return notas.filter { nota in
                let intervalo = Conduccion.intervalo(cantus, nota)
                guard !Contrapunto.esDisonancia(intervalo) else { return false }
                let perfecta = Conduccion.perfecta(intervalo)
                if compas == 0 { return perfecta == 8 || (arriba && perfecta == 5) }
                if compas == ultimo { return perfecta == 8 }
                // En medio, ni unísonos ni cruces.
                return !(intervalo.numero == 1) && (arriba ? nota.midi > cantus.midi : nota.midi < cantus.midi)
            }
        }

        // La búsqueda en haz: cada camino con su coste, y solo los mejores pasan al compás siguiente.
        typealias Camino = (notas: [Altura], coste: Double)
        let anchoDelHaz = 400
        var caminos: [Camino] = candidatas(0).map { ([$0], 0) }
        for compas in cantusFirmus.indices.dropFirst() {
            var siguientes: [Camino] = []
            for camino in caminos {
                for nota in candidatas(compas) {
                    guard let coste = costeDelPaso(camino.notas, nota, compas: compas, ultimo: ultimo, cantusFirmus)
                    else { continue }
                    siguientes.append((camino.notas + [nota], camino.coste + coste))
                }
            }
            caminos = Array(siguientes.sorted { $0.coste < $1.coste }.prefix(anchoDelHaz))
        }

        var resultado: [Contrapunto] = []
        for camino in caminos.sorted(by: { $0.coste < $1.coste }) where camino.notas.count == cantusFirmus.count {
            guard
                let propuesta = try? Contrapunto(
                    cantusFirmus: cantusFirmus, contrapunto: camino.notas.map { Evento($0, .redonda) },
                    especie: .primera),
                propuesta.faltas.isEmpty, !resultado.contains(propuesta)
            else { continue }
            resultado.append(propuesta)
            if resultado.count == propuestas { break }
        }
        return resultado
    }

    /// Lo que cuesta añadir `nota` a las de antes en el compás `compas`, o `nil` si rompe una regla: un salto no
    /// melódico, unas paralelas o unas directas, o un final sin grado conjunto.
    private static func costeDelPaso(
        _ antes: [Altura], _ nota: Altura, compas: Int, ultimo: Int, _ cantusFirmus: [Altura]
    ) -> Double? {
        let anterior = antes[antes.count - 1]
        let movimiento = nota.midi - anterior.midi
        let salto = anterior.intervalo(hasta: nota)
        guard !Conduccion.Saltos.contrapunto.noEsMelodico(salto, ascendente: movimiento > 0) else { return nil }
        let paso = Conduccion.PasoDeVoces(de: (cantusFirmus[compas - 1], anterior), a: (cantusFirmus[compas], nota))
        guard paso.paralelas == nil, paso.directas == nil else { return nil }
        if compas == ultimo, !Contrapunto.esGrado(anterior, nota) { return nil }
        // Después de un salto de más de una cuarta, hay que volver en sentido contrario.
        if antes.count >= 2 {
            let previo = antes[antes.count - 2]
            let saltoPrevio = anterior.midi - previo.midi
            if previo.intervalo(hasta: anterior).numero >= 5, saltoPrevio != 0,
                movimiento == 0 || (movimiento > 0) == (saltoPrevio > 0)
            {
                return nil
            }
        }
        var coste = 0.0
        // Mejor por grado conjunto; una tercera, algo; más, más.
        let distancia = abs(movimiento)
        if distancia == 0 {
            coste += 3
        } else if distancia > 2 {
            coste += distancia <= 4 ? 1 : Double(distancia) / 2
        }
        // Mejor el movimiento contrario.
        if paso.esDirecto { coste += 1 } else if paso.seMuevenLasDos { coste -= 0.5 }
        // En el penúltimo compás, la sensible: a la final se llega por semitono desde abajo, no por tono.
        if compas == ultimo - 1, modulo(cantusFirmus[ultimo].midi - nota.midi, 12) == 2 { coste += 2 }
        // En medio, mejor las consonancias imperfectas.
        if compas < ultimo, Conduccion.perfecta(Conduccion.intervalo(cantusFirmus[compas], nota)) != nil { coste += 1 }
        return coste
    }
}
