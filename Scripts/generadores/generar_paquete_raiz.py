#!/usr/bin/env python3
"""Genera el `Package.swift` de la raíz a partir de los de `Packages/`.

SwiftPM solo lee el manifiesto de la raíz de un repositorio, así que quien usa Tesela por URL necesita uno que
reúna los paquetes de `Packages/`. Dentro del repositorio se trabaja con los de cada carpeta; el de la raíz se
escribe con este script y no se edita a mano.

De cada paquete toma sus bibliotecas y sus módulos (los `.target`, no las pruebas ni los módulos de apoyo de
`Tests/`), con sus dependencias: un producto de otro paquete (`.product(name: "Armonia", package: "Armonia")`) es,
en la raíz, ese módulo. Los paquetes van en el orden de sus dependencias, y todos deben pedir las mismas
plataformas.

Uso:  python3 Scripts/generadores/generar_paquete_raiz.py              (escribe Package.swift)
      python3 Scripts/generadores/generar_paquete_raiz.py --comprobar  (sale con 1 si no está al día; el CI)
"""
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
PAQUETES = RAIZ / "Packages"
DESTINO = RAIZ / "Package.swift"
# El ancho de línea de `.swift-format`: el manifiesto generado tiene que pasar su comprobación.
ANCHO = 120

CABECERA = """// swift-tools-version:6.0
import PackageDescription

// GENERADO por Scripts/generadores/generar_paquete_raiz.py a partir de los Package.swift de Packages/: no se edita a
// mano. Tras cambiar un paquete, `python3 Scripts/generadores/generar_paquete_raiz.py` (el CI comprueba que está al
// día).
//
// Los paquetes de `Packages/`, para usarlos desde otro proyecto por URL:
//
//     .package(url: "https://github.com/rododendro1/Tesela.git", branch: "main")
//
// SwiftPM solo lee el `Package.swift` de la raíz de un repositorio, así que este reúne los paquetes con los mismos
// módulos y dependencias que cada uno declara en su carpeta. Dentro del repositorio se sigue trabajando con aquellos
// (`cd Packages/Armonia && swift test`): aquí no hay pruebas.
"""


def sin_comentarios(texto):
    return re.sub(r"//.*", "", texto)


def llamadas(texto, funcion):
    """El contenido de cada `.funcion(...)`, con los paréntesis equilibrados."""
    resultado = []
    for inicio in (m.end() for m in re.finditer(rf"\.{funcion}\(", texto)):
        nivel, i = 1, inicio
        while nivel:
            nivel += {"(": 1, ")": -1}.get(texto[i], 0)
            i += 1
        resultado.append(texto[inicio:i - 1])
    return resultado


def leer(carpeta):
    """(dependencias entre paquetes, plataformas, bibliotecas, módulos) de `Packages/<carpeta>/Package.swift`."""
    texto = sin_comentarios((PAQUETES / carpeta / "Package.swift").read_text(encoding="utf-8"))
    nombre = re.search(r'Package\(\s*name:\s*"([^"]+)"', texto)
    if not nombre or nombre.group(1) != carpeta:
        sys.exit(f"Packages/{carpeta}: el paquete debe llamarse como su carpeta")
    paquetes = {Path(ruta).name for ruta in re.findall(r'\.package\(\s*path:\s*"([^"]+)"', texto)}
    plataformas = frozenset(re.findall(r"\.(macOS|iOS)\(\.(v\d+)\)", texto))
    variables = dict(re.findall(r'let (\w+): Target\.Dependency = \.product\(name: "(\w+)"', texto))
    bibliotecas = [
        (n, re.findall(r'"(\w+)"', o))
        for n, o in re.findall(r'\.library\(\s*name:\s*"(\w+)",\s*targets:\s*\[([^\]]*)\]', texto)
    ]
    modulos = []
    for cuerpo in llamadas(texto, "target"):
        nombre = re.search(r'name:\s*"(\w+)"', cuerpo).group(1)
        ruta = re.search(r'path:\s*"([^"]+)"', cuerpo)
        if ruta and ruta.group(1).startswith("Tests/"):
            continue  # un módulo de apoyo de las pruebas, que no es parte de la biblioteca
        dependencias = []
        lista = re.search(r"dependencies:\s*\[(.*?)\]", cuerpo, re.S)
        if lista:
            for m in re.finditer(r'\.product\(\s*name:\s*"(\w+)"[^)]*\)|"(\w+)"|\b(\w+)\b', lista.group(1)):
                if m.group(1) or m.group(2):
                    dependencias.append(m.group(1) or m.group(2))
                elif m.group(3) in variables:
                    dependencias.append(variables[m.group(3)])
        modulos.append((nombre, dependencias, f"Packages/{carpeta}/Sources/{nombre}"))
    return paquetes, plataformas, bibliotecas, modulos


