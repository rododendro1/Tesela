#!/usr/bin/env python3
"""Escribe las notas de una versión a partir del CHANGELOG.md de cada paquete.

Junta, con un título por paquete, la sección «## <versión>» de `Packages/<Paquete>/CHANGELOG.md`; los paquetes
sin esa sección no salen. Falla si ningún paquete la tiene o si la versión no coincide con `MARKETING_VERSION`
de `project.yml` (la de las apps), para que una etiqueta no se publique sin sus notas ni con las apps en otra
versión. Lo usa `.github/workflows/version.yml` al subir una etiqueta, y el CI para comprobar que la versión
actual tiene notas.

Uso: python3 Scripts/notas_de_version.py 0.2.0            (también vale «v0.2.0»)
     python3 Scripts/notas_de_version.py --actual          (la versión de project.yml)
"""
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
# GitHub no admite notas de más de 125 000 caracteres: por encima de este límite se cortan y se enlazan los CHANGELOG.
LIMITE = 120_000


def version_de_las_apps():
    m = re.search(r'MARKETING_VERSION:\s*"?([^"\s]+)"?', (RAIZ / "project.yml").read_text(encoding="utf-8"))
    return m.group(1) if m else None


def seccion(texto, version):
    """Las líneas bajo «## <versión>» (con o sin fecha) hasta el siguiente «## », sin el título."""
    lineas = texto.splitlines()
    titulo = re.compile(r"^##\s+v?" + re.escape(version) + r"(\s|$)")
    for i, linea in enumerate(lineas):
        if titulo.match(linea):
            fin = next((j for j in range(i + 1, len(lineas)) if lineas[j].startswith("## ")), len(lineas))
            return "\n".join(lineas[i + 1:fin]).strip()
    return None


def notas(version):
    partes = []
    for changelog in sorted((RAIZ / "Packages").glob("*/CHANGELOG.md")):
        cuerpo = seccion(changelog.read_text(encoding="utf-8"), version)
        if cuerpo:
            partes.append(f"## {changelog.parent.name}\n\n{cuerpo}")
    return "\n\n".join(partes)


def main(argumentos):
    if len(argumentos) != 1:
        print(__doc__.strip(), file=sys.stderr)
        return 2
    apps = version_de_las_apps()
    version = apps if argumentos[0] == "--actual" else argumentos[0].removeprefix("v")
    if not re.fullmatch(r"\d+\.\d+\.\d+", version or ""):
        print(f"«{version}» no es una versión como 0.2.0.", file=sys.stderr)
        return 1
    if version != apps:
        print(f"La versión {version} no coincide con MARKETING_VERSION de project.yml ({apps}).", file=sys.stderr)
        return 1
    texto = notas(version)
    if not texto:
        print(f"Ningún Packages/*/CHANGELOG.md tiene una sección «## {version}».", file=sys.stderr)
        return 1
    if len(texto) > LIMITE:
        corte = texto.rfind("\n", 0, LIMITE)
        texto = texto[:corte] + "\n\n…\n\nLas notas siguen en el `CHANGELOG.md` de cada paquete (`Packages/<Paquete>/CHANGELOG.md`)."
    print(texto)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
