import Armonia
import ExposicionArmonia

// El catálogo de acordes (`AcordeConNombre.catalogo`: los genéricos y después los de nombre propio, en su orden), una
// fila por acorde con lo que dice de él la API pública: nombres (y su traducción a los otros doce idiomas),
// intervalos, notas sobre Do, el cifrado y el nombre de su tipo de acorde, lo que se mide de él, estilos y las obras
// que lo citan. Las medidas son las de `MedidaDeAcorde.todas` que van al JSON, con su clave en snake_case por columna
// y su valor en texto plano (`ValorDeMedida.textoPlano`): una medida nueva sale aquí sin tocar este fichero.

/// Las medidas, en el orden en que se leen.
private let medidasDeAcordes = MedidaDeAcorde.todas.filter(\.vaAlJSON)

/// Los nombres, como en la API: con ♭ y ♯ y en español.
private let notacionDeAcordes = Notacion.compacta(.espanol)

private let columnasDeLosNombresDeAcordes: [String] = columnasDeNombres + columnasDeAliasYVariantes
private let columnasDeLaFichaDeAcordes: [String] = [
    "grupo", "intervalos", "semitonos", "notas_sobre_do", "cifrado", "nombre_del_tipo",
    "escala_del_cifrado", "escalas_compatibles",
]
// Por partes: en una sola expresión, Swift 6.0 no termina de comprobar los tipos.
private let columnasDeLasMedidasDeAcordes: [String] = medidasDeAcordes.map { enSnakeCase($0.clave) }
private let columnasDelOrigenDeAcordes: [String] = columnasDeLugaresSinTradicion + columnasDeLaFecha
let columnasDeAcordes: [String] =
    columnasDeLosNombresDeAcordes + columnasDeLaFichaDeAcordes + columnasDeLasMedidasDeAcordes
    + columnasDelOrigenDeAcordes + ["epocas_de_uso"] + columnasDelCaracter + ["estilos", "referencias"]

private let genericos = Set(AcordeConNombre.genericos)

/// La fila de un acorde, en el orden de `columnasDeAcordes`.
func filaDeAcorde(_ acorde: AcordeConNombre) -> [String] {
    let comoSeLlama = nombres(de: acorde)
    let estadisticas = acorde.estadisticas
    let otros: [String] = aliasYVariantes(de: acorde)
    let ficha: [String] = [
        genericos.contains(acorde) ? "genérico" : "nombre propio",
        acorde.intervalos.map(\.abreviatura).joined(separator: " "),
        acorde.intervalos.map { String($0.semitonos) }.joined(separator: " "),
        acorde.notas(sobre: .do).map(\.nombre).joined(separator: " "),
        acorde.tipo?.cifrado ?? "",
        acorde.tipo?.acordeConNombre?.nombre ?? "",
        acorde.tipo.flatMap { TipoDeEscala.delCifrado($0.estructura)?.nombre } ?? "",
        // Sobre Do, de la que mejor le va a la que peor (`Acorde.escalasCompatibles(entre:)`).
        acorde.tipo.map { Acorde(.do, $0).escalasCompatibles().map(\.nombre).joined(separator: " · ") } ?? "",
    ]
    let antes: [String] = otros + ficha
    // En `numero_de_notas`, las notas distintas: el acorde de la Sinfonía de los salmos tiene cuatro voces y tres
    // notas.
    let valores = medidasDeAcordes.map { $0.valor(de: estadisticas, en: notacionDeAcordes)?.textoPlano ?? "" }
    let despues = [
        acorde.estilos.map(\.nombre).joined(separator: " · "),
        acorde.referencias.map(\.cita).joined(separator: " · "),
    ]
    let deDonde = lugares(nil, acorde.lugaresDeOrigen, acorde.paisesDeOrigen, acorde.continentesDeOrigen).dropFirst()
    let epocas = acorde.epocasDeUso.map(\.nombre).joined(separator: " · ")
    return comoSeLlama + antes + valores + Array(deDonde) + fecha(de: acorde) + [epocas] + caracter(de: acorde)
        + despues
}

let acordes = Catalogo(
    fichero: "acordes.tsv", columnas: columnasDeAcordes, filas: AcordeConNombre.catalogo.map(filaDeAcorde),
    obras: AcordeConNombre.catalogo.flatMap(\.referencias))
