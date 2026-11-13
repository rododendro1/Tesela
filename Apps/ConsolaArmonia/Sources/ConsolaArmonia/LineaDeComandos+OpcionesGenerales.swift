import Armonia

// Las opciones que valen para todas las órdenes y se quitan antes de elegir la orden: el idioma y la escritura de las
// notas, el sistema de nombres, la octava, `--json` y `-o`.

/// Lo que dicen las opciones generales de una orden.
struct OpcionesGenerales {
    var notacion: Notacion
    /// Un sistema de nombres móvil (sargam, jianpu), que solo entiende `escala`.
    var movil: SistemaMovil?
    /// Con `--json`, las órdenes que lo admiten dan sus datos en JSON (LineaDeComandos+JSON.swift y
    /// Ordenes/*/+JSON).
    var json: Bool
    /// Con `-o`, el fichero al que va lo que da la orden (`-o -`, la salida estándar, aunque sea un fichero binario).
    var destino: String?
}

/// Un error de uso en una opción general, con la notación que había cuando se encontró, en la que se escribe.
struct ErrorEnUnaOpcionGeneral: Error {
    let error: ErrorDeUso
    let notacion: Notacion
}

extension LineaDeComandos {
    /// Quita de `opciones` las opciones generales y dice lo que piden. La notación sale del entorno
    /// (`ARMONIA_IDIOMA`) y de las opciones, en este orden: `--ingles`, `--idioma`, `--textos`, `--escritura`,
    /// `--grafia` y `--sistema`, y la octava.
    static func opcionesGenerales(
        _ opciones: inout Argumentos, entorno: [String: String]
    ) throws(ErrorEnUnaOpcionGeneral) -> OpcionesGenerales {
        var notacion: Notacion
        switch notacionDelEntorno(entorno) {
        case .success(let delEntorno):
            notacion = delEntorno
        case .failure(let error):
            throw ErrorEnUnaOpcionGeneral(error: error, notacion: .compacta(.espanol))
        }
        if opciones.quitarMarca(.ingles) { notacion = .ascii(.ingles) }
        try idiomaYEscritura(&opciones, &notacion)
        let (movil, grafiaElegida) = try sistemaDeNombres(&opciones, &notacion)
        // La octava va como la escriba la notación (en subíndice en las compactas, con cifras en las demás), salvo
        // con --subindices o --cifras.
        let subindices = opciones.quitarMarca(.subindices)
        let cifras = opciones.quitarMarca(.cifras)
        if subindices {
            notacion = notacion.conOctavas(.subindices)
        } else if cifras {
            notacion = notacion.conOctavas(.cifras)
        }
        if let grafiaElegida, notacion.sistemaDeNombres == nil { notacion = notacion.conGrafia(grafiaElegida) }
        let json = opciones.quitarMarca(.json)
        // «-o» a secas se nombra con su nombre largo.
        let destino = try valor(.salida, &opciones, notacion, sinNombre: "salida")
        return OpcionesGenerales(notacion: notacion, movil: movil, json: json, destino: destino)
    }

    /// El valor de una opción, `nil` si no está y un error si está sin valor.
    private static func valor(
        _ opcion: OpcionDeOrden, _ opciones: inout Argumentos, _ notacion: Notacion, sinNombre: String = ""
    ) throws(ErrorEnUnaOpcionGeneral) -> String? {
        switch opciones.quitarOpcion(opcion) {
        case .ausente:
            return nil
        case .sinValor(let nombre):
            throw ErrorEnUnaOpcionGeneral(error: .faltaValor(nombre.isEmpty ? sinNombre : nombre), notacion: notacion)
        case .valor(let texto):
            return texto
        }
    }

    /// `--idioma` (el de las notas y los textos), `--textos` (solo el de los textos) y `--escritura`.
    private static func idiomaYEscritura(
        _ opciones: inout Argumentos, _ notacion: inout Notacion
    ) throws(ErrorEnUnaOpcionGeneral) {
        if let texto = try valor(.idioma, &opciones, notacion) {
            guard let elegida = notacionDelIdioma(texto) else {
                throw ErrorEnUnaOpcionGeneral(error: .idiomaDesconocido(texto), notacion: notacion)
            }
            notacion = elegida
        }
        if let texto = try valor(.textos, &opciones, notacion) {
            guard let elegida = notacionDelIdioma(texto) else {
                throw ErrorEnUnaOpcionGeneral(error: .idiomaDesconocido(texto), notacion: notacion)
            }
            notacion = notacion.conTextos(en: elegida.idiomaDeLasNotas)
            if elegida.grafia != .original { notacion = notacion.conGrafia(elegida.grafia) }
        }
        if let texto = try valor(.escritura, &opciones, notacion) {
            guard let escritura = escritura(texto, en: notacion.escritura.idioma) else {
                throw ErrorEnUnaOpcionGeneral(error: .escrituraNoValida(texto), notacion: notacion)
            }
            notacion = Notacion(escritura: escritura, textos: notacion.textos, grafia: notacion.grafia)
        }
    }

    /// Con --sistema, los nombres de otra tradición: los fijos (bizantino, japonés, lü) en toda la orden, como una
    /// escritura más; los móviles (sargam, jianpu), solo en `escala`, que tiene tónica, y se devuelven. Con --grafia,
    /// la de los sistemas y, en ruso y en griego, la de las notas y los textos (--idioma ru --grafia transliterada es
    /// --idioma ru-latn), que se devuelve para aplicarla después de la octava.
    private static func sistemaDeNombres(
        _ opciones: inout Argumentos, _ notacion: inout Notacion
    ) throws(ErrorEnUnaOpcionGeneral) -> (SistemaMovil?, Grafia?) {
        var grafiaElegida: Grafia?
        if let texto = try valor(.grafia, &opciones, notacion) {
            guard let elegida = grafia(texto) else {
                throw ErrorEnUnaOpcionGeneral(error: .grafiaNoValida(texto), notacion: notacion)
            }
            grafiaElegida = elegida
        }
        var movil: SistemaMovil?
        if let texto = try valor(.sistema, &opciones, notacion) {
            guard let sistema = SistemaDeNombres(nombre: texto) else {
                throw ErrorEnUnaOpcionGeneral(error: .sistemaDesconocido(texto), notacion: notacion)
            }
            if let conSistema = Notacion.sistema(
                sistema, grafia: grafiaElegida ?? .transliterada, textos: notacion.textos)
            {
                notacion = conSistema
            } else {
                movil = SistemaMovil(sistema: sistema, grafia: grafiaElegida ?? .transliterada, nombre: texto)
            }
        }
        return (movil, grafiaElegida)
    }
}
