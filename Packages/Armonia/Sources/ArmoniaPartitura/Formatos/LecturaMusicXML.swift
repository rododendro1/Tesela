import ArmoniaNucleo
import ArmoniaTeoria
// Lectura de MusicXML por partes (`score-partwise`, lo que exportan MuseScore, Finale, Sibelius,
// Dorico y `musicXML()`), sin comprimir.
//
// Se leen las notas con su ortografía tal cual (un Sol♯ sigue siendo Sol♯), los acordes (`<chord/>`),
// las voces que vuelven atrás (`<backup>`) o avanzan (`<forward>`), las ligaduras (dos notas ligadas son
// una sola) y los instrumentos transpositores (`<transpose>`: se lee lo que suena, no lo que se escribe).
// Las notas de adorno y las notas guía (`<grace>`, `<cue>`) no cuentan, ni la percusión (`<unpitched>`).
// Del primer compás que los tenga: la armadura, el compás y el tempo (`<sound tempo>`).

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

extension PiezaImportada {
    /// Lee una partitura MusicXML por partes.
    ///
    ///     let xml = coral.musicXML(duracion: .blanca)
    ///     let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
    public init(musicXML datos: Data) throws {
        let lector = LectorMusicXML()
        let parser = XMLParser(data: datos)
        parser.shouldResolveExternalEntities = false
        parser.delegate = lector
        guard parser.parse() else { throw ErrorDeImportacion.xmlDanado(linea: parser.lineNumber) }
        guard lector.raiz == "score-partwise" else { throw ErrorDeImportacion.noEsMusicXMLPorPartes }
        guard !lector.notas.isEmpty else { throw ErrorDeImportacion.sinNotas }
        self.init(titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas,
                  tempo: lector.tempo, notas: lector.notas)
    }
}

/// Recorre el documento elemento a elemento y va colocando las notas en el tiempo.
final class LectorMusicXML: NSObject, XMLParserDelegate {
    private(set) var raiz: String?
    private(set) var titulo: String?
    private(set) var tonalidad: Tonalidad?
    private(set) var compas: Compas?
    private(set) var tempo: Tempo?
    private(set) var notas: [NotaDeLaPieza] = []

    /// Los elementos abiertos, del documento al actual, y el texto del actual.
    private var pila: [String] = []
    private var texto = ""

    // La parte en curso.
    private var parte = -1
    private var divisiones = 1
    private var posicion = Duracion.cero
    private var inicioDelCompas = Duracion.cero
    /// Hasta dónde ha llegado alguna voz en el compás: ahí empieza el siguiente.
    private var finDelCompas = Duracion.cero
    private var inicioDeLaAnterior = Duracion.cero
    private var transposicion: (pasos: Int, semitonos: Int)?
    /// Las notas con una ligadura que sigue, por parte y altura MIDI: su índice en `notas`.
    private var ligadas: [Int: Int] = [:]

    // Lo que se va leyendo dentro de un elemento.
    private var nota = NotaLeida()
    private var armadura: (quintas: Int?, menor: Bool) = (nil, false)
    private var tiempo: (pulsos: Int?, unidad: Int?) = (nil, nil)
    private var transporte: (pasos: Int, semitonos: Int, octavas: Int) = (0, 0, 0)

    private struct NotaLeida {
        var esDeAcorde = false
        var sinTiempo = false   // de adorno
        var muda = false        // silencio, nota guía o percusión
        var paso: NotaNatural?
        var alteracion = 0
        var octava: Int?
        var pulsos: Int?
        var ligaduraQueEmpieza = false
        var ligaduraQueAcaba = false
    }

