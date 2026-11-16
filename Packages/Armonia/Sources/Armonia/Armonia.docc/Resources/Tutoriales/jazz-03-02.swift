import Armonia

let doMayor = Escala(.do, .mayor)
doMayor.tensionesDisponibles(grado: 2).map(\.cifra) // ["9", "11", "13"]
doMayor.tensionesDisponibles(grado: 1).map(\.cifra) // ["9", "13"]
doMayor.notasAEvitar(sobre: Acorde("Do7M")) // [Fa]
