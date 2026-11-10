import Armonia
import Exposicion

// El catálogo de acordes (`AcordeConNombre.catalogo`: los genéricos y después los de nombre propio, en su orden), una
// fila por acorde con lo que dice de él la API pública: nombres (y su traducción a los otros doce idiomas),
// intervalos, notas sobre Do, el cifrado y el nombre de su tipo de acorde, lo que se mide de él, estilos y las obras
// que lo citan. Las medidas son las de `MedidaDeAcorde.todas` que van al JSON, con su clave por columna y su valor en
// texto plano (`ValorDeMedida.textoPlano`): una medida nueva sale aquí sin tocar este fichero.

/// Las medidas, en el orden en que se leen.
private let medidasDeAcordes = MedidaDeAcorde.todas.filter(\.vaAlJSON)

/// Los nombres, como en la API: con ♭ y ♯ y en español.
private let notacionDeAcordes = Notacion.compacta(.espanol)

let columnasDeAcordes: [String] =
    ["nombre"] + traducciones.map { "nombre_en_\($0.rawValue)" } + [
        "alias", "variantes", "grupo", "intervalos", "semitonos", "notas_sobre_do", "cifrado", "nombre_del_tipo",
    ] + medidasDeAcordes.map(\.clave) + ["estilos", "referencias"]

private let genericos = Set(AcordeConNombre.genericos)

/// La fila de un acorde, en el orden de `columnasDeAcordes`.
func filaDeAcorde(_ acorde: AcordeConNombre) -> [String] {
    let comoSeLlama = [acorde.nombre] + traducciones.map { acorde.nombre(en: .delIdioma($0)) }
    let estadisticas = acorde.estadisticas
    let antes: [String] = [
        acorde.alias.joined(separator: " · "),
        acorde.variantes.joined(separator: " · "),
        genericos.contains(acorde) ? "genérico" : "nombre propio",
        acorde.intervalos.map(\.abreviatura).joined(separator: " "),
        acorde.intervalos.map { String($0.semitonos) }.joined(separator: " "),
        acorde.notas(sobre: .do).map(\.nombre).joined(separator: " "),
        acorde.tipo?.cifrado ?? "",
        acorde.tipo?.acordeConNombre?.nombre ?? "",
    ]
    // En `numeroDeNotas`, las notas distintas: el acorde de la Sinfonía de los salmos tiene cuatro voces y tres notas.
    let valores = medidasDeAcordes.map { $0.valor(de: estadisticas, en: notacionDeAcordes)?.textoPlano ?? "" }
    let despues = [
        acorde.estilos.map(\.nombre).joined(separator: " · "),
        acorde.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + antes + valores + despues
}

let acordes = Catalogo(
    fichero: "acordes.tsv", columnas: columnasDeAcordes, filas: AcordeConNombre.catalogo.map(filaDeAcorde),
    obras: AcordeConNombre.catalogo.flatMap(\.referencias))
