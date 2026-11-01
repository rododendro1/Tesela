#!/usr/bin/env python3
"""Comprueba las traducciones de los textos del motor en los quince idiomas.

Los textos están de dos maneras: en un `Traduccion(…)` con los quince juntos, o en los ficheros por
idioma de cada módulo (`Textos/TextosDeX+Espanol.swift`, `…+Ingles.swift`…), donde cada campo de
`TextosDeX` tiene su texto en cada fichero. El compilador ya obliga a dar los quince, pero no impide
copiar uno que no toca. Se miran los textos literales (los que se montan con código no se pueden leer
aquí) y se avisa de tres cosas:

  1. un texto en alemán, ruso o griego idéntico al inglés (y distinto del español), que suele ser
     un texto que se quedó sin traducir;
  2. un texto en ruso sin letras cirílicas o en griego sin letras griegas, aunque tenga palabras;
  3. una misma frase en español (de dos palabras o más) traducida de dos maneras en un idioma.

Las órdenes y las opciones de la línea de comandos (`armonia …`, `--…`) y las sintaxis de la ayuda
se escriben igual en todos los idiomas, así que no cuentan. Los textos que son iguales a propósito
van en EXCEPCIONES.

Uso:  python3 Scripts/comprobaciones/comprobar_traducciones.py     (sale con 1 si hay un problema)
"""
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]

from idiomas import CODIGOS as IDIOMAS, CODIGO_DEL_FICHERO, comprobar as comprobar_idiomas

# Textos que se escriben igual que en inglés a propósito.
EXCEPCIONES = {
    "help",     # el nombre de la orden
    "Symbol",   # alemán: también es la palabra alemana
    "Name",     # alemán: también es la palabra alemana
    "completion bash|zsh|fish",  # la sintaxis de la orden, con los nombres de las terminales
    "manual",   # el nombre de la orden
}

_TEXTO = r'"((?:[^"\\]|\\.)*)"'
_TRADUCCION = re.compile(
    r"Traduccion\(\s*" + _TEXTO + r"\s*,\s*" + _TEXTO
    + "".join(rf"\s*,\s*{etiqueta}:\s*" + _TEXTO for etiqueta in IDIOMAS[2:])
    + r"\s*\)",
    re.S,
)


def sin_codigo(texto: str) -> str:
    """El texto sin interpolaciones, órdenes ni opciones de la línea de comandos."""
    texto = re.sub(r"\\\([^)]*\)", "", texto)
    texto = re.sub(r"armonia [^\n]*", "", texto)
    return re.sub(r"--\S+", "", texto)


# Los ficheros por idioma: `TextosDeTrastes+Euskera.swift` tiene los textos en euskera.
FICHEROS_DE_IDIOMA = CODIGO_DEL_FICHERO
_FICHERO_DE_IDIOMA = re.compile(r"/Textos/(TextosDe\w+)\+(\w+)\.swift$")
# Un campo de una línea: `nombre: "texto",` o, si lleva valores, `nombre: { a, b in "texto" },`.
_CAMPO = re.compile(r"^ {8}(\w+): (?:\{ [\w, ]+ in )?" + _TEXTO + r"(?: \})?,?$", re.M)


def traducciones():
    try:
        archivos = subprocess.check_output(["git", "ls-files", "*.swift"], cwd=RAIZ, text=True,
                                           stderr=subprocess.DEVNULL).split()
    except (OSError, subprocess.CalledProcessError):    # sin git (un zip, por ejemplo): se recorre el árbol
        saltar = {".git", ".build", ".swiftpm", "DerivedData", "build", "node_modules"}
        archivos = sorted(str(r.relative_to(RAIZ)) for r in RAIZ.rglob("*.swift")
                          if not (set(r.relative_to(RAIZ).parts) & saltar))
    por_campo = defaultdict(dict)
    for archivo in archivos:
        if "/Tests/" in archivo:
            continue
        codigo = (RAIZ / archivo).read_text(encoding="utf-8")
        for m in _TRADUCCION.finditer(codigo):
            linea = codigo.count("\n", 0, m.start()) + 1
            yield f"{archivo}:{linea}", dict(zip(IDIOMAS, m.groups()))
        fichero = _FICHERO_DE_IDIOMA.search(archivo)
        if fichero and fichero.group(2) in FICHEROS_DE_IDIOMA:
            for m in _CAMPO.finditer(codigo):
                por_campo[(fichero.group(1), m.group(1))][FICHEROS_DE_IDIOMA[fichero.group(2)]] = m.group(2)
    for (estructura, campo), textos in sorted(por_campo.items()):
        if len(textos) == len(IDIOMAS):
            yield f"{estructura}.{campo}", textos


def main() -> int:
    errores = []
    frases = defaultdict(lambda: defaultdict(dict))
    cuantas = 0
    for lugar, textos in traducciones():
        cuantas += 1
        ingles = textos["en"]
        if "--" in ingles:
            # Una sintaxis de orden («tabla --chord | --scale…»): se escribe igual en todos.
            continue
        for idioma in ("de", "ru", "el"):
            texto = textos[idioma]
            if (texto == ingles and texto != textos["es"] and texto not in EXCEPCIONES
                    and re.search(r"[A-Za-z]{4}", sin_codigo(texto))):
                errores.append(f"{lugar}: en {idioma}, «{texto}» es igual que en inglés")
        for idioma, letras in (("ru", "[а-яё]"), ("el", "[α-ωάέήίόύώϊϋΐΰ]")):
            texto = sin_codigo(textos[idioma])
            if (textos[idioma] not in EXCEPCIONES and re.search(r"[A-Za-z]{3}", texto)
                    and not re.search(letras, texto, re.I)):
                errores.append(f"{lugar}: en {idioma}, «{textos[idioma]}» no tiene letras de su alfabeto")
        espanol = textos["es"]
        if " " in espanol and "\\(" not in espanol:
            for idioma in IDIOMAS[1:]:
                frases[espanol][idioma].setdefault(textos[idioma], lugar)

    for espanol, por_idioma in frases.items():
        for idioma, variantes in por_idioma.items():
            if len(variantes) > 1:
                lista = "; ".join(f"«{t}» ({lugar})" for t, lugar in variantes.items())
                errores.append(f"«{espanol}» se traduce de {len(variantes)} maneras en {idioma}: {lista}")

    print(f"{cuantas} traducciones literales revisadas.")
    if cuantas == 0:
        # Si `Traduccion` cambia de forma (otro idioma, otras etiquetas), la expresión deja de encontrarlas.
        errores.append("no se ha encontrado ninguna Traduccion literal: ¿ha cambiado IDIOMAS?")
    if not comprobar_idiomas():
        errores.append("Scripts/comprobaciones/idiomas.py no tiene los códigos de `Idioma.codigo`, en su orden")
    if errores:
        print(f"\n{len(errores)} problema(s):")
        for e in errores:
            print("  -", e)
        return 1
    print("Traducciones correctas.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
