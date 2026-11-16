import Armonia

let bayati = Escala(.re, .bayati)
bayati.notas // Re Mi♭ Fa Sol La Si♭ Do
bayati.notasMicrotonales() // Re Mi𝄳 Fa Sol La Si♭ Do
bayati.afinacion()!.desviacion(de: "Mib4") // 50

TipoDeEscala.bayati.ajnas.map(\.fragmento.nombre) // ["jins Bayātī", "jins Nahāwand"]
TipoDeEscala.bayati.ajnas.map(\.grado) // [1, 4]
bayati.notas(de: TipoDeEscala.bayati.ajnas[1]) // [Sol, La, Si♭, Do, Re]
TipoDeEscala.bayati.intervalo(de: .ghammaz) // .cuartaJusta
