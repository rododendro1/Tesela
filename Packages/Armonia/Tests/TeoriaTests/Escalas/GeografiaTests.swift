import Testing

@testable import Elementos
@testable import Teoria

@Suite struct GeografiaTests {
    /// Las populares occidentales que vienen de un lugar declaran su región, y siguen siendo occidentales.
    @Test func lasPopularesTienenSuRegion() {
        #expect(TipoDeEscala.flamenca.regiones == [.andalucia])
        #expect(TipoDeEscala.mayorRumana.regiones == [.rumania])
        #expect(TipoDeEscala.menorHungara.regiones == [.hungria])
        #expect(TipoDeEscala.mayorHungara.regiones == [.hungria])
        #expect(TipoDeEscala.pentatonicaEscocesa.regiones == [.escocia])
        #expect(TipoDeEscala.doricoCuartaAumentada.regiones == [.ucrania, .rumania])
        for tipo in TipoDeEscala.occidentales where !tipo.regiones.isEmpty {
            #expect(tipo.estilos == [.popular], Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.occidentales.filter { !$0.regiones.isEmpty }.count == 6)
        #expect(RegionDeEscala.andalucia.tipos == [.flamenca])
        #expect(RegionDeEscala.hungria.tipos.contains(.menorHungara))
        #expect(RegionDeEscala.hungria.tipos.contains(.pentatonicaHungara))
    }

    /// Como subtradición, una región solo da las escalas de su tradición: la de Hungría, que es europea, no da las
    /// húngaras occidentales; la de Andalucía, que es occidental, da la flamenca.
    @Test func lasSubtradicionesSonDeSuTradicion() {
        #expect(Subtradicion.region(.hungria).tipos.contains(.pentatonicaHungara))
        #expect(!Subtradicion.region(.hungria).tipos.contains(.menorHungara))
        #expect(Subtradicion.region(.andalucia).tipos == [.flamenca])
        #expect(TipoDeEscala.menorHungara.subtradiciones == [.estilo(.popular)])
        #expect(TipoDeEscala.flamenca.subtradiciones == [.estilo(.popular), .region(.andalucia)])
    }

    /// Los lugares de origen son los más concretos que se saben: la región, el país o el continente.
    @Test func lugaresDeOrigen() {
        #expect(TipoDeEscala.flamenca.lugaresDeOrigen == [.region(.andalucia)])
        #expect(TipoDeEscala.flamenca.paisesDeOrigen == [.espana])
        #expect(TipoDeEscala.flamenca.continentesDeOrigen == [.europa])
        #expect(TipoDeEscala.slendro.lugaresDeOrigen == [.region(.java), .region(.bali)])
        #expect(TipoDeEscala.slendro.paisesDeOrigen == [.indonesia])
        #expect(TipoDeEscala.slendro.continentesDeOrigen == [.asia])
        #expect(TipoDeEscala.bilaval.lugaresDeOrigen == [.pais(.india)])
        #expect(TipoDeEscala.mayor.lugaresDeOrigen == [.continente(.europa)])
        #expect(TipoDeEscala.mayor.paisesDeOrigen.isEmpty)
        #expect(TipoDeEscala.bayati.lugaresDeOrigen == [.continente(.asia), .continente(.africa)])
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).lugaresDeOrigen.isEmpty)
        // Todas las del catálogo tienen alguno.
        for tipo in TipoDeEscala.catalogo {
            #expect(!tipo.lugaresDeOrigen.isEmpty, Comment(rawValue: tipo.nombre))
        }
    }

    /// Un lugar sabe en cuáles está.
    @Test func losLugaresQueLoContienen() {
        #expect(Lugar.region(.andalucia).contenidoEn == [.pais(.espana), .continente(.europa)])
        #expect(Lugar.region(.alpes).contenidoEn == [.pais(.suiza), .pais(.austria), .continente(.europa)])
        #expect(Lugar.pais(.georgia).contenidoEn == [.continente(.europa)])
        #expect(Lugar.pais(.turquia).contenidoEn == [.continente(.asia)])
        #expect(Lugar.continente(.asia).contenidoEn.isEmpty)
        #expect(Lugar.continente(.asia).conLosQueLoContienen == [.continente(.asia)])
        for region in RegionDeEscala.allCases {
            #expect(!region.paises.isEmpty, "\(region)")
        }
        #expect(Tradicion.corea.paises == [.coreaDelSur, .coreaDelNorte])
        #expect(Tradicion.mundoArabe.paises.isEmpty && Tradicion.mundoArabe.continentes == [.asia, .africa])
        #expect(Tradicion.occidental.continentes == [.europa])
    }

    /// Los lugares de uso son los de origen de las escalas con sus mismas notas, sin los de origen.
    @Test func lugaresDeUso() {
        let frigioDominante = TipoDeEscala.frigioDominante.lugaresDeUso
        #expect(frigioDominante.contains(.continente(.asia)) && frigioDominante.contains(.continente(.africa)))
        #expect(frigioDominante.contains(.pais(.turquia)) && frigioDominante.contains(.pais(.grecia)))
        #expect(!frigioDominante.contains(.continente(.europa)))
        // Primero los continentes, luego los países y luego las regiones.
        #expect(frigioDominante == frigioDominante.sorted { $0.orden < $1.orden })
        #expect(TipoDeEscala.dorico.lugaresDeUso.contains(.region(.georgia)))
        // El dórico ucraniano es de Ucrania, que ya es de origen del dórico ♯4.
        #expect(!TipoDeEscala.doricoCuartaAumentada.lugaresDeUso.contains(.region(.ucrania)))
        #expect(TipoDeEscala.persa.lugaresDeUso.isEmpty)
        for tipo in TipoDeEscala.catalogo {
            let origen = Set(tipo.lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
            #expect(tipo.lugaresDeUso.allSatisfy { !origen.contains($0) }, Comment(rawValue: tipo.nombre))
        }
    }

    /// La persa, la egipcia, la oriental y las napolitanas no vienen de donde dice su nombre: son de Europa.
    @Test func losNombresGeograficosSinOrigen() {
        for tipo in TipoDeEscala.nombresGeograficosSinOrigen {
            #expect(tipo.nombreGeograficoSinOrigen, Comment(rawValue: tipo.nombre))
            #expect(tipo.regiones.isEmpty, Comment(rawValue: tipo.nombre))
            #expect(tipo.lugaresDeOrigen == [.continente(.europa)], Comment(rawValue: tipo.nombre))
            #expect(TipoDeEscala.occidentales.contains { $0.esIdentico(a: tipo) }, Comment(rawValue: tipo.nombre))
        }
        #expect(!TipoDeEscala.flamenca.nombreGeograficoSinOrigen)
        #expect(!TipoDeEscala(nombre: "persa", intervalos: [.unisono, .quintaJusta]).nombreGeograficoSinOrigen)
    }

    /// Los continentes, los países y las regiones nuevas tienen nombre en los trece idiomas; los países, su código.
    @Test func nombres() {
        #expect(RegionDeEscala.andalucia.nombre == "Andalucía")
        #expect(RegionDeEscala.rumania.nombre(en: .delIdioma(.aleman)) == "Rumänien")
        #expect(Pais.espana.nombre == "España")
        #expect(Pais.reinoUnido.nombre(en: .delIdioma(.ingles)) == "United Kingdom")
        #expect(Continente.africa.nombre == "África")
        #expect(Lugar.pais(.japon).nombre == "Japón")
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            #expect(!RegionDeEscala.andalucia.nombre(en: notacion).isEmpty)
            #expect(!RegionDeEscala.rumania.nombre(en: notacion).isEmpty)
            for continente in Continente.allCases {
                #expect(!continente.nombre(en: notacion).isEmpty, "\(continente) \(idioma)")
            }
            for pais in Pais.allCases {
                #expect(!pais.nombre(en: notacion).isEmpty, "\(pais) \(idioma)")
            }
        }
        let codigos = Pais.allCases.map(\.codigoISO)
        #expect(Set(codigos).count == codigos.count)
        #expect(codigos.allSatisfy { $0.count == 2 && $0.allSatisfy(\.isUppercase) })
        #expect(Pais.espana.codigoISO == "ES" && Pais.reinoUnido.codigoISO == "GB")
    }
}
