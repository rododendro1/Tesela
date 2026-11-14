import Elementos

// MARK: - India
//
// Las versiones microtonales (`afinaciones:` en cada escala). Thāṭ y Yaman (los 22 śruti, por su número desde Sa: 0 =
// 1/1, 3 = 10/9, 7 = 5/4, 9 = 4/3, 13 = 3/2…). Los de grado natural siguen el ṣaḍja-grāma de Bharata, el modelo de E.
// J. Arnold: Kāfī es Sa Re(10/9) ga(32/27) ma Pa Dha(5/3) ni(16/9); Khamāj sube ga a Ga(5/4), Bilāval también ni a
// Ni(15/8) y Kalyāṇ, ma a Ma(45/32). Los rāgas con ati-komal (Bhairav, Bhairavī, Toḍī) llevan el re y el dha
// pitagóricos (256/243, 128/81); Toḍī, como lo miden Bel y otros (Ga 32/27, Ma 45/32, Ni 243/128); Mārvā y Pūrvī, el re
// de 16/15.

extension TipoDeEscala {
    // MARK: Mēḷa (música carnática)

    /// Nombres de los 72 mēḷa, en orden, transliterados según el AITS (IAST).
    package static let nombresDeMelakarta = [
        "Kanakāṅgī", "Ratnāṅgī", "Gānamūrti", "Vanaspati", "Mānavatī", "Tānarūpī",
        "Senāvatī", "Hanumattoḍī", "Dhenukā", "Nāṭakapriyā", "Kokilapriyā", "Rūpavatī",
        "Gāyakapriyā", "Vakuḷābharaṇam", "Māyāmālavagauḷa", "Cakravākam", "Sūryakāntam", "Hāṭakāmbarī",
        "Jhaṅkāradhvani", "Naṭabhairavī", "Kīravāṇī", "Kharaharapriyā", "Gaurīmanoharī", "Varuṇapriyā",
        "Mārarañjanī", "Cārukeśī", "Sarasāṅgī", "Harikāmbhojī", "Dhīraśaṅkarābharaṇam", "Nāganandinī",
        "Yāgapriyā", "Rāgavardhinī", "Gāṅgeyabhūṣaṇī", "Vāgadhīśvarī", "Śūlinī", "Calanāṭa",
        "Sālagam", "Jalārṇavam", "Jhālavarāḷī", "Navanītam", "Pāvanī", "Raghupriyā",
        "Gavāmbhodhi", "Bhavapriyā", "Śubhapantuvarāḷī", "Ṣaḍvidhamārgiṇī", "Suvarṇāṅgī", "Divyamaṇi",
        "Dhavaḷāmbarī", "Nāmanārāyaṇī", "Kāmavardhinī", "Rāmapriyā", "Gamanāśrama", "Viśvambharī",
        "Śyāmalāṅgī", "Ṣaṇmukhapriyā", "Siṃhendramadhyamam", "Hemavatī", "Dharmavatī", "Nītimatī",
        "Kāntāmaṇi", "Ṛṣabhapriyā", "Latāṅgī", "Vācaspati", "Mecakalyāṇī", "Citrāmbarī",
        "Sucaritra", "Jyotisvarūpiṇī", "Dhātuvardhanī", "Nāsikābhūṣaṇī", "Kosalam", "Rasikapriyā",
    ]

    /// Los mismos nombres en la transliteración habitual sin diacríticos (se aceptan al buscar).
    package static let nombresDeMelakartaSinDiacriticos = [
        "Kanakangi", "Ratnangi", "Ganamurti", "Vanaspati", "Manavati", "Tanarupi",
        "Senavati", "Hanumatodi", "Dhenuka", "Natakapriya", "Kokilapriya", "Rupavati",
        "Gayakapriya", "Vakulabharanam", "Mayamalavagowla", "Chakravakam", "Suryakantam", "Hatakambari",
        "Jhankaradhvani", "Natabhairavi", "Kiravani", "Kharaharapriya", "Gourimanohari", "Varunapriya",
        "Mararanjani", "Charukesi", "Sarasangi", "Harikambhoji", "Dhirasankarabharanam", "Naganandini",
        "Yagapriya", "Ragavardhini", "Gangeyabhushani", "Vagadhisvari", "Shulini", "Chalanata",
        "Salagam", "Jalarnavam", "Jhalavarali", "Navanitam", "Pavani", "Raghupriya",
        "Gavambhodi", "Bhavapriya", "Shubhapantuvarali", "Shadvidamargini", "Suvarnangi", "Divyamani",
        "Dhavalambari", "Namanarayani", "Kamavardhini", "Ramapriya", "Gamanashrama", "Vishvambari",
        "Shamalangi", "Shanmukhapriya", "Simhendramadhyamam", "Hemavati", "Dharmavati", "Nitimati",
        "Kantamani", "Rishabhapriya", "Latangi", "Vachaspati", "Mechakalyani", "Chitrambari",
        "Sucharitra", "Jyotisvarupini", "Dhatuvardhani", "Nasikabhushani", "Kosalam", "Rasikapriya",
    ]

    /// Los mismos nombres en devanagari, en la forma sánscrita (con virama final: धीरशङ्कराभरणम्).
    package static let nombresDeMelakartaEnDevanagari = [
        "कनकाङ्गी", "रत्नाङ्गी", "गानमूर्ति", "वनस्पति", "मानवती", "तानरूपी",
        "सेनावती", "हनुमत्तोडी", "धेनुका", "नाटकप्रिया", "कोकिलप्रिया", "रूपवती",
        "गायकप्रिया", "वकुळाभरणम्", "मायामालवगौळ", "चक्रवाकम्", "सूर्यकान्तम्", "हाटकाम्बरी",
        "झङ्कारध्वनि", "नटभैरवी", "कीरवाणी", "खरहरप्रिया", "गौरीमनोहरी", "वरुणप्रिया",
        "माररञ्जनी", "चारुकेशी", "सरसाङ्गी", "हरिकाम्भोजी", "धीरशङ्कराभरणम्", "नागनन्दिनी",
        "यागप्रिया", "रागवर्धिनी", "गाङ्गेयभूषणी", "वागधीश्वरी", "शूलिनी", "चलनाट",
        "सालगम्", "जलार्णवम्", "झालवराळी", "नवनीतम्", "पावनी", "रघुप्रिया",
        "गवाम्भोधि", "भवप्रिया", "शुभपन्तुवराळी", "षड्विधमार्गिणी", "सुवर्णाङ्गी", "दिव्यमणि",
        "धवळाम्बरी", "नामनारायणी", "कामवर्धिनी", "रामप्रिया", "गमनाश्रम", "विश्वम्भरी",
        "श्यामलाङ्गी", "षण्मुखप्रिया", "सिंहेन्द्रमध्यमम्", "हेमवती", "धर्मवती", "नीतिमती",
        "कान्तामणि", "ऋषभप्रिया", "लताङ्गी", "वाचस्पति", "मेचकल्याणी", "चित्राम्बरी",
        "सुचरित्र", "ज्योतिस्वरूपिणी", "धातुवर्धनी", "नासिकाभूषणी", "कोसलम्", "रसिकप्रिया",
    ]

