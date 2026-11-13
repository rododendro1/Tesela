import Armonia

// Los demás catálogos del motor (con los alias, y las variantes si las tienen, en los trece idiomas): los ritmos, los
// temperamentos, las notas con nombre y sus funciones, las escalas microtonales, las referencias, los encordados, los
// teclados isomórficos y cuadrados, los modos gregorianos y los instrumentos de la partitura.

let columnasDeRitmos: [String] =
    columnasDeNombres + columnasDeAliasYVariantes(conVariantes: false) + [
        "familia", "patron", "agrupacion", "unidad", "compas", "pulsos", "ataques", "fuertes", "intervalos",
        "vector_de_distancias", "euclideo", "profundo", "simetrias_por_rotacion", "uniformidad", "contratiempo",
        "sincopa",
    ] + columnasDeLaFecha + columnasDelCaracter + ["estilos", "referencias"]

func filaDeRitmo(_ ritmo: RitmoConNombre) -> [String] {
    let medidas = ritmo.estadisticas
    let otros: [String] = aliasYVariantes(de: ritmo, conVariantes: false)
    let resto: [String] = [
        ritmo.familia.nombre, ritmo.patron,
        ritmo.agrupacion.map(String.init).joined(separator: "+"), String(ritmo.unidad), ritmo.compas.description,
        String(medidas.pulsos), String(medidas.ataques), String(medidas.fuertes), lista(medidas.intervalos),
        lista(medidas.vectorDeDistancias), siONo(medidas.euclideo), siONo(medidas.profundo),
        String(medidas.simetriasPorRotacion), numero(medidas.uniformidad), String(medidas.contratiempo),
        numero(medidas.sincopa),
    ]
    let estilos = ritmo.estilos.map(\.nombre).joined(separator: " · ")
    let alFinal: [String] = fecha(de: ritmo) + caracter(de: ritmo) + [estilos, citas(ritmo.referencias)]
    return nombres(de: ritmo) + otros + resto + alFinal
}

let ritmos = Catalogo(
    fichero: "ritmos.tsv", columnas: columnasDeRitmos, filas: RitmoConNombre.catalogo.map(filaDeRitmo),
    obras: RitmoConNombre.catalogo.flatMap(\.referencias))

let razonesJustas = ["3_2", "5_4", "6_5", "7_4", "11_8"]

let columnasAntesDeLosErrores: [String] =
    ["alias"] + columnasDeOtrosNombres(conVariantes: false) + [
        "familia", "autor", "pasos_por_octava", "quinta", "uniforme", "paso_menor", "paso_mayor",
    ]
let columnasDeLosErrores: [String] = razonesJustas.map { "error_\($0)" }
let columnasTrasLosErrores: [String] =
    [
        "quinta_del_lobo", "tercera_mas_pura", "tercera_mas_lejana", "desviaciones_del_igual", "pasos",
        "para_escuchar", "sistema_microtonal",
    ] + columnasDeLaFecha + ["referencias"]
let columnasDeTemperamentos: [String] =
    columnasDeNombres + columnasAntesDeLosErrores + columnasDeLosErrores + columnasTrasLosErrores

func filaDeTemperamento(_ temperamento: TemperamentoConNombre) -> [String] {
    let medidas = temperamento.estadisticas
    let otros: [String] = aliasYVariantes(de: temperamento, conVariantes: false)
    let ficha: [String] = [
        temperamento.familia.nombre, temperamento.autor ?? "", String(medidas.pasosPorOctava),
        numero(temperamento.quinta),
        siONo(medidas.uniforme), numero(medidas.pasoMenor), numero(medidas.pasoMayor),
    ]
    let errores: [String] = medidas.aproximaciones.map { numero($0.error) }
    let resto: [String] = [
        numero(medidas.quintaDelLobo), numero(medidas.terceraMasPura), numero(medidas.terceraMasLejana),
        medidas.desviacionesDelIgual.map(lista) ?? "", lista(temperamento.pasos),
        siONo(TemperamentoQueAfina.paraEscuchar.contains { $0.temperamento == temperamento }),
        temperamento.sistemaDeAlturas?.rawValue ?? "",
    ]
    let alFinal: [String] = fecha(de: temperamento) + [citas(temperamento.referencias)]
    return nombres(de: temperamento) + otros + ficha + errores + resto + alFinal
}

let temperamentos = Catalogo(
    fichero: "temperamentos.tsv", columnas: columnasDeTemperamentos,
    filas: TemperamentoConNombre.catalogo.map(filaDeTemperamento),
    obras: TemperamentoConNombre.catalogo.flatMap(\.referencias))

let columnasDeNotas: [String] =
    columnasDeNombres + columnasDeAliasYVariantes() + [
        "familia", "altura", "desvio", "frecuencia", "frecuencia_del_la4", "midi",
    ] + columnasDeLaFecha + ["referencias"]

/// Una nota con nombre: su altura, lo que se aparta de la temperada y su frecuencia.
func filaDeNota(_ nota: NotaConNombre) -> [String] {
    let otros: [String] = aliasYVariantes(de: nota)
    let resto: [String] = [
        nota.familia.nombre,
        nota.altura.description, numero(nota.desvio), numero(nota.frecuencia), numero(nota.frecuenciaDelLa4),
        String(nota.midi),
    ]
    let alFinal: [String] = fecha(de: nota) + [citas(nota.referencias)]
    return nombres(de: nota) + otros + resto + alFinal
}

let notas = Catalogo(
    fichero: "notas.tsv", columnas: columnasDeNotas, filas: NotaConNombre.catalogo.map(filaDeNota),
    obras: NotaConNombre.catalogo.flatMap(\.referencias))

let columnasDeFunciones: [String] =
    columnasDeNombres + columnasDeAliasYVariantes() + ["familia", "intervalo", "cents", "desvio"] + columnasDeLaFecha
    + ["referencias"]

/// Una función de nota: su familia y, si lo tiene, su intervalo desde la tónica.
func filaDeFuncion(_ funcion: FuncionDeNota) -> [String] {
    let intervalo: String = funcion.intervalo?.description ?? ""
    let otros: [String] = aliasYVariantes(de: funcion)
    let resto: [String] = [
        funcion.familia.nombre, intervalo, numero(funcion.cents),
        numero(funcion.desvio),
    ]
    let alFinal: [String] = fecha(de: funcion) + [citas(funcion.referencias)]
    return nombres(de: funcion) + otros + resto + alFinal
}

let funciones = Catalogo(
    fichero: "funciones-de-nota.tsv", columnas: columnasDeFunciones, filas: FuncionDeNota.catalogo.map(filaDeFuncion),
    obras: FuncionDeNota.catalogo.flatMap(\.referencias))

/// Una escala microtonal: sus pasos, sus cents y lo que se apartan de la temperada.
func filaDeEscala(_ escala: AfinacionPropia) -> [String] {
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
    filas: AfinacionPropia.catalogo.map(filaDeEscala),
    obras: AfinacionPropia.catalogo.flatMap(\.referencias))

let referencias = Catalogo(
    fichero: "referencias.tsv",
    columnas: [
        "clave", "clase", "autores", "titulo", "anio", "publicado_en", "editorial", "lugar", "volumen", "paginas",
        "doi", "url", "cita",
    ],
    filas: Referencia.catalogo.map(filaDeObra), obras: Referencia.catalogo)

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
