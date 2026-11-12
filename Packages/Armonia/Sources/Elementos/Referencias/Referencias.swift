// MARK: - Las obras del catálogo
//
// Cada obra es una constante, con la clave de su autor (o de su primer autor) y su año: `west1992`. Una obra nueva va
// en su sección y en `catalogo`; una prueba comprueba que cada una está en `catalogo` una vez y que alguna escala o
// algún acorde la cita. Los títulos se escriben como en la obra, sin traducir; los de un tratado, en su lengua y su
// grafía.

extension Referencia {
    // MARK: Obras generales

    /// El artículo «Mode» del New Grove, de Harold Powers y otros: los modos de todas las tradiciones, también los
    /// siete diatónicos.
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
    /// Hacıbəyov, los mugam azerbaiyanos. El texto azerbaiyano está en musbook.musigi-dunya.az.
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

    /// Cantemir, el «Libro de la ciencia de la música» (hacia 1700): los makamlar de la música otomana de su tiempo, con
    /// su notación por letras (manuscrito; el año es aproximado).
    public static let cantemir1700 = Referencia(
        "cantemir1700", .tratado, autores: ["Cantemir, Dimitrie"],
        titulo: "Kitâbu ʿİlmiʾl-Mûsikî ʿalâ vechiʾl-Hurûfât", anio: 1700, lugar: "Estambul")
    /// Ezgi, el primer volumen de la teoría de Arel-Ezgi-Uzdilek: las 53 comas y los çeşni.
    public static let ezgi1933 = Referencia(
        "ezgi1933", .libro, autores: ["Ezgi, Suphi"], titulo: "Nazarî-Amelî Türk Mûsikîsi", anio: 1933,
        editorial: "İstanbul Konservatuarı", lugar: "Estambul")

    // MARK: Grecia moderna

    /// Pennanen, la música popular griega del siglo XX: los dromoi del rebético y del laikó, con sus escalas y los makam
    /// de los que vienen (tesis doctoral).
    public static let pennanen1999 = Referencia(
        "pennanen1999", .tesis, autores: ["Pennanen, Risto Pekka"],
        titulo: "Westernisation and Modernisation in Greek Popular Music", anio: 1999,
        editorial: "University of Tampere", lugar: "Tampere")

    // MARK: Canto gregoriano y Renacimiento

    /// Apel, el canto gregoriano: los ocho modos, la solmisación y el hexacordo.
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
    /// Sam-Ang Sam, el conjunto pinpeat de Camboya: su historia, su música y su afinación.
    public static let sam1988 = Referencia(
        "sam1988", .tesis, autores: ["Sam, Sam-Ang"], titulo: "The Pin Peat Ensemble: Its History, Music, and Context",
        anio: 1988, editorial: "Wesleyan University", lugar: "Middletown")
    /// Williamson, el arpa birmana (saung gauk): su repertorio clásico, sus afinaciones y sus modos.
    public static let williamson2000 = Referencia(
        "williamson2000", .libro, autores: ["Williamson, Muriel C."],
        titulo: "The Burmese Harp: Its Classical Music, Tunings, and Modes", anio: 2000,
        editorial: "Northern Illinois University, Center for Southeast Asian Studies", lugar: "DeKalb")
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
    /// Shin Eun-Joo, P'yŏngjo, Ujo y Kyemyŏnjo en el pansori según Baek Daewoong y Lee Bohyeong (en la traducción
    /// inglesa de Seokyoung Kim; el original, en 한국음악연구 63, 2018).
    public static let shin2024 = Referencia(
        "shin2024", .articulo, autores: ["Shin, Eun-Joo"],
        titulo:
            "Two Theories of Ujo and Pyeongjo in Pansori: Comparing Baek Daewoong's and Lee Bohyeong's Theories of Pansori Modes",
        anio: 2024, publicadoEn: "Music Theory Online", volumen: "30 (4)", doi: "10.30535/mto.30.4.10")

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

