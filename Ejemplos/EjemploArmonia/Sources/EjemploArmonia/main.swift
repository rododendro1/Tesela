import Armonia
import Foundation

// Un recorrido por la API del motor, de lo más simple a lo más compuesto: notas e intervalos, acordes, escalas y
// tonalidades, afinaciones, notación, partituras, teoría postonal y análisis. Cada sección se lee sola.
//
// Los valores que se escriben en el código van como literales (`let acorde: Acorde = "Sol7/Si"`): un literal mal
// escrito es un error de programación y detiene la ejecución. Lo que llega de fuera se lee con `init(leyendo:)`, que
// lanza un error con la posición y el motivo (véase «Errores de lectura»).

// MARK: - Utilidades del ejemplo

func titulo(_ texto: String) { print("\n== \(texto) ==") }

/// El texto relleno con espacios hasta `ancho` caracteres, para alinear columnas.
func columna(_ texto: String, _ ancho: Int) -> String {
    texto.padding(toLength: max(ancho, texto.count), withPad: " ", startingAt: 0)
}

/// Los valores en una línea: «Do4 Mi4 Sol4».
func lista(_ valores: some Sequence<some CustomStringConvertible>, separador: String = " ") -> String {
    valores.map(\.description).joined(separator: separador)
}

/// Los nombres en español en una línea: «Do Mi Sol».
func nombres(_ valores: some Sequence<some Nombrable>, separador: String = " ") -> String {
    valores.map(\.nombre).joined(separator: separador)
}

/// Un número con dos decimales: «329.63».
func dosDecimales(_ valor: Double) -> String { String(format: "%.2f", valor) }

// MARK: - Notas e intervalos

titulo("Línea de quintas")
for pasos in -8...8 {
    print(columna(String(pasos), 4), Nota(pasosDeQuinta: pasos))
}

titulo("Notas")
let la: Altura = "La4"
print(la, "MIDI", la.midi, "→", la.frecuencia(), "Hz; coordenadas (\(la.pasosDeQuinta), \(la.pasosDeOctava))")
let doBemol: Altura = "Dob4"
print(doBemol, "MIDI", doBemol.midi, "— enarmónica de", Altura(midi: 59))
let faSostenido: Altura = "Fa#4"
let solBemol: Altura = "Solb4"
print(
    "\(faSostenido) ≠ \(solBemol):", faSostenido != solBemol, "· enarmónicas:", faSostenido.esEnarmonica(de: solBemol))
let mi: Altura = "Mi4"
print(
    "Mi4 temperado vs pitagórico:", dosDecimales(mi.frecuencia()), "Hz ·",
    dosDecimales(mi.frecuencia(en: TemperamentoRegular.pitagorico)), "Hz")
print("Alteraciones:", (-3...3).map { Alteracion($0).nombre }.joined(separator: ", "))

titulo("Intervalos")
let pares: [(Altura, Altura)] = [
    ("Do4", "Mi4"), ("Fa4", "Si4"), ("Si3", "Fa4"), ("Do4", "Re5"), ("Sol4", "Do4"), ("Do4", "Do#4"),
]
for (desde, hasta) in pares {
    let intervalo = hasta - desde
    print(
        "\(desde) → \(hasta):", intervalo,
        "(\(intervalo.abreviatura), \(intervalo.semitonos) st,",
        "coordenadas (\(intervalo.pasosDeQuinta), \(intervalo.pasosDeOctava)))")
}
print("Inversión de 3M:", Intervalo.terceraMayor.inversion)
print("3M + 3m =", Intervalo.terceraMayor + .terceraMenor)
print(
    "Do + 4A =", Nota.do + .cuartaAumentada, "· Do + 5d =", Nota.do + .quintaDisminuida, "· Re + 3M =", Nota.re + "3M")
