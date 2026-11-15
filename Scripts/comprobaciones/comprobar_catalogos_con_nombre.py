#!/usr/bin/env python3
"""Comprueba que cada elemento declarado de los catálogos con nombre está en su lista, y que los documentos
cuentan los que hay.

Un acorde, una progresión, un ritmo, un temperamento, una función de nota, un instrumento o un teclado se declaran
con `public static let x = Tipo(…)` (o con una función que lo crea), pero hay que apuntarlos a mano en la lista que los reúne (`catalogo`,
`genericos`, `todos`…). Si se olvida uno, el compilador no avisa: el elemento existe pero no se busca ni sale en la
consola ni en los TSV. Las pruebas lo vigilaban contando los elementos (`catalogo.count == 58`), y cada elemento
nuevo obligaba a cambiar esos números. Este script mira, leyendo el texto:

  1. Que toda `public static let x = …` (sin tipo o del tipo del catálogo) de los ficheros del catálogo está en una de sus listas.
  2. Que ninguna lista nombra dos veces el mismo elemento ni uno que no se declara allí.
  3. Que las cifras que dan los documentos («El catálogo tiene 58 progresiones») son las de las listas.

Uso: python3 Scripts/comprobaciones/comprobar_catalogos_con_nombre.py
"""
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
FUENTES = RAIZ / "Packages" / "Armonia" / "Sources"
HUECOS = "Docs/HUECOS_DEL_CATALOGO.md"
TONALIDAD = "Packages/Armonia/Sources/Armonia/Armonia.docc/Tonalidad.md"
PARTITURA = "Packages/Armonia/Sources/Armonia/Armonia.docc/NotacionYPartitura.md"

# (tipo, ficheros donde se declara, listas que lo reúnen, cifras de los documentos: (fichero, expresión, listas)).
CATALOGOS = [
    ("AcordeConNombre", "Teoria/Acordes/Catalogo/*.swift", ["genericos", "conNombrePropio"], [
        (HUECOS, r"y (\d+) acordes, todos con nombre", ["genericos", "conNombrePropio"]),
        (HUECOS, r"Hay (\d+) acordes genéricos", ["genericos"]),
        (HUECOS, r"genéricos y (\d+) de nombre propio", ["conNombrePropio"]),
    ]),
    ("ProgresionConNombre", "Teoria/Progresiones/ProgresionConNombre+Catalogo.swift", ["catalogo"], [
        (HUECOS, r"El catálogo tiene (\d+) progresiones", ["catalogo"]),
        (TONALIDAD, r"reúne (\d+) progresiones con nombre", ["catalogo"]),
    ]),
    ("RitmoConNombre", "Teoria/Ritmos/RitmoConNombre+Catalogo.swift", ["catalogo"], []),
    ("TemperamentoConNombre", "Teoria/Afinacion/TemperamentoConNombre+Catalogo.swift", ["catalogo"], []),
    ("FuncionDeNota", "Teoria/Funciones/FuncionDeNota+Catalogo.swift", ["catalogo"], []),
    ("InstrumentoDePartitura", "Partituras/Modelo/Pentagrama.swift", ["todos"], [
        (PARTITURA, r"Hay (\d+) instrumentos predefinidos", ["todos"]),
    ]),
    ("TecladoIsomorfico", "Diagramas/Redes/TecladoIsomorfico.swift", ["todos"], []),
    ("TecladoCuadrado", "Diagramas/Redes/TecladoCuadrado.swift", ["todos"], []),
]

errores = []


def cuerpos(texto, tipo):
    """El texto de `struct Tipo`, `enum Tipo` y de cada `extension Tipo`: en un fichero viven otros tipos."""
    partes = []
    for inicio in re.finditer(rf"\b(?:struct|enum|extension) {tipo}\b[^{{]*\{{", texto):
        nivel, i = 1, inicio.end()
        while nivel and i < len(texto):
            nivel += {"{": 1, "}": -1}.get(texto[i], 0)
            i += 1
        partes.append(texto[inicio.end():i - 1])
    return "\n".join(partes)


def lista(texto, nombre, tipo):
    """Los miembros (`.x`) de `static let nombre: [tipo] = [ … ]`, en orden."""
    inicio = re.search(rf"static let {nombre}: \[{tipo}\] = \[", texto)
    if not inicio:
        return None
    nivel, i = 1, inicio.end()
    while nivel:
        nivel += {"[": 1, "]": -1}.get(texto[i], 0)
        i += 1
    return re.findall(r"\.(\w+)", texto[inicio.end():i - 1])


for tipo, patron, listas, cifras in CATALOGOS:
    textos = [re.sub(r"//.*", "", f.read_text(encoding="utf-8")) for f in sorted(FUENTES.glob(patron))]
    if not textos:
        errores.append(f"{tipo}: no hay ningún fichero {patron}")
        continue
    todo = cuerpos("\n".join(textos), tipo)
    # Con su inicializador o con una función del tipo que lo crea (`grado(.tonica, .unisono)`).
    creadoras = re.findall(rf"static func (\w+)\([^)]*\)\s*->\s*(?:{tipo}|Self)\b", todo)
    inicio = "|".join([tipo, "Self", r"\.init"] + creadoras)
    declarados = re.findall(rf"public static let (\w+)(?:: {tipo})? = (?:{inicio})\(", todo)
    miembros = {}
    for nombre in listas:
        encontrados = lista(todo, nombre, tipo)
        if encontrados is None:
            errores.append(f"{tipo}: no encuentro la lista `{nombre}`")
            continue
        miembros[nombre] = encontrados
        for repetido in sorted({m for m in encontrados if encontrados.count(m) > 1}):
            errores.append(f"{tipo}.{nombre}: «{repetido}» está más de una vez")
        for ajeno in sorted(set(encontrados) - set(declarados)):
            errores.append(f"{tipo}.{nombre}: «{ajeno}» no se declara en {patron}")
    listados = {m for encontrados in miembros.values() for m in encontrados}
    for fuera in [d for d in declarados if d not in listados]:
        errores.append(f"{tipo}.{fuera} no está en {' ni en '.join(listas)}: no se busca ni sale en el catálogo")
    for documento, expresion, de in cifras:
        hallada = re.search(expresion, (RAIZ / documento).read_text(encoding="utf-8"))
        cuantos = sum(len(miembros.get(n, [])) for n in de)
        if not hallada:
            errores.append(f"{documento}: no encuentro «{expresion}»")
        elif int(hallada.group(1)) != cuantos:
            errores.append(f"{documento}: dice {hallada.group(1)} donde {tipo} tiene {cuantos} ({' + '.join(de)})")

if errores:
    for error in errores:
        print(error)
    print(f"{len(errores)} problema(s) en los catálogos con nombre.")
    sys.exit(1)
print(f"Catálogos con nombre correctos ({len(CATALOGOS)} tipos).")
