import Elementos
import Testing

@testable import Teoria

/// Lo que tienen en común los siete catálogos con nombre (`ElementoConNombre`), probado una vez para todos.
@Suite struct ElementoConNombreTests {
    /// Cada elemento de cada catálogo se encuentra por su nombre, sus alias y sus variantes en los trece idiomas, y
    /// `nombres(en:)` los da en orden.
    @Test func cadaCatalogoSeBuscaPorSusNombres() {
        comprobarBusqueda(TipoDeEscala.self)
        comprobarBusqueda(AcordeConNombre.self)
        comprobarBusqueda(ProgresionConNombre.self)
        comprobarBusqueda(RitmoConNombre.self)
        comprobarBusqueda(TemperamentoConNombre.self)
        comprobarBusqueda(NotaConNombre.self)
        comprobarBusqueda(FuncionDeNota.self)
    }

    private func comprobarBusqueda<Elemento: ElementoConNombre>(_: Elemento.Type) {
        #expect(!Elemento.catalogo.isEmpty)
        #expect(Elemento.buscar(conteniendo: "") == Elemento.catalogo)
        #expect(Elemento.buscar(nombre: "no es el nombre de nada") == nil)
        // Buscar por un texto recorre todo el catálogo en los trece idiomas: basta con unos pocos.
        for elemento in Elemento.catalogo.prefix(5) {
            #expect(Elemento.buscar(conteniendo: elemento.nombre).contains(elemento), "\(elemento)")
        }
        for elemento in Elemento.catalogo {
            let espanol = elemento.nombres(en: .compacta(.espanol))
            #expect(espanol == [elemento.nombre] + elemento.alias + elemento.variantes, "\(elemento)")
            #expect(elemento.description == elemento.nombre)
            if let documentada = elemento.documentada {
                #expect(elemento.referencias.first == documentada, "\(elemento)")
            }
            if let anio = elemento.anioDeOrigen { #expect(elemento.epocaDeOrigen == Epoca(anio: anio), "\(elemento)") }
        }
    }

    /// `TipoDeEscala.buscar(nombre:)` lee los trece idiomas, y no solo el español y el inglés como `init(leyendo:)`.
    @Test func lasEscalasSeBuscanEnLosTreceIdiomas() {
        #expect(TipoDeEscala.buscar(nombre: "dórico") == .dorico)
        #expect(TipoDeEscala.buscar(nombre: "Dorian") == .dorico)
        #expect(TipoDeEscala.buscar(nombre: "dorisch") == .dorico)
        #expect(TipoDeEscala.buscar(nombre: "doble armonica") == .dobleArmonica)
        #expect(throws: (any Error).self) { try TipoDeEscala(leyendo: "dorisch") }
        for idioma in Idioma.allCases {
            let notacion = Notacion.compacta(.espanol).conTextos(en: idioma)
            for tipo in TipoDeEscala.occidentales {
                let nombre = tipo.nombre(en: notacion)
                #expect(TipoDeEscala.buscar(nombre: nombre) != nil, "\(nombre) en \(idioma)")
            }
        }
        let bebop = TipoDeEscala.buscar(conteniendo: "bebop")
        #expect(bebop.contains(.bebopDominante) && bebop.contains(.bebopMenorArmonica))
        #expect(!bebop.contains(.mayor))
    }

    /// La fecha de los ritmos, los temperamentos y las notas sale de su año.
    @Test func laFechaDeLosOtrosCatalogos() {
        #expect(TemperamentoConNombre.werckmeisterIII.anioDeOrigen == 1691)
        #expect(TemperamentoConNombre.werckmeisterIII.epocaDeOrigen == .barroco)
        #expect(TemperamentoConNombre.mesotonicoCuartoDeComa.epocaDeOrigen == .renacimiento)
        #expect(TemperamentoConNombre.pitagorico.epocaDeOrigen == nil)
        #expect(NotaConNombre.la440.epocaDeOrigen == .sigloXX)
        #expect(RitmoConNombre.primerModoRitmico.epocaDeOrigen == .edadMedia)
        #expect(RitmoConNombre.charleston.anioDeOrigen == 1923)
        #expect(RitmoConNombre.bossaNova.epocaDeOrigen == .sigloXX)
        #expect(RitmoConNombre.tresillo.epocaDeOrigen == nil)
        #expect(FuncionDeNota.dominante.documentada == nil && FuncionDeNota.dominante.epocaDeOrigen == nil)
        let propio = RitmoConNombre(
            nombre: "mío", patron: "x.x.", familia: .lineaDeTiempo, documentada: .toussaint2013, anio: 1500)
        #expect(propio.referencias == [.toussaint2013])
        #expect(propio.anioDeOrigen == Referencia.toussaint2013.anio)
    }

    /// La afinación propia de una escala no siempre es microtonal: la de Kalyāṇ es justa.
    @Test func laAfinacionPropiaNoSiempreEsMicrotonal() {
        #expect(TipoDeEscala.kalyan.afinacionPropia != nil && !TipoDeEscala.kalyan.esMicrotonal)
        #expect(TipoDeEscala.bayati.afinacionPropia != nil && TipoDeEscala.bayati.esMicrotonal)
        #expect(TipoDeEscala.mayor.afinacionPropia == nil && !TipoDeEscala.mayor.esMicrotonal)
    }
}
