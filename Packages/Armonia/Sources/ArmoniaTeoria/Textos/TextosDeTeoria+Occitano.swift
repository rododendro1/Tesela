// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en occitano. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let occitano = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), amb la bassa en \(bajo)" },
        nombresDeLasInversiones: ["estat fondamental", "primièra inversion", "segonda inversion", "tresena inversion",
                                  "quatrena inversion", "cinquena inversion", "sisena inversion"],
        inversionConNumero: "inversion _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fondamentala",
        papelTercera: "tèrça",
        papelSuspension: "suspension",
        papelQuinta: "quinta",
        papelSexta: "sexta",
        papelSeptima: "setena",
        papelNovena: "novena",
        papelUndecima: "onzena",
        papelDecimotercera: "tretzena",
        papelTension: { n in "tension \(n)a" },
        triadaMayor: "majora",
        triadaMenor: "menora",
        triadaDisminuida: "diminuida",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspenduda",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sens tèrça",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acòrd \(vacio ? "major" : latino)" },
        tipoMayor: "major",
        tipoMenor: "menor",
        tipoDisminuido: "diminuit",
        tipoAumentado: "aumentat",
        tipoSuspendidoDeSegunda: "suspendut de segonda",
        tipoSuspendidoDeCuarta: "suspendut de quarta",
        tipoQuintaAcordeDePotencia: "quinta (acòrd de poténcia)",
        tipoSeptimaDeDominante: "setena de dominanta",
        tipoSeptimaMayor: "setena majora",
        tipoMenorSeptima: "menor setena",
        tipoSemidisminuido: "semidiminuit",
        tipoSeptimaDisminuida: "setena diminuida",
        tipoMenorConSeptimaMayor: "menor amb setena majora",
        tipoAumentadoConSeptimaMenor: "aumentat amb setena menora",
        tipoAumentadoConSeptimaMayor: "aumentat amb setena majora",
        tipoSeptimaSuspendida: "setena suspenduda",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor sexta",
        tipoSextaYNovena: "sexta e novena",
        tipoNovenaDeDominante: "novena de dominanta",
        tipoNovenaMayor: "novena majora",
        tipoMenorNovena: "menor novena",
        tipoNovenaAnadida: "novena aponduda",
        tipoUndecima: "onzena",
        tipoMenorUndecima: "menor onzena",
        tipoDecimotercera: "tretzena",
        tipoMenorDecimotercera: "menor tretzena",
        tipoSeptimaConNovenaMenor: "setena amb novena menora",
        tipoSextaAumentadaItaliana: "sexta aumentada italiana",
        tipoSextaAumentadaFrancesa: "sexta aumentada francesa",
        tipoSextaAumentadaAlemana: "sexta aumentada alemanda",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acòrds \(pasos))" },
        enElAcorde: { acorde in "(acòrd \(acorde + 1))" },
        quintasParalelas: "Quintas parallèlas",
        octavasParalelas: "Octavas parallèlas",
        quintasDirectas: "Quintas dirèctas",
        octavasDirectas: "Octavas dirèctas",
        cruceDeVoces: "Crosament de voses",
        superposicion: "Sobreposicion",
        separacionExcesiva: "Mai d'una octava",
        saltoNoMelodico: "Saut pas melodic",
        fueraDeTesitura: "Fòra de tessitura",
        vozBajo: "bassa",
        vozTenor: "tenor",
        vozContralto: "contralt",
        vozSoprano: "soprano",
        vozNumero: { numero in "votz \(numero)" },

        // Escala.swift
        gradoTonica: "tonica",
        gradoSupertonica: "sobretonica",
        gradoMediante: "mediant",
        gradoSubdominante: "sosdominanta",
        gradoDominante: "dominanta",
        gradoSuperdominante: "sobredominanta",
        gradoSensible: "sensibla",
        gradoSubtonica: "sostonica",

        // AnalisisArmonico.swift
        funcionTonica: "tonica",
        funcionSubdominante: "sosdominanta",
        funcionDominante: "dominanta",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "acòrds \(pasos)" },
        cadenciaAutentica: "cadéncia autentica",
        cadenciaPlagal: "cadéncia plagala",
        cadenciaRota: "cadéncia rompuda",
        semicadencia: "semicadéncia",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) a l'acòrd \(n)" },
        pivote: "pivòt",
        directa: " (dirècta)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpegi de \(acorde)" },
        patronAscendente: "ascendent",
        patronDescendente: "descendent",
        patronIdaYVuelta: "d'anada e de tornada",
        patronAlberti: "bassa d'Alberti",
        patronQuebrado: "trencat",
        patronBajaYSube: "de davalada e de montada",
        // Rearmonizacion.swift
        sustitutoTritonal: "substitut de triton",
        dominanteSecundaria: "dominanta segondària",
        prestamoModal: "manlèu modal",
        sustitutoDiatonico: "substitut diatonic",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
