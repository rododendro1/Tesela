import Armonia

// Los demás catálogos del motor (con los alias, y las variantes si las tienen, en los trece idiomas): los ritmos, los
// temperamentos, las notas con nombre y sus funciones, los ornamentos, las escalas microtonales, las referencias, los
// encordados, los teclados isomórficos y cuadrados, los modos gregorianos y los instrumentos de la partitura.

let columnasDeRitmos: [String] =
    columnasDeNombres + columnasDeAliasYVariantes + [
        "familia", "patron", "agrupacion", "unidad", "compas", "pulsos", "ataques", "fuertes", "intervalos",
        "vector_de_distancias", "euclideo", "profundo", "simetrias_por_rotacion", "uniformidad", "contratiempo",
        "sincopa", "tradicion", "lugares_de_origen", "paises_de_origen", "continentes_de_origen",
    ] + columnasDeLaFecha + columnasDelCaracter + ["estilos", "referencias"]

func filaDeRitmo(_ ritmo: RitmoConNombre) -> [String] {
    let estadisticas = ritmo.estadisticas
    let otros: [String] = aliasYVariantes(de: ritmo)
    let resto: [String] =
        [
            ritmo.familia.nombre, ritmo.patron,
            ritmo.agrupacion.map(String.init).joined(separator: "+"), String(ritmo.unidad), ritmo.compas.description,
            String(estadisticas.pulsos), String(estadisticas.ataques), String(estadisticas.fuertes),
            lista(estadisticas.intervalos),
            lista(estadisticas.vectorDeDistancias), siONo(estadisticas.euclideo), siONo(estadisticas.profundo),
            String(estadisticas.simetriasPorRotacion), numero(estadisticas.uniformidad),
            String(estadisticas.contratiempo),
            numero(estadisticas.sincopa),
        ] + lugares(ritmo.tradicion, ritmo.lugaresDeOrigen, ritmo.paisesDeOrigen, ritmo.continentesDeOrigen)
    let estilos = ritmo.estilos.map(\.nombre).joined(separator: " · ")
    let alFinal: [String] = fecha(de: ritmo) + caracter(de: ritmo) + [estilos, citas(ritmo.referencias)]
    return nombres(de: ritmo) + otros + resto + alFinal
}

/// Las columnas de los lugares de origen sin la tradición, en los catálogos que son todos de la occidental (los
/// acordes y las progresiones), con `lugares(_:_:_:_:)` sin su primera.
let columnasDeLugaresSinTradicion = ["lugares_de_origen", "paises_de_origen", "continentes_de_origen"]

/// La tradición, los lugares, los países (por su código ISO) y los continentes de origen, como en las escalas.
func lugares(
    _ tradicion: Tradicion?, _ lugares: [Lugar], _ paises: [Pais], _ continentes: [Continente]
) -> [String] {
    [
        tradicion?.nombre ?? "", lugares.map(\.nombre).joined(separator: " · "),
        paises.map(\.codigoISO).joined(separator: " "), continentes.map(\.nombre).joined(separator: " · "),
    ]
}

let ritmos = Catalogo(
    fichero: "ritmos.tsv", columnas: columnasDeRitmos, filas: RitmoConNombre.catalogo.map(filaDeRitmo),
    obras: RitmoConNombre.catalogo.flatMap(\.referencias))

let razonesJustas = ["3_2", "5_4", "6_5", "7_4", "11_8"]

let columnasAntesDeLosErrores: [String] =
    columnasDeAliasYVariantes + [
        "familia", "autor", "pasos_por_octava", "quinta", "uniforme", "paso_menor", "paso_mayor",
    ]
let columnasDeLosErrores: [String] = razonesJustas.map { "error_\($0)" }
let columnasTrasLosErrores: [String] =
    [
        "quinta_del_lobo", "tercera_mas_pura", "tercera_mas_lejana", "desviaciones_del_igual", "pasos",
        "para_escuchar", "sistema_microtonal", "tradicion", "lugares_de_origen", "paises_de_origen",
        "continentes_de_origen",
    ] + columnasDeLaFecha + ["estilos", "referencias"]
