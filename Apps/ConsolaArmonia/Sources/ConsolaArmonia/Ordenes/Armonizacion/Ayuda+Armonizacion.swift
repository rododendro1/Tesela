import Armonia

extension LineaDeComandos {
    /// El análisis, la armonización y el contrapunto, en el orden en que salen en la ayuda.
    static let ordenesDeArmonizacion: [Orden] = [
        Orden(
            nombres: ["analizar", "analyze", "analyse"], ayuda: ayudaDeAnalizar,
            json: { try analizarJSON($0, $1.notacion) },
            ejecutar: { try analizar($0, $1) }),
        Orden(
            nombres: ["armonizar", "harmonize", "harmonise"],
            ayuda: ayudaDeArmonizar,
            json: { try armonizarJSON($0, $1) },
            ejecutar: { try armonizar($0, $1) }),
        Orden(
            nombres: ["realizar", "realize", "realise"], ayuda: ayudaDeRealizar, json: { try realizarJSON($0, $1) },
            ejecutar: { try realizar($0, $1) }),
        Orden(
            nombres: ["revisar", "check"], ayuda: ayudaDeRevisar, json: { try revisarJSON($0, $1) },
            ejecutar: { try revisar($0, $1) }),
        Orden(
            nombres: ["contrapunto", "counterpoint"], ayuda: ayudaDeContrapunto,
            json: { try contrapuntoJSON($0, $1.notacion) },
            ejecutar: { try contrapunto($0, $1.notacion) }),
        Orden(
            nombres: ["transponer", "transportar", "transpose"],
            ayuda: ayudaDeTransponer,
            json: { try transponerJSON($0, $1.notacion) },
            ejecutar: { try transponer($0, $1) }),
        Orden(
            nombres: ["rearmonizar", "reharmonize", "reharmonise"],
            ayuda: ayudaDeRearmonizar, json: { try rearmonizarJSON($0, $1.notacion) },
            ejecutar: { try rearmonizar($0, $1.notacion) }),
    ]

