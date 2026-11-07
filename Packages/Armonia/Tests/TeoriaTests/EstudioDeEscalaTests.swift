import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Para estudiar una escala: secuencias, modos, comparaciones, bebop y pentatónicas, digitación de piano y cambios.
@Suite struct EstudioDeEscalaTests {
    @Test func secuencias() {
        let terceras = Escala(.do).secuencia(.terceras)
        #expect(terceras.count == 15)
        #expect(Array(terceras.prefix(4).map(\.midi)) == [60, 64, 62, 65])
        #expect(terceras.last?.midi == 72)
        let bajando = Escala(.do).secuencia(.terceras, sentido: .descendente)
        #expect(Array(bajando.prefix(4).map(\.midi)) == [72, 69, 71, 67])
        #expect(bajando.last?.midi == 60)
        for secuencia in SecuenciaDeEscala.allCases {
            #expect(Escala(.do).secuencia(secuencia).count == 7 * secuencia.pasos.count + 1)
        }
        let dosOctavas = Escala(.do).secuencia(.cuatriadas, octavas: 2)
        #expect(dosOctavas.count == 57)
        #expect(dosOctavas.last?.midi == 84)
        // La menor melódica sube con Sol♯ y baja con Sol.
        let melodica = Escala(.la, .menorMelodica)
        #expect(melodica.secuencia(.gruposDeTres).map(\.midi).contains(80))
        let bajada = melodica.secuencia(.gruposDeTres, sentido: .descendente).map(\.midi)
        #expect(!bajada.contains(80) && !bajada.contains(68))
        let dos = TipoDeEscala(nombre: "dos notas", intervalos: [.unisono, .quintaJusta])
        #expect(Escala(.do, dos).secuencia(.terceras).isEmpty)
    }

    @Test func nombresDeLasSecuencias() {
        #expect(SecuenciaDeEscala.terceras.nombre == "por terceras")
        #expect("\(SecuenciaDeEscala.gruposDeTres)" == "en grupos de tres")
        #expect(SecuenciaDeEscala.cuatriadas.nombre(en: .inglesASCII) == "in seventh chords")
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let nombres = SecuenciaDeEscala.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }

    @Test func modos() {
        #expect(Escala(.do, .lidio).brillo == 1)
        #expect(Escala(.do).brillo == 0)
        #expect(Escala(.do, .locrio).brillo == -5)
        #expect(Escala(.do, .pentatonicaMayor).brillo == nil)
        #expect(Escala(.re, .dorico).modosParalelos.map(\.brillo) == [1, 0, -1, -2, -3, -4, -5])
        #expect(Escala(.re, .dorico).modosParalelos.allSatisfy { $0.tonica == .re })
        let relativos = Escala(.do).modosRelativos
        #expect(relativos.count == 7)
        #expect(relativos[1] == Escala(.re, .dorico))
    }

    @Test func compararDosEscalas() {
        let lidio = Escala(.do).comparar(con: Escala(.do, .lidio))
        #expect(lidio.cambios.map(\.grado) == [4])
        #expect(lidio.cambios.map(\.desde.nombre) == ["Fa"])
        #expect(lidio.cambios.map(\.hasta.nombre) == ["Fa♯"])
        #expect(lidio.comunes.count == 6)
        #expect(lidio.soloEnOrigen.map(\.nombre) == ["Fa"])
        #expect(lidio.soloEnDestino.map(\.nombre) == ["Fa♯"])
        #expect(lidio.distanciaEnQuintas == 1)
        let sol = Escala(.do).comparar(con: Escala(.sol))
        #expect(sol.cambios.isEmpty)
        #expect(sol.soloEnDestino.map(\.nombre) == ["Fa♯"])
        let pentatonica = Escala(.do).comparar(con: Escala(.do, .pentatonicaMayor))
        #expect(pentatonica.cambios.isEmpty)
        #expect(pentatonica.distanciaEnQuintas == nil)
        #expect(pentatonica.soloEnOrigen.map(\.nombre) == ["Fa", "Si"])
    }

    @Test func cambiosYNotasGuia() {
        #expect(Escala(.re, .dorico).cambios(desde: Escala(.do)).isEmpty)
        #expect(Escala(.la, .frigioDominante).cambios(desde: Escala(.do)).map(\.nombre) == ["Si♭", "Do♯"])
        #expect(Acorde("Dosus4").notasGuia.map(\.nombre) == ["Fa", "Sol"])
    }

    @Test func bebop() throws {
        let do7 = Acorde("Do7").escalasBebop
        #expect(do7.map(\.escala.tipo) == [.bebopDominante])
        let dominante = try #require(do7.first)
        #expect(dominante.notaDePaso.nombre == "Si")
        #expect(dominante.recorrido.map(\.nombre) == ["Do", "Si", "Si♭", "La", "Sol", "Fa", "Mi", "Re"])
        let do7M = Acorde("Do7M").escalasBebop
        #expect(do7M.map(\.escala.tipo) == [.bebopMayor])
        #expect(do7M.first?.notaDePaso.nombre == "Sol♯")
        #expect(Acorde("Dom6").escalasBebop.contains { $0.escala.tipo == .bebopMenorMelodica })
    }

    @Test func pentatonicas() throws {
        let sobreDo7M = Acorde("Do7M").pentatonicas
        let primera = try #require(sobreDo7M.first)
        #expect(primera.escala == Escala(.do, .pentatonicaMayor))
        #expect(primera.tensiones == ["9", "13"])
        #expect(sobreDo7M.contains { $0.escala == Escala(.re, .pentatonicaMayor) })
        // Sin la tercera del acorde (Fa pentatónica no tiene Mi) o con notas a evitar (el Fa), no vale.
        #expect(!sobreDo7M.contains { $0.escala == Escala(.fa, .pentatonicaMayor) })
        let tensiones = sobreDo7M.map(\.tensiones.count)
        #expect(tensiones == tensiones.sorted())
        // Sin tercera, cualquiera sin notas a evitar.
        #expect(!Acorde("Dosus4").pentatonicas.isEmpty)
    }

    @Test func digitacionDePiano() {
        #expect(Escala(.do).digitacionDePiano(.derecha).dedos == [1, 2, 3, 1, 2, 3, 4, 5])
        #expect(Escala(.fa).digitacionDePiano(.derecha).dedos == [1, 2, 3, 4, 1, 2, 3, 4])
        #expect(Escala(.do).digitacionDePiano(.izquierda).dedos == [5, 4, 3, 2, 1, 3, 2, 1])
        let dosOctavas = Escala(.re).digitacionDePiano(.derecha, octavas: 2)
        #expect(dosOctavas.alturas.count == 15)
        #expect(dosOctavas.dedos.count == 15)
        #expect(dosOctavas.dedos.last == 5)
        #expect(dosOctavas.mano == .derecha)
        // El pulgar no cae en las teclas negras de Re mayor (Fa♯ y Do♯).
        let negras = zip(dosOctavas.alturas, dosOctavas.dedos).filter { [1, 6].contains($0.0.midi % 12) }
        #expect(negras.allSatisfy { $0.1 != 1 })
    }
}
