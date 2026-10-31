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
        // Rearmonizacion.swift
        sustitutoTritonal: "sostituzione di tritono",
        dominanteSecundaria: "dominante secondaria",
        prestamoModal: "prestito modale",
        sustitutoDiatonico: "sostituzione diatonica",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "in " + tonalidad }
    )
}
