// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en catalán. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let catalan = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), amb el baix en \(bajo)" },
        nombresDeLasInversiones: ["estat fonamental", "primera inversió", "segona inversió", "tercera inversió",
                                  "quarta inversió", "cinquena inversió", "sisena inversió"],
        inversionConNumero: "inversió _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fonamental",
        papelTercera: "tercera",
        papelSuspension: "suspensió",
        papelQuinta: "quinta",
        papelSexta: "sexta",
        papelSeptima: "sèptima",
        papelNovena: "novena",
        papelUndecima: "onzena",
        papelDecimotercera: "tretzena",
        papelTension: { n in "tensió \(n)a" },
        triadaMayor: "major",
        triadaMenor: "menor",
        triadaDisminuida: "disminuïda",
        triadaAumentada: "augmentada",
        triadaSuspendida: "suspesa",
        triadaDeQuinta: "de quinta",
        triadaSinTercera: "sense tercera",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "acord \(vacio ? "major" : latino)" },
        tipoMayor: "major",
        tipoMenor: "menor",
        tipoDisminuido: "disminuït",
        tipoAumentado: "augmentat",
        tipoSuspendidoDeSegunda: "suspès de segona",
        tipoSuspendidoDeCuarta: "suspès de quarta",
        tipoQuintaAcordeDePotencia: "quinta (acord de potència)",
        tipoSeptimaDeDominante: "sèptima de dominant",
        tipoSeptimaMayor: "sèptima major",
        tipoMenorSeptima: "menor sèptima",
        tipoSemidisminuido: "semidisminuït",
        tipoSeptimaDisminuida: "sèptima disminuïda",
        tipoMenorConSeptimaMayor: "menor amb sèptima major",
        tipoAumentadoConSeptimaMenor: "augmentat amb sèptima menor",
        tipoAumentadoConSeptimaMayor: "augmentat amb sèptima major",
        tipoSeptimaSuspendida: "sèptima suspesa",
        tipoSexta: "sexta",
        tipoMenorSexta: "menor sexta",
        tipoSextaYNovena: "sexta i novena",
        tipoNovenaDeDominante: "novena de dominant",
        tipoNovenaMayor: "novena major",
        tipoMenorNovena: "menor novena",
        tipoNovenaAnadida: "novena afegida",
        tipoUndecima: "onzena",
        tipoMenorUndecima: "menor onzena",
        tipoDecimotercera: "tretzena",
        tipoMenorDecimotercera: "menor tretzena",
        tipoSeptimaConNovenaMenor: "sèptima amb novena menor",
        tipoSextaAumentadaItaliana: "sexta augmentada italiana",
        tipoSextaAumentadaFrancesa: "sexta augmentada francesa",
        tipoSextaAumentadaAlemana: "sexta augmentada alemanya",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " i ") },
        enLaVoz: { primera in "en \(primera)" },
        enLosAcordes: { pasos in "(acords \(pasos))" },
        enElAcorde: { acorde in "(acord \(acorde + 1))" },
        quintasParalelas: "Quintes paral·leles",
        octavasParalelas: "Octaves paral·leles",
        quintasDirectas: "Quintes directes",
        octavasDirectas: "Octaves directes",
        cruceDeVoces: "Encreuament de veus",
        superposicion: "Superposició",
        separacionExcesiva: "Més d'una octava",
        saltoNoMelodico: "Salt no melòdic",
        fueraDeTesitura: "Fora de tessitura",
        vozBajo: "baix",
        vozTenor: "tenor",
        vozContralto: "contralt",
        vozSoprano: "soprano",
        vozNumero: { numero in "veu \(numero)" },

        // Escala.swift
        gradoTonica: "tònica",
        gradoSupertonica: "supertònica",
        gradoMediante: "mediant",
        gradoSubdominante: "subdominant",
        gradoDominante: "dominant",
        gradoSuperdominante: "superdominant",
        gradoSensible: "sensible",
        gradoSubtonica: "subtònica",

        // AnalisisArmonico.swift
        funcionTonica: "tònica",
        funcionSubdominante: "subdominant",
        funcionDominante: "dominant",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "acords \(pasos)" },
        cadenciaAutentica: "cadència autèntica",
        cadenciaPlagal: "cadència plagal",
        cadenciaRota: "cadència trencada",
        semicadencia: "semicadència",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) a \(a) a l'acord \(n)" },
        pivote: "pivot",
        directa: " (directa)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpegi de \(acorde)" },
        patronAscendente: "ascendent",
        patronDescendente: "descendent",
        patronIdaYVuelta: "d'anada i tornada",
        patronAlberti: "baix d'Alberti",
        patronQuebrado: "trencat",
        patronBajaYSube: "de baixada i pujada",
        // Rearmonizacion.swift
        sustitutoTritonal: "substitut de trítò",
        dominanteSecundaria: "dominant secundària",
        prestamoModal: "manlleu modal",
        sustitutoDiatonico: "substitut diatònic",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
