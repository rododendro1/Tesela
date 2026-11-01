import Armonia

/// Tablaturas en MusicXML: digitaciones de acordes y arpegios en el mástil, con la cuerda y el traste de cada
/// nota, la afinación del instrumento y el capo, para abrirlas en MuseScore o Guitar Pro. No usa SwiftUI, así
/// que se prueba en Linux.
///
///     let mastil = Mastil(Encordado.guitarra.conCapo(2))
///     let xml = PresentacionDeTablatura.musicXML(
///         digitaciones: mastil.digitaciones(de: Acorde("Do"), limite: 1), titulo: "Re con capo")
///     xml.contains("<capo>2</capo>")   // true
///
/// Los trastes se cuentan desde el capo, como en el mástil (`Encordado.conCapo(_:)`); las cuerdas se
/// numeran como en MusicXML, desde la más aguda. Las notas que se escriben son las que suenan.
public enum PresentacionDeTablatura {
    /// Las divisiones de la negra: la semicorchea es la nota más corta que se escribe.
    static let divisiones = 4

    /// Un acorde por compás, en redondas: cada digitación con todas sus cuerdas a la vez. Si se dan los acordes
    /// (uno por digitación), las notas se escriben con su ortografía (Si♭, no La♯) y los cifrados encima.
    public static func musicXML(
        digitaciones: [Digitacion], acordes: [Acorde] = [], titulo: String, notacion: Notacion = .espanolUnicode
    ) -> String {
        guard let mastil = digitaciones.first?.mastil else {
            return documento(mastil: Mastil(), compases: [], titulo: titulo, notacion: notacion)
        }
        let compases = digitaciones.enumerated().map { i, digitacion -> String in
            let acorde = i < acordes.count ? acordes[i] : nil
            var xml = ""
            if let acorde {
                xml += "      <direction placement=\"above\"><direction-type><words>"
                xml += EscrituraXML.escapar(acorde.cifrado(en: notacion)) + "</words></direction-type></direction>\n"
            }
            for (j, posicion) in digitacion.posiciones.enumerated() {
                xml += nota(
                    posicion, en: mastil, ortografia: acorde?.notas ?? [], duracion: .redonda, enAcorde: j > 0)
            }
            if digitacion.posiciones.isEmpty { xml += silencio(.redonda) }
            return xml
        }
        return documento(mastil: mastil, compases: compases, titulo: titulo, notacion: notacion)
    }

    /// Las notas de un arpegio en una posición, de grave a agudo, en corcheas (o en la figura que se diga), de
    /// cuatro tiempos en cuatro tiempos; el último compás se completa con un silencio.
    public static func musicXML(
        arpegio: ArpegioEnElMastil, acorde: Acorde? = nil, figura: Figura = .corchea, titulo: String,
        notacion: Notacion = .espanolUnicode
    ) -> String {
        musicXML(
            posiciones: arpegio.posiciones, en: arpegio.mastil, ortografia: acorde?.notas ?? [], figura: figura,
            titulo: titulo, notacion: notacion)
    }

    /// Las notas de una escala en una posición, de grave a agudo, en corcheas (o en la figura que se diga).
    public static func musicXML(
        posicion: EscalaEnElMastil, escala: Escala? = nil, figura: Figura = .corchea, titulo: String,
        notacion: Notacion = .espanolUnicode
    ) -> String {
        musicXML(
            posiciones: posicion.posiciones, en: posicion.mastil, ortografia: escala?.notas ?? [], figura: figura,
            titulo: titulo, notacion: notacion)
    }

    /// Unas posiciones tocadas una detrás de otra.
    static func musicXML(
        posiciones: [PosicionEnElMastil], en mastil: Mastil, ortografia: [Nota], figura: Figura, titulo: String,
        notacion: Notacion
    ) -> String {
        // Una figura más larga que la redonda no cabe en un compás de 4/4.
        let figura = figura == .cuadrada ? .redonda : figura
        let porCompas = max(1, ticks(.redonda) / ticks(figura))
        var compases: [String] = []
        var inicio = 0
        while inicio < posiciones.count {
            let fin = min(inicio + porCompas, posiciones.count)
            var xml = ""
            for posicion in posiciones[inicio..<fin] {
                xml += nota(posicion, en: mastil, ortografia: ortografia, duracion: figura, enAcorde: false)
            }
            let resto = ticks(.redonda) - (fin - inicio) * ticks(figura)
            if resto > 0 { xml += silencio(ticks: resto) }
            compases.append(xml)
            inicio = fin
        }
        return documento(mastil: mastil, compases: compases, titulo: titulo, notacion: notacion)
    }

    // MARK: El documento

