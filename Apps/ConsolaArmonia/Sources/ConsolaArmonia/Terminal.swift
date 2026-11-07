import Armonia
import Foundation

// MARK: - El autocompletado y la página de manual
//
// `armonia completado bash|zsh|fish` escribe el autocompletado para la terminal y `armonia manual`, la ayuda como
// página de manual (roff). Los dos salen de la tabla de órdenes (`ordenes`): los nombres de cada orden, su ayuda y
// las opciones que declara (`Orden.opciones`). Una orden o una opción nueva aparece en los dos sin tocar nada aquí.

extension LineaDeComandos {
    // MARK: Lo que se completa

    /// Las opciones que valen en cualquier orden (`LineaDeComandos.ejecutar`).
    static let generales: [OpcionDeOrden] = [
        .ingles, .idioma, .textos, .escritura, .subindices, .cifras, .json, .salida,
    ]

    /// Los nombres de las opciones generales, en español y en inglés.
    static let opcionesGenerales: [String] = generales.flatMap(\.nombres)

    /// Los nombres de las opciones que no llevan valor detrás; las demás, sí. Salen de lo que declara cada opción
    /// (`OpcionDeOrden.llevaValor`): una que es marca en una orden y lleva valor en otra (`--dedos`) cuenta como
    /// marca.
    static let marcas: Set<String> = Set(
        (generales + ordenes.flatMap(\.declaradas)).filter { !$0.llevaValor }.flatMap(\.nombres))

    /// Los nombres de unas opciones, para `valoresDeOpciones`.
    private static func nombres(_ opciones: OpcionDeOrden...) -> [String] { opciones.flatMap(\.nombres) }

    /// Los valores que se proponen tras una opción.
    static let valoresDeOpciones: [(opciones: [String], valores: [String])] = [
        (
            nombres(.idioma, .textos),
            ["es", "en", "ca", "gl", "ast", "an", "eu", "pt", "fr", "oc", "it", "de", "el", "ru", "hu"]
        ),
        (nombres(.escritura), ["palabras", "compacto", "ascii", "unicode", "words", "compact"]),
        (
            nombres(.patron),
            [
                "ascendente", "descendente", "ida-y-vuelta", "baja-y-sube", "quebrado", "alberti", "up", "down",
                "up-down", "down-up", "broken",
            ]
        ),
        (nombres(.motor), ["lilypond", "musescore", "verovio", "guido", "propio", "own"]),
        (nombres(.formato), ["pdf", "svg", "png"]),
        (nombres(.aproximacion), ["abajo", "arriba", "encierro", "below", "above", "enclosure"]),
        (nombres(.dedos), ["piano", "guitarra", "derecha", "izquierda", "guitar", "right", "left"]),
        (
            nombres(.secuencia),
            [
                "terceras", "cuartas", "grupos-de-3", "grupos-de-4", "triadas", "cuatriadas", "thirds", "fourths",
                "groups-of-3", "groups-of-4", "triads", "sevenths",
            ]
        ),
        (
            nombres(.clave, .claveDePartitura),
            ["sol", "fa", "do1", "do2", "do3", "do4", "sol8b", "sol8a", "fa3", "treble", "bass", "alto", "tenor"]
        ),
        (nombres(.ciclo), ["hexatonico", "octatonico"]),
        (
            nombres(.tradicion),
            LineaDeComandos.nombresDeLasTradiciones.flatMap { [$0.espanol, $0.ingles] }.reduce(into: [String]()) {
                if !$0.contains($1) { $0.append($1) }
            }
        ),
        (nombres(.categoria), CategoriaTradicional.allCases.map(\.rawValue)),
        (nombres(.fuente), FuenteTeorica.allCases.map(\.rawValue)),
        (nombres(.uso), LineaDeComandos.nombresDeLosUsos.flatMap { [$0.espanol, $0.ingles] }),
        (nombres(.orden), ["brillo", "notas", "brightness", "notes"]),
        (
            nombres(.conIntervalo, .sinIntervalo),
            [
                "semitono", "tono", "tercera-menor", "tercera-mayor", "cuarta", "tritono", "semitone", "tone",
                "minor-third", "major-third", "fourth", "tritone",
            ]
        ),
    ]

