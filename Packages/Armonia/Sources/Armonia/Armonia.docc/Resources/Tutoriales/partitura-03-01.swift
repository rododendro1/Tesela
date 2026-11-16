import Armonia

let coral = Coral.realizar(["Do", "Fa", "Sol7", "Do"])!
coral.esCorrecta // true
coral.voz(0).map(\.nota) // [Do, Fa, Sol, Do]

let partitura = coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia"))
partitura.musicXML().contains("<staves>2</staves>") // true
