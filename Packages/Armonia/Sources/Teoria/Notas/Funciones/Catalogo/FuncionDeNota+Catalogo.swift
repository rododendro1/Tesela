import Elementos
import Foundation

// MARK: - El catálogo de funciones de nota
//
// Los papeles que hace una nota, con nombre: los grados de la escala, las notas del modo gregoriano, del rāga y del
// maqam, las blue notes, los adornos y las notas extrañas al acorde. Los nombres en los otros idiomas están en
// `Notas/Funciones/Nombres/`.

extension FuncionDeNota {
    // MARK: Grados de la escala

    /// El primer grado, el que da nombre a la escala.
    public static let tonica = grado(.tonica, .unisono)
    /// El segundo grado.
    public static let supertonica = grado(.supertonica, .segundaMayor)
    /// El tercer grado, a medio camino entre la tónica y la dominante (en la escala mayor, a una tercera mayor).
    public static let mediante = grado(.mediante, .terceraMayor)
    /// El cuarto grado, una quinta bajo la tónica.
    public static let subdominante = grado(.subdominante, .cuartaJusta)
    /// El quinto grado, el que más tira hacia la tónica después de la sensible.
    public static let dominante = grado(.dominante, .quintaJusta)
    /// El sexto grado (en la escala mayor, a una sexta mayor).
    public static let superdominante = grado(.superdominante, .sextaMayor, alias: ["submediante"])
    /// El séptimo grado a un semitono de la tónica, que sube a ella.
    public static let sensible = grado(.sensible, .septimaMayor, alias: ["nota sensible"])
    /// El séptimo grado a un tono de la tónica, en la escala menor natural y en los modos.
    public static let subtonica = grado(.subtonica, .septimaMenor)

    /// Un grado de la escala, con su nombre en español.
    static func grado(_ grado: NombreDeGrado, _ intervalo: Intervalo, alias: [String] = []) -> FuncionDeNota {
        FuncionDeNota(
            nombre: grado.nombre(en: .conPalabras(.espanol)), familia: .grado, intervalo: intervalo,
            nombreDeGrado: grado, alias: alias, referencias: [.aldwell2011])
    }

    // MARK: Modo gregoriano

    /// La nota en que acaba el canto, la que da nombre a la maneria: Re, Mi, Fa o Sol.
    public static let finalis = FuncionDeNota(
        nombre: "finalis", familia: .gregoriana, intervalo: .unisono, alias: ["nota final"], referencias: [.apel1958])
    /// La nota sobre la que se recita, que cambia de un modo a otro (`ModoGregoriano.tenor`): La en el primero, Do en
    /// el tercero.
    public static let tenor = FuncionDeNota(
        nombre: "tenor", familia: .gregoriana, alias: ["nota de recitación", "repercussio"], referencias: [.apel1958])
    /// La quinta sobre la finalis, donde acaban los cantos transportados.
    public static let confinalis = FuncionDeNota(
        nombre: "confinalis", familia: .gregoriana, intervalo: .quintaJusta, alias: ["cofinal"],
        referencias: [.apel1958])

    // MARK: Rāga

    /// La tónica fija del rāga, Ṣaḍja, que suena siempre en el bordón.
    public static let sa = FuncionDeNota(
        nombre: "sa", familia: .india, intervalo: .unisono, alias: ["ṣaḍja"], variantes: ["shadja"],
        referencias: [.jairazbhoy1971, .powers2001])
    /// La quinta fija, Pañcama, la otra nota del bordón.
    public static let pa = FuncionDeNota(
        nombre: "pa", familia: .india, intervalo: .quintaJusta, alias: ["pañcama"], variantes: ["panchama"],
        referencias: [.jairazbhoy1971, .powers2001])
    /// La nota más importante del rāga después del sa, la que más se oye.
    public static let vadi = FuncionDeNota(
        nombre: "vādī", familia: .india, referencias: [.jairazbhoy1971, .powers2001])
    /// La segunda en importancia, casi siempre a una cuarta o una quinta del vādī.
    public static let samvadi = FuncionDeNota(
        nombre: "saṃvādī", familia: .india, variantes: ["samvadi"], referencias: [.jairazbhoy1971, .powers2001])
    /// La nota en que se descansa al acabar una frase.
    public static let nyasa = FuncionDeNota(
        nombre: "nyāsa", familia: .india, referencias: [.jairazbhoy1971, .powers2001])

