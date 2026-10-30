#!/usr/bin/env python3
"""Comprueba que el catálogo de escalas no se ha descuadrado.

Una escala tipo `TipoDeEscala` se declara en un sitio, pero hay que apuntarla en otros dos a mano:
la lista donde se busca (`todos` o la de su tradición, que `tradicionales` reúne) y, para todas,
su nombre en cada fichero de idioma de `Nombres/` (`NombresDeEscalas+Catalan.swift`…). Si se olvida
una, el compilador no avisa: la escala existe pero `buscar(nombre:)` no la encuentra, o su nombre en
un idioma cae al español.

Comprueba:
  1. toda `public static let x = TipoDeEscala(…)` está en `todos` o en una lista de tradición;
  2. ninguna lista nombra dos veces la misma escala;
  3. cada fichero de idioma de `Nombres/` da todas las escalas de `todos` (con `.init`) y todas las de otras
     tradiciones (con `.tradicional(.miembro)`; los 72 melakarta no se listan), sin repetir ni nombrar escalas
     que no existen;
  4. cada fichero de idioma da el nombre de todas las clases de `ClaseDeEscala` (con `.clase`);
  5. en un idioma, ningún alias se escribe igual que el nombre o el alias de otra escala (el primero taparía
     al segundo al leer).

Uso:  python3 Scripts/comprobar_catalogo.py      (sale con 1 si hay algún problema)
Es una lectura del texto, no del compilador: se limita al estilo con que está escrito el catálogo.
"""
import collections
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent / "Packages" / "Armonia" / "Sources" / "ArmoniaTeoria" / "Escalas"
FICHEROS = sorted(RAIZ.rglob("*.swift"))
TEXTO = {f: re.sub(r"//.*", "", f.read_text(encoding="utf-8")) for f in FICHEROS}


def cuerpo_de_lista(nombre):
    """Texto entre corchetes de `public static let nombre: [TipoDeEscala] = [ … ]`."""
    for texto in TEXTO.values():
        m = re.search(r"public static let " + nombre + r"\b[^=\n]*=\s*\[", texto)
        if m:
            i, nivel, j = m.end(), 1, m.end()
            while nivel:
                nivel += (texto[j] == "[") - (texto[j] == "]")
                j += 1
            return texto[i:j - 1]
    return None


definidas = {}
listas = set()
for f, texto in TEXTO.items():
    for m in re.finditer(r"public static let (`?\w+`?)\s*(?::\s*\[TipoDeEscala\])?\s*=\s*(\[|TipoDeEscala\()", texto):
        nombre = m.group(1).strip("`")
        if m.group(2) == "[":
            listas.add(nombre)
        else:
            definidas[nombre] = f.name

errores = []
todos = re.findall(r"\.(\w+)", cuerpo_de_lista("todos") or "")
if not todos:
    sys.exit("No encuentro la lista `todos`: ¿cambió el estilo del catálogo?")

nombradas = set(todos)
for lista in sorted(listas - {"todos", "tradicionales"}):
    elementos = re.findall(r"\.(\w+)", cuerpo_de_lista(lista) or "")
    nombradas |= set(elementos)
    for n, veces in collections.Counter(elementos).items():
        if veces > 1:
            errores.append(f"`{lista}` nombra {n} {veces} veces")
for n, veces in collections.Counter(todos).items():
    if veces > 1:
        errores.append(f"`todos` nombra {n} {veces} veces")

for n, fichero in sorted(definidas.items()):
    if n not in nombradas:
        errores.append(f"{n} ({fichero}) no está en `todos` ni en ninguna lista de tradición: no se podrá buscar")

# --- Los ficheros por idioma de `Nombres/`
from normalizar_escalas import normalizar, comprobar as comprobar_normalizacion

NOMBRES = RAIZ / "Nombres"
IDIOMAS_DE_NOMBRES = ["Catalan", "Gallego", "Asturiano", "Aragones", "Euskera", "Portugues", "Frances", "Occitano",
                      "Italiano", "Aleman", "Ingles", "Ruso", "Griego"]    # el español sale del propio catálogo
CADENA = r'"((?:[^"\\]|\\.)*)"'


def es_ascii(texto):
    return all(ord(c) < 128 for c in texto)


def alias_redundantes(nombre, alias):
    """Alias en ASCII que son solo la forma normalizada de otra grafía (se obtienen con `aliasNormalizados`)."""
    escritas = [nombre] + alias
    return [a for a in alias if es_ascii(a) and any(
        b != a and normalizar(b) == normalizar(a) and (not es_ascii(b) or b == nombre) for b in escritas)]