    func parser(_ parser: XMLParser, didStartElement nombre: String, namespaceURI: String?,
                qualifiedName: String?, attributes atributos: [String: String] = [:]) {
        if raiz == nil { raiz = nombre }
        defer { pila.append(nombre) }
        texto = ""
        // `padre` es todavía el elemento que contiene a este.
        switch nombre {
        case "part":
            parte += 1
            divisiones = 1
            posicion = .cero
            inicioDelCompas = .cero
            finDelCompas = .cero
            inicioDeLaAnterior = .cero
            transposicion = nil
        case "measure":
            posicion = inicioDelCompas
            finDelCompas = inicioDelCompas
        case "note":
            nota = NotaLeida()
        case "chord" where padre == "note":
            nota.esDeAcorde = true
        case "grace" where padre == "note":
            nota.sinTiempo = true
        case "rest" where padre == "note", "cue" where padre == "note", "unpitched" where padre == "note":
            nota.muda = true
        case "tie" where padre == "note":
            if atributos["type"] == "start" { nota.ligaduraQueEmpieza = true }
            if atributos["type"] == "stop" { nota.ligaduraQueAcaba = true }
        case "key":
            armadura = (nil, false)
        case "time":
            tiempo = (nil, nil)
        case "transpose":
            transporte = (0, 0, 0)
        case "sound":
            if tempo == nil, let valor = atributos["tempo"].flatMap({ Double($0) }), valor > 0, valor < 10_000 {
                tempo = Tempo(comprobando: valor)
            }
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters cadena: String) {
        texto += cadena
    }

    func parser(_ parser: XMLParser, didEndElement nombre: String, namespaceURI: String?, qualifiedName: String?) {
        let valor = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        texto = ""
        pila.removeLast()
        // Los números, redondeados; los que no son finitos o son desmesurados no se tienen en cuenta.
        let numero = Double(valor).flatMap { $0.isFinite && abs($0) < 10_000_000 ? Int($0.rounded()) : nil }
        switch nombre {
        case "work-title", "movement-title":
            if titulo == nil || nombre == "work-title", !valor.isEmpty { titulo = valor }
        case "divisions":
            if let numero, numero > 0, numero <= 100_000 { divisiones = numero }
        case "step" where padre == "pitch":
            nota.paso = ["C", "D", "E", "F", "G", "A", "B"].firstIndex(of: valor).flatMap(NotaNatural.init(rawValue:))
        case "alter" where padre == "pitch":
            nota.alteracion = numero ?? 0
        case "octave" where padre == "pitch":
            nota.octava = numero
        case "duration":
            switch padre {
            case "note": nota.pulsos = numero
            case "backup": avanzar(-(numero ?? 0))
            case "forward": avanzar(numero ?? 0)
            default: break
            }
        case "note":
            colocarLaNota()
        case "measure":
            inicioDelCompas = max(finDelCompas, posicion)
        case "fifths" where padre == "key":
            armadura.quintas = numero
        case "mode" where padre == "key":
            armadura.menor = valor == "minor"
        case "key":
            if tonalidad == nil, let quintas = armadura.quintas, abs(quintas) <= 7 {
                tonalidad = Tonalidad(armadura: quintas, modo: armadura.menor ? .menor : .mayor)
            }
        case "beats" where padre == "time":
            // "3+2" suma sus partes.
            let partes = valor.split(separator: "+").map { Int($0.trimmingCharacters(in: .whitespaces)) }
            tiempo.pulsos = partes.contains(nil) ? nil : partes.compactMap { $0 }.reduce(0, +)
        case "beat-type" where padre == "time":
            tiempo.unidad = numero
        case "time":
            if compas == nil, let pulsos = tiempo.pulsos, let unidad = tiempo.unidad {
                compas = Compas(comprobando: pulsos, unidad)
            }
        case "diatonic" where padre == "transpose":
            transporte.pasos = numero ?? 0
        case "chromatic" where padre == "transpose":
            transporte.semitonos = numero ?? 0
        case "octave-change" where padre == "transpose":
            transporte.octavas = numero ?? 0
        case "transpose":
            transposicion = (transporte.pasos + 7 * transporte.octavas, transporte.semitonos + 12 * transporte.octavas)
        default:
            break
        }
    }

    /// El elemento que contiene al actual.
    private var padre: String? { pila.last }

    private func avanzar(_ pulsos: Int) {
        posicion = max(.cero, posicion + Duracion(pulsos, 4 * divisiones))
        finDelCompas = max(finDelCompas, posicion)
    }

    private func colocarLaNota() {
        guard !nota.sinTiempo, let pulsos = nota.pulsos, pulsos > 0 else { return }
        let duracion = Duracion(pulsos, 4 * divisiones)
        let inicio = nota.esDeAcorde ? inicioDeLaAnterior : posicion
        if !nota.esDeAcorde {
            inicioDeLaAnterior = posicion
            avanzar(pulsos)
        }
        guard !nota.muda, let paso = nota.paso, let octava = nota.octava else { return }
        var altura = Altura(Nota(paso, Alteracion(nota.alteracion)), octava: octava)
        if let transposicion {
            altura = Altura(pasos: altura.pasos + transposicion.pasos, midi: altura.midi + transposicion.semitonos)
        }
        let clave = parte * 1024 + altura.midi + 512
        if nota.ligaduraQueAcaba, let i = ligadas[clave], notas[i].fin == inicio {
            let anterior = notas[i]
            notas[i] = NotaDeLaPieza(altura: anterior.altura, inicio: anterior.inicio,
                                     duracion: anterior.duracion + duracion, parte: parte)
            if !nota.ligaduraQueEmpieza { ligadas[clave] = nil }
        } else {
            notas.append(NotaDeLaPieza(altura: altura, inicio: inicio, duracion: duracion, parte: parte))
            if nota.ligaduraQueEmpieza { ligadas[clave] = notas.count - 1 }
        }
    }
}
