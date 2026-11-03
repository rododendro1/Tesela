import Armonia
import Foundation

/// Una serie dodecafónica tal como la enseña la app: sus datos (notas, intervalos, hexacordos, formas
/// combinatorias), la matriz de 12 × 12 con el nombre de cada fila y columna, y la forma elegida, con sus notas, su
/// pentagrama, lo que suena al escucharla y los ficheros para exportar.
public struct SeriePresentada: Hashable, Sendable {
    /// Un dato con su nombre: «Intervalos: 11 8 9 10 7 6 5 4 2 3 4».
    public struct Dato: Hashable, Sendable {
        public let titulo: String
        public let valor: String
    }

    /// La serie como se escribe con cifras: «0 e 7 4 2 9 3 8 t 1 5 6».
    public let serie: String
    public let datos: [Dato]
    /// «48 formas distintas», o 24 si la serie es simétrica.
    public let formasDistintas: String
    /// La matriz de 12 × 12 (`SerieDodecafonica/matriz`): cada fila es una P de izquierda a derecha y su R de
    /// derecha a izquierda; cada columna, una I de arriba abajo y su RI de abajo arriba.
    public let matriz: [[Int]]
    /// Las formas de cada fila (P, a la izquierda) y de cada columna (I, arriba). La R de una fila y la RI de una
    /// columna tienen el mismo índice.
    public let formasDeLasFilas: [FormaDeSerie]
    public let formasDeLasColumnas: [FormaDeSerie]
    /// El nombre de cada clase de altura (0…11) en la notación, sin repetir ninguna.
    public let nombresDeLasClases: [String]
    /// La forma que se muestra, se escucha y se exporta.
    public let forma: FormaDeSerie
    /// Sus clases, en orden.
    public let clasesDeLaForma: [Int]
    /// Sus notas: «Fa Mi Do La Sol Re…».
    public let notasDeLaForma: String
    public let pentagrama: PentagramaPresentado
    public let sonido: Escucha
    public let ficheros: [FicheroParaExportar]

    /// La clase como se escribe en la matriz: 0…9, t (10) y e (11).
    public static func cifra(_ clase: Int) -> String {
        clase == 10 ? "t" : clase == 11 ? "e" : String(clase)
    }

    /// Si la celda está en la forma elegida: en su fila (P o R) o en su columna (I o RI).
    public func estaEnLaForma(fila: Int, columna: Int) -> Bool {
        switch forma.tipo {
        case .original, .retrogrado: return formasDeLasFilas[fila].indice == forma.indice
        case .inversion, .retrogradoDeLaInversion: return formasDeLasColumnas[columna].indice == forma.indice
        }
    }

    /// Una fila de la matriz para los lectores de pantalla: «P0: Fa Mi Do La…».
    public func descripcion(deLaFila fila: Int) -> String {
        formasDeLasFilas[fila].description + ": "
            + matriz[fila].map { nombresDeLasClases[$0] }.joined(separator: " ")
    }
}

/// La parte de la vista de la serie dodecafónica que no es dibujo. No usa SwiftUI, así que se prueba en Linux.
///
///     let berg = try PresentacionDeSerie.presentar(
///         "5 4 0 9 7 2 8 1 3 6 t e", forma: FormaDeSerie(.inversion, 5), notacion: .espanolCompacto)
///     berg.clasesDeLaForma   // [5, 6, 10, 1, 3, 8, 2, 9, 7, 4, 0, 11]
public enum PresentacionDeSerie {
    /// La serie de la Suite lírica de Berg, de todos los intervalos, para empezar.
    public static let ejemplo = "5 4 0 9 7 2 8 1 3 6 t e"

    /// Negra a 120: la serie dura seis segundos.
    public static let tempo = Tempo(120)

