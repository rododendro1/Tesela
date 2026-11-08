# Cambios

## 0.4.1 (2026-11-08)

- El selector de notación tiene un interruptor «Alfabeto latino» cuando las notas o los textos están en ruso o en
  griego (`Notacion.admiteOtraGrafia`). La notación se guarda con su grafía detrás de su clave
  («ruso@transliterada», «griego+espanol@ascii»).
- **Cambio incompatible:** la lista del selector de las notaciones de otras tradiciones es
  `Notacion.deOtrasTradicionesDelSelector`, porque `Notacion.deOtrasTradiciones` es ahora la del motor, con las tres
  grafías de cada sistema. Las claves no cambian.
- Las apps están también en sueco: `sv` en `Idiomas.plist`, las carpetas `sv.lproj` y los textos de las vistas.
  El selector de notación tiene la notación sueca (Fiss, Ess, B, H).
- Las apps están en doce idiomas: el selector de notación ya no tiene el asturiano, el aragonés ni el occitano, y
  las apps ya no declaran `ast`, `an` ni `oc` (`Idiomas.plist` y las carpetas `.lproj`). Con una de esas notaciones
  guardada, las apps vuelven al español con ♯ y ♭; con el sistema en uno de esos idiomas, toman el siguiente idioma
  del sistema que conozcan o, si no hay ninguno, el español.

## 0.4.0 (2026-11-07)

- El selector de notación tiene una sección «Otras tradiciones» con los sistemas fijos de nombres de nota (bizantino,
  japonés, coreano, de Guido, los lü y el solfeo árabe y hebreo), en sus grafías: `Notacion.deOtrasTradiciones`, con
  su clave («bizantino», «bizantinoOriginal», «luChinosASCII») y su título («Βυζαντινή (Ga♯)»). Al elegir uno, los
  textos siguen en el idioma que se estaba leyendo.
- **Cambio incompatible:** `Notacion.desde(clave:)` ya no lee las claves de antes de la 0.3.0 («espanolUnicode»,
  «inglesUnicode» y «aleman», que era Deutsch (Fis)): con una de ellas guardada, las apps vuelven al español con ♯ y
  ♭ hasta que se elija otra notación.

## 0.3.7 (2026-11-07)

- **Cambio incompatible:** el paquete, el producto y el módulo se llaman ahora `Interfaz` (antes `TeselaUI`),
  y la carpeta es `Packages/Interfaz`. Quien lo use por SwiftPM cambia `.product(name: "TeselaUI", …)` por
  `.product(name: "Interfaz", …)` y `import TeselaUI` por `import Interfaz`; los tipos no cambian.

## 0.3.6 (2026-11-06)

- **Las redes de notas, a `TeselaPresentacion`.** `RedDeNotas`, `ContenidoDeRed`, `PresentacionDeRedes`, `AjusteUIL`
  y `AjusteCuadrado` no usan SwiftUI y las dibuja también la línea de comandos, así que pasan a `TeselaPresentacion`.
  `TeselaUI` lo reexporta: con `import TeselaUI` se siguen viendo igual, salvo quien escriba el módulo delante
  (`TeselaUI.RedDeNotas`).

- **Cambio incompatible:** el paquete, el producto y el módulo se llaman ahora `TeselaUI` (antes `ArmoniaUI`), y la
  carpeta es `Packages/TeselaUI`. No es parte del motor sino lo que comparten las apps. Quien lo use por SwiftPM
  cambia `.product(name: "ArmoniaUI", …)` por `.product(name: "TeselaUI", …)` y `import ArmoniaUI` por
  `import TeselaUI`; los tipos no cambian.

## 0.3.2 (2026-11-03)

- **Acordes en las doce tonalidades y arpegios para exportar.** En Escalas, los acordes de cada grado en las doce
  tonalidades, con o sin séptima, para escucharlos y exportarlos. En Acordes, cada posición del arpegio en el mástil
  se exporta en tablatura MusicXML y puede subir y bajar, como se estudia el barrido.

- **Escalas propias en Armonía.** En Escalas, una escala escrita por sus notas o por sus pasos en semitonos (con su
  número de Forte), sus escalas vecinas, el reloj de la escala en el círculo cromático o en el de quintas, la escala
  en las doce tonalidades para escucharla y exportarla, y las posiciones en el bajo, en afinaciones abiertas y con
  capo.

- **Más escalas en Armonía.** En Escalas, la digitación de piano dibujada en un teclado para cada mano (y para
  exportar en SVG), la simetría de las escalas simétricas con sus acordes que se repiten, las cinco formas de la
  pentatónica con las notas que comparten y la secuencia elegida tocada en cada posición, en tablatura. En
  Identificar, las escalas que contienen lo que suena. En Análisis, las líneas de notas guía, para escucharlas y
  exportarlas.

