import Elementos

// MARK: - El catálogo de progresiones
//
// Las progresiones con nombre: las cadencias y las secuencias de la armonía tonal, los esquemas del barroco y del
// estilo galante, las del jazz y el blues y las del pop. Cada una con sus grados en cifrado romano, su modo, sus
// estilos y dónde se lee. Los nombres en los otros idiomas están en `Progresiones/Nombres/`.

extension ProgresionConNombre {
    // MARK: Cadencias y secuencias de la armonía tonal

    public static let cadenciaPerfecta = ProgresionConNombre(
        nombre: "cadencia perfecta", cifrado: "V7 I", alias: ["cadencia auténtica"], estilos: [.clasica],
        referencias: [.aldwell2011])
    public static let cadenciaPlagal = ProgresionConNombre(
        nombre: "cadencia plagal", cifrado: "IV I", estilos: [.clasica], referencias: [.aldwell2011])
    public static let cadenciaRota = ProgresionConNombre(
        nombre: "cadencia rota", cifrado: "V7 vi", alias: ["cadencia de engaño", "cadencia interrumpida"],
        estilos: [.clasica], referencias: [.aldwell2011])
    public static let semicadencia = ProgresionConNombre(
        nombre: "semicadencia", cifrado: "I V", alias: ["cadencia suspensiva"], estilos: [.clasica],
        referencias: [.aldwell2011])
    /// La semicadencia en menor con el bajo que baja un semitono, del 6.º al 5.º: iv6–V.
    public static let cadenciaFrigia = ProgresionConNombre(
        nombre: "cadencia frigia", cifrado: "iv6 V", modo: .menor, estilos: [.clasica], referencias: [.aldwell2011])
    /// La sexta napolitana antes de la dominante: N6–V7–i.
    public static let cadenciaNapolitana = ProgresionConNombre(
        nombre: "cadencia napolitana", cifrado: "N6 V7 i", modo: .menor, estilos: [.clasica],
        referencias: [.aldwell2011])
    /// La sexta aumentada alemana, que se abre en la dominante: Ger+6–V–i.
    public static let cadenciaConSextaAumentada = ProgresionConNombre(
        nombre: "cadencia con sexta aumentada", cifrado: "Ger+6 V i", modo: .menor, estilos: [.clasica],
        referencias: [.aldwell2011])
    /// Las fundamentales bajan por quintas por todos los grados: I–IV–vii°–iii–vi–ii–V–I.
    public static let quintasDescendentes = ProgresionConNombre(
        nombre: "progresión por quintas", cifrado: "I IV vii° iii vi ii V I",
        alias: ["círculo de quintas", "quintas descendentes"], estilos: [.clasica, .jazz], referencias: [.aldwell2011])

    // MARK: Esquemas del barroco y del estilo galante

