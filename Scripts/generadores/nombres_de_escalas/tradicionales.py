#!/usr/bin/env python3
"""Añade a cada fichero de idioma las escalas de otras tradiciones (`.tradicional(.miembro)`), con traducción las que la necesitan.
Uso: python3 tradicionales.py <raíz del repo>"""
import re, sys
from pathlib import Path

RAIZ = Path(sys.argv[1])
ESC = RAIZ / "Packages/Armonia/Sources/ArmoniaTeoria/Escalas"
CAD = re.compile(r'"((?:[^"\\]|\\.)*)"')
TRAD = [("Andes", "Andes"), ("China", "China"), ("Corea", "Corea"), ("Etiopía", "Etiopia"),
        ("Grecia: dromoi y escalas de la Grecia antigua", "Grecia"), ("India", "India"), ("Indonesia", "Indonesia"),
        ("Japón", "Japon"), ("Klezmer", "Klezmer"), ("Mundo árabe: maqamat", "MundoArabe"), ("Persia: dastgāh", "Persia")]

# Nombres que se traducen: original -> {idioma: traducción}. El resto se escribe igual en todos los idiomas.
ORDEN = ["Catalan", "Gallego", "Asturiano", "Aragones", "Euskera", "Portugues", "Frances", "Occitano", "Italiano", "Aleman",
         "Ingles", "Ruso", "Griego"]
T = {
 "pentatónica andina": ["pentatònica andina", "pentatónica andina", "pentatónica andina", "pentatónica andina", "Andeetako pentatonikoa", "pentatónica andina", "pentatonique andine", "pentatonica andina", "pentatonica andina", "andine Pentatonik", "Andean pentatonic", "андская пентатоника", "ανδική πεντατονική"],
 "tritónica andina": ["tritònica andina", "tritónica andina", "tritónica andina", "tritónica andina", "Andeetako tritonikoa", "tritónica andina", "tritonique andine", "tritonica andina", "tritonica andina", "andine Tritonik", "Andean tritonic", "андская тритоника", "ανδική τρίτονη"],
 "tetracordo diatónico": ["tetracord diatònic", "tetracordo diatónico", "tetracordu diatónicu", "tetracordo diatónico", "tetrakorde diatonikoa", "tetracorde diatónico", "tétracorde diatonique", "tetracòrd diatonic", "tetracordo diatonico", "diatonischer Tetrachord", "diatonic tetrachord", "диатонический тетрахорд", "διατονικό τετράχορδο"],
 "tetracordo cromático": ["tetracord cromàtic", "tetracordo cromático", "tetracordu cromáticu", "tetracordo cromático", "tetrakorde kromatikoa", "tetracorde cromático", "tétracorde chromatique", "tetracòrd cromatic", "tetracordo cromatico", "chromatischer Tetrachord", "chromatic tetrachord", "хроматический тетрахорд", "χρωματικό τετράχορδο"],
 "harmonía doria": ["harmonia dòria", "harmonía dórica", "harmonía dória", "harmonía doria", "harmonia doriarra", "harmonia dória", "harmonie dorienne", "armonia doriana", "armonia dorica", "dorische Harmonie", "Dorian harmonia", "дорийская гармония", "δωρική αρμονία"],
 "harmonía doria cromática": ["harmonia dòria cromàtica", "harmonía dórica cromática", "harmonía dória cromática", "harmonía doria cromática", "harmonia doriar kromatikoa", "harmonia dória cromática", "harmonie dorienne chromatique", "armonia doriana cromatica", "armonia dorica cromatica", "chromatische dorische Harmonie", "chromatic Dorian harmonia", "дорийская хроматическая гармония", "χρωματική δωρική αρμονία"],
 "harmonía frigia": ["harmonia frígia", "harmonía frixia", "harmonía frixia", "harmonía frichia", "harmonia frigiarra", "harmonia frígia", "harmonie phrygienne", "armonia frigiana", "armonia frigia", "phrygische Harmonie", "Phrygian harmonia", "фригийская гармония", "φρυγική αρμονία"],
 "harmonía lidia": ["harmonia lídia", "harmonía lidia", "harmonía lidia", "harmonía lidia", "harmonia lidiarra", "harmonia lídia", "harmonie lydienne", "armonia lidiana", "armonia lidia", "lydische Harmonie", "Lydian harmonia", "лидийская гармония", "λυδική αρμονία"],
}
# Los nombres propios con «mayor/menor» de las escalas etíopes: se traduce el modo, no el nombre propio (ruso y griego, tal cual).
for base in ("Təzəta", "Bati"):
    for modo, tr in (("mayor", ["major", "maior", "mayor", "mayor", "maiorra", "maior", "majeur", "major", "maggiore", "Dur", "major"]),
                     ("menor", ["menor", "menor", "menor", "menor", "minorra", "menor", "mineur", "menor", "minore", "Moll", "minor"])):
        T[f"{base} {modo}"] = [f"{base} {x}" for x in tr] + [f"{base} {modo}", f"{base} {modo}"]


