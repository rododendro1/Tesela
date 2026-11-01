# Cómo contribuir

Gracias por echar una mano. Tesela está escrito en castellano (el código, la documentación y los mensajes de
commit), y lo que entra conviene que siga igual.

## Antes de empezar

- Para un error, abre un issue con la plantilla «Error» y lo que hace falta para reproducirlo: la versión, la
  plataforma y, si se puede, el cifrado, la escala o el fichero que lo provoca.
- Para algo nuevo, abre primero un issue con la plantilla «Propuesta» y espera a hablarlo, sobre todo si cambia la
  API pública de un paquete o añade un paquete o una app.
- Un fallo de seguridad no va en un issue: mira [SECURITY.md](SECURITY.md).

## Preparar el entorno

Los paquetes solo necesitan Swift 6.0 o posterior, en macOS o en Linux; las apps, además, macOS con Xcode y
XcodeGen. Los pasos están en el apartado «Empezar» del [README](README.md):

```sh
cd Packages/Armonia && swift test        # el motor
cd Packages/Hexagonos && swift test      # las rejillas hexagonales
cd Packages/ArmoniaUI && swift test      # la interfaz (en Linux, solo la parte sin SwiftUI)
./Scripts/compilar_todo.sh               # todo, por capas, como el CI
```

## Qué debe llevar un cambio

- **Pruebas.** Todo cambio de comportamiento lleva su prueba en el paquete que cambia. El CI mide la cobertura en
  Linux y la deja en el resumen de cada ejecución, y falla si el porcentaje de funciones o de líneas probadas de un
  paquete baja de su mínimo (en el job `cobertura` de `.github/workflows/ci.yml`). Si tu cambio lo sube, sube también
  el mínimo. Lo que lee ficheros de fuera tiene además pruebas con ficheros estropeados al azar
  (`ImportacionAlAzarTests`): si tocas esa lectura, añade ahí los casos nuevos.
- **Dibujos.** Los SVG del pentagrama, el Tonnetz, la tabla armónica y los teclados se comparan con los guardados en
  `Packages/Armonia/Tests/ArmoniaTests/Referencias` (`ReferenciasSVGTests`). Si cambias un dibujo a propósito,
  regenéralos con `TESELA_REGENERAR_REFERENCIAS=1 swift test --filter ReferenciasSVGTests` (en `Packages/Armonia`) y
  revisa el diff: es lo que verá quien revise el pull request.
- **Dependencias en orden.** Un paquete solo depende de los que tiene debajo, nunca de una app. Si añades un
  módulo o un paquete, sigue el apartado «Añadir un paquete o una app» del README:
  `Scripts/comprobaciones/comprobar_dependencias.py` comprueba que el `Package.swift` de la raíz coincide con los de `Packages/`.
- **Textos traducidos.** Un texto nuevo de la interfaz o del motor va en los quince idiomas.
  `Scripts/comprobaciones/comprobar_traducciones.py` avisa de los que faltan.
- **Documentación.** La API pública lleva comentario de documentación. Los enlaces de DocC (``Tipo/miembro`` y
  `<doc:Articulo>`) tienen que apuntar a algo que exista, y los ejemplos de código de los artículos se prueban:
  si cambias uno, regenera sus pruebas con `python3 Scripts/generadores/generar_pruebas_de_documentacion.py`.
- **CHANGELOG.** Anota el cambio en el `CHANGELOG.md` de cada paquete que cambie, en la sección `## Sin publicar`
  (la primera; créala si no está). Al publicar una versión, esa sección pasa a ser la de la versión y sus notas son
  las de la release.

## Formato

El código Swift sigue el formato de [swift-format](https://github.com/swiftlang/swift-format), que viene con
Swift 6, con la configuración de `.swift-format` (4 espacios, 120 columnas). Antes de abrir el pull request:

```sh
swift format -i -r --parallel Packages Apps Ejemplos Herramientas Package.swift   # lo arregla
swift format lint --strict -r --parallel Packages Apps Ejemplos Herramientas Package.swift   # lo comprueba, como el CI
```

Las tablas de datos (los nombres de escalas y los textos traducidos) y las pruebas generadas empiezan con
`// swift-format-ignore-file`: tienen una fila por línea, que es como las leen los scripts de `Scripts/`, y no se
formatean. Si añades otra tabla así, ponle esa marca.

Los commits que solo cambian el formato o mueven ficheros van en `.git-blame-ignore-revs`, para que `git blame`
los salte (GitHub lo hace solo; en local, `git config blame.ignoreRevsFile .git-blame-ignore-revs`). Si haces uno
así, añádelo después de fusionarlo.

## Comprobaciones

Son las del primer job del CI y no necesitan Swift. Pásalas antes de abrir el pull request:

```sh
python3 Scripts/comprobaciones/comprobar_higiene.py
python3 Scripts/comprobaciones/comprobar_dependencias.py
python3 Scripts/comprobaciones/comprobar_modulos.py
python3 Scripts/comprobaciones/comprobar_catalogo.py
python3 Scripts/comprobaciones/comprobar_enlaces_docc.py
python3 Scripts/comprobaciones/comprobar_traducciones.py
python3 Scripts/generadores/generar_pruebas_de_documentacion.py --comprobar
python3 Scripts/comprobaciones/notas_de_version.py --comprobar
```

En cada pull request corren estas comprobaciones, la del formato y las pruebas en Linux (Swift 6.0 y 6.2). Si el pull
request cambia las apps, `ArmoniaUI` o el proyecto de Xcode, las dos apps se compilan además en macOS (el job `apps`). Los
demás jobs de macOS (las pruebas de interfaz, el simulador de iOS y DocC) corren los lunes y a mano desde la pestaña
Actions; si tu cambio toca las vistas o la documentación, pide en el pull request que se lancen.

## Pull requests

- Uno por tema, contra `main`, con un título que diga qué cambia.
- Rellena la plantilla: qué cambia, por qué y cómo se ha probado.
- Al contribuir aceptas que tu código se publique con la licencia MIT del proyecto ([LICENSE](LICENSE)).

## Versiones

Las versiones siguen [SemVer](https://semver.org/lang/es/); mientras sean 0.x, una nueva puede quitar lo que una
anterior marcó como obsoleto. Para publicar una:

```sh
python3 Scripts/comprobaciones/notas_de_version.py --publicar 0.2.0   # «Sin publicar» pasa a «0.2.0 (fecha)» y sube MARKETING_VERSION
# … pull request con ese cambio, y fusionarlo …
git tag 0.2.0 && git push origin 0.2.0                 # en el commit de main
```

Con la etiqueta, `.github/workflows/version.yml` crea la release con las notas de esa versión y `documentacion.yml`
publica la documentación.
