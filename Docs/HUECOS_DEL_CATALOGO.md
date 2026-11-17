# Huecos del catálogo de escalas y acordes

Estado a 16 de noviembre de 2026, tras las escalas sintéticas, los lugares, las épocas, los estilos, las corrientes y
las fuentes de cuatro acordes de nombre propio.

## Resumen

Todas las escalas de otras tradiciones citan ya alguna obra. Quedan 13 escalas occidentales sin ninguna referencia y
cuatro acordes sin fuente (m(add9), add11, m(add11) y el alfa de Lendvai). El catálogo tiene 539 escalas en 50 listas de tradición y 76 acordes, todos con nombre en
los trece idiomas. Las cifras de escalas y de listas las comprueba `comprobar_catalogo.py` con las del catálogo: si
cambian, hay que cambiarlas aquí. Las siete europeas y las danzas (passamezzo, ruggiero, bergamasca, chacona y pasacalle) ya citan una
obra cada una.

## Escalas de otras tradiciones sin referencia

Ninguna, según `comprobar_catalogo.py`. Las tres que quedaban citan ahora una obra sobre su instrumento:

| Escala | Obra |
| --- | --- |
| Pinpeat | Sam (1988), la tesis sobre el conjunto pinpeat jemer |
| Saung | Williamson (2000), el arpa birmana y sus afinaciones |
| Amadinda | Kubik (1994), la teoría de la música africana, de donde viene la equipentatónica de Uganda |

## Tradiciones cortas o ausentes

El sudeste asiático y África son las tradiciones con menos escalas del catálogo. Cuatro tradiciones no están. Las
cifras de las que sí están son las escalas declaradas en su fichero del catálogo.

| Tradición | Escalas ahora | Qué falta |
| --- | --- | --- |
| Sudeste asiático | 8 (piphat, pinpeat, saung y los cinco lai del khaen) | Los modos filipinos del kulintang y más escalas jemeres y birmanas |
| África | 7 (amadinda, timbila, cuatro de la kora, nyamaropa) | Las escalas de África occidental fuera de la kora, como las del balafon, y las del Sahel |
| Asia Central | ninguna | El shashmaqom de Bujará y Samarcanda |
| Magreb | ninguna | Los ṭubūʿ de las nubas andalusíes |
| Mongolia | ninguna | Las pentatónicas del canto largo y del morin khuur |
| Uigures | ninguna | Los doce muqam |

Son más largas India (131, en sus cuatro ficheros), el mundo árabe (44) y Turquía (40).

### Dónde buscar las que faltan

Se buscaron en noviembre de 2026 los muqam uigures y los ṭubūʿ del Magreb, y no se añadió ninguno: lo que se puede
leer en abierto no da sus escalas en texto, y sin una obra que las dé no se escriben de memoria.

- **Uigures:** Harris (2008), *The Making of a Musical Canon in Chinese Central Asia: The Uyghur Twelve Muqam*, y
  Light (2008), *Intimate Heritage*, no están en abierto. Zhou Ji (周吉), «维吾尔木卡姆音体系研究», da el
  conjunto de notas del tema de cada uno de los doce muqam, pero en una tabla que es una imagen.
- **Magreb:** la Jewish Music Research Centre de la Universidad Hebrea («Andalusian Nuba») muestra las escalas de
  los once ṭubūʿ marroquíes, también en imágenes, sacadas del árbol de los modos del manuscrito al-Ḥāʾik (Tetuán).
  Según esa página son escalas de tonos y semitonos, sin microtonos.

- **Asia Central, el shashmaqom:** los seis maqom de Bujará (Buzruk, Rost, Navo, Dugoh, Segoh, Iroq) se nombran por
  el modo en que suenan, pero cada uno es una suite de muchas shuʿba con escalas distintas, y ni la Gran Enciclopedia
  Rusa («Маком») ni lo que se lee en abierto da el звукоряд de cada uno. Hacen falta Levin (1984) o Rajabov (1963).

