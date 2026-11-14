import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct ClaveDeEscalaTests {
    /// Las claves de todas las escalas del catálogo, en su orden. Lo que se guarda en JSON las nombra por su clave, así
    /// que una clave no puede cambiar ni desaparecer: si se cambia el nombre de una escala, se le da la clave que
    /// tenía (`clave:`), y una escala nueva añade aquí la suya.
    static let claves: [String] = [
        "mayor", "dorico", "frigio", "lidio", "mixolidio", "menor-natural", "locrio", "menor-armonica",
        "menor-melodica", "menor-melodica-de-jazz", "mayor-armonica", "locrio-6", "jonico-#5", "dorico-#4",
        "frigio-dominante", "lidio-#2", "ultralocrio", "dorico-b2", "lidio-aumentado", "lidio-dominante",
        "mixolidio-b6", "locrio-2", "alterada", "pentatonica-mayor", "pentatonica-menor", "blues", "tonos-enteros",
        "disminuida-tono-semitono", "bebop-dominante", "bebop-mayor", "bebop-dorico", "bebop-locrio", "bebop-lidio",
        "dorico-b5", "frigio-b4", "lidio-b3", "mixolidio-b2", "lidio-aumentado-#2", "locrio-bb7", "doble-armonica",
        "menor-hungara", "mayor-hungara", "napolitana-menor", "napolitana-mayor", "enigmatica", "persa", "mayor-locria",
        "lidio-menor", "prometeo", "prometeo-napolitano", "disminuida-semitono-tono", "aumentada",
        "aumentada-semitono-tercera", "blues-mayor", "egipcia", "cromatica", "cromatica-con-cinco-bemoles",
        "cromatica-con-tres-bemoles", "cromatica-con-dos-bemoles", "cromatica-con-un-bemol",
        "cromatica-con-cinco-sostenidos", "bebop-menor-melodica", "bebop-menor-armonica", "flamenca", "petrushka",
        "petrushka-menor", "tritono-de-dos-semitonos", "hexatonica-de-armonicos", "modo-3-de-messiaen", "tcherepnin",
        "modo-4-de-messiaen", "modo-5-de-messiaen", "modo-6-de-messiaen", "modo-7-de-messiaen", "lidio-#2-#6",
        "ultrafrigio", "oriental", "jonico-#2-#5", "locrio-bb3-bb7", "lidio-aumentado-#6", "lidio-dominante-aumentado",
        "locrio-2-b4", "superlocrio-bb3", "lidio-#6", "mixolidio-aumentado", "eolico-#4", "locrio-dominante",
        "jonico-#2", "ultralocrio-bb3", "pentatonica-dominante", "pentatonica-menor-6", "pentatonica-mayor-b6",
        "pentatonica-menor-b5", "pentatonica-mayor-b3", "pentatonica-menor-b6", "blues-de-nueve-notas",
        "blues-menor-con-2", "hexacordo", "argelina", "jonico-sin-4", "mixolidio-sin-3", "dorico-sin-6", "eolico-sin-2",
        "hexatonica-de-dos-triadas", "hexatonica-menor-de-dos-triadas", "mayor-rumana", "ultralocrio-bb6",
        "menor-armonica-b5", "superlocrio-6", "menor-melodica-#5", "dorico-b2-#4", "lidio-aumentado-#3", "jonico-b2",
        "jonico-b5", "jonico-#6", "pentatonica-mixolidia", "pentatonica-lidia", "pentatonica-escocesa", "bilaval",
        "kalyan", "khamaj", "kafi", "asavari", "bhairavi", "bhairav", "marva", "purvi", "todi", "ousak", "hitzaz",
        "hitzazkiar", "pireotikos", "tabahaniotikos", "niavent", "nikriz", "kartzigar", "sabah", "houzam", "sengah",
        "tsinganikos", "rast", "kiourdi", "houseini", "kanakangi", "ratnangi", "ganamurti", "vanaspati", "manavati",
        "tanarupi", "senavati", "hanumattodi", "dhenuka", "natakapriya", "kokilapriya", "rupavati", "gayakapriya",
        "vakulabharanam", "mayamalavagaula", "cakravakam", "suryakantam", "hatakambari", "jhankaradhvani",
        "natabhairavi", "kiravani", "kharaharapriya", "gaurimanohari", "varunapriya", "mararanjani", "carukesi",
        "sarasangi", "harikambhoji", "dhirasankarabharanam", "naganandini", "yagapriya", "ragavardhini",
        "gangeyabhusani", "vagadhisvari", "sulini", "calanata", "salagam", "jalarnavam", "jhalavarali", "navanitam",
        "pavani", "raghupriya", "gavambhodhi", "bhavapriya", "subhapantuvarali", "sadvidhamargini", "suvarnangi",
        "divyamani", "dhavalambari", "namanarayani", "kamavardhini", "ramapriya", "gamanasrama", "visvambhari",
        "syamalangi", "sanmukhapriya", "simhendramadhyamam", "hemavati", "dharmavati", "nitimati", "kantamani",
        "rsabhapriya", "latangi", "vacaspati", "mecakalyani", "citrambari", "sucaritra", "jyotisvarupini",
        "dhatuvardhani", "nasikabhusani", "kosalam", "rasikapriya", "mohanam", "hindolam", "hamsadhvani", "abhogi",
        "madhyamavati", "bilahari", "kambhoji", "arabhi", "kedaragaula", "revati", "amrtavarsini", "mohanakalyani",
        "saveri", "nata", "suddha-saveri", "suddha-dhanyasi", "sriranjani", "malayamarutam", "gambhiranata",
        "hamsanadam", "sadja-grama", "madhyama-grama", "uttaramandra", "rajani", "uttarayata", "suddhasadja",
        "matsarikrta", "asvakranta", "abhirudgata", "sauviri", "harinasva", "kalopanata", "suddhamadhya", "margi",
        "pauravi", "hrsyaka", "gong", "shang", "jue", "zhi", "yu", "qingyue", "yayue", "yanyue", "ritsu", "ryo", "yo",
        "minyo", "miyakobushi", "in", "insen", "iwato", "hirajoshi", "kumoijoshi", "ryukyu", "akebono", "kokin-joshi",
        "tezeta-mayor", "tezeta-menor", "bati-mayor", "bati-menor", "ambassal", "ancihoye", "hijaz", "nahawand", "kurd",
        "ajam", "hijazkar", "nawa-athar", "maqam-rast", "bayati", "saba", "suznak", "husayni", "nayruz", "sikah",
        "maqam-huzam", "iraq", "rahat-al-arwah", "bayati-shuri", "jiharkah", "athar-kurd", "maqam-nikriz", "lami",
        "saba-zamzam", "pelog-selisir", "slendro", "degung", "pelog-pathet-lima", "pelog-pathet-nem",
        "pelog-pathet-barang", "slendro-pathet-nem", "slendro-pathet-sanga", "slendro-pathet-manyura", "pelog-tembung",
        "pelog-sunaren", "freygish", "misheberakh", "adonai-malakh", "magen-avot", "bhupali", "malkauns", "durga",
        "yaman", "bagesri", "des", "sivaranjani", "kalavati", "candrakauns", "megh", "lalit", "bhimpalasi", "bihag",
        "darbari-kanada", "puriya-dhanasri", "mahur", "homayun", "cahargah", "sur", "rast-panjgah", "dastgah-segah",
        "nava", "bayat-e-tork", "afsari", "dasti", "abu-ata", "bayat-e-esfahan", "pyongjo", "kyemyonjo", "ujo",
        "pentatonica-andina", "tritonica-andina", "tetracordo-diatonico", "tetracordo-cromatico",
        "tetracordo-enarmonico", "tetracordo-cromatico-de-arquitas", "tetracordo-diatonico-de-arquitas",
        "tetracordo-enarmonico-de-ptolomeo", "tetracordo-cromatico-blando", "tetracordo-cromatico-tenso",
        "tetracordo-diatonico-blando", "tetracordo-diatonico-ditonico", "tetracordo-diatonico-tenso",
        "tetracordo-diatonico-igual", "harmonia-mixolidia", "harmonia-lidia", "harmonia-frigia", "harmonia-doria",
        "harmonia-doria-cromatica", "harmonia-hipolidia", "harmonia-hipofrigia", "harmonia-hipodoria", "rast-makami",
        "hicaz-makami", "hicazkar-makami", "nihavend-makami", "kurdi-makami", "buselik-makami", "cargah-makami",
        "ussak-makami", "huseyni-makami", "segah-makami", "huzzam-makami", "saba-makami", "karcigar-makami",
        "suzinak-makami", "nikriz-makami", "neveser-makami", "mahur-makami", "acemasiran-makami", "sultaniyegah-makami",
        "sedaraban-makami", "humayun-makami", "uzzal-makami", "zirguleli-hicaz-makami", "kurdilihicazkar-makami",
        "muhayyer-makami", "ferahfeza-makami", "isfahan-makami", "rast-mugami", "sur-mugami", "segah-mugami",
        "cahargah-mugami", "suster-mugami", "bayati-siraz-mugami", "humayun-mugami", "echos-protos",
        "echos-plagios-protos", "echos-defteros", "echos-plagios-defteros", "echos-tritos", "echos-varys",
        "echos-tetartos", "echos-plagios-tetartos", "echos-legetos", "isartu", "kitmu", "embubu", "pitu", "nid-qabli",
        "nis-tuhri", "qablitu", "jins-rast", "jins-bayati", "jins-saba", "jins-sikah", "jins-hijaz", "jins-kurd",
        "jins-nahawand", "jins-ajam", "jins-nikriz", "cargah-dortlusu", "cargah-beslisi", "buselik-dortlusu",
        "buselik-beslisi", "kurdi-dortlusu", "kurdi-beslisi", "rast-dortlusu", "rast-beslisi", "ussak-dortlusu",
        "ussak-beslisi", "hicaz-dortlusu", "hicaz-beslisi", "amadinda", "timbila", "hardino", "sauta", "tomora-ba",
        "tomora-mesengo", "nyamaropa", "piphat", "pinpeat", "saung", "protus-authenticus", "protus-plagalis",
        "deuterus-authenticus", "deuterus-plagalis", "tritus-authenticus", "tritus-plagalis", "tetrardus-authenticus",
        "tetrardus-plagalis", "tetracordo-enarmonico-de-arquitas", "tetracordo-cromatico-de-didimo",
        "tetracordo-diatonico-de-didimo", "tetracordo-enarmonico-de-didimo", "tetracordo-cromatico-de-eratostenes",
        "tetracordo-enarmonico-de-eratostenes", "harmonia-mixolidia-cromatica", "harmonia-lidia-cromatica",
        "harmonia-frigia-cromatica", "harmonia-hipolidia-cromatica", "harmonia-hipofrigia-cromatica",
        "harmonia-hipodoria-cromatica", "harmonia-mixolidia-enarmonica", "harmonia-lidia-enarmonica",
        "harmonia-frigia-enarmonica", "harmonia-doria-enarmonica", "harmonia-hipolidia-enarmonica",
        "harmonia-hipofrigia-enarmonica", "harmonia-hipodoria-enarmonica", "harmonia-lidia-de-aristides",
        "harmonia-doria-de-aristides", "harmonia-frigia-de-aristides", "harmonia-iastia-de-aristides",
        "harmonia-mixolidia-de-aristides", "harmonia-sintonolidia-de-aristides", "hexachordum-naturale",
        "hexachordum-durum", "hexachordum-molle", "dorico-ucraniano", "podhalanska", "pentatonica-hungara",
        "cuerno-alpino", "gaita-escocesa", "georgiana", "istriana", "aeolius", "hypoaeolius", "ionicus", "hypoionicus",
        "bac", "vong-co", "ho-mai-nhi", "sa-mac", "dan-ca", "mixolidio-nordestino", "lidio-nordestino",
        "dorico-nordestino", "tetracordo-cromatico-blando-de-aristoxeno", "tetracordo-cromatico-hemiolico",
        "tetracordo-diatonico-blando-de-aristoxeno", "shadd-ushshaq", "shadd-nawa", "shadd-abu-salik", "shadd-rast",
        "shier-lu", "yanglu", "yinlu", "dorico-con-ficta", "mixolidio-con-ficta", "lidio-con-si-bemol", "musica-recta",
        "tetracordo-diatonico-de-vicentino", "tetracordo-cromatico-de-vicentino", "tetracordo-enarmonico-de-vicentino",
        "ichikotsucho", "sojo", "taishikicho", "hyojo", "oshikicho", "banshikicho",
        "lai-sutsanaen", "lai-po-sai", "lai-soi", "lai-yai", "lai-noi",
        "ajam-ushayran", "shawq-afza", "ushshaq-masri", "zanjaran",
    ]

    @Test func lasClavesDelCatalogoNoCambian() {
        let actuales = TipoDeEscala.catalogo.map { $0.clave ?? "" }
        let perdidas = Set(Self.claves).subtracting(actuales)
        #expect(
            perdidas.isEmpty,
            "Claves que ya no tiene ninguna escala: \(perdidas.sorted()). Si se cambió el nombre, dale la clave que tenía (`clave:`)."
        )
        let nuevas = Set(actuales).subtracting(Self.claves)
        #expect(nuevas.isEmpty, "Claves nuevas, que hay que añadir a `ClaveDeEscalaTests.claves`: \(nuevas.sorted())")
    }

    @Test func todasLasEscalasDelCatalogoTienenUnaClaveDistinta() {
        let claves = TipoDeEscala.catalogo.compactMap(\.clave)
        #expect(claves.count == TipoDeEscala.catalogo.count)
        #expect(Set(claves).count == claves.count)
        #expect(
            claves.allSatisfy { $0.allSatisfy { $0.isASCII && ($0.isLowercase || $0.isNumber || "#-".contains($0)) } })
    }

    @Test func laClaveSaleDelNombre() {
        #expect(TipoDeEscala.dorico.clave == "dorico")
        #expect(TipoDeEscala.kafi.clave == "kafi")
        #expect(TipoDeEscala.rastMakami.clave == "rast-makami")
        #expect(TipoDeEscala.claveDeNombre("ʿAjam") == "ajam")
        #expect(TipoDeEscala.claveDeNombre("lidio ♯5") == "lidio-#5")
    }

    @Test func lasQueNoSonDelCatalogoNoTienenClave() {
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .terceraMayor]).clave == nil)
        #expect(TipoDeEscala.menorMelodica.formaDescendente.clave == nil)
    }

    /// Una escala escrita a mano con el nombre y las notas de una del catálogo es esa, como antes de las claves; con
    /// el nombre y otras notas, es una propia.
    @Test func sinClaveSeReconocePorElNombreYLasNotas() {
        let kafi = TipoDeEscala(nombre: "Kāfī", intervalos: TipoDeEscala.dorico.intervalos)
        #expect(kafi.identidad == TipoDeEscala.kafi.identidad)
        #expect(kafi.categoria == TipoDeEscala.kafi.categoria)
        let otra = TipoDeEscala(nombre: "Kāfī", intervalos: TipoDeEscala.mayor.intervalos)
        #expect(otra.identidad != TipoDeEscala.kafi.identidad)
        #expect(otra.categoria == nil)
    }

    @Test func elJSONGuardaLaClave() throws {
        let datos = try JSONEncoder().encode(TipoDeEscala.kafi)
        let texto = try #require(String(data: datos, encoding: .utf8))
        #expect(texto.contains(#""clave":"kafi""#))
        let leida = try JSONDecoder().decode(TipoDeEscala.self, from: datos)
        #expect(leida.clave == "kafi")
        #expect(leida.identidad == TipoDeEscala.kafi.identidad)
    }

    /// Lo guardado con un nombre que ya no tiene la escala sigue siendo esa escala, por su clave.
    @Test func conLaClaveSeReconoceAunqueCambieElNombre() throws {
        let json = #"{"nombre": "Kafi antiguo", "clave": "kafi", "intervalos": [], "alias": []}"#
        let leida = try JSONDecoder().decode(TipoDeEscala.self, from: Data(json.utf8))
        #expect(leida.identidad == TipoDeEscala.kafi.identidad)
        #expect(leida.categoria == TipoDeEscala.kafi.categoria)
    }

    /// Lo guardado antes de que hubiera claves se reconoce por el nombre y las notas.
    @Test func elJSONSinClaveSigueLeyendose() throws {
        var objeto = try #require(
            JSONSerialization.jsonObject(with: JSONEncoder().encode(TipoDeEscala.kafi)) as? [String: Any])
        objeto["clave"] = nil
        let leida = try JSONDecoder().decode(
            TipoDeEscala.self, from: JSONSerialization.data(withJSONObject: objeto))
        #expect(leida.clave == nil)
        #expect(leida.identidad == TipoDeEscala.kafi.identidad)
    }
}
