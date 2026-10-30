import Armonia
import ArmoniaPresentacion

// MARK: - Textos
//
// Lo que escribe la herramienta por su cuenta, en los catorce idiomas de los textos: las
// etiquetas de la salida (`Mensaje`, en este archivo) y los errores de uso (`ErrorDeUso`, en
// ErrorDeUso.swift). Lo musical (notas, acordes, escalas…) no está aquí: lo traduce el motor
// con `Notacion`.
//
// Los textos están en `TextosDeCLI`, un idioma por fichero (`Textos/TextosDeCLI+Espanol.swift`…): cada
// fichero da todos los campos, así que un caso nuevo no compila hasta que tiene su texto en los catorce. El idioma es el de la notación (`--ingles`, `--idioma eu`…).
// La ayuda (`LineaDeComandos.ayuda(en:)`) también está en los catorce idiomas.
// Los avisos del coral (sin armonización, sin faltas…) los comparte con las apps: son
// `CoralPresentado.Aviso`, en `ArmoniaPresentacion`.

/// Las piezas de texto de la salida de las órdenes.
enum Mensaje {
    case notas
    case acordes
    case escalas
    case armadura
    case relativa
    case homonima
    case bajo(String)
    case inversion(Int)
    case bajoAjeno
    case sinAcordes
    case sin(String)
    case semitonos(Int)
    case sinAlteraciones
    case alteraciones(Int, sostenidos: Bool)
    case aCuatroVoces
    case sinDigitaciones
    case dedos(Int)
    case cejilla(Int)
    case pasos(Int)
    case triadas(Int)
    case ciclo(CicloNeorriemanniano)
    case instrumento(Encordado)

    func texto(en notacion: Notacion) -> String {
        traduccion.en(notacion)
    }

    var traduccion: Traduccion {
        switch self {
        case .notas: return TextosDeCLI.traducidos.map(\.mensajeNotas)
        case .acordes: return TextosDeCLI.traducidos.map(\.mensajeAcordes)
        case .escalas: return TextosDeCLI.traducidos.map(\.mensajeEscalas)
        case .armadura: return TextosDeCLI.traducidos.map(\.mensajeArmadura)
        case .relativa: return TextosDeCLI.traducidos.map(\.mensajeRelativa)
        case .homonima: return TextosDeCLI.traducidos.map(\.mensajeHomonima)
        case .bajo(let nota):
            return TextosDeCLI.traducidos.map { $0.mensajeBajo(nota) }
        case .inversion(let n):
            // Los nombres de las inversiones son los de la biblioteca (`Acorde.nombreDeLaInversion`).
            return Mensaje.traduccion { Acorde.nombreDeLaInversion(n, en: $0) }
        case .bajoAjeno:
            return TextosDeCLI.traducidos.map(\.mensajeBajoAjeno)
        case .sinAcordes:
            return TextosDeCLI.traducidos.map(\.mensajeSinAcordes)
        case .sin(let notas):
            return TextosDeCLI.traducidos.map { $0.mensajeSin(notas) }
        case .semitonos(let n):
            return TextosDeCLI.traducidos.map { $0.mensajeSemitonos(n) }
        case .sinAlteraciones:
            return TextosDeCLI.traducidos.map(\.mensajeSinAlteraciones)
        case .alteraciones(let n, let sostenidos):
            if sostenidos {
                return TextosDeCLI.traducidos.map { $0.mensajeSostenidos(n) }
            }
            return TextosDeCLI.traducidos.map { $0.mensajeBemoles(n) }
        case .aCuatroVoces:
            return TextosDeCLI.traducidos.map(\.mensajeACuatroVoces)
        case .sinDigitaciones:
            return TextosDeCLI.traducidos.map(\.mensajeSinDigitaciones)
        case .dedos(let n):
            return TextosDeCLI.traducidos.map { $0.mensajeDedos(n) }
        case .cejilla(let traste):
            return TextosDeCLI.traducidos.map { $0.mensajeCejilla(traste) }
        case .pasos(let n):
            switch n {
            case 0: return TextosDeCLI.traducidos.map(\.mensajeNingunPaso)
            case 1: return TextosDeCLI.traducidos.map(\.mensajeUnPaso)
            default: return TextosDeCLI.traducidos.map { $0.mensajePasos(n) }
            }
        case .triadas(let n):
            return TextosDeCLI.traducidos.map { $0.mensajeTriadas(n) }
        case .ciclo(let ciclo):
            return Traduccion(ciclo.nombre(en: .espanolUnicode), ciclo.nombre(en: .inglesASCII), ca: ciclo.nombre(en: .catalan),
                              gl: ciclo.nombre(en: .gallego), ast: ciclo.nombre(en: .asturiano),
                              an: ciclo.nombre(en: .aragones), eu: ciclo.nombre(en: .euskera), pt: ciclo.nombre(en: .portugues),
                              fr: ciclo.nombre(en: .frances), oc: ciclo.nombre(en: .occitano),
                              it: ciclo.nombre(en: .italiano), de: ciclo.nombre(en: .aleman),
                              el: ciclo.nombre(en: .griego), ru: ciclo.nombre(en: .ruso))
        case .instrumento(let encordado):
            // `--instrumento` acepta el nombre en cualquiera de los catorce idiomas.
            return Mensaje.traduccion { encordado.nombre(en: $0) }
        }
    }
}

extension Mensaje {
    /// Una `Traduccion` con el texto que da la biblioteca para cada idioma.
    static func traduccion(_ texto: (Notacion) -> String) -> Traduccion {
        Traduccion(texto(.espanolUnicode), texto(.inglesASCII), ca: texto(.catalan), gl: texto(.gallego), ast: texto(.asturiano),
                   an: texto(.aragones), eu: texto(.euskera), pt: texto(.portugues),
                   fr: texto(.frances), oc: texto(.occitano), it: texto(.italiano), de: texto(.aleman),
                   el: texto(.griego), ru: texto(.ruso))
    }
}
