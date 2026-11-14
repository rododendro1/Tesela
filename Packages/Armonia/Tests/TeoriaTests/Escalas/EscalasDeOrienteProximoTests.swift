import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escalas de Oriente Próximo y del Mediterráneo oriental: dromoi, makamlar, maqamat, harmoniai y Babilonia.
@Suite struct EscalasDeOrienteProximoTests {
    @Test func dromoi() {
        #expect(TipoDeEscala.dromoi.count == 15)
        #expect(Escala(.re, .hitzaz).notas.map(\.nombre) == ["Re", "Mi♭", "Fa♯", "Sol", "La", "Si♭", "Do"])
        #expect(Escala(.re, .pireotikos).notas.map(\.nombre) == ["Re", "Mi♭", "Fa♯", "Sol♯", "La", "Si♭", "Do♯"])
        #expect(Escala(.re, .houzam).notas.map(\.nombre) == ["Re", "Mi♯", "Fa♯", "Sol", "La", "Si", "Do♯"])
        #expect(Escala(.re, .sabah).notas.map(\.nombre) == ["Re", "Mi", "Fa", "Sol♭", "La", "Si♭", "Do"])
        #expect(Escala(.re, .kartzigar).notas.map(\.nombre) == ["Re", "Mi", "Fa", "Sol", "La♭", "Si", "Do"])
        #expect(TipoDeEscala.ousak == .frigio)
        #expect(TipoDeEscala.hitzaz == .frigioDominante)
        #expect(TipoDeEscala.nikriz == .doricoCuartaAumentada)
        #expect(TipoDeEscala.tabahaniotikos == .mayorArmonica)
    }

