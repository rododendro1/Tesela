import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La tablatura en MusicXML, en su propio pentagrama, y las voces y los pentagramas del fichero al importarlo.
@Suite struct TablaturaYVocesEnMusicXMLTests {
    /// Do3 en la 5.ª cuerda y Mi3 en la 4.ª, en una guitarra con capo en el 2: dos negras y un silencio de blanca.
    private var conTablatura: Partitura {
        let voz = Voz([
            Evento(alturas: ["Re3"], duracion: .negra), Evento(alturas: ["Fa#3"], duracion: .negra),
            .silencio(.blanca),
        ])
        let pulsaciones: [Duracion: [Tablatura.Pulsacion]] = [
            .cero: [Tablatura.Pulsacion(cuerda: 1, traste: 3)], .negra: [Tablatura.Pulsacion(cuerda: 2, traste: 2)],
        ]
        let afinacion: [Altura] = ["Mi2", "La2", "Re3", "Sol3", "Si3", "Mi4"]
        let pentagrama = Partitura.Pentagrama(
            voces: [Partitura.Linea(voz, pulsaciones: pulsaciones)], cuerdas: 6, afinacion: afinacion, capo: 2)
        return Partitura(pentagramas: [pentagrama], encabezado: Encabezado(titulo: "Con capo"))
    }

    @Test func laTablaturaVaEnSuPentagrama() throws {
        let xml = conTablatura.musicXML()
        #expect(xml.contains("<staves>2</staves>"))
        #expect(xml.contains("<clef number=\"1\">\n          <sign>G</sign>"))
        #expect(xml.contains("<clef-octave-change>-1</clef-octave-change>"))
        #expect(xml.contains("<clef number=\"2\">\n          <sign>TAB</sign>"))
        #expect(xml.contains("<staff-lines>6</staff-lines>"))
        let grave = "<staff-tuning line=\"1\"><tuning-step>E</tuning-step><tuning-octave>2</tuning-octave>"
        #expect(xml.contains(grave))
        #expect(xml.contains("<staff-tuning line=\"6\"><tuning-step>E</tuning-step><tuning-octave>4</tuning-octave>"))
        #expect(xml.contains("<capo>2</capo>"))
        // La cuerda 1 desde la grave es la 5.ª de MusicXML, que cuenta desde la aguda.
        #expect(xml.contains("<string>5</string>\n            <fret>3</fret>"))
        #expect(xml.contains("<string>4</string>\n            <fret>2</fret>"))
        #expect(xml.components(separatedBy: "<technical>").count - 1 == 2)
        #expect(xml.contains("<staff>2</staff>") && xml.contains("<backup>"))
        // Sin tablatura, ni el pentagrama ni la técnica.
        var sinTablatura = conTablatura
        sinTablatura.pentagramas[0].cuerdas = nil
        let sola = sinTablatura.musicXML()
        #expect(!sola.contains("<staves>") && !sola.contains("TAB") && !sola.contains("<technical>"))
        // MEI no la escribe.
        #expect(!conTablatura.mei().contains("TAB"))
    }

    @Test func laTablaturaNoDuplicaLasNotasAlLeerla() throws {
        let pieza = try PiezaImportada(musicXML: Data(conTablatura.musicXML().utf8))
        #expect(pieza.notas.map(\.altura) == ["Re3", "Fa#3"])
        #expect(pieza.notas.allSatisfy { $0.pentagrama == 1 && $0.voz == 1 })
        let vuelta = pieza.partitura()
        #expect(vuelta.pentagramas.count == 1 && vuelta.pentagramas[0].voces.count == 1)
    }

    @Test func soloTablaturaSeLee() throws {
        // Una parte que solo tiene el pentagrama de tablatura: sus notas son las únicas, y se leen.
        let xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <score-partwise version="4.0">
              <part-list><score-part id="P1"><part-name>Guitarra</part-name></score-part></part-list>
              <part id="P1">
                <measure number="1">
                  <attributes><divisions>1</divisions><clef><sign>TAB</sign><line>5</line></clef></attributes>
                  <note><pitch><step>E</step><octave>2</octave></pitch><duration>4</duration><voice>1</voice></note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        #expect(pieza.notas.map(\.altura) == ["Mi2"])
    }

    @Test func lasVocesYLosPentagramasDelFichero() throws {
        // Un piano: la derecha con dos voces (dos blancas; una negra y una blanca con puntillo) y la izquierda con una
        // redonda, en la voz 5.
        let xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <score-partwise version="4.0">
              <part-list><score-part id="P1"><part-name>Piano</part-name></score-part></part-list>
              <part id="P1">
                <measure number="1">
                  <attributes>
                    <divisions>1</divisions><staves>2</staves>
                    <clef number="1"><sign>G</sign><line>2</line></clef>
                    <clef number="2"><sign>F</sign><line>4</line></clef>
                  </attributes>
                  <note>
                    <pitch><step>G</step><octave>4</octave></pitch><duration>2</duration>
                    <voice>1</voice><staff>1</staff>
                  </note>
                  <note>
                    <pitch><step>A</step><octave>4</octave></pitch><duration>2</duration>
                    <voice>1</voice><staff>1</staff>
                  </note>
                  <backup><duration>4</duration></backup>
                  <note>
                    <pitch><step>E</step><octave>4</octave></pitch><duration>1</duration>
                    <voice>2</voice><staff>1</staff>
                  </note>
                  <note>
                    <pitch><step>F</step><octave>4</octave></pitch><duration>3</duration>
                    <voice>2</voice><staff>1</staff>
                  </note>
                  <backup><duration>4</duration></backup>
                  <note>
                    <pitch><step>C</step><octave>3</octave></pitch><duration>4</duration>
                    <voice>5</voice><staff>2</staff>
                  </note>
                </measure>
              </part>
            </score-partwise>
            """
        let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
        #expect(Set(pieza.notas.compactMap(\.voz)) == [1, 2, 5] && Set(pieza.notas.compactMap(\.pentagrama)) == [1, 2])
        let partitura = pieza.partitura()
        #expect(partitura.pentagramas.count == 2)
        let derecha = partitura.pentagramas[0].voces.map { $0.voz.eventos.map(\.alturas) }
        #expect(derecha == [[["Sol4"], ["La4"]], [["Mi4"], ["Fa4"]]])
        #expect(partitura.pentagramas[1].voces.map { $0.voz.eventos.map(\.alturas) } == [[["Do3"]]])
        #expect(partitura.pentagramas[1].claveEscrita == .fa)
        // Sin voces en el fichero (como en MIDI), las de siempre: lo que se solapa va en otra voz.
        let sinVoces = PiezaImportada(
            notas: pieza.notas.map {
                NotaDeLaPieza(altura: $0.altura, inicio: $0.inicio, duracion: $0.duracion, pentagrama: $0.pentagrama)
            })
        #expect(sinVoces.partitura().pentagramas[0].voces.count == 2)
    }

    @Test func lasCapasDeMEISonVoces() throws {
        let partitura = Partitura(
            pentagramas: [
                Partitura.Pentagrama(voces: [
                    Partitura.Linea(Voz([Evento(alturas: ["Sol4"], duracion: .redonda)])),
                    Partitura.Linea(Voz([Evento(alturas: ["Mi4"], duracion: .redonda)])),
                ])
            ])
        let pieza = try PiezaImportada(leyendo: Data(partitura.mei().utf8))
        #expect(Set(pieza.notas.compactMap(\.voz)) == [1, 2])
        #expect(pieza.notas.allSatisfy { $0.pentagrama == nil })
        #expect(pieza.partitura().pentagramas[0].voces.count == 2)
    }
}
