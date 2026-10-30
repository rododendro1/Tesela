// Los textos de ArmoniaTeoria en español. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let espanol = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "con bajo en \(bajo)" },
        nombresDeLasInversiones: ["estado fundamental", "primera inversión", "segunda inversión", "tercera inversión",
                                  "cuarta inversión", "quinta inversión", "sexta inversión"],
        inversionConNumero: "inversión _",

        // EstructuraDeAcorde+Idiomas.swift
        papelFundamental: "fundamental",
        papelTercera: "tercera",
        papelSuspension: "suspensión",
        papelQuinta: "quinta",
        papelSexta: "sexta",
        papelSeptima: "séptima",
        papelNovena: "novena",
        papelUndecima: "undécima",
        papelDecimotercera: "decimotercera",
        papelTension: { n in "tensión \(n)ª" },
        triadaMayor: "mayor",
        triadaMenor: "menor",
        triadaDisminuida: "disminuida",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspendida",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sin tercera",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acorde \(vacio ? "mayor" : latino)" },
        tipoMayor: "mayor",
        tipoMenor: "menor",
        tipoDisminuido: "disminuido",
        tipoAumentado: "aumentado",
        tipoSuspendidoDeSegunda: "suspendido de segunda",
        tipoSuspendidoDeCuarta: "suspendido de cuarta",
        tipoQuintaAcordeDePotencia: "quinta (acorde de potencia)",
        tipoSeptimaDeDominante: "séptima de dominante",
        tipoSeptimaMayor: "séptima mayor",
        tipoMenorSeptima: "menor séptima",
        tipoSemidisminuido: "semidisminuido",
        tipoSeptimaDisminuida: "séptima disminuida",
        tipoMenorConSeptimaMayor: "menor con séptima mayor",
        tipoAumentadoConSeptimaMenor: "aumentado con séptima menor",
        tipoAumentadoConSeptimaMayor: "aumentado con séptima mayor",
        tipoSeptimaSuspendida: "séptima suspendida",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor sexta",
        tipoSextaYNovena: "sexta y novena",
        tipoNovenaDeDominante: "novena de dominante",
        tipoNovenaMayor: "novena mayor",
        tipoMenorNovena: "menor novena",
        tipoNovenaAnadida: "novena añadida",
        tipoUndecima: "undécima",
        tipoMenorUndecima: "menor undécima",
        tipoDecimotercera: "decimotercera",
        tipoMenorDecimotercera: "menor decimotercera",
        tipoSeptimaConNovenaMenor: "séptima con novena menor",
        tipoSextaAumentadaItaliana: "sexta aumentada italiana",
        tipoSextaAumentadaFrancesa: "sexta aumentada francesa",
        tipoSextaAumentadaAlemana: "sexta aumentada alemana",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " y ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintas paralelas",
        octavasParalelas: "Octavas paralelas",
        quintasDirectas: "Quintas directas",
        octavasDirectas: "Octavas directas",
        cruceDeVoces: "Cruce de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Más de una octava",
        saltoNoMelodico: "Salto no melódico",
        fueraDeTesitura: "Fuera de tesitura",
        vozBajo: "bajo",
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
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) en el acorde \(n)" },
        pivote: "pivote",
        directa: " (directa)"
    )
}
