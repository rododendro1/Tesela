/// Una opción de una orden de `armonia`: los nombres con que se escribe, en español y en inglés, y si la sigue un
/// valor (`--limite 5`) o es una marca (`--diagrama`). Cada opción se declara una vez, aquí, y de ahí salen a la vez
/// su lectura (`Argumentos.quitarMarca(_:)`, `Argumentos.valor(_:siFalta:)`…), la ayuda de las órdenes que la
/// explican (`EntradaDeAyuda.opciones`), el autocompletado y las propuestas ante una opción mal escrita.
///
///     var argumentos = Argumentos(["Sol7", "--instrumento", "ukelele", "--diagram"])
///     argumentos.quitarMarca(.diagrama)                   // true
///     try argumentos.valor(.instrumento)                  // "ukelele"
struct OpcionDeOrden: Hashable, Sendable {
    /// Los nombres que se enseñan y se completan: primero el español y luego el inglés.
    let nombres: [String]
    /// Otros que se leen igual, pero no se enseñan ni se completan: los que llevan tilde (`--patrón`).
    let ocultos: [String]
    /// Si la sigue un valor, o si es una marca que no lleva nada detrás.
    let llevaValor: Bool

    /// Una marca: `--diagrama`.
    static func marca(_ nombres: String..., ocultos: [String] = []) -> OpcionDeOrden {
        OpcionDeOrden(nombres: nombres, ocultos: ocultos, llevaValor: false)
    }

    /// Una opción con valor: `--limite 5`.
    static func valor(_ nombres: String..., ocultos: [String] = []) -> OpcionDeOrden {
        OpcionDeOrden(nombres: nombres, ocultos: ocultos, llevaValor: true)
    }

    /// Todos los nombres con que se lee.
    var leidos: [String] { nombres + ocultos }

    /// Para elegir con un `switch` por lo que se ha escrito: `case OpcionDeOrden.acorde:`.
    static func ~= (opcion: OpcionDeOrden, texto: String) -> Bool { opcion.leidos.contains(texto) }
}

extension OpcionDeOrden {
    // MARK: Las generales, que valen en cualquier orden (`LineaDeComandos.generales`)
    static let ingles = marca("--ingles", "--english")
    static let idioma = valor("--idioma", "--language")
    static let textos = valor("--textos", "--texts")
    static let escritura = valor("--escritura", "--writing")
    static let sistema = valor("--sistema", "--system")
    static let grafia = valor("--grafia", "--script", ocultos: ["--grafía"])
    static let fuente = valor("--fuente", "--source")
    static let subindices = marca("--subindices", "--subscripts")
    static let cifras = marca("--cifras", "--digits")
    static let json = marca("--json")
    static let salida = valor("-o", "--salida", "--output")

    // MARK: Las de la ayuda
    static let ayuda = marca("--help")
    static let version = marca("--version")

    // MARK: Lo que se dibuja (`tonnetz`, `tabla`, `cuadricula`, `hoja`) y la tonalidad (`--en`)
    static let acorde = valor("--acorde", "--chord")
    static let escala = valor("--escala", "--scale")
    static let clases = valor("--clases", "--pcs")
    static let recorrido = valor("--recorrido", "--sequence")
    static let camino = valor("--camino", "--shortest")
    static let ciclo = valor("--ciclo", "--cycle")
    static let en = valor("--en", "--in")

    // MARK: Las de las partituras, solo en español (las lee `Argumentos.quitarOpcionesConTexto`)
    static let compas = valor("--compas")
    static let anacrusa = valor("--anacrusa")
    static let claveDePartitura = valor("--clave")
    static let tempo = valor("--tempo")
    static let titulo = valor("--titulo")
    static let duracion = valor("--duracion")
    static let figuraDePartitura = valor("--figura")
    static let patronDePartitura = valor("--patron")
    static let cifrados = marca("--cifrados")
    static let analisis = marca("--analisis", ocultos: ["--análisis"])
    static let programa = valor("--programa", "--program")