    private static func documento(mastil: Mastil, compases: [String], titulo: String, notacion: Notacion) -> String {
        let encordado = mastil.encordado
        let alAire = encordado.sinCapo.cuerdas
        var xml = """
            <?xml version="1.0" encoding="UTF-8" standalone="no"?>
            <!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 4.0 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">
            <score-partwise version="4.0">
              <work>
                <work-title>\(EscrituraXML.escapar(titulo))</work-title>
              </work>
              <identification>
                <encoding>
                  <software>Armonia</software>
                </encoding>
              </identification>
              <part-list>
                <score-part id="P1">
                  <part-name>\(EscrituraXML.escapar(encordado.titulo(en: notacion)))</part-name>
                </score-part>
              </part-list>
              <part id="P1">

            """
        for (i, compas) in (compases.isEmpty ? [silencio(.redonda)] : compases).enumerated() {
            xml += "    <measure number=\"\(i + 1)\">\n"
            if i == 0 {
                xml += "      <attributes>\n        <divisions>\(divisiones)</divisions>\n"
                xml += "        <key><fifths>0</fifths></key>\n"
                xml += "        <time><beats>4</beats><beat-type>4</beat-type></time>\n"
                xml += "        <clef><sign>TAB</sign><line>5</line></clef>\n"
                xml += "        <staff-details>\n          <staff-lines>\(alAire.count)</staff-lines>\n"
                for (linea, cuerda) in alAire.enumerated() {
                    xml += "          <staff-tuning line=\"\(linea + 1)\">"
                    xml += "<tuning-step>\(paso(cuerda.nota.natural))</tuning-step>"
                    if cuerda.nota.alteracion.semitonos != 0 {
                        xml += "<tuning-alter>\(cuerda.nota.alteracion.semitonos)</tuning-alter>"
                    }
                    xml += "<tuning-octave>\(cuerda.octava)</tuning-octave></staff-tuning>\n"
                }
                if encordado.capo > 0 { xml += "          <capo>\(encordado.capo)</capo>\n" }
                xml += "        </staff-details>\n      </attributes>\n"
            }
            xml += compas
            xml += "    </measure>\n"
        }
        xml += "  </part>\n</score-partwise>\n"
        return xml
    }

    /// Una nota con su cuerda y su traste. `enAcorde`: suena a la vez que la anterior.
    private static func nota(
        _ posicion: PosicionEnElMastil, en mastil: Mastil, ortografia: [Nota], duracion: Figura, enAcorde: Bool
    ) -> String {
        let altura = escrita(mastil.altura(en: posicion), ortografia: ortografia)
        // En MusicXML la cuerda 1 es la más aguda; en el mástil, la 0 es la más grave.
        let cuerda = mastil.encordado.numeroDeCuerdas - posicion.cuerda
        var xml = "      <note>\n"
        if enAcorde { xml += "        <chord/>\n" }
        xml += "        <pitch><step>\(paso(altura.nota.natural))</step>"
        if altura.nota.alteracion.semitonos != 0 { xml += "<alter>\(altura.nota.alteracion.semitonos)</alter>" }
        xml += "<octave>\(altura.octava)</octave></pitch>\n"
        xml += "        <duration>\(ticks(duracion))</duration>\n        <voice>1</voice>\n"
        xml += "        <type>\(tipo(duracion))</type>\n"
        xml += "        <notations><technical><string>\(cuerda)</string><fret>\(posicion.traste)</fret>"
        xml += "</technical></notations>\n      </note>\n"
        return xml
    }

    private static func silencio(_ figura: Figura) -> String {
        silencio(ticks: ticks(figura))
    }

    private static func silencio(ticks: Int) -> String {
        "      <note>\n        <rest/>\n        <duration>\(ticks)</duration>\n"
            + "        <voice>1</voice>\n      </note>\n"
    }

    /// La altura escrita como la escribe el acorde o la escala, si tiene esa nota; si no, como sale.
    static func escrita(_ altura: Altura, ortografia: [Nota]) -> Altura {
        guard let nota = ortografia.first(where: { $0.claseDeAltura == altura.nota.claseDeAltura }),
            nota != altura.nota
        else { return altura }
        // La octava de la nota escrita es la que deja su número MIDI igual: Si♯3 suena como Do4.
        let enLaMismaOctava = Altura(nota, octava: altura.octava)
        return Altura(nota, octava: altura.octava + (altura.midi - enLaMismaOctava.midi) / 12)
    }

    static func ticks(_ figura: Figura) -> Int {
        switch figura {
        case .cuadrada: return 8 * divisiones
        case .redonda: return 4 * divisiones
        case .blanca: return 2 * divisiones
        case .negra: return divisiones
        case .corchea: return divisiones / 2
        default: return max(1, divisiones / 4)
        }
    }

    private static func tipo(_ figura: Figura) -> String {
        switch figura {
        case .cuadrada: return "breve"
        case .redonda: return "whole"
        case .blanca: return "half"
        case .negra: return "quarter"
        case .corchea: return "eighth"
        default: return "16th"
        }
    }

    private static func paso(_ natural: NotaNatural) -> String {
        ["C", "D", "E", "F", "G", "A", "B"][natural.rawValue]
    }
}