    @Test func makamlarMugamYMaqamatAproximados() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // Maqamat y dastgāh con cuartos de tono, aproximados.
        #expect(notas(.maqamRast) == "Do Re Mi Fa Sol La Si")
        #expect(Escala(.do, TipoDeEscala.maqamRast.formaDescendente).notas.last?.description == "Si♭")
        #expect(TipoDeEscala.maqamRast == .rast)
        #expect(notas(.bayati, .re) == "Re Mi♭ Fa Sol La Si♭ Do")
        #expect(notas(.saba, .re) == "Re Mi♭ Fa Sol♭ La Si♭ Do")
        #expect(TipoDeEscala.suznak == .mayorArmonica)
        #expect(TipoDeEscala.sur == .frigio)
        #expect(TipoDeEscala.rastPanjgah == .mixolidio)
        #expect(TipoDeEscala.husayni == .frigio)
        #expect(TipoDeEscala.nayruz == .menorNatural)
        #expect(TipoDeEscala.sikah == .frigio)
        #expect(TipoDeEscala.iraq == .locrio)
        #expect(TipoDeEscala.jiharkah == .mayor)
        #expect(TipoDeEscala.bayateTork == .mixolidio)
        #expect(TipoDeEscala.bayateEsfahan == .menorArmonica)
        #expect(TipoDeEscala.abuAta == .locrio && TipoDeEscala.segah == .locrio)
        #expect(notas(.huzam, .mi) == "Mi Fa Sol La♭ Si Do Re")
        // Makamlar.
        #expect(notas(.rastMakami, .sol) == "Sol La Si Do Re Mi Fa♯")
        #expect(TipoDeEscala.rastMakami.esDireccional)
        #expect(notas(.hicazMakami, .la) == "La Si♭ Do♯ Re Mi Fa♯ Sol")
        #expect(TipoDeEscala.hicazMakami.formaDescendente.intervalos == TipoDeEscala.frigioDominante.intervalos)
        #expect(TipoDeEscala.hicazkarMakami == .dobleArmonica)
        #expect(TipoDeEscala.kurdiMakami == .frigio)
        #expect(TipoDeEscala.buselikMakami == .menorNatural)
        #expect(TipoDeEscala.cargahMakami == .mayor)
        #expect(TipoDeEscala.nihavendMakami.formaAscendente == .menorArmonica)
        #expect(TipoDeEscala.ussakMakami == .menorNatural)
        #expect(TipoDeEscala.segahMakami == .frigio)
        #expect(TipoDeEscala.suzinakMakami == .mayorArmonica)
        #expect(TipoDeEscala.karcigarMakami == .kartzigar && TipoDeEscala.nikrizMakami == .nikriz)
        #expect(TipoDeEscala.neveserMakami == .niavent)
        #expect(TipoDeEscala.huseyniMakami.formaAscendente == .dorico)
        #expect(TipoDeEscala.huseyniMakami.formaDescendente.intervalos == TipoDeEscala.menorNatural.intervalos)
        // Mugam: Rast, Şur y Segah tienen ocho notas (una por debajo de la tónica y otra por encima).
        #expect(notas(.rastMugami) == "Do Re Mi Fa Sol La Si♭ Si")
        #expect(notas(.surMugami, .sol) == "Sol La Si♭ Do Re Mi♭ Mi Fa")
        #expect(notas(.segahMugami, .mi) == "Mi Fa Sol La Si♭ Si Do Re")
        #expect(TipoDeEscala.cahargahMugami == .dobleArmonica)
        #expect(notas(.sustarMugami) == "Do Re Mi♭ Mi Fa Sol La♭ Si")
        #expect(notas(.bayatiSirazMugami) == "Do Re Mi♭ Fa Sol La♭ La Si")
        #expect(notas(.humayunMugami) == "Do Re Mi Fa Sol Sol♯ La Si")
        // Se leen con sus letras turcas y azerbaiyanas y sin ellas (la ı sin punto como i).
        for (texto, nombre) in [
            ("Sol Rast makamı", "Rast makamı"), ("La hicaz makami", "Hicaz makamı"),
            ("Sol nihavend makami", "Nihâvend makamı"), ("Do Çârgâh makamı", "Çârgâh makamı"),
            ("Do cargah makami", "Çârgâh makamı"), ("Sol makam Rast", "Rast makamı"),
            ("Do Rast muğamı", "Rast muğamı"), ("Sol sur mugami", "Şur muğamı"), ("Mi mugam Segah", "Segah muğamı"),
            ("Do maqam rast", "maqām Rāst"), ("Re bayati", "Bayātī"), ("Re Saba", "Ṣabā"), ("Re Šur", "Šur"),
            ("Re shur", "Šur"), ("Do rast panjgah", "Rāst-Panjgāh"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        // «Rast» sola sigue siendo el dromos.
        #expect((try? Escala(leyendo: "Re rast"))?.tipo.nombre == "Rast")
    }

    @Test func harmoniaiMakamlarMaqamatPathetYRagasNuevos() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // Las siete harmoniai son las siete especies de octava de la escala de Mi a Mi.
        #expect(TipoDeEscala.harmoniaMixolidia == .locrio)
        #expect(TipoDeEscala.harmoniaHipolidia == .lidio)
        #expect(TipoDeEscala.harmoniaHipofrigia == .mixolidio)
        #expect(TipoDeEscala.harmoniaHipodoria == .menorNatural)
        #expect(notas(.tetracordoEnarmonico, .mi) == "Mi Fa♭ Fa La")
        // Makamlar: varios son las notas de otro makam en otra perde.
        #expect(TipoDeEscala.mahurMakami == .mayor && TipoDeEscala.acemasiranMakami == .mayor)
        #expect(TipoDeEscala.sultaniyegahMakami == .nihavendMakami)
        #expect(notas(.sultaniyegahMakami, .re) == "Re Mi Fa Sol La Si♭ Do♯")
        #expect(TipoDeEscala.sedarabanMakami == .dobleArmonica && TipoDeEscala.zirguleliHicazMakami == .dobleArmonica)
        #expect(TipoDeEscala.humayunMakami == .frigioDominante)
        #expect(notas(.uzzalMakami, .la) == "La Si♭ Do♯ Re Mi Fa♯ Sol")
        #expect(TipoDeEscala.uzzalMakami.intervalos == TipoDeEscala.hicazMakami.intervalos)
        // Maqamat sin cuartos de tono.
        #expect(notas(.atharKurd) == "Do Re♭ Mi♭ Fa♯ Sol La♭ Si")
        #expect(TipoDeEscala.maqamNikriz == .nikriz && TipoDeEscala.maqamNikriz.categoria == .maqam)
        #expect(TipoDeEscala.lami == .locrio)
        #expect(TipoDeEscala.sabaZamzam == .saba)
        // Pathet y modos de Bali, cada grado del pélog de nueve partes iguales redondeado desde su tónica.
        #expect(TipoDeEscala.pelogLima == .pelog)
        #expect(notas(.pelogNem, .sol) == "Sol La♭ Do Re Mi♭")
        #expect(notas(.pelogBarang, .la) == "La Si♭ Re Mi Sol♯")
        #expect(TipoDeEscala.pelogSunaren == .pelog && TipoDeEscala.pelogTembung == .pelog)
        // El sléndro, equidistante: los tres pathet tienen los mismos intervalos.
        #expect(TipoDeEscala.slendroSanga == .slendro && TipoDeEscala.slendroManyura == .slendro)
        #expect(TipoDeEscala.slendroNem == .egipcia)
        // Rāgas: los cuatro suben y bajan en línea recta.
        #expect(notas(.lalit) == "Do Re♭ Mi Fa Fa♯ La♭ Si")
        #expect(TipoDeEscala.mohanakalyani.formaAscendente.intervalos == TipoDeEscala.mohanam.intervalos)
        #expect(notas(.mohanakalyani.formaDescendente) == "Do Re Mi Fa♯ Sol La Si")
        #expect(notas(.saveri) == "Do Re♭ Fa Sol La♭")
        #expect(notas(.nata) == "Do Re♯ Mi Fa Sol La♯ Si")
        #expect(notas(.nata.formaDescendente) == "Do Re♯ Fa Sol Si")
        // Se leen por su nombre, con sus letras y sin ellas, y la sexta disminuida de Barry Harris es el bebop.
        for (texto, nombre) in [
            ("Re Sultaniyegah makami", "Sultânîyegâh makamı"), ("La makam Uzzal", "Uzzâl makamı"),
            ("Re Sedaraban makami", "Şedaraban makamı"), ("Do Athar Kurd", "Āthār Kurd"),
            ("Do maqam Nikriz", "maqām Nikrīz"), ("Re Saba Zamzam", "Ṣabā Zamzam"), ("Do Tembung", "Pélog tembung"),
            ("Do Slendro manyura", "Sléndro pathet manyura"), ("Do Mohanakalyani", "Mohanakalyāṇi"),
            ("Do Lalit", "Lalit"), ("Si harmonia mixolidia", "harmonía mixolidia"),
        ] {
            #expect((try? Escala(leyendo: texto))?.tipo.nombre == nombre, Comment(rawValue: texto))
        }
        #expect(Escala("Do sexta disminuida").tipo == .bebopMayor)
        #expect(Escala("C minor sixth diminished").tipo == .bebopMenorMelodica)
    }

