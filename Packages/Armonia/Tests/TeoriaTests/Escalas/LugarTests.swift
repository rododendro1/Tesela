import Testing

@testable import Elementos
@testable import Teoria

@Suite struct LugarTests {
    /// Las populares occidentales que vienen de un lugar declaran su región, y siguen siendo occidentales.
    @Test func lasPopularesTienenSuRegion() {
        #expect(TipoDeEscala.flamenca.regiones == [.andalucia])
        #expect(TipoDeEscala.mayorRumana.regiones == [.rumania])
        #expect(TipoDeEscala.menorHungara.regiones == [.hungria])
        #expect(TipoDeEscala.mayorHungara.regiones == [.hungria])
        #expect(TipoDeEscala.pentatonicaEscocesa.regiones == [.escocia])
        #expect(TipoDeEscala.doricoCuartaAumentada.regiones == [.ucrania, .rumania])
        for tipo in TipoDeEscala.occidentales where !tipo.regiones.isEmpty {
            #expect(tipo.estilos.allSatisfy { $0.esPopular }, Comment(rawValue: tipo.nombre))
            #expect(tipo.tradicion == .occidental, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.occidentales.filter { !$0.regiones.isEmpty }.count == 6)
        #expect(RegionDeEscala.andalucia.tipos == [.flamenca])
        #expect(RegionDeEscala.hungria.tipos.contains(.menorHungara))
        #expect(RegionDeEscala.hungria.tipos.contains(.pentatonicaHungara))
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
        #expect(TipoDeEscala.bayati.lugaresDeOrigen == ZonaMusical.allCases.map(Lugar.zona))
        #expect(TipoDeEscala.bayati.continentesDeOrigen == [.asia, .africa])
        #expect(TipoDeEscala.echosProtos.lugaresDeOrigen == [.historico(.bizancio)])
        #expect(TipoDeEscala.echosProtos.paisesDeOrigen == [.grecia, .turquia])
        #expect(TipoDeEscala.freygish.lugaresDeOrigen == [.pueblo(.asquenazi)])
        #expect(
            TipoDeEscala.menorHungara.lugaresDeOrigen
                == [.pueblo(.romani), .region(.hungria)].sorted { $0.orden < $1.orden })
        #expect(TipoDeEscala.menorHungara.paisesDeOrigen == [.hungria])
        // El jazz y el blues son de Estados Unidos.
        #expect(TipoDeEscala.alterada.lugaresDeOrigen == [.pais(.estadosUnidos)])
        #expect(TipoDeEscala.alterada.continentesDeOrigen == [.america])
        #expect(TipoDeEscala.dorico.lugaresDeOrigen == [.continente(.europa)])
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
        #expect(frigioDominante.contains(.zona(.levante)) && frigioDominante.contains(.zona(.magreb)))
        #expect(frigioDominante.contains(.pais(.turquia)) && frigioDominante.contains(.pais(.grecia)))
        #expect(frigioDominante.contains(.pueblo(.asquenazi)))
        #expect(!frigioDominante.contains(.continente(.europa)))
        // Primero los continentes, luego los países y luego las regiones.
        #expect(frigioDominante == frigioDominante.sorted { $0.orden < $1.orden })
        #expect(TipoDeEscala.dorico.lugaresDeUso == [.pais(.estadosUnidos)])
        // Las notas iguales son coincidencias, no usos: el dórico coincide con la georgiana y la mayor con Bilāval.
        #expect(TipoDeEscala.dorico.lugaresQueCoinciden.contains(.region(.georgia)))
        #expect(TipoDeEscala.mayor.lugaresQueCoinciden.contains(.pais(.india)))
        #expect(!TipoDeEscala.mayor.lugaresDeUso.contains(.pais(.india)))
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
        #expect(TipoDeEscala.argelina.nombreGeograficoSinOrigen)
        #expect(TipoDeEscala.argelina.referencias.contains(.finkRicci1975))
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

    /// Las familias tienen las mismas notas, al subir o al bajar, y sus escalas no se repiten.
    @Test func lasFamilias() {
        var vistas: [TipoDeEscala] = []
        for familia in TipoDeEscala.familias {
            for tipo in familia {
                let bajando = tipo.intervalosDescendentes.map { TipoDeEscala(nombre: "", intervalos: $0) }
                #expect(tipo == familia[0] || bajando == familia[0], Comment(rawValue: tipo.nombre))
                #expect(!vistas.contains { $0.esIdentico(a: tipo) }, Comment(rawValue: tipo.nombre))
                vistas.append(tipo)
            }
        }
        #expect(TipoDeEscala.hiyaz.parientes.contains(.frigioDominante))
        #expect(TipoDeEscala.mayor.parientes.isEmpty)
    }

    /// Las zonas, los pueblos y los lugares históricos, con sus países y sus nombres.
    @Test func zonasPueblosYLugaresHistoricos() {
        #expect(Lugar.zona(.levante).contenidoEn.contains(.pais(.siria)))
        #expect(Lugar.zona(.magreb).contenidoEn.contains(.continente(.africa)))
        #expect(
            Lugar.historico(.bizancio).contenidoEn == [
                .pais(.grecia), .pais(.turquia), .continente(.europa), .continente(.asia),
            ])
        #expect(Lugar.pueblo(.romani).contenidoEn == [.continente(.europa)])
        #expect(Lugar.region(.andalucia).esta(en: .continente(.europa)))
        #expect(!Lugar.region(.andalucia).esta(en: .pais(.grecia)))
        #expect(LugarHistorico.bizancio.nombre == Tradicion.bizancio.nombre)
        #expect(ZonaMusical.egipto.nombre == Pais.egipto.nombre)
        #expect(Pais.estadosUnidos.codigoISO == "US" && Pais.estadosUnidos.continente == .america)
        #expect(Set(Lugar.todos).count == Lugar.todos.count)
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            for lugar in Lugar.todos {
                #expect(!lugar.nombre(en: notacion).isEmpty, "\(lugar) \(idioma)")
            }
        }
        for zona in ZonaMusical.allCases { #expect(!zona.paises.isEmpty) }
    }
}
