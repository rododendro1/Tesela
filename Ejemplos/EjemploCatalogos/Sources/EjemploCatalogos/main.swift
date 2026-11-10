import Armonia
import Foundation

// Escribe en TSV, un fichero por catálogo, lo que dice la API pública de cada uno: los ritmos, los temperamentos, las
// notas con nombre y sus funciones, las escalas microtonales, las referencias, los encordados, los teclados isomórficos y cuadrados, los modos gregorianos y
// los instrumentos de la partitura. Las listas de una celda van separadas por espacios (pasos, notas) o por « · »
// (alias, citas); una celda vacía es un dato que el elemento no tiene, y las de sí o no dicen «sí» o «no». Los
// números se escriben con tres decimales como mucho.
//
//     swift run EjemploCatalogos [carpeta | -]

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

func siONo(_ valor: Bool) -> String { valor ? "sí" : "no" }

/// Un número con tres decimales como mucho: «696.578», «700».
func numero(_ valor: Double?) -> String {
    guard let valor else { return "" }
    let redondeado = (valor * 1000).rounded() / 1000
    return redondeado == redondeado.rounded() ? String(Int(redondeado)) : String(redondeado)
}

func lista(_ valores: [Int]) -> String { valores.map(String.init).joined(separator: " ") }
func lista(_ valores: [Double]) -> String { valores.map(numero).joined(separator: " ") }
func citas(_ referencias: [Referencia]) -> String { referencias.map(\.cita).joined(separator: " · ") }

/// Los idiomas a los que se traduce el nombre, en el orden de `Idioma.allCases`: todos menos el español.
let traducciones = Idioma.allCases.filter { $0 != .espanol }
let columnasDeNombres = ["nombre"] + traducciones.map { "nombre_en_\($0.rawValue)" }

/// Un catálogo: el fichero, las columnas y una fila por elemento.
struct Catalogo {
    let fichero: String
    let columnas: [String]
    let filas: [[String]]

    var tsv: String {
        ([columnas] + filas).map { $0.map(celda).joined(separator: "\t") }.joined(separator: "\n") + "\n"
    }
}

// MARK: - Los catálogos

let columnasDeRitmos: [String] =
    columnasDeNombres + [
        "alias", "familia", "patron", "agrupacion", "unidad", "compas", "pulsos", "ataques", "fuertes", "intervalos",
        "vector_de_distancias", "euclideo", "profundo", "simetrias_por_rotacion", "uniformidad", "contratiempo",
        "sincopa", "referencias",
    ]

func filaDeRitmo(_ ritmo: RitmoConNombre) -> [String] {
    let medidas = ritmo.estadisticas
    let nombres: [String] = [ritmo.nombre] + traducciones.map { ritmo.nombre(en: .delIdioma($0)) }
    let resto: [String] = [
        ritmo.alias.joined(separator: " · "), ritmo.familia.nombre, ritmo.patron,
        ritmo.agrupacion.map(String.init).joined(separator: "+"), String(ritmo.unidad), ritmo.compas.description,
        String(medidas.pulsos), String(medidas.ataques), String(medidas.fuertes), lista(medidas.intervalos),
        lista(medidas.vectorDeDistancias), siONo(medidas.euclideo), siONo(medidas.profundo),
        String(medidas.simetriasPorRotacion), numero(medidas.uniformidad), String(medidas.contratiempo),
        numero(medidas.sincopa), citas(ritmo.referencias),
    ]
    return nombres + resto
}

let ritmos = Catalogo(
    fichero: "ritmos.tsv", columnas: columnasDeRitmos, filas: RitmoConNombre.catalogo.map(filaDeRitmo))

let razonesJustas = ["3_2", "5_4", "6_5", "7_4", "11_8"]

let columnasAntesDeLosErrores: [String] = [
    "alias", "familia", "autor", "anio", "pasos_por_octava", "quinta", "uniforme", "paso_menor", "paso_mayor",
]
let columnasDeLosErrores: [String] = razonesJustas.map { "error_\($0)" }
let columnasTrasLosErrores: [String] = [
    "quinta_del_lobo", "tercera_mas_pura", "tercera_mas_lejana", "desviaciones_del_igual", "pasos",
    "afinacion_historica", "sistema_microtonal", "referencias",
]
let columnasDeTemperamentos: [String] =
    columnasDeNombres + columnasAntesDeLosErrores + columnasDeLosErrores + columnasTrasLosErrores

