import Armonia

/// Los textos de la interfaz de las apps (pestañas, secciones, etiquetas, indicaciones), en los catorce idiomas de
/// los textos del motor.
///
/// Siguen el idioma de los textos de la notación elegida, igual que los nombres de acordes, escalas y avisos,
/// así que el selector de notación cambia la app entera. Los textos están en `TextosDeApps`, un fichero por
/// idioma en `Textos/` (`TextosDeApps+Espanol.swift`…): uno nuevo no compila hasta que está en los catorce. Los
/// ejemplos de las indicaciones («Cifrado, por ejemplo Sol7/Si») se escriben en la notación elegida («G7/B»).
///
///     Notacion.inglesASCII.texto(.digitaciones)    // "Fingerings"
public enum TextoDeLasApps: Hashable, Sendable {
    // Pestañas y títulos
    case acordes
    case escalas
    case analisis
    case coral

    // Acordes
    case acorde
    case campoDeCifrado
    case informacion
    case nombre
    case cifrado
    case notas
    case digitaciones
    case instrumentoYAfinacion
    case sinDigitaciones
    case calculando
    /// «3 dedos», o «4 dedos, cejilla en el traste 1».
    case dedos(Int, cejilla: Int?)
    case arpegio
    case patron
    case octavas
    case conLaOctavaFinal
    /// La figura de cada nota de un arpegio (corchea, semicorchea…).
    case figura
    /// «Capo en el traste 2», o «Sin capo» con 0.
    case capo(Int)
    case escalasCompatibles
    case arpegioEnElMastil
    /// «Trastes 5–8»: la franja de una posición del mástil.
    case trastes(desde: Int, hasta: Int)

    // Identificar un acorde tocando sus notas
    case identificar
    case tocaElMastil
    case tocaNotas
    case borrar
    case sinAcordeConocido
    case verEnAcordes
    case tecladoMIDI
    case dispositivosMIDI
    case teoriaPostonal
    case formaPrima
    case numeroDeForte
    case vectorIntervalico

    // Escalas
    case escala
    case tonica
    case tipo
    case habituales
    case otrasTradiciones
    case acordesDeLaEscala
    case mastilDeGuitarra
    case posicionesEnElMastil
    /// «3 notas por cuerda».
    case notasPorCuerda(Int)
    /// «Forma E», de las del sistema CAGED.
    case forma(String)
    case pentagrama

    // Análisis
    case progresion
    case campoDeProgresion
    case resultado
    case acordeAAcorde
    case cadencias
    /// La progresión arpegiada.
    case arpegiar
    case rearmonizar
    case aplicar

    // Coral
    case tarea
    case campoDeTonalidad
    case tonalidad
    case armonizaciones
    case aCuatroVoces
    case conduccionDeLasVoces
    case avisos

    // Tonnetz
    case recorridoPLR
    case modo
    case red
    /// El campo del teclado UIL, el giro de 30° en 30° y el espejo.
    case formatoUIL
    case giro
    case espejo
    case noSeDibuja
    case campoDeTriadaInicial
    case reiniciar
    case deshacer
    case campoDeAcorde
    case campoDeEscala

    // Comunes
    case textos
    case comoLasNotas
    case exportar
    /// Abrir un fichero MIDI o MusicXML (en la pestaña de análisis).
    case abrir
    case escuchar
    /// Cortar lo que está sonando.
    case detener
    /// Llevar lo escrito a otra tonalidad, o subirlo o bajarlo un intervalo.
    case transponer
    /// El temperamento con que suena «Escuchar».
    case afinacionAlEscuchar

    // Accesibilidad (lo que lee VoiceOver)
    case rejillaHexagonal
    /// «19 casillas».
    case casillas(Int)
    /// «elegida q 2, r -1».
    case casillaElegida(q: Int, r: Int)
    /// «Mástil de guitarra, trastes 0 a 5», con el nombre del instrumento de `Encordado.nombre(en:)`.
    case mastilDe(String, desde: Int, hasta: Int)
    /// «cuerda 1, traste 0», con las cuerdas contadas desde 1.
    case posicion(cuerda: Int, traste: Int)
    /// «13 marcas».
    case marcas(Int)
    /// «cuerdas apagadas: 1, 6».
    case cuerdasApagadas(String)
    case sinMarcas

    public func texto(en notacion: Notacion) -> String {
        traduccion(notacion).en(notacion)
    }