    /// Lo que va tras el nombre de algunas órdenes.
    static func tipos(de orden: Orden) -> [String] {
        if ordenesDePartituras.contains(where: { $0.nombres == orden.nombres }) {
            return [
                "melodia", "coral", "acordes", "arpegios", "escala", "melody", "chorale", "chords", "arpeggios",
                "scale",
            ]
        }
        if orden.nombres.contains("grabar") {
            // Una partitura, como en `lilypond`, o una orden de dibujo.
            return tipos(de: ordenesDePartituras[0]) + ordenesDeDibujos.flatMap(nombres(de:))
        }
        if orden.nombres.contains("completado") { return ["bash", "zsh", "fish"] }
        // Las subórdenes de los dibujos: `tonnetz acorde Sol7`, `hoja tonalidad Re mayor`.
        if ["tonnetz", "tabla", "cuadricula"].contains(where: orden.nombres.contains) {
            return LineaDeComandos.subordenesDeLosDibujos.flatMap(\.nombres).map { String($0.dropFirst(2)) }
        }
        if orden.nombres.contains("hoja") {
            let subordenes = ["escala", "acorde", "acordes", "tonalidad", "scale", "chord", "chords", "key"]
            return subordenes + nombresDeLasEscalas
        }
        if ordenesConEscala.contains(where: orden.nombres.contains) { return nombresDeLasEscalas }
        return []
    }

    /// Las órdenes que leen una escala (`escala Re dórico`): tras ellas se completan los nombres de las escalas.
    static let ordenesConEscala = ["escala", "posiciones", "teclado", "reloj", "hoja"]

    /// Los nombres de las escalas del catálogo, en español y en inglés, como se completan: en minúsculas, sin tildes
    /// y con guiones en lugar de espacios («menor-armonica», «harmonic-minor»), que se leen igual. Los que llevan
    /// otros caracteres (paréntesis, apóstrofos) no se proponen: la terminal los partiría.
    static let nombresDeLasEscalas: [String] = {
        var nombres: [String] = []
        var vistos: Set<String> = []
        let permitidos = Set("abcdefghijklmnopqrstuvwxyz0123456789-")
        for tipo in TipoDeEscala.catalogo {
            for nombre in [tipo.nombre, tipo.nombre(en: .inglesASCII)] {
                let palabra = nombre.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                    .lowercased().split(separator: " ").joined(separator: "-")
                guard !palabra.isEmpty, palabra.allSatisfy(permitidos.contains), vistos.insert(palabra).inserted
                else { continue }
                nombres.append(palabra)
            }
        }
        return nombres
    }()

    /// Las opciones de una orden, en español y en inglés, sin las generales: las que declara (`Orden.opciones`).
    static func opciones(de orden: Orden) -> [String] { orden.opciones }

    /// Los nombres que se completan de una orden: sin `-h` ni `--help`, que son de la ayuda.
    static func nombres(de orden: Orden) -> [String] { orden.nombres.filter { !$0.hasPrefix("-") } }

    // MARK: Autocompletado

    enum Terminal: String, CaseIterable { case bash, zsh, fish }

    static func completado(para terminal: Terminal) -> String {
        switch terminal {
        case .bash: return completadoBash(zsh: false)
        case .zsh: return completadoBash(zsh: true)
        case .fish: return completadoFish()
        }
    }

    /// Para bash y, con `bashcompinit`, para zsh.
    private static func completadoBash(zsh: Bool) -> String {
        var conValor: [String] = []
        for opcion in ordenes.flatMap(opciones(de:)) + opcionesGenerales
        where !marcas.contains(opcion) && !conValor.contains(opcion) {
            conValor.append(opcion)
        }
        var lineas: [String] = []
        if zsh {
            lineas += [
                "#compdef armonia",
                "# El autocompletado de armonia para zsh. Generado con «armonia completado zsh»; para usarlo:",
                "#     source <(armonia completado zsh)",
                "autoload -U +X bashcompinit && bashcompinit",
            ]
        } else {
            lineas += [
                "# El autocompletado de armonia para bash. Generado con «armonia completado bash»; para usarlo:",
                "#     source <(armonia completado bash)",
            ]
        }
        lineas += [
            "_armonia() {",
            "    local actual=\"${COMP_WORDS[COMP_CWORD]}\" anterior=\"${COMP_WORDS[COMP_CWORD-1]}\"",
            "    local orden=\"\" i",
            "    # La orden es la primera palabra que no es una opción ni el valor de una.",
            "    for ((i = 1; i < COMP_CWORD; i++)); do",
            "        case \"${COMP_WORDS[i]}\" in",
            "            \(conValor.joined(separator: "|"))) ((i++)) ;;",
            "            -*) ;;",
            "            *) orden=\"${COMP_WORDS[i]}\"; break ;;",
            "        esac",
            "    done",
            "    case \"$anterior\" in",
        ]
        for (opciones, valores) in valoresDeOpciones {
            lineas.append(
                "        \(opciones.joined(separator: "|"))) COMPREPLY=($(compgen -W \"\(valores.joined(separator: " "))\" -- \"$actual\")); return ;;"
            )
        }
        lineas += [
            "    esac",
            "    local palabras",
            "    case \"$orden\" in",
            "        \"\") palabras=\"\(ordenes.flatMap(nombres(de:)).joined(separator: " "))\" ;;",
        ]
        for orden in ordenes {
            let palabras = tipos(de: orden) + opciones(de: orden)
            guard !palabras.isEmpty else { continue }
            lineas.append(
                "        \(nombres(de: orden).joined(separator: "|"))) palabras=\"\(palabras.joined(separator: " "))\" ;;"
            )
        }
        lineas += [
            "    esac",
            "    COMPREPLY=($(compgen -W \"$palabras \(opcionesGenerales.joined(separator: " "))\" -- \"$actual\"))",
            "}",
            "complete -o default -F _armonia armonia",
        ]
        return lineas.joined(separator: "\n")
    }

