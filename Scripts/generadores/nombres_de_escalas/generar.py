#!/usr/bin/env python3
"""Añade alias a los ficheros de idioma de NombresDeEscalas (los del español y del inglés, traducidos).
Uso: python3 generar.py <raíz del repo>"""
import re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "comprobaciones"))   # Scripts/comprobaciones/normalizar_escalas.py
from lexico import LANGS, MODOS, PAL

RAIZ = Path(sys.argv[1])
NOMBRES = RAIZ / "Packages/Armonia/Sources/ArmoniaTeoria/Escalas/Nombres"
IDX = {l: i for i, l in enumerate(LANGS)}


from normalizar_escalas import normalizar as norm



def pal(clave, lang):
    return PAL[clave][IDX[lang]]


def modo(lang, m, fem=False):
    base = MODOS[m][lang][1 if fem else 0]
    return base


ALEMAN_ORDEN = {("dor", "ukr"): ("ukr", "dor"), ("men", "rum"): ("rum", "men"), ("fri", "esp"): ("esp", "fri"),
                ("may", "mel"): ("mel", "may"), ("men", "mel", "cla"): ("cla", "mel", "men")}
ALEMAN_SIN = {("'bebop'", "mel"), ("'bebop'", "arm"), ("gitf", "hun"), ("fri", "fla"), ("men", "mel", "asc")}
EUSKERA_SIN = {("men", "mel", "asc")}


def ensamblar(lang, tokens):
    if lang == "Euskera" and tuple(tokens) in EUSKERA_SIN: return None
    if lang == "Aleman":
        if tuple(tokens) in ALEMAN_SIN: return None
        tokens = list(ALEMAN_ORDEN.get(tuple(tokens), tokens))
    """tokens: 'ion', 'ionf' (femenino), palabras del léxico o literales entre comillas simples."""
    partes = []
    for i, t in enumerate(tokens):
        if t.startswith("'"):
            partes.append(t.strip("'")); continue
        fem = t.endswith("f") and t[:-1] in MODOS
        clave = t[:-1] if fem else t
        if t == "sfri":
            partes.append("super" + modo(lang, "fri")); continue
        if clave in MODOS:
            w = modo(lang, clave, fem)
            # Euskera: delante de un adjetivo, la raíz sin -rra ("lidiar gehitua").
            sigue = tokens[i + 1] if i + 1 < len(tokens) else None
            if lang == "Euskera" and sigue is not None and not sigue.startswith("'") and w.endswith("arra"):
                w = w[:-3]
            partes.append(w)
        else:
            w = pal(clave, lang)
            if w is None: return None
            partes.append(w)
    return " ".join(partes)


