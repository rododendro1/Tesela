import Elementos
import Foundation
import Testing

@testable import Teoria

/// El recorrido de los rāgas vakra: el orden en que se tocan los grados al subir y al bajar.
struct RecorridoTests {
    func alturas(_ tipo: TipoDeEscala, _ sentido: SentidoDelIntervalo = .ascendente) -> [String] {
        Escala(.do, tipo).alturas(octava: 4, sentido: sentido).map(\.description)
    }

    @Test func seTocanEnSuOrden() {
        // Ānandabhairavi sube en zigzag y baja recto.
        #expect(alturas(.anandabhairavi) == ["Do4", "Mi♭4", "Re4", "Mi♭4", "Fa4", "Sol4", "La4", "Sol4", "Do5"])
        #expect(
            alturas(.anandabhairavi, .descendente) == ["Do5", "Si♭4", "La4", "Sol4", "Fa4", "Mi♭4", "Re4", "Do4"])
        // Aṭāṇā sube recto y baja en zigzag.
        #expect(alturas(.atana) == ["Do4", "Re4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(alturas(.atana, .descendente) == ["Do5", "Si4", "La4", "Sol4", "Fa4", "Sol4", "Mi4", "Re4", "Do4"])
        // Suruṭṭi, las dos.
        #expect(alturas(.surutti) == ["Do4", "Re4", "Fa4", "Sol4", "Si♭4", "La4", "Si♭4", "Do5"])
        #expect(
            alturas(.surutti, .descendente) == [
                "Do5", "Si♭4", "La4", "Sol4", "Fa4", "Mi4", "Sol4", "Fa4", "Re4", "Do4",
            ])
    }

    @Test func losOtrosVakraDelCatalogo() {
        #expect(alturas(.kedaram) == ["Do4", "Fa4", "Mi4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(
            alturas(.darbar, .descendente) == [
                "Do5", "Si♭4", "La4", "Sol4", "Fa4", "Re4", "Mi♭4", "Mi♭4", "Re4", "Do4",
            ])
        #expect(alturas(.mukhari) == ["Do4", "Re4", "Fa4", "Sol4", "Si♭4", "La4", "Do5"])
        #expect(alturas(.mukhari, .descendente) == ["Do5", "Si♭4", "La♭4", "Sol4", "Fa4", "Mi♭4", "Re4", "Do4"])
        #expect(alturas(.gaula) == ["Do4", "Re♭4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(
            alturas(.gaula, .descendente) == ["Do5", "Si4", "Sol4", "Fa4", "Re♭4", "Mi4", "Fa4", "Re♭4", "Do4"])
        #expect(alturas(.nalinakanti) == ["Do4", "Mi4", "Re4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(alturas(.nalinakanti, .descendente) == ["Do5", "Si4", "Sol4", "Fa4", "Mi4", "Re4", "Do4"])
        #expect(alturas(.kathanakutuhalam) == ["Do4", "Re4", "Fa4", "La4", "Si4", "Mi4", "Sol4", "Do5"])
        #expect(
            alturas(.begada) == ["Do4", "Mi4", "Re4", "Mi4", "Fa4", "Sol4", "La4", "Si♭4", "La4", "Sol4", "Do5"])
        #expect(alturas(.sahana) == ["Do4", "Re4", "Mi4", "Fa4", "Sol4", "Fa4", "La4", "Si♭4", "Do5"])
        #expect(
            alturas(.sahana, .descendente) == [
                "Do5", "Si♭4", "Do5", "La4", "Si♭4", "La4", "Sol4", "Fa4", "Mi4", "Fa4", "Re4", "Mi4", "Re4", "Do4",
            ])
        #expect(
            alturas(.ritigaula) == [
                "Do4", "Mi♭4", "Re4", "Mi♭4", "Fa4", "Si♭4", "La4", "Fa4", "Si♭4", "Si♭4", "Do5",
            ])
        #expect(
            alturas(.ritigaula, .descendente) == [
                "Do5", "Si♭4", "La4", "Fa4", "Mi♭4", "Fa4", "Sol4", "Fa4", "Mi♭4", "Re4", "Do4",
            ])
    }

    /// Khamās sube en zigzag, sin Re; Bihāg sube desde el Ni de abajo y baja en zigzag, con el Ma tīvra de paso, que
    /// es una nota externa.
    @Test func khamasYBihag() {
        #expect(alturas(.khamas) == ["Do4", "Fa4", "Mi4", "Fa4", "Sol4", "La4", "Si♭4", "Do5"])
        #expect(alturas(.khamas, .descendente) == ["Do5", "Si♭4", "La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4"])
        #expect(TipoDeEscala.khamas.madre == .melakarta(28) && TipoDeEscala.khamas.melakartasCompatibles == [28])
        #expect(alturas(.bihag) == ["Si3", "Do4", "Mi4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(
            alturas(.bihag, .descendente) == [
                "Do5", "Si4", "La4", "Sol4", "Fa♯4", "Sol4", "Mi4", "Fa4", "Mi4", "Re4", "Do4",
            ])
        #expect(TipoDeEscala.bihag.notasExternas == [.cuartaAumentada] && TipoDeEscala.bihag.madre == .bilaval)
    }

    /// Un recorrido puede empezar por debajo de la tónica: Darbārī Kānaḍa carnática sube desde el ni de abajo. Las
    /// notas de la escala y sus cents siguen saliendo de la tónica.
    @Test func unRecorridoQueEmpiezaPorDebajo() {
        let darbari = Escala(.do, .darbariKanadaCarnatica)
        #expect(
            alturas(.darbariKanadaCarnatica) == [
                "Si♭3", "Do4", "Re4", "Mi♭4", "Re4", "Do4", "Fa4", "Sol4", "La♭4", "Si♭4", "Do5",
            ])
        #expect(
            alturas(.darbariKanadaCarnatica, .descendente) == [
                "Do5", "La♭4", "Si♭4", "Sol4", "Fa4", "Sol4", "Mi♭4", "Fa4", "Re4", "Do4",
            ])
        #expect(darbari.notas.first == .do && darbari.tipo.madre?.nombre == "Naṭabhairavī")
        #expect(darbari.cents(con: .afinacionJusta).first == 0 && darbari.cents(con: .afinacionJusta).count == 7)
        // Sus mismas notas son las de la indostánica, que va recta: el recorrido no cuenta para `==`.
        #expect(darbari.tipo == .darbariKanada && !darbari.tipo.esIdentico(a: .darbariKanada))
    }

    /// Los cents de un vakra van en el orden de sus notas, no en el de su recorrido.
    @Test func losCentsDeUnVakraVanEnOrden() {
        let cents = Escala(.do, .anandabhairavi).cents(con: .afinacionJusta)
        #expect(cents.count == 6 && cents == cents.sorted())
    }

    /// Las notas externas (anya svara): las que no son de la madre, estén en la escala o solo en sus frases.
    @Test func lasNotasExternasNoSonDelPadre() {
        #expect(
            TipoDeEscala.mukhari.notasExternas == [.sextaMenor]
                && TipoDeEscala.mukhari.madre?.nombre == "Kharaharapriyā")
        #expect(TipoDeEscala.mukhari.melakartasCompatibles == [22])
        #expect(TipoDeEscala.anandabhairavi.notasExternas == [.terceraMayor, .sextaMenor, .septimaMayor])
        // Las de Ānandabhairavi no están en sus formas: solo salen en algunas frases.
        #expect(
            TipoDeEscala.anandabhairavi.notasExternas.allSatisfy {
                !TipoDeEscala.anandabhairavi.intervalosEnAmbasDirecciones.contains($0)
            })
        #expect(
            TipoDeEscala.begada.notasExternas == [.septimaMenor]
                && TipoDeEscala.devagandhari.notasExternas == [.septimaMenor])
        // Deś sube con el Ni natural, que Khamāj, su thāṭ, no tiene.
        #expect(TipoDeEscala.des.notasExternas == [.septimaMayor] && TipoDeEscala.des.madre?.nombre == "Khamāj")
        let bhairavi = TipoDeEscala.bhairaviCarnatica
        #expect(bhairavi.notasExternas == [.sextaMayor] && bhairavi.madre?.nombre == "Naṭabhairavī")
        #expect((try? TipoDeEscala(leyendo: "Bhairavi"))?.esIdentico(a: .bhairavi) == true)
        #expect((try? TipoDeEscala(leyendo: "Carnatic Bhairavi"))?.esIdentico(a: bhairavi) == true)
        #expect(TipoDeEscala.mayor.notasExternas.isEmpty && TipoDeEscala.kedaram.notasExternas.isEmpty)
        // No van en el JSON ni cuentan para `==`: son del catálogo, por la identidad.
        let propia = TipoDeEscala(
            nombre: "mía", intervalos: TipoDeEscala.mukhari.intervalos,
            intervalosDescendentes: TipoDeEscala.mukhari.intervalosDescendentes)
        #expect(propia == .mukhari && propia.notasExternas.isEmpty)
        let datos = try? JSONEncoder().encode(TipoDeEscala.mukhari)
        #expect(datos.flatMap { String(data: $0, encoding: .utf8) }?.contains("Externas") == false)
    }

    @Test func losGradosFueraDeLaOctavaVanALaDeArribaOALaDeAbajo() {
        let tipo = TipoDeEscala(
            nombre: "mía", intervalos: TipoDeEscala.mayor.intervalos, recorrido: [1, 0, 1, 2, 3, 4, 5, 6, 7, 9, 8])
        #expect(
            alturas(tipo) == ["Do4", "Si3", "Do4", "Re4", "Mi4", "Fa4", "Sol4", "La4", "Si4", "Re5", "Do5"])
        #expect(
            Escala(.do, TipoDeEscala(nombre: "mía", intervalos: TipoDeEscala.mayor.intervalos, recorrido: [1, -1, 8]))
                .alturas(octava: 4).map(\.description) == ["Do4", "La3", "Do5"])
    }

    @Test func unRecorridoRectoNoSeGuarda() {
        let recto = TipoDeEscala(
            nombre: "mía", intervalos: TipoDeEscala.mayor.intervalos, recorrido: Array(1...8),
            recorridoDescendente: Array((1...8).reversed()))
        #expect(recto.recorrido == nil && recto.recorridoDescendente == nil && !recto.esVakra)
        #expect(TipoDeEscala.anandabhairavi.esVakra && TipoDeEscala.anandabhairavi.recorridoDescendente == nil)
        #expect(!TipoDeEscala.bilahari.esVakra)
    }

    /// Las mismas notas suenan igual (`==`) con otro recorrido: el recorrido no es parte del contenido.
    @Test func noCuentaParaElContenido() {
        let recta = TipoDeEscala(
            nombre: "recta", intervalos: TipoDeEscala.atana.intervalos,
            intervalosDescendentes: TipoDeEscala.atana.intervalosDescendentes)
        #expect(recta == .atana && !recta.esVakra)
    }

    /// Todo recorrido del catálogo sale de la tónica, llega a la otra y pasa por todos los grados.
    @Test func losDelCatalogoVanDeTonicaATonicaPorTodosLosGrados() {
        let vakra = TipoDeEscala.catalogo.filter(\.esVakra)
        #expect(
            vakra.map(\.nombre) == [
                "Ānandabhairavi", "Suruṭṭi", "Aṭāṇā", "Kēdāram", "Darbār", "Mukhāri", "Gauḷa", "Nalinakānti",
                "Kathanakutūhalam", "Bēgaḍa", "Sahānā", "Rītigauḷa", "Darbārī Kānaḍa carnática",
                "Kāpi", "Kānaḍa", "Nīlāmbari", "Nāyaki", "Sāraṅga", "Śrī carnática", "Hamīr Kalyāṇi", "Yamunā Kalyāṇi",
                "Dēvamanōhari", "Behāg carnática", "Khamās", "Kuriñji", "Navarōj", "Deś", "Bihāg",
                "Darbārī Kānaḍa", "Kedār",
            ])
        for tipo in vakra {
            let subida = tipo.intervalos.count
            let bajada = (tipo.intervalosDescendentes ?? tipo.intervalos).count
            let grado = { (n: Int, de: Int) in ((n - 1) % de + de) % de }
            // Pasan por todos los grados, en alguna octava, sin salirse de la de abajo ni de la de arriba. Casi todos
            // van de tónica a tónica; los de ámbito corto, como Kuriñji (de Ni a Dha) y Navarōj (de Pa a Pa), no.
            if let recorrido = tipo.recorrido {
                #expect(recorrido.first! <= 1, Comment(rawValue: tipo.nombre))
                #expect(Set(recorrido.map { grado($0, subida) }) == Set(0..<subida), Comment(rawValue: tipo.nombre))
                #expect(recorrido.allSatisfy { $0 > -subida && $0 <= subida + 1 }, Comment(rawValue: tipo.nombre))
            }
            if let recorrido = tipo.recorridoDescendente {
                #expect(recorrido.last! <= 1, Comment(rawValue: tipo.nombre))
                #expect(Set(recorrido.map { grado($0, bajada) }) == Set(0..<bajada), Comment(rawValue: tipo.nombre))
                #expect(recorrido.allSatisfy { $0 > -bajada && $0 <= bajada + 1 }, Comment(rawValue: tipo.nombre))
            }
            // La bajada empieza donde acaba la subida.
            let escala = Escala(.do, tipo)
            #expect(
                escala.alturas(octava: 4).last == escala.alturas(octava: 4, sentido: .descendente).first,
                Comment(rawValue: tipo.nombre))
        }
    }

    /// Los de ámbito corto, los que bajan hasta el Ni de abajo y los indostánicos con su recorrido.
    @Test func losQueNoVanDeTonicaATonica() {
        #expect(alturas(.kurinji) == ["Si3", "Do4", "Re4", "Mi4", "Fa4", "Sol4", "La4"])
        #expect(alturas(.kurinji, .descendente) == ["La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4", "Si3"])
        #expect(alturas(.navaroj) == ["Sol3", "La3", "Si3", "Do4", "Re4", "Mi4", "Fa4", "Sol4"])
        #expect(alturas(.navaroj, .descendente) == ["Sol4", "Fa4", "Mi𝄫4", "Re♯4", "Do4", "Si♭3", "La3", "Sol3"])
        #expect(alturas(.des) == ["Si3", "Do4", "Re4", "Fa4", "Sol4", "Si4", "Do5"])
        #expect(
            alturas(.des, .descendente) == [
                "Do5", "Si♭4", "La4", "Sol4", "La4", "Fa4", "Mi4", "Re4", "Sol4", "Fa4", "Mi4", "Re4", "Mi4", "Si3",
                "Do4",
            ])
        #expect(alturas(.kedar) == ["Do4", "Fa4", "Mi4", "Sol4", "La4", "Si4", "Do5"])
        #expect(alturas(.kedar, .descendente) == ["Do5", "Si4", "La4", "Sol4", "Fa♯4", "Sol4", "Fa4", "Re4", "Do4"])
        #expect(
            alturas(.darbariKanada, .descendente) == [
                "Do5", "La♭4", "Si♭4", "Sol4", "Fa4", "Sol4", "Mi♭4", "Fa4", "Re4", "Do4",
            ])
        #expect(!TipoDeEscala.sindhuBhairavi.esVakra && TipoDeEscala.sindhuBhairavi.notasExternas.count == 5)
    }

    @Test func seGuardaEnJSONYLoQueNoLoTraeSeLeeSinEl() throws {
        let datos = try JSONEncoder().encode(TipoDeEscala.surutti)
        let objeto = try #require(JSONSerialization.jsonObject(with: datos) as? [String: Any])
        #expect(objeto["recorrido"] as? [Int] == [1, 2, 3, 4, 6, 5, 6, 7])
        #expect(objeto["recorridoDescendente"] as? [Int] == [8, 7, 6, 5, 4, 3, 5, 4, 2, 1])
        let leida = try JSONDecoder().decode(TipoDeEscala.self, from: datos)
        #expect(leida.recorrido == TipoDeEscala.surutti.recorrido && leida.esIdentico(a: .surutti))
        let sinRecorrido = try JSONSerialization.jsonObject(with: JSONEncoder().encode(TipoDeEscala.kafi))
        #expect((sinRecorrido as? [String: Any])?["recorrido"] == nil)
        #expect(
            try JSONDecoder().decode(TipoDeEscala.self, from: JSONEncoder().encode(TipoDeEscala.kafi)).esVakra == false)
    }
}
