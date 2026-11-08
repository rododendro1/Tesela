// MARK: - Sistemas de nombres
//
// Los nombres de nota de otras tradiciones, que no son un idioma: el bizantino (Ni Pa Vou Ga Di Ke Zo), el sargam
// indio (Sā Re Ga ma Pa Dha Ni), el japonés (ハニホヘトイロ), el coreano (다라마바사가나), el ut de Guido y los doce lü
// de China, Japón y Corea. Un `Idioma` decide a la vez los nombres de nota y la lengua de los textos; un sistema de
// nombres solo decide los nombres, y los textos siguen en el idioma que se elija.
//
// Hay dos familias. En los sistemas fijos cada nota tiene su nombre, como en un idioma: en el bizantino, Ni es Do,
// como en los echoi de `TipoDeEscala+Bizancio`. En los móviles el nombre es el de un grado respecto a una tónica: en
// el sargam, Sā es la tónica, y «Pa» es Sol solo si Sā es Do. Por eso los nombres se piden con la tónica
// (`nombre(de:tonica:grafia:)`), que los fijos no usan.
//
// Los sistemas de siete nombres escriben las alteraciones con signos detrás (Ga♯), con un prefijo (嬰ヘ, 올림바) o,
// en el sargam, con el nombre del komal o del tivra (ga, Ma). Los de doce, los lü, tienen un nombre por cada clase de
// altura y no escriben alteraciones: 大吕 es Do♯ y Re♭ a la vez, y al leerlo sale la grafía de su cadena de quintas
// (Do♯).
//
// Cada sistema se escribe de tres formas (`Grafia`): con su escritura original (griego, devanagari, kana, hangul,
// hanzi), transliterado (con IAST en el sargam: Sā; con pinyin en los lü chinos: huángzhōng) y en ASCII (Sa,
// huangzhong). Las tablas están en `SistemaDeNombres+Tablas.swift`.

