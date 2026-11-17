#!/bin/sh
# Borra las compilaciones (`.build`) de los paquetes del repositorio. Los paquetes que dependen de otro por su
# carpeta (InterfazArmonia de Armonia, los ejemplos de casi todos) pueden quedarse con una compilación vieja de su
# dependencia después de cambiarla: fallan con «no member» que sí está, o el compilador se cae en un `switch` que
# no ve un caso nuevo. Borrarlas lo arregla; la siguiente compilación tarda más.
#
#     ./Scripts/compilacion/limpiar_compilaciones.sh                  # todas
#     ./Scripts/compilacion/limpiar_compilaciones.sh Packages/Armonia # solo las de esas carpetas
set -u
cd "$(dirname "$0")/../.."

if [ $# -gt 0 ]; then
    CARPETAS="$*"
else
    CARPETAS=$(find . -name Package.swift -not -path '*/.build/*' -not -path '*/.swiftpm/*' -exec dirname {} \; | sort)
fi

BORRADAS=0
for carpeta in $CARPETAS; do
    if [ -d "$carpeta/.build" ]; then
        printf '%s\n' "${carpeta#./}/.build"
        rm -rf "$carpeta/.build"
        BORRADAS=$((BORRADAS + 1))
    fi
done
printf 'Compilaciones borradas: %s\n' "$BORRADAS"
