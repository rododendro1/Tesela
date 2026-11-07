import Elementos
import PartituraArmonia
import Teoria

// Exportación a LilyPond (lilypond.org), el programa libre que graba partituras en PDF con la calidad de una
// edición impresa: `lilypond coral.ly` deja `coral.pdf`. Frescobaldi lo edita y lo muestra a la vez.
//
// Se escribe la grafía de cada voz (`Voz.grafia`), con la ortografía tal cual, en altura absoluta y con los nombres
// holandeses de LilyPond (`fis'`, `bes,`). LilyPond decide qué alteraciones se ven y cómo se agrupan las barras,
// como en una partitura. Los cifrados van encima de la nota en que empieza cada acorde y el análisis, debajo, como
// `\markup`.

// MARK: - Escritor LilyPond

/// Reúne varias voces, cada una en un pentagrama (con un `Voice` por voz), y escribe el fichero `.ly`.
package struct EscritorLilyPond: EscritorDeTexto {
    package let compas: Compas
    package let anacrusa: Duracion
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    package let parte: String
    package let claves: [Clave]
    package var lineas: [Exportacion.LineaAnotada] = []
    package var rotulo: (texto: String, pentagrama: Int)?

    package init(
        compas: Compas, anacrusa: Duracion, tonalidad: Tonalidad?, tempo: Tempo?,
        titulo: String?, parte: String, claves: [Clave]
    ) {
        self.compas = compas
        self.anacrusa = anacrusa
        self.tonalidad = tonalidad
        self.tempo = tempo
        self.titulo = titulo
        self.parte = parte
        self.claves = claves
    }

    package var documento: String {
        var ly = "\\version \"2.24.0\"\n\n\\header {\n"
        if let titulo { ly += "  title = \(EscritorLilyPond.cadena(titulo))\n" }
        ly += "  tagline = ##f\n}\n\n\\score {\n"
        let nombre = "\\with { instrumentName = \(EscritorLilyPond.cadena(parte)) }"
        let pentagramas = 1...max(claves.count, 1)
        if claves.count > 1 { ly += "  \\new PianoStaff \(nombre) <<\n" }
        for pentagrama in pentagramas {
            ly += claves.count > 1 ? "    \\new Staff <<\n" : "  \\new Staff \(nombre) <<\n"
            for l in lineas.indices where lineas[l].pentagrama == pentagrama {
                ly += voz(l, sangria: claves.count > 1 ? "      " : "    ")
            }
            ly += claves.count > 1 ? "    >>\n" : "  >>\n"
        }
        if claves.count > 1 { ly += "  >>\n" }
        return ly + "  \\layout { }\n}\n"
    }

    /// Un `\new Voice` con lo que va al principio (clave, armadura, compás…) y un compás por renglón.
    private func voz(_ l: Int, sangria: String) -> String {
        let linea = lineas[l]
        let clave = self.clave(delPentagrama: linea.pentagrama)
        var inicio: [String] = []
        if let arriba = linea.plicaArriba { inicio.append(arriba ? "\\voiceOne" : "\\voiceTwo") }
        inicio.append("\\clef \"\(EscritorLilyPond.clave(clave))\"")
        inicio.append(EscritorLilyPond.armadura(tonalidad))
        inicio.append(EscritorLilyPond.compas(compas))
        if let tempo, l == 0 { inicio.append(EscritorLilyPond.indicacion(tempo)) }
        if anacrusa > .cero { inicio.append("\\partial " + EscritorLilyPond.duracion(anacrusa)) }
        var ly = sangria + "\\new Voice {\n" + sangria + "  " + inicio.joined(separator: " ") + "\n"
        let compases = Exportacion.compases(de: linea.voz)
        for (c, eventos) in compases.enumerated() {
            let compasEntero = esSilencioDeCompas(eventos, compas: c)
            let irregulares = Exportacion.irregulares(eventos.map(\.evento))
            var piezas: [String] = []
            for (i, (evento, inicio, nuevo)) in eventos.enumerated() {
                let irregular = irregulares.contains { $0.rango.contains(i) }
                var texto =
                    compasEntero
                    ? "R" + EscritorLilyPond.duracion(compas.duracion)
                    : EscritorLilyPond.evento(evento, irregular: irregular)
                texto += EscritorLilyPond.expresion(evento)
                if nuevo, let cifrado = linea.cifrados[inicio] {
                    texto += "^\\markup \(EscritorLilyPond.cadena(cifrado))"
                }
                let debajo = self.debajo(enLaLinea: l, compas: c, evento: i, inicio: inicio, nuevo: nuevo)
                if debajo.count == 1 { texto += "_\\markup \(EscritorLilyPond.cadena(debajo[0]))" }
                if debajo.count > 1 {
                    texto += "_\\markup \\column { " + debajo.map(EscritorLilyPond.cadena).joined(separator: " ") + " }"
                }
                piezas.append(texto)
            }
            piezas = Exportacion.envolviendo(
                piezas, grupos: irregulares, abrir: { "\\tuplet \($0)/\($1) {" }, cerrar: "}")
            // Sin barra de comprobación tras el último, que puede estar incompleto (el que cierra una anacrusa).
            ly += sangria + "  " + piezas.joined(separator: " ") + (c == compases.count - 1 ? "\n" : " |\n")
        }
        if compases.isEmpty { ly += sangria + "  R" + EscritorLilyPond.duracion(compas.duracion) + " |\n" }
        return ly + sangria + "  \\bar \"|.\"\n" + sangria + "}\n"
    }

    // MARK: Eventos

    /// Una nota (`fis'4~`), un acorde (`<c e g>2.`) o un silencio (`r8`). En un grupo irregular, la duración es la
    /// de la figura que se escribe, porque `\tuplet` la acorta.
    private static func evento(_ evento: Evento, irregular: Bool) -> String {
        let escrita = Exportacion.figura(de: evento.duracion)
        let figura =
            irregular && escrita.figura != nil
            ? figura(escrita.figura!) + String(repeating: ".", count: escrita.puntillos) : duracion(evento.duracion)
        let ligadura = evento.ligada ? "~" : ""
        switch evento.alturas.count {
        case 0: return "r" + figura
        case 1: return altura(evento.notas[0]) + figura + ligadura
        default:
            let notas = evento.notas.map { altura($0) }
            return "<" + notas.joined(separator: " ") + ">" + figura + ligadura
        }
    }

    /// Las articulaciones y la dinámica detrás de la nota: `-.` (staccato), `->` (acento), `\fermata`, `\mf`…
    package static func expresion(_ evento: Evento) -> String {
        let articulaciones = evento.articulaciones.map { articulacion -> String in
            switch articulacion {
            case .staccato: return "-."
            case .staccatissimo: return "-!"
            case .tenuto: return "--"
            case .acento: return "->"
            case .marcato: return "-^"
            case .calderon: return "\\fermata"
            case .trino: return "\\trill"
            case .mordenteSuperior: return "\\prall"
            case .mordenteInferior: return "\\mordent"
            case .grupeto: return "\\turn"
            case .grupetoInvertido: return "\\reverseturn"
            }
        }
        return articulaciones.joined() + (evento.dinamica.map { "\\" + $0.rawValue } ?? "")
    }

    /// La altura absoluta con el nombre holandés: Do4 → `c'`, Fa♯3 → `fis`, Si♭1 → `bes,,`. Con un `desvio` de
    /// un cuarto de tono (en cents), con los nombres de los cuartos de tono: Mi♭4 + 50 → `eeh'`; las comas no
    /// tienen nombre y se escribe la nota temperada.
    package static func altura(_ altura: Altura, desvio: Double = 0) -> String {
        self.altura(Evento.NotaDelEvento(altura, desvio: desvio))
    }

    /// La altura de una nota, con el nombre de su microtono si lo tiene (el koron, `eh`, como el medio bemol).
    package static func altura(_ nota: Evento.NotaDelEvento) -> String {
        let (natural, semitonos, octava) = Exportacion.sinTriples(nota.altura)
        let nombre = natural.letra.lowercased()
        let temperada = [-2: "eses", -1: "es", 0: "", 1: "is", 2: "isis"][semitonos] ?? ""
        let alteracion = nota.signo(semitonos: semitonos)?.lilypond ?? temperada
        let marcas = octava >= 3 ? String(repeating: "'", count: octava - 3) : String(repeating: ",", count: 3 - octava)
        return nombre + alteracion + marcas
    }

    /// Una duración: con su figura (`4.`, `\breve`) si la tiene; si no, como fracción de redonda (`1*5/16`).
    package static func duracion(_ duracion: Duracion) -> String {
        if let escrita = duracion.figuraYPuntillos {
            let (figura, puntillos) = (escrita.figura, escrita.puntillos)
            return self.figura(figura) + String(repeating: ".", count: puntillos)
        }
        return "1*\(duracion.numerador)/\(duracion.denominador)"
    }

    private static func figura(_ figura: Figura) -> String {
        figura == .cuadrada ? "\\breve" : String(1 << figura.rawValue)
    }

    // MARK: Lo del principio

    package static func clave(_ clave: Clave) -> String {
        switch clave {
        case .sol: return "treble"
        case .solOctavaBaja: return "treble_8"
        case .solOctavaAlta: return "treble^8"
        case .fa: return "bass"
        case .faEnTercera: return "varbaritone"
        case .doEnPrimera: return "soprano"
        case .doEnSegunda: return "mezzosoprano"
        case .doEnTercera: return "alto"
        case .doEnCuarta: return "tenor"
        }
    }

    /// `\key d \major`; Do mayor si no hay tonalidad.
    private static func armadura(_ tonalidad: Tonalidad?) -> String {
        guard let tonalidad else { return "\\key c \\major" }
        let tonica = altura(Altura(tonalidad.tonica, octava: 3))
        return "\\key \(tonica) " + (tonalidad.modo == .mayor ? "\\major" : "\\minor")
    }

    /// `\time 3/4`, y `\time 2,2,3 7/8` en uno de amalgama irregular.
    private static func compas(_ compas: Compas) -> String {
        let pulsos = EscritorMEI.pulsos(compas)
        let agrupacion = pulsos.contains("+") ? String(pulsos.map { $0 == "+" ? "," : $0 }) + " " : ""
        return "\\time \(agrupacion)\(compas.numerador)/\(compas.denominador)"
    }

    /// `\tempo 4. = 60`, con la figura del pulso; en negras si no tiene figura.
    private static func indicacion(_ tempo: Tempo) -> String {
        if let escrita = tempo.unidad.figuraYPuntillos {
            let (figura, puntillos) = (escrita.figura, escrita.puntillos)
            let unidad = self.figura(figura) + String(repeating: ".", count: puntillos)
            return "\\tempo \(unidad) = \(Int(tempo.pulsosPorMinuto.rounded()))"
        }
        return "\\tempo 4 = \(Int(tempo.negrasPorMinuto.rounded()))"
    }
}