    static let ayudaDeAnalizar: [EntradaDeAyuda] = [
        // analizar <acordes> [--en <tonalidad>] [--escalas]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAnalizar),
            descripcion: TextosDeConsola.traduccion(\.descripcionAnalizar),
            ejemplo: ejemplo(
                "armonia analizar Do Fa Sol7 Do Lam Re7 Sol",
                "armonia analyze C F G7 C Am D7 G"),
            notas: TextosDeConsola.traduccion(\.notasAnalizar),
            opciones: [.en, .escalas, .notasGuia, .conduccion, .comparar, .bajo, .estadisticas]),
        // analizar --archivo <fichero> [--ventana <duración>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAnalizarArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionAnalizarArchivo),
            ejemplo: ejemplo(
                "armonia analizar --archivo coral.mid",
                "armonia analyze --file chorale.musicxml"),
            opciones: [.archivo, .ventana]),
        // realizar <bajo cifrado> --bajo-cifrado [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRealizarBajoCifrado),
            descripcion: TextosDeConsola.traduccion(\.descripcionRealizarBajoCifrado),
            ejemplo: ejemplo(
                "armonia realizar Do La:6 Sol:7 Do --bajo-cifrado", "armonia realize C A:6 G:7 C --figured-bass"),
            opciones: [.bajoCifrado, .en]),
    ]

    static let ayudaDeArmonizar: [EntradaDeAyuda] = [
        // armonizar <melodía> [--en <tonalidad>] [--propuestas 3]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisArmonizar),
            descripcion: TextosDeConsola.traduccion(\.descripcionArmonizar),
            ejemplo: ejemplo(
                "armonia armonizar Mi4 Fa4 Re4 Do4",
                "armonia harmonize E4 F4 D4 C4"),
            opciones: [.en, .propuestas]),
        // armonizar --archivo <fichero> [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisArmonizarArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionArmonizarArchivo),
            ejemplo: ejemplo("armonia armonizar --archivo tema.musicxml", "armonia harmonize --file tune.musicxml"),
            opciones: [.archivo, .en]),
    ]

    static let ayudaDeRealizar: [EntradaDeAyuda] = [
        // realizar <acordes> [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRealizar),
            descripcion: TextosDeConsola.traduccion(\.descripcionRealizar),
            ejemplo: ejemplo(
                "armonia realizar Do Fa Sol7 Do",
                "armonia realize C F G7 C"),
            opciones: [.en]),
        // realizar --archivo <fichero> [--ventana 1]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRealizarArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionRealizarArchivo),
            ejemplo: ejemplo("armonia realizar --archivo progresion.mid", "armonia realize --file progression.mid"),
            opciones: [.archivo, .ventana]),
    ]

    static let ayudaDeRevisar: [EntradaDeAyuda] = [
        // revisar <acordes>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRevisar),
            descripcion: TextosDeConsola.traduccion(\.descripcionRevisar),
            ejemplo: ejemplo(
                "armonia revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4",
                "armonia check C3 E4 G4 C5, G2 D4 G4 B4")),
        // revisar --archivo <fichero>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRevisarArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionRevisarArchivo),
            ejemplo: ejemplo("armonia revisar --archivo coral.musicxml", "armonia check --file chorale.musicxml"),
            opciones: [.archivo]),
    ]

    static let ayudaDeContrapunto: [EntradaDeAyuda] = [
        // contrapunto <cantus> / <contrapunto> [--especie 1]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisContrapunto),
            descripcion: TextosDeConsola.traduccion(\.descripcionContrapunto),
            ejemplo: ejemplo(
                "armonia contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2",
                "armonia counterpoint D4 F4 E4 D4 / -:2 A4 D5 A4 B4 C#5 D5:1 --species 2"),
            opciones: [.especie]),
        // contrapunto <cantus> --proponer [--debajo] [--propuestas 1]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisProponerContrapunto),
            descripcion: TextosDeConsola.traduccion(\.descripcionProponerContrapunto),
            ejemplo: ejemplo(
                "armonia contrapunto Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4 --proponer",
                "armonia counterpoint D4 F4 E4 D4 G4 F4 A4 G4 F4 E4 D4 --propose"),
            opciones: [.proponer, .debajo, .propuestas]),
        // contrapunto <cantus> / <voz> / <voz>… [--especie 1,1]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisContrapuntoAVariasVoces),
            descripcion: TextosDeConsola.traduccion(\.descripcionContrapuntoAVariasVoces),
            ejemplo: ejemplo(
                "armonia contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Sol4 La4 / Re3 Re3 Do3 Re3",
                "armonia counterpoint D4 F4 E4 D4 / A4 A4 G4 A4 / D3 D3 C3 D3"),
            opciones: [.especie]),
    ]

    static let ayudaDeTransponer: [EntradaDeAyuda] = [
        // transponer <intervalo|tónica> <acordes o notas>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTransponer),
            descripcion: TextosDeConsola.traduccion(\.descripcionTransponer),
            ejemplo: ejemplo(
                "armonia transponer Re Do Lam Fa Sol7",
                "armonia transpose -m3 C Am F G7")),
        // transponer <intervalo|tónica> --archivo <fichero> [--formato musicxml]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisTransponerArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionTransponerArchivo),
            ejemplo: ejemplo(
                "armonia transponer 2M --archivo tema.mid > tema-en-re.mid",
                "armonia transpose 2M --file tune.mid > tune-in-d.mid"),
            opciones: [.archivo, .formato]),
    ]

    static let ayudaDeRearmonizar: [EntradaDeAyuda] = [
        // rearmonizar <acordes> [--en <tonalidad>]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisRearmonizar),
            descripcion: TextosDeConsola.traduccion(\.descripcionRearmonizar),
            ejemplo: ejemplo(
                "armonia rearmonizar Do Lam Rem7 Sol7 Do",
                "armonia reharmonize C Am Dm7 G7 C"),
            opciones: [.en])
    ]
}