let tritono: Intervalo = "4A"
print("4A < 5d:", tritono < .quintaDisminuida)
for intervalo in [Intervalo.terceraMayor, .cuartaJusta, .cuartaAumentada, .segundaAumentada, .novenaMenor] {
    print("  \(intervalo.nombre): clase \(intervalo.claseIntervalica), \(intervalo.consonancia())")
}
print(
    "Razones justas:",
    [Intervalo.terceraMayor, .terceraMenor, .septimaMayor, .cuartaAumentada]
        .map { "\($0.abreviatura) \($0.razonJusta)" }.joined(separator: " · "))

// MARK: - Acordes

titulo("Acordes")
let acordes: [Acorde] = ["Do", "Rem7", "Sol7/Si", "Fa#m7b5", "Sibmaj7", "Mi°7"]
for acorde in acordes {
    print(
        columna(acorde.cifrado, 9), nombres(acorde.notasDesdeElBajo),
        "·", lista(acorde.posicionCerrada(octava: 3)), "·", acorde.nombre)
}

titulo("Cifrado generativo")
// Se escribe el texto tal como llega para compararlo con el cifrado que da el motor.
for texto in ["G7(b9,#11)", "Dm11", "Sol13sus4", "Do6/9", "Fa7alt", "Mibmaj7#11", "Do/Re", "La-7"] {
    let acorde = try! Acorde(leyendo: texto)
    print(columna(texto, 12), "→", columna(acorde.cifrado, 22), nombres(acorde.notasDesdeElBajo))
}

titulo("Estilos de cifrado")
let muestra: [Acorde] = ["Sib7(b9)/Re", "Do#m7b5", "Mibmaj7", "Fa+", "Rem(add9)"]
let estilos: [(nombre: String, estilo: EstiloDeCifrado)] = [
    ("predeterminado", .predeterminado), ("ascii", .ascii(.espanol)), ("internacional", .ascii(.ingles)),
    ("compacta inglesa", .compacta(.ingles)), ("jazz", .jazz), ("palabras", .calidadesConPalabras),
]
for (nombre, estilo) in estilos {
    print(columna(nombre, 17), muestra.map { $0.cifrado(estilo: estilo) }.joined(separator: "  "))
}

titulo("Estructura del acorde")
let alterado: Acorde = "Sol13(b9)"
for componente in alterado.componentes {
    print("  \(columna(componente.nota.nombre, 4)) \(componente.intervalo.nombre) — \(componente.papel)")
}
if let tercera = alterado.tercera, let septima = alterado.septima {
    print(
        "  tercera:", tercera, "· séptima:", septima, "· tensiones:", nombres(alterado.tensiones),
        "· tríada:", alterado.estructura.calidadDeTriada)
}

titulo("Identificación")
let alturas: [Altura] = ["Mi3", "Sol3", "Do4", "La3"]
print("\(lista(alturas)) →", Acorde.identificar(alturas: alturas).map(\.cifrado).joined(separator: " · "))
let conjuntos: [[Nota]] = [
    ["Do", "Mi", "Sib"], ["Do", "Mi", "Sib", "Reb"], ["Re", "Do", "Mi", "Sol"], ["Mi", "Sol", "Do", "Mi"],
]
// Con notas que faltan o sobran: cada lectura dice cuánto cuesta y qué notas omite.
for notas in conjuntos {
    let lecturas = Acorde.candidatos(notas: notas).prefix(3).map { candidato in
        let faltan = candidato.omitidas.isEmpty ? "" : " sin " + nombres(candidato.omitidas, separador: ",")
        return "\(candidato.valor.cifrado) (\(candidato.coste)\(faltan))"
    }
    print(nombres(notas), "→", lecturas.joined(separator: " · "))
}

