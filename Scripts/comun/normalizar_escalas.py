#!/usr/bin/env python3
"""`TipoDeEscala.normalizar` en Python, para los scripts que comparan nombres de escalas.

Es una copia de la función de Swift (`Teoria/Escalas/TipoDeEscala.swift`): minúsculas, sin diacríticos
(salvo en las escrituras índicas, la tailandesa, la birmana y la jemer), ی ى → ي y ک → ك, ♯/♭ como #/b, sin ♮ ni ordinales (4ª), «−» como «-», «…» como «..», la ı sin punto del
turco como i y un solo espacio entre palabras. Para que las dos no se separen, las dos leen los mismos casos de `Scripts/datos/normalizar.tsv`: el test de
Swift (`NormalizarVectoresTests`) y este script.

Uso:  python3 Scripts/comun/normalizar_escalas.py --comprobar     (sale con 1 si algún caso no coincide)
Los otros scripts lo importan: `from normalizar_escalas import normalizar`.
"""
import re
import sys
import unicodedata
from pathlib import Path

VECTORES = Path(__file__).resolve().parents[1] / "datos" / "normalizar.tsv"
_SUSTITUCIONES = (
    ("♯", "#"), ("♭", "b"), ("♮", ""), ("ª", ""), ("−", "-"), ("…", ".."), ("ı", "i"),
    ("\u06cc", "\u064a"), ("\u0649", "\u064a"), ("\u06a9", "\u0643"),  # ی ى → ي, ک → ك
)
# Las escrituras con las vocales en signos combinantes, que no se quitan: las de la India, la tailandesa y la lao,
# la birmana y la jemer.
_CON_VOCALES_EN_SIGNOS = ((0x0900, 0x0DFF), (0x0E00, 0x0EFF), (0x1000, 0x109F), (0x1780, 0x17FF))


def normalizar(texto):
    con_vocales_en_signos = any(a <= ord(c) <= b for c in texto for a, b in _CON_VOCALES_EN_SIGNOS)
    for antes, despues in _SUSTITUCIONES:
        texto = texto.replace(antes, despues)
    if not con_vocales_en_signos:
        texto = "".join(c for c in unicodedata.normalize("NFD", texto) if unicodedata.category(c) != "Mn")
    return " ".join(p for p in re.split(r"[ \-]", texto.casefold()) if p)


def vectores():
    """(entrada, esperado) de cada línea del fichero de casos; `#` abre un comentario."""
    for n, linea in enumerate(VECTORES.read_text(encoding="utf-8").split("\n"), start=1):
        if not linea.strip() or linea.startswith("#"):
            continue
        partes = linea.split("\t")
        if len(partes) != 2:
            sys.exit(f"{VECTORES.name}:{n}: se esperaban dos columnas separadas por un tabulador")
        yield n, partes[0], partes[1]


def comprobar():
    fallos = [(n, e, esperado, normalizar(e)) for n, e, esperado in vectores() if normalizar(e) != esperado]
    for n, entrada, esperado, obtenido in fallos:
        print(f"  - {VECTORES.name}:{n}: «{entrada}» da «{obtenido}», no «{esperado}»")
    return not fallos


if __name__ == "__main__":
    if "--comprobar" in sys.argv:
        if not comprobar():
            sys.exit(1)
        print(f"Normalización coherente con los casos ({sum(1 for _ in vectores())}).")
    else:
        print(__doc__)