- **Teclados de cuadrícula como los de un controlador.** En la app Tonnetz, cuatro redes más (terceras menores,
  tritonos, octavas y secuencial) y «H,V», con los ejes que se escriban. Con `AjusteCuadrado`, cualquiera se gira de
  90° en 90°, se refleja, se dibuja en la rejilla de un Launchpad, un Push o un LinnStrument con la nota de origen que
  se elija y, con una escala, se toca en tono. Las notas llevan su contorno y la primera, el borde naranja.

- **Teclados de cuadrícula en la app Tonnetz.** Seis redes más en el selector: en cuartas, en terceras mayores, en
  quintas, Wicki-Hayden en cuadrícula, de tonos enteros y el Tonnetz de Euler. Se dibujan con cuadrados de 12 columnas
  por 7 filas, con el Do4 hacia el centro, y se tocan como los teclados hexagonales.

- **Estudiar escalas en Armonía.** En Escalas, la escala en secuencias (por terceras, en grupos, en tríadas…),
  subiendo o bajando, con su pentagrama, para escucharla y exportarla; la digitación de piano de cada mano; los modos
  sobre la misma tónica, del más brillante al más oscuro, con lo que cambia cada uno, y los de las mismas notas; y la
  comparación con otra escala. En Acordes, las escalas bebop y las pentatónicas para improvisar. En Análisis, debajo
  de cada acorde, las notas que cambian y las notas guía.

- **Más acordes en Armonía.** En Acordes, las disposiciones sin fundamental (A y B) y a dos manos; cada disposición
  en un grupo de cuerdas del instrumento, con su diagrama, la tablatura y los dedos; los otros nombres del acorde, el
  que queda sin la fundamental, las tonalidades en que está, sus sustituciones para escucharlas y la comparación con
  otro acorde (notas comunes y cómo va cada voz). Las disposiciones se exportan en partitura y MIDI.

- **Más arpegios en Armonía.** En Acordes, el arpegio se escribe también por grados («1 5 3 8»), empieza por la
  tercera o la quinta, suma tensiones (9, 11, 13), lleva notas cromáticas de aproximación y suena en tresillos, con
  swing y al tempo elegido. En el mástil, además de por posiciones, en las cinco formas CAGED y con una nota por
  cuerda, con los dedos sugeridos. En Análisis, la progresión arpegiada puede enlazar cada acorde con el anterior por
  la nota más cercana.

- **Disposiciones en Armonía.** En Acordes, el acorde cerrado, en drop 2, drop 3, drop 2 y 4, con la fundamental,
  la tercera y la séptima o solo con las notas guía, en todas sus octavas, con el pentagrama y un botón para escuchar
  cada una. En Análisis, la progresión dispuesta así con el menor movimiento de las voces: se escucha (resaltando el
  acorde que suena) y se exporta como partitura y MIDI.
- **Contrapunto en Armonía.** Desde la pestaña Coral se abre el contrapunto de especies: se elige la especie (de la
  primera a la quinta, cada una con un ejemplo sin faltas sobre el cantus en re de Fux), se escriben el cantus firmus
  y el contrapunto, y se ve compás a compás qué notas hay, sus intervalos con el cantus y las faltas. Se escucha
  (resaltando el compás que suena) y se exporta en MusicXML, MEI, LilyPond, ABC y MIDI.
- **«Partitura» en Tonnetz.** Un modo nuevo abre un fichero MIDI, MusicXML (también .mxl), MEI o ABC y sigue sus
  acordes en la red, con «Anterior» y «Siguiente» o mientras suena: cada tríada se dibuja con las que llevan a ella
  y sus flechas, y se dice qué transformaciones P, L y R hay desde la anterior. En macOS, la app pide permiso para
  leer el fichero elegido.
- `ArmoniaPresentacion` sale del paquete a uno propio, `Packages/ArmoniaPresentacion`, con sus pruebas. `ArmoniaUI`
  lo sigue reexportando, así que las apps no cambian; quien use `ArmoniaPresentacion` por ruta local debe apuntar a
  `Packages/ArmoniaPresentacion` y nombrar el producto con `package: "ArmoniaPresentacion"`. Por URL (el
  `Package.swift` de la raíz) no cambia nada.
- `Notacion.mensaje(de:)` traduce cualquier error del motor (`any ErrorDeArmonia`), también los de UIL, que antes
  salían siempre en español.

## 0.3.1 (2026-11-02)

- «Abrir» en el análisis también abre ficheros MEI (.mei) y ABC (.abc).
- «Escuchar» toca los microtonos: el Mi𝄳 de Re Bayātī suena un cuarto de tono sobre Mi♭, y las voces con desvíos
  (`Mi♭4(50¢):4`) suenan con sus cents. `Escucha.NotaMIDI` guarda el `microtono`, y `afinado(en:)` lo suma a la
  afinación del temperamento elegido.
- Con los nombres nuevos del motor (`Notacion.espanolPalabras`…), las claves guardadas en los ajustes no cambian:
  «espanol», «catalan», «alemanPalabras»…