titulo("Identificación desde MIDI")
for midi in [[60, 64, 68], [61, 65, 68], [60, 63, 66, 69], [55, 59, 62, 65, 68], [64, 67, 72], [62, 72, 76, 79]] {
    let lecturas = Acorde.candidatos(midi: midi).prefix(3)
    guard let mejor = lecturas.first?.valor else { continue }
    print(
        "\(midi) →", lecturas.map(\.valor.cifrado).joined(separator: " · "),
        "  escrito:", lista(mejor.ortografiar(midi: midi)))
}
if let enSolBemol = Acorde.identificar(midi: [66, 70, 73], tonalidad: "Solb mayor").first {
    print("[66, 70, 73] en Sol♭ mayor →", enSolBemol)
}

// MARK: - Escalas y tonalidades

titulo("Escalas")
let escalas: [Escala] = ["Do mayor", "Mib mayor", "La menor armónica", "Re dórico", "Fa# lidio", "Do tonos enteros"]
for escala in escalas {
    let armadura = escala.armadura.map(String.init) ?? "—"
    print(columna(escala.nombre, 20), nombres(escala.notas), "· armadura:", armadura)
}
let mibMayor: Escala = "Mib mayor"
print("Notas de la armadura de Mi♭ mayor:", nombres(mibMayor.notasDeLaArmadura ?? []))
let doSostenidoMayor: Escala = "Do# mayor"
print("Do♯ mayor →", doSostenidoMayor.enarmonicaMasSimple)
print("Círculo de quintas:", Escala.circuloDeQuintas().map(\.tonica.nombre).joined(separator: " "))
print("Grados de Do mayor:", (1...7).compactMap { Escala(.do).nombreDeGrado($0)?.nombre }.joined(separator: ", "))
print(
    "Escalas con Do Mi Sol Si Fa♯:",
    nombres(Escala.identificar(notas: [.do, .mi, .sol, .si, "Fa#"]).prefix(6), separador: ", "))

titulo("Modos")
for escala in [Escala(.do), Escala(.la, .menorMelodica)] {
    print("\(escala):", (1...7).map { escala.modo(grado: $0).nombre }.joined(separator: ", "))
}
print("La menor melódica bajando:", lista(Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente)))

titulo("Armonización")
for escala in [Escala(.do), Escala(.la, .menorArmonica), Escala(.la, .menorMelodica)] {
    print(escala)
    print("  ", escala.armonizar(cuatriadas: true).map { $0?.cifrado ?? "?" }.joined(separator: "  "))
    print("  ", escala.cifradosRomanos(cuatriadas: true).map { $0 ?? "?" }.joined(separator: "  "))
}
print(
    "La menor armónica (ref. menor natural):",
    Escala(.la, .menorArmonica).cifradosRomanos(referencia: .menorNatural).map { $0 ?? "?" }.joined(separator: "  "))

titulo("Escalas de la India y dromoi griegos")
for tipo in [TipoDeEscala.melakarta(15)!, .todi, .hitzaz, .houzam] {
    let escala = Escala(.re, tipo)
    print("  \(escala.nombre):", nombres(escala.notas))
}
print("  La escala mayor es el mēḷa", TipoDeEscala.mayor.numeroDeMelakarta ?? 0)
let rast = Escala(.re, .rast)
print(
    "  \(rast.nombre): sube", lista(rast.alturas(octava: 4)),
    "· baja", lista(rast.alturas(octava: 4, sentido: .descendente)))
print("  Otros nombres de la escala mayor:", TipoDeEscala.mayor.equivalentes.map(\.nombre).joined(separator: ", "))

titulo("Tonalidad")
let laMenor: Tonalidad = "La menor"
print("  \(laMenor): armadura \(laMenor.armadura), relativa \(laMenor.relativa), homónima \(laMenor.homonima)")
print("  Armonía:", laMenor.armonizar(cuatriadas: true).map(\.cifrado).joined(separator: " "))
print("  Cifrado romano:", laMenor.cifradosRomanos(cuatriadas: true).joined(separator: " "))
if let sol = laMenor.nombreDeGrado(de: .sol), let solSostenido = laMenor.nombreDeGrado(de: "Sol#") {
    print("  Sol y Sol♯:", sol, "/", solSostenido)
}
print("  Tonos vecinos:", nombres(laMenor.vecinas, separador: ", "))
print("  Círculo de quintas menor:", Tonalidad.circuloDeQuintas(.menor).map(\.tonica.nombre).joined(separator: " "))

