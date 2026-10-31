import Armonia
import ArmoniaPresentacion
import Foundation

// MARK: - Armonización y realización a cuatro voces

extension LineaDeComandos {
    /// `armonizar Mi4 Re4 Do4`: las mejores armonizaciones y, si las notas llevan octava, el coral a
    /// cuatro voces con la melodía en el soprano.
    static func armonizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let propuestas = argumentos.quitarNumero("--propuestas", "--proposals", en: 1...20, porDefecto: 3) else {
            return uso(.propuestasFueraDeRango, notacion)
        }
        guard let dada = try argumentos.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        guard !argumentos.restantes.isEmpty else { return uso(.faltanNotasDeLaArmonizacion, notacion) }
        let coral = try PresentacionDeCoral.armonizar(
            argumentos.unidos, en: dada,
            propuestas: propuestas, notacion: notacion)
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

    /// `realizar Do Fa Sol7 Do`: los acordes escritos a cuatro voces, sin faltas.
    static func realizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let tonalidad = try argumentos.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        guard !argumentos.restantes.isEmpty else { return uso(.faltanAcordesDeLaRealizacion, notacion) }
        let coral = try PresentacionDeCoral.realizar(argumentos.unidos, en: tonalidad, notacion: notacion)
        guard !coral.avisos.contains(.sinRealizacion) else {
            return bien(CoralPresentado.Aviso.sinRealizacion.texto(en: notacion))
        }
        return bien(([coral.titulo] + describir(coral.filas)).joined(separator: "\n"))
    }

    /// `revisar Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4`: las faltas de conducción, una por línea.
    static func revisar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        guard !argumentos.isEmpty else { return uso(.faltanAcordesDeLasVoces, notacion) }
        let coral = try PresentacionDeCoral.revisar(argumentos.joined(separator: " "), notacion: notacion)
        return bien(coral.avisos.map { $0.texto(en: notacion) }.joined(separator: "\n"))
    }

    /// `contrapunto Re4 Fa4 Mi4 Re4 / La4 La4 Do#5 Re5 --especie 1`: la especie, si el contrapunto va encima
    /// o debajo del cantus firmus, y las faltas, una por línea.
    static func contrapunto(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var argumentos = Argumentos(argumentos)
        guard let numero = argumentos.quitarNumero("--especie", "--species", en: 1...5, porDefecto: 1),
            let especie = Contrapunto.Especie(rawValue: numero)
        else {
            return uso(.especieFueraDeRango, notacion)
        }
        if let desconocida = argumentos.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        let partes = argumentos.unidos.split(separator: "/", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard partes.count == 2, !partes[0].isEmpty, !partes[1].isEmpty else {
            return uso(.faltanVocesDelContrapunto, notacion)
        }
        let ejercicio = try Contrapunto(cantusFirmus: partes[0], contrapunto: partes[1], especie: especie)
        return bien(ejercicio.informe(en: notacion))
    }

    /// `transponer 2M Do Lam Fa Sol7` o `transponer Re Do Lam Fa Sol7`: lo escrito subido o bajado un intervalo, o
    /// llevado a otra tónica por el camino más corto. Lo que no se lee como acordes se transporta como notas (un
    /// coral, una melodía).
    static func transponer(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        let argumentos = Argumentos(argumentos)
        if let desconocida = argumentos.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        guard argumentos.restantes.count >= 2 else { return uso(.faltaTransporte, notacion) }
        let texto = argumentos.restantes.dropFirst().joined(separator: " ")
        let comoAcordes = try? PresentacionDeTransposicion.transponer(texto, .unisono, notacion: notacion)
        let contenido: PresentacionDeTransposicion.Contenido = comoAcordes == nil ? .notas : .acordes
        let primero = argumentos.restantes[0]
        let intervalo: Intervalo
        if let leido = try? Intervalo(leyendo: primero) {
            intervalo = leido
        } else {
            let destino = try Nota(leyendo: primero)
            let origen = PresentacionDeTransposicion.tonalidad(de: texto, contenido: contenido)?.tonica ?? destino
            intervalo = origen.intervaloMasCorto(hasta: destino)
        }
        let transportado = try PresentacionDeTransposicion.transponer(
            texto, intervalo, contenido: contenido, notacion: notacion)
        return bien(transportado)
    }

    /// `rearmonizar Do Lam Rem7 Sol7 Do [--en Do mayor]`: la tonalidad y, una por línea, las otras armonías de cada
    /// acorde, con su número en la progresión.
    static func rearmonizar(_ argumentos: [String], _ notacion: Notacion) throws -> ResultadoDeOrden {
        var acordes = Argumentos(argumentos)
        guard let tonalidad = try acordes.quitarTonalidad() else { return uso(.faltaTonalidadTrasEn, notacion) }
        if let desconocida = acordes.opcionDesconocida { return uso(.opcionDesconocida(desconocida), notacion) }
        guard !acordes.restantes.isEmpty else { return uso(.faltanAcordesDeLaRearmonizacion, notacion) }
        let leidos = try acordes.restantes.map { try Acorde(leyendo: $0) }
        guard let resultado = PresentacionDeRearmonizacion.proponer(leidos, en: tonalidad, notacion: notacion) else {
            return uso(.faltanAcordesDeLaRearmonizacion, notacion)
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
