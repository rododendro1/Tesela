import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct FuncionDeNotaTests {
    /// Cada función del catálogo tiene un nombre que no se repite y una referencia, y cada familia, alguna.
    @Test func catalogo() {
        let catalogo = FuncionDeNota.catalogo
        #expect(catalogo.count == 34)
        #expect(Set(catalogo.map(\.nombre)).count == catalogo.count)
        for funcion in catalogo {
            #expect(funcion.id == funcion.nombre && funcion.description == funcion.nombre)
            #expect(!funcion.referencias.isEmpty, "\(funcion)")
            #expect((funcion.cents == nil) == (funcion.intervalo == nil), "\(funcion)")
        }
        for familia in FamiliaDeFuncionDeNota.allCases {
            #expect(!FuncionDeNota.todas(de: familia).isEmpty, "\(familia)")
            #expect(Set(Idioma.allCases.map { familia.nombre(en: .conPalabras($0)) }).count > 1)
        }
    }

    /// Los intervalos, los cents y las notas sobre una tónica.
    @Test func intervalos() {
        #expect(FuncionDeNota.dominante.intervalo == .quintaJusta && FuncionDeNota.dominante.cents == 700)
        #expect(FuncionDeNota.dominante.nota(sobre: .re) == .la)
        #expect(FuncionDeNota.sensible.nota(sobre: Nota(.la)) == Nota(.sol, .sostenido))
        #expect(FuncionDeNota.pa.cents == 700 && FuncionDeNota.sa.cents == 0)
        #expect(FuncionDeNota.terceraBlue.cents == 350)
        #expect(abs(FuncionDeNota.septimaBlue.desvio + 31.174) < 0.001)
        #expect(FuncionDeNota.tenor.intervalo == nil && FuncionDeNota.tenor.nota(sobre: .re) == nil)
    }

    /// Los grados se llaman como `NombreDeGrado` en todos los idiomas, y cada uno lleva al suyo.
    @Test func grados() {
        let grados: [NombreDeGrado] = [
            .tonica, .supertonica, .mediante, .subdominante, .dominante, .superdominante, .sensible, .subtonica,
        ]
        #expect(FuncionDeNota.todas(de: .grado).compactMap(\.nombreDeGrado) == grados)
        for grado in grados {
            #expect(grado.funcion.nombreDeGrado == grado)
            for idioma in Idioma.allCases {
                #expect(grado.funcion.nombre(en: .conPalabras(idioma)) == grado.nombre(en: .conPalabras(idioma)))
            }
        }
    }

    /// Cada fichero de idioma da todas las funciones del catálogo, una sola vez y sin repetir nombres.
    @Test func nombresEnTodosLosIdiomas() {
        let catalogo = FuncionDeNota.catalogo
        for idioma in Idioma.allCases {
            let nombres = NombresDeFunciones.de(idioma)
            #expect(nombres.filas.count == catalogo.count, "\(idioma)")
            #expect(Set(nombres.filas.map(\.elemento)) == Set(catalogo), "\(idioma)")
            let escritos = catalogo.compactMap { nombres.nombre(de: $0) }
            #expect(escritos.count == catalogo.count, "\(idioma)")
            #expect(Set(escritos.map(NombresDeFunciones.Tabla.normalizar)).count == catalogo.count, "\(idioma)")
        }
    }

    /// Ningún nombre, alias ni variante, en ningún idioma, es de dos funciones distintas.
    @Test func ningunNombreEsDeDos() {
        var duenos: [String: FuncionDeNota] = [:]
        for funcion in FuncionDeNota.catalogo {
            for clave in funcion.claves {
                if let otra = duenos[clave] { #expect(otra == funcion, "«\(clave)»: \(otra) y \(funcion)") }
                duenos[clave] = funcion
            }
        }
    }

    /// Se busca por el nombre, un alias o una variante en cualquier idioma.
    @Test func buscar() {
        #expect(FuncionDeNota.buscar(nombre: "leading tone") == .sensible)
        #expect(FuncionDeNota.buscar(nombre: "submediante") == .superdominante)
        #expect(FuncionDeNota.buscar(nombre: "vadi") == .vadi)
        #expect(FuncionDeNota.buscar(nombre: "güçlü") == .ghammaz)
        #expect(FuncionDeNota.buscar(nombre: "Triller") == .trino)
        #expect(FuncionDeNota.buscar(nombre: "suspension") == .retardo)
        #expect(FuncionDeNota.buscar(nombre: "no es una función") == nil)
        #expect(FuncionDeNota.buscar(conteniendo: "blue") == [.terceraBlue, .quintaBlue, .septimaBlue])
        #expect(FuncionDeNota.buscar(conteniendo: "") == FuncionDeNota.catalogo)
    }
}
