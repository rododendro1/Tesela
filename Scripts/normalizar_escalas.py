#!/usr/bin/env python3
"""`TipoDeEscala.normalizar` en Python, para los scripts que comparan nombres de escalas.

Es una copia de la función de Swift (`ArmoniaTeoria/Escalas/TipoDeEscala+Catalogo.swift`): minúsculas, sin diacríticos
(salvo en devanagari), ♯/♭ como #/b, sin ♮ ni ordinales (4ª), «−» como «-», «…» como «..» y un solo espacio entre
palabras. Para que las dos no se separen, las dos leen los mismos casos de `Scripts/vectores/normalizar.tsv`: el test de
Swift (`NormalizarVectoresTests`) y este script.

Uso:  python3 Scripts/normalizar_escalas.py --comprobar     (sale con 1 si algún caso no coincide)
Los otros scripts lo importan: `from normalizar_escalas import normalizar`.
"""
import re
import sys
import unicodedata
from pathlib import Path

VECTORES = Path(__file__).resolve().parent / "vectores" / "normalizar.tsv"
_SUSTITUCIONES = (("♯", "#"), ("♭", "b"), ("♮", ""), ("ª", ""), ("−", "-"), ("…", ".."))


def normalizar(texto):
    devanagari = any(0x0900 <= ord(c) <= 0x097F for c in texto)
    for antes, despues in _SUSTITUCIONES:
        texto = texto.replace(antes, despues)
    if not devanagari:
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
