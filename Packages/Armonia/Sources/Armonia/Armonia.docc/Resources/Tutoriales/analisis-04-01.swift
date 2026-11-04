import Armonia

let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
analisis.tonalidad // Do mayor
analisis.cifrados // ["I", "vi", "V7/V", "V7", "I"]
analisis.funciones.map { $0?.abreviatura ?? "–" } // ["T", "T", "D", "D", "T"]
analisis.acordes[2].categoria // .dominanteSecundaria(de: 5)
analisis // I–vi–V7/V–V7–I en Do mayor

let fichero = analisis.partitura().midi()
let pieza = try PiezaImportada(leyendo: fichero)
pieza.tonalidadEstimada // Do mayor
