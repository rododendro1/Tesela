import Elementos

// MARK: - SudesteAsiatico
//
// Las versiones microtonales (`afinaciones:` en cada escala). En cents: siete partes de 171,4 (redondeados).

extension TipoDeEscala {
    // MARK: Afinaciones equidistantes del sudeste asiático
    //
    // La música clásica de Tailandia y la de Camboya reparten la octava en siete partes casi iguales, de unos 171
    // cents: la afinación de los conjuntos piphat tailandeses y pinpeat jemeres. Como la equiheptatónica africana,
    // va en doce notas con cada grado redondeado al semitono más cercano (el dórico) y en cents en su versión
    // microtonal. Las melodías usan sobre todo cinco de las siete notas, en una de varias alturas (thang), que una
    // escala no recoge. Fuente: Wikipedia («Music of Thailand», «Music of Cambodia»).

    /// Piphat (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas.
    public static let piphat = TipoDeEscala(
        nombre: "Piphat",
        intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["tailandesa"], nombresOriginales: [.init("ปี่พาทย์", .tailandes)],
        categoria: .afinacion, regiones: [.tailandia],
        afinaciones: [.equiheptatonica], referencias: [.morton1976])
    /// Pinpeat (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas.
    public static let pinpeat = TipoDeEscala(
        nombre: "Pinpeat",
        intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["camboyana", "jemer"], nombresOriginales: [.init("ពិណពាទ្យ", .jemer)],
        categoria: .afinacion, regiones: [.camboya],
        afinaciones: [.equiheptatonica], referencias: [.sam1988])

    // MARK: El arpa birmana
    //
    // Las afinaciones del saung gauk de Myanmar (hnyìn, myin, palè y auk) son pentatónicas con dos pasos: uno
    // pequeño, de unos 182 cents, y uno grande, de unos 327, en el orden pequeño, pequeño, grande, pequeño, grande
    // o en una de sus rotaciones. Aquí va ese orden, con los pasos medios que da Jay Rahn («Reformulating Burmese
    // Harp Tunings», York University, 2019): Do Re Mi Sol La en doce notas, con un Mi entre Mi♭ y Mi.

    /// Saung (arpa birmana): Do Re Mi Sol La en doce notas.
    public static let saung = TipoDeEscala(
        nombre: "Saung", intervalos: TipoDeEscala.pentatonicaMayor.intervalos,
        alias: ["saung gauk", "arpa birmana", "birmana"],
        nombresOriginales: [.init("စောင်း", .birmano)],
        categoria: .afinacion, regiones: [.birmania],
        // En cents: 182, 182, 327, 182 y 327.
        afinaciones: [.init(.razones, pasos: [0, 182, 364, 691, 873])], referencias: [.williamson2000])

    // MARK: Los lai del khaen
    //
    // El khaen, el órgano de boca de los lao de Laos y del Isán (el nordeste de Tailandia), se toca en cinco modos
    // (lai), cada uno sobre una nota fija y con sus bordones. Se agrupan en dos familias pentatónicas: los de thang
    // san (ทางสั้น), Re Mi Sol La Si y sus transposiciones, y los de thang yao (ทางยาว), la pentatónica menor. Las
    // notas son las de Miller (1985), en la afinación occidental con que se suele transcribir el khaen. El nombre
    // original va en tailandés, como se escribe en el Isán.

    /// ลายสุดสะแนน: el «padre de los lai», de thang san, sobre Sol (Sol La Do Re Mi).
    public static let laiSutsanaen = TipoDeEscala(
        nombre: "Lai sutsanaen", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Sutsanaen", "Lai sootsanaen"],
        nombresOriginales: [.init("ลายสุดสะแนน", .tailandes)],
        categoria: .escala, regiones: [.laos], referencias: [.miller1985])
    /// ลายโป้ซ้าย: el más antiguo, de thang san, sobre Do (Do Re Fa Sol La).
    public static let laiPoSai = TipoDeEscala(
        nombre: "Lai po sai", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Po sai"],
        nombresOriginales: [.init("ลายโป้ซ้าย", .tailandes)],
        categoria: .escala, regiones: [.laos], referencias: [.miller1985])
    /// ลายสร้อย: de thang san, sobre Re (Re Mi Sol La Si).
    public static let laiSoi = TipoDeEscala(
        nombre: "Lai soi", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        nombresOriginales: [.init("ลายสร้อย", .tailandes)],
        categoria: .escala, regiones: [.laos], referencias: [.miller1985])
    /// ลายใหญ่: de thang yao, sobre La (La Do Re Mi Sol).
    public static let laiYai = TipoDeEscala(
        nombre: "Lai yai", intervalos: TipoDeEscala.pentatonicaMenor.intervalos,
        nombresOriginales: [.init("ลายใหญ่", .tailandes)],
        categoria: .escala, regiones: [.laos], referencias: [.miller1985])
    /// ลายน้อย: de thang yao, sobre Re (Re Fa Sol La Do).
    public static let laiNoi = TipoDeEscala(
        nombre: "Lai noi", intervalos: TipoDeEscala.pentatonicaMenor.intervalos,
        nombresOriginales: [.init("ลายน้อย", .tailandes)],
        categoria: .escala, regiones: [.laos], referencias: [.miller1985])

    package static let sudesteAsiaticas: [TipoDeEscala] = [
        .piphat, .pinpeat, .saung, .laiSutsanaen, .laiPoSai, .laiSoi, .laiYai, .laiNoi,
    ]
}
