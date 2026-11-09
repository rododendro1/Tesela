# Huecos del catálogo de escalas y acordes

Estado a 9 de noviembre de 2026, tras la 0.4.4 y el PR #264.

## Resumen

En main quedan 10 escalas de otras tradiciones y 30 escalas occidentales sin ninguna referencia. Faltan además una
sexta aumentada y cuatro acordes de nombre propio. El catálogo tiene 434 escalas en 49 listas de tradición y 49
acordes, todos con nombre en los doce idiomas. Lo más rápido de cerrar son las europeas (7 escalas de una lista) y la
sexta suiza.

## Escalas sin ninguna referencia

Son 10 escalas en 3 listas, según `comprobar_catalogo.py`. Ninguna de las tres listas tiene referencia propia, así que
una sola obra por lista bastaría para cubrirlas.

| Lista | Escalas sin fuente | Total en la lista | Qué haría falta |
| --- | --- | --- | --- |
| Europeas | dórico ucraniano, podhalańska, pentatónica húngara, cuerno alpino, gaita escocesa, georgiana, istriana | 7 | Una obra por escala, porque cada una es de un país |
| Sudeste asiático | pinpeat, saung | 3 | Una fuente sobre la música jemer y otra sobre la birmana; el piphat ya cita a Morton (1976) |
| Africanas | amadinda | 7 | Una fuente sobre el xilófono de Uganda; las otras seis citan a Tracey, Berliner o Knight |

## Tradiciones cortas o ausentes

El sudeste asiático y África son las tradiciones con menos escalas del catálogo. Cuatro tradiciones no están. Las
cifras de las que sí están son las escalas declaradas en su fichero del catálogo.

| Tradición | Escalas ahora | Qué falta |
| --- | --- | --- |
| Sudeste asiático | 3 (piphat, pinpeat, saung) | Los pathet laosianos, los modos filipinos del kulintang y más escalas jemeres y birmanas |
| África | 7 (amadinda, timbila, cuatro de la kora, nyamaropa) | Las escalas de África occidental fuera de la kora, como las del balafon, y las del Sahel |
| Asia Central | ninguna | El shashmaqom de Bujará y Samarcanda |
| Magreb | ninguna | Los ṭubūʿ de las nubas andalusíes |
| Mongolia | ninguna | Las pentatónicas del canto largo y del morin khuur |
| Uigures | ninguna | Los doce muqam |

Son más largas India (62), Turquía (39) y el mundo árabe (35).

## Escalas occidentales sin fuente

De las 112 escalas occidentales, 30 no citan ninguna obra. Son las alteradas que no tienen siete notas y que, por
tanto, Busoni no cubre.

| Grupo | Escalas | Cuántas |
| --- | --- | --- |
| Pentatónicas alteradas | dominante, menor 6, mayor ♭6, menor ♭5, mayor ♭3, menor ♭6, mixolidia, lidia, escocesa, egipcia | 10 |
| Hexatónicas | jónico sin 4ª, mixolidio sin 3ª, dórico sin 6ª, eólico sin 2ª, de dos tríadas (mayor y menor), de armónicos, trítono de dos semitonos, Prometeo napolitana | 9 |
| Cromáticas con alteraciones | con uno, dos, tres y cinco bemoles, con cinco sostenidos | 5 |
| De ocho o nueve notas | bebop locrio, bebop lidio, bebop menor armónica, argelina, blues de nueve notas, blues menor con 2ª | 6 |

Las bebop podrían citar a Levine (1995), como ya hacen las otras bebop, si se comprueba que las trae. Las hexatónicas
de dos tríadas encajarían en Cohn (1996), que ya está en el catálogo.

## Acordes que faltan

Tras el PR #264 hay 41 acordes genéricos y 8 de nombre propio. Faltan estos:

| Acorde | Notas | Fuente posible | Por qué no está |
| --- | --- | --- | --- |
| Sexta aumentada suiza | La♭ Do Re♯ Fa♯ (sobre La♭) | Aldwell, Schachter y Cadwallader (2011) | El lector de acordes no admite la cuarta doble aumentada; hay que tocar `ClasificacionDeAcorde` |
| m(add9) | Do Mi♭ Sol Re (sobre Do) | Ninguna del catálogo | Sin fuente |
| Acorde de Elektra | Re♭ Fa La♭ + Mi Sol♯ Si | Kramer (1993) o Abbate (1989) | Su ortografía varía entre fuentes; hay que leer la partitura o la fuente |
| Acorde de los augures (*La consagración de la primavera*) | Fa♭ La♭ Do♭ + Mi♭ Sol Si♭ Re♭ | Taruskin (1996) o van den Toorn (1983) | Sin fuente verificada en el catálogo |
| Acorde de la Sinfonía de los salmos | Mi Sol Si con la tercera doblada | White (1979) | Sin fuente verificada |
| Acorde alfa de Lendvai | Las dos séptimas disminuidas superpuestas | Lendvai (1971), ya en el catálogo | Hay que confirmar en el libro qué notas da |

Los acordes de Hendrix y mu ya están, pero no citan ninguna obra.

## Datos por confirmar y orden propuesto

Antes de añadir nada conviene confirmar tres datos que ya están en el catálogo:

- Las páginas citadas de Manuel (1989) y de Cohn (1996).
- Que Persichetti, Tymoczko, Rechberger y Levine traen cada escala y cada acorde a los que se citan, porque se citan
  por capítulos y no por página.
- Que la edición de 1907 de Busoni ya cuenta las 113 escalas; la cita es a la de 1916, p. 41.

Orden propuesto:

1. La sexta suiza: la fuente ya está y solo hace falta el cambio en el lector.
2. Las europeas, el pinpeat, el saung y la amadinda: diez escalas que solo necesitan sus fuentes.
3. Las bebop y las hexatónicas de dos tríadas, con Levine y Cohn.
4. Los acordes de nombre propio, cuando haya fuentes con su ortografía.
5. Las tradiciones ausentes, empezando por el shashmaqom, que es vecino de los dastgāh.
