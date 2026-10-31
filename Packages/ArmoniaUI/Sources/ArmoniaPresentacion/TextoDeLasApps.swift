import Armonia

/// Los textos de la interfaz de las apps (pestañas, secciones, etiquetas, indicaciones), en los catorce idiomas de
/// los textos del motor.
///
/// Siguen el idioma de los textos de la notación elegida, igual que los nombres de acordes, escalas y avisos,
/// así que el selector de notación cambia la app entera. Cada caso da su `Traduccion`, que pide los catorce
/// idiomas: uno nuevo no compila hasta que los tiene. Los ejemplos de las indicaciones («Cifrado, por ejemplo
/// Sol7/Si») se escriben en la notación elegida («G7/B»).
///
///     Notacion.inglesASCII.texto(.digitaciones)    // "Fingerings"
public enum TextoDeLasApps: Hashable, Sendable {
    // Pestañas y títulos
    case acordes
    case escalas
    case analisis
    case coral

    // Acordes
    case acorde
    case campoDeCifrado
    case informacion
    case nombre
    case cifrado
    case notas
    case digitaciones
    case instrumentoYAfinacion
    case sinDigitaciones
    case calculando
    /// «3 dedos», o «4 dedos, cejilla en el traste 1».
    case dedos(Int, cejilla: Int?)
    case arpegio
    case patron
    case escalasCompatibles
    case arpegioEnElMastil
    /// «Trastes 5–8»: la franja de una posición del mástil.
    case trastes(desde: Int, hasta: Int)

    // Identificar un acorde tocando sus notas
    case identificar
    case tocaElMastil
    case tocaNotas
    case borrar
    case sinAcordeConocido
    case verEnAcordes
    case tecladoMIDI
    case dispositivosMIDI
    case teoriaPostonal
    case formaPrima
    case numeroDeForte
    case vectorIntervalico

    // Escalas
    case escala
    case tonica
    case tipo
    case habituales
    case otrasTradiciones
    case acordesDeLaEscala
    case mastilDeGuitarra
    case posicionesEnElMastil
    /// «3 notas por cuerda».
    case notasPorCuerda(Int)
    /// «Forma E», de las del sistema CAGED.
    case forma(String)
    case pentagrama

    // Análisis
    case progresion
    case campoDeProgresion
    case resultado
    case acordeAAcorde
    case cadencias
    /// La progresión arpegiada.
    case arpegiar

    // Coral
    case tarea
    case campoDeTonalidad
    case tonalidad
    case armonizaciones
    case aCuatroVoces
    case conduccionDeLasVoces
    case avisos

    // Tonnetz
    case recorridoPLR
    case modo
    case red
    /// El campo del teclado UIL, el giro de 30° en 30° y el espejo.
    case formatoUIL
    case giro
    case espejo
    case noSeDibuja
    case campoDeTriadaInicial
    case reiniciar
    case deshacer
    case campoDeAcorde
    case campoDeEscala

    // Comunes
    case textos
    case comoLasNotas
    case exportar
    /// Abrir un fichero MIDI o MusicXML (en la pestaña de análisis).
    case abrir
    case escuchar
    /// El temperamento con que suena «Escuchar».
    case afinacionAlEscuchar

    // Accesibilidad (lo que lee VoiceOver)
    case rejillaHexagonal
    /// «19 casillas».
    case casillas(Int)
    /// «elegida q 2, r -1».
    case casillaElegida(q: Int, r: Int)
    /// «Mástil de guitarra, trastes 0 a 5», con el nombre del instrumento de `Encordado.nombre(en:)`.
    case mastilDe(String, desde: Int, hasta: Int)
    /// «cuerda 1, traste 0», con las cuerdas contadas desde 1.
    case posicion(cuerda: Int, traste: Int)
    /// «13 marcas».
    case marcas(Int)
    /// «cuerdas apagadas: 1, 6».
    case cuerdasApagadas(String)
    case sinMarcas

    public func texto(en notacion: Notacion) -> String {
        traduccion(notacion).en(notacion)
    }

