#!/usr/bin/env python3
"""Comprueba las traducciones de los textos del motor en los trece idiomas.

Los textos están de tres maneras: en un `Traduccion(…)` con los trece juntos; en los ficheros por
idioma de cada módulo (`Textos/TextosDeX+Espanol.swift`, `…+Ingles.swift`…), donde cada campo de
`TextosDeX` tiene su texto en cada fichero, y en los nombres de los acordes del catálogo
(`Acordes/Nombres/NombresDeAcordes+Ingles.swift`…, con el español en la declaración del acorde). El compilador ya obliga a dar los trece, pero no impide
copiar uno que no toca. Se miran los textos literales (los que se montan con código no se pueden leer
aquí) y se avisa de cuatro cosas:

  1. un texto en alemán, ruso o griego idéntico al inglés (y distinto del español), que suele ser
     un texto que se quedó sin traducir;
  2. un texto en ruso sin letras cirílicas o en griego sin letras griegas, aunque tenga palabras;
  3. una misma frase en español (de dos palabras o más) traducida de dos maneras en un idioma;
  4. una plantilla («no se puede leer «{1}» (carácter {2})») con otros huecos que en español: en un
     idioma falta un `{n}`, sobra o tiene otro número.

Las órdenes y las opciones de la línea de comandos (`armonia …`, `--…`) y las sintaxis de la ayuda
se escriben igual en todos los idiomas, así que no cuentan. Los textos que son iguales a propósito
van en EXCEPCIONES.

Uso:  python3 Scripts/comprobaciones/comprobar_traducciones.py     (sale con 1 si hay un problema)
"""
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "comun"))  # Scripts/comun: idiomas.py y normalizar_escalas.py
from idiomas import CODIGOS as IDIOMAS, CODIGO_DEL_FICHERO, comprobar as comprobar_idiomas

# Textos que se escriben igual que en inglés a propósito.
EXCEPCIONES = {
    "help",     # el nombre de la orden
    "Symbol",   # alemán: también es la palabra alemana
    "Name",     # alemán: también es la palabra alemana
    "completion bash|zsh|fish",  # la sintaxis de la orden, con los nombres de las terminales
    "manual",   # el nombre de la orden
    "engines",  # el nombre de la orden
    "sheet <scale>",  # la sintaxis de la orden, sin opciones
    "own",      # el nombre de `--engine own`
    "Japan",    # alemán: el nombre del país
    "Korea",    # alemán: el nombre del país
    "Vietnam",  # alemán: el nombre del país
    "Thailand",  # alemán: el nombre del país
    "Renaissance",  # alemán y francés: la misma palabra
    "Archytas",  # alemán: el nombre del teórico (FuenteTeorica)
    "Eratosthenes",  # alemán: el nombre del teórico
    "Aristides Quintilianus",  # alemán: el nombre del teórico
    "Glarean",  # alemán: el nombre del teórico
    "Chrysanthos",  # alemán: el nombre del teórico
    "Ukraine",  # alemán: el nombre del país
    "Myanmar",  # alemán: el nombre del país
    "Mandinka",  # alemán: el nombre del pueblo
}

_TEXTO = r'"((?:[^"\\]|\\.)*)"'
_TRADUCCION = re.compile(
    r"Traduccion\(\s*" + _TEXTO + r"\s*,\s*" + _TEXTO
    + "".join(rf"\s*,\s*{etiqueta}:\s*" + _TEXTO for etiqueta in IDIOMAS[2:])
    + r"\s*\)",
    re.S,
)


_HUECO = re.compile(r"\{(\d+)\}")


def sin_codigo(texto: str) -> str:
    """El texto sin interpolaciones, órdenes ni opciones de la línea de comandos."""
    texto = re.sub(r"\\\([^)]*\)", "", texto)
    texto = re.sub(r"\{\d+\}", "", texto)
    texto = re.sub(r"armonia [^\n]*", "", texto)
    return re.sub(r"--\S+", "", texto)


# Los ficheros por idioma: `TextosDeTrastes+Euskera.swift` tiene los textos en euskera.
FICHEROS_DE_IDIOMA = CODIGO_DEL_FICHERO
_FICHERO_DE_IDIOMA = re.compile(r"/Textos/(TextosDe\w+)\+(\w+)\.swift$")
# Un campo de una línea: `nombre: "texto",` (una `Plantilla` lleva huecos `{1}`) o, si se monta con
# código, `nombre: { a, b in "texto" },`.
_CAMPO = re.compile(r"^ {8}(\w+): (?:\{ [\w, ]+ in )?" + _TEXTO + r"(?: \})?,?$", re.M)


