import Armonia

let yaman = Escala(.do, .yaman)
yaman.notas // Do Re Mi Fa♯ Sol La Si
TipoDeEscala.yaman.madre == .kalyan // true
TipoDeEscala.yaman.momentos // [anochecer]
TipoDeEscala.yaman.intervalo(de: .vadi) // .terceraMayor
TipoDeEscala.yaman.funciones(de: .septimaMayor).map(\.nombre) // ["saṃvādī"]