Se volvió a buscar los tres en noviembre de 2026, con el mismo resultado: el estudio de Zhou Ji sigue dando los
音列 solo en imágenes, y las fuentes en árabe sobre los ṭubūʿ (Kunnāsh al-Ḥāyik, la tesis de Liberty University sobre
los ṭubūʿ tunecinos) no se pueden leer desde aquí.

- **Birmania, las afinaciones del saung:** Garfias («Preliminary Thoughts on Burmese Modes», *Asian Music* 7/1, 1975)
  da la tónica de cada una (hnyin loun en Do, auk pyan en Fa, pule en Si, myin saing en Mi…) y su modo del hsaing,
  pero no sus cinco notas, y su tabla de modos del hsaing no coincide con la del saung en todos. Como el saung del
  catálogo ya recoge la forma común de todas (pasos pequeño, pequeño, grande, pequeño, grande), harían falta las
  notas de Williamson (2000) para escribirlas por separado, y la grafía birmana de cada nombre.

- **Turquía, el otomano:** los makam no llevan su nombre en la escritura otomana. La Wikipedia turca no la da en
  ningún artículo de makam, y las obras que la tienen (el diccionario Redhouse, la edición de Cantemir) solo están
  escaneadas.
- **Mundo árabe, los maqāmāt que faltan de Maqam World:** Māhūr (su nombre árabe, ماهور, es el del dastgāh persa),
  Kirdān (las mismas notas y ajnas que Rāst), y los que usan un jins que el catálogo no tiene (Mustaʿār, Nahāwand
  Muraṣṣaʿ, Ṣabā Dalanshīn) o que Maqam World no describe en texto (Sūzdalārā, Sīkāh Baladī). Awj ʿIrāq, Bastanikār
  e Ḥijāzkār Kurd esperan a que se confirmen sus notas fuera de las imágenes de Maqam World.

- **Mundo árabe, los shudūd de Ṣafī al-Dīn que faltan:** ʿIrāq e Iṣfahān tienen una octava nota una coma (24 cents)
  por debajo de la octava, y Buzurg, dos notas a una coma la una de la otra (678 y 702 cents). En doce notas cada par
  es la misma nota, y la versión pitagórica tiene que tener un paso por grado, así que no caben en un `TipoDeEscala`.
- **India, Mārvā y Valaji:** el rāga Mārvā se llama como su thāṭ, que ya está, y Valaji es un alias de Kalāvatī; no
  entran como escalas aparte para que el nombre no lleve a dos.
- **Japón, más afinaciones del koto:** Nakazora-jōshi (中空調子) es, en la tabla de afinaciones del afinador de KORG
  que copia shamisen.info, el Hirajōshi sobre otra nota (Re Mi Fa La Si♭ con un Sol grave): en doce notas no es una
  escala nueva. Han-iwato (半岩戸調子) no está en ninguna de las tablas que se leen en abierto. Kumoi-jōshi (雲井調子)
  estaba como Do Re Mi♭ Sol La, las notas de Akebono; la tabla de KORG y la de asahi-net, cuerda a cuerda, coinciden
  en Sol La♭ Do Re Mi♭ (Do Re♭ Fa Sol La♭), y así está ahora.

- **India, los pann tamiles:** las fuentes en abierto no coinciden en el rāga que le toca a cada pann (Kurinci es
  Harikāmbhoji en shaivam.org y Malahari en Bharatpedia; Intaḷam, Māyāmālavagauḷa o Nāṭanāmakriyā), y los que sí
  coinciden (Takkēci, Kāmbhoji; Kāntārapañcamam, Kedāragauḷa) son escalas que el catálogo ya tiene.
- **China, los modos de Chaozhou:** Dujunco («Birth of a New Mode?», *Ethnomusicology OnLine* 8) describe los cuatro
  diaoti (qingsan qingliu, zhongsan zhongliu, qingsan zhongliu, huowu) por qué notas se aprietan y cuánto, pero sus
  escalas están en una figura que es una imagen, y la entrada de zh.wikipedia no se puede leer desde aquí.
