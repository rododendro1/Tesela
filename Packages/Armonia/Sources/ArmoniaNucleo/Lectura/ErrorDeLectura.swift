import Foundation

/// Error al leer un texto: una nota, un intervalo, un cifrado, una escala, una voz con su ritmo, unos
/// acordes a varias voces…
///
/// Indica el texto, el carácter donde se detuvo la lectura y el motivo, en los quince idiomas de los
/// textos (`Traduccion`):
///
///     do {
///         let acorde = try Acorde(leyendo: "Do7(b3)")
///     } catch let error as ErrorDeLectura {
///         print(error)   // No se puede leer «Do7(b3)» (carácter 5): «b3» no es una tensión válida…
///         error.descripcion(en: .inglesASCII)   // Cannot read "Do7(b3)" (character 5): "b3" is not a valid tension…
///     }

public struct ErrorDeLectura: Error, Hashable, Sendable, CustomStringConvertible {
    public enum Motivo: Hashable, Sendable {
        case textoVacio
        case notaNoReconocida
        case caracteresSobrantes(String)
        case octavaNoValida(String)
        case numeroDeIntervaloNoValido(String)
        case calidadNoValida(String)
        case intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo)
        case simboloNoReconocido(String)
        case tensionNoValida(String)
        case numeroDeAcordeNoValido(Int)
        case numeroRepetido(Int)
        case calidadesIncompatibles(CalidadesIncompatibles)
        case gradoNoOmitible(Int)
        case acordeNoInterpretable(RechazoDeAcorde)
        case bajoNoValido(String)
        /// Un nombre de nota escrito en otro idioma que el resto ("Sol7/B" en lugar de "Sol7/Si").
        case idiomasMezclados(String)
        case tipoDeEscalaNoReconocido(String)
        case modoNoReconocido(String)
        case alteracionNoReconocida(String)
        case duracionNoValida(String)
        case compasNoValido(String)
        /// Los acordes de una conducción de voces no tienen todos el mismo número de voces (o tienen menos de dos).
        case vocesDistintas
        /// El contrapunto no dura lo mismo que el cantus firmus: una redonda por cada nota.
        case contrapuntoDeOtraDuracion(redondas: Int)
    }

    /// Símbolos de un cifrado que no pueden ir juntos.
    public enum CalidadesIncompatibles: Hashable, Sendable {
        /// ° y ø a la vez ("Dodimø").
        case disminuidoYSemidisminuido
        /// El acorde de quinta con m, °, ø o + ("Dom5").
        case quintaConCalidad
    }

    /// Por qué un conjunto de notas no es un acorde por terceras.
    public enum RechazoDeAcorde: Hashable, Sendable {
        case faltaLaFundamental
        /// Un intervalo que no es tercera, quinta, séptima ni tensión (la 1ª aumentada, por ejemplo).
        case intervaloSinPapel(Intervalo)
        case terceraMayorYMenor
        case variasSeptimas
        case septimaDisminuidaFueraDelDisminuido
        case noEsPorTerceras
    }

    /// Texto completo que se intentaba leer.
    public let texto: String
    /// Carácter (contando desde 0) donde se detuvo la lectura; `nil` cuando el problema
    /// no está en un punto concreto sino en el conjunto (por ejemplo, ° y ø a la vez).
    public let posicion: Int?
    public let motivo: Motivo

    public init(texto: String, posicion: Int?, motivo: Motivo) {
        self.texto = texto
        self.posicion = posicion
        self.motivo = motivo
    }
}

extension ErrorDeLectura: LocalizedError {
    public var errorDescription: String? { description }
}

// MARK: - Idiomas
//
// Los mensajes de `ErrorDeLectura` en los quince idiomas de los textos (`Traduccion`). Aquí están los
// generales (texto vacío, caracteres que sobran); los demás, según lo que se leía, más abajo en
// TextosDeNotas, TextosDeAcordes, TextosDeEscalas y TextosDePartitura, una función por motivo, para que un motivo nuevo no
// compile hasta que tiene su texto.

extension ErrorDeLectura {
    /// Explicación del motivo, en español.
    public var explicacion: String { explicacion(en: .espanolCompacto) }

    /// Explicación del motivo en el idioma de los textos de la notación (`notacion.textos`).
    public func explicacion(en notacion: Notacion) -> String {
        explicacionTraducida(notacion).en(notacion)
    }

