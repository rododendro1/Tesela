import Elementos

// MARK: - El catálogo de progresiones
//
// Las progresiones con nombre: las cadencias y las secuencias de la armonía tonal, los esquemas del barroco y del
// estilo galante y los bajos de danza del Renacimiento, las del jazz y el blues y las del pop y el rock. Cada una con
// sus grados en cifrado romano, su modo, sus estilos y, si la hay, la obra donde se lee. Los nombres en los otros idiomas están en `Progresiones/Nombres/`.

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
    /// La tónica mayor al final de una pieza en menor: iv–V7–I.
    public static let picardia = ProgresionConNombre(
        nombre: "tercera de picardía", cifrado: "iv V7 I", modo: .menor, alias: ["cadencia picarda"],
        estilos: [.clasica], referencias: [.aldwell2011])
    /// La dominante que no resuelve en la tónica en estado fundamental: V–V42–I6.
    public static let evitada = ProgresionConNombre(
        nombre: "cadencia evitada", cifrado: "V V42 I6", estilos: [.clasica])
    /// Las fundamentales bajan por quintas por todos los grados: I–IV–vii°–iii–vi–ii–V–I.
    public static let quintasDescendentes = ProgresionConNombre(
        nombre: "progresión por quintas", cifrado: "I IV vii° iii vi ii V I",
        alias: ["círculo de quintas", "quintas descendentes"], estilos: [.clasica, .jazz], referencias: [.aldwell2011])

    // MARK: Esquemas del barroco y del estilo galante, y bajos de danza

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
    /// El bajo 4–3–2–1 bajo la melodía 6–5–4–3, que contesta a una apertura.
    public static let prinner = ProgresionConNombre(
        nombre: "Prinner", cifrado: "IV I6 V43 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// El bajo 7–1–2–3 bajo la melodía 4–3–7–1.
    public static let fenaroli = ProgresionConNombre(
        nombre: "Fenaroli", cifrado: "V65 I V43 I6", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// Sobre la tónica pedal, la melodía ♭7–6–♮7–8 tras una cadencia.
    public static let quiescenza = ProgresionConNombre(
        nombre: "quiescenza", cifrado: "I V7/IV IV64 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// El bajo 1–2–7–1 bajo la melodía 1–7–4–3.
    public static let meyer = ProgresionConNombre(
        nombre: "Meyer", cifrado: "I V43 V65 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// La melodía 5–4–3 sobre el bajo 1–2–3.
    public static let solFaMi = ProgresionConNombre(
        nombre: "sol-fa-mi", cifrado: "I V43 I6", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// El ii65 que se repite, y el bajo que sube por la sensible de la dominante, antes de la cadencia.
    public static let indugio = ProgresionConNombre(
        nombre: "indugio", cifrado: "ii65 V65/V V7 I", estilos: [.clasica], referencias: [.gjerdingen2007])
    /// La folía: i–V–i–VII–III–VII–i–V, en menor.
    public static let folia = ProgresionConNombre(
        nombre: "folía", cifrado: "i V i VII III VII i V", modo: .menor, alias: ["follia", "folia de España"],
        estilos: [.clasica], referencias: [.hudson1982])
    /// El bajo que baja por grados de la tónica a la dominante: i–v6–iv6–V.
    public static let bajoDeLamento = ProgresionConNombre(
        nombre: "bajo de lamento", cifrado: "i v6 iv6 V", modo: .menor, alias: ["tetracordo descendente"],
        estilos: [.clasica], referencias: [.rosand1979])
    /// El bajo de lamento por semitonos, de la tónica a la dominante: i–V6–V42/iv–IV6–iv6–V.
    public static let lamentoCromatico = ProgresionConNombre(
        nombre: "bajo de lamento cromático", cifrado: "i V6 V42/iv IV6 iv6 V", modo: .menor,
        alias: ["lamento cromático"], estilos: [.clasica])
    /// El bajo de danza del Renacimiento en menor: i–♭VII–i–V–III–♭VII–i–V–i.
    public static let passamezzoAntico = ProgresionConNombre(
        nombre: "passamezzo antico", cifrado: "i VII i V III VII i V i", modo: .menor, estilos: [.clasica],
        referencias: [.gerbino2001])
    /// El bajo de danza del Renacimiento en mayor: I–IV–I–V–I–IV–I–V–I.
    public static let passamezzoModerno = ProgresionConNombre(
        nombre: "passamezzo moderno", cifrado: "I IV I V I IV I V I", estilos: [.clasica],
        referencias: [.gerbino2001])
    /// El bajo de danza 1–4–2–5, 1–4–5–1.
    public static let ruggiero = ProgresionConNombre(
        nombre: "ruggiero", cifrado: "I IV ii V I IV V I", estilos: [.clasica], referencias: [.staiti2023])
    public static let bergamasca = ProgresionConNombre(
        nombre: "bergamasca", cifrado: "I IV V I", estilos: [.clasica],
        referencias: [.sheinberg2016.paginas("19")])
    /// El bajo de la chacona barroca en mayor: I–V–vi–V.
    public static let chacona = ProgresionConNombre(
        nombre: "chacona", cifrado: "I V vi V", estilos: [.clasica], referencias: [.hudsonChaconne1982])
    /// El bajo del pasacalle en menor: i–iv–V–i.
    public static let passacaglia = ProgresionConNombre(
        nombre: "pasacalle", cifrado: "i iv V i", modo: .menor, alias: ["passacaglia"], estilos: [.clasica],
        referencias: [.hudsonPassacaglia1982])

    // MARK: Jazz y blues

    public static let iiVI = ProgresionConNombre(
        nombre: "ii–V–I", cifrado: "ii7 V7 Imaj7", estilos: [.jazz], referencias: [.levine1995])
    /// Un ii–V que no resuelve en su tónica.
    public static let iiV = ProgresionConNombre(
        nombre: "ii–V", cifrado: "ii7 V7", estilos: [.jazz], referencias: [.levine1995])
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
    /// El ii–V con la dominante cambiada por su sustituto tritonal: ii7–subV7–Imaj7.
    public static let iiSubVI = ProgresionConNombre(
        nombre: "ii–subV–I", cifrado: "ii7 subV7 Imaj7", alias: ["ii–V con sustituto tritonal"], estilos: [.jazz],
        referencias: [.levine1995])
    /// El turnaround por terceras mayores descendentes, el de «Lady Bird» (Dameron, 1939).
    public static let dameron = ProgresionConNombre(
        nombre: "turnaround de Tadd Dameron", cifrado: "Imaj7 ♭III7 ♭VImaj7 ♭IImaj7",
        alias: ["turnaround de Lady Bird"], estilos: [.jazz])
    /// El blues de Charlie Parker («Blues for Alice», 1951), con un ii–V en casi cada compás.
    public static let birdBlues = ProgresionConNombre(
        nombre: "Bird blues",
        cifrado: "Imaj7 viiø7 V7/vi vi7 V7/V v7 I7 IV7 iv7 ♭VII7 iii7 V7/ii ♭iii7 ♭VI7 ii7 V7 Imaj7 V7/ii ii7 V7",
        alias: ["blues de Charlie Parker"], estilos: [.jazz, .blues])
    /// El ciclo de quintas de «Autumn Leaves» (Kosma, 1945): un ii–V–I a la tónica y otro a la relativa menor.
    public static let autumnLeaves = ProgresionConNombre(
        nombre: "progresión de Autumn Leaves", cifrado: "ii7 V7 Imaj7 IVmaj7 viiø7 V7/vi vi", estilos: [.jazz])

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
    public static let mixolidia = ProgresionConNombre(
        nombre: "I–♭VII–IV", cifrado: "I ♭VII IV", alias: ["progresión mixolidia"], estilos: [.popular])
    public static let eolicaRock = ProgresionConNombre(
        nombre: "i–♭VII–♭VI–♭VII", cifrado: "i VII VI VII", modo: .menor, estilos: [.popular])
    public static let laBamba = ProgresionConNombre(
        nombre: "I–IV–V–IV", cifrado: "I IV V IV", alias: ["progresión de La Bamba"], estilos: [.popular])
    /// La de «Creep» (Radiohead, 1992), con el III mayor y el iv prestado.
    public static let creep = ProgresionConNombre(
        nombre: "I–III–IV–iv", cifrado: "I III IV iv", alias: ["progresión de Creep"], estilos: [.popular])

    /// Todas, en este orden: la armonía tonal, el barroco, el galante y las danzas, el jazz y el blues, y el pop.
    public static let catalogo: [ProgresionConNombre] = [
        .cadenciaPerfecta, .cadenciaPlagal, .cadenciaRota, .semicadencia, .cadenciaFrigia, .cadenciaNapolitana,
        .cadenciaConSextaAumentada, .picardia, .evitada, .quintasDescendentes, .romanesca, .pachelbel, .monte, .fonte,
        .ponte, .doReMi, .prinner, .fenaroli, .quiescenza, .meyer, .solFaMi, .indugio, .folia, .bajoDeLamento,
        .lamentoCromatico, .passamezzoAntico, .passamezzoModerno, .ruggiero, .bergamasca, .chacona, .passacaglia,
        .iiVI, .iiV, .iiVIMenor, .turnaround, .backdoor, .blues, .bluesMenor, .rhythmChanges, .coltrane, .iiSubVI,
        .dameron, .birdBlues, .autumnLeaves, .ejePop, .deLos50, .eolica, .andaluza, .mixolidia, .eolicaRock, .laBamba,
        .creep,
    ]
}
