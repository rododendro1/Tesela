#!/usr/bin/env python3
"""Comprueba que la CI, la documentación y los scripts nombran los paquetes de `Scripts/datos/paquetes.json`.

La lista de paquetes, sus módulos, las apps de SwiftPM, los ejemplos, las herramientas y los mínimos de cobertura
salen de un solo sitio, `Scripts/datos/paquetes.json`. Al añadir o renombrar un paquete, el resto de sitios que lo
nombran se quedaban atrás sin que nadie lo viera. Este script mira, sin compilar:

  - Que las carpetas de `Packages/`, de `Apps/` (las de SwiftPM), de `Ejemplos/` y de `Herramientas/` son las del
    manifiesto, y que los productos de cada paquete son sus módulos.
  - En `.github/workflows/ci.yml`:
      - la matriz de `paquetes` (todos menos el motor, que tiene su job);
      - la de `swiftpm`;
      - la de `cobertura`, con los mínimos del manifiesto;
      - que `macos`, `macos-paquetes` y `documentacion` pasan por cada paquete;
      - que `cambios` mira todos los paquetes;
      - que los filtros de pruebas del motor (`^(…)Tests`) y su bucle «Sin avisos» nombran todos sus módulos.
  - Que `documentacion.yml` construye la documentación de cada paquete y `.spi.yml` la de cada módulo.
  - Que `Scripts/compilacion/compilar_todo.sh` pasa por cada paquete, app, ejemplo y herramienta, y que sus
    filtros nombran todos los módulos del motor.

Uso: python3 Scripts/comprobaciones/comprobar_paquetes.py
"""
import json
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
MANIFIESTO = json.loads((RAIZ / "Scripts" / "datos" / "paquetes.json").read_text(encoding="utf-8"))
PAQUETES = MANIFIESTO["paquetes"]
SWIFTPM = MANIFIESTO["swiftpm"]
MOTOR = next(p for p in PAQUETES if p["nombre"] == "Armonia")
FILTRO = re.compile(r"\^\(([A-Za-z|]+)\)Tests")
ENTRADA = re.compile(r"^\s*- \{ nombre: (\w+), ruta: ([\w/]+)(?:, filtro: \"[^\"]*\", funciones: ([\d.]+), lineas: ([\d.]+))? \}")

errores = []


def leer(ruta):
    return (RAIZ / ruta).read_text(encoding="utf-8")


def jobs(texto):
    """Cada job de un workflow, por su clave, con su texto."""
    cuerpo = texto.split("\njobs:\n", 1)[1]
    partes = re.split(r"^  ([\w-]+):\n", cuerpo, flags=re.M)
    return dict(zip(partes[1::2], partes[2::2]))


def comparar(lugar, encontrados, esperados):
    encontrados, esperados = list(encontrados), list(esperados)
    for falta in [e for e in esperados if e not in encontrados]:
        errores.append(f"{lugar}: falta {falta}")
    for sobra in [e for e in encontrados if e not in esperados]:
        errores.append(f"{lugar}: sobra {sobra} (no está en Scripts/datos/paquetes.json)")


def filtros_con_todos_los_modulos(lugar, texto):
    filtros = FILTRO.findall(texto)
    for filtro in filtros:
        faltan = [m for m in MOTOR["modulos"] if m not in filtro.split("|")]
        if faltan:
            errores.append(f"{lugar}: el filtro «^({filtro})Tests» no tiene {', '.join(faltan)}")
    return filtros


# Las carpetas y los productos.
carpetas = sorted(p.name for p in (RAIZ / "Packages").iterdir() if (p / "Package.swift").exists())
comparar("Packages/", carpetas, sorted(p["nombre"] for p in PAQUETES))
for paquete in PAQUETES:
    manifiesto = RAIZ / "Packages" / paquete["nombre"] / "Package.swift"
    if manifiesto.exists():
        productos = re.findall(r'\.library\(\s*name:\s*"(\w+)"', re.sub(r"//.*", "", manifiesto.read_text("utf-8")))
        comparar(f"los productos de Packages/{paquete['nombre']}", sorted(productos), sorted(paquete["modulos"]))
apps = sorted(
    f"{d.parent.name}/{d.name}"
    for padre in ("Apps", "Ejemplos", "Herramientas")
    for d in (RAIZ / padre).iterdir()
    if (d / "Package.swift").exists()
)
comparar("Apps, Ejemplos y Herramientas", apps, sorted(a["ruta"] for a in SWIFTPM))

