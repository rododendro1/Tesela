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
        #expect(SistemaDeNombres(nombre: "Jūni-ritsu") == .luJaponeses)
        #expect(SistemaDeNombres(nombre: "luChinos") == .luChinos)
        #expect(SistemaDeNombres(nombre: "iroha") == .japones)
        #expect(
            SistemaDeNombres.allCases.filter { $0.familia == .movil }
                == [.sargam, .jianpu, .gongche, .wusheng, .carnatico, .tonicSolFa, .notasDeForma])
        #expect(SistemaDeNombres(nombre: "shape notes") == .notasDeForma)
        #expect(SistemaDeNombres(nombre: "Tonic sol-fa") == .tonicSolFa)
    }

    @Test func japones() throws {
        let japones = SistemaDeNombres.japones
        let naturales = NotaNatural.allCases.map { Nota($0) }
        #expect(japones.nombres(de: naturales, grafia: .original) == ["ハ", "ニ", "ホ", "ヘ", "ト", "イ", "ロ"])
        #expect(japones.nombre(de: Nota("Fa#"), grafia: .original) == "嬰ヘ")
        #expect(japones.nombre(de: Nota("Sib"), grafia: .original) == "変ロ")
        #expect(japones.nombre(de: Nota("Sibb"), grafia: .original) == "重変ロ")
        #expect(japones.nombre(de: Nota("Fa#")) == "ei He")
        #expect(japones.nombre(de: Nota("Fa##"), grafia: .ascii) == "ju-ei He")
        #expect(japones.nombre(de: Nota("Fa###")) == "jū-ei He♯")
        #expect(try japones.leer("嬰ヘ") == Nota("Fa#"))
        #expect(try japones.leer("hen ro") == Nota("Sib"))
        #expect(try japones.leer("Ei-I") == Nota("La#"))
        #expect(try japones.leer("I") == Nota("La"))
        #expect(try japones.leer("he") == Nota("Fa"))
    }

    @Test func coreano() throws {
        let coreano = SistemaDeNombres.coreano
        let naturales = NotaNatural.allCases.map { Nota($0) }
        #expect(coreano.nombres(de: naturales, grafia: .original) == ["다", "라", "마", "바", "사", "가", "나"])
        #expect(coreano.nombre(de: Nota("Fa#"), grafia: .original) == "올림바")
        #expect(coreano.nombre(de: Nota("Sib"), grafia: .original) == "내림나")
        #expect(coreano.nombre(de: Nota("Mibb"), grafia: .original) == "겹내림마")
        #expect(coreano.nombre(de: Nota("Sib")) == "naerim Na")
        #expect(try coreano.leer("올림바") == Nota("Fa#"))
        #expect(try coreano.leer("naerim na") == Nota("Sib"))
        #expect(try coreano.leer("Na") == Nota("Si"))
    }

    @Test func guidoniano() throws {
        let guidoniano = SistemaDeNombres.guidoniano
        #expect(guidoniano.nombre(de: Nota("Do")) == "Ut")
        #expect(guidoniano.nombre(de: Nota("Do#")) == "Ut♯")
        #expect(guidoniano.nombre(de: Nota("Sib"), grafia: .ascii) == "Sib")
        #expect(try guidoniano.leer("ut") == Nota("Do"))
        #expect(try guidoniano.leer("Sol#") == Nota("Sol#"))
        #expect(throws: ErrorDeLectura.self) { try guidoniano.leer("Do") }
    }

    @Test func luChinos() throws {
        let lu = SistemaDeNombres.luChinos
        let cromatica: [Nota] = ["Do", "Do#", "Re", "Re#", "Mi", "Fa", "Fa#", "Sol", "Sol#", "La", "La#", "Si"]
        let original = ["黄钟", "大吕", "太簇", "夹钟", "姑洗", "仲吕", "蕤宾", "林钟", "夷则", "南吕", "无射", "应钟"]
        #expect(lu.nombres(de: cromatica, grafia: .original) == original)
        #expect(lu.nombre(de: Nota("Do")) == "huángzhōng")
        #expect(lu.nombre(de: Nota("Reb")) == "dàlǚ")
        #expect(lu.nombre(de: Nota("Si"), grafia: .ascii) == "yingzhong")
        // Al leerlos, la grafía de los sostenidos, como en los doce lü del catálogo: zhònglǚ es Mi♯.
        #expect(try lu.leer("大吕") == Nota("Do#"))
        #expect(try lu.leer("大呂") == Nota("Do#"))
        #expect(try lu.leer("dalü") == Nota("Do#"))
        #expect(try lu.leer("dalv") == Nota("Do#"))
        #expect(try lu.leer("Zhònglǚ") == Nota("Mi#"))
        #expect(try lu.leer("huang zhong") == Nota("Do"))
    }

    @Test func luJaponeses() throws {
        let lu = SistemaDeNombres.luJaponeses
        #expect(lu.nombre(de: Nota("Re")) == "ichikotsu")
        #expect(lu.nombre(de: Nota("La"), grafia: .original) == "黄鐘")
        #expect(lu.nombre(de: Nota("Mi")) == "hyōjō")
        #expect(lu.nombre(de: Nota("Do#"), grafia: .ascii) == "kamimu")
        #expect(try lu.leer("壱越") == Nota("Re"))
        #expect(try lu.leer("oshiki") == Nota("La"))
        #expect(try lu.leer("shōsetsu") == Nota("Fa"))
        #expect(try lu.leer("tangin") == Nota("Re#"))
        #expect(try lu.leer("shinsen") == Nota("Do"))
    }

    @Test func luCoreanos() throws {
        let lu = SistemaDeNombres.luCoreanos
        #expect(lu.nombre(de: Nota("Mib"), grafia: .original) == "황종")
        #expect(lu.nombre(de: Nota("Mib")) == "hwangjong")
        #expect(lu.nombre(de: Nota("Re"), grafia: .original) == "응종")
        #expect(lu.nombre(de: Nota("Sib")) == "imjong")
        #expect(try lu.leer("황종") == Nota("Mib"))
        #expect(try lu.leer("黃鍾") == Nota("Mib"))
        #expect(try lu.leer("黃") == Nota("Mib"))
        #expect(try lu.leer("林") == Nota("Sib"))
        #expect(try lu.leer("namnyeo") == Nota("Do"))
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

    @Test func jianpu() throws {
        let jianpu = SistemaDeNombres.jianpu
        let dorico: [Nota] = ["Re", "Mi", "Fa", "Sol", "La", "Si", "Do"]
        #expect(jianpu.nombres(de: dorico, tonica: Nota("Re")) == ["1", "2", "♭3", "4", "5", "6", "♭7"])
        #expect(jianpu.nombre(de: Nota("Fa#")) == "♯4")
        #expect(jianpu.nombre(de: Nota("Fa#"), grafia: .ascii) == "#4")
        #expect(jianpu.nombre(de: Nota("Sibb"), grafia: .ascii) == "bb7")
        #expect(try jianpu.leer("b7") == Nota("Sib"))
        #expect(try jianpu.leer("♯4", tonica: Nota("Sol")) == Nota("Do#"))
        #expect(try jianpu.leer("4#") == Nota("Fa#"))
    }

    @Test func gongche() throws {
        let gongche = SistemaDeNombres.gongche
        let mayor: [Nota] = ["Sol", "La", "Si", "Do", "Re", "Mi", "Fa#"]
        #expect(
            gongche.nombres(de: mayor, tonica: Nota("Sol"), grafia: .original) == ["上", "尺", "工", "凡", "六", "五", "乙"])
        #expect(gongche.nombre(de: Nota("Re")) == "chě")
        #expect(try gongche.leer("liu") == Nota("Sol"))
        #expect(try gongche.leer("凡♯") == Nota("Fa#"))
    }

    @Test func wusheng() throws {
        let wusheng = SistemaDeNombres.wusheng
        let pentatonica: [Nota] = ["Do", "Re", "Mi", "Sol", "La"]
        #expect(wusheng.nombres(de: pentatonica, grafia: .original) == ["宫", "商", "角", "徵", "羽"])
        #expect(wusheng.nombres(de: pentatonica) == ["gōng", "shāng", "jué", "zhǐ", "yǔ"])
        // Las otras cuatro: qīngjué, biànzhǐ, rùn y biàngōng.
        let otras: [Nota] = ["Fa", "Fa#", "Sib", "Si"]
        #expect(wusheng.nombres(de: otras, grafia: .original) == ["清角", "变徵", "闰", "变宫"])
        #expect(wusheng.nombres(de: otras, grafia: .ascii) == ["qingjue", "bianzhi", "run", "biangong"])
        #expect(try wusheng.leer("zhi", tonica: Nota("Fa")) == Nota("Do"))
        #expect(try wusheng.leer("變徵") == Nota("Fa#"))
        #expect(try wusheng.leer("jue") == Nota("Mi"))
        #expect(try wusheng.leer("qīngjué") == Nota("Fa"))
    }

    @Test func carnatico() throws {
        let carnatico = SistemaDeNombres.carnatico
        let doce: [Nota] = ["Do", "Reb", "Re", "Re#", "Mibb", "Mib", "Mi", "Fa", "Fa#", "Sol", "Lab", "La", "La#"]
        #expect(
            carnatico.nombres(de: doce)
                == ["Sa", "Ri₁", "Ri₂", "Ri₃", "Ga₁", "Ga₂", "Ga₃", "Ma₁", "Ma₂", "Pa", "Da₁", "Da₂", "Da₃"])
        let septimas: [Nota] = ["Sibb", "Sib", "Si"]
        #expect(carnatico.nombres(de: septimas, grafia: .ascii) == ["Ni1", "Ni2", "Ni3"])
        // Ri₂ y Ga₁ suenan igual y se escriben distinto, como Re y Mi𝄫.
        #expect(try carnatico.leer("Ri2") == Nota("Re"))
        #expect(try carnatico.leer("Ga₁") == Nota("Mibb"))
        #expect(try carnatico.leer("G2") == Nota("Mib"))
        #expect(try carnatico.leer("M2", tonica: Nota("Re")) == Nota("Sol#"))
        #expect(try carnatico.leer("S") == Nota("Do"))
    }

    @Test func tonicSolFaYNotasDeForma() throws {
        let mayor: [Nota] = ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"]
        #expect(SistemaDeNombres.tonicSolFa.nombres(de: mayor) == ["d", "r", "m", "f", "s", "l", "t"])
        #expect(SistemaDeNombres.tonicSolFa.nombre(de: Nota("Sib"), tonica: Nota("Fa"), grafia: .ascii) == "f")
        #expect(try SistemaDeNombres.tonicSolFa.leer("s", tonica: Nota("Re")) == Nota("La"))
        let formas = SistemaDeNombres.notasDeForma
        #expect(formas.nombres(de: mayor) == ["fa", "sol", "la", "fa", "sol", "la", "mi"])
        // Fa, sol y la nombran dos grados: al leerlos, el más bajo.
        #expect(try formas.leer("fa") == Nota("Do"))
        #expect(try formas.leer("la") == Nota("Mi"))
        #expect(try formas.leer("mi", tonica: Nota("Sol")) == Nota("Fa#"))
    }

    @Test func idaYVuelta() throws {
        // Las notas de forma no vuelven: fa, sol y la son dos grados cada una.
        for sistema in SistemaDeNombres.allCases where sistema != .notasDeForma {
            for grafia in Grafia.allCases {
                for tonica in [Nota("Do"), Nota("Re"), Nota("Sib")] {
                    for quintas in -14...14 {
                        let nota = Nota(pasosDeQuinta: tonica.pasosDeQuinta + quintas)
                        let nombre = sistema.nombre(de: nota, tonica: tonica, grafia: grafia)
                        let leida = try sistema.leer(nombre, tonica: tonica)
                        // Los lü nombran la clase de altura: se vuelve a la misma, con la grafía de su cadena.
                        let doce = [.luChinos, .luJaponeses, .luCoreanos].contains(sistema)
                        if doce {
                            #expect(leida.claseDeAltura == nota.claseDeAltura, "\(sistema) \(grafia) \(nombre)")
                        } else {
                            #expect(leida == nota, "\(sistema) \(grafia) \(nombre)")
                        }
                    }
                }
            }
        }
    }
}
