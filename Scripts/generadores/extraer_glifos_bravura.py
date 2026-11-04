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
    "redonda": (0xE0A2, "noteheadWhole"), "blanca": (0xE0A3, "noteheadHalf"), "negra": (0xE0A4, "noteheadBlack"),
    # El ritmo: corchetes de las plicas, silencios, el puntillo, las cifras del compás y la del tresillo.
    "corcheteDeCorcheaArriba": (0xE240, "flag8thUp"), "corcheteDeCorcheaAbajo": (0xE241, "flag8thDown"),
    "corcheteDeSemicorcheaArriba": (0xE242, "flag16thUp"), "corcheteDeSemicorcheaAbajo": (0xE243, "flag16thDown"),
    "corcheteDeFusaArriba": (0xE244, "flag32ndUp"), "corcheteDeFusaAbajo": (0xE245, "flag32ndDown"),
    "silencioDeRedonda": (0xE4E3, "restWhole"), "silencioDeBlanca": (0xE4E4, "restHalf"),
    "silencioDeNegra": (0xE4E5, "restQuarter"), "silencioDeCorchea": (0xE4E6, "rest8th"),
    "silencioDeSemicorchea": (0xE4E7, "rest16th"), "silencioDeFusa": (0xE4E8, "rest32nd"),
    "puntillo": (0xE1E7, "augmentationDot"),
    **{f"cifraDeCompas{i}": (0xE080 + i, f"timeSig{i}") for i in range(10)},
    "cifraDeTresillo": (0xE883, "tuplet3"),
    "bemol": (0xE260, "accidentalFlat"), "becuadro": (0xE261, "accidentalNatural"),
    "sostenido": (0xE262, "accidentalSharp"), "dobleSostenido": (0xE263, "accidentalDoubleSharp"),
    "dobleBemol": (0xE264, "accidentalDoubleFlat"),
    # Microtonos: cuartos de tono (Stein-Zimmermann), las comas de Arel-Ezgi-Uzdilek y el koron y el sori persas.
    "medioBemol": (0xE280, "accidentalQuarterToneFlatStein"),
    "tresCuartosBemol": (0xE281, "accidentalThreeQuarterTonesFlatZimmermann"),
    "medioSostenido": (0xE282, "accidentalQuarterToneSharpStein"),
    "tresCuartosSostenido": (0xE283, "accidentalThreeQuarterTonesSharpStein"),
    "buyukMucennebBemol": (0xE440, "accidentalBuyukMucennebFlat"),
    "kucukMucennebBemol": (0xE441, "accidentalKucukMucennebFlat"),
    "bakiyeBemol": (0xE442, "accidentalBakiyeFlat"), "komaBemol": (0xE443, "accidentalKomaFlat"),
    "komaSostenido": (0xE444, "accidentalKomaSharp"), "bakiyeSostenido": (0xE445, "accidentalBakiyeSharp"),
    "kucukMucennebSostenido": (0xE446, "accidentalKucukMucennebSharp"),
    "buyukMucennebSostenido": (0xE447, "accidentalBuyukMucennebSharp"),
    "koron": (0xE460, "accidentalKoron"), "sori": (0xE461, "accidentalSori"),
    # Los moria bizantinos (72 por octava), con los signos de doceavos de tono de Wyschnegradsky que usan sus escalas.
    "moriaSostenido2": (0xE421, "accidentalWyschnegradsky2TwelfthsSharp"),
    "moriaSostenido4": (0xE423, "accidentalWyschnegradsky4TwelfthsSharp"),
    "moriaSostenido8": (0xE427, "accidentalWyschnegradsky8TwelfthsSharp"),
    "moriaSostenido10": (0xE429, "accidentalWyschnegradsky10TwelfthsSharp"),
    "moriaBemol2": (0xE42C, "accidentalWyschnegradsky2TwelfthsFlat"),
    "moriaBemol4": (0xE42E, "accidentalWyschnegradsky4TwelfthsFlat"),
    "moriaBemol8": (0xE432, "accidentalWyschnegradsky8TwelfthsFlat"),
    "moriaBemol10": (0xE434, "accidentalWyschnegradsky10TwelfthsFlat"),
    # Los śruti: la coma sintónica de Helmholtz-Ellis, una flecha en el bemol, el becuadro o el sostenido.
    "bemolFlechaAbajo": (0xE2C1, "accidentalFlatOneArrowDown"),
    "becuadroFlechaAbajo": (0xE2C2, "accidentalNaturalOneArrowDown"),
    "sostenidoFlechaAbajo": (0xE2C3, "accidentalSharpOneArrowDown"),
    "bemolFlechaArriba": (0xE2C6, "accidentalFlatOneArrowUp"),
    "becuadroFlechaArriba": (0xE2C7, "accidentalNaturalOneArrowUp"),
    "sostenidoFlechaArriba": (0xE2C8, "accidentalSharpOneArrowUp"),
    # Las articulaciones y los ornamentos, encima de la nota (o debajo, los de las articulaciones que tienen dos).
    "staccatoArriba": (0xE4A2, "articStaccatoAbove"), "staccatissimoArriba": (0xE4A6, "articStaccatissimoAbove"),
    "staccatissimoAbajo": (0xE4A7, "articStaccatissimoBelow"),
    "tenuto": (0xE4A4, "articTenutoAbove"), "acento": (0xE4A0, "articAccentAbove"),
    "marcatoArriba": (0xE4AC, "articMarcatoAbove"), "marcatoAbajo": (0xE4AD, "articMarcatoBelow"),
    "calderonArriba": (0xE4C0, "fermataAbove"), "calderonAbajo": (0xE4C1, "fermataBelow"),
    "trino": (0xE566, "ornamentTrill"), "mordenteSuperior": (0xE56C, "ornamentShortTrill"),
    "mordenteInferior": (0xE56D, "ornamentMordent"), "grupeto": (0xE567, "ornamentTurn"),
    "grupetoInvertido": (0xE568, "ornamentTurnInverted"),
    # Las cifras de los grupos irregulares (cinquillo, seisillo…).
    **{f"cifraDeGrupo{i}": (0xE880 + i, f"tuplet{i}") for i in range(10)},
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
