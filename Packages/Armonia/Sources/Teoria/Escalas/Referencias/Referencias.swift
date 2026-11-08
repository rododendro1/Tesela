// MARK: - Las obras del catálogo
//
// Cada obra es una constante, con la clave de su autor (o de su primer autor) y su año: `west1992`. Una obra nueva va
// en su sección y en `catalogo`; una prueba comprueba que cada una está en `catalogo` una vez y que alguna escala la
// cita. Los títulos se escriben como en la obra, sin traducir; los de un tratado, en su lengua y su grafía.

extension Referencia {
    // MARK: Obras generales

    /// El artículo «Mode» del New Grove, de Harold Powers y otros: los modos de todas las tradiciones.
    public static let powers2001 = Referencia(
        "powers2001", .capitulo, autores: ["Powers, Harold S.", "Wiering, Frans", "Porter, James", "Cowdery, James"],
        titulo: "Mode",
        anio: 2001, publicadoEn: "The New Grove Dictionary of Music and Musicians, 2.ª ed., editado por Stanley Sadie",
        editorial: "Macmillan", lugar: "Londres")
    /// Barbour, la historia de los temperamentos: Ramos, Zarlino, Salinas y Zhu Zaiyu.
    public static let barbour1951 = Referencia(
        "barbour1951", .libro, autores: ["Barbour, J. Murray"], titulo: "Tuning and Temperament: A Historical Survey",
        anio: 1951, editorial: "Michigan State College Press", lugar: "East Lansing")

    // MARK: India

    /// Jairazbhoy, los rāgas indostánicos y los thāṭ de Bhatkhande.
    public static let jairazbhoy1971 = Referencia(
        "jairazbhoy1971", .libro, autores: ["Jairazbhoy, N. A."],
        titulo: "The Rāgs of North Indian Music: Their Structure and Evolution", anio: 1971,
        editorial: "Faber and Faber", lugar: "Londres")
    /// Kaufmann, los rāgas indostánicos.
    public static let kaufmann1968 = Referencia(
        "kaufmann1968", .libro, autores: ["Kaufmann, Walter"], titulo: "The Ragas of North India", anio: 1968,
        editorial: "Indiana University Press", lugar: "Bloomington")
    /// Kaufmann, los mēḷa y los janya carnáticos.
    public static let kaufmann1976 = Referencia(
        "kaufmann1976", .libro, autores: ["Kaufmann, Walter"],
        titulo: "The Ragas of South India: A Catalogue of Scalar Material", anio: 1976,
        editorial: "Indiana University Press", lugar: "Bloomington")
    /// Rowell, la teoría del Nāṭyaśāstra: los grāma y las mūrchanā.
    public static let rowell1992 = Referencia(
        "rowell1992", .libro, autores: ["Rowell, Lewis"], titulo: "Music and Musical Thought in Early India",
        anio: 1992, editorial: "University of Chicago Press", lugar: "Chicago")

    // MARK: Mundo árabe, Persia, Turquía y Azerbaiyán

