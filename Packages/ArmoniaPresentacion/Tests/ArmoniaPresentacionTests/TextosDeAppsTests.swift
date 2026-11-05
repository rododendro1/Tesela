import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// Los textos de la interfaz de las apps.

@Suite struct TextosDeAppsTests {
    /// Una muestra de cada texto.
    static let todos: [@Sendable (Notacion) -> String] = [
        { $0.texto(\.acordes) },
        { $0.texto(\.escalas) },
        { $0.texto(\.analisis) },
        { $0.texto(\.coral) },
        { $0.texto(\.acorde) },
        { $0.campo(.cifrado) },
        { $0.texto(\.informacion) },
        { $0.texto(\.nombre) },
        { $0.texto(\.cifrado) },
        { $0.texto(\.notas) },
        { $0.texto(\.digitaciones) },
        { $0.texto(\.instrumentoYAfinacion) },
        { $0.texto(\.sinDigitaciones) },
        { $0.texto(\.calculando) },
        { $0.texto { $0.dedosYCejilla(1, nil) } },
        { $0.texto { $0.dedosYCejilla(4, 3) } },
        { $0.texto(\.arpegio) },
        { $0.texto(\.patron) },
        { $0.texto(\.escalasCompatibles) },
        { $0.texto(\.arpegioEnElMastil) },
        { $0.texto { $0.trastes(5, 8) } },
        { $0.texto(\.identificar) },
        { $0.texto(\.tocaElMastil) },
        { $0.texto(\.tocaNotas) },
        { $0.texto(\.borrar) },
        { $0.texto(\.sinAcordeConocido) },
        { $0.texto(\.verEnAcordes) },
        { $0.texto(\.tecladoMIDI) },
        { $0.texto(\.dispositivosMIDI) },
        { $0.texto(\.teoriaPostonal) },
        { $0.texto(\.formaPrima) },
        { $0.texto(\.numeroDeForte) },
        { $0.texto(\.vectorIntervalico) },
        { $0.texto(\.escala) },
        { $0.texto(\.tonica) },
        { $0.texto(\.tipo) },
        { $0.texto(\.habituales) },
        { $0.texto(\.otrasTradiciones) },
        { $0.texto(\.acordesDeLaEscala) },
        { $0.texto(\.mastilDeGuitarra) },
        { $0.texto(\.posicionesEnElMastil) },
        { $0.texto { $0.notasPorCuerda(3) } },
        { $0.texto { $0.notasPorCuerda(1) } },
        { $0.texto { $0.forma("E") } },
        { $0.texto(\.pentagrama) },
        { $0.texto(\.progresion) },
        { $0.texto(\.campoDeProgresion) },
        { $0.texto(\.resultado) },
        { $0.texto(\.acordeAAcorde) },
        { $0.texto(\.cadencias) },
        { $0.texto(\.arpegiar) },
        { $0.texto(\.tarea) },
        { $0.texto(\.campoDeTonalidad) },
        { $0.texto(\.tonalidad) },
        { $0.texto(\.armonizaciones) },
        { $0.texto(\.aCuatroVoces) },
        { $0.texto(\.conduccionDeLasVoces) },
        { $0.texto(\.avisos) },
        { $0.texto(\.recorridoPLR) },
        { $0.texto(\.modo) },
        { $0.texto(\.red) },
        { $0.texto(\.formatoUIL) },
        { $0.texto(\.giro) },
        { $0.texto(\.espejo) },
        { $0.texto(\.ejesHV) },
        { $0.texto(\.rejilla) },
        { $0.texto(\.notaDeOrigen) },
        { $0.texto(\.enTono) },
        { $0.texto(\.noSeDibuja) },
        { $0.campo(.triadaInicial) },
        { $0.texto(\.reiniciar) },
        { $0.texto(\.deshacer) },
        { $0.campo(.acorde) },
        { $0.campo(.escala) },
        { $0.texto(\.textos) },
        { $0.texto(\.comoLasNotas) },
        { $0.texto(\.octavaEnSubindice) },
        { $0.texto(\.exportar) },
        { $0.texto(\.abrir) },
        { $0.texto(\.escuchar) },
        { $0.texto(\.afinacionAlEscuchar) },
        { $0.texto(\.rejillaHexagonal) },
        { $0.texto { $0.casillas(1) } },
        { $0.texto { $0.casillas(19) } },
        { $0.texto { $0.casillaElegida(q: 2, r: -1) } },
        { $0.texto { $0.mastilDe("guitarra", 0, 5) } },
        { $0.texto { $0.posicion(1, 3) } },
        { $0.texto { $0.marcas(13) } },
        { $0.texto { $0.cuerdasApagadas("1, 6") } },
        { $0.texto(\.sinMarcas) },
        { $0.texto(\.octavas) },
        { $0.texto(\.conLaOctavaFinal) },
        { $0.texto(\.figura) },
        { $0.texto(\.empezarEn) },
        { $0.texto(\.porGrados) },
        { $0.texto(\.aproximacion) },
        { $0.texto(\.tresillos) },
        { $0.texto(\.swing) },
        { $0.texto(\.enlazarLosAcordes) },
        { $0.texto(\.porPosiciones) },
        { $0.texto(\.dedosSugeridos) },
        { $0.texto { $0.tempo(72) } },
        { $0.texto { $0.capoEnElTraste(0) } },
        { $0.texto { $0.capoEnElTraste(2) } },
        { $0.texto(\.rearmonizar) },
        { $0.texto(\.aplicar) },
        { $0.texto(\.detener) },
        { $0.texto(\.transponer) },
        { $0.texto(\.contrapunto) },
        { $0.texto(\.especie) },
        { PresentacionDeContrapunto.indicacionDelCantus(en: $0) },
        { PresentacionDeContrapunto.indicacionDelContrapunto(en: $0) },
        { $0.texto { $0.compasNumero(3) } },
        { $0.texto(\.serieDodecafonica) },
        { $0.texto { $0.indicacionSerie("0 1 2", "Do Re♭") } },
        { $0.texto(\.formaDeSerie) },
        { $0.texto(\.matriz) },
        { $0.texto(\.intervalos) },
        { $0.texto(\.deTodosLosIntervalos) },
        { $0.texto(\.hexacordos) },
        { $0.texto(\.formasCombinatorias) },
        { $0.texto { $0.formasDistintas(24) } },
        { $0.texto(\.partitura) },
        { $0.texto(\.anterior) },
        { $0.texto(\.siguiente) },
        { $0.texto(\.abreUnaPartitura) },
        { $0.texto(\.disposicion) },
        { $0.texto(\.disposicionCerrada) },
        { $0.texto(\.fundamentalTerceraYSeptima) },
        { $0.texto(\.terceraYSeptima) },
        { $0.texto { $0.cuerdas("6-5-4-3") } },
        { $0.texto { $0.movimientoTotal(7) } },
        { $0.texto { $0.soloEn("Do mayor") } },
        { $0.texto { $0.alteracionesDeDiferencia(2) } },
        { $0.texto { $0.notaDePaso("Si") } },
        { $0.texto { $0.cambian("Fa♯") } },
        { $0.texto { $0.notasGuia("Mi, Si") } },
        { $0.texto(\.digitacionDePiano) },
        { $0.texto(\.otrosNombres) },
        { $0.texto(\.sustituciones) },
        { $0.texto(\.escalasQueLasContienen) },
        { $0.texto { $0.ademas("Fa, La") } },
        { $0.texto(\.simetria) },
        { $0.texto { $0.repiteCada(3, 3) } },
        { $0.texto(\.tonicasEquivalentes) },
        { $0.texto(\.lineasDeNotasGuia) },
        { $0.texto(\.desdeLaTercera) },
        { $0.texto(\.desdeLaSeptima) },
        { $0.texto(\.secuenciaEnLasPosiciones) },
        { $0.texto(\.formasDeLaPentatonica) },
        { $0.texto { $0.formaNumero(1) } },
        { $0.texto { $0.comparteCon(2, "6:8") } },
        { $0.texto(\.teclado) },
        { $0.texto(\.escalaPropia) },
        { $0.texto(\.campoDeEscalaPropia) },
        { $0.texto(\.pasosEnSemitonos) },
        { $0.texto(\.escalasVecinas) },
        { $0.texto(\.relojDeLaEscala) },
        { $0.texto(\.circuloCromatico) },
        { $0.texto(\.circuloDeQuintas) },
        { $0.texto(\.enLasDoceTonalidades) },
        { $0.texto(\.acordesEnLasDoceTonalidades) },
        { $0.texto(\.conSeptima) },
        { $0.texto(\.subirYBajar) },
    ]

