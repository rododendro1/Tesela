// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// Los textos de ArmoniaTeoria en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let hungaro = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), \(bajo) a basszusban" },
        nombresDeLasInversiones: ["alaphelyzet", "első fordítás", "második fordítás", "harmadik fordítás",
                                  "negyedik fordítás", "ötödik fordítás", "hatodik fordítás"],
        inversionConNumero: "_. fordítás",

        // EstructuraDeAcorde.swift
        papelFundamental: "alaphang",
        papelTercera: "terc",
        papelSuspension: "késleltetés",
        papelQuinta: "kvint",
        papelSexta: "szext",
        papelSeptima: "szeptim",
        papelNovena: "nóna",
        papelUndecima: "undecima",
        papelDecimotercera: "tercdecima",
        papelTension: { n in Intervalo.ordinal(n, en: .hungaro) },
        triadaMayor: "dúr",
        triadaMenor: "moll",
        triadaDisminuida: "szűkített",
        triadaAumentada: "bővített",
        triadaSuspendida: "felfüggesztett",
        triadaDeQuinta: "kvintakkord",
        triadaSinTercera: "terc nélkül",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in vacio ? "dúr hármashangzat" : "\(propio) akkord" },
        tipoMayor: "dúr",
        tipoMenor: "moll",
        tipoDisminuido: "szűkített",
        tipoAumentado: "bővített",
        tipoSuspendidoDeSegunda: "felfüggesztett szekund",
        tipoSuspendidoDeCuarta: "felfüggesztett kvart",
        tipoQuintaAcordeDePotencia: "kvintakkord",
        tipoSeptimaDeDominante: "domináns szeptimakkord",
        tipoSeptimaMayor: "nagy szeptimakkord",
        tipoMenorSeptima: "moll szeptimakkord",
        tipoSemidisminuido: "félszűkített szeptimakkord",
        tipoSeptimaDisminuida: "szűkített szeptimakkord",
        tipoMenorConSeptimaMayor: "moll nagy szeptimakkord",
        tipoAumentadoConSeptimaMenor: "bővített szeptimakkord",
        tipoAumentadoConSeptimaMayor: "bővített nagy szeptimakkord",
        tipoSeptimaSuspendida: "domináns szeptimakkord felfüggesztett kvarttal",
        tipoSexta: "dúr hozzáadott szexttel",
        tipoMenorSexta: "moll hozzáadott szexttel",
        tipoSextaYNovena: "dúr hozzáadott szexttel és nónával",
        tipoNovenaDeDominante: "domináns nónakkord",
        tipoNovenaMayor: "nagy nónakkord",
        tipoMenorNovena: "moll nónakkord",
        tipoNovenaAnadida: "dúr hozzáadott nónával",
        tipoUndecima: "domináns undecimakkord",
        tipoMenorUndecima: "moll undecimakkord",
        tipoDecimotercera: "domináns tercdecimakkord",
        tipoMenorDecimotercera: "moll tercdecimakkord",
        tipoSeptimaConNovenaMenor: "domináns szeptimakkord kis nónával",
        tipoSextaAumentadaItaliana: "olasz bővített szextakkord",
        tipoSextaAumentadaFrancesa: "francia bővített szextakkord",
        tipoSextaAumentadaAlemana: "német bővített szextakkord",

        // Coral.swift
        entreLasVoces: { nombres in nombres.map(\.conArticuloHungaro).joined(separator: " és ") + " között" },
        enLaVoz: { primera in primera.conArticuloHungaro + "ban" },
        enLosAcordes: { pasos in "(akkordok: \(pasos))" },
        enElAcorde: { acorde in "(\(acorde + 1). akkord)" },
        quintasParalelas: "Párhuzamos kvintek",
        octavasParalelas: "Párhuzamos oktávok",
        quintasDirectas: "Rejtett kvintek",
        octavasDirectas: "Rejtett oktávok",
        cruceDeVoces: "Szólamkeresztezés",
        superposicion: "Szólamátfedés",
        separacionExcesiva: "Egy oktávnál nagyobb távolság",
        saltoNoMelodico: "Dallamtalan ugrás",
        fueraDeTesitura: "Hangterjedelmen kívül",
        vozBajo: "basszus",
        vozTenor: "tenor",
        vozContralto: "alt",
        vozSoprano: "szoprán",
        vozNumero: { numero in "\(numero). szólam" },

        // Escala.swift
        gradoTonica: "tonika",
        gradoSupertonica: "szupertonika",
        gradoMediante: "mediáns",
        gradoSubdominante: "szubdomináns",
        gradoDominante: "domináns",
        gradoSuperdominante: "szubmediáns",
        gradoSensible: "vezetőhang",
        gradoSubtonica: "szubtonika",

        // AnalisisArmonico.swift
        funcionTonica: "tonika",
        funcionSubdominante: "szubdomináns",
        funcionDominante: "domináns",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "akkordok: \(pasos)" },
        cadenciaAutentica: "autentikus zárlat",
        cadenciaPlagal: "plagális zárlat",
        cadenciaRota: "megszakított zárlat",
        semicadencia: "félzárlat",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "\(de)ból \(a)ba (\(n). akkord)" },
        pivote: "közvetítő akkord",
        directa: " (közvetlen)",
        // Arpegio.swift
        arpegioDe: { acorde in "\(acorde) akkordfelbontás" },
        patronAscendente: "felfelé",
        patronDescendente: "lefelé",
        patronIdaYVuelta: "fel és le",
        patronAlberti: "Alberti-basszus",
        patronQuebrado: "tört",
        patronBajaYSube: "le és fel",
        // Rearmonizacion.swift
        sustitutoTritonal: "tritónuszhelyettesítés",
        dominanteSecundaria: "mellékdomináns",
        prestamoModal: "modális kölcsönzés",
        sustitutoDiatonico: "diatonikus helyettesítés",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        // Con el inesivo: «C-dúrban», «a-mollban» (dúr y moll piden -ban).
        enLaTonalidad: { tonalidad in tonalidad + "ban" }
    )
}
