import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

/// Lo que se guarda en JSON se lee igual, y lo que no se podría crear con sus inicializadores no se lee.
@Suite struct CodificacionTests {
    private func idaYVuelta<T: Codable & Equatable>(_ valor: T) throws -> T {
        try JSONDecoder().decode(T.self, from: JSONEncoder().encode(valor))
    }

    private func leer<T: Decodable>(_ tipo: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(tipo, from: Data(json.utf8))
    }

    @Test func tempoYEncabezado() throws {
        let tempo = Tempo(60, unidad: Duracion(.negra, puntillos: 1))
        #expect(try idaYVuelta(tempo) == tempo)
        let encabezado = Encabezado(titulo: "Coral", tonalidad: Tonalidad(.re, .menor), tempo: Tempo(72))
        #expect(try idaYVuelta(encabezado) == encabezado)
        #expect(try idaYVuelta(Encabezado()) == Encabezado())
        // Un tempo que no es positivo no se lee.
        let negra = String(decoding: try JSONEncoder().encode(Duracion.negra), as: UTF8.self)
        #expect(try leer(Tempo.self, #"{"pulsosPorMinuto": 90, "unidad": \#(negra)}"#) == Tempo(90))
        #expect(throws: DecodingError.self) { try leer(Tempo.self, #"{"pulsosPorMinuto": 0, "unidad": \#(negra)}"#) }
    }

    @Test func ritmoArmonico() throws {
        let ritmo = RitmoArmonico(
            [AcordeConDuracion("Do", .blanca), AcordeConDuracion("Sol7", .negra)], compas: Compas(3, 4),
            tempo: Tempo(90))
        #expect(try idaYVuelta(ritmo) == ritmo)
        #expect(try idaYVuelta(RitmoArmonico(["Do", "Fa"])) == RitmoArmonico(["Do", "Fa"]))
        let inicio = AcordeConInicio("Lam", inicio: .blanca)
        #expect(try idaYVuelta(inicio) == inicio)
        // Un acorde que no dura nada no se lee.
        let sinDuracion = String(decoding: try JSONEncoder().encode(Duracion.cero), as: UTF8.self)
        #expect(throws: DecodingError.self) {
            try leer(AcordeConDuracion.self, #"{"acorde": "Do", "duracion": \#(sinDuracion)}"#)
        }
    }

    @Test func partitura() throws {
        let soprano = try Voz(leyendo: "Mi5:2 Re5:2")
        let bajo = try Voz(leyendo: "Do3:2 Sol2:2")
        let analisis = Tonalidad(.do).analizar([Acorde("Do"), Acorde("Sol7")]).acordes
        let arriba = Partitura.Linea(
            soprano, nombre: "Soprano", plicaArriba: true, cifrados: [.cero: Acorde("Do"), .blanca: Acorde("Sol7")],
            analisis: [.cero: analisis[0], .blanca: analisis[1]], dedos: [.cero: [5]])
        let partitura = Partitura(
            pentagramas: [
                .init(clave: .sol, voces: [arriba]), .init(clave: .fa, voces: [.init(bajo)], numeroDeCuerdas: 6),
            ],
            encabezado: Encabezado(titulo: "Dos voces", tempo: Tempo(80)), tonalidadDelAnalisis: Tonalidad(.do),
            notacion: .inglesASCII.conTextos(en: .catalan), llave: true)
        #expect(try idaYVuelta(partitura) == partitura)
        let tablatura = Tablatura(numeroDeCuerdas: 6, pulsaciones: [0: [.init(cuerda: 1, traste: 3)]])
        let acordes = Partitura(acordes: [[Altura("Do3"), Altura("Mi3")]], titulo: "Do", tablatura: tablatura)
        let leida = try idaYVuelta(acordes)
        #expect(leida == acordes)
        #expect(!leida.dibujaElRitmo)
    }

    @Test func razonDeFrecuencias() throws {
        #expect(try idaYVuelta(RazonDeFrecuencias(3, 2)) == RazonDeFrecuencias(3, 2))
    }

    @Test func notacion() throws {
        for notacion in Notacion.allCases {
            #expect(try idaYVuelta(notacion) == notacion)
        }
        let combinada = Notacion.conPalabras(.ruso).conTextos(en: .espanol).conOctavas(.cifras)
        #expect(try idaYVuelta(combinada) == combinada)
        // Una escritura que no está entre las que hay no se lee.
        #expect(throws: DecodingError.self) {
            try leer(EscrituraDeNotas.self, #"{"idioma": "aleman", "conPalabras": false, "tipografia": "conDobles"}"#)
        }
    }
}
