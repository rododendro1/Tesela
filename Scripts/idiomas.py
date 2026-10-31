"""Los catorce idiomas del motor, para los scripts: su código ISO 639 y cómo se llaman sus ficheros de textos
(`TextosDeX+Euskera.swift`), en el orden de `Idioma` (ArmoniaNucleo/Texto/Notacion.swift).

`comprobar()` lee los códigos de `Idioma.codigo` en Swift y dice si esta lista se ha descuadrado.
"""
import re
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
NOTACION = RAIZ / "Packages/Armonia/Sources/ArmoniaNucleo/Texto/Notacion.swift"

# (código, nombre del fichero de textos), en el orden de los casos de `Idioma`.
IDIOMAS = [("es", "Espanol"), ("en", "Ingles"), ("ca", "Catalan"), ("gl", "Gallego"), ("ast", "Asturiano"),
           ("an", "Aragones"), ("eu", "Euskera"), ("pt", "Portugues"), ("fr", "Frances"), ("oc", "Occitano"),
           ("it", "Italiano"), ("de", "Aleman"), ("el", "Griego"), ("ru", "Ruso")]

CODIGOS = [codigo for codigo, _ in IDIOMAS]
FICHEROS = [fichero for _, fichero in IDIOMAS]
CODIGO_DEL_FICHERO = {fichero: codigo for codigo, fichero in IDIOMAS}


def comprobar():
    """Los códigos de `Idioma.codigo`, en el orden de Swift, son los de `IDIOMAS`."""
    texto = NOTACION.read_text(encoding="utf-8")
    cuerpo = re.search(r"public var codigo: String \{(.*?)\n    \}", texto, re.S)
    return cuerpo is not None and re.findall(r'case \.\w+: return "(\w+)"', cuerpo.group(1)) == CODIGOS