- Mientras no se toque el interruptor «Octava en subíndice», la octava va como la escriba la notación: en subíndice
  en las compactas (La₄) y con cifras en las demás, como en el motor y en la línea de comandos. El ajuste se lee como
  `Bool?` y `Notacion.desde(clave:octavasEnSubindice:)` acepta `nil`.
- El alemán con palabras (Deutsch (F Kreuz)) se guarda con la clave «alemanPalabras», y «aleman» se lee como
  `.alemanCompacto` (Deutsch (Fis)), que es lo que significaba hasta la 0.3.0: quien eligió Fis antes de la 0.3.0
  lo sigue viendo. `Notacion.desde(clave:)` lee las dos.

## 0.3.0 (2026-11-01)

- **Sin nombres obsoletos**: desaparecen los que la 0.2.0 marcó como obsoletos: `PresentacionDePentagrama`
  (`PentagramaPresentado`), `PresentacionPostonal` (`AnalisisPostonalPresentado`), `Sonido` (`Escucha`) y
  `AnalisisPresentado.rearmonizaciones(notacion:)` (`rearmonizaciones(en:)`).
- El selector de notación ofrece también la escritura compacta de cada idioma con palabras: Français (Fa♯),
  Русский (Фа♯)… Se guardan como «francesCompacto», «rusoCompacto»; las claves de antes no cambian.
- Los textos de las apps, en húngaro (`TextosDeApps.hungaro`); el selector de idioma lo ofrece solo, y las apps
  lo declaran en `Config/Idiomas.plist` y en sus carpetas `hu.lproj`.
- Las claves de las notaciones compactas son «espanolCompacto», «inglesCompacto» y «alemanCompacto», y
  `Notacion.desde(clave:)` lee también las de antes («espanolUnicode», «inglesUnicode»). «aleman» es ahora el
  alemán con palabras (Deutsch (F Kreuz)), y el selector ofrece también Deutsch (Fis). En las apps la octava sigue
  el ajuste de los subíndices, también en las notaciones compactas.
- El menú para exportar de las apps ofrece también LilyPond (`.ly`) y ABC (`.abc`) en el análisis, el coral y los
  arpegios: `FicheroParaExportar.Formato.lilyPond` y `.abc`, con sus textos en los catorce idiomas.
- La tablatura en MusicXML escapa sus textos con `EscrituraXML.escapar`, la del motor.
- Los textos con un número usan `Idioma.contar`, con el plural de cada idioma: en francés, «0 note par corde»
  en vez de «0 notes». El selector de idioma recorre `Idioma.allCases`.
- Desaparece `TextoDeLasApps`: sus casos solo llevaban a un campo de `TextosDeApps`, que pasa a ser público. Un texto
  de las apps se lee con `notacion.texto(\.digitaciones)` o `notacion.texto { $0.notasPorCuerda(3) }`, y los campos
  con ejemplos en la notación con `notacion.campo(.cifrado)` (`CampoDeLasApps`). `TextosDeApps.dedosYCejilla(_:_:)`,
  `capoEnElTraste(_:)` y `casillaElegida(q:r:)` juntan los textos compuestos. Los textos no cambian.
- `Idioma.titulo` es el `nombrePropio` del motor y `Idioma.clave`, su `rawValue`: las claves guardadas en los ajustes
  no cambian.
- `TextosDeApps` adopta `TextosTraducidos` del motor; `TextosDeApps.traduccion(_:)` sigue igual.
- El selector de notación de las apps tiene un interruptor «Octava en subíndice» (La₄), traducido a los catorce
  idiomas. Se guarda aparte, en `AjustesDeLasApps.claveDeOctavasEnSubindice`, y `notacionGuardada()` lo aplica con
  `Notacion.desde(clave:octavasEnSubindice:)`. `SelectorDeNotacion` acepta el binding `octavasEnSubindice:`.

## 0.2.0 (2026-10-31)

- Arreglado: en macOS, sin optimizar, los textos de las apps desbordaban la pila (señal 11). Pasaba en las pruebas
  de ArmoniaUI y en Tonnetz al elegir «Acorde». Cada caso de `TextoDeLasApps` copiaba en la pila los catorce
  `TextosDeApps`; ahora la copia es una, en `TextosDeApps.traduccion(_:)`.
- Revisión de la terminología de la API. Los nombres viejos siguen compilando, marcados como obsoletos, y se quitarán
  en la próxima versión:
  - `PresentacionDePentagrama` pasa a `PentagramaPresentado` y `PresentacionPostonal`, a `AnalisisPostonalPresentado`,
    como los demás resultados (`AnalisisPresentado`, `CoralPresentado`…); las `PresentacionDe…` son las que preparan.
  - `AnalisisPresentado.rearmonizaciones(notacion:)` pasa a `rearmonizaciones(en:)`, como las demás funciones que
    reciben una `Notacion`.
  - `Sonido` pasa a `Escucha`: es lo que suena al pulsar «Escuchar», y «sonido» es también otro nombre de la altura.
  - `Reproductor`, `SelectorDeNotacion` y `Escucha.afinado(en:)` usan `AfinacionHistorica`, el nombre nuevo de
    `Temperamento`.
