import Elementos
import Teoria

// La conducción de voces que comparten el coral (`Coral.faltas`) y el contrapunto (`Contrapunto.faltas`,
// `ContrapuntoAVariasVoces.faltas`): qué es una consonancia perfecta, cuándo dos voces van en quintas u octavas
// paralelas o llegan a ellas por movimiento directo, y qué saltos no son melódicos. Cada uno añade lo suyo encima
// (en el coral, las directas son solo entre las voces extremas y con salto en el soprano; en el contrapunto, solo
// en parte fuerte), pero la regla de base es una.

/// Las reglas de conducción de voces que comparten el coral y el contrapunto.
package enum Conduccion {
    /// 5 si el intervalo es una quinta justa (simple o compuesta), 8 si es una octava justa o un unísono; `nil` en
    /// otro caso.
    package static func perfecta(_ intervalo: Intervalo) -> Int? {
        guard intervalo.calidad == .justa else { return nil }
        switch intervalo.numeroSimple {
        case 5: return 5
        case 1, 8: return 8
        default: return nil
        }
    }

    /// El intervalo entre dos alturas, de la grave a la aguda, sea cual sea su orden.
    package static func intervalo(_ a: Altura, _ b: Altura) -> Intervalo {
        a.midi <= b.midi ? a.intervalo(hasta: b) : b.intervalo(hasta: a)
    }

    /// El paso de dos voces de una sonoridad a la siguiente.
    package struct PasoDeVoces {
        /// Las dos voces antes y después.
        package let antes: (Altura, Altura)
        package let despues: (Altura, Altura)

        package init(de antes: (Altura, Altura), a despues: (Altura, Altura)) {
            self.antes = antes
            self.despues = despues
        }

        /// Lo que se mueve cada voz, en semitonos (positivo si sube).
        package var movimientos: (Int, Int) {
            (despues.0.midi - antes.0.midi, despues.1.midi - antes.1.midi)
        }

        /// Las dos voces cambian de nota.
        package var seMuevenLasDos: Bool { movimientos.0 != 0 && movimientos.1 != 0 }

        /// Las dos se mueven en el mismo sentido.
        package var esDirecto: Bool { seMuevenLasDos && (movimientos.0 > 0) == (movimientos.1 > 0) }

        /// 5 o 8 si las dos voces se mueven y van de una quinta (o una octava, o un unísono) a otra; `nil` si no.
        package var paralelas: Int? {
            guard seMuevenLasDos, let perfecta = Conduccion.perfecta(Conduccion.intervalo(antes.0, antes.1)),
                perfecta == Conduccion.perfecta(Conduccion.intervalo(despues.0, despues.1))
            else { return nil }
            return perfecta
        }

        /// 5 o 8 si las dos voces llegan por movimiento directo a una quinta (o a una octava) desde otro intervalo;
        /// `nil` si no.
        package var directas: Int? {
            guard esDirecto, let perfecta = Conduccion.perfecta(Conduccion.intervalo(despues.0, despues.1)),
                Conduccion.perfecta(Conduccion.intervalo(antes.0, antes.1)) != perfecta
            else { return nil }
            return perfecta
        }
    }

    /// Qué saltos no son melódicos.
    package enum Saltos {
        /// En la armonía a cuatro voces: los aumentados y los de más de una octava.
        case armonia
        /// En el contrapunto estricto: los aumentados y disminuidos, las séptimas, los de más de una octava, la
        /// sexta mayor y la sexta menor descendente.
        case contrapunto

        /// `true` si el salto no es melódico. `ascendente` dice el sentido, que el intervalo no lleva.
        package func noEsMelodico(_ salto: Intervalo, ascendente: Bool) -> Bool {
            switch self {
            case .armonia:
                if case .aumentada = salto.calidad, salto.numero != 1 { return true }
                return salto.semitonos > 12
            case .contrapunto:
                switch salto.calidad {
                case .aumentada, .disminuida: return true
                default: break
                }
                if salto.numero > 8 || salto.numero == 7 { return true }
                if salto.numero == 6 { return salto.calidad == .mayor || !ascendente }
                return false
            }
        }
    }
}