/// Un sistema de nombres de nota de otra tradición: `SistemaDeNombres.sargam.nombre(de: Nota("Mib"))` es «ga».
public enum SistemaDeNombres: String, Hashable, Sendable, CaseIterable, Codable {
    /// Los nombres de la salmodia bizantina, de Do a Si: Ni Pa Vou Ga Di Ke Zo (Νη Πα Βου Γα Δι Κε Ζω). Es fijo: Ni
    /// es siempre Do, como en la teoría de la Comisión Patriarcal (1881) y en los echoi del catálogo. Las alteraciones
    /// se escriben con los signos de siempre: Fa♯ es Ga♯.
    case bizantino
    /// El sargam de la música indostaní, del primer grado al séptimo: Sā Re Ga ma Pa Dha Ni (सा रे ग म प ध नि). Es
    /// móvil: Sā es la tónica. Re, Ga, Dha y Ni komal (un semitono más bajos) van en minúscula (re, ga, dha, ni), y
    /// el Ma tivra (un semitono más alto) en mayúscula; el ma natural (shuddha), en minúscula. Es la convención de las
    /// escalas indias del catálogo (Kāfī: Sā Re ga ma Pa Dha ni). En devanagari, el komal lleva una raya debajo (रे॒)
    /// y el tivra un trazo encima (म॑).
    case sargam
    /// Los nombres japoneses, de Do a Si: ハ ニ ホ ヘ ト イ ロ (Ha Ni Ho He To I Ro), los del orden iroha. Es fijo.
    /// La alteración va delante: 嬰 (ei) sube y 変 (hen) baja, y 重 (jū) la dobla: 嬰ヘ es Fa♯ y 重変ロ, Si𝄫.
    case japones
    /// Los nombres coreanos, de Do a Si: 다 라 마 바 사 가 나 (Da Ra Ma Ba Sa Ga Na). Es fijo. La alteración va
    /// delante: 올림 (ollim) sube y 내림 (naerim) baja, y 겹 (gyeop) la dobla: 올림바 es Fa♯ y 내림나, Si♭.
    case coreano
    /// Los nombres de Guido d'Arezzo, de Do a Si: Ut Re Mi Fa Sol La, y Si para el séptimo, que Guido no nombraba.
    /// Es fijo y escribe las alteraciones con signos: Ut♯, Si♭. Las sílabas de los hexacordos, con sus mutaciones,
    /// están en `ManoGuidoniana`.
    case guidoniano
    /// Los doce lü chinos (十二律), desde 黄钟 (huángzhōng) en Do: 大吕 dàlǚ, 太簇 tàicù… 应钟 yìngzhōng. Es fijo, con un
    /// nombre por cada clase de altura, como en `TipoDeEscala.shierLu`; al leerlos, las notas salen con la grafía de su
    /// cadena de quintas desde Do: Do♯, Re♯, Mi♯ (zhònglǚ), Sol♯, La♯.
    case luChinos
    /// Los doce lü japoneses (十二律, jūni-ritsu) del gagaku, desde 壱越 (ichikotsu) en Re: 断金 tangin, 平調 hyōjō…
    /// 上無 kamimu. Es fijo; al leerlos, las notas salen de Fa a La♯ en la cadena de quintas (黄鐘 ōshiki es La).
    case luJaponeses
    /// Los doce lü coreanos (율명, yulmyeong) de la música de corte, desde 황종 (hwangjong) en Mi♭, como se suele
    /// transcribir: 대려 daeryeo, 태주 taeju… 응종 eungjong. Es fijo; al leerlos, las notas salen de Mi♭ a Sol♯ en la
    /// cadena de quintas. Se leen también en hanja, con el nombre entero (黃鍾) o con su sílaba (黃), como en el
    /// jeongganbo.
    case luCoreanos
    /// El jianpu, la notación por números de China: 1 2 3 4 5 6 7 desde la tónica, con la alteración delante (♯4, ♭7).
    /// Es móvil.
    case jianpu
    /// El gongche (工尺谱), la notación china con caracteres: 上 尺 工 凡 六 五 乙 (shàng chě gōng fán liù wǔ yǐ) desde
    /// la tónica, con 上 como do, como se usa hoy. Es móvil; las alteraciones van con signos detrás.
    case gongche
    /// Las cinco notas chinas (五声, wǔshēng) y las dos que se les añaden: 宫 商 角 徵 羽 (gōng shāng jué zhǐ yǔ) desde
    /// gōng, con 清角 (qīngjué) en el cuarto, 变徵 (biànzhǐ) en el cuarto aumentado, 闰 (rùn) en la séptima menor y
    /// 变宫 (biàngōng) en la mayor. Es móvil: la tónica que se da es gōng, también en los modos que no empiezan en él.
    case wusheng
    /// Los swaras carnáticos, los dieciséis nombres de doce alturas: Sa, Ri₁ Ri₂ Ri₃, Ga₁ Ga₂ Ga₃, Ma₁ Ma₂, Pa, Da₁
    /// Da₂ Da₃, Ni₁ Ni₂ Ni₃. Es móvil. Dos nombres pueden sonar igual y escribirse distinto, como Re♯ y Mi♭: Ri₂ es la
    /// 2.ª mayor y Ga₁, la 3.ª disminuida.
    case carnatico
    /// El tonic sol-fa de Curwen: d r m f s l t desde la tónica, con las alteraciones con signos detrás. Es móvil. El
    /// do móvil cromático, con sus sílabas (di, ri, me…), está en `SolfeoRelativo`.
    case tonicSolFa
    /// Las notas de forma (shape notes) de cuatro sílabas, las del Sacred Harp: fa sol la fa sol la mi desde la tónica.
    /// Es móvil. Como fa, sol y la nombran dos grados, al leerlos se toma el más bajo (fa es el primero, no el cuarto).
    case notasDeForma
    /// El solfeo en escritura árabe, de Do a Si: دو ري مي فا صول لا سي, como se escribe en el Magreb, Egipto y el
    /// Levante. Es fijo, se escribe de derecha a izquierda y las alteraciones van con signos detrás (فا♯).
    /// Transliterado y en ASCII, Do Re Mi.
    case solfeoArabe
    /// El solfeo en escritura hebrea, de Do a Si: דו רה מי פה סול לה סי. Es fijo, se escribe de derecha a izquierda y
    /// las alteraciones van con signos detrás (פה♯). Transliterado y en ASCII, Do Re Mi.
    case solfeoHebreo