    /// Touma, los maqamat y los ajnas.
    public static let touma1996 = Referencia(
        "touma1996", .libro, autores: ["Touma, Habib Hassan"], titulo: "The Music of the Arabs", anio: 1996,
        editorial: "Amadeus Press", lugar: "Portland")
    /// Farraj y Abu Shumays, los maqamat y los ajnas de la práctica del siglo XX.
    public static let farraj2019 = Referencia(
        "farraj2019", .libro, autores: ["Farraj, Johnny", "Abu Shumays, Sami"],
        titulo: "Inside Arabic Music: Arabic Maqam Performance and Theory in the 20th Century", anio: 2019,
        editorial: "Oxford University Press", lugar: "Nueva York")
    /// Maqam World, la web de Farraj y Abu Shumays, de donde salen los maqamat y los ajnas del catálogo.
    public static let maqamWorld = Referencia(
        "maqamWorld", .web, autores: ["Farraj, Johnny", "Abu Shumays, Sami"], titulo: "Maqam World", anio: nil,
        url: "https://www.maqamworld.com")
    /// Wright, los adwār de Ṣafī al-Dīn.
    public static let wright1978 = Referencia(
        "wright1978", .libro, autores: ["Wright, Owen"],
        titulo: "The Modal System of Arab and Persian Music, A.D. 1250–1300", anio: 1978,
        editorial: "Oxford University Press", lugar: "Oxford")
    /// Farhat, los dastgāh.
    public static let farhat1990 = Referencia(
        "farhat1990", .libro, autores: ["Farhat, Hormoz"], titulo: "The Dastgāh Concept in Persian Music",
        anio: 1990, editorial: "Cambridge University Press", lugar: "Cambridge")
    /// Signell, los makamlar en el sistema de Arel y Ezgi.
    public static let signell1977 = Referencia(
        "signell1977", .libro, autores: ["Signell, Karl L."], titulo: "Makam: Modal Practice in Turkish Art Music",
        anio: 1977, editorial: "Asian Music Publications", lugar: "Seattle")
    /// La TDV İslâm Ansiklopedisi, con un artículo para cada makam.
    public static let tdvIslamAnsiklopedisi = Referencia(
        "tdvIslamAnsiklopedisi", .web, autores: ["Türkiye Diyanet Vakfı"], titulo: "TDV İslâm Ansiklopedisi",
        anio: nil, url: "https://islamansiklopedisi.org.tr")
    /// Hacıbəyov, los mugam azerbaiyanos.
    public static let hacibeyov1945 = Referencia(
        "hacibeyov1945", .libro, autores: ["Hacıbəyov, Üzeyir"], titulo: "Azərbaycan xalq musiqisinin əsasları",
        anio: 1945, lugar: "Bakú")

    // MARK: Grecia antigua y Bizancio

    /// West, la música griega antigua: harmoniai, géneros y notación.
    public static let west1992 = Referencia(
        "west1992", .libro, autores: ["West, M. L."], titulo: "Ancient Greek Music", anio: 1992,
        editorial: "Clarendon Press", lugar: "Oxford")
    /// Barker, la traducción de Aristóxeno, Ptolomeo y Arístides Quintiliano.
    public static let barker1989 = Referencia(
        "barker1989", .libro, autores: ["Barker, Andrew"],
        titulo: "Greek Musical Writings, vol. II: Harmonic and Acoustic Theory", anio: 1989,
        editorial: "Cambridge University Press", lugar: "Cambridge")
    /// Chalmers, los géneros de todos los autores, en razones y en cents.
    public static let chalmers1993 = Referencia(
        "chalmers1993", .libro, autores: ["Chalmers, John H."], titulo: "Divisions of the Tetrachord", anio: 1993,
        editorial: "Frog Peak Music", lugar: "Hanover (New Hampshire)")
    /// Mathiesen, la teoría griega de la Antigüedad a la Edad Media.
    public static let mathiesen1999 = Referencia(
        "mathiesen1999", .libro, autores: ["Mathiesen, Thomas J."],
        titulo: "Apollo's Lyre: Greek Music and Music Theory in Antiquity and the Middle Ages", anio: 1999,
        editorial: "University of Nebraska Press", lugar: "Lincoln")
    /// El Theōrētikon de Chrysanthos, los echoi en 68 partes de la octava.
    public static let chrysanthos1832 = Referencia(
        "chrysanthos1832", .tratado, autores: ["Chrysanthos de Madytos"], titulo: "Θεωρητικὸν μέγα τῆς μουσικῆς",
        anio: 1832, lugar: "Trieste")

    // MARK: Canto gregoriano y Renacimiento

    /// Apel, el canto gregoriano: los ocho modos y la solmisación.
    public static let apel1958 = Referencia(
        "apel1958", .libro, autores: ["Apel, Willi"], titulo: "Gregorian Chant", anio: 1958,
        editorial: "Indiana University Press", lugar: "Bloomington")
    /// El Dodecachordon de Glareano, los doce modos.
    public static let glareano1547 = Referencia(
        "glareano1547", .tratado, autores: ["Glareanus, Henricus"], titulo: "Dodecachordon", anio: 1547,
        editorial: "Heinrich Petri", lugar: "Basilea")
    /// La Musica practica de Ramos de Pareja.
    public static let ramos1482 = Referencia(
        "ramos1482", .tratado, autores: ["Ramos de Pareja, Bartolomé"], titulo: "Musica practica", anio: 1482,
        lugar: "Bolonia")
    /// L'antica musica de Vicentino, los tres géneros en 31 diesis.
    public static let vicentino1555 = Referencia(
        "vicentino1555", .tratado, autores: ["Vicentino, Nicola"],
        titulo: "L'antica musica ridotta alla moderna prattica", anio: 1555, editorial: "Antonio Barre", lugar: "Roma")
    /// Las Istitutioni harmoniche de Zarlino.
    public static let zarlino1558 = Referencia(
        "zarlino1558", .tratado, autores: ["Zarlino, Gioseffo"], titulo: "Le istitutioni harmoniche", anio: 1558,
        lugar: "Venecia")
    /// El De musica libri septem de Salinas.
    public static let salinas1577 = Referencia(
        "salinas1577", .tratado, autores: ["Salinas, Francisco de"], titulo: "De musica libri septem", anio: 1577,
        editorial: "Mathias Gastius", lugar: "Salamanca")

