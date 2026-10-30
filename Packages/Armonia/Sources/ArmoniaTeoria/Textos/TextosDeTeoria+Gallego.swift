// Los textos de ArmoniaTeoria en gallego. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let gallego = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "co baixo en \(bajo)" },
        nombresDeLasInversiones: ["estado fundamental", "primeira inversión", "segunda inversión", "terceira inversión",
                                  "cuarta inversión", "quinta inversión", "sexta inversión"],
        inversionConNumero: "inversión _",

        // EstructuraDeAcorde+Idiomas.swift
        papelFundamental: "fundamental",
        papelTercera: "terceira",
        papelSuspension: "suspensión",
        papelQuinta: "quinta",
        papelSexta: "sexta",
        papelSeptima: "sétima",
        papelNovena: "novena",
        papelUndecima: "undécima",
        papelDecimotercera: "décimo terceira",
        papelTension: { n in "tensión \(n)ª" },
        triadaMayor: "maior",
        triadaMenor: "menor",
        triadaDisminuida: "diminuída",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspendida",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sen terceira",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acorde \(vacio ? "maior" : latino)" },
        tipoMayor: "maior",
        tipoMenor: "menor",
        tipoDisminuido: "diminuído",
        tipoAumentado: "aumentado",
        tipoSuspendidoDeSegunda: "suspendido de segunda",
        tipoSuspendidoDeCuarta: "suspendido de cuarta",
        tipoQuintaAcordeDePotencia: "quinta (acorde de potencia)",
        tipoSeptimaDeDominante: "sétima de dominante",
        tipoSeptimaMayor: "sétima maior",
        tipoMenorSeptima: "menor sétima",
        tipoSemidisminuido: "semidiminuído",
        tipoSeptimaDisminuida: "sétima diminuída",
        tipoMenorConSeptimaMayor: "menor con sétima maior",
        tipoAumentadoConSeptimaMenor: "aumentado con sétima menor",
        tipoAumentadoConSeptimaMayor: "aumentado con sétima maior",
        tipoSeptimaSuspendida: "sétima suspendida",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor sexta",
        tipoSextaYNovena: "sexta e novena",
        tipoNovenaDeDominante: "novena de dominante",
        tipoNovenaMayor: "novena maior",
        tipoMenorNovena: "menor novena",
        tipoNovenaAnadida: "novena engadida",
        tipoUndecima: "undécima",
        tipoMenorUndecima: "menor undécima",
        tipoDecimotercera: "décimo terceira",
        tipoMenorDecimotercera: "menor décimo terceira",
        tipoSeptimaConNovenaMenor: "sétima con novena menor",
        tipoSextaAumentadaItaliana: "sexta aumentada italiana",
        tipoSextaAumentadaFrancesa: "sexta aumentada francesa",
        tipoSextaAumentadaAlemana: "sexta aumentada alemá",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " e ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Oitavas paralelas",
        quintasDirectas: "Quintas directas",
        octavasDirectas: "Oitavas directas",
        cruceDeVoces: "Cruzamento de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Máis dunha oitava",
        saltoNoMelodico: "Salto non melódico",
        fueraDeTesitura: "Fóra de tesitura",
        vozBajo: "baixo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // Escala+Idiomas.swift
        gradoTonica: "tónica",
        gradoSupertonica: "supertónica",
        gradoMediante: "mediante",
        gradoSubdominante: "subdominante",
        gradoDominante: "dominante",
        gradoSuperdominante: "superdominante",
        gradoSensible: "sensible",
        gradoSubtonica: "subtónica",

        // AnalisisArmonico.swift
        funcionTonica: "tónica",
        funcionSubdominante: "subdominante",
        funcionDominante: "dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "acordes \(pasos)" },
        cadenciaAutentica: "cadencia auténtica",
        cadenciaPlagal: "cadencia plagal",
        cadenciaRota: "cadencia rota",
        semicadencia: "semicadencia",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) no acorde \(n)" },
        pivote: "pivote",
        directa: " (directa)"
    )
}
