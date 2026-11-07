import Foundation
import Testing

@testable import Diagramas
@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Polifonia
@testable import Teoria
@testable import Trastes

/// Los textos con valores (los campos de tipo cierre de los `TextosDeX`) dan algo en los trece idiomas.
///
/// `TextosDeX.en(notacion, …)` solo ejecuta el cierre del idioma de la notación, así que sin esta prueba los de
/// los idiomas que no prueba nadie no se ejecutarían nunca.
@Suite struct TextosConValoresTests {
    @Test func cadaTextoConValoresEnCadaIdioma() {
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let textos = TextosDeElementos.traducidos.texto(en: idioma)
            let resultados = [
                textos.multiplicidad(3),
                textos.noSePuedeLeer("x"),
                textos.caracter(3),
                textos.caracteresSobrantes("x"),
                textos.octavaNoValida("x"),
                textos.numeroDeIntervaloNoValido("x"),
                textos.calidadNoValida("x"),
                textos.intervaloInexistente(3, .mayor, notacion, TextosDeElementos.traduccion(\.disonancia)),
                textos.alteracionNoReconocida("x"),
                textos.nombreDeIntervalo("x", "x"),
                textos.unisonoEnMasculino("x"),
                textos.ordinalEnCifras(3),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDeElementos, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let textos = TextosDeTeoria.traducidos.texto(en: idioma)
            let resultados = [
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
                textos.conBajoEn("x", "x"),
                textos.papelTension(3),
                textos.acordeDesconocido(true, "x", "x"),
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
            let textos = TextosDeDiagramas.traducidos.texto(en: idioma)
            let resultados = [
                textos.cicloDesde("x", "x"),
                TextosDeTeoria.traducidos.texto(en: idioma).semitonos(3),
                textos.uilNoValido("x"),
                textos.intervalosIncoherentes(1, 2, 3),
                textos.giroNoValido(45),
                textos.afinacionNoSoportada(19),
                textos.cizallaNoSoportada(2),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDeDiagramas, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let textos = TextosDePolifonia.traducidos.texto(en: idioma)
            let resultados = [
                textos.entreLasVoces(["x", "y"]),
                textos.enLaVoz("x"),
                textos.enLosAcordes("x"),
                textos.enElAcorde(3),
                textos.vozNumero(3),
                textos.enElCompas(3),
                textos.enLosCompases("x"),
                textos.especieConElContrapuntoEncima(3),
                textos.especieConElContrapuntoDebajo(3),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDePolifonia, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let textos = TextosDePartituras.traducidos.texto(en: idioma)
            let resultados = [
                textos.fraccionDeRedonda("x"),
                textos.duracionNoValida("x"),
                textos.compasNoValido("x"),
                textos.contrapuntoDeOtraDuracion(3),
            ]
            for (i, texto) in resultados.enumerated() {
                #expect(!texto.isEmpty, "TextosDePartituras, texto \(i) en \(idioma)")
            }
        }
        for idioma in Idioma.allCases {
            let texto = TextosDeFormatos.traducidos.texto(en: idioma).xmlDanado(3)
            #expect(!texto.isEmpty, "TextosDeFormatos, xmlDanado en \(idioma)")
        }
    }
}
