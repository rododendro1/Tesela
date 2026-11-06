import Armonia

Acorde.identificar(notas: [.mi, .sol, .do]).first // Do/Mi
Acorde.identificar(midi: [55, 59, 62, 65, 68]).first // Sol7(♭9)

let candidato = Acorde.candidatos(notas: [.do, .mi, "Sib"]).first!
candidato.valor.cifrado // "Do7"
candidato.omitidas // [Sol]