- **Sunda, los laras madenda y pelog degung:** la guía de Ableton de la afinación sundanesa, que sigue a
  Kusumadinata (1969), da los cents en tablas que son imágenes, y se contradice en cuál de los degung es el «tri suara».
- **Filipinas, el kulintang:** duyug, sinulog, tidtu, binalig y tagonggo son modos rítmicos, no escalas, y cada juego
  de gongs tiene su afinación (Maceda 1963, Trimillos 2004, en la Wikipedia en inglés).
- **Mundo árabe, Mustaʿār:** Maqam World da su jins (un Sīkāh con la segunda alta) solo en una imagen. Ṣabā Zamzam
  ya está en el catálogo.
- **Azerbaiyán, más muğam:** los siete lad de Hacıbəyov (Rast, Şur, Segah, Çahargah, Şüştər, Bayatı-Şiraz y
  Hümayun) ya están todos. Los otros muğam (Mahur-hindi, Rahab, Bayatı-Kürd, Zabul…) son dəstgah que se tocan en
  alguno de esos siete lad, y los tres «colaterales» que cita la Wikipedia en inglés («Mugham»: Şahnaz, Sarənc y otra
  forma de Çahargah) no tienen sus notas en ningún texto que se lea en abierto.
- **Grecia, más dromoi:** los quince del catálogo llevan ya su nombre en griego. Los que se nombran además en lo que se
  lee en abierto (Bouselik, Machour, Rechavi, Tsargkiach, Neveser, Bestenigkiar, en las páginas de Carmelo Siciliano)
  no dan sus notas en texto, o son las de un dromos o un makam que ya está (Tsargkiach es la mayor; Neveser, Niavént).
- **Bali, lebeng y baro:** entran los dos con la tabla de la Wikipedia en inglés («Pelog»), que avisa de que son poco
  usados y menos fijos que los otros tres: baro tiene al menos cuatro lecturas (la del catálogo es la de Beratha y
  Asnawa), y lebeng solo tiene siete notas en el semar pegulingan; en el gambuh es pentatónico, sin una escala fija.
- **Turquía, Nişâbur y Şehnaz:** la TDV İslâm Ansiklopedisi los describe con más de un dizi o con un recorrido que no
  deja una escala sola, así que de esta tanda solo entra Bayâtî.
- **India, los janya en śruti:** los rāgas indostánicos con thāṭ llevan los śruti de su thāṭ (el modelo de Arnold),
  pero los janya no: cada svara carnático (el śuddha ṛṣabha, el sādhāraṇa gāndhāra…) puede ir en dos śruti según el
  rāga, y la Wikipedia en inglés («Shruti (music)») no da qué śruti le toca a cada uno. Hace falta una tabla carnática
  en texto, como la de Sambamoorthy.
- **India, más rāgas vakra:** Bēgaḍa, Sahānā y Rītigauḷa salen de karnATik (*Royal Carpet: Carnatic Ragas*), porque
  la Wikipedia en inglés no se puede leer (Bēgaḍa) o se contradice (Sahānā, Rītigauḷa, Darbārī Kānaḍa). La
  Darbārī Kānaḍa carnática, que karnATik sube desde el ni de abajo, va aparte de la indostánica, que sube recta.
  Nalinakānti no tiene `madre`: la fuente no lo da y, sin Dha, sus notas caben en dos mēḷa.
- **India, los rāgas que faltaban de karnATik y los vakra indostánicos:** ya están todos, con estas salvedades.
  - Khamās sale de la Wikipedia en inglés, porque la página de la K de karnATik se corta a los 61 084 caracteres.
  - Kuriñji, de guruguha.org (2020), en su forma de hoy, de ámbito corto: va del Ni de abajo al Dha.
  - Sindhu Bhairavi sigue el texto de la Wikipedia en inglés, recto y con las doce notas; el cuadro añade un giro, y
    el artículo no cita fuente para su mēḷa (Hanumattoḍī). Falta una obra que lo confirme.
  - Navarōj va de Pa a Pa con las notas de karnATik, Ga₁ y Ri₃ incluidas, como notas externas: si son una errata
    por Ga₃ y Re₂, como parece, hay que corregirlo con otra fuente.
  - Deś, Kedār y Darbārī Kānaḍa llevan el recorrido del cuadro de la Wikipedia en inglés. En Kedār y en Darbārī el
    texto da otro, con más giros; Bor (1999) diría cuál.
