import Armonia

let menor = Escala("La menor armónica")
menor.notas // [La, Si, Do, Re, Mi, Fa, Sol♯]
menor.cifradosRomanos(cuatriadas: true)
// ["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]