titulo("Ortografía y detección de tonalidad")
let melodia = [69, 71, 72, 74, 76, 77, 80, 81, 80, 78, 77, 76]
let estimacion = Tonalidad.candidatos(midi: melodia)
print(
    "Tonalidad estimada:",
    estimacion.prefix(3).map { "\($0.valor) (\(dosDecimales($0.correlacion)))" }.joined(separator: " · "))
if let tonalidad = estimacion.first?.valor {
    print("Escrita en \(tonalidad):", lista(tonalidad.ortografiar(midi: melodia)))
}
let cromatica = Array(60...72)
print("Cromática en Do mayor ↑:", Escala(.do).ortografiar(midi: cromatica).map(\.nota.nombre).joined(separator: " "))
print(
    "Cromática en Do mayor ↓:",
    Escala(.do).ortografiar(midi: Array(cromatica.reversed())).map(\.nota.nombre).joined(separator: " "))

// MARK: - Afinaciones

titulo("Afinaciones")
let afinaciones: [(nombre: String, sistema: any SistemaDeAfinacion)] = [
    ("igual", TemperamentoRegular.igual), ("pitagórico", TemperamentoRegular.pitagorico),
    ("mesotónico ¼", TemperamentoRegular.mesotonicoCuartoDeComa),
    ("31 divisiones", TemperamentoRegular.igual(divisiones: 31)),
    ("justa en Do", AfinacionJusta(tonica: .do)),
]
let notasAfinadas: [Altura] = ["Do4", "Mi4", "Sol4", "La4", "Sol#4", "Lab4"]
for (nombre, sistema) in afinaciones {
    print(
        columna(nombre, 14),
        notasAfinadas.map { "\($0) \(dosDecimales(sistema.frecuencia(de: $0)))" }.joined(separator: "  "))
}

titulo("Base 40, 54 y 600")
let notasHewlett: [Altura] = ["Do4", "Fa#4", "Solb4", "Si#3"]
for base in [BaseDeHewlett.base40, .base54, .base600] {
    let numeros = notasHewlett.map { "\($0)=\($0.numero(en: base).map(String.init) ?? "—")" }
    print("  \(base):", numeros.joined(separator: " "), "· 5ª justa =", Intervalo.quintaJusta.numero(en: base) ?? 0)
}

// MARK: - Notación

titulo("Notación internacional")
let ingles = Notacion.ascii(.ingles)
let ejemploAcorde: Acorde = "Sib7(b9)/Re"
let faSostenido3: Altura = "Fa#3"
let dorico: Escala = "Re dórico"
print(
    "Se escribe:", ejemploAcorde.cifrado(en: ingles), "·", ejemploAcorde.nombre(en: ingles), "·",
    Intervalo.cuartaAumentada.abreviatura(en: ingles), "·", Intervalo.novenaMenor.nombre(en: ingles), "·",
    faSostenido3.nombre(en: ingles), "·", dorico.nombre(en: ingles), "·", laMenor.nombre(en: ingles))
print("Círculo de quintas:", Tonalidad.circuloDeQuintas().map { $0.tonica.nombre(en: ingles) }.joined(separator: " "))
// Y se lee: la lectura admite también la notación inglesa.
let quintaEnIngles: Intervalo = "P5"
let menorArmonicaEnIngles: Escala = "Bb harmonic minor"
print("Se lee: P5 →", quintaEnIngles, "· Bb harmonic minor →", menorArmonicaEnIngles)

