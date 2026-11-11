import Armonia
import Exposicion
import Foundation
import Hexagonos
import Testing

@testable import Interfaz

@Suite struct ModeloDelTonnetzTests {
    private let espanol = Notacion.compacta(.espanol)

    private struct FicheroRoto: Error {}

    private func importada(_ texto: String) throws -> ProgresionImportada {
        let analisis = try AnalisisArmonico.analizar(leyendo: texto)
        return try ImportacionDeProgresion.leer(Data(analisis.partitura().musicXML().utf8))
    }

    // MARK: El recorrido

    @Test func alAbrirElRecorridoEmpiezaEnDo() {
        let modelo = ModeloDelTonnetz()
        #expect(modelo.textoDelRecorrido(en: espanol) == "Do")
        #expect(modelo.dibujado(sonando: nil) == .recorrido(modelo.recorrido))
    }

    @Test func lasTransformacionesSeAnadenYSeDeshacen() {
        var modelo = ModeloDelTonnetz()
        modelo.aplicar(.p)
        modelo.aplicar(.r)
        #expect(modelo.textoDelRecorrido(en: espanol) == "Do → Dom → Mi♭")
        #expect(modelo.transformaciones == [.p, .r])
        modelo.deshacer()
        #expect(modelo.textoDelRecorrido(en: espanol) == "Do → Dom")
        modelo.deshacer()
        modelo.deshacer()
        #expect(modelo.textoDelRecorrido(en: espanol) == "Do")
        #expect(modelo.transformaciones.isEmpty)
    }

    @Test func reiniciarEmpiezaEnLaTriadaEscrita() {
        var modelo = ModeloDelTonnetz()
        modelo.aplicar(.l)
        modelo.textoInicial = "Lam"
        modelo.reiniciar()
        #expect(modelo.textoDelRecorrido(en: espanol) == "Lam")
        modelo.textoInicial = "Xq"
        modelo.reiniciar()
        #expect(modelo.recorrido.isEmpty)
        #expect(modelo.dibujado(sonando: nil) == nil)
        #expect(modelo.ficheros(sonando: nil, en: espanol).isEmpty)
    }

    @Test func sinRecorridoNoSeAplicaNada() {
        var modelo = ModeloDelTonnetz()
        modelo.textoInicial = "Xq"
        modelo.reiniciar()
        modelo.aplicar(.p)
        #expect(modelo.recorrido.isEmpty)
        #expect(modelo.transformaciones.isEmpty)
    }

    @Test func elRecorridoSuenaComoSusAcordes() {
        var modelo = ModeloDelTonnetz()
        modelo.aplicar(.r)
        #expect(modelo.sonido(sonando: nil) == .acordes(modelo.recorrido))
    }

    // MARK: Acorde y escala

    @Test func elAcordeYLaEscalaSeDibujanSiSeLeen() {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .acorde
        #expect(modelo.sonido(sonando: nil) != .silencio)
        #expect(modelo.ficheros(sonando: nil, en: espanol).count == 1)
        modelo.textoAcorde = "Xq"
        #expect(modelo.dibujado(sonando: nil) == nil)
        #expect(modelo.sonido(sonando: nil) == .silencio)
        modelo.contenido = .escala
        if case .escala(let escala) = modelo.dibujado(sonando: nil) {
            #expect(modelo.sonido(sonando: nil) == .escala(escala))
        } else {
            Issue.record("la escala no se dibuja")
        }
    }

    // MARK: Identificar

    @Test func sinNotasTocadasSePideTocar() {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .identificar
        #expect(modelo.identificado(en: espanol) == espanol.texto(\.tocaNotas))
        #expect(modelo.sonido(sonando: nil) == .silencio)
    }

    @Test func lasNotasTocadasDicenSuAcorde() {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .identificar
        modelo.clasesTocadas = [0, 4, 7]
        #expect(modelo.identificado(en: espanol).hasPrefix("Do · "))
        #expect(modelo.identificado(en: espanol).contains(espanol.texto(\.numeroDeForte)))
        #expect(modelo.sonido(sonando: nil) != .silencio)
    }

    @Test func dosNotasSinAcordeAvisanYSuenanJuntas() {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .identificar
        modelo.clasesTocadas = [0, 1]
        #expect(modelo.identificado(en: espanol).contains(espanol.texto(\.sinAcordeConocido)))
        #expect(modelo.sonido(sonando: nil) == .coral([[Altura(midi: 60), Altura(midi: 61)]]))
    }

    @Test func unaNotaSoloDiceSuNombre() {
        var modelo = ModeloDelTonnetz()
        modelo.clasesTocadas = [2]
        #expect(modelo.identificado(en: espanol) == "Re")
    }