    /// Mensaje completo, en español: «No se puede leer «Do7(b3)» (carácter 5): …».
    public var description: String { descripcion(en: .espanolCompacto) }

    /// Mensaje completo en el idioma de los textos de la notación.
    public func descripcion(en notacion: Notacion) -> String {
        var inicio =
            texto.isEmpty
            ? TextosDeNucleo.en(notacion, \.valorNoValido)
            : TextosDeNucleo.en(notacion) { $0.noSePuedeLeer(texto) }
        if let p = posicion {
            inicio += TextosDeNucleo.en(notacion) { $0.caracter(p) }
        }
        // En francés, los dos puntos llevan espacio delante.
        return inicio + TextosDeNucleo.en(notacion, \.dosPuntos) + explicacion(en: notacion)
    }

    /// La explicación en los quince idiomas de los textos. La notación solo hace falta para los
    /// nombres de calidades e intervalos en inglés, que siguen su vocabulario.
    private func explicacionTraducida(_ notacion: Notacion) -> Traduccion {
        switch motivo {
        case .textoVacio:
            return TextosDeNucleo.traduccion(\.textoVacio)
        case .notaNoReconocida: return TextosDeNotas.notaNoReconocida()
        case .caracteresSobrantes(let resto):
            return TextosDeNucleo.traduccion { $0.caracteresSobrantes(resto) }
        case .octavaNoValida(let resto): return TextosDeNotas.octavaNoValida(resto)
        case .numeroDeIntervaloNoValido(let resto): return TextosDeNotas.numeroDeIntervaloNoValido(resto)
        case .calidadNoValida(let resto): return TextosDeNotas.calidadNoValida(resto)
        case .intervaloInexistente(let numero, let calidad):
            return TextosDeNotas.intervaloInexistente(numero: numero, calidad: calidad, en: notacion)
        case .simboloNoReconocido(let simbolo): return TextosDeAcordes.simboloNoReconocido(simbolo)
        case .tensionNoValida(let tension): return TextosDeAcordes.tensionNoValida(tension)
        case .numeroDeAcordeNoValido(let numero): return TextosDeAcordes.numeroDeAcordeNoValido(numero)
        case .numeroRepetido(let numero): return TextosDeAcordes.numeroRepetido(numero)
        case .calidadesIncompatibles(let valor): return TextosDeAcordes.calidadesIncompatibles(valor)
        case .gradoNoOmitible(let grado): return TextosDeAcordes.gradoNoOmitible(grado)
        case .acordeNoInterpretable(let rechazo): return TextosDeAcordes.acordeNoInterpretable(rechazo, en: notacion)
        case .bajoNoValido(let bajo): return TextosDeAcordes.bajoNoValido(bajo)
        case .idiomasMezclados(let nombre): return TextosDeAcordes.idiomasMezclados(nombre)
        case .duracionNoValida(let texto): return TextosDePartitura.duracionNoValida(texto)
        case .compasNoValido(let texto): return TextosDePartitura.compasNoValido(texto)
        case .vocesDistintas: return TextosDePartitura.vocesDistintas()
        case .contrapuntoDeOtraDuracion(let redondas):
            return TextosDePartitura.contrapuntoDeOtraDuracion(redondas: redondas)
        case .alteracionNoReconocida(let signo): return TextosDeNotas.alteracionNoReconocida(signo)
        case .modoNoReconocido(let nombre): return TextosDeEscalas.modoNoReconocido(nombre)
        case .tipoDeEscalaNoReconocido(let nombre): return TextosDeEscalas.tipoDeEscalaNoReconocido(nombre)
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer las notas, las alteraciones, las octavas y los intervalos, en los quince idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDeNotas {
        static func notaNoReconocida() -> Traduccion {
            return TextosDeNucleo.traduccion(\.notaNoReconocida)
        }

        static func octavaNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaLaOctava)
                : TextosDeNucleo.traduccion { $0.octavaNoValida(resto) }
        }

        static func numeroDeIntervaloNoValido(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaElNumeroDeIntervalo)
                : TextosDeNucleo.traduccion { $0.numeroDeIntervaloNoValido(resto) }
        }

