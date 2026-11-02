#!/bin/bash
# Swift decide qué recompilar por la fecha de cada fichero, y actions/checkout las pone todas a la hora de la
# descarga: con eso, un .build recuperado no ahorraría nada. Así que todos los ficheros del repositorio pasan a
# una misma fecha fija (la que tenían también al compilar lo que se guardó) y los que han cambiado desde el commit
# del .build recuperado, a la hora actual. Si no se puede saber qué ha cambiado, se borra lo recuperado: más vale
# compilarlo todo que fiarse de algo viejo.
set -euo pipefail

git config --global --add safe.directory "$GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"
git ls-files -z | xargs -0 touch -c -m -d "2000-01-01 00:00:00 UTC"

[ -n "$RECUPERADA" ] || { echo "Sin caché: se compila todo."; exit 0; }
commit=${RECUPERADA#"$PREFIJO"}
if git fetch -q --depth=1 origin "$commit" && git cat-file -e "$commit^{commit}"; then
  # Al borrar o renombrar un fichero de Swift, lo que se compiló contra él puede no recompilarse: con Swift 6.0, un
  # ejecutable guardado seguía enlazando con `Notacion.espanolUnicode` después de quitarla. Mejor compilarlo todo.
  if [ -n "$(git diff --diff-filter=DR --name-only "$commit" HEAD -- '*.swift')" ]; then
    echo "Desde ${commit:0:7} se ha borrado o renombrado algún fichero de Swift: se compila todo."
    while IFS= read -r ruta; do [ -n "$ruta" ] && rm -rf "$ruta"; done <<< "$RUTAS"
    exit 0
  fi
  cambiados=$(git diff --name-only "$commit" HEAD | wc -l)
  git diff -z --name-only "$commit" HEAD | xargs -0 -r touch -c -m
  # Al cambiar el código de un módulo, lo que lo usa desde otro módulo puede no recompilarse aunque cambie la forma de
  # un tipo: con un campo nuevo en `Evento`, ArmoniaUI y los ejemplos seguían con el tamaño viejo y se caían al leer
  # uno. Así que se recompila todo el código propio; lo recuperado sigue sirviendo cuando solo cambian las pruebas.
  if [ -n "$(git diff --name-only "$commit" HEAD -- '*/Sources/*.swift')" ]; then
    echo "Desde ${commit:0:7} ha cambiado el código de algún módulo: se recompila todo el código propio."
    git ls-files -z '*.swift' | xargs -0 -r touch -c -m
  fi
  echo "Caché de ${commit:0:7}: $cambiados ficheros cambiados desde entonces."
else
  echo "::warning::No se encuentra el commit $commit de la caché; se compila todo."
  while IFS= read -r ruta; do [ -n "$ruta" ] && rm -rf "$ruta"; done <<< "$RUTAS"
fi
