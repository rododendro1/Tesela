import Armonia
import Testing

@testable import Interfaz

@Suite struct AjustesDeLasAppsTests {
    @Test func cadaTemperamentoParaEscucharSeGuardaYSeLee() {
        for temperamento in TemperamentoQueAfina.paraEscuchar {
            let clave = AjustesDeLasApps.claveDeTemperamento(temperamento)
            #expect(AjustesDeLasApps.temperamento(deClave: clave) == temperamento)
        }
        let claves = TemperamentoQueAfina.paraEscuchar.map(AjustesDeLasApps.claveDeTemperamento)
        #expect(Set(claves).count == claves.count)
    }

    @Test func lasClavesGuardadasAntesSeSiguenLeyendo() {
        #expect(AjustesDeLasApps.temperamento(deClave: "igual") == .temperamentoIgual)
        #expect(AjustesDeLasApps.temperamento(deClave: "mesotonico") == .mesotonicoCuartoDeComa)
        #expect(AjustesDeLasApps.temperamento(deClave: "justa") == .afinacionJusta)
        #expect(AjustesDeLasApps.temperamento(deClave: "nada") == nil)
    }
}
