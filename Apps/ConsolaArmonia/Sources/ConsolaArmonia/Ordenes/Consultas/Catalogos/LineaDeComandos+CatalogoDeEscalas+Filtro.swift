import Armonia
import Exposicion
import Foundation

// MARK: - Consultas: el filtro del catálogo de escalas
//
// Lo que deja `escalas` del catálogo, leído de sus opciones. Los valores de cada opción se leen en
// LineaDeComandos+CatalogoDeEscalas+Valores.swift.

extension LineaDeComandos {

    /// Cómo agrupa `--agrupar` las escalas: por el continente o por el país de donde vienen, o por su época de
    /// origen.
    enum AgrupacionDeEscalas {
        case continente, pais, epoca
    }

    /// Lo que deja `escalas` del catálogo: la tradición, la categoría, la fuente, el uso, el número de notas, lo que
    /// se mide de cada una y el texto que se busca en los nombres, y el orden en que salen.
    struct FiltroDeEscalas {
        var tradicion: Tradicion?
        var categoria: CategoriaTradicional?
        var fuente: FuenteTeorica?
        /// Los de `--estilo`: uno, o los tres populares con `--estilo popular`.
        var usos: [Estilo] = []
        /// La de `--estilo bebop`: solo las escalas de esa corriente (y `usos`, su estilo).
        var corriente: Corriente?
        /// Los de `--lugar`: la escala pasa si uno de sus lugares de origen o de uso es uno de ellos o está en él.
        var lugares: [Lugar] = []
        /// Las de `--epoca`: la escala pasa si una de sus épocas, de origen o de uso, es una de ellas.
        var epocas: [Epoca] = []
        /// El de `--afecto`: solo las que lo tienen en alguna de sus fuentes.
        var afecto: Afecto?
        /// La de `--escuela`: solo las de esa escuela.
        var escuela: Escuela?
        var agrupacion: AgrupacionDeEscalas?
        var numeroDeNotas: Int?
        var orden: OrdenDeEscalas?
        var sinSemitonos = false
        var conIntervalo: Int?
        var sinIntervalo: Int?
        var conPaso: Int?
        var regulares = false
        /// La clave de `--afinacion`: solo las de una afinación de ese carácter.
        var afinacion: String?
        /// `true` con `--fragmentos` (solo ellos), `false` con `--sin-fragmentos`; `nil`, todas.
        var fragmentos: Bool?
        /// El texto suelto, como clave de búsqueda; vacío si no hay.
        var buscado = ""

        private func estadisticas(_ tipo: TipoDeEscala) -> EstadisticasDeEscala { Escala(.do, tipo).estadisticas }

        /// Si una escala pasa los filtros que no son de tradición, categoría, fuente ni uso.
        func cumple(_ tipo: TipoDeEscala, en notacion: Notacion) -> Bool {
            guard numeroDeNotas == nil || tipo.numeroDeNotas == numeroDeNotas else { return false }
            guard !sinSemitonos || estadisticas(tipo).anhemitonica else { return false }
            guard !regulares || estadisticas(tipo).maximamenteRegular else { return false }
            guard fragmentos == nil || tipo.esFragmento == fragmentos else { return false }
            guard afinacion == nil || tipo.caracterDeLaAfinacion?.clave == afinacion else { return false }
            if !lugares.isEmpty {
                let suyos = Set((tipo.lugaresDeOrigen + tipo.lugaresDeUso).flatMap(\.conLosQueLoContienen))
                guard lugares.contains(where: suyos.contains) else { return false }
            }
            if !epocas.isEmpty, !tipo.epocas.contains(where: epocas.contains) { return false }
            if let afecto, !tipo.afectos.contains(afecto) { return false }
            if let escuela, !tipo.escuelas.contains(escuela) { return false }
            if conIntervalo != nil || sinIntervalo != nil || conPaso != nil {
                let medidas = estadisticas(tipo)
                if let conIntervalo, medidas.vectorIntervalico[conIntervalo - 1] == 0 { return false }
                if let sinIntervalo, medidas.vectorIntervalico[sinIntervalo - 1] > 0 { return false }
                if let conPaso, !medidas.pasos.contains(conPaso) { return false }
            }
            return buscado.isEmpty || claveDeBusqueda(tipo.nombre(en: notacion)).contains(buscado)
                || claveDeBusqueda(tipo.nombre).contains(buscado)
        }

