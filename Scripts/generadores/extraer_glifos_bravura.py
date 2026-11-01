#!/usr/bin/env python3
"""Extrae de la fuente Bravura (SMuFL, licencia SIL OFL) los glifos que dibuja el pentagrama y los escribe como
trazados SVG en `Packages/Armonia/Sources/ArmoniaPartitura/Dibujo/GlifosSMuFL.swift`.

Los trazados quedan en espacios de pentagrama (1 = la distancia entre dos líneas; en SMuFL son 250 unidades de 1000),
con el eje y hacia abajo, para que el SVG no dependa de la fuente al ejecutar.

Uso:  python3 Scripts/generadores/extraer_glifos_bravura.py ruta/a/Bravura.otf
      (la fuente: https://github.com/steinbergmedia/bravura, carpeta redist/otf; necesita `pip install fonttools`)
La licencia de la fuente está en `Licencias/Bravura-OFL.txt`.
"""
import sys
from pathlib import Path

from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

DESTINO = (Path(__file__).resolve().parents[2]
           / "Packages/Armonia/Sources/ArmoniaPartitura/Dibujo/GlifosSMuFL.swift")
UNIDADES_POR_ESPACIO = 250.0
# nombre en Swift: (punto de código SMuFL, nombre SMuFL)
GLIFOS = {
    "claveDeSol": (0xE050, "gClef"), "claveDeSolOctavaBaja": (0xE052, "gClef8vb"),
    "claveDeSolOctavaAlta": (0xE053, "gClef8va"),
    "claveDeFa": (0xE062, "fClef"), "claveDeFaOctavaBaja": (0xE064, "fClef8vb"), "claveDeFaOctavaAlta": (0xE065, "fClef8va"),
    "claveDeDo": (0xE05C, "cClef"),
    "llave": (0xE000, "brace"),
    "redonda": (0xE0A2, "noteheadWhole"), "blanca": (0xE0A3, "noteheadHalf"),
    "bemol": (0xE260, "accidentalFlat"), "becuadro": (0xE261, "accidentalNatural"),
    "sostenido": (0xE262, "accidentalSharp"), "dobleSostenido": (0xE263, "accidentalDoubleSharp"),
    "dobleBemol": (0xE264, "accidentalDoubleFlat"),
}


def numero(v):
    return f"{v:.3f}".rstrip("0").rstrip(".") or "0"


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    fuente = TTFont(sys.argv[1])
    cmap = fuente.getBestCmap()
    glifos = fuente.getGlyphSet()
    lineas = []
    for nombre, (punto, smufl) in GLIFOS.items():
        glifo = cmap[punto]
        lapiz = SVGPathPen(glifos, ntos=numero)
        glifos[glifo].draw(TransformPen(lapiz, (1 / UNIDADES_POR_ESPACIO, 0, 0, -1 / UNIDADES_POR_ESPACIO, 0, 0)))
        ancho = glifos[glifo].width / UNIDADES_POR_ESPACIO
        limites = BoundsPen(glifos)
        glifos[glifo].draw(limites)
        _, minimo, _, maximo = limites.bounds   # unidades de la fuente, con y hacia arriba
        arriba, abajo = -maximo / UNIDADES_POR_ESPACIO, -minimo / UNIDADES_POR_ESPACIO   # espacios, con y hacia abajo
        lineas.append(f"    /// {smufl} (U+{punto:04X}).\n"
                      f"    static let {nombre} = Glifo(ancho: {numero(ancho)}, arriba: {numero(arriba)}, abajo: {numero(abajo)},\n"
                      f"                                trazado: \"{lapiz.getCommands()}\")")
    DESTINO.parent.mkdir(parents=True, exist_ok=True)
    DESTINO.write_text(f"""// Generado por Scripts/generadores/extraer_glifos_bravura.py a partir de la fuente Bravura. No lo edites a mano.
//
// Bravura © Steinberg Media Technologies GmbH, con licencia SIL Open Font License 1.1 (Licencias/Bravura-OFL.txt).
// Los trazados están en espacios de pentagrama (1 = distancia entre dos líneas), con el origen en la línea base del
// glifo y el eje y hacia abajo; `ancho` es lo que avanza el glifo, en la misma unidad.

/// Un glifo musical de SMuFL como trazado SVG.
package struct Glifo: Sendable {{
    package let ancho: Double
    /// Lo que sube y lo que baja el glifo desde su origen (con y hacia abajo: `arriba` es negativo).
    package let arriba: Double
    package let abajo: Double
    package let trazado: String
}}

/// Los glifos de Bravura que usa el pentagrama.
package enum GlifosSMuFL {{
{chr(10).join(lineas)}
}}
""", encoding="utf-8")
    print(f"{len(GLIFOS)} glifos en {DESTINO.relative_to(DESTINO.parents[5])}")


if __name__ == "__main__":
    main()
