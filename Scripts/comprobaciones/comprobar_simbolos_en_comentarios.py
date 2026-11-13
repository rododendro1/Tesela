#!/usr/bin/env python3
"""Comprueba, sin compilar, que los símbolos que nombran los comentarios del código existen.

Un comentario que dice `TipoDeEscala.todos` cuando ya no hay ningún `todos` sigue compilando, y nadie lo ve.
Este script lee los comentarios de los ficheros Swift de `Packages/*/Sources`, `Apps/*` y `Ejemplos/*`, los artículos
de DocC y los README (no los CHANGELOG, que cuentan lo que hubo) y, en cada `Tipo.miembro` entre comillas invertidas
cuyo tipo esté declarado en el repositorio, mira que el miembro esté declarado en ese tipo, en sus extensiones o en
los protocolos que sigue:

  - Sin paréntesis (`TipoDeEscala.occidentales`), tiene que ser una propiedad o un caso: un `var`, un `let` o un
    `case`. Si solo hay una función con ese nombre, se escribe con su firma (`TipoDeEscala.todos(numeroDeNotas:)`).
  - Con paréntesis (`Escala.notas(en:)`), una función, un caso con valores asociados o, con `init`, un inicializador.
  - Un tipo anidado (`ModeloDelCatalogo.Tarjeta`) también vale.

Los tipos de fuera (`String.count`, `Array.first`) no se revisan, y los miembros se buscan por su nombre, sin
mirar la firma ni el nivel de acceso: es un filtro barato, como `comprobar_enlaces_docc.py` con DocC.
Uso: python3 Scripts/comprobaciones/comprobar_simbolos_en_comentarios.py
"""
import re
import sys
from collections import defaultdict
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]

BLOQUE = re.compile(r"\b(struct|enum|class|actor|protocol|extension)\s+([A-Za-z_][\w.]*)(?:<[^>{]*>)?\s*(?::\s*([^{]*))?")
PROPIEDAD = re.compile(r"\b(?:var|let)\s+`?([A-Za-z_]\w*)")
FUNCION = re.compile(r"\bfunc\s+`?([A-Za-z_]\w*)")
CASO = re.compile(r"^\s*(?:(?:public|package|internal|private|fileprivate|indirect)\s+)*case\s+(?!let\b|var\b|\.)(.*)")
INIT = re.compile(r"\binit[?!]?\s*[(<]")
TIPO_ANIDADO = re.compile(r"\b(?:struct|enum|class|actor|protocol|typealias)\s+([A-Za-z_]\w*)")
# `Tipo.miembro`, `Tipo.Anidado.miembro` o `Tipo.funcion(con:)`.
REFERENCIA = re.compile(r"`([A-Z]\w*(?:\.[A-Za-z_]\w*)+)(\()?[^`]*`")
# Lo que da Swift sin declararlo: `CaseIterable`, `RawRepresentable`, `Identifiable`, `CustomStringConvertible`, los
# nombres de fichero (`Nota.swift`).
SINTETIZADOS = {"allCases", "rawValue", "id", "description", "hashValue", "swift", "init"}


def ficheros():
    for carpeta in ["Packages", "Apps", "Ejemplos"]:
        for ruta in sorted((RAIZ / carpeta).rglob("*.swift")):
            partes = ruta.relative_to(RAIZ).parts
            if ".build" in partes or "Tests" in partes or any(p.endswith("Tests") for p in partes):
                continue
            yield ruta


def documentos():
    """Los artículos de DocC y los README, que nombran los símbolos igual. Los CHANGELOG no: cuentan lo que hubo."""
    rutas = sorted(RAIZ.glob("*.md")) + sorted((RAIZ / "Scripts").rglob("*.md"))
    for carpeta in ["Packages", "Apps", "Ejemplos"]:
        rutas += sorted(ruta for ruta in (RAIZ / carpeta).rglob("*.md") if ".build" not in ruta.parts)
    return [ruta for ruta in rutas if ruta.name != "CHANGELOG.md"]


def sin_cadenas_ni_comentarios(linea: str) -> str:
    linea = re.sub(r'"(?:[^"\\]|\\.)*"', '""', linea)
    return linea.split("//")[0]