        static func calidadNoValida(_ resto: String) -> Traduccion {
            return resto.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaLaCalidad)
                : TextosDeNucleo.traduccion { $0.calidadNoValida(resto) }
        }

        static func intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo, en notacion: Notacion) -> Traduccion
        {
            if numero == 1, case .disminuida = calidad {
                return TextosDeNucleo.traduccion(\.unisonoDisminuido)
            }
            let clase = (numero - 1) % 7
            let regla =
                [0, 3, 4].contains(clase)
                ? TextosDeNucleo.traduccion(\.reglaDeLasJustas)
                : TextosDeNucleo.traduccion(\.reglaDeLasMayores)
            return TextosDeNucleo.traduccion { $0.intervaloInexistente(numero, calidad, notacion, regla) }
        }

        static func alteracionNoReconocida(_ signo: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.alteracionNoReconocida(signo) }
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer los cifrados de los acordes, en los quince idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDeAcordes {
        static func simboloNoReconocido(_ simbolo: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.simboloNoReconocido(simbolo) }
        }

        static func tensionNoValida(_ tension: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.tensionNoValida(tension) }
        }

        static func numeroDeAcordeNoValido(_ numero: Int) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.numeroDeAcordeNoValido(numero) }
        }

        static func numeroRepetido(_ numero: Int) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.numeroRepetido(numero) }
        }

        static func calidadesIncompatibles(_ valor: CalidadesIncompatibles) -> Traduccion {
            switch valor {
            case .disminuidoYSemidisminuido:
                return TextosDeNucleo.traduccion(\.disminuidoYSemidisminuido)
            case .quintaConCalidad:
                return TextosDeNucleo.traduccion(\.quintaConCalidad)
            }
        }

        static func gradoNoOmitible(_ grado: Int) -> Traduccion {
            return grado == 1
                ? TextosDeNucleo.traduccion(\.fundamentalNoOmitible)
                : TextosDeNucleo.traduccion { $0.gradoNoOmitible(grado) }
        }

        static func acordeNoInterpretable(_ rechazo: RechazoDeAcorde, en notacion: Notacion) -> Traduccion {
            switch rechazo {
            case .faltaLaFundamental:
                return TextosDeNucleo.traduccion(\.faltaLaFundamental)
            case .intervaloSinPapel(let intervalo):
                return TextosDeNucleo.traduccion { $0.intervaloSinPapel(intervalo, notacion) }
            case .terceraMayorYMenor:
                return TextosDeNucleo.traduccion(\.terceraMayorYMenor)
            case .variasSeptimas:
                return TextosDeNucleo.traduccion(\.variasSeptimas)
            case .septimaDisminuidaFueraDelDisminuido:
                return TextosDeNucleo.traduccion(\.septimaDisminuidaFueraDelDisminuido)
            case .noEsPorTerceras:
                return TextosDeNucleo.traduccion(\.noEsPorTerceras)
            }
        }

        static func bajoNoValido(_ bajo: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.bajoNoValido(bajo) }
        }

        static func idiomasMezclados(_ nombre: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.idiomasMezclados(nombre) }
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer las escalas y los modos, en los quince idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDeEscalas {
        static func modoNoReconocido(_ nombre: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.modoNoReconocido(nombre) }
        }

        static func tipoDeEscalaNoReconocido(_ nombre: String) -> Traduccion {
            return nombre.isEmpty
                ? TextosDeNucleo.traduccion(\.faltaElTipoDeEscala)
                : TextosDeNucleo.traduccion { $0.tipoDeEscalaNoReconocido(nombre) }
        }
    }
}

// Los mensajes de `ErrorDeLectura` al leer las duraciones, los compases, las voces y el contrapunto, en los quince idiomas de los textos.

extension ErrorDeLectura {
    enum TextosDePartitura {
        static func duracionNoValida(_ texto: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.duracionNoValida(texto) }
        }

        static func compasNoValido(_ texto: String) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.compasNoValido(texto) }
        }

        static func vocesDistintas() -> Traduccion {
            return TextosDeNucleo.traduccion(\.vocesDistintas)
        }

        static func contrapuntoDeOtraDuracion(redondas: Int) -> Traduccion {
            return TextosDeNucleo.traduccion { $0.contrapuntoDeOtraDuracion(redondas) }
        }
    }
}