    // MARK: Maqam y makam

    /// La tónica del maqam, en la que acaba (en turco, durak).
    public static let qarar = FuncionDeNota(
        nombre: "qarār", familia: .maqam, intervalo: .unisono, alias: ["durak"],
        referencias: [.touma1996, .signell1977])
    /// La nota donde se une el segundo jins al primero, que cambia de un maqam a otro (en turco, güçlü).
    public static let ghammaz = FuncionDeNota(
        nombre: "ghammāz", familia: .maqam, alias: ["güçlü"], referencias: [.touma1996, .signell1977])
    /// En el makam turco, la nota bajo la tónica que sube a ella.
    public static let yeden = FuncionDeNota(nombre: "yeden", familia: .maqam, referencias: [.signell1977])

    // MARK: Blue notes

    /// La tercera neutra, entre la menor y la mayor: 350 cents.
    public static let terceraBlue = FuncionDeNota(
        nombre: "tercera blue", familia: .blues, intervalo: .terceraMenor, desvio: 50,
        referencias: [.vanDerMerwe1989])
    /// La quinta disminuida, temperada.
    public static let quintaBlue = FuncionDeNota(
        nombre: "quinta blue", familia: .blues, intervalo: .quintaDisminuida, referencias: [.vanDerMerwe1989])
    /// La séptima armónica, 7/4: 969 cents, 31 bajo la séptima menor.
    public static let septimaBlue = FuncionDeNota(
        nombre: "séptima blue", familia: .blues, intervalo: .septimaMenor, desvio: 1200 * log2(7 / 4) - 1000,
        referencias: [.vanDerMerwe1989])

    // MARK: Adornos

    /// Una nota breve, tachada, que se toca casi a la vez que la principal.
    public static let acciaccatura = FuncionDeNota(
        nombre: "acciaccatura", familia: .adorno, alias: ["apoyatura breve"], referencias: [.neumann1978])
    /// La nota principal, la de al lado y otra vez la principal, deprisa.
    public static let mordente = FuncionDeNota(nombre: "mordente", familia: .adorno, referencias: [.neumann1978])
    /// Las notas de arriba y de abajo alrededor de la principal.
    public static let grupeto = FuncionDeNota(
        nombre: "grupeto", familia: .adorno, variantes: ["gruppetto"], referencias: [.neumann1978])
    /// La nota principal y la de arriba, alternando deprisa.
    public static let trino = FuncionDeNota(nombre: "trino", familia: .adorno, referencias: [.neumann1978])

    // MARK: Notas extrañas

    /// Une por grados dos notas del acorde.
    public static let notaDePaso = extrana("nota de paso")
    /// Sale de una nota del acorde por grado y vuelve a ella.
    public static let bordadura = extrana("bordadura")
    /// Llega por salto a la parte fuerte y resuelve por grado.
    public static let apoyatura = extrana("apoyatura")
    /// Se queda del acorde anterior y resuelve bajando.
    public static let retardo = extrana("retardo")
    /// Una nota del acorde siguiente que llega antes que él.
    public static let anticipacion = extrana("anticipación")
    /// Sale por grado y resuelve por salto.
    public static let escapada = extrana("escapada")
    /// Se mantiene mientras los acordes cambian por encima o por debajo.
    public static let notaPedal = extrana("nota pedal")
    /// Una disonancia que no es de ninguna de las otras.
    public static let notaLibre = extrana("nota libre")

    /// Una nota extraña al acorde, con su nombre en español.
    static func extrana(_ nombre: String) -> FuncionDeNota {
        FuncionDeNota(nombre: nombre, familia: .notaExtrana, referencias: [.aldwell2011])
    }

    /// Todo el catálogo, en el orden de este fichero.
    public static let catalogo: [FuncionDeNota] = [
        .tonica, .supertonica, .mediante, .subdominante, .dominante, .superdominante, .sensible, .subtonica,
        .finalis, .tenor, .confinalis, .sa, .pa, .vadi, .samvadi, .nyasa, .qarar, .ghammaz, .yeden, .terceraBlue,
        .quintaBlue, .septimaBlue, .acciaccatura, .mordente, .grupeto, .trino, .notaDePaso, .bordadura, .apoyatura,
        .retardo, .anticipacion, .escapada, .notaPedal, .notaLibre,
    ]
}
