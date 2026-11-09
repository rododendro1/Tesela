import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las referencias bibliográficas del catálogo (`Referencia`, `TipoDeEscala.referencias`).
@Suite struct ReferenciasTests {
    /// Todas las obras citadas, por las escalas, sus listas, sus fuentes y sus afinaciones, y por los acordes.
    private var citadas: [Referencia] {
        TipoDeEscala.catalogo.flatMap(\.referencias)
            + TipoDeEscala.listasTradicionales.flatMap(\.referencias)
            + FuenteTeorica.allCases.compactMap(\.referencia)
            + AcordeConNombre.catalogo.flatMap(\.referencias)
    }

    @Test func cadaObraEstaUnaVezEnElCatalogoYSeCita() {
        let claves = Referencia.catalogo.map(\.clave)
        #expect(Set(claves).count == claves.count)
        let usadas = Set(citadas.map(\.clave))
        for obra in Referencia.catalogo {
            #expect(usadas.contains(obra.clave), "nadie cita \(obra.clave)")
            #expect(obra.paginasCitadas == nil, Comment(rawValue: obra.clave))
            #expect(!obra.autores.isEmpty && !obra.titulo.isEmpty, Comment(rawValue: obra.clave))
            if obra.clase != .web { #expect(obra.anio != nil, Comment(rawValue: obra.clave)) }
            if obra.clase == .articulo || obra.clase == .capitulo {
                #expect(obra.publicadoEn != nil, Comment(rawValue: obra.clave))
            }
        }
        // Y ninguna escala cita una obra que no esté en el catálogo.
        #expect(usadas.isSubset(of: Set(claves)))
    }

    /// La clave es el apellido del primer autor (o el nombre de la web) y el año.
    @Test func laClaveLlevaElAnio() {
        for obra in Referencia.catalogo {
            if let anio = obra.anio { #expect(obra.clave.hasSuffix(String(anio)), Comment(rawValue: obra.clave)) }
        }
    }

    @Test func citaYDescripcion() {
        #expect(Referencia.west1992.cita == "West 1992")
        #expect(Referencia.west1992.paginas("160–172").cita == "West 1992: 160–172")
        #expect(Referencia.farraj2019.cita == "Farraj & Abu Shumays 2019")
        #expect(Referencia.surjodiningrat1972.cita == "Surjodiningrat et al. 1972")
        #expect(Referencia.maqamWorld.cita == "Maqam World")
        #expect(
            Referencia.west1992.descripcion == "West, M. L. (1992). Ancient Greek Music. Oxford: Clarendon Press.")
        #expect(
            Referencia.kilmer1971.descripcion
                == "Kilmer, Anne Draffkorn (1971). The Discovery of an Ancient Mesopotamian Theory of Music. "
                + "Proceedings of the American Philosophical Society 115 (2): 131–149.")
        #expect(
            Referencia.maqamWorld.descripcion
                == "Farraj, Johnny; Abu Shumays, Sami. Maqam World. https://www.maqamworld.com")
        // Una cita es la obra con sus páginas.
        let cita = Referencia.west1992.paginas("160")
        #expect(cita != .west1992 && cita.obra == .west1992 && cita.id == "west1992:160")
    }

    @Test func unicasQuitaLasRepetidas() {
        let citas: [Referencia] = [.west1992, .barker1989, .west1992.paginas("12"), .barker1989]
        #expect(Referencia.unicas(citas).map(\.id) == ["barker1989", "west1992:12"])
        #expect(Referencia.sinRepetir(citas).map(\.clave) == ["west1992", "barker1989"])
    }

    @Test func lasEscalasTienenLasDeSuListaSuFuenteYSusAfinaciones() {
        #expect(TipoDeEscala.bayati.referencias == [.maqamWorld, .touma1996, .farraj2019])
        // Ptolomeo, por su fuente (Barker), y su lista.
        #expect(TipoDeEscala.tetracordoDiatonicoTenso.referencias == [.barker1989, .chalmers1993, .west1992])
        // Los echoi, por la afinación de Chrysanthos.
        #expect(TipoDeEscala.echosProtos.referencias.contains(.chrysanthos1832))
        #expect(TipoDeEscala.echosProtos.afinaciones[1].referencias == [.chrysanthos1832])
        #expect(TipoDeEscala.echosProtos.microtonal?.referencias == [])
        // El dórico con ficta: Barbour, por su lista, y los tratados de Zarlino, Salinas y Ramos.
        #expect(
            TipoDeEscala.escalasRenacentistas[0].referencias
                == [.barbour1951, .zarlino1558, .salinas1577, .ramos1482])
        #expect(TipoDeEscala.hardino.referencias == [.knight1973])
        // Las propias y las occidentales sintéticas no tienen.
        #expect(TipoDeEscala.lidioSegundaAumentada.referencias.isEmpty)
        #expect(TipoDeEscala(nombre: "mía", intervalos: TipoDeEscala.bayati.intervalos).referencias.isEmpty)
    }

    /// Las occidentales, por `referenciasOccidentales`, y los acordes genéricos, por su declaración.
    @Test func lasOccidentalesYLosAcordesTienenLasSuyas() {
        #expect(TipoDeEscala.mayor.referencias == [.aldwell2011, .powers2001, .levine1995])
        #expect(
            TipoDeEscala.lidioDominante.referencias == [.levine1995, .persichetti1961, .lendvai1971, .tymoczko2011])
        #expect(TipoDeEscala.flamenca.referencias == [.manuel1989])
        #expect(TipoDeEscala.aumentada.referencias == [.tymoczko2011, .cohn1996])
        #expect(AcordeConNombre.dominanteSeptima.referencias == [.aldwell2011, .levine1995])
        #expect(AcordeConNombre.potencia.referencias == [.walser1993])
    }

    @Test func bibtex() {
        let texto = Referencia.bibtex([.kilmer1971, .west1992.paginas("5"), .west1992])
        #expect(
            texto == """
                @article{kilmer1971,
                  author = {Kilmer, Anne Draffkorn},
                  title = {The Discovery of an Ancient Mesopotamian Theory of Music},
                  journal = {Proceedings of the American Philosophical Society},
                  volume = {115 (2)},
                  pages = {131--149},
                  year = {1971}
                }

                @book{west1992,
                  author = {West, M. L.},
                  title = {Ancient Greek Music},
                  publisher = {Clarendon Press},
                  address = {Oxford},
                  year = {1992}
                }
                """)
        #expect(Referencia.bibtex([.farraj2019]).contains("author = {Farraj, Johnny and Abu Shumays, Sami}"))
        #expect(Referencia.bibtex([.knight1973]).hasPrefix("@phdthesis{knight1973,"))
        #expect(Referencia.bibtex([.knight1973]).contains("school = {University of California, Los Angeles}"))
    }

    @Test func cslJSON() throws {
        let datos = Data(Referencia.cslJSON([.farraj2019, .maqamWorld, .powers2001]).utf8)
        let objetos = try #require(try JSONSerialization.jsonObject(with: datos) as? [[String: Any]])
        #expect(objetos.map { $0["id"] as? String } == ["farraj2019", "maqamWorld", "powers2001"])
        #expect(objetos.map { $0["type"] as? String } == ["book", "webpage", "chapter"])
        let autores = try #require(objetos[0]["author"] as? [[String: String]])
        #expect(autores == [["family": "Farraj", "given": "Johnny"], ["family": "Abu Shumays", "given": "Sami"]])
        #expect(objetos[1]["issued"] == nil && objetos[1]["URL"] as? String == "https://www.maqamworld.com")
        #expect((objetos[2]["issued"] as? [String: [[Int]]])?["date-parts"] == [[2001]])
    }

    @Test func lasFuentesTienenSuObra() {
        #expect(FuenteTeorica.ptolomeo.referencia == .barker1989)
        #expect(FuenteTeorica.zarlino.referencia == .zarlino1558)
        #expect(FuenteTeorica.guido.referencia == nil)
        for fuente in FuenteTeorica.allCases where fuente != .guido {
            #expect(fuente.referencia != nil, Comment(rawValue: fuente.rawValue))
        }
    }
}
