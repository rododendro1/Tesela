import Armonia

let dominante: Acorde = "Sol7/Si"
dominante.notas // [Sol, Si, Re, Fa]
dominante.posicionCerrada(octava: 3) // [Si3, Re4, Fa4, Sol4]
dominante.cifrado(estilo: .inglesASCII) // "G7/B"
Acorde("G7(b9,#11)").cifrado // "Sol7(♭9,♯11)"
