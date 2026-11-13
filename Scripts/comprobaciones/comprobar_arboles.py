#!/usr/bin/env python3
"""Comprueba, sin compilar, que los árboles de carpetas de la documentación son los del repositorio.

Los árboles dibujados (`├──`, `└──`) de `Packages/Armonia/README.md` y de `Docs/DESARROLLO.md` cuentan qué hay en
cada carpeta. Al mover o renombrar una, el árbol sigue diciendo lo de antes y nadie lo ve. Este script lee cada
árbol y mira:

  - Que cada carpeta o fichero que nombra existe donde dice.
  - Que no falta ninguna carpeta: en el del motor, ninguna de `Sources/` (salvo las de dentro de un `.docc`); en el
    del repositorio, que es un resumen, ninguna hija de una carpeta que ya lista hijas.
  - En el del motor, que los tipos que nombra la descripción de cada carpeta están declarados en ella. Solo se miran
    los nombres que son tipos del repositorio (`TipoDeEscala`, `Lugar`); los autores y las siglas (`Krumhansl`,
    `SVG`) no son tipos y no se miran, ni los pocos que se nombran por lo que son (`NO_SON_EL_TIPO`). Un tipo que
    está en otra carpeta es que se movió y el árbol no se enteró.

La profundidad de cada entrada sale de la columna de su nombre: cuatro caracteres por nivel.
Uso: python3 Scripts/comprobaciones/comprobar_arboles.py
"""
import re
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]

# (el documento, la carpeta de la que cuelga el árbol, si tiene que listar todas las carpetas)
ARBOLES = [
    ("Packages/Armonia/README.md", "Packages/Armonia", True),
    ("Docs/DESARROLLO.md", ".", False),
]
RAMA = re.compile(r"^([│ ]*)(?:[├└]── )?(\S+)(.*)$")
TIPO = re.compile(r"\b(?:struct|enum|class|actor|protocol|typealias)\s+([A-Z]\w*)")
EXTENSION = re.compile(r"\bextension\s+([A-Z]\w*)")
# Los nombres que también son tipos pero el árbol usa por lo que son: la distancia en el Tonnetz de
# `RelacionEntreAcordes`.
NO_SON_EL_TIPO = {"Tonnetz"}
NOMBRE = re.compile(r"(?<![\w.+`(/-])([A-Z][A-Za-z0-9]+)(?![\w(`])")


def ficheros_del_repositorio():
    try:
        salida = subprocess.run(["git", "ls-files"], cwd=RAIZ, capture_output=True, text=True, check=True).stdout
        return [Path(r) for r in salida.splitlines() if (RAIZ / r).exists()]
    except (OSError, subprocess.CalledProcessError):
        saltar = {".git", ".build", ".swiftpm", "DerivedData", "build"}
        return [r.relative_to(RAIZ) for r in RAIZ.rglob("*") if r.is_file()
                and not set(r.relative_to(RAIZ).parts) & saltar]


def arboles(texto):
    """Las líneas de cada bloque de código que dibuja un árbol."""
    bloque = None
    for linea in texto.splitlines():
        if linea.startswith("```"):
            if bloque is not None and any("├── " in b or "└── " in b for b in bloque):
                yield bloque
            bloque = [] if bloque is None else None
        elif bloque is not None:
            bloque.append(linea)


def entradas(lineas):
    """(profundidad, nombre, descripción) de cada entrada; las líneas que siguen se suman a la descripción."""
    lista = []
    for linea in lineas:
        sin_rama = linea.replace("│", " ")
        if lista and (not sin_rama.strip() or sin_rama.startswith("    ") and "── " not in linea):
            lista[-1][2] += " " + sin_rama.strip()
            continue
        m = RAMA.match(linea)
        if not m:
            continue
        lista.append([linea.index(m.group(2)) // 4, m.group(2), m.group(3).strip()])
    return lista


def rutas(lista):
    """Cada entrada con su ruta, que sale de las entradas que la contienen."""
    pila = []
    for profundidad, nombre, descripcion in lista:
        del pila[profundidad:]
        pila.append(nombre.rstrip("/"))
        yield "/".join(pila), nombre.endswith("/"), descripcion


ficheros = ficheros_del_repositorio()
carpetas = {p for f in ficheros for p in f.parents if p != Path(".")}
declarados = {}  # tipo → carpetas donde se declara
for f in ficheros:
    if f.suffix == ".swift":
        texto = (RAIZ / f).read_text(encoding="utf-8")
        for nombre in set(TIPO.findall(texto)):
            declarados.setdefault(nombre, set()).add(f.parent)
extendidos = {}  # tipo → carpetas donde se extiende (el árbol puede nombrar `TipoDeEscala+Lugar` por su tipo)
for f in ficheros:
    if f.suffix == ".swift":
        for nombre in set(EXTENSION.findall((RAIZ / f).read_text(encoding="utf-8"))):
            extendidos.setdefault(nombre, set()).add(f.parent)

problemas = []
for documento, base, completo in ARBOLES:
    texto = (RAIZ / documento).read_text(encoding="utf-8")
    for lineas in arboles(texto):
        listadas = {}
        for ruta, es_carpeta, descripcion in rutas(entradas(lineas)):
            camino = Path(base) / ruta
            listadas[camino] = descripcion
            if not (camino in carpetas if es_carpeta else (RAIZ / camino).is_file()):
                problemas.append(f"{documento}: «{ruta}{'/' if es_carpeta else ''}» no existe")
                continue
            if not es_carpeta or not completo:
                continue
            for nombre in sorted(set(NOMBRE.findall(descripcion))):
                donde = declarados.get(nombre)
                if not donde or nombre in NO_SON_EL_TIPO or any(camino in (d, *d.parents) for d in donde | extendidos.get(nombre, set())):
                    continue
                otras = ", ".join(sorted(str(d) for d in donde))
                problemas.append(f"{documento}: «{ruta}/» nombra {nombre}, que está en {otras}")
        for carpeta in sorted(listadas):
            if carpeta not in carpetas or carpeta.suffix == ".docc" or ".docc" in str(carpeta):
                continue
            hijas = {c for c in carpetas if c.parent == carpeta and ".docc" not in c.parent.name}
            listadas_hijas = {c for c in listadas if c.parent == carpeta}
            if not completo and not listadas_hijas:
                continue
            for hija in sorted(hijas - set(listadas)):
                problemas.append(f"{documento}: falta «{hija.relative_to(base)}/» en el árbol")

if problemas:
    print("\n".join(problemas))
    print(f"{len(problemas)} problema(s) en los árboles de la documentación.")
    sys.exit(1)
print(f"Árboles de la documentación correctos ({len(ARBOLES)} documentos).")
