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
        // Escala+Acorde.swift
        papelNotaDelAcorde: "nota de l'acord",
        papelTensionDisponible: "tensió",
        papelNotaAEvitar: "nota a evitar",
        modoDe: { modo, escala in "mode \(modo) de \(escala)" },
        // NotaExtrana.swift
        nombresDeNotasExtranas: ["nota de pas", "brodadura", "appoggiatura", "retard", "anticipació", "escapada", "nota pedal", "nota lliure"],
        // Rearmonizacion.swift
        sustitutoTritonal: "substitut de trítò",
        dominanteSecundaria: "dominant secundària",
        prestamoModal: "manlleu modal",
        sustitutoDiatonico: "substitut diatònic",
        // ErrorDeLecturaDeTeoria.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» no forma part de cap xifrat conegut" },
        tensionNoValida: { tension in "«\(tension)» no és una tensió vàlida (s'admeten ♭/♯ amb 5, 9, 11 i 13, i add amb 2, 4, 6, 9, 11 i 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» no és un número d'acord (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» apareix després d'un altre número; les tensions addicionals van entre parèntesis, com a 7(9)" },
        disminuidoYSemidisminuido: "disminuït (°) i semidisminuït (ø) no es poden combinar",
        quintaConCalidad: "l'acord de quinta (5) no porta tercera, així que no admet m, °, ø ni +",
        fundamentalNoOmitible: "no es pot ometre la fonamental",
        gradoNoOmitible: { grado in "«omit\(grado)» no és vàlid (es poden ometre 3, 5, 7, 9, 11 i 13)" },
        faltaLaFundamental: "falta la fonamental",
        intervaloSinPapel: { intervalo, notacion in "la \(intervalo.nombre(en: .catalanPalabras)) no té cap paper en un acord per terceres" },
        terceraMayorYMenor: "té tercera major i menor alhora (la ♯9 s'escriu com a 9a augmentada, no com a 3a menor)",
        variasSeptimas: "té més d'una sèptima",
        septimaDisminuidaFueraDelDisminuido: "la sèptima disminuïda només apareix a l'acord disminuït (amb 3a menor i 5a disminuïda)",
        noEsPorTerceras: "no és un acord per terceres",
        bajoNoValido: { bajo in "«\(bajo)» no és un nom de nota per al baix" },
        idiomasMezclados: { nombre in "«\(nombre)» està escrit en un altre idioma que la fonamental: s'escriu tot amb síl·labes (Sol7/Si) o tot amb lletres (G7/B)" },
        // ErrorDeLecturaDeTeoria.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» no és el mode d'una tonalitat: una tonalitat és major o menor (per als altres modes, fes servir Escala)" },
        faltaElTipoDeEscala: "falta el tipus d'escala (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» no és un tipus d'escala conegut" },
        // ErrorDeLecturaDeTeoria.swift (coral)
        vocesDistintas: "tots els acords han de tenir el mateix nombre de veus, i almenys dues",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
