import Armonia

/// Los textos de la interfaz de las apps (pestañas, secciones, etiquetas, indicaciones), en los catorce idiomas de
/// los textos del motor.
///
/// Siguen el idioma de los textos de la notación elegida, igual que los nombres de acordes, escalas y avisos,
/// así que el selector de notación cambia la app entera. Cada texto es un campo de `TextosDeApps`, con un fichero
/// por idioma en `Textos/` (`TextosDeApps+Espanol.swift`…): uno nuevo no compila hasta que está en los catorce.
///
///     Notacion.inglesASCII.texto(\.digitaciones)                // "Fingerings"
///     Notacion.espanolCompacto.texto { $0.notasPorCuerda(3) }    // "3 notas por cuerda"
extension Notacion {
    /// Un texto de la interfaz de las apps en el idioma de los textos de esta notación.
    public func texto(_ campo: (TextosDeApps) -> String) -> String {
        TextosDeApps.en(self, campo)
    }

    /// El texto de un campo de las apps, con sus ejemplos escritos en esta notación: «Cifrado, por ejemplo
    /// Sol7/Si» en español, «Chord symbol, for example G7/B» en inglés.
    public func campo(_ campo: CampoDeLasApps) -> String {
        switch campo {
        case .cifrado:
            let ejemplo = cifradoDeEjemplo("Sol7/Si")
            return texto { $0.campoDeCifrado(ejemplo) }
        case .triadaInicial:
            let ejemplo = cifradoDeEjemplo("Do") + ", " + cifradoDeEjemplo("Lam") + "…"
            return texto { $0.campoDeTriadaInicial(ejemplo) }
        case .acorde:
            let ejemplo = cifradoDeEjemplo("Dom7") + ", " + cifradoDeEjemplo("Fa#m7b5") + "…"
            return texto(\.cifrado) + " (\(ejemplo))"
        case .escala:
            let ejemplo = [Escala(.re, .dorico), Escala(.la, .menorArmonica)].map { $0.nombre(en: self) }
            return texto(\.escala) + " (\(ejemplo.joined(separator: ", "))…)"
        }
    }

    /// Un cifrado de ejemplo en esta notación: «Sol7/Si» → «G7/B». Si no se lee, se deja como va.
    func cifradoDeEjemplo(_ texto: String) -> String {
        (try? Acorde(leyendo: texto))?.cifrado(en: self) ?? texto
    }

    /// Alturas de ejemplo en esta notación: «Mi4 Fa4 Re4 Do4» → «E4 F4 D4 C4». Lo que no se lee se deja como va.
    func alturasDeEjemplo(_ texto: String) -> String {
        texto.split(separator: " ", omittingEmptySubsequences: false).map { palabra in
            let coma = palabra.hasSuffix(",")
            let limpia = coma ? String(palabra.dropLast()) : String(palabra)
            return ((try? Altura(leyendo: limpia))?.nombre(en: self) ?? limpia) + (coma ? "," : "")
        }.joined(separator: " ")
    }
}

/// Los campos de texto de las apps que llevan ejemplos, que se escriben en la notación elegida.
public enum CampoDeLasApps: Hashable, Sendable, CaseIterable {
    /// «Cifrado, por ejemplo Sol7/Si».
    case cifrado
    /// «Tríada inicial (Do, Lam…)», en Tonnetz.
    case triadaInicial
    /// «Cifrado (Dom7, Fa♯m7♭5…)», en Tonnetz.
    case acorde
    /// «Escala (Re dórico, La menor armónica…)», en Tonnetz.
    case escala
}

// MARK: - Textos compuestos

extension TextosDeApps {
    /// «3 dedos», o «4 dedos, cejilla en el traste 1».
    public func dedosYCejilla(_ dedos: Int, _ cejilla: Int?) -> String {
        guard let traste = cejilla else { return self.dedos(dedos) }
        return "\(self.dedos(dedos)), \(self.cejilla(traste))"
    }

    /// «Capo en el traste 2», o «Sin capo» con 0.
    public func capoEnElTraste(_ traste: Int) -> String {
        traste <= 0 ? sinCapo : capo(traste)
    }

    /// «elegida q 2, r -1»: la casilla elegida de la rejilla, para VoiceOver.
    public func casillaElegida(q: Int, r: Int) -> String {
        "\(elegida) q \(q), r \(r)"
    }
}

extension String {
    /// «guitarra» → «Guitarra».
    var capitalizandoLaPrimera: String { prefix(1).uppercased() + dropFirst() }
}