    // MARK: Mesopotamia, África, los Andes y Brasil

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
    /// Kubik, la teoría de la música africana: el xilófono amadinda de Buganda y su afinación equipentatónica.
    public static let kubik1994 = Referencia(
        "kubik1994", .libro, autores: ["Kubik, Gerhard"], titulo: "Theory of African Music, vol. I", anio: 1994,
        editorial: "Florian Noetzel", lugar: "Wilhelmshaven")
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
    /// Siqueira, el sistema modal del folclore del Nordeste de Brasil: los modos mixolidio, lidio con la 7ª menor y
    /// dórico.
    public static let siqueira1981 = Referencia(
        "siqueira1981", .libro, autores: ["Siqueira, José"], titulo: "Sistema modal na música folclórica do Brasil",
        anio: 1981, editorial: "Secretaria de Educação e Cultura", lugar: "João Pessoa")

    // MARK: Acordes

    /// Rothgeb, el acorde de Tristán tal como se escribe (Fa Si Re♯ Sol♯) y su origen.
    public static let rothgeb1995 = Referencia(
        "rothgeb1995", .articulo, autores: ["Rothgeb, John"], titulo: "The Tristan Chord: Identity and Origin",
        anio: 1995, publicadoEn: "Music Theory Online", volumen: "1 (1)",
        url: "https://mtosmt.org/issues/mto.95.1.1/mto.95.1.1.rothgeb.html")
    /// Samson, la armonía de 1900 a 1920: el acorde místico de Skriabin y su escala, la de Prometeo.
    public static let samson1977 = Referencia(
        "samson1977", .libro, autores: ["Samson, Jim"],
        titulo: "Music in Transition: A Study of Tonal Expansion and Atonality, 1900–1920", anio: 1977,
        editorial: "W. W. Norton", lugar: "Nueva York")
    /// Taruskin, el acorde de Petrushka (dos tríadas mayores a un trítono), su escala y la octatónica.
    public static let taruskin1987 = Referencia(
        "taruskin1987", .articulo, autores: ["Taruskin, Richard"],
        titulo: "Chez Pétrouchka: Harmony and Tonality chez Stravinsky", anio: 1987, publicadoEn: "19th-Century Music",
        volumen: "10 (3)", paginas: "265–286")
    /// Taruskin, Stravinski y las tradiciones rusas: el acorde de los augures de «La consagración de la primavera».
    public static let taruskin1996 = Referencia(
        "taruskin1996", .libro, autores: ["Taruskin, Richard"],
        titulo: "Stravinsky and the Russian Traditions: A Biography of the Works Through Mavra", anio: 1996,
        editorial: "University of California Press", lugar: "Berkeley")
    /// Burkhart, el acorde de «Farben», la tercera de las Cinco piezas para orquesta de Schönberg.
    public static let burkhart1973 = Referencia(
        "burkhart1973", .articulo, autores: ["Burkhart, Charles"],
        titulo: "Schoenberg's Farben: An Analysis of Op. 16, No. 3", anio: 1973,
        publicadoEn: "Perspectives of New Music", volumen: "12 (1/2)")
    /// Levine, las disposiciones del piano de jazz: el acorde So What.
    public static let levine1989 = Referencia(
        "levine1989", .libro, autores: ["Levine, Mark"], titulo: "The Jazz Piano Book", anio: 1989,
        editorial: "Sher Music", lugar: "Petaluma")
    /// Persichetti, la armonía del siglo XX: los acordes por cuartas y las escalas sintéticas con nombre (napolitanas,
    /// húngaras, enigmática…).
    public static let persichetti1961 = Referencia(
        "persichetti1961", .libro, autores: ["Persichetti, Vincent"],
        titulo: "Twentieth-Century Harmony: Creative Aspects and Practice", anio: 1961, editorial: "W. W. Norton",
        lugar: "Nueva York")

    // MARK: Escalas occidentales

