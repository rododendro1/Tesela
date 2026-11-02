#!/bin/sh
# Empaqueta un ejecutable `armonia` ya compilado para publicarlo en una release: el binario, la página de manual
# en español y en inglés, el completado para bash, zsh y fish, y la licencia, en `<nombre>.tar.gz` (con su
# `.sha256` al lado). El manual y el completado los genera el propio binario, así que salen siempre al día.
#
#     ./Scripts/empaquetar_cli.sh .build/release/armonia armonia-0.3.0-linux-x86_64
#
# Si el binario no es de esta máquina (uno compilado para otra arquitectura), pasa un tercer argumento con otro
# `armonia` que sí se pueda ejecutar para generar los ficheros: los textos son los mismos.
#
# Dentro del paquete:
#
#     armonia                       el ejecutable
#     share/man/man1/armonia.1      el manual (man ./share/man/man1/armonia.1)
#     share/man/en/man1/armonia.1   el manual en inglés
#     completado/armonia.bash       source completado/armonia.bash
#     completado/armonia.zsh        source completado/armonia.zsh (en ~/.zshrc)
#     completado/armonia.fish       en ~/.config/fish/completions/
#     LICENSE
set -eu

BINARIO=$1
NOMBRE=$2
GENERADOR=${3:-$1}
# Sin barra, el shell buscaría el generador en el PATH.
case $GENERADOR in */*) ;; *) GENERADOR=./$GENERADOR ;; esac
RAIZ=$(cd "$(dirname "$0")/.." && pwd)

DESTINO=$(mktemp -d)
trap 'rm -rf "$DESTINO"' EXIT
CARPETA="$DESTINO/$NOMBRE"
mkdir -p "$CARPETA/share/man/man1" "$CARPETA/share/man/en/man1" "$CARPETA/completado"

cp "$BINARIO" "$CARPETA/armonia"
chmod 755 "$CARPETA/armonia"
"$GENERADOR" manual > "$CARPETA/share/man/man1/armonia.1"
"$GENERADOR" manual --ingles > "$CARPETA/share/man/en/man1/armonia.1"
"$GENERADOR" completado bash > "$CARPETA/completado/armonia.bash"
"$GENERADOR" completado zsh > "$CARPETA/completado/armonia.zsh"
"$GENERADOR" completado fish > "$CARPETA/completado/armonia.fish"
cp "$RAIZ/LICENSE" "$CARPETA/LICENSE"

tar -C "$DESTINO" -czf "$NOMBRE.tar.gz" "$NOMBRE"
if command -v sha256sum > /dev/null; then
    sha256sum "$NOMBRE.tar.gz" > "$NOMBRE.tar.gz.sha256"
else
    shasum -a 256 "$NOMBRE.tar.gz" > "$NOMBRE.tar.gz.sha256"
fi
echo "$NOMBRE.tar.gz"
