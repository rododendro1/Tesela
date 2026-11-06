// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension RepresentableComoTexto {
    /// Lo de antes de `try? T(leyendo:)`: el valor de un texto, o `nil` si no se puede leer.
    @available(*, deprecated, message: "usa try? T(leyendo:)")
    public init?(texto: String) {
        guard let valor = try? Self(leyendo: texto) else { return nil }
        self = valor
    }
}

// Las notaciones y las escrituras con nombre de los idiomas que no son el español ni el inglés: ahora
// `.compacta(_:)` y `.conPalabras(_:)` con el idioma.

extension Notacion {
    @available(*, deprecated, message: "usa conPalabras(.catalan)")
    public static var catalanPalabras: Notacion { .conPalabras(.catalan) }
    @available(*, deprecated, message: "usa compacta(.catalan)")
    public static var catalanCompacto: Notacion { .compacta(.catalan) }
    @available(*, deprecated, message: "usa conPalabras(.gallego)")
    public static var gallegoPalabras: Notacion { .conPalabras(.gallego) }
    @available(*, deprecated, message: "usa compacta(.gallego)")
    public static var gallegoCompacto: Notacion { .compacta(.gallego) }
    @available(*, deprecated, message: "usa conPalabras(.asturiano)")
    public static var asturianoPalabras: Notacion { .conPalabras(.asturiano) }
    @available(*, deprecated, message: "usa compacta(.asturiano)")
    public static var asturianoCompacto: Notacion { .compacta(.asturiano) }
    @available(*, deprecated, message: "usa conPalabras(.aragones)")
    public static var aragonesPalabras: Notacion { .conPalabras(.aragones) }
    @available(*, deprecated, message: "usa compacta(.aragones)")
    public static var aragonesCompacto: Notacion { .compacta(.aragones) }
    @available(*, deprecated, message: "usa conPalabras(.euskera)")
    public static var euskeraPalabras: Notacion { .conPalabras(.euskera) }
    @available(*, deprecated, message: "usa compacta(.euskera)")
    public static var euskeraCompacto: Notacion { .compacta(.euskera) }
    @available(*, deprecated, message: "usa conPalabras(.portugues)")
    public static var portuguesPalabras: Notacion { .conPalabras(.portugues) }
    @available(*, deprecated, message: "usa compacta(.portugues)")
    public static var portuguesCompacto: Notacion { .compacta(.portugues) }
    @available(*, deprecated, message: "usa conPalabras(.frances)")
    public static var francesPalabras: Notacion { .conPalabras(.frances) }
    @available(*, deprecated, message: "usa compacta(.frances)")
    public static var francesCompacto: Notacion { .compacta(.frances) }
    @available(*, deprecated, message: "usa conPalabras(.occitano)")
    public static var occitanoPalabras: Notacion { .conPalabras(.occitano) }
    @available(*, deprecated, message: "usa compacta(.occitano)")
    public static var occitanoCompacto: Notacion { .compacta(.occitano) }
    @available(*, deprecated, message: "usa conPalabras(.italiano)")
    public static var italianoPalabras: Notacion { .conPalabras(.italiano) }
    @available(*, deprecated, message: "usa compacta(.italiano)")
    public static var italianoCompacto: Notacion { .compacta(.italiano) }
    @available(*, deprecated, message: "usa conPalabras(.aleman)")
    public static var alemanPalabras: Notacion { .conPalabras(.aleman) }
    @available(*, deprecated, message: "usa compacta(.aleman)")
    public static var alemanCompacto: Notacion { .compacta(.aleman) }
    @available(*, deprecated, message: "usa conPalabras(.griego)")
    public static var griegoPalabras: Notacion { .conPalabras(.griego) }
    @available(*, deprecated, message: "usa compacta(.griego)")
    public static var griegoCompacto: Notacion { .compacta(.griego) }
    @available(*, deprecated, message: "usa conPalabras(.ruso)")
    public static var rusoPalabras: Notacion { .conPalabras(.ruso) }
    @available(*, deprecated, message: "usa compacta(.ruso)")
    public static var rusoCompacto: Notacion { .compacta(.ruso) }
    @available(*, deprecated, message: "usa conPalabras(.hungaro)")
    public static var hungaroPalabras: Notacion { .conPalabras(.hungaro) }
    @available(*, deprecated, message: "usa compacta(.hungaro)")
    public static var hungaroCompacto: Notacion { .compacta(.hungaro) }
}

