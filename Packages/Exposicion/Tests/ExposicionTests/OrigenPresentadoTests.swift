import Armonia
import Exposicion
import Testing

/// El origen escrito de los elementos de los catálogos con nombre (`OrigenPresentado`).
@Suite struct OrigenPresentadoTests {
    /// El año, la época y la obra, iguales en todos los catálogos.
    @Test func elOrigenDeCadaCatalogo() throws {
        let notacion = Notacion.compacta(.espanol)
        let werckmeister = try #require(OrigenPresentado(TemperamentoConNombre.werckmeisterIII, en: notacion))
        #expect(werckmeister.anio == 1691 && werckmeister.epoca == "Barroco")
        #expect(werckmeister.texto == "Barroco (1691)")
        #expect(werckmeister.datos(en: notacion).map(\.valor) == ["Barroco (1691)"])
        let salinas = try #require(OrigenPresentado(TemperamentoConNombre.mesotonicoTercioDeComa, en: notacion))
        #expect(salinas.anio == 1577 && salinas.documentada == Referencia.salinas1577.cita)
        #expect(OrigenPresentado(TemperamentoConNombre.pitagorico, en: notacion) == nil)
        #expect(OrigenPresentado(FuncionDeNota.dominante, en: notacion) == nil)
        #expect(OrigenPresentado(RitmoConNombre.charleston, en: notacion)?.anio == 1923)
        // El de una escala es el mismo que da `OrigenDeEscalaPresentado`.
        let hungara = try #require(OrigenDeEscalaPresentado(.menorHungara, en: notacion))
        #expect(OrigenPresentado(TipoDeEscala.menorHungara, en: notacion) == hungara.origen)
        #expect(hungara.datos(en: notacion).first?.valor == hungara.origen?.texto)
    }

    /// Los seis catálogos presentados llevan lo mismo: el nombre, los alias, las citas y el origen.
    @Test func losCatalogosPresentados() {
        let notacion = Notacion.compacta(.espanol)
        let tristan = AcordeConNombrePresentado(.tristan, sobre: .fa, en: notacion)
        #expect(tristan.notas == ["Fa", "Si", "Re♯", "Sol♯"] && tristan.cifrado == nil)
        #expect(tristan.origen?.texto == "Romanticismo (1859)")
        #expect(tristan.estilosYOrigen == "clásica · Romanticismo (1859)")
        #expect(AcordeConNombrePresentado(.dominanteSeptima, en: notacion).cifrado == "Do7")
        let andaluza = ProgresionConNombrePresentada(.andaluza, sobre: .la, en: notacion)
        #expect(andaluza.cifrado == "i VII VI V" && andaluza.acordes == ["Lam", "Sol", "Fa", "Mi"])
        let solea = RitmoPresentado(.solea, en: notacion)
        #expect(solea.estilos == ["flamenco"] && solea.alias == ["soleares"])
        let otros = solea.datosDelCatalogo(en: notacion).first
        #expect(otros?.nombre == "Otros nombres" && otros?.valor == "soleares")
        let werckmeister = TemperamentoPresentado(.werckmeisterIII, en: notacion)
        #expect(werckmeister.referencias.first == Referencia.werckmeister1691.cita)
        #expect(werckmeister.datosDelCatalogo(en: notacion).last?.valor == "Barroco (1691)")
        #expect(FuncionDeNotaPresentada(.dominante, en: notacion).origen == nil)
    }
}