    /// Los mismos nombres en telugu y en canarés, pasados del devanagari letra a letra con tres reglas de la
    /// ortografía de esas lenguas para los nombres de rāga: la nasal ante una consonante de su grupo se escribe con
    /// anusvara (కనకాంగి, no కనకాఙ్గీ), la -m final también (చక్రవాకం) y la ī y la ā finales se acortan
    /// (ఖరహరప్రియ). Cotejados con los títulos de la Wikipedia en telugu: de los 72 coinciden 57, y los otros 15
    /// difieren en lo que el IAST de `nombresDeMelakarta` da por bueno (నటభైరవి, no నఠభైరవి; ఋషభప్రియ).
    package static let nombresDeMelakartaEnTelugu: [String] = [
        "కనకాంగి", "రత్నాంగి", "గానమూర్తి", "వనస్పతి", "మానవతి", "తానరూపి",
        "సేనావతి", "హనుమత్తోడి", "ధేనుక", "నాటకప్రియ", "కోకిలప్రియ", "రూపవతి",
        "గాయకప్రియ", "వకుళాభరణం", "మాయామాలవగౌళ", "చక్రవాకం", "సూర్యకాంతం", "హాటకాంబరి",
        "ఝంకారధ్వని", "నటభైరవి", "కీరవాణి", "ఖరహరప్రియ", "గౌరీమనోహరి", "వరుణప్రియ",
        "మారరంజని", "చారుకేశి", "సరసాంగి", "హరికాంభోజి", "ధీరశంకరాభరణం", "నాగనందిని",
        "యాగప్రియ", "రాగవర్ధిని", "గాంగేయభూషణి", "వాగధీశ్వరి", "శూలిని", "చలనాట",
        "సాలగం", "జలార్ణవం", "ఝాలవరాళి", "నవనీతం", "పావని", "రఘుప్రియ",
        "గవాంభోధి", "భవప్రియ", "శుభపంతువరాళి", "షడ్విధమార్గిణి", "సువర్ణాంగి", "దివ్యమణి",
        "ధవళాంబరి", "నామనారాయణి", "కామవర్ధిని", "రామప్రియ", "గమనాశ్రమ", "విశ్వంభరి",
        "శ్యామలాంగి", "షణ్ముఖప్రియ", "సింహేంద్రమధ్యమం", "హేమవతి", "ధర్మవతి", "నీతిమతి",
        "కాంతామణి", "ఋషభప్రియ", "లతాంగి", "వాచస్పతి", "మేచకల్యాణి", "చిత్రాంబరి",
        "సుచరిత్ర", "జ్యోతిస్వరూపిణి", "ధాతువర్ధని", "నాసికాభూషణి", "కోసలం", "రసికప్రియ",
    ]

    package static let nombresDeMelakartaEnCanares: [String] = [
        "ಕನಕಾಂಗಿ", "ರತ್ನಾಂಗಿ", "ಗಾನಮೂರ್ತಿ", "ವನಸ್ಪತಿ", "ಮಾನವತಿ", "ತಾನರೂಪಿ",
        "ಸೇನಾವತಿ", "ಹನುಮತ್ತೋಡಿ", "ಧೇನುಕ", "ನಾಟಕಪ್ರಿಯ", "ಕೋಕಿಲಪ್ರಿಯ", "ರೂಪವತಿ",
        "ಗಾಯಕಪ್ರಿಯ", "ವಕುಳಾಭರಣಂ", "ಮಾಯಾಮಾಲವಗೌಳ", "ಚಕ್ರವಾಕಂ", "ಸೂರ್ಯಕಾಂತಂ", "ಹಾಟಕಾಂಬರಿ",
        "ಝಂಕಾರಧ್ವನಿ", "ನಟಭೈರವಿ", "ಕೀರವಾಣಿ", "ಖರಹರಪ್ರಿಯ", "ಗೌರೀಮನೋಹರಿ", "ವರುಣಪ್ರಿಯ",
        "ಮಾರರಂಜನಿ", "ಚಾರುಕೇಶಿ", "ಸರಸಾಂಗಿ", "ಹರಿಕಾಂಭೋಜಿ", "ಧೀರಶಂಕರಾಭರಣಂ", "ನಾಗನಂದಿನಿ",
        "ಯಾಗಪ್ರಿಯ", "ರಾಗವರ್ಧಿನಿ", "ಗಾಂಗೇಯಭೂಷಣಿ", "ವಾಗಧೀಶ್ವರಿ", "ಶೂಲಿನಿ", "ಚಲನಾಟ",
        "ಸಾಲಗಂ", "ಜಲಾರ್ಣವಂ", "ಝಾಲವರಾಳಿ", "ನವನೀತಂ", "ಪಾವನಿ", "ರಘುಪ್ರಿಯ",
        "ಗವಾಂಭೋಧಿ", "ಭವಪ್ರಿಯ", "ಶುಭಪಂತುವರಾಳಿ", "ಷಡ್ವಿಧಮಾರ್ಗಿಣಿ", "ಸುವರ್ಣಾಂಗಿ", "ದಿವ್ಯಮಣಿ",
        "ಧವಳಾಂಬರಿ", "ನಾಮನಾರಾಯಣಿ", "ಕಾಮವರ್ಧಿನಿ", "ರಾಮಪ್ರಿಯ", "ಗಮನಾಶ್ರಮ", "ವಿಶ್ವಂಭರಿ",
        "ಶ್ಯಾಮಲಾಂಗಿ", "ಷಣ್ಮುಖಪ್ರಿಯ", "ಸಿಂಹೇಂದ್ರಮಧ್ಯಮಂ", "ಹೇಮವತಿ", "ಧರ್ಮವತಿ", "ನೀತಿಮತಿ",
        "ಕಾಂತಾಮಣಿ", "ಋಷಭಪ್ರಿಯ", "ಲತಾಂಗಿ", "ವಾಚಸ್ಪತಿ", "ಮೇಚಕಲ್ಯಾಣಿ", "ಚಿತ್ರಾಂಬರಿ",
        "ಸುಚರಿತ್ರ", "ಜ್ಯೋತಿಸ್ವರೂಪಿಣಿ", "ಧಾತುವರ್ಧನಿ", "ನಾಸಿಕಾಭೂಷಣಿ", "ಕೋಸಲಂ", "ರಸಿಕಪ್ರಿಯ",
    ]