    private static func completadoFish() -> String {
        var lineas = [
            "# El autocompletado de armonia para fish. Generado con «armonia completado fish»; para usarlo:",
            "#     armonia completado fish > ~/.config/fish/completions/armonia.fish",
            "complete -c armonia -f",
        ]
        let todas = ordenes.flatMap(nombres(de:))
        lineas.append(
            "complete -c armonia -n \"not __fish_seen_subcommand_from \(todas.joined(separator: " "))\" -a \"\(todas.joined(separator: " "))\""
        )
        func opcion(_ nombre: String, _ condicion: String?) -> String {
            var linea = "complete -c armonia"
            if let condicion { linea += " -n \"__fish_seen_subcommand_from \(condicion)\"" }
            linea += " -l \(nombre.dropFirst(2))"
            if let valores = valoresDeOpciones.first(where: { $0.opciones.contains(nombre) })?.valores {
                linea += " -x -a \"\(valores.joined(separator: " "))\""
            } else if !marcas.contains(nombre) {
                linea += " -r"
            }
            return linea
        }
        for nombre in opcionesGenerales { lineas.append(opcion(nombre, nil)) }
        for orden in ordenes {
            let suyos = nombres(de: orden).joined(separator: " ")
            let tipos = tipos(de: orden)
            if !tipos.isEmpty {
                lineas.append(
                    "complete -c armonia -n \"__fish_seen_subcommand_from \(suyos)\" -a \"\(tipos.joined(separator: " "))\""
                )
            }
            for nombre in opciones(de: orden) { lineas.append(opcion(nombre, suyos)) }
        }
        return lineas.joined(separator: "\n")
    }

    // MARK: Página de manual

    /// La ayuda como página de manual (roff, sección 1), en el idioma de los textos: la cabecera da el nombre y
    /// la sinopsis, cada orden es un apartado con su ejemplo, y el pie va en las notas.
    static func manual(en idioma: Idioma) -> String {
        let cabecera = cabeceraDeLaAyuda.texto(en: idioma).components(separatedBy: "\n").filter { !$0.isEmpty }
        // «armonia: teoría musical…», «Uso: armonia <orden>…» y «Órdenes:».
        let descripcion = cabecera.first.map { limpiar($0.drop { $0 != ":" }.dropFirst(), " .") } ?? ""
        let uso = cabecera.count > 1 ? cabecera[1] : ""
        let tituloDelUso = uso.prefix { $0 != ":" }
        let sinopsis = limpiar(uso.drop { $0 != ":" }.dropFirst(), " ")
        let tituloDeLasOrdenes = limpiar((cabecera.last ?? "").prefix { $0 != ":" && $0 != "(" }, " ")
        var roff = [
            ".TH ARMONIA 1 \"\" \"Tesela\" \"armonia\"",
            ".SH " + escapar(TextosDeConsola.traduccion(\.manualNombre).texto(en: idioma)),
            "armonia \\- " + escapar(descripcion),
            ".SH " + escapar(tituloDelUso.uppercased()),
            ".B armonia",
            escapar(String(sinopsis.dropFirst("armonia ".count))),
            ".SH " + escapar(tituloDeLasOrdenes.uppercased()),
        ]
        for entrada in ordenesDeLaAyuda {
            roff.append(".TP")
            let sintaxis = entrada.sintaxis.texto(en: idioma).components(separatedBy: "\n")
            roff.append(".B " + escapar(sintaxis[0]))
            for otra in sintaxis.dropFirst() { roff += [".br", ".B " + escapar(otra)] }
            roff.append(escapar(unaLinea(entrada.descripcion.texto(en: idioma))))
            if let notas = entrada.notas?.texto(en: idioma), !notas.isEmpty {
                roff += [".sp", escapar(unaLinea(notas))]
            }
            if let ejemplo = entrada.ejemplo?.texto(en: idioma), !ejemplo.isEmpty {
                roff += [".sp", ".RS 4", ".EX", escapar(ejemplo), ".EE", ".RE"]
            }
        }
        let textos = TextosDeConsola.traducidos.texto(en: idioma)
        roff += [
            ".SH " + escapar(textos.manualEntorno), ".TP", ".B ARMONIA_IDIOMA", escapar(textos.manualIdiomaDelEntorno),
        ]
        for programa in programasDeGrabado {
            roff += [
                ".TP", ".B " + escapar(EjecutorDelSistema.variable(de: programa)),
                escapar(textos.manualRutaDelPrograma(programa)),
            ]
        }
        roff.append(".SH " + escapar(textos.manualEstadoDeSalida))
        for (codigo, texto) in textos.manualCodigosDeSalida.enumerated() {
            roff += [".TP", ".B \(codigo)", escapar(texto)]
        }
        roff.append(".SH " + escapar(TextosDeConsola.traduccion(\.manualNotas).texto(en: idioma)))
        for parrafo in pieDeLaAyuda.texto(en: idioma).components(separatedBy: "\n\n") {
            roff += [".PP", escapar(unaLinea(parrafo))]
        }
        return roff.joined(separator: "\n")
    }