    @Test func afinacionesBabilonicas() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota = .do) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        // En la reconstrucción de Kilmer con escalas descendentes, cada afinación es uno de los siete modos diatónicos.
        #expect(TipoDeEscala.isartu == .mayor)
        // Su versión microtonal, pitagórica: el tritono del lidio es de 612 cents y el del locrio, de 588.
        #expect(TipoDeEscala.isartu.afinacionPropia?.cents == [0, 204, 408, 498, 702, 906, 1110])
        #expect(TipoDeEscala.qablitu.afinacionPropia?.cents == [0, 204, 408, 612, 702, 906, 1110])
        #expect(TipoDeEscala.nisTuhri.afinacionPropia?.cents == [0, 90, 294, 498, 588, 792, 996])
        #expect(TipoDeEscala.mesopotamicas.allSatisfy { $0.afinacionPropia?.sistema == .razones })
        #expect(TipoDeEscala.kitmu == .mixolidio)
        #expect(TipoDeEscala.embubu == .dorico)
        #expect(TipoDeEscala.pitu == .menorNatural)
        #expect(TipoDeEscala.nidQabli == .frigio)
        #expect(TipoDeEscala.nisTuhri == .locrio)
        #expect(TipoDeEscala.qablitu == .lidio)
        #expect(notas(.nidQabli, .mi) == "Mi Fa Sol La Si Do Re")
        // En el orden de UET VII 74, cada una baja un semitono una sola nota de la anterior (y qablītu, la tónica).
        let lista = TipoDeEscala.mesopotamicas
        for (anterior, siguiente) in zip(lista, lista.dropFirst()) {
            let a = Set(Escala(.do, anterior).notas.map(\.claseDeAltura))
            let b = Set(Escala(.do, siguiente).notas.map(\.claseDeAltura))
            // De nīš tuḫri a qablītu baja la cuerda de la tónica: qablītu queda sobre Si.
            let bajada = siguiente == .qablitu ? 11 : 0
            let traspuesta = Set(b.map { ($0 + bajada) % 12 })
            #expect(a.subtracting(traspuesta).count == 1, Comment(rawValue: siguiente.nombre))
        }
        // Se encuentran con o sin diacríticos, con la mimación y con la lectura antigua de nīš tuḫri.
        for (texto, nombre) in [
            ("isartu", "išartu"), ("ishartu", "išartu"), ("išartum", "išartu"), ("nid qabli", "nīd qabli"),
            ("nis gabari", "nīš tuḫri"), ("nish tuhri", "nīš tuḫri"), ("qablitum", "qablītu"), ("embubu", "embūbu"),
        ] {
            #expect((try? TipoDeEscala(leyendo: texto))?.nombre == nombre, Comment(rawValue: texto))
        }
        #expect((try? Escala(leyendo: "Re pitu"))?.tipo.nombre == "pītu")
        #expect(!(TipoDeEscala.occidentales.contains { $0.nombre == "išartu" }))
    }

    /// Los colores de Aristóxeno, en doceavos de tono, y los adwār de Ṣafī al-Dīn, pitagóricos.
    @Test func aristoxenoYSafiAlDin() throws {
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.tradicion == .greciaAntigua })
        #expect(TipoDeEscala.coloresDeAristoxeno.allSatisfy { $0.categoria == .tetracordo })
        #expect(TipoDeEscala.tetracordoCromaticoBlandoDeAristoxeno.afinacionPropia?.desvios == [0, -33, 33, 0])
        #expect(TipoDeEscala.tetracordoCromaticoHemiolico.afinacionPropia?.desvios == [0, -25, -50, 0])
        #expect(try TipoDeEscala(leyendo: "cromático tónico") == .tetracordoCromatico)
        #expect(TipoDeEscala.adwar.allSatisfy { $0.tradicion == .mundoArabe && $0.categoria == .maqam })
        #expect(TipoDeEscala.shaddNawa == .menorNatural)
        #expect(TipoDeEscala.shaddRast.afinacionPropia?.desvios == [0, 4, -16, -2, 2, -18, -4])
        #expect((try? TipoDeEscala(leyendo: "Rast de Safi al-Din"))?.nombre == "shadd Rāst")
    }

    /// Los cuatro maqāmāt que salen de sus ajnas en Maqam World: ʿAjam ʿUshayrān, Shawq Afzā, ʿUshshāq Maṣrī y
    /// Zanjarān.
    @Test func maqamatQueSalenDeSusAjnas() {
        func notas(_ tipo: TipoDeEscala, _ tonica: Nota) -> String {
            Escala(tonica, tipo).notas.map(\.description).joined(separator: " ")
        }
        #expect(notas(.ajamUshayran, Nota("Si♭")) == "Si♭ Do Re Mi♭ Fa Sol La")
        #expect(notas(.shawqAfza, .do) == "Do Re Mi Fa Sol La♭ Si")
        #expect(notas(.ushshaqMasri, .re) == "Re Mi Fa Sol La Si♭ Do")
        #expect(notas(.zanjaran, .re) == "Re Mi♭ Fa♯ Sol La Si Do")
        #expect(TipoDeEscala.ushshaqMasri.afinacionPropia?.pasos == [0, 4, 6, 10, 14, 17, 20])
        #expect(TipoDeEscala.zanjaran.ajnas.map(\.fragmento) == [.jinsHijaz, .jinsAjam])
        #expect(TipoDeEscala.ajamUshayran.ajnas.map(\.grado) == [1, 3, 6])
        #expect(TipoDeEscala.buscar(nombre: "شوق افزا")?.esIdentico(a: .shawqAfza) == true)
        #expect(TipoDeEscala.maqamat.count == 26)
    }
}
