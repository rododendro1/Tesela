import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Los nombres de las escalas en la escritura de su tradición (`TipoDeEscala.nombresOriginales`).
@Suite struct NombresOriginalesTests {
    /// Todas las escalas del catálogo, las tradicionales y las occidentales, sin repetir.
    private static let catalogo: [TipoDeEscala] = {
        var vistas = Set<IdentidadDeEscala>()
        return TipoDeEscala.catalogo.filter { vistas.insert($0.identidad).inserted }
    }()

    /// Las tradiciones cuyas escalas llevan su nombre original, salvo las de `sinNombreOriginal`.
    private static let tradicionesConEscrituraPropia: Set<Tradicion> = [
        .india, .mundoArabe, .persia, .china, .japon, .corea, .etiopia, .grecia, .bizancio, .sudesteAsiatico,
        .klezmer,
    ]

    /// Las escalas de esas tradiciones que aún no lo tienen (los huecos de `Docs/HUECOS_DEL_CATALOGO.md`) o cuyo
    /// nombre no lo tiene (el mayor y el menor etíopes llevan el original en el mayor).
    private static let sinNombreOriginal: Set<String> = ["Təzəta menor", "Bati menor"]

    @Test func cadaTextoEstaEnSuEscrituraYEnNFC() {
        for tipo in Self.catalogo {
            for original in tipo.nombresOriginales {
                #expect(!original.texto.isEmpty, "\(tipo.nombre)")
                #expect(
                    original.texto.precomposedStringWithCanonicalMapping.unicodeScalars.elementsEqual(
                        original.texto.unicodeScalars), "\(tipo.nombre): \(original.texto) no está en NFC")
                #expect(
                    original.idioma.escritura.contiene(original.texto),
                    "\(tipo.nombre): \(original.texto) no está en \(original.idioma.escritura)")
            }
        }
    }

    /// El persa escribe ی y ک, y el árabe, ي y ك: la otra forma es casi siempre un error al copiar.
    @Test func elArabeYElPersaUsanSusLetras() {
        let persas: Set<Character> = ["\u{06CC}", "\u{06A9}", "\u{06AF}", "\u{067E}"] // ی ک گ پ
        let arabes: Set<Character> = ["\u{064A}", "\u{0643}"] // ي ك
        for tipo in Self.catalogo {
            for original in tipo.nombresOriginales {
                switch original.idioma {
                case .arabe: #expect(original.texto.allSatisfy { !persas.contains($0) }, "\(original.texto)")
                case .persa: #expect(original.texto.allSatisfy { !arabes.contains($0) }, "\(original.texto)")
                default: break
                }
            }
        }
    }

    @Test func laLecturaEstaEnLetraLatinaYNoEsElNombre() {
        for tipo in Self.catalogo {
            for original in tipo.nombresOriginales {
                guard let lectura = original.lectura else { continue }
                #expect(lectura != tipo.nombre, "\(tipo.nombre): \(original.texto) sobra la lectura")
                #expect(!TipoDeEscala.tieneEscrituraNoLatina(lectura), "\(tipo.nombre): \(lectura)")
            }
        }
    }

    /// `variantes` es solo de escritura latina: lo demás va en `nombresOriginales`.
    @Test func lasVariantesYLosAliasSonLatinos() {
        for tipo in Self.catalogo {
            for otro in tipo.alias + tipo.variantes {
                #expect(!TipoDeEscala.tieneEscrituraNoLatina(otro), "\(tipo.nombre): \(otro)")
            }
        }
    }

    @Test func noSeRepitenEnUnaEscala() {
        for tipo in Self.catalogo {
            let textos = tipo.nombresOriginales.map(\.texto)
            #expect(Set(textos).count == textos.count, "\(tipo.nombre): \(textos)")
        }
    }

    @Test func lasEscalasDeLasTradicionesConEscrituraPropiaLoTienen() {
        for tipo in Self.catalogo {
            guard let tradicion = tipo.tradicion, Self.tradicionesConEscrituraPropia.contains(tradicion) else {
                continue
            }
            let tiene = !tipo.nombresOriginales.isEmpty
            #expect(tiene != Self.sinNombreOriginal.contains(tipo.nombre), "\(tipo.nombre)")
        }
    }

    /// De la Grecia antigua, las que tienen nombre en los teóricos: las harmoniai y los géneros y sus colores.
    @Test func lasGriegasAntiguas() {
        #expect(
            TipoDeEscala.harmoniaDoria.nombreOriginal == NombreOriginal("δωριστί", .griegoAntiguo, lectura: "dōristí"))
        #expect(TipoDeEscala.tetracordoCromaticoBlandoDeAristoxeno.nombreOriginal?.texto == "χρῶμα μαλακόν")
        #expect(TipoDeEscala.harmoniaDoriaCromatica.nombresOriginales.isEmpty)
        #expect(TipoDeEscala.freygish.nombresOriginales.map(\.idioma) == [.yidis, .hebreo])
        #expect(IdiomaOriginal.hebreo.deDerechaAIzquierda && !IdiomaOriginal.birmano.deDerechaAIzquierda)
    }

    /// La forma completa, con la palabra de la categoría delante o detrás, y sin repetirla.
    @Test func losNombresOriginalesCompletos() {
        #expect(TipoDeEscala.hiyaz.nombreOriginalCompleto?.texto == "مقام حجاز")
        #expect(TipoDeEscala.mahur.nombreOriginalCompleto?.texto == "دستگاه ماهور")
        #expect(TipoDeEscala.yaman.nombreOriginalCompleto?.texto == "राग यमन")
        #expect(TipoDeEscala.bilaval.nombreOriginalCompleto?.texto == "थाट बिलावल")
        #expect(TipoDeEscala.melakarta(1)?.nombreOriginalCompleto?.texto == "मेळ कनकाङ्गी")
        #expect(TipoDeEscala.ousak.nombreOriginalCompleto?.texto == "δρόμος Ουσάκ")
        #expect(TipoDeEscala.tezetaMayor.nombreOriginalCompleto?.texto == "ትዝታ ቅኝት")
        #expect(TipoDeEscala.gong.nombresOriginalesCompletos.map(\.texto) == ["宫调", "宮調"])
        #expect(TipoDeEscala.zhi.nombresOriginalesCompletos.map(\.texto) == ["徵調", "徴"])
        // Las que ya la llevan, o cuya categoría no la tiene, se quedan como están.
        for tipo in [TipoDeEscala.jinsSaba, .shaddRast, .echosProtos, .pyongjo, .yo, .freygish, .harmoniaDoria] {
            #expect(tipo.nombresOriginalesCompletos == tipo.nombresOriginales, "\(tipo.nombre)")
        }
        #expect(TipoDeEscala.buscar(nombre: "مقام حجاز")?.esIdentico(a: .hiyaz) == true)
        for tipo in Self.catalogo {
            #expect(tipo.nombresOriginalesCompletos.count == tipo.nombresOriginales.count, "\(tipo.nombre)")
            for (corto, completo) in zip(tipo.nombresOriginales, tipo.nombresOriginalesCompletos) {
                #expect(completo.texto.contains(corto.texto) && completo.idioma == corto.idioma, "\(tipo.nombre)")
            }
        }
    }

    @Test func lasDemasNoLoTienen() {
        for tipo in TipoDeEscala.occidentales { #expect(tipo.nombresOriginales.isEmpty, "\(tipo.nombre)") }
        #expect(TipoDeEscala.rastMakami.nombresOriginales.isEmpty)
        #expect(TipoDeEscala(nombre: "propia", intervalos: [.unisono, .quintaJusta]).nombresOriginales.isEmpty)
    }

    /// El nombre de las escalas griegas y bizantinas en la tabla griega es su nombre original.
    @Test func laTablaGriegaEscribeElNombreOriginal() {
        let griegos = NombresDeEscalas.de(.griego)
        for tipo in Self.catalogo where tipo.tradicion == .grecia || tipo.tradicion == .bizancio {
            guard let original = tipo.nombreOriginal, let enGriego = griegos.tradicionales[tipo.identidad] else {
                continue
            }
            #expect(enGriego.nombre.lowercased() == original.texto.lowercased(), "\(tipo.nombre)")
        }
    }

    @Test func seLeenPorSuNombreOriginalEnTodosLosIdiomas() {
        for tipo in Self.catalogo {
            for original in tipo.nombresOriginales {
                // Dos escalas pueden compartir el nombre original (δωριστί, la doria y la de Arístides): basta con
                // que la que se encuentra lo tenga.
                #expect(
                    TipoDeEscala.buscar(nombre: original.texto)?.nombresOriginales.contains(original) == true,
                    "\(tipo.nombre): \(original.texto)")
                for idioma in Idioma.allCases where !tipo.nombresOriginales.isEmpty {
                    let indice = NombresDeEscalas.de(idioma).indice
                    #expect(
                        indice[TipoDeEscala.normalizar(original.texto)] != nil, "\(idioma): \(original.texto)")
                }
            }
        }
    }

    @Test func ejemplos() {
        #expect(TipoDeEscala.hiyaz.nombreOriginal == NombreOriginal("حجاز", .arabe))
        #expect(TipoDeEscala.gong.nombresOriginales.map(\.idioma) == [.chinoSimplificado, .chinoTradicional])
        #expect(TipoDeEscala.yo.nombresOriginales.map(\.lectura) == [nil, "Yō onkai"])
        #expect(TipoDeEscala.melakartas[14].nombreOriginal == NombreOriginal("मायामालवगौळ", .sanscrito))
        #expect(TipoDeEscala.bilaval.nombreOriginal?.idioma == .hindi)
        #expect(IdiomaOriginal.persa.deDerechaAIzquierda && !IdiomaOriginal.hindi.deDerechaAIzquierda)
        #expect(IdiomaOriginal.chinoTradicional.nombre(en: .compacta(.ingles)) == "traditional Chinese")
        #expect(IdiomaOriginal.arabe.nombre == "árabe")
    }

    /// Lo que se escribe con teclado persa encuentra el maqām árabe, y sin harakat.
    @Test func laBusquedaIgualaElArabeYElPersa() {
        #expect(TipoDeEscala.buscar(nombre: "سیکاه")?.esIdentico(a: .sikah) == true)
        #expect(TipoDeEscala.buscar(nombre: "بَيَاتِي")?.esIdentico(a: .bayati) == true)
        #expect(TipoDeEscala.buscar(nombre: "ปี่พาทย์")?.esIdentico(a: .piphat) == true)
    }

    /// Un JSON con la escritura original en `variantes`, como los de antes, se sigue leyendo, y la escala toma sus
    /// nombres originales del catálogo.
    @Test func losJSONAntiguosSiguenValiendo() throws {
        let json = #"{"nombre":"Bayātī","clave":"bayati","intervalos":[],"alias":[],"variantes":["Bayyātī","بياتي"]}"#
        let leido = try JSONDecoder().decode(TipoDeEscala.self, from: Data(json.utf8))
        #expect(leido.nombresOriginales.map(\.texto) == ["بياتي"])
    }

    /// Los mēḷa en telugu y en canarés salen del devanagari con las tres reglas de `nombresDeMelakartaEnTelugu`.
    @Test func losMelaYLosJanyaEnTeluguYEnCanaresSalenDelDevanagari() {
        let virama: UInt32 = 0x94D
        // Cada nasal y las consonantes de su grupo (ङ: क…ङ; ञ: च…ञ; ण: ट…ण; न: त…न; म: प…म).
        let grupos: [UInt32: ClosedRange<UInt32>] = [
            0x919: 0x915...0x919, 0x91E: 0x91A...0x91E, 0x923: 0x91F...0x923, 0x928: 0x924...0x928,
            0x92E: 0x92A...0x92E,
        ]
        func pasar(_ devanagari: String, desplazamiento: UInt32) -> String {
            var letras = devanagari.unicodeScalars.map(\.value)
            var salida: [UInt32] = []
            var i = 0
            while i < letras.count {
                if let grupo = grupos[letras[i]], i + 2 < letras.count, letras[i + 1] == virama,
                    grupo.contains(letras[i + 2])
                {
                    salida.append(0x902)
                    i += 2
                } else {
                    salida.append(letras[i])
                    i += 1
                }
            }
            letras = salida
            if letras.suffix(2) == [0x92E, virama] { letras = letras.dropLast(2) + [0x902] }
            if letras.last == 0x940 {
                letras[letras.count - 1] = 0x93F
            } else if letras.last == 0x93E {
                letras.removeLast()
            }
            var texto = String.UnicodeScalarView()
            for letra in letras {
                texto.append(Unicode.Scalar((0x900...0x97F).contains(letra) ? letra + desplazamiento : letra)!)
            }
            return String(texto).precomposedStringWithCanonicalMapping
        }
        let devanagari = TipoDeEscala.nombresDeMelakartaEnDevanagari
        #expect(devanagari.map { pasar($0, desplazamiento: 0x300) } == TipoDeEscala.nombresDeMelakartaEnTelugu)
        #expect(devanagari.map { pasar($0, desplazamiento: 0x380) } == TipoDeEscala.nombresDeMelakartaEnCanares)
        // Los janya, igual: el telugu y el canarés salen del sánscrito.
        for janya in TipoDeEscala.janyas {
            let textos = Dictionary(janya.nombresOriginales.map { ($0.idioma, $0.texto) }) { a, _ in a }
            let sanscrito = try? #require(textos[.sanscrito], Comment(rawValue: janya.nombre))
            #expect(
                textos[.telugu] == sanscrito.map { pasar($0, desplazamiento: 0x300) }, Comment(rawValue: janya.nombre))
            #expect(
                textos[.canares] == sanscrito.map { pasar($0, desplazamiento: 0x380) }, Comment(rawValue: janya.nombre))
        }
        #expect(TipoDeEscala.suddhaSaveri.nombresOriginales[1].texto == "శుద్ధ సావేరి")
        let kanakangi = try? #require(TipoDeEscala.melakarta(1))
        #expect(kanakangi?.nombresOriginales.map(\.texto) == ["कनकाङ्गी", "కనకాంగి", "ಕನಕಾಂಗಿ", "கனகாங்கி"])
        #expect(kanakangi?.nombreOriginal?.idioma == .sanscrito)
        #expect(
            kanakangi?.nombresOriginalesCompletos.map(\.texto) == [
                "मेळ कनकाङ्गी", "మేళ కనకాంగి", "ಮೇಳ ಕನಕಾಂಗಿ", "கனகாங்கி",
            ])
        #expect(TipoDeEscala.melakarta(29)?.nombresOriginales[1].texto == "ధీరశంకరాభరణం")
        #expect(TipoDeEscala.melakarta(56)?.nombresOriginales[2].texto == "ಷಣ್ಮುಖಪ್ರಿಯ")
        #expect(TipoDeEscala.buscar(nombre: "ఖరహరప్రియ")?.esIdentico(a: .melakarta(22)!) == true)
        #expect(TipoDeEscala.buscar(nombre: "ಕೀರವಾಣಿ")?.esIdentico(a: .melakarta(21)!) == true)
        #expect(IdiomaOriginal.telugu.escritura == .telugu && IdiomaOriginal.canares.escritura == .kannada)
        #expect(IdiomaOriginal.canares.nombre(en: .compacta(.espanol)) == "canarés")
        // El tamil no lleva la palabra mēḷa: no tiene una forma fija.
        #expect(TipoDeEscala.nombresDeMelakartaEnTamil.count == 72)
        #expect(Set(TipoDeEscala.nombresDeMelakartaEnTamil).count == 72)
        #expect(TipoDeEscala.melakarta(22)?.nombresOriginales.last == NombreOriginal("கரகரப்பிரியா", .tamil))
        #expect(TipoDeEscala.buscar(nombre: "சண்முகப்பிரியா")?.esIdentico(a: .melakarta(56)!) == true)
        #expect(IdiomaOriginal.tamil.escritura.codigo == "Taml")
    }
}