    /// Aldwell, Schachter y Cadwallader (4.ª ed.), la armonía tonal: las escalas mayor y menores, y los acordes de la tonalidad.
    public static let aldwell2011 = Referencia(
        "aldwell2011", .libro, autores: ["Aldwell, Edward", "Schachter, Carl", "Cadwallader, Allen"],
        titulo: "Harmony and Voice Leading", anio: 2011, editorial: "Schirmer Cengage Learning", lugar: "Boston")
    /// Levine, la teoría del jazz: los modos de la menor melódica, las bebop, las disminuidas, las pentatónicas, el
    /// blues y los acordes de cuatro, cinco y más notas.
    public static let levine1995 = Referencia(
        "levine1995", .libro, autores: ["Levine, Mark"], titulo: "The Jazz Theory Book", anio: 1995,
        editorial: "Sher Music", lugar: "Petaluma")
    /// Messiaen, los modos de transposición limitada.
    public static let messiaen1944 = Referencia(
        "messiaen1944", .libro, autores: ["Messiaen, Olivier"], titulo: "Technique de mon langage musical",
        anio: 1944, editorial: "Alphonse Leduc", lugar: "París")
    /// Lendvai, la escala acústica en Bartók.
    public static let lendvai1971 = Referencia(
        "lendvai1971", .libro, autores: ["Lendvai, Ernő"], titulo: "Béla Bartók: An Analysis of His Music",
        anio: 1971, editorial: "Kahn & Averill", lugar: "Londres")
    /// Cohn, los sistemas hexatónicos: la escala aumentada.
    public static let cohn1996 = Referencia(
        "cohn1996", .articulo, autores: ["Cohn, Richard"],
        titulo: "Maximally Smooth Cycles, Hexatonic Systems, and the Analysis of Late-Romantic Triadic Progressions",
        anio: 1996, publicadoEn: "Music Analysis", volumen: "15 (1)", paginas: "9–40")
    /// Slonimsky, el tesauro de escalas: las divisiones de la octava en partes iguales (tritono, ditono, sesquitono) con
    /// notas interpoladas, de donde salen la aumentada semitono-tercera y Petrushka menor.
    public static let slonimsky1947 = Referencia(
        "slonimsky1947", .libro, autores: ["Slonimsky, Nicolas"], titulo: "Thesaurus of Scales and Melodic Patterns",
        anio: 1947, editorial: "Coleman-Ross", lugar: "Nueva York")
    /// Slonimsky, la música de Tcherepnin: su escala de nueve pasos, de tres tetracordos de semitono, tono y semitono.
    public static let slonimsky1968 = Referencia(
        "slonimsky1968", .articulo, autores: ["Slonimsky, Nicolas"], titulo: "Alexander Tcherepnin Septuagenarian",
        anio: 1968, publicadoEn: "Tempo")
    /// Burke, la escala enigmática de Verdi y Puccini: el acertijo de Crescentini y su forma descendente, con Fa♮.
    public static let burke2015 = Referencia(
        "burke2015", .articulo, autores: ["Burke, Richard"],
        titulo: "“That Awkward Scale”: Verdi, Puccini, and the Scala enigmatica", anio: 2015,
        publicadoEn: "Music Theory Online", volumen: "21 (2)",
        url: "https://mtosmt.org/issues/mto.15.21.2/mto.15.21.2.burke.html")
    /// Tymoczko, las escalas del siglo XX y del jazz: la acústica, la de tonos enteros, la octatónica, la hexatónica
    /// y las armónicas menor y mayor.
    public static let tymoczko2011 = Referencia(
        "tymoczko2011", .libro, autores: ["Tymoczko, Dmitri"],
        titulo: "A Geometry of Music: Harmony and Counterpoint in the Extended Common Practice", anio: 2011,
        editorial: "Oxford University Press", lugar: "Nueva York")
    /// Manuel, la armonía del modo frigio en el flamenco: la escala flamenca y el frigio dominante.
    public static let manuel1989 = Referencia(
        "manuel1989", .articulo, autores: ["Manuel, Peter"],
        titulo: "Modal Harmony in Andalusian, Eastern European, and Turkish Syncretic Musics", anio: 1989,
        publicadoEn: "Yearbook for Traditional Music", volumen: "21", paginas: "70–94")
    /// Van der Merwe, el origen de la música popular del siglo XX: las pentatónicas y el blues.
    public static let vanDerMerwe1989 = Referencia(
        "vanDerMerwe1989", .libro, autores: ["Van der Merwe, Peter"],
        titulo: "Origins of the Popular Style: The Antecedents of Twentieth-Century Popular Music", anio: 1989,
        editorial: "Clarendon Press", lugar: "Oxford")
    /// Walser, el heavy metal: el acorde de potencia.
    public static let walser1993 = Referencia(
        "walser1993", .libro, autores: ["Walser, Robert"],
        titulo: "Running with the Devil: Power, Gender, and Madness in Heavy Metal Music", anio: 1993,
        editorial: "Wesleyan University Press", lugar: "Hanover")

