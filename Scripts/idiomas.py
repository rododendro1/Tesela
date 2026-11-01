"""Los catorce idiomas del motor, para los scripts: su código ISO 639 y cómo se llaman sus ficheros de textos
(`TextosDeX+Euskera.swift`), en el orden de `Idioma` (ArmoniaNucleo/Notacion/Notacion.swift).

`comprobar()` lee los casos de `Idioma` y los códigos de sus filas en `ReglasDeIdioma` y dice si esta lista
se ha descuadrado.
"""
import re
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
NOTACION = RAIZ / "Packages/Armonia/Sources/ArmoniaNucleo/Notacion/Notacion.swift"
REGLAS = RAIZ / "Packages/Armonia/Sources/ArmoniaNucleo/Notacion/ReglasDeIdioma.swift"

# (código, nombre del fichero de textos), en el orden de los casos de `Idioma`.
IDIOMAS = [("es", "Espanol"), ("en", "Ingles"), ("ca", "Catalan"), ("gl", "Gallego"), ("ast", "Asturiano"),
           ("an", "Aragones"), ("eu", "Euskera"), ("pt", "Portugues"), ("fr", "Frances"), ("oc", "Occitano"),
           ("it", "Italiano"), ("de", "Aleman"), ("el", "Griego"), ("ru", "Ruso")]

CODIGOS = [codigo for codigo, _ in IDIOMAS]
FICHEROS = [fichero for _, fichero in IDIOMAS]
CODIGO_DEL_FICHERO = {fichero: codigo for codigo, fichero in IDIOMAS}


def comprobar():
    """Las filas de `ReglasDeIdioma` siguen el orden de `Idioma`, cada una con su código, y los códigos y los
    ficheros son los de `IDIOMAS` (el fichero es el caso con mayúscula: `euskera` → `Euskera`)."""
    enumerado = re.search(r"public enum Idioma\b[^{]*\{(.*?)\n\}", NOTACION.read_text(encoding="utf-8"), re.S)
    filas = re.search(r"public var reglas: ReglasDeIdioma \{(.*?)\n    \}", REGLAS.read_text(encoding="utf-8"), re.S)
    if enumerado is None or filas is None:
        return False
    casos = re.findall(r"^    case (\w+)$", enumerado.group(1), re.M)
    leidas = re.findall(r'case \.(\w+):\s*return ReglasDeIdioma\(\s*codigo: "(\w+)"', filas.group(1))
    return leidas == list(zip(casos, CODIGOS)) and [c[:1].upper() + c[1:] for c in casos] == FICHEROS
