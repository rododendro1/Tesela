import Armonia

let analisis = Tonalidad(.do).analizar(["Rem7", "Sol7", "Do7M"])
analisis.cifrados // ["ii7", "V7", "Imaj7"]
analisis.escalas // [Re dórico, Sol mixolidio, Do mayor]

let conDominante = Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Sol7"])
conDominante.escalas[1] // La frigio dominante
