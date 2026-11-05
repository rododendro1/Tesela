# Escalas

Tipos de escala, modos, modos gregorianos, escalas que suben y bajan distinto, y escalas de la
India, Grecia (moderna y antigua), China, Japón, Corea, Etiopía, el mundo árabe, Persia, Indonesia,
los Andes y el klezmer.

## Más escalas y tonalidades

- Modos de la menor armónica (locrio ♮6, jónico ♯5, dórico ♯4, frigio dominante,
  lidio ♯2, ultralocrio) y de la melódica (dórico ♭2, lidio aumentado, lidio dominante,
  mixolidio ♭6, locrio ♮2, alterada), la mayor armónica y sus modos (dórico ♭5, frigio ♭4,
  lidio ♭3, mixolidio ♭2, lidio aumentado ♯2, locrio ♭♭7) y cinco escalas bebop (dominante,
  mayor, dórica, menor melódica y menor armónica).
- Escalas de colores «exóticos»: doble armónica (bizantina), menor y mayor húngaras,
  napolitanas menor y mayor, enigmática (Verdi), persa, mayor locria (árabe), lidio menor y
  Prometeo (Skriabin).
- Simétricas y otras: disminuida semitono-tono (además de la tono-semitono), aumentada, blues
  mayor, egipcia (pentatónica suspendida), Petrushka (dos acordes mayores a un tritono) y
  cromática. Los modos de Messiaen 1 y 2 se leen como tonos enteros y disminuida
  semitono-tono, y del 3 al 7 tienen tipo propio (el 3 es también la escala de nueve notas de
  Tcherepnin).
- La escala flamenca o andaluza: el frigio con la tercera mayor y la menor, de ocho notas.
- Los modos de la doble armónica (lidio ♯2 ♯6, ultrafrigio, menor húngara, oriental,
  jónico ♯2 ♯5, locrio ♭♭3 ♭♭7), de la napolitana mayor (lidio aumentado ♯6 o tonos enteros
  con sensible, lidio dominante aumentado, lidio menor, mayor locria, locrio ♮2 ♭4,
  superlocrio ♭♭3) y de la napolitana menor (lidio ♯6, mixolidio aumentado, eólico ♯4 o
  gitana húngara, locrio dominante, jónico ♯2, ultralocrio ♭♭3).
- Los modos de la mayor húngara: ultralocrio ♭♭6, menor armónica ♭5, superlocrio ♮6 (la
  alterada con 6ª mayor), menor melódica ♯5, dórico ♭2 ♯4 y lidio aumentado ♯3.
- La mayor rumana (Do Re♭ Mi Fa♯ Sol La Si♭), del folclore balcánico.
- Pentatónicas del jazz: dominante, menor 6 (dórica), mayor ♭6 (de Coltrane) y menor ♭5; la
  mixolidia (Do Mi Fa Sol Si♭), la lidia (Do Mi Fa♯ Sol Si) y la escocesa (Do Re Fa Sol La, la
  pentatónica mayor desde su 4.º grado); la blues de nueve notas y la blues menor con 2ª.
- Hexatónicas gaélicas, los modos con un hueco de la música escocesa e irlandesa: jónico sin 4ª,
  mixolidio sin 3ª, dórico sin 6ª y eólico sin 2ª. Y las de dos tríadas, mayores a un tono
  (Do + Re: Do Re Mi Fa♯ Sol La) o menores (Rem + Mim: Re Mi Fa Sol La Si).
- El hexacordo de Guido (ut re mi fa sol la), con `Escala.hexacordoNatural` (Do),
  `hexacordoDuro` (Sol) y `hexacordoBlando` (Fa).
- La argelina, de ocho notas: la menor húngara con la 4ª justa además de la aumentada.
- Otros nombres de escalas que ya estaban: acústica o de Bartók (lidio dominante), menor
  rumana (dórico ♯4), dominante ♭9 ♭13 (frigio dominante), mayor melódica (mixolidio ♭6),
  gitana española (flamenca), nordestina (lidio dominante, la del baião), las que llevan el
  nombre de quien las popularizó (de Liszt = menor húngara, de Rimski-Kórsakov = disminuida
  semitono-tono, de Debussy = tonos enteros, de Weitzmann = aumentada) y las
  auxiliares de la cromática lidia de George Russell (aumentada auxiliar = tonos enteros,
  disminuida auxiliar = disminuida, disminuida auxiliar blues = semitono-tono). La cromática
  lidia en sí tiene las doce notas: es la cromática ordenada por quintas. Y los de los conservatorios
  españoles: menor bachiana o de Bach (menor melódica de jazz, la que sube y baja igual), menor dórica
  (dórico) y menor antigua (menor natural).
- Todas se leen también en inglés ("E phrygian dominant", "G altered", "A hungarian minor").

```swift
Escala(.do, .dobleArmonica).notas      // Do Re♭ Mi Fa Sol La♭ Si
Escala("Do enigmática").notas          // Do Re♭ Mi Fa♯ Sol♯ La♯ Si
Escala("La menor húngara").nombre(en: .inglesASCII)   // "A hungarian minor"
TipoDeEscala.mayorArmonica.rotacion(4).nombre    // "lidio ♭3"
TipoDeEscala.dobleArmonica == .hitzazkiar        // true
Escala("Mi flamenca").notas                      // Mi Fa Sol Sol♯ La Si Do Re
Escala("Do modo 3 de Messiaen").notas            // Do Re Mi♭ Mi Fa♯ Sol La♭ Si♭ Si
Escala("Re menor rumana").tipo.nombre            // "dórico ♯4"
TipoDeEscala.dobleArmonica.rotacion(5).nombre    // "oriental"
Escala.hexacordoBlando.notas                     // Fa Sol La Si♭ Do Re
TipoDeEscala.mayorHungara.rotacion(4).nombre     // "superlocrio ♮6"
Escala("Do pentatónica escocesa").notas          // Do Re Fa Sol La
Escala("La de Liszt").tipo.nombre                // "menor húngara"
Escala("Do menor bachiana").notas                // Do Re Mi♭ Fa Sol La Si
```
- `Escala.candidatos(_:)` y `candidatos(clasesDeAltura:)`: qué escalas contienen unas notas, de más a menos
  probable (menos notas sobrantes y menos alteraciones); `identificar` da solo las escalas.
- `notasDeLaArmadura` (Mi♭ mayor → Si♭, Mi♭, La♭), `Escala(armadura:tipo:)`,
  `circuloDeQuintas(_:)`, `distancia(hasta:)` y `enarmonicaMasSimple` (Do♯ → Re♭ mayor),
  también para los modos. Para las relaciones entre tonalidades, mira `Tonalidad`.
