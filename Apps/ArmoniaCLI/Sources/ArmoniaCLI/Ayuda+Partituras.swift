import Armonia

extension LineaDeComandos {
    /// Las partituras en MusicXML, MEI y MIDI, en el orden en que salen en la ayuda.
    static let ordenesDePartituras: [Orden] = [
        Orden(nombres: ["musicxml"], ayuda: ayudaDeMusicxml) { try partitura($0, $1, formato: .musicXML) },
        Orden(nombres: ["mei"], ayuda: ayudaDeMei) { try partitura($0, $1, formato: .mei) },
        Orden(nombres: ["midi"], ayuda: ayudaDeMidi) { try partitura($0, $1, formato: .midi) },
    ]

    static let ayudaDeMusicxml: [EntradaDeAyuda] = [
        // musicxml melodia <eventos> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMusicxmlMelodia),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMusicxmlMelodia),
            ejemplo: ejemplo(
                "armonia musicxml melodia Do4:4 Re4:8 Mi4:8 Fa4:2 --compas 3/4 > melodia.musicxml",
                "armonia musicxml melody C4:4 D4:8 E4:8 F4:2 --compas 3/4 > melody.musicxml")),
        // musicxml coral <acordes> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMusicxmlCoral),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMusicxmlCoral),
            ejemplo: ejemplo(
                "armonia musicxml coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 > coral.musicxml",
                "armonia musicxml chorale C3 E4 G4 C5, G2 D4 G4 B4 > chorale.musicxml")),
        // musicxml acordes <cifrados> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMusicxmlAcordes),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMusicxmlAcordes),
            ejemplo: ejemplo(
                "armonia musicxml acordes Do Lam Re7 Sol7 Do > progresion.musicxml",
                "armonia musicxml chords C Am D7 G7 C > progression.musicxml"),
            notas: TextosDeCLI.traducidos.map(\.notasMusicxmlAcordes)),
        // musicxml arpegios <cifrados> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMusicxmlArpegios),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMusicxmlArpegios),
            ejemplo: ejemplo(
                "armonia musicxml arpegios Do Lam Fa Sol7 --patron alberti --duracion 2 > arpegios.musicxml",
                "armonia musicxml arpeggios C Am F G7 --patron alberti --duracion 2 > arpeggios.musicxml"),
            notas: TextosDeCLI.traducidos.map(\.notasMusicxmlArpegios)),
        // musicxml acordes --archivo <fichero>
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMusicxmlArchivo),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMusicxmlArchivo),
            ejemplo: ejemplo(
                "armonia midi arpegios --archivo coral.mid --patron alberti > arpegios.mid",
                "armonia midi arpeggios --file chorale.mid --pattern alberti > arpeggios.mid")),
    ]

    static let ayudaDeMei: [EntradaDeAyuda] = [
        // mei melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMeiMelodia),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMeiMelodia),
            ejemplo: ejemplo(
                "armonia mei coral Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4 --cifrados > coral.mei",
                "armonia mei chorale C3 E4 G4 C5, G2 D4 G4 B4 --cifrados > chorale.mei"))
    ]

    static let ayudaDeMidi: [EntradaDeAyuda] = [
        // midi melodia|coral|acordes|arpegios <…> [opciones]
        EntradaDeAyuda(
            sintaxis: TextosDeCLI.traducidos.map(\.sintaxisMidiMelodia),
            descripcion: TextosDeCLI.traducidos.map(\.descripcionMidiMelodia),
            ejemplo: ejemplo(
                "armonia midi acordes Do Lam Re7 Sol7 Do > progresion.mid",
                "armonia midi chords C Am D7 G7 C > progression.mid"))
    ]
}
