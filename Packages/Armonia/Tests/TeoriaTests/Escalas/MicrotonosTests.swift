import Testing

@testable import Elementos
@testable import Teoria

@Suite struct MicrotonosTests {
    private func nombres(
        _ escala: Escala, _ sentido: SentidoDelIntervalo = .ascendente, en notacion: Notacion = .compacta(.espanol),
        afinacion: AfinacionPropia? = nil
    ) -> String? {
        escala.notasMicrotonales(sentido: sentido, afinacion: afinacion)?.map { $0.nombre(en: notacion) }
            .joined(separator: " ")
    }

    /// Cada versión microtonal tiene un paso por grado y ningún grado se aparta más de medio semitono.
    @Test func elCatalogoEsCoherente() {
        for microtonal in AfinacionPropia.catalogo {
            #expect(microtonal.esCoherente, Comment(rawValue: microtonal.temperada.nombre))
            #expect(
                microtonal.temperada.afinaciones.contains(microtonal), Comment(rawValue: microtonal.temperada.nombre))
            #expect(microtonal.pasos == microtonal.pasos.sorted(), Comment(rawValue: microtonal.temperada.nombre))
        }
        #expect(AfinacionPropia.catalogo.count == 210)
        // La primera de cada escala es la de su teoría de hoy, sin fuente.
        #expect(TipoDeEscala.catalogo.allSatisfy { $0.afinacionPropia?.fuente == nil })
    }

    /// Se busca por el nombre: el frigio tiene los intervalos de Bayātī, pero no sus microtonos.
    @Test func soloLasTradicionalesTienenMicrotonos() {
        #expect(TipoDeEscala.bayati == .frigio)
        #expect(TipoDeEscala.bayati.afinacionPropia != nil)
        #expect(TipoDeEscala.frigio.afinacionPropia == nil)
        #expect(TipoDeEscala.ajam.afinacionPropia == nil)
        #expect(Escala(.do, .mayor).notasMicrotonales() == nil)
        let propia = TipoDeEscala(nombre: "Bayātī", intervalos: [.unisono, .quintaJusta])
        #expect(propia.afinacionPropia == nil)
    }

    /// Los echoi diatónicos tienen dos afinaciones: la de la Comisión Patriarcal y la de Chrysanthos.
    @Test func variasAfinacionesPorEscala() throws {
        let afinaciones = TipoDeEscala.echosProtos.afinaciones
        #expect(afinaciones.map(\.sistema) == [.moria72, .razones])
        #expect(afinaciones.map(\.fuente) == [nil, .chrysanthos])
        #expect(TipoDeEscala.echosProtos.afinacionPropia == afinaciones.first)
        #expect(afinaciones[1].desvios == [12, -29, -6, 6, 18, -24, 0])
        #expect(TipoDeEscala.echosDefteros.afinaciones.count == 1)
        #expect(TipoDeEscala.mayor.afinaciones.isEmpty)
        let chrysanthos = try #require(nombres(Escala(.re, .echosProtos), afinacion: afinaciones[1]))
        #expect(chrysanthos == "Re(+12¢) Mi(−29¢) Fa(−6¢) Sol(+6¢) La(+18¢) Si(−24¢) Do")
        // Una afinación de otra escala no vale.
        #expect(Escala(.re, .echosProtos).notasMicrotonales(afinacion: TipoDeEscala.bayati.afinacionPropia) == nil)
    }

    /// La escala de blues, la única occidental: la tercera neutra y la séptima armónica.
    @Test func lasBlueNotes() throws {
        let blues = try #require(TipoDeEscala.blues.afinacionPropia)
        #expect(AfinacionPropia.occidentales == [blues])
        #expect(blues.desvios == [0, 50, -2, 0, 2, -31])
        let texto = try #require(nombres(Escala(.do, .blues)))
        #expect(texto == "Do Mi♭(+50¢) Fa(−2¢) Fa♯ Sol(+2¢) Si♭(−31¢)")
        #expect(TipoDeEscala.bluesMayor.afinacionPropia == nil)
    }

    @Test func maqamatEnCuartosDeTono() {
        let bayati = TipoDeEscala.bayati.afinacionPropia
        #expect(bayati?.cents == [0, 150, 300, 500, 700, 800, 1000])
        #expect(bayati?.desvios == [0, 50, 0, 0, 0, 0, 0])
        #expect(nombres(Escala(.re, .bayati)) == "Re Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.re, .saba)) == "Re Mi𝄳 Fa Sol♭ La Si♭ Do")
        #expect(nombres(Escala(.do, .suznak)) == "Do Re Mi𝄳 Fa Sol La♭ Si")
        // Rāst sube con Si𝄳 y baja con Si♭.
        #expect(nombres(Escala(.do, .maqamRast)) == "Do Re Mi𝄳 Fa Sol La Si𝄳")
        #expect(nombres(Escala(.do, .maqamRast), .descendente) == "Do Re Mi𝄳 Fa Sol La Si♭")
        #expect(TipoDeEscala.maqamRast.afinacionPropia?.desvios(sentido: .descendente).last == 0)
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
        #expect(TipoDeEscala.sikah.afinacionPropia?.desvios().first == -50)
        #expect(Escala(.mi, .sikah).notasMicrotonales()?.first?.cents == -50)
        #expect(nombres(Escala(.si, .bayati)) == "Si Do𝄲 Re Mi Fa♯ Sol La")
    }

    @Test func dastgahConKoron() {
        #expect(TipoDeEscala.sur.afinacionPropia?.sistema == .persa)
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
        #expect(TipoDeEscala.segah.afinacionPropia?.sistema == .persa)
    }

    @Test func makamlarEnComas() {
        let rast = TipoDeEscala.rastMakami.afinacionPropia
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
        // Solo los seis pitagóricos (Nihâvend, Kürdî, Bûselik, Çârgâh, Mâhur y Acemaşiran) no tienen versión
        // microtonal.
        #expect(TipoDeEscala.makamlar.filter { $0.afinacionPropia == nil }.count == 6)
        #expect(TipoDeEscala.ussakMakami.afinacionPropia?.cents[1] == 8.0 * 1200 / 53)
        #expect(nombres(Escala(.sol, .kurdilihicazkarMakami)) == "Sol La♭ Si♭ Do Re Mi♭ Fa")
        #expect(nombres(Escala(.re, .ferahfezaMakami)) == "Re Mi Fa Sol La Si♭ Do")
        // Los çeşni de Rast, Uşşak y Hicaz, en comas; los ajnas con cuartos de tono, en cuartos de tono.
        #expect(nombres(Escala(.la, .hicazDortlusu)) == "La Si♭⁺¹ Do♯⁻¹ Re")
        #expect(nombres(Escala(.la, .ussakBeslisi)) == "La Si⁻¹ Do Re Mi")
        #expect(nombres(Escala(.re, .jinsBayati)) == "Re Mi𝄳 Fa Sol")
        #expect(nombres(Escala(.mi, .jinsSikah)) == "Mi𝄳 Fa Sol")
        #expect(TipoDeEscala.jinsHijaz.afinacionPropia == nil && TipoDeEscala.kurdiDortlusu.afinacionPropia == nil)
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
        #expect(TipoDeEscala.dromoi.allSatisfy { $0.afinacionPropia != nil })
        #expect(TipoDeEscala.hiyaz.afinacionPropia == nil)
        // Una coma son 1200/53 cents.
        let si = Escala(.sol, .rastMakami).notasMicrotonales()?[2]
        #expect(abs((si?.cents ?? 0) - 17.0 * 1200 / 53) < 1e-9)
    }

    /// El gamelan, en nueve y cinco partes iguales; los xilófonos africanos y los conjuntos de Tailandia y Camboya, en
    /// cinco o siete.
    @Test func afinacionesEquidistantes() {
        #expect(TipoDeEscala.pelog.afinacionPropia?.sistema == .razones)
        #expect(TipoDeEscala.pelogNem.afinacionPropia?.pasos == [0, 133, 533, 667, 800])
        #expect(TipoDeEscala.indonesias.filter { $0.afinacionPropia == nil } == [.degung])
        #expect(TipoDeEscala.pathets.allSatisfy { $0.afinacionPropia != nil })
        #expect(TipoDeEscala.slendro.afinacionPropia?.pasos == [0, 240, 480, 720, 960])
        #expect(TipoDeEscala.amadinda.afinacionPropia?.pasos == TipoDeEscala.slendro.afinacionPropia?.pasos)
        #expect(TipoDeEscala.timbila.afinacionPropia?.pasos == [0, 171, 343, 514, 686, 857, 1029])
        #expect(TipoDeEscala.piphat.afinacionPropia?.pasos == TipoDeEscala.timbila.afinacionPropia?.pasos)
        #expect(TipoDeEscala.pinpeat.afinacionPropia != nil)
        #expect(TipoDeEscala.protusAuthenticus.afinacionPropia == nil)
    }

    /// Las harmoniai enarmónicas y las de Arístides, en cuartos de tono; los géneros de Dídimo y Eratóstenes, en cents.
    @Test func harmoniaiEnCuartosDeTono() {
        #expect(nombres(Escala(.mi, .harmoniaDoriaEnarmonica)) == "Mi Fa𝄳 Fa La Si Do𝄳 Do")
        #expect(nombres(Escala(.do, .harmoniaFrigiaEnarmonica)) == "Do𝄳 Mi𝄳 Mi Fa𝄳 La𝄳 Si𝄳 Si")
        #expect(nombres(Escala(.mi, .harmoniaLidiaDeAristides)) == "Mi Fa𝄳 La𝄳 Si𝄳 Do♭ Do𝄳 Re♯𝄲")
        #expect(TipoDeEscala.harmoniaiDeAristides.allSatisfy { $0.afinacionPropia?.sistema == .cuartosDeTono })
        #expect(TipoDeEscala.harmoniaiCromaticas.allSatisfy { $0.afinacionPropia == nil })
        #expect(TipoDeEscala.tetracordoEnarmonicoDeArquitas.afinacionPropia?.pasos == [0, 63, 112, 498])
        #expect(Escala(.mi, .tetracordoEnarmonicoDeArquitas).notas.map(\.description) == ["Mi", "Mi♯", "Fa", "La"])
    }

    @Test func echoiEnMoria() {
        let protos = TipoDeEscala.echosProtos.afinacionPropia
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
        #expect(nombres(Escala(.re, .echosProtos), en: .ascii(.ingles)) == "D E(-2) F G A B(-2) C")
        // El tercero, enarmónico, ya es la escala mayor.
        #expect(TipoDeEscala.echosTritos == .mayor && TipoDeEscala.echosTritos.afinacionPropia == nil)
        #expect(TipoDeEscala.echoi.filter { $0.afinacionPropia == nil } == [.echosTritos])
        #expect(TipoDeEscala.echosProtos.tradicion == .bizancio && TipoDeEscala.echosProtos.categoria == .echos)
        #expect(SistemaMicrotonal.moria72.cents(de: 12) == 200)
    }

    @Test func thaatEnSruti() {
        // Los 22 śruti: razones justas, con un limma, una coma o un semitono menor entre dos seguidos.
        #expect(SistemaMicrotonal.razonesDeLosSruti.count == 22)
        #expect(SistemaMicrotonal.razonesDeLosSruti[1] == RazonDeFrecuencias(256, 243))
        #expect(SistemaMicrotonal.razonesDeLosSruti[7].description == "5/4")
        #expect(abs(SistemaMicrotonal.sruti.cents(de: 7) - 386.31) < 0.01)
        #expect(abs(SistemaMicrotonal.sruti.cents(de: 22 + 13) - 1901.96) < 0.01)
        #expect(abs(SistemaMicrotonal.sruti.cents(de: -9) - (-498.04)) < 0.01)
        let bilaval = TipoDeEscala.bilaval.afinacionPropia
        #expect(bilaval?.sistema == .sruti)
        #expect(nombres(Escala(.do, .bilaval)) == "Do Re↓ Mi↓ Fa Sol La↓ Si↓")
        #expect(nombres(Escala(.do, .kafi)) == "Do Re↓ Mi♭ Fa Sol La↓ Si♭")
        #expect(nombres(Escala(.do, .kalyan)) == "Do Re↓ Mi↓ Fa♯↓ Sol La↓ Si↓")
        #expect(nombres(Escala(.do, .yaman)) == nombres(Escala(.do, .kalyan)))
        #expect(nombres(Escala(.do, .bhairav)) == "Do Re♭ Mi↓ Fa Sol La♭ Si↓")
        #expect(nombres(Escala(.do, .purvi)) == "Do Re♭↑ Mi↓ Fa♯↓ Sol La♭↑ Si↓")
        #expect(nombres(Escala(.do, .todi)) == "Do Re♭ Mi♭ Fa♯↓ Sol La♭ Si")
        #expect(nombres(Escala(.do, .bilaval), en: .ascii(.ingles)) == "C D(-1) E(-1) F G A(-1) B(-1)")
        // Mi↓ es 5/4: 13,69 cents bajo el Mi temperado.
        let mi = Escala(.do, .bilaval).notasMicrotonales()?[2]
        #expect(abs((mi?.cents ?? 0) - 386.31) < 0.01)
        #expect(abs((bilaval?.desvios[2] ?? 0) - (-13.69)) < 0.01)
        // Todos los thāṭ tienen versión microtonal; los mēḷa carnáticos, no.
        #expect(TipoDeEscala.thaats.allSatisfy { $0.afinacionPropia?.sistema == .sruti })
        #expect(TipoDeEscala.melakarta(29)?.afinacionPropia == nil)
    }

    @Test func lasDoblesConDobles() {
        let nota = NotaMicrotonal(temperada: Nota(.si, -2), sistema: .cuartosDeTono, ajuste: -1, cents: 0)
        #expect(nota.nombre == "Si𝄫𝄳")
        #expect(nota.nombre(en: .compacta(.ingles)) == "B𝄫𝄳")
        #expect(nota.nombre(en: .ascii(.ingles)) == "Bbbqb")
        let mi = NotaMicrotonal(temperada: .mi, sistema: .cuartosDeTono, ajuste: -1, cents: 0)
        #expect(mi.nombre == "Mi𝄳")
    }

    /// Los makamlar del tetracordo Hicaz en la dügâh y los *şed* de Nihâvend y Hicazkâr en la yegâh, con bakiye.
    @Test func makamlarDeLaFamiliaHicazYSultaniyegah() {
        #expect(nombres(Escala(.re, .sultaniyegahMakami)) == "Re Mi Fa Sol La Si♭⁺¹ Do♯⁻¹")
        #expect(nombres(Escala(.re, .sultaniyegahMakami), .descendente) == "Re Mi Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.re, .sedarabanMakami)) == "Re Mi♭⁺¹ Fa♯⁻¹ Sol La Si♭⁺¹ Do♯⁻¹")
        #expect(nombres(Escala(.la, .humayunMakami)) == "La Si♭⁺¹ Do♯⁻¹ Re Mi Fa Sol")
        #expect(nombres(Escala(.la, .uzzalMakami)) == "La Si♭⁺¹ Do♯⁻¹ Re Mi Fa♯⁻¹ Sol")
        #expect(nombres(Escala(.la, .zirguleliHicazMakami)) == "La Si♭⁺¹ Do♯⁻¹ Re Mi Fa⁺¹ Sol♯⁻¹")
        // Uzzâl sube con las perdes de Hicaz.
        #expect(TipoDeEscala.uzzalMakami.afinacionPropia?.pasos == TipoDeEscala.hicazMakami.afinacionPropia?.pasos)
        #expect(TipoDeEscala.mahurMakami.afinacionPropia == nil && TipoDeEscala.acemasiranMakami.afinacionPropia == nil)
    }

    /// El tetracordo enarmónico griego: dos cuartos de tono y un dítono.
    @Test func tetracordoEnarmonicoEnCuartosDeTono() {
        let enarmonico = TipoDeEscala.tetracordoEnarmonico.afinacionPropia
        #expect(enarmonico?.sistema == .cuartosDeTono)
        #expect(enarmonico?.cents == [0, 50, 100, 500])
        #expect(Escala(.mi, .tetracordoEnarmonico).notas.map(\.description).joined(separator: " ") == "Mi Fa♭ Fa La")
        #expect(nombres(Escala(.mi, .tetracordoEnarmonico)) == "Mi Fa𝄳 Fa La")
        #expect(nombres(Escala(.mi, .tetracordoEnarmonico), en: .ascii(.ingles)) == "E Fqb F A")
    }

    @Test func gramaYMurchanaDelNatyasastra() {
        // El ṣaḍja-grāma tiene las razones de Kāfī; Uttaramandrā, su primera mūrchanā, empieza en Sa.
        #expect(TipoDeEscala.sadjaGrama == .dorico)
        #expect(TipoDeEscala.sadjaGrama.afinacionPropia?.pasos == TipoDeEscala.kafi.afinacionPropia?.pasos)
        #expect(nombres(Escala(.re, .uttaramandra)) == "Re Mi↓ Fa Sol La Si↓ Do")
        // Rajanī, desde Ni, es la mayor justa: Sa Re(9/8) Ga(5/4) ma Pa Dha(27/16) Ni(15/8).
        #expect(TipoDeEscala.rajani == .mayor)
        #expect(TipoDeEscala.rajani.afinacionPropia?.pasos == [0, 4, 7, 9, 13, 17, 20])
        // Sauvīrī, la primera del madhyama-grāma, desde Ma: su Pa (40/27) queda a 10/9 de la tónica.
        #expect(TipoDeEscala.sauviri == .mixolidio)
        #expect(TipoDeEscala.sauviri.afinacionPropia?.pasos == [0, 3, 7, 9, 13, 16, 18])
        #expect(TipoDeEscala.matsarikrta.afinacionPropia?.pasos == [0, 4, 7, 9, 13, 16, 18])
        // El madhyama-grāma desde Sa tiene el Pa una coma baja (40/27), que no es uno de los 22 śruti: va en cents.
        let madhyama = TipoDeEscala.madhyamaGrama.afinacionPropia
        #expect(madhyama?.sistema == .razones)
        #expect(madhyama?.pasos == [0, 182, 294, 498, 680, 884, 996])
        #expect(nombres(Escala(.do, .madhyamaGrama)) == "Do Re(−18¢) Mi♭(−6¢) Fa(−2¢) Sol(−20¢) La(−16¢) Si♭(−4¢)")
        #expect(TipoDeEscala.murchanas.allSatisfy { $0.afinacionPropia != nil })
    }

    @Test func generosDeArquitasYPtolomeo() {
        #expect(SistemaMicrotonal.razones.pasosPorOctava == 1200)
        #expect(SistemaMicrotonal.razones.cents(de: 63) == 63)
        #expect(nombres(Escala(.mi, .tetracordoDiatonicoDeArquitas)) == "Mi Fa(−37¢) Sol(−6¢) La(−2¢)")
        #expect(
            nombres(Escala(.mi, .tetracordoDiatonicoDeArquitas), en: .ascii(.ingles)) == "E F(-37c) G(-6c) A(-2c)")
        #expect(nombres(Escala(.mi, .tetracordoDiatonicoTenso)) == "Mi Fa(+12¢) Sol(+16¢) La(−2¢)")
        #expect(nombres(Escala(.mi, .tetracordoEnarmonicoDePtolomeo)) == "Mi Fa♭(+38¢) Fa(+12¢) La(−2¢)")
        // El diatónico igual, con su segunda neutra de 151 cents, se escribe con Fa♯.
        #expect(nombres(Escala(.mi, .tetracordoDiatonicoIgual)) == "Mi Fa♯(−49¢) Sol(+16¢) La(−2¢)")
        #expect(TipoDeEscala.tetracordoDiatonicoDitonico == .tetracordoDiatonico)
        #expect(TipoDeEscala.tetracordoCromaticoTenso.tradicion == .greciaAntigua)
        #expect(TipoDeEscala.tetracordoCromaticoTenso.categoria == .tetracordo)
        #expect(TipoDeEscala.generosDeArquitasYPtolomeo.allSatisfy { $0.afinacionPropia?.sistema == .razones })
    }

    @Test func nombresEnOtrasNotaciones() {
        let bayati = Escala(.re, .bayati)
        #expect(nombres(bayati, en: .compacta(.ingles)) == "D E𝄳 F G A B♭ C")
        #expect(nombres(bayati, en: .ascii(.ingles)) == "D Eqb F G A Bb C")
        #expect(nombres(bayati, en: .ascii(.espanol)) == "Re Miqb Fa Sol La Sib Do")
        #expect(nombres(bayati, en: .conPalabras(.frances)) == "Ré Mi𝄳 Fa Sol La Si♭ Do")
        #expect(nombres(Escala(.sol, .rastMakami), en: .ascii(.ingles)) == "G A B(-1) C D E F#(-1)")
        #expect(Escala(.re, .bayati).notasMicrotonales()?[1].description == "Mi𝄳")
    }
}
