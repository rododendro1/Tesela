import Armonia

let dominante = Acorde("Sol7")
dominante.escalasCompatibles().first // Sol mixolidio
dominante.escalas().first?.motivo == .delCifrado // true
Acorde("Sol7(#11)").escalasCompatibles().first // Sol lidio dominante
Acorde("Sol7(b9)").escalasCompatibles().first // Sol disminuida semitono-tono
