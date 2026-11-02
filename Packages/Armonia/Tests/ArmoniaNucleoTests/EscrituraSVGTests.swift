import Testing

@testable import ArmoniaNucleo

@Suite struct EscrituraSVGTests {
    @Test func numeros() {
        #expect(NumerosSVG.unDecimal.texto(3) == "3.0")
        #expect(NumerosSVG.unDecimal.texto(-0.46) == "-0.5")
        #expect(NumerosSVG.hastaTresDecimales.texto(3) == "3")
        #expect(NumerosSVG.hastaTresDecimales.texto(0.1254) == "0.125")
        #expect(NumerosSVG.hastaTresDecimales.texto(-0.0001) == "0")
    }

    @Test func elementos() {
        let circulo = ElementoSVG("circle").con("cx", 10).con("cy", 5.25).con("fill", "#ffffff")
        #expect(circulo.vacio == ##"<circle cx="10.0" cy="5.2" fill="#ffffff"/>"##)
        #expect(circulo.apertura == ##"<circle cx="10.0" cy="5.2" fill="#ffffff">"##)
        let poligono = ElementoSVG("polygon", numeros: .hastaTresDecimales).con("points", puntos: [(0, 1), (2.5, 3)])
        #expect(poligono.vacio == #"<polygon points="0,1 2.5,3"/>"#)
        #expect(ElementoSVG("g").con("fill", "red", si: false).conHijos("<title/>") == "<g><title/></g>")
        #expect(ElementoSVG("g").con("fill", "red", si: true).apertura == #"<g fill="red">"#)
    }

    @Test func escapaElTextoYLosAtributos() {
        #expect(ElementoSVG("text").con("class", "a\"b").conTexto("Do & <Mi>") == #"<text class="a&quot;b">Do &amp; &lt;Mi&gt;</text>"#)
    }
}