    // MARK: Progresiones

    /// Gjerdingen, los esquemas del estilo galante: la romanesca, el monte, la fonte, la ponte, el do-re-mi…
    public static let gjerdingen2007 = Referencia(
        "gjerdingen2007", .libro, autores: ["Gjerdingen, Robert O."], titulo: "Music in the Galant Style", anio: 2007,
        editorial: "Oxford University Press", lugar: "Nueva York")
    /// Hudson, la folía, de la guitarra española de cinco órdenes a Corelli (el primero de sus cuatro volúmenes).
    public static let hudson1982 = Referencia(
        "hudson1982", .libro, autores: ["Hudson, Richard"],
        titulo:
            "The Folia, the Saraband, the Passacaglia, and the Chaconne, vol. I: The Folia",
        anio: 1982, editorial: "American Institute of Musicology", lugar: "Neuhausen-Stuttgart")
    /// Hudson, el pasacalle, de la guitarra española a las variaciones para teclado (el tercero de sus cuatro
    /// volúmenes).
    public static let hudsonPassacaglia1982 = Referencia(
        "hudsonPassacaglia1982", .libro, autores: ["Hudson, Richard"],
        titulo: "The Folia, the Saraband, the Passacaglia, and the Chaconne, vol. III: The Passacaglia",
        anio: 1982, editorial: "American Institute of Musicology", lugar: "Neuhausen-Stuttgart")
    /// Hudson, la chacona (el cuarto de sus cuatro volúmenes).
    public static let hudsonChaconne1982 = Referencia(
        "hudsonChaconne1982", .libro, autores: ["Hudson, Richard"],
        titulo: "The Folia, the Saraband, the Passacaglia, and the Chaconne, vol. IV: The Chaconne",
        anio: 1982, editorial: "American Institute of Musicology", lugar: "Neuhausen-Stuttgart")
    /// El artículo «Passamezzo» del New Grove: el antico y el moderno.
    public static let gerbino2001 = Referencia(
        "gerbino2001", .capitulo, autores: ["Gerbino, Giuseppe", "Silbiger, Alexander"], titulo: "Passamezzo",
        anio: 2001, publicadoEn: "The New Grove Dictionary of Music and Musicians, 2.ª ed., editado por Stanley Sadie",
        editorial: "Macmillan", lugar: "Londres")
    /// Staiti, la historia del ruggiero, de la melodía y su bajo.
    public static let staiti2023 = Referencia(
        "staiti2023", .articulo, autores: ["Staiti, Nico"], titulo: "Il Ruggiero: storia di una forma di danza",
        anio: 2023, publicadoEn: "Artes – Rivista di arte, letteratura e musica dell'Officina San Francesco Bologna",
        volumen: "2", paginas: "111–136", doi: "10.6092/issn.2974-7287/18300")
    /// Sheinberg, la bergamasca y su bajo I–IV–V–I (p. 19, citando a Judith Cohen).
    public static let sheinberg2016 = Referencia(
        "sheinberg2016", .articulo, autores: ["Sheinberg, Esti"],
        titulo: "In Praise of the Politically Incorrect: the Bergamasca", anio: 2016,
        publicadoEn: "Min-Ad: Israel Studies in Musicology", volumen: "13", paginas: "19–34")
    /// Rosand, el tetracordo descendente, el bajo del lamento.
    public static let rosand1979 = Referencia(
        "rosand1979", .articulo, autores: ["Rosand, Ellen"], titulo: "The Descending Tetrachord: An Emblem of Lament",
        anio: 1979, publicadoEn: "The Musical Quarterly", volumen: "65", paginas: "346–359")
    /// Doll, la armonía del rock y del pop: los esquemas de cuatro acordes, la de los 50, ♭VI–♭VII–I…
    public static let doll2017 = Referencia(
        "doll2017", .libro, autores: ["Doll, Christopher"],
        titulo: "Hearing Harmony: Toward a Tonal Theory for the Rock Era", anio: 2017,
        editorial: "University of Michigan Press", lugar: "Ann Arbor")

    // MARK: Compendios

    // MARK: Europa

