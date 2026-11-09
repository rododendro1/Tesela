// swift-format-ignore-file
// Generado por Scripts/generadores/generar_pruebas_de_documentacion.py a partir de los bloques ```swift
// del README y del catálogo DocC. No lo edites a mano: cambia el ejemplo y vuelve a generarlo.

import Foundation
import Testing
@testable import Armonia
import Hexagonos

@Suite struct EjemplosDeDocumentacionTests {
    @Test func readme1() throws {
        // README.md, bloque 1
        let doc = BloqueDeDocumentacion(#"README.md"#, 1)
        let i = Altura("Re5") - Altura("Do4")
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, doc, 3)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, doc, 4)
        comprobar(Altura("La4").frecuencia(), #"440.0"#, doc, 5)
        comprobar(Altura(midi: 63, ventana: .bemoles), #"Mi♭4"#, doc, 6)
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, doc, 8)
        comprobar(Acorde.identificar(notas: [.mi, .sol, .do]).first, #"Do/Mi"#, doc, 9)
        let menor = Escala("La menor armónica")
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, doc, 12)
        comprobar(Escala("Mib mayor").armadura, #"-3"#, doc, 14)
        comprobar(Escala(.do).modo(grado: 2), #"Re dórico"#, doc, 15)
        _ = i
    }

    @Test func acordes1() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 1)
        comprobar(Acorde("G7(b9,#11)").cifrado, #""Sol7(♭9,♯11)""#, doc, 0)
        comprobar(TipoDeAcorde("m11").cifrado, #""m11""#, doc, 1)
        comprobar(TipoDeAcorde("13sus4").intervalos, #"[1ª justa, 4ª justa, 5ª justa, 7ª menor, 9ª mayor, 13ª mayor]"#, doc, 2)
        comprobar(TipoDeAcorde("7alt").cifrado, #""7(♭9,♯9,♯11,♭13)""#, doc, 3)
        _ = Acorde("Do6/9/Mi")
        comprobar(Acorde("Do/Re").tieneBajoAjeno, #"true"#, doc, 5)
    }

    @Test func acordes2() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 2)
        let c = Acorde.candidatos(notas: [.do, .mi, "Sib"]).first!
        comprobar(c.valor.cifrado, #""Do7""#, doc, 1)
        comprobar(c.omitidas, #"[Sol]"#, doc, 2)
        comprobar(Acorde.identificar(notas: [.do, .mi, "Sib", "Reb"]).first, #"Do7(♭9)"#, doc, 3)
    }

    @Test func acordes3() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 3)
        comprobar(Acorde("Lab(#6,omit5)").tipo.nombre, #""sexta aumentada italiana""#, doc, 0)
        comprobar(Acorde.identificar(notas: ["La♭", "Do", "Fa♯"] as [Nota]).first?.cifrado, #""La♭(♯6,omit5)""#, doc, 1)
        comprobar(Acorde.identificar(notas: ["La♭", "Do", "Mi♭", "Fa♯"] as [Nota]).first?.cifrado, #""La♭(♯6)""#, doc, 2)
    }

    @Test func acordes4() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 4)
        comprobar(AcordeConNombre.dominanteSeptima.nombre, #""séptima de dominante""#, doc, 0)
        comprobar(AcordeConNombre.dominanteSeptima.tipo?.cifrado, #""7""#, doc, 1)
        comprobar(AcordeConNombre.dominanteSeptima.notas(sobre: .sol), #"[Sol, Si, Re, Fa]"#, doc, 2)
        comprobar(TipoDeAcorde.dominanteSeptima.acordeConNombre == .dominanteSeptima, #"true"#, doc, 3)
        comprobar(AcordeConNombre.sextaAumentadaAlemana.estilos, #"[clasica]"#, doc, 4)
    }

    @Test func acordes5() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 5)
        comprobar(AcordeConNombre.tristan.notas(sobre: .fa), #"[Fa, Si, Re♯, Sol♯]"#, doc, 0)
        comprobar(AcordeConNombre.tristan.referencias.map(\.cita), #"["Rothgeb 1995"]"#, doc, 1)
        comprobar(AcordeConNombre.dominanteSeptima.referencias.map(\.cita), #"["Aldwell et al. 2011", "Levine 1995"]"#, doc, 2)
        comprobar(AcordeConNombre.petrushka.tipo, #"nil"#, doc, 3)
        comprobar(TipoDeAcorde.mayorNovenaAnadida.acordesConNombre, #"[novena añadida, acorde mu]"#, doc, 4)
    }

    @Test func acordes6() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 6)
        comprobar(AcordeConNombre.dominanteSeptima.nombre(en: .conPalabras(.ingles)), #"dominant seventh"#, doc, 0)
        comprobar(AcordeConNombre.buscar(nombre: "Tristan chord") == .tristan, #"true"#, doc, 1)
        comprobar(AcordeConNombre.buscar(conteniendo: "sexta aumentada").count, #"4"#, doc, 2)
    }

    @Test func acordes7() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 7)
        comprobar(TipoDeAcorde.dominanteSeptima.cardinal?.nombre, #""tétrada""#, doc, 0)
        comprobar(TipoDeAcorde.potencia.cardinal?.nombre(en: .conPalabras(.ingles)), #""dyad""#, doc, 1)
        comprobar(AcordeConNombre.petrushka.numeroDeNotas, #"6"#, doc, 2)
        comprobar(TipoDeAcorde.todos(numeroDeNotas: 3).count, #"6"#, doc, 3)
    }

    @Test func acordes8() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 8)
        comprobar(TipoDeAcorde.dominanteSeptima.estadisticas.brilloPorQuintas, #"0.75"#, doc, 0)
        comprobar(TipoDeAcorde.dominanteSeptima.estadisticas.numeroDeForte, #""4-27""#, doc, 1)
        comprobar(TipoDeAcorde.disminuidoSeptima.estadisticas.transposicionesDistintas, #"3"#, doc, 2)
        comprobar(AcordeConNombre.tristan.estadisticas.ambito, #"15"#, doc, 3)
        comprobar(AcordeConNombre.petrushka.estadisticas.porTerceras, #"false"#, doc, 4)
    }

    @Test func acordes9() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 9)
        comprobar(Acorde.identificar(midi: [60, 64, 68]).first, #"Do+"#, doc, 0)
        comprobar(Acorde.identificar(midi: [60, 63, 66, 69]).first, #"Do°7"#, doc, 1)
        comprobar(Acorde.identificar(midi: [61, 65, 68]).first, #"Re♭"#, doc, 2)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, doc, 3)
        comprobar(Acorde.identificar(midi: [66, 70, 73], tonalidad: "Solb mayor").first, #"Sol♭"#, doc, 4)
        comprobar(Acorde("Do+").ortografiar(midi: [60, 64, 68]), #"[Do4, Mi4, Sol♯4]"#, doc, 5)
    }

    @Test func acordes10() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 10)
        let a: Acorde = "Sol13(b9)"
        comprobar(a.componentes.map { "\($0.nota) \($0.papel)" }, #"["Sol fundamental", "Si tercera", "Re quinta", "Fa séptima", "La♭ novena", "Mi decimotercera"]"#, doc, 1)
        _ = (a.tercera, a.quinta, a.septima)
        comprobar(a.tensiones, #"[La♭, Mi]"#, doc, 4)
        comprobarIgual(a.papel(de: "Lab"), .tension(9), doc, 5)
        comprobarIgual(a.estructura.calidadDeTriada, .mayor, doc, 6)
        comprobar(TipoDeAcorde("7sus4").estructura.suspension, #"4ª justa"#, doc, 7)
    }

    @Test func acordes11() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 11)
        comprobar(Acorde("Sol7").vecinosParsimoniosos().map(\.description) == ["Sol♯°7 (Sol→Sol♯)", "Solm7 (Si→Si♭)", "Mim7 (Fa→Mi)"], #"true"#, doc, 0)
        comprobar(Acorde("Sol7").vecinosParsimoniosos(voces: 2).contains { $0.acorde == Acorde("Reb7") }, #"true"#, doc, 1)
        comprobar(Acorde("Sol7").caminoParsimonioso(hasta: "Rem7")?.map(\.acorde.cifrado) == ["Sol♯°7", "Sim7(♭5)", "Rem7"], #"true"#, doc, 2)
        comprobar(Acorde("Sol7").caminoParsimonioso(hasta: "Reb7", voces: 2)?.count == 1, #"true"#, doc, 3)
        comprobar(Acorde("Domaj7").vecinosParsimoniosos().map(\.description) == ["Do♯m7(♭5) (Do→Do♯)", "Do7 (Si→Si♭)"], #"true"#, doc, 4)
        comprobar(Acorde("Domaj7").caminoParsimonioso(hasta: "Sol7")?.count == 3, #"true"#, doc, 5)
    }

    @Test func acordes12() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 12)
        comprobar("\(Acorde("Sol7").conduccionMinima(hasta: "Do"))", #""Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos""#, doc, 0)
        comprobar(Acorde("Rem7").conduccionMinima(hasta: "Sol7").semitonosMovidos == 3, #"true"#, doc, 1)
        comprobar(Acorde("Do").conduccionMinima(hasta: "Lam").semitonosMovidos == 2, #"true"#, doc, 2)
    }

    @Test func acordes13() throws {
        // Sources/Armonia/Armonia.docc/Acordes.md, bloque 13
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Acordes.md"#, 13)
        comprobar(Acorde("Sol7").disposiciones(.cuartal).isEmpty, #"false"#, doc, 0)
        comprobar(DisposicionDeAcorde.cuartal.voces, #"4"#, doc, 1)
    }

    @Test func afinacionYRepresentaciones1() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 1)
        _ = TemperamentoRegular.igual
        _ = TemperamentoRegular.pitagorico
        _ = TemperamentoRegular.mesotonicoCuartoDeComa
        _ = TemperamentoRegular.igual(divisiones: 31)
        _ = AfinacionJusta(tonica: .do)
        _ = Altura("Sol#4").frecuencia(en: TemperamentoRegular.mesotonicoCuartoDeComa)
        comprobar(Intervalo.terceraMayor.razonJusta, #"5/4"#, doc, 6)
        comprobar(TemperamentoRegular.igual.cents(de: .terceraMayor), #"400"#, doc, 7)
        comprobar(AfinacionJusta(tonica: .do).desviacion(de: "Mi4"), #"−13,69 cents"#, doc, 8)
    }

    @Test func afinacionYRepresentaciones2() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 2)
        let werckmeister = TemperamentoCircular.werckmeisterIII
        comprobar(werckmeister.desviaciones[4], #"−9,78"#, doc, 1)
        comprobar(werckmeister.frecuencia(de: "Sol#4") == werckmeister.frecuencia(de: "Lab4"), #"true"#, doc, 2)
        comprobar(TemperamentoCircular.kirnbergerIII.cents(desde: "Do4", hasta: "Mi4"), #"386,31"#, doc, 3)
        comprobar(TemperamentoCircular.vallotti.afinar(frecuenciaDelLa4: 415).frecuencia(de: "La4"), #"415"#, doc, 4)
        comprobar(TemperamentoCircular(nombre: "mío", quintas: Array(repeating: 701, count: 12)), #"nil"#, doc, 5)
    }

    @Test func afinacionYRepresentaciones3() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 3)
        comprobar(AfinacionHistorica.allCases.count, #"8"#, doc, 0)
        comprobar(AfinacionHistorica.justa.afinacion(tonica: .re).desviacion(de: "Fa#4"), #"−13,69"#, doc, 1)
        comprobar(AfinacionHistorica.mesotonico.distingueEnarmonicas, #"true"#, doc, 2)
        comprobar(AfinacionHistorica.vallotti.nombre(en: .conPalabras(.ruso)), #""Валлотти""#, doc, 3)
    }

    @Test func afinacionYRepresentaciones4() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 4)
        let bayati = Escala(.re, .bayati).afinacion()!
        comprobar(bayati.desviacion(de: "Mib4"), #"50"#, doc, 1)
        comprobar(bayati.desviacion(de: "Mi4"), #"0"#, doc, 2)
        comprobar(Escala(.re, .bayati).afinacion(la4: 442)?.frecuencia(de: "La4"), #"442"#, doc, 3)
        comprobar(TipoDeEscala.echosProtos.afinaciones.count, #"2"#, doc, 4)
        comprobarIgual(TipoDeEscala.echosProtos.afinaciones[1].fuente, .chrysanthos, doc, 5)
        let chrysanthos = TipoDeEscala.echosProtos.afinaciones[1]
        comprobar(Escala(.re, .echosProtos).afinacion(microtonal: chrysanthos)?.desviacion(de: "Mi4"), #"−29"#, doc, 7)
        comprobar(Escala(.do, .mayor).afinacion(), #"nil"#, doc, 8)
    }

    @Test func afinacionYRepresentaciones5() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 5)
        comprobar(Escala(.do, .mayor).cents(en: .justa)[2], #"386,31"#, doc, 0)
        comprobar(Escala(.do, .mayor).cents(en: .werckmeisterIII)[2], #"390,22"#, doc, 1)
        comprobar(Escala(Nota(.re, .bemol), .mayor).cents(en: .werckmeisterIII)[2], #"407,82"#, doc, 2)
        comprobarIgual(TipoDeEscala.protusAuthenticus.afinacionSugerida, .pitagorico, doc, 3)
        comprobar(Escala(.re, .protusAuthenticus).cents(en: .pitagorico)[2], #"294,13"#, doc, 4)
        comprobarIgual(Tradicion.india.afinacionSugerida, .justa, doc, 5)
        comprobarIgual(TipoDeEscala.dorico.afinacionSugerida, .mesotonico, doc, 6)
        comprobarIgual(TipoDeEscala.mayor.afinacionSugerida, .werckmeisterIII, doc, 7)
        comprobarIgual(TipoDeEscala.alterada.afinacionSugerida, .igual, doc, 8)
        comprobar(Escala(.la, .blues).afinacion()?.desviacion(de: "Sol4"), #"−31"#, doc, 9)
    }

    @Test func afinacionYRepresentaciones6() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 6)
        comprobar(Altura("Do4").numero(en: .base40), #"162"#, doc, 0)
        comprobar(Altura("Fa#4").numero(en: .base40), #"180"#, doc, 1)
        comprobar(Altura("Solb4").numero(en: .base40), #"184"#, doc, 2)
        comprobar(Altura(numero: 185, en: .base40), #"Sol4"#, doc, 3)
        comprobar(Intervalo.quintaJusta.numero(en: .base40), #"23"#, doc, 4)
        comprobar(Intervalo(numero: 12, en: .base40), #"3ª mayor"#, doc, 5)
        comprobar(Intervalo(numero: 20, en: .base40), #"nil"#, doc, 6)
        comprobar(Nota("Si#").numero(en: .base40), #"38"#, doc, 7)
        comprobar(Altura(Nota(.fa, 3), octava: 4).numero(en: .base40), #"nil"#, doc, 8)
        comprobar(Altura(Nota(.fa, 3), octava: 4).numero(en: .base54), #"245"#, doc, 9)
        comprobar(Altura("Do4").numero(en: .base600), #"2442"#, doc, 10)
        _ = BaseDeHewlett(base: 96)
    }

    @Test func afinacionYRepresentaciones7() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 7)
        comprobar(Nota.re.color(segun: .scriabin), #"#FFFF00"#, doc, 0)
        comprobar(CorrespondenciaDeColores.scriabin.nombreDelColor(de: .mi), #""azul cielo (luz de luna o escarcha)""#, doc, 1)
        comprobar(Altura("La4").color(segun: .newton).hexadecimal, ##""#4B0082""##, doc, 2)
        comprobar(Acorde("Do").colores(segun: .circuloDeQuintas), #"[#FF0000, #00FF00, #FF8000]"#, doc, 3)
        _ = Escala(.re, .dorico).colores(segun: .castel)
        _ = (ColorRGB(hexadecimal: "#FF8000"), ColorRGB(tono: 120, saturacion: 1, brillo: 1))
    }

    @Test func afinacionYRepresentaciones8() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 8)
        comprobar(PuntoDeLaRed(quintas: 0, terceras: 1).nota, #"Mi"#, doc, 0)
        comprobar(PuntoDeLaRed(quintas: 1, terceras: -1).nota, #"Mi♭"#, doc, 1)
        comprobar(PuntoDeLaRed(quintas: 4, terceras: -1).claseDeAltura, #"0"#, doc, 2)
        comprobar("\(Tonnetz(Acorde("Do")))", #""Do (0, 0) · Mi (0, 1) · Sol (1, 0)""#, doc, 3)
        comprobar(Tonnetz(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")], #"true"#, doc, 4)
        comprobar(Tonnetz(Escala(.do)).esConexo, #"true"#, doc, 5)
        comprobar(Tonnetz(Escala(.do, .tonosEnteros)).esConexo, #"false"#, doc, 6)
        comprobar("\(Tonnetz(ConjuntoDeClasesDeAltura([0, 4, 7])))", #""0 (0, 0) · 4 (0, 1) · 7 (1, 0)""#, doc, 7)
    }

    @Test func afinacionYRepresentaciones9() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 9)
        let dibujo = Tonnetz(Escala(.re, .dorico)).svg()
        let sinLeyenda = Tonnetz(Acorde("Do")).svg(opciones: .init(titulo: "Tónica"), leyenda: false)
        let ingles = Tonnetz(Acorde("Fa#m7")).svg(opciones: .init(notacion: .ascii(.ingles)), margen: 2)
        let toro = Tonnetz(ConjuntoDeClasesDeAltura([0, 4, 7, 11])).svg(margen: 3)
        comprobar(RelojDeClasesDeAltura(clases: [0, 4, 7]).svg(opciones: .init(notacion: .ascii(.ingles))).contains(">G</text>"), #"true"#, doc, 4)
        comprobar(TecladoDePiano(desde: 60, hasta: 72).svg(marcadas: [61], opciones: .init(ventana: .bemoles)).contains(">Re♭</text>"), #"true"#, doc, 5)
        comprobar(TecladoDePiano(desde: 60, hasta: 72).svg(marcadas: MarcasDeDiagrama(Escala("Fa mayor").alturas(octava: 4))).contains(">Si♭</text>"), #"true"#, doc, 6)
        comprobar(RelojDeClasesDeAltura(notas: Escala("Fa mayor").notas).svg().contains(">Si♭</text>"), #"true"#, doc, 7)
        _ = (dibujo, sinLeyenda, ingles, toro)
    }

    @Test func afinacionYRepresentaciones10() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 10)
        comprobar(Acorde("Do").transformar(.r) == Acorde("Lam"), #"true"#, doc, 0)
        comprobar(Acorde("Mib").transformar(.r) == Acorde("Dom"), #"true"#, doc, 1)
        comprobar(try Acorde("Do").transformar(leyendo: "PLR") == Acorde("Fam"), #"true"#, doc, 2)
        comprobar(Acorde("Do").transformar(TransformacionNeorriemanniana.s) == Acorde("Do#m"), #"true"#, doc, 3)
        comprobar(Acorde("Sol7").transformar(.p) == nil, #"true"#, doc, 4)
        comprobar(TransformacionNeorriemanniana.entre("Do", "Mim") == .l, #"true"#, doc, 5)
        comprobar(Acorde("Do").caminoNeorriemanniano(hasta: "Mibm") == [.p, .r, .p], #"true"#, doc, 6)
        comprobar(Acorde("Do").caminoNeorriemanniano(hasta: "Sol#", enarmonico: true) == [.p, .l], #"true"#, doc, 7)
    }

    @Test func afinacionYRepresentaciones11() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 11)
        let recorrido = Tonnetz(recorrido: ["Do", "Lam", "Fa", "Rem"])
        comprobar(recorrido?.recorrido.count == 4, #"true"#, doc, 1)
        let bomba = Tonnetz(recorrido: ["Do", "Lam", "Rem", "Sol", "Do"])!
        comprobar(bomba.recorrido.first == bomba.recorrido.last, #"false"#, doc, 3)
        let dibujo = Tonnetz(caminoDesde: "Do", hasta: "Fa#")?.svg()
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones12() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 12)
        comprobar(Acorde("Do").ciclo(.hexatonico)?.map(\.cifrado) == ["Do", "Dom", "La♭", "La♭m", "Mi", "Mim", "Do"], #"true"#, doc, 0)
        comprobar(Acorde("Do").ciclo(.octatonico)?.map(\.cifrado) == ["Do", "Dom", "Mi♭", "Mi♭m", "Sol♭", "Fa♯m", "La", "Lam", "Do"], #"true"#, doc, 1)
        comprobar(Acorde("Do").ciclo(.lr)?.count == 25, #"true"#, doc, 2)
        comprobar(Tonnetz(ciclo: .hexatonico, desde: "Do")?.recorrido.count == 7, #"true"#, doc, 3)
    }

    @Test func afinacionYRepresentaciones13() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 13
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 13)
        comprobar(TablaArmonica.midi(de: PuntoDeLaRed(quintas: 1, terceras: 0)) == 67, #"true"#, doc, 0)
        comprobar(TablaArmonica(Acorde("Domaj7")).triadas.map(\.acorde) == [Acorde("Do"), Acorde("Mim")], #"true"#, doc, 1)
        comprobar(TablaArmonica([Altura("Do4"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 1, #"true"#, doc, 2)
        comprobar(TablaArmonica([Altura("Do3"), Altura("Mi4"), Altura("Sol4")]).triadas.count == 0, #"true"#, doc, 3)
        comprobar("\(TablaArmonica([Altura("Do4"), Altura("Sol4")]))", #""Do4 (0, 0) · Sol4 (1, 0)""#, doc, 4)
        let dibujo = TablaArmonica(Escala(.re, .dorico)).svg()
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones14() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 14
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 14)
        comprobar(TablaArmonica(recorrido: ["Do", "Lam", "Fa"])?.recorrido.count == 3, #"true"#, doc, 0)
        comprobar(TablaArmonica(caminoDesde: "Do", hasta: "Sol7") == nil, #"true"#, doc, 1)
    }

    @Test func afinacionYRepresentaciones15() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 15
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 15)
        let mi = PuntoDeLaRed(quintas: 0, terceras: 1)
        comprobar(mi.coordenada == CoordenadaAxial(q: 0, r: 1), #"true"#, doc, 3)
        comprobar(PuntoDeLaRed(CoordenadaAxial(q: 1, r: 0)).nota == .sol, #"true"#, doc, 4)
        comprobar(Tonnetz.punto(en: Punto(x: 60, y: 3), paso: 64) == PuntoDeLaRed(quintas: 1, terceras: 0), #"true"#, doc, 5)
        comprobar(TablaArmonica.coordenada(de: mi) == CoordenadaAxial(q: 1, r: -1), #"true"#, doc, 6)
    }

    @Test func afinacionYRepresentaciones16() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 16
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 16)
        let teclado = TecladoIsomorfico.wickiHayden
        comprobar(teclado.midi(en: CoordenadaAxial(q: 1, r: -1)) == 67, #"true"#, doc, 3)
        comprobar(teclado.semitonos(hacia: DireccionHexagonal(.noreste, .puntiaguda)!) == 7, #"true"#, doc, 4)
        comprobar(TecladoIsomorfico.tablaArmonica.semitonos(hacia: .sMasRMenos) == 7, #"true"#, doc, 5)
        comprobar(TecladoIsomorfico.acordeonC.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 3, #"true"#, doc, 6)
        comprobar(TecladoIsomorfico.acordeonB.semitonos(hacia: DireccionHexagonal(.noreste, .plana)!) == 2, #"true"#, doc, 7)
        comprobar(TecladoIsomorfico.wickiHaydenPlano.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 7, #"true"#, doc, 8)
        comprobar(TecladoIsomorfico.gerhard.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 1, #"true"#, doc, 9)
        comprobar(TecladoIsomorfico.park.semitonos(hacia: DireccionHexagonal(.este, .puntiaguda)!) == 5, #"true"#, doc, 10)
        let mapa = FormasDeMapa.rectangulo(columnas: 12, filas: 4, .filasImpares)
        let dibujo = TecladoIsomorfico.janko.svg(mapa, marcadas: [60, 64, 67])
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones17() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 17
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 17)
        let formato = try FormatoUIL(leyendo: "2,7,5;R30M")
        comprobar(formato.esCompleto == true, #"true"#, doc, 1)
        comprobar(formato.orientacion == .puntiaguda, #"true"#, doc, 2)
        comprobar(try formato.teclado().semitonos(hacia: .qMasSMenos) == 2, #"true"#, doc, 3)
        comprobar(try FormatoUIL(leyendo: "M2,P5,P4;R30M").descripcion == "2,7,5;R30M", #"true"#, doc, 4)
        comprobar(try TecladoIsomorfico.conUIL("3,7,4;R0").semitonos(hacia: .sMasRMenos) == 7, #"true"#, doc, 5)
        comprobar(TecladoIsomorfico.wickiHayden.uil?.descripcion == "2,7,5;R30M", #"true"#, doc, 6)
        comprobar(try TecladoIsomorfico.wickiHayden.rotado(grados: -30).uil?.descripcion == "2,7,5;R0M", #"true"#, doc, 7)
        comprobar(TecladoIsomorfico.wickiHayden.reflejado.uil?.descripcion == "2,7,5;R330", #"true"#, doc, 8)
        comprobar(FormatoUIL.conocidos.count == 8, #"true"#, doc, 9)
    }

    @Test func afinacionYRepresentaciones18() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 18
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 18)
        let cuartas = TecladoCuadrado.cuartas
        comprobar(cuartas.midi(en: CasillaCuadrada(columna: 2, fila: 1)) == 67, #"true"#, doc, 1)
        comprobar(cuartas.semitonosEnDiagonal == 6, #"true"#, doc, 2)
        comprobar(TecladoCuadrado.wickiHaydenCuadrado.semitonosEnDiagonal == 7, #"true"#, doc, 3)
        comprobar(cuartas.rotado().semitonosEnH == 5, #"true"#, doc, 4)
        comprobar(cuartas.reflejado.semitonosEnH == -1, #"true"#, doc, 5)
        comprobar(TecladoCuadrado(nombre: "Tonos", semitonosEnH: 2, semitonosEnV: 4).esCompleto == false, #"true"#, doc, 6)
        let ventana = CasillaCuadrada.rectangulo(columnas: 0...11, filas: 0...3)
        let dibujo = cuartas.svg(ventana, marcadas: [60, 64, 67])
        _ = dibujo
    }

    @Test func afinacionYRepresentaciones19() throws {
        // Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md, bloque 19
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/AfinacionYRepresentaciones.md"#, 19)
        let enTono = TecladoCuadrado.cuartas.enTono(Escala(.re, .dorico))
        comprobar(enTono.semitonosEnV == 3, #"true"#, doc, 1)
        comprobar(enTono.midi(en: .origen) == 62, #"true"#, doc, 2)
        comprobar(TecladoCuadrado.conEjes("2,7")?.semitonosEnV == 7, #"true"#, doc, 3)
        comprobar(TecladoCuadrado.secuencial.conOrigen(36).midi(en: CasillaCuadrada(columna: 0, fila: 1)) == 44, #"true"#, doc, 4)
        comprobar(RejillaDeControlador.launchpad.casillas.count == 64, #"true"#, doc, 5)
        let pads = enTono.conOrigen(36).svg(RejillaDeControlador.launchpad.casillas, marcadas: [62], primeras: [62], contorno: true)
        _ = pads
    }

    @Test func armonia1() throws {
        // Sources/Armonia/Armonia.docc/Armonia.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Armonia.md"#, 1)
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, doc, 2)
        _ = Escala("La menor armónica").cifradosRomanos(cuatriadas: true)
        comprobar(Tonalidad.identificar(midi: [69, 71, 72, 74, 76, 77, 80, 81]).first, #"La menor"#, doc, 4)
    }

    @Test func convenciones1() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Convenciones.md"#, 1)
        func subirQuinta<T: Transponible>(_ x: T) -> T { x + .quintaJusta }
        comprobar(subirQuinta(Acorde("Do7")), #"Sol7"#, doc, 1)
        comprobar(subirQuinta(Escala(.do)), #"Sol mayor"#, doc, 2)
        comprobar(Nota.do.secuencia(.quintaJusta, veces: 3), #"Do, Sol, Re, La"#, doc, 3)
        comprobar(Acorde("Do").esDeLaMismaClase(que: Acorde("Lam")), #"true"#, doc, 4)
        comprobar(Acorde("Sib7(b9)/Re").texto(en: .ascii(.ingles)), #""Bb7(b9)/D""#, doc, 5)
        comprobar(Escala("Re dórico").nombre(en: .ascii(.ingles)), #""D dorian""#, doc, 6)
    }

    @Test func convenciones2() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Convenciones.md"#, 2)
        let n: Nota = "Fa#";  let i: Intervalo = "3M";  let a: Acorde = "Sol7/Si"
        let e: Escala = "Re dórico";  let t: TipoDeAcorde = "m7(b5)"
        comprobar(Nota.re + "3M", #"Fa♯"#, doc, 2)
        comprobar(String(decoding: try JSONEncoder().encode([a]), as: UTF8.self), #"["Sol7\/Si"]"#, doc, 3)
        comprobar([Intervalo.quintaJusta, .terceraMayor].sorted(), #"[3ª mayor, 5ª justa]"#, doc, 4)
        _ = Escala("La menor melódica").alturas(octava: 4, sentido: .descendente)
        comprobar(Escala(.la, .menorArmonica).cifradosRomanos(referencia: .menorNatural), #"["i", "ii°", "III+", "iv", "V", "VI", "♯vii°"]"#, doc, 6)
        _ = (n, e, i, t)
    }

    @Test func convenciones3() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, bloque 3
        let entrada = "Sol7"
        let a = Acorde("Sol7")
        let b = try? Acorde(leyendo: entrada)
        let c = try Acorde(leyendo: entrada)
        _ = (a, b, c)
    }

    @Test func convenciones4() throws {
        // Sources/Armonia/Armonia.docc/Convenciones.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Convenciones.md"#, 4)
        comprobarIgual(try NombreDeGrado(leyendo: "submediante"), .superdominante, doc, 0)
        _ = (try NombreDeGrado(leyendo: "Tónica"), try NombreDeGrado(leyendo: "leading tone"))
        comprobar(try PapelEnAcorde(leyendo: "oncena") == PapelEnAcorde(leyendo: "undécima"), #"true"#, doc, 2)
        comprobar(try PapelEnAcorde(leyendo: "trecena") == PapelEnAcorde(leyendo: "decimotercera"), #"true"#, doc, 3)
        comprobar(PapelEnAcorde.tension(11).nombre, #""undécima""#, doc, 4)
    }

    @Test func elModelo1() throws {
        // Sources/Armonia/Armonia.docc/ElModelo.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/ElModelo.md"#, 1)
        let i = Altura("Re5") - Altura("Do4")
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, doc, 3)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, doc, 4)
        comprobar(Altura("La4").frecuencia(), #"440.0"#, doc, 5)
        comprobar(Altura(midi: 63, ventana: .bemoles), #"Mi♭4"#, doc, 6)
        comprobar(VentanaDeQuintas(conteniendo: ["Do", "Mi", "Sol", "Si♭"]), #"Re♭–Fa♯"#, doc, 7)
        comprobar(VentanaDeQuintas.sostenidos.reescrita(Altura("Si♭4")), #"La♯4"#, doc, 8)
        comprobar(Acorde("Do7").ortografiar(midi: [61]), #"[Re♭4]"#, doc, 9)
        comprobar(Acorde("Sol7/Si").posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, doc, 11)
        comprobar(Acorde.identificar(notas: [.mi, .sol, .do]).first, #"Do/Mi"#, doc, 12)
        let menor = Escala("La menor armónica")
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, doc, 15)
        comprobar(Escala("Mib mayor").armadura, #"-3"#, doc, 17)
        comprobar(Escala(.do).modo(grado: 2), #"Re dórico"#, doc, 18)
        _ = i
    }

    @Test func escalas1() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 1)
        comprobar(Escala(.do, .dobleArmonica).notas, #"Do Re♭ Mi Fa Sol La♭ Si"#, doc, 0)
        comprobar(Escala("Do enigmática").notas, #"Do Re♭ Mi Fa♯ Sol♯ La♯ Si"#, doc, 1)
        comprobar(Escala("La menor húngara").nombre(en: .ascii(.ingles)), #""A hungarian minor""#, doc, 2)
        comprobar(TipoDeEscala.mayorArmonica.modo(grado: 4).nombre, #""lidio ♭3""#, doc, 3)
        comprobar(TipoDeEscala.dobleArmonica == .hitzazkiar, #"true"#, doc, 4)
        comprobar(Escala("Mi flamenca").notas, #"Mi Fa Sol Sol♯ La Si Do Re"#, doc, 5)
        comprobar(Escala("Do modo 3 de Messiaen").notas, #"Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si"#, doc, 6)
        comprobar(Escala("Re menor rumana").tipo.nombre, #""dórico ♯4""#, doc, 7)
        comprobar(TipoDeEscala.dobleArmonica.modo(grado: 5).nombre, #""oriental""#, doc, 8)
        comprobar(Escala.hexacordoBlando.notas, #"Fa Sol La Si♭ Do Re"#, doc, 9)
        comprobar(TipoDeEscala.mayorHungara.modo(grado: 4).nombre, #""superlocrio ♮6""#, doc, 10)
        comprobar(Escala("Do pentatónica escocesa").notas, #"Do Re Fa Sol La"#, doc, 11)
        comprobar(Escala("La de Liszt").tipo.nombre, #""menor húngara""#, doc, 12)
        comprobar(Escala("Do menor bachiana").notas, #"Do Re Mi♭ Fa Sol La Si"#, doc, 13)
    }

    @Test func escalas2() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 2)
        comprobar(TipoDeEscala.cromaticasPorQuintas.count, #"6"#, doc, 0)
        comprobar(TipoDeEscala.cromatica(ventana: .masSimple) == TipoDeEscala.cromatica, #"true"#, doc, 1)
        comprobar(Escala(.re, .cromaticaConCincoSostenidos).notas, #"Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯"#, doc, 2)
        comprobar(Escala("Do cromática con dos bemoles").notas, #"Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si"#, doc, 3)
        comprobar(Escala("Do cromatica -6..5").tipo.nombre, #""cromática con cinco bemoles""#, doc, 4)
        comprobar(Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10), #"La♯"#, doc, 5)
    }

    @Test func escalas3() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 3)
        comprobar(TipoDeEscala.dorico.estilos == [.clasica, .jazz], #"true"#, doc, 0)
        comprobar(Estilo.blues.tipos.count, #"6"#, doc, 1)
        comprobar(Estilo.sigloXX.nombre, #""siglo XX""#, doc, 2)
        comprobar(TipoDeEscala.kafi.estilos == [.indostanica], #"true"#, doc, 3)
        comprobarIgual(TipoDeEscala.dorico.tradicion, .occidental, doc, 4)
    }

    @Test func escalas4() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 4)
        comprobar(TipoDeEscala.dorico.alias, #"["menor dórica"]"#, doc, 0)
        comprobar(TipoDeEscala.dorico.variantes, #"["dórica"]"#, doc, 1)
        comprobar(try TipoDeEscala(leyendo: "dórica") == .dorico, #"true"#, doc, 2)
    }

    @Test func escalas5() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 5)
        comprobar(try TipoDeEscala(leyendo: "dorico b2") == TipoDeEscala(leyendo: "dórico ♭2"), #"true"#, doc, 0)
        comprobar(TipoDeEscala.dobleArmonica.aliasNormalizados.contains("doble armonica"), #"true"#, doc, 1)
        comprobar(try TipoDeEscala(leyendo: "jonico sin 4") == TipoDeEscala.jonicoSinCuarta, #"true"#, doc, 2)
    }

    @Test func escalas6() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 6)
        comprobar(TipoDeEscala.menorMelodica.esDireccional, #"true"#, doc, 0)
        comprobarIgual(TipoDeEscala.menorMelodica.formaDescendente, .menorNatural, doc, 1)
        comprobar(Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente), #"La5 Sol5 Fa5 … La4"#, doc, 2)
        comprobar(TipoDeEscala.rast.formaAscendente == .mayor, #"true"#, doc, 3)
        comprobarIgual(TipoDeEscala.kiourdi.formaDescendente, .menorNatural, doc, 4)
        _ = TipoDeEscala.bilahari.intervalosEnAmbasDirecciones
    }

    @Test func escalas7() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 7)
        comprobar(TipoDeEscala.kafi.esIdentico(a: .dorico), #"false"#, doc, 0)
        comprobar(TipoDeEscala.kafi.equivalentes.contains(.dorico), #"true"#, doc, 1)
        comprobar(TipoDeEscala.rast == .mayor, #"false"#, doc, 2)
    }

    @Test func escalas8() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 8)
        comprobar(TipoDeEscala.propio(TipoDeEscala.kafi.intervalos).nombre, #""dórico""#, doc, 0)
        comprobar(TipoDeEscala.kafi.equivalentes.first?.nombre, #""dórico""#, doc, 1)
        comprobar(try TipoDeEscala(leyendo: "Hijaz").nombre, #""Ḥijāz""#, doc, 2)
    }

    @Test func escalas9() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 9)
        comprobar(Arpegio(Acorde("Do7")).alturas(octava: 4).map(\.midi) == [60, 64, 67, 70, 72], #"true"#, doc, 0)
        comprobar(Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3).map(\.midi) == [48, 55, 52, 55], #"true"#, doc, 1)
        comprobar(Escala("Do mayor").arpegio(grado: 5, cuatriada: true)?.acorde == Acorde("Sol7"), #"true"#, doc, 2)
        comprobar(Escala("Do mayor").arpegios().count == 7, #"true"#, doc, 3)
        comprobar(try Arpegio(leyendo: "arpegio Dom7").acorde == Acorde("Dom7"), #"true"#, doc, 4)
        comprobar(Acorde("Do7").escalasCompatibles().contains(Escala(.do, .mixolidio)), #"true"#, doc, 5)
        let dibujo = Arpegio(Acorde("Do7")).svgPentagrama()
        _ = dibujo
    }

    @Test func escalas10() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 10)
        comprobar(Escala(.do, .mayor).notasAEvitar(sobre: Acorde("Do7M")) == [.fa], #"true"#, doc, 0)
        comprobar(Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).map(\.cifra) == ["1", "9", "♭3", "11", "5", "13", "♭7"], #"true"#, doc, 1)
        comprobar(Escala(.sol, .frigioDominante).tensiones(sobre: Acorde("Sol7")) == [Nota(.la, .bemol), Nota(.mi, .bemol)], #"true"#, doc, 2)
        comprobar(Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Sol7"]).escalas[1] == Escala(.la, .frigioDominante), #"true"#, doc, 3)
        comprobar(Tonalidad(.do).escalaDelAcorde(Acorde("Sib7")) == Escala(Nota(.si, .bemol), .lidioDominante), #"true"#, doc, 4)
        comprobar(Escala(.do, .alterada).escalaMadre?.madre == Escala(Nota(.re, .bemol), .menorMelodicaJazz), #"true"#, doc, 5)
        comprobar(Escala(.re, .dorico).escalaMadre?.nombre(en: .compacta(.espanol)) == "modo 2 de Do mayor", #"true"#, doc, 6)
        comprobar(Acorde("Do7(#11)").escalasCompatibles().first == Escala(.do, .lidioDominante), #"true"#, doc, 7)
    }

    @Test func escalas11() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 11)
        comprobar(Escala(.do, .mayor).acordesQueCaben(grado: 1).contains(Acorde(.do, .mayorSexta)), #"true"#, doc, 0)
        comprobar(Escala(.do, .lidio).estructurasSuperiores(sobre: Acorde("Do7M")).first == Acorde(.re, .mayor), #"true"#, doc, 1)
    }

    @Test func escalas12() throws {
        // Sources/Armonia/Armonia.docc/Escalas.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Escalas.md"#, 12)
        comprobar(Escala(.re, .dorico).notaCaracteristica == .si, #"true"#, doc, 0)
        comprobar(Escala(.re, .dorico).acordesCaracteristicos == [Acorde("Mim"), Acorde("Sol")], #"true"#, doc, 1)
        comprobar(Escala(.sol, .mixolidio).cadenciaModal == [Acorde("Fa"), Acorde("Sol")], #"true"#, doc, 2)
        comprobar(Escala(.mi, .frigio).cadenciaModal == [Acorde("Fa"), Acorde("Mim")], #"true"#, doc, 3)
    }

    @Test func escalasDelMundo1() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 1)
        comprobar(TipoDeEscala.melakarta(15), #"Māyāmālavagauḷa"#, doc, 0)
        comprobar(TipoDeEscala.mayor.numeroDeMelakarta, #"29"#, doc, 1)
        comprobar(TipoDeEscala.mayor.cakra?.nombre, #""Bāṇa""#, doc, 2)
        comprobar(Escala(.re, .hitzaz).notas, #"Re Mi♭ Fa♯ Sol La Si♭ Do"#, doc, 3)
        _ = (Escala("Do Kāfī"), Escala("Do kafi"), Escala("Re hijaz"), Escala("Do melakarta 22"))
        comprobar(Escala(.do, .todi).notas, #"Do Re♭ Mi♭ Fa♯ Sol La♭ Si"#, doc, 5)
        comprobar(TipoDeEscala.melakarta(15) == .bhairav, #"true"#, doc, 6)
        comprobar(Escala(.re, .zhi).notas, #"Re Mi Sol La Si"#, doc, 7)
        comprobar(Escala("Do hirajoshi").notas, #"Do Re Mi♭ Sol La♭"#, doc, 8)
        comprobar(Escala("Do 平調子").tipo.nombre, #""Hirajōshi""#, doc, 9)
        comprobar(Escala("Re Χιτζάζ").tipo.nombre, #""Hitzáz""#, doc, 10)
        comprobar(Escala("Do भैरवी").tipo.nombre, #""Bhairavī""#, doc, 11)
        comprobar(TipoDeEscala.gong == .pentatonicaMayor, #"true"#, doc, 12)
        comprobar(Escala("Do Rast muğamı").notas, #"Do Re Mi Fa Sol La Si♭ Si"#, doc, 13)
        comprobar(Escala("La hicaz makami").notas, #"La Si♭ Do♯ Re Mi Fa♯ Sol"#, doc, 14)
        comprobar(Escala("Do podhalańska").notas, #"Do Re Mi Fa♯ Sol La Si♭"#, doc, 15)
    }

    @Test func escalasDelMundo2() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 2)
        comprobarIgual(TipoDeEscala.kafi.categoria, .thaat, doc, 0)
        comprobarIgual(TipoDeEscala.melakarta(15)?.categoria, .melakarta, doc, 1)
        comprobarIgual(TipoDeEscala.hitzaz.tradicion, .grecia, doc, 2)
        comprobarIgual(TipoDeEscala.rastMakami.categoria, .makam, doc, 3)
        comprobar(TipoDeEscala.mohanam.esRaga, #"true"#, doc, 4)
        comprobar(TipoDeEscala.kafi.esRaga, #"false"#, doc, 5)
        comprobar(TipoDeEscala.mohanam.padre?.numeroDeMelakarta, #"28"#, doc, 6)
        comprobar(TipoDeEscala.yaman.padre == .kalyan, #"true"#, doc, 7)
        comprobar(TipoDeEscala.sadjaGrama.derivadas.count, #"7"#, doc, 8)
        comprobar(TipoDeEscala.menorNatural.categoria, #"nil"#, doc, 9)
        comprobar(TipoDeEscala.tradicionales(categoria: .melakarta).count, #"72"#, doc, 10)
        comprobar(CategoriaTradicional.escala.nombre(en: Notacion.compacta(.espanol).conTextos(en: .frances)), #""gamme""#, doc, 11)
    }

    @Test func escalasDelMundo3() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 3)
        comprobar(TipoDeEscala.mohanam.estilos == [.carnatica], #"true"#, doc, 0)
        comprobar(TipoDeEscala.pelogTembung.regiones == [.bali], #"true"#, doc, 1)
        comprobar(TipoDeEscala.slendro.regiones == [.java, .bali], #"true"#, doc, 2)
        comprobarIgual(RegionDeEscala.bali.tradicion, .indonesia, doc, 3)
        comprobar(RegionDeEscala.java.tipos.count, #"7"#, doc, 4)
        comprobar(Estilo.carnatica.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)), #""Carnatic""#, doc, 5)
    }

    @Test func escalasDelMundo4() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 4)
        comprobarIgual(TipoDeEscala.tetracordoDiatonicoTenso.fuente, .ptolomeo, doc, 0)
        comprobarIgual(TipoDeEscala.ionicus.fuente, .glareano, doc, 1)
        comprobarIgual(FuenteTeorica.ptolomeo.tradicion, .greciaAntigua, doc, 2)
        comprobar(TipoDeEscala.tradicionales(fuente: .ptolomeo).count, #"7"#, doc, 3)
        comprobar(FuenteTeorica.ptolomeo.nombre(en: Notacion.compacta(.espanol).conTextos(en: .ingles)), #""Ptolemy""#, doc, 4)
    }

    @Test func escalasDelMundo5() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 5)
        comprobar(TipoDeEscala.kafi.nombreCompleto, #""thāṭ Kāfī""#, doc, 0)
        comprobar(TipoDeEscala.mohanam.nombreCompleto, #""rāga Mohanam""#, doc, 1)
        comprobar(TipoDeEscala.bayati.nombreCompleto, #""maqām Bayātī""#, doc, 2)
        comprobar(TipoDeEscala.rastMakami.nombreCompleto, #""Rast makamı""#, doc, 3)
        comprobar(TipoDeEscala.mayor.nombreCompleto, #""mayor""#, doc, 4)
    }

    @Test func escalasDelMundo6() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 6)
        comprobarIgual(TipoDeEscala.mohanam.clase, .modo, doc, 0)
        comprobarIgual(TipoDeEscala.kafi.clase, .escalaMadre, doc, 1)
        comprobarIgual(TipoDeEscala.melakarta(15)?.clase, .escalaMadre, doc, 2)
        comprobarIgual(TipoDeEscala.tetracordoDiatonico.clase, .fragmento, doc, 3)
        comprobarIgual(TipoDeEscala.jinsHijaz.categoria, .jins, doc, 4)
        comprobar(TipoDeEscala.menorNatural.clase, #"nil"#, doc, 5)
        comprobar(TipoDeEscala.tradicionales(clase: .fragmento).count, #"48"#, doc, 6)
        comprobar(TipoDeEscala.tradicionales(clase: .afinacion).count, #"18"#, doc, 7)
    }

    @Test func escalasDelMundo7() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 7)
        comprobar(TipoDeEscala.bayati.referencias.map(\.cita), #"["Maqam World", "Touma 1996", "Farraj & Abu Shumays 2019", "Rechberger 2008"]"#, doc, 0)
        comprobar(TipoDeEscala.tetracordoDiatonicoTenso.referencias.first == .barker1989, #"true"#, doc, 1)
        comprobar(Referencia.west1992.paginas("160–172").cita, #""West 1992: 160–172""#, doc, 2)
        comprobar(Referencia.west1992.descripcion, #""West, M. L. (1992). Ancient Greek Music. Oxford: Clarendon Press.""#, doc, 3)
        comprobar(FuenteTeorica.zarlino.referencia == .zarlino1558, #"true"#, doc, 4)
        comprobar(TipoDeEscala.flamenca.referencias.map(\.cita), #"["Manuel 1989"]"#, doc, 5)
    }

    @Test func escalasDelMundo8() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 8)
        comprobar(Escala(.re, .bayati).notas, #"Re Mi♭ Fa Sol La Si♭ Do"#, doc, 0)
        comprobar(Escala(.re, .bayati).notasMicrotonales(), #"Re Mi𝄳 Fa Sol La Si♭ Do"#, doc, 1)
        comprobar(Escala(.do, .maqamRast).notasMicrotonales(sentido: .descendente), #"Do Re Mi𝄳 Fa Sol La Si♭"#, doc, 2)
        comprobar(Escala(.sol, .rastMakami).notasMicrotonales(), #"Sol La Si⁻¹ Do Re Mi Fa♯⁻¹"#, doc, 3)
        comprobarIgual(TipoDeEscala.rastMakami.microtonal?.sistema, .comas53, doc, 4)
        comprobar(Escala(.re, .echosProtos).notasMicrotonales(), #"Re Mi⁻² Fa Sol La Si⁻² Do"#, doc, 5)
        comprobar(Escala(.do, .bilaval).notasMicrotonales(), #"Do Re↓ Mi↓ Fa Sol La↓ Si↓"#, doc, 6)
        comprobar(TipoDeEscala.frigio.microtonal, #"nil"#, doc, 7)
        comprobar(TipoDeEscala.echosProtos.afinaciones.count, #"2"#, doc, 8)
    }

    @Test func escalasDelMundo9() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 9)
        let voz = Escala(.re, .bayati).voz()
        comprobar(voz.eventos[1], #"Mi♭4(50¢,cuartosDeTono,1):4"#, doc, 1)
        comprobar(Escala(.re, .sur).voz().eventos[1], #"Mi♭4(50¢,persa,1):4"#, doc, 2)
        comprobar(voz.partitura().musicXML().contains("<alter>-0.5</alter>"), #"true"#, doc, 3)
        comprobar(Evento("Si4(-15.09¢):4").notas, #"[Si4(-15.09¢)]"#, doc, 4)
        comprobar(Escala(.re, .bayati).svgPentagrama(secuencia: .terceras).contains("<title>Mi𝄳</title>"), #"true"#, doc, 5)
        let bayati = try Voz(leyendo: "Mi♭4(50¢):4 Re4:2.")
        comprobar(Partitura(.init(bayati), encabezado: Encabezado(titulo: "Bayātī")).svg().contains("(+50¢)</title>"), #"true"#, doc, 7)
    }

    @Test func escalasDelMundo10() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 10)
        comprobar(ModoGregoriano(2)!.description, #""modo 2 (protus plagal, hipodórico): final Re, tenor Fa, ámbito La3–La4""#, doc, 0)
        comprobar(try ModoGregoriano(leyendo: "hipofrigio").tenor, #"La"#, doc, 2)
        comprobar(ModoGregoriano(3)!.escala, #"Mi frigio"#, doc, 3)
        comprobar(ModoGregoriano(6)!.ambito.first, #"Do4"#, doc, 4)
    }

    @Test func escalasDelMundo11() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 11)
        comprobar(ModoGregoriano(2)!.tipoDeEscala.nombre, #""protus plagalis""#, doc, 0)
        comprobar(try TipoDeEscala(leyendo: "hipodórico").nombre, #""protus plagalis""#, doc, 1)
    }

    @Test func escalasDelMundo12() throws {
        // Sources/Armonia/Armonia.docc/EscalasDelMundo.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/EscalasDelMundo.md"#, 12)
        comprobar(ManoGuidoniana.gamut.count, #"20"#, doc, 0)
        comprobar(ManoGuidoniana.nombre(de: Altura(.do, octava: 3)), #""C fa ut""#, doc, 1)
        comprobar(ManoGuidoniana.silabas(de: Altura(.sol, octava: 3)), #"["sol", "re", "ut"]"#, doc, 2)
        comprobar(ManoGuidoniana.nombre(de: Altura(Nota(.si, .bemol), octava: 3)), #""b fa ♮ mi""#, doc, 3)
    }

    @Test func melodiaYRitmo1() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 1)
        let tema: Melodia = ["Do4", "Mi4", "Sol4"]
        comprobar(tema.transponer(.segundaMayor), #"Re4 Fa♯4 La4"#, doc, 1)
        comprobar(tema.transponer(grados: 1, en: Escala(.do)), #"Re4 Fa4 La4"#, doc, 2)
        comprobar(tema.invertir(), #"Do4 La♭3 Fa3"#, doc, 3)
        comprobar(tema.retrogradar(), #"Sol4 Mi4 Do4"#, doc, 4)
        _ = (tema.intervalos, tema.contorno, tema.ambito)
        comprobar(Melodia(midi: [69, 71, 72, 74, 76, 77, 80, 81]), #"La4 … Sol♯5 La5"#, doc, 6)
    }

    @Test func melodiaYRitmo2() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 2)
        comprobar(Duracion(.negra, puntillos: 1), #"negra con puntillo"#, doc, 0)
        comprobar(Duracion(.negra, puntillos: 1).texto, #""4.""#, doc, 1)
        comprobar(Duracion.corchea.grupoIrregular(3, en: 2), #"1/12 de redonda"#, doc, 2)
        comprobar(Duracion("8."), #"corchea con puntillo"#, doc, 3)
        comprobar((Duracion.blanca + .corchea).descomposicion, #"[blanca, corchea]"#, doc, 4)
        comprobar(Duracion.corchea.ticks(porNegra: 480), #"240"#, doc, 5)
        let c: Compas = "6/8"
        _ = (c.tipo, c.pulsos, c.pulso)
        comprobar(Tempo(100).indicacion, #""Andante""#, doc, 9)
        comprobar(Tempo(120).segundos(de: .blanca), #"1"#, doc, 10)
    }

    @Test func melodiaYRitmo3() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 3)
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4", compas: "3/4")
        comprobar(voz.duracion, #"redonda con puntillo"#, doc, 1)
        comprobar(voz.compases, #"[[Do4:4, Re4:8, Mi4:8, Fa4:4~], [Fa4:2, Sol4:4]]"#, doc, 2)
        comprobar(voz.segundos(tempo: Tempo(90)), #"4"#, doc, 3)
        _ = (voz.melodia, voz.ritmo)
        _ = (voz.aumentar(2), voz.disminuir(2), voz.retrogradar(), voz + .quintaJusta)
        _ = Voz(melodia: ["Do4", "Mi4", "Sol4"], ritmo: [.negra, .negra, .blanca], compas: "3/4")
    }

    @Test func melodiaYRitmo4() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 4)
        let frase = try Voz(leyendo: "Do4:4{p} Re4:4{staccato} Mi4:2{f,acento}")
        comprobarIgual(frase.eventos[0].dinamica, .p, doc, 1)
        comprobar(frase.eventos[2].articulaciones == [.acento], #"true"#, doc, 2)
        comprobar(frase.eventos[2].description, #""Mi4:2{f,acento}""#, doc, 3)
        comprobar(Dinamica.f.velocidadMIDI, #"96"#, doc, 4)
        comprobar(try Evento(leyendo: "Sol4:2{trino}").articulaciones == [.trino], #"true"#, doc, 5)
    }

    @Test func melodiaYRitmo5() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 5)
        let tema = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Do4:4 Re4:4 Mi4:2 Sol4:4 Fa4:4 Mi4:2 Do4:4 Re4:4 Do4:2")
        comprobar(tema.frases().count, #"4"#, doc, 1)
        comprobar(tema.frases()[2].eventos == 6..<9, #"true"#, doc, 2)
        comprobar(tema.forma() == ["A", "A", "B", "A′"], #"true"#, doc, 3)
        let progresion = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4 Re4:8 Mi4:8 Fa#4:4 Mi4:8 Fa#4:8 Sol#4:2")
        let motivo = progresion.motivos(minimo: 3)[0]
        comprobar(motivo.intervalos == [2, 2], #"true"#, doc, 7)
        comprobar(motivo.apariciones == [0, 3, 6], #"true"#, doc, 8)
        comprobar(motivo.transposiciones == [0, 2, 4], #"true"#, doc, 9)
        comprobar(motivo.esSecuencia, #"true"#, doc, 10)
    }

    @Test func melodiaYRitmo6() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 6)
        let corcheas = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:2")
        comprobar(corcheas.conSwing().ritmo == [Duracion(1, 6), Duracion(1, 12), Duracion(1, 6), Duracion(1, 12), .blanca], #"true"#, doc, 1)
        let tresContraDos = Polirritmia(3, contra: 2)
        comprobar(tresContraDos.resultante() == [Duracion(1, 3), Duracion(1, 6), Duracion(1, 6), Duracion(1, 3)], #"true"#, doc, 4)
        comprobar(tresContraDos.voces(compases: 2)[0].eventos.count, #"6"#, doc, 5)
    }

    @Test func melodiaYRitmo7() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 7)
        comprobar(Compas("7/8").agrupacion, #"[2, 2, 3]"#, doc, 0)
        comprobar(Compas("7/8").pulsos, #"3"#, doc, 1)
        comprobar(Compas("6/8").iniciosDePulso, #"[cero, negra con puntillo]"#, doc, 2)
        comprobarIgual(Compas.compasillo.acento(pulso: 2), .semifuerte, doc, 3)
        comprobar(Compas.compasillo.acento(en: .corchea), #"nil"#, doc, 4)
    }

    @Test func melodiaYRitmo8() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 8)
        comprobar(try Voz(leyendo: "Do4:4 Re4:2 Mi4:4").grafia, #"[[Do4:4, Re4:4~, Re4:4, Mi4:4]]"#, doc, 0)
        comprobar(try Voz(leyendo: "Do4:8 Re4:4 Mi4:8 Fa4:2").grafia, #"[[Do4:8, Re4:8~, Re4:8, Mi4:8, Fa4:2]]"#, doc, 1)
        comprobar(try Voz(leyendo: "Do4:4. Re4:8 Mi4:2").grafia, #"[[Do4:4., Re4:8, Mi4:2]]"#, doc, 2)
        comprobar(try Voz(leyendo: "Do4:4 Re4:4. Mi4:8 Fa4:4").grafia, #"[[Do4:4, Re4:4~, Re4:8, Mi4:8, Fa4:4]]"#, doc, 3)
        comprobar(try Voz(leyendo: "Do4:4 Re4:4 Mi4:4", compas: "6/8").grafia, #"[[Do4:4, Re4:8~, Re4:8, Mi4:4]]"#, doc, 4)
        comprobar(try Voz(leyendo: "Do4:2..", compas: "7/8").grafia, #"[[Do4:2~, Do4:4.]]"#, doc, 5)
        comprobar(try Voz(leyendo: "Do4:2..", compas: "3+2+2/8").grafia, #"[[Do4:4.~, Do4:2]]"#, doc, 6)
    }

    @Test func melodiaYRitmo9() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 9)
        let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
        let partitura = escala.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90)))
        comprobar(partitura.musicXML().contains("<work-title>Escala</work-title>"), #"true"#, doc, 2)
        comprobar(partitura.pentagramas.count, #"1"#, doc, 3)
        let bajo = try Voz(leyendo: "Do3:2. Fa2:4", compas: "3/4")
        let manos: [Partitura.Pentagrama] = [.init(clave: .sol, voces: [.init(escala)]), .init(clave: .fa, voces: [.init(bajo)])]
        let dos = Partitura(pentagramas: manos, encabezado: Encabezado(titulo: "Dos manos"), llave: true)
        comprobar(dos.lilyPond().contains("PianoStaff"), #"true"#, doc, 7)
        comprobar(dos.svg().contains("<svg"), #"true"#, doc, 8)
    }

    @Test func melodiaYRitmo10() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 10)
        let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
        let xml = escala.partitura(encabezado: Encabezado(titulo: "Escala", tonalidad: Tonalidad(.do), tempo: Tempo(90))).musicXML()
        comprobar(xml.contains("<fifths>0</fifths>"), #"true"#, doc, 2)
        comprobar(xml.contains("<actual-notes>3</actual-notes>"), #"true"#, doc, 3)
    }

    @Test func melodiaYRitmo11() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 11)
        let escala = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2 Sol4:1/12 La4:1/12 Si4:1/12 Do5:2.", compas: "3/4")
        let mei = escala.partitura(encabezado: Encabezado(titulo: "Escala", tonalidad: Tonalidad(.do), tempo: Tempo(90))).mei()
        comprobar(mei.contains("keysig=\"0\""), #"true"#, doc, 2)
        comprobar(mei.contains("<tuplet num=\"3\" numbase=\"2\">"), #"true"#, doc, 3)
    }

    @Test func melodiaYRitmo12() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 12)
        let tema = try Voz(leyendo: "Sol4:4 Do5:2 Re5:8 Mi5:8 Fa#5:4 Sol5:2", compas: "3/4", anacrusa: .negra)
        let ly = tema.partitura(encabezado: Encabezado(titulo: "Tema", tonalidad: Tonalidad(.sol))).lilyPond()
        comprobar(ly.contains("\\key g \\major \\time 3/4 \\partial 4"), #"true"#, doc, 2)
        comprobar(ly.contains("fis''4 g''2"), #"true"#, doc, 3)
        let abc = tema.partitura(encabezado: Encabezado(titulo: "Tema", tonalidad: Tonalidad(.sol))).abc()
        comprobar(abc.contains("K:G"), #"true"#, doc, 5)
        comprobar(abc.contains("c2 d/2e/2 | f g2 |]"), #"true"#, doc, 6)
    }

    @Test func melodiaYRitmo13() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 13
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 13)
        let melodia = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8~ Mi4:4 Sol4+Si4:2", compas: "3/4")
        let datos = melodia.partitura(encabezado: Encabezado(titulo: "Escala", tempo: Tempo(90), instrumento: 40)).midi()
        comprobar(datos.prefix(4) == Data("MThd".utf8), #"true"#, doc, 2)
    }

    @Test func melodiaYRitmo14() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 14
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 14)
        let acorde = try Voz(leyendo: "Do4+Mi4+Sol4:1")
        let datos = acorde.partitura().midi(afinacion: TemperamentoRegular.mesotonicoCuartoDeComa)
        let pieza = try PiezaImportada(midi: datos)
        comprobar(pieza.notas.map(\.parte) == [0, 0, 0], #"true"#, doc, 3)
        comprobar(abs(400 + pieza.notas[1].desvio - pieza.notas[0].desvio - 386.31) < 0.05, #"true"#, doc, 4)
    }

    @Test func melodiaYRitmo15() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 15
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 15)
        let sur = try PiezaImportada(musicXML: Data(Escala(.re, .sur).partitura().musicXML().utf8))
        comprobar(sur.notas[1].sistema == .persa && sur.notas[1].ajuste == 1, #"true"#, doc, 1)
    }

    @Test func melodiaYRitmo16() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 16
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 16)
        let leida = try PiezaImportada(musicXML: Data(Voz(leyendo: "Do4:4 -:4 Mi4+Sol4:2").partitura().musicXML().utf8))
        comprobar(leida.partitura().pentagramas[0].voces[0].voz.eventos.count == 3, #"true"#, doc, 1)
        comprobar(leida.partitura().svg().hasPrefix("<svg"), #"true"#, doc, 2)
    }

    @Test func melodiaYRitmo17() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 17
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 17)
        let tema = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
        comprobar(FormatoDePartitura.allCases.map(\.extensionDeFichero) == ["musicxml", "mei", "ly", "gmn", "abc", "mid"], #"true"#, doc, 1)
        let delTema = tema.partitura(encabezado: Encabezado(titulo: "Tema"))
        comprobar(delTema.exportar(como: .lilyPond) == Data(delTema.lilyPond().utf8), #"true"#, doc, 3)
        comprobar(delTema.exportar(como: .midi) == delTema.midi(), #"true"#, doc, 4)
    }

    @Test func melodiaYRitmo18() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 18
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 18)
        let arpegio = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        comprobar(arpegio.eventos.count, #"9"#, doc, 1)
        let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Sol7")]
        let alberti = Voz(arpegiando: acordes, patron: .alberti, porAcorde: .blanca)
        comprobar(alberti.eventos.count, #"16"#, doc, 4)
        comprobar(alberti.eventos.prefix(4).flatMap(\.alturas).map(\.midi) == [48, 55, 52, 55], #"true"#, doc, 5)
        let datos = alberti.partitura(encabezado: Encabezado(titulo: "Bajo de Alberti")).midi()
        _ = datos
    }

    @Test func melodiaYRitmo19() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 19
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 19)
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let pieza = try PiezaImportada(leyendo: coral.partitura(duracion: .blanca, encabezado: Encabezado(tonalidad: Tonalidad(.do))).midi())
        comprobar(pieza.tonalidad, #"Do mayor"#, doc, 2)
        comprobar(pieza.notas.count, #"12"#, doc, 3)
        comprobar(pieza.acordes().map(\.cifrado), #"["Do", "Sol", "Do"]"#, doc, 4)
        comprobar(pieza.analisis()?.cifrados, #"["I", "V", "I"]"#, doc, 5)
        comprobar(pieza.ritmoArmonico().duraciones == [.blanca, .blanca, .redonda], #"true"#, doc, 6)
    }

    @Test func melodiaYRitmo20() throws {
        // Sources/Armonia/Armonia.docc/MelodiaYRitmo.md, bloque 20
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/MelodiaYRitmo.md"#, 20)
        let repetida = try PiezaImportada(abc: "X:1\nM:4/4\nL:1/4\nK:C\n|: {B}c4 |1 d4 :|2 e4 |]\n")
        comprobar(repetida.notas.map(\.inicio) == [.cero, Duracion(1), Duracion(2), Duracion(3)], #"true"#, doc, 1)
        comprobar(repetida.notas[3].altura, #"Mi5"#, doc, 2)
        comprobar(repetida.notasDeAdorno.count, #"2"#, doc, 3)
    }

    @Test func notacionYPartitura1() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 1)
        comprobar(Nota("Sib").nombre(en: .compacta(.aleman)), #""B""#, doc, 0)
        comprobar(Nota("Mibb").nombre(en: .compacta(.aleman)), #""Eses""#, doc, 1)
        comprobar(Nota("Fa#").nombre(en: .conPalabras(.aleman)), #""F Kreuz""#, doc, 2)
        comprobar(Altura("Fa#3").nombre(en: .compacta(.aleman)), #""Fis₃""#, doc, 3)
        comprobar(Altura("Fa#3").nombre(en: .conPalabras(.frances)), #""fa dièse 3""#, doc, 4)
        comprobar(Acorde("Sim7").cifrado(en: .conPalabras(.aleman)), #""Hm7""#, doc, 5)
        comprobar(Acorde("Rebmaj7").cifrado(en: .conPalabras(.frances)), #""Ré♭maj7""#, doc, 6)
        comprobar(try Nota(leyendo: "B", en: .compacta(.aleman)), #"Si♭"#, doc, 7)
        comprobar(try Nota(leyendo: "F Kreuz", en: .compacta(.aleman)), #"Fa♯"#, doc, 8)
        comprobar(try Altura(leyendo: "re diesis 5", en: .conPalabras(.italiano)), #"Re♯5"#, doc, 9)
        _ = (Tonalidad("Fis-Dur"), Tonalidad("ré bémol majeur"), Tonalidad("la minore"))
        comprobar(Alteracion(-2).nombre(en: .conPalabras(.frances)), #""double bémol""#, doc, 11)
        comprobar(Nota("Fa#").nombre(en: .conPalabras(.portugues)), #""fá sustenido""#, doc, 12)
        comprobar(Alteracion(2).nombre(en: .conPalabras(.portugues)), #""duplo sustenido""#, doc, 13)
        comprobar(Acorde("Rebmaj7").cifrado(en: .conPalabras(.portugues)), #""Ré♭maj7""#, doc, 14)
        comprobar(Altura("fá sustenido 3"), #"Fa♯3"#, doc, 15)
        comprobar(Tonalidad("si bemol maior"), #"Si♭ mayor"#, doc, 16)
        comprobar(Escala("ré dórico"), #"Re dórico"#, doc, 17)
        comprobar(Nota("Fa#").nombre(en: .conPalabras(.ruso)), #""фа-диез""#, doc, 18)
        comprobar(Tonalidad("Re mayor").nombre(en: .conPalabras(.griego)), #""ρε μείζονα""#, doc, 19)
        comprobar(Acorde("Sibm7").cifrado(en: .conPalabras(.griego)), #""Σι♭m7""#, doc, 20)
        comprobar(Tonalidad("ля минор"), #"La menor"#, doc, 21)
    }

    @Test func notacionYPartitura2() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 2)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.catalan)), #""3a major""#, doc, 0)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.gallego)), #""3ª maior""#, doc, 1)
        comprobar(Intervalo.sextaMenor.nombre(en: .conPalabras(.euskera)), #""6. txikia""#, doc, 2)
        comprobar(Cadencia.Tipo.rota.nombre(en: .conPalabras(.catalan)), #""cadència trencada""#, doc, 3)
        comprobar(Escala(.re, .dorico).nombre(en: .conPalabras(.euskera)), #""re doriarra""#, doc, 4)
        comprobar(Acorde("Sol7/Si").nombre(en: .conPalabras(.catalan)), #""sol setena de dominant, primera inversió""#, doc, 5)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.frances)), #""tierce majeure""#, doc, 6)
        comprobar(Cadencia.Tipo.rota.nombre(en: .conPalabras(.italiano)), #""cadenza d'inganno""#, doc, 7)
        comprobar(Escala(.re, .dorico).nombre(en: .conPalabras(.frances)), #""ré dorien""#, doc, 8)
        comprobar(Acorde("Sol7/Si").nombre(en: .conPalabras(.portugues)), #""sol sétima de dominante, primeira inversão""#, doc, 9)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.aleman)), #""große Terz""#, doc, 10)
        comprobar(Cadencia.Tipo.rota.nombre(en: .conPalabras(.aleman)), #""Trugschluss""#, doc, 11)
        comprobar(Acorde("Sol7/Si").nombre(en: .conPalabras(.aleman)), #""Dominantseptakkord auf G, erste Umkehrung""#, doc, 12)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.ruso)), #""большая терция""#, doc, 13)
        comprobar(Escala(.re, .dorico).nombre(en: .conPalabras(.ruso)), #""ре дорийский""#, doc, 14)
        comprobar(Intervalo.terceraMayor.nombre(en: .conPalabras(.griego)), #""μεγάλη τρίτη""#, doc, 15)
    }

    @Test func notacionYPartitura3() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 3)
        let notacion = Notacion.conPalabras(.ruso).conTextos(en: .espanol)
        comprobar(Acorde("Sol7/Si").nombre(en: notacion), #""соль séptima de dominante, primera inversión""#, doc, 1)
        comprobar(Escala(.re, .dorico).nombre(en: Notacion.ascii(.ingles).conTextos(en: .euskera)), #""D doriarra""#, doc, 2)
        comprobar(Notacion(escritura: .conPalabras(.ruso), textos: .espanol) == notacion, #"true"#, doc, 3)
    }

    @Test func notacionYPartitura4() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 4)
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: .compacta(.espanol)), #""Fa♯₃""#, doc, 0)
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: .ascii(.espanol)), #""Fa#3""#, doc, 1)
        let conCifras = Notacion.compacta(.espanol).conOctavas(.cifras)
        comprobar(Altura(Nota.fa.sostenido, octava: 3).nombre(en: conCifras), #""Fa♯3""#, doc, 3)
        comprobar(try Altura(leyendo: "Si♭₋₁") == Altura(Nota.si.bemol, octava: -1), #"true"#, doc, 4)
    }

    @Test func notacionYPartitura5() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 5)
        comprobar(Escala("fa dièse lydien"), #"Fa♯ lidio"#, doc, 0)
        comprobar(Escala("si bemolle minore melodica"), #"Si♭ menor melódica"#, doc, 1)
        comprobar(Escala("ре дорийский"), #"Re dórico"#, doc, 2)
        comprobar(Escala("λα αρμονική ελάσσονα"), #"La menor armónica"#, doc, 3)
    }

    @Test func notacionYPartitura6() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 6)
        comprobar(SistemaDeNombres.bizantino.nombre(de: Nota("Fa#")), #""Ga♯""#, doc, 0)
        comprobar(SistemaDeNombres.bizantino.nombre(de: Nota("Re"), grafia: .original), #""Πα""#, doc, 1)
        comprobar(SistemaDeNombres.sargam.nombre(de: Nota("Fa"), tonica: Nota("Re")), #""ga""#, doc, 2)
        comprobar(SistemaDeNombres.sargam.nombre(de: Nota("Fa#"), grafia: .original), #""म॑""#, doc, 3)
        comprobar(try SistemaDeNombres.sargam.leer("Ma"), #"Fa♯"#, doc, 4)
        comprobar(Escala(.re, .dorico).nombres(en: .sargam).joined(separator: " "), #""Sā Re ga ma Pa Dha ni""#, doc, 5)
        comprobar(SistemaDeNombres.japones.nombre(de: Nota("Fa#"), grafia: .original), #""嬰ヘ""#, doc, 6)
        comprobar(SistemaDeNombres.coreano.nombre(de: Nota("Sib"), grafia: .original), #""내림나""#, doc, 7)
        comprobar(SistemaDeNombres.luChinos.nombre(de: Nota("Reb")), #""dàlǚ""#, doc, 8)
        comprobar(SistemaDeNombres.luJaponeses.nombre(de: Nota("Re"), grafia: .original), #""壱越""#, doc, 9)
        comprobar(try SistemaDeNombres.luCoreanos.leer("黃"), #"Mi♭"#, doc, 10)
        comprobar(SistemaDeNombres.jianpu.nombre(de: Nota("Fa#")), #""♯4""#, doc, 11)
        comprobar(SistemaDeNombres.gongche.nombre(de: Nota("Re")), #""chě""#, doc, 12)
        comprobar(try SistemaDeNombres.wusheng.leer("變徵"), #"Fa♯"#, doc, 13)
        comprobar(try SistemaDeNombres.carnatico.leer("G2"), #"Mi♭"#, doc, 14)
        comprobar(SistemaDeNombres.tonicSolFa.nombre(de: Nota("Sib"), tonica: Nota("Fa")), #""f""#, doc, 15)
    }

    @Test func notacionYPartitura7() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 7)
        let bizantina = Notacion.sistema(.bizantino)!
        comprobar(Acorde("Sol7/Si").cifrado(en: bizantina), #""Di7/Zo""#, doc, 1)
        comprobar(try Nota(leyendo: "Γα♯", en: bizantina), #"Fa♯"#, doc, 2)
        comprobar(Notacion.sistema(.sargam), #"nil"#, doc, 3)
    }

    @Test func notacionYPartitura8() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 8)
        comprobar(NombresPorOctava.arabe.nombre(de: Altura(.mi, octava: 4), ajuste: -1), #""Sīkāh""#, doc, 0)
        comprobar(NombresPorOctava.turco.nombre(de: Altura(.si, octava: 4), ajuste: -1), #""Segâh""#, doc, 1)
        comprobar(NombresPorOctava.griegoAntiguo.nombre(de: Altura(.la, octava: 3)), #""mésē""#, doc, 2)
        comprobar(Escala(.do, .maqamRast).nombres(en: .arabe, octava: 4).compactMap { $0 }.joined(separator: " "), #""Rāst Dūkāh Sīkāh Jahārkāh Nawā Ḥusaynī Awj""#, doc, 3)
        comprobar(SistemaMicrotonal.nombresDeLosSruti().first, #""tīvrā""#, doc, 5)
        comprobar(Escala(.sol, .pelogNem).nombresDelGamelan()?.joined(separator: " "), #""lima nem bem gulu dhadha""#, doc, 6)
        comprobar(SistemaDeNombres.solfeoHebreo.nombre(de: Nota("Fa"), grafia: .original), #""פה""#, doc, 7)
    }

    @Test func notacionYPartitura9() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 9)
        _ = Nota("Sibb").alteracion
        comprobar(Alteracion(3).nombre, #""triple sostenido""#, doc, 1)
        comprobar(Alteracion(-1).nombre(en: .ascii(.ingles)), #""flat""#, doc, 2)
        comprobar(Alteracion(2).simbolo, #""♯♯""#, doc, 3)
        comprobar(Alteracion(3).simboloConDobles, #""𝄪♯""#, doc, 4)
        comprobar(Alteracion(-2).simboloASCII, #""bb""#, doc, 5)
        comprobar(Alteracion(-2).simbolo(en: .unicodeConDobles), #""𝄫""#, doc, 6)
        _ = (Alteracion("x"), Alteracion("doble bemol"), Alteracion("♮"))
        _ = Alteracion.sostenido + .sostenido
        comprobar(Alteracion.sostenido.pasosDeQuinta, #"7"#, doc, 9)
    }

    @Test func notacionYPartitura10() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 10)
        comprobar(Intervalo.sextaMenor.claseIntervalica, #"4"#, doc, 0)
        comprobarIgual(Intervalo.segundaAumentada.consonancia(), .disonancia, doc, 1)
        comprobar(Intervalo(numero: 1, calidad: .disminuida(1)), #"nil"#, doc, 2)
        comprobar(Clave.sol.posicion(de: "Do4").descripcion, #""1.ª línea adicional inferior""#, doc, 4)
        comprobar(Clave.doEnTercera.posicion(de: "Do4").lugar, #"4"#, doc, 5)
        comprobar(Clave.fa.altura(lugar: 8), #"La3"#, doc, 6)
        comprobarIgual(Clave.masAdecuada(para: ["Do2", "Mi2"]), .fa, doc, 7)
        comprobar(InstrumentoDePartitura.clarineteEnSib.sonido(de: Altura("Do5")), #"Si♭4"#, doc, 9)
        comprobar(InstrumentoDePartitura.saxofonAlto.escritura(de: Escala("Si mayor")), #"La♭ mayor"#, doc, 10)
        comprobar(InstrumentoDePartitura.saxofonAlto.escritura(de: Acorde("Do7")), #"La7"#, doc, 11)
    }

    @Test func notacionYPartitura11() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 11)
        comprobar(Escala("Re mayor").svgPentagrama().hasPrefix("<svg"), #"true"#, doc, 0)
        comprobar(Escala("Re mayor").svgPentagrama().contains("<title>Re₄</title>"), #"true"#, doc, 1)
        comprobar(Escala("La menor melódica").svgPentagrama().contains("<title>Sol₅</title>"), #"true"#, doc, 2)
        comprobar(Acorde("Sol7").svgPentagrama().contains(">Sol7</text>"), #"true"#, doc, 3)
        comprobar(Acorde("Sol7").svgPentagrama(cifrado: false).contains("<text"), #"false"#, doc, 4)
        comprobar(Escala("Do mayor").svgPentagrama(opciones: OpcionesDePentagrama(notacion: .ascii(.ingles))).contains("<title>C4</title>"), #"true"#, doc, 5)
    }

    @Test func notacionYPartitura12() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 12)
        comprobar(Escala("Re mayor").svgPentagrama() == Escala("Re mayor").partitura().svg(), #"true"#, doc, 0)
        comprobar(Acorde("Sol7").partitura().pentagramas[0].voces[0].cifrados == [.cero: Acorde("Sol7")], #"true"#, doc, 1)
        comprobar(Escala("Re mayor").svgPentagrama(opciones: OpcionesDePentagrama(titulo: "")).contains("id=\"titulo\""), #"false"#, doc, 2)
        comprobar(Escala("Re mayor").svgPentagrama(opciones: OpcionesDePentagrama(titulo: "Escala")).contains("<title id=\"titulo\">Escala</title>"), #"true"#, doc, 3)
    }

    @Test func notacionYPartitura13() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 13
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 13)
        comprobar(Acorde("Do13").svgPentagrama().contains("<title>Do₃</title>"), #"true"#, doc, 0)
        comprobar(Escala("Do mayor").svgPentagrama(octava: 6).contains("8va"), #"true"#, doc, 1)
        comprobar(Escala("Do mayor").svgPentagrama(octava: 3, opciones: OpcionesDePentagrama(maquetacion: .init(pentagramas: .doble))).contains("<title>Do₃</title>"), #"true"#, doc, 2)
    }

    @Test func notacionYPartitura14() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 14
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 14)
        let enLaMenor = OpcionesDePentagrama(armadura: .tonalidad(Tonalidad(.la, .menor)))
        comprobar(Arpegio(Acorde("Mi7")).svgPentagrama(opciones: enLaMenor).contains("<title>Sol♯₄</title>"), #"true"#, doc, 1)
    }

    @Test func notacionYPartitura15() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 15
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 15)
        let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        comprobar(Partitura(.init(voz), encabezado: Encabezado(titulo: "Do7")).svg().contains("<title>Si♭₄</title>"), #"true"#, doc, 1)
    }

    @Test func notacionYPartitura16() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 16
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 16)
        var porLineas = OpcionesDePentagrama()
        _ = porLineas.maquetacion.compasesPorLinea = 4
        let larga = try Voz(leyendo: Array(repeating: "Do4:4 Mi4:4 Sol4:2", count: 8).joined(separator: " "))
        let ocho = Partitura(.init(larga), encabezado: Encabezado(titulo: "Ocho compases"))
        comprobar(ocho.svg(opciones: porLineas) != ocho.svg(), #"true"#, doc, 4)
        let soprano = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
        let contralto = try Voz(leyendo: "Do5:4 Si4:4 Sol4:2")
        let juntas = Partitura(pentagramas: [.init(voces: [.init(soprano), .init(contralto)])], encabezado: Encabezado(titulo: "Dos voces"))
        comprobar(juntas.svg().contains("<title>Sol₄</title>"), #"true"#, doc, 8)
    }

    @Test func notacionYPartitura17() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 17
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 17)
        let derecha = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
        let izquierda = try Voz(leyendo: "Do3:2 Sol2:2")
        let manos: [Partitura.Pentagrama] = [.init(clave: .sol, voces: [.init(derecha)]), .init(clave: .fa, voces: [.init(izquierda)])]
        comprobar(Partitura(pentagramas: manos, encabezado: Encabezado(titulo: "Piano"), llave: true).svg().contains("<title>Sol₂</title>"), #"true"#, doc, 3)
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Sol3 Re4 Si4 | Do3 Sol3 Mi4 Do5")
        comprobar(coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia")).svg().contains("<title>Si₄</title>"), #"true"#, doc, 5)
    }

    @Test func notacionYPartitura18() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 18
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 18)
        let opciones = OpcionesDePentagrama(marcas: .init(intervalosDeLasNotas: true, semitonos: true, tonica: true))
        comprobar(Acorde("Sol9").svgPentagrama(opciones: opciones).contains(">1 3 5 ♭7 9</text>"), #"true"#, doc, 1)
        comprobar(Escala("Re dórico").svgPentagrama(octavas: 2, opciones: opciones).contains("<title>Re₆</title>"), #"true"#, doc, 2)
    }

    @Test func notacionYPartitura19() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 19
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 19)
        let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let voces = DisposicionDeAcorde.drop2.conducir(progresion) ?? []
        let grados = Tonalidad(.do).analizar(progresion).cifrados
        comprobar(Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(grados: .enOrden(grados))).svg().contains(">V7</text>"), #"true"#, doc, 3)
        comprobar(Escala("Re mayor").svgPentagrama(digitacion: .derecha).contains(">5</text>"), #"true"#, doc, 4)
        comprobar(Escala("Do mayor").svgPentagrama(secuencia: .terceras).contains("por terceras"), #"true"#, doc, 5)
    }

    @Test func notacionYPartitura20() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 20
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 20)
        comprobar(Tonalidad(.do).cifrasDeBajo(de: Acorde("Sol7/Si")), #"["6", "5"]"#, doc, 0)
        comprobar(Tonalidad(.la, .menor).cifrasDeBajo(de: Acorde("Mi")), #"["♯"]"#, doc, 1)
    }

    @Test func notacionYPartitura21() throws {
        // Sources/Armonia/Armonia.docc/NotacionYPartitura.md, bloque 21
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/NotacionYPartitura.md"#, 21)
        do {
            let acorde = try Acorde(leyendo: "Do7(b3)")
            print(acorde)
        } catch let error as ErrorDeLecturaDeTeoria {
            print(error)
            comprobarIgual(error.motivo, .tensionNoValida("b3"), doc, 7)
            comprobar(error.posicion, #"4"#, doc, 8)
            print(error.descripcion(en: .ascii(.ingles)))
        }
        do { _ = try TipoDeAcorde(comprobandoPasosDeQuinta: [0, -3, 4]) } catch { print(error) }
    }

    @Test func postonal1() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Postonal.md"#, 1)
        let c: ConjuntoDeClasesDeAltura = [0, 4, 7]
        comprobar(c.formaPrima, #"[0, 3, 7]"#, doc, 1)
        comprobar(c.numeroDeForte, #""3-11""#, doc, 2)
        comprobar(c.vectorIntervalico, #"[0, 0, 1, 1, 1, 0]"#, doc, 3)
        comprobar(c.nombreComun, #""tríada mayor o menor""#, doc, 4)
        comprobar(ConjuntoDeClasesDeAltura([0, 1, 4, 6]).estaEnRelacionZ(con: [0, 1, 3, 7]), #"true"#, doc, 5)
        comprobar(Escala(.re).conjuntoDeClasesDeAltura.numeroDeForte, #""7-35""#, doc, 6)
    }

    @Test func postonal2() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Postonal.md"#, 2)
        let triada = try ConjuntoDeClasesDeAltura(leyendo: "{0 4 7}")
        comprobar(triada.numeroDeForte, #""3-11""#, doc, 1)
        comprobar(try ConjuntoDeClasesDeAltura(leyendo: "01t").clases, #"[0, 1, 10]"#, doc, 2)
        comprobar(try ConjuntoDeClasesDeAltura(leyendo: "Re Fa La").clases, #"[2, 5, 9]"#, doc, 3)
        comprobar(try ConjuntoDeClasesDeAltura(leyendo: "4-Z15").clases, #"[0, 1, 4, 6]"#, doc, 4)
    }

    @Test func postonal3() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Postonal.md"#, 3)
        let berg = try SerieDodecafonica(leyendo: "Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si")
        comprobar(berg.description, #""5 4 0 9 7 2 8 1 3 6 t e""#, doc, 1)
        comprobar(berg.inversion(5).description, #""5 6 t 1 3 8 2 9 7 4 0 e""#, doc, 2)
        comprobar(berg.matriz[1], #"[6, 5, 1, 10, 8, 3, 9, 2, 4, 7, 11, 0]"#, doc, 3)
        comprobar(berg.esDeTodosLosIntervalos, #"true"#, doc, 4)
        comprobar(berg.identificar(berg.retrogrado(5)), #"[P11, R5]"#, doc, 5)
        comprobar(berg.hexacordos.primero.numeroDeForte, #""6-32""#, doc, 6)
        comprobar(berg.formasCombinatorias, #"[P11, I10, R5, RI4]"#, doc, 7)
        comprobar(berg.esTotalmenteCombinatoria, #"true"#, doc, 8)
    }

    @Test func postonal4() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Postonal.md"#, 4)
        let menorConSeptima: ConjuntoDeClasesDeAltura = [0, 3, 7, 10]
        comprobar(menorConSeptima.vectorDeIndice, #"[1, 2, 1, 2, 0, 2, 1, 2, 1, 0, 4, 0]"#, doc, 1)
        comprobar(menorConSeptima.notasComunes(invirtiendo: 10), #"4"#, doc, 2)
        comprobar(menorConSeptima.ejesDeSimetria, #"[5–11]"#, doc, 3)
        comprobar(ConjuntoDeClasesDeAltura([0, 1]).ejesDeSimetria, #"[0½–6½]"#, doc, 4)
    }

    @Test func postonal5() throws {
        // Sources/Armonia/Armonia.docc/Postonal.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Postonal.md"#, 5)
        comprobar(ConjuntoDeClasesDeAltura([1, 5, 8]).notas(), #"[Re♭, Fa, La♭]"#, doc, 0)
        comprobar(ConjuntoDeClasesDeAltura([1, 5, 8]).notas(con: Nota(.do, .sostenido)), #"[Do♯, Mi♯, Sol♯]"#, doc, 1)
    }

    @Test func tonalidad1() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 1)
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.armadura, #"0"#, doc, 1)
        _ = (laMenor.relativa, laMenor.homonima)
        comprobar(laMenor.vecinas, #"[Do mayor, Sol mayor, Mi menor, Fa mayor, Re menor]"#, doc, 3)
        comprobar(laMenor.armonizar(cuatriadas: true), #"Lam7 Sim7(♭5) Domaj7 Rem7 Mi7 Famaj7 Sol♯°7"#, doc, 4)
        _ = laMenor.cifradosRomanos()
        comprobarIgual(laMenor.nombreDeGrado(de: .sol), .subtonica, doc, 6)
        comprobar(Tonalidad.circuloDeQuintas(.menor), #"La♭ menor … La♯ menor"#, doc, 7)
        comprobar(Tonalidad(Escala(.re, .dorico)), #"nil"#, doc, 8)
    }

    @Test func tonalidad2() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 2)
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Escala(.do).ortografiar(midi: [60, 61, 62]), #"Do4 Do♯4 Re4"#, doc, 0)
        comprobar(Escala(.do).ortografiar(midi: [62, 61, 60]), #"Re4 Re♭4 Do4"#, doc, 1)
        comprobar(Altura(midi: 70, escala: Escala(.fa)), #"Si♭4"#, doc, 2)
        comprobar(Altura(midi: 68, tonalidad: "La menor"), #"Sol♯4"#, doc, 3)
        comprobar(Escala("Fa# mayor").ortografiar(midi: [65, 60]), #"Mi♯4 Si♯3"#, doc, 4)
        comprobar(Tonalidad.candidatos(midi: melodia).first?.valor, #"La menor"#, doc, 5)
    }

    @Test func tonalidad3() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 3)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 1)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 2)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 3)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 4)
        comprobar(analisis.nombre(en: .ascii(.ingles)), #""I–vi–V7/V–V7–I in C major""#, doc, 5)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Fa/La Sol7/Si Do"), #"I–IV6–V65–I en Do mayor"#, doc, 7)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Sim7(b5) Mi7 Lam"), #"iiø7–V7–i en La menor"#, doc, 8)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Lab Sib Do"), #"I–♭VI–♭VII–I en Do mayor"#, doc, 9)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Reb/Fa Sol7 Do"), #"I–♭II6–V7–I en Do mayor"#, doc, 10)
        comprobar(try AnalisisArmonico.analizar(leyendo: "Do Fa#°7 Sol Do"), #"I–vii°7/V–V–I en Do mayor"#, doc, 11)
        comprobar(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi7", "La"]).cifrados, #"["i", "iv6", "V7", "I"]"#, doc, 12)
        comprobar(Tonalidad(.do).analizar(["Mim6", "Mim/Sol"]).cifrados, #"["iii(add6)", "iii6"]"#, doc, 13)
    }

    @Test func tonalidad4() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 4)
        comprobar(Tonalidad(.do).analizar(["Fa6/La", "Fa6/Do", "Do(add9)/Mi"]).cifrados, #"["IV(add6)643", "IV(add6)642", "I(add9)763"]"#, doc, 0)
    }

    @Test func tonalidad5() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 5
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 5)
        comprobar(Tonalidad(.do).analizar(["Do", "Lab(#6,omit5)", "Sol", "Do"]).cifrados, #"["I", "It+6", "V", "I"]"#, doc, 0)
        comprobar(Tonalidad(.do).analizar(["Fa", "Re7(b5)/Lab", "Sol"]).cifrados, #"["IV", "Fr+6", "V"]"#, doc, 1)
        comprobar(Tonalidad(.do).analizar(["Lab(#6)", "Do/Sol", "Sol7", "Do"]).cifrados, #"["Ger+6", "I64", "V7", "I"]"#, doc, 2)
        comprobar(Tonalidad(.do).analizar(["Lab7", "Sol"]).cifrados, #"["Ger+6", "V"]"#, doc, 3)
        comprobar(Tonalidad(.do).analizar(["Reb/Lab", "Sol7", "Do"]).cifrados, #"["♭II64", "V7", "I"]"#, doc, 4)
        comprobar(Tonalidad(.do).analizar(["Mib7", "Rem7", "Reb7", "Do"]).cifrados, #"["subV7/ii", "ii7", "subV7", "I"]"#, doc, 5)
        comprobar(Tonalidad(.do).analizar(["Do/Sol", "Sol7", "Do"]).funciones.map { $0!.abreviatura }, #"["D", "D", "T"]"#, doc, 6)
    }

    @Test func tonalidad6() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 6
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 6)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let partituraAnalizada = analisis.partitura(encabezado: Encabezado(titulo: "Progresión")).musicXML()
        comprobar(partituraAnalizada.contains("<kind text=\"7\">dominant</kind>"), #"true"#, doc, 2)
        comprobar(partituraAnalizada.contains("<text>V7/V</text>"), #"true"#, doc, 3)
        comprobar(analisis.partitura(notacion: .ascii(.ingles)).musicXML().contains("C major:"), #"true"#, doc, 4)
    }

    @Test func tonalidad7() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 7
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 7)
        let progresion = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(progresion.partitura(notacion: .ascii(.ingles)).mei().contains(">D7</harm>"), #"true"#, doc, 1)
        comprobar(progresion.partitura().mei().contains("<syl>V7/V</syl>"), #"true"#, doc, 2)
    }

    @Test func tonalidad8() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 8
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 8)
        let cadencia = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do").cadencias[0]
        comprobarIgual(cadencia.tipo, .autentica, doc, 1)
        comprobar(cadencia.esPerfecta, #"true"#, doc, 2)
        comprobar(cadencia.description, #""Cadencia auténtica V7–I (acordes 3 → 4)""#, doc, 3)
        comprobar(cadencia.descripcion(en: .ascii(.ingles)), #""Authentic cadence V7–I (chords 3 → 4)""#, doc, 4)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Fa", "Do"]).cadencias.first?.tipo, .plagal, doc, 6)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Sol7", "Lam"]).cadencias.first?.tipo, .rota, doc, 7)
        comprobarIgual(Tonalidad(.do).analizar(["Do", "Lam", "Fa", "Sol"]).cadencias.first?.tipo, .semicadencia, doc, 8)
        comprobar(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi"]).cadencias[0].description, #""Semicadencia frigia iv6–V (acordes 2 → 3)""#, doc, 9)
        comprobar(Tonalidad(.do).analizar(["Do", "Fam", "Do"]).cadencias[0].description, #""Cadencia plagal menor iv–I (acordes 2 → 3)""#, doc, 10)
    }

    @Test func tonalidad9() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 9
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 9)
        let recorrido = try RecorridoTonal(leyendo: "Do Fa Sol7 Do Lam Re7 Sol")
        comprobar(recorrido.tramos.map(\.tonalidad), #"[Do mayor, Sol mayor]"#, doc, 1)
        comprobar(recorrido.cifrados, #"["I", "IV", "V7", "I", "ii", "V7", "I"]"#, doc, 2)
        comprobar(recorrido.description, #""I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor""#, doc, 3)
        comprobar(recorrido.modulaciones[0].acorde, #"4"#, doc, 4)
        comprobar(recorrido.modulaciones[0].pivote?.description, #""Lam = vi en Do mayor = ii en Sol mayor""#, doc, 5)
        comprobar(recorrido.cadencias.map(\.tonalidad), #"[Do mayor, Sol mayor]"#, doc, 6)
        comprobar(try RecorridoTonal(leyendo: "Do Sol Do Fa Rem Mi7 Lam").modulaciones[0].description, #""De Do mayor a La menor en el acorde 5 (pivote: Rem = ii en Do mayor = iv en La menor)""#, doc, 8)
    }

    @Test func tonalidad10() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 10
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 10)
        comprobar(try RecorridoTonal(leyendo: "Do Lam Re7 Sol7 Do").modulaciones.isEmpty, #"true"#, doc, 0)
    }

    @Test func tonalidad11() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 11
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 11)
        let planes = Tonalidad(.do).modulaciones(hasta: Tonalidad(.sol))
        comprobarIgual(planes[0].tecnica, .acordeComun, doc, 1)
        comprobar(planes[0].pivote?.description, #""Lam = vi en Do mayor = ii en Sol mayor""#, doc, 2)
        comprobarIgual(Tonalidad(.do).modulaciones(hasta: Tonalidad(Nota.la.bemol))[0].tecnica, .disminuidaEnarmonica, doc, 3)
    }

    @Test func tonalidad12() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 12
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 12)
        let c = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5")
        comprobar(c.faltas.map(\.tipo) == [.quintasParalelas, .octavasParalelas], #"true"#, doc, 1)
        comprobar(c.faltas[0].voces, #"[0, 1]"#, doc, 2)
        comprobar(c.faltas[0].description, #""Quintas paralelas entre bajo y tenor (acordes 1 → 2)""#, doc, 3)
        comprobar(c.faltas[0].descripcion(en: .ascii(.ingles)), #""Parallel fifths between bass and tenor (chords 1 → 2)""#, doc, 4)
        comprobar(try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5").esCorrecta, #"true"#, doc, 6)
        comprobar(try Coral(voces: [["Do3", "Sol2"], ["Mi4", "Re4"], ["Sol4", "Sol4"], ["Do5", "Si4"]]).esCorrecta, #"true"#, doc, 7)
    }

    @Test func tonalidad13() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 13
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 13)
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let partitura = coral.partitura(duracion: .blanca, encabezado: Encabezado(titulo: "Cadencia")).musicXML()
        comprobar(partitura.contains("<staves>2</staves>"), #"true"#, doc, 2)
    }

    @Test func tonalidad14() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 14
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 14)
        let cadencia = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        comprobar(cadencia.partitura(conCifrados: true, conAnalisis: true).musicXML().contains("<text>V</text>"), #"true"#, doc, 1)
    }

    @Test func tonalidad15() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 15
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 15)
        let cierre = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        comprobar(cierre.partitura(conCifrados: true, conAnalisis: true).mei().contains("<syl>V</syl>"), #"true"#, doc, 1)
    }

    @Test func tonalidad16() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 16
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 16)
        let coral = Coral.realizar(["Do", "Fa", "Sol7", "Do"])!
        comprobar(coral.esCorrecta, #"true"#, doc, 1)
        comprobar(coral.voz(0).map(\.nota), #"[Do, Fa, Sol, Do]"#, doc, 2)
        let conSoprano = Coral.realizar(["Do", "Fa", "Sol", "Do"], soprano: ["Mi4", "Fa4", "Re4", "Do4"])!
        comprobar(conSoprano.voz(3), #"[Mi4, Fa4, Re4, Do4]"#, doc, 5)
        comprobar(Coral.realizar(["Do", "Rem"], soprano: ["Sol4", "La4"]), #"nil"#, doc, 6)
    }

    @Test func tonalidad17() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 17
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 17)
        comprobar(Tonalidad(.do).acordes(para: .sol).prefix(3).map(\.valor), #"[Sol, Do, Sol7]"#, doc, 0)
        let propuestas = Tonalidad(.do).armonizar(melodia: ["Mi", "Fa", "Re", "Do"], propuestas: 3)
        comprobar(propuestas.map(\.valor.cifrados), #"[["I", "IV", "V", "I"], ["I", "IV", "V7", "I"], ["I", "ii", "V", "I"]]"#, doc, 3)
        comprobar(propuestas[0].valor.description, #""Do Fa Sol Do (I–IV–V–I)""#, doc, 4)
        comprobar(Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"])[0].valor.cifrados, #"["I", "V/V", "V", "I"]"#, doc, 5)
    }

    @Test func tonalidad18() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 18
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 18)
        let armonizada = Tonalidad(.do).armonizarACuatroVoces(["Mi4", "Fa4", "Re4", "Do4"])!
        comprobar(armonizada.armonizacion.cifrados, #"["I", "IV", "V", "I"]"#, doc, 1)
        comprobar(armonizada.coral.voz(3), #"[Mi4, Fa4, Re4, Do4]"#, doc, 2)
        comprobar(armonizada.coral.esCorrecta, #"true"#, doc, 3)
    }

    @Test func tonalidad19() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 19
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 19)
        let esquemas = EsquemaArmonico.buscar(en: ["Do7M", "Lam7", "Rem7", "Sol7", "Do7M"])
        comprobar(esquemas.map(\.progresion), #"[turnaround, progresión por quintas, ii–V–I]"#, doc, 1)
        comprobar(esquemas.map(\.indices), #"[0..<4, 1..<5, 2..<5]"#, doc, 2)
        comprobar(EsquemaArmonico.buscar(en: ["Fam7", "Sib7", "Do7M"])[0].progresion == .backdoor, #"true"#, doc, 3)
        comprobar(EsquemaArmonico.buscar(en: ["Lam", "Sol", "Fa", "Mi"])[0].progresion == .andaluza, #"true"#, doc, 4)
        comprobar(EsquemaArmonico.buscar(en: ["Lam", "Sol", "Fa", "Mi"])[0].tonica, #"La"#, doc, 5)
    }

    @Test func tonalidad20() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 20
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 20)
        comprobar(try Tonalidad(.do).acorde(romano: "ii65") == Acorde("Rem7/Fa"), #"true"#, doc, 0)
        comprobar(try Tonalidad(.do).acorde(romano: "V7/V") == Acorde("Re7"), #"true"#, doc, 1)
        comprobar(try Tonalidad(.la, .menor).acorde(romano: "vii°7") == Acorde("Sol#°7"), #"true"#, doc, 2)
        comprobar(try Tonalidad(.do).acordes(romanos: "I ♭VI ♭VII I") == ["Do", "Lab", "Sib", "Do"], #"true"#, doc, 3)
    }

    @Test func tonalidad21() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 21
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 21)
        comprobar(ProgresionConNombre.monte.acordes(sobre: .do) == ["Do7", "Fa", "Re7", "Sol"], #"true"#, doc, 0)
        comprobar(ProgresionConNombre.andaluza.acordes(sobre: .la) == ["Lam", "Sol", "Fa", "Mi"], #"true"#, doc, 1)
        comprobar(ProgresionConNombre.andaluza.nombre(en: .conPalabras(.ingles)) == "Andalusian cadence", #"true"#, doc, 2)
        comprobar(ProgresionConNombre.buscar(nombre: "ii-V-I") == .iiVI, #"true"#, doc, 3)
        comprobar(ProgresionConNombre.buscar(conteniendo: "blues").count, #"3"#, doc, 4)
    }

    @Test func tonalidad22() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 22
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 22)
        comprobar(try Tonalidad(.do).acorde(sobre: .si, cifras: "65"), #"Sol7/Si"#, doc, 0)
        comprobar(try Tonalidad(.la, .menor).acorde(sobre: .mi, cifras: "#"), #"Mi"#, doc, 1)
        comprobar(try Tonalidad(.la, .menor).acordes(bajoCifrado: "La Fa:6 Mi:# La"), #"[Lam, Rem/Fa, Mi, Lam]"#, doc, 2)
        let realizado = try Coral.realizar(bajoCifrado: "Do Fa Sol:7 Do", en: Tonalidad(.do))!
        comprobar(realizado.esCorrecta, #"true"#, doc, 4)
    }

    @Test func tonalidad23() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 23
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 23)
        comprobar(Tonalidad(.do).negativa(.mi) == Nota(.mi, .bemol), #"true"#, doc, 0)
        comprobar(Tonalidad(.do).negativo(Acorde("Do")) == Acorde("Dom"), #"true"#, doc, 1)
        comprobar(Tonalidad(.do).negativo(Acorde("Fa")) == Acorde("Solm"), #"true"#, doc, 2)
    }

    @Test func tonalidad24() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 24
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 24)
        let melodia: [Altura] = ["Mi5", "Re5", "Do5", "Do5", "Si4", "Do5"]
        let notas = NotaDeLaMelodia.analizar(melodia, sobre: ["Do", "Do", "Fa", "Sol", "Sol", "Do"])!
        comprobar(notas[1].description, #""Re5 (nota de paso)""#, doc, 2)
        comprobar(notas[3].description, #""Do5 (retardo 4-3)""#, doc, 3)
        comprobar(notas.notasExtranas.map(\.indice), #"[1, 3]"#, doc, 4)
        comprobar(NotaExtrana.apoyatura.nombre(en: .ascii(.ingles)), #""appoggiatura""#, doc, 5)
    }

    @Test func tonalidad25() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 25
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 25)
        let cantus = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"
        let fux = try Contrapunto(cantusFirmus: cantus, contrapunto: "La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5", especie: .primera)
        comprobar(fux.esCorrecto, #"true"#, doc, 2)
        comprobar(fux.contrapuntoArriba, #"true"#, doc, 3)
        comprobar(fux.informe.hasPrefix("Especie 1, con el contrapunto encima del cantus firmus\n"), #"true"#, doc, 4)
        comprobar(fux.informe.hasSuffix("Sin faltas."), #"true"#, doc, 5)
        let quintas = try Contrapunto(cantusFirmus: "Do4 Re4 Mi4 Do4", contrapunto: "Sol4 La4 Sol4 Do5", especie: .primera)
        comprobar(quintas.faltas.contains(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1)), #"true"#, doc, 8)
        comprobar(FaltaDeContrapunto(tipo: .quintasParalelas, compases: 0...1).description, #""Quintas paralelas (compases 1 → 2)""#, doc, 9)
        comprobar(try Contrapunto(cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1", especie: .segunda).esCorrecto, #"true"#, doc, 12)
        comprobar(try Contrapunto(cantusFirmus: "Re4 Mi4 Re4", contrapunto: "-:2 Re5:1 Do#5 Re5:1", especie: .cuarta).esCorrecto, #"true"#, doc, 13)
    }

    @Test func tonalidad26() throws {
        // Sources/Armonia/Armonia.docc/Tonalidad.md, bloque 26
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Tonalidad.md"#, 26)
        let tres = try ContrapuntoAVariasVoces(cantusFirmus: "Re4 Fa4 Mi4 Re4", voces: [("La4 La4 Do#5 Re5", .primera), ("Re3 Re3 La2 Re3", .primera)])
        comprobar(tres.esCorrecto, #"true"#, doc, 1)
        let paralelas = try ContrapuntoAVariasVoces(cantusFirmus: "Re4 Fa4 Mi4 Re4", voces: [("La4 La4 Sol4 La4", .primera), ("Re3 Re3 Do3 Re3", .primera)])
        comprobar(paralelas.faltas.contains(FaltaEntreVoces(falta: FaltaDeContrapunto(tipo: .quintasParalelas, compases: 1...2), voces: [1, 2])), #"true"#, doc, 4)
    }

    @Test func trastes1() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, bloque 1
        let mastil = Mastil(.guitarra)
        let ukelele = try Encordado(leyendo: "ukulele")
        let acorde = Acorde("Sol7/Si")
        let formas = mastil.digitaciones(de: acorde, limite: 3)
        let primera = formas.first
        let tablatura = primera?.tablatura
        let notas = primera?.notas(para: acorde)
        let dedos = primera?.dedos
        let cejilla = primera?.cejilla
        let pentatonica = mastil.posiciones(de: Escala(.la, .pentatonicaMenor), en: 0...12)
        _ = (ukelele, tablatura, notas, dedos, cejilla, pentatonica)
    }

    @Test func trastes2() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, bloque 2
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Trastes.md"#, 2)
        let mastil = Mastil(.guitarra, numeroDeTrastes: 12)
        let posiciones = mastil.arpegios(de: Acorde("Lam"))
        comprobar(posiciones.count, #"3"#, doc, 2)
        comprobar(posiciones[0].rangoDeTrastes == 0...3, #"true"#, doc, 3)
        comprobar(posiciones[0].alturas.map(\.midi) == [40, 45, 48, 52, 57, 60, 64], #"true"#, doc, 4)
        let todas = mastil.posiciones(de: Acorde("Lam"), en: 0...5)
        _ = todas
    }

    @Test func trastes3() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, bloque 3
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Trastes.md"#, 3)
        let mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        let porCuerda = mastil.posicionesPorCuerda(de: Escala(.sol, .mayor))
        comprobar(porCuerda.count, #"7"#, doc, 2)
        comprobar(porCuerda[0].rangoDeTrastes == 0...5, #"true"#, doc, 3)
        comprobar(porCuerda[0].posiciones.count, #"18"#, doc, 4)
        let caged = mastil.posicionesCAGED(de: Escala(.do, .mayor))
        comprobar(caged.map(\.forma) == [.c, .a, .g, .e, .d], #"true"#, doc, 6)
        comprobar(caged.map(\.rangoDeTrastes) == [0...4, 2...6, 5...9, 7...11, 9...13], #"true"#, doc, 7)
    }

    @Test func trastes4() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, bloque 4
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Trastes.md"#, 4)
        let mastil = Mastil(.guitarra, numeroDeTrastes: 15)
        let posicion = mastil.posicionesCAGED(de: Escala(.sol, .mayor))[0]
        comprobar(posicion.escala == Escala(.sol, .mayor), #"true"#, doc, 2)
        let enCorcheas = posicion.partitura(ritmo: .uniforme(.corchea))
        comprobar(enCorcheas.dibujaElRitmo && enCorcheas.pentagramas[0].numeroDeCuerdas == 6, #"true"#, doc, 4)
        let doMayor = mastil.digitaciones(de: Acorde("Do"))[0]
        comprobar(doMayor.partitura().encabezado.tema == .progresion([Acorde("Do")]), #"true"#, doc, 6)
        comprobar(doMayor.partitura().pentagramas[0].claveEscrita == .solOctavaBaja, #"true"#, doc, 7)
    }

    @Test func trastes5() throws {
        // Sources/Armonia/Armonia.docc/Trastes.md, bloque 5
        let mastil = Mastil(.guitarra)
        let leida = try Digitacion(leyendo: "x32010", en: mastil)
        let comprobada = Digitacion(comprobando: [nil, 3, 2, 0, 1, 0], en: mastil)
        let sonido = mastil.midiSiExiste(en: PosicionEnElMastil(cuerda: 9, traste: 0))
        _ = (leida, comprobada, sonido)
    }

    @Test func tutorialAcordes01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-01.swift"#, 1)
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, doc, 3)
    }

    @Test func tutorialAcordes01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-02.swift"#, 1)
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, doc, 3)
        comprobar(dominante.posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, doc, 4)
    }

    @Test func tutorialAcordes01031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-01-03.swift"#, 1)
        let dominante: Acorde = "Sol7/Si"
        comprobar(dominante.notas, #"[Sol, Si, Re, Fa]"#, doc, 3)
        comprobar(dominante.posicionCerrada(octava: 3), #"[Si3, Re4, Fa4, Sol4]"#, doc, 4)
        comprobar(dominante.cifrado(estilo: .ascii(.ingles)), #""G7/B""#, doc, 5)
        comprobar(Acorde("G7(b9,#11)").cifrado, #""Sol7(♭9,♯11)""#, doc, 6)
    }

    @Test func tutorialAcordes02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-01.swift"#, 1)
        comprobar(Acorde.identificar(notas: [.mi, .sol, .do]).first, #"Do/Mi"#, doc, 2)
    }

    @Test func tutorialAcordes02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-02.swift"#, 1)
        comprobar(Acorde.identificar(notas: [.mi, .sol, .do]).first, #"Do/Mi"#, doc, 2)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, doc, 3)
    }

    @Test func tutorialAcordes02031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-02-03.swift"#, 1)
        comprobar(Acorde.identificar(notas: [.mi, .sol, .do]).first, #"Do/Mi"#, doc, 2)
        comprobar(Acorde.identificar(midi: [55, 59, 62, 65, 68]).first, #"Sol7(♭9)"#, doc, 3)
        let candidato = Acorde.candidatos(notas: [.do, .mi, "Sib"]).first!
        comprobar(candidato.valor.cifrado, #""Do7""#, doc, 6)
        comprobar(candidato.omitidas, #"[Sol]"#, doc, 7)
    }

    @Test func tutorialAcordes03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-01.swift"#, 1)
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, doc, 3)
    }

    @Test func tutorialAcordes03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-02.swift"#, 1)
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, doc, 3)
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, doc, 4)
    }

    @Test func tutorialAcordes03031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/acordes-03-03.swift"#, 1)
        let menor = Escala("La menor armónica")
        comprobar(menor.notas, #"[La, Si, Do, Re, Mi, Fa, Sol♯]"#, doc, 3)
        comprobar(menor.cifradosRomanos(cuatriadas: true), #"["i(maj7)", "iiø7", "♭III+maj7", "iv7", "V7", "♭VImaj7", "vii°7"]"#, doc, 4)
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.armonizar(cuatriadas: true), #"Lam7 Sim7(♭5) Domaj7 Rem7 Mi7 Famaj7 Sol♯°7"#, doc, 8)
    }

    @Test func tutorialAnalisis01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-01.swift"#, 1)
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Tonalidad.identificar(midi: melodia).first, #"La menor"#, doc, 3)
    }

    @Test func tutorialAnalisis01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-01-02.swift"#, 1)
        let melodia = [69, 71, 72, 74, 76, 77, 80, 81]
        comprobar(Tonalidad.identificar(midi: melodia).first, #"La menor"#, doc, 3)
        let laMenor: Tonalidad = "La menor"
        comprobar(laMenor.relativa, #"Do mayor"#, doc, 6)
        _ = laMenor.cifradosRomanos()
    }

    @Test func tutorialAnalisis02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-01.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
    }

    @Test func tutorialAnalisis02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-02.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
    }

    @Test func tutorialAnalisis02031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-02-03.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
    }

    @Test func tutorialAnalisis03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-01.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
        let cadencia = analisis.cadencias.last!
        comprobarIgual(cadencia.tipo, .autentica, doc, 10)
        comprobar(cadencia.esPerfecta, #"true"#, doc, 11)
    }

    @Test func tutorialAnalisis03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-03-02.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
        let cadencia = analisis.cadencias.last!
        comprobarIgual(cadencia.tipo, .autentica, doc, 10)
        comprobar(cadencia.esPerfecta, #"true"#, doc, 11)
        comprobarIgual(try AnalisisArmonico.analizar(leyendo: "Do Fa Sol").cadencias.last!.tipo, .semicadencia, doc, 12)
    }

    @Test func tutorialAnalisis04011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-01.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
        let fichero = analisis.partitura().midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, doc, 11)
    }

    @Test func tutorialAnalisis04021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-02.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
        let fichero = analisis.partitura().midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, doc, 11)
        comprobar(pieza.acordes(), #"[Do, Lam, Re7, Sol7, Do]"#, doc, 12)
        if let leido = pieza.analisis() {
            comprobar(leido.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 14)
        }
    }

    @Test func tutorialAnalisis04031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/analisis-04-03.swift"#, 1)
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        comprobar(analisis.tonalidad, #"Do mayor"#, doc, 3)
        comprobar(analisis.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 4)
        comprobar(analisis.funciones.map { $0?.abreviatura ?? "–" }, #"["T", "T", "D", "D", "T"]"#, doc, 5)
        comprobarIgual(analisis.acordes[2].categoria, .dominanteSecundaria(de: 5), doc, 6)
        comprobar(analisis, #"I–vi–V7/V–V7–I en Do mayor"#, doc, 7)
        let fichero = analisis.partitura().midi()
        let pieza = try PiezaImportada(leyendo: fichero)
        comprobar(pieza.tonalidadEstimada, #"Do mayor"#, doc, 11)
        comprobar(pieza.acordes(), #"[Do, Lam, Re7, Sol7, Do]"#, doc, 12)
        if let leido = pieza.analisis() {
            comprobar(leido.cifrados, #"["I", "vi", "V7/V", "V7", "I"]"#, doc, 14)
        }
        let partitura = analisis.partitura(encabezado: Encabezado(titulo: "Mi primera progresión")).musicXML()
        comprobar(partitura.contains("<text>V7/V</text>"), #"true"#, doc, 18)
    }

    @Test func tutorialNotas01011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-01.swift"#, 1)
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, doc, 3)
    }

    @Test func tutorialNotas01021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-02.swift"#, 1)
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, doc, 3)
        let solBemol: Nota = "Solb"
        comprobar(fa == solBemol, #"false"#, doc, 5)
    }

    @Test func tutorialNotas01031() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-01-03.swift"#, 1)
        let fa: Nota = "Fa#"
        comprobar(fa, #"Fa♯"#, doc, 3)
        let solBemol: Nota = "Solb"
        comprobar(fa == solBemol, #"false"#, doc, 5)
        comprobar(fa.intervalo(hasta: solBemol), #"2ª disminuida"#, doc, 6)
    }

    @Test func tutorialNotas02011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-01.swift"#, 1)
        let la = Altura("La4")
        comprobar(la.midi, #"69"#, doc, 3)
        comprobar(la.frecuencia(), #"440.0"#, doc, 4)
    }

    @Test func tutorialNotas02021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-02-02.swift"#, 1)
        let la = Altura("La4")
        comprobar(la.midi, #"69"#, doc, 3)
        comprobar(la.frecuencia(), #"440.0"#, doc, 4)
        comprobar(Altura(midi: 63, ventana: .bemoles), #"Mi♭4"#, doc, 5)
        comprobar(Altura(midi: 68, tonalidad: "La menor"), #"Sol♯4"#, doc, 6)
    }

    @Test func tutorialNotas03011() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-01.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-01.swift"#, 1)
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, doc, 2)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, doc, 3)
    }

    @Test func tutorialNotas03021() throws {
        // Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift, bloque 1
        let doc = BloqueDeDocumentacion(#"Sources/Armonia/Armonia.docc/Resources/Tutoriales/notas-03-02.swift"#, 1)
        comprobar(Nota.si.intervalo(hasta: .fa), #"5ª disminuida"#, doc, 2)
        comprobar(Intervalo.terceraMayor.inversion, #"6ª menor"#, doc, 3)
        comprobar(Nota.re + "3M", #"Fa♯"#, doc, 4)
        comprobar(Altura("Do4") + "5J", #"Sol4"#, doc, 5)
    }
}