    /// Los mismos nombres en tamil, que no se pueden pasar del devanagari: el tamil no tiene aspiradas ni sonoras y
    /// escribe los nombres de rāga a su manera (கரகரப்பிரியா, அரிக்காம்போதி, மாயாமாளவகௌளை). Son los títulos de la
    /// Wikipedia en tamil, cotejados letra a letra con el IAST de `nombresDeMelakarta`: los que no casan solo
    /// difieren en esas costumbres (la h que se vuelve க o se pierde, la -ai final, la i que separa grupos). El 8 es
    /// ஹனுமத்தோடி, porque la Wikipedia lo titula con su nombre corriente, தோடி.
    package static let nombresDeMelakartaEnTamil: [String] = [
        "கனகாங்கி", "ரத்னாங்கி", "கானமூர்த்தி", "வனஸ்பதி", "மானவதி", "தானரூபி",
        "சேனாவதி", "ஹனுமத்தோடி", "தேனுகா", "நாடகப்பிரியா", "கோகிலப்பிரியா", "ரூபவதி",
        "காயகப்பிரியா", "வகுளாபரணம்", "மாயாமாளவகௌளை", "சக்ரவாகம்", "சூர்யகாந்தம்", "ஹாடகாம்பரி",
        "ஜங்காரத்வனி", "நடபைரவி", "கீரவாணி", "கரகரப்பிரியா", "கௌரிமனோகரி", "வருணப்பிரியா",
        "மாரரஞ்சனி", "சாருகேசி", "சரசாங்கி", "அரிக்காம்போதி", "தீரசங்கராபரணம்", "நாகாநந்தினி",
        "யாகப்பிரியா", "ராகவர்த்தனி", "காங்கேயபூஷணி", "வாகதீச்வரி", "சூலினி", "சலநாட",
        "சாலகம்", "ஜலார்ணவம்", "ஜாலவராளி", "நவநீதம்", "பாவனி", "ரகுப்பிரியா",
        "கவாம்போதி", "பவப்பிரியா", "சுபபந்துவராளி", "ஷட்விதமார்க்கிணி", "சுவர்ணாங்கி", "திவ்யமணி",
        "தவளாம்பரி", "நாமநாராயணி", "காமவர்த்தனி", "ராமப்பிரியா", "கமனாச்ரம", "விஷ்வம்பரி",
        "சியாமளாங்கி", "சண்முகப்பிரியா", "சிம்மேந்திரமத்திமம்", "ஹேமவதி", "தர்மவதி", "நீதிமதி",
        "காந்தாமணி", "ரிஷபப்பிரியா", "லதாங்கி", "வாசஸ்பதி", "மேசகல்யாணி", "சித்ராம்பரி",
        "சுசரித்ர", "ஜோதிஸ்வரூபிணி", "தாதுவர்த்தனி", "நாசிகாபூஷணி", "கோசலம்", "ரசிகப்பிரியா",
    ]

    /// Los 72 mēḷa, en orden. Cada uno tiene Sa y Pa (unísono y 5ª justa), un Ma (4ª justa
    /// en los 36 primeros, aumentada en los 36 últimos) y una de las seis parejas Ri–Ga y Dha–Ni.
    /// Ri3 se escribe como 2ª aumentada, Ga1 como 3ª disminuida, Dha3 como 6ª aumentada y Ni1
    /// como 7ª disminuida, que es como los nombra la tradición.
    package static let melakartas: [TipoDeEscala] = {
        let riGa: [(Intervalo, Intervalo)] = [
            (.segundaMenor, .terceraDisminuida), (.segundaMenor, .terceraMenor), (.segundaMenor, .terceraMayor),
            (.segundaMayor, .terceraMenor), (.segundaMayor, .terceraMayor), (.segundaAumentada, .terceraMayor),
        ]
        let dhaNi: [(Intervalo, Intervalo)] = [
            (.sextaMenor, .septimaDisminuida), (.sextaMenor, .septimaMenor), (.sextaMenor, .septimaMayor),
            (.sextaMayor, .septimaMenor), (.sextaMayor, .septimaMayor), (.sextaAumentada, .septimaMayor),
        ]
        var tipos: [TipoDeEscala] = []
        for ma in [Intervalo.cuartaJusta, .cuartaAumentada] {
            for (ri, ga) in riGa {
                for (dha, ni) in dhaNi {
                    let numero = tipos.count + 1
                    let nombre = nombresDeMelakarta[numero - 1]
                    // Otra grafía solo si no es el nombre sin diacríticos (eso ya lo cubre `normalizar`).
                    let otraGrafia = nombresDeMelakartaSinDiacriticos[numero - 1]
                    tipos.append(
                        TipoDeEscala(
                            nombre: nombre,
                            intervalos: [.unisono, ri, ga, ma, .quintaJusta, dha, ni],
                            alias: ["melakarta \(numero)"]
                                + (normalizar(otraGrafia) == normalizar(nombre) ? [] : [otraGrafia]),
                            nombresOriginales: [
                                .init(nombresDeMelakartaEnDevanagari[numero - 1], .sanscrito),
                                .init(nombresDeMelakartaEnTelugu[numero - 1], .telugu),
                                .init(nombresDeMelakartaEnCanares[numero - 1], .canares),
                                .init(nombresDeMelakartaEnTamil[numero - 1], .tamil),
                            ],
                            categoria: .melakarta))
                }
            }
        }
        return tipos
    }()

    /// Mēḷa por su número (1…72): `TipoDeEscala.melakarta(15)` → Māyāmālavagauḷa.
    public static func melakarta(_ numero: Int) -> TipoDeEscala? {
        (1...72).contains(numero) ? melakartas[numero - 1] : nil
    }

    /// Número de mēḷa de una escala heptatónica con unísono y 5ª justa, una nota entre
    /// la 2ª menor y la 3ª mayor… según sus semitonos: la escala mayor es el 29
    /// (Dhīraśaṅkarābharaṇam) y la menor armónica, el 21 (Kīravāṇī). `nil` si no encaja.
    public var numeroDeMelakarta: Int? {
        let semitonos = Set(intervalos.map(\.semitonos))
        guard semitonos.count == 7, semitonos.contains(0), semitonos.contains(7) else { return nil }
        return TipoDeEscala.melakartas.firstIndex { Set($0.intervalos.map(\.semitonos)) == semitonos }
            .map { $0 + 1 }
    }

    /// Mēḷa de los que puede derivar la escala (los que contienen todas sus notas, al subir y
    /// al bajar), por número: Mohanam, sin 4ª ni 7ª, encaja en 28, 29, 64 y 65.
    /// Se compara la escritura y no solo los semitonos: la 6ª mayor (Dha2) no es la 7ª
    /// disminuida (Ni1), así que Mohanam no encaja en el 25.
    public var melakartasCompatibles: [Int] {
        let notas = Set(intervalosEnAmbasDirecciones.map(\.pasosDeQuinta))
        return TipoDeEscala.melakartas.indices.filter { i in
            notas.isSubset(of: Set(TipoDeEscala.melakartas[i].intervalos.map(\.pasosDeQuinta)))
        }.map { $0 + 1 }
    }

    // MARK: Janya (rāgas derivados, música carnática)

    // Algunos rāgas janya muy habituales, con su ārohaṇa (subida) y avarohaṇa (bajada). Se dejan
    // fuera los vakra (los que suben o bajan en zigzag), que no son escalas ordenadas.