    /// Soroker, lo ucraniano en la música clásica: el dórico con la cuarta aumentada (pp. 8–10).
    public static let soroker1995 = Referencia(
        "soroker1995", .libro, autores: ["Soroker, Yakov"], titulo: "Ukrainian Musical Elements in Classical Music",
        anio: 1995, editorial: "Canadian Institute of Ukrainian Studies Press", lugar: "Edmonton")
    /// Małanicz-Przybylska, la música de hoy de Podhale.
    public static let malaniczPrzybylska2018 = Referencia(
        "malaniczPrzybylska2018", .libro, autores: ["Małanicz-Przybylska, Maria"],
        titulo: "Między dźwiękami Skalnego Podhala. Współczesna góralszczyzna", anio: 2018,
        editorial: "Wydawnictwa Uniwersytetu Warszawskiego", lugar: "Varsovia")
    /// Kodály, la canción popular húngara y su pentatónica (la traducción inglesa de «A magyar népzene», 1937).
    public static let kodaly1960 = Referencia(
        "kodaly1960", .libro, autores: ["Kodály, Zoltán"], titulo: "Folk Music of Hungary", anio: 1960,
        editorial: "Barrie and Rockliff", lugar: "Londres")
    /// Liszt, el libro sobre los gitanos y su música en Hungría: la escala húngara, con sus dos segundas aumentadas.
    public static let liszt1859 = Referencia(
        "liszt1859", .libro, autores: ["Liszt, Franz"], titulo: "Des Bohémiens et de leur musique en Hongrie",
        anio: 1859, editorial: "A. Bourdilliat", lugar: "París")
    /// Glinka, «Ruslán y Liudmila»: el tema de Chernomor, la primera escala de tonos enteros de una obra conocida.
    public static let glinka1842 = Referencia(
        "glinka1842", .partitura, autores: ["Glinka, Mikhail"], titulo: "Ruslan and Lyudmila", anio: 1842)
    /// Rimski-Kórsakov, «Sadkó», op. 5: la primera vez que se usa la escala octatónica, la «escala de Rimski-Kórsakov».
    public static let rimskiKorsakov1867 = Referencia(
        "rimskiKorsakov1867", .partitura, autores: ["Rimsky-Korsakov, Nikolai"], titulo: "Sadko, Op. 5", anio: 1867)
    /// Verdi, el «Ave Maria» sobre la «scala enigmatica», la primera de las «Quattro pezzi sacri».
    public static let verdi1889 = Referencia(
        "verdi1889", .partitura, autores: ["Verdi, Giuseppe"], titulo: "Ave Maria sulla scala enigmatica", anio: 1889)
    /// Skriabin, «Prometeo: el poema del fuego», op. 60, sobre el acorde místico.
    public static let skriabin1910 = Referencia(
        "skriabin1910", .partitura, autores: ["Scriabin, Alexander"], titulo: "Prometheus: The Poem of Fire, Op. 60",
        anio: 1910)
    /// Stravinski, «Petrushka», el ballet del acorde de dos tríadas a un tritono.
    public static let stravinski1911 = Referencia(
        "stravinski1911", .partitura, autores: ["Stravinsky, Igor"], titulo: "Petrushka", anio: 1911)
    /// Campbell, el cuerno de los Alpes y sus armónicos, en la Cambridge Encyclopedia of Brass Instruments.
    public static let campbell2019 = Referencia(
        "campbell2019", .capitulo, autores: ["Campbell, Murray"], titulo: "Alphorn", anio: 2019,
        publicadoEn:
            "The Cambridge Encyclopedia of Brass Instruments, editado por Trevor Herbert, Arnold Myers y John Wallace",
        editorial: "Cambridge University Press", lugar: "Cambridge", paginas: "18–20", doi: "10.1017/9781316841273")
    /// Cannon, la gaita de las Highlands y su escala.
    public static let cannon2002 = Referencia(
        "cannon2002", .libro, autores: ["Cannon, Roderick D."], titulo: "The Highland Bagpipe and Its Music",
        anio: 2002, editorial: "Birlinn", lugar: "Edimburgo")
    /// Scherbaum, Mzhavanadze, Rosenzweig y Müller, las afinaciones del canto georgiano medidas en grabaciones de
    /// campo de Svaneti.
    public static let scherbaum2022 = Referencia(
        "scherbaum2022", .articulo,
        autores: ["Scherbaum, Frank", "Mzhavanadze, Nana", "Rosenzweig, Sebastian", "Müller, Meinard"],
        titulo: "Tuning Systems of Traditional Georgian Singing Determined from a New Corpus of Field Recordings",
        anio: 2022, publicadoEn: "Musicologist", volumen: "6 (2)", paginas: "142–168",
        doi: "10.33906/musicologist.1068947")
    /// Bonifačić, qué es y qué no es la llamada escala istriana.
    public static let bonifacic2001 = Referencia(
        "bonifacic2001", .articulo, autores: ["Bonifačić, Ruža"],
        titulo: "O problematici takozvane «istarske ljestvice»", anio: 2001,
        publicadoEn: "Narodna umjetnost", volumen: "38 (2)", paginas: "73–97")

