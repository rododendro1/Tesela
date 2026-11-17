import Armonia

let coral = try Coral(realizando: ["Do", "Fa", "Sol7", "Do"])
coral.esCorrecta // true
coral.voz(0).map(\.nota) // [Do, Fa, Sol, Do]

let conSoprano = try Coral(realizando: ["Do", "Fa", "Sol", "Do"], soprano: ["Mi4", "Fa4", "Re4", "Do4"])
conSoprano.voz(3) // [Mi4, Fa4, Re4, Do4]
try? Coral(realizando: ["Do", "Rem"], soprano: ["Sol4", "La4"]) // nil