    public static let mohanam = TipoDeEscala(
        nombre: "Mohanam", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        variantes: ["Mohana"],
        nombresOriginales: [.init("मोहनम्", .sanscrito), .init("మోహనం", .telugu), .init("ಮೋಹನಂ", .canares)],
        categoria: .janya, padre: .melakarta(28))
    public static let hindolam = TipoDeEscala(
        nombre: "Hindolam", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("हिन्दोलम्", .sanscrito), .init("హిందోలం", .telugu), .init("ಹಿಂದೋಲಂ", .canares)],
        categoria: .janya, padre: .melakarta(20))
    /// Sa ri ma Pa ni (Do Re♭ Fa Sol Si♭).
    public static let revati = TipoDeEscala(
        nombre: "Revati", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("रेवति", .sanscrito), .init("రేవతి", .telugu), .init("ರೇವತಿ", .canares)],
        categoria: .janya)
    /// Sa Ga Ma Pa Ni (Do Mi Fa♯ Sol Si): como la pentatónica lidia.
    public static let amrtavarsini = TipoDeEscala(
        nombre: "Amṛtavarṣiṇī", intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        variantes: ["Amritavarshini", "Amrutavarshini"],
        nombresOriginales: [.init("अमृतवर्षिणी", .sanscrito), .init("అమృతవర్షిణి", .telugu), .init("ಅಮೃತವರ್ಷಿಣಿ", .canares)],
        categoria: .janya, padre: .melakarta(65))
    public static let hamsadhvani = TipoDeEscala(
        nombre: "Haṃsadhvani", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .septimaMayor],
        variantes: ["Hamsadhwani"],
        nombresOriginales: [.init("हंसध्वनि", .sanscrito), .init("హంసధ్వని", .telugu), .init("ಹಂಸಧ್ವನಿ", .canares)],
        categoria: .janya, padre: .melakarta(29))
    public static let abhogi = TipoDeEscala(
        nombre: "Ābhogi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor],
        nombresOriginales: [.init("आभोगि", .sanscrito), .init("ఆభోగి", .telugu), .init("ಆಭೋಗಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    public static let madhyamavati = TipoDeEscala(
        nombre: "Madhyamāvatī", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("मध्यमावती", .sanscrito), .init("మధ్యమావతి", .telugu), .init("ಮಧ್ಯಮಾವತಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    public static let bilahari = TipoDeEscala(
        nombre: "Bilahari",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [.init("बिलहरि", .sanscrito), .init("బిలహరి", .telugu), .init("ಬಿಲಹರಿ", .canares)],
        categoria: .janya, padre: .melakarta(29))
    public static let kambhoji = TipoDeEscala(
        nombre: "Kāmbhoji",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Kambodhi"],
        nombresOriginales: [.init("काम्भोजि", .sanscrito), .init("కాంభోజి", .telugu), .init("ಕಾಂಭೋಜಿ", .canares)],
        categoria: .janya, padre: .melakarta(28))
    public static let arabhi = TipoDeEscala(
        nombre: "Ārabhi",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [.init("आरभि", .sanscrito), .init("ఆరభి", .telugu), .init("ಆರಭಿ", .canares)],
        categoria: .janya, padre: .melakarta(29))
    public static let kedaragaula = TipoDeEscala(
        nombre: "Kedāragauḷa",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Kedaragowla"],
        nombresOriginales: [.init("केदारगौळ", .sanscrito), .init("కేదారగౌళ", .telugu), .init("ಕೇದಾರಗೌಳ", .canares)],
        categoria: .janya, padre: .melakarta(28))
    /// Mohanakalyāṇi, del mēḷa 65 (Mecakalyāṇī): sube como Mohanam (Sa Ri₂ Ga₃ Pa Dha₂) y baja con las siete notas,
    /// con Ma₂ (Do Si La Sol Fa♯ Mi Re).
    public static let mohanakalyani = TipoDeEscala(
        nombre: "Mohanakalyāṇi",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [.init("मोहनकल्याणि", .sanscrito), .init("మోహనకల్యాణి", .telugu), .init("ಮೋಹನಕಲ್ಯಾಣಿ", .canares)],
        categoria: .janya, padre: .melakarta(65))
    /// Sāveri, del mēḷa 15 (Māyāmālavagauḷa): sube Sa Ri₁ Ma₁ Pa Dha₁ y baja con las siete notas (Do Si La♭ Sol Fa
    /// Mi Re♭).
    public static let saveri = TipoDeEscala(
        nombre: "Sāveri",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("सावेरि", .sanscrito), .init("సావేరి", .telugu), .init("ಸಾವೇರಿ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Nāṭa, del mēḷa 36 (Calanāṭa): sube Sa Ri₃ Ga₃ Ma₁ Pa Dha₃ Ni₃ (Do Re♯ Mi Fa Sol La♯ Si) y baja sin Ga ni Dha.
    public static let nata = TipoDeEscala(
        nombre: "Nāṭa",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaAumentada, .septimaMayor,
        ],
        intervalosDescendentes: [.unisono, .segundaAumentada, .cuartaJusta, .quintaJusta, .septimaMayor],
        variantes: ["Nattai"],
        nombresOriginales: [.init("नाट", .sanscrito), .init("నాట", .telugu), .init("ನಾಟ", .canares)],
        categoria: .janya, padre: .melakarta(36))

    /// Śuddha Sāveri, del mēḷa 29 (Dhīraśaṅkarābharaṇam): Sa Ri₂ Ma₁ Pa Dha₂ (Do Re Fa Sol La), la Durgā indostánica.
    public static let suddhaSaveri = TipoDeEscala(
        nombre: "Śuddha Sāveri", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Shuddha Saveri"],
        nombresOriginales: [.init("शुद्ध सावेरि", .sanscrito), .init("శుద్ధ సావేరి", .telugu), .init("ಶುದ್ಧ ಸಾವೇರಿ", .canares)],
        categoria: .janya, padre: .melakarta(29))
    /// Śuddha Dhanyāsi, del mēḷa 22 (Kharaharapriyā): Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭), la pentatónica menor.
    public static let suddhaDhanyasi = TipoDeEscala(
        nombre: "Śuddha Dhanyāsi", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Shuddha Dhanyasi"],
        nombresOriginales: [.init("शुद्ध धन्यासि", .sanscrito), .init("శుద్ధ ధన్యాసి", .telugu), .init("ಶುದ್ಧ ಧನ್ಯಾಸಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Śrīrañjani, del mēḷa 22 (Kharaharapriyā): Sa Ri₂ Ga₂ Ma₁ Dha₂ Ni₂ (Do Re Mi♭ Fa La Si♭), sin Pa.
    public static let sriranjani = TipoDeEscala(
        nombre: "Śrīrañjani",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Shriranjani"],
        nombresOriginales: [.init("श्रीरञ्जनि", .sanscrito), .init("శ్రీరంజని", .telugu), .init("ಶ್ರೀರಂಜನಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Mālayamārutam, del mēḷa 16 (Cakravākam): Sa Ri₁ Ga₃ Pa Dha₂ Ni₂ (Do Re♭ Mi Sol La Si♭), sin Ma.
    public static let malayamarutam = TipoDeEscala(
        nombre: "Mālayamārutam",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Malayamarutham"],
        nombresOriginales: [.init("मलयमारुतम्", .sanscrito), .init("మలయమారుతం", .telugu), .init("ಮಲಯಮಾರುತಂ", .canares)],
        categoria: .janya, padre: .melakarta(16))
    /// Gambhīranāṭa, del mēḷa 36 (Calanāṭa): Sa Ga₃ Ma₁ Pa Ni₃ (Do Mi Fa Sol Si).
    public static let gambhiranata = TipoDeEscala(
        nombre: "Gambhīranāṭa", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        variantes: ["Gambheera Nattai"],
        nombresOriginales: [.init("गम्भीरनाट", .sanscrito), .init("గంభీరనాట", .telugu), .init("ಗಂಭೀರನಾಟ", .canares)],
        categoria: .janya, padre: .melakarta(36))
    /// Haṃsanādam, del mēḷa 60 (Nītimati): Sa Ri₂ Ma₂ Pa Ni₃ (Do Re Fa♯ Sol Si).
    public static let hamsanadam = TipoDeEscala(
        nombre: "Haṃsanādam", intervalos: [.unisono, .segundaMayor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        nombresOriginales: [.init("हंसनादम्", .sanscrito), .init("హంసనాదం", .telugu), .init("ಹಂಸನಾದಂ", .canares)],
        categoria: .janya, padre: .melakarta(60))

    // Doce más, con el ārohaṇa, el avarohaṇa y el mēḷa de la Wikipedia en inglés (noviembre de 2026). Bauḷi va sin
    // `padre` porque su artículo no lo nombra.

    /// Haṃsānandi, del mēḷa 53 (Gamanaśrama): Sa Ri₁ Ga₃ Ma₂ Dha₂ Ni₃ (Do Re♭ Mi Fa♯ La Si), sin Pa.
    public static let hamsanandi = TipoDeEscala(
        nombre: "Haṃsānandi",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("हंसानन्दि", .sanscrito), .init("హంసానంది", .telugu), .init("ಹಂಸಾನಂದಿ", .canares)],
        categoria: .janya, padre: .melakarta(53))
    /// Kalyāṇavasantam, del mēḷa 21 (Kīravāṇī): sube Sa Ga₂ Ma₁ Dha₁ Ni₃ (Do Mi♭ Fa La♭ Si) y baja con las siete notas.
    public static let kalyanavasantam = TipoDeEscala(
        nombre: "Kalyāṇavasantam",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Kalyana Vasantham"],
        nombresOriginales: [
            .init("कल्याणवसन्तम्", .sanscrito), .init("కల్యాణవసంతం", .telugu), .init("ಕಲ್ಯಾಣವಸಂತಂ", .canares),
        ],
        categoria: .janya, padre: .melakarta(21))
    /// Bhūpālam, del mēḷa 45 (Śubhapantuvarāḷi): Sa Ri₁ Ga₂ Pa Dha₁ (Do Re♭ Mi♭ Sol La♭).
    public static let bhupalam = TipoDeEscala(
        nombre: "Bhūpālam", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        nombresOriginales: [.init("भूपालम्", .sanscrito), .init("భూపాలం", .telugu), .init("ಭೂಪಾಲಂ", .canares)],
        categoria: .janya, padre: .melakarta(45))
    /// Revagupti, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Pa Dha₁ (Do Re♭ Mi Sol La♭).
    public static let revagupti = TipoDeEscala(
        nombre: "Revagupti", intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor],
        nombresOriginales: [.init("रेवगुप्ति", .sanscrito), .init("రేవగుప్తి", .telugu), .init("ರೇವಗುಪ್ತಿ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Bauḷi: sube como Revagupti (Sa Ri₁ Ga₃ Pa Dha₁) y baja con Ni₃ (Do Si La♭ Sol Mi Re♭).
    public static let bauli = TipoDeEscala(
        nombre: "Bauḷi",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .quintaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Bowli"],
        nombresOriginales: [.init("बौळि", .sanscrito), .init("బౌళి", .telugu), .init("ಬೌಳಿ", .canares)],
        categoria: .janya)
    /// Lalitā, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Ma₁ Dha₁ Ni₃ (Do Re♭ Mi Fa La♭ Si), sin Pa.
    public static let lalita = TipoDeEscala(
        nombre: "Lalitā",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Lalitha"],
        nombresOriginales: [.init("ललिता", .sanscrito), .init("లలిత", .telugu), .init("ಲಲಿತ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Megharañjani, del mēḷa 15 (Māyāmālavagauḷa): Sa Ri₁ Ga₃ Ma₁ Ni₃ (Do Re♭ Mi Fa Si).
    public static let megharanjani = TipoDeEscala(
        nombre: "Megharañjani", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .septimaMayor],
        nombresOriginales: [.init("मेघरञ्जनि", .sanscrito), .init("మేఘరంజని", .telugu), .init("ಮೇಘರಂಜನಿ", .canares)],
        categoria: .janya, padre: .melakarta(15))
    /// Dhanyāsi, del mēḷa 8 (Hanumatoḍi): sube Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭) y baja con las siete notas. La
    /// escuela de Dīkṣitar la pone en el mēḷa 20, con Ri₂ al bajar.
    public static let dhanyasi = TipoDeEscala(
        nombre: "Dhanyāsi",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("धन्यासि", .sanscrito), .init("ధన్యాసి", .telugu), .init("ಧನ್ಯಾಸಿ", .canares)],
        categoria: .janya, padre: .melakarta(8))
    /// Ābheri, del mēḷa 22 (Kharaharapriyā): sube Sa Ga₂ Ma₁ Pa Ni₂ (Do Mi♭ Fa Sol Si♭) y baja con las siete notas.
    public static let abheri = TipoDeEscala(
        nombre: "Ābheri",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [.init("आभेरि", .sanscrito), .init("ఆభేరి", .telugu), .init("ಆಭೇರಿ", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Maṇiraṅgu, del mēḷa 22 (Kharaharapriyā): sube Sa Ri₂ Ma₁ Pa Ni₂ (Do Re Fa Sol Si♭) y baja con Ga₂.
    public static let manirangu = TipoDeEscala(
        nombre: "Maṇiraṅgu",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("मणिरङ्गु", .sanscrito), .init("మణిరంగు", .telugu), .init("ಮಣಿರಂಗು", .canares)],
        categoria: .janya, padre: .melakarta(22))
    /// Nāgasvarāvaḷi, del mēḷa 28 (Harikāmbhoji): Sa Ga₃ Ma₁ Pa Dha₂ (Do Mi Fa Sol La).
    public static let nagasvaravali = TipoDeEscala(
        nombre: "Nāgasvarāvaḷi", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Nagaswaravali"],
        nombresOriginales: [
            .init("नागस्वरावळि", .sanscrito), .init("నాగస్వరావళి", .telugu), .init("ನಾಗಸ್ವರಾವಳಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(28))
    /// Sunādavinodinī, del mēḷa 53 (Gamanaśrama): Sa Ga₃ Ma₂ Dha₂ Ni₃ (Do Mi Fa♯ La Si), como el Hindol indostánico.
    public static let sunadavinodini = TipoDeEscala(
        nombre: "Sunādavinodinī",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [
            .init("सुनादविनोदिनी", .sanscrito), .init("సునాదవినోదిని", .telugu), .init("ಸುನಾದವಿನೋದಿನಿ", .canares),
        ],
        categoria: .janya, padre: .melakarta(53))

    /// Rāgas janya incluidos.
    package static let janyas: [TipoDeEscala] = [
        .mohanam, .hindolam, .hamsadhvani, .abhogi, .madhyamavati, .bilahari, .kambhoji, .arabhi, .kedaragaula,
        .revati, .amrtavarsini, .mohanakalyani, .saveri, .nata, .suddhaSaveri, .suddhaDhanyasi, .sriranjani,
        .malayamarutam, .gambhiranata, .hamsanadam, .hamsanandi, .kalyanavasantam, .bhupalam, .revagupti, .bauli,
        .lalita, .megharanjani, .dhanyasi, .abheri, .manirangu, .nagasvaravali, .sunadavinodini,
    ]

    // MARK: Thāṭ (música indostánica)

    public static let bilaval = TipoDeEscala(
        nombre: "Bilāval",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], variantes: ["Bilawal"], nombresOriginales: [.init("बिलावल", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 20])])
    public static let kalyan = TipoDeEscala(
        nombre: "Kalyāṇ",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], nombresOriginales: [.init("कल्याण", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 11, 13, 16, 20])])
    public static let khamaj = TipoDeEscala(
        nombre: "Khamāj",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [.init("खमाज", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 18])])
    public static let kafi = TipoDeEscala(
        nombre: "Kāfī",
        intervalos: TipoDeEscala.dorico.intervalos,
        nombresOriginales: [.init("काफ़ी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    public static let asavari = TipoDeEscala(
        nombre: "Āsāvarī",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("आसावरी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 14, 18])])
    public static let bhairavi = TipoDeEscala(
        nombre: "Bhairavī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("भैरवी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 5, 9, 13, 14, 18])])
    public static let bhairav = TipoDeEscala(
        nombre: "Bhairav",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("भैरव", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 7, 9, 13, 14, 20])])
    public static let marva = TipoDeEscala(
        nombre: "Mārvā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], variantes: ["Marwa"], nombresOriginales: [.init("मारवा", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 13, 16, 20])])
    public static let purvi = TipoDeEscala(
        nombre: "Pūrvī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], variantes: ["Poorvi"], nombresOriginales: [.init("पूर्वी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 2, 7, 11, 13, 15, 20])])
    public static let todi = TipoDeEscala(
        nombre: "Toḍī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("तोडी", .hindi)],
        categoria: .thaat, afinaciones: [.init(.sruti, pasos: [0, 1, 5, 11, 13, 14, 21])])

    /// Los diez thāṭ de Bhatkhande.
    package static let thaats: [TipoDeEscala] = [
        .bilaval, .kalyan, .khamaj, .kafi, .asavari, .bhairavi, .bhairav, .marva, .purvi, .todi,
    ]

    // MARK: Rāgas indostánicos
    //
    // Algunos de los rāgas más tocados, con su āroh (subida) y avaroh (bajada) en la forma recta
    // que dan los libros de teoría (sin los giros vakra). Darbārī Kānaḍa, que es vakra de por sí, va con sus notas
    // rectas: su ga y su dha ati-komal, con andolan, y sus giros no caben en una escala.

    /// Bhūpālī: la pentatónica mayor (Sa Re Ga Pa Dha).
    public static let bhupali = TipoDeEscala(
        nombre: "Bhūpālī", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        variantes: ["Bhoopali", "Bhupal"], nombresOriginales: [.init("भूपाली", .hindi)],
        categoria: .raga, padre: .kalyan)
    /// Mālkauns (Sa ga ma dha ni): el Hindolam carnático.
    public static let malkauns = TipoDeEscala(
        nombre: "Mālkauns", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Malkosh"], nombresOriginales: [.init("मालकौंस", .hindi)],
        categoria: .raga, padre: .bhairavi)
    /// Durgā (Sa Re ma Pa Dha).
    public static let durga = TipoDeEscala(
        nombre: "Durgā", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        nombresOriginales: [.init("दुर्गा", .hindi)],
        categoria: .raga, padre: .bilaval)
    /// Yaman: el thāṭ Kalyāṇ entero, con la 4ª aumentada.
    public static let yaman = TipoDeEscala(
        nombre: "Yaman",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["Yaman Kalyāṇ"], variantes: ["Iman"], nombresOriginales: [.init("यमन", .hindi)],
        categoria: .raga, padre: .kalyan, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 11, 13, 16, 20])])
    /// Bāgeśrī: sube sin Re ni Pa y baja sin Pa.
    public static let bagesri = TipoDeEscala(
        nombre: "Bāgeśrī",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Bageshri", "Bageshree"], nombresOriginales: [.init("बागेश्री", .hindi)],
        categoria: .raga, padre: .kafi)
    /// Śivarañjanī (Sa Re ga Pa Dha).
    public static let sivaranjani = TipoDeEscala(
        nombre: "Śivarañjanī", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        variantes: ["Shivaranjani"], nombresOriginales: [.init("शिवरंजनी", .hindi)],
        categoria: .raga, padre: .kafi)
    /// Kalāvatī (Sa Ga Pa Dha ni), el Valaji carnático.
    public static let kalavati = TipoDeEscala(
        nombre: "Kalāvatī", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["Valaji"], nombresOriginales: [.init("कलावती", .hindi)],
        categoria: .raga, padre: .khamaj)
    /// Candrakauns (Sa ga ma dha Ni): el Mālkauns con Ni natural.
    public static let candrakauns = TipoDeEscala(
        nombre: "Candrakauns", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Chandrakauns", "Chandrakons"], nombresOriginales: [.init("चंद्रकौंस", .hindi)],
        categoria: .raga)
    /// Megh (Sa Re ma Pa ni): como la egipcia.
    public static let megh = TipoDeEscala(
        nombre: "Megh", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Megh Malhar"], nombresOriginales: [.init("मेघ", .hindi)],
        categoria: .raga, padre: .kafi)
    /// Deś: sube sin Ga ni Dha y con Ni natural; baja con ni komal.
    public static let des = TipoDeEscala(
        nombre: "Deś",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Desh"], nombresOriginales: [.init("देश", .hindi)],
        categoria: .raga, padre: .khamaj)
    /// Lalit (Sa re Ga ma Ma dha Ni, sin Pa): los dos Ma seguidos, el natural y el tīvra (Do Re♭ Mi Fa Fa♯ La♭ Si).
    public static let lalit = TipoDeEscala(
        nombre: "Lalit",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .cuartaAumentada, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("ललित", .hindi)],
        categoria: .raga)
    /// Bhīmpalāsī (thāṭ Kāfī): sube sin Re ni Dha (Sa ga ma Pa ni) y baja con todas (Sa Re ga ma Pa Dha ni).
    public static let bhimpalasi = TipoDeEscala(
        nombre: "Bhīmpalāsī",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        variantes: ["Bhimpalas", "Bheempalasi"], nombresOriginales: [.init("भीमपलासी", .hindi)],
        categoria: .raga, padre: .kafi)
    /// Bihāg (thāṭ Bilāval): sube sin Re ni Dha (Sa Ga ma Pa Ni) y baja con todas; el Ma tīvra solo aparece de
    /// paso (Pa Ma Ga ma Ga) y no entra en la escala.
    public static let bihag = TipoDeEscala(
        nombre: "Bihāg",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Behag"], nombresOriginales: [.init("बिहाग", .hindi)],
        categoria: .raga, padre: .bilaval)
    /// Darbārī Kānaḍa (thāṭ Āsāvarī: Sa Re ga ma Pa dha ni), en su forma recta: la menor natural, como Āsāvarī.
    public static let darbariKanada = TipoDeEscala(
        nombre: "Darbārī Kānaḍa",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Darbari"], variantes: ["Darbārī Kānaṛā", "Darbari Kanhra"],
        nombresOriginales: [.init("दरबारी कान्हड़ा", .hindi)],
        categoria: .raga, padre: .asavari)
    /// Pūriyā Dhanāśrī (thāṭ Pūrvī: Sa re Ga Ma Pa dha Ni, Do Re♭ Mi Fa♯ Sol La♭ Si).
    public static let puriyaDhanasri = TipoDeEscala(
        nombre: "Pūriyā Dhanāśrī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        variantes: ["Puriya Dhanashri", "Puriya Dhanashree"], nombresOriginales: [.init("पूरिया धनाश्री", .hindi)],
        categoria: .raga, padre: .purvi)

    // Cuatro más, con el āroh y el avaroh de la Wikipedia en inglés (noviembre de 2026), en su forma recta: dos con
    // ga komal, Ma tivra y Pa (Madhuvantī, con Re y Dha śuddha al bajar; Multānī, de Toḍī, con re y dha komal),
    // Hindol (Kalyāṇ sin Re ni Pa) y Sohinī (Mārvā sin Pa, que sube sin Re).

    /// Madhuvantī: sube Sa ga Ma Pa Ni y baja Sa Ni Dha Pa Ma ga Re. Sin `padre`: se suele poner en Toḍī, pero su Re y
    /// su Dha śuddha no están en ese thāṭ.
    public static let madhuvanti = TipoDeEscala(
        nombre: "Madhuvantī",
        intervalos: [.unisono, .terceraMenor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        nombresOriginales: [.init("मधुवंती", .hindi)],
        categoria: .raga)
    /// Multānī: sube Sa ga Ma Pa Ni y baja Sa Ni dha Pa Ma ga re.
    public static let multani = TipoDeEscala(
        nombre: "Multānī",
        intervalos: [.unisono, .terceraMenor, .cuartaAumentada, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("मुलतानी", .hindi)],
        categoria: .raga, padre: .todi)
    /// Hindol (Sa Ga Ma Dha Ni, con Ma tivra), en su forma recta; no es el Hindolam carnático, que es Mālkauns.
    public static let hindol = TipoDeEscala(
        nombre: "Hindol",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("हिंडोल", .hindi)],
        categoria: .raga, padre: .kalyan)
    /// Sohinī: sube Sa Ga Ma Dha Ni y baja Sa Ni Dha Ma Ga re, en su forma recta.
    public static let sohini = TipoDeEscala(
        nombre: "Sohinī",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        variantes: ["Sohni"], nombresOriginales: [.init("सोहनी", .hindi)],
        categoria: .raga, padre: .marva)

    // Ocho más, también de la Wikipedia en inglés (noviembre de 2026) y en su forma recta. Van sin `padre` los que
    // tienen notas que no están en el thāṭ que les da su artículo (Vṛndāvanī Sāraṅg y Ahir Bhairav) o cuyo artículo no
    // da thāṭ (Gujarī Toḍī y Jog).

    /// Jaunpurī (thāṭ Āsāvarī): sube sin ga (Sa Re ma Pa dha ni) y baja con todas.
    public static let jaunpuri = TipoDeEscala(
        nombre: "Jaunpurī",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        variantes: ["Jonpuri"], nombresOriginales: [.init("जौनपुरी", .hindi)],
        categoria: .raga, padre: .asavari)
    /// Miyāṅ kī Toḍī (thāṭ Toḍī): sube sin Pa (Sa re ga Ma dha Ni) y baja con él.
    public static let miyanKiTodi = TipoDeEscala(
        nombre: "Miyāṅ kī Toḍī",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        nombresOriginales: [.init("मियाँ की तोड़ी", .hindi)],
        categoria: .raga, padre: .todi)
    /// Gujarī Toḍī: Miyāṅ kī Toḍī sin Pa, ni al subir ni al bajar.
    public static let gujariTodi = TipoDeEscala(
        nombre: "Gujarī Toḍī",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaAumentada, .sextaMenor, .septimaMayor],
        nombresOriginales: [.init("गुजरी तोड़ी", .hindi)],
        categoria: .raga)
    /// Rāgeśrī (thāṭ Khamāj): sube sin Re ni Pa (Sa Ga ma Dha ni) y baja sin Pa.
    public static let rageshri = TipoDeEscala(
        nombre: "Rāgeśrī",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Rageshri", "Rageshree"], nombresOriginales: [.init("रागेश्री", .hindi)],
        categoria: .raga, padre: .khamaj)
    /// Vṛndāvanī Sāraṅg: sube con Ni (Sa Re ma Pa Ni) y baja con ni komal (Sa ni Pa ma Re), sin Ga ni Dha. Su artículo
    /// la pone en Kāfī, que no tiene Ni.
    public static let vrindavaniSarang = TipoDeEscala(
        nombre: "Vṛndāvanī Sāraṅg",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        intervalosDescendentes: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Brindabani Sarang", "Vrindavani Sarang"], nombresOriginales: [.init("वृन्दावनी सारंग", .hindi)],
        categoria: .raga)
    /// Jog: sube Sa Ga ma Pa ni y baja Sa ni Pa ma Ga ma ga, con las dos Ga; en la forma recta, Sa ni Pa ma Ga ga.
    public static let jog = TipoDeEscala(
        nombre: "Jog",
        intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        intervalosDescendentes: [.unisono, .terceraMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("जोग", .hindi)],
        categoria: .raga)
    /// Ahir Bhairav: Sa re Ga ma Pa Dha ni. Su artículo la pone en Bhairav, que tiene dha y Ni.
    public static let ahirBhairav = TipoDeEscala(
        nombre: "Ahir Bhairav",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        nombresOriginales: [.init("अहीर भैरव", .hindi)],
        categoria: .raga)
    /// Pūriyā (thāṭ Mārvā): Sa re Ga Ma Dha Ni, sin Pa, como Mārvā.
    public static let puriya = TipoDeEscala(
        nombre: "Pūriyā",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaAumentada, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("पूरिया", .hindi)],
        categoria: .raga, padre: .marva)

    /// Rāgas indostánicos incluidos.
    package static let ragasIndostanicos: [TipoDeEscala] = [
        .bhupali, .malkauns, .durga, .yaman, .bagesri, .des, .sivaranjani, .kalavati, .candrakauns, .megh, .lalit,
        .bhimpalasi, .bihag, .darbariKanada, .puriyaDhanasri, .madhuvanti, .multani, .hindol, .sohini, .jaunpuri,
        .miyanKiTodi,
        .gujariTodi, .rageshri, .vrindavaniSarang, .jog, .ahirBhairav, .puriya,
    ]

    // MARK: Grāma y mūrchanā (el Nāṭyaśāstra)
    //
    // Las escalas madre del Nāṭyaśāstra de Bharata (hacia el siglo II) y del Dattilam. El ṣaḍja-grāma reparte los 22
    // śruti de la octava entre sus siete notas (Sa 4, Ri 3, Ga 2, Ma 4, Pa 4, Dha 3, Ni 2, cada nota en el último
    // śruti de su intervalo) y el madhyama-grāma baja Pa un śruti (Pa 3, Dha 4). Cada grāma da siete mūrchanā, la
    // escala que empieza en cada una de sus notas, en el orden del texto: las del ṣaḍja-grāma bajan desde Sa
    // (Uttaramandrā) hasta Ri; las del madhyama-grāma, desde Ma (Sauvīrī) hasta Pa.
    //
    // Se escriben como el modelo de E. J. Arnold de los thāṭ, el que siguen los śruti de sus `afinaciones:`: el
    // ṣaḍja-grāma es Sa Ri(10/9) ga(32/27) ma(4/3) Pa(3/2) Dha(5/3) ni(16/9), las notas de Kāfī, y el madhyama-grāma
    // tiene Pa una coma sintónica más bajo (40/27). Cada mūrchanā lleva las razones de su grāma contadas desde su
    // primera nota. En doce notas son los siete modos diatónicos (el ṣaḍja-grāma es el dórico); su versión microtonal
    // va en los 22 śruti, salvo la de las que tienen una razón que no es uno de ellos (la quinta una coma corta de
    // 40/27 o la quinta disminuida de 64/45), que va en cents.

    /// El ṣaḍja-grāma, desde Sa: el dórico en doce notas.
    public static let sadjaGrama = TipoDeEscala(
        nombre: "ṣaḍja-grāma",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["shadja grama", "shadjagrama"], nombresOriginales: [.init("षड्जग्राम", .sanscrito)],
        categoria: .grama,
        // Grāma y mūrchanā del Nāṭyaśāstra, con las razones de los thāṭ: en śruti, por su número desde Sa, y en
        // cents las que tienen una quinta una coma corta (40/27) o la quinta disminuida de 64/45, que no son
        // ninguno de los 22.
        afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    /// El madhyama-grāma, desde Sa: el dórico en doce notas.
    public static let madhyamaGrama = TipoDeEscala(
        nombre: "madhyama-grāma",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["madhyamagrama"], nombresOriginales: [.init("मध्यमग्राम", .sanscrito)],
        categoria: .grama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 884, 996])])
    /// La mūrchanā del ṣaḍja-grāma desde Sa: el dórico en doce notas.
    public static let uttaramandra = TipoDeEscala(
        nombre: "Uttaramandrā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        nombresOriginales: [.init("उत्तरमन्द्रा", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 3, 5, 9, 13, 16, 18])])
    /// La mūrchanā del ṣaḍja-grāma desde Ni: la mayor en doce notas.
    public static let rajani = TipoDeEscala(
        nombre: "Rajanī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("रजनी", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 17, 20])])
    /// La mūrchanā del ṣaḍja-grāma desde Dha: el locrio en doce notas.
    public static let uttarayata = TipoDeEscala(
        nombre: "Uttarāyatā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("उत्तरायता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama,
        afinaciones: [.init(.razones, pasos: [0, 112, 316, 498, 610, 814, 1018])])
    /// La mūrchanā del ṣaḍja-grāma desde Pa: el eólico en doce notas.
    public static let suddhasadja = TipoDeEscala(
        nombre: "Śuddhaṣaḍjā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Shuddhashadja"], nombresOriginales: [.init("शुद्धषड्जा", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 792, 996])])
    /// La mūrchanā del ṣaḍja-grāma desde Ma: el mixolidio en doce notas.
    public static let matsarikrta = TipoDeEscala(
        nombre: "Matsarīkṛtā",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Matsarikrita"], nombresOriginales: [.init("मत्सरीकृता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 16, 18])])
    /// La mūrchanā del ṣaḍja-grāma desde Ga: el lidio en doce notas.
    public static let asvakranta = TipoDeEscala(
        nombre: "Aśvakrāntā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Ashvakranta"], nombresOriginales: [.init("अश्वक्रान्ता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 8, 11, 13, 17, 20])])
    /// La mūrchanā del ṣaḍja-grāma desde Ri: el frigio en doce notas.
    public static let abhirudgata = TipoDeEscala(
        nombre: "Abhirudgatā",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("अभिरुद्गता", .sanscrito)],
        categoria: .murchana, padre: .sadjaGrama, afinaciones: [.init(.sruti, pasos: [0, 2, 6, 10, 13, 15, 19])])
    /// La mūrchanā del madhyama-grāma desde Ma: el mixolidio en doce notas.
    public static let sauviri = TipoDeEscala(
        nombre: "Sauvīrī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        nombresOriginales: [.init("सौवीरी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 3, 7, 9, 13, 16, 18])])
    /// La mūrchanā del madhyama-grāma desde Ga: el lidio en doce notas.
    public static let harinasva = TipoDeEscala(
        nombre: "Hariṇāśvā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["Harinashva"], nombresOriginales: [.init("हरिणाश्वा", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 11, 13, 17, 20])])
    /// La mūrchanā del madhyama-grāma desde Ri: el frigio en doce notas.
    public static let kalopanata = TipoDeEscala(
        nombre: "Kalopanatā",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("कलोपनता", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 2, 6, 9, 13, 15, 19])])
    /// La mūrchanā del madhyama-grāma desde Sa: el dórico en doce notas.
    public static let suddhamadhya = TipoDeEscala(
        nombre: "Śuddhamadhyā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Shuddhamadhya"], nombresOriginales: [.init("शुद्धमध्या", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama,
        afinaciones: [.init(.razones, pasos: [0, 182, 294, 498, 680, 884, 996])])
    /// La mūrchanā del madhyama-grāma desde Ni: la mayor en doce notas.
    public static let margi = TipoDeEscala(
        nombre: "Mārgī",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        nombresOriginales: [.init("मार्गी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 7, 9, 13, 16, 20])])
    /// La mūrchanā del madhyama-grāma desde Dha: el locrio en doce notas.
    public static let pauravi = TipoDeEscala(
        nombre: "Pauravī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        nombresOriginales: [.init("पौरवी", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama,
        afinaciones: [.init(.razones, pasos: [0, 112, 316, 498, 610, 814, 996])])
    /// La mūrchanā del madhyama-grāma desde Pa: el eólico en doce notas.
    public static let hrsyaka = TipoDeEscala(
        nombre: "Hṛṣyakā",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Hrishyaka"], nombresOriginales: [.init("हृष्यका", .sanscrito)],
        categoria: .murchana, padre: .madhyamaGrama, afinaciones: [.init(.sruti, pasos: [0, 4, 6, 10, 13, 15, 19])])

    /// Los dos grāma.
    package static let gramas: [TipoDeEscala] = [.sadjaGrama, .madhyamaGrama]
    /// Las catorce mūrchanā, en el orden del Nāṭyaśāstra: las siete del ṣaḍja-grāma y las siete del madhyama-grāma.
    package static let murchanas: [TipoDeEscala] = [
        .uttaramandra, .rajani, .uttarayata, .suddhasadja, .matsarikrta, .asvakranta, .abhirudgata,
        .sauviri, .harinasva, .kalopanata, .suddhamadhya, .margi, .pauravi, .hrsyaka,
    ]
}