extension EscrituraDeNotas {
    @available(*, deprecated, message: "usa conPalabras(.catalan)")
    public static var catalanPalabras: EscrituraDeNotas { .conPalabras(.catalan) }
    @available(*, deprecated, message: "usa compacta(.catalan)")
    public static var catalanCompacto: EscrituraDeNotas { .compacta(.catalan) }
    @available(*, deprecated, message: "usa conPalabras(.gallego)")
    public static var gallegoPalabras: EscrituraDeNotas { .conPalabras(.gallego) }
    @available(*, deprecated, message: "usa compacta(.gallego)")
    public static var gallegoCompacto: EscrituraDeNotas { .compacta(.gallego) }
    @available(*, deprecated, message: "usa conPalabras(.asturiano)")
    public static var asturianoPalabras: EscrituraDeNotas { .conPalabras(.asturiano) }
    @available(*, deprecated, message: "usa compacta(.asturiano)")
    public static var asturianoCompacto: EscrituraDeNotas { .compacta(.asturiano) }
    @available(*, deprecated, message: "usa conPalabras(.aragones)")
    public static var aragonesPalabras: EscrituraDeNotas { .conPalabras(.aragones) }
    @available(*, deprecated, message: "usa compacta(.aragones)")
    public static var aragonesCompacto: EscrituraDeNotas { .compacta(.aragones) }
    @available(*, deprecated, message: "usa conPalabras(.euskera)")
    public static var euskeraPalabras: EscrituraDeNotas { .conPalabras(.euskera) }
    @available(*, deprecated, message: "usa compacta(.euskera)")
    public static var euskeraCompacto: EscrituraDeNotas { .compacta(.euskera) }
    @available(*, deprecated, message: "usa conPalabras(.portugues)")
    public static var portuguesPalabras: EscrituraDeNotas { .conPalabras(.portugues) }
    @available(*, deprecated, message: "usa compacta(.portugues)")
    public static var portuguesCompacto: EscrituraDeNotas { .compacta(.portugues) }
    @available(*, deprecated, message: "usa conPalabras(.frances)")
    public static var francesPalabras: EscrituraDeNotas { .conPalabras(.frances) }
    @available(*, deprecated, message: "usa compacta(.frances)")
    public static var francesCompacto: EscrituraDeNotas { .compacta(.frances) }
    @available(*, deprecated, message: "usa conPalabras(.occitano)")
    public static var occitanoPalabras: EscrituraDeNotas { .conPalabras(.occitano) }
    @available(*, deprecated, message: "usa compacta(.occitano)")
    public static var occitanoCompacto: EscrituraDeNotas { .compacta(.occitano) }
    @available(*, deprecated, message: "usa conPalabras(.italiano)")
    public static var italianoPalabras: EscrituraDeNotas { .conPalabras(.italiano) }
    @available(*, deprecated, message: "usa compacta(.italiano)")
    public static var italianoCompacto: EscrituraDeNotas { .compacta(.italiano) }
    @available(*, deprecated, message: "usa conPalabras(.aleman)")
    public static var alemanPalabras: EscrituraDeNotas { .conPalabras(.aleman) }
    @available(*, deprecated, message: "usa compacta(.aleman)")
    public static var alemanCompacto: EscrituraDeNotas { .compacta(.aleman) }
    @available(*, deprecated, message: "usa conPalabras(.griego)")
    public static var griegoPalabras: EscrituraDeNotas { .conPalabras(.griego) }
    @available(*, deprecated, message: "usa compacta(.griego)")
    public static var griegoCompacto: EscrituraDeNotas { .compacta(.griego) }
    @available(*, deprecated, message: "usa conPalabras(.ruso)")
    public static var rusoPalabras: EscrituraDeNotas { .conPalabras(.ruso) }
    @available(*, deprecated, message: "usa compacta(.ruso)")
    public static var rusoCompacto: EscrituraDeNotas { .compacta(.ruso) }
    @available(*, deprecated, message: "usa conPalabras(.hungaro)")
    public static var hungaroPalabras: EscrituraDeNotas { .conPalabras(.hungaro) }
    @available(*, deprecated, message: "usa compacta(.hungaro)")
    public static var hungaroCompacto: EscrituraDeNotas { .compacta(.hungaro) }
}