    // MARK: Asia oriental y sudeste asiático

    /// Kuttner, la teoría de los lü y el sanfen sunyi en la China antigua.
    public static let kuttner1990 = Referencia(
        "kuttner1990", .libro, autores: ["Kuttner, Fritz A."],
        titulo:
            "The Archaeology of Music in Ancient China: 2,000 Years of Acoustical Experimentation, 1400 B.C.–A.D. 750",
        anio: 1990, editorial: "Paragon House", lugar: "Nueva York")
    /// Malm, las escalas japonesas (yō, in, miyakobushi…).
    public static let malm1959 = Referencia(
        "malm1959", .libro, autores: ["Malm, William P."], titulo: "Japanese Music and Musical Instruments",
        anio: 1959, editorial: "Charles E. Tuttle", lugar: "Rutland (Vermont) y Tokio")
    /// Garfias, los modos del gagaku.
    public static let garfias1975 = Referencia(
        "garfias1975", .libro, autores: ["Garfias, Robert"],
        titulo: "Music of a Thousand Autumns: The Tōgaku Style of Japanese Court Music", anio: 1975,
        editorial: "University of California Press", lugar: "Berkeley")
    /// Trần Văn Khê, los modos vietnamitas.
    public static let tranVanKhe1962 = Referencia(
        "tranVanKhe1962", .libro, autores: ["Trần, Văn Khê"], titulo: "La musique vietnamienne traditionnelle",
        anio: 1962, editorial: "Presses Universitaires de France", lugar: "París")
    /// Morton, la música de Tailandia y su afinación de siete partes iguales.
    public static let morton1976 = Referencia(
        "morton1976", .libro, autores: ["Morton, David"], titulo: "The Traditional Music of Thailand", anio: 1976,
        editorial: "University of California Press", lugar: "Berkeley")
    /// Surjodiningrat, Sudarjana y Susanto, las medidas de los gamelan de Java central.
    public static let surjodiningrat1972 = Referencia(
        "surjodiningrat1972", .libro, autores: ["Surjodiningrat, Wasisto", "Sudarjana, P. J.", "Susanto, Adhi"],
        titulo: "Tone Measurements of Outstanding Javanese Gamelans in Jogjakarta and Surakarta", anio: 1972,
        editorial: "Gadjah Mada University Press", lugar: "Yogyakarta")
    /// Tenzer, el gamelan de Bali y sus modos.
    public static let tenzer2000 = Referencia(
        "tenzer2000", .libro, autores: ["Tenzer, Michael"],
        titulo: "Gamelan Gong Kebyar: The Art of Twentieth-Century Balinese Music", anio: 2000,
        editorial: "University of Chicago Press", lugar: "Chicago")

    // MARK: Klezmer y Etiopía

    /// Rubin, los shteyger del klezmer de Nueva York.
    public static let rubin2020 = Referencia(
        "rubin2020", .libro, autores: ["Rubin, Joel E."],
        titulo: "New York Klezmer in the Early Twentieth Century: The Music of Naftule Brandwein and Dave Tarras",
        anio: 2020, editorial: "University of Rochester Press", lugar: "Rochester")
    /// Ashenafi Kebede, los qenet etíopes.
    public static let kebede1971 = Referencia(
        "kebede1971", .tesis, autores: ["Kebede, Ashenafi"],
        titulo: "The Music of Ethiopia: Its Development and Cultural Setting", anio: 1971,
        editorial: "Wesleyan University", lugar: "Middletown (Connecticut)")