    /// La romanesca galante: baja una cuarta y sube una segunda, dos veces.
    public static let romanesca = ProgresionConNombre(
        nombre: "romanesca", cifrado: "I V vi iii", estilos: [.clasica], referencias: [.gjerdingen2007])
    public static let pachelbel = ProgresionConNombre(
        nombre: "canon de Pachelbel", cifrado: "I V vi iii IV I IV V", estilos: [.clasica, .popular],
        referencias: [.gjerdingen2007])
    /// La misma cadencia dos veces, un grado más arriba.
    public static let monte = ProgresionConNombre(
        nombre: "monte", cifrado: "V7/IV IV V7/V V", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// La misma cadencia dos veces, un grado más abajo, la primera en menor.
    public static let fonte = ProgresionConNombre(
        nombre: "fonte", cifrado: "V7/ii ii V7 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// La dominante que se mantiene sobre su bajo antes de ir a la tónica.
    public static let ponte = ProgresionConNombre(
        nombre: "ponte", cifrado: "V V7 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// El bajo 1–7–1 bajo la melodía 1–2–3.
    public static let doReMi = ProgresionConNombre(
        nombre: "do-re-mi", cifrado: "I V6 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// La folía: i–V–i–VII–III–VII–i–V, en menor.
    public static let folia = ProgresionConNombre(
        nombre: "folía", cifrado: "i V i VII III VII i V", modo: .menor, alias: ["follia", "folia de España"],
        estilos: [.clasica], referencias: [.hudson1982])
    /// El bajo que baja por grados de la tónica a la dominante: i–v6–iv6–V.
    public static let bajoDeLamento = ProgresionConNombre(
        nombre: "bajo de lamento", cifrado: "i v6 iv6 V", modo: .menor, alias: ["tetracordo descendente"],
        estilos: [.clasica], referencias: [.rosand1979])

    // MARK: Jazz y blues

    public static let iiVI = ProgresionConNombre(
        nombre: "ii–V–I", cifrado: "ii7 V7 Imaj7", estilos: [.jazz], referencias: [.levine1995])
    public static let iiVIMenor = ProgresionConNombre(
        nombre: "ii–V–i menor", cifrado: "iiø7 V7 i", modo: .menor, estilos: [.jazz], referencias: [.levine1995])
    public static let turnaround = ProgresionConNombre(
        nombre: "turnaround", cifrado: "Imaj7 vi7 ii7 V7", estilos: [.jazz], referencias: [.levine1995])
    /// La dominante por la puerta de atrás: un ii–V que resuelve un tono más arriba.
    public static let backdoor = ProgresionConNombre(
        nombre: "backdoor", cifrado: "iv7 ♭VII7 Imaj7", alias: ["ii–V por la puerta de atrás"], estilos: [.jazz],
        referencias: [.levine1995])
    /// Un acorde por compás.
    public static let blues = ProgresionConNombre(
        nombre: "blues de 12 compases", cifrado: "I7 I7 I7 I7 IV7 IV7 I7 I7 V7 IV7 I7 I7", alias: ["blues"],
        estilos: [.jazz, .blues], referencias: [.levine1995])
    public static let bluesMenor = ProgresionConNombre(
        nombre: "blues menor", cifrado: "i7 i7 i7 i7 iv7 iv7 i7 i7 VI7 V7 i7 i7", modo: .menor,
        estilos: [.jazz, .blues], referencias: [.levine1995])
    /// La sección A de «I Got Rhythm» (Gershwin, 1930).
    public static let rhythmChanges = ProgresionConNombre(
        nombre: "rhythm changes", cifrado: "Imaj7 vi7 ii7 V7 iii7 vi7 ii7 V7 Imaj7 I7 IVmaj7 iv7 iii7 vi7 ii7 V7",
        estilos: [.jazz], referencias: [.levine1995])
    /// Las tres tónicas a una tercera mayor de «Giant Steps» (Coltrane, 1959), cada una con su dominante.
    public static let coltrane = ProgresionConNombre(
        nombre: "cambios de Coltrane", cifrado: "Imaj7 V7/♭VI ♭VImaj7 V7/III IIImaj7 V7 Imaj7",
        alias: ["Coltrane changes"], estilos: [.jazz], referencias: [.levine1995])

    // MARK: Pop y rock

    public static let ejePop = ProgresionConNombre(
        nombre: "I–V–vi–IV", cifrado: "I V vi IV", alias: ["progresión de los cuatro acordes"],
        estilos: [.popular], referencias: [.doll2017])
    public static let deLos50 = ProgresionConNombre(
        nombre: "progresión de los 50", cifrado: "I vi IV V", alias: ["progresión doo-wop"], estilos: [.popular],
        referencias: [.doll2017])
    public static let eolica = ProgresionConNombre(
        nombre: "♭VI–♭VII–I", cifrado: "♭VI ♭VII I", alias: ["cadencia eólica"], estilos: [.popular],
        referencias: [.doll2017])
    public static let andaluza = ProgresionConNombre(
        nombre: "cadencia andaluza", cifrado: "i VII VI V", modo: .menor, alias: ["tetracordo andaluz"],
        estilos: [.popular], referencias: [.manuel1989])

    /// Todas, en este orden: la armonía tonal, el barroco y el galante, el jazz y el blues, y el pop.
    public static let catalogo: [ProgresionConNombre] = [
        .cadenciaPerfecta, .cadenciaPlagal, .cadenciaRota, .semicadencia, .cadenciaFrigia, .cadenciaNapolitana,
        .cadenciaConSextaAumentada, .quintasDescendentes, .romanesca, .pachelbel, .monte, .fonte, .ponte, .doReMi,
        .folia, .bajoDeLamento, .iiVI, .iiVIMenor, .turnaround, .backdoor, .blues, .bluesMenor, .rhythmChanges,
        .coltrane, .ejePop, .deLos50, .eolica, .andaluza,
    ]
}