def texto_de(tradicion):
    """El código de una tradición: la India tiene su fichero; las demás están en `TipoDeEscala+Tradiciones.swift`,
    cada una desde su `// MARK: - Nombre` hasta la marca siguiente."""
    if tradicion == "India":
        return (ESC / "Tradiciones" / "TipoDeEscala+India.swift").read_text(encoding="utf-8")
    texto = (ESC / "Tradiciones" / "TipoDeEscala+Tradiciones.swift").read_text(encoding="utf-8")
    m = re.search(rf"^// MARK: - {tradicion}$(.*?)(?=^// MARK: - |\Z)", texto, re.M | re.S)
    if m is None:
        sys.exit(f"No encuentro `// MARK: - {tradicion}` en TipoDeEscala+Tradiciones.swift")
    return m.group(1)


def nombres():
    grupos = []
    for titulo, fichero in TRAD:
        texto = texto_de(fichero)
        ns = re.findall(r'static let (`?\w+`?) = TipoDeEscala\(\s*nombre: "((?:[^"\\]|\\.)*)"', texto)
        if fichero == "India":    # los 72 melakarta no llevan fila: conservan su nombre original
            titulo = "India: ragas janya, thaat y ragas indostánicos"
        grupos.append((titulo, ns))
    return grupos


def bloque(idioma):
    lineas = ["", "        // Escalas de otras tradiciones: nombres propios, iguales en todos los idiomas salvo los que se traducen.",
              '        // Para traducir una: `.tradicional(.hitzaz, "…")`. Los alias (Hijaz, Hicaz…) están en el catálogo.',
              "        // Los 72 melakarta no se listan: sin fila, conservan su nombre en IAST."]
    vistos = set()
    for titulo, ns in nombres():
        lineas.append(f"        // {titulo}")
        for miembro, n in ns:
            if n in vistos: continue
            vistos.add(n)
            tr = T.get(n)
            if tr is not None:
                t = tr[ORDEN.index(idioma)]
                lineas.append(f'        .tradicional(.{miembro}, "{t}"),' if t != n else f'        .tradicional(.{miembro}),')
            else:
                lineas.append(f'        .tradicional(.{miembro}),')
    faltan = set(T) - vistos
    if faltan: sys.exit(f"no existen: {faltan}")
    return "\n".join(lineas), len(vistos)


for idioma in ORDEN:
    ruta = ESC / "Nombres" / f"NombresDeEscalas+{idioma}.swift"
    s = ruta.read_text(encoding="utf-8")
    assert "tradicional(" not in s, idioma
    cuerpo, n = bloque(idioma)
    cierre = "\n    ])\n}\n"
    assert s.endswith(cierre), idioma
    s = s[: -len(cierre)] + "\n" + cuerpo + cierre
    ruta.write_text(s, encoding="utf-8")
    print(idioma, n)
