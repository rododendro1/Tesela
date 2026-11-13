import Armonia
import Foundation

// MARK: - Las opciones de una partitura
//
// `LineaDeComandos.partitura` lee aquí sus opciones, y escribe con ellas la música de cada tipo: una melodía, un
// coral, unos acordes, sus arpegios o una escala. Cada tipo comprueba las opciones que no son suyas.

/// Lo que se ha leído de una orden de partitura: la música, las opciones comunes a todos los tipos y, con
/// `--archivo`, los acordes del fichero.
struct OpcionesDePartitura {
    /// Los nombres de los tipos de acordes y de arpegios.
    static let tiposDeAcordes: Set = ["acordes", "progresion", "progresión", "chords"]
    static let tiposDeArpegios: Set = ["arpegios", "arpegio", "arpeggios", "arpeggio"]

    let tipo: String
    let formato: FormatoDePartitura
    let notacion: Notacion
    /// Los argumentos hasta la primera opción.
    let musica: [String]
    /// Las opciones con su texto, por su nombre en español sin tilde, y las marcas (`--cifrados`, `--analisis`).
    let opciones: [String: String]
    let marcas: Set<String>
    /// `--enlazar`: cada arpegio empieza cerca de donde acabó el anterior.
    let enlazados: Bool
    let instrumento: Int?
    let tonalidad: Tonalidad?
    var compas: Compas
    var tempo: Tempo?
    var titulo: String?
    /// Los acordes de `--archivo`, con su ritmo armónico; `nil` si no hay archivo.
    private(set) var leido: RitmoArmonico?

    /// El nombre de la orden (`musicxml`, `midi`…), para los errores.
    var orden: String { formato.rawValue }

    /// Lee las opciones de los argumentos que siguen al tipo. Cada opción toma lo que la sigue, y se lee con sus
    /// nombres en español y en inglés, y con tilde (`--compas`, `--time`, `--compás`). La clave y las marcas no son
    /// de MIDI, y el programa, solo de MIDI.
    init(_ argumentos: [String], tipo: String, formato: FormatoDePartitura, _ contexto: LineaDeComandos.ContextoDeOrden)
        throws
    {
        self.tipo = tipo
        self.formato = formato
        notacion = contexto.notacion
        var entrada = Argumentos(argumentos)
        enlazados = entrada.quitarMarca(.enlazar)
        let comunes: [OpcionDeOrden] = [
            .compas, .anacrusa, .en, .tempo, .titulo, .duracion, .patronDePartitura, .figuraDePartitura, .archivo,
            .ventana, .cifrados, .analisis,
        ]
        (opciones, marcas) = try entrada.quitarOpcionesConTexto(
            comunes + (formato == .midi ? [.programa] : [.claveDePartitura]))
        musica = entrada.restantes
        if let texto = opciones["programa"] {
            guard let n = Int(texto), (0...127).contains(n) else { throw ErrorDeUso.instrumentoMIDI }
            instrumento = n
        } else {
            instrumento = nil
        }
        if formato == .midi && !marcas.isEmpty { throw ErrorDeUso.marcasSoloMusicXML }
        if let vacia = opciones.sorted(by: { $0.key < $1.key }).first(where: { $0.value.isEmpty })?.key {
            throw ErrorDeUso.faltaValor(vacia)
        }
        compas = try opciones["compas"].map { try Compas(leyendo: $0) } ?? .compasillo
        let notacion = contexto.notacion
        tonalidad = try opciones["en"].map { try Tonalidad(leyendo: $0, enLaOrden: notacion) }
        if let texto = opciones["tempo"] {
            let partes = texto.split(separator: " ").map(String.init)
            guard let bpm = Double(partes[0].replacingComa()), bpm > 0, partes.count <= 2 else {
                throw ErrorDeUso.tempoMalEscrito
            }
            tempo = Tempo(bpm, unidad: try partes.dropFirst().first.map { try Duracion(leyendo: $0) } ?? .negra)
        }
        titulo = opciones["titulo"]
        let sonArpegios = OpcionesDePartitura.tiposDeArpegios.contains(tipo)
        if !sonArpegios, let opcion = ["figura", "patron"].first(where: { opciones[$0] != nil }) {
            throw ErrorDeUso.soloParaArpegios(opcion)
        }
        if !sonArpegios && enlazados { throw ErrorDeUso.soloParaArpegios("enlazar") }
    }