- VoiceOver numera las cuerdas del mástil como quien toca: en la guitarra, el Mi grave es la cuerda 6 (antes, la 1).
- Documentación de DocC para `ArmoniaUI` y `ArmoniaPresentacion`: una página de entrada por módulo, con un ejemplo y
  los tipos agrupados por tarea, publicada en GitHub Pages junto a la de Armonia y Hexagonos.
- `RedDeNotas` toma el teclado y el nombre de cada red de `TecladoIsomorfico.todos` y `nombre(en:)` del motor.
- Los textos de las apps (`TextoDeLasApps`, los avisos y las tareas del coral y los nombres de los formatos de
  exportación) pasan a `TextosDeApps`, un fichero por idioma en `ArmoniaPresentacion/Textos/`, como los del motor.
  Los textos no cambian.
- Más opciones de arpegio en ArmoniaApp. En la pestaña Acordes, el arpegio elige también cuántas octavas abarca, si
  acaba en la octava y la figura de sus notas (negra, corchea o semicorchea); en Análisis, la figura de la progresión
  arpegiada. `PresentacionDeArpegios.arpegio(_:figura:notacion:)`, `progresion(…figura:…)` y
  `AnalisisPresentado.arpegiada(_:figura:notacion:)`.
- Seguir lo que suena. El `Reproductor` publica lo que suena y el paso por el que va (`paso(de:)`), y «Escuchar» pasa
  a «Detener» mientras suena. Se resalta el acorde que se oye en Análisis y la nota en los pentagramas del arpegio y
  de la escala y en los mástiles de las posiciones. `Sonido.inicios` y `paso(en:)`,
  `PresentacionDePentagrama(…resaltada:)` y `DiagramaDeMastil.resaltando(_:)`.
- Transponer. Análisis lleva la progresión a otra tonalidad del mismo modo (la abierta de un fichero, con su ritmo) y
  Coral sube o baja lo escrito un intervalo. `PresentacionDeTransposicion`.
- Capo y tablaturas. Las digitaciones y el arpegio en el mástil de la pestaña Acordes se calculan con capo, y se
  exportan como tablaturas MusicXML (cuerda, traste, afinación y capo) para MuseScore o Guitar Pro.
  `PresentacionDeTablatura`.
- Rearmonizar. En Análisis, cada acorde con sus otras armonías: cómo suena el pasaje con el cambio y «Aplicar», que lo
  pone en la progresión. `PresentacionDeRearmonizacion` y `AnalisisPresentado.rearmonizaciones(notacion:)`.
- En la línea de comandos: `transponer` (un intervalo o la nueva tónica; acordes, melodías o corales), `rearmonizar`,
  `digitaciones --capo 2` y `digitaciones --musicxml` (la tablatura), y los patrones `quebrado` y `baja-y-sube`.
- Los teclados Gerhard y Park en la app Tonnetz: `RedDeNotas.gerhard` y `RedDeNotas.park`, en el selector de la red,
  con su dibujo y sus notas para tocar. Bosanquet-Wilson no se añade aparte porque, en 12 notas, es el Jankó.
- Ritmo armónico al importar. En la pestaña Análisis, «Abrir» acepta también el MusicXML comprimido (.mxl) y guarda
  lo que dura cada acorde de la pieza, con su compás y su tempo: mientras no se retoque la progresión, lo siguen la
  partitura, el MIDI, «Escuchar» y «Arpegiar». `ImportacionDeProgresion.leer(_:ventana:)` da la
  `ProgresionImportada` (acordes, `RitmoArmonico` y título); `PresentacionDeAnalisis.analizar(_:ritmo:en:notacion:)`
  y `analizar(_ importada:…)` la analizan; `PresentacionDeArpegios.progresion(…ritmo:…)` la arpegia, y
  `Sonido.acordes(_:duraciones:tempo:)` la toca.
- Escalas por posiciones en ArmoniaApp. En la pestaña Escalas, la sección nueva «Posiciones en el mástil» da la escala
  en la guitarra en las cinco formas CAGED o con tres notas por cuerda (dos en las pentatónicas), cada posición con sus
  trastes, su diagrama y «Escuchar». `DiagramaDeMastil(posicion:escala:…)` la dibuja; textos nuevos
  `.posicionesEnElMastil`, `.notasPorCuerda(_:)` y `.forma(_:)` en los catorce idiomas.

## 0.1.0 (2026-10-31)

Primera versión con etiqueta del repositorio: `0.1.0`.

