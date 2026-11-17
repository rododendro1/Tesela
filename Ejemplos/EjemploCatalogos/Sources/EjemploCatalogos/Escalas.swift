import Armonia
import Foundation

// El catálogo de escalas (`TipoDeEscala.catalogo`: las occidentales y las de otras tradiciones, en su orden), una fila
// por escala con lo que dice de ella la API pública: nombres, nombres en su escritura original, alias y variantes
// (también en los otros doce idiomas), intervalos, tradición, estilos, regiones, lugares, año y épocas, la obra que
// documenta el nombre, categoría, fuente, afinaciones, lo que se mide de sus notas (brillo, pasos, forma prima,
// simetría…), sus parientes en el catálogo y las obras que la citan.

/// Los cents con un decimal como mucho y punto decimal, sea cual sea la configuración regional: «0 151 294.1».
private func cents(_ valores: [Double]) -> String {
    valores.map { Redondeo.texto($0, decimales: 1) }.joined(separator: " ")
}

/// Un número con dos decimales como mucho y punto decimal: «2», «-0.43».
private func decimal(_ valor: Double) -> String { Redondeo.texto(valor, decimales: 2) }

/// Con tres decimales como mucho.
private func milesimas(_ valor: Double) -> String { Redondeo.texto(valor) }

private func numeros(_ valores: [Int]) -> String { valores.map(String.init).joined(separator: " ") }

private func nombres(_ tipos: [TipoDeEscala]) -> String { tipos.map(\.nombre).joined(separator: " · ") }

/// Las columnas de los nombres, de la tradición y de los lugares, antes de la fecha.
private let columnasDeEscalasAntesDeLaFecha: [String] =
    [
        "nombre", "nombre_completo", "nombres_originales", "nombres_originales_completos",
        "idiomas_de_los_nombres_originales",
    ]
    + traducciones.map { "nombre_en_\($0.rawValue)" } + columnasDeAliasYVariantes + [
        "tradicion", "estilos", "regiones", "lugares_de_origen", "paises_de_origen",
        "continentes_de_origen", "lugares_de_uso",
    ]

let columnasDeEscalas: [String] = columnasDeEscalasAntesDeLaFecha + columnasDeLaFecha + columnasDeEscalasTrasLaFecha

/// Las columnas de después de la fecha: la ficha, lo que se mide, el carácter y los parientes.
private let columnasDeEscalasTrasLaFecha: [String] =
    [
        "epocas_de_uso", "categoria", "clase", "fuente", "numero_de_notas",
        "intervalos", "semitonos", "intervalos_descendentes", "notas_sobre_do",
        // Los rāgas vakra, en el orden en que se tocan sobre Do, y las notas que no son de su mēḷa.
        "es_vakra", "recorrido", "recorrido_descendente", "notas_externas",
        "numero_de_melakarta", "mnemonico_de_melakarta", "cakra", "solfa_de_melakarta", "madre", "afinaciones",
        "sistema_microtonal", "cents",
        // Lo que se mide de sus notas, sobre Do (`EstadisticasDeEscala`).
        "cardinal", "pasos", "brillo", "brillo_por_quintas", "forma_prima", "forte", "vector_intervalico",
        "nombre_del_conjunto", "anhemitonica", "cohemitonica", "maximamente_regular", "transposiciones_distintas",
        "aproximada", "nota_caracteristica",
        // Lo que dicen las teorías de escalas.
        "myhill", "generador", "bien_formada", "rothenberg", "ambiguedades", "contradicciones", "estabilidad",
        "cociente_de_igualdad", "anchura_del_espectro", "profunda", "consonancia_diadica", "fourier", "equilibrada",
        "uniformidad", "triadas", "hanson", "modo_de_messiaen", "simetrica_por_inversion", "pareja_z", "complemento",
        "imperfecciones", "unicidad", "simplicidad", "triadas_por_grados", "cuatriadas_por_grados",
        "cuatriadas_por_cuartas", "tensiones_por_grados", "combinatoriedad",
        "entropia_intervalica", "parsimonia", "gradus", "altura_de_tenney", "limite_impar", "entropia_armonica",
        "rugosidad_media", "perfil_mayor", "perfil_menor", "con_sensible", "tetracordos_iguales",
        // Su carácter: los afectos, los momentos del día y lo que dice cada fuente, con su cita.
        "afectos", "momentos", "caracter",
        // Sus parientes en el catálogo y las obras que la citan.
        "equivalentes", "derivadas", "referencias",
    ]

/// Los acordes de los grados, separados por espacios; «?» en el que no forma un tipo conocido.
private func acordesDeLosGrados(_ acordes: [Acorde?]) -> String {
    acordes.map { $0?.cifrado ?? "?" }.joined(separator: " ")
}