def miembros_por_tipo(rutas):
    """Lo que declara cada tipo, en su cuerpo o en sus extensiones: propiedades y casos, funciones y casos con
    valores, inicializadores y tipos anidados; y los protocolos que sigue, para sumar lo de sus extensiones."""
    propiedades, funciones, anidados, protocolos = defaultdict(set), defaultdict(set), defaultdict(set), defaultdict(set)
    tipos = set()
    for ruta in rutas:
        pila = []  # (nombre del tipo, profundidad de su cuerpo)
        profundidad = 0
        pendiente = None
        en_bloque_de_comentario = False
        for linea in ruta.read_text(encoding="utf-8").splitlines():
            if en_bloque_de_comentario:
                if "*/" in linea:
                    en_bloque_de_comentario = False
                continue
            if linea.lstrip().startswith("/*") and "*/" not in linea:
                en_bloque_de_comentario = True
                continue
            if '"""' in linea:
                continue
            codigo = sin_cadenas_ni_comentarios(linea)
            dentro = pila[-1][0] if pila and pila[-1][1] == profundidad else None
            if dentro:
                for nombre in PROPIEDAD.findall(codigo):
                    propiedades[dentro].add(nombre)
                for nombre in FUNCION.findall(codigo):
                    funciones[dentro].add(nombre)
                caso = CASO.match(codigo)
                if caso:
                    for parte in re.split(r",(?![^(]*\))", caso.group(1)):
                        nombre = re.match(r"\s*`?([A-Za-z_]\w*)`?\s*(\()?", parte)
                        if nombre:
                            # `.xmlDanado` o `.xmlDanado(linea:)`
                            propiedades[dentro].add(nombre.group(1))
                            if nombre.group(2):
                                funciones[dentro].add(nombre.group(1))
                if INIT.search(codigo):
                    funciones[dentro].add("init")
                for nombre in TIPO_ANIDADO.findall(codigo):
                    anidados[dentro].add(nombre)
            bloque = BLOQUE.search(codigo)
            if bloque:
                nombre = bloque.group(2).split(".")[-1]
                if bloque.group(1) != "extension":
                    tipos.add(nombre)
                herencia = (bloque.group(3) or "").split(" where ")[0]
                protocolos[nombre].update(re.findall(r"[A-Za-z_]\w*", herencia))
                pendiente = nombre
            for caracter in codigo:
                if caracter == "{":
                    profundidad += 1
                    if pendiente:
                        pila.append((pendiente, profundidad))
                        pendiente = None
                elif caracter == "}":
                    if pila and pila[-1][1] == profundidad:
                        pila.pop()
                    profundidad -= 1
    # Lo de los protocolos que sigue (y de los que siguen esos), como si lo declarara el tipo.
    for tipo in list(protocolos):
        vistos, pendientes = set(), list(protocolos[tipo])
        while pendientes:
            protocolo = pendientes.pop()
            if protocolo in vistos or protocolo == tipo:
                continue
            vistos.add(protocolo)
            propiedades[tipo] |= propiedades[protocolo]
            funciones[tipo] |= funciones[protocolo]
            pendientes += protocolos[protocolo]
    return tipos, propiedades, funciones, anidados


def main():
    rutas = list(ficheros())
    tipos, propiedades, funciones, anidados = miembros_por_tipo(rutas)
    revisados = errores = 0
    for ruta in rutas + documentos():
        for numero, linea in enumerate(ruta.read_text(encoding="utf-8").splitlines(), 1):
            comentario = linea.find("//") if ruta.suffix == ".swift" else 0
            if comentario < 0:
                continue
            for cadena, parentesis in REFERENCIA.findall(linea[comentario:]):
                partes = cadena.split(".")
                tipo = partes[0]
                if tipo not in tipos:
                    continue
                # `Tipo.Anidado.miembro`: el último que es un tipo anidado, y lo que le sigue.
                indice = 1
                while indice < len(partes) - 1 and partes[indice] in anidados[tipo]:
                    tipo, indice = partes[indice], indice + 1
                miembro = partes[indice]
                revisados += 1
                if miembro in anidados[tipo] or miembro in SINTETIZADOS:
                    continue
                if parentesis and indice == len(partes) - 1:
                    bien = miembro in funciones[tipo]
                else:
                    bien = miembro in propiedades[tipo]
                if not bien:
                    lugar = f"{ruta.relative_to(RAIZ)}:{numero}"
                    if miembro in funciones[tipo]:
                        print(f"{lugar}: `{cadena}` es una función: escríbela con su firma, `{miembro}(…:)`")
                    else:
                        print(f"{lugar}: `{cadena}`: «{tipo}» no tiene ningún «{miembro}»")
                    errores += 1
    print(f"{revisados} símbolos revisados en los comentarios de {len(rutas)} ficheros y en la documentación.")
    if errores:
        print(f"{errores} símbolo(s) que no existen.")
        sys.exit(1)
    print("Los símbolos de los comentarios existen.")


main()