titulo("Otras lenguas")
let notasTraducidas: [Nota] = ["Do#", "Mib", "Sib", "Si"]
let faSostenidoMayor: Tonalidad = "Fa# mayor"
let siMenorSeptima: Acorde = "Sim7"
for notacion in [
    Notacion.compacta(.aleman), .conPalabras(.frances), .conPalabras(.italiano), .conPalabras(.catalan),
    .conPalabras(.gallego), .conPalabras(.euskera), .conPalabras(.portugues),
] {
    print(
        "  \(columna(notacion.textos.nombrePropio + ":", 10))",
        notasTraducidas.map { $0.nombre(en: notacion) }.joined(separator: ", "),
        "·", faSostenidoMayor.nombre(en: notacion), "·", siMenorSeptima.cifrado(en: notacion))
}

titulo("Colores de las notas")
for correspondencia in CorrespondenciaDeColores.allCases {
    print(
        "  \(correspondencia):", Escala(.do).colores(segun: correspondencia).map(\.hexadecimal).joined(separator: " "))
}

// MARK: - Partituras

titulo("Pentagrama")
let posiciones: [(clave: Clave, notas: [Altura])] = [
    (.sol, ["Do4", "Sol4", "La5"]), (.fa, ["Sol2", "Do4"]), (.doEnTercera, ["Do4", "Fa3"]),
]
for (clave, notas) in posiciones {
    print("  \(clave):", notas.map { "\($0) → \(clave.posicion(de: $0))" }.joined(separator: " · "))
}
if let clave = Clave.masAdecuada(para: ["Do2", "Mi2", "Sol2"]) {
    print("  Clave para Do2–Mi2–Sol2:", clave)
}

titulo("Instrumentos transpositores")
let concierto: Escala = "Mib mayor"
let doEscrito: Altura = "Do5"
for instrumento in [InstrumentoDePartitura.clarineteEnSib, .saxofonAlto, .trompaEnFa, .saxofonTenor] {
    print(
        "  \(instrumento): Mi♭ mayor de concierto se escribe en \(instrumento.escritura(de: concierto)),",
        "Do5 escrito suena \(instrumento.sonido(de: doEscrito))")
}

titulo("Melodías")
let tema: Melodia = ["Do4", "Re4", "Mi4", "Do4", "Sol4"]
print("  original:   ", tema)
print("  inversión:  ", tema.invertir())
print("  retrógrado: ", tema.retrogradar())
print("  +2M real:   ", tema.transponer(.segundaMayor))
print("  +1 grado:   ", tema.transponer(grados: 1, en: Escala(.do)).map(String.init(describing:)) ?? "—")
print("  desde MIDI: ", Melodia(midi: [62, 64, 65, 67, 69, 70, 73, 74]))

titulo("Ritmo")
let voz = try! Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4", compas: "3/4")
let tempo = Tempo(90)
print("  Voz:", voz)
print("  Compases:", voz.compases.map { $0.map(\.texto).joined(separator: " ") }.joined(separator: " | "))
print("  Duración:", voz.duracion, "· a", tempo, "dura", voz.segundos(tempo: tempo), "s")
// La escritura con métrica parte y liga las figuras que cruzan los tiempos fuertes del compás.
let sincopa = try! Voz(leyendo: "Do4:8 Re4:4 Mi4:8 Fa4:4 Sol4:2 La4:4 Si4:4", compas: "4/4")
print(
    "  Escritura con métrica:", sincopa.grafia.map { $0.map(\.texto).joined(separator: " ") }.joined(separator: " | "))
print("  7/8:", Compas("7/8").agrupacion, "· 3+2+2/8:", Compas("3+2+2/8").agrupacion)
print("  Figuras:", Figura.allCases.map { "\($0.nombre) (\($0.duracion.texto))" }.joined(separator: ", "))

// MARK: - Teoría postonal

