import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct MicrotonosTests {
    private func nombres(
        _ escala: Escala, _ sentido: SentidoDelIntervalo = .ascendente, en notacion: Notacion = .espanolCompacto
    ) -> String? {
        escala.notasMicrotonales(sentido: sentido)?.map { $0.nombre(en: notacion) }.joined(separator: " ")
    }

    /// Cada versión microtonal tiene un paso por grado y ningún grado se aparta más de medio semitono.
    @Test func elCatalogoEsCoherente() {
        for microtonal in TipoDeEscalaMicrotonal.catalogo {
            #expect(microtonal.esCoherente, Comment(rawValue: microtonal.temperada.nombre))
            #expect(microtonal.temperada.microtonal == microtonal, Comment(rawValue: microtonal.temperada.nombre))
            #expect(microtonal.pasos == microtonal.pasos.sorted(), Comment(rawValue: microtonal.temperada.nombre))
        }
        #expect(TipoDeEscalaMicrotonal.catalogo.count == 49)
    }

    /// Se busca por el nombre: el frigio tiene los intervalos de Bayātī, pero no sus microtonos.
    @Test func soloLasTradicionalesTienenMicrotonos() {
        #expect(TipoDeEscala.bayati == .frigio)
        #expect(TipoDeEscala.bayati.microtonal != nil)
        #expect(TipoDeEscala.frigio.microtonal == nil)
        #expect(TipoDeEscala.ajam.microtonal == nil)
        #expect(Escala(.do, .mayor).notasMicrotonales() == nil)
        let propia = TipoDeEscala(nombre: "Bayātī", intervalos: [.unisono, .quintaJusta])
        #expect(propia.microtonal == nil)
    }

    @Test func maqamatEnCuartosDeTono() {
        let bayati = TipoDeEscala.bayati.microtonal
        #expect(bayati?.cents == [0, 150, 300, 500, 700, 800, 1000])
        #expect(bayati?.desvios == [0, 50, 0, 0, 0, 0, 0])
        #expect(nombres(Escala(.re, .bayati)) == "Re Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.re, .saba)) == "Re Mi𝄳 Fa Sol♭ La Si♭ Do")
        #expect(nombres(Escala(.do, .suznak)) == "Do Re Mi𝄳 Fa Sol La♭ Si")
        // Rāst sube con Si𝄳 y baja con Si♭.
        #expect(nombres(Escala(.do, .maqamRast)) == "Do Re Mi𝄳 Fa Sol La Si𝄳")
        #expect(nombres(Escala(.do, .maqamRast), .descendente) == "Do Re Mi𝄳 Fa Sol La Si♭")
        #expect(TipoDeEscala.maqamRast.microtonal?.desvios(sentido: .descendente).last == 0)
        // En otra tónica, el medio signo se suma a la alteración: Sol Rāst tiene Si𝄳 y Fa𝄲 (medio sostenido).
        #expect(nombres(Escala(.sol, .maqamRast)) == "Sol La Si𝄳 Do Re Mi Fa𝄲")
        #expect(nombres(Escala(.fa, .bayati)) == "Fa Sol𝄳 La♭ Si♭ Do Re♭ Mi♭")
        // Ḥusaynī, con un segundo jins Bayātī en la quinta; Nayrūz, un jins Rāst y uno Bayātī.
        #expect(nombres(Escala(.re, .husayni)) == "Re Mi𝄳 Fa Sol La Si𝄳 Do")
        #expect(nombres(Escala(.do, .nayruz)) == "Do Re Mi𝄳 Fa Sol La𝄳 Si♭")
        // Con la tónica en un cuarto de tono, escritas sobre la nota temperada.
        #expect(nombres(Escala(.mi, .sikah)) == "Mi𝄳 Fa Sol La Si𝄳 Do Re")
        #expect(nombres(Escala(.mi, .huzam)) == "Mi𝄳 Fa Sol La♭ Si Do Re")
        #expect(nombres(Escala(.si, .iraq)) == "Si𝄳 Do Re Mi𝄳 Fa Sol La")
        #expect(nombres(Escala(.si, .rahatAlArwah)) == "Si𝄳 Do Re Mi♭ Fa♯ Sol La")
        #expect(nombres(Escala(.re, .bayatiShuri)) == "Re Mi𝄳 Fa Sol La♭ Si Do")
        #expect(nombres(Escala(.fa, .jiharkah)) == "Fa Sol La Si♭ Do Re Mi𝄳")
        #expect(TipoDeEscala.sikah.microtonal?.desvios().first == -50)
        #expect(Escala(.mi, .sikah).notasMicrotonales()?.first?.cents == -50)
        #expect(nombres(Escala(.si, .bayati)) == "Si Do𝄲 Re Mi Fa♯ Sol La")
    }

    @Test func dastgahConKoron() {
        #expect(TipoDeEscala.sur.microtonal?.sistema == .persa)
        #expect(nombres(Escala(.re, .sur)) == "Re Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.do, .cahargah)) == "Do Re𝄳 Mi Fa Sol La𝄳 Si")
        #expect(nombres(Escala(.sol, .homayun)) == "Sol La𝄳 Si Do Re Mi♭ Fa")
        // Segāh, con la tónica en un koron; Navā y los āvāz de Šur y de Homāyun.
        #expect(nombres(Escala(.mi, .segah)) == "Mi𝄳 Fa Sol La𝄳 Si♭ Do Re")
        #expect(nombres(Escala(.sol, .nava)) == "Sol La Si♭ Do Re Mi𝄳 Fa")
        #expect(nombres(Escala(.fa, .bayateTork)) == "Fa Sol La Si♭ Do Re Mi𝄳")
        #expect(nombres(Escala(.do, .afshari)) == "Do Re Mi𝄳 Fa Sol La𝄳 Si♭")
        #expect(nombres(Escala(.re, .dashti)) == nombres(Escala(.re, .sur)))
        #expect(nombres(Escala(.re, .abuAta)) == "Re Mi𝄳 Fa Sol La𝄳 Si♭ Do")
        #expect(nombres(Escala(.sol, .bayateEsfahan)) == "Sol La Si♭ Do Re Mi𝄳 Fa♯")
        #expect(TipoDeEscala.segah.microtonal?.sistema == .persa)
    }

    @Test func makamlarEnComas() {
        let rast = TipoDeEscala.rastMakami.microtonal
        #expect(rast?.sistema == .comas53)
        #expect(rast?.pasos == [0, 9, 17, 22, 31, 40, 48])
        #expect(nombres(Escala(.sol, .rastMakami)) == "Sol La Si⁻¹ Do Re Mi Fa♯⁻¹")
        #expect(nombres(Escala(.sol, .rastMakami), .descendente) == "Sol La Si⁻¹ Do Re Mi Fa")
        #expect(nombres(Escala(.la, .hicazMakami)) == "La Si♭⁺¹ Do♯⁻¹ Re Mi Fa♯⁻¹ Sol")
        #expect(nombres(Escala(.la, .hicazMakami), .descendente) == "La Si♭⁺¹ Do♯⁻¹ Re Mi⁻¹ Fa Sol")
        #expect(nombres(Escala(.sol, .hicazkarMakami)) == "Sol La♭⁺¹ Si⁻¹ Do Re Mi♭⁺¹ Fa♯⁻¹")
        // Uşşak y Hüseynî, con la segâh: Si una koma bajo, como en Rast.
        #expect(nombres(Escala(.la, .ussakMakami)) == "La Si⁻¹ Do Re Mi Fa Sol")
        #expect(nombres(Escala(.la, .huseyniMakami)) == "La Si⁻¹ Do Re Mi Fa♯⁻¹ Sol")
        #expect(nombres(Escala(.la, .huseyniMakami), .descendente) == "La Si⁻¹ Do Re Mi Fa Sol")
        // Segâh y Hüzzam, desde la segâh.
        #expect(nombres(Escala(.si, .segahMakami)) == "Si⁻¹ Do Re Mi Fa♯⁻¹ Sol La")
        #expect(nombres(Escala(.si, .huzzamMakami)) == "Si⁻¹ Do Re Mi♭⁺¹ Fa♯⁻¹ Sol La")
        #expect(nombres(Escala(.la, .sabaMakami)) == "La Si⁻¹ Do Re♭⁺¹ Mi Fa Sol")
        #expect(nombres(Escala(.la, .karcigarMakami)) == "La Si⁻¹ Do Re Mi♭⁺¹ Fa♯⁻¹ Sol")
        #expect(nombres(Escala(.sol, .suzinakMakami)) == "Sol La Si⁻¹ Do Re Mi♭⁺¹ Fa♯⁻¹")
        #expect(nombres(Escala(.sol, .nikrizMakami)) == "Sol La Si♭ Do♯⁻¹ Re Mi Fa")
        #expect(nombres(Escala(.sol, .neveserMakami)) == "Sol La Si♭ Do♯⁻¹ Re Mi♭⁺¹ Fa♯⁻¹")
        // Solo los cuatro pitagóricos (Nihâvend, Kürdî, Bûselik y Çârgâh) no tienen versión microtonal.
        #expect(TipoDeEscala.makamlar.filter { $0.microtonal == nil }.count == 4)
        #expect(TipoDeEscala.ussakMakami.microtonal?.cents[1] == 8.0 * 1200 / 53)
        // Dromoi, con la afinación de su maqam o su makam.
        #expect(nombres(Escala(.re, .ousak)) == "Re Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.re, .sabah)) == "Re Mi𝄳 Fa Sol♭ La Si♭ Do")
        #expect(nombres(Escala(.re, .hitzaz)) == "Re Mi♭⁺¹ Fa♯⁻¹ Sol La Si♭ Do")
        #expect(nombres(Escala(.re, .kartzigar)) == "Re Mi⁻¹ Fa Sol La♭⁺¹ Si⁻¹ Do")
        #expect(nombres(Escala(.do, .rast), .descendente) == "Do Re Mi⁻¹ Fa Sol La Si♭")
        #expect(nombres(Escala(.re, .pireotikos)) == "Re Mi♭⁺¹ Fa♯⁻¹ Sol♯⁻¹ La Si♭⁺¹ Do♯⁻¹")
        #expect(nombres(Escala(.re, .nikriz)) == "Re Mi Fa Sol♯⁻¹ La Si Do")
        #expect(nombres(Escala(.re, .houzam)) == "Re Mi♯⁻¹ Fa♯⁻¹ Sol La Si Do♯")
        #expect(nombres(Escala(.re, .kiourdi), .descendente) == "Re Mi⁻¹ Fa Sol La Si♭ Do")
        // Todos los dromoi tienen versión microtonal; los maqamat sin cuartos de tono, no.
        #expect(TipoDeEscala.dromoi.allSatisfy { $0.microtonal != nil })
        #expect(TipoDeEscala.hiyaz.microtonal == nil)
        // Una coma son 1200/53 cents.
        let si = Escala(.sol, .rastMakami).notasMicrotonales()?[2]
        #expect(abs((si?.cents ?? 0) - 17.0 * 1200 / 53) < 1e-9)
    }

    @Test func nombresEnOtrasNotaciones() {
        let bayati = Escala(.re, .bayati)
        #expect(nombres(bayati, en: .inglesCompacto) == "D E𝄳 F G A B♭ C")
        #expect(nombres(bayati, en: .inglesASCII) == "D Eqb F G A Bb C")
        #expect(nombres(bayati, en: .espanolASCII) == "Re Miqb Fa Sol La Sib Do")
        #expect(nombres(bayati, en: .francesPalabras) == "Ré Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.sol, .rastMakami), en: .inglesASCII) == "G A B(-1) C D E F#(-1)")
        #expect(Escala(.re, .bayati).notasMicrotonales()?[1].description == "Mi𝄳")
    }
}