    @Test func cadaTextoEstaEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            for (i, texto) in Self.todos.enumerated() {
                #expect(!(texto(notacion).isEmpty), "texto \(i) en \(idioma)")
            }
        }
        #expect(Notacion.inglesASCII.texto(\.digitaciones) == "Fingerings")
        #expect(Notacion.euskeraPalabras.texto(\.acordes) == "Akordeak")
        #expect(Notacion.alemanPalabras.texto(\.escalas) == "Skalen")
        #expect(Notacion.occitanoPalabras.texto(\.digitaciones) == "Digitacions")
        #expect(Notacion.rusoPalabras.texto { $0.dedosYCejilla(3, 5) } == "3 пальца, барре на 5-м ладу")
        #expect(Notacion.rusoPalabras.texto { $0.marcas(11) } == "11 отметок")
        #expect(Notacion.griegoPalabras.texto(\.acordes) == "Συγχορδίες")
    }

    /// Todos los textos caben en la pila de un hilo secundario de macOS (512 KB), también sin optimizar. Con un
    /// `TextosDeApps.traducidos.map` en cada caso del `switch` del antiguo `TextoDeLasApps`, cada caso guardaba en
    /// la pila su copia de los quince idiomas y el campo de acorde desbordaba la del hilo principal (señal 11).
    @Test func losTextosCabenEnLaPilaDeUnHiloSecundario() {
        let todos = Self.todos
        let hecho = DispatchSemaphore(value: 0)
        let hilo = Thread {
            for idioma in Idioma.allCases {
                let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
                for (i, texto) in todos.enumerated() {
                    #expect(!(texto(notacion).isEmpty), "texto \(i) en \(idioma)")
                }
            }
            hecho.signal()
        }
        hilo.stackSize = 512 * 1024
        hilo.start()
        #expect(hecho.wait(timeout: .now() + 60) == .success)
    }

    @Test func losEjemplosVanEnLaNotacion() {
        #expect(Notacion.espanolCompacto.campo(.cifrado) == "Cifrado, por ejemplo Sol7/Si")
        #expect(Notacion.inglesASCII.campo(.cifrado) == "Chord symbol, for example G7/B")
        #expect(Notacion.inglesASCII.campo(.triadaInicial) == "Starting triad (C, Am…)")
        #expect(
            PresentacionDeCoral.Tarea.armonizar.indicacion(en: .inglesASCII)
                == "Melody (E4 F4 D4 C4, without octaves or with rhythm: E4:4 D4:8)")
        #expect(
            PresentacionDeCoral.Tarea.revisar.indicacion(en: .espanolCompacto)
                == "Voces de grave a agudo (Do₃ Mi₄ Sol₄ Do₅, Sol₂ Re₄ Sol₄ Si₄)")
        #expect(PresentacionDeCoral.Tarea.realizar.indicacion(en: .inglesASCII) == "Chords (C F G7 C)")
    }

    @Test func elCapo() {
        #expect(Notacion.espanolCompacto.texto { $0.capoEnElTraste(0) } == "Sin capo")
        #expect(Notacion.espanolCompacto.texto { $0.capoEnElTraste(2) } == "Capo en el traste 2")
        #expect(Notacion.inglesASCII.texto { $0.capoEnElTraste(3) } == "Capo on fret 3")
    }

    @Test func losDedosYLaCejilla() {
        #expect(Notacion.espanolCompacto.texto { $0.dedosYCejilla(1, nil) } == "1 dedo")
        #expect(Notacion.espanolCompacto.texto { $0.dedosYCejilla(4, 1) } == "4 dedos, cejilla en el traste 1")
        #expect(Notacion.inglesASCII.texto { $0.dedosYCejilla(3, 5) } == "3 fingers, barre at fret 5")
    }

    @Test func losInstrumentosYLasTransformacionesTienenNombreEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let instrumentos = Encordado.todos.map { $0.nombre(en: notacion) }
            #expect(Set(instrumentos).count == instrumentos.count, "\(idioma)")
            let transformaciones = TransformacionNeorriemanniana.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(transformaciones).count == transformaciones.count, "\(idioma)")
        }
        // En español, los del motor: es lo que se escribe en `--instrumento`.
        #expect(Encordado.todos.map { $0.nombre(en: .espanolCompacto) } == Encordado.todos.map(\.nombre))
        #expect(Encordado.guitarraDeSieteCuerdas.titulo(en: .inglesASCII) == "Seven-string guitar")
        #expect(Encordado.mandolina.nombre(en: .portuguesPalabras) == "bandolim")
        #expect(TransformacionNeorriemanniana.l.nombre(en: .inglesASCII) == "leading-tone exchange")
        // Un instrumento propio conserva su nombre.
        let laud = Encordado(nombre: "laúd", afinacion: Encordado.mandolina.afinacion)
        #expect(laud.nombre(en: .inglesASCII) == "laúd")
    }

    @Test func losEjemplosQueNoSeLeenSeDejanComoVan() {
        #expect(Notacion.inglesASCII.cifradoDeEjemplo("Xyz") == "Xyz")
        #expect(Notacion.inglesASCII.alturasDeEjemplo("Mi4 Xyz, Do4") == "E4 Xyz, C4")
    }
}
