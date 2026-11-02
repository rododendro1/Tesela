# Cambios

## Sin publicar

- **`PresentacionDeDisposiciones`**: las disposiciones de un acorde (de Do3 a Sol5) y una progresión dispuesta con
  el menor movimiento de las voces, con sus filas, su pentagrama, su sonido y, en la progresión, la partitura y el
  MIDI. `PentagramaPresentado` dibuja acordes con sus alturas escritas, y `DisposicionDeAcorde.nombre(en:)` los
  nombra en los quince idiomas (los drops, igual en todos).
- **`PresentacionDeContrapunto`**, la vista de contrapunto de la app de armonía: comprueba un contrapunto de
  especies y lo enseña con una fila por compás (sus notas, los intervalos con el cantus y las faltas que lo tocan),
  las faltas una a una, el sonido de las dos voces (con el compás que suena) y los ficheros para exportar. Trae un
  ejemplo sin faltas de cada especie sobre el cantus en re de Fux.
- **`RecorridoDePartitura`**, «Partitura» en la app del Tonnetz: los acordes de un fichero MIDI, MusicXML, MEI o
  ABC con su ritmo armónico y, entre cada dos tríadas, las transformaciones P, L y R que llevan de una a otra.
  `tramo(hasta:longitud:)` da las tríadas seguidas que se dibujan con sus flechas.
- Textos nuevos en los quince idiomas: contrapunto, especie, los campos del cantus y del contrapunto, el número de
  compás, partitura, anterior, siguiente y la indicación para abrir una partitura.
- Paquete propio: `ArmoniaPresentacion` (lo que enseñan las apps y la línea de comandos, sin SwiftUI) estaba dentro de
  `Packages/ArmoniaUI` y ahora está en `Packages/ArmoniaPresentacion`, con sus pruebas, su CI y su documentación. Su
  historial anterior está en el CHANGELOG de `ArmoniaUI`.
