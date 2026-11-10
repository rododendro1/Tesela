import Armonia
import Foundation

// Recorre `TipoDeEscala.catalogo` (las occidentales y las de otras tradiciones, en su orden) y escribe una fila por
// escala con lo que dice de ella la API pública: nombres (y su traducción a los otros doce idiomas), intervalos, tradición, estilos, regiones, categoría,
// fuente, afinaciones, lo que se mide de sus notas (brillo, pasos, forma prima, simetría…), sus parientes en el
// catálogo y las obras que la citan. Las listas de una celda van separadas por espacios (intervalos, notas, cents,
// pasos) o por « · » (alias, variantes, estilos, regiones, escalas, citas); una celda vacía es un dato que la escala
// no tiene, y las de sí o no dicen «sí» o «no».
//
//     swift run EjemploCatalogoDeEscalas [fichero | -] [--tradicion <tradición>] [--bibtex <fichero.bib>]
//
// `--tradicion` deja solo las escalas de una tradición, por su nombre («india», «mundoArabe», «Japón»), y `--bibtex`
// escribe además las obras citadas por las escalas de la tabla, sin repetir, en BibTeX.

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

/// Los cents con un decimal como mucho y punto decimal, sea cual sea la configuración regional: «0 151 294.1».
func cents(_ valores: [Double]) -> String {
    valores.map { Redondeo.texto($0, decimales: 1) }.joined(separator: " ")
}

/// Un número con dos decimales como mucho y punto decimal: «2», «-0.43».
func decimal(_ valor: Double) -> String { Redondeo.texto(valor, decimales: 2) }

/// Con tres decimales como mucho.
func milesimas(_ valor: Double) -> String { Redondeo.texto(valor) }

func siONo(_ valor: Bool) -> String { valor ? "sí" : "no" }

func numeros(_ valores: [Int]) -> String { valores.map(String.init).joined(separator: " ") }

func nombres(_ tipos: [TipoDeEscala]) -> String { tipos.map(\.nombre).joined(separator: " · ") }

/// Los idiomas a los que se traduce el nombre, en el orden de `Idioma.allCases`: todos menos el español.
let traducciones = Idioma.allCases.filter { $0 != .espanol }

let columnas: [String] =
    ["nombre", "nombre_completo"] + traducciones.map { "nombre_en_\($0.rawValue)" } + [
        "alias", "variantes", "tradicion", "estilos", "regiones", "categoria", "clase", "fuente", "numero_de_notas",
        "intervalos", "semitonos", "intervalos_descendentes", "notas_sobre_do",
        "melakarta", "padre", "afinaciones", "sistema_microtonal", "cents",
        // Lo que se mide de sus notas, sobre Do (`EstadisticasDeEscala`).
        "cardinal", "pasos", "brillo", "brillo_por_quintas", "forma_prima", "forte", "vector_intervalico",
        "nombre_del_conjunto", "anhemitonica", "cohemitonica", "maximamente_regular", "transposiciones_distintas",
        "aproximada", "nota_caracteristica",
        // Lo que dicen las teorías de escalas.
        "myhill", "generador", "bien_formada", "rothenberg", "ambiguedades", "contradicciones", "estabilidad",
        "cociente_de_igualdad", "anchura_del_espectro", "profunda", "consonancia_diadica", "fourier", "equilibrada",
        "uniformidad", "triadas", "hanson", "modo_de_messiaen", "simetrica_por_inversion", "pareja_z", "complemento",
        "imperfecciones", "unicidad", "simplicidad", "triadas_por_grados", "cuatriadas_por_grados", "combinatoriedad",
        "entropia_intervalica", "parsimonia", "gradus", "altura_de_tenney", "limite_impar", "entropia_armonica",
        "rugosidad_media", "perfil_mayor", "perfil_menor", "con_sensible", "tetracordos_iguales",
        // Sus parientes en el catálogo y las obras que la citan.
        "equivalentes", "derivadas", "referencias",
    ]