    func traduccion(_ notacion: Notacion) -> Traduccion {
        switch self {
        case .acordes:
            return TextosDeApps.traducidos.map(\.acordes)
        case .escalas:
            return TextosDeApps.traducidos.map(\.escalas)
        case .analisis:
            return TextosDeApps.traducidos.map(\.analisis)
        case .coral:
            return TextosDeApps.traducidos.map(\.coral)
        case .acorde:
            return TextosDeApps.traducidos.map(\.acorde)
        case .campoDeCifrado:
            let ejemplo = Self.cifrado("Sol7/Si", notacion)
            return TextosDeApps.traducidos.map { $0.campoDeCifrado(ejemplo) }
        case .informacion:
            return TextosDeApps.traducidos.map(\.informacion)
        case .nombre:
            return TextosDeApps.traducidos.map(\.nombre)
        case .cifrado:
            return TextosDeApps.traducidos.map(\.cifrado)
        case .notas:
            return TextosDeApps.traducidos.map(\.notas)
        case .digitaciones:
            return TextosDeApps.traducidos.map(\.digitaciones)
        case .arpegio:
            return TextosDeApps.traducidos.map(\.arpegio)
        case .patron:
            return TextosDeApps.traducidos.map(\.patron)
        case .arpegioEnElMastil:
            return TextosDeApps.traducidos.map(\.arpegioEnElMastil)
        case .trastes(let desde, let hasta):
            return TextosDeApps.traducidos.map { $0.trastes(desde, hasta) }
        case .escalasCompatibles:
            return TextosDeApps.traducidos.map(\.escalasCompatibles)
        case .identificar:
            return TextosDeApps.traducidos.map(\.identificar)
        case .tocaElMastil:
            return TextosDeApps.traducidos.map(\.tocaElMastil)
        case .tocaNotas:
            return TextosDeApps.traducidos.map(\.tocaNotas)
        case .borrar:
            return TextosDeApps.traducidos.map(\.borrar)
        case .sinAcordeConocido:
            return TextosDeApps.traducidos.map(\.sinAcordeConocido)
        case .verEnAcordes:
            return TextosDeApps.traducidos.map(\.verEnAcordes)
        case .tecladoMIDI:
            return TextosDeApps.traducidos.map(\.tecladoMIDI)
        case .dispositivosMIDI:
            return TextosDeApps.traducidos.map(\.dispositivosMIDI)
        case .teoriaPostonal:
            return TextosDeApps.traducidos.map(\.teoriaPostonal)
        case .formaPrima:
            return TextosDeApps.traducidos.map(\.formaPrima)
        case .numeroDeForte:
            return TextosDeApps.traducidos.map(\.numeroDeForte)
        case .vectorIntervalico:
            return TextosDeApps.traducidos.map(\.vectorIntervalico)
        case .instrumentoYAfinacion:
            return TextosDeApps.traducidos.map(\.instrumentoYAfinacion)
        case .sinDigitaciones:
            return TextosDeApps.traducidos.map(\.sinDigitaciones)
        case .calculando:
            return TextosDeApps.traducidos.map(\.calculando)
        case .dedos(let n, let cejilla):
            guard let t = cejilla else { return TextosDeApps.traducidos.map { $0.dedos(n) } }
            return TextosDeApps.traducidos.map { "\($0.dedos(n)), \($0.cejilla(t))" }
        case .escala:
            return TextosDeApps.traducidos.map(\.escala)
        case .tonica:
            return TextosDeApps.traducidos.map(\.tonica)
        case .tipo:
            return TextosDeApps.traducidos.map(\.tipo)
        case .habituales:
            return TextosDeApps.traducidos.map(\.habituales)
        case .otrasTradiciones:
            return TextosDeApps.traducidos.map(\.otrasTradiciones)
        case .acordesDeLaEscala:
            return TextosDeApps.traducidos.map(\.acordesDeLaEscala)
        case .posicionesEnElMastil:
            return TextosDeApps.traducidos.map(\.posicionesEnElMastil)
        case .notasPorCuerda(let n):
            return TextosDeApps.traducidos.map { $0.notasPorCuerda(n) }
        case .forma(let forma):
            return TextosDeApps.traducidos.map { $0.forma(forma) }
        case .mastilDeGuitarra:
            return TextosDeApps.traducidos.map(\.mastilDeGuitarra)
        case .pentagrama:
            return TextosDeApps.traducidos.map(\.pentagrama)
        case .progresion:
            return TextosDeApps.traducidos.map(\.progresion)
        case .campoDeProgresion:
            return TextosDeApps.traducidos.map(\.campoDeProgresion)
        case .resultado:
            return TextosDeApps.traducidos.map(\.resultado)
        case .acordeAAcorde:
            return TextosDeApps.traducidos.map(\.acordeAAcorde)
        case .arpegiar:
            return TextosDeApps.traducidos.map(\.arpegiar)
        case .cadencias:
            return TextosDeApps.traducidos.map(\.cadencias)
        case .tarea:
            return TextosDeApps.traducidos.map(\.tarea)
        case .campoDeTonalidad:
            return TextosDeApps.traducidos.map(\.campoDeTonalidad)
        case .tonalidad:
            return TextosDeApps.traducidos.map(\.tonalidad)
        case .armonizaciones:
            return TextosDeApps.traducidos.map(\.armonizaciones)
        case .aCuatroVoces:
            return TextosDeApps.traducidos.map(\.aCuatroVoces)
        case .conduccionDeLasVoces:
            return TextosDeApps.traducidos.map(\.conduccionDeLasVoces)
        case .avisos:
            return TextosDeApps.traducidos.map(\.avisos)
        case .recorridoPLR:
            return TextosDeApps.traducidos.map(\.recorridoPLR)
        case .modo:
            return TextosDeApps.traducidos.map(\.modo)
        case .red:
            return TextosDeApps.traducidos.map(\.red)
        case .formatoUIL:
            return TextosDeApps.traducidos.map(\.formatoUIL)
        case .giro:
            return TextosDeApps.traducidos.map(\.giro)
        case .espejo:
            return TextosDeApps.traducidos.map(\.espejo)
        case .noSeDibuja:
            return TextosDeApps.traducidos.map(\.noSeDibuja)
        case .campoDeTriadaInicial:
            let ejemplo = Self.cifrado("Do", notacion) + ", " + Self.cifrado("Lam", notacion) + "…"
            return TextosDeApps.traducidos.map { $0.campoDeTriadaInicial(ejemplo) }
        case .reiniciar:
            return TextosDeApps.traducidos.map(\.reiniciar)
        case .deshacer:
            return TextosDeApps.traducidos.map(\.deshacer)
        case .campoDeAcorde:
            let ejemplo = Self.cifrado("Dom7", notacion) + ", " + Self.cifrado("Fa#m7b5", notacion) + "…"
            return TextoDeLasApps.cifrado.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .campoDeEscala:
            let ejemplos = [Escala(.re, .dorico), Escala(.la, .menorArmonica)].map { $0.nombre(en: notacion) }
            let ejemplo = ejemplos.joined(separator: ", ") + "…"
            return TextoDeLasApps.escala.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .textos:
            return TextosDeApps.traducidos.map(\.textos)
        case .comoLasNotas:
            return TextosDeApps.traducidos.map(\.comoLasNotas)
        case .octavas:
            return TextosDeApps.traducidos.map(\.octavas)
        case .conLaOctavaFinal:
            return TextosDeApps.traducidos.map(\.conLaOctavaFinal)
        case .figura:
            return TextosDeApps.traducidos.map(\.figura)
        case .capo(let n) where n <= 0:
            return TextosDeApps.traducidos.map(\.sinCapo)
        case .capo(let n):
            return TextosDeApps.traducidos.map { $0.capo(n) }
        case .rearmonizar:
            return TextosDeApps.traducidos.map(\.rearmonizar)
        case .aplicar:
            return TextosDeApps.traducidos.map(\.aplicar)
        case .detener:
            return TextosDeApps.traducidos.map(\.detener)
        case .transponer:
            return TextosDeApps.traducidos.map(\.transponer)
        case .escuchar:
            return TextosDeApps.traducidos.map(\.escuchar)
        case .afinacionAlEscuchar:
            return TextosDeApps.traducidos.map(\.afinacionAlEscuchar)
        case .exportar:
            return TextosDeApps.traducidos.map(\.exportar)
        case .abrir:
            return TextosDeApps.traducidos.map(\.abrir)
        case .rejillaHexagonal:
            return TextosDeApps.traducidos.map(\.rejillaHexagonal)
        case .casillas(let n):
            return TextosDeApps.traducidos.map { $0.casillas(n) }
        case .casillaElegida(let q, let r):
            return TextosDeApps.traducidos.map { "\($0.elegida) q \(q), r \(r)" }
        case .mastilDe(let instrumento, let desde, let hasta):
            return TextosDeApps.traducidos.map { $0.mastilDe(instrumento, desde, hasta) }
        case .posicion(let cuerda, let traste):
            return TextosDeApps.traducidos.map { $0.posicion(cuerda, traste) }
        case .marcas(let n):
            return TextosDeApps.traducidos.map { $0.marcas(n) }
        case .cuerdasApagadas(let lista):
            return TextosDeApps.traducidos.map { $0.cuerdasApagadas(lista) }
        case .sinMarcas:
            return TextosDeApps.traducidos.map(\.sinMarcas)
        }
    }

