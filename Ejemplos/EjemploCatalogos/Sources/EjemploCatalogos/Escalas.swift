import Armonia
import Foundation

// El catálogo de escalas (`TipoDeEscala.catalogo`: las occidentales y las de otras tradiciones, en su orden), una fila
// por escala con lo que dice de ella la API pública: nombres (y su traducción a los otros doce idiomas), intervalos,
// tradición, estilos, regiones, categoría, fuente, afinaciones, lo que se mide de sus notas (brillo, pasos, forma
// prima, simetría…), sus parientes en el catálogo y las obras que la citan.

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

let columnasDeEscalas: [String] =
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

/// La fila de una escala, en el orden de `columnasDeEscalas`.
func filaDeTipoDeEscala(_ tipo: TipoDeEscala) -> [String] {
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
        medidas.tonal.triadas.map { $0.map { $0?.cifrado ?? "?" }.joined(separator: " ") } ?? "",
        medidas.tonal.cuatriadas.map { $0.map { $0?.cifrado ?? "?" }.joined(separator: " ") } ?? "",
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