    /// Rechberger, un compendio de más de mil escalas: las diatónicas y las pentatónicas, los modos griegos, bizantinos
    /// y eclesiásticos, los gitanos húngaros y los sistemas árabe, persa, turco, indio, japonés y chino (ISBN
    /// 978-952-5489-07-1). Se cita por sus capítulos, no escala por escala.
    public static let rechberger2008 = Referencia(
        "rechberger2008", .libro, autores: ["Rechberger, Herman"], titulo: "Scales and Modes around the World",
        anio: 2008, editorial: "Fennica Gehrman", lugar: "Helsinki")
    /// Busoni, el Entwurf: las 113 escalas de siete notas que salen de bajar y subir los grados de la de Do (p. 41
    /// de la segunda edición, la de 1916; la primera, de 1907, ya las cuenta, como se ve en la traducción de Baker de
    /// 1911). No les da nombre: se cita por todas las heptatónicas sintéticas.
    public static let busoni1916 = Referencia(
        "busoni1916", .libro, autores: ["Busoni, Ferruccio"], titulo: "Entwurf einer neuen Ästhetik der Tonkunst",
        anio: 1916, editorial: "Insel-Verlag", lugar: "Leipzig")

    // MARK: Ritmo

    /// Toussaint, la geometría del ritmo: la notación de caja, los ritmos euclídeos, las seis claves, el contratiempo,
    /// los ritmos profundos y las distancias entre ritmos.
    public static let toussaint2013 = Referencia(
        "toussaint2013", .libro, autores: ["Toussaint, Godfried T."],
        titulo: "The Geometry of Musical Rhythm: What Makes a “Good” Rhythm Good?", anio: 2013, editorial: "CRC Press",
        lugar: "Boca Raton")
    /// Clayton, el tiempo en la música indostánica: los tāla, sus vibhāg, la palmada (tālī) y la onda (khālī).
    public static let clayton2000 = Referencia(
        "clayton2000", .libro, autores: ["Clayton, Martin"],
        titulo: "Time in Indian Music: Rhythm, Metre, and Form in North Indian Rāg Performance", anio: 2000,
        editorial: "Oxford University Press", lugar: "Oxford")
    /// Viswanathan y Allen, la música carnática: el ādi tāla y la cuenta de los tāla del sur.
    public static let viswanathan2004 = Referencia(
        "viswanathan2004", .libro, autores: ["Viswanathan, T.", "Allen, Matthew Harp"], titulo: "Music in South India",
        anio: 2004, editorial: "Oxford University Press", lugar: "New York")
    /// Brăiloiu, el ritmo aksak: los compases de tiempos de dos y tres pulsos de los Balcanes y de Turquía.
    public static let brailoiu1951 = Referencia(
        "brailoiu1951", .articulo, autores: ["Brăiloiu, Constantin"], titulo: "Le rythme aksak", anio: 1951,
        publicadoEn: "Revue de Musicologie", volumen: "33", paginas: "71–108")
    /// Apel, la notación de la polifonía: los seis modos rítmicos de la escuela de Notre Dame.
    public static let apel1953 = Referencia(
        "apel1953", .libro, autores: ["Apel, Willi"], titulo: "The Notation of Polyphonic Music, 900–1600",
        anio: 1953, editorial: "The Mediaeval Academy of America", lugar: "Cambridge (Massachusetts)")
    /// Fernández, la teoría del flamenco: el compás de doce tiempos de la soleá y la bulería, y el de la seguiriya.
    public static let fernandez2004 = Referencia(
        "fernandez2004", .libro, autores: ["Fernández, Lola"], titulo: "Teoría musical del flamenco", anio: 2004,
        editorial: "Acordes Concert", lugar: "Madrid")