    /// Lee la serie y la prepara para enseñarla con la forma elegida. Lanza el error de lectura si no se lee o si no
    /// son las doce clases una vez cada una.
    public static func presentar(
        _ texto: String, forma: FormaDeSerie, notacion: Notacion
    ) throws -> SeriePresentada {
        let serie = try SerieDodecafonica(leyendo: texto)
        let t = { (campo: (TextosDeApps) -> String) in notacion.texto(campo) }
        // Una nota por clase, escritas todas a la vez para que ninguna se repita.
        let total = ConjuntoDeClases(0..<12)
        let notaDeCada = Dictionary(uniqueKeysWithValues: zip(total.clases, total.notas()))
        let nombres = (0..<12).map { notaDeCada[$0]?.nombre(en: notacion) ?? cifra($0) }
        let lista = { (clases: [Int]) in clases.map { nombres[$0] }.joined(separator: " ") }

        var intervalos = serie.intervalos.map(String.init).joined(separator: " ")
        if serie.esDeTodosLosIntervalos { intervalos += " (" + t(\.deTodosLosIntervalos) + ")" }
        let (primero, segundo) = serie.hexacordos
        let datos = [
            SeriePresentada.Dato(titulo: t(\.notas), valor: lista(serie.clases)),
            SeriePresentada.Dato(titulo: t(\.intervalos), valor: intervalos),
            SeriePresentada.Dato(
                titulo: t(\.hexacordos),
                valor: [primero, segundo].map { $0.numeroDeForte ?? $0.description }.joined(separator: " · ")),
            SeriePresentada.Dato(
                titulo: t(\.formasCombinatorias),
                valor: serie.formasCombinatorias.map(\.description).joined(separator: " ")),
        ]

        let matriz = serie.matriz
        let clases = serie.forma(forma).clases
        let alturas = clases.map { clase in
            notaDeCada[clase].flatMap { Altura($0, midi: 60 + clase) } ?? Altura(midi: 60 + clase)
        }
        let titulo = t(\.serieDodecafonica) + " " + forma.description
        let voz = Voz(alturas.map { Evento($0, .negra) })
        // Sin armadura: una serie no está en ninguna tonalidad.
        let sinArmadura = Tonalidad(armadura: 0)
        return SeriePresentada(
            serie: serie.description, datos: datos,
            formasDistintas: notacion.texto { $0.formasDistintas(serie.numeroDeFormasDistintas) }, matriz: matriz,
            formasDeLasFilas: matriz.map { FormaDeSerie(.original, $0[0]) },
            formasDeLasColumnas: matriz[0].map { FormaDeSerie(.inversion, $0) },
            nombresDeLasClases: nombres, forma: forma, clasesDeLaForma: clases,
            notasDeLaForma: lista(clases),
            pentagrama: PentagramaPresentado(alturas.map { [$0] }, titulo: forma.description, notacion: notacion),
            sonido: Escucha.voz(voz, tempo: tempo),
            ficheros: [
                .musicXML(voz.musicXML(tonalidad: sinArmadura, titulo: titulo), nombre: titulo),
                .mei(voz.mei(tonalidad: sinArmadura, titulo: titulo), nombre: titulo),
                .lilyPond(voz.lilyPond(tonalidad: sinArmadura, titulo: titulo), nombre: titulo),
                .abc(voz.abc(tonalidad: sinArmadura, titulo: titulo), nombre: titulo),
                .midi(voz.midi(tonalidad: sinArmadura, tempo: tempo, titulo: titulo), nombre: titulo),
            ])
    }

    private static func cifra(_ clase: Int) -> String { SeriePresentada.cifra(clase) }

    /// Qué se escribe en el campo de la serie, con un ejemplo en cifras y otro en la notación:
    /// «Serie (5 4 0 9 7 2 8 1 3 6 t e, o Fa Mi Do La…)».
    public static func indicacion(en notacion: Notacion) -> String {
        let nombres = [Nota.fa, .mi, .`do`, .la].map { $0.nombre(en: notacion) }.joined(separator: " ") + "…"
        return notacion.texto { $0.indicacionSerie(ejemplo, nombres) }
    }
}
