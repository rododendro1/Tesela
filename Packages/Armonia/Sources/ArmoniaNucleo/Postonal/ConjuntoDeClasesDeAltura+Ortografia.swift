// La escritura más sencilla de un conjunto de clases de altura.
//
// Un conjunto no tiene ortografía: {0, 3, 7} puede ser Do–Mi♭–Sol o Si♯–Re♯–Fa𝄪. Para escribirlo se busca el
// tramo más corto de la línea de quintas que tiene una nota de cada clase. En siete quintas seguidas no se repite
// letra, así que los conjuntos que caben en ellas (las escalas diatónicas y todo lo que hay dentro) salen con letras
// distintas, y con terceras y quintas donde las tienen. Si hay varios tramos igual de cortos, el de menos alteraciones;
// después, el más cerca de Re (el centro de las notas naturales, Fa–Do–Sol–Re–La–Mi–Si); y al final, el de bemoles.
// Sin una nota fija, solo se usan notas con un sostenido o un bemol como mucho.

extension ConjuntoDeClasesDeAltura {
    /// Las notas del conjunto con la escritura más sencilla, en el orden de `clases`:
    ///
    ///     ConjuntoDeClasesDeAltura([0, 3, 7]).notas()           // [Do, Mi♭, Sol]
    ///     ConjuntoDeClasesDeAltura([0, 1]).notas()              // [Do, Re♭]
    ///     ConjuntoDeClasesDeAltura([2, 6, 9]).notas()           // [Re, Fa♯, La]
    ///     ConjuntoDeClasesDeAltura([1, 5, 8]).notas()           // [Re♭, Fa, La♭]
    ///
    /// Con `fija`, esa nota se escribe así y las demás alrededor de ella: con Do♯, {1, 5, 8} es Do♯–Mi♯–Sol♯.
    /// Si la clase de `fija` no está en el conjunto, se añade a la búsqueda pero no al resultado.
    public func notas(con fija: Nota? = nil) -> [Nota] {
        guard !clases.isEmpty else { return [] }
        // Cada tramo de doce quintas seguidas tiene una nota de cada clase. Los que van de Fa♭ (−8) a Si♯ (12) dan
        // notas con un sostenido o un bemol como mucho; con `fija`, se usan los que la contienen.
        let desdeFija = fija.map { ($0.pasosDeQuinta - 11)...$0.pasosDeQuinta }
        let inicios = desdeFija.map { Array($0) } ?? Array(-8...1)
        let clasesDeLaBusqueda = fija.map { clases + [$0.claseDeAltura] } ?? clases

        func escritura(desde inicio: Int) -> [Int] {
            // La única quinta del tramo [inicio, inicio + 11] de cada clase.
            clases.map { clase in inicio + modulo(clase * 7 - inicio, 12) }
        }
        func coste(_ inicio: Int) -> (Int, Int, Int, Int) {
            let quintas = clasesDeLaBusqueda.map { clase in inicio + modulo(clase * 7 - inicio, 12) }
            let (menor, mayor) = (quintas.min() ?? 0, quintas.max() ?? 0)
            let alteraciones = quintas.map { abs(Nota(pasosDeQuinta: $0).alteracion.semitonos) }.reduce(0, +)
            let distanciaARe = quintas.map { abs($0 - 2) }.reduce(0, +)
            let sostenidos = quintas.filter { $0 > 5 }.count
            return (mayor - menor, alteraciones, distanciaARe, sostenidos)
        }
        let mejor = inicios.min { coste($0) < coste($1) } ?? 0
        return escritura(desde: mejor).map(Nota.init(pasosDeQuinta:))
    }
}

extension ConjuntoDeClasesDeAltura {
    /// El nombre de cada clase de altura, de 0 (Do) a 11 (Si), escritas todas a la vez con `notas(con:)` para que no
    /// se repita ninguna letra: la escritura con que se nombran las clases de una serie o de una matriz.
    public static func nombresDeLasClases(en notacion: Notacion) -> [String] {
        let total = ConjuntoDeClasesDeAltura(0..<12)
        let notas = Dictionary(uniqueKeysWithValues: zip(total.clases, total.notas()))
        return (0..<12).map { notas[$0]?.nombre(en: notacion) ?? String($0) }
    }
}