    /// Los programas de los motores de `armonia grabar`, sin repetir, cada uno con su variable de entorno
    /// (`ARMONIA_LILYPOND`): el primero de los nombres de cada motor y `rsvg-convert`.
    static var programasDeGrabado: [String] {
        var programas: [String] = []
        for motor in MotorDeGrabado.allCases where !programas.contains(motor.programas[0]) {
            programas.append(motor.programas[0])
        }
        if !programas.contains("rsvg-convert") { programas.append("rsvg-convert") }
        return programas
    }

    /// Las líneas cortadas a mano para la columna de la ayuda, juntas: el lector de man las corta solo.
    private static func unaLinea(_ texto: String) -> String {
        texto.components(separatedBy: "\n").map { limpiar($0[...], " ") }.joined(separator: " ")
    }

    /// El texto sin esos caracteres al principio ni al final.
    private static func limpiar(_ texto: Substring, _ caracteres: String) -> String {
        String(texto).trimmingCharacters(in: CharacterSet(charactersIn: caracteres))
    }

    /// Un texto en roff: la barra invertida se dobla, los guiones son guiones de verdad (`\-`, para que se puedan
    /// copiar) y una línea que empieza por punto o por apóstrofo no se toma por una petición.
    static func escapar(_ texto: String) -> String {
        var resultado = ""
        for caracter in texto {
            switch caracter {
            case "\\": resultado += "\\e"
            case "-": resultado += "\\-"
            default: resultado.append(caracter)
            }
        }
        if resultado.hasPrefix(".") || resultado.hasPrefix("'") { resultado = "\\&" + resultado }
        return resultado
    }

    // MARK: Las órdenes

    static let ordenesDeLaTerminal: [Orden] = [
        Orden(nombres: ["completado", "completion"], ayuda: ayudaDelCompletado) { argumentos, notacion in
            guard let nombre = argumentos.first?.lowercased(), argumentos.count == 1,
                let terminal = Terminal(rawValue: nombre)
            else {
                throw ErrorDeUso.terminalDesconocida(argumentos.first ?? "")
            }
            return bien(completado(para: terminal))
        },
        Orden(nombres: ["manual", "man"], ayuda: ayudaDelManual) { argumentos, notacion in
            if let sobra = argumentos.first { throw ErrorDeUso.opcionDesconocida(sobra) }
            return bien(manual(en: notacion.textos))
        },
    ]

    static let ayudaDelCompletado: [EntradaDeAyuda] = [
        // completado bash|zsh|fish
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisCompletado),
            descripcion: TextosDeConsola.traduccion(\.descripcionCompletado),
            ejemplo: ejemplo("source <(armonia completado bash)", "source <(armonia completion bash)"))
    ]

    static let ayudaDelManual: [EntradaDeAyuda] = [
        // manual
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisManual),
            descripcion: TextosDeConsola.traduccion(\.descripcionManual),
            ejemplo: ejemplo("armonia manual > armonia.1", "armonia manual --ingles > armonia.1"))
    ]
}
