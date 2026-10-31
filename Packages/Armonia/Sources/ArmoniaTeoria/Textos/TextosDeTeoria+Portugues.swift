// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en portugués. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let portugues = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), com o baixo em \(bajo)" },
        nombresDeLasInversiones: ["estado fundamental", "primeira inversão", "segunda inversão", "terceira inversão",
                                  "quarta inversão", "quinta inversão", "sexta inversão"],
        inversionConNumero: "inversão _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fundamental",
        papelTercera: "terceira",
        papelSuspension: "suspensão",
        papelQuinta: "quinta",
        papelSexta: "sexta",
        papelSeptima: "sétima",
        papelNovena: "nona",
        papelUndecima: "décima primeira",
        papelDecimotercera: "décima terceira",
        papelTension: { n in "tensão \(n)ª" },
        triadaMayor: "maior",
        triadaMenor: "menor",
        triadaDisminuida: "diminuta",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspensa",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sem terceira",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acorde \(vacio ? "maior" : latino)" },
        tipoMayor: "maior",
        tipoMenor: "menor",
        tipoDisminuido: "diminuto",
        tipoAumentado: "aumentado",
        tipoSuspendidoDeSegunda: "suspenso de segunda",
        tipoSuspendidoDeCuarta: "suspenso de quarta",
        tipoQuintaAcordeDePotencia: "quinta (power chord)",
        tipoSeptimaDeDominante: "sétima de dominante",
        tipoSeptimaMayor: "sétima maior",
        tipoMenorSeptima: "menor com sétima",
        tipoSemidisminuido: "meio-diminuto",
        tipoSeptimaDisminuida: "sétima diminuta",
        tipoMenorConSeptimaMayor: "menor com sétima maior",
        tipoAumentadoConSeptimaMenor: "aumentado com sétima menor",
        tipoAumentadoConSeptimaMayor: "aumentado com sétima maior",
        tipoSeptimaSuspendida: "sétima suspensa",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor com sexta",
        tipoSextaYNovena: "sexta e nona",
        tipoNovenaDeDominante: "nona de dominante",
        tipoNovenaMayor: "nona maior",
        tipoMenorNovena: "menor com nona",
        tipoNovenaAnadida: "nona adicionada",
        tipoUndecima: "décima primeira",
        tipoMenorUndecima: "menor com décima primeira",
        tipoDecimotercera: "décima terceira",
        tipoMenorDecimotercera: "menor com décima terceira",
        tipoSeptimaConNovenaMenor: "sétima com nona menor",
        tipoSextaAumentadaItaliana: "sexta aumentada italiana",
        tipoSextaAumentadaFrancesa: "sexta aumentada francesa",
        tipoSextaAumentadaAlemana: "sexta aumentada alemã",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "em \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Oitavas paralelas",
        quintasDirectas: "Quintas diretas",
        octavasDirectas: "Oitavas diretas",
        cruceDeVoces: "Cruzamento de vozes",
        superposicion: "Sobreposição",
        separacionExcesiva: "Mais de uma oitava",
        saltoNoMelodico: "Salto não melódico",
        fueraDeTesitura: "Fora da tessitura",
        vozBajo: "baixo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // Escala.swift
        gradoTonica: "tónica",
        gradoSupertonica: "supertónica",
        gradoMediante: "mediante",
        gradoSubdominante: "subdominante",
        gradoDominante: "dominante",
        gradoSuperdominante: "sobredominante",
        gradoSensible: "sensível",
        gradoSubtonica: "subtónica",

        // AnalisisArmonico.swift
        funcionTonica: "tónica",
        funcionSubdominante: "subdominante",
        funcionDominante: "dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "acordes \(pasos)" },
        cadenciaAutentica: "cadência autêntica",
        cadenciaPlagal: "cadência plagal",
        cadenciaRota: "cadência interrompida",
        semicadencia: "semicadência",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) para \(a) no acorde \(n)" },
        pivote: "pivô",
        directa: " (direta)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpejo de \(acorde)" },
        patronAscendente: "ascendente",
        patronDescendente: "descendente",
        patronIdaYVuelta: "de ida e volta",
        patronAlberti: "baixo de Alberti",
        patronQuebrado: "quebrado",
        patronBajaYSube: "de descida e subida",
        // Rearmonizacion.swift
        sustitutoTritonal: "substituto de trítono",
        dominanteSecundaria: "dominante secundária",
        prestamoModal: "empréstimo modal",
        sustitutoDiatonico: "substituto diatónico",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "em " + tonalidad }
    )
}