/// Los acordes de los grados con su fundamental (los tipos de `EstadisticasTonalesDeEscala`, sobre cada grado).
private func acordesDeLosGrados(_ tipos: [TipoDeAcorde?], de escala: Escala) -> String {
    acordesDeLosGrados(tipos.enumerated().map { i, tipo in tipo.map { Acorde(escala.grado(i + 1), $0) } })
}

/// Las tensiones disponibles de cada grado (`Escala.gradosArmonizados`): las de un grado separadas por
/// espacios, los grados por « · »; «?» en el que no tiene cuatríada y «—» en el que no tiene tensiones.
private func tensionesPorGrados(de escala: Escala) -> String {
    escala.gradosArmonizados.map { grado in
        guard grado.acorde != nil else { return "?" }
        return grado.tensiones.isEmpty ? "—" : grado.tensiones.map(\.cifra).joined(separator: " ")
    }.joined(separator: " · ")
}

/// La fila de una escala, en el orden de `columnasDeEscalas`.
func filaDeTipoDeEscala(_ tipo: TipoDeEscala) -> [String] {
    // En el orden de `columnasDelCaracter`.
    let delCaracter = caracter(de: tipo)
    let microtonal = tipo.afinacionPropia
    let sobreDo = Escala(.do, tipo)
    let estadisticas = sobreDo.estadisticas
    // Un fragmento no se repite a la octava: no se armoniza.
    let tieneAcordes = !tipo.esFragmento
    let conjunto = sobreDo.conjuntoDeClasesDeAltura
    // Su mēḷa: el suyo si es heptatónica y encaja en uno, y si no, el de la madre, cuando la madre es un mēḷa.
    // Las notas sobre Do en el orden del recorrido: «Do Mi♭ Re Mi♭ Fa Sol La Sol Do».
    func recorrido(_ sentido: SentidoDelIntervalo) -> String {
        sobreDo.alturas(octava: 4, sentido: sentido).map(\.nota.nombre).joined(separator: " ")
    }
    let mela = tipo.numeroDeMelakarta != nil ? tipo : tipo.madre.flatMap { $0.categoria == .melakarta ? $0 : nil }
    let comoSeLlama =
        [
            tipo.nombre, tipo.nombreCompleto, tipo.nombresOriginales.map(\.texto).joined(separator: " · "),
            tipo.nombresOriginalesCompletos.map(\.texto).joined(separator: " · "),
            tipo.nombresOriginales.map(\.idioma.codigo).joined(separator: " · "),
        ] + traducciones.map { tipo.nombre(en: .delIdioma($0)) }
    let otros: [String] = aliasYVariantes(de: tipo)
    let deDondeEs: [String] = [
        tipo.tradicion?.nombre ?? "",
        tipo.estilos.map(\.nombre).joined(separator: " · "),
        tipo.regiones.map(\.nombre).joined(separator: " · "),
        tipo.lugaresDeOrigen.map(\.nombre).joined(separator: " · "),
        tipo.paisesDeOrigen.map(\.codigoISO).joined(separator: " "),
        tipo.continentesDeOrigen.map(\.nombre).joined(separator: " · "),
        tipo.lugaresDeUso.map(\.nombre).joined(separator: " · "),
    ]
    let resto: [String] = [
        tipo.epocasDeUso.map(\.nombre).joined(separator: " · "),
        tipo.categoria?.nombre ?? "",
        tipo.clase?.rawValue ?? "",
        tipo.fuente?.nombre ?? "",
        String(tipo.numeroDeNotas),
        tipo.intervalos.map(\.abreviatura).joined(separator: " "),
        numeros(tipo.intervalos.map(\.semitonos)),
        tipo.intervalosDescendentes?.map(\.abreviatura).joined(separator: " ") ?? "",
        sobreDo.notas.map(\.nombre).joined(separator: " "),
        siONo(tipo.esVakra),
        tipo.recorrido == nil ? "" : recorrido(.ascendente),
        tipo.recorridoDescendente == nil ? "" : recorrido(.descendente),
        tipo.notasExternas.map(\.abreviatura).joined(separator: " "),
        mela.flatMap(\.numeroDeMelakarta).map(String.init) ?? "",
        mela?.mnemonicoDeMela ?? "",
        mela?.cakra?.nombre ?? "",
        mela?.solfaDeMela?.joined(separator: " ") ?? "",
        tipo.madre?.nombre ?? "",
        String(tipo.afinaciones.count),
        microtonal?.sistema.rawValue ?? "",
        microtonal.map { cents($0.cents) } ?? "",

        estadisticas.cardinal?.nombre ?? "",
        numeros(estadisticas.pasos),
        estadisticas.brillo.map(String.init) ?? "",
        decimal(estadisticas.brilloPorQuintas),
        numeros(conjunto.formaPrima),
        estadisticas.numeroDeForte ?? "",
        numeros(estadisticas.vectorIntervalico),
        conjunto.nombreComun ?? "",
        siONo(estadisticas.anhemitonica),
        siONo(estadisticas.cohemitonica),
        siONo(estadisticas.maximamenteRegular),
        String(estadisticas.transposicionesDistintas),
        siONo(estadisticas.aproximada),
        sobreDo.notaCaracteristica?.nombre ?? "",

        siONo(estadisticas.intervalosGenericos.propiedadDeMyhill),
        estadisticas.intervalosGenericos.generador.map(String.init) ?? "",
        siONo(estadisticas.intervalosGenericos.bienFormada),
        estadisticas.intervalosGenericos.propiedadDeRothenberg.rawValue,
        String(estadisticas.intervalosGenericos.ambiguedades),
        String(estadisticas.intervalosGenericos.contradicciones),
        milesimas(estadisticas.intervalosGenericos.estabilidad),
        milesimas(estadisticas.intervalosGenericos.cocienteDeIgualdad),
        milesimas(estadisticas.intervalosGenericos.anchuraDelEspectro),
        siONo(estadisticas.conjunto.profundo),
        milesimas(estadisticas.conjunto.consonanciaDiadica),
        estadisticas.conjunto.magnitudesDeFourier.map(milesimas).joined(separator: " "),
        siONo(estadisticas.conjunto.equilibrado),
        milesimas(estadisticas.conjunto.distanciaALaUniformidad),
        numeros([
            estadisticas.conjunto.triadasContenidas.mayores, estadisticas.conjunto.triadasContenidas.menores,
            estadisticas.conjunto.triadasContenidas.disminuidas,
            estadisticas.conjunto.triadasContenidas.aumentadas,
        ]),
        estadisticas.conjunto.analisisDeHanson,
        estadisticas.conjunto.modoDeMessiaen.map(String.init) ?? "",
        siONo(estadisticas.conjunto.simetricoPorInversion),
        estadisticas.conjunto.parejaZ ?? "",
        estadisticas.conjunto.complemento ?? "",
        String(estadisticas.conjunto.imperfecciones),
        siONo(estadisticas.conjunto.unicidad),
        siONo(estadisticas.conjunto.simplicidad),
        // Los acordes de cada grado sobre Do, con su fundamental: con el tipo solo, la tríada mayor no se vería (su
        // cifrado es «»).
        estadisticas.tonal.triadas.map { acordesDeLosGrados($0, de: sobreDo) } ?? "",
        estadisticas.tonal.cuatriadas.map { acordesDeLosGrados($0, de: sobreDo) } ?? "",
        tieneAcordes ? acordesDeLosGrados(sobreDo.acordesDeLosGrados(deNotas: 4, por: .cuartas)) : "",
        tieneAcordes ? tensionesPorGrados(de: sobreDo) : "",
        estadisticas.conjunto.combinatoriedad.map { c in
            (c.transposiciones.map { "T\($0)" } + c.inversiones.map { "I\($0)" }).joined(separator: " ")
                + (c.tipo.map { " (\($0))" } ?? "")
        } ?? "",
        milesimas(estadisticas.conjunto.entropiaIntervalica),
        String(estadisticas.conjunto.parsimonia),
        String(estadisticas.afinacion.gradoDeSuavidad),
        milesimas(estadisticas.afinacion.alturaDeTenney),
        String(estadisticas.afinacion.limiteImpar),
        milesimas(estadisticas.psicoacustica.entropiaArmonica),
        milesimas(estadisticas.psicoacustica.rugosidadMedia),
        milesimas(estadisticas.tonal.perfilMayor),
        milesimas(estadisticas.tonal.perfilMenor),
        siONo(estadisticas.tonal.conSensible),
        siONo(estadisticas.tonal.tetracordosIguales),

        delCaracter[0], delCaracter[1], delCaracter[2],

        nombres(tipo.equivalentes),
        nombres(tipo.derivadas),
        tipo.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + otros + deDondeEs + fecha(de: tipo) + resto
}

/// Las escalas del catálogo, o solo las de una tradición.
func escalas(de tradicion: Tradicion?) -> Catalogo {
    let tipos = TipoDeEscala.catalogo.filter { tradicion == nil || $0.tradicion == tradicion }
    return Catalogo(
        fichero: "escalas.tsv", columnas: columnasDeEscalas, filas: tipos.map(filaDeTipoDeEscala),
        obras: tipos.flatMap(\.referencias))
}

/// La tradición de un nombre, sin mirar mayúsculas ni tildes: el del caso («mundoArabe») o el que se lee («Japón»).
func tradicion(llamada nombre: String) -> Tradicion? {
    func clave(_ texto: String) -> String {
        texto.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).filter { !$0.isWhitespace }
    }
    return Tradicion.allCases.first { clave($0.rawValue) == clave(nombre) || clave($0.nombre) == clave(nombre) }
}
