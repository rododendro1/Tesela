import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

/// Los textos con valores (los campos de tipo cierre de los `TextosDeX`) dan algo en los quince idiomas.
///
/// `TextosDeX.en(notacion, …)` solo ejecuta el cierre del idioma de la notación, así que sin esta prueba los de
/// los idiomas que no prueba nadie no se ejecutarían nunca.
@Suite struct TextosConValoresTests {
    @Test func cadaTextoConValoresEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let textos = TextosDeNucleo.traducidos.texto(en: idioma)
            let resultados = [
                textos.multiplicidad(3),
                textos.simboloNoReconocido("x"),
                textos.tensionNoValida("x"),
                textos.numeroDeAcordeNoValido(3),
                textos.numeroRepetido(3),
                textos.gradoNoOmitible(3),
                textos.intervaloSinPapel(.terceraMayor, notacion),
                textos.bajoNoValido("x"),
                textos.idiomasMezclados("x"),
                textos.modoNoReconocido("x"),
                textos.tipoDeEscalaNoReconocido("x"),
                textos.noSePuedeLeer("x"),
                textos.caracter(3),
                textos.caracteresSobrantes("x"),
                textos.octavaNoValida("x"),
                textos.numeroDeIntervaloNoValido("x"),
                textos.calidadNoValida("x"),
                textos.intervaloInexistente(3, .mayor, notacion, TextosDeNucleo.traduccion(\.disonancia)),
                textos.alteracionNoReconocida("x"),
                textos.duracionNoValida("x"),
                textos.compasNoValido("x"),
                textos.contrapuntoDeOtraDuracion(3),
                textos.nombreDeIntervalo("x", "x"),
                textos.unisonoEnMasculino("x"),
                textos.ordinalEnCifras(3),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDeNucleo, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let textos = TextosDeTeoria.traducidos.texto(en: idioma)
            let resultados = [
                textos.conBajoEn("x", "x"),
                textos.papelTension(3),
                textos.acordeDesconocido(true, "x", "x"),
                textos.entreLasVoces(["x", "y"]),
                textos.enLaVoz("x"),
                textos.enLosAcordes("x"),
                textos.enElAcorde(3),
                textos.vozNumero(3),
                textos.cadenciaEnLosAcordes("x"),
                textos.deUnaTonalidadAOtra("x", "x", 3),
                textos.arpegioDe("x"),
                textos.acordeSobre("x", "x"),
                textos.enLaTonalidad("x"),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDeTeoria, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let textos = TextosDeRepresentaciones.traducidos.texto(en: idioma)
            let resultados = [
                textos.cicloDesde("x", "x"),
                textos.semitonos(3),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDeRepresentaciones, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let textos = TextosDePartitura.traducidos.texto(en: idioma)
            let resultados = [
                textos.enElCompas(3),
                textos.enLosCompases("x"),
                textos.especieConElContrapuntoEncima(3),
                textos.especieConElContrapuntoDebajo(3),
                textos.xmlDanado(3),
                textos.fraccionDeRedonda("x"),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDePartitura, texto \(i) en \(idioma)")
            }
        }
    }
}
