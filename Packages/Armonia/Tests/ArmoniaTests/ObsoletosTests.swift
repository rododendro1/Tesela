import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

// Los nombres de antes (`Obsoletos.swift` de cada módulo) siguen dando lo mismo que los nuevos hasta que se quiten.
// Se usan a propósito, así que estas pruebas compilan con avisos de obsoleto.

@Suite struct ObsoletosTests {
    @available(*, deprecated)
    @Test func lasEscalasOccidentales() {
        #expect(TipoDeEscala.todos == TipoDeEscala.occidentales)
        #expect(TipoDeEscala.todos(uso: .blues) == TipoDeEscala.occidentales(uso: .blues))
    }

    @available(*, deprecated)
    @Test func leerSinError() {
        #expect(Acorde(texto: "Sol7/Si") == Acorde("Sol7/Si"))
        #expect(Acorde(texto: "Do7(b3)") == nil)
    }

    @available(*, deprecated)
    @Test func invertirUnAcorde() {
        #expect(Acorde("Do7").invertir(1) == Acorde("Do7").cambiarInversion(1))
    }

    @available(*, deprecated)
    @Test func lasNotacionesConNombreDeCadaIdioma() {
        let notaciones: [(Notacion, Notacion)] = [
            (Notacion.catalanPalabras, Notacion.conPalabras(.catalan)),
            (Notacion.gallegoPalabras, Notacion.conPalabras(.gallego)),
            (Notacion.asturianoPalabras, Notacion.conPalabras(.asturiano)),
            (Notacion.aragonesPalabras, Notacion.conPalabras(.aragones)),
            (Notacion.euskeraPalabras, Notacion.conPalabras(.euskera)),
            (Notacion.portuguesPalabras, Notacion.conPalabras(.portugues)),
            (Notacion.francesPalabras, Notacion.conPalabras(.frances)),
            (Notacion.occitanoPalabras, Notacion.conPalabras(.occitano)),
            (Notacion.italianoPalabras, Notacion.conPalabras(.italiano)),
            (Notacion.alemanPalabras, Notacion.conPalabras(.aleman)),
            (Notacion.griegoPalabras, Notacion.conPalabras(.griego)),
            (Notacion.rusoPalabras, Notacion.conPalabras(.ruso)),
            (Notacion.hungaroPalabras, Notacion.conPalabras(.hungaro)),
            (Notacion.catalanCompacto, Notacion.compacta(.catalan)),
            (Notacion.gallegoCompacto, Notacion.compacta(.gallego)),
            (Notacion.asturianoCompacto, Notacion.compacta(.asturiano)),
            (Notacion.aragonesCompacto, Notacion.compacta(.aragones)),
            (Notacion.euskeraCompacto, Notacion.compacta(.euskera)),
            (Notacion.portuguesCompacto, Notacion.compacta(.portugues)),
            (Notacion.francesCompacto, Notacion.compacta(.frances)),
            (Notacion.occitanoCompacto, Notacion.compacta(.occitano)),
            (Notacion.italianoCompacto, Notacion.compacta(.italiano)),
            (Notacion.alemanCompacto, Notacion.compacta(.aleman)),
            (Notacion.griegoCompacto, Notacion.compacta(.griego)),
            (Notacion.rusoCompacto, Notacion.compacta(.ruso)),
            (Notacion.hungaroCompacto, Notacion.compacta(.hungaro)),
        ]
        for (antes, ahora) in notaciones { #expect(antes == ahora) }
        let escrituras: [(EscrituraDeNotas, EscrituraDeNotas)] = [
            (EscrituraDeNotas.catalanPalabras, EscrituraDeNotas.conPalabras(.catalan)),
            (EscrituraDeNotas.gallegoPalabras, EscrituraDeNotas.conPalabras(.gallego)),
            (EscrituraDeNotas.asturianoPalabras, EscrituraDeNotas.conPalabras(.asturiano)),
            (EscrituraDeNotas.aragonesPalabras, EscrituraDeNotas.conPalabras(.aragones)),
            (EscrituraDeNotas.euskeraPalabras, EscrituraDeNotas.conPalabras(.euskera)),
            (EscrituraDeNotas.portuguesPalabras, EscrituraDeNotas.conPalabras(.portugues)),
            (EscrituraDeNotas.francesPalabras, EscrituraDeNotas.conPalabras(.frances)),
            (EscrituraDeNotas.occitanoPalabras, EscrituraDeNotas.conPalabras(.occitano)),
            (EscrituraDeNotas.italianoPalabras, EscrituraDeNotas.conPalabras(.italiano)),
            (EscrituraDeNotas.alemanPalabras, EscrituraDeNotas.conPalabras(.aleman)),
            (EscrituraDeNotas.griegoPalabras, EscrituraDeNotas.conPalabras(.griego)),
            (EscrituraDeNotas.rusoPalabras, EscrituraDeNotas.conPalabras(.ruso)),
            (EscrituraDeNotas.hungaroPalabras, EscrituraDeNotas.conPalabras(.hungaro)),
            (EscrituraDeNotas.catalanCompacto, EscrituraDeNotas.compacta(.catalan)),
            (EscrituraDeNotas.gallegoCompacto, EscrituraDeNotas.compacta(.gallego)),
            (EscrituraDeNotas.asturianoCompacto, EscrituraDeNotas.compacta(.asturiano)),
            (EscrituraDeNotas.aragonesCompacto, EscrituraDeNotas.compacta(.aragones)),
            (EscrituraDeNotas.euskeraCompacto, EscrituraDeNotas.compacta(.euskera)),
            (EscrituraDeNotas.portuguesCompacto, EscrituraDeNotas.compacta(.portugues)),
            (EscrituraDeNotas.francesCompacto, EscrituraDeNotas.compacta(.frances)),
            (EscrituraDeNotas.occitanoCompacto, EscrituraDeNotas.compacta(.occitano)),
            (EscrituraDeNotas.italianoCompacto, EscrituraDeNotas.compacta(.italiano)),
            (EscrituraDeNotas.alemanCompacto, EscrituraDeNotas.compacta(.aleman)),
            (EscrituraDeNotas.griegoCompacto, EscrituraDeNotas.compacta(.griego)),
            (EscrituraDeNotas.rusoCompacto, EscrituraDeNotas.compacta(.ruso)),
            (EscrituraDeNotas.hungaroCompacto, EscrituraDeNotas.compacta(.hungaro)),
        ]
        for (antes, ahora) in escrituras { #expect(antes == ahora) }
    }

    @available(*, deprecated)
    @Test func deYAEnLasEscalasVecinas() throws {
        let vecina = EscalaVecina(escala: Escala(.do, .lidio), de: .fa, a: Nota(.fa, .sostenido))
        #expect(vecina == EscalaVecina(escala: Escala(.do, .lidio), desde: .fa, hasta: Nota(.fa, .sostenido)))
        #expect(vecina.de == vecina.desde && vecina.a == vecina.hasta)
        let enlace = try #require(Escala.mapaDeBrillo().enlaces.first)
        #expect(enlace.de == enlace.desde && enlace.a == enlace.hasta)
    }
}