        /// Los grupos, en el orden del catálogo: las habituales (si no se filtra por tradición, categoría ni fuente)
        /// y, después, cada tradición con su categoría.
        func grupos(en notacion: Notacion) -> [GrupoDeEscalas] {
            let traducir = { (mensaje: Mensaje) in mensaje.texto(en: notacion) }
            var grupos: [GrupoDeEscalas] = []
            if tradicion == nil && categoria == nil && fuente == nil {
                if !usos.isEmpty {
                    let delUso = TipoDeEscala.occidentales.filter { tipo in
                        tipo.estilos.contains(where: usos.contains)
                            && (corriente.map(tipo.corrientes.contains) ?? true) && cumple(tipo, en: notacion)
                    }
                    let nombre =
                        corriente?.nombre(en: notacion)
                        ?? (usos.count == 1 ? usos[0].nombre(en: notacion) : Estilo.nombreDeLosPopulares(en: notacion))
                    if !delUso.isEmpty { grupos.append((traducir(.habituales) + " · " + nombre, delUso)) }
                } else {
                    let habituales = TipoDeEscala.occidentales.filter { cumple($0, en: notacion) }
                    if !habituales.isEmpty { grupos.append((traducir(.habituales), habituales)) }
                }
            }
            for tipo in TipoDeEscala.tradicionales where usos.isEmpty && cumple(tipo, en: notacion) {
                guard let suya = tipo.tradicion, let deTipo = tipo.categoria else { continue }
                guard tradicion == nil || tradicion == suya, categoria == nil || categoria == deTipo,
                    fuente == nil || fuente == tipo.fuente || tipo.afinaciones.contains(where: { $0.fuente == fuente })
                else { continue }
                let titulo = suya.nombre(en: notacion) + " · " + deTipo.nombre(en: notacion)
                if let i = grupos.firstIndex(where: { $0.titulo == titulo }) {
                    grupos[i].tipos.append(tipo)
                } else {
                    grupos.append((titulo, [tipo]))
                }
            }
            guard let agrupacion else { return grupos }
            return agrupados(grupos.flatMap(\.tipos), por: agrupacion, en: notacion)
        }

        /// Con `--agrupar continente`, un grupo por continente de origen, en el orden de `Continente.allCases`; con
        /// `--agrupar pais`, uno por país, y después uno por continente con las que no tienen país (la mayor, en
        /// Europa). Una escala de varios sale en todos los suyos; las que no tienen lugar (las propias), al final. Con
        /// `--agrupar epoca`, uno por época de origen, en orden, y al final las que no tienen.
        func agrupados(
            _ tipos: [TipoDeEscala], por agrupacion: AgrupacionDeEscalas, en notacion: Notacion
        ) -> [GrupoDeEscalas] {
            var grupos: [GrupoDeEscalas] = []
            if agrupacion == .epoca {
                // Por su época de origen, en orden, con sus años: «Barroco · 1600–1750».
                for epoca in Epoca.allCases {
                    let deLaEpoca = tipos.filter { $0.epocaDeOrigen == epoca }
                    let titulo = epoca.nombre(en: notacion) + " · " + epoca.textoDeLosAnios
                    if !deLaEpoca.isEmpty { grupos.append((titulo, deLaEpoca)) }
                }
                let sinEpoca = tipos.filter { $0.epocaDeOrigen == nil }
                if !sinEpoca.isEmpty { grupos.append((Mensaje.sinEpoca.texto(en: notacion), sinEpoca)) }
                return grupos
            }
            if agrupacion == .pais {
                for pais in Pais.allCases {
                    let delPais = tipos.filter { $0.paisesDeOrigen.contains(pais) }
                    if !delPais.isEmpty { grupos.append((pais.nombre(en: notacion), delPais)) }
                }
            }
            for continente in Continente.allCases {
                let delContinente = tipos.filter {
                    $0.continentesDeOrigen.contains(continente)
                        && (agrupacion == .continente || $0.paisesDeOrigen.isEmpty)
                }
                if !delContinente.isEmpty { grupos.append((continente.nombre(en: notacion), delContinente)) }
            }
            let sinLugar = tipos.filter { $0.continentesDeOrigen.isEmpty }
            if !sinLugar.isEmpty { grupos.append((Mensaje.sinLugar.texto(en: notacion), sinLugar)) }
            return grupos
        }

        /// Con `--orden`, de la más brillante a la más oscura, o de menos a más notas; a igualdad, en el orden del
        /// catálogo.
        func ordenados(_ tipos: [TipoDeEscala]) -> [TipoDeEscala] {
            guard let orden else { return tipos }
            // La clave de cada una, de menor a mayor: el brillo, cambiado de signo, o el número de notas.
            let claves = tipos.map { orden == .brillo ? -estadisticas($0).brilloPorQuintas : Double($0.numeroDeNotas) }
            return tipos.indices.sorted { (claves[$0], $0) < (claves[$1], $1) }.map { tipos[$0] }
        }
    }

