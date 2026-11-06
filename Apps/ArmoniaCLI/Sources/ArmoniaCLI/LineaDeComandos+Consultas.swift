import Armonia
import Foundation
import TeselaPresentacion

// MARK: - Consultas: intervalos, tonalidades, análisis y teoría postonal

extension LineaDeComandos {
    /// `intervalo <nota> <nota>`: el intervalo entre dos notas.
    static func consultarIntervalo(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard resto.count == 2 else { throw ErrorDeUso.dosNotas }
        return bien(try intervalo(resto[0], resto[1], notacion))
    }

    /// `tonalidad <tonalidad>`: su armadura, sus acordes y sus relativas.
    static func consultarTonalidad(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(resto)
        let modulaciones = argumentos.quitarOpcionConPalabras(.modulaciones)
        if let opcion = argumentos.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltaTonalidad }
        let tonalidad = try Tonalidad(leyendoEnLaOrden: argumentos.unidos)
        var lineas = [describir(tonalidad: tonalidad, notacion)]
        // `--modulaciones [Sol mayor]`: a los tonos vecinos o, si se da, a esa tonalidad de todas las maneras.
        var destino: Tonalidad?
        switch modulaciones {
        case .ausente: return bien(lineas[0])
        case .sinValor: destino = nil
        case .valor(let texto): destino = try Tonalidad(leyendoEnLaOrden: texto)
        }
        lineas.append(notacion.texto(\.modulaciones) + ":")
        lineas += PresentacionDeModulaciones.modulaciones(desde: tonalidad, hasta: destino, en: notacion).map {
            "  " + $0.destino + " · " + $0.tecnica + ": " + $0.plan.descripcion(en: notacion)
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// `conjunto <clases>`: el conjunto de clases de altura, con su forma prima y su vector.
    static func consultarConjunto(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !resto.isEmpty else { throw ErrorDeUso.faltaConjunto }
        return bien(describir(conjunto: try ConjuntoDeClasesDeAltura(leyendo: resto.joined(separator: " ")), notacion))
    }

    /// `serie <doce notas>`: la serie dodecafónica y su matriz.
    static func consultarSerie(_ resto: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let opcion = Argumentos(resto).opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        guard !resto.isEmpty else { throw ErrorDeUso.faltaSerie }
        return bien(describir(serie: try SerieDodecafonica(leyendo: resto.joined(separator: " ")), notacion))
    }

    static func intervalo(_ a: String, _ b: String, _ notacion: Notacion) throws -> String {
        let intervalo = try intervalo(a, b)
        let semitonos = Mensaje.semitonos(intervalo.semitonos).texto(en: notacion)
        return "\(intervalo.nombre(en: notacion)) (\(intervalo.texto(en: notacion)), \(semitonos))"
    }

    /// El intervalo de una nota a otra: entre las alturas si las dos llevan octava (Do4 Mi5 es una décima), y si no,
    /// el ascendente entre las notas.
    static func intervalo(_ a: String, _ b: String) throws -> Intervalo {
        if let grave = try? Altura(leyendoEnLaOrden: a), let aguda = try? Altura(leyendoEnLaOrden: b) { return aguda - grave }
        return try Nota(leyendoEnLaOrden: a).intervalo(hasta: try Nota(leyendoEnLaOrden: b))
    }

    static func describir(tonalidad: Tonalidad, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let armadura: String
        switch tonalidad.armadura {
        case 0: armadura = t(.sinAlteraciones)
        default:
            let signos = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }.joined(separator: " ")
            armadura = "\(signos) (\(t(.alteraciones(abs(tonalidad.armadura), sostenidos: tonalidad.armadura > 0))))"
        }
        let acordes = zip(tonalidad.cifradosRomanos(cuatriadas: true), tonalidad.armonizar(cuatriadas: true))
            .map { "\($0) \($1.cifrado(en: notacion))" }.joined(separator: " · ")
        return [
            tonalidad.nombre(en: notacion),
            "  \(t(.armadura)): " + armadura,
            "  \(t(.relativa)): " + tonalidad.relativa.nombre(en: notacion)
                + " · \(t(.homonima)): " + tonalidad.homonima.nombre(en: notacion),
            "  \(t(.acordes)): " + acordes,
        ].joined(separator: "\n")
    }