let columnasDeTemperamentos: [String] =
    columnasDeNombres + columnasAntesDeLosErrores + columnasDeLosErrores + columnasTrasLosErrores

func filaDeTemperamento(_ temperamento: TemperamentoConNombre) -> [String] {
    let estadisticas = temperamento.estadisticas
    let otros: [String] = aliasYVariantes(de: temperamento)
    let ficha: [String] = [
        temperamento.familia.nombre, temperamento.autor ?? "", String(estadisticas.pasosPorOctava),
        numero(temperamento.quinta),
        siONo(estadisticas.uniforme), numero(estadisticas.pasoMenor), numero(estadisticas.pasoMayor),
    ]
    let errores: [String] = estadisticas.aproximaciones.map { numero($0.error) }
    let resto: [String] = [
        numero(estadisticas.quintaDelLobo), numero(estadisticas.terceraMasPura), numero(estadisticas.terceraMasLejana),
        estadisticas.desviacionesDelIgual.map(lista) ?? "", lista(temperamento.pasos),
        siONo(TemperamentoQueAfina.paraEscuchar.contains { $0.temperamento == temperamento }),
        temperamento.sistemaDeAlturas?.rawValue ?? "",
    ]
    let deDonde: [String] = lugares(
        temperamento.tradicion, temperamento.lugaresDeOrigen, temperamento.paisesDeOrigen,
        temperamento.continentesDeOrigen)
    let estilos = temperamento.estilos.map(\.nombre).joined(separator: " · ")
    let alFinal: [String] = deDonde + fecha(de: temperamento) + [estilos, citas(temperamento.referencias)]
    return nombres(de: temperamento) + otros + ficha + errores + resto + alFinal
}

let temperamentos = Catalogo(
    fichero: "temperamentos.tsv", columnas: columnasDeTemperamentos,
    filas: TemperamentoConNombre.catalogo.map(filaDeTemperamento),
    obras: TemperamentoConNombre.catalogo.flatMap(\.referencias))