    // MARK: Las demás, por orden alfabético
    static let acordes = marca("--acordes", "--chords")
    static let ajenas = marca("--ajenas", "--non-chord")
    static let ampliada = marca("--ampliada", "--extended")
    static let aproximacion = valor("--aproximacion", "--approach", ocultos: ["--aproximación"])
    static let archivo = valor("--archivo", "--file")
    static let arpegio = marca("--arpegio", "--arpeggio")
    static let bajando = marca("--bajando", "--descending")
    static let bajo = marca("--bajo", "--walking-bass")
    static let bajoCifrado = marca("--bajo-cifrado", "--figured-bass")
    static let barrido = marca("--barrido", "--sweep")
    static let bebop = marca("--bebop")
    static let caged = marca("--caged")
    static let cambiarClave = marca("--cambiar-clave", "--clef-changes")
    static let capo = valor("--capo")
    static let categoria = valor("--categoria", "--category", ocultos: ["--categoría"])
    static let clave = valor("--clave", "--clef")
    static let comparar = valor("--comparar", "--compare")
    static let completo = marca("--completo", "--complete")
    static let conIntervalo = valor("--con-intervalo", "--with-interval")
    static let conPaso = valor("--con-paso", "--with-step")
    static let conduccion = marca("--conduccion", "--voice-leading")
    static let debajo = marca("--debajo", "--below")
    static let dedos = marca("--dedos", "--fingers")
    static let dedosDeLaDigitacion = valor("--dedos", "--fingers")
    static let desde = valor("--desde", "--from")
    static let diagrama = marca("--diagrama", "--diagram")
    static let disposiciones = marca("--disposiciones", "--voicings")
    static let doble = marca("--doble", "--grand-staff")
    static let doce = marca("--doce", "--all-keys")
    static let ejes = valor("--ejes", "--axes")
    static let enTono = marca("--en-tono", "--in-key")
    static let enlazar = marca("--enlazar", "--connect")
    static let escalas = marca("--escalas", "--scales")
    static let escalera = marca("--escalera", "--brightness-ladder")
    static let especie = valor("--especie", "--species")
    static let espejo = marca("--espejo", "--mirror")
    static let estadisticas = marca("--estadisticas", "--statistics")
    static let figura = valor("--figura", "--figure")
    static let formas = marca("--formas", "--shapes")
    static let formato = valor("--formato", "--format")
    static let giro = valor("--giro", "--rotate")
    static let grados = valor("--grados", "--degrees")
    static let idaYVuelta = marca("--ida-y-vuelta", "--up-and-down")
    static let instrumento = valor("--instrumento", "--instrument")
    static let intervalos = marca("--intervalos", "--intervals")
    static let limite = valor("--limite", "--limit")
    static let mano = valor("--mano", "--hand")
    static let mapa = marca("--mapa", "--map")
    static let margen = valor("--margen")
    static let modos = marca("--modos", "--modes")
    static let modulaciones = valor("--modulaciones", "--modulations")
    static let motor = valor("--motor", "--engine")
    static let musicxml = marca("--musicxml")
    static let nombres = marca("--nombres", "--names")
    static let notas = valor("--notas", "--notes")
    static let notasGuia = marca("--notas-guia", "--guide-tones")
    /// En qué registro va el pentagrama.
    static let registro = valor("--registro", "--register")
    static let octavas = valor("--octavas", "--octaves")
    static let orden = valor("--orden", "--sort")
    static let origen = valor("--origen", "--origin")
    static let parecidas = marca("--parecidas", "--closest")
    static let patron = valor("--patron", "--pattern", ocultos: ["--patrón"])
    static let pentatonicas = marca("--pentatonicas", "--pentatonics")
    /// La digitación de piano de `escala`.
    static let piano = marca("--dedos", "--fingers")
    static let progresiones = marca("--progresiones", "--progressions")
    static let proponer = marca("--proponer", "--propose")
    static let propuestas = valor("--propuestas", "--proposals")
    static let quintas = marca("--quintas", "--fifths")
    static let regulares = marca("--regulares", "--maximally-even")
    static let rejilla = valor("--rejilla", "--grid")
    static let romanos = marca("--romanos", "--roman")
    static let secuencia = valor("--secuencia", "--sequence")
    static let semitonos = marca("--semitonos", "--semitones")
    static let simetria = marca("--simetria", "--symmetry")
    static let sinIntervalo = valor("--sin-intervalo", "--without-interval")
    static let sinOctava = marca("--sin-octava", "--no-octave")
    static let sinSemitonos = marca("--sin-semitonos", "--anhemitonic")
    static let sobre = valor("--sobre", "--over")
    static let sustituciones = marca("--sustituciones", "--substitutions")
    static let tab = marca("--tab")
    static let tensiones = valor("--tensiones", "--tensions")
    static let tonalidad = valor("--tonalidad", "--key")
    static let tonalidades = marca("--tonalidades", "--keys")
    static let tonica = marca("--tonica", "--tonic", ocultos: ["--tónica"])
    static let tradicion = valor("--tradicion", "--tradition", ocultos: ["--tradición"])
    static let traste = valor("--traste", "--fret")
    static let tresillos = marca("--tresillos", "--triplets")
    static let triadas = marca("--triadas", "--triads")
    static let uso = valor("--uso", "--use")
    static let vecinas = marca("--vecinas", "--neighbors")
    /// `escalas --vecinas Re dórico`, `--parecidas`, `--escalera`: como las marcas de `escala`, pero con la escala detrás.
    static let vecinasDe = valor("--vecinas", "--neighbors")
    static let parecidasA = valor("--parecidas", "--closest")
    static let escaleraDe = valor("--escalera", "--brightness-ladder")
    static let ventana = valor("--ventana", "--window")
    static let voces = valor("--voces", "--voices")
}
