// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let aragones = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), con baixo en \(bajo)" },
        nombresDeLasInversiones: ["estau fundamental", "primera inversión", "segunda inversión", "tercera inversión",
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
        triadaDisminuida: "disminuida",
        triadaAumentada: "aumentada",
        triadaSuspendida: "suspendida",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sin tercera",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acorde \(vacio ? "mayor" : latino)" },
        tipoMayor: "mayor",
        tipoMenor: "menor",
        tipoDisminuido: "disminuiu",
        tipoAumentado: "aumentau",
        tipoSuspendidoDeSegunda: "suspendiu de segunda",
        tipoSuspendidoDeCuarta: "suspendiu de cuarta",
        tipoQuintaAcordeDePotencia: "quinta (acorde de potencia)",
        tipoSeptimaDeDominante: "séptima de dominant",
        tipoSeptimaMayor: "séptima mayor",
        tipoMenorSeptima: "menor séptima",
        tipoSemidisminuido: "semidisminuiu",
        tipoSeptimaDisminuida: "séptima disminuida",
        tipoMenorConSeptimaMayor: "menor con séptima mayor",
        tipoAumentadoConSeptimaMenor: "aumentau con séptima menor",
        tipoAumentadoConSeptimaMayor: "aumentau con séptima mayor",
        tipoSeptimaSuspendida: "séptima suspendida",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor sexta",
        tipoSextaYNovena: "sexta y novena",
        tipoNovenaDeDominante: "novena de dominant",
        tipoNovenaMayor: "novena mayor",
        tipoMenorNovena: "menor novena",
        tipoNovenaAnadida: "novena adhibida",
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
        separacionExcesiva: "Más d\'una octava",
        saltoNoMelodico: "Salto no melodico",
        fueraDeTesitura: "Difuera de tesitura",
        vozBajo: "baixo",
        vozTenor: "tenor",
        vozContralto: "contralto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voz \(numero)" },

        // Escala.swift
        gradoTonica: "tonica",
        gradoSupertonica: "supertonica",
        gradoMediante: "mediant",
        gradoSubdominante: "subdominant",
        gradoDominante: "dominant",
        gradoSuperdominante: "superdominant",
        gradoSensible: "sensible",
        gradoSubtonica: "subtonica",

        // AnalisisArmonico.swift
        funcionTonica: "tonica",
        funcionSubdominante: "subdominant",
        funcionDominante: "dominant",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "acordes \(pasos)" },
        cadenciaAutentica: "cadencia autentica",
        cadenciaPlagal: "cadencia plagal",
        cadenciaRota: "cadencia rota",
        semicadencia: "semicadencia",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) en l\'acorde \(n)" },
        pivote: "pivot",
        directa: " (directa)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpechio de \(acorde)" },
        patronAscendente: "ascendent",
        patronDescendente: "descendent",
        patronIdaYVuelta: "d'ida y tornada",
        patronAlberti: "baixo d'Alberti",
        patronQuebrado: "trencau",
        patronBajaYSube: "de baixada y puyada",
        // Rearmonizacion.swift
        sustitutoTritonal: "sustituto tritonal",
        dominanteSecundaria: "dominant secundaria",
        prestamoModal: "emprestamiento modal",
        sustitutoDiatonico: "sustituto diatonico",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
