// Lo que pesa cada cosa al armonizar una melodía: los costes que suman ``Tonalidad/armonizar(melodia:propuestas:)``
// y ``Tonalidad/armonizarACuatroVoces(melodia:)``. Cuanto más cuesta, menos se elige; 0 es lo natural.

/// Los costes de la armonización, juntos y con nombre: los de cada acorde, los de empezar, los de cada paso de un
/// acorde al siguiente según sus funciones y los de terminar.
package struct PesosDeArmonizacion: Sendable {
    // MARK: Acordes

    /// Las tríadas de los siete grados en mayor: el I, el IV y el V no cuestan; el iii, casi lo que una dominante
    /// secundaria.
    package var gradosEnMayor: [Double] = [0, 0.2, 0.9, 0, 0, 0.3, 0.8]
    /// Las de los siete grados en menor (con la dominante mayor).
    package var gradosEnMenor: [Double] = [0, 0.5, 0.6, 0, 0, 0.3, 0.8]
    /// El V7.
    package var septimaDeDominante = 0.15
    /// El ii6, en mayor.
    package var iiEnPrimeraInversion = 0.25
    /// La dominante secundaria del V (V/V y V7/V).
    package var secundariaDelV = 0.6
    /// Las demás dominantes secundarias.
    package var otraSecundaria = 0.8
    /// Las séptimas disminuidas de nota común del I y del V.
    package var disminuidaDeNotaComun = 1.0
    /// Lo que se añade a un acorde del modo homónimo, cuando ninguno de la tonalidad tiene la nota.
    package var delModoHomonimo = 1.0

    // MARK: La nota en el acorde

    /// Que la nota de la melodía sea la fundamental del acorde.
    package var notaFundamental = 0.0
    /// Que sea la quinta.
    package var notaQuinta = 0.15
    /// Que sea la tercera.
    package var notaTercera = 0.25
    /// Que sea otra (la séptima).
    package var otraNota = 0.3

    // MARK: Empezar

    /// Empezar en el I.
    package var inicioEnLaTonica = 0.0
    /// Empezar en el V.
    package var inicioEnLaDominante = 0.5
    /// Empezar en otro acorde.
    package var otroInicio = 1.0

    // MARK: Pasos

    /// Una séptima de la melodía que no baja por grado conjunto.
    package var septimaDeLaMelodiaSinResolver = 2.0
    /// Una dominante secundaria (o una disminuida de nota común) que no va a su destino.
    package var sinIrASuDestino = 5.0
    /// Repetir el acorde.
    package var mismoAcorde = 0.6
    /// Otra disposición de las mismas notas (otra inversión).
    package var mismasNotas = 0.3
    /// De un acorde con séptima a la tríada de su fundamental: la séptima se queda sin resolver (V7 → V).
    package var septimaQueNoResuelve = 1.0
    /// De la dominante al I: la cadencia.
    package var dominanteAlI = 0.0
    /// De la dominante al vi: la cadencia rota.
    package var cadenciaRota = 0.5
    /// De la dominante a otra tónica (el iii).
    package var dominanteAOtraTonica = 1.2
    /// De la dominante a la subdominante: la retrogresión.
    package var retrogresion = 2.0
    /// Del V a sí mismo con otra forma (V → V7).
    package var delVAlV = 0.1
    /// De una dominante a otra.
    package var dominanteADominante = 0.6
    /// De la subdominante a la dominante.
    package var subdominanteADominante = 0.0
    /// Del IV al ii.
    package var delIVAlII = 0.2
    /// De una subdominante a otra.
    package var subdominanteASubdominante = 0.8
    /// Del IV al I: la cadencia plagal.
    package var plagal = 0.6
    /// De la subdominante a otra tónica.
    package var subdominanteAOtraTonica = 0.9
    /// Del I al vi.
    package var delIAlVI = 0.1
    /// Del I a otra tónica.
    package var delIAOtraTonica = 0.3
    /// Del iii al vi.
    package var delIIIAlVI = 0.2
    /// De una tónica a otra.
    package var tonicaATonica = 0.8
    /// Cualquier otro paso.
    package var otroPaso = 0.1

    // MARK: Terminar

    /// Una cadencia auténtica: de la dominante al I en estado fundamental.
    package var cadenciaAutentica = 0.0
    /// Terminar en el I en estado fundamental sin venir de la dominante.
    package var finalEnElISinDominante = 1.0
    /// Terminar en el V (una semicadencia) cuando la última nota es del I.
    package var semicadenciaPudiendoIrAlI = 2.0
    /// Terminar en el V cuando la última nota no es del I.
    package var semicadencia = 0.5
    /// Terminar en una dominante secundaria, que no llega a su destino.
    package var finalSinDestino = 5.0
    /// Terminar en cualquier otro acorde.
    package var otroFinal = 4.0

    // MARK: Las voces

    /// Lo que pesa un semitono de movimiento de las voces frente a la armonía, en el coral a cuatro voces.
    package var pesoDeLasVoces = 0.15

    /// Los de siempre.
    package static let habituales = PesosDeArmonizacion()

    /// El coste de las tríadas de un grado (1…7) en un modo.
    package func grado(_ grado: Int, enMayor: Bool) -> Double {
        (enMayor ? gradosEnMayor : gradosEnMenor)[grado - 1]
    }
}