    func traduccion(_ notacion: Notacion) -> Traduccion {
        switch self {
        case .acordes:
            return Traduccion(
                "Acordes", "Chords", ca: "Acords", gl: "Acordes", ast: "Acordes",
                an: "Acordes", eu: "Akordeak", pt: "Acordes",
                fr: "Accords", oc: "Acòrds", it: "Accordi", de: "Akkorde",
                el: "Συγχορδίες", ru: "Аккорды")
        case .escalas:
            return Traduccion(
                "Escalas", "Scales", ca: "Escales", gl: "Escalas", ast: "Escales",
                an: "Escalas", eu: "Eskalak", pt: "Escalas",
                fr: "Gammes", oc: "Gamas", it: "Scale", de: "Skalen",
                el: "Κλίμακες", ru: "Гаммы")
        case .analisis:
            return Traduccion(
                "Análisis", "Analysis", ca: "Anàlisi", gl: "Análise", ast: "Análisis",
                an: "Analisi", eu: "Analisia", pt: "Análise",
                fr: "Analyse", oc: "Analisi", it: "Analisi", de: "Analyse",
                el: "Ανάλυση", ru: "Анализ")
        case .coral:
            return Traduccion(
                "Coral", "Chorale", ca: "Coral", gl: "Coral", ast: "Coral",
                an: "Coral", eu: "Korala", pt: "Coral",
                fr: "Choral", oc: "Coral", it: "Corale", de: "Choral",
                el: "Χορικό", ru: "Хорал")
        case .acorde:
            return Traduccion(
                "Acorde", "Chord", ca: "Acord", gl: "Acorde", ast: "Acorde",
                an: "Acorde", eu: "Akordea", pt: "Acorde",
                fr: "Accord", oc: "Acòrd", it: "Accordo", de: "Akkord",
                el: "Συγχορδία", ru: "Аккорд")
        case .campoDeCifrado:
            let ejemplo = Self.cifrado("Sol7/Si", notacion)
            return Traduccion(
                "Cifrado, por ejemplo \(ejemplo)", "Chord symbol, for example \(ejemplo)",
                ca: "Xifratge, per exemple \(ejemplo)", gl: "Cifrado, por exemplo \(ejemplo)",
                ast: "Cifráu, por exemplu \(ejemplo)", an: "Cifrau, per eixemplo \(ejemplo)",
                eu: "Zifratua, adibidez \(ejemplo)", pt: "Cifra, por exemplo \(ejemplo)",
                fr: "Chiffrage, par exemple \(ejemplo)", oc: "Chifratge, per exemple \(ejemplo)",
                it: "Sigla, per esempio \(ejemplo)", de: "Akkordsymbol, zum Beispiel \(ejemplo)",
                el: "Σύμβολο, για παράδειγμα \(ejemplo)", ru: "Обозначение, например \(ejemplo)")
        case .informacion:
            return Traduccion(
                "Información", "Information", ca: "Informació", gl: "Información", ast: "Información",
                an: "Información", eu: "Informazioa", pt: "Informação",
                fr: "Informations", oc: "Informacion", it: "Informazioni", de: "Informationen",
                el: "Πληροφορίες", ru: "Сведения")
        case .nombre:
            return Traduccion(
                "Nombre", "Name", ca: "Nom", gl: "Nome", ast: "Nome",
                an: "Nombre", eu: "Izena", pt: "Nome", fr: "Nom", oc: "Nom", it: "Nome", de: "Name",
                el: "Όνομα", ru: "Название")
        case .cifrado:
            return Traduccion(
                "Cifrado", "Symbol", ca: "Xifratge", gl: "Cifrado", ast: "Cifráu",
                an: "Cifrau", eu: "Zifratua", pt: "Cifra",
                fr: "Chiffrage", oc: "Chifratge", it: "Sigla", de: "Symbol",
                el: "Σύμβολο", ru: "Обозначение")
        case .notas:
            return Traduccion(
                "Notas", "Notes", ca: "Notes", gl: "Notas", ast: "Notes",
                an: "Notas", eu: "Notak", pt: "Notas", fr: "Notes", oc: "Nòtas", it: "Note", de: "Noten",
                el: "Νότες", ru: "Ноты")
        case .digitaciones:
            return Traduccion(
                "Digitaciones", "Fingerings", ca: "Digitacions", gl: "Dixitacións", ast: "Digitaciones",
                an: "Digitacions", eu: "Hatz-jarrerak", pt: "Dedilhações",
                fr: "Doigtés", oc: "Digitacions", it: "Diteggiature", de: "Griffe",
                el: "Δακτυλοθεσίες", ru: "Аппликатуры")
        case .arpegio:
            return Traduccion(
                "Arpegio", "Arpeggio", ca: "Arpegi", gl: "Arpexo", ast: "Arpexu",
                an: "Arpechio", eu: "Arpegioa", pt: "Arpejo",
                fr: "Arpège", oc: "Arpegi", it: "Arpeggio", de: "Akkordbrechung",
                el: "Αρπέζ", ru: "Арпеджио")
        case .patron:
            return Traduccion(
                "Patrón", "Pattern", ca: "Patró", gl: "Padrón", ast: "Patrón",
                an: "Patrón", eu: "Eredua", pt: "Padrão",
                fr: "Motif", oc: "Motiu", it: "Schema", de: "Muster",
                el: "Μοτίβο", ru: "Рисунок")
        case .arpegioEnElMastil:
            return Traduccion(
                "Arpegio en el mástil", "Arpeggio on the fretboard", ca: "Arpegi al mànec",
                gl: "Arpexo no mástil", ast: "Arpexu nel mástil", an: "Arpechio en o mástil",
                eu: "Arpegioa mastilean", pt: "Arpejo no braço",
                fr: "Arpège sur le manche", oc: "Arpegi sul margue", it: "Arpeggio sul manico",
                de: "Akkordbrechung auf dem Griffbrett",
                el: "Αρπέζ στην ταστιέρα", ru: "Арпеджио на грифе")
        case .trastes(let desde, let hasta):
            return Traduccion(
                "Trastes \(desde)–\(hasta)", "Frets \(desde)–\(hasta)", ca: "Trasts \(desde)–\(hasta)",
                gl: "Trastes \(desde)–\(hasta)", ast: "Trastes \(desde)–\(hasta)",
                an: "Trastes \(desde)–\(hasta)", eu: "\(desde)–\(hasta) trasteak",
                pt: "Trastes \(desde)–\(hasta)", fr: "Cases \(desde)–\(hasta)",
                oc: "Trasts \(desde)–\(hasta)", it: "Tasti \(desde)–\(hasta)",
                de: "Bünde \(desde)–\(hasta)", el: "Τάστα \(desde)–\(hasta)",
                ru: "Лады \(desde)–\(hasta)")
        case .escalasCompatibles:
            return Traduccion(
                "Escalas compatibles", "Compatible scales", ca: "Escales compatibles",
                gl: "Escalas compatibles", ast: "Escales compatibles", an: "Escalas compatibles",
                eu: "Eskala bateragarriak", pt: "Escalas compatíveis",
                fr: "Gammes compatibles", oc: "Gamas compatiblas", it: "Scale compatibili",
                de: "Passende Skalen", el: "Συμβατές κλίμακες", ru: "Подходящие гаммы")
        case .identificar:
            return Traduccion(
                "Identificar", "Identify", ca: "Identifica", gl: "Identificar", ast: "Identificar",
                an: "Identificar", eu: "Identifikatu", pt: "Identificar",
                fr: "Identifier", oc: "Identificar", it: "Riconosci", de: "Erkennen",
                el: "Αναγνώριση", ru: "Распознать")
        case .tocaElMastil:
            return Traduccion(
                "Toca el mástil para saber qué acorde forman las notas.",
                "Tap the fretboard to find out which chord the notes make.",
                ca: "Toca el mànec per saber quin acord formen les notes.",
                gl: "Toca o mástil para saber que acorde forman as notas.",
                ast: "Toca\'l mástil pa saber qué acorde formen les notes.",
                an: "Toca o mástil ta saber qué acorde forman as notas.",
                eu: "Ukitu mastila notek zer akorde osatzen duten jakiteko.",
                pt: "Toca no braço para saber que acorde formam as notas.",
                fr: "Touchez le manche pour savoir quel accord forment les notes.",
                oc: "Tòca lo margue per saber quin acòrd fan las nòtas.",
                it: "Tocca il manico per sapere quale accordo formano le note.",
                de: "Tippe auf das Griffbrett, um zu sehen, welchen Akkord die Töne bilden.",
                el: "Άγγιξε την ταστιέρα για να δεις ποια συγχορδία σχηματίζουν οι νότες.",
                ru: "Нажимай на гриф, чтобы узнать, какой аккорд образуют ноты.")
        case .tocaNotas:
            return Traduccion(
                "Toca notas para saber qué acorde forman; la primera es el bajo.",
                "Tap notes to find out which chord they make; the first one is the bass.",
                ca: "Toca notes per saber quin acord formen; la primera és el baix.",
                gl: "Toca notas para saber que acorde forman; a primeira é o baixo.",
                ast: "Toca notes pa saber qué acorde formen; la primera ye\'l baxu.",
                an: "Toca notas ta saber qué acorde forman; a primera ye o baixo.",
                eu: "Ukitu notak zer akorde osatzen duten jakiteko; lehena da baxua.",
                pt: "Toca notas para saber que acorde formam; a primeira é o baixo.",
                fr: "Touchez des notes pour savoir quel accord elles forment ; la première est la basse.",
                oc: "Tòca de nòtas per saber quin acòrd fan; la primièra es la bassa.",
                it: "Tocca delle note per sapere quale accordo formano; la prima è il basso.",
                de: "Tippe auf Töne, um zu sehen, welchen Akkord sie bilden; der erste ist der Bass.",
                el: "Άγγιξε νότες για να δεις ποια συγχορδία σχηματίζουν· η πρώτη είναι το μπάσο.",
                ru: "Нажимай на ноты, чтобы узнать, какой аккорд они образуют; первая — бас.")
        case .borrar:
            return Traduccion(
                "Borrar", "Clear", ca: "Esborra", gl: "Borrar", ast: "Borrar",
                an: "Borrar", eu: "Garbitu", pt: "Limpar",
                fr: "Effacer", oc: "Escafar", it: "Cancella", de: "Löschen",
                el: "Καθαρισμός", ru: "Очистить")
        case .sinAcordeConocido:
            return Traduccion(
                "No forman ningún acorde conocido.", "No chord found.",
                ca: "No formen cap acord conegut.", gl: "Non forman ningún acorde coñecido.",
                ast: "Nun formen nengún acorde conocíu.", an: "No forman garra acorde conoixiu.",
                eu: "Ez dute akorde ezagunik osatzen.", pt: "Não formam nenhum acorde conhecido.",
                fr: "Aucun accord connu.", oc: "Fan pas cap d'acòrd conegut.",
                it: "Non formano nessun accordo conosciuto.", de: "Kein bekannter Akkord.",
                el: "Δεν σχηματίζουν καμία γνωστή συγχορδία.", ru: "Известный аккорд не найден.")
        case .verEnAcordes:
            return Traduccion(
                "Ver en Acordes", "Show in Chords", ca: "Mostra a Acords", gl: "Ver en Acordes",
                ast: "Ver n\'Acordes", an: "Veyer en Acordes", eu: "Ikusi Akordeetan",
                pt: "Ver em Acordes", fr: "Voir dans Accords", oc: "Veire dins Acòrds",
                it: "Mostra in Accordi", de: "In Akkorden zeigen",
                el: "Προβολή στις Συγχορδίες", ru: "Показать в аккордах")
        case .tecladoMIDI:
            return Traduccion(
                "Teclado MIDI", "MIDI keyboard", ca: "Teclat MIDI", gl: "Teclado MIDI",
                ast: "Tecláu MIDI", an: "Teclau MIDI", eu: "MIDI teklatua", pt: "Teclado MIDI",
                fr: "Clavier MIDI", oc: "Clavièr MIDI", it: "Tastiera MIDI", de: "MIDI-Keyboard",
                el: "Πληκτρολόγιο MIDI", ru: "MIDI-клавиатура")
        case .dispositivosMIDI:
            return Traduccion(
                "Dispositivos conectados", "Connected devices", ca: "Dispositius connectats",
                gl: "Dispositivos conectados", ast: "Preseos coneutaos", an: "Dispositivos connectaus",
                eu: "Konektatutako gailuak", pt: "Dispositivos ligados",
                fr: "Appareils connectés", oc: "Aparelhs connectats", it: "Dispositivi collegati",
                de: "Verbundene Geräte", el: "Συνδεδεμένες συσκευές", ru: "Подключённые устройства")
        case .teoriaPostonal:
            return Traduccion(
                "Teoría postonal", "Post-tonal theory", ca: "Teoria postonal", gl: "Teoría postonal",
                ast: "Teoría postonal", an: "Teoría postonal", eu: "Teoria postonala",
                pt: "Teoria pós-tonal", fr: "Théorie post-tonale", oc: "Teoria postonala",
                it: "Teoria post-tonale", de: "Posttonale Theorie",
                el: "Μετατονική θεωρία", ru: "Посттональная теория")
        case .formaPrima:
            return Traduccion(
                "Forma prima", "Prime form", ca: "Forma primera", gl: "Forma prima",
                ast: "Forma prima", an: "Forma prima", eu: "Lehen forma", pt: "Forma prima",
                fr: "Forme primaire", oc: "Fòrma primièra", it: "Forma primaria",
                de: "Primform", el: "Πρωταρχική μορφή", ru: "Первичная форма")
        case .numeroDeForte:
            return Traduccion(
                "Número de Forte", "Forte number", ca: "Nombre de Forte", gl: "Número de Forte",
                ast: "Númberu de Forte", an: "Numero de Forte", eu: "Forteren zenbakia",
                pt: "Número de Forte", fr: "Numéro de Forte", oc: "Numèro de Forte",
                it: "Numero di Forte", de: "Forte-Nummer", el: "Αριθμός Forte", ru: "Номер по Форту")
        case .vectorIntervalico:
            return Traduccion(
                "Vector interválico", "Interval vector", ca: "Vector interval·lic",
                gl: "Vector interválico", ast: "Vector interválicu", an: "Vector interválico",
                eu: "Tarte-bektorea", pt: "Vetor intervalar", fr: "Vecteur d\'intervalles",
                oc: "Vector d\'intervals", it: "Vettore intervallare", de: "Intervallvektor",
                el: "Διάνυσμα διαστημάτων", ru: "Интервальный вектор")
        case .instrumentoYAfinacion:
            return Traduccion(
                "Instrumento y afinación", "Instrument and tuning", ca: "Instrument i afinació",
                gl: "Instrumento e afinación", ast: "Instrumentu y afinación",
                an: "Instrumento y afinación", eu: "Instrumentua eta afinazioa", pt: "Instrumento e afinação",
                fr: "Instrument et accord", oc: "Instrument e acordatge", it: "Strumento e accordatura",
                de: "Instrument und Stimmung",
                el: "Όργανο και κούρδισμα", ru: "Инструмент и строй")
        case .sinDigitaciones:
            return Traduccion(
                "No hay digitaciones cómodas para este acorde en este instrumento.",
                "There are no comfortable fingerings for this chord on this instrument.",
                ca: "No hi ha digitacions còmodes per a aquest acord en aquest instrument.",
                gl: "Non hai dixitacións cómodas para este acorde neste instrumento.",
                ast: "Nun hai digitaciones cómodes pa esti acorde nesti instrumentu.",
                an: "No bi ha digitacions cómodas ta este acorde en este instrumento.",
                eu: "Ez dago akorde honetarako hatz-jarrera erosorik instrumentu honetan.",
                pt: "Não há dedilhações confortáveis para este acorde neste instrumento.",
                fr: "Aucun doigté confortable pour cet accord sur cet instrument.",
                oc: "I a pas de digitacion comòda per aqueste acòrd sus aqueste instrument.",
                it: "Nessuna diteggiatura comoda per questo accordo su questo strumento.",
                de: "Für diesen Akkord gibt es auf diesem Instrument keine bequemen Griffe.",
                el: "Δεν υπάρχουν άνετες δακτυλοθεσίες για αυτή τη συγχορδία σε αυτό το όργανο.",
                ru: "Для этого аккорда на этом инструменте нет удобных аппликатур.")
        case .calculando:
            return Traduccion(
                "Calculando…", "Calculating…", ca: "Calculant…", gl: "Calculando…", ast: "Calculando…",
                an: "Calculando…", eu: "Kalkulatzen…", pt: "A calcular…",
                fr: "Calcul en cours…", oc: "Calcul en cors…", it: "Calcolo in corso…", de: "Wird berechnet…",
                el: "Υπολογισμός…", ru: "Вычисление…")
        case .dedos(let n, let cejilla):
            let dedos = Traduccion(
                n == 1 ? "1 dedo" : "\(n) dedos", n == 1 ? "1 finger" : "\(n) fingers",
                ca: n == 1 ? "1 dit" : "\(n) dits", gl: n == 1 ? "1 dedo" : "\(n) dedos",
                ast: n == 1 ? "1 deu" : "\(n) deos", an: n == 1 ? "1 dido" : "\(n) didos",
                eu: "\(n) hatz", pt: n == 1 ? "1 dedo" : "\(n) dedos",
                fr: n == 1 ? "1 doigt" : "\(n) doigts", oc: n == 1 ? "1 det" : "\(n) dets",
                it: n == 1 ? "1 dito" : "\(n) dita",
                de: n == 1 ? "1 Finger" : "\(n) Finger",
                el: n == 1 ? "1 δάχτυλο" : "\(n) δάχτυλα", ru: Traduccion.pluralRuso(n, "палец", "пальца", "пальцев"))
            guard let t = cejilla else { return dedos }
            return Traduccion(
                "\(dedos.espanol), cejilla en el traste \(t)", "\(dedos.ingles), barre at fret \(t)",
                ca: "\(dedos.catalan), celleta al trast \(t)", gl: "\(dedos.gallego), pestana no traste \(t)",
                ast: "\(dedos.asturiano), ceya nel traste \(t)", an: "\(dedos.aragones), ceja en o traste \(t)",
                eu: "\(dedos.euskera), zeja \(t). trastean", pt: "\(dedos.portugues), pestana no traste \(t)",
                fr: "\(dedos.frances), barré à la case \(t)", oc: "\(dedos.occitano), barrat al trast \(t)",
                it: "\(dedos.italiano), barré al tasto \(t)", de: "\(dedos.aleman), Barré im \(t). Bund",
                el: "\(dedos.griego), μπαρέ στο τάστο \(t)", ru: "\(dedos.ruso), барре на \(t)-м ладу")
        case .escala:
            return Traduccion(
                "Escala", "Scale", ca: "Escala", gl: "Escala", ast: "Escala",
                an: "Escala", eu: "Eskala", pt: "Escala",
                fr: "Gamme", oc: "Gama", it: "Scala", de: "Skala",
                el: "Κλίμακα", ru: "Гамма")
        case .tonica:
            return Traduccion(
                "Tónica", "Tonic", ca: "Tònica", gl: "Tónica", ast: "Tónica",
                an: "Tónica", eu: "Tonika", pt: "Tónica",
                fr: "Tonique", oc: "Tonica", it: "Tonica", de: "Grundton",
                el: "Τονική", ru: "Тоника")
        case .tipo:
            return Traduccion(
                "Tipo", "Type", ca: "Tipus", gl: "Tipo", ast: "Tipu",
                an: "Tipo", eu: "Mota", pt: "Tipo", fr: "Type", oc: "Tipe", it: "Tipo", de: "Art",
                el: "Είδος", ru: "Тип")
        case .habituales:
            return Traduccion(
                "Habituales", "Common", ca: "Habituals", gl: "Habituais", ast: "Habituales",
                an: "Habituals", eu: "Ohikoak", pt: "Habituais",
                fr: "Courantes", oc: "Abitualas", it: "Comuni", de: "Gebräuchliche",
                el: "Συνήθεις", ru: "Обычные")
        case .otrasTradiciones:
            return Traduccion(
                "Otras tradiciones", "Other traditions", ca: "Altres tradicions", gl: "Outras tradicións",
                ast: "Otres tradiciones", an: "Atras tradicions", eu: "Beste tradizio batzuk",
                pt: "Outras tradições",
                fr: "Autres traditions", oc: "Autras tradicions", it: "Altre tradizioni",
                de: "Andere Traditionen",
                el: "Άλλες παραδόσεις", ru: "Другие традиции")
        case .acordesDeLaEscala:
            return Traduccion(
                "Acordes de la escala", "Chords of the scale", ca: "Acords de l'escala",
                gl: "Acordes da escala", ast: "Acordes de la escala", an: "Acordes d\'a escala",
                eu: "Eskalaren akordeak", pt: "Acordes da escala",
                fr: "Accords de la gamme", oc: "Acòrds de la gama", it: "Accordi della scala",
                de: "Akkorde der Skala",
                el: "Συγχορδίες της κλίμακας", ru: "Аккорды гаммы")
        case .posicionesEnElMastil:
            return Traduccion(
                "Posiciones en el mástil", "Positions on the fretboard", ca: "Posicions al mànec",
                gl: "Posicións no mástil", ast: "Posiciones nel mástil", an: "Posicions en o mástil",
                eu: "Posizioak mastilean", pt: "Posições no braço", fr: "Positions sur le manche",
                oc: "Posicions sul margue", it: "Posizioni sul manico", de: "Lagen auf dem Griffbrett",
                el: "Θέσεις στην ταστιέρα", ru: "Позиции на грифе")
        case .notasPorCuerda(let n):
            let una = n == 1
            return Traduccion(
                "\(n) \(una ? "nota" : "notas") por cuerda", "\(n) \(una ? "note" : "notes") per string",
                ca: "\(n) \(una ? "nota" : "notes") per corda", gl: "\(n) \(una ? "nota" : "notas") por corda",
                ast: "\(n) \(una ? "nota" : "notes") per cuerda", an: "\(n) \(una ? "nota" : "notas") por corda",
                eu: "\(n) nota soka bakoitzeko", pt: "\(n) \(una ? "nota" : "notas") por corda",
                fr: "\(n) \(una ? "note" : "notes") par corde", oc: "\(n) \(una ? "nòta" : "nòtas") per còrda",
                it: "\(n) \(una ? "nota" : "note") per corda", de: "\(n) \(una ? "Ton" : "Töne") pro Saite",
                el: "\(n) \(una ? "νότα" : "νότες") ανά χορδή",
                ru: "\(n) \(una ? "нота" : n < 5 ? "ноты" : "нот") на струну")
        case .forma(let forma):
            return Traduccion(
                "Forma \(forma)", "\(forma) shape", ca: "Forma \(forma)", gl: "Forma \(forma)",
                ast: "Forma \(forma)", an: "Forma \(forma)", eu: "\(forma) forma", pt: "Forma \(forma)",
                fr: "Forme \(forma)", oc: "Forma \(forma)", it: "Forma \(forma)", de: "\(forma)-Form",
                el: "Σχήμα \(forma)", ru: "Форма \(forma)")
        case .mastilDeGuitarra:
            return Traduccion(
                "Mástil de guitarra", "Guitar fretboard", ca: "Mànec de guitarra", gl: "Mástil de guitarra",
                ast: "Mástil de guitarra", an: "Mástil de guitarra", eu: "Gitarraren mastila",
                pt: "Braço da guitarra",
                fr: "Manche de guitare", oc: "Margue de guitarra", it: "Manico della chitarra",
                de: "Gitarrengriffbrett",
                el: "Μπράτσο κιθάρας", ru: "Гриф гитары")
        case .pentagrama:
            return Traduccion(
                "Pentagrama", "Staff", ca: "Pentagrama", gl: "Pentagrama", ast: "Pentagrama",
                an: "Pentagrama", eu: "Pentagrama", pt: "Pauta",
                fr: "Portée", oc: "Pentagrama", it: "Pentagramma",
                de: "Notensystem",
                el: "Πεντάγραμμο", ru: "Нотный стан")
        case .progresion:
            return Traduccion(
                "Progresión", "Progression", ca: "Progressió", gl: "Progresión", ast: "Progresión",
                an: "Progresión", eu: "Progresioa", pt: "Progressão",
                fr: "Progression", oc: "Progression", it: "Progressione", de: "Akkordfolge",
                el: "Αλληλουχία", ru: "Последовательность")
        case .campoDeProgresion:
            return Traduccion(
                "Acordes separados por espacios", "Chords separated by spaces",
                ca: "Acords separats per espais", gl: "Acordes separados por espazos",
                ast: "Acordes separtaos por espacios", an: "Acordes deseparaus per espacios",
                eu: "Akordeak, zuriunez bereizita", pt: "Acordes separados por espaços",
                fr: "Accords séparés par des espaces", oc: "Acòrds separats per d'espacis",
                it: "Accordi separati da spazi", de: "Akkorde, durch Leerzeichen getrennt",
                el: "Συγχορδίες χωρισμένες με κενά", ru: "Аккорды через пробел")
        case .resultado:
            return Traduccion(
                "Resultado", "Result", ca: "Resultat", gl: "Resultado", ast: "Resultáu",
                an: "Resultau", eu: "Emaitza", pt: "Resultado",
                fr: "Résultat", oc: "Resultat", it: "Risultato", de: "Ergebnis",
                el: "Αποτέλεσμα", ru: "Результат")
        case .acordeAAcorde:
            return Traduccion(
                "Acorde a acorde", "Chord by chord", ca: "Acord a acord", gl: "Acorde a acorde",
                ast: "Acorde a acorde", an: "Acorde a acorde", eu: "Akordez akorde",
                pt: "Acorde a acorde",
                fr: "Accord par accord", oc: "Acòrd per acòrd", it: "Accordo per accordo",
                de: "Akkord für Akkord",
                el: "Συγχορδία προς συγχορδία", ru: "Аккорд за аккордом")
        case .arpegiar:
            return Traduccion(
                "Arpegiar", "Arpeggiate", ca: "Arpegiar", gl: "Arpexar", ast: "Arpexar",
                an: "Arpechar", eu: "Arpegiatu", pt: "Arpejar",
                fr: "Arpéger", oc: "Arpejar", it: "Arpeggiare", de: "Arpeggieren",
                el: "Σε αρπέζ", ru: "Арпеджировать")
        case .cadencias:
            return Traduccion(
                "Cadencias", "Cadences", ca: "Cadències", gl: "Cadencias", ast: "Cadencies",
                an: "Cadencias", eu: "Kadentziak", pt: "Cadências",
                fr: "Cadences", oc: "Cadéncias", it: "Cadenze", de: "Kadenzen",
                el: "Πτώσεις", ru: "Каденции")
        case .tarea:
            return Traduccion(
                "Tarea", "Task", ca: "Tasca", gl: "Tarefa", ast: "Xera",
                an: "Fayena", eu: "Zeregina", pt: "Tarefa",
                fr: "Tâche", oc: "Tasca", it: "Attività", de: "Aufgabe",
                el: "Εργασία", ru: "Задача")
        case .campoDeTonalidad:
            return Traduccion(
                "Tonalidad (vacío: la que mejor encaje)", "Key (empty: the best fit)",
                ca: "Tonalitat (buit: la que millor encaixi)", gl: "Tonalidade (baleiro: a que mellor encaixe)",
                ast: "Tonalidá (baleru: la que meyor encaxe)",
                an: "Tonalidat (vuedo: a que millor s\'achuste)", eu: "Tonalitatea (hutsik: hoberen egokitzen dena)",
                pt: "Tonalidade (vazio: a que melhor encaixar)",
                fr: "Tonalité (vide : la plus adaptée)", oc: "Tonalitat (voida: la que s'i acòrda melhor)",
                it: "Tonalità (vuoto: quella più adatta)", de: "Tonart (leer: die passendste)",
                el: "Τονικότητα (κενό: η καταλληλότερη)", ru: "Тональность (пусто: наиболее подходящая)")
        case .tonalidad:
            return Traduccion(
                "Tonalidad", "Key", ca: "Tonalitat", gl: "Tonalidade", ast: "Tonalidá",
                an: "Tonalidat", eu: "Tonalitatea", pt: "Tonalidade",
                fr: "Tonalité", oc: "Tonalitat", it: "Tonalità", de: "Tonart",
                el: "Τονικότητα", ru: "Тональность")
        case .armonizaciones:
            return Traduccion(
                "Armonizaciones, de mejor a peor", "Harmonizations, best first",
                ca: "Harmonitzacions, de millor a pitjor", gl: "Harmonizacións, de mellor a peor",
                ast: "Armonizaciones, de meyor a peor", an: "Armonizacions, de millor a pior",
                eu: "Harmonizazioak, onenetik txarrenera",
                pt: "Harmonizações, da melhor para a pior",
                fr: "Harmonisations, de la meilleure à la moins bonne",
                oc: "Armonizacions, de la melhora a la pièger",
                it: "Armonizzazioni, dalla migliore alla peggiore",
                de: "Harmonisierungen, die besten zuerst",
                el: "Εναρμονίσεις, από την καλύτερη στη χειρότερη", ru: "Гармонизации, от лучшей к худшей")
        case .aCuatroVoces:
            return Traduccion(
                "A cuatro voces, de grave a agudo", "In four parts, from low to high",
                ca: "A quatre veus, de greu a agut", gl: "A catro voces, de grave a agudo",
                ast: "A cuatro voces, de grave a agudu", an: "A cuatro voces, de grave a agudo",
                eu: "Lau ahotsetara, baxuenetik altuenera", pt: "A quatro vozes, do grave ao agudo",
                fr: "À quatre voix, du grave à l'aigu", oc: "A quatre voses, del grèu a l'agut",
                it: "A quattro voci, dal grave all'acuto", de: "Vierstimmig, von tief nach hoch",
                el: "Τετράφωνα, από το βαθύ στο οξύ", ru: "В четыре голоса, снизу вверх")
        case .conduccionDeLasVoces:
            return Traduccion(
                "Conducción de las voces", "Voice leading", ca: "Conducció de les veus",
                gl: "Condución das voces", ast: "Conducción de les voces", an: "Conducción d\'as voces",
                eu: "Ahots-eramatea", pt: "Condução das vozes",
                fr: "Conduite des voix", oc: "Conduccion de las voses", it: "Condotta delle parti",
                de: "Stimmführung",
                el: "Οδήγηση φωνών", ru: "Голосоведение")
        case .avisos:
            return Traduccion(
                "Avisos", "Warnings", ca: "Avisos", gl: "Avisos", ast: "Avisos",
                an: "Avisos", eu: "Oharrak", pt: "Avisos",
                fr: "Avertissements", oc: "Avertiments", it: "Avvisi", de: "Hinweise",
                el: "Προειδοποιήσεις", ru: "Предупреждения")
        case .recorridoPLR:
            return Traduccion(
                "Recorrido P·L·R", "P·L·R path", ca: "Recorregut P·L·R", gl: "Percorrido P·L·R",
                ast: "Percorríu P·L·R", an: "Recorrido P·L·R", eu: "P·L·R ibilbidea", pt: "Percurso P·L·R",
                fr: "Parcours P·L·R", oc: "Percors P·L·R", it: "Percorso P·L·R", de: "P·L·R-Weg",
                el: "Διαδρομή P·L·R", ru: "Путь P·L·R")
        case .modo:
            return Traduccion(
                "Modo", "Mode", ca: "Mode", gl: "Modo", ast: "Mou",
                an: "Modo", eu: "Modua", pt: "Modo",
                fr: "Mode", oc: "Mòde", it: "Modalità", de: "Modus",
                el: "Λειτουργία", ru: "Режим")
        case .red:
            return Traduccion(
                "Red", "Grid", ca: "Xarxa", gl: "Rede", ast: "Rede",
                an: "Ret", eu: "Sarea", pt: "Rede", fr: "Réseau", oc: "Ret", it: "Rete", de: "Netz",
                el: "Πλέγμα", ru: "Сетка")
        case .formatoUIL:
            return Traduccion(
                "Formato UIL", "UIL format", ca: "Format UIL", gl: "Formato UIL", ast: "Formatu UIL",
                an: "Formato UIL", eu: "UIL formatua", pt: "Formato UIL", fr: "Format UIL",
                oc: "Format UIL", it: "Formato UIL", de: "UIL-Format",
                el: "Μορφή UIL", ru: "Формат UIL")
        case .giro:
            return Traduccion(
                "Giro", "Rotation", ca: "Gir", gl: "Xiro", ast: "Xiru",
                an: "Chiro", eu: "Biraketa", pt: "Rotação", fr: "Rotation",
                oc: "Rotacion", it: "Rotazione", de: "Drehung",
                el: "Περιστροφή", ru: "Поворот")
        case .espejo:
            return Traduccion(
                "Espejo", "Mirror", ca: "Mirall", gl: "Espello", ast: "Espeyu",
                an: "Espello", eu: "Ispilua", pt: "Espelho", fr: "Miroir",
                oc: "Miralh", it: "Specchio", de: "Spiegeln",
                el: "Καθρέφτης", ru: "Зеркало")
        case .noSeDibuja:
            return Traduccion(
                "No se puede dibujar: revisa el texto.", "Can't draw it: check the text.",
                ca: "No es pot dibuixar: revisa el text.", gl: "Non se pode debuxar: revisa o texto.",
                ast: "Nun se pue dibuxar: revisa\'l testu.", an: "No se puede dibuixar: revisa o texto.",
                eu: "Ezin da marraztu: berrikusi testua.", pt: "Não é possível desenhar: revê o texto.",
                fr: "Impossible de dessiner : vérifie le texte.",
                oc: "Se pòt pas dessenhar: verifica lo tèxte.",
                it: "Impossibile disegnare: controlla il testo.", de: "Kann nicht gezeichnet werden: prüf den Text.",
                el: "Δεν σχεδιάζεται: έλεγξε το κείμενο.", ru: "Не удаётся нарисовать: проверь текст.")
        case .campoDeTriadaInicial:
            let ejemplo = Self.cifrado("Do", notacion) + ", " + Self.cifrado("Lam", notacion) + "…"
            return Traduccion(
                "Tríada inicial (\(ejemplo))", "Starting triad (\(ejemplo))",
                ca: "Tríada inicial (\(ejemplo))", gl: "Tríade inicial (\(ejemplo))",
                ast: "Tríada inicial (\(ejemplo))", an: "Tríada inicial (\(ejemplo))",
                eu: "Hasierako hirukia (\(ejemplo))", pt: "Tríade inicial (\(ejemplo))",
                fr: "Triade de départ (\(ejemplo))", oc: "Triada iniciala (\(ejemplo))",
                it: "Triade iniziale (\(ejemplo))", de: "Anfangsdreiklang (\(ejemplo))",
                el: "Αρχική τριφωνία (\(ejemplo))", ru: "Начальное трезвучие (\(ejemplo))")
        case .reiniciar:
            return Traduccion(
                "Reiniciar", "Restart", ca: "Reinicia", gl: "Reiniciar", ast: "Reaniciar",
                an: "Reiniciar", eu: "Berrabiarazi", pt: "Reiniciar",
                fr: "Recommencer", oc: "Tornar començar", it: "Ricomincia", de: "Neu beginnen",
                el: "Επανεκκίνηση", ru: "Начать заново")
        case .deshacer:
            return Traduccion(
                "Deshacer", "Undo", ca: "Desfés", gl: "Desfacer", ast: "Desfacer",
                an: "Desfer", eu: "Desegin", pt: "Desfazer",
                fr: "Annuler", oc: "Desfar", it: "Annulla", de: "Rückgängig",
                el: "Αναίρεση", ru: "Отменить")
        case .campoDeAcorde:
            let ejemplo = Self.cifrado("Dom7", notacion) + ", " + Self.cifrado("Fa#m7b5", notacion) + "…"
            return TextoDeLasApps.cifrado.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .campoDeEscala:
            let ejemplos = [Escala(.re, .dorico), Escala(.la, .menorArmonica)].map { $0.nombre(en: notacion) }
            let ejemplo = ejemplos.joined(separator: ", ") + "…"
            return TextoDeLasApps.escala.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .textos:
            return Traduccion(
                "Textos", "Texts", ca: "Textos", gl: "Textos", ast: "Testos",
                an: "Textos", eu: "Testuak", pt: "Textos",
                fr: "Textes", oc: "Tèxtes", it: "Testi", de: "Texte",
                el: "Κείμενα", ru: "Тексты")
        case .comoLasNotas:
            return Traduccion(
                "Como las notas", "Same as the notes", ca: "Com les notes", gl: "Como as notas",
                ast: "Como les notes", an: "Como as notas", eu: "Notak bezala", pt: "Como as notas",
                fr: "Comme les notes", oc: "Coma las nòtas", it: "Come le note", de: "Wie die Noten",
                el: "Όπως οι νότες", ru: "Как ноты")
        case .escuchar:
            return Traduccion(
                "Escuchar", "Listen", ca: "Escolta", gl: "Escoitar", ast: "Escuchar",
                an: "Escuitar", eu: "Entzun", pt: "Ouvir",
                fr: "Écouter", oc: "Escotar", it: "Ascolta", de: "Anhören",
                el: "Ακρόαση", ru: "Слушать")
        case .afinacionAlEscuchar:
            return Traduccion(
                "Afinación al escuchar", "Playback tuning", ca: "Afinació en escoltar",
                gl: "Afinación ao escoitar", ast: "Afinación al escuchar",
                an: "Afinación en escuitar", eu: "Entzuteko afinazioa", pt: "Afinação ao ouvir",
                fr: "Tempérament à l'écoute", oc: "Acordatge en escotar", it: "Accordatura dell'ascolto",
                de: "Stimmung beim Anhören",
                el: "Κούρδισμα ακρόασης", ru: "Строй при прослушивании")
        case .exportar:
            return Traduccion(
                "Exportar", "Export", ca: "Exporta", gl: "Exportar", ast: "Esportar",
                an: "Exportar", eu: "Esportatu", pt: "Exportar",
                fr: "Exporter", oc: "Exportar", it: "Esporta", de: "Exportieren",
                el: "Εξαγωγή", ru: "Экспорт")
        case .abrir:
            return Traduccion(
                "Abrir", "Open", ca: "Obre", gl: "Abrir", ast: "Abrir",
                an: "Ubrir", eu: "Ireki", pt: "Abrir",
                fr: "Ouvrir", oc: "Dobrir", it: "Apri", de: "Öffnen",
                el: "Άνοιγμα", ru: "Открыть")
        case .rejillaHexagonal:
            return Traduccion(
                "Rejilla hexagonal", "Hexagonal grid", ca: "Graella hexagonal", gl: "Grade hexagonal",
                ast: "Rexáu hexagonal", an: "Reixa hexagonal", eu: "Sare hexagonala",
                pt: "Grelha hexagonal",
                fr: "Grille hexagonale", oc: "Grasilha exagonala", it: "Griglia esagonale",
                de: "Sechseckgitter",
                el: "Εξαγωνικό πλέγμα", ru: "Шестиугольная сетка")
        case .casillas(let n):
            let una = n == 1
            return Traduccion(
                "\(n) \(una ? "casilla" : "casillas")", "\(n) \(una ? "cell" : "cells")",
                ca: "\(n) \(una ? "casella" : "caselles")", gl: "\(n) \(una ? "cela" : "celas")",
                ast: "\(n) \(una ? "casiella" : "casielles")", an: "\(n) \(una ? "caseta" : "casetas")",
                eu: una ? "gelaxka 1" : "\(n) gelaxka", pt: "\(n) \(una ? "casa" : "casas")",
                fr: "\(n) \(una ? "case" : "cases")", oc: "\(n) \(una ? "casa" : "casas")",
                it: "\(n) \(una ? "casella" : "caselle")",
                de: "\(n) \(una ? "Feld" : "Felder")",
                el: "\(n) \(una ? "κελί" : "κελιά")", ru: Traduccion.pluralRuso(n, "клетка", "клетки", "клеток"))
        case .casillaElegida(let q, let r):
            return Traduccion(
                "elegida", "selected", ca: "escollida", gl: "escollida", ast: "escoyida",
                an: "escollida", eu: "hautatua", pt: "escolhida",
                fr: "choisie", oc: "causida", it: "scelta", de: "ausgewählt",
                el: "επιλεγμένο", ru: "выбрана"
            )
            .aplicando { "\($0) q \(q), r \(r)" }
        case .mastilDe(let instrumento, let desde, let hasta):
            return Traduccion(
                "Mástil de \(instrumento), trastes \(desde) a \(hasta)",
                "\(instrumento.capitalizandoLaPrimera) neck, frets \(desde) to \(hasta)",
                ca: "Mànec de \(instrumento), trasts \(desde) a \(hasta)",
                gl: "Mástil de \(instrumento), trastes \(desde) a \(hasta)",
                ast: "Mástil de \(instrumento), trastes \(desde) a \(hasta)",
                an: "Mástil de \(instrumento), trastes \(desde) a \(hasta)",
                eu: "Mastila (\(instrumento)), trasteak \(desde)-\(hasta)",
                pt: "Braço de \(instrumento), trastes \(desde) a \(hasta)",
                fr: "Manche de \(instrumento), cases \(desde) à \(hasta)",
                oc: "Margue de \(instrumento), trasts \(desde) a \(hasta)",
                it: "Manico di \(instrumento), tasti da \(desde) a \(hasta)",
                de: "Griffbrett (\(instrumento)), Bünde \(desde) bis \(hasta)",
                el: "Μπράτσο (\(instrumento)), τάστα \(desde) έως \(hasta)",
                ru: "Гриф (\(instrumento)), лады с \(desde) по \(hasta)")
        case .posicion(let cuerda, let traste):
            return Traduccion(
                "cuerda \(cuerda), traste \(traste)", "string \(cuerda), fret \(traste)",
                ca: "corda \(cuerda), trast \(traste)", gl: "corda \(cuerda), traste \(traste)",
                ast: "cuerda \(cuerda), traste \(traste)", an: "cuerda \(cuerda), traste \(traste)",
                eu: "soka \(cuerda), trastea \(traste)", pt: "corda \(cuerda), traste \(traste)",
                fr: "corde \(cuerda), case \(traste)", oc: "còrda \(cuerda), trast \(traste)",
                it: "corda \(cuerda), tasto \(traste)", de: "Saite \(cuerda), Bund \(traste)",
                el: "χορδή \(cuerda), τάστο \(traste)", ru: "струна \(cuerda), лад \(traste)")
        case .marcas(let n):
            let una = n == 1
            return Traduccion(
                "\(n) \(una ? "marca" : "marcas")", "\(n) \(una ? "mark" : "marks")",
                ca: "\(n) \(una ? "marca" : "marques")", gl: "\(n) \(una ? "marca" : "marcas")",
                ast: "\(n) \(una ? "marca" : "marques")", an: "\(n) \(una ? "marca" : "marcas")",
                eu: una ? "marka 1" : "\(n) marka", pt: "\(n) \(una ? "marca" : "marcas")",
                fr: "\(n) \(una ? "marque" : "marques")", oc: "\(n) \(una ? "marca" : "marcas")",
                it: "\(n) \(una ? "segno" : "segni")",
                de: "\(n) \(una ? "Markierung" : "Markierungen")",
                el: "\(n) \(una ? "σημάδι" : "σημάδια")", ru: Traduccion.pluralRuso(n, "отметка", "отметки", "отметок"))
        case .cuerdasApagadas(let lista):
            return Traduccion(
                "cuerdas apagadas: \(lista)", "muted strings: \(lista)",
                ca: "cordes apagades: \(lista)", gl: "cordas apagadas: \(lista)",
                ast: "cuerdes apagaes: \(lista)", an: "cuerdas apagadas: \(lista)",
                eu: "isilarazitako sokak: \(lista)", pt: "cordas abafadas: \(lista)",
                fr: "cordes étouffées : \(lista)", oc: "còrdas amorsadas: \(lista)",
                it: "corde smorzate: \(lista)", de: "gedämpfte Saiten: \(lista)",
                el: "σβησμένες χορδές: \(lista)", ru: "заглушённые струны: \(lista)")
        case .sinMarcas:
            return Traduccion(
                "Sin marcas", "No marks", ca: "Sense marques", gl: "Sen marcas", ast: "Ensin marques",
                an: "Sin marcas", eu: "Markarik ez", pt: "Sem marcas",
                fr: "Aucune marque", oc: "Cap de marca", it: "Nessun segno", de: "Keine Markierungen",
                el: "Χωρίς σημάδια", ru: "Нет отметок")
        }
    }