- **India, el vādī y el saṃvādī:** 29 rāgas indostánicos los tienen, de la Wikipedia en inglés. Faltan los que no
  tienen artículo o no los dan (Bhūpālī, Śivarañjanī, Candrakauns, Lalit, Madhuvantī, Jaunpurī, Miyāṅ kī Toḍī,
  Gujarī Toḍī, Jog, Kirvāṇī, Dhānī, Pūrvī, Khamāj, Kalyāṇ) y los que dan dos parejas (Ahir Bhairav, Naṭ Bhairav,
  Bhairavī). Ningún rāga tiene aún su nyāsa.
- **Mongolia:** la colección de Sipos (*Mongolian Folk Songs*, ERHFM) clasifica las canciones por pentatónicas que el
  catálogo ya tiene (las cinco rotaciones de la pentatónica, como los modos chinos).

Con una de esas tablas en texto, o con un escaneo de las obras, se pueden añadir.

También en noviembre de 2026 se buscaron los modos de la liturgia etíope y los octoechos de otras iglesias, para
traerlos con su nombre original, y tampoco entró ninguno: las fuentes en abierto los nombran, pero no dan las notas
de cada modo.

- **Etiopía, los modos del zema:** ግዕዝ (gəʿəz), ዕዝል (ʿəzl) y አራራይ (ʾarārāy), los tres de la tradición de Yared,
  se describen por su uso en la liturgia (ferial, de cuaresma y de duelo, festivo), no como escalas. Las cuatro
  qənet del catálogo (ትዝታ, ባቲ, አምባሰል, አንቺሆዬ) son las de la música profana, y no son estos.
- **Armenia, los ութ ձայն:** las fuentes en abierto (Arts 15/6, 117, MDPI) dan los nombres de los ocho ձայն
  romanizados (Ayp Tza…) y el principio de los tetracordos que los forman, pero no la escala de cada uno.
- **Siria, los ocho ܩܠܐ (qolē) del Beth Gazo:** hay estudios que los ponen en relación con ocho maqāmāt, pero no hay una
  tabla de qué maqām le toca a cada ܩܠܐ en la que coincidan.
- **Rusia, los ocho гласы del znamenny:** son fórmulas melódicas (попевки), no escalas, y la escala del обиход en la
  que se cantan no se repite a la octava, de modo que no cabe en un `TipoDeEscala`.

## Escalas sin nombre original

Las escalas de la India, el mundo árabe, Persia, China, Japón, Corea, Etiopía, Grecia, Bizancio, el sudeste asiático y
el klezmer tienen su nombre en la escritura de su tradición (`TipoDeEscala.nombresOriginales`), salvo el menor de las
etíopes (Təzəta menor y Bati menor): el amárico no tiene otro nombre para él, y ትዝታ y ባቲ están en el mayor. La prueba
`NombresOriginalesTests` las lista.

De la Grecia antigua lo tienen, en griego politónico, las que tienen nombre en los teóricos: las siete harmoniai
(δωριστί, ὑπολυδιστί…), las seis de Arístides (con ἰαστί y συντονολυδιστί), los tres géneros (γένος διατονικόν…) y
sus colores en Aristóxeno y en Ptolomeo (χρῶμα μαλακόν, διατονικὸν ὁμαλόν…). Las demás (las harmoniai cromáticas y
enarmónicas, los tetracordos de Arquitas, Dídimo y Eratóstenes) son combinaciones del catálogo sin nombre griego
propio, y no lo llevan.