    /// Si cada nota tiene su nombre (`.fija`) o el nombre depende de la tónica (`.movil`).
    public var familia: FamiliaDeNombres {
        switch self {
        case .sargam, .jianpu, .gongche, .wusheng, .carnatico, .tonicSolFa, .notasDeForma: return .movil
        case .bizantino, .japones, .coreano, .guidoniano, .luChinos, .luJaponeses, .luCoreanos, .solfeoArabe,
            .solfeoHebreo:
            return .fija
        }
    }

    /// Cómo se llama el sistema, en minúsculas y sin tildes, para leerlo en la línea de comandos o en los ajustes:
    /// «bizantino», «byzantine»; «sargam»; «japones», «iroha»; «lu chinos», «shier lu»…
    public var nombres: [String] {
        switch self {
        case .bizantino: return ["bizantino", "byzantine", "bizantziarra"]
        case .sargam: return ["sargam", "sargama", "swara", "svara"]
        case .japones: return ["japones", "japanese", "iroha"]
        case .coreano: return ["coreano", "korean"]
        case .guidoniano: return ["guidoniano", "guidonian", "ut"]
        case .luChinos: return ["lu chinos", "lu", "shier lu", "doce lu", "chinese lu"]
        case .luJaponeses: return ["lu japoneses", "juni ritsu", "japanese lu"]
        case .luCoreanos: return ["lu coreanos", "yulmyeong", "korean lu"]
        case .jianpu: return ["jianpu", "numerada", "numbered"]
        case .gongche: return ["gongche", "gongchepu"]
        case .wusheng: return ["wusheng", "cinco notas", "pentatonica china", "gong shang jue zhi yu"]
        case .carnatico: return ["carnatico", "carnatic", "swaras carnaticos"]
        case .tonicSolFa: return ["tonic sol fa", "sol fa", "curwen"]
        case .notasDeForma: return ["notas de forma", "shape notes", "fasola", "sacred harp"]
        case .solfeoArabe: return ["solfeo arabe", "arabic solfege", "arabe"]
        case .solfeoHebreo: return ["solfeo hebreo", "hebrew solfege", "hebreo"]
        }
    }

    /// El sistema de uno de sus `nombres` o de su `rawValue`, sin importar las mayúsculas, las tildes, los espacios
    /// ni los guiones («Jūni-ritsu», «luChinos»); `nil` si no es ninguno.
    public init?(nombre: String) {
        let clave = SistemaDeNombres.plegar(nombre)
        let sistema = SistemaDeNombres.allCases.first { sistema in
            ([sistema.rawValue] + sistema.nombres).contains { SistemaDeNombres.plegar($0) == clave }
        }
        guard let encontrado = sistema else { return nil }
        self = encontrado
    }

    /// Los nombres de las siete notas naturales, de Do a Si (en los móviles, de los siete grados naturales desde la
    /// tónica), en una grafía: en el sargam, los de los grados shuddha (con el ma en minúscula); en los lü, los de las
    /// clases de altura de Do, Re, Mi, Fa, Sol, La y Si.
    public func naturales(en grafia: Grafia) -> [String] {
        switch disposicion {
        case .siete(let naturales, _): return naturales(grafia)
        case .doce: return NotaNatural.allCases.map { nombre(de: Nota($0), grafia: grafia) }
        }
    }
}

