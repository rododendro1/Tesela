// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaTeoria en euskera. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let euskera = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "baxua \(bajo) dela" },
        nombresDeLasInversiones: ["oinarrizko egoera", "lehen inbertsioa", "bigarren inbertsioa", "hirugarren inbertsioa",
                                  "laugarren inbertsioa", "bosgarren inbertsioa", "seigarren inbertsioa"],
        inversionConNumero: "_. inbertsioa",

        // EstructuraDeAcorde.swift
        papelFundamental: "oinarria",
        papelTercera: "hirugarrena",
        papelSuspension: "esekidura",
        papelQuinta: "bosgarrena",
        papelSexta: "seigarrena",
        papelSeptima: "zazpigarrena",
        papelNovena: "bederatzigarrena",
        papelUndecima: "hamaikagarrena",
        papelDecimotercera: "hamahirugarrena",
        papelTension: { n in "\(n). tentsioa" },
        triadaMayor: "handia",
        triadaMenor: "txikia",
        triadaDisminuida: "gutxitua",
        triadaAumentada: "gehitua",
        triadaSuspendida: "esekia",
        triadaDeQuinta: "bosgarrenekoa",
        triadaSinTercera: "hirugarrenik gabea",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in vacio ? "akorde maiorra" : "\(latino) akordea" },
        tipoMayor: "maiorra",
        tipoMenor: "minorra",
        tipoDisminuido: "gutxitua",
        tipoAumentado: "gehitua",
        tipoSuspendidoDeSegunda: "bigarrenera esekia",
        tipoSuspendidoDeCuarta: "laugarrenera esekia",
        tipoQuintaAcordeDePotencia: "bosgarrena (potentzia-akordea)",
        tipoSeptimaDeDominante: "dominanteko zazpigarrena",
        tipoSeptimaMayor: "zazpigarren handia",
        tipoMenorSeptima: "minor zazpigarrena",
        tipoSemidisminuido: "erdi-gutxitua",
        tipoSeptimaDisminuida: "zazpigarren gutxitua",
        tipoMenorConSeptimaMayor: "minorra zazpigarren handiarekin",
        tipoAumentadoConSeptimaMenor: "gehitua zazpigarren txikiarekin",
        tipoAumentadoConSeptimaMayor: "gehitua zazpigarren handiarekin",
        tipoSeptimaSuspendida: "zazpigarren esekia",
        tipoSexta: "seigarrena",
        tipoMenorSexta: "minor seigarrena",
        tipoSextaYNovena: "seigarrena eta bederatzigarrena",
        tipoNovenaDeDominante: "dominanteko bederatzigarrena",
        tipoNovenaMayor: "bederatzigarren handia",
        tipoMenorNovena: "minor bederatzigarrena",
        tipoNovenaAnadida: "bederatzigarren gehigarria",
        tipoUndecima: "hamaikagarrena",
        tipoMenorUndecima: "minor hamaikagarrena",
        tipoDecimotercera: "hamahirugarrena",
        tipoMenorDecimotercera: "minor hamahirugarrena",
        tipoSeptimaConNovenaMenor: "zazpigarrena bederatzigarren txikiarekin",
        tipoSextaAumentadaItaliana: "seigarren gehitu italiarra",
        tipoSextaAumentadaFrancesa: "seigarren gehitu frantsesa",
        tipoSextaAumentadaAlemana: "seigarren gehitu alemana",

        // Coral.swift
        entreLasVoces: { nombres in nombres.joined(separator: " eta ") },
        enLaVoz: { primera in primera },
        enLosAcordes: { pasos in "(\(pasos) akordeak)" },
        enElAcorde: { acorde in "(\(acorde + 1). akordea)" },
        quintasParalelas: "Bosgarren paraleloak",
        octavasParalelas: "Zortzidun paraleloak",
        quintasDirectas: "Bosgarren zuzenak",
        octavasDirectas: "Zortzidun zuzenak",
        cruceDeVoces: "Ahotsen gurutzatzea",
        superposicion: "Gainjartzea",
        separacionExcesiva: "Zortzidun bat baino gehiago",
        saltoNoMelodico: "Jauzi ez-melodikoa",
        fueraDeTesitura: "Tesituratik kanpo",
        vozBajo: "baxua",
        vozTenor: "tenorra",
        vozContralto: "altua",
        vozSoprano: "sopranoa",
        vozNumero: { numero in "\(numero). ahotsa" },

        // Escala.swift
        gradoTonica: "tonika",
        gradoSupertonica: "supertonika",
        gradoMediante: "mediantea",
        gradoSubdominante: "subdominantea",
        gradoDominante: "dominantea",
        gradoSuperdominante: "superdominantea",
        gradoSensible: "sentsiblea",
        gradoSubtonica: "subtonika",

        // AnalisisArmonico.swift
        funcionTonica: "tonika",
        funcionSubdominante: "subdominantea",
        funcionDominante: "dominantea",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "\(pasos) akordeak" },
        cadenciaAutentica: "kadentzia autentikoa",
        cadenciaPlagal: "kadentzia plagala",
        cadenciaRota: "kadentzia hautsia",
        semicadencia: "erdi-kadentzia",

        // RecorridoTonal.swift
        // Con el ablativo y el adlativo: "Do maiorretik sol maiorrera, 5. akordean".
        deUnaTonalidadAOtra: { de, a, n in
            Tonalidad.declinar(de, "etik").conMayusculaInicial + " " + Tonalidad.declinar(a, "era") + ", \(n). akordean"
        },
        pivote: "pibota",
        directa: " (zuzena)"
    )
}