    /// Un cifrado de ejemplo en la notación: «Sol7/Si» → «G7/B».
    static func cifrado(_ texto: String, _ notacion: Notacion) -> String {
        (try? Acorde(leyendo: texto))?.cifrado(en: notacion) ?? texto
    }

    /// Alturas de ejemplo en la notación: «Mi4 Fa4 Re4 Do4» → «E4 F4 D4 C4».
    static func alturas(_ texto: String, _ notacion: Notacion) -> String {
        texto.split(separator: " ", omittingEmptySubsequences: false).map { palabra in
            let coma = palabra.hasSuffix(",")
            let limpia = coma ? String(palabra.dropLast()) : String(palabra)
            return ((try? Altura(leyendo: limpia))?.nombre(en: notacion) ?? limpia) + (coma ? "," : "")
        }.joined(separator: " ")
    }
}

extension Traduccion {
    /// La misma frase en los catorce idiomas, cambiada igual en todos.
    func aplicando(_ cambio: (String) -> String) -> Traduccion {
        map(cambio)
    }
}

extension Notacion {
    /// Un texto de la interfaz de las apps en el idioma de los textos de esta notación.
    public func texto(_ texto: TextoDeLasApps) -> String {
        texto.texto(en: self)
    }
}

extension String {
    /// «guitarra» → «Guitarra».
    var capitalizandoLaPrimera: String { prefix(1).uppercased() + dropFirst() }
}