titulo("Conjuntos de clases de altura")
let conjuntosDeClases: [(nombre: String, conjunto: ConjuntoDeClasesDeAltura)] = [
    ("Do mayor", Acorde("Do").conjuntoDeClasesDeAltura), ("Sol7", Acorde("Sol7").conjuntoDeClasesDeAltura),
    ("diatónica", Escala(.re).conjuntoDeClasesDeAltura), ("[0,1,4,6]", [0, 1, 4, 6]),
]
for (nombre, conjunto) in conjuntosDeClases {
    let nombreComun = conjunto.nombreComun.map { ", " + $0 } ?? ""
    print(
        "  \(nombre): forma prima \(conjunto.formaPrima), \(conjunto.numeroDeForte ?? "—"),",
        "vector \(conjunto.vectorIntervalico)\(nombreComun)")
}
print("  Sol7 y Sim7(♭5), de la misma clase:", Acorde("Sol7").esDeLaMismaClase(que: Acorde("Sim7b5")))

// MARK: - Análisis

titulo("Análisis de progresiones")
for progresion in [
    "Do Lam Re7 Sol7 Do", "Sim7(b5) Mi7 Lam", "Do Fa/La Sol7/Si Do", "Do Lab Sib Do", "Do Reb/Fa Sol7 Do",
] {
    let analisis = try! AnalisisArmonico.analizar(leyendo: progresion)
    let funciones = analisis.funciones.map { $0?.abreviatura ?? "–" }.joined(separator: " ")
    print("  \(progresion): \(analisis)  (\(funciones))")
}

titulo("Conducción de voces")
for texto in [
    "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5",
    "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5 | Fa3 Do4 La4 Fa5",
] {
    let coral = try! Coral(leyendo: texto)
    print("  \(texto)")
    if coral.esCorrecta { print("    correcta") }
    for falta in coral.faltas { print("    \(falta)") }
}

// MARK: - Protocolos comunes

titulo("Protocolos comunes")
// `Transponible`: lo que se transpone con `+` sirve para una función genérica.
func subirQuinta<T: Transponible>(_ valor: T) -> T { valor + .quintaJusta }
print(
    "  Una quinta más arriba:", subirQuinta(Nota.do), "·", subirQuinta(Acorde("Do7/Mi")), "·",
    subirQuinta(Escala(.re, .dorico)), "·", subirQuinta(Melodia(["Do4", "Mi4", "Sol4"])))
print("  Secuencia de quintas:", nombres(Nota.do.secuencia(.quintaJusta, veces: 11)))
// `Nombrable`: cualquier valor con nombre se escribe en la notación que se pida.
let nombrables: [any Nombrable] = [
    Intervalo.cuartaAumentada, TipoDeAcorde.semidisminuido, Escala("Mi frigio dominante"),
    NombreDeGrado.sensible, Clave.doEnTercera, InstrumentoDePartitura.saxofonAlto,
]
for valor in nombrables {
    print("  \(valor.nombre(en: .compacta(.espanol))) — \(valor.nombre(en: ingles))")
}
// `RepresentableComoTexto`: se lee y se escribe como texto, y por eso también como JSON.
let textos: [any RepresentableComoTexto] = [Nota("Fa#"), Intervalo.septimaMenor, Acorde("Sib7(b9)/Re")]
print("  En notación internacional:", textos.map { $0.texto(en: ingles) }.joined(separator: " · "))
let json = try! JSONEncoder().encode([Acorde("Sol7/Si"), "Fa#m7b5"])
print("  JSON:", String(decoding: json, as: UTF8.self))

// MARK: - Errores de lectura

titulo("Errores de lectura")
// `init(leyendo:)` dice dónde está el problema y por qué; es lo que hay que usar con lo que escribe una persona.
func mostrarElError(_ leer: () throws -> Any) {
    do { _ = try leer() } catch { print(error) }
}
for texto in ["Do7(b3)", "Do7 9", "Do/Xa", "Dom5"] {
    mostrarElError { try Acorde(leyendo: texto) }
}
mostrarElError { try Escala(leyendo: "Re dorian") }
