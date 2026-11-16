import Armonia

let bayati = Escala(.re, .bayati)
bayati.notas // Re Mi♭ Fa Sol La Si♭ Do
bayati.notasMicrotonales() // Re Mi𝄳 Fa Sol La Si♭ Do
bayati.afinacion()!.desviacion(de: "Mib4") // 50