/// Las dos familias de ``SistemaDeNombres``.
public enum FamiliaDeNombres: String, Hashable, Sendable, CaseIterable, Codable {
    /// Cada nota tiene su nombre, como en un idioma: en el bizantino, Ni es Do.
    case fija
    /// El nombre es el de un grado respecto a una tónica: en el sargam, Sā es la tónica.
    case movil
}

/// En qué alfabeto se escriben los nombres de un ``SistemaDeNombres`` y, en ruso y en griego, los nombres de nota y
/// los textos de una ``Notacion``: el de la tradición o del idioma, o el latino, con o sin diacríticos. Los demás
/// idiomas ya se escriben con letras latinas, y en ellos no cambia nada.
public enum Grafia: String, Hashable, Sendable, CaseIterable, Codable {
    /// Con la escritura de la tradición o del idioma: Νη Πα Βου; सा रे ग; 嬰ヘ; 올림바; 黄钟; соль, φα δίεση. Las
    /// alteraciones que el sistema no nombra, con ♯ y ♭.
    case original
    /// Transliterado al alfabeto latino, con diacríticos: Ni Pa Vou; Sā Re Ga (IAST); ei He; ollim Ba; huángzhōng
    /// (pinyin); el ruso con la ISO 9 (solʹ, bolʹšaâ terciâ) y el griego con la ELOT 743 (fa díesi). Con ♯ y ♭.
    case transliterada
    /// Transliterado sin diacríticos: Ni Pa Vou; Sa Re Ga; huangzhong; sol', bol'shaya tertsiya; fa diesi. En los
    /// sistemas, también con # y b.
    case ascii
}

// MARK: - Disposición

extension SistemaDeNombres {
    /// Cómo nombra un sistema las notas.
    enum Disposicion {
        /// Siete nombres, uno por nota natural (o por grado), y las alteraciones como diga `Alteraciones`.
        case siete(naturales: (Grafia) -> [String], alteraciones: Alteraciones)
        /// Doce nombres, uno por clase de altura, desde `primera` (la clase de altura del primero: 0 en Do, 2 en Re,
        /// 3 en Mi♭). Al leerlos, cada uno se escribe con la nota de la cadena de quintas que empieza en `desdeQuinta`
        /// (`Nota.pasosDeQuinta`: 0 es Do, −1 Fa, −3 Mi♭) y sigue once quintas.
        case doce(nombres: (Grafia) -> [String], primera: Int, desdeQuinta: Int)
    }

    /// Cómo escribe un sistema de siete nombres las alteraciones.
    enum Alteraciones {
        /// Con signos detrás: Ga♯, Ut♭.
        case signos
        /// Con un prefijo para la simple y otro para la doble (en ese orden: sostenido, bemol, doble sostenido, doble
        /// bemol), que llevan detrás lo que las separa del nombre (nada en kana y en hangul, un espacio en latino). Lo
        /// que pasa de la doble, con signos detrás.
        case prefijos((Grafia) -> [String])
        /// Algunas con nombre propio (en el sargam, el komal y el tivra: ga, Ma; en el carnático, Ri₁ y Ri₃), y lo
        /// demás con signos detrás.
        case propias((Grafia) -> [NombrePropio])
    }

    /// El nombre propio de un grado alterado: el grado (de 0 a 6), su alteración y cómo se escribe.
    struct NombrePropio {
        let indice: Int
        let alteracion: Int
        let nombre: String
    }
}

// MARK: - Escritura