func filaDeTemperamento(_ temperamento: TemperamentoConNombre) -> [String] {
    let medidas = temperamento.estadisticas
    let nombres: [String] = [temperamento.nombre] + traducciones.map { temperamento.nombre(en: .delIdioma($0)) }
    let ficha: [String] = [
        temperamento.alias.joined(separator: " · "), temperamento.familia.nombre, temperamento.autor ?? "",
        temperamento.anio.map(String.init) ?? "", String(medidas.pasosPorOctava), numero(temperamento.quinta),
        siONo(medidas.uniforme), numero(medidas.pasoMenor), numero(medidas.pasoMayor),
    ]
    let errores: [String] = medidas.aproximaciones.map { numero($0.error) }
    let resto: [String] = [
        numero(medidas.quintaDelLobo), numero(medidas.terceraMasPura), numero(medidas.terceraMasLejana),
        medidas.desviacionesDelIgual.map(lista) ?? "", lista(temperamento.pasos),
        temperamento.historica?.nombre ?? "", temperamento.sistemaMicrotonal?.rawValue ?? "",
        citas(temperamento.referencias),
    ]
    return nombres + ficha + errores + resto
}

let temperamentos = Catalogo(
    fichero: "temperamentos.tsv", columnas: columnasDeTemperamentos,
    filas: TemperamentoConNombre.catalogo.map(filaDeTemperamento))

let columnasDeNotas: [String] =
    columnasDeNombres + [
        "alias", "variantes", "familia", "altura", "desvio", "frecuencia", "frecuencia_del_la4", "midi", "anio",
        "referencias",
    ]

/// Una nota con nombre: su altura, lo que se aparta de la temperada y su frecuencia.
func filaDeNota(_ nota: NotaConNombre) -> [String] {
    let nombres: [String] = [nota.nombre] + traducciones.map { nota.nombre(en: .delIdioma($0)) }
    let anio: String = nota.anio.map { String($0) } ?? ""
    let resto: [String] = [
        nota.alias.joined(separator: " · "), nota.variantes.joined(separator: " · "), nota.familia.nombre,
        nota.altura.description, numero(nota.desvio), numero(nota.frecuencia), numero(nota.frecuenciaDelLa4),
        String(nota.midi), anio, citas(nota.referencias),
    ]
    return nombres + resto
}

let notas = Catalogo(fichero: "notas.tsv", columnas: columnasDeNotas, filas: NotaConNombre.catalogo.map(filaDeNota))

let columnasDeFunciones: [String] =
    columnasDeNombres + ["alias", "familia", "intervalo", "cents", "desvio", "referencias"]

/// Una función de nota: su familia y, si lo tiene, su intervalo desde la tónica.
func filaDeFuncion(_ funcion: FuncionDeNota) -> [String] {
    let nombres: [String] = [funcion.nombre] + traducciones.map { funcion.nombre(en: .delIdioma($0)) }
    let intervalo: String = funcion.intervalo?.description ?? ""
    let resto: [String] = [
        funcion.alias.joined(separator: " · "), funcion.familia.nombre, intervalo, numero(funcion.cents),
        numero(funcion.desvio), citas(funcion.referencias),
    ]
    return nombres + resto
}

let funciones = Catalogo(
    fichero: "funciones-de-nota.tsv", columnas: columnasDeFunciones, filas: FuncionDeNota.catalogo.map(filaDeFuncion))

/// Una escala microtonal: sus pasos, sus cents y lo que se apartan de la temperada.
func filaDeEscala(_ escala: TipoDeEscalaMicrotonal) -> [String] {
    let descendentes: String = escala.pasosDescendentes.map(lista) ?? ""
    let fuente: String = escala.fuente?.rawValue ?? ""
    return [
        escala.temperada.nombre, escala.sistema.rawValue, lista(escala.pasos), descendentes, lista(escala.cents),
        lista(escala.desvios), siONo(escala.esCoherente), fuente, citas(escala.referencias),
    ]
}

/// Una obra citada, con cada campo en su columna.
func filaDeObra(_ obra: Referencia) -> [String] {
    let anio: String = obra.anio.map { String($0) } ?? ""
    let publicadoEn: String = obra.publicadoEn ?? ""
    let editorial: String = obra.editorial ?? ""
    let lugar: String = obra.lugar ?? ""
    let volumen: String = obra.volumen ?? ""
    let paginas: String = obra.paginasDeLaObra ?? ""
    let doi: String = obra.doi ?? ""
    let url: String = obra.url ?? ""
    let autores: String = obra.autores.joined(separator: " · ")
    return [
        obra.clave, obra.clase.rawValue, autores, obra.titulo, anio, publicadoEn, editorial, lugar, volumen, paginas,
        doi, url, obra.cita,
    ]
}

