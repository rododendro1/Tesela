import Armonia
import SwiftUI
import TeselaUI

/// Elige una tónica y una escala del catálogo (occidentales y de otras tradiciones) y muestra sus notas,
/// sus acordes, dónde caen en el mástil y cómo se tocan por posiciones (CAGED o tres notas por cuerda).
///
/// Cada sección es una vista aparte (en `VistaDeEscalas+Mastil.swift`, `VistaDeEscalas+Estudio.swift` y
/// `VistaDeEscalas+Relacionadas.swift`); aquí se queda lo que comparten varias, o la barra al exportar.
struct VistaDeEscalas: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    /// La tónica y el tipo elegidos, o la escala escrita.
    @State private var eleccion = EleccionDeEscala()
    /// Las posiciones en el mástil: las del sistema CAGED o las de tres (o dos) notas por cuerda.
    @State private var caged = true
    /// La secuencia de estudio, su sentido y cuántas octavas abarca.
    @State private var secuencia = SecuenciaDeEscala.terceras
    @State private var bajando = false
    @State private var octavas = 1
    /// El instrumento y el capo de las posiciones en el mástil.
    @State private var encordado = Encordado.guitarra
    @State private var capo = 0
    /// Las secciones que lleva la hoja de estudio, para verla y exportarla.
    @State private var seccionesDeLaHoja = Set(SeccionDeLaHoja.allCases)
    /// La escala con que se compara la elegida, o vacío.
    @State private var otraEscala = "Do lidio"
    /// Lo que está sonando, para resaltar la nota en el pentagrama.
    @ObservedObject private var reproductor = Reproductor.compartido

    var body: some View {
        let escala = eleccion.escala
        let pentagrama = PentagramaPresentado(escala, notacion: notacion)
        let sonido = Escucha.escala(escala)
        let mastil = self.mastil
        let presentada = secuenciaPresentada(de: escala)
        Form {
            Section(notacion.texto(\.escala)) {
                Picker(notacion.texto(\.tonica), selection: $eleccion.tonica) {
                    ForEach(EleccionDeEscala.tonicas.indices, id: \.self) {
                        Text(EleccionDeEscala.tonicas[$0].nombre(en: notacion)).tag($0)
                    }
                }
                Picker(notacion.texto(\.tipo), selection: $eleccion.tipo) {
                    Section(notacion.texto(\.habituales)) {
                        ForEach(EleccionDeEscala.habituales, id: \.self) { Text(nombre($0)).tag($0) }
                    }
                    Section(notacion.texto(\.otrasTradiciones)) {
                        ForEach(EleccionDeEscala.deOtrasTradiciones, id: \.self) { Text(nombre($0)).tag($0) }
                    }
                }
                TextField(notacion.texto(\.campoDeEscalaPropia), text: $eleccion.propia)
                    .comoCampoDeCifrado()
                    .accessibilityLabel(Text(notacion.texto(\.escalaPropia)))
            }
            notas(de: escala, sonido: sonido)
            let acordes = escala.armonizar().compactMap { $0 }
            if !acordes.isEmpty {
                Section(notacion.texto(\.acordesDeLaEscala)) {
                    Text(acordes.map { $0.cifrado(en: notacion) }.joined(separator: "   "))
                }
            }
            SeccionDeAcordesQueCaben(escala: escala)
            Section(notacion.texto(\.pentagrama)) {
                // Mientras suena, la nota que se oye, de otro color.
                if let paso = reproductor.paso(de: sonido) {
                    DiagramaDePentagrama(PentagramaPresentado(escala, notacion: notacion, resaltada: paso))
                } else {
                    DiagramaDePentagrama(pentagrama)
                }
            }
            Section(notacion.texto(\.mastilDeGuitarra)) {
                DiagramaDeMastil(mastil: Mastil(.guitarra, numeroDeTrastes: 12), escala: escala, notacion: notacion)
            }
            SeccionDePosiciones(escala: escala, mastil: mastil, caged: $caged, encordado: $encordado, capo: $capo)
            SeccionDeFormasPentatonicas(escala: escala, mastil: mastil)
            SeccionDeLaSecuencia(presentada: presentada, secuencia: $secuencia, bajando: $bajando, octavas: $octavas)
            SeccionDeLaSecuenciaEnLasPosiciones(
                escala: escala, secuencia: secuencia, bajando: bajando, caged: caged, mastil: mastil)
            SeccionDeLaDigitacionDePiano(escala: escala)
            SeccionDeLaSimetria(escala: escala)
            SeccionDeLasEstadisticas(escala: escala)
            SeccionDeLaEscaleraDeBrillo(escala: escala)
            SeccionDelMapaDeBrillo(escala: escala)
            SeccionDelReloj(escala: escala)
            ListaDeEscalas(
                PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion),
                titulo: notacion.texto(\.escalasVecinas))
            ListaDeEscalas(
                PresentacionDeEstudioDeEscala.parecidas(a: escala, en: notacion),
                titulo: notacion.texto(\.escalasParecidas))
            SeccionDeProgresiones(escala: escala)
            SeccionDeLasDoceTonalidades(escala: escala)
            SeccionDeLosAcordesEnLasDoceTonalidades(escala: escala)
            SeccionDeLosModos(escala: escala)
            SeccionDeLaComparacion(escala: escala, otraEscala: $otraEscala)
            SeccionDeLaHojaDeEstudio(escala: escala, secciones: $seccionesDeLaHoja)
        }
        .navigationTitle(notacion.texto(\.escalas))
        .selectorDeNotacionEnLaBarra()
        // Una escala pedida desde otra pestaña (las compatibles con un acorde), ahora o si se pidió antes de abrir
        // esta.
        .onChange(of: navegacion.escalaPedida) { _ in tomarLaEscalaPedida() }
        .onAppear(perform: tomarLaEscalaPedida)
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros(de: escala, pentagrama: pentagrama, secuencia: presentada))
            }
        }
    }

    /// El nombre de la escala, de qué escala es modo, sus notas (y las microtonales), sus pasos y «Escuchar».
    private func notas(de escala: Escala, sonido: Escucha) -> some View {
        Section(notacion.texto(\.notas)) {
            Text(escala.nombre(en: notacion)).font(.headline)
            // De qué escala es modo (Re dórico → modo 2 de Do mayor); se abre al tocarlo.
            if let modo = PresentacionDeEscalaYAcorde.modo(de: escala, en: notacion),
                let madre = escala.escalaMadre?.madre
            {
                Button(modo) { navegacion.ver(madre) }
            }
            Text(escala.notas.map { $0.nombre(en: notacion) }.joined(separator: "  "))
                .font(.system(.body, design: .monospaced))
            // La versión microtonal (Re Bayātī: Re Mi𝄳 Fa…) y los cents de cada grado, si la escala la tiene.
            if let microtonos = escala.notasMicrotonales() {
                Text(microtonos.map { $0.nombre(en: notacion) }.joined(separator: "  "))
                    .font(.system(.body, design: .monospaced))
                Text("¢  " + microtonos.map { "\(Int($0.cents.rounded()))" }.joined(separator: "  "))
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            LabeledContent(
                notacion.texto(\.pasosEnSemitonos),
                value: escala.pasosEnSemitonos.map(String.init).joined(separator: "-")
                    + (escala.numeroDeForte.map { "  ·  " + $0 } ?? ""))
            BotonDeEscuchar(sonido)
        }
    }

    /// Lo que se exporta con la barra: el pentagrama, la hoja de estudio, el mapa de brillo, la secuencia, los
    /// teclados de cada mano, la comparación (si la otra escala se lee) y las doce tonalidades.
    private func ficheros(
        de escala: Escala, pentagrama: PentagramaPresentado, secuencia: SecuenciaPresentada
    ) -> [FicheroParaExportar] {
        typealias Estudio = PresentacionDeEstudioDeEscala
        var ficheros = [
            pentagrama.fichero,
            Estudio.ficheroDeLaHoja(de: escala, secciones: seccionesDeLaHoja, en: notacion),
            Estudio.ficheroDelMapaDeBrillo(de: escala, en: notacion),
        ]
        ficheros += secuencia.ficheros + Estudio.ficherosDeLosTeclados(de: escala, en: notacion)
        if let otra = try? Escala(leyendo: otraEscala) {
            ficheros.append(Estudio.ficheroDeLaComparacion(escala, con: otra, en: notacion))
        }
        return ficheros + Estudio.enLasDoceTonalidades(escala, en: notacion).ficheros
    }

    private func secuenciaPresentada(de escala: Escala) -> SecuenciaPresentada {
        PresentacionDeEstudioDeEscala.secuencia(
            escala, secuencia, octavas: octavas, sentido: bajando ? .descendente : .ascendente, en: notacion)
    }

    /// El mástil de las posiciones: el instrumento elegido, con su capo.
    private var mastil: Mastil { Mastil(encordado.conCapo(capo), numeroDeTrastes: 15) }

    /// Elige la escala pedida desde otra pestaña, si la hay, y la vacía.
    private func tomarLaEscalaPedida() {
        guard let pedida = navegacion.escalaPedida else { return }
        navegacion.escalaPedida = nil
        eleccion.elegir(pedida)
    }

    private func nombre(_ indice: Int) -> String {
        EleccionDeEscala.nombreDelTipo(indice, en: notacion)
    }
}
