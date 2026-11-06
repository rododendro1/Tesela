import ArmoniaElementos
import ArmoniaTeoria
import Foundation

// El sistema (las claves, las marcas de octava y los cambios de clave) y el principio de cada pentagrama: las
// claves, la armadura y la cifra del compás. Es la primera pasada de `PentagramaSVG.dibujo()`.

extension PentagramaSVG {
    /// Lo que se decide antes de dibujar: las claves de los pentagramas, las octavas que se corre cada uno (la marca
    /// 8va u 8vb) y, con cambios de clave, la clave de cada columna.
    struct Sistema {
        let claves: [Clave]
        /// `octavas[k]` > 0 escribe las notas del pentagrama `k` esas octavas más graves de lo que suenan (8va,
        /// encima del pentagrama de arriba); < 0, más agudas (8vb, debajo del de abajo).
        let octavas: [Int]
        /// Si cada columna lleva la clave de sol o la de fa según su registro.
        let conCambios: Bool
        let clavesDeLasColumnas: [Clave]

        var doble: Bool { claves.count == 2 }

        /// La clave con que se escribe una columna en el pentagrama `k`.
        func clave(_ columna: Int, _ k: Int) -> Clave {
            clavesDeLasColumnas.indices.contains(columna) ? clavesDeLasColumnas[columna] : claves[k]
        }
    }

    func disponerElSistema() -> Sistema {
        let claves = clavesDelPentagrama()
        let doble = claves.count == 2
        let doCentral = PentagramaSVG.doCentral
        // Con cambios de clave (una sola clave, sin elegir), cada columna lleva la de sol o la de fa según su registro, y
        // no hace falta la marca de octava.
        let conCambios = opciones.maquetacion.cambiosDeClave && !doble && opciones.maquetacion.clave == nil
        let clavesDeLasColumnas = conCambios ? PentagramaSVG.clavesPorRegistro(columnas, desde: claves[0]) : []
        // Una octava más cerca del pentagrama, con la marca 8va u 8vb, si con la clave elegida harían falta demasiadas
        // líneas adicionales.
        var octavas = [Int](repeating: 0, count: claves.count)
        if opciones.maquetacion.marcaDeOctava, opciones.maquetacion.clave == nil || doble, !conCambios {
            for k in claves.indices {
                let suyas = columnas.flatMap { $0 }.filter { !doble || ($0.midi >= doCentral) == (k == 0) }
                func lineas(_ octavas: Int) -> Int {
                    suyas.map {
                        PentagramaSVG.lugaresDeLasLineasAdicionales(
                            de: claves[k].posicion(de: PentagramaSVG.escrita($0, octavas: octavas)).lugar
                        ).count
                    }.max() ?? 0
                }
                let sinMarca = lineas(0)
                guard sinMarca > PentagramaSVG.lineasAdicionalesParaElPentagramaDoble else { continue }
                // Con dos pentagramas, el de arriba solo lleva 8va y el de abajo solo 8vb.
                let candidatas = doble ? (k == 0 ? [1] : [-1]) : [1, -1]
                let mejor = candidatas.min { lineas($0) < lineas($1) } ?? 0
                if lineas(mejor) < sinMarca { octavas[k] = mejor }
            }
        }
        return Sistema(
            claves: claves, octavas: octavas, conCambios: conCambios, clavesDeLasColumnas: clavesDeLasColumnas)
    }

    // MARK: - El lienzo y el principio

    /// Lo que se va dibujando, de izquierda a derecha: hasta dónde se ha llegado y lo que sube y baja el dibujo, para
    /// el alto de la imagen.
    struct Lienzo {
        /// Las claves y las armaduras, que se quedan donde están.
        var cuerpo: [String] = []
        /// Las notas y lo que va con ellas: se desplazan si el texto de encima o de debajo es más ancho.
        var notas: [String] = []
        var x = 0.6
        var minimoY = 0.0
        var maximoY: Double

        mutating func incluir(_ glifo: Glifo, lugar: Int, pentagrama: Int) {
            let y = PentagramaSVG.y(deLugar: lugar, pentagrama: pentagrama)
            minimoY = min(minimoY, y + glifo.arriba)
            maximoY = max(maximoY, y + glifo.abajo)
        }
    }

    /// Las claves, la armadura y la cifra del compás. Devuelve la alteración que da la armadura a cada nota.
    func dibujarElPrincipio(_ sistema: Sistema, en lienzo: inout Lienzo) -> [NotaNatural: Int] {
        let claves = sistema.claves
        // Claves.
        var anchoDeLasClaves = 0.0
        for (k, clave) in claves.enumerated() {
            let (glifoDeClave, lugarDeClave) = PentagramaSVG.glifoYLugar(de: clave)
            lienzo.incluir(glifoDeClave, lugar: lugarDeClave, pentagrama: k)
            lienzo.cuerpo.append(PentagramaSVG.glifo(glifoDeClave, x: lienzo.x, lugar: lugarDeClave, pentagrama: k))
            anchoDeLasClaves = max(anchoDeLasClaves, glifoDeClave.ancho)
        }
        lienzo.x += anchoDeLasClaves + 1.0

        // Armadura.
        let sostenidos = armadura.first.map { $0.alteracion.semitonos > 0 } ?? true
        var vigentes: [NotaNatural: Int] = [:]
        let glifoDeLaArmadura = sostenidos ? GlifosSMuFL.sostenido : GlifosSMuFL.bemol
        for nota in armadura {
            for (k, clave) in claves.enumerated() {
                let lugar = PentagramaSVG.lugarEnLaArmadura(nota, clave: clave, sostenidos: sostenidos)
                lienzo.incluir(glifoDeLaArmadura, lugar: lugar, pentagrama: k)
                lienzo.cuerpo.append(PentagramaSVG.glifo(glifoDeLaArmadura, x: lienzo.x, lugar: lugar, pentagrama: k))
            }
            lienzo.x += glifoDeLaArmadura.ancho + 0.15
            vigentes[nota.natural] = nota.alteracion.semitonos
        }
        // Un pequeño espacio entre la clave (o la armadura) y la primera nota.
        lienzo.x += armadura.isEmpty ? 0.8 : 0.9
        // La cifra del compás: el numerador entre la 5.ª línea y la 3.ª, el denominador entre la 3.ª y la 1.ª.
        if let ritmo, conCifraDeCompas {
            let cifras = ritmo.cifras
            let anchos = cifras.map { $0.map(\.ancho).reduce(0, +) }
            let anchoDeLaCifra = anchos.max() ?? 0
            for (fila, glifos) in cifras.enumerated() {
                var xDeLaCifra = lienzo.x + (anchoDeLaCifra - anchos[fila]) / 2
                for glifo in glifos {
                    for k in claves.indices {
                        let lugar = fila == 0 ? 6 : 2
                        lienzo.incluir(glifo, lugar: lugar, pentagrama: k)
                        lienzo.cuerpo.append(PentagramaSVG.glifo(glifo, x: xDeLaCifra, lugar: lugar, pentagrama: k))
                    }
                    xDeLaCifra += glifo.ancho
                }
            }
            lienzo.x += anchoDeLaCifra + 1.2
        }
        return vigentes
    }
}