Hay tradiciones que no lo llevan a propósito: la turca y la azerbaiyana (su escritura es la latina; la otomana sería
una forma histórica), la indonesia y la vietnamita (la latina es la de uso) y la mesopotámica (la transliteración del
acadio es la norma).

## Escalas occidentales sin fuente

De las 118 escalas occidentales, 13 no citan ninguna obra. Quince pentatónicas, hexatónicas y blues alteradas citan
ahora la lista de modos de Op de Coul (Huygens-Fokker), que da sus pasos en texto. Algunas van allí con otro nombre:
el jónico sin 4ª es su «Lydian Hexatonic», el eólico sin 2ª su «Phrygian Hexatonic», la mayor ♭3 su «Dorian
Pentatonic», la menor ♭6 su «Blues Aeolian Pentatonic I» y la blues menor con 2ª su «Modified Blues».

| Grupo | Escalas | Cuántas |
| --- | --- | --- |
| Pentatónicas alteradas | menor ♭5 y mayor ♭6, que la lista solo trae como rāgas (Jayakauns, Bhupeshwari) | 2 |
| Hexatónicas | de dos tríadas (mayor y menor), de armónicos | 3 |
| Cromáticas con alteraciones | con uno, dos, tres y cinco bemoles, con cinco sostenidos | 5 |
| De ocho notas | bebop locrio, bebop lidio, bebop menor armónica | 3 |

Las bebop locria, lidia y menor armónica no están, que sepamos, en Levine (1995) ni en Kingstone (2006), que la
Wikipedia en inglés («Bebop scale») cita para la mayor, la menor melódica y la séptima con quinta bemol; la bebop
menor armónica sale en ese artículo, pero sin nota que diga de dónde: sus bebop son la de dominante, la
mayor, la dórica y la menor melódica, que ya lo citan. La lista de Op de Coul tiene los pasos de la bebop locria y de
la menor armónica, pero como «Phrygian/Locrian mixed» y «Maqam Nahawand»: no como bebop. Hace falta otra obra que
las traiga.

Las hexatónicas de dos tríadas no encajan en Cohn (1996), como se pensaba: sus sistemas hexatónicos juntan dos
tríadas a una tercera mayor, que es la escala aumentada (y esa ya lo cita). Las del catálogo juntan dos tríadas a un
tono, la técnica de los «triad pairs» del jazz, y necesitan una obra de improvisación que la explique. La que se suele citar, Campbell (*Triad Pairs for Jazz*), no
se puede leer desde aquí, y lo que se lee de ella en la red no dice a qué distancia van las dos tríadas.

## Escalas sin época

La época de una escala no se escribe: sale de lo que el catálogo ya sabe de ella (`TipoDeEscala.epocaDeOrigen`). Toda
occidental de un estilo con épocas (la música clásica, el jazz, el blues, las de compositor y el pop y el rock) tiene
la suya, y lo comprueban las pruebas (`EpocaTests`). Quedan sin época 14 occidentales y 234 de otras tradiciones.

| Grupo | Escalas | Qué falta |
| --- | --- | --- |
| Populares | dórico ♯4, egipcia, flamenca, argelina, mayor rumana, pentatónica escocesa, y los cuatro hexatónicos sin una nota (jónico sin 4ª, mixolidio sin 3ª, dórico sin 6ª, eólico sin 2ª) | Una obra que las documente con su año (`documentada:`), como Liszt (1859) en la menor húngara |
| Sintéticas | persa, jónico ♭2, jónico ♭5, jónico ♯6 | Una escala madre fechada de la que sean modo, o una obra que las traiga |
| De otras tradiciones | 99 de la India (rāgas y janya), 35 del mundo árabe, 19 de Japón, 14 de Turquía, 13 de Indonesia y las de África, los Andes, Brasil, China, Corea, Etiopía, Europa, el klezmer, el sudeste asiático y Vietnam | El año de su obra o de su categoría; muchas son de tradiciones vivas sin una fecha de origen clara, y es mejor dejarlas sin época que inventarla |