def en_orden(paquetes):
    """Los paquetes en el orden de sus dependencias (y, a igualdad, por nombre)."""
    orden, pendientes = [], dict(paquetes)
    while pendientes:
        listos = sorted(n for n, d in pendientes.items() if d <= set(orden))
        if not listos:
            sys.exit(f"Dependencias circulares entre {sorted(pendientes)}")
        orden.append(listos[0])
        del pendientes[listos[0]]
    return orden


def lista(elementos):
    return "[" + ", ".join(f'"{e}"' for e in elementos) + "]"


def llamada(funcion, argumentos, sangria="        "):
    """`.funcion(a, b),` en una línea si cabe; si no, un argumento por línea, y una lista larga, partida."""
    una = f"{sangria}.{funcion}({', '.join(argumentos)}),"
    # swift-format rechaza aquí una llamada de 120 caracteres justos (lo vio el CI en #218): una menos.
    if len(una) < ANCHO:
        return una
    interior = sangria + "    "
    lineas = [f"{sangria}.{funcion}("]
    for i, argumento in enumerate(argumentos):
        final = ")," if i == len(argumentos) - 1 else ","
        linea = interior + argumento + final
        if len(linea) <= ANCHO or not argumento.endswith("]"):
            lineas.append(linea)
            continue
        # La lista partida: los elementos tan juntos como quepan, con una coma tras el último.
        clave, elementos = argumento.split("[", 1)
        lineas.append(f"{interior}{clave}[")
        fila = interior + "    "
        for elemento in (e.strip() for e in elementos[:-1].split(",")):
            if len(fila) + len(elemento) + 1 > ANCHO and fila.strip():
                lineas.append(fila.rstrip())
                fila = interior + "    "
            fila += elemento + ", "
        lineas.append(fila.rstrip())
        lineas.append(interior + "]" + final)
    return "\n".join(lineas)


def generar():
    carpetas = sorted(p.name for p in PAQUETES.iterdir() if (p / "Package.swift").exists())
    leidos = {c: leer(c) for c in carpetas}
    plataformas = {p for _, p, _, _ in leidos.values()}
    if len(plataformas) != 1:
        sys.exit("Los paquetes de Packages/ no piden las mismas plataformas")
    orden = en_orden({c: leidos[c][0] for c in carpetas})
    productos, objetivos = [], []
    for carpeta in orden:
        _, _, bibliotecas, modulos = leidos[carpeta]
        productos.append(f"        // Packages/{carpeta}")
        productos += [llamada("library", [f'name: "{n}"', f"targets: {lista(t)}"]) for n, t in bibliotecas]
        if objetivos:
            objetivos.append("")
        for nombre, dependencias, ruta in modulos:
            argumentos = [f'name: "{nombre}"'] + ([f"dependencies: {lista(dependencias)}"] if dependencias else [])
            objetivos.append(llamada("target", argumentos + [f'path: "{ruta}"']))
    orden_de_plataformas = {"macOS": 0, "iOS": 1}
    texto_de_plataformas = ", ".join(
        f".{s}(.{v})" for s, v in sorted(next(iter(plataformas)), key=lambda p: orden_de_plataformas[p[0]]))
    return (
        CABECERA
        + '\nlet package = Package(\n    name: "Tesela",\n'
        + f"    platforms: [{texto_de_plataformas}],\n"
        + "    products: [\n" + "\n".join(productos) + "\n    ],\n"
        + "    targets: [\n" + "\n".join(objetivos) + "\n    ]\n)\n"
    )


def main():
    texto = generar()
    if "--comprobar" in sys.argv[1:]:
        if DESTINO.read_text(encoding="utf-8") != texto:
            print("Package.swift (raíz) no está al día: python3 Scripts/generadores/generar_paquete_raiz.py")
            return 1
        print("Package.swift (raíz) al día.")
        return 0
    DESTINO.write_text(texto, encoding="utf-8")
    print("Package.swift (raíz) generado.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
