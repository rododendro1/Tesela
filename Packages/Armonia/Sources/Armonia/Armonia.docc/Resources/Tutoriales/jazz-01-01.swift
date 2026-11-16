import Armonia

let dominante = Acorde("Sol7")
dominante.escalasCompatibles().first // Sol mixolidio
dominante.escalas().first?.motivo == .delCifrado // true
