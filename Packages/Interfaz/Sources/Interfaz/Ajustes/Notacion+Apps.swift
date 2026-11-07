import Armonia
import Foundation

/// Lo que comparten las apps al elegir y guardar la notación. No usa SwiftUI, así que se prueba en Linux.
extension Notacion {
    /// Cómo se llama cada notación en el selector.
    public var titulo: String {
        esCombinada ? "\(escritura.titulo) · \(textos.titulo)" : escritura.titulo
    }

    /// El nombre con que se guarda en los ajustes. Es estable: no depende del orden de `allCases`.
    /// Una notación combinada se guarda como «ruso+espanol».
    public var clave: String {
        esCombinada ? escritura.clave + "+" + textos.clave : escritura.clave
    }

    /// La notación del idioma del sistema, para cuando aún no se ha elegido ninguna: con el sistema en
    /// catalán, `.conPalabras(.catalan)`; en un idioma sin notación propia, la española. `idiomas` son los códigos
    /// de `Locale.preferredLanguages` («ca-ES», «en-GB»…), y manda el primero que se conozca.
    public static func delSistema(idiomas: [String] = Locale.preferredLanguages) -> Notacion {
        for codigo in idiomas {
            if let idioma = Idioma(codigo: codigo) { return .delIdioma(idioma) }
        }
        return .espanolCompacto
    }

    /// La notación guardada con esa clave; si no existe, el español con ♯ y ♭.
    public static func desde(clave: String) -> Notacion {
        let partes = clave.split(separator: "+", maxSplits: 1).map(String.init)
        let clave = partes.first
        let notas = (allCases + deOtrasTradiciones).first { $0.clave == clave } ?? .espanolCompacto
        guard partes.count == 2, let textos = Idioma.allCases.first(where: { $0.clave == partes[1] }) else {
            return notas
        }
        return notas.conTextos(en: textos)
    }

    /// La notación guardada con esa clave, con la octava como subíndice (La₄) si `octavasEnSubindice` y con cifras
    /// (La4) si es `false`. Si es `nil` (no se ha tocado el ajuste), como la escriba la notación: en subíndice en las
    /// compactas y con cifras en las demás, como en el motor y en la línea de comandos.
    public static func desde(clave: String, octavasEnSubindice: Bool?) -> Notacion {
        let notacion = desde(clave: clave)
        guard let octavasEnSubindice else { return notacion }
        return notacion.conOctavas(octavasEnSubindice ? .subindices : .cifras)
    }

    /// Las notaciones con los nombres de un sistema fijo de otra tradición (bizantino, japonés, los lü…), para el
    /// selector: la transliterada, la original y la ASCII de cada sistema, sin las que escriben el Fa♯ del título igual
    /// que otra (el ut de Guido no tiene otra escritura que la latina; el japonés en ASCII solo cambia en las dobles).
    /// Llevan los textos en español; `conNotas(_:)` les pone los que se hayan elegido.
    public static let deOtrasTradiciones: [Notacion] = {
        var elegidas: [Notacion] = []
        var titulos: Set<String> = []
        for sistema in SistemaDeNombres.allCases {
            for grafia in [Grafia.transliterada, .original, .ascii] {
                guard let notacion = Notacion.sistema(sistema, grafia: grafia) else { continue }
                if titulos.insert(notacion.titulo).inserted { elegidas.append(notacion) }
            }
        }
        return elegidas
    }()

    /// El idioma elegido para los textos, o `nil` si van en el de las notas.
    public var idiomaElegidoParaLosTextos: Idioma? {
        esCombinada ? textos : nil
    }

    /// Otras notas, conservando el idioma elegido para los textos.
    public func conNotas(_ notas: Notacion) -> Notacion {
        // Las de otra tradición no tienen idioma: los textos siguen en el que se estaba leyendo.
        if notas.sistemaDeNombres != nil { return notas.conTextos(en: textos) }
        return idiomaElegidoParaLosTextos.map { notas.conTextos(en: $0) } ?? notas.notas
    }

    /// Los mismos nombres de nota con los textos en otro idioma, o en el de las notas si es `nil`.
    public func conTextosElegidos(_ idioma: Idioma?) -> Notacion {
        idioma.map { conTextos(en: $0) } ?? notas
    }

    /// Mensaje legible de un error del motor, en el idioma de esta notación.
    public func mensaje(de error: Error) -> String {
        (error as? any ErrorDeArmonia)?.descripcion(en: self) ?? error.localizedDescription
    }
}

extension EscrituraDeNotas {
    /// Cómo se llama cada escritura en el selector: el idioma en su lengua y un ejemplo escrito con ella,
    /// «Español (Fa sostenido)», «English (F#)», «Deutsch (Fis)», «Deutsch (F Kreuz)»,
    /// «Русский (фа-диез)».
    public var titulo: String {
        let ejemplo = EscrituraDeNotas.ejemplo.nombre(en: Notacion(escritura: self))
        return "\(sistema?.titulo ?? idioma.titulo) (\(ejemplo))"
    }

    /// El Fa♯ con el que se muestra cada escritura en el selector.
    private static let ejemplo = Nota(.fa, .sostenido)

    /// El nombre con que se guarda en los ajustes: el del idioma y, en los que tienen variantes, la suya
    /// («espanol», «espanolASCII», «espanolCompacto»; «frances», «francesCompacto»). El alemán con palabras se
    /// guarda como «alemanPalabras», porque «aleman» era el alemán compacto (Fis) hasta la 0.3.0.
    ///
    /// Las de otra tradición, con el sistema y la grafía: «bizantino», «bizantinoOriginal», «bizantinoASCII».
    public var clave: String {
        if let sistema {
            switch grafia {
            case .transliterada: return sistema.rawValue
            case .original: return sistema.rawValue + "Original"
            case .ascii: return sistema.rawValue + "ASCII"
            }
        }
        if conPalabras { return idioma == .aleman ? "alemanPalabras" : idioma.clave }
        return idioma.clave + (usaASCII && idioma.reglas.tieneVariantes ? "ASCII" : "Compacto")
    }
}

extension Idioma {
    /// Cómo se llama cada idioma en el selector de los textos: su `nombrePropio` («Euskara», «Deutsch»).
    public var titulo: String { nombrePropio }

    /// El nombre con que se guarda en los ajustes: el del caso («euskera», «aleman»).
    public var clave: String { rawValue }
}

extension SistemaDeNombres {
    /// Cómo se llama cada sistema en el selector, como los idiomas, en su lengua: «Βυζαντινή», «十二律».
    public var titulo: String {
        switch self {
        case .bizantino: return "Βυζαντινή"
        case .japones: return "日本音名"
        case .coreano: return "한국 음이름"
        case .guidoniano: return "Guido d'Arezzo"
        case .luChinos: return "十二律"
        case .luJaponeses: return "十二律 (雅楽)"
        case .luCoreanos: return "율명"
        case .solfeoArabe: return "الصولفيج"
        case .solfeoHebreo: return "סולפג'"
        case .sargam: return "सरगम"
        case .jianpu: return "简谱"
        case .gongche: return "工尺谱"
        case .wusheng: return "五声"
        case .carnatico: return "Karṇāṭaka"
        case .tonicSolFa: return "Tonic sol-fa"
        case .notasDeForma: return "Shape notes"
        }
    }
}