- `nombreDeGrado(_:)` y `nombreDeGrado(de:)`: tónica, supertónica… sensible o subtónica.

## Cromáticas por ventana de quintas

Una escala cromática escrita son doce quintas seguidas de la línea de quintas, contadas desde la
tónica (Fa = −1, Do = 0, Sol = 1): doce quintas seguidas dan las doce clases de altura sin repetir
ninguna. Para que la escala mayor de la tónica quede dentro, la ventana empieza entre −6 y −1, así
que hay seis. Cada una cambia una nota de la anterior de bemol a sostenido, por el orden de la
línea de quintas: Sol♭ → Fa♯, Re♭ → Do♯, La♭ → Sol♯, Mi♭ → Re♯ y Si♭ → La♯.

| Ventana | Tipo | En Do |
|---|---|---|
| −6…5 | `cromaticaConCincoBemoles` | Do Re♭ Re Mi♭ Mi Fa Sol♭ Sol La♭ La Si♭ Si |
| −5…6 | `cromatica` (`cromaticaConCuatroBemoles`) | Do Re♭ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si |
| −4…7 | `cromaticaConTresBemoles` | Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol La♭ La Si♭ Si |
| −3…8 | `cromaticaConDosBemoles` | Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si |
| −2…9 | `cromaticaConUnBemol` | Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si |
| −1…10 | `cromaticaConCincoSostenidos` | Do Do♯ Re Re♯ Mi Fa Fa♯ Sol Sol♯ La La♯ Si |

Se nombran por sus bemoles, porque los sostenidos son siempre los que faltan hasta cinco. Se leen
por el nombre, en cada idioma, o por la ventana («cromática −3…8», «cromatica -3..8»). Como se
cuentan desde la tónica, en Re la primera empieza Re Mi♭ y la última, Re Re♯. Con una de ellas,
cada clase de altura se escribe como dice su ventana:

```swift
TipoDeEscala.cromaticasPorQuintas.count                     // 6
TipoDeEscala.cromatica(desdeLaQuinta: -5) == TipoDeEscala.cromatica   // true
Escala(.re, .cromaticaConCincoSostenidos).notas             // Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si Si♯ Do♯
Escala("Do cromática con dos bemoles").notas                // Do Do♯ Re Mi♭ Mi Fa Fa♯ Sol Sol♯ La Si♭ Si
Escala("Do cromatica -6..5").tipo.nombre                    // "cromática con cinco bemoles"
Escala(.do, .cromaticaConCincoSostenidos).nombre(claseDeAltura: 10)   // La♯
```

## Clásica, jazz, blues: el uso de una escala

Las notas no dicen de qué música es una escala: la menor melódica de jazz es la «bachiana» de los conservatorios, y
el lidio dominante es la acústica de Bartók. Lo dice el uso, y `TipoDeEscala.usos` lo da para cada escala de
`todos`, con uno o varios `UsoDeEscala`:

- **clásica**: la escala da la tonalidad y de ella sale la armonía (la mayor, las menores, los modos, las
  napolitanas, la cromática, el hexacordo).
- **jazz**: la escala se elige acorde a acorde (los modos de la menor melódica, las bebop, las disminuidas, las
  pentatónicas del jazz y las de dos tríadas, y los siete modos de la mayor).
- **blues**: las blues y las pentatónicas de las que salen.
- **siglo XX**: las simétricas y las de compositor (tonos enteros, disminuidas, Messiaen, Prometeo, Petrushka, la
  acústica, la cromática).
- **popular**: las que vienen de una música popular (flamenca, mayor rumana, menor húngara, pentatónicas, gaélicas).
- **sintética**: las que salen de rotar o alterar otra, sin repertorio propio (casi todos los modos de la menor y la
  mayor armónicas, de la doble armónica y de las napolitanas).

`TipoDeEscala.todos(uso:)` da las de un uso, en el orden de `todos`, y en la línea de comandos `armonia escalas --uso
jazz` las lista. Las escalas de otras tradiciones no tienen uso: se clasifican por su tradición.

```swift
TipoDeEscala.dorico.usos == [.clasica, .jazz]    // true
TipoDeEscala.todos(uso: .blues).count            // 6
UsoDeEscala.sigloXX.nombre                       // "siglo XX"
TipoDeEscala.kafi.usos.isEmpty                   // true
```

## Escalas de otras tradiciones

Escalas de otras tradiciones, en su versión temperada (en la práctica, sobre todo los dromoi
usan microtonos):

- **Los 72 mēḷa** de la música carnática, generados por su regla: Sa y Pa fijos, Ma (4ª
  justa o aumentada) y una de seis parejas Ri–Ga y Dha–Ni. Ri3, Ga1, Dha3 y Ni1 se escriben
  como 2ª aumentada, 3ª disminuida, 6ª aumentada y 7ª disminuida.
- **Los 10 thāṭ** de la música indostánica: Bilāval, Kalyāṇ, Khamāj, Kāfī, Āsāvarī, Bhairavī,
  Bhairav, Mārvā, Pūrvī y Toḍī.