    // MARK: Mesopotamia, África y los Andes

    /// Kilmer, la primera lectura de la teoría musical de los textos cuneiformes.
    public static let kilmer1971 = Referencia(
        "kilmer1971", .articulo, autores: ["Kilmer, Anne Draffkorn"],
        titulo: "The Discovery of an Ancient Mesopotamian Theory of Music", anio: 1971,
        publicadoEn: "Proceedings of the American Philosophical Society", volumen: "115 (2)", paginas: "131–149")
    /// Gurney, las afinaciones babilónicas con las escalas descendentes.
    public static let gurney1994 = Referencia(
        "gurney1994", .articulo, autores: ["Gurney, O. R."], titulo: "Babylonian Music Again", anio: 1994,
        publicadoEn: "Iraq", volumen: "56", paginas: "101–106")
    /// West, la notación babilónica y los textos hurritas.
    public static let west1994 = Referencia(
        "west1994", .articulo, autores: ["West, M. L."],
        titulo: "The Babylonian Musical Notation and the Hurrian Melodic Texts", anio: 1994,
        publicadoEn: "Music & Letters", volumen: "75 (2)", paginas: "161–179")
    /// Tracey, la timbila de los chopi.
    public static let tracey1948 = Referencia(
        "tracey1948", .libro, autores: ["Tracey, Hugh"], titulo: "Chopi Musicians: Their Music, Poetry and Instruments",
        anio: 1948, editorial: "Oxford University Press", lugar: "Londres")
    /// Berliner, la mbira de los shona.
    public static let berliner1978 = Referencia(
        "berliner1978", .libro, autores: ["Berliner, Paul F."],
        titulo: "The Soul of Mbira: Music and Traditions of the Shona People of Zimbabwe", anio: 1978,
        editorial: "University of California Press", lugar: "Berkeley")
    /// Knight, la kora de los mandinga y sus afinaciones.
    public static let knight1973 = Referencia(
        "knight1973", .tesis, autores: ["Knight, Roderic Copley"],
        titulo: "Mandinka Jaliya: Professional Music of The Gambia",
        anio: 1973, editorial: "University of California, Los Angeles", lugar: "Los Ángeles")
    /// Raoul y Marguerite d'Harcourt, las escalas pentatónicas de los Andes.
    public static let harcourt1925 = Referencia(
        "harcourt1925", .libro, autores: ["Harcourt, Raoul d'", "Harcourt, Marguerite d'"],
        titulo: "La musique des Incas et ses survivances", anio: 1925, editorial: "Paul Geuthner", lugar: "París")

    /// Todas las obras, en el orden de este fichero.
    public static let catalogo: [Referencia] = [
        .powers2001, .barbour1951, .jairazbhoy1971, .kaufmann1968, .kaufmann1976, .rowell1992, .touma1996, .farraj2019,
        .maqamWorld, .wright1978, .farhat1990, .signell1977, .tdvIslamAnsiklopedisi, .hacibeyov1945, .west1992,
        .barker1989, .chalmers1993, .mathiesen1999, .chrysanthos1832, .apel1958, .glareano1547, .ramos1482,
        .vicentino1555, .zarlino1558, .salinas1577, .kuttner1990, .malm1959, .garfias1975, .tranVanKhe1962, .morton1976,
        .surjodiningrat1972, .tenzer2000, .rubin2020, .kebede1971, .kilmer1971, .gurney1994, .west1994, .tracey1948,
        .berliner1978, .knight1973, .harcourt1925,
    ]
}

extension FuenteTeorica {
    /// La obra donde se leen las escalas de la fuente: su tratado o, en las griegas, su traducción (Barker). `nil` en
    /// Guido.
    public var referencia: Referencia? {
        switch self {
        case .arquitas, .aristoxeno, .eratostenes, .didimo, .ptolomeo, .aristides: .barker1989
        case .guido: nil
        case .glareano: .glareano1547
        case .safiAlDin: .wright1978
        case .guanzi, .lushiChunqiu: .kuttner1990
        case .vicentino: .vicentino1555
        case .chrysanthos: .chrysanthos1832
        case .ramosDePareja: .ramos1482
        case .zarlino: .zarlino1558
        case .salinas: .salinas1577
        case .zhuZaiyu: .barbour1951
        }
    }
}
