# Cambios

## Sin publicar

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
