# Tesela

Music theory in Swift: a harmony engine, two apps for iOS and macOS, and a command-line tool, `armonia`. Everything
speaks fifteen languages, English among them. The code and its documentation are written in Spanish; this page is a
short English summary.

[Español](README.md) · [Documentation (DocC)](https://rododendro1.github.io/Tesela/)

## What's inside

- **Ars Harmonica** (app): chords (with fingerings, arpeggios and piano and jazz voicings), scales (on the fretboard, by
  position), harmonic analysis of a progression or of a MIDI, MusicXML, MEI or ABC file, four-part chorales, species
  counterpoint, chord identification from the fretboard or a MIDI keyboard, and twelve-tone rows. Exports MusicXML,
  MEI, LilyPond, GUIDO, ABC and MIDI.
- **Tonnetz** (app): chords, scales, P/L/R walks and scores played on the Tonnetz, the harmonic table or an
  isomorphic keyboard (Wicki-Hayden, Jankó, chromatic button accordion…).
- **`armonia`** (command line): the same from the terminal, as text or JSON, plus engraved scores in PDF, SVG or PNG.
- **Packages** you can use in your own project: `Armonia` (the engine), `Hexagonos` (hexagonal grids), and
  `TeselaPresentacion` and `TeselaUI` (what the apps share).

## Command line

Each [release](https://github.com/rododendro1/Tesela/releases) ships `armonia` prebuilt for Linux (x86_64 and arm64,
no dependencies) and macOS, with a man page and completion for bash, zsh and fish. Or build it with Swift 6:
`swift build -c release --package-path Apps/ArmoniaCLI`.

```sh
armonia chord G7/B --ingles                       # notes, inversion and the role of each note
armonia scale D dorian --chords --ingles          # notes and the chord on each degree
armonia analyze C Am D7 G7 C --ingles             # degrees, functions and cadences
armonia engrave chorale C3 E4 G4 C5 > chorale.pdf # needs LilyPond
armonia chord G7/B --ingles --json | jq '.[0].notas'
echo "C E G Bb" | armonia identify --ingles        # also from standard input
armonia check C3 E4 G4 C5, D3 F4 A4 D5 || echo bad  # exits with code 3 when there are mistakes
armonia help --ingles                             # the commands (help chord: that one; help --all: everything)
armonia                                           # in a terminal, a session: one command per line
armonia < exercises.txt                           # one command per line; exits with the worst code
armonia midi chords C F G C -o cadence.mid         # -o: to a file, also in the session
armonia chord H7 --language de                     # notes also in the chosen language
```

Commands and note names are accepted in Spanish or English (Do, C, Sib, Bb). `--ingles` answers in English notation
and language; `--language` picks any of the fifteen languages, and so does the `ARMONIA_IDIOMA` variable
(`export ARMONIA_IDIOMA=en`; `system` takes it from `LANG`). With `--json`, the keys are always the same (in
Spanish) whatever the language.

## Using the packages

```swift
dependencies: [
    .package(url: "https://github.com/rododendro1/Tesela.git", from: "0.3.2"),
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "Armonia", package: "Tesela"),
    ]),
]
```

The API is in Spanish (`Acorde`, `Escala`, `Tonalidad`…) and documented in DocC. The packages build with Swift 6.0
or later on macOS and Linux. The apps need macOS with Xcode and XcodeGen; the steps are in the [Spanish
README](README.md#las-apps).

Released under the MIT license ([LICENSE](LICENSE)).