Se buscaron en noviembre de 2026 fechas para los catorce makamlar sin época (los que no están en Cantemir). Los
artículos de la TDV İslâm Ansiklopedisi dan, como mucho, quién los compuso, sin año: Sultânîyegâh es de Hamâmîzâde
İsmâil Dede Efendi, Ferahfezâ de Vardakosta Ahmed Ağa, y la pieza más antigua en Şedaraban, de II. Gazi Giray Han;
de Hicazkâr y Suzinak no dicen ni eso. Sin una obra con su año no se les pone época.

## Acordes que faltaban

Hay 54 acordes genéricos y 22 de nombre propio. Los que faltaban ya están, pero algunos sin fuente:

| Acorde | Notas | Fuente | Qué queda |
| --- | --- | --- | --- |
| Sexta aumentada suiza | La♭ Do Re♯ Fa♯ (sobre La♭) | Aldwell, Schachter y Cadwallader (2011) | Nada: el lector ya admite la cuarta doble aumentada (`𝄪11`) |
| m(add9) | Do Mi♭ Sol Re (sobre Do) | Ninguna | Buscar una obra que la traiga |
| Acorde de Elektra | Do♯ Mi♯ Sol♯ + Mi Si | La partitura (Strauss, 1909) | Confirmar la ortografía en la partitura, Kramer (1993) o Abbate (1989) |
| Acorde de los augures | Fa♭ La♭ Do♭ + Mi♭ Sol Si♭ Re♭ | Taruskin (1996) | Nada |
| Acorde de la Sinfonía de los salmos | Mi Sol Si Sol | La partitura (Stravinski, 1930) y Austin (1966: 334) | Nada |
| Acorde alfa de Lendvai | Do Mi♭ Fa♯ La + Do♯ Mi Sol Si♭ | Ninguna | Confirmar en Lendvai (1971) qué notas da |

| Tricordo vienés | Do Re♭ Sol♭ (3-5 de Forte) | DeLone y otros (1975: 348) | Ver la página en el libro |

Los seis últimos de nombre propio son disposiciones del jazz y acordes del siglo XX: el de Kenny Barron y las
estructuras superiores II, VI y ♭VI citan a Levine (1989, y 1995 las estructuras superiores), y el acorde por quintas y
el racimo cromático, a Persichetti (1961). Sus notas son las que se enseñan habitualmente; falta ver en los libros las
páginas, y si Levine escribe las estructuras superiores con la séptima en el bajo o con el tritono.

Los dos últimos son los tetracordos de todos los intervalos, 4-Z15 (Do Re♭ Mi Fa♯) y 4-Z29 (Do Re♭ Mi♭ Sol), que
citan a Forte (1973); que cada uno tenga cada clase de intervalo una vez lo comprueban las pruebas. Entre los
genéricos, seis de los que se añadieron (7(♭13), 7(♭9,♭13), 7(♯5,♯9), 7sus4(♭9), 6sus4 y el °(maj7)) citan a
Levine (1995) sin página; add11 y m(add11), como m(add9), no tienen fuente.

El de Hendrix cita a Shapiro y Glebbeek (1995: 144), y el mu, la introducción de Becker y Fagen al cancionero de
Steely Dan, que se lee en The Steely Dan Archive. El acorde del sueño de La Monte Young (Sol Do Do♯ Re) cita a
Smith (1977), que da sus notas.

Las cuatro fuentes nuevas (DeLone, Austin, Shapiro y Glebbeek, Becker y Fagen) se han tomado, con su página, de las
notas de la Wikipedia en inglés («Viennese trichord», «Psalms chord», «Dominant seventh sharp ninth chord», «Mu
chord»), y la de Becker y Fagen se ha leído además en su texto. Las páginas de los tres libros están sin comprobar en
el libro. Austin dice del acorde de los salmos que es «a perverse spacing of the E minor triad, with the minor third
doubled in four octaves»; DeLone define el tricordo vienés como una cuarta justa y un tritono.

Quedan fuera, por ahora:

