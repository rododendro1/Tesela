import Armonia
import Foundation

/// La conducción de las voces de una progresión entera: para cada paso de un acorde al siguiente, las notas
/// comunes y lo que se mueve cada voz.
public struct ConduccionPresentada: Hashable, Sendable {
    public struct Paso: Hashable, Sendable {
        /// «Rem7 → Sol7».
        public let titulo: String
        /// «Notas comunes: Re, Fa», o «Notas comunes: ninguna».
        public let comunes: String
        /// Una por voz, de grave a agudo: «Fa₃ → Fa₃ (0)», «Do₄ → Si₃ (−1)».
        public let voces: [String]
        /// Lo que se mueven las voces, sin signo, en semitonos.
        public let movimiento: Int
    }

    /// La disposición en que se conduce: «Drop 2».
    public let disposicion: String
    public let pasos: [Paso]
    /// «Movimiento total: 7 semitonos», de toda la progresión.
    public let movimientoTotal: String
    public let sonido: Escucha
}

/// La progresión en una de las doce tonalidades.
public struct ProgresionEnUnaTonalidad: Hashable, Sendable {
    public let tonalidad: Tonalidad
    /// «Sol mayor».
    public let titulo: String
    public let acordes: [Acorde]
    /// «Lam7 Re7 Solmaj7».
    public let cifrados: String
    public let sonido: Escucha
}

extension PresentacionDeAnalisis {
    // MARK: La conducción de las voces

    /// Cómo va cada voz de un acorde al siguiente en toda la progresión, con el menor movimiento en la disposición
    /// dada (o, si no se puede, cerrada); `nil` con menos de dos acordes o si no se pueden disponer.
    ///
    ///     let conduccion = PresentacionDeAnalisis.conduccion(
    ///         [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], en: .compacta(.espanol))
    ///     conduccion?.pasos.map(\.titulo)   // ["Rem7 → Sol7", "Sol7 → Domaj7"]
    public static func conduccion(
        _ acordes: [Acorde], disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> ConduccionPresentada? {
        guard acordes.count >= 2 else { return nil }
        let elegida = disposicion.conducir(acordes) == nil ? DisposicionDeAcorde.cerrada : disposicion
        guard let voces = elegida.conducir(acordes), voces.count == acordes.count else { return nil }
        var pasos: [ConduccionPresentada.Paso] = []
        for i in 1..<acordes.count {
            let (antes, despues) = (acordes[i - 1], acordes[i])
            let suyas = Set(despues.notas.map(\.claseDeAltura))
            var comunes: [Nota] = []
            for nota in antes.notas where suyas.contains(nota.claseDeAltura) && !comunes.contains(nota) {
                comunes.append(nota)
            }
            let lista =
                comunes.isEmpty
                ? notacion.texto(\.ningunaNotaComun) : comunes.map { $0.nombre(en: notacion) }.joined(separator: ", ")
            let movimientos = zip(voces[i - 1], voces[i]).map { desde, hasta in
                (desde, hasta, hasta.midi - desde.midi)
            }
            pasos.append(
                ConduccionPresentada.Paso(
                    titulo: antes.cifrado(en: notacion) + " → " + despues.cifrado(en: notacion),
                    comunes: notacion.texto(\.notasComunes) + ": " + lista,
                    voces: movimientos.map { desde, hasta, paso in
                        desde.nombre(en: notacion) + " → " + hasta.nombre(en: notacion) + " (" + firmado(paso) + ")"
                    },
                    movimiento: movimientos.map { abs($0.2) }.reduce(0, +)))
        }
        let total = pasos.map(\.movimiento).reduce(0, +)
        return ConduccionPresentada(
            disposicion: elegida.nombre(en: notacion), pasos: pasos,
            movimientoTotal: notacion.texto { $0.movimientoTotal(total) }, sonido: .coral(voces))
    }

    /// «+2», «−1», «0».
    private static func firmado(_ paso: Int) -> String {
        paso > 0 ? "+\(paso)" : paso < 0 ? "−\(-paso)" : "0"
    }

    // MARK: Las doce tonalidades

    /// La progresión en las doce tonalidades, de quinta en quinta desde la suya (de Do mayor, Sol, Re… hasta Fa),
    /// cada una con la escritura de menos alteraciones y los acordes llevados por el camino más corto.
    ///
    ///     let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
    ///     let doce = PresentacionDeAnalisis.enLasDoceTonalidades(
    ///         progresion, tonalidad: Tonalidad(.do), en: .compacta(.espanol))
    ///     doce[1].cifrados   // "Lam7 Re7 Solmaj7"
    public static func enLasDoceTonalidades(
        _ acordes: [Acorde], tonalidad: Tonalidad, en notacion: Notacion
    ) -> [ProgresionEnUnaTonalidad] {
        (0..<12).map { k in
            let armadura = ((tonalidad.armadura + k + 5) % 12 + 12) % 12 - 5
            let destino = k == 0 ? tonalidad : Tonalidad(armadura: armadura, modo: tonalidad.modo)
            let intervalo = tonalidad.tonica.intervaloMasCorto(hasta: destino.tonica)
            let llevados = k == 0 ? acordes : acordes.map { $0.transponer(intervalo) }
            return ProgresionEnUnaTonalidad(
                tonalidad: destino, titulo: destino.nombre(en: notacion), acordes: llevados,
                cifrados: llevados.map { $0.cifrado(en: notacion) }.joined(separator: " "),
                sonido: Escucha.acordes(llevados).conTonica(destino.tonica))
        }
    }

    /// La hoja para practicar la progresión en las doce tonalidades (SVG del ancho de un A4): en cada una, su nombre,
    /// los cifrados y el pentagrama con una disposición de cada acorde (la `disposicion`, o cerrada si no se puede).
    public static func hojaEnLasDoceTonalidades(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen + 22
        let original = acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
        cuerpo.append(Hoja.texto(original, x: margen, y: y, tamano: 20, negrita: true))
        y += 20
        cuerpo.append(Hoja.texto(notacion.texto(\.enLasDoceTonalidades), x: margen, y: y, tamano: 13, color: "#555555"))
        y += 16
        for progresion in enLasDoceTonalidades(acordes, tonalidad: tonalidad, en: notacion) {
            y += 18
            cuerpo.append(Hoja.texto(progresion.titulo, x: margen, y: y, tamano: 13, negrita: true))
            cuerpo.append(Hoja.texto(progresion.cifrados, x: margen + 130, y: y, tamano: 13))
            y += 4
            let dispuesta =
                PresentacionDeDisposiciones.progresion(progresion.acordes, disposicion, en: notacion)
                ?? PresentacionDeDisposiciones.progresion(progresion.acordes, .cerrada, en: notacion)
            if let dispuesta {
                y += Hoja.incrustar(dispuesta.pentagrama.svg, x: margen, y: y, ancho: util, en: &cuerpo)
            }
            y += 6
        }
        let alto = (y + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: alto, cuerpo)
    }
}