# La CI.
ci = jobs(leer(".github/workflows/ci.yml"))
paquetes = re.search(r"paquete: \[([^\]]*)\]", ci["paquetes"])
comparar(
    "ci.yml, matriz de `paquetes`",
    [p.strip() for p in paquetes.group(1).split(",")] if paquetes else [],
    [p["nombre"] for p in PAQUETES if p is not MOTOR],
)
swiftpm = [ENTRADA.match(l) for l in ci["swiftpm"].splitlines()]
comparar(
    "ci.yml, matriz de `swiftpm`",
    [f"{m.group(1)} ({m.group(2)})" for m in swiftpm if m],
    [f"{a['nombre']} ({a['ruta']})" for a in SWIFTPM],
)
cobertura = [ENTRADA.match(l) for l in ci["cobertura"].splitlines()]
comparar(
    "ci.yml, matriz de `cobertura`",
    [f"{m.group(1)} ({m.group(2)}): {float(m.group(3))} y {float(m.group(4))}" for m in cobertura if m],
    [f"{p['nombre']} (Packages/{p['nombre']}): {p['cobertura']['funciones']} y {p['cobertura']['lineas']}"
     for p in PAQUETES]
    + [f"{a['nombre']} ({a['ruta']}): {a['cobertura']['funciones']} y {a['cobertura']['lineas']}"
       for a in SWIFTPM if "cobertura" in a],
)
for job in ("macos", "macos-paquetes", "documentacion"):
    for paquete in PAQUETES:
        if f"working-directory: Packages/{paquete['nombre']}\n" not in ci.get(job, ""):
            errores.append(f"ci.yml, job `{job}`: no pasa por Packages/{paquete['nombre']}")
cambios = re.search(r"grep -qE '(\^\(Apps/ArsHarmonicaApp/[^']*)'", ci["cambios"])
for paquete in PAQUETES:
    if not cambios or paquete["nombre"] not in cambios.group(1):
        errores.append(f"ci.yml, `cambios`: no mira Packages/{paquete['nombre']}")
for job in ("motor", "cobertura", "macos", "macos-paquetes"):
    if not filtros_con_todos_los_modulos(f"ci.yml, job `{job}`", ci[job]):
        errores.append(f"ci.yml, job `{job}`: no tiene el filtro de las pruebas del motor")
sin_avisos = re.search(r"for objetivo in ([\w ]+); do", ci["motor"])
comparar(
    "ci.yml, «Sin avisos (módulos)» del motor",
    sin_avisos.group(1).split() if sin_avisos else [],
    MOTOR["modulos"],
)

# La documentación.
documentacion = leer(".github/workflows/documentacion.yml")
for paquete in PAQUETES:
    if f"working-directory: Packages/{paquete['nombre']}\n" not in documentacion:
        errores.append(f"documentacion.yml: no construye la documentación de Packages/{paquete['nombre']}")
spi = re.search(r"documentation_targets:\n((?:\s+- \w+\n)+)", leer(".spi.yml"))
comparar(
    ".spi.yml, documentation_targets",
    sorted(re.findall(r"- (\w+)", spi.group(1))) if spi else [],
    sorted(m for p in PAQUETES for m in p["modulos"]),
)

# El script que lo compila todo.
compilar = leer("Scripts/compilacion/compilar_todo.sh")
for ruta in [f"Packages/{p['nombre']}" for p in PAQUETES] + [a["ruta"] for a in SWIFTPM]:
    if not re.search(rf"\s{re.escape(ruta)}\s", compilar):
        errores.append(f"compilar_todo.sh: no pasa por {ruta}")
if not filtros_con_todos_los_modulos("compilar_todo.sh", compilar):
    errores.append("compilar_todo.sh: no tiene el filtro de las pruebas del motor")
bucle = re.search(r"for modulo in ([\w ]+); do", compilar)
comparar("compilar_todo.sh, los módulos del motor", bucle.group(1).split() if bucle else [], MOTOR["modulos"])

if errores:
    for error in errores:
        print(error)
    print(f"{len(errores)} problema(s) con los paquetes.")
    sys.exit(1)
print(f"Paquetes correctos ({len(PAQUETES)} paquetes y {len(SWIFTPM)} de SwiftPM).")
