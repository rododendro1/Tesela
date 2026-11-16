import Armonia

let yaman = Escala(.do, .yaman)
yaman.notas // Do Re Mi Fa♯ Sol La Si
TipoDeEscala.yaman.madre == .kalyan // true
TipoDeEscala.yaman.momentos // [anochecer]
TipoDeEscala.yaman.intervalo(de: .vadi) // .terceraMayor
TipoDeEscala.yaman.funciones(de: .septimaMayor).map(\.nombre) // ["saṃvādī"]

TipoDeEscala.anandabhairavi.recorrido // [1, 3, 2, 3, 4, 5, 6, 5, 7]
TipoDeEscala.atana.recorrido // nil
TipoDeEscala.atana.recorridoDescendente // [8, 7, 6, 5, 4, 5, 3, 2, 1]
