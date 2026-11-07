import Armonia
import Exposicion
import Foundation

// MARK: - Armonización y realización a cuatro voces

extension LineaDeComandos {
    /// `armonizar Mi4 Re4 Do4`: las mejores armonizaciones y, si las notas llevan octava, el coral a
    /// cuatro voces con la melodía en el soprano.
    static func armonizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let coral = try coralArmonizado(argumentos, notacion)
        guard !coral.avisos.contains(.sinArmonizacion) else {
            return bien(CoralPresentado.Aviso.sinArmonizacion.texto(en: notacion))
        }
        var lineas = [coral.titulo]
        for (n, propuesta) in coral.propuestas.enumerated() {
            lineas.append("  \(n + 1). " + propuesta)
        }
        // Sin octavas no hay coral, y no se dice nada más.
        if !coral.avisos.contains(.faltanOctavas) {
            lineas.append(Mensaje.aCuatroVoces.texto(en: notacion))
            if coral.filas.isEmpty {
                lineas.append("  " + CoralPresentado.Aviso.sinRealizacion.texto(en: notacion))
            } else {
                lineas += describir(coral.filas)
            }
        }
        return bien(lineas.joined(separator: "\n"))
    }

    /// La armonización de `armonizar`, para el texto y para `--json`.
    static func coralArmonizado(_ argumentos: [String], _ notacion: Notacion) throws -> CoralPresentado {
        var argumentos = Argumentos(argumentos)
        guard let propuestas = argumentos.quitarNumero(.propuestas, en: 1...20, porDefecto: 3) else {
            throw ErrorDeUso.propuestasFueraDeRango
        }
        guard let dada = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let archivo = try argumentos.valor(.archivo)
        try argumentos.sinOpcionesDesconocidas()
        // Con `--archivo`, la melodía del fichero (su voz más aguda), con su ritmo, en su tonalidad si la dice.
        if let archivo {
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConNotas }
            let pieza = try PiezaImportada(leyendo: try datos(deArchivo: archivo))
            return try PresentacionDeCoral.armonizar(
                try pieza.melodia().texto, en: dada ?? pieza.tonalidad, propuestas: propuestas,
                notacion: notacion)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanNotasDeLaArmonizacion }
        return try PresentacionDeCoral.armonizar(
            argumentos.unidos, en: dada, propuestas: propuestas, notacion: notacion)
    }

    /// `realizar Do Fa Sol7 Do`: los acordes escritos a cuatro voces, sin faltas.
    static func realizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let coral = try coralRealizado(argumentos, notacion)
        guard !coral.avisos.contains(.sinRealizacion) else {
            return bien(CoralPresentado.Aviso.sinRealizacion.texto(en: notacion))
        }
        return bien(([coral.titulo] + describir(coral.filas)).joined(separator: "\n"))
    }

    /// La realización de `realizar`, para el texto y para `--json`.
    static func coralRealizado(_ argumentos: [String], _ notacion: Notacion) throws -> CoralPresentado {
        var argumentos = Argumentos(argumentos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        let archivo = try argumentos.valor(.archivo)
        let ventana = try argumentos.valor(.ventana).map { try Duracion(leyendo: $0) }
        let conBajoCifrado = argumentos.quitarMarca(.bajoCifrado)
        try argumentos.sinOpcionesDesconocidas()
        guard archivo != nil || ventana == nil else { throw ErrorDeUso.ventanaSinArchivo }
        // Con `--bajo-cifrado`, las notas del bajo con sus cifras («Do La:6 Sol:7 Do»), en la tonalidad dada o en la
        // que mejor explica el bajo.
        if conBajoCifrado {
            guard archivo == nil else { throw ErrorDeUso.archivoConAcordes }
            guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDeLaRealizacion }
            let texto = argumentos.unidos
            let bajos = try argumentos.restantes.map {
                try Nota(leyendoEnLaOrden: String($0.split(separator: ":", maxSplits: 1).first ?? ""))
            }
            guard let enTono = tonalidad ?? Tonalidad.candidatos(notas: bajos).first?.valor else {
                throw ErrorDeUso.faltaTonalidad
            }
            let acordes = try enTono.acordes(bajoCifrado: texto)
            return PresentacionDeCoral.realizar(enTono.analizar(acordes), notacion: notacion)
        }
        // Con `--archivo`, los acordes del fichero (por sus cambios de armonía, o en ventanas de `--ventana`).
        if let archivo {
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConAcordes }
            let pieza = try PiezaImportada(leyendo: try datos(deArchivo: archivo))
            guard let analisis = pieza.analisis(en: tonalidad, ventana: ventana) else {
                throw ErrorDeUso.archivoSinAcordes
            }
            return PresentacionDeCoral.realizar(analisis, notacion: notacion)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDeLaRealizacion }
        return try PresentacionDeCoral.realizar(argumentos.unidos, en: tonalidad, notacion: notacion)
    }

    /// `revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4`: las faltas de conducción, una por línea. Con alguna, el código
    /// de salida es 3.
    static func revisar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let coral = try coralRevisado(argumentos, notacion)
        let texto = coral.avisos.map { $0.texto(en: notacion) }.joined(separator: "\n")
        return ResultadoDeOrden(salida: texto + "\n", error: "", codigo: faltas(de: coral).isEmpty ? 0 : 3)
    }

    /// El coral de `revisar`, con sus faltas en los avisos: el escrito o, con `--archivo`, el de un fichero.
    static func coralRevisado(_ argumentos: [String], _ notacion: Notacion) throws -> CoralPresentado {
        var argumentos = Argumentos(argumentos)
        let archivo = try argumentos.valor(.archivo)
        try argumentos.sinOpcionesDesconocidas()
        if let archivo {
            guard argumentos.restantes.isEmpty else { throw ErrorDeUso.archivoConAcordes }
            let pieza = try PiezaImportada(leyendo: try datos(deArchivo: archivo))
            return PresentacionDeCoral.revisar(try pieza.coral(), en: notacion)
        }
        guard !argumentos.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDeLasVoces }
        return try PresentacionDeCoral.revisar(argumentos.restantes.joined(separator: " "), en: notacion)
    }

    /// Las faltas de conducción entre los avisos de un coral.
    static func faltas(de coral: CoralPresentado) -> [FaltaDeConduccion] {
        coral.avisos.compactMap {
            if case .falta(let falta) = $0 { return falta }
            return nil
        }
    }

    /// `contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5 --especie 1`: la especie, si el contrapunto va encima
    /// o debajo del cantus firmus, y las faltas, una por línea. Con alguna, el código de salida es 3.
    ///
    /// Con `--proponer` (y solo el cantus), los contrapuntos de primera especie sin faltas que mejor suenan: cada uno,
    /// sus notas y su informe.
    static func contrapunto(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        if let varias = try contrapuntoAVariasVoces(argumentos) {
            return ResultadoDeOrden(
                salida: varias.informe(en: notacion) + "\n", error: "", codigo: varias.esCorrecto ? 0 : 3)
        }
        let ejercicios = try ejerciciosDeContrapunto(argumentos)
        let propuestos = ejercicios.propuestos
        let textos = ejercicios.lista.enumerated().map { n, ejercicio in
            let informe = ejercicio.informe(en: notacion)
            guard propuestos else { return informe }
            let notas = ejercicio.contrapunto.eventos.flatMap(\.alturas).map { $0.nombre(en: notacion) }.joined(
                separator: " ")
            let numero = ejercicios.lista.count > 1 ? "\(n + 1). " : ""
            return numero + notas + "\n" + informe
        }
        let conFaltas = ejercicios.lista.contains { !$0.faltas.isEmpty }
        return ResultadoDeOrden(salida: textos.joined(separator: "\n\n") + "\n", error: "", codigo: conFaltas ? 3 : 0)
    }

    /// `contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Sol4 La4 / Re3 Re3 Do3 Re3 [--especie 1,2]`: más de una voz sobre el
    /// cantus, cada una con su especie (una para todas, o una por voz, separadas por comas). `nil` si solo hay una.
    static func contrapuntoAVariasVoces(_ textos: [String]) throws -> ContrapuntoAVariasVoces? {
        var argumentos = Argumentos(textos)
        guard !argumentos.restantes.contains(where: OpcionDeOrden.proponer.leidos.contains) else { return nil }
        let especies = try argumentos.valor(.especie, siFalta: .especieFueraDeRango)
        try argumentos.sinOpcionesDesconocidas()
        let partes = argumentos.unidos.split(separator: "/", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard partes.count > 2 else { return nil }
        guard !partes.contains(where: \.isEmpty) else { throw ErrorDeUso.faltanVocesDelContrapunto }
        let leidas = (especies ?? "1").split(separator: ",").map {
            Int($0.trimmingCharacters(in: .whitespaces)).flatMap(Contrapunto.Especie.init(rawValue:))
        }
        let voces = partes.count - 1
        guard leidas.count == 1 || leidas.count == voces, case let todas = leidas.compactMap({ $0 }),
            todas.count == leidas.count
        else {
            throw ErrorDeUso.especieFueraDeRango
        }
        return try ContrapuntoAVariasVoces(
            cantusFirmus: partes[0],
            voces: partes.dropFirst().enumerated().map { i, voz in (voz, todas.count == 1 ? todas[0] : todas[i]) })
    }

    /// El ejercicio de `contrapunto`, o los propuestos con `--proponer`, para el texto y para `--json`.
    static func ejerciciosDeContrapunto(_ argumentos: [String]) throws -> (lista: [Contrapunto], propuestos: Bool) {
        var argumentos = Argumentos(argumentos)
        guard argumentos.quitarMarca(.proponer) else { return ([try ejercicioDeContrapunto(argumentos)], false) }
        let debajo = argumentos.quitarMarca(.debajo)
        guard let propuestas = argumentos.quitarNumero(.propuestas, en: 1...20, porDefecto: 1) else {
            throw ErrorDeUso.propuestasFueraDeRango
        }
        try argumentos.sinOpcionesDesconocidas()
        let texto = argumentos.unidos
        guard !texto.isEmpty, !texto.contains("/") else { throw ErrorDeUso.faltanVocesDelContrapunto }
        let propuestos = try Contrapunto.proponer(sobre: texto, arriba: !debajo, propuestas: propuestas)
        guard !propuestos.isEmpty else { throw ErrorDeUso.sinContrapuntoPosible }
        return (propuestos, true)
    }

    /// El ejercicio escrito de `contrapunto`: el cantus y el contrapunto, separados por «/».
    private static func ejercicioDeContrapunto(_ argumentos: Argumentos) throws -> Contrapunto {
        var argumentos = argumentos
        guard let numero = argumentos.quitarNumero(.especie, en: 1...5, porDefecto: 1),
            let especie = Contrapunto.Especie(rawValue: numero)
        else {
            throw ErrorDeUso.especieFueraDeRango
        }
        try argumentos.sinOpcionesDesconocidas()
        let partes = argumentos.unidos.split(separator: "/", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard partes.count == 2, !partes[0].isEmpty, !partes[1].isEmpty else {
            throw ErrorDeUso.faltanVocesDelContrapunto
        }
        return try Contrapunto(cantusFirmus: partes[0], contrapunto: partes[1], especie: especie)
    }

    /// `transponer 2M Do Lam Fa Sol7` o `transponer Re Do Lam Fa Sol7`: lo escrito subido o bajado un intervalo, o
    /// llevado a otra tónica por el camino más corto. Lo que no se lee como acordes se transporta como notas (un
    /// coral, una melodía).
    ///
    /// Con `--archivo`, el fichero transportado, como partitura: en el formato de `--formato` o, si no se da, en el
    /// del fichero (MusicXML si no es MIDI, MEI ni ABC).
    static func transponer(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var leidos = Argumentos(argumentos)
        guard let archivo = try leidos.valor(.archivo) else { return bien(try transporte(argumentos, notacion).texto) }
        let formatoEscrito = try leidos.valor(.formato)
        try leidos.sinOpcionesDesconocidas()
        guard leidos.restantes.count == 1 else { throw ErrorDeUso.faltaTransporte }
        let formato: FormatoDePartitura
        if let formatoEscrito {
            guard let leido = FormatoDePartitura(rawValue: formatoEscrito.lowercased()) else {
                throw ErrorDeUso.formatoDePartituraDesconocido(formatoEscrito)
            }
            formato = leido
        } else {
            formato = FormatoDePartitura(ruta: archivo) ?? .musicXML
        }
        let pieza = try PiezaImportada(leyendo: try datos(deArchivo: archivo))
        let primero = leidos.restantes[0]
        let intervalo: Intervalo
        if let leido = try? Intervalo(leyendo: primero) {
            intervalo = leido
        } else {
            let destino = try Nota(leyendoEnLaOrden: primero)
            intervalo = (pieza.tonalidadEstimada?.tonica ?? destino).intervaloMasCorto(hasta: destino)
        }
        let datos = pieza.transponer(intervalo).partitura().exportar(como: formato)
        guard formato.esTexto else { return binario(datos) }
        return bien(String(decoding: datos, as: UTF8.self).trimmingCharacters(in: "\n"))
    }

    /// Lo que hace `transponer`: el intervalo, si se ha leído como acordes o como notas, y lo transportado.
    static func transporte(
        _ argumentos: [String], _ notacion: Notacion
    ) throws -> (intervalo: Intervalo, contenido: PresentacionDeTransposicion.Contenido, texto: String) {
        let argumentos = Argumentos(argumentos)
        if argumentos.restantes.contains(where: OpcionDeOrden.archivo.leidos.contains) {
            throw ErrorDeUso.sinSalidaJSON("transponer --archivo")
        }
        try argumentos.sinOpcionesDesconocidas()
        guard argumentos.restantes.count >= 2 else { throw ErrorDeUso.faltaTransporte }
        let texto = argumentos.restantes.dropFirst().joined(separator: " ")
        let comoAcordes = try? PresentacionDeTransposicion.transponer(texto, .unisono, en: notacion)
        let contenido: PresentacionDeTransposicion.Contenido = comoAcordes == nil ? .notas : .acordes
        let primero = argumentos.restantes[0]
        let intervalo: Intervalo
        if let leido = try? Intervalo(leyendo: primero) {
            intervalo = leido
        } else {
            let destino = try Nota(leyendoEnLaOrden: primero)
            let origen = PresentacionDeTransposicion.tonalidad(de: texto, contenido: contenido)?.tonica ?? destino
            intervalo = origen.intervaloMasCorto(hasta: destino)
        }
        let transportado = try PresentacionDeTransposicion.transponer(
            texto, intervalo, contenido: contenido, en: notacion)
        return (intervalo, contenido, transportado)
    }

    /// `rearmonizar Do Lam Rem7 Sol7 Do [--en Do mayor]`: la tonalidad y, una por línea, las otras armonías de cada
    /// acorde, con su número en la progresión.
    static func rearmonizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var acordes = Argumentos(argumentos)
        guard let tonalidad = try acordes.quitarTonalidad() else { throw ErrorDeUso.faltaTonalidadTrasEn }
        try acordes.sinOpcionesDesconocidas()
        guard !acordes.restantes.isEmpty else { throw ErrorDeUso.faltanAcordesDeLaRearmonizacion }
        let leidos = try acordes.restantes.map { try Acorde(leyendoEnLaOrden: $0) }
        guard let resultado = PresentacionDeRearmonizacion.proponer(leidos, en: tonalidad, notacion: notacion) else {
            throw ErrorDeUso.faltanAcordesDeLaRearmonizacion
        }
        let lineas = resultado.propuestas.map { "  \($0.rearmonizacion.posicion + 1). \($0.descripcion)" }
        return bien(([resultado.tonalidad.nombre(en: notacion)] + lineas).joined(separator: "\n"))
    }

    /// Una línea por acorde: el cifrado, el grado y las alturas de grave a agudo
    /// («Do        I         Do3 Mi4 Sol4 Do5»), que se pueden copiar en `revisar` o `musicxml coral`.
    static func describir(_ filas: [CoralPresentado.Fila]) -> [String] {
        let anchoDelCifrado = max(10, (filas.map(\.cifrado.count).max() ?? 0) + 2)
        let anchoDelGrado = max(10, (filas.map(\.grado.count).max() ?? 0) + 2)
        return filas.map {
            "  " + $0.cifrado.padding(hasta: anchoDelCifrado) + $0.grado.padding(hasta: anchoDelGrado) + $0.voces
        }
    }
}