    static func analizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var acordes = Argumentos(argumentos)
        // Con --escalas, debajo de cada acorde, su escala con sus tensiones y sus notas a evitar. Se quita antes que
        // la tonalidad, que se lleva todo lo que va detrás de --en.
        let conEscalas = acordes.quitarMarca(.escalas)
        let conNotasGuia = acordes.quitarMarca(.notasGuia)
        let conConduccion = acordes.quitarMarca(.conduccion)
        let conBajo = acordes.quitarMarca(.bajo)
        let contra = try acordes.valorConPalabras(.comparar)
        guard let tonalidad = try acordes.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let archivo = try acordes.valor(.archivo)
        let ventana = try acordes.valor(.ventana).map { try Duracion(leyendo: $0) }
        if let opcion = acordes.opcionDesconocida { throw ErrorDeUso.opcionDesconocida(opcion) }
        let analisis: AnalisisPresentado
        if let archivo {
            guard acordes.restantes.isEmpty else { throw ErrorDeUso.archivoConAcordes }
            guard let datos = contenido(deArchivo: archivo) else { return archivoIlegible(archivo, notacion) }
            let pieza = try PiezaImportada(leyendo: datos)
            guard
                let leido = PresentacionDeAnalisis.analizar(
                    pieza.acordes(ventana: ventana), en: tonalidad,
                    notacion: notacion)
            else {
                throw ErrorDeUso.archivoSinAcordes
            }
            analisis = leido
        } else {
            guard !acordes.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDelAnalisis }
            // Con la tonalidad dada, sin modulaciones; si no, en tramos.
            analisis = try PresentacionDeAnalisis.analizar(acordes.unidos, en: tonalidad, notacion: notacion)
        }
        var lineas = [analisis.titulo]
        let todas = analisis.tramos.flatMap(\.filas)
        // Con --escalas, también las notas que cambian de una escala a la siguiente y las notas guía.
        let cambios = analisis.cambiosDeEscala(en: notacion)
        var indice = 0
        // Columnas de al menos 10 caracteres, más anchas si un cifrado no cabe.
        let anchoDelCifrado = max(10, (todas.map(\.cifrado.count).max() ?? 0) + 2)
        let anchoDelGrado = max(10, (todas.map(\.grado.count).max() ?? 0) + 2)
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera { lineas.append(cabecera) }
            for fila in tramo.filas {
                let funcion = fila.funcion.isEmpty ? "–" : fila.funcion
                lineas.append(
                    "  " + fila.cifrado.padding(hasta: anchoDelCifrado) + fila.grado.padding(hasta: anchoDelGrado)
                        + funcion)
                if conEscalas, let escala = fila.escala {
                    let resumen = escala.resumen.isEmpty ? "" : " — " + escala.resumen
                    lineas.append("    " + escala.nombre + resumen)
                    if !escala.estructurasSuperiores.isEmpty {
                        let etiqueta = notacion.texto(\.estructurasSuperiores)
                        lineas.append("      " + etiqueta + ": " + escala.estructurasSuperiores)
                    }
                    if cambios.indices.contains(indice) { lineas.append("      " + cambios[indice]) }
                }
                indice += 1
            }
        }
        lineas += analisis.cadencias
        if conNotasGuia {
            lineas.append(notacion.texto(\.lineasDeNotasGuia) + ":")
            lineas += PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
                analisis.acordes, tonalidad: analisis.tonalidad, en: notacion
            ).map { "  " + $0.titulo + ": " + $0.notas }
        }
        // Con --conduccion, cada paso con sus notas comunes y lo que se mueve cada voz, en drop 2.
        if conConduccion, let conduccion = PresentacionDeAnalisis.conduccion(analisis.acordes, en: notacion) {
            lineas.append(notacion.texto(\.conduccionDeVoces) + " (" + conduccion.disposicion + "):")
            for paso in conduccion.pasos {
                lineas.append("  " + paso.titulo + " · " + paso.comunes)
                lineas.append("    " + paso.voces.joined(separator: " · "))
            }
            lineas.append("  " + conduccion.movimientoTotal)
        }
        // Con --bajo, un bajo caminante: un compás de negras por acorde.
        if conBajo, let bajo = PresentacionDeAnalisis.bajoCaminante(analisis.acordes, en: notacion) {
            lineas.append(notacion.texto(\.bajoCaminante) + ":")
            for (acorde, compas) in zip(analisis.acordes, bajo.compases) {
                lineas.append("  " + acorde.cifrado(en: notacion) + ": " + compas)
            }
        }
        // Con --comparar (o --contra, como antes), la otra versión acorde a acorde: lo que cambia, sus grados y sus notas comunes.
        if let contra {
            let otra = try contra.split(separator: " ").map { try Acorde(leyendoEnLaOrden: String($0)) }
            if let comparacion = PresentacionDeAnalisis.comparar(
                analisis.acordes, con: otra, en: tonalidad, notacion: notacion)
            {
                let cifrados = otra.map { $0.cifrado(en: notacion) }.joined(separator: " ")
                lineas.append(notacion.texto(\.compararCon) + " " + cifrados + " (" + comparacion.tonalidad + "):")
                for fila in comparacion.filas {
                    let acordesDeLaFila = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
                    let comunes = fila.comunes.isEmpty ? "" : " · " + fila.comunes
                    lineas.append("  \(fila.posicion). " + acordesDeLaFila + " · " + fila.grados + comunes)
                }
                lineas.append("  " + comparacion.resumen)
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    // MARK: Teoría postonal

    /// `conjunto 0 4 7`: el conjunto con sus notas, sus formas, sus vectores y sus ejes de simetría.
    static func describir(conjunto: ConjuntoDeClasesDeAltura, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        let datos = DatosDeConjunto(conjunto, notacion: notacion)
        func lista(_ numeros: [Int]) -> String { "[" + numeros.map(String.init).joined(separator: ", ") + "]" }
        let ejes = conjunto.ejesDeSimetria.map(\.description).joined(separator: " · ")
        return [
            [lista(datos.clases), datos.forte].compactMap { $0 }.joined(separator: "  "),
            "  \(t(.notas)): " + datos.notas.joined(separator: " "),
            "  \(t(.formaNormal)): \(lista(datos.formaNormal))",
            "  \(t(.formaPrima)): \(lista(datos.formaPrima))",
            "  \(t(.vectorIntervalico)): \(lista(datos.vectorIntervalico))",
            "  \(t(.vectorDeIndice)): \(lista(datos.vectorDeIndice))",
            "  \(t(.ejesDeSimetria)): " + (ejes.isEmpty ? "—" : ejes),
        ].joined(separator: "\n")
    }

    /// `serie 0 e 7 4 2 9 3 8 t 1 5 6`: la serie con sus notas, sus intervalos, sus hexacordos, sus formas
    /// combinatorias y la matriz, con las P a la izquierda, las R a la derecha, las I arriba y las RI abajo.
    static func describir(serie: SerieDodecafonica, _ notacion: Notacion) -> String {
        let t = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
        // Los datos de `--json` (`DatosDeSerie`), en texto.
        let datos = DatosDeSerie(serie, notacion: notacion)
        var intervalos = "  \(t(.intervalos)): " + datos.intervalos.map(String.init).joined(separator: " ")
        if datos.deTodosLosIntervalos { intervalos += "  (\(t(.deTodosLosIntervalos)))" }
        var lineas = [
            datos.clases.map(SerieDodecafonica.cifra).joined(separator: " "),
            "  \(t(.notas)): " + datos.notas.joined(separator: " "),
            intervalos,
            "  \(t(.hexacordos)): " + datos.hexacordos.joined(separator: " · "),
            "  \(t(.formasCombinatorias)): " + datos.formasCombinatorias.joined(separator: " "),
            "  " + t(.formasDistintas(datos.formasDistintas)),
            "",
        ]
        func celda(_ texto: String) -> String { texto + String(repeating: " ", count: max(1, 5 - texto.count)) }
        let cifra = SerieDodecafonica.cifra
        let matriz = datos.matriz
        let margen = "  " + celda("")
        func cabecera(_ tipo: TipoDeFormaDeSerie) -> String {
            margen + matriz[0].map { celda(FormaDeSerie(tipo, $0).description) }.joined()
        }
        lineas.append(cabecera(.inversion))
        for fila in matriz {
            let p = FormaDeSerie(.original, fila[0]).description
            let r = FormaDeSerie(.retrogrado, fila[0]).description
            lineas.append("  " + celda(p) + fila.map { celda(cifra($0)) }.joined() + r)
        }
        lineas.append(cabecera(.retrogradoDeLaInversion))
        return lineas.map { String($0.reversed().drop(while: { $0 == " " }).reversed()) }.joined(separator: "\n")
    }
}