# --- Alias que se componen con las palabras del léxico: tipo -> [secuencia de tokens]
COMPUESTOS = {
    "mayor": [["ion"], ["ionf"]],
    "frigioCuartaDisminuida": [["sfri"]],
    "dorico": [["dorf"]], "frigio": [["frif"]], "lidio": [["lidf"]], "mixolidio": [["mixf"]], "locrio": [["locf"]],
    "menorNatural": [["men"], ["eol"], ["eolf"]],
    "alterada": [["sup"], ["supf"]],
    "jonicoAumentado": [["ion", "aum"]],
    "lidioAumentado": [["lid", "'♯5'"]],
    "doricoSegundaMenor": [["fri", "'♮6'"]],
    "lidioDominante": [["lid", "'♭7'"], ["aco"], ["mix", "'♯4'"]],
    "locrioSextaNatural": [["loc", "nat", "'6'"], ["loc", "'♯6'"]],
    "locrioSegundaNatural": [["loc", "nat", "'2'"], ["sdis"]],
    "lidioDominanteAumentado": [["lid", "dom", "'♯5'"], ["lid", "aum", "'♭7'"]],
    "locrioDominante": [["loc", "'♮3'"], ["loc", "may", "'♭2'"]],
    "eolicoCuartaAumentada": [["men", "'♯4'"], ["gitf", "hun"]],
    "frigioDominante": [["fri", "may"], ["fri", "'♯3'"], ["fri", "'♮3'"], ["espf"], ["fri", "esp"], ["dom", "'♭9 ♭13'"]],
    "lidioTerceraMenor": [["lid", "dis"]],
    "ultralocrio": [["sup", "'♭♭7'"], ["alt", "disf"]],
    "superlocrioTerceraDisminuida": [["alt", "'♭♭3'"]],
    "ultralocrioSextaDisminuida": [["alt", "'♭♭6 ♭♭7'"]],
    "superlocrioSextaNatural": [["alt", "'♮6'"]],
    "locrioSegundaNaturalCuartaDisminuida": [["sdis", "'♭4'"], ["loc", "nat", "'2 ♭4'"]],
    "mixolidioAumentado": [["mix", "'♯5'"]],
    "mixolidioSextaMenor": [["hin"], ["may", "mel"], ["eol", "dom"]],
    "doricoCuartaAumentada": [["dor", "ukr"], ["men", "rum"], ["rum"]],
    "doricoSegundaMenorCuartaAumentada": [["dor", "'♭9 ♯11'"]],
    "bebopMenorMelodica": [["'bebop'", "mel"]],
    "bebopMenorArmonica": [["'bebop'", "arm"]],
    "bebopDominante": [["'bebop'"]],
    "bebopDorico": [["'bebop'", "men"]],
    "dobleArmonica": [["biz"], ["gitf", "mayf"]],
    "menorHungara": [["gitf", "menf"]],
    "mayorLocria": [["ara"]],
    "prometeo": [["mis"]],
    "flamenca": [["and"], ["fri", "fla"], ["gitf", "espf"]],
    "pentatonicaEscocesa": [["esc"]],
    "pentatonicaMayor": [["pent"]],
    "menorMelodica": [["men", "mel", "cla"]],
    "menorMelodicaJazz": [["men", "mel", "asc"]],
    "jonicoSinCuarta": [["ionf", "gae"], ["ion", "hexm"]],
    "mixolidioSinTercera": [["mixf", "gae"], ["mix", "hexm"]],
    "doricoSinSexta": [["dorf", "gae"], ["dor", "hexm"]],
    "eolicoSinSegunda": [["eolf", "gae"], ["eol", "hexm"]],
}
# Los modos femeninos de arriba usan "dorf", etc.: se resuelven con MODOS.

