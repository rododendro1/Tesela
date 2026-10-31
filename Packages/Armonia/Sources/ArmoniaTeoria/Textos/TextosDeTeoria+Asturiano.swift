// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let asturiano = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "con baxu en \(bajo)" },
        nombresDeLasInversiones: ["estáu fundamental", "primer inversión", "segunda inversión", "tercer inversión",
                                  "cuarta inversión", "quinta inversión", "sexta inversión"],
        inversionConNumero: "inversión _",

        // EstructuraDeAcorde.swift
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
        triadaDisminuida: "menguada",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspendida",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "ensin tercera",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acorde \(vacio ? "mayor" : latino)" },
        tipoMayor: "mayor",
        tipoMenor: "menor",
        tipoDisminuido: "menguáu",
        tipoAumentado: "aumentáu",
        tipoSuspendidoDeSegunda: "suspendíu de segunda",
        tipoSuspendidoDeCuarta: "suspendíu de cuarta",
        tipoQuintaAcordeDePotencia: "quinta (acorde de potencia)",
        tipoSeptimaDeDominante: "séptima de dominante",
        tipoSeptimaMayor: "séptima mayor",
        tipoMenorSeptima: "menor séptima",
        tipoSemidisminuido: "semimenguáu",
        tipoSeptimaDisminuida: "séptima menguada",
        tipoMenorConSeptimaMayor: "menor con séptima mayor",
        tipoAumentadoConSeptimaMenor: "aumentáu con séptima menor",
        tipoAumentadoConSeptimaMayor: "aumentáu con séptima mayor",
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
        entreLasVoces: { nombres in "ente " + nombres.joined(separator: " y ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acordes \(pasos))" },
        enElAcorde: { acorde in "(acorde \(acorde + 1))" },
        quintasParalelas: "Quintes paraleles",
        octavasParalelas: "Octaves paraleles",
        quintasDirectas: "Quintes direutes",
        octavasDirectas: "Octaves direutes",
        cruceDeVoces: "Crucia de voces",
        superposicion: "Superposición",
        separacionExcesiva: "Más d\'una octava",
        saltoNoMelodico: "Saltu non melódicu",
        fueraDeTesitura: "Fuera de tesitura",
        vozBajo: "baxu",
        vozTenor: "tenor",
        vozContralto: "contraltu",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // Escala.swift
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
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) nel acorde \(n)" },
        pivote: "pivote",
        directa: " (direuta)"
    )
}
