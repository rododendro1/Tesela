import Armonia

let mayor = Escala(.do, .mayor)
let vecinas = mayor.vecinas()
vecinas.count // 10
vecinas[4].escala // Do lidio
vecinas[4].desde // Fa
vecinas[4].hasta // Fa♯