let columnasDeNotas: [String] =
    columnasDeNombres + columnasDeAliasYVariantes + [
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
    columnasDeNombres + columnasDeAliasYVariantes + ["familia", "intervalo", "cents", "desvio"] + columnasDeLaFecha
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

let columnasDeOrnamentos: [String] =
    columnasDeNombres + columnasDeAliasYVariantes + ["pasos", "sobre_mi4_en_do_mayor"] + columnasDeLaFecha
    + ["epocas_de_uso", "estilos", "referencias"]

/// Un ornamento: sus pasos por grados desde la nota principal y cómo suena sobre Mi4 en Do mayor.
func filaDeOrnamento(_ ornamento: OrnamentoConNombre) -> [String] {
    let otros: [String] = aliasYVariantes(de: ornamento)
    let alturas = ornamento.alturas(sobre: Altura(.mi, octava: 4), en: Escala(.do, .mayor)) ?? []
    let resto: [String] = [
        ornamento.pasos.map(String.init).joined(separator: " "), alturas.map(\.description).joined(separator: " "),
    ]
    let alFinal: [String] =
        fecha(de: ornamento) + [
            ornamento.epocasDeUso.map(\.nombre).joined(separator: " · "),
            ornamento.estilos.map(\.nombre).joined(separator: " · "), citas(ornamento.referencias),
        ]
    return nombres(de: ornamento) + otros + resto + alFinal
}

let ornamentos = Catalogo(
    fichero: "ornamentos.tsv", columnas: columnasDeOrnamentos, filas: OrnamentoConNombre.catalogo.map(filaDeOrnamento),
    obras: OrnamentoConNombre.catalogo.flatMap(\.referencias))

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

/// Lo que cita cada obra, por su clave: «escala Re dórico», «acorde Tristán»…, en el orden de los catálogos, con las
/// obras que dan su carácter y, al final, las del carácter de las tonalidades («tonalidad Re mayor»).
private let citadaPor: [String: [String]] = {
    func citas(_ elementos: [some ElementoConNombre], _ catalogo: String) -> [(String, String)] {
        elementos.flatMap { elemento -> [(String, String)] in
            let quien = catalogo + " " + elemento.nombre
            return (elemento.referencias + elemento.caracter.map(\.referencia)).map { ($0.clave, quien) }
        }
    }
    let microtonales: [(String, String)] = AfinacionPropia.catalogo.flatMap { afinacion in
        afinacion.referencias.map { ($0.clave, "escala microtonal " + afinacion.temperada.nombre) }
    }
    let grupos: [[(String, String)]] = [
        citas(TipoDeEscala.catalogo, "escala"), citas(AcordeConNombre.catalogo, "acorde"),
        citas(ProgresionConNombre.catalogo, "progresión"), citas(RitmoConNombre.catalogo, "ritmo"),
        citas(TemperamentoConNombre.catalogo, "temperamento"), citas(NotaConNombre.catalogo, "nota"),
        citas(FuncionDeNota.catalogo, "función"), citas(OrnamentoConNombre.catalogo, "ornamento"), microtonales,
        Encordado.todos.flatMap { encordado in encordado.referencias.map { ($0.clave, "encordado " + encordado.nombre) }
        },
        Tonalidad.conCaracter.flatMap { tonalidad in
            tonalidad.caracter.map { ($0.referencia.clave, "tonalidad " + tonalidad.nombre) }
        },
    ]
    var porClave: [String: [String]] = [:]
    for (clave, quien) in grupos.joined() where porClave[clave]?.contains(quien) != true {
        porClave[clave, default: []].append(quien)
    }
    return porClave
}()

let referencias = Catalogo(
    fichero: "referencias.tsv",
    columnas: [
        "clave", "clase", "autores", "titulo", "anio", "publicado_en", "editorial", "lugar", "volumen", "paginas",
        "doi", "url", "cita", "citada_por",
    ],
    filas: Referencia.catalogo.map { filaDeObra($0) + [(citadaPor[$0.clave] ?? []).joined(separator: " · ")] },
    obras: Referencia.catalogo)

let encordados = Catalogo(
    fichero: "encordados.tsv",
    columnas: columnasDeNombres + [
        "otros_nombres", "cuerdas", "ordenes", "cuerdas_por_orden", "afinacion", "ambito_al_aire", "capo",
        "reentrante", "trastes", "tradicion",
        "lugares_de_origen", "paises_de_origen", "continentes_de_origen", "anio_de_origen", "epoca_de_origen",
        "estilos", "referencias",
    ],
    filas: Encordado.todos.map { encordado in
        let nombres = Idioma.allCases.map { encordado.nombre(en: .delIdioma($0)) }
        // De la cuerda al aire más grave a la más aguda, que no son la primera y la última si es reentrante.
        var ambito = ""
        if let grave = encordado.afinacion.min(by: { $0.midi < $1.midi }),
            let aguda = encordado.afinacion.max(by: { $0.midi < $1.midi })
        {
            ambito = "\(grave)–\(aguda)"
        }
        let ficha: [String] = [
            encordado.otrosNombres.joined(separator: " · "),
            String(encordado.cuerdasReales), String(encordado.numeroDeCuerdas), lista(encordado.cuerdasPorOrden),
            encordado.afinacion.map(\.description).joined(separator: " "), ambito, String(encordado.capo),
            siONo(encordado.esReentrante), encordado.trastes.rawValue,
        ]
        let deDonde: [String] = lugares(
            encordado.tradicion, encordado.lugaresDeOrigen, encordado.paisesDeOrigen, encordado.continentesDeOrigen)
        let fecha: [String] = [
            encordado.anioDeOrigen.map(String.init) ?? "", encordado.epocaDeOrigen?.nombre ?? "",
            encordado.estilos.map(\.nombre).joined(separator: " · "), citas(encordado.referencias),
        ]
        return nombres + ficha + deDonde + fecha
    },
    obras: Encordado.todos.flatMap(\.referencias))

/// El nombre en español y en los demás idiomas, en el orden de `columnasDeNombres`, de lo que se nombra sin ser un
/// elemento del catálogo (un teclado, un instrumento).
func nombres(_ nombre: String, _ enIdioma: (Notacion) -> String) -> [String] {
    [nombre] + traducciones.map { enIdioma(.delIdioma($0)) }
}

let tecladosIsomorficos = Catalogo(
    fichero: "teclados-isomorficos.tsv",
    columnas: columnasDeNombres + [
        "orientacion", "semitonos_en_q", "semitonos_en_r", "semitonos_en_las_seis_direcciones", "midi_del_origen",
        "formato_uil",
    ],
    filas: TecladoIsomorfico.todos.map { teclado in
        nombres(teclado.nombre, teclado.nombre(en:)) + [
            "\(teclado.orientacion)", String(teclado.semitonosEnQ), String(teclado.semitonosEnR),
            lista(teclado.semitonosEnLasSeisDirecciones), String(teclado.midiDelOrigen),
            teclado.uil?.description ?? "",
        ]
    })

let tecladosCuadrados = Catalogo(
    fichero: "teclados-cuadrados.tsv",
    columnas: columnasDeNombres + [
        "semitonos_en_h", "semitonos_en_v", "semitonos_en_la_diagonal", "semitonos_en_la_antidiagonal",
        "midi_del_origen", "grados", "cromatico", "completo",
    ],
    filas: TecladoCuadrado.todos.map { teclado in
        nombres(teclado.nombre, teclado.nombre(en:)) + [
            String(teclado.semitonosEnH), String(teclado.semitonosEnV), String(teclado.semitonosEnDiagonal),
            String(teclado.semitonosEnAntidiagonal), String(teclado.midiDelOrigen), lista(teclado.grados),
            siONo(teclado.esCromatico), siONo(teclado.esCompleto),
        ]
    })

let modosGregorianos = Catalogo(
    fichero: "modos-gregorianos.tsv",
    columnas: [
        "numero", "nombre", "nombre_griego", "maneria", "autentico", "pareja", "finalis", "tenor", "ambito", "escala",
        "tipo_de_escala",
    ],
    filas: ModoGregoriano.todos.map { modo in
        // El auténtico y su plagal van seguidos: el 1 con el 2, el 3 con el 4…
        let pareja = ModoGregoriano.todos.first { $0.numero == (modo.esAutentico ? modo.numero + 1 : modo.numero - 1) }
        return [
            String(modo.numero), modo.nombre, modo.nombreGriego, "\(modo.maneria)", siONo(modo.esAutentico),
            pareja?.nombre ?? "", modo.finalis.description, modo.tenor.description, "\(modo.grave)–\(modo.agudo)",
            modo.escala.notas.map(\.description).joined(separator: " "), modo.tipoDeEscala.nombre,
        ]
    })

let instrumentos = Catalogo(
    fichero: "instrumentos.tsv",
    columnas: columnasDeNombres + ["transposicion", "clave", "primera_linea", "transpositor", "suena_el_do4_como"],
    filas: InstrumentoDePartitura.todos.map { instrumento in
        nombres(instrumento.nombre, instrumento.nombre(en:)) + [
            instrumento.transposicion.description, "\(instrumento.clave)",
            instrumento.clave.alturaDeLaPrimeraLinea.description, siONo(instrumento.esTranspositor),
            instrumento.sonido(de: Altura(.do, octava: 4)).description,
        ]
    })