    /// `--archivo`: los acordes de un fichero MIDI, MusicXML, MEI o ABC, con su ritmo armónico (lo que dura cada
    /// uno), y su compás, su tempo y su título si no se dan otros.
    mutating func leerElArchivo(_ contexto: LineaDeComandos.ContextoDeOrden) throws {
        guard let archivo = opciones["archivo"] else {
            if opciones["ventana"] != nil { throw ErrorDeUso.ventanaSinArchivo }
            return
        }
        let tipos = OpcionesDePartitura.tiposDeAcordes.union(OpcionesDePartitura.tiposDeArpegios)
        guard tipos.contains(tipo) else { throw ErrorDeUso.archivoSoloParaAcordes }
        guard musica.isEmpty else { throw ErrorDeUso.archivoConAcordes }
        let datos = try LineaDeComandos.datos(deArchivo: archivo, contexto)
        let pieza = try PiezaImportada(leyendo: datos)
        let ventana = try opciones["ventana"].map { try Duracion(leyendo: $0) }
        let suyo = pieza.ritmoArmonico(ventana: ventana)
        guard !suyo.acordes.isEmpty else { throw ErrorDeUso.archivoSinAcordes }
        if opciones["compas"] == nil, let delFichero = pieza.compas { compas = delFichero }
        tempo = tempo ?? pieza.tempo
        titulo = titulo ?? pieza.titulo
        leido = RitmoArmonico(suyo.acordes, compas: compas, tempo: tempo)
    }

    // MARK: Lo que comparten los tipos

    /// Los acordes analizados, del fichero o escritos, y su ritmo (`nil`: el de `--duracion`); `nil` si no hay
    /// acordes.
    private func progresion() throws -> (analisis: AnalisisArmonico, ritmo: RitmoArmonico?)? {
        if let leido {
            let acordes = leido.acordes.map(\.acorde)
            let enSuTonalidad = tonalidad.map { $0.analizar(acordes) }
            guard let analisis = enSuTonalidad ?? AnalisisArmonico.analizar(acordes) else { return nil }
            // `--duracion` manda sobre el ritmo del fichero.
            return (analisis, opciones["duracion"] == nil ? leido : nil)
        }
        guard !musica.isEmpty else { return nil }
        return (try AnalisisArmonico.analizar(leyendo: musica.joined(separator: " "), en: tonalidad), nil)
    }

    /// `--clave`, si se da.
    private func claveDada() throws -> Clave? {
        guard let texto = opciones["clave"] else { return nil }
        guard let leida = LineaDeComandos.leerClave(texto) else { throw ErrorDeUso.claveDesconocida(texto) }
        return leida
    }

    /// La clave y la anacrusa son solo de la melodía (y la clave, también de la escala).
    private func sinClaveNiAnacrusa() throws {
        for opcion in ["clave", "anacrusa"] where opciones[opcion] != nil {
            throw ErrorDeUso.soloParaMelodia(opcion)
        }
    }

    /// `--duracion`, o la que se da si no está.
    private func duracionDada(siNo porDefecto: Duracion) throws -> Duracion {
        try opciones["duracion"].map { try Duracion(leyendo: $0) } ?? porDefecto
    }

    // MARK: Los tipos