- Los acordes beta, gamma, delta y épsilon de Lendvai: lo que se lee de él en la red da el gamma por sus intervalos
  (3 + 5 + 3) y ninguno por sus notas. Hay que leerlos en Lendvai (1971).
- El acorde mayor-menor de Bartók (la 3.ª mayor y la menor a la vez): sin una obra leída que lo defina así. Candidato:
  Antokoletz, *The Music of Béla Bartók* (1984).
- El disminuido con séptima mayor, °(maj7): sin una obra que lo nombre.
- El de *A Hard Day's Night*, el «acorde de Chopin» y el de la Décima de Mahler: no hay acuerdo sobre sus notas o no
  hay una fuente seria que los nombre así.

## Progresiones que faltan

El catálogo tiene 61 progresiones. Quedan fuera, hasta leer una obra que las dé:

- El line cliché (i–i(maj7)–i7–i6): falta una obra que lo nombre así.
- La progresión Omnibus: Telesco, «Enharmonicism and the Omnibus Progression», *Music Theory Spectrum* (1998).
- La cadenza doppia de Gjerdingen (2007): es un esquema de voces, no de acordes.
- El ciclo octatónico (P y R): Cohn la trata en otro artículo (1997), que no está entre las referencias.
- El ōdō shinkō del J-pop (IV–V–iii–vi) y el blues de 8 compases, que tiene muchas formas: sin una fuente académica.

## Ritmos, temperamentos, piezas e instrumentos que faltan

Lo que no ha entrado en los catálogos de ritmos, temperamentos, progresiones e instrumentos, y por qué:

- **Los iqāʿāt que faltan** (ayyūb, waḥda, samāʿī thaqīl, dawr hindī…): Maqam World los lista con su compás, pero
  su patrón de dum y tak solo está en una imagen, sin texto (la página de ayyūb, por ejemplo, dice solo que es
  «rápido, corto y cíclico»). Hace falta Racy (2003), Marcus (2007) o Touma (1996), que ya da los cuatro que hay.
- **Los usul turcos que faltan** (sofyan, semai, aksak semai, devr-i kebir…): hace falta Özkan, *Türk Mûsikîsi
  Nazariyatı ve Usûlleri*, para los golpes (düm, tek, tekâ) de cada uno.
- **Neidhardt:** sus temperamentos circulares (1724, 1732) tienen varias versiones, y sus fracciones de coma solo se
  pueden dar con Lindley en el New Grove o con el tratado.
- **Las piezas de Cork** (*The New Guide to Harmony with LEGO Bricks*): los acordes de cada pieza y sus nombres hay
  que leerlos en el libro.
- **El saz y el koto no caben en el mástil:** el bağlama tiene trastes de menos de un semitono (más de doce por
  octava), y el mástil de `Trastes` cuenta en semitonos; con trastes cromáticos daría posiciones
  falsas. El koto no tiene mástil: trece cuerdas al aire sobre puentes móviles, que se afinan para cada pieza y se
  aprietan para subir la nota. Las afinaciones del koto ya están como escalas (Hirajōshi, Kumoijōshi…).
- **Los acordes de Messiaen:** *Technique de mon langage musical* (1944) los define en el capítulo XIV, «L'accord
  sur dominante» y «L'accord de la résonance» (p. 50, según el índice), pero no se ha podido leer ese capítulo, y sin
  él no se sabe qué notas lleva cada uno. Entrarán cuando se pueda leer.
- **Los trastes microtonales:** el mástil ya sabe de trastes que faltan (los del dulcémele, con su 6½) y de cuerdas
  cortas (la quinta del banjo), pero sus posiciones siguen siendo semitonos enteros. Para el bağlama haría falta
  contar las posiciones en cents y saber dónde está cada traste: en la práctica hay de 17 a 24 por octava, según el
  instrumento y la escuela, y no se ha podido leer una tabla de sus distancias que sirva de fuente. Mientras no la
  haya, el saz no entra en el catálogo.

## Carácter sin fuente