    /// Lee los filtros de `escalas`, en el orden en que se comprueban, y el texto suelto que queda.
    static func filtrosDelCatalogo(_ entrada: inout Argumentos, _ notacion: Notacion) throws -> FiltroDeEscalas {
        var filtro = FiltroDeEscalas()
        if let texto = try entrada.valor(.tradicion) {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasTradiciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.tradicionDesconocida(texto) }
            filtro.tradicion = encontrada.tradicion
        }
        if let texto = try entrada.valor(.categoria) {
            let clave = claveDeBusqueda(texto)
            let nombres = { (candidata: CategoriaTradicional) in
                [candidata.rawValue, candidata.nombre, candidata.nombre(en: notacion)].map(claveDeBusqueda)
            }
            guard let encontrada = CategoriaTradicional.allCases.first(where: { nombres($0).contains(clave) }) else {
                throw ErrorDeUso.categoriaDesconocida(texto)
            }
            filtro.categoria = encontrada
        }
        // `--fuente ptolomeo`, `--source ptolemy`: las escalas que definió o afinó un teórico, por su clave o por su
        // nombre en español, en inglés o en el idioma de la notación.
        if let texto = try entrada.valor(.fuente) { filtro.fuente = try fuenteTeorica(leyendo: texto, notacion) }
        // `--estilo jazz`, o una corriente de un estilo: `--estilo bebop`, `--style neoclassical-metal`.
        if let texto = try entrada.valor(.estilo) {
            if let corriente = corriente(leyendo: texto, notacion) {
                filtro.corriente = corriente
                filtro.usos = [corriente.estilo]
            } else {
                filtro.usos = try estilos(leyendo: texto, notacion)
            }
        }
        // `--lugar espana`, `--place spain`: las de un lugar, de origen o de uso; `--agrupar continente`, por el suyo.
        if let texto = try entrada.valor(.lugar) { filtro.lugares = try lugares(leyendo: texto, notacion) }
        // `--epoca barroco`, `--era baroque`: las de una época, de origen o de uso; `--escuela carnatica`, las de una
        // escuela.
        if let texto = try entrada.valor(.epoca) { filtro.epocas = try epocas(leyendo: texto, notacion) }
        if let texto = try entrada.valor(.escuela) { filtro.escuela = try escuela(leyendo: texto, notacion) }
        // `--afecto lastimero`, `--affect plaintive`: las que tienen ese afecto en alguna de sus fuentes.
        if let texto = try entrada.valor(.afecto) { filtro.afecto = try afecto(leyendo: texto, notacion) }
        // `--afinacion microtonal`, `--tuning just`: por el carácter de su afinación.
        if let texto = try entrada.valor(.afinacion) { filtro.afinacion = try claveDeAfinacion(leyendo: texto) }
        if let texto = try entrada.valor(.agrupar) {
            let clave = claveDeBusqueda(texto)
            guard
                let encontrada = nombresDeLasAgrupaciones.first(where: {
                    claveDeBusqueda($0.espanol) == clave || claveDeBusqueda($0.ingles) == clave
                })
            else { throw ErrorDeUso.agrupacionDesconocida(texto) }
            filtro.agrupacion = encontrada.agrupacion
        }
        // `--notas 5`: solo las de cinco notas (las pentatónicas).
        filtro.numeroDeNotas = try numeroDeNotasPedido(&entrada)
        // `--orden brillo`, `--sin-semitonos`, `--regulares`: por lo que se mide de cada escala.
        if let texto = try entrada.valor(.orden) {
            guard let elegido = ordenesDeEscalas[claveDeBusqueda(texto)] else {
                throw ErrorDeUso.ordenDeEscalasDesconocido(texto)
            }
            filtro.orden = elegido
        }
        filtro.sinSemitonos = entrada.quitarMarca(.sinSemitonos)
        // `--con-intervalo tritono`, `--sin-intervalo 1`, `--con-paso 3`: por el vector interválico y los pasos.
        if let texto = try entrada.valor(.conIntervalo) { filtro.conIntervalo = try claseIntervalica(texto) }
        if let texto = try entrada.valor(.sinIntervalo) { filtro.sinIntervalo = try claseIntervalica(texto) }
        if let texto = try entrada.valor(.conPaso, siFalta: .pasoFueraDeRango) {
            guard let n = Int(texto), (1...11).contains(n) else { throw ErrorDeUso.pasoFueraDeRango }
            filtro.conPaso = n
        }
        filtro.regulares = entrada.quitarMarca(.regulares)
        // `--fragmentos`: los tetracordos, los ajnas, los hexacordos…; `--sin-fragmentos`, todas menos ellos.
        let soloFragmentos = entrada.quitarMarca(.fragmentos)
        let sinFragmentos = entrada.quitarMarca(.sinFragmentos)
        if soloFragmentos != sinFragmentos { filtro.fragmentos = soloFragmentos }
        try entrada.sinOpcionesDesconocidas()
        filtro.buscado = claveDeBusqueda(entrada.unidos)
        return filtro
    }
}
