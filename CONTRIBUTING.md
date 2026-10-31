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
  Linux y la deja en el resumen de cada ejecución; procura que no baje.
- **Dependencias en orden.** Un paquete solo depende de los que tiene debajo, nunca de una app. Si añades un
  módulo o un paquete, sigue el apartado «Añadir un paquete o una app» del README:
  `Scripts/comprobar_dependencias.py` comprueba que el `Package.swift` de la raíz coincide con los de `Packages/`.
- **Textos traducidos.** Un texto nuevo de la interfaz o del motor va en los catorce idiomas.
  `Scripts/comprobar_traducciones.py` avisa de los que faltan.
- **Documentación.** La API pública lleva comentario de documentación. Los enlaces de DocC (``Tipo/miembro`` y
  `<doc:Articulo>`) tienen que apuntar a algo que exista, y los ejemplos de código de los artículos se prueban:
  si cambias uno, regenera sus pruebas con `python3 Scripts/generar_pruebas_de_documentacion.py`.
- **CHANGELOG.** Anota el cambio en el `CHANGELOG.md` de cada paquete que cambie, en la sección de la versión que
  está en marcha. Esas secciones son las notas de la release.

## Comprobaciones

Son las del primer job del CI y no necesitan Swift. Pásalas antes de abrir el pull request:

```sh
python3 Scripts/comprobar_higiene.py
python3 Scripts/comprobar_dependencias.py
python3 Scripts/comprobar_modulos.py
python3 Scripts/comprobar_catalogo.py
python3 Scripts/comprobar_enlaces_docc.py
python3 Scripts/comprobar_traducciones.py
python3 Scripts/generar_pruebas_de_documentacion.py --comprobar
python3 Scripts/notas_de_version.py --actual > /dev/null
```

En cada pull request corren estas comprobaciones y las pruebas en Linux (Swift 6.0 y 6.2). Los jobs de macOS
(las apps, sus pruebas de interfaz y DocC) corren los lunes y a mano desde la pestaña Actions; si tu cambio toca
las apps o la documentación, pide en el pull request que se lancen.

## Pull requests

- Uno por tema, contra `main`, con un título que diga qué cambia.
- Rellena la plantilla: qué cambia, por qué y cómo se ha probado.
- Al contribuir aceptas que tu código se publique con la licencia MIT del proyecto ([LICENSE](LICENSE)).

## Versiones

Las versiones siguen [SemVer](https://semver.org/lang/es/); mientras sean 0.x, una nueva puede quitar lo que una
anterior marcó como obsoleto. Para publicar una, se sube `MARKETING_VERSION` en `project.yml`, se cierra la
sección de esa versión en los CHANGELOG y se etiqueta el commit de `main` (`git tag 0.2.0 && git push origin 0.2.0`):
`.github/workflows/version.yml` crea la release con esas notas y `documentacion.yml` publica la documentación.
