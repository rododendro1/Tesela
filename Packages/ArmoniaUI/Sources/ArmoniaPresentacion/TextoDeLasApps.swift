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
    /// «cuerda 6, traste 0», con el número tradicional de la cuerda (la 1.ª es la de abajo).
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
            return TextosDeApps.traduccion(\.acordes)
        case .escalas:
            return TextosDeApps.traduccion(\.escalas)
        case .analisis:
            return TextosDeApps.traduccion(\.analisis)
        case .coral:
            return TextosDeApps.traduccion(\.coral)
        case .acorde:
            return TextosDeApps.traduccion(\.acorde)
        case .campoDeCifrado:
            let ejemplo = Self.cifrado("Sol7/Si", notacion)
            return TextosDeApps.traduccion { $0.campoDeCifrado(ejemplo) }
        case .informacion:
            return TextosDeApps.traduccion(\.informacion)
        case .nombre:
            return TextosDeApps.traduccion(\.nombre)
        case .cifrado:
            return TextosDeApps.traduccion(\.cifrado)
        case .notas:
            return TextosDeApps.traduccion(\.notas)
        case .digitaciones:
            return TextosDeApps.traduccion(\.digitaciones)
        case .arpegio:
            return TextosDeApps.traduccion(\.arpegio)
        case .patron:
            return TextosDeApps.traduccion(\.patron)
        case .arpegioEnElMastil:
            return TextosDeApps.traduccion(\.arpegioEnElMastil)
        case .trastes(let desde, let hasta):
            return TextosDeApps.traduccion { $0.trastes(desde, hasta) }
        case .escalasCompatibles:
            return TextosDeApps.traduccion(\.escalasCompatibles)
        case .identificar:
            return TextosDeApps.traduccion(\.identificar)
        case .tocaElMastil:
            return TextosDeApps.traduccion(\.tocaElMastil)
        case .tocaNotas:
            return TextosDeApps.traduccion(\.tocaNotas)
        case .borrar:
            return TextosDeApps.traduccion(\.borrar)
        case .sinAcordeConocido:
            return TextosDeApps.traduccion(\.sinAcordeConocido)
        case .verEnAcordes:
            return TextosDeApps.traduccion(\.verEnAcordes)
        case .tecladoMIDI:
            return TextosDeApps.traduccion(\.tecladoMIDI)
        case .dispositivosMIDI:
            return TextosDeApps.traduccion(\.dispositivosMIDI)
        case .teoriaPostonal:
            return TextosDeApps.traduccion(\.teoriaPostonal)
        case .formaPrima:
            return TextosDeApps.traduccion(\.formaPrima)
        case .numeroDeForte:
            return TextosDeApps.traduccion(\.numeroDeForte)
        case .vectorIntervalico:
            return TextosDeApps.traduccion(\.vectorIntervalico)
        case .instrumentoYAfinacion:
            return TextosDeApps.traduccion(\.instrumentoYAfinacion)
        case .sinDigitaciones:
            return TextosDeApps.traduccion(\.sinDigitaciones)
        case .calculando:
            return TextosDeApps.traduccion(\.calculando)
        case .dedos(let n, let cejilla):
            guard let t = cejilla else { return TextosDeApps.traduccion { $0.dedos(n) } }
            return TextosDeApps.traduccion { "\($0.dedos(n)), \($0.cejilla(t))" }
        case .escala:
            return TextosDeApps.traduccion(\.escala)
        case .tonica:
            return TextosDeApps.traduccion(\.tonica)
        case .tipo:
            return TextosDeApps.traduccion(\.tipo)
        case .habituales:
            return TextosDeApps.traduccion(\.habituales)
        case .otrasTradiciones:
            return TextosDeApps.traduccion(\.otrasTradiciones)
        case .acordesDeLaEscala:
            return TextosDeApps.traduccion(\.acordesDeLaEscala)
        case .posicionesEnElMastil:
            return TextosDeApps.traduccion(\.posicionesEnElMastil)
        case .notasPorCuerda(let n):
            return TextosDeApps.traduccion { $0.notasPorCuerda(n) }
        case .forma(let forma):
            return TextosDeApps.traduccion { $0.forma(forma) }
        case .mastilDeGuitarra:
            return TextosDeApps.traduccion(\.mastilDeGuitarra)
        case .pentagrama:
            return TextosDeApps.traduccion(\.pentagrama)
        case .progresion:
            return TextosDeApps.traduccion(\.progresion)
        case .campoDeProgresion:
            return TextosDeApps.traduccion(\.campoDeProgresion)
        case .resultado:
            return TextosDeApps.traduccion(\.resultado)
        case .acordeAAcorde:
            return TextosDeApps.traduccion(\.acordeAAcorde)
        case .arpegiar:
            return TextosDeApps.traduccion(\.arpegiar)
        case .cadencias:
            return TextosDeApps.traduccion(\.cadencias)
        case .tarea:
            return TextosDeApps.traduccion(\.tarea)
        case .campoDeTonalidad:
            return TextosDeApps.traduccion(\.campoDeTonalidad)
        case .tonalidad:
            return TextosDeApps.traduccion(\.tonalidad)
        case .armonizaciones:
            return TextosDeApps.traduccion(\.armonizaciones)
        case .aCuatroVoces:
            return TextosDeApps.traduccion(\.aCuatroVoces)
        case .conduccionDeLasVoces:
            return TextosDeApps.traduccion(\.conduccionDeLasVoces)
        case .avisos:
            return TextosDeApps.traduccion(\.avisos)
        case .recorridoPLR:
            return TextosDeApps.traduccion(\.recorridoPLR)
        case .modo:
            return TextosDeApps.traduccion(\.modo)
        case .red:
            return TextosDeApps.traduccion(\.red)
        case .formatoUIL:
            return TextosDeApps.traduccion(\.formatoUIL)
        case .giro:
            return TextosDeApps.traduccion(\.giro)
        case .espejo:
            return TextosDeApps.traduccion(\.espejo)
        case .noSeDibuja:
            return TextosDeApps.traduccion(\.noSeDibuja)
        case .campoDeTriadaInicial:
            let ejemplo = Self.cifrado("Do", notacion) + ", " + Self.cifrado("Lam", notacion) + "…"
            return TextosDeApps.traduccion { $0.campoDeTriadaInicial(ejemplo) }
        case .reiniciar:
            return TextosDeApps.traduccion(\.reiniciar)
        case .deshacer:
            return TextosDeApps.traduccion(\.deshacer)
        case .campoDeAcorde:
            let ejemplo = Self.cifrado("Dom7", notacion) + ", " + Self.cifrado("Fa#m7b5", notacion) + "…"
            return TextoDeLasApps.cifrado.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .campoDeEscala:
            let ejemplos = [Escala(.re, .dorico), Escala(.la, .menorArmonica)].map { $0.nombre(en: notacion) }
            let ejemplo = ejemplos.joined(separator: ", ") + "…"
            return TextoDeLasApps.escala.traduccion(notacion).aplicando { "\($0) (\(ejemplo))" }
        case .textos:
            return TextosDeApps.traduccion(\.textos)
        case .comoLasNotas:
            return TextosDeApps.traduccion(\.comoLasNotas)
        case .octavas:
            return TextosDeApps.traduccion(\.octavas)
        case .conLaOctavaFinal:
            return TextosDeApps.traduccion(\.conLaOctavaFinal)
        case .figura:
            return TextosDeApps.traduccion(\.figura)
        case .capo(let n) where n <= 0:
            return TextosDeApps.traduccion(\.sinCapo)
        case .capo(let n):
            return TextosDeApps.traduccion { $0.capo(n) }
        case .rearmonizar:
            return TextosDeApps.traduccion(\.rearmonizar)
        case .aplicar:
            return TextosDeApps.traduccion(\.aplicar)
        case .detener:
            return TextosDeApps.traduccion(\.detener)
        case .transponer:
            return TextosDeApps.traduccion(\.transponer)
        case .escuchar:
            return TextosDeApps.traduccion(\.escuchar)
        case .afinacionAlEscuchar:
            return TextosDeApps.traduccion(\.afinacionAlEscuchar)
        case .exportar:
            return TextosDeApps.traduccion(\.exportar)
        case .abrir:
            return TextosDeApps.traduccion(\.abrir)
        case .rejillaHexagonal:
            return TextosDeApps.traduccion(\.rejillaHexagonal)
        case .casillas(let n):
            return TextosDeApps.traduccion { $0.casillas(n) }
        case .casillaElegida(let q, let r):
            return TextosDeApps.traduccion { "\($0.elegida) q \(q), r \(r)" }
        case .mastilDe(let instrumento, let desde, let hasta):
            return TextosDeApps.traduccion { $0.mastilDe(instrumento, desde, hasta) }
        case .posicion(let cuerda, let traste):
            return TextosDeApps.traduccion { $0.posicion(cuerda, traste) }
        case .marcas(let n):
            return TextosDeApps.traduccion { $0.marcas(n) }
        case .cuerdasApagadas(let lista):
            return TextosDeApps.traduccion { $0.cuerdasApagadas(lista) }
        case .sinMarcas:
            return TextosDeApps.traduccion(\.sinMarcas)
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
