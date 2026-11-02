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
        #expect(TipoDeEscalaMicrotonal.catalogo.count == 68)
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

    @Test func echoiEnMoria() {
        let protos = TipoDeEscala.echosProtos.microtonal
        #expect(protos?.sistema == .moria72)
        #expect(protos?.desvios.map { ($0 * 100).rounded() / 100 } == [0, -33.33, 0, 0, 0, -33.33, 0])
        #expect(nombres(Escala(.re, .echosProtos)) == "Re Mi⁻² Fa Sol La Si⁻² Do")
        #expect(nombres(Escala(.la, .echosPlagiosProtos)) == "La Si⁻² Do Re Mi⁻² Fa Sol")
        // El segundo, cromático blando; el plagal del segundo, cromático duro: los dos, la doble armónica.
        #expect(nombres(Escala(.sol, .echosDefteros)) == "Sol La♭⁺² Si⁻² Do Re Mi♭⁺² Fa♯⁻²")
        #expect(nombres(Escala(.re, .echosPlagiosDefteros)) == "Re Mi♭ Fa♯⁺² Sol La Si♭ Do♯⁺²")
        // El varýs y el légetos, con la tónica dos moria baja.
        #expect(nombres(Escala(.si, .echosVarys)) == "Si⁻² Do Re Mi⁻² Fa Sol La")
        #expect(nombres(Escala(.mi, .echosLegetos)) == "Mi⁻² Fa Sol La Si⁻² Do Re")
        #expect(nombres(Escala(.sol, .echosTetartos)) == "Sol La Si⁻² Do Re Mi⁻² Fa")
        #expect(nombres(Escala(.do, .echosPlagiosTetartos)) == "Do Re Mi⁻² Fa Sol La Si⁻²")
        #expect(nombres(Escala(.re, .echosProtos), en: .inglesASCII) == "D E(-2) F G A B(-2) C")
        // El tercero, enarmónico, ya es la escala mayor.
        #expect(TipoDeEscala.echosTritos == .mayor && TipoDeEscala.echosTritos.microtonal == nil)
        #expect(TipoDeEscala.echoi.filter { $0.microtonal == nil } == [.echosTritos])
        #expect(TipoDeEscala.echosProtos.tradicion == .bizancio && TipoDeEscala.echosProtos.categoria == .echos)
        #expect(SistemaMicrotonal.moria72.cents(de: 12) == 200)
    }

    @Test func thaatEnSruti() {
        // Los 22 śruti: razones justas, con un limma, una coma o un semitono menor entre dos seguidos.
        #expect(SistemaMicrotonal.razonesDeLosSruti.count == 22)
        #expect(abs(SistemaMicrotonal.sruti.cents(de: 7) - 386.31) < 0.01)
        #expect(abs(SistemaMicrotonal.sruti.cents(de: 22 + 13) - 1901.96) < 0.01)
        #expect(abs(SistemaMicrotonal.sruti.cents(de: -9) - (-498.04)) < 0.01)
        let bilaval = TipoDeEscala.bilaval.microtonal
        #expect(bilaval?.sistema == .sruti)
        #expect(nombres(Escala(.do, .bilaval)) == "Do Re↓ Mi↓ Fa Sol La↓ Si↓")
        #expect(nombres(Escala(.do, .kafi)) == "Do Re↓ Mi♭ Fa Sol La↓ Si♭")
        #expect(nombres(Escala(.do, .kalyan)) == "Do Re↓ Mi↓ Fa♯↓ Sol La↓ Si↓")
        #expect(nombres(Escala(.do, .yaman)) == nombres(Escala(.do, .kalyan)))
        #expect(nombres(Escala(.do, .bhairav)) == "Do Re♭ Mi↓ Fa Sol La♭ Si↓")
        #expect(nombres(Escala(.do, .purvi)) == "Do Re♭↑ Mi↓ Fa♯↓ Sol La♭↑ Si↓")
        #expect(nombres(Escala(.do, .todi)) == "Do Re♭ Mi♭ Fa♯↓ Sol La♭ Si")
        #expect(nombres(Escala(.do, .bilaval), en: .inglesASCII) == "C D(-1) E(-1) F G A(-1) B(-1)")
        // Mi↓ es 5/4: 13,69 cents bajo el Mi temperado.
        let mi = Escala(.do, .bilaval).notasMicrotonales()?[2]
        #expect(abs((mi?.cents ?? 0) - 386.31) < 0.01)
        #expect(abs((bilaval?.desvios[2] ?? 0) - (-13.69)) < 0.01)
        // Todos los thāṭ tienen versión microtonal; los mēḷa carnáticos, no.
        #expect(TipoDeEscala.thaats.allSatisfy { $0.microtonal?.sistema == .sruti })
        #expect(TipoDeEscala.melakarta(29)?.microtonal == nil)
    }

    @Test func lasDoblesConDobles() {
        let nota = NotaMicrotonal(temperada: Nota(.si, -2), sistema: .cuartosDeTono, ajuste: -1, cents: 0)
        #expect(nota.nombre() == "Si𝄫𝄳")
        #expect(nota.nombre(en: .inglesCompacto) == "B𝄫𝄳")
        #expect(nota.nombre(en: .inglesASCII) == "Bbbqb")
        let mi = NotaMicrotonal(temperada: .mi, sistema: .cuartosDeTono, ajuste: -1, cents: 0)
        #expect(mi.nombre() == "Mi𝄳")
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