    func melodia() throws -> Data {
        guard !musica.isEmpty else { throw ErrorDeUso.faltanNotasDeLaMelodia(orden: orden) }
        if !marcas.isEmpty { throw ErrorDeUso.marcasSoloCoral }
        if opciones["duracion"] != nil { throw ErrorDeUso.duracionSoloCoral }
        let clave = try claveDada()
        let anacrusa = try opciones["anacrusa"].map { try Duracion(leyendo: $0) } ?? .cero
        let voz = try Voz(leyendo: musica.joined(separator: " "), compas: compas, anacrusa: anacrusa)
        return voz.partitura(
            clave: clave,
            encabezado: Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento)
        ).exportar(como: formato)
    }

    func coral() throws -> Data {
        guard !musica.isEmpty else { throw ErrorDeUso.faltanAcordesDelCoral(orden: orden) }
        try sinClaveNiAnacrusa()
        let duracion = try duracionDada(siNo: .negra)
        let coral = try Coral(leyendo: musica.joined(separator: " "))
        // En MIDI no hay marcas: ya se ha comprobado.
        return coral.partitura(
            duracion: duracion, compas: compas,
            encabezado: Encabezado(titulo: titulo, tonalidad: tonalidad, tempo: tempo, instrumento: instrumento),
            conCifrados: marcas.contains("cifrados"), conAnalisis: marcas.contains("analisis"),
            notacion: notacion
        ).exportar(como: formato)
    }

    func acordes() throws -> Data {
        try sinClaveNiAnacrusa()
        if !marcas.isEmpty { throw ErrorDeUso.acordesConCifradosYAnalisis }
        let duracion = try duracionDada(siNo: .negra)
        guard let leida = try progresion() else { throw ErrorDeUso.faltanAcordesDeLaProgresion(orden: orden) }
        let (analisis, suyo) = leida
        let ritmo = suyo ?? RitmoArmonico(analisis.acordes.map(\.acorde), duracion: duracion, compas: compas)
        return ritmo.partitura(
            en: analisis.tonalidad,
            encabezado: Encabezado(titulo: titulo, tempo: tempo, instrumento: instrumento), notacion: notacion
        ).exportar(como: formato)
    }

    func arpegios() throws -> Data {
        try sinClaveNiAnacrusa()
        if !marcas.isEmpty { throw ErrorDeUso.acordesConCifradosYAnalisis }
        var patron = Arpegio.Patron.ascendente
        if let texto = opciones["patron"] {
            guard let elegido = LineaDeComandos.patronDeArpegio(texto) else {
                throw ErrorDeUso.patronDesconocido(texto)
            }
            patron = elegido
        }
        let figura = try opciones["figura"].map { try Duracion(leyendo: $0) } ?? .corchea
        if figura <= .cero, let texto = opciones["figura"] { // "0/4"
            throw ErrorDeLecturaDePartitura(texto: texto, posicion: nil, motivo: .duracionNoValida(texto))
        }
        let porAcorde = try opciones["duracion"].map { try Duracion(leyendo: $0) }
        // La tonalidad, la dada o la que mejor explica los acordes, pone la armadura.
        guard let leida = try progresion() else { throw ErrorDeUso.faltanAcordesDeLaProgresion(orden: orden) }
        let (analisis, ritmo) = leida
        let voz: Voz
        if let ritmo {
            voz = Voz(arpegiando: ritmo, patron: patron, figura: figura, enlazados: enlazados)
        } else {
            voz = Voz(
                arpegiando: analisis.acordes.map(\.acorde), patron: patron, figura: figura,
                porAcorde: porAcorde, compas: compas, enlazados: enlazados)
        }
        return voz.partitura(
            encabezado: Encabezado(
                titulo: titulo, tonalidad: analisis.tonalidad, tempo: tempo, instrumento: instrumento)
        ).exportar(como: formato)
    }

    /// Una escala en negras (o en lo que diga `--duracion`), con sus microtonos si los tiene.
    func escala() throws -> Data {
        guard !musica.isEmpty else { throw ErrorDeUso.faltaEscala }
        if !marcas.isEmpty { throw ErrorDeUso.marcasSoloCoral }
        if opciones["anacrusa"] != nil { throw ErrorDeUso.soloParaMelodia("anacrusa") }
        let clave = try claveDada()
        let escala = try Escala(leyendo: musica.joined(separator: " "), enLaOrden: notacion)
        var voz = escala.voz(duracion: try duracionDada(siNo: .negra))
        voz.compas = compas
        return voz.partitura(
            clave: clave,
            encabezado: Encabezado(
                titulo: titulo ?? escala.nombre(en: notacion), tonalidad: tonalidad, tempo: tempo,
                instrumento: instrumento)
        ).exportar(como: formato)
    }
}