- Arpegios en ArmoniaApp. En la pestaña Acordes, «Exportar» da también el arpegio en MusicXML, MEI y MIDI, y la
  sección nueva «Arpegio en el mástil» lo enseña en el instrumento elegido para las digitaciones: las notas del
  acorde por todo el mástil y, debajo, cada posición (una franja de cuatro trastes) con su diagrama y «Escuchar». En
  la pestaña Análisis, «Arpegiar» toca la progresión arpegiada con el patrón elegido (una blanca por acorde, en
  corcheas), y «Exportar» la añade en MusicXML, MEI y MIDI.
- `PresentacionDeArpegios` (en `ArmoniaPresentacion`) da un arpegio o una progresión arpegiada como
  `ArpegioPresentado`: la voz, el sonido y los ficheros. `AnalisisPresentado` guarda sus `acordes` y su `tonalidad`, y
  `arpegiada(_:notacion:)` la arpegia. `DiagramaDeMastil(mastil:acorde:…)` dibuja las notas de un acorde por todo el
  mástil y `DiagramaDeMastil(arpegio:acorde:…)`, un `ArpegioEnElMastil`. Textos nuevos en los catorce idiomas:
  `.arpegioEnElMastil`, `.trastes(desde:hasta:)` y `.arpegiar`.

- El paquete pide Swift 6.0 o posterior y compila en el modo de lenguaje 6, como las apps (`SWIFT_VERSION` 6.0 en
  `project.yml`). Antes pedía Swift 5.9.
  `VistaSVG` crea y carga su `WKWebView` en el actor principal (`@MainActor`), como pide WebKit: así no da
  avisos de concurrencia con Swift 6.

- «Abrir» en la pestaña Análisis de ArmoniaApp: elige un fichero MIDI o MusicXML y sus acordes, uno por pulso, pasan
  al campo de la progresión, que se analiza (y se puede retocar) como si se hubiera escrito.
  `ImportacionDeProgresion.progresion(de:)`, en `ArmoniaPresentacion`, hace la lectura; los errores se muestran con
  `Notacion.mensaje(de:)`, que ya explica también los de `ErrorDeImportacion`. En macOS, la app pide permiso de
  lectura de los ficheros que se eligen (`ENABLE_USER_SELECTED_FILES`).
- `PresentacionDeAnalisis.analizar(_:en:notacion:)` acepta también los acordes ya leídos (`[Acorde]`), como los de un
  fichero MIDI o MusicXML importado; devuelve `nil` si no hay ninguno.

- Teclado MIDI: `EntradaMIDI` (CoreMIDI) escucha todas las fuentes MIDI del sistema y publica las teclas pulsadas;
  `CambioMIDI`, en `ArmoniaPresentacion` y sin CoreMIDI, lee los mensajes UMP de MIDI 1.0, lleva la cuenta de lo
  pulsado y retiene el último acorde al soltarlo. En ArmoniaApp, lo tocado en el teclado se identifica en la
  pestaña «Identificar» (con el número de fuentes conectadas); en la app Tonnetz, se marca en el modo «Identificar».
- Teoría postonal: `PresentacionPostonal` da la forma prima, el número de Forte y el vector interválico de unas
  notas. «Identificar» los muestra en ArmoniaApp, y el número de Forte, en la app Tonnetz.
- Las pestañas de ArmoniaApp se enlazan (`Navegacion`, en la app): «Ver en Acordes» lleva el acorde identificado a
  la pestaña de acordes, y cada escala compatible de un acorde se abre en la de escalas.
- Textos nuevos de las apps, en los catorce idiomas: `.verEnAcordes`, `.tecladoMIDI`, `.dispositivosMIDI`,
  `.teoriaPostonal`, `.formaPrima`, `.numeroDeForte` y `.vectorIntervalico`.
- Arpegios en ArmoniaApp: la pestaña de acordes muestra el arpegio en el patrón que se elija (ascendente,
  descendente, de ida y vuelta o bajo de Alberti), con su pentagrama, que también se exporta, y «Escuchar», y las
  escalas compatibles con el acorde (Sol7 → Sol mixolidio…). `Sonido.arpegio(_:paso:)` toca un arpegio nota a nota
  desde la octava 3, y `PresentacionDePentagrama(_ arpegio:)` da su pentagrama.
- Identificar un acorde tocando sus notas. ArmoniaApp tiene una pestaña nueva, «Identificar», con el mástil del
  instrumento elegido: se toca una nota por cuerda (otra vez para quitarla), el bajo es la más grave y se ven las
  lecturas más probables. En la app Tonnetz, el modo «Identificar» hace lo mismo en el Tonnetz, la tabla armónica
  y los teclados isomórficos, con la primera nota tocada como bajo. `DiagramaDeMastil.alTocar(_:)` avisa de la
  posición tocada; `ContenidoDeRed.clases(_:)`, `PresentacionDeRedes.alternar(_:en:)` y
  `PresentacionDeRedes.acordes(de:)` son lo que usa la app Tonnetz.