def traducciones():
    try:
        archivos = subprocess.check_output(["git", "ls-files", "*.swift"], cwd=RAIZ, text=True,
                                           stderr=subprocess.DEVNULL).split()
    except (OSError, subprocess.CalledProcessError):    # sin git (un zip, por ejemplo): se recorre el árbol
        saltar = {".git", ".build", ".swiftpm", "DerivedData", "build", "node_modules"}
        archivos = sorted(str(r.relative_to(RAIZ)) for r in RAIZ.rglob("*.swift")
                          if not (set(r.relative_to(RAIZ).parts) & saltar))
    por_campo = defaultdict(dict)
    for archivo in archivos:
        if "/Tests/" in archivo:
            continue
        codigo = (RAIZ / archivo).read_text(encoding="utf-8")
        for m in _TRADUCCION.finditer(codigo):
            linea = codigo.count("\n", 0, m.start()) + 1
            yield f"{archivo}:{linea}", dict(zip(IDIOMAS, m.groups()))
        fichero = _FICHERO_DE_IDIOMA.search(archivo)
        if fichero and fichero.group(2) in FICHEROS_DE_IDIOMA:
            for m in _CAMPO.finditer(codigo):
                por_campo[(fichero.group(1), m.group(1))][FICHEROS_DE_IDIOMA[fichero.group(2)]] = m.group(2)
    for (estructura, campo), textos in sorted(por_campo.items()):
        if len(textos) == len(IDIOMAS):
            yield f"{estructura}.{campo}", textos
    yield from nombres_de_acordes()


# Los acordes del catálogo: el español en su declaración (`public static let mayor = AcordeConNombre(nombre: "…"`),
# y los demás idiomas en una fila de `NombresDeAcordes+Idioma.swift` (`.init(.mayor, "major"`).
ACORDES = RAIZ / "Packages/Armonia/Sources/Teoria/Acordes"
_ACORDE = re.compile(r"public static let (\w+) = AcordeConNombre\(\s*nombre: " + _TEXTO)
_FILA_DE_ACORDE = re.compile(r"^ {8}\.init\(\.(\w+), " + _TEXTO, re.M)


def nombres_de_acordes():
    por_acorde = defaultdict(dict)
    for fichero in sorted((ACORDES / "Catalogo").glob("*.swift")):
        for m in _ACORDE.finditer(fichero.read_text(encoding="utf-8")):
            por_acorde[m.group(1)]["es"] = m.group(2)
    for fichero in sorted((ACORDES / "Nombres").glob("NombresDeAcordes+*.swift")):
        idioma = CODIGO_DEL_FICHERO.get(fichero.stem.split("+")[1])
        if idioma is None:
            continue
        for m in _FILA_DE_ACORDE.finditer(fichero.read_text(encoding="utf-8")):
            por_acorde[m.group(1)].setdefault(idioma, m.group(2))
    for acorde, textos in sorted(por_acorde.items()):
        if len(textos) == len(IDIOMAS):
            yield f"NombresDeAcordes.{acorde}", textos


def main() -> int:
    errores = []
    frases = defaultdict(lambda: defaultdict(dict))
    cuantas = 0
    for lugar, textos in traducciones():
        cuantas += 1
        ingles = textos["en"]
        if "--" in ingles or lugar.split(".")[-1].startswith("sintaxis"):
            # Una sintaxis de orden («tabla chord | scale…», «--chord»): se escribe igual en todos.
            continue
        for idioma in ("de", "ru", "el"):
            texto = textos[idioma]
            if (texto == ingles and texto != textos["es"] and texto not in EXCEPCIONES
                    and re.search(r"[A-Za-z]{4}", sin_codigo(texto))):
                errores.append(f"{lugar}: en {idioma}, «{texto}» es igual que en inglés")
        for idioma, letras in (("ru", "[а-яё]"), ("el", "[α-ωάέήίόύώϊϋΐΰ]")):
            texto = sin_codigo(textos[idioma])
            if (textos[idioma] not in EXCEPCIONES and re.search(r"[A-Za-z]{3}", texto)
                    and not re.search(letras, texto, re.I)):
                errores.append(f"{lugar}: en {idioma}, «{textos[idioma]}» no tiene letras de su alfabeto")
        espanol = textos["es"]
        huecos = sorted(set(_HUECO.findall(espanol)))
        for idioma in IDIOMAS[1:]:
            suyos = sorted(set(_HUECO.findall(textos[idioma])))
            if suyos != huecos:
                errores.append(f"{lugar}: en {idioma}, los huecos son {suyos or 'ninguno'} y en español {huecos or 'ninguno'}")
        if " " in espanol and "\\(" not in espanol and not huecos:
            for idioma in IDIOMAS[1:]:
                frases[espanol][idioma].setdefault(textos[idioma], lugar)

    for espanol, por_idioma in frases.items():
        for idioma, variantes in por_idioma.items():
            if len(variantes) > 1:
                lista = "; ".join(f"«{t}» ({lugar})" for t, lugar in variantes.items())
                errores.append(f"«{espanol}» se traduce de {len(variantes)} maneras en {idioma}: {lista}")

    print(f"{cuantas} traducciones literales revisadas.")
    if cuantas == 0:
        # Si `Traduccion` cambia de forma (otro idioma, otras etiquetas), la expresión deja de encontrarlas.
        errores.append("no se ha encontrado ninguna Traduccion literal: ¿ha cambiado IDIOMAS?")
    if not comprobar_idiomas():
        errores.append("Scripts/comun/idiomas.py no tiene los códigos de `Idioma.codigo`, en su orden")
    if errores:
        print(f"\n{len(errores)} problema(s):")
        for e in errores:
            print("  -", e)
        return 1
    print("Traducciones correctas.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
