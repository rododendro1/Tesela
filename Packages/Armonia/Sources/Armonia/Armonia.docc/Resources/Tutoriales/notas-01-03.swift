import Armonia

let fa: Nota = "Fa#"
fa // Fa♯
let solBemol: Nota = "Solb"
fa == solBemol // false
fa.intervalo(hasta: solBemol) // 2ª disminuida
