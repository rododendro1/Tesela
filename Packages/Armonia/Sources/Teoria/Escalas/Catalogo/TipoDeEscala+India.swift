import Elementos

// MARK: - India
//
// Las versiones microtonales (`afinaciones:` en cada escala). Thāṭ y rāgas con thāṭ (los 22 śruti, por su número desde
// Sa: 0 = 1/1, 3 = 10/9, 7 = 5/4, 9 = 4/3, 13 = 3/2…). Los de grado natural siguen el ṣaḍja-grāma de Bharata, el modelo
// de E. J. Arnold: Kāfī es Sa Re(10/9) ga(32/27) ma Pa Dha(5/3) ni(16/9); Khamāj sube ga a Ga(5/4), Bilāval también ni
// a Ni(15/8) y Kalyāṇ, ma a Ma(45/32). Los rāgas con ati-komal (Bhairav, Bhairavī, Toḍī) llevan el re y el dha
// pitagóricos (256/243, 128/81); Toḍī, como lo miden Bel y otros (Ga 32/27, Ma 45/32, Ni 243/128); Mārvā y Pūrvī, el re
// de 16/15. Cada rāga con `padre` lleva los śruti de su thāṭ, nota a nota, como Yaman los de Kalyāṇ; Deś, que sube con
// el Ni de Bilāval y baja con el ni de Khamāj, lleva el Ni de Bilāval (15/8), y Darbārī Kānaḍa, los de Āsāvarī, sin su
// ga y su dha ati-komal. Los janya no tienen: el modelo de Arnold es el de los thāṭ, y cada svara carnático puede ir en
// dos śruti según el rāga, sin una fuente que diga cuál.

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

    /// Las notas que no son de su padre (los anya svara de un rāga bhāṣāṅga), de grave a agudo. Unas están en sus
    /// formas, como el Dha₁ con que baja Mukhāri sobre Kharaharapriyā; otras solo salen en algunas frases, como el Ga₃,
    /// el Dha₁ y el Ni₃ de Ānandabhairavi. En un rāga indostánico, las que no son de su thāṭ: el Ni natural con que
    /// sube Deś, que Khamāj no tiene. No cuentan para `melakartasCompatibles` ni para `==`, y no van en el JSON:
    /// son del catálogo, como `padre`. Vacía en las demás escalas.
    ///
    ///     TipoDeEscala.mukhari.notasExternas    // [.sextaMenor]
    public var notasExternas: [Intervalo] { datosDelCatalogo.notasExternas }

    /// Mēḷa de los que puede derivar la escala (los que contienen todas sus notas, al subir y
    /// al bajar, menos las externas: `notasExternas`), por número: Mohanam, sin 4ª ni 7ª, encaja en 28, 29, 64 y 65,
    /// y Mukhāri, sin su Dha₁, solo en el 22. Se compara la escritura y no solo los semitonos: la 6ª mayor (Dha2)
    /// no es la 7ª disminuida (Ni1), así que Mohanam no encaja en el 25.
    public var melakartasCompatibles: [Int] {
        let notas = Set(intervalosEnAmbasDirecciones.filter { !notasExternas.contains($0) }.map(\.pasosDeQuinta))
        return TipoDeEscala.melakartas.indices.filter { i in
            notas.isSubset(of: Set(TipoDeEscala.melakartas[i].intervalos.map(\.pasosDeQuinta)))
        }.map { $0 + 1 }
    }
}