- Textos nuevos de las apps, en los catorce idiomas: `.arpegio`, `.patron`, `.escalasCompatibles`, `.identificar`,
  `.tocaElMastil`, `.tocaNotas`, `.borrar` y `.sinAcordeConocido`.

- `RedDeNotas.uil` y `AjusteUIL`: un teclado isomórfico descrito en el formato UIL (`2,7,5;R30M`), con giro de 30° en
  30° (`giros`) y espejo; `PresentacionDeRedes.svg`, `midi` y `nombre` toman un `uil:`. La app Tonnetz ofrece el campo
  de texto, un menú con los teclados del artículo, el giro y el espejo. Textos nuevos: `.formatoUIL`, `.giro` y
  `.espejo`, en los catorce idiomas. Un texto no válido no se dibuja.

- `RedDeNotas` suma `.wickiHaydenEspejo`, `.wickiHaydenPlano`, `.acordeonC` y `.acordeonB`, con su nombre en los catorce
  idiomas; la app Tonnetz los ofrece. Los teclados de hexágonos planos se dibujan en un rectángulo de columnas
  (`PresentacionDeRedes.casillasDelTecladoPlano`), no en uno de filas.
- `DiagramaDePentagrama` muestra el pentagrama de una escala o de un acorde (con `VistaSVG`), y
  `PresentacionDePentagrama`, que no usa SwiftUI, da el SVG, su proporción, el texto para los lectores de pantalla y
  el fichero SVG para `BotonDeExportar`. ArmoniaApp lo muestra en las pestañas de escalas y de acordes y lo exporta.
  Texto nuevo de las apps: `.pentagrama`, en los catorce idiomas.
- `VistaSVG(svg:adaptable:)`: con `adaptable`, la página usa los colores del sistema (modo claro u oscuro) en vez del
  fondo blanco fijo; lo usa `DiagramaDePentagrama`, que además tiene `alturaMaxima`.