El carácter de una escala o de una tonalidad solo entra con una fuente que se haya podido leer. En noviembre de 2026 se
buscaron, sin encontrar un texto con el que comprobarlas, las fuentes de la segunda fase de la propuesta:

- **Las rasa de los rāgas**: Bor (1999) da la hora y la estación, que ya están, pero no se ha podido ver qué rasa da a
  cada uno.
- **Ḥijāz y los demás maqāmāt**: Touma (1996: 43–44) solo describe Rāst, Bayātī, Sīkāh, Ṣabā y Ḥijāz, y de Ḥijāz dice
  «el desierto lejano», que no es un afecto. Para los demás harían falta Racy (2003) o Farraj y Abu Shumays (2019), que
  advierten que no hay una tabla aceptada.
- **Los makamlar**: los tratados otomanos de musicoterapia (Gevrekzâde Hâfız Hasan, Şuûrî) dan a cada makam una hora y
  una dolencia, pero solo se han encontrado resúmenes que no dicen qué autor lo dice de cada uno.
- **Los dastgāh**: no se ha encontrado en Farhat (1990) ni en During (1991) un pasaje que se pueda citar.
- **Japón, Bizancio y el klezmer**: de In y Yō no se ha encontrado nada citable en Malm (1959); el ēthos de los echoi
  que circula es de Savas, sin obra ni página, y no de Chrysanthos; y lo que la Wikipedia dice de Adonai Malakh
  («majestuoso») y Magen Avot («la paz del sábado») no lleva la nota de su fuente.
- **Mattheson** para las tonalidades (*Das neu-eröffnete Orchestre*, 1713): están Charpentier (en Cessac 1988) y
  Schubart (en Steblin 1983), pero no una traducción de Mattheson que se haya podido leer.
- **Glareano y Zarlino** para los doce modos: los dos los describen (el *Dodecachordon*, 1547, y la cuarta parte de
  las *Istitutioni*, 1558), pero no se han encontrado sus frases en una traducción con página (Miller 1965, Cohen
  1983); la Wikipedia solo da sus nombres y su clasificación.

## Datos comprobados y por confirmar

Comprobado en noviembre de 2026:

- Manuel (1989) ocupa las pp. 70–94 del vol. 21 del Yearbook for Traditional Music, y Cohn (1996) las pp. 9–40 del
  vol. 15 (1) de Music Analysis.
- Busoni ya cuenta las 113 escalas en la primera edición: la traducción de Baker (1911), hecha sobre la de 1907, dice
  «one hundred and thirteen different scales».
- Persichetti trae las once escalas que se le citaban y, además, la superlocria, la de tonos enteros con sensible, la
  doble armónica, la Prometeo y la Prometeo napolitana, que ahora también lo citan. Se ha comprobado en un resumen de
  curso de su capítulo de escalas, no en el libro.
- Tymoczko trata las seis que se le citan en los capítulos 4 y 9 («Scales» y «Scales in Twentieth-Century Music»).

Sin comprobar, porque no se ha podido ver la obra: las páginas de Sam (1988), Williamson (2000), Kubik (1994) y
Taruskin (1996) donde se tratan el pinpeat, el saung, la amadinda y el acorde de los augures, que se citan por la obra
entera; que Levine trae cada uno de los modos de la menor melódica y de
las bebop que se le citan (los temas sí están: menor melódica, disminuidas, tonos enteros, pentatónicas, blues y
bebop), y las doce escalas que se citan de Rechberger (2008).

Orden propuesto:

1. De las europeas, comprobar en Małanicz-Przybylska (2018) las notas exactas de la podhalańska.
2. Una obra para las bebop que faltan y otra para las hexatónicas de dos tríadas (los «triad pairs»).
3. Las fuentes de los demás acordes de nombre propio y de m(add9), con su ortografía.
4. Las tradiciones ausentes, empezando por el shashmaqom, que es vecino de los dastgāh. Cada una necesita una obra
   que dé las notas de cada modo: no se añade ninguna escala sin ella.