    /// Un cifrado de ejemplo en la notación: «Sol7/Si» → «G7/B».
    static func cifrado(_ texto: String, _ notacion: Notacion) -> String {
        (try? Acorde(leyendo: texto))?.cifrado(en: notacion) ?? texto
    }

    /// Alturas de ejemplo en la notación: «Mi4 Fa4 Re4 Do4» → «E4 F4 D4 C4».
    static func alturas(_ texto: String, _ notacion: Notacion) -> String {
        texto.split(separator: " ", omittingEmptySubsequences: false).map { palabra in
            let coma = palabra.hasSuffix(",")
            let limpia = coma ? String(palabra.dropLast()) : String(palabra)
            return ((try? Altura(leyendo: limpia))?.nombre(en: notacion) ?? limpia) + (coma ? "," : "")
        }.joined(separator: " ")
    }
}

extension Traduccion {
    /// La misma frase en los catorce idiomas, cambiada igual en todos.
    func aplicando(_ cambio: (String) -> String) -> Traduccion {
        map(cambio)
    }
}

extension Notacion {
    /// Un texto de la interfaz de las apps en el idioma de los textos de esta notación.
    public func texto(_ texto: TextoDeLasApps) -> String {
        texto.texto(en: self)
    }
}

extension String {
    /// «guitarra» → «Guitarra».
    var capitalizandoLaPrimera: String { prefix(1).uppercased() + dropFirst() }
}
