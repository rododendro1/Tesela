import Foundation
import Testing

@testable import ArmoniaElementos

/// Los nombres de nota de otras tradiciones: el bizantino, fijo (Ni es Do), y el sargam, móvil (Sā es la tónica).
@Suite struct SistemasDeNombresTests {
    @Test func familias() {
        #expect(SistemaDeNombres.bizantino.familia == .fija)
        #expect(SistemaDeNombres.sargam.familia == .movil)
        #expect(SistemaDeNombres(nombre: "Bizantino") == .bizantino)
        #expect(SistemaDeNombres(nombre: "byzantine") == .bizantino)
        #expect(SistemaDeNombres(nombre: "SARGAM") == .sargam)
        #expect(SistemaDeNombres(nombre: "solfeo") == nil)
    }

    @Test func bizantinoEnSusTresGrafias() {
        let naturales = NotaNatural.allCases.map { Nota($0) }
        #expect(SistemaDeNombres.bizantino.nombres(de: naturales) == ["Ni", "Pa", "Vou", "Ga", "Di", "Ke", "Zo"])
        #expect(
            SistemaDeNombres.bizantino.nombres(de: naturales, grafia: .original)
                == ["Νη", "Πα", "Βου", "Γα", "Δι", "Κε", "Ζω"])
        #expect(SistemaDeNombres.bizantino.nombre(de: Nota("Fa#")) == "Ga♯")
        #expect(SistemaDeNombres.bizantino.nombre(de: Nota("Sib"), grafia: .ascii) == "Zob")
        #expect(SistemaDeNombres.bizantino.nombre(de: Nota("Mibb"), grafia: .original) == "Βου♭♭")
    }

    @Test func elBizantinoEsFijo() throws {
        // La tónica no cambia los nombres: Re es Pa con cualquiera.
        #expect(SistemaDeNombres.bizantino.nombre(de: Nota("Re"), tonica: Nota("Sol")) == "Pa")
        #expect(try SistemaDeNombres.bizantino.leer("Pa", tonica: Nota("Sol")) == Nota("Re"))
    }

    @Test func sargamDesdeDo() {
        let sargam = SistemaDeNombres.sargam
        let cromatica: [Nota] = ["Do", "Reb", "Re", "Mib", "Mi", "Fa", "Fa#", "Sol", "Lab", "La", "Sib", "Si"]
        #expect(
            sargam.nombres(de: cromatica)
                == ["Sā", "re", "Re", "ga", "Ga", "ma", "Ma", "Pa", "dha", "Dha", "ni", "Ni"])
        #expect(
            sargam.nombres(de: cromatica, grafia: .ascii)
                == ["Sa", "re", "Re", "ga", "Ga", "ma", "Ma", "Pa", "dha", "Dha", "ni", "Ni"])
        let original = [
            "सा", "रे\u{0952}", "रे", "ग\u{0952}", "ग", "म", "म\u{0951}", "प", "ध\u{0952}", "ध", "नि\u{0952}", "नि",
        ]
        #expect(sargam.nombres(de: cromatica, grafia: .original) == original)
    }

    @Test func sargamDesdeOtraTonica() {
        let sargam = SistemaDeNombres.sargam
        // Re dórico: Sā Re ga ma Pa Dha ni.
        let dorico: [Nota] = ["Re", "Mi", "Fa", "Sol", "La", "Si", "Do"]
        #expect(sargam.nombres(de: dorico, tonica: Nota("Re")) == ["Sā", "Re", "ga", "ma", "Pa", "Dha", "ni"])
        #expect(sargam.nombre(de: Nota("Sol#"), tonica: Nota("Re")) == "Ma")
    }

    @Test func sargamSinNombrePropio() {
        let sargam = SistemaDeNombres.sargam
        // Lo que el sargam no nombra va con signos: el Sā sostenido, el Re doble bemol (re y un bemol más), el Ma
        // doble sostenido.
        #expect(sargam.nombre(de: Nota("Do#")) == "Sā♯")
        #expect(sargam.nombre(de: Nota("Rebb")) == "re♭")
        #expect(sargam.nombre(de: Nota("Fa##"), grafia: .ascii) == "Ma#")
        #expect(sargam.nombre(de: Nota("Fab")) == "ma♭")
        #expect(sargam.nombre(de: Nota("Re#")) == "Re♯")
    }

    @Test func leerBizantino() throws {
        let bizantino = SistemaDeNombres.bizantino
        #expect(try bizantino.leer("Ni") == Nota("Do"))
        #expect(try bizantino.leer("ΝΗ") == Nota("Do"))
        #expect(try bizantino.leer("Νή") == Nota("Do"))
        #expect(try bizantino.leer("Γα♯") == Nota("Fa#"))
        #expect(try bizantino.leer("vou b") == Nota("Mib"))
        #expect(try bizantino.leer("Bou") == Nota("Mi"))
        #expect(try bizantino.leer("zo") == Nota("Si"))
        #expect(throws: ErrorDeLectura.self) { try bizantino.leer("Sa") }
        #expect(throws: ErrorDeLectura.self) { try bizantino.leer("") }
    }

    @Test func leerSargam() throws {
        let sargam = SistemaDeNombres.sargam
        #expect(try sargam.leer("Sā") == Nota("Do"))
        #expect(try sargam.leer("Sa") == Nota("Do"))
        #expect(try sargam.leer("sa") == Nota("Do"))
        // Las mayúsculas cuentan: re es el komal y Ma el tivra.
        #expect(try sargam.leer("Re") == Nota("Re"))
        #expect(try sargam.leer("re") == Nota("Reb"))
        #expect(try sargam.leer("ma") == Nota("Fa"))
        #expect(try sargam.leer("Ma") == Nota("Fa#"))
        #expect(try sargam.leer("Dha") == Nota("La"))
        #expect(try sargam.leer("dha") == Nota("Lab"))
        #expect(try sargam.leer("Re#") == Nota("Re#"))
        // En devanagari, con la raya del komal y el trazo del tivra.
        #expect(try sargam.leer("रे\u{0952}") == Nota("Reb"))
        #expect(try sargam.leer("म\u{0951}") == Nota("Fa#"))
        #expect(try sargam.leer("नि") == Nota("Si"))
        // Desde otra tónica.
        #expect(try sargam.leer("ga", tonica: Nota("Re")) == Nota("Fa"))
        #expect(throws: ErrorDeLectura.self) { try sargam.leer("Vou") }
    }

    @Test func idaYVuelta() throws {
        for sistema in SistemaDeNombres.allCases {
            for grafia in Grafia.allCases {
                for tonica in [Nota("Do"), Nota("Re"), Nota("Sib")] {
                    for quintas in -14...14 {
                        let nota = Nota(pasosDeQuinta: tonica.pasosDeQuinta + quintas)
                        let nombre = sistema.nombre(de: nota, tonica: tonica, grafia: grafia)
                        let leida = try sistema.leer(nombre, tonica: tonica)
                        #expect(leida == nota, "\(sistema) \(grafia) \(nombre)")
                    }
                }
            }
        }
    }
}