extension SistemaDeNombres {
    /// El nombre de una nota en el sistema. En los fijos no se usa la tónica: Fa♯ es siempre Ga♯ en bizantino. En
    /// los móviles, el nombre es el del grado desde `tonica` (Do si no se da): con la tónica en Re, Fa es «ga» (el
    /// Ga komal) y Fa♯, «Ga».
    ///
    ///     SistemaDeNombres.bizantino.nombre(de: Nota("Fa#"))                       // "Ga♯"
    ///     SistemaDeNombres.bizantino.nombre(de: Nota("Re"), grafia: .original)     // "Πα"
    ///     SistemaDeNombres.sargam.nombre(de: Nota("Fa"), tonica: Nota("Re"))       // "ga"
    ///     SistemaDeNombres.sargam.nombre(de: Nota("Fa#"), grafia: .original)       // "म॑"
    ///     SistemaDeNombres.japones.nombre(de: Nota("Fa#"), grafia: .original)      // "嬰ヘ"
    ///     SistemaDeNombres.coreano.nombre(de: Nota("Sib"))                         // "naerim Na"
    ///     SistemaDeNombres.luChinos.nombre(de: Nota("Reb"), grafia: .original)     // "大吕"
    ///
    /// Una alteración que el sistema no nombra se escribe con signos tras el nombre: en sargam, el Sā sostenido es
    /// «Sā♯» y el Re doble bemol, «re♭» (el komal, un semitono más bajo). Los lü no escriben alteraciones: nombran la
    /// clase de altura, así que Do♯ y Re♭ son los dos 大吕.
    public func nombre(de nota: Nota, tonica: Nota = Nota(.do), grafia: Grafia = .transliterada) -> String {
        let grado = familia == .fija ? nota : Nota(pasosDeQuinta: nota.pasosDeQuinta - tonica.pasosDeQuinta)
        switch disposicion {
        case .doce(let nombres, let primera, _):
            return nombres(grafia)[modulo(grado.claseDeAltura - primera, 12)]
        case .siete(let naturales, let alteraciones):
            let indice = grado.natural.rawValue
            var alteracion = grado.alteracion.semitonos
            var base = naturales(grafia)[indice]
            switch alteraciones {
            case .signos:
                break
            case .propias(let propias):
                // La alteración con nombre propio del mismo sentido que más se acerque sin pasarse: en el carnático,
                // Ga₁ (−2) para el Mi𝄫 y Ga₂ (−1) para el Mi♭; en el sargam, ga (−1) y un bemol más para el Mi𝄫.
                let candidatas = propias(grafia).filter { propia in
                    propia.indice == indice && propia.alteracion.signum() == alteracion.signum()
                        && abs(propia.alteracion) <= abs(alteracion)
                }
                if let propia = candidatas.max(by: { abs($0.alteracion) < abs($1.alteracion) }) {
                    base = propia.nombre
                    alteracion -= propia.alteracion
                }
            case .prefijos(let prefijos):
                let conPrefijo = max(-2, min(2, alteracion))
                if conPrefijo != 0 {
                    base = prefijos(grafia)[SistemaDeNombres.indiceDelPrefijo(conPrefijo)] + base
                    alteracion -= conPrefijo
                }
            }
            return base + Alteracion(alteracion).simbolo(en: grafia == .ascii ? .ascii : .unicode)
        }
    }

    /// Los nombres de varias notas, como ``nombre(de:tonica:grafia:)``.
    public func nombres(de notas: [Nota], tonica: Nota = Nota(.do), grafia: Grafia = .transliterada) -> [String] {
        notas.map { nombre(de: $0, tonica: tonica, grafia: grafia) }
    }

    /// Dónde está el prefijo de una alteración de −2 a 2 (sin el 0) en la lista de prefijos: sostenido, bemol, doble
    /// sostenido y doble bemol.
    private static func indiceDelPrefijo(_ alteracion: Int) -> Int {
        switch alteracion {
        case 1: return 0
        case -1: return 1
        case 2: return 2
        default: return 3
        }
    }
}

// MARK: - Lectura