# --- Frases que no se componen: tipo -> lista de frases; cada frase, una cadena por idioma (orden de LANGS), None si no hay.
# Orden: Catalan, Gallego, Asturiano, Aragones, Euskera, Portugues, Frances, Occitano, Italiano, Aleman
FRASES = {
    "menorHungara": [["de Liszt", "de Liszt", "de Liszt", "de Liszt", "Liszt", "de Liszt", "de Liszt", "de Liszt", "di Liszt", "Liszt"],
                     ["Liszt"] * 10,
                     ["doble harmònica menor", "dobre harmónica menor", "doble armónica menor", "doble armónica menor", "harmoniko bikoitz minorra",
                      "dupla harmónica menor", "double harmonique mineure", "dobla armonica menora", "doppia armonica minore", "doppelt harmonisch Moll"]],
    "dobleArmonica": [["doble harmònica major", "dobre harmónica maior", "doble armónica mayor", "doble armónica mayor", "harmoniko bikoitz maiorra",
                       "dupla harmónica maior", "double harmonique majeure", "dobla armonica majora", "doppia armonica maggiore", "doppelt harmonisch Dur"]],
    "prometeo": [["de Prometeu", "de Prometeo", "de Prometeo", "de Prometeo", "Prometeo", "de Prometeu", "de Prométhée", "de Promètèu", "di Prometeo", "Prometheus"],
                   ["Skriabin"] * 10, ["Scriabin"] * 10],
    "disminuidaSemitonoTono": [
        ["disminuïda dominant", "diminuída dominante", "menguada dominante", "disminuyida dominant", "gutxitua dominantea", "diminuta dominante", "diminuée dominante", "disminuida dominanta", "diminuita dominante", "vermindert dominant"],
        ["dominant disminuïda", "dominante diminuída", "dominante menguada", "dominant disminuyida", "dominantea gutxitua", "dominante diminuta", "dominante diminuée", "dominanta disminuida", "dominante diminuita", "dominant vermindert"],
        ["mode 2 de Messiaen", "modo 2 de Messiaen", "mou 2 de Messiaen", "modo 2 de Messiaen", "Messiaenen 2. modua", "modo 2 de Messiaen", "mode 2 de Messiaen", "mòde 2 de Messiaen", "modo 2 di Messiaen", "Messiaen-Modus 2"],
        ["de Rimski-Kórsakov", "de Rimski-Kórsakov", "de Rimski-Kórsakov", "de Rimski-Kórsakov", "Rimski-Korsakov", "de Rimski-Kórsakov", "de Rimski-Korsakov", "de Rimski-Kòrsakov", "di Rimskij-Korsakov", "Rimski-Korsakow"],
        ["Rimsky-Korsakov"] * 10],
    "aumentada": [["hexatònica augmentada", "hexatónica aumentada", "hexatónica aumentada", "hexatónica aumentada", "hexatoniko gehitua", "hexatónica aumentada", "hexatonique augmentée", "exatonica aumentada", "esatonica aumentata", "übermäßig Hexatonik"],
                  ["Weitzmann"] * 10,
                  ["de Weitzmann", "de Weitzmann", "de Weitzmann", "de Weitzmann", "Weitzmannen", "de Weitzmann", "de Weitzmann", "de Weitzmann", "di Weitzmann", "Weitzmann"]],
    "egipcia": [["pentatònica suspesa", "pentatónica suspendida", "pentatónica suspendida", "pentatónica suspendida", "pentatoniko esekia", "pentatónica suspensa", "pentatonique suspendue", "pentatonica suspenduda", "pentatonica sospesa", "suspendierte Pentatonik"]],
    "petrushka": [["Petrouchka"] * 10, ["de Petrushka", "de Petrushka", "de Petrushka", "de Petrushka", "Petrushka", "de Petrushka", "de Petrouchka", "de Petrushka", "di Petrushka", "Petruschka"],
                    ["de tritó", "de trítono", "de tritono", "de tritono", "tritonoaren", "de trítono", "de triton", "de tritòn", "di tritono", "Tritonus"]],
    "pentatonicaMenorSexta": [["pentatònica menor amb sexta", "pentatónica menor con sexta", "pentatónica menor con sexta", "pentatónica menor con sexta", None, "pentatónica menor com sexta", "pentatonique mineure avec sixte", "pentatonica menora amb sèxta", "pentatonica minore con sesta", "Moll-Pentatonik mit Sexte"],
                              ["pentatònica dòrica", "pentatónica dórica", "pentatónica dórica", "pentatónica dórica", "pentatoniko doriarra", "pentatónica dórica", "pentatonique dorienne", "pentatonica doriana", "pentatonica dorica", "dorische Pentatonik"]],
    "pentatonicaMayorSextaMenor": [["pentatònica de Coltrane", "pentatónica de Coltrane", "pentatónica de Coltrane", "pentatónica de Coltrane", "Coltranen pentatonikoa", "pentatónica de Coltrane", "pentatonique de Coltrane", "pentatonica de Coltrane", "pentatonica di Coltrane", "Coltrane-Pentatonik"],
                                    ["Coltrane"] * 10],
    "hexacordo": [["hexacord de Guido", "hexacordo de Guido", "hexacordu de Guido", "hexacordo de Guido", "Guidoren hexakordea", "hexacorde de Guido", "hexacorde de Guido", "exacòrd de Guido", "esacordo di Guido", "Guidonischer Hexachord"],
                  ["ut re mi fa sol la"] * 10],
    "tonosEnteros": [["hexatònica", "hexatónica", "hexatónica", "hexatónica", "hexatonikoa", "hexatónica", "hexatonique", "exatonica", "esatonica", "Hexatonik"],
              ["mode 1 de Messiaen", "modo 1 de Messiaen", "mou 1 de Messiaen", "modo 1 de Messiaen", "Messiaenen 1. modua", "modo 1 de Messiaen", "mode 1 de Messiaen", "mòde 1 de Messiaen", "modo 1 di Messiaen", "Messiaen-Modus 1"],
              ["augmentada auxiliar", "aumentada auxiliar", "aumentada auxiliar", "aumentada auxiliar", "gehitu osagarria", "aumentada auxiliar", "augmentée auxiliaire", "aumentada auxiliara", "aumentata ausiliaria", "Hilfs-übermäßig"],
                ["de Debussy", "de Debussy", "de Debussy", "de Debussy", "Debussyren", "de Debussy", "de Debussy", "de Debussy", "di Debussy", "Debussy"],
              ["Debussy"] * 10],
    "disminuida": [["octatònica", "octatónica", "octatónica", "octatónica", "oktatonikoa", "octatónica", "octatonique", "octatonica", "ottatonica", "Oktatonik"],
                   ["mode 2 de Messiaen invers", "modo 2 de Messiaen inverso", "mou 2 de Messiaen inversu", "modo 2 de Messiaen inverso", "Messiaenen 2. modua alderantziz", "modo 2 de Messiaen inverso", "mode 2 de Messiaen inversé", "mòde 2 de Messiaen invèrs", "modo 2 di Messiaen inverso", "Messiaen-Modus 2 invers"],
                   ["disminuïda auxiliar", "diminuída auxiliar", "menguada auxiliar", "disminuyida auxiliar", "gutxitu osagarria", "diminuta auxiliar", "diminuée auxiliaire", "disminuida auxiliara", "diminuita ausiliaria", "Hilfs-vermindert"]],
    "menorMelodicaQuintaAumentada": [["menor de jazz ♯5", "menor de jazz ♯5", "menor de jazz ♯5", "menor de jazz ♯5", "jazzeko minorra ♯5", "menor de jazz ♯5", "mineur de jazz ♯5", "menor de jazz ♯5", "minore di jazz ♯5", "Jazz-Moll ♯5"]],
    "lidioAumentadoSextaAumentada": [["tons sencers amb sensible", "tons enteiros con sensible", "tonos enteros con sensible", "tonos enteros con sensible", None, "tons inteiros com sensível", "par tons avec sensible", "tons entièrs amb sensibla", "esatonale con sensibile", "Ganzton mit Leitton"]],
    "menorMelodicaJazz": [["menor de jazz", "menor de jazz", "menor de jazz", "menor de jazz", "jazzeko minorra", "menor de jazz", "mineur de jazz", "menor de jazz", "minore di jazz", "Jazz-Moll"]],
    "cromatica": [["cromàtica amb quatre bemolls", "cromática con catro bemois", "cromática con cuatro bemoles", "cromática con cuatro bemoles", "kromatikoa lau bemolekin", "cromática com quatro bemóis", "chromatique à quatre bémols", "cromatica amb quatre bemòls", "cromatica con quattro bemolli", "chromatisch mit vier b"]],
    "hexatonicaDeDosTriadas": [["dues tríades", "dúas tríades", "dos tríades", "dos tríadas", "bi triade", "duas tríades", "deux triades", "doas triadas", "due triadi", "zwei Dreiklänge"],
                               ["parell de tríades", "par de tríades", "pareya de tríades", "par de tríadas", "triade bikotea", "par de tríades", "paire de triades", "parelh de triadas", "coppia di triadi", "Dreiklangspaar"],
                               ["hexatònica major de dues tríades", "hexatónica maior de dúas tríades", "hexatónica mayor de dos tríades", "hexatónica mayor de dos tríadas", "bi triadeko hexatoniko maiorra", "hexatónica maior de duas tríades", "hexatonique majeure à deux triades", "exatonica majora de doas triadas", "esatonica maggiore di due triadi", "Dur-Hexatonik aus zwei Dreiklängen"]],
    "hexatonicaMenorDeDosTriadas": [["parell de tríades menors", "par de tríades menores", "pareya de tríades menores", "par de tríadas menors", "triade minorren bikotea", "par de tríades menores", "paire de triades mineures", "parelh de triadas menoras", "coppia di triadi minori", "Moll-Dreiklangspaar"]],
    "bluesDeNueveNotas": [["blues eneatònic", "blues eneatónico", "blues eneatónicu", "blues eneatónico", None, "blues eneatónico", "blues ennéatonique", "blues eneatonic", "blues enneatonico", None],
                          ["blues de 9 notes", "blues de 9 notas", "blues de 9 notes", "blues de 9 notas", "9 notako bluesa", "blues de 9 notas", "blues à 9 notes", "blues de 9 nòtas", "blues di 9 note", "9-Ton-Blues"]],
    "bluesMenorConSegunda": [["blues amb segona", "blues con segunda", "blues con segunda", "blues con segunda", "blues bigarrenarekin", "blues com segunda", "blues avec seconde", "blues amb segonda", "blues con seconda", "Blues mit zweiter Stufe"]],
    "messiaen3": [["Messiaen 3"] * 10, ["Tcherepnin"] * 10,
                  ["de Tcherepnin", "de Tcherepnin", "de Tcherepnin", "de Tcherepnin", "Tcherepninen", "de Tcherepnin", "de Tcherepnine", "de Tcherepnin", "di Tcherepnin", "Tscherepnin"],
                  ["nou notes", "nove notas", "nueve notes", "nueu notas", "bederatzi nota", "nove notas", "neuf notes", "nòu nòtas", "nove note", "neun Töne"]],
    "messiaen4": [["Messiaen 4"] * 10], "messiaen5": [["Messiaen 5"] * 10],
    "messiaen6": [["Messiaen 6"] * 10], "messiaen7": [["Messiaen 7"] * 10],
    "lidioDominante": [["de Bartók", "de Bartók", "de Bartók", "de Bartók", "Bartók", "de Bartók", "de Bartók", "de Bartók", "di Bartók", "Bartók"],
                       ["Bartók"] * 10],
}


