import Armonia

let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
Tonalidad.identificar(midi: melodia).first // La menor

let laMenor: Tonalidad = "La menor"
laMenor.relativa // Do mayor
laMenor.romanos() // i ii° III iv V VI vii°
