import Armonia
import ArmoniaPresentacion

// MARK: - Textos
//
// Lo que escribe la herramienta por su cuenta, en los quince idiomas de los textos: las
// etiquetas de la salida (`Mensaje`, en este archivo) y los errores de uso (`ErrorDeUso`, en
// ErrorDeUso.swift). Lo musical (notas, acordes, escalas…) no está aquí: lo traduce el motor
// con `Notacion`.
//
// Los textos están en `TextosDeCLI`, un idioma por fichero (`Textos/TextosDeCLI+Espanol.swift`…): cada
// fichero da todos los campos, así que un caso nuevo no compila hasta que tiene su texto en los quince. El idioma es el de la notación (`--ingles`, `--idioma eu`…).
// La ayuda (`LineaDeComandos.ayuda(en:)`) también está en los quince idiomas.
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
        case .notas: return TextosDeCLI.traduccion(\.mensajeNotas)
        case .acordes: return TextosDeCLI.traduccion(\.mensajeAcordes)
        case .escalas: return TextosDeCLI.traduccion(\.mensajeEscalas)
        case .armadura: return TextosDeCLI.traduccion(\.mensajeArmadura)
        case .relativa: return TextosDeCLI.traduccion(\.mensajeRelativa)
        case .homonima: return TextosDeCLI.traduccion(\.mensajeHomonima)
        case .bajo(let nota):
            return TextosDeCLI.traduccion { $0.mensajeBajo(nota) }
        case .inversion(let n):
            // Los nombres de las inversiones son los de la biblioteca (`Acorde.nombreDeLaInversion`).
            return Traduccion(cadaIdioma: { Acorde.nombreDeLaInversion(n, en: $0) })
        case .bajoAjeno:
            return TextosDeCLI.traduccion(\.mensajeBajoAjeno)
        case .sinAcordes:
            return TextosDeCLI.traduccion(\.mensajeSinAcordes)
        case .sin(let notas):
            return TextosDeCLI.traduccion { $0.mensajeSin(notas) }
        case .semitonos(let n):
            return TextosDeCLI.traduccion { $0.mensajeSemitonos(n) }
        case .sinAlteraciones:
            return TextosDeCLI.traduccion(\.mensajeSinAlteraciones)
        case .alteraciones(let n, let sostenidos):
            if sostenidos {
                return TextosDeCLI.traduccion { $0.mensajeSostenidos(n) }
            }
            return TextosDeCLI.traduccion { $0.mensajeBemoles(n) }
        case .aCuatroVoces:
            return TextosDeCLI.traduccion(\.mensajeACuatroVoces)
        case .sinDigitaciones:
            return TextosDeCLI.traduccion(\.mensajeSinDigitaciones)
        case .dedos(let n):
            return TextosDeCLI.traduccion { $0.mensajeDedos(n) }
        case .cejilla(let traste):
            return TextosDeCLI.traduccion { $0.mensajeCejilla(traste) }
        case .pasos(let n):
            switch n {
            case 0: return TextosDeCLI.traduccion(\.mensajeNingunPaso)
            case 1: return TextosDeCLI.traduccion(\.mensajeUnPaso)
            default: return TextosDeCLI.traduccion { $0.mensajePasos(n) }
            }
        case .triadas(let n):
            return TextosDeCLI.traduccion { $0.mensajeTriadas(n) }
        case .ciclo(let ciclo):
            return Traduccion(cadaIdioma: { ciclo.nombre(en: $0) })
        case .instrumento(let encordado):
            // `--instrumento` acepta el nombre en cualquiera de los quince idiomas.
            return Traduccion(cadaIdioma: { encordado.nombre(en: $0) })
        }
    }
}
