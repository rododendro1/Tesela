import Armonia

let laMenor = Tonalidad(.la, .menor)
try laMenor.acordes(bajoCifrado: "La Fa:6 Mi:# La") // [Lam, Rem/Fa, Mi, Lam]
let realizado = try Coral(bajoCifrado: "La Fa:6 Mi:# La", en: laMenor)
realizado.esCorrecta // true
realizado.voz(0).map(\.nota) // [La, Fa, Mi, La]