extension SistemaDeNombres {
    /// Lee un nombre escrito en el sistema, en cualquiera de sus grafías, con las alteraciones que no tienen nombre
    /// propio en signos (#, b, ♯, ♭, x, 𝄪, 𝄫). En los móviles, el grado se cuenta desde `tonica` (Do si no se da).
    ///
    ///     try SistemaDeNombres.bizantino.leer("Γα♯")                       // Fa♯
    ///     try SistemaDeNombres.bizantino.leer("vou b")                     // Mi♭
    ///     try SistemaDeNombres.sargam.leer("ga", tonica: Nota("Re"))       // Fa
    ///     try SistemaDeNombres.sargam.leer("Ma")                           // Fa♯
    ///     try SistemaDeNombres.sargam.leer("रे॒")                            // Re♭
    ///     try SistemaDeNombres.japones.leer("嬰ヘ")                        // Fa♯
    ///     try SistemaDeNombres.luChinos.leer("dalü")                       // Do♯
    ///
    /// En el sargam cuentan las mayúsculas, porque separan el grado natural del komal (Re, re) y el ma del Ma tivra; no
    /// cuentan las tildes («Sa» y «Sā»). En los demás no cuentan las mayúsculas, las tildes, los espacios ni los
    /// guiones («νή», «NI», «Ei-he», «huangzhong»). Si no se puede leer, lanza `ErrorDeLectura` (`.notaNoReconocida`).
    public func leer(_ texto: String, tonica: Nota = Nota(.do)) throws -> Nota {
        let escalares = Array(normalizar(texto).unicodeScalars)
        // Un prefijo (o ninguno) y, tras él, el nombre más largo que empiece el texto: «Dha» antes que «D…», «नि» antes
        // que «न». Si con un prefijo no hay nombre detrás, se prueba sin él: «naerim» en coreano, «Na» y «ei» en
        // japonés, «I».
        for prefijo in prefijosDeLectura where escalares.starts(with: prefijo.escalares) {
            let tras = Array(escalares.dropFirst(prefijo.escalares.count))
            let candidatos = formasDeLectura.filter { tras.starts(with: $0.escalares) }
            // El más largo y, entre los igual de largos, el primero: en las notas de forma, fa es el primer grado.
            var elegida: FormaDeLectura?
            for candidato in candidatos where candidato.escalares.count > (elegida?.escalares.count ?? -1) {
                elegida = candidato
            }
            guard let forma = elegida else { continue }
            var resto = String(String.UnicodeScalarView(tras.dropFirst(forma.escalares.count)))
            var alteracion = prefijo.alteracion
            // En devanagari, la raya de debajo (komal) y el trazo de encima (tivra) van tras la sílaba.
            let marcas: [Unicode.Scalar] = ["\u{0951}", "\u{0952}"]
            if self == .sargam, let marca = resto.unicodeScalars.first, marcas.contains(marca) {
                alteracion += marca == "\u{0952}" ? -1 : 1
                resto = String(String.UnicodeScalarView(resto.unicodeScalars.dropFirst()))
            }
            let signos = try Alteracion(leyendo: resto)
            alteracion += signos.semitonos
            let grado = Nota(pasosDeQuinta: forma.nota.pasosDeQuinta + 7 * alteracion)
            guard familia == .movil else { return grado }
            return Nota(pasosDeQuinta: grado.pasosDeQuinta + tonica.pasosDeQuinta)
        }
        throw ErrorDeLectura(texto: texto, posicion: 0, motivo: .notaNoReconocida)
    }

    /// Una forma escrita, ya normalizada como el texto que se lee, con la nota (o el grado) que nombra, o la
    /// alteración, si es un prefijo.
    private struct FormaDeLectura {
        let escalares: [Unicode.Scalar]
        let nota: Nota
        let alteracion: Int
    }