- En el selector de notación, cada entrada se llama como su idioma con un ejemplo escrito con ella, que ahora
  se genera: «Español (Fa sostenido)», «English (F#)», «Deutsch (Fis)». La única que cambia es «Español ASCII
  (Fa#)», que pasa a «Español (Fa#)», como la inglesa. Las claves guardadas no cambian.

- El selector de notación ofrece las tres modalidades del español y del inglés: «Español (Fa sostenido)»,
  «Español ASCII (Fa#)», «Español (Fa♯)», «English (F sharp)», «English (F#)» y «English (F♯)». La clave con
  que se guarda cada una es el nombre de su caso («espanol», «espanolASCII», «espanolUnicode», «ingles»,
  «inglesASCII», «inglesUnicode»), así que lo guardado antes como «espanol» (Fa♯) o «ingles» (F#) pasa a
  leerse con palabras; basta con volver a elegirla en el selector.

- Los identificadores de las apps empiezan por `es.solfa.tesela`, el dominio del proyecto (tesela.solfa.es)
  al revés.

- Las apps declaran sus catorce idiomas (`Config/Idiomas.plist`, unido al Info.plist, y una carpeta
  `<idioma>.lproj` por idioma en `Apps/<App>/Idiomas`), con el español como idioma de desarrollo: el sistema pone
  sus propios textos (Compartir, Cancelar…) en el idioma del usuario y la App Store los lista.

- Las dos apps llevan un manifiesto de privacidad (`Config/PrivacyInfo.xcprivacy`), que exige la App Store: no
  rastrean ni recogen datos, y declaran el uso de `UserDefaults` para los ajustes (motivo CA92.1).

- `TemaDeLasApps.acento` pasa del violeta al azul de las notas de los dibujos del Tonnetz (#1f4e9c), así que el
  mástil, la rejilla y los dibujos de las redes usan el mismo color.

- `Tema.swift` pasa a llamarse `TemaDeLasApps.swift`, como su tipo, y las pruebas de `ArmoniaUITests.swift` se
  reparten en `VistaSVGTests.swift`, `NotacionTests.swift` y `PresentacionDeMastilTests.swift`.

- El selector de notación y el de idioma de los textos siguen el orden nuevo de los idiomas: español, inglés,
  catalán, gallego, asturiano, aragonés, euskera, portugués, francés, occitano, italiano, alemán, griego y ruso.
  Los ajustes guardados se conservan.

- «Escuchar» suena en el temperamento que se elija en el menú de la notación («Afinación al escuchar»): igual,
  pitagórico, mesotónico, Werckmeister III, Kirnberger III, Vallotti, Young o justo sobre la tónica. Se guarda en
  `AjustesDeLasApps.claveDeTemperamento`. El `Reproductor` toca cada nota en su propio sampler, afinado por su lado.
- `Sonido.NotaMIDI` guarda la `altura` escrita (el `midi` sale de ella) y su `desviacion` en cents, y
  `Sonido.Cambio`, la `nota` y la `desviacion`. `Sonido` lleva la `tonica` (la del acorde, la escala o la
  tonalidad), y `afinado(en:)` y `conTonica(_:)`. `Sonido.nota(_:)` acepta también una `Altura`.
- `SelectorDeNotacion(clave:temperamento:)`, con el temperamento opcional.
- `FicheroParaExportar.Formato.mei` y `FicheroParaExportar.mei(_:nombre:)`: el menú de exportar de los corales y
  del análisis ofrece también la partitura en MEI («Partitura MEI», `.mei`), entre la de MusicXML y el MIDI.

- Las apps están también en aragonés y asturiano: el selector de notación ofrece «Aragonés (fa sosteniu)» y
  «Asturianu (fa sosteníu)», y un sistema en `an` o `ast` los elige solo.

- `Encordado.nombre(en:)`, `Encordado.titulo(en:)` y `TransformacionNeorriemanniana.nombre(en:)` pasan a la
  biblioteca Armonia. Se usan igual, porque las apps ya la importan.

- `Sonido.Cambio.empieza` pasa a ser `esInicio`, como los demás booleanos. Sin alias.

- Los textos de las apps (`TextoDeLasApps`, tareas, formatos, instrumentos, transformaciones y redes) están
  también en alemán, occitano, ruso y griego, que antes salían en inglés.

- Más nombres claros, sin alias: el tema y los ajustes pasan a llamarse `TemaDeLasApps` y
  `AjustesDeLasApps` (los ajustes guardados se conservan), `DiagramaHexagonal` y `PresentacionHexagonal`,
  `DiagramaDeRejilla` y `PresentacionDeRejilla`, y `Sonido.eventos` y `Sonido(eventos:)`, `Sonido.notas` y
  `Sonido(notas:)`.

- Desaparecen los nombres marcados como obsoletos: `MastilView`, `TonnetzView` y `SVGView` (son `DiagramaDeMastil`,
  `DiagramaDeTonnetz` y `VistaSVG`), `toolbarNotacion(clave:)` (es `selectorDeNotacionEnLaBarra(clave:)`) y
  `campoDeCifrado()` (es `comoCampoDeCifrado()`).

- El paquete pasa a llamarse `ArmoniaUI` (`Packages/ArmoniaUI`), y sus módulos `ArmoniaUI` y
  `ArmoniaPresentacion`. En el código es `import ArmoniaUI`, y
  en un `Package.swift`, `.product(name: "ArmoniaUI", package: "ArmoniaUI")` (o `package: "Tesela"` desde la
  raíz). Los ajustes guardados se conservan.

- Nombres más claros, sin alias porque son recientes: `Sonido.Evento` pasa a ser `Sonido.NotaMIDI` (ya no
  tapa el `Evento` del ritmo), `Sonido.alturas(_:)` y `alturas(_:conElRitmoDe:)` pasan a ser `Sonido.coral(_:)` y
  `coral(_:conElRitmoDe:)`, `AnalisisPresentado.Tramo` pasa a ser `TramoPresentado` (como `AnalisisPresentado`
  y `CoralPresentado`, y para no confundirlo con `TramoTonal`) y `PresentacionDeRedes.midi(en:de:en:)` pasa a
  ser `midi(en:de:enLaRed:)`.
- Las vistas de las apps llevan «De» como el resto de tipos: `VistaDeAcordes`, `VistaDeEscalas`,
  `VistaDeAnalisis`, `VistaDeCoral` y `VistaDeTonnetz`. La herramienta de rendimiento pasa a llamarse
  `RendimientoArmonia` (`Herramientas/RendimientoArmonia`), en el mismo orden que `EjemploArmonia`.
- Usa los nombres nuevos del motor: `Notacion` (antes `Nomenclatura`), `Coral` (antes `ConduccionDeVoces`) y
  `texto(en:)`. `Nomenclatura+Apps.swift` pasa a ser `Notacion+Apps.swift`; la API no cambia.

Componentes de SwiftUI para las apps de Tesela, sobre `Armonia` y `Hexagonos`:

- `DiagramaDeMastil`: el mástil con una escala o una digitación, y `PresentacionDeMastil`, la parte que no es
  dibujo (qué trastes y cuerdas se enseñan).
- `DiagramaDeTonnetz` y `VistaSVG`: los dibujos SVG del motor en una vista.
- `DiagramaHexagonal` y `PresentacionHexagonal`: rejillas hexagonales interactivas.
- `SelectorDeNotacion` y `AjustesDeLasApps`: la notación (española o inglesa) que comparten las apps, con
  `selectorDeNotacionEnLaBarra(clave:)` para ponerla en la barra de herramientas.
- `comoCampoDeCifrado()`: ajusta un campo de texto para escribir cifrados.
- `TemaDeLasApps`: colores y medidas comunes.
- `PresentacionDeAnalisis`, `PresentacionDeCoral` y `PresentacionDeRedes`: lo que enseñan las vistas de análisis
  (con modulaciones y cadencias), de corales (armonizar, realizar y revisar) y de redes (Tonnetz, tabla armónica y
  teclados isomórficos), en texto y SVG, sin SwiftUI.
- `FicheroParaExportar` y `BotonDeExportar`: un menú que comparte partituras MusicXML, ficheros MIDI y dibujos SVG.

En Linux solo compila la lógica que no usa SwiftUI.

### Sonido

- `Sonido` (en `ArmoniaPresentacion`): qué notas MIDI suenan y cuándo, para un acorde (arpegiado y luego
  junto, desde su bajo), una escala, una progresión o un coral. `AnalisisPresentado` y `CoralPresentado` traen
  el suyo.
- `Reproductor` y `BotonDeEscuchar`: lo tocan con el sintetizador del sistema (`AVAudioUnitSampler`; en macOS
  con el piano General MIDI del sistema). Las apps tienen «Escuchar» en Acordes, Escalas, Análisis, Coral y
  Tonnetz.
- `Sonido.voz(_:tempo:)` toca una `Voz` con su ritmo (los silencios callan y las ligadas no vuelven a empezar),
  y `Sonido.alturas(_:conElRitmoDe:)`, un coral con el ritmo de una voz. Al armonizar, la melodía puede llevar
  ritmo («Mi4:2 Re4:4 Do4:4»): se armonizan sus notas y el coral suena con ese ritmo. `Sonido.nota(_:)`, una
  nota sola.
- `alTocarElSVG(_:_:)` avisa de dónde se toca una `VistaSVG`, en las coordenadas del dibujo, y
  `PresentacionDeRedes.midi(en:de:en:)` dice qué nota hay ahí: en la app Tonnetz, tocar una nota del Tonnetz, de
  la tabla armónica o de un teclado isomórfico la hace sonar.

### Textos

- `Encordado.nombre(en:)` y `titulo(en:)`, y `TransformacionNeorriemanniana.nombre(en:)`: los instrumentos y las
  transformaciones P, L y R en los ocho idiomas de los textos.
- Lo que lee VoiceOver en `DiagramaDeMastil`, `DiagramaHexagonal` (con la notación del entorno) y
  `DiagramaDeTonnetz` va en el idioma de los textos.

### Apps traducidas y ayudantes comunes

- `TextoDeLasApps` (en `ArmoniaPresentacion`): los textos de la interfaz de las dos apps en los ocho idiomas
  de los textos del motor, con los ejemplos de las indicaciones escritos en la notación elegida. Siguen el
  idioma de los textos de la notación, así que el selector cambia la app entera. También se traducen las
  tareas del coral (`Tarea.titulo(en:)`, `indicacion(en:)`), los formatos para exportar
  (`Formato.titulo(en:)`), las redes (`RedDeNotas.nombre(en:)`), el selector y el menú «Exportar».
- La notación va en el entorno: `notacionGuardada()` en la raíz de cada app la lee de los ajustes, las vistas
  usan `@Environment(\.notacion)` y `selectorDeNotacionEnLaBarra()` ya no necesita la clave.
- Si aún no se ha elegido notación, se usa la del idioma del sistema (`Nomenclatura.delSistema()`).
- `calcularEnSegundoPlano(para:esperando:en:_:)`, `Calculado` y `FilaCalculando`: el cálculo con espera
  mientras se escribe, fuera del hilo principal y con «Calculando…», que repetían Acordes y Coral.

### Presentación compartida con la línea de comandos

- `PresentacionDeAnalisis`, `PresentacionDeCoral` y `FicheroParaExportar` pasan al módulo `ArmoniaPresentacion`
  (producto del mismo nombre), que no usa SwiftUI. `ArmoniaUI` lo reexporta, así que las apps no cambian, y
  `armonia analizar`, `armonizar`, `realizar` y `revisar` lo usan en lugar de montar el resultado por su cuenta.
- `PresentacionDeAnalisis.analizar(_:en:notacion:)` acepta una tonalidad dada, y entonces no busca modulaciones.
- `CoralPresentado.avisos` son ahora `CoralPresentado.Aviso` en lugar de textos fijos en español:
  `texto(en:)` los escribe en el idioma de la notación. Los de «sin armonización», «sin realización» y «sin
  faltas» son los mismos que ya escribía la línea de comandos.
- `PresentacionDeCoral.armonizar`, `realizar` y `revisar` son públicas.

### Nombres

Los nombres anteriores estuvieron marcados como obsoletos y ya se han quitado.

- `toolbarNotacion(clave:)` pasa a `selectorDeNotacionEnLaBarra(clave:)`, sin mezclar inglés y español.
- `campoDeCifrado()` pasa a `comoCampoDeCifrado()`: no crea un campo, ajusta el que ya hay.
