import Armonia
import ExposicionArmonia

// MARK: - Consultas: el lugar y la época de los ritmos y los temperamentos
//
// `--lugar` y `--agrupar`, como en `escalas`: los ritmos y los temperamentos de un lugar de origen, y agrupados por
// su continente, su país o su época de origen.

extension LineaDeComandos {
    /// Lo que piden `--lugar` y `--agrupar` en `ritmos` y `temperamentos`.
    struct LugarDelCatalogo {
        /// Los de `--lugar`: pasa si uno de sus lugares de origen es uno de ellos o está en él.
        var lugares: [Lugar] = []
        var agrupacion: AgrupacionDeEscalas?

        /// Si unos lugares de origen pasan el filtro de `--lugar`.
        func cumple(_ deOrigen: [Lugar]) -> Bool {
            guard !lugares.isEmpty else { return true }
            let suyos = Set(deOrigen.flatMap(\.conLosQueLoContienen))
            return lugares.contains(where: suyos.contains)
        }
    }

    /// Lee `--lugar espana` y `--agrupar pais`.
    static func lugarDelCatalogo(_ argumentos: inout Argumentos, _ notacion: Notacion) throws -> LugarDelCatalogo {
        var pedido = LugarDelCatalogo()
        if let texto = try argumentos.valor(.lugar) { pedido.lugares = try lugares(leyendo: texto, notacion) }
        if let texto = try argumentos.valor(.agrupar) { pedido.agrupacion = try agrupacion(leyendo: texto) }
        return pedido
    }

    /// La forma de agrupar de `--agrupar`, en español o en inglés; lanza `agrupacionDesconocida` si no es ninguna.
    static func agrupacion(leyendo texto: String) throws -> AgrupacionDeEscalas {
        let clave = claveDeBusqueda(texto)
        guard
            let encontrada = nombresDeLasAgrupaciones.first(where: {
                claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
            })
        else { throw ErrorDeUso.agrupacionDesconocida(texto) }
        return encontrada.agrupacion
    }

    /// Unos elementos del catálogo agrupados como pide `--agrupar`: por su época de origen, en orden, y al final los
    /// que no tienen; por su continente de origen; o por su país, y después por continente los que no tienen país.
    /// Uno de varios sale en todos los suyos; los que no tienen lugar, al final.
    static func agrupados<Elemento>(
        _ elementos: [Elemento], por agrupacion: AgrupacionDeEscalas, en notacion: Notacion,
        epoca: (Elemento) -> Epoca?, paises: (Elemento) -> [Pais], continentes: (Elemento) -> [Continente]
    ) -> [(titulo: String, elementos: [Elemento])] {
        var grupos: [(titulo: String, elementos: [Elemento])] = []
        if agrupacion == .epoca {
            // Por su época de origen, en orden, con sus años: «Barroco · 1600–1750».
            for suya in Epoca.allCases {
                let deLaEpoca = elementos.filter { epoca($0) == suya }
                let titulo = suya.nombre(en: notacion) + " · " + suya.textoDeLosAnios
                if !deLaEpoca.isEmpty { grupos.append((titulo, deLaEpoca)) }
            }
            let sinEpoca = elementos.filter { epoca($0) == nil }
            if !sinEpoca.isEmpty { grupos.append((Mensaje.sinEpoca.texto(en: notacion), sinEpoca)) }
            return grupos
        }
        if agrupacion == .pais {
            for pais in Pais.allCases {
                let delPais = elementos.filter { paises($0).contains(pais) }
                if !delPais.isEmpty { grupos.append((pais.nombre(en: notacion), delPais)) }
            }
        }
        for continente in Continente.allCases {
            let delContinente = elementos.filter {
                continentes($0).contains(continente) && (agrupacion == .continente || paises($0).isEmpty)
            }
            if !delContinente.isEmpty { grupos.append((continente.nombre(en: notacion), delContinente)) }
        }
        let sinLugar = elementos.filter { continentes($0).isEmpty }
        if !sinLugar.isEmpty { grupos.append((Mensaje.sinLugar.texto(en: notacion), sinLugar)) }
        return grupos
    }

    /// Las líneas de unos elementos, agrupadas si se pide: el título de cada grupo, con cuántos tiene, y sus líneas
    /// sangradas.
    static func lineasAgrupadas<Elemento>(
        de elementos: [Elemento], agrupadas agrupacion: AgrupacionDeEscalas?, en notacion: Notacion,
        epoca: (Elemento) -> Epoca?, paises: (Elemento) -> [Pais], continentes: (Elemento) -> [Continente],
        lineas: (Elemento) -> [String]
    ) -> [String] {
        guard let agrupacion else { return elementos.flatMap(lineas) }
        let grupos = agrupados(
            elementos, por: agrupacion, en: notacion, epoca: epoca, paises: paises, continentes: continentes)
        return grupos.flatMap { grupo in
            ["\(grupo.titulo) (\(grupo.elementos.count))"] + grupo.elementos.flatMap(lineas).map { "  " + $0 }
        }
    }
}
