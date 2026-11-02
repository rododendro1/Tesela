import Armonia

let la = Altura("La4")
la.midi // 69
la.frecuencia() // 440.0
Altura(midi: 63, preferirBemoles: true) // Mi♭4
Altura(midi: 68, tonalidad: "La menor") // Sol♯4