let escalasMicrotonales = Catalogo(
    fichero: "escalas-microtonales.tsv",
    columnas: [
        "escala", "sistema", "pasos", "pasos_descendentes", "cents", "desvios", "coherente", "fuente", "referencias",
    ],
    filas: TipoDeEscalaMicrotonal.catalogo.map(filaDeEscala))

let referencias = Catalogo(
    fichero: "referencias.tsv",
    columnas: [
        "clave", "clase", "autores", "titulo", "anio", "publicado_en", "editorial", "lugar", "volumen", "paginas",
        "doi", "url", "cita",
    ],
    filas: Referencia.catalogo.map(filaDeObra))

let encordados = Catalogo(
    fichero: "encordados.tsv",
    columnas: ["nombre", "nombre_en_ingles", "cuerdas", "afinacion", "capo", "reentrante"],
    filas: Encordado.todos.map { encordado in
        [
            encordado.nombre, encordado.nombre(en: .delIdioma(.ingles)), String(encordado.numeroDeCuerdas),
            encordado.afinacion.map(\.description).joined(separator: " "), String(encordado.capo),
            siONo(encordado.esReentrante),
        ]
    })

let tecladosIsomorficos = Catalogo(
    fichero: "teclados-isomorficos.tsv",
    columnas: ["nombre", "nombre_en_ingles", "orientacion", "semitonos_en_q", "semitonos_en_r", "midi_del_origen"],
    filas: TecladoIsomorfico.todos.map { teclado in
        [
            teclado.nombre, teclado.nombre(en: .delIdioma(.ingles)), "\(teclado.orientacion)",
            String(teclado.semitonosEnQ), String(teclado.semitonosEnR), String(teclado.midiDelOrigen),
        ]
    })

let tecladosCuadrados = Catalogo(
    fichero: "teclados-cuadrados.tsv",
    columnas: ["nombre", "semitonos_en_h", "semitonos_en_v", "midi_del_origen", "grados", "cromatico", "completo"],
    filas: TecladoCuadrado.todos.map { teclado in
        [
            teclado.nombre, String(teclado.semitonosEnH), String(teclado.semitonosEnV), String(teclado.midiDelOrigen),
            lista(teclado.grados), siONo(teclado.esCromatico), siONo(teclado.esCompleto),
        ]
    })

let modosGregorianos = Catalogo(
    fichero: "modos-gregorianos.tsv",
    columnas: ["numero", "nombre", "nombre_griego", "autentico", "finalis", "tenor", "ambito", "escala"],
    filas: ModoGregoriano.todos.map { modo in
        [
            String(modo.numero), modo.nombre, modo.nombreGriego, siONo(modo.esAutentico), modo.finalis.description,
            modo.tenor.description, "\(modo.grave)–\(modo.agudo)",
            modo.escala.notas.map(\.description).joined(separator: " "),
        ]
    })

let instrumentos = Catalogo(
    fichero: "instrumentos.tsv",
    columnas: ["nombre", "transposicion", "clave", "transpositor"],
    filas: InstrumentoDePartitura.todos.map { instrumento in
        [
            instrumento.nombre, instrumento.transposicion.description, "\(instrumento.clave)",
            siONo(instrumento.esTranspositor),
        ]
    })

let catalogos = [
    ritmos, temperamentos, notas, funciones, escalasMicrotonales, referencias, encordados, tecladosIsomorficos,
    tecladosCuadrados,
    modosGregorianos, instrumentos,
]

// MARK: - Salida

let destino = CommandLine.arguments.dropFirst().first ?? "catalogos"
if destino == "-" {
    for catalogo in catalogos { print("# " + catalogo.fichero + "\n" + catalogo.tsv, terminator: "") }
} else {
    do {
        try FileManager.default.createDirectory(atPath: destino, withIntermediateDirectories: true)
        for catalogo in catalogos {
            let ruta = (destino as NSString).appendingPathComponent(catalogo.fichero)
            try catalogo.tsv.write(toFile: ruta, atomically: true, encoding: String.Encoding.utf8)
            print("\(ruta): \(catalogo.filas.count) filas")
        }
    } catch {
        FileHandle.standardError.write(Data("No se pudo escribir en \(destino): \(error)\n".utf8))
        exit(1)
    }
}
