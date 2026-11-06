import Armonia

// Lo que la pestaña de escalas dibuja o exporta además de sus secciones: los teclados de cada mano, cada posición en
// el mástil (sus trastes y cómo suena) y los ficheros de la hoja de estudio, del mapa de brillo y de la comparación.

extension PresentacionDeEstudioDeEscala {
    /// La escala en el teclado de piano con los dedos de cada mano, la derecha primero: el dibujo y su título
    /// («Do mayor · Mano derecha»).
    public static func teclados(de escala: Escala, en notacion: Notacion) -> [(svg: String, titulo: String)] {
        Mano.allCases.map { mano in
            let titulo =
                escala.nombre(en: notacion) + " · "
                + notacion.texto { mano == .derecha ? $0.manoDerecha : $0.manoIzquierda }
            return (teclado(de: escala, mano: mano, en: notacion), titulo)
        }
    }

    /// Los teclados de cada mano, para exportarlos en SVG.
    public static func ficherosDeLosTeclados(de escala: Escala, en notacion: Notacion) -> [FicheroParaExportar] {
        teclados(de: escala, en: notacion).map { FicheroParaExportar.svg($0.svg, nombre: $0.titulo) }
    }

    /// Los trastes que abarca una posición: «Trastes 2–6».
    public static func trastes(de posicion: EscalaEnElMastil, en notacion: Notacion) -> String {
        notacion.texto { $0.trastes(posicion.rangoDeTrastes.lowerBound, posicion.rangoDeTrastes.upperBound) }
    }

    /// Una posición nota a nota, cuerda a cuerda, en corcheas, como se estudia.
    public static func sonido(de posicion: EscalaEnElMastil, en escala: Escala) -> Escucha {
        Escucha.voz(Voz(posicion.alturas.map { Evento($0, .corchea) })).conTonica(escala.tonica)
    }

    /// La hoja de estudio de la escala con las secciones elegidas, para exportarla: «Hoja de estudio Do mayor».
    public static func ficheroDeLaHoja(
        de escala: Escala, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases), en notacion: Notacion
    ) -> FicheroParaExportar {
        FicheroParaExportar.svg(
            hojaDeEstudio(de: escala, en: notacion, secciones: secciones),
            nombre: notacion.texto(\.hojaDeEstudio) + " " + escala.nombre(en: notacion))
    }

    /// El mapa de brillo de las escalas con tantas notas como esta y su tónica, con esta resaltada.
    public static func mapaDeBrillo(de escala: Escala, en notacion: Notacion) -> String {
        mapaDeBrillo(numeroDeNotas: escala.tipo.numeroDeNotas, resaltada: escala, en: notacion)
    }

    /// El mapa de brillo de la escala, para exportarlo: «Mapa de brillo Do».
    public static func ficheroDelMapaDeBrillo(de escala: Escala, en notacion: Notacion) -> FicheroParaExportar {
        FicheroParaExportar.svg(
            mapaDeBrillo(de: escala, en: notacion),
            nombre: notacion.texto(\.mapaDeBrillo) + " " + escala.tonica.nombre(en: notacion))
    }

    /// La comparación nota a nota de dos escalas, para exportarla: «Do mayor · Do lidio».
    public static func ficheroDeLaComparacion(
        _ escala: Escala, con otra: Escala, en notacion: Notacion
    ) -> FicheroParaExportar {
        FicheroParaExportar.svg(
            comparacionNotaANota(escala, con: otra, en: notacion),
            nombre: escala.nombre(en: notacion) + " · " + otra.nombre(en: notacion))
    }
}