def principal():
    resumen = {}
    conflictos = []
    # nombres principales de cada idioma, por tipo, para detectar choques
    for lang in LANGS:
        ruta = NOMBRES / f"NombresDeEscalas+{lang}.swift"
        texto = ruta.read_text(encoding="utf-8")
        filas = re.findall(r'^        \.init\((\.\w+), "((?:[^"\\]|\\.)*)"\),$', texto, re.M)
        nombres_norm = {}
        for t, n in filas:
            nombres_norm.setdefault(norm(n), t)
        todos = {}   # clave normalizada -> tipo del que ya es alias
        nuevos = {}
        for t, n in filas:
            tipo = t[1:]
            cand = []
            for toks in COMPUESTOS.get(tipo, []):
                s = ensamblar(lang, toks)
                if s: cand.append(s)
            for frase in FRASES.get(tipo, []):
                s = frase[IDX[lang]]
                if s: cand.append(s)
            vistos = {norm(n)}
            buenos = []
            for a in cand:
                k = norm(a)
                if k in vistos: continue
                if k in nombres_norm and nombres_norm[k] != t:
                    conflictos.append((lang, tipo, a, "es el nombre de " + nombres_norm[k][1:])); continue
                if k in todos and todos[k] != t:
                    conflictos.append((lang, tipo, a, "ya es alias de " + todos[k][1:])); continue
                vistos.add(k); todos[k] = t; buenos.append(a)
            if buenos: nuevos[t] = buenos
        def sustituir(m):
            t, n = m.group(1), m.group(2)
            if t in nuevos:
                al = ", ".join('"' + a + '"' for a in nuevos[t])
                return f'        .init({t}, "{n}", alias: [{al}]),'
            return m.group(0)
        nuevo_texto = re.sub(r'^        \.init\((\.\w+), "((?:[^"\\]|\\.)*)"\),$', sustituir, texto, flags=re.M)
        ruta.write_text(nuevo_texto, encoding="utf-8")
        resumen[lang] = (len(nuevos), sum(len(v) for v in nuevos.values()))
    for l, (a, b) in resumen.items(): print(f"{l:10} {a} tipos con alias, {b} alias")
    print("conflictos:", len(conflictos))
    for c in conflictos: print("  ", c)


principal()
