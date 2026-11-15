#!/usr/bin/env python3
"""Comprueba los TSV que escribe `Ejemplos/EjemploCatalogos`, uno por catálogo.

El CI ya ejecuta el ejemplo, pero eso solo dice que no se cae: una columna que se queda vacía porque cambió la API,
una fila con una celda de más o un catálogo que deja de escribirse pasarían sin que nadie lo viera. Este script mira:

  - Que están todos los ficheros que nombra el ejemplo (`fichero: "….tsv"` en sus fuentes), y ninguno más.
  - Que cada uno tiene filas, una cabecera sin columnas repetidas y, en cada fila, tantas celdas como columnas.
  - Que la primera celda (el nombre o la clave) no está vacía y que no hay dos filas iguales.
  - Que ninguna columna está vacía en todas las filas, salvo las de datos que un catálogo puede no tener aún en
    ninguno de sus elementos: los alias y las variantes de un idioma, el carácter y la fecha de origen
    (`COLUMNAS_QUE_PUEDEN_ESTAR_VACIAS`).
  - Que ninguna celda empieza ni acaba con espacios: en una lista separada por espacios, es un elemento vacío (el
    cifrado de la tríada mayor, que es «»).

Uso: python3 Scripts/comprobaciones/comprobar_tsv.py [carpeta]
Sin carpeta, ejecuta antes el ejemplo (`swift run EjemploCatalogos`) en una carpeta temporal.
"""
import csv
import re
import subprocess
import sys
import tempfile
from collections import Counter
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
EJEMPLO = RAIZ / "Ejemplos" / "EjemploCatalogos"
FICHERO = re.compile(r'fichero:\s*"([^"]+\.tsv)"')
COLUMNAS_QUE_PUEDEN_ESTAR_VACIAS = re.compile(
    r"^((alias|variantes)(_en_\w+)?|afectos|momentos|caracter|anio_de_origen|epoca_de_origen)$")


def ficheros_esperados():
    return sorted({m for f in (EJEMPLO / "Sources").rglob("*.swift") for m in FICHERO.findall(f.read_text("utf-8"))})


def errores_de(fichero):
    errores = []
    with fichero.open(encoding="utf-8", newline="") as f:
        filas = list(csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE))
    if len(filas) < 2:
        return [f"{fichero.name}: no tiene filas"]
    cabecera, cuerpo = filas[0], filas[1:]
    repetidas = [c for c, n in Counter(cabecera).items() if n > 1]
    if repetidas:
        errores.append(f"{fichero.name}: columnas repetidas: {', '.join(repetidas)}")
    for i, fila in enumerate(cuerpo, start=2):
        if len(fila) != len(cabecera):
            errores.append(f"{fichero.name}:{i}: {len(fila)} celdas y {len(cabecera)} columnas")
            continue
        if not fila[0]:
            errores.append(f"{fichero.name}:{i}: la primera celda ({cabecera[0]}) está vacía")
        for columna, celda in zip(cabecera, fila):
            if celda != celda.strip():
                errores.append(f"{fichero.name}:{i}: «{columna}» empieza o acaba con espacios")
    for fila, n in Counter(map(tuple, cuerpo)).items():
        if n > 1:
            errores.append(f"{fichero.name}: la fila de «{fila[0]}» está {n} veces")
    completas = [fila for fila in cuerpo if len(fila) == len(cabecera)]
    for j, columna in enumerate(cabecera):
        if not COLUMNAS_QUE_PUEDEN_ESTAR_VACIAS.match(columna) and all(not fila[j] for fila in completas):
            errores.append(f"{fichero.name}: la columna «{columna}» está vacía en todas las filas")
    return errores


def comprobar(carpeta):
    esperados = ficheros_esperados()
    if not esperados:
        return [f"No encuentro ningún `fichero: \"….tsv\"` en {EJEMPLO.relative_to(RAIZ)}/Sources"]
    escritos = sorted(p.name for p in carpeta.glob("*.tsv"))
    errores = [f"Falta {nombre}" for nombre in esperados if nombre not in escritos]
    errores += [f"{nombre} no lo nombra el ejemplo" for nombre in escritos if nombre not in esperados]
    for nombre in esperados:
        if (carpeta / nombre).exists():
            errores += errores_de(carpeta / nombre)
    return errores


def main():
    if len(sys.argv) > 2:
        print(__doc__, file=sys.stderr)
        return 2
    with tempfile.TemporaryDirectory() as temporal:
        if len(sys.argv) == 2:
            carpeta = Path(sys.argv[1]).resolve()
        else:
            carpeta = Path(temporal)
            subprocess.run(["swift", "run", "-q", "EjemploCatalogos", str(carpeta)], cwd=EJEMPLO, check=True,
                           stdout=subprocess.DEVNULL)
        errores = comprobar(carpeta)
        total = len(list(carpeta.glob("*.tsv")))
    for error in errores:
        print(error)
    if errores:
        print(f"{len(errores)} problema(s) en los TSV.")
        return 1
    print(f"TSV correctos ({total} ficheros).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
