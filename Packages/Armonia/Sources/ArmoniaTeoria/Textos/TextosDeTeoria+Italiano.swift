// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en italiano. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let italiano = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), con il basso in \(bajo)" },
        nombresDeLasInversiones: ["stato fondamentale", "primo rivolto", "secondo rivolto", "terzo rivolto",
                                  "quarto rivolto", "quinto rivolto", "sesto rivolto"],
        inversionConNumero: "rivolto _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fondamentale",
        papelTercera: "terza",
        papelSuspension: "sospensione",
        papelQuinta: "quinta",
        papelSexta: "sesta",
        papelSeptima: "settima",
        papelNovena: "nona",
        papelUndecima: "undicesima",
        papelDecimotercera: "tredicesima",
        papelTension: { n in "tensione \(n)ª" },
        triadaMayor: "maggiore",
        triadaMenor: "minore",
        triadaDisminuida: "diminuita",
        triadaAumentada: "aumentata",
        triadaSuspendida: "sospesa",
        triadaDeQuinta: "di quinta",
        triadaSinTercera: "senza terza",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "accordo \(vacio ? "maggiore" : latino)" },
        tipoMayor: "maggiore",
        tipoMenor: "minore",
        tipoDisminuido: "diminuito",
        tipoAumentado: "aumentato",
        tipoSuspendidoDeSegunda: "sospeso di seconda",
        tipoSuspendidoDeCuarta: "sospeso di quarta",
        tipoQuintaAcordeDePotencia: "quinta (power chord)",
        tipoSeptimaDeDominante: "settima di dominante",
        tipoSeptimaMayor: "settima maggiore",
        tipoMenorSeptima: "minore settima",
        tipoSemidisminuido: "semidiminuito",
        tipoSeptimaDisminuida: "settima diminuita",
        tipoMenorConSeptimaMayor: "minore con settima maggiore",
        tipoAumentadoConSeptimaMenor: "aumentato con settima minore",
        tipoAumentadoConSeptimaMayor: "aumentato con settima maggiore",
        tipoSeptimaSuspendida: "settima sospesa",
        tipoSexta: "sesta",
        tipoMenorSexta: "minore sesta",
        tipoSextaYNovena: "sesta e nona",
        tipoNovenaDeDominante: "nona di dominante",
        tipoNovenaMayor: "nona maggiore",
        tipoMenorNovena: "minore nona",
        tipoNovenaAnadida: "nona aggiunta",
        tipoUndecima: "undicesima",
        tipoMenorUndecima: "minore undicesima",
        tipoDecimotercera: "tredicesima",
        tipoMenorDecimotercera: "minore tredicesima",
        tipoSeptimaConNovenaMenor: "settima con nona minore",
        tipoSextaAumentadaItaliana: "sesta aumentata italiana",
        tipoSextaAumentadaFrancesa: "sesta aumentata francese",
        tipoSextaAumentadaAlemana: "sesta aumentata tedesca",

        // Coral.swift
        entreLasVoces: { nombres in "tra " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "in \(primera)" },
        enLosAcordes: { pasos in "(accordi \(pasos))" },
        enElAcorde: { acorde in "(accordo \(acorde + 1))" },
        quintasParalelas: "Quinte parallele",
        octavasParalelas: "Ottave parallele",
        quintasDirectas: "Quinte nascoste",
        octavasDirectas: "Ottave nascoste",
        cruceDeVoces: "Incrocio delle voci",
        superposicion: "Sovrapposizione",
        separacionExcesiva: "Più di un'ottava",
        saltoNoMelodico: "Salto non melodico",
        fueraDeTesitura: "Fuori tessitura",
        vozBajo: "basso",
        vozTenor: "tenore",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voce \(numero)" },

        // Escala.swift
        gradoTonica: "tonica",
        gradoSupertonica: "sopratonica",
        gradoMediante: "mediante",
        gradoSubdominante: "sottodominante",
        gradoDominante: "dominante",
        gradoSuperdominante: "sopradominante",
        gradoSensible: "sensibile",
        gradoSubtonica: "sottotonica",

        // AnalisisArmonico.swift
        funcionTonica: "tonica",
        funcionSubdominante: "sottodominante",
        funcionDominante: "dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "accordi \(pasos)" },
        cadenciaAutentica: "cadenza perfetta",
        cadenciaPlagal: "cadenza plagale",
        cadenciaRota: "cadenza d'inganno",
        semicadencia: "semicadenza",
        semicadenciaFrigia: "semicadenza frigia",
        cadenciaPlagalMenor: "cadenza plagale minore",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "Da \(de) a \(a) all'accordo \(n)" },
        pivote: "perno",
        directa: " (diretta)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpeggio di \(acorde)" },
        patronAscendente: "ascendente",
        patronDescendente: "discendente",
        patronIdaYVuelta: "andata e ritorno",
        patronAlberti: "basso albertino",
        patronQuebrado: "spezzato",
        patronBajaYSube: "discesa e salita",
        aproximacionDesdeAbajo: "da sotto",
        aproximacionDesdeArriba: "da sopra",
        aproximacionEncierro: "accerchiamento",
        // Escala+Acorde.swift
        papelNotaDelAcorde: "nota dell'accordo",
        papelTensionDisponible: "tensione",
        papelNotaAEvitar: "nota da evitare",
        modoDe: { modo, escala in "modo \(modo) di \(escala)" },
        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota di passaggio", "nota di volta", "appoggiatura", "ritardo", "anticipazione", "nota sfuggita", "pedale", "nota libera"],
        // EsquemaArmonico.swift
        nombresDeEsquemas: ["ii–V–I", "ii–V", "turnaround", "backdoor", "blues di 12 battute", "progressione per quinte", "romanesca", "canone di Pachelbel", "monte", "fonte", "ponte"],
        // Rearmonizacion.swift
        sustitutoTritonal: "sostituzione di tritono",
        dominanteSecundaria: "dominante secondaria",
        prestamoModal: "prestito modale",
        sustitutoDiatonico: "sostituzione diatonica",
        rearmonizacionIIV: "ii–V",
        rearmonizacionBackdoor: "dominante backdoor",
        // ErrorDeLecturaDeTeoria.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» non fa parte di nessuna sigla conosciuta" },
        tensionNoValida: { tension in "«\(tension)» non è una tensione valida (si ammettono ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» non è un numero di accordo (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» compare dopo un altro numero; le tensioni aggiuntive vanno tra parentesi, come in 7(9)" },
        disminuidoYSemidisminuido: "diminuito (°) e semidiminuito (ø) non si possono combinare",
        quintaConCalidad: "l'accordo di quinta (5) non ha la terza, quindi non ammette m, °, ø né +",
        fundamentalNoOmitible: "non si può omettere la fondamentale",
        gradoNoOmitible: { grado in "«omit\(grado)» non è valido (si possono omettere 3, 5, 7, 9, 11 e 13)" },
        faltaLaFundamental: "manca la fondamentale",
        intervaloSinPapel: { intervalo, notacion in "l'intervallo di \(intervalo.nombre(en: .italianoPalabras)) non ha un ruolo in un accordo per terze" },
        terceraMayorYMenor: "ha insieme la terza maggiore e quella minore (la ♯9 si scrive come 9ª aumentata, non come 3ª minore)",
        variasSeptimas: "ha più di una settima",
        septimaDisminuidaFueraDelDisminuido: "la settima diminuita compare solo nell'accordo diminuito (con 3ª minore e 5ª diminuita)",
        noEsPorTerceras: "non è un accordo per terze",
        bajoNoValido: { bajo in "«\(bajo)» non è un nome di nota per il basso" },
        idiomasMezclados: { nombre in "«\(nombre)» è scritto in un'altra lingua rispetto alla fondamentale: si scrive tutto in sillabe (Sol7/Si) o tutto in lettere (G7/B)" },
        // ErrorDeLecturaDeTeoria.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» non è il modo di una tonalità: una tonalità è maggiore o minore (per gli altri modi, usa Escala)" },
        faltaElTipoDeEscala: "manca il tipo di scala (maggiore, dorica, minore armonica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» non è un tipo di scala conosciuto" },
        // ErrorDeLecturaDeTeoria.swift (coral)
        vocesDistintas: "tutti gli accordi devono avere lo stesso numero di voci, e almeno due",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "in " + tonalidad }
    )
}
