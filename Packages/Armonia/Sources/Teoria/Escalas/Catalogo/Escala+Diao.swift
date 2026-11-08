import Elementos
import Foundation

// MARK: - Los diao: los modos chinos con el lü de su tónica
//
// En la teoría china un modo se nombra con el lü sobre el que está y el nombre del modo: 黄钟宫 (huángzhōng gōng) es
// el modo gōng sobre huángzhōng, y 林钟商, el shāng sobre línzhōng. Con los doce lü y los cinco modos salen los
// sesenta diao (六十调), que el tratado de música del Hou Hanshu (後漢書, «Lüli zhi») atribuye a Jing Fang.
//
// Las fuentes no leen igual un nombre como 林钟商. En la lectura 为调 («X 为 Y»: X hace de Y), el lü es la nota del
// modo: 林钟为商 es el shāng con su tónica en línzhōng, y gōng un tono más abajo. En la 之调 («X 之 Y»: el Y de X), el
// lü es gōng, y la tónica, el grado del modo desde él: 林钟之商 es el shāng del gōng de línzhōng, sobre nánlǚ. Aquí,
// sin partícula, se lee como 为调, que es como se nombran los sesenta diao en los tratados desde el Hou Hanshu y como
// los transcribe Yang Yinliu (Zhongguo gudai yinyue shigao, 1981); con 之 o 为 delante del modo, como dice la
// partícula. En el modo gōng las dos lecturas coinciden.
//
// Los lü se leen como en `SistemaDeNombres.luChinos`: en caracteres simplificados o tradicionales, en pinyin con o
// sin tonos. Huángzhōng es Do, como en el resto del motor.

extension Escala {
    /// Cómo se lee un nombre de diao con partícula: 之 (el lü es gōng) o 为 (el lü es la tónica del modo).
    public enum LecturaDeDiao: String, Hashable, Sendable, CaseIterable, Codable {
        /// 为调: el lü es la tónica del modo. 林钟商 y 林钟为商 son el shāng sobre línzhōng (Sol).
        case wei
        /// 之调: el lü es gōng, y la tónica, el grado del modo desde él. 林钟之商 es el shāng sobre nánlǚ (La).
        case zhi
    }

    /// Los cinco modos de los diao, en el orden de las cinco notas: gōng, shāng, jué, zhǐ y yǔ.
    public static let modosDeLosDiao: [TipoDeEscala] = [.gong, .shang, .jue, .zhi, .yu]

    /// Lee un diao: un lü y un modo chino, en caracteres o en pinyin («黄钟宫», «林钟商», «huángzhōng gōng», «linzhong
    /// shang»), y con partícula, «林钟之商» o «林钟为商». Sin partícula, el lü es la tónica (`.wei`). Los modos son los
    /// cinco de `modosDeLosDiao` y las tres heptatónicas de gōng (qīngyuè, yǎyuè y yànyuè). `nil` si no es un diao.
    ///
    ///     Escala(diao: "黄钟宫")      // Do gōng
    ///     Escala(diao: "林钟商")      // Sol shāng
    ///     Escala(diao: "林钟之商")    // La shāng (el gōng en línzhōng, Sol)
    ///     Escala(diao: "taicu yu")   // Re yǔ
    public init?(diao texto: String) {
        let caracteres = Array(texto.trimmingCharacters(in: .whitespaces))
        // El lü más largo con que empieza el texto: «黄钟», «huangzhong».
        for largo in stride(from: caracteres.count - 1, through: 1, by: -1) {
            let lu = String(caracteres[..<largo]).trimmingCharacters(in: .whitespaces)
            guard !lu.isEmpty, !lu.contains(where: { "#b♯♭x".contains($0) }),
                let nota = try? SistemaDeNombres.luChinos.leer(lu)
            else { continue }
            var resto = String(caracteres[largo...]).trimmingCharacters(in: .whitespaces)
            var lectura = LecturaDeDiao.wei
            // La partícula: 之 o 为 (為), o en pinyin, zhī o wéi, delante del modo.
            for (particulas, cual) in [
                (["之", "zhī ", "zhi "], LecturaDeDiao.zhi), (["为", "為", "wéi ", "wei "], .wei),
            ] {
                if let particula = particulas.first(where: { resto.lowercased().hasPrefix($0) }),
                    Escala.modoDeDiao(String(resto.dropFirst(particula.count))) != nil
                {
                    resto = String(resto.dropFirst(particula.count)).trimmingCharacters(in: .whitespaces)
                    lectura = cual
                    break
                }
            }
            guard let modo = Escala.modoDeDiao(resto) else { continue }
            self = Escala(lu: nota, modo: modo, lectura: lectura)
            return
        }
        return nil
    }

