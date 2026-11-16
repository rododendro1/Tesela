import Armonia

let laMenor = Tonalidad(.la, .menor)
try laMenor.acordes(bajoCifrado: "La Fa:6 Mi:# La") // [Lam, Rem/Fa, Mi, Lam]
