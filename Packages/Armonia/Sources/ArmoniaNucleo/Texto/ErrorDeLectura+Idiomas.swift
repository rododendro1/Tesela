// Los mensajes de `ErrorDeLectura` en los catorce idiomas de los textos (`Traduccion`). Aquí están los
// generales (texto vacío, caracteres que sobran); los demás, según lo que se leía, en
// ErrorDeLectura+Notas, +Acordes, +Escalas y +Partitura, una función por motivo, para que un motivo nuevo no
// compile hasta que tiene su texto.

extension ErrorDeLectura {
    /// Explicación del motivo, en español.
    public var explicacion: String { explicacion(en: .espanolUnicode) }

    /// Explicación del motivo en el idioma de los textos de la notación (`notacion.textos`).
    public func explicacion(en notacion: Notacion) -> String {
        explicacionTraducida(notacion).en(notacion)
    }

    /// Mensaje completo, en español: «No se puede leer «Do7(b3)» (carácter 5): …».
    public var description: String { descripcion(en: .espanolUnicode) }

    /// Mensaje completo en el idioma de los textos de la notación.
    public func descripcion(en notacion: Notacion) -> String {
        var inicio = texto.isEmpty
            ? TextosDeNucleo.traducidos.map(\.valorNoValido).en(notacion)
            : TextosDeNucleo.traducidos.map { $0.noSePuedeLeer(texto) }.en(notacion)
        if let p = posicion {
            inicio += TextosDeNucleo.traducidos.map { $0.caracter(p) }.en(notacion)
        }
        // En francés, los dos puntos llevan espacio delante.
        return inicio + (notacion.textos == .frances ? " : " : ": ") + explicacion(en: notacion)
    }

    /// La explicación en los catorce idiomas de los textos. La notación solo hace falta para los
    /// nombres de calidades e intervalos en inglés, que siguen su vocabulario.
    private func explicacionTraducida(_ notacion: Notacion) -> Traduccion {
        switch motivo {
        case .textoVacio:
            return TextosDeNucleo.traducidos.map(\.textoVacio)
        case .notaNoReconocida: return TextosDeNotas.notaNoReconocida()
        case .caracteresSobrantes(let resto):
            return TextosDeNucleo.traducidos.map { $0.caracteresSobrantes(resto) }
        case .octavaNoValida(let resto): return TextosDeNotas.octavaNoValida(resto)
        case .numeroDeIntervaloNoValido(let resto): return TextosDeNotas.numeroDeIntervaloNoValido(resto)
        case .calidadNoValida(let resto): return TextosDeNotas.calidadNoValida(resto)
        case .intervaloInexistente(let numero, let calidad): return TextosDeNotas.intervaloInexistente(numero: numero, calidad: calidad, en: notacion)
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
        case .contrapuntoDeOtraDuracion(let redondas): return TextosDePartitura.contrapuntoDeOtraDuracion(redondas: redondas)
        case .alteracionNoReconocida(let signo): return TextosDeNotas.alteracionNoReconocida(signo)
        case .modoNoReconocido(let nombre): return TextosDeEscalas.modoNoReconocido(nombre)
        case .tipoDeEscalaNoReconocido(let nombre): return TextosDeEscalas.tipoDeEscalaNoReconocido(nombre)
        }
    }
}