    /// El diao de un modo sobre un lü, leído como `lectura`: con `.wei`, el lü es la tónica; con `.zhi`, el lü es
    /// gōng, y la tónica, el grado del modo desde él.
    ///
    ///     Escala(lu: Nota("Sol"), modo: .shang, lectura: .zhi)   // La shāng
    public init(lu: Nota, modo: TipoDeEscala, lectura: LecturaDeDiao = .wei) {
        switch lectura {
        case .wei: self.init(lu, modo)
        case .zhi: self.init(lu + Escala.gradoDesdeGong(modo), modo)
        }
    }

    /// Los sesenta diao (六十调): los cinco modos sobre cada uno de los doce lü, desde huángzhōng gōng, con el lü en la
    /// tónica (la lectura 为调). Cada uno, con su nombre en la grafía elegida: «黄钟宫», «huángzhōng gōng».
    public static func sesentaDiao(grafia: Grafia = .transliterada) -> [(nombre: String, escala: Escala)] {
        // Los lü, en su cadena de quintas desde huángzhōng (Do, Do♯… Mi♯…), ordenados de grave a agudo.
        let lus = (0...11).map { Nota(pasosDeQuinta: $0) }.sorted { $0.claseDeAltura < $1.claseDeAltura }
        return lus.flatMap { lu in
            modosDeLosDiao.map { modo in
                let escala = Escala(lu, modo)
                return (escala.nombreDeDiao(grafia: grafia) ?? "", escala)
            }
        }
    }

    /// El nombre de la escala como diao, con el lü de su tónica (la lectura 为调): Sol shāng es «林钟商» (original),
    /// «línzhōng shāng» (transliterada) o «linzhong shang» (ASCII). `nil` si el tipo no es uno de los modos de los
    /// diao.
    public func nombreDeDiao(grafia: Grafia = .transliterada) -> String? {
        guard let indice = Escala.modosDeLosDiao.firstIndex(of: tipo) else { return nil }
        let lu = SistemaDeNombres.luChinos.nombre(de: tonica, grafia: grafia)
        let modo: String
        switch grafia {
        case .original: modo = ["宫", "商", "角", "徵", "羽"][indice]
        case .transliterada: modo = " " + ["gōng", "shāng", "jué", "zhǐ", "yǔ"][indice]
        case .ascii: modo = " " + ["gong", "shang", "jue", "zhi", "yu"][indice]
        }
        return lu + modo
    }

    /// El modo chino de un nombre, si es uno de los de los diao o de las heptatónicas de gōng.
    private static func modoDeDiao(_ texto: String) -> TipoDeEscala? {
        let limpio = texto.trimmingCharacters(in: .whitespaces)
        guard !limpio.isEmpty, let tipo = TipoDeEscala.buscar(nombre: limpio, aceptarIngles: true) else { return nil }
        return (modosDeLosDiao + [.qingyue, .yayue, .yanyue]).contains(tipo) ? tipo : nil
    }

    /// El grado de la tónica del modo desde gōng: shāng, una segunda mayor; jué, una tercera mayor; zhǐ, una quinta;
    /// yǔ, una sexta mayor. Las heptatónicas empiezan en gōng.
    private static func gradoDesdeGong(_ modo: TipoDeEscala) -> Intervalo {
        switch modo {
        case .shang: return .segundaMayor
        case .jue: return .terceraMayor
        case .zhi: return .quintaJusta
        case .yu: return .sextaMayor
        default: return .unisono
        }
    }
}