/// La fila de una escala, en el orden de `columnas`.
func fila(_ tipo: TipoDeEscala) -> [String] {
    let microtonal = tipo.microtonal
    let sobreDo = Escala(.do, tipo)
    let medidas = sobreDo.estadisticas
    let conjunto = sobreDo.conjuntoDeClasesDeAltura
    let comoSeLlama = [tipo.nombre, tipo.nombreCompleto] + traducciones.map { tipo.nombre(en: .delIdioma($0)) }
    let resto: [String] = [
        tipo.alias.joined(separator: " · "),
        tipo.variantes.joined(separator: " · "),
        tipo.tradicion?.nombre ?? "",
        tipo.estilos.map(\.nombre).joined(separator: " · "),
        tipo.regiones.map(\.nombre).joined(separator: " · "),
        tipo.categoria?.nombre ?? "",
        tipo.clase?.rawValue ?? "",
        tipo.fuente?.nombre ?? "",
        String(tipo.numeroDeNotas),
        tipo.intervalos.map(\.abreviatura).joined(separator: " "),
        numeros(tipo.intervalos.map(\.semitonos)),
        tipo.intervalosDescendentes?.map(\.abreviatura).joined(separator: " ") ?? "",
        sobreDo.notas.map(\.nombre).joined(separator: " "),
        tipo.numeroDeMelakarta.map(String.init) ?? "",
        tipo.padre?.nombre ?? "",
        String(tipo.afinaciones.count),
        microtonal?.sistema.rawValue ?? "",
        microtonal.map { cents($0.cents) } ?? "",

        medidas.cardinal?.nombre ?? "",
        numeros(medidas.pasos),
        medidas.brillo.map(String.init) ?? "",
        decimal(medidas.brilloPorQuintas),
        numeros(conjunto.formaPrima),
        medidas.numeroDeForte ?? "",
        numeros(medidas.vectorIntervalico),
        conjunto.nombreComun ?? "",
        siONo(medidas.anhemitonica),
        siONo(medidas.cohemitonica),
        siONo(medidas.maximamenteRegular),
        String(medidas.transposicionesDistintas),
        siONo(medidas.aproximada),
        sobreDo.notaCaracteristica?.nombre ?? "",

        siONo(medidas.intervalosGenericos.propiedadDeMyhill),
        medidas.intervalosGenericos.generador.map(String.init) ?? "",
        siONo(medidas.intervalosGenericos.bienFormada),
        medidas.intervalosGenericos.propiedadDeRothenberg.rawValue,
        String(medidas.intervalosGenericos.ambiguedades),
        String(medidas.intervalosGenericos.contradicciones),
        milesimas(medidas.intervalosGenericos.estabilidad),
        milesimas(medidas.intervalosGenericos.cocienteDeIgualdad),
        milesimas(medidas.intervalosGenericos.anchuraDelEspectro),
        siONo(medidas.conjunto.profundo),
        milesimas(medidas.conjunto.consonanciaDiadica),
        medidas.conjunto.magnitudesDeFourier.map(milesimas).joined(separator: " "),
        siONo(medidas.conjunto.equilibrado),
        milesimas(medidas.conjunto.distanciaALaUniformidad),
        numeros([
            medidas.conjunto.triadasContenidas.mayores, medidas.conjunto.triadasContenidas.menores,
            medidas.conjunto.triadasContenidas.disminuidas,
            medidas.conjunto.triadasContenidas.aumentadas,
        ]),
        medidas.conjunto.analisisDeHanson,
        medidas.conjunto.modoDeMessiaen.map(String.init) ?? "",
        siONo(medidas.conjunto.simetricoPorInversion),
        medidas.conjunto.parejaZ ?? "",
        medidas.conjunto.complemento ?? "",
        String(medidas.conjunto.imperfecciones),
        siONo(medidas.conjunto.unicidad),
        siONo(medidas.conjunto.simplicidad),
        medidas.tonal.triadasPorGrados?.joined(separator: " ") ?? "",
        medidas.tonal.cuatriadasPorGrados?.joined(separator: " ") ?? "",
        medidas.conjunto.combinatoriedad.map { c in
            (c.transposiciones.map { "T\($0)" } + c.inversiones.map { "I\($0)" }).joined(separator: " ")
                + (c.tipo.map { " (\($0))" } ?? "")
        } ?? "",
        milesimas(medidas.conjunto.entropiaIntervalica),
        String(medidas.conjunto.parsimonia),
        String(medidas.afinacion.gradoDeSuavidad),
        milesimas(medidas.afinacion.alturaDeTenney),
        String(medidas.afinacion.limiteImpar),
        milesimas(medidas.psicoacustica.entropiaArmonica),
        milesimas(medidas.psicoacustica.rugosidadMedia),
        milesimas(medidas.tonal.perfilMayor),
        milesimas(medidas.tonal.perfilMenor),
        siONo(medidas.tonal.conSensible),
        siONo(medidas.tonal.tetracordosIguales),

        nombres(tipo.equivalentes),
        nombres(tipo.derivadas),
        tipo.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + resto
}

// MARK: - Argumentos

/// Termina con un mensaje en la salida de errores.
func fallar(_ mensaje: String) -> Never {
    FileHandle.standardError.write(Data((mensaje + "\n").utf8))
    exit(1)
}

/// La tradición de un nombre, sin mirar mayúsculas ni tildes: el del caso («mundoArabe») o el que se lee («Japón»).
func tradicion(llamada nombre: String) -> Tradicion? {
    func clave(_ texto: String) -> String {
        texto.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).filter { !$0.isWhitespace }
    }
    return Tradicion.allCases.first { clave($0.rawValue) == clave(nombre) || clave($0.nombre) == clave(nombre) }
}

