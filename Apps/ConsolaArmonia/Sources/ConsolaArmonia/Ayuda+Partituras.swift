import Armonia

extension LineaDeComandos {
    /// Las partituras en MusicXML, MEI, LilyPond, GUIDO, ABC y MIDI, en el orden en que salen en la ayuda.
    static let ordenesDePartituras: [Orden] = [
        Orden(nombres: ["musicxml"], ayuda: ayudaDeMusicxml, opciones: opcionesDePartitura) {
            try partitura($0, $1, formato: .musicXML)
        },
        Orden(nombres: ["mei"], ayuda: ayudaDeMei, opciones: opcionesDePartitura) {
            try partitura($0, $1, formato: .mei)
        },
        Orden(nombres: ["lilypond"], ayuda: ayudaDeLilypond, opciones: opcionesDePartitura) {
            try partitura($0, $1, formato: .lilyPond)
        },
        Orden(nombres: ["guido"], ayuda: ayudaDeGuido, opciones: opcionesDePartitura) {
            try partitura($0, $1, formato: .guido)
        },
        Orden(nombres: ["abc"], ayuda: ayudaDeAbc, opciones: opcionesDePartitura) {
            try partitura($0, $1, formato: .abc)
        },
        Orden(nombres: ["midi"], ayuda: ayudaDeMidi, opciones: opcionesDeMidi) {
            try partitura($0, $1, formato: .midi)
        },
    ]

    /// Las opciones de todas las partituras: las que explica `musicxml`, y `--pattern` (`--patron` en inglés) y
    /// `--ventana` (`--window`, el ritmo armónico de lo que se lee con `--archivo`), que su ayuda no nombra.
    static let opcionesDePartitura: [OpcionDeOrden] = ayudaDeMusicxml.flatMap(\.opciones) + [.patron, .ventana]

    /// Las de MIDI: las mismas sin la clave ni las marcas, que no van en un MIDI, y con el programa (el instrumento).
    static let opcionesDeMidi: [OpcionDeOrden] =
        opcionesDePartitura.filter { !opcionesSoloDeMusicXML.contains($0) } + [.programa]

    /// La clave y las marcas de las partituras, que no van en un MIDI.
    static let opcionesSoloDeMusicXML: Set<OpcionDeOrden> = [.claveDePartitura, .cifrados, .analisis]

    static let ayudaDeMusicxml: [EntradaDeAyuda] = [
        // musicxml melodia <eventos> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlMelodia),
            ejemplo: ejemplo(
                "armonia musicxml melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > melodia.musicxml",
                "armonia musicxml melody C4:4 D4:8 E4:8 F4:2 --compas 3/4 > melody.musicxml")),
        // musicxml coral <acordes> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlCoral),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlCoral),
            ejemplo: ejemplo(
                "armonia musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.musicxml",
                "armonia musicxml chorale C3 E4 G4 C5, G2 D4 G4 B4 > chorale.musicxml")),
        // musicxml acordes <cifrados> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlAcordes),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlAcordes),
            ejemplo: ejemplo(
                "armonia musicxml acordes Do Lam Re7 Sol7 Do > progresion.musicxml",
                "armonia musicxml chords C Am D7 G7 C > progression.musicxml"),
            notas: TextosDeConsola.traduccion(\.notasMusicxmlAcordes),
            opciones: [
                .compas, .anacrusa, .en, .claveDePartitura, .tempo, .titulo, .duracion, .cifrados,
                .analisis,
            ]),
        // musicxml arpegios <cifrados> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlArpegios),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlArpegios),
            ejemplo: ejemplo(
                "armonia musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2 > arpegios.musicxml",
                "armonia musicxml arpeggios C Am F G7 --patron alberti --duracion 2 > arpeggios.musicxml"),
            notas: TextosDeConsola.traduccion(\.notasMusicxmlArpegios),
            opciones: [.patronDePartitura, .figuraDePartitura, .duracion, .enlazar]),
        // musicxml escala <escala> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlEscala),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlEscala),
            ejemplo: ejemplo(
                "armonia musicxml escala Re bayati > bayati.musicxml",
                "armonia musicxml scale D bayati > bayati.musicxml")),
        // musicxml acordes --archivo <fichero>
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMusicxmlArchivo),
            descripcion: TextosDeConsola.traduccion(\.descripcionMusicxmlArchivo),
            ejemplo: ejemplo(
                "armonia midi arpegios --archivo coral.mid --patron alberti > arpegios.mid",
                "armonia midi arpeggios --file chorale.mid --pattern alberti > arpeggios.mid"),
            opciones: [.archivo]),
    ]

    static let ayudaDeMei: [EntradaDeAyuda] = [
        // mei melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMeiMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionMeiMelodia),
            ejemplo: ejemplo(
                "armonia mei coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados > coral.mei",
                "armonia mei chorale C3 E4 G4 C5, G2 D4 G4 B4 --cifrados > chorale.mei"))
    ]

    static let ayudaDeLilypond: [EntradaDeAyuda] = [
        // lilypond melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisLilypondMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionLilypondMelodia),
            ejemplo: ejemplo(
                "armonia lilypond acordes Do Lam Re7 Sol7 Do > progresion.ly",
                "armonia lilypond chords C Am D7 G7 C > progression.ly"))
    ]

    static let ayudaDeGuido: [EntradaDeAyuda] = [
        // guido melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisGuidoMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionGuidoMelodia),
            ejemplo: ejemplo(
                "armonia guido coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados > coral.gmn",
                "armonia guido chorale C3 E4 G4 C5, G2 D4 G4 B4 --cifrados > chorale.gmn"))
    ]

    static let ayudaDeAbc: [EntradaDeAyuda] = [
        // abc melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisAbcMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionAbcMelodia),
            ejemplo: ejemplo(
                "armonia abc melodia Sol4:4 Do5:2 Re5:8 Mi5:8 --compas 3/4 --anacrusa 4 > melodia.abc",
                "armonia abc melody G4:4 C5:2 D5:8 E5:8 --compas 3/4 --anacrusa 4 > melody.abc"))
    ]

    static let ayudaDeMidi: [EntradaDeAyuda] = [
        // midi melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeConsola.traduccion(\.sintaxisMidiMelodia),
            descripcion: TextosDeConsola.traduccion(\.descripcionMidiMelodia),
            ejemplo: ejemplo(
                "armonia midi acordes Do Lam Re7 Sol7 Do > progresion.mid",
                "armonia midi chords C Am D7 G7 C > progression.mid"),
            opciones: [.claveDePartitura, .cifrados, .programa])
    ]
}