- **15 dromoi** griegos: Ousák, Hitzáz, Hitzazkiár, Pireótikos, Tabahaniótikos, Niavént,
  Nikríz (Souzinak), Kartzigár, Sabáh, Houzám, Sengáh, Tsingánikos, Rast, Kiourdí y Houseïní.
  Todos tienen versión microtonal: Ousák y Sabáh, con la segunda neutra de Bayātī y de Ṣabā;
  los demás, en las comas de Arel-Ezgi-Uzdilek, con las notas del makam que tiene las suyas
  (Hicaz, Hicazkâr, Suzinak, Nev'eser, Nikriz, Karcığar, Rast) o, los que solo existen en
  Grecia, con sus tetracordos (la segunda aumentada de Hicaz, la cuarta aumentada de Nikriz).
- **8 escalas chinas**: los cinco modos pentatónicos Gōng, Shāng, Jué, Zhǐ y Yǔ (la pentatónica
  desde cada una de sus notas) y las heptatónicas Qīngyuè, Yǎyuè y Yànyuè (como la mayor, el
  lidio y el mixolidio).
- **13 escalas japonesas**: Ritsu y Ryo, del gagaku; Yō, Min'yō, Miyakobushi, In e Insen, de la
  música popular y urbana; Iwato, Hirajōshi, Kumoijōshi, Akebono y Kokin-jōshi, afinaciones del
  koto; y Ryūkyū, de Okinawa. Las fuentes occidentales describen algunas de varias formas: aquí
  va la más citada.
- **6 qenet etíopes**: Təzəta mayor y menor, Bati mayor y menor, Ambassäl y Ančihoye. Las
  fuentes no coinciden del todo en sus notas: aquí va la versión más citada.
- **18 maqamat árabes**: seis que no necesitan cuartos de tono, Ḥijāz (frigio dominante),
  Nahāwand (menor armónica), Kurd (frigio), ʿAjam (mayor), Ḥijāzkār (doble armónica) y Nawā
  Athar (menor húngara); y doce aproximados, con el cuarto de tono en su letra y redondeado
  como se suele escribir: maqām Rāst (como el dromos Rast), Bayātī (frigio), Ṣabā, Sūznāk
  (mayor armónica), Ḥusaynī (frigio), Nayrūz (menor natural), Bayātī Shūrī (Bayātī con Ḥijāz
  en la cuarta), Jiharkāh (la mayor, con la séptima un cuarto de tono baja), y Sīkāh, maqām
  Huzām, ʿIrāq y Rāḥat al-Arwāḥ, con la tónica en un cuarto de tono, escritos sobre Mi y Si.
  ʿUshshāq Turkī no está: en cuartos de tono es Bayātī.
- **9 ajnas árabes**, los fragmentos de los que se hacen los maqamat, con «jins» delante para no confundirse
  con su maqam: Rāst, Bayātī, Ṣabā y Sīkāh (con cuartos de tono, aproximados como sus maqamat), Ḥijāz y Kurd,
  tetracordos; Sīkāh es un tricordo, y Nahāwand, ʿAjam y Nikrīz, pentacordos.
- **Indonesia**: Pélog selisir (también «balinesa») y Sléndro, y los pathet de Java y los modos de Bali. Siguen
  los modelos de las medidas de Surjodiningrat: el pélog en nueve partes iguales de la octava y el sléndro en
  cinco; en doce notas cada grado va al semitono más cercano desde su tónica (el sléndro, Do Re Fa Sol Si♭), y
  en cents en su versión microtonal.
- **15 rāgas indostánicos** que no son thāṭ: Bhūpālī, Mālkauns, Durgā, Śivarañjanī, Kalāvatī
  (el Valaji carnático), Candrakauns y Megh, pentatónicos; Yaman, Lalit, Pūriyā Dhanāśrī y Darbārī
  Kānaḍa (en su forma recta: es vakra, y su ga y su dha ati-komal no caben en doce notas); y Bāgeśrī,
  Deś, Bhīmpalāsī y Bihāg, que suben y bajan distinto.
- **Los 2 grāma y las 14 mūrchanā** del Nāṭyaśāstra: el ṣaḍja-grāma (el dórico, las razones de Kāfī) y el
  madhyama-grāma (con Pa una coma más bajo), y las siete escalas de cada uno, una desde cada nota: Uttaramandrā,
  Rajanī, Uttarāyatā, Śuddhaṣaḍjā, Matsarīkṛtā, Aśvakrāntā y Abhirudgatā; Sauvīrī, Hariṇāśvā, Kalopanatā,
  Śuddhamadhyā, Mārgī, Pauravī y Hṛṣyakā. En doce notas son los siete modos diatónicos; se distinguen por sus
  microtonos.
- **12 dastgāh y āvāz persas**: Māhur (la mayor) y Rāst-Panjgāh (el mixolidio); Homāyun,
  Čahārgāh y Šur, aproximados (como el frigio dominante, la doble armónica y el frigio); los
  dastgāh Navā y Segāh, este con la tónica en un *koron* (escrito sobre Mi); y los āvāz Bayāt-e
  Tork, Afšāri, Dašti (las notas de Šur), Abu ʿAtā y Bayāt-e Esfahān, con el *koron* en su letra
  y redondeado al bemol, como se suele escribir.
- **27 makamlar turcos**: Rast, Hicaz, Hicazkâr, Nihâvend, Kürdî, Bûselik, Çârgâh, Uşşak,
  Hüseynî, Segâh, Hüzzam, Saba, Karcığar, Suzinak, Nikriz, Nev'eser, Mâhur, Acemaşiran, Sultânîyegâh,
  Şedaraban, Hümâyun, Uzzâl, Zirgüleli Hicaz, Kürdîlihicazkâr, Muhayyer, Ferahfezâ e Isfahan, con
  «makamı» detrás (Rast makamı). Cada nota del sistema de Arel-Ezgi-Uzdilek, de 53 comas, va a su semitono más
  cercano. Uşşak, Hüseynî y Segâh pierden así su segâh (Si una koma bajo), que solo se oye en su
  versión microtonal.
- **12 çeşni turcos**, los dörtlü (tetracordos) y beşli (pentacordos) de Arel-Ezgi-Uzdilek de los que se
  hacen los makamlar: Çârgâh, Bûselik, Kürdî, Rast, Uşşak y Hicaz, cada uno de cuatro y de cinco notas
  (Hicaz dörtlüsü, Hicaz beşlisi).
- **4 mugam azerbaiyanos**, los de Üzeyir Hacıbəyov que ya están en doce notas: Rast, Şur,
  Segah y Çahargah, con «muğamı» detrás. Los tres primeros encadenan tres tetracordos y tienen
  una nota distinta por debajo de la tónica y por encima, así que tienen ocho notas (Rast
  muğamı en Do: Do Re Mi Fa Sol La Si♭ Si).
- **9 echoi bizantinos**, los ocho modos de la salmodia y el légetos: echos prótos (el dórico, sobre Re), plágios
  prótos (el eólico, sobre La), défteros y plágios défteros (la doble armónica, sobre Sol y Re), trítos (la mayor,
  sobre Fa), varýs (el locrio, sobre Si), tétartos (el mixolidio, sobre Sol), plágios tétartos (la mayor, sobre Do)
  y légetos (el frigio, sobre Mi). Cada uno sobre su nota base más habitual, con los nombres en transliteración
  griega (ήχος πρώτος → echos prótos).
- **7 afinaciones babilónicas**, las de la lira y el arpa de los textos cuneiformes (UET VII 74), con el nombre
  del intervalo entre dos cuerdas que las define: išartu (la mayor), kitmu (el mixolidio), embūbu (el dórico),
  pītu (el eólico), nīd qabli (el frigio, la del himno hurrita h.6), nīš tuḫri (el locrio; antes se leía nīš
  gabarî) y qablītu (el lidio). Las notas se reconstruyen, y la reconstrucción se discute: aquí va la de Kilmer
  con las escalas descendentes que siguen Gurney y West desde 1994, desde la cuerda más aguda. En la lectura
  ascendente de 1971 cada nombre era otra especie de octava (išartu, la doria griega).
- **2 escalas coreanas**: P'yŏngjo y Kyemyŏnjo.
- **África**: dos afinaciones de xilófono casi equidistantes, el amadinda de Buganda (cinco partes iguales de
  240 cents, Do Re Fa Sol Si♭ en doce notas) y el timbila de los chopi (siete de 171 cents, el dórico).
- **El sudeste asiático**: las siete partes iguales de la música clásica de Tailandia (piphat) y de Camboya
  (pinpeat), escritas como el timbila.
- **Los 8 modos gregorianos**, con sus nombres latinos (protus authenticus, protus plagalis…), cada uno desde su
  final. Ver «Modos gregorianos», más abajo. Y los tres hexacordos de Guido de Arezzo (hexachordum naturale,
  durum y molle: Ut Re Mi Fa Sol La desde Do, Sol y Fa).
- **Los Andes**: la pentatónica andina (menor) y la tritónica andina (Do Mi♭ Sol).
- **El folklore europeo**: el dórico ucraniano (Do Re Mi♭ Fa♯ Sol La Si♭), la escala podhalańska de los górales
  de los Tatras (Do Re Mi Fa♯ Sol La Si♭), la pentatónica húngara de Bartók y Kodály (la–do–re–mi–sol) y dos
  instrumentos de afinación natural, con su versión en cents: el cuerno alpino (los armónicos del 8.º al 15.º, con
  el «fa del cuerno» de 551 cents) y la gaita escocesa (un mixolidio con la 3ª y la 6ª justas y la 7ª natural de
  7/4). Otras escalas populares de Europa ya están entre las occidentales: la mayor rumana, la menor húngara, la
  flamenca, la pentatónica escocesa y las hexatónicas gaélicas.
- **La Grecia antigua**: los tetracordos diatónico, cromático y enarmónico de Aristóxeno; los géneros de
  Arquitas (cromático y diatónico) y los de Ptolomeo (enarmónico, cromático blando y tenso, diatónico blando,
  ditónico, tenso e igual), con sus razones justas; el enarmónico de Arquitas y los de Dídimo (cromático, diatónico
  y enarmónico) y Eratóstenes (cromático y enarmónico); las siete harmoniai, de la mixolidia a la hipodoria, y la
  doria cromática; las otras seis harmoniai cromáticas y las siete enarmónicas, en la escala de Mi a Mi de cada
  género; y las seis harmoniai de Arístides Quintiliano (lidia, doria, frigia, iastia, mixolidia y sintonolidia),
  que da como las de Platón, de cinco a ocho notas.
- **4 modos del klezmer**: Freygish (Ahavah Rabbah), Misheberakh, Adonai Malakh (mixolidio con
  la 3ª menor de paso) y Magen Avot (menor natural).

Los nombres indios siguen el AITS (Alfabeto Internacional de Transliteración Sánscrita, IAST):
Māyāmālavagauḷa, Ṣaṇmukhapriyā, Mecakalyāṇī. Los griegos llevan el acento de la palabra griega
(Πειραιώτικος → Pireótikos). Los chinos van en pinyin con sus tonos (Zhǐ, Yǎyuè), los japoneses
en Hepburn con macrones en las vocales largas (Hirajōshi, Ryūkyū), los etíopes como en la
Encyclopaedia Aethiopica (Təzəta, Ančihoye), los árabes en ALA-LC (Ḥijāz, ʿAjam) y los de
Indonesia con la grafía javanesa (Pélog, Sléndro), los persas en la transliteración de la
Encyclopædia Iranica (Čahārgāh), los turcos y los azerbaiyanos en su ortografía (Hicazkâr,
Şur muğamı) y los coreanos en McCune-Reischauer (P'yŏngjo), con la
romanización oficial y el hangul como alias, y los acadios en su transliteración habitual (išartu, nīš tuḫri). Un nombre gana a un alias: «Hijaz» es el
maqam Ḥijāz, y el dromos se busca como Hitzáz o Hicaz. Al buscar no importan los
diacríticos ni las mayúsculas, y también se aceptan las transliteraciones habituales sin ellos
(Mayamalavagowla, Shanmukhapriya, Hitzaz, hirajoshi), los nombres en chino y en japonés (宫, 平調子), los de
los dromoi en griego (Χιτζάζ) y los de las escalas indias en devanagari (यमन, मायामालवगौळ). En devanagari no se
quitan las marcas, porque भैरव (Bhairav) y भैरवी (Bhairavī) son dos rāgas distintos.

```swift
TipoDeEscala.melakarta(15)                   // Māyāmālavagauḷa
TipoDeEscala.mayor.numeroDeMelakarta         // 29 (Dhīraśaṅkarābharaṇam)
Escala(.re, .hitzaz).notas                   // Re Mi♭ Fa♯ Sol La Si♭ Do
Escala("Do Kāfī"), Escala("Do kafi"), Escala("Re hijaz"), Escala("Do melakarta 22")
Escala(.do, .todi).notas                     // Do Re♭ Mi♭ Fa♯ Sol La♭ Si
TipoDeEscala.melakarta(15) == .bhairav       // true: y también == .hitzazkiar
Escala(.re, .zhi).notas                      // Re Mi Sol La Si
Escala("Do hirajoshi").notas                 // Do Re Mi♭ Sol La♭
Escala("Do 平調子").tipo.nombre               // "Hirajōshi"
Escala("Re Χιτζάζ").tipo.nombre               // "Hitzáz"
Escala("Do भैरवी").tipo.nombre                // "Bhairavī"
TipoDeEscala.gong == .pentatonicaMayor       // true
Escala("Do Rast muğamı").notas               // Do Re Mi Fa Sol La Si♭ Si
Escala("La hicaz makami").notas              // La Si♭ Do♯ Re Mi Fa♯ Sol
Escala("Do podhalańska").notas               // Do Re Mi Fa♯ Sol La Si♭
```

No forman parte de `TipoDeEscala.todos`, para no cambiar las búsquedas de escalas habituales;
están en `TipoDeEscala.tradicionales` (y en `melakartas`, `thaats`, `dromoi`, `chinas`, `japonesas`,
`ragasIndostanicos`, `dastgah`, `coreanas`, `andinas`, `griegasAntiguas`, `makamlar`, `mugamlar`, `echoi`, `mesopotamicas`, `gramas`, `murchanas`, `generosDeArquitasYPtolomeo`, `ajnas`, `cesniler`, `africanas`,
`sudesteAsiaticas`, `modosGregorianos`, `generosDeDidimoYEratostenes`, `harmoniaiCromaticas`, `harmoniaiEnarmonicas`,
`harmoniaiDeAristides`, `hexacordos`, `europeas`,
`pathets`…). Sus nombres
son nombres propios: en los idiomas de alfabeto latino se escriben igual (en inglés también), y solo se
traducen los descriptivos (las andinas, las europeas, los tetracordos y las harmoniai griegas, y el «mayor» y el «menor» de
las etíopes). En ruso y en griego se transcriben a su alfabeto (Бхайрав, Μπιλαβάλ), salvo los 72 mēḷa,
que siguen en IAST; la forma latina se sigue leyendo.

### Rāga, mēḷa, dromos: la categoría de una escala

`categoria` y `tradicion` dicen qué es una escala de otra tradición. Salen de las listas de arriba y
valen `nil` en las occidentales y en las escalas propias (también en una propia que se llame «Kāfī» pero
suene distinta). Un mēḷa es también un rāga (`esRaga`); un thāṭ, que es una escala madre de la que se
derivan rāgas, no. Un rāga janya tiene `padre`, el mēḷa del que deriva por la tradición.

```swift
TipoDeEscala.kafi.categoria                     // .thaat
TipoDeEscala.melakarta(15)?.categoria           // .melakarta
TipoDeEscala.hitzaz.tradicion                   // .grecia
TipoDeEscala.rastMakami.categoria               // .makam
TipoDeEscala.mohanam.esRaga                     // true
TipoDeEscala.kafi.esRaga                        // false
TipoDeEscala.mohanam.padre?.numeroDeMelakarta   // 28
TipoDeEscala.menorNatural.categoria             // nil: las occidentales no tienen categoría
TipoDeEscala.tradicionales(categoria: .melakarta).count   // 72
CategoriaTradicional.escala.nombre(en: Notacion.espanolCompacto.conTextos(en: .frances))   // "gamme"
```

Las categorías se agrupan en cuatro clases (`ClaseDeEscala`), según qué es la escala: un modo que se toca (un rāga,
un maqam, un dromos…), una escala madre de la que salen otras (los mēḷa, los thāṭ, los grāma y los laras), un
fragmento de menos de una octava (los tetracordos y los géneros griegos, los ajnas árabes, los çeşni turcos y los
hexacordos de Guido) o la afinación de un instrumento (las
babilónicas, las africanas y las del sudeste asiático). Sirve, por ejemplo, para dejar fuera los fragmentos al buscar entre todas.

```swift
TipoDeEscala.mohanam.clase                        // .modo
TipoDeEscala.kafi.clase                           // .escalaMadre
TipoDeEscala.melakarta(15)?.clase                 // .escalaMadre
TipoDeEscala.tetracordoDiatonico.clase            // .fragmento
TipoDeEscala.jinsHijaz.categoria                  // .jins
TipoDeEscala.menorNatural.clase                   // nil
TipoDeEscala.tradicionales(clase: .fragmento).count   // 42
TipoDeEscala.tradicionales(clase: .afinacion).count   // 11
```

### Microtonos

Algunas escalas aproximadas tienen también su versión microtonal, `microtonal` (un ``TipoDeEscalaMicrotonal``):
dónde cae cada grado en la teoría de su tradición, en los pasos de su sistema (``SistemaMicrotonal``) contados
desde la tónica temperada. La tienen todos los maqamat que usan cuartos de tono, en cuartos de tono
(`.cuartosDeTono`, la teoría árabe moderna); los dastgāh y āvāz con *koron*, con el de Vaziri (`.persa`); los
makamlar, salvo los seis pitagóricos (Nihâvend, Kürdî, Bûselik, Çârgâh, Mâhur y Acemaşiran), en las 53 comas de Arel-Ezgi-Uzdilek
(`.comas53`); los quince dromoi, con la afinación de su maqam o su makam; los echoi bizantinos, salvo el trítos, en
los 72 moria de la Comisión Patriarcal de 1881 (`.moria72`); y los diez thāṭ y Yaman, en los 22 śruti indios
(`.sruti`), cada uno una razón justa, como los grāma y las mūrchanā; el tetracordo enarmónico griego, en cuartos de
tono (Mi Fa𝄳 Fa La), con las harmoniai enarmónicas y las de Arístides; el gamelan, los xilófonos africanos y el piphat y el pinpeat, en cents, con la octava en
partes iguales; y los géneros de Arquitas, Ptolomeo, Dídimo y Eratóstenes, en cents (`.razones`), igual que las mūrchanā con
el Pa de 40/27, que no es uno de los 22 śruti. Los thāṭ siguen el ṣaḍja-grāma de Bharata como lo reconstruye E. J. Arnold
(Kāfī: Sa, Re 10/9, ga 32/27, ma 4/3, Pa, Dha 5/3, ni 16/9), con el re y el dha pitagóricos (256/243, 128/81) en
Bhairav, Bhairavī y Toḍī, y Toḍī como lo miden Bel y otros. Los que en su propia teoría no tienen microtonos (Ḥijāz,
Māhur…) no la necesitan, y los mugam azerbaiyanos tampoco: son los de Hacıbəyov, ya en doce notas. En Sīkāh, ʿIrāq,
Segāh, Segâh, Hüzzam, el varýs o el légetos la tónica misma es un microtono: Sīkāh se escribe sobre Mi, y su
primer grado es Mi𝄳. Cada grado conserva la letra de su nota temperada y se aparta de ella medio semitono como mucho, así que la escala de doce notas sigue valiendo para todo lo demás.

`Escala.notasMicrotonales(sentido:)` da sus notas (``NotaMicrotonal``), con los cents desde la tónica. Se
escriben con el medio bemol y el medio sostenido (Mi𝄳, Fa𝄲; en ASCII, Miqb y Faq#), también el *koron* y el
*sori*, que no están en Unicode; en el sistema turco, con la nota pitagórica y las comas que se aparta (Si⁻¹,
una koma bajo Si; en ASCII, Si(-1)); en el bizantino, con los moria que se aparta de la nota temperada (Mi⁻², dos
moria bajo Mi); y en los śruti, con la flecha de Helmholtz-Ellis de una coma sintónica (81/80) sobre la nota
pitagórica (Mi↓ es 5/4; Re♭↑, 16/15); y en cents, con los que se aparta de la nota temperada (Fa(−37¢); en
ASCII, Fa(-37c)). Son las afinaciones teóricas: cada escuela afina un poco distinto. Se
buscan por el nombre, como `categoria`: el frigio tiene los intervalos de Bayātī, pero no sus microtonos.

```swift
Escala(.re, .bayati).notas                                       // Re Mi♭ Fa Sol La Si♭ Do
Escala(.re, .bayati).notasMicrotonales()                         // Re Mi𝄳 Fa Sol La Si♭ Do
Escala(.do, .maqamRast).notasMicrotonales(sentido: .descendente) // Do Re Mi𝄳 Fa Sol La Si♭
Escala(.sol, .rastMakami).notasMicrotonales()                    // Sol La Si⁻¹ Do Re Mi Fa♯⁻¹
TipoDeEscala.rastMakami.microtonal?.sistema                      // .comas53
Escala(.re, .echosProtos).notasMicrotonales()                    // Re Mi⁻² Fa Sol La Si⁻² Do
Escala(.do, .bilaval).notasMicrotonales()                        // Do Re↓ Mi↓ Fa Sol La↓ Si↓
TipoDeEscala.frigio.microtonal                                   // nil
```

Los microtonos llegan también a las partituras. `Escala.voz(octava:sentido:duracion:)` da la escala en negras, y
cada nota lleva lo que se aparta de su nota temperada, en cents (`Evento.Nota.desvio`; en texto, `Mi♭4(50¢):4`). Los
formatos la escriben así: MusicXML, con el `alter` en decimales (−0.5) y su `<accidental>`; MEI, con `accid`
(`1qf`, el *koron* o las comas de Arel-Ezgi-Uzdilek: `kf`, `bs`…); LilyPond y ABC, con sus cuartos de tono (`eeh`,
`_/E`), y las comas y los moria como la nota temperada; y MIDI, con una inflexión de tono (*pitch bend*) antes de
cada nota. Los moria exactos llevan en MusicXML el signo de doceavos de tono de Wyschnegradsky. `svgPentagrama()`
dibuja sus signos con los glifos de Bravura: los cuartos de tono de Stein-Zimmermann, las comas de
Arel-Ezgi-Uzdilek, el *koron* y el *sori*, los moria de Wyschnegradsky y, en los śruti, la flecha de
Helmholtz-Ellis. Los dibuja también con ritmo: en las secuencias de estudio de la escala
(`svgPentagrama(secuencia:)`), al tocarla en unas alturas cualesquiera (`svgPentagrama(tocadaEn:)`) y en cualquier
``Voz`` con desvíos (`Partitura.svg(opciones:)`), que lleva en el nombre de cada nota sus cents. Las notas de una
escala saben además en qué sistema se escriben y cuántos pasos de él se apartan (`Evento.Nota.sistema` y
`Evento.Nota.ajuste`; en texto, `Mi♭4(50¢,persa,1):4`): con eso, el *koron* de un dastgāh y la flecha de un śruti
llegan igual al pentagrama y a los formatos (`<accidental>koron</accidental>` en MusicXML, `accid="koron"` en MEI),
también en la partitura de la escala tocada en unas alturas cualesquiera (`Escala.partitura(tocadaEn:)`). Una nota
sin sistema, como las escritas a mano, lleva el signo que dan sus cents.

```swift
let voz = Escala(.re, .bayati).voz()
voz.eventos[1]                                   // Mi♭4(50¢,cuartosDeTono,1):4
Escala(.re, .sur).voz().eventos[1]               // Mi♭4(50¢,persa,1):4: el Mi koron
voz.partitura().musicXML().contains("<alter>-0.5</alter>")   // true
Evento("Si4(-15.09¢):4").notas                   // [Si4(-15.09¢)]
Escala(.re, .bayati).svgPentagrama(secuencia: .terceras).contains("<title>Mi𝄳</title>")   // true
let bayati = try Voz(leyendo: "Mi♭4(50¢):4 Re4:2.")
Partitura(.init(bayati), encabezado: Encabezado(titulo: "Bayātī")).svg().contains("(+50¢)</title>")   // true
```

## Nombres en cada idioma y alias

El nombre de cada tipo de escala en cada idioma, y las otras formas con que se lee (sus alias), están en un
fichero por idioma: `Escalas/Nombres/NombresDeEscalas+Catalan.swift`, `+Gallego`, `+Ruso`… (el español sale
del propio catálogo). `TipoDeEscala.nombre(en:)` usa el fichero del idioma de la notación, y
`TipoDeEscala(leyendo:)` y `Escala("Re dòric")` leen los de todos. Cada fichero da todos los tipos de
`TipoDeEscala.todos`, el nombre de cada `CategoriaTradicional` (`.categoria`) y las escalas de otras tradiciones
que se traducen en ese idioma (`.tradicional(.andina, "…")`, que apunta al miembro de `TipoDeEscala` y no compila si
deja de existir); las demás, sin fila, conservan su nombre original (Kāfī, Hitzáz).
`Scripts/comprobaciones/comprobar_catalogo.py` vigila que no falte ninguno y que no haya filas que no traducen nada. Un idioma nuevo es un fichero más.

`TipoDeEscala.alias` guarda solo las grafías correctas («dórico ♭2», «húngara»). Las simplificadas («dorico b2»,
«hungara») no se repiten: salen de `aliasNormalizados` y de `normalizar` (minúsculas, sin diacríticos, ♯/♭ como
#/b, sin ♮ ni ordinales), con lo que se encuentran igual.

```swift
try TipoDeEscala(leyendo: "dorico b2") == TipoDeEscala(leyendo: "dórico ♭2")        // true
TipoDeEscala.dobleArmonica.aliasNormalizados.contains("doble armonica")                 // true
try TipoDeEscala(leyendo: "jonico sin 4") == TipoDeEscala.jonicoSinCuarta              // true
```

## Modos gregorianos

`ModoGregoriano` describe los ocho modos del canto llano. Además de sus notas, cada uno tiene una
final (*finalis*), un tenor o dominante (la nota de recitación) y un ámbito. Van por parejas
con la misma final: protus (Re), deuterus (Mi), tritus (Fa) y tetrardus (Sol). El impar es el
auténtico, de la final a su octava. El par es el plagal («hipo-»), de una 4ª por debajo de la
final a una 5ª por encima.

| Modo | Nombre | Final | Tenor | Ámbito |
|---|---|---|---|---|
| 1 | protus auténtico (dórico) | Re | La | Re–Re |
| 2 | protus plagal (hipodórico) | Re | Fa | La–La |
| 3 | deuterus auténtico (frigio) | Mi | Do | Mi–Mi |
| 4 | deuterus plagal (hipofrigio) | Mi | La | Si–Si |
| 5 | tritus auténtico (lidio) | Fa | Do | Fa–Fa |
| 6 | tritus plagal (hipolidio) | Fa | La | Do–Do |
| 7 | tetrardus auténtico (mixolidio) | Sol | Re | Sol–Sol |
| 8 | tetrardus plagal (hipomixolidio) | Sol | Do | Re–Re |

```swift
ModoGregoriano(2)!.description
// "modo 2 (protus plagal, hipodórico): final Re, tenor Fa, ámbito La3–La4"
try ModoGregoriano(leyendo: "hipofrigio").tenor   // La
ModoGregoriano(3)!.escala                        // Mi frigio
ModoGregoriano(6)!.ambito.first                  // Do4
```

`ambito` da las notas de la más grave a la más aguda, con la final en la octava 4. Los modos 5 y
6 se cantaban muchas veces con Si♭, que `escala` no incluye.

Los ocho están también en el catálogo de escalas, en `TipoDeEscala.modosGregorianos` (la categoría
`.modoGregoriano`), con sus nombres latinos; `tipoDeEscala` lleva del uno al otro.

```swift
ModoGregoriano(2)!.tipoDeEscala.nombre           // "protus plagalis"
try TipoDeEscala(leyendo: "hipodórico").nombre    // "protus plagalis"
```

## Escalas que suben y bajan distinto

Algunas escalas usan notas distintas al subir y al bajar: la menor melódica clásica (que baja
como la natural), los dromoi Rast, Kiourdí y Houseïní, y muchos rāgas janya. `intervalos` es la
forma ascendente e `intervalosDescendentes`, la descendente (`nil` si la escala baja igual que sube).

```swift
TipoDeEscala.menorMelodica.esDireccional          // true
TipoDeEscala.menorMelodica.formaDescendente       // == .menorNatural
Escala(.la, .menorMelodica).alturas(octava: 4, sentido: .descendente)   // La5 Sol5 Fa5 … La4
TipoDeEscala.rast.formaAscendente == .mayor       // true; baja con la 7ª menor
TipoDeEscala.kiourdi.formaDescendente             // == .menorNatural
TipoDeEscala.bilahari.intervalosEnAmbasDirecciones
```

Los rāgas janya incluidos son Mohanam, Hindolam, Haṃsadhvani, Ābhogi, Madhyamāvatī, Revati,
Amṛtavarṣiṇī (iguales al subir y al bajar), Bilahari, Kāmbhoji, Ārabhi y Kedāragauḷa (distintos). Se dejan fuera los
vakra, que suben o bajan en zigzag. `melakartasCompatibles` dice de qué mēḷa puede derivar
cada uno: `TipoDeEscala.mohanam.melakartasCompatibles` → `[28, 29, 64, 65]`.

### Qué forma usa cada operación

- **Las dos direcciones:** `contiene(_:)`, `contieneEnarmonico(_:)`, `Escala.candidatos` y la
  ortografía de alturas MIDI. La menor melódica contiene Sol (al bajar) y Sol♯ (al subir), y
  en ella el Sol no se escribe como nota cromática. Con `sentido:` se mira solo una:
  `contiene(.sol, sentido: .ascendente)` → `false`.
- **Solo la subida:** `notas`, los grados (`grado(_:)`, `grado(de: _:)`, `nombreDeGrado(_:)`), la
  armonización, la armadura y `conjuntoDeClases` (la menor melódica es 7-34).
- `notasEnAmbasDirecciones` y `notas(sentido:)` dan las notas de cada caso.

### Menor melódica clásica y de jazz

`menorMelodica` es la clásica: sube con la 6ª y la 7ª mayores y baja como la natural.
`menorMelodicaJazz` usa la 6ª y la 7ª mayores también al bajar; es la escala madre de los modos
de la menor melódica (`TipoDeEscala.alterada.rotacion(2) == .menorMelodicaJazz`) y tiene el mismo
contenido que el mēḷa 23, Gaurīmanoharī. En inglés, "melodic minor" es la clásica y
"jazz minor" o "ascending melodic minor", la de jazz.

## Misma escala y mismo nombre

Dos tipos de escala son iguales (`==`) si tienen el mismo contenido al subir y al bajar, se
llamen como se llamen: `TipoDeEscala.kafi == .dorico`. Para comparar también el nombre está
`esIdentico(a:)`, y `equivalentes` da los otros nombres con que se conoce una escala:

```swift
TipoDeEscala.kafi.esIdentico(a: .dorico)          // false
TipoDeEscala.kafi.equivalentes.contains(.dorico)  // true
TipoDeEscala.rast == .mayor                       // false: baja distinto
```

Cuando dos escalas del catálogo coinciden, gana la que va antes en `TipoDeEscala.catalogo`: primero las
occidentales (`todos`) y después las de otras tradiciones (`tradicionales`), cada una en su orden. Así se
nombra una escala escrita por sus notas, y así se ordenan los `equivalentes`. Al buscar por nombre, además, un
nombre gana siempre a un alias:

```swift
TipoDeEscala.propio(TipoDeEscala.kafi.intervalos).nombre   // "dórico"
TipoDeEscala.kafi.equivalentes.first?.nombre               // "dórico"
try TipoDeEscala(leyendo: "Hijaz").nombre                 // "Ḥijāz" (el maqam; el dromos Hitzáz lo tiene de alias)
```

## Arpegios

Un arpegio no es un tipo de escala sino un acorde tocado nota a nota, así que ``Arpegio`` no entra en el catálogo de escalas:
guarda un ``Acorde``, el orden del recorrido (``Arpegio/Patron``: ascendente, descendente, de ida y vuelta o el bajo de Alberti) y
las octavas que abarca. Se obtiene de un acorde o de un grado de una escala, se lee y se nombra en los quince idiomas
(«Arpegio de Do mayor», «C major arpeggio», «Arpège de Do majeur») y se dibuja en un pentagrama. ``Acorde/escalasCompatibles(entre:)``
da la relación acorde-escala del jazz: las escalas sobre la fundamental que contienen todas las notas del acorde, entre
las de ``TipoDeEscala/deJazz`` y de las que tienen menos notas a evitar a las que más.

```swift
Arpegio(Acorde("Do7")).alturas(octava: 4).map(\.midi) == [60, 64, 67, 70, 72]       // true
Arpegio(Acorde("Do"), patron: .alberti).alturas(octava: 3).map(\.midi) == [48, 55, 52, 55]   // true
Escala("Do mayor").arpegio(grado: 5, cuatriada: true)?.acorde == Acorde("Sol7")      // true
Escala("Do mayor").arpegios().count == 7                                              // true
try Arpegio(leyendo: "arpegio Dom7").acorde == Acorde("Dom7")                        // true
Acorde("Do7").escalasCompatibles().contains(Escala(.do, .mixolidio))                 // true
let dibujo = Arpegio(Acorde("Do7")).svgPentagrama()
```

## Escalas sobre un acorde

La teoría acorde-escala del jazz mira cada nota de una escala desde el acorde que suena. ``Escala/notas(sobre:)`` dice
qué es cada una (``PapelEnLaEscala``): una nota del acorde, una tensión disponible o una nota a evitar, la que está un
semitono por encima de una nota del acorde y choca con ella si se sostiene (el fa sobre Do7M en jónico). En un acorde
de dominante, la ♭9 y la ♭13 no se evitan; en uno sus4, sí la tercera mayor. Cada nota lleva su grado sobre la
fundamental (``NotaSobreElAcorde/cifra``) como en los cifrados de jazz: las 2.ª, 4.ª y 6.ª se cuentan como 9, 11 y 13, y
una 3.ª menor sobre un acorde mayor, como ♯9.

Qué escala toca sobre cada acorde depende de lo que hace en la tonalidad. ``Tonalidad/escalaDelAcorde(_:siguiente:)`` y
``AnalisisArmonico/escalas`` la eligen por su papel en el análisis: el modo de la tonalidad para un acorde diatónico
(Rem7 en Do, dórico), el de la escala del destino para una dominante secundaria (V7/ii, frigio dominante: el
mixolidio ♭9 ♭13), el de la homónima para un préstamo (♭VI, lidio) y lidio dominante para el sustituto tritonal. Si el
acorde no cabe en esa escala, se queda con la de ``TipoDeEscala/paraAcordes`` que saca menos notas de la tonalidad.

``Escala/escalaMadre`` dice de qué escala es modo cada una, entre las mayores, las menores melódicas, las menores
armónicas y las mayores armónicas (``TipoDeEscala/familiasDeModos``).

```swift
Escala(.do, .mayor).notasAEvitar(sobre: Acorde("Do7M")) == [.fa]                       // true
Escala(.re, .dorico).notas(sobre: Acorde("Rem7")).map(\.cifra) == ["1", "9", "♭3", "11", "5", "13", "♭7"]   // true
Escala(.sol, .frigioDominante).tensiones(sobre: Acorde("Sol7")) == [Nota(.la, .bemol), Nota(.mi, .bemol)]   // true
Tonalidad(.do).analizar(["Do", "La7", "Rem7", "Sol7"]).escalas[1] == Escala(.la, .frigioDominante)          // true
Tonalidad(.do).escalaDelAcorde(Acorde("Sib7")) == Escala(Nota(.si, .bemol), .lidioDominante)               // true
Escala(.do, .alterada).escalaMadre?.madre == Escala(Nota(.re, .bemol), .menorMelodicaJazz)               // true
Escala(.re, .dorico).escalaMadre?.nombre(en: .espanolCompacto) == "modo 2 de Do mayor"                   // true
Acorde("Do7(#11)").escalasCompatibles().first == Escala(.do, .lidioDominante)                            // true
```

### Los acordes de una escala

En el otro sentido, ``Escala/acordesQueCaben(grado:)`` da todos los acordes de ``TipoDeAcorde/paraEscalas`` que caben
sobre un grado, no solo los de terceras superpuestas: en Do mayor, sobre el 1.º, también Dosus2, Do6, Do6/9 y
Do(add9); en Do frigio dominante, Do7(♭9). ``Escala/estructurasSuperiores(sobre:)`` da las tríadas mayores y menores
de la escala que se pueden tocar sobre el acorde: las que tienen alguna tensión y ninguna nota a evitar, primero las
de más tensiones. Sobre Do7M en lidio, Re mayor: la 9, la ♯11 y la 13.

```swift
Escala(.do, .mayor).acordesQueCaben(grado: 1).contains(Acorde(.do, .mayorSexta))                        // true
Escala(.do, .lidio).estructurasSuperiores(sobre: Acorde("Do7M")).first == Acorde(.re, .mayor)             // true
```

### Armonía modal

Los siete modos de la escala mayor (``Escala/modoDeLaMayor``, de 1 a 7) se distinguen del mayor o del menor más
parecido por una nota, ``Escala/notaCaracteristica``: la 6.ª mayor del dórico, la 2.ª menor del frigio, la 4.ª
aumentada del lidio, la 7.ª menor del mixolidio… ``Escala/acordesCaracteristicos`` son las tríadas del modo que la
llevan (sin la de la tónica ni las disminuidas), y ``Escala/cadenciaModal``, la cadencia que afirma el modo sin la
dominante de la tonalidad: IV–i en dórico, ♭II–i en frigio, II–I en lidio, ♭VII–I en mixolidio.

```swift
Escala(.re, .dorico).notaCaracteristica == .si                                          // true
Escala(.re, .dorico).acordesCaracteristicos == [Acorde("Mim"), Acorde("Sol")]           // true
Escala(.sol, .mixolidio).cadenciaModal == [Acorde("Fa"), Acorde("Sol")]                 // true
Escala(.mi, .frigio).cadenciaModal == [Acorde("Fa"), Acorde("Mim")]                     // true
```

### Estudiar una escala

``Escala/secuencia(_:octava:octavas:sentido:)`` da la escala en una ``SecuenciaDeEscala`` de estudio, subiendo o
bajando: por terceras (Do Mi, Re Fa, Mi Sol…), por cuartas, en grupos de tres o de cuatro notas, o en la tríada o la
cuatriada de cada grado. ``Escala/digitacionDePiano(_:octava:octavas:)`` da los dedos de cada ``Mano``: en Do mayor,
1 2 3 1 2 3 4 5 en la derecha y 5 4 3 2 1 3 2 1 en la izquierda; en Fa mayor, 1 2 3 4 1 2 3 4 en la derecha, para que
el pulgar no caiga en el Si♭.

``Escala/modosParalelos`` son los siete modos de la mayor sobre la misma tónica, del más brillante (lidio) al más
oscuro (locrio), y ``Escala/brillo`` mide cuánto: lidio +1, jónico 0, dórico −2, locrio −5.
``Escala/modosRelativos`` son las escalas con las mismas notas que empiezan en cada grado.
``Escala/comparar(con:)`` da una ``ComparacionDeEscalas``: las notas comunes, las que solo están en una, los grados
que cambian (de Do mayor a Do lidio, el 4.º, de Fa a Fa♯) y la distancia en el círculo de quintas.

Sobre un acorde, ``Acorde/escalasBebop`` son las bebop que, bajando en corcheas, ponen una nota del acorde en cada
parte fuerte (Do bebop dominante sobre Do7, con el Si de paso), y ``Acorde/pentatonicas``, las pentatónicas sin notas
a evitar, con las tensiones que suma cada una. En una progresión, ``Escala/cambios(desde:)`` dice qué notas cambian
de la escala de un acorde a la del siguiente y ``Acorde/notasGuia``, su tercera y su séptima.