    /// Las formas de los nombres que se leen: los de las tres grafías, con sus nombres propios (en el sargam, el komal
    /// y el tivra), y los de `otrasFormas`.
    private var formasDeLectura: [FormaDeLectura] {
        var formas: [(String, Nota)] = []
        for grafia in Grafia.allCases {
            switch disposicion {
            case .siete(let naturales, let alteraciones):
                for (indice, nombre) in naturales(grafia).enumerated() {
                    formas.append((nombre, Nota(NotaNatural(rawValue: indice) ?? .do)))
                }
                if case .propias(let propias) = alteraciones {
                    for propia in propias(grafia) {
                        let natural = NotaNatural(rawValue: propia.indice) ?? .do
                        formas.append((propia.nombre, Nota(natural, Alteracion(propia.alteracion))))
                    }
                }
            case .doce(let nombres, let primera, let desdeQuinta):
                for (indice, nombre) in nombres(grafia).enumerated() {
                    formas.append((nombre, SistemaDeNombres.notaDeLaClase(primera + indice, desdeQuinta: desdeQuinta)))
                }
            }
        }
        formas += otrasFormas
        return formas.map { nombre, nota in
            FormaDeLectura(escalares: Array(normalizar(nombre).unicodeScalars), nota: nota, alteracion: 0)
        }
    }

    /// Los prefijos que se leen, del más largo al más corto, y al final la cadena vacía (sin prefijo).
    private var prefijosDeLectura: [FormaDeLectura] {
        var prefijos: [FormaDeLectura] = []
        if case .siete(_, .prefijos(let tabla)) = disposicion {
            for grafia in Grafia.allCases {
                for (indice, prefijo) in tabla(grafia).enumerated() {
                    prefijos.append(
                        FormaDeLectura(
                            escalares: Array(normalizar(prefijo).unicodeScalars), nota: Nota(.do),
                            alteracion: [1, -1, 2, -2][indice]))
                }
            }
        }
        prefijos.sort { $0.escalares.count > $1.escalares.count }
        return prefijos + [FormaDeLectura(escalares: [], nota: Nota(.do), alteracion: 0)]
    }

    /// La nota de una clase de altura en la cadena de once quintas que empieza en `desdeQuinta`: con 0, la clase 1
    /// es Do♯ y la 5, Mi♯; con −3, la 3 es Mi♭.
    static func notaDeLaClase(_ clase: Int, desdeQuinta: Int) -> Nota {
        let cadena = desdeQuinta...(desdeQuinta + 11)
        let quintas = cadena.first { Nota(pasosDeQuinta: $0).claseDeAltura == modulo(clase, 12) }
        return Nota(pasosDeQuinta: quintas ?? desdeQuinta)
    }

    /// El texto como se compara al leer: en el sargam, sin espacios y con la ā como a, pero con las mayúsculas; en los
    /// demás, plegado (``plegar(_:)``).
    private func normalizar(_ texto: String) -> String {
        guard self == .sargam else { return SistemaDeNombres.plegar(texto) }
        // La ā, compuesta (U+0101) o con el macrón aparte (U+0304), se lee como a.
        var escalares = String.UnicodeScalarView()
        for escalar in texto.unicodeScalars where escalar != " " && escalar != "\u{0304}" {
            switch escalar {
            case "\u{0101}": escalares.append("a")
            case "\u{0100}": escalares.append("A")
            default: escalares.append(escalar)
            }
        }
        return String(escalares)
    }

    /// El texto sin mayúsculas, tildes (también las griegas, los macrones y los carones del pinyin: ā, ǎ, ǚ), espacios
    /// ni guiones: «Jū-ei He» → «jueihe», «dàlǚ» → «dalu».
    static func plegar(_ texto: String) -> String {
        let sinTildes = texto.claveDeBusqueda.map { (c: Character) -> Character in
            switch c {
            case "ā", "ǎ": return "a"
            case "ē", "ě": return "e"
            case "ī", "ǐ": return "i"
            case "ō", "ǒ": return "o"
            case "ū", "ǔ", "ǖ", "ǘ", "ǚ", "ǜ": return "u"
            default: return c
            }
        }
        return String(sinTildes.filter { $0 != " " })
    }
}