var destino = "catalogo-de-escalas.tsv"
var soloDe: Tradicion?
var destinoBibTeX: String?
var argumentos = CommandLine.arguments.dropFirst()
while let argumento = argumentos.popFirst() {
    switch argumento {
    case "--tradicion":
        guard let nombre = argumentos.popFirst() else { fallar("Falta la tradición después de --tradicion") }
        guard let elegida = tradicion(llamada: nombre) else {
            fallar(
                "«\(nombre)» no es una tradición; son: \(Tradicion.allCases.map(\.rawValue).joined(separator: ", "))")
        }
        soloDe = elegida
    case "--bibtex":
        guard let fichero = argumentos.popFirst() else { fallar("Falta el fichero después de --bibtex") }
        destinoBibTeX = fichero
    default:
        destino = argumento
    }
}

// MARK: - Salida

let escalas = TipoDeEscala.catalogo.filter { soloDe == nil || $0.tradicion == soloDe }
let filas = [columnas] + escalas.map(fila)
let tsv = filas.map { $0.map(celda).joined(separator: "\t") }.joined(separator: "\n") + "\n"

/// Escribe un texto en un fichero, o en la salida estándar si el fichero es «-».
func escribir(_ texto: String, en fichero: String) {
    if fichero == "-" {
        print(texto, terminator: "")
        return
    }
    do {
        try texto.write(toFile: fichero, atomically: true, encoding: .utf8)
    } catch {
        fallar("No se pudo escribir \(fichero): \(error)")
    }
}

func lugar(_ fichero: String) -> String { fichero == "-" ? "la salida estándar" : fichero }

var resumen = ["\(escalas.count) escalas en \(lugar(destino))"]
escribir(tsv, en: destino)
if let destinoBibTeX {
    let obras = Referencia.sinRepetir(escalas.flatMap(\.referencias))
    escribir(Referencia.bibtex(obras), en: destinoBibTeX)
    resumen.append("\(obras.count) obras en \(lugar(destinoBibTeX))")
}
// Con algo en la salida estándar, el resumen va a la de errores para no mezclarse con ello.
let texto = resumen.joined(separator: "\n") + "\n"
if destino == "-" || destinoBibTeX == "-" {
    FileHandle.standardError.write(Data(texto.utf8))
} else {
    print(texto, terminator: "")
}