def tradicionales_declaradas():
    """Los miembros (`static let`) de las escalas de otras tradiciones, en `Tradiciones/`. Los 72 melakarta salen
    de una tabla y no llevan fila: sin ella conservan su nombre original."""
    miembros = []
    for f, texto in TEXTO.items():
        if f.parent.name == "Tradiciones":
            miembros += re.findall(r'static let `?(\w+)`? = TipoDeEscala\(', texto)
    return list(dict.fromkeys(miembros))


if not comprobar_normalizacion():
    errores.append("`normalizar` de Python no coincide con los casos de Scripts/vectores/normalizar.tsv")
tradicionales_esperadas = tradicionales_declaradas()
clases_esperadas = []
for f, texto in TEXTO.items():
    if f.name == "ClaseDeEscala.swift":
        clases_esperadas = re.findall(r'^    case (\w+)$', texto, re.M)
if not clases_esperadas:
    sys.exit("No encuentro los casos de `ClaseDeEscala`: ¿cambió el estilo?")
for idioma in IDIOMAS_DE_NOMBRES:
    ruta = NOMBRES / f"NombresDeEscalas+{idioma}.swift"
    if not ruta.exists():
        errores.append(f"falta {ruta.name}")
        continue
    texto = re.sub(r"(?m)^\s*//.*$", "", ruta.read_text(encoding="utf-8"))
    filas = re.findall(r'^\s*\.init\(\.(\w+), ' + CADENA + r'(?:, alias: \[(.*?)\])?\),$', texto, re.M)
    tipos = [t for t, _, _ in filas]
    for n, veces in collections.Counter(tipos).items():
        if veces > 1:
            errores.append(f"{ruta.name}: {n} está {veces} veces")
    for n in todos:
        if n not in tipos:
            errores.append(f"{ruta.name}: falta {n} (sin nombre en ese idioma caería al español)")
    for n in sorted(set(tipos) - set(todos)):
        errores.append(f"{ruta.name}: nombra {n}, que no está en `todos`")
    trad = re.findall(r'^\s*\.tradicional\(\.`?(\w+)`?', texto, re.M)
    for n, veces in collections.Counter(trad).items():
        if veces > 1:
            errores.append(f"{ruta.name}: la escala tradicional .{n} está {veces} veces")
    for n in tradicionales_esperadas:
        if n not in trad:
            errores.append(f"{ruta.name}: falta la escala tradicional .{n}")
    for n in sorted(set(trad) - set(tradicionales_esperadas)):
        errores.append(f"{ruta.name}: nombra la escala tradicional .{n}, que no existe")
    clases = re.findall(r'^\s*\.clase\(\.(\w+), ', texto, re.M)
    for c in clases_esperadas:
        if c not in clases:
            errores.append(f"{ruta.name}: falta el nombre de la clase .{c}")
    for c in sorted(set(clases) - set(clases_esperadas)):
        errores.append(f"{ruta.name}: nombra la clase .{c}, que no existe")
    for t, nombre, alias in filas:
        for a in alias_redundantes(nombre, re.findall(CADENA, alias or "")):
            errores.append(f"{ruta.name}: el alias «{a}» de {t} es solo una forma normalizada: se deduce solo")
    # Alias que se pisan: el primero que aparece gana al leer, y el otro no se leería nunca.
    dueño = {}
    for t, nombre, alias in filas:
        dueño.setdefault(normalizar(nombre), t)
    for t, nombre, alias in filas:
        for a in re.findall(CADENA, alias or ""):
            k = normalizar(a)
            if k in dueño and dueño[k] != t:
                errores.append(f"{ruta.name}: el alias «{a}» de {t} es también el nombre o alias de {dueño[k]}")
            dueño.setdefault(k, t)

# Los alias guardados son los escritos correctamente; las grafías sin diacríticos salen de `aliasNormalizados`.
for f, texto in TEXTO.items():
    for m in re.finditer(r'alias: \[((?:[^\]\\]|\\.)*)\]', texto):
        if "\\(" in m.group(1):
            continue
        nombre = re.findall(r'nombre: ' + CADENA, texto[:m.start()])
        for a in alias_redundantes(nombre[-1] if nombre else "", re.findall(CADENA, m.group(1))):
            errores.append(f"{f.name}: el alias «{a}» de «{nombre[-1] if nombre else '?'}» es solo una forma normalizada: se deduce solo")

print(f"{len(definidas)} escalas declaradas, {len(todos)} en `todos`, {len(listas) - 2} listas de tradición")
if errores:
    print(f"{len(errores)} problema(s):")
    for e in errores:
        print("  -", e)
    sys.exit(1)
print("Catálogo coherente.")
