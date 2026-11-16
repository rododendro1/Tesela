import Armonia

let doMayor = Escala(.do, .mayor)
doMayor.tensionesDisponibles(grado: 2).map(\.cifra) // ["9", "11", "13"]
doMayor.tensionesDisponibles(grado: 1).map(\.cifra) // ["9", "13"]
doMayor.notasAEvitar(sobre: Acorde("Do7M")) // [Fa]
Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).map(\.cifra) // ["1", "9", "♭3", "11", "5", "13", "♭7"]
Escala(.do, .mixolidio).notas(sobre: Acorde("Do7M"))[6].papel // .choque