    // MARK: Temperamentos

    /// Lindley, el artículo «Temperaments» del New Grove: los mesotónicos, los buenos temperamentos del Barroco
    /// (Werckmeister, Kirnberger, Vallotti, Young) y el igual.
    public static let lindley2001 = Referencia(
        "lindley2001", .capitulo, autores: ["Lindley, Mark"], titulo: "Temperaments", anio: 2001,
        publicadoEn: "The New Grove Dictionary of Music and Musicians, 2.ª ed., editado por Stanley Sadie",
        editorial: "Macmillan", lugar: "Londres")
    /// Sethares, la afinación y el timbre: las octavas partidas en 19, 22, 31 y 41 partes iguales.
    public static let sethares2005 = Referencia(
        "sethares2005", .libro, autores: ["Sethares, William A."], titulo: "Tuning, Timbre, Spectrum, Scale",
        anio: 2005, editorial: "Springer", lugar: "Londres")

    // MARK: Notas

    /// Haynes, la historia del diapasón: del Chorton y el Cammerton del Barroco al La 440, pasando por el diapasón
    /// normal francés, el filarmónico de Londres y el de Verdi.
    public static let haynes2002 = Referencia(
        "haynes2002", .libro, autores: ["Haynes, Bruce"], titulo: "A History of Performing Pitch: The Story of \"A\"",
        anio: 2002, editorial: "Scarecrow Press", lugar: "Lanham")
    /// Neumann, los adornos del Barroco y después: la acciaccatura, el mordente, el grupeto y el trino.
    public static let neumann1978 = Referencia(
        "neumann1978", .libro, autores: ["Neumann, Frederick"],
        titulo: "Ornamentation in Baroque and Post-Baroque Music, with Special Emphasis on J. S. Bach", anio: 1978,
        editorial: "Princeton University Press", lugar: "Princeton")

    /// Todas las obras, en el orden de este fichero.
    public static let catalogo: [Referencia] = [
        .powers2001, .barbour1951, .jairazbhoy1971, .kaufmann1968, .kaufmann1976, .rowell1992, .touma1996, .farraj2019,
        .maqamWorld, .wright1978, .farhat1990, .signell1977, .tdvIslamAnsiklopedisi, .hacibeyov1945, .west1992,
        .barker1989, .chalmers1993, .mathiesen1999, .chrysanthos1832, .cantemir1700, .ezgi1933, .pennanen1999,
        .apel1958, .glareano1547,
        .ramos1482,
        .vicentino1555, .zarlino1558, .salinas1577, .kuttner1990, .malm1959, .garfias1975, .tranVanKhe1962, .morton1976,
        .sam1988, .williamson2000,
        .surjodiningrat1972, .tenzer2000, .shin2024, .rubin2020, .kebede1971, .kilmer1971, .gurney1994, .west1994,
        .tracey1948, .kubik1994,
        .berliner1978, .knight1973, .harcourt1925, .siqueira1981, .rothgeb1995, .samson1977, .taruskin1987,
        .taruskin1996,
        .burkhart1973,
        .levine1989, .persichetti1961, .aldwell2011, .levine1995, .messiaen1944, .lendvai1971, .cohn1996,
        .slonimsky1947, .slonimsky1968, .burke2015,
        .tymoczko2011, .manuel1989, .vanDerMerwe1989, .walser1993, .gjerdingen2007, .hudson1982, .hudsonPassacaglia1982,
        .hudsonChaconne1982,
        .gerbino2001, .staiti2023, .sheinberg2016, .rosand1979, .doll2017,
        .soroker1995, .malaniczPrzybylska2018, .kodaly1960, .liszt1859, .glinka1842, .rimskiKorsakov1867, .verdi1889,
        .skriabin1910, .stravinski1911, .campbell2019, .cannon2002, .scherbaum2022,
        .bonifacic2001,
        .rechberger2008, .busoni1916, .toussaint2013, .clayton2000, .viswanathan2004, .brailoiu1951, .apel1953,
        .fernandez2004, .lindley2001, .sethares2005, .haynes2002, .neumann1978,
    ]
}
