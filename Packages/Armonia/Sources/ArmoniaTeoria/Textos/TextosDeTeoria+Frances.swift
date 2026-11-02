// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en francés. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let frances = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), avec la basse en \(bajo)" },
        nombresDeLasInversiones: ["état fondamental", "premier renversement", "deuxième renversement", "troisième renversement",
                                  "quatrième renversement", "cinquième renversement", "sixième renversement"],
        inversionConNumero: "renversement _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fondamentale",
        papelTercera: "tierce",
        papelSuspension: "suspension",
        papelQuinta: "quinte",
        papelSexta: "sixte",
        papelSeptima: "septième",
        papelNovena: "neuvième",
        papelUndecima: "onzième",
        papelDecimotercera: "treizième",
        papelTension: { n in "tension \(n)e" },
        triadaMayor: "majeure",
        triadaMenor: "mineure",
        triadaDisminuida: "diminuée",
        triadaAumentada: "augmentée",
        triadaSuspendida: "suspendue",
        triadaDeQuinta: "de quinte",
        triadaSinTercera: "sans tierce",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "accord \(vacio ? "majeur" : latino)" },
        tipoMayor: "majeur",
        tipoMenor: "mineur",
        tipoDisminuido: "diminué",
        tipoAumentado: "augmenté",
        tipoSuspendidoDeSegunda: "suspendu de seconde",
        tipoSuspendidoDeCuarta: "suspendu de quarte",
        tipoQuintaAcordeDePotencia: "quinte (accord de puissance)",
        tipoSeptimaDeDominante: "septième de dominante",
        tipoSeptimaMayor: "septième majeure",
        tipoMenorSeptima: "mineur septième",
        tipoSemidisminuido: "semi-diminué",
        tipoSeptimaDisminuida: "septième diminuée",
        tipoMenorConSeptimaMayor: "mineur septième majeure",
        tipoAumentadoConSeptimaMenor: "augmenté septième mineure",
        tipoAumentadoConSeptimaMayor: "augmenté septième majeure",
        tipoSeptimaSuspendida: "septième suspendue",
        tipoSexta: "sixte ajoutée",
        tipoMenorSexta: "mineur sixte",
        tipoSextaYNovena: "sixte et neuvième",
        tipoNovenaDeDominante: "neuvième de dominante",
        tipoNovenaMayor: "neuvième majeure",
        tipoMenorNovena: "mineur neuvième",
        tipoNovenaAnadida: "neuvième ajoutée",
        tipoUndecima: "onzième",
        tipoMenorUndecima: "mineur onzième",
        tipoDecimotercera: "treizième",
        tipoMenorDecimotercera: "mineur treizième",
        tipoSeptimaConNovenaMenor: "septième avec neuvième mineure",
        tipoSextaAumentadaItaliana: "sixte augmentée italienne",
        tipoSextaAumentadaFrancesa: "sixte augmentée française",
        tipoSextaAumentadaAlemana: "sixte augmentée allemande",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " et ") },
        enLaVoz: { primera in "(\(primera))" },
        enLosAcordes: { pasos in "(accords \(pasos))" },
        enElAcorde: { acorde in "(accord \(acorde + 1))" },
        quintasParalelas: "Quintes parallèles",
        octavasParalelas: "Octaves parallèles",
        quintasDirectas: "Quintes directes",
        octavasDirectas: "Octaves directes",
        cruceDeVoces: "Croisement de voix",
        superposicion: "Chevauchement",
        separacionExcesiva: "Plus d'une octave",
        saltoNoMelodico: "Saut non mélodique",
        fueraDeTesitura: "Hors tessiture",
        vozBajo: "basse",
        vozTenor: "ténor",
        vozContralto: "alto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voix \(numero)" },

        // Escala.swift
        gradoTonica: "tonique",
        gradoSupertonica: "sus-tonique",
        gradoMediante: "médiante",
        gradoSubdominante: "sous-dominante",
        gradoDominante: "dominante",
        gradoSuperdominante: "sus-dominante",
        gradoSensible: "sensible",
        gradoSubtonica: "sous-tonique",

        // AnalisisArmonico.swift
        funcionTonica: "tonique",
        funcionSubdominante: "sous-dominante",
        funcionDominante: "dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "accords \(pasos)" },
        cadenciaAutentica: "cadence parfaite",
        cadenciaPlagal: "cadence plagale",
        cadenciaRota: "cadence rompue",
        semicadencia: "demi-cadence",
        semicadenciaFrigia: "demi-cadence phrygienne",
        cadenciaPlagalMenor: "cadence plagale mineure",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) à \(a) à l'accord \(n)" },
        pivote: "pivot",
        directa: " (directe)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpège de \(acorde)" },
        patronAscendente: "ascendant",
        patronDescendente: "descendant",
        patronIdaYVuelta: "aller-retour",
        patronAlberti: "basse d'Alberti",
        patronQuebrado: "brisé",
        patronBajaYSube: "descente-montée",
        aproximacionDesdeAbajo: "par en dessous",
        aproximacionDesdeArriba: "par au-dessus",
        aproximacionEncierro: "encerclement",
        // Escala+Acorde.swift
        papelNotaDelAcorde: "note de l'accord",
        papelTensionDisponible: "tension",
        papelNotaAEvitar: "note à éviter",
        modoDe: { modo, escala in "mode \(modo) de \(escala)" },
        // NotaExtrana.swift
        nombresDeNotasExtranas: ["note de passage", "broderie", "appoggiature", "retard", "anticipation", "échappée", "pédale", "note libre"],
        // EsquemaArmonico.swift
        nombresDeEsquemas: ["ii–V–I", "ii–V", "turnaround", "backdoor", "blues de 12 mesures", "marche de quintes", "romanesca", "canon de Pachelbel", "monte", "fonte", "ponte"],
        // Rearmonizacion.swift
        sustitutoTritonal: "substitution tritonique",
        dominanteSecundaria: "dominante secondaire",
        prestamoModal: "emprunt modal",
        sustitutoDiatonico: "substitution diatonique",
        rearmonizacionIIV: "ii–V",
        rearmonizacionBackdoor: "dominante backdoor",
        rearmonizacionIIRelativo: "ii relatif",
        rearmonizacionDisminuido: "substitution diminuée",
        // ErrorDeLecturaDeTeoria.swift (acordes)
        simboloNoReconocido: { simbolo in "« \(simbolo) » ne fait partie d'aucun chiffrage connu" },
        tensionNoValida: { tension in "« \(tension) » n'est pas une tension valide (♭/♯ s'emploient avec 5, 9, 11 et 13, et add avec 2, 4, 6, 9, 11 et 13)" },
        numeroDeAcordeNoValido: { numero in "« \(numero) » n'est pas un numéro d'accord (5, 6, 7, 9, 11 ou 13)" },
        numeroRepetido: { numero in "« \(numero) » suit un autre numéro ; les tensions supplémentaires se mettent entre parenthèses, comme dans 7(9)" },
        disminuidoYSemidisminuido: "diminué (°) et semi-diminué (ø) ne peuvent pas se combiner",
        quintaConCalidad: "l'accord de quinte (5) n'a pas de tierce, il n'admet donc ni m, ni °, ni ø, ni +",
        fundamentalNoOmitible: "on ne peut pas omettre la fondamentale",
        gradoNoOmitible: { grado in "« omit\(grado) » n'est pas valide (on peut omettre 3, 5, 7, 9, 11 et 13)" },
        faltaLaFundamental: "il manque la fondamentale",
        intervaloSinPapel: { intervalo, notacion in "l'intervalle de \(intervalo.nombre(en: .francesPalabras)) n'a aucun rôle dans un accord par tierces" },
        terceraMayorYMenor: "il a à la fois une tierce majeure et une tierce mineure (la ♯9 s'écrit comme neuvième augmentée, pas comme tierce mineure)",
        variasSeptimas: "il a plus d'une septième",
        septimaDisminuidaFueraDelDisminuido: "la septième diminuée n'apparaît que dans l'accord diminué (avec tierce mineure et quinte diminuée)",
        noEsPorTerceras: "ce n'est pas un accord par tierces",
        bajoNoValido: { bajo in "« \(bajo) » n'est pas un nom de note pour la basse" },
        idiomasMezclados: { nombre in "« \(nombre) » est écrit dans une autre langue que la fondamentale : on écrit tout en syllabes (Sol7/Si) ou tout en lettres (G7/B)" },
        // ErrorDeLecturaDeTeoria.swift (escalas)
        modoNoReconocido: { nombre in "« \(nombre) » n'est pas le mode d'une tonalité : une tonalité est majeure ou mineure (pour les autres modes, utilisez Escala)" },
        faltaElTipoDeEscala: "il manque le type de gamme (majeur, dorien, mineur harmonique…)",
        tipoDeEscalaNoReconocido: { nombre in "« \(nombre) » n'est pas un type de gamme connu" },
        // ErrorDeLecturaDeTeoria.swift (coral)
        vocesDistintas: "tous les accords doivent avoir le même nombre de voix, et au moins deux",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
