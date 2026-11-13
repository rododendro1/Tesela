import Testing

@testable import Teoria

/// Sin optimizar, cada fila de las listas de nombres de cada idioma (`Nombres/`) construye en la pila su
/// `TipoDeEscala` y su `NombresDeEscalas.Fila`, y las listas del ruso y el griego tienen unas 490 filas. Con la ficha
/// dentro del tipo (unos 330 bytes), su inicialización llegó a ocupar casi 500 KB y desbordó la pila de un hilo
/// secundario de macOS (512 KB) con la cobertura activada. Si un campo nuevo hace crecer el tipo, que avise aquí y no
/// con una señal 11: lo que sea grande o se use poco va en la ficha, que se guarda aparte.
struct TamanoDeLasEscalasTests {
    @Test func unaEscalaOcupaPoco() {
        #expect(MemoryLayout<TipoDeEscala>.size <= 64)
        #expect(MemoryLayout<NombresDeEscalas.Fila>.size <= 160)
    }

    /// La ficha se comparte entre las copias y no se pierde: el dórico copiado sigue teniendo sus estilos.
    @Test func laFichaSeComparte() {
        let copia = TipoDeEscala.dorico
        #expect(copia.datos.estilos == TipoDeEscala.dorico.datos.estilos)
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).datos.estilos.isEmpty)
    }
}
