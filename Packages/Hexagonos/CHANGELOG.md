# Cambios

## Sin publicar

- **Cambio incompatible:** `CoordenadaCubica(validando:_:_:)` es ahora `CoordenadaCubica(comprobando:r:s:)`, como los
  `init?(comprobando:)` de Armonía: `nil` si las tres no suman cero, para coordenadas que vienen de fuera.
- **Cambio incompatible:** `Trazado.limites(de:)` y `MapaHexagonal.limites(con:)` dan un `Rectangulo` en lugar de la
  tupla `(minimo:, maximo:)`. Los campos se llaman igual, así que `caja.minimo` sigue valiendo; solo cambia lo que
  desestructura (`let (a, b) = …`). `Rectangulo` es `Hashable`, `Sendable` y `Codable`, y da además `ancho`, `alto` y
  `centro`.

## 0.1.0 (2026-10-31)

Primera versión con etiqueta del repositorio: `0.1.0`.

- El paquete pide Swift 6.0 o posterior y compila en el modo de lenguaje 6. Antes pedía Swift 5.9.

- `longitud` pasa a ser `distanciaAlOrigen` en `CoordenadaAxial` y `CoordenadaCubica`: son los pasos hasta el origen.
  Sin alias.

- Desaparecen los nombres marcados como obsoletos: `Disposicion` (es `Trazado`), `distancia(a:)` (es
  `distancia(hasta:)`), `ve(_:tapada:)` (es `esVisible(_:tapada:)`), `DireccionHexagonal.girada(sextos:)` (es
  `rotada(sextos:)`) y `MapaHexagonal.girado(sextos:alrededorDe:)` (es `rotado(sextos:alrededorDe:)`).

Rejillas hexagonales sin dependencias, solo con la biblioteca estándar y Foundation:

- Coordenadas axiales, cúbicas, desplazadas (cuatro variantes), dobladas (dos) y fraccionarias, y las conversiones
  entre ellas.
- Vecindad: `DireccionHexagonal` con su punto cardinal en cada orientación, vecinos, diagonales y distancias.
- Líneas y visibilidad (`linea(hasta:)`, `esVisible(_:tapada:)`, `visibles(en:tapada:)`), regiones (`alcance`, `anillo`,
  `espiral`, `FormasDeMapa`) y simetrías (rotaciones y reflexiones).
- Movimiento: `alcanzables`, `camino(hasta:por:)` y, con coste, `caminoMasBarato(hasta:)` (A*) y
  `alcanzables(presupuesto:)` (Dijkstra).
- `MapaHexagonal<Valor>`: un valor por casilla, con vecinas, simetrías, caminos y visibilidad, y `Codable`.
- Dibujo: `Trazado` (puntiaguda o plana), `centro(de:)`, `casilla(en:)`, `vertices(de:)` y `svg(_:)`.
- Un ejemplo ejecutable, `Ejemplos/EjemploHexagonos` (`swift run EjemploHexagonos`), que recorre la API y dibuja
  los mapas en el terminal.

### Terminología

Los nombres anteriores estuvieron marcados como obsoletos y ya se han quitado.

- `Disposicion` pasa a `Trazado`: «disposición» es, en armonía, el orden de las voces de un acorde.
- `distancia(a:)` pasa a `distancia(hasta:)` en las cuatro coordenadas, como `linea(hasta:)` y `camino(hasta:por:)`.
- `DireccionHexagonal.girada(sextos:)` pasa a `rotada(sextos:)`, y `MapaHexagonal.girado(sextos:alrededorDe:)` a
  `rotado(sextos:alrededorDe:)`, como `CoordenadaAxial.rotada(sextos:alrededorDe:)`.
- `CoordenadaAxial.ve(_:tapada:)` pasa a `esVisible(_:tapada:)`.

Se usa desde otro proyecto con `.package(url: "https://github.com/rododendro1/Tesela.git", branch: "main")` y el
producto `Hexagonos`.
