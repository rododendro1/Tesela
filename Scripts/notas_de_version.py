#!/usr/bin/env python3
"""Las notas de cada versión, sacadas del CHANGELOG.md de cada paquete, y el paso de «Sin publicar» a una versión.

Cada `Packages/<Paquete>/CHANGELOG.md` tiene, de lo más nuevo a lo más viejo, una sección «## Sin publicar»
(opcional, la primera) con lo que ya está en main, y una por versión: «## 0.2.0 (2026-11-15)».

  0.2.0 o v0.2.0   Escribe las notas de esa versión: la sección de cada paquete que la tiene, con un título por
                   paquete. Falla si ninguno la tiene o si no coincide con `MARKETING_VERSION` de `project.yml` (la
                   de las apps). Lo usa `.github/workflows/version.yml` al subir una etiqueta.
  --comprobar      Comprueba los CHANGELOG (títulos bien escritos, «Sin publicar» solo arriba, versiones de más nueva
                   a más vieja) y que la versión de `project.yml` tiene notas. Lo usa el CI.
  --publicar 0.2.0 Prepara una versión: las secciones «Sin publicar» pasan a «0.2.0 (fecha de hoy)» y
                   `MARKETING_VERSION` a 0.2.0. Falla si ningún paquete tiene nada sin publicar.

Uso: python3 Scripts/notas_de_version.py 0.2.0 | --actual | --comprobar | --publicar 0.2.0
     (--actual es la versión de project.yml)
"""
import datetime
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
PROYECTO = RAIZ / "project.yml"
SIN_PUBLICAR = "Sin publicar"
# GitHub no admite notas de más de 125 000 caracteres: por encima de este límite se cortan y se enlazan los CHANGELOG.
LIMITE = 120_000
TITULO_DE_VERSION = re.compile(r"^## (\d+)\.(\d+)\.(\d+) \(\d{4}-\d{2}-\d{2}\)$")
# Las versiones de antes de las etiquetas («## Versión 5»): van al final y no se comprueban.
TITULO_ANTIGUO = re.compile(r"^## Versión \d+$")


def changelogs():
    return sorted((RAIZ / "Packages").glob("*/CHANGELOG.md"))


def version_de_las_apps():
    m = re.search(r'MARKETING_VERSION:\s*"?([^"\s]+)"?', PROYECTO.read_text(encoding="utf-8"))
    return m.group(1) if m else None


def es_version(texto):
    return re.fullmatch(r"\d+\.\d+\.\d+", texto or "") is not None


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
    for changelog in changelogs():
        cuerpo = seccion(changelog.read_text(encoding="utf-8"), version)
        if cuerpo:
            partes.append(f"## {changelog.parent.name}\n\n{cuerpo}")
    return "\n\n".join(partes)


def escribir_notas(version):
    apps = version_de_las_apps()
    if not es_version(version):
        print(f"«{version}» no es una versión como 0.2.0.", file=sys.stderr)
        return 1
    if version != apps:
        print(f"La versión {version} no coincide con MARKETING_VERSION de project.yml ({apps}).", file=sys.stderr)
        return 1
    texto = notas(version)
    if not texto:
        print(f"Ningún Packages/*/CHANGELOG.md tiene una sección «## {version}». Para pasar lo que está en "
              f"«## {SIN_PUBLICAR}» a esa versión: python3 Scripts/notas_de_version.py --publicar {version}",
              file=sys.stderr)
        return 1
    if len(texto) > LIMITE:
        corte = texto.rfind("\n", 0, LIMITE)
        texto = texto[:corte] + "\n\n…\n\nLas notas siguen en el `CHANGELOG.md` de cada paquete (`Packages/<Paquete>/CHANGELOG.md`)."
    print(texto)
    return 0


def errores_de(changelog):
    """Lo que está mal en los títulos de sección de un CHANGELOG."""
    errores = []
    anterior = None
    titulos = [(n, l) for n, l in enumerate(changelog.read_text(encoding="utf-8").splitlines(), 1) if l.startswith("## ")]
    for indice, (n, linea) in enumerate(titulos):
        donde = f"{changelog.relative_to(RAIZ)}:{n}"
        if TITULO_ANTIGUO.match(linea):
            anterior = (-1, -1, -1)   # detrás solo puede haber otras antiguas
            continue
        if anterior == (-1, -1, -1):
            errores.append(f"{donde}: «{linea}» va detrás de una versión antigua («## Versión N»)")
            continue
        if linea == f"## {SIN_PUBLICAR}":
            if indice != 0:
                errores.append(f"{donde}: «{SIN_PUBLICAR}» tiene que ser la primera sección")
            continue
        m = TITULO_DE_VERSION.match(linea)
        if not m:
            errores.append(f"{donde}: «{linea}» no es «## {SIN_PUBLICAR}», «## 0.2.0 (aaaa-mm-dd)» ni «## Versión N»")
            continue
        version = tuple(int(x) for x in m.groups())
        if anterior is not None and version >= anterior:
            errores.append(f"{donde}: las versiones van de la más nueva a la más vieja")
        anterior = version
    return errores


def comprobar():
    errores = [e for changelog in changelogs() for e in errores_de(changelog)]
    apps = version_de_las_apps()
    if not notas(apps or ""):
        errores.append(f"Ningún CHANGELOG tiene la sección de la versión de project.yml ({apps})")
    for error in errores:
        print(error, file=sys.stderr)
    return 1 if errores else 0


def publicar(version, hoy=None):
    if not es_version(version):
        print(f"«{version}» no es una versión como 0.2.0.", file=sys.stderr)
        return 1
    if notas(version):
        print(f"La versión {version} ya tiene notas.", file=sys.stderr)
        return 1
    apps = version_de_las_apps()
    if es_version(apps) and tuple(map(int, version.split("."))) <= tuple(map(int, apps.split("."))):
        print(f"La versión {version} no es posterior a la de project.yml ({apps}).", file=sys.stderr)
        return 1
    fecha = (hoy or datetime.date.today()).isoformat()
    cambiados = []
    for changelog in changelogs():
        texto = changelog.read_text(encoding="utf-8")
        nuevo = re.sub(rf"^## {SIN_PUBLICAR}$", f"## {version} ({fecha})", texto, count=1, flags=re.MULTILINE)
        if nuevo != texto:
            changelog.write_text(nuevo, encoding="utf-8")
            cambiados.append(changelog.parent.name)
    if not cambiados:
        print(f"Ningún CHANGELOG tiene una sección «## {SIN_PUBLICAR}»: no hay nada que publicar.", file=sys.stderr)
        return 1
    proyecto = PROYECTO.read_text(encoding="utf-8")
    PROYECTO.write_text(re.sub(r'(MARKETING_VERSION:\s*)"?[^"\s]+"?', rf'\g<1>"{version}"', proyecto, count=1),
                        encoding="utf-8")
    print(f"Versión {version} ({fecha}): {', '.join(cambiados)}, y MARKETING_VERSION en project.yml.")
    print(f"Fusiona el cambio en main y etiqueta ese commit: git tag {version} && git push origin {version}")
    return 0


def main(argumentos):
    if argumentos == ["--comprobar"]:
        return comprobar()
    if len(argumentos) == 2 and argumentos[0] == "--publicar":
        return publicar(argumentos[1].removeprefix("v"))
    if len(argumentos) == 1 and not argumentos[0].startswith("--") or argumentos == ["--actual"]:
        return escribir_notas(version_de_las_apps() if argumentos[0] == "--actual" else argumentos[0].removeprefix("v"))
    print(__doc__.strip(), file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
