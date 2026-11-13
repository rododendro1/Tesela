import Armonia
import Exposicion

// MARK: - Textos
//
// Lo que escribe la herramienta por su cuenta, en los trece idiomas de los textos: las
// etiquetas de la salida (`Mensaje`, en este archivo) y los errores de uso (`ErrorDeUso`, en
// ErrorDeUso.swift). Lo musical (notas, acordes, escalas…) no está aquí: lo traduce el motor
// con `Notacion`.
//
// Los textos están en `TextosDeConsola`, un idioma por fichero (`Textos/TextosDeConsola+Espanol.swift`…): cada
// fichero da todos los campos, así que un caso nuevo no compila hasta que tiene su texto en los trece. El idioma es el de la notación (`--ingles`, `--idioma eu`…).
// La ayuda (`LineaDeComandos.ayuda(en:)`) también está en los trece idiomas.
// Los avisos del coral (sin armonización, sin faltas…) los comparte con las apps: son
// `CoralPresentado.Aviso`, en `Exposicion`.

/// Las piezas de texto de la salida de las órdenes.
enum Mensaje {
    case notas
    case acordes
    case microtonos
    case referencias
    case caracter
    case escalas
    case habituales
    case sinLugar
    case sinEpoca
    case ningunaEscala
    case ningunaProgresion
    case ningunRitmo
    case ningunTemperamento
    case ningunaNota
    case ningunaFuncion
    case ningunAcorde
    case tetracordos
    case sinTetracordos
    case ajnas
    case armadura
    case relativa
    case homonima
    case bajo(String)
    case mela(Int, CakraDeMela, mnemonico: String, solfa: String)
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
    case formaNormal
    case formaPrima
    case vectorIntervalico
    case vectorDeIndice
    case ejesDeSimetria
    case intervalos
    case deTodosLosIntervalos
    case formasDistintas(Int)
    case hexacordos
    case formasCombinatorias

    func texto(en notacion: Notacion) -> String {
        traduccion.en(notacion)
    }

    var traduccion: Traduccion {
        switch self {
        case .notas: return TextosDeConsola.traduccion(\.mensajeNotas)
        case .acordes: return TextosDeConsola.traduccion(\.mensajeAcordes)
        case .microtonos: return TextosDeConsola.traduccion(\.mensajeMicrotonos)
        case .referencias: return TextosDeConsola.traduccion(\.mensajeReferencias)
        case .caracter: return TextosDeConsola.traduccion(\.mensajeCaracter)
        case .escalas: return TextosDeConsola.traduccion(\.mensajeEscalas)
        case .habituales: return TextosDeConsola.traduccion(\.mensajeHabituales)
        case .sinLugar: return TextosDeConsola.traduccion(\.mensajeSinLugar)
        case .sinEpoca: return TextosDeConsola.traduccion(\.mensajeSinEpoca)
        case .ningunaEscala: return TextosDeConsola.traduccion(\.mensajeNingunaEscala)
        case .ningunaProgresion: return TextosDeConsola.traduccion(\.mensajeNingunaProgresion)
        case .ningunRitmo: return TextosDeConsola.traduccion(\.mensajeNingunRitmo)
        case .ningunTemperamento: return TextosDeConsola.traduccion(\.mensajeNingunTemperamento)
        case .ningunaNota: return TextosDeConsola.traduccion(\.mensajeNingunaNota)
        case .ningunaFuncion: return TextosDeConsola.traduccion(\.mensajeNingunaFuncion)
        case .ningunAcorde: return TextosDeConsola.traduccion(\.mensajeNingunAcorde)
        case .tetracordos: return TextosDeConsola.traduccion(\.mensajeTetracordos)
        case .sinTetracordos: return TextosDeConsola.traduccion(\.mensajeSinTetracordos)
        case .ajnas: return TextosDeConsola.traduccion(\.mensajeAjnas)
        case .armadura: return TextosDeConsola.traduccion(\.mensajeArmadura)
        case .relativa: return TextosDeConsola.traduccion(\.mensajeRelativa)
        case .homonima: return TextosDeConsola.traduccion(\.mensajeHomonima)
        case .bajo(let nota):
            return TextosDeConsola.traduccion { $0.mensajeBajo(nota) }
        case .mela(let numero, let cakra, let mnemonico, let solfa):
            return TextosDeConsola.traduccion { $0.mensajeMela(numero, cakra.numero, cakra.nombre, mnemonico, solfa) }
        case .inversion(let n):
            // Los nombres de las inversiones son los de la biblioteca (`Acorde.nombreDeLaInversion`).
            return Traduccion(cadaIdioma: { Acorde.nombreDeLaInversion(n, en: $0) })
        case .bajoAjeno:
            return TextosDeConsola.traduccion(\.mensajeBajoAjeno)
        case .sinAcordes:
            return TextosDeConsola.traduccion(\.mensajeSinAcordes)
        case .sin(let notas):
            return TextosDeConsola.traduccion { $0.mensajeSin(notas) }
        case .semitonos(let n):
            return TextosDeConsola.traduccion { $0.mensajeSemitonos(n) }
        case .sinAlteraciones:
            return TextosDeConsola.traduccion(\.mensajeSinAlteraciones)
        case .alteraciones(let n, let sostenidos):
            if sostenidos {
                return TextosDeConsola.traduccion { $0.mensajeSostenidos(n) }
            }
            return TextosDeConsola.traduccion { $0.mensajeBemoles(n) }
        case .aCuatroVoces:
            return TextosDeConsola.traduccion(\.mensajeACuatroVoces)
        case .sinDigitaciones:
            return TextosDeConsola.traduccion(\.mensajeSinDigitaciones)
        case .dedos(let n):
            return TextosDeConsola.traduccion { $0.mensajeDedos(n) }
        case .cejilla(let traste):
            return TextosDeConsola.traduccion { $0.mensajeCejilla(traste) }
        case .pasos(let n):
            switch n {
            case 0: return TextosDeConsola.traduccion(\.mensajeNingunPaso)
            case 1: return TextosDeConsola.traduccion(\.mensajeUnPaso)
            default: return TextosDeConsola.traduccion { $0.mensajePasos(n) }
            }
        case .triadas(let n):
            return TextosDeConsola.traduccion { $0.mensajeTriadas(n) }
        case .ciclo(let ciclo):
            return Traduccion(cadaIdioma: { ciclo.nombre(en: $0) })
        case .instrumento(let encordado):
            // `--instrumento` acepta el nombre en cualquiera de los trece idiomas.
            return Traduccion(cadaIdioma: { encordado.nombre(en: $0) })
        case .formaNormal: return TextosDeConsola.traduccion(\.mensajeFormaNormal)
        case .formaPrima: return TextosDeConsola.traduccion(\.mensajeFormaPrima)
        case .vectorIntervalico: return TextosDeConsola.traduccion(\.mensajeVectorIntervalico)
        case .vectorDeIndice: return TextosDeConsola.traduccion(\.mensajeVectorDeIndice)
        case .ejesDeSimetria: return TextosDeConsola.traduccion(\.mensajeEjesDeSimetria)
        case .intervalos: return TextosDeConsola.traduccion(\.mensajeIntervalos)
        case .deTodosLosIntervalos: return TextosDeConsola.traduccion(\.mensajeDeTodosLosIntervalos)
        case .formasDistintas(let n): return TextosDeConsola.traduccion { $0.mensajeFormasDistintas(n) }
        case .hexacordos: return TextosDeConsola.traduccion(\.mensajeHexacordos)
        case .formasCombinatorias: return TextosDeConsola.traduccion(\.mensajeFormasCombinatorias)
        }
    }
}
