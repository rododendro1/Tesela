import Testing

@testable import Elementos
@testable import Teoria

struct CorrienteTests {
    /// Cada corriente de una escala es de uno de sus estilos, y cada corriente tiene alguna escala.
    @Test func cadaCorrienteEsDeUnEstiloDeLaEscala() {
        for tipo in TipoDeEscala.occidentales {
            for corriente in tipo.corrientes {
                #expect(tipo.estilos.contains(corriente.estilo), Comment(rawValue: "\(tipo.nombre): \(corriente)"))
            }
        }
        for corriente in Corriente.allCases {
            #expect(!corriente.tipos.isEmpty, Comment(rawValue: corriente.rawValue))
            #expect(corriente.estilo.corrientes.contains(corriente))
        }
        #expect(TipoDeEscala.tradicionales.allSatisfy { $0.corrientes.isEmpty })
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta]).corrientes.isEmpty)
    }

    @Test func ejemplos() {
        #expect(TipoDeEscala.dorico.corrientes == [.modal])
        #expect(TipoDeEscala.alterada.corrientes == [.bebop])
        #expect(TipoDeEscala.frigioDominante.corrientes == [.heavyMetal, .metalNeoclasico])
        #expect(TipoDeEscala.menorArmonica.estilos == [.clasica, .popRock])
        #expect(TipoDeEscala.menorArmonica.corrientes == [.metalNeoclasico])
        #expect(Estilo.jazz.corrientes == [.bebop, .modal])
        #expect(Estilo.clasica.corrientes.isEmpty)
        #expect(Corriente.modal.anio == 1959 && Corriente.modal.estilo == .jazz)
        #expect(Corriente.bebop.tipos.contains(.bebopDominante))
    }

    /// Las épocas de uso de una corriente van de la de su año a la de su fin, o hasta el siglo XXI.
    @Test func lasEpocasDeUnaCorriente() {
        #expect(Corriente.impresionismo.epocasDeUso == [.romanticismo, .sigloXX])
        #expect(Corriente.bebop.epocasDeUso == [.sigloXX, .sigloXXI])
        #expect(Corriente.metalNeoclasico.epocasDeUso == [.sigloXX, .sigloXXI])
        // Las corrientes precisan las épocas de su estilo: el impresionismo ya es del Romanticismo.
        #expect(TipoDeEscala.tonosEnteros.epocasDeUso(de: .deCompositor) == [.romanticismo, .sigloXX])
        #expect(TipoDeEscala.mayor.epocasDeUso(de: .jazz) == Estilo.jazz.epocasDeUso)
        #expect(TipoDeEscala.menorArmonica.epocasDeUso.contains(.sigloXXI))
    }

    @Test func losNombres() {
        #expect(Corriente.modal.nombre == "jazz modal")
        #expect(Corriente.modal.nombre(en: .ascii(.ingles)) == "modal jazz")
        #expect(Corriente.metalNeoclasico.nombre(en: .compacta(.ruso)) == "неоклассический метал")
        for idioma in Idioma.allCases {
            let nombres = Corriente.allCases.map { $0.nombre(en: Notacion.compacta(.espanol).conTextos(en: idioma)) }
            #expect(Set(nombres).count == nombres.count, Comment(rawValue: "\(idioma)"))
        }
    }
}
