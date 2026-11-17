import Armonia

let la = Altura("La4")
la.midi // 69
la.frecuencia() // 440.0
Altura(midi: 63, ventana: .bemoles) // Mi♭4
Altura(midi: 68, en: Tonalidad(.la, .menor)) // Sol♯4
