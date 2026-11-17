import Armonia

let coral = try Coral(realizando: ["Do", "Fa", "Sol7", "Do"])
coral.esCorrecta // true
coral.voz(0).map(\.nota) // [Do, Fa, Sol, Do]