    @Test func unAcordeSinOtrasLecturasNoLasEnumera() {
        var modelo = ModeloDelTonnetz()
        modelo.clasesTocadas = [0, 4, 7]
        let lineas = modelo.identificado(en: espanol).split(separator: "\n")
        #expect(lineas.first == "Do · " + (try! Acorde(leyendo: "Do")).nombre(en: espanol))
    }

    @Test func tocarEnIdentificarMarcaYDesmarca() throws {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .identificar
        modelo.clasesTocadas = [0]
        let dibujado = try #require(modelo.dibujado(sonando: nil))
        // Cada punto del dibujo que da una nota la marca, y al tocarlo otra vez se desmarca.
        var tocado: (Punto, Int)?
        for x in stride(from: 0.0, through: 600, by: 7) where tocado == nil {
            for y in stride(from: 0.0, through: 600, by: 7) {
                var prueba = modelo
                if let midi = prueba.tocar(en: Punto(x: x, y: y), de: dibujado) {
                    tocado = (Punto(x: x, y: y), midi)
                    break
                }
            }
        }
        let (punto, midi) = try #require(tocado)
        let antes = modelo.clasesTocadas
        #expect(modelo.tocar(en: punto, de: dibujado) == midi)
        #expect(modelo.clasesTocadas != antes)
        _ = modelo.tocar(en: punto, de: dibujado)
        #expect(modelo.clasesTocadas == antes)
    }

    @Test func tocarFueraDeIdentificarSoloSuena() throws {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .acorde
        let dibujado = try #require(modelo.dibujado(sonando: nil))
        for x in stride(from: 0.0, through: 600, by: 11) {
            for y in stride(from: 0.0, through: 600, by: 11) {
                _ = modelo.tocar(en: Punto(x: x, y: y), de: dibujado)
            }
        }
        #expect(modelo.clasesTocadas.isEmpty)
    }

    // MARK: La partitura

    @Test func unaPartituraAbiertaSeSiguePasoAPaso() throws {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .partitura
        #expect(modelo.pasoActual(sonando: nil) == nil)
        #expect(modelo.sonido(sonando: nil) == .silencio)
        modelo.abrir(.success(try importada("Do Lam Fa Sol")), en: espanol)
        #expect(modelo.pasoActual(sonando: nil) == 0)
        #expect(modelo.descripcion(delPaso: 0) == "1/4 · Do")
        #expect(modelo.dibujado(sonando: nil) == .acorde(modelo.partitura!.pasos[0].acorde))

        let siguiente = modelo.elegirPaso(avanzando: true, sonando: nil)
        #expect(siguiente == modelo.partitura?.pasos[1].acorde)
        #expect(modelo.pasoActual(sonando: nil) == 1)
        #expect(modelo.descripcion(delPaso: 1)?.hasPrefix("2/4 · Do –") == true)
        #expect(modelo.descripcion(delPaso: 9) == nil)
        if case .recorrido(let tramo) = modelo.dibujado(sonando: nil) {
            #expect(tramo.count == 2)
        } else {
            Issue.record("el paso 2 no dibuja el recorrido hasta él")
        }
        // Lo que suena manda sobre lo elegido.
        #expect(modelo.pasoActual(sonando: 3) == 3)
        #expect(modelo.sonido(sonando: nil) == modelo.partitura?.sonido)
    }

    @Test func sinPartituraNoHayPasos() {
        var modelo = ModeloDelTonnetz()
        modelo.contenido = .partitura
        #expect(modelo.elegirPaso(avanzando: true, sonando: nil) == nil)
        #expect(modelo.dibujado(sonando: nil) == nil)
        #expect(modelo.descripcion(delPaso: 0) == nil)
    }

    @Test func unaPartituraQueNoSeLeeGuardaElError() throws {
        var modelo = ModeloDelTonnetz()
        modelo.abrir(.failure(FicheroRoto()), en: espanol)
        #expect(modelo.errorAlAbrir is FicheroRoto)
        #expect(modelo.partitura == nil)
        modelo.abrir(.success(try importada("Do Sol")), en: espanol)
        #expect(modelo.errorAlAbrir == nil)
    }

    @Test func alCambiarLaNotacionSeReescribenLosCifrados() throws {
        var modelo = ModeloDelTonnetz()
        modelo.abrir(.success(try importada("Do Lam")), en: espanol)
        modelo.cambiar(a: .compacta(.ingles))
        #expect(modelo.descripcion(delPaso: 0) == "1/2 · C")
    }

    @Test func cadaModoTieneSuTitulo() {
        let titulos = ModeloDelTonnetz.Contenido.allCases.map { $0.titulo(en: espanol) }
        #expect(Set(titulos).count == titulos.count)
        #expect(titulos.allSatisfy { !$0.isEmpty })
        #expect(ModeloDelTonnetz.Contenido.allCases.allSatisfy { $0.id == $0 })
    }
}
