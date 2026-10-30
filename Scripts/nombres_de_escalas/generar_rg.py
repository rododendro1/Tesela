#!/usr/bin/env python3
"""Añade alias a mano, por tipo, al ruso y al griego de NombresDeEscalas y, en `EXTRA`, al euskera y al alemán.
Uso: python3 generar_rg.py <raíz del repo>"""
import re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))   # Scripts/normalizar_escalas.py
RAIZ = Path(sys.argv[1]); N = RAIZ / "Packages/Armonia/Sources/ArmoniaTeoria/Escalas/Nombres"
from normalizar_escalas import normalizar as norm

# tipo: (ruso, griego)
T = {
 "mayor": (["ионийская"], ["ιωνική"]), "dorico": (["дорийская"], ["δωρική"]), "frigio": (["фригийская"], ["φρυγική"]),
 "lidio": (["лидийская"], ["λυδική"]), "mixolidio": (["миксолидийская"], ["μιξολυδική"]),
 "menorNatural": (["эолийская"], ["αιολική"]), "locrio": (["локрийская"], ["λοκρική"]),
 "menorMelodica": (["классический мелодический минор"], ["κλασική μελωδική ελάσσονα"]),
 "menorMelodicaJazz": (["мелодический минор восходящий"], ["μελωδική ελάσσονα ανιούσα"]),
 "pentatonicaMayor": (["пентатоника"], ["πεντατονική"]),
 "tonosEnteros": (["гексатоническая", "1-й лад Мессиана", "Дебюсси"], ["εξατονική", "1ος τρόπος του Μεσιάν", "Ντεμπισί"]),
 "disminuida": (["октатоническая"], ["οκτατονική"]),
 "disminuidaSemitonoTono": (["уменьшённая доминантовая", "доминантовая уменьшённая", "2-й лад Мессиана", "Римский-Корсаков"],
                            ["ελαττωμένη δεσπόζουσας", "δεσπόζουσα ελαττωμένη", "2ος τρόπος του Μεσιάν", "Ρίμσκι-Κόρσακοφ"]),
 "menorHungara": (["цыганский минор", "двойной гармонический минор", "Лист"], ["τσιγγάνικη ελάσσονα", "διπλή αρμονική ελάσσονα", "Λιστ"]),
 "dobleArmonica": (["византийская", "цыганский мажор", "двойной гармонический мажор"], ["βυζαντινή", "τσιγγάνικη μείζονα", "διπλή αρμονική μείζονα"]),
 "mayorLocria": (["арабская"], ["αραβική"]), "prometeo": (["мистическая", "Скрябин"], ["μυστική", "Σκριάμπιν"]),
 "aumentada": (["увеличенная гексатоническая"], ["αυξημένη εξατονική"]),
 "petrushka": (["тритоновая"], []),
 "pentatonicaMenorSexta": (["дорийская пентатоника"], ["δωρική πεντατονική"]),
 "pentatonicaMayorSextaMenor": (["пентатоника Колтрейна", "Колтрейн"], ["πεντατονική του Κόλτρεϊν", "Κόλτρεϊν"]),
 "hexacordo": (["гексахорд Гвидо", "ut re mi fa sol la"], ["εξάχορδο του Γκουίντο", "ut re mi fa sol la"]),
 "messiaen3": (["Мессиан 3", "Черепнин"], ["Μεσιάν 3", "Τσερεπνίν"]),
 "messiaen4": (["Мессиан 4"], ["Μεσιάν 4"]), "messiaen5": (["Мессиан 5"], ["Μεσιάν 5"]),
 "messiaen6": (["Мессиан 6"], ["Μεσιάν 6"]), "messiaen7": (["Мессиан 7"], ["Μεσιάν 7"]),
 "cromatica": (["хроматическая с четырьмя бемолями"], ["χρωματική με τέσσερις υφέσεις"]),
 "bebopDominante": (["бибоп"], ["μπίμποπ"]),
 "bebopDorico": (["минорный бибоп"], ["ελάσσονα μπίμποπ"]),
 "bebopMenorMelodica": (["бибоп мелодический"], ["μπίμποπ μελωδική"]),
 "bebopMenorArmonica": (["бибоп гармонический"], ["μπίμποπ αρμονική"]),
 "frigioCuartaDisminuida": (["суперфригийский"], ["υπερφρύγιος"]),
 "jonicoAumentado": (["ионийский увеличенный"], ["ιωνικός αυξημένος"]),
 "lidioAumentado": (["лидийский ♯5"], ["λύδιος ♯5"]),
 "doricoSegundaMenor": (["фригийский ♮6"], ["φρύγιος ♮6"]),
 "lidioDominante": (["лидийский ♭7", "акустическая", "миксолидийский ♯4", "Барток"], ["λύδιος ♭7", "ακουστική", "μιξολύδιος ♯4", "Μπάρτοκ"]),
 "locrioSextaNatural": (["локрийский ♯6"], ["λόκριος ♯6"]),
 "locrioSegundaNatural": (["полууменьшённая"], ["ημιελαττωμένη"]),
 "alterada": (["суперлокрийская"], ["υπερλοκρική"]),
 "ultralocrio": (["суперлокрийский ♭♭7", "альтерированная уменьшённая"], ["υπερλόκριος ♭♭7", "αλλοιωμένη ελαττωμένη"]),
 "mixolidioSextaMenor": (["индийская", "мелодический мажор", "эолийский доминантовый"], ["ινδική", "μελωδική μείζονα", "αιολικός δεσπόζουσας"]),
 "doricoCuartaAumentada": (["украинский дорийский", "румынский минор"], ["ουκρανικός δώριος", "ρουμανική ελάσσονα"]),
 "doricoSegundaMenorCuartaAumentada": (["дорийский ♭9 ♯11"], ["δώριος ♭9 ♯11"]),
 "frigioDominante": (["фригийский ♯3", "фригийский ♮3", "испанская", "испанский фригийский"], ["φρύγιος ♯3", "φρύγιος ♮3", "ισπανική", "ισπανικός φρύγιος"]),
 "lidioTerceraMenor": (["лидийский уменьшённый"], ["λύδιος ελαττωμένος"]),
 "locrioDominante": (["локрийский ♮3"], ["λόκριος ♮3"]),
 "lidioDominanteAumentado": (["лидийский доминантовый ♯5", "лидийский увеличенный ♭7"], ["λύδιος δεσπόζουσας ♯5", "λύδιος αυξημένος ♭7"]),
 "eolicoCuartaAumentada": (["минор ♯4"], ["ελάσσονα ♯4"]),
 "superlocrioTerceraDisminuida": (["альтерированная ♭♭3"], ["αλλοιωμένη ♭♭3"]),
 "ultralocrioSextaDisminuida": (["альтерированная ♭♭6 ♭♭7"], ["αλλοιωμένη ♭♭6 ♭♭7"]),
 "superlocrioSextaNatural": (["альтерированная ♮6"], ["αλλοιωμένη ♮6"]),
 "locrioSegundaNaturalCuartaDisminuida": (["полууменьшённая ♭4"], ["ημιελαττωμένη ♭4"]),
 "mixolidioAumentado": (["миксолидийский ♯5"], ["μιξολύδιος ♯5"]),
 "jonicoSinCuarta": (["ионийский гексатонический"], ["ιωνικός εξατονικός"]),
 "mixolidioSinTercera": (["миксолидийский гексатонический"], ["μιξολύδιος εξατονικός"]),
 "doricoSinSexta": (["дорийский гексатонический"], ["δώριος εξατονικός"]),
 "eolicoSinSegunda": (["эолийский гексатонический"], ["αιολικός εξατονικός"]),
 "flamenca": (["андалусская", "цыганская испанская"], ["ανδαλουσιανή", "φρύγιος φλαμένκο"]),
 "pentatonicaEscocesa": (["шотландская"], ["σκωτσέζικη"]),
 "hexatonicaDeDosTriadas": (["две триады", "пара трезвучий"], ["δύο τρίφωνα", "ζεύγος τριφώνων"]),
 "hexatonicaMenorDeDosTriadas": (["пара минорных трезвучий"], ["ζεύγος ελασσόνων τριφώνων"]),
 "bluesDeNueveNotas": (["блюз из 9 звуков"], ["μπλουζ 9 φθόγγων"]),
 "bluesMenorConSegunda": (["блюз с II"], ["μπλουζ με 2η"]),
 "lidioAumentadoSextaAumentada": (["целотоновая с вводным тоном"], ["ολοτονική με οδηγό"]),
 "menorMelodicaQuintaAumentada": (["джазовый минор ♯5"], ["μελωδική ελάσσονα τζαζ ♯5"]),
}
# Alias que faltaban en euskera y alemán respecto al español: tipo: (euskera, alemán)
EXTRA = {
 "disminuida": (["gutxitua"], ["vermindert"]),
 "aumentada": (["gehitu simetrikoa"], ["symmetrisch übermäßig"]),
 "frigioDominante": (["frigiar maiorra"], ["phrygisch Dur"]),
 "menorMelodicaJazz": (["minor melodiko goranzkoa"], []),
}
# Ruso y griego, además de los de `T`: tipo: (ruso, griego)
T["disminuida"] = (T["disminuida"][0] + ["уменьшённая"], T["disminuida"][1] + ["ελαττωμένη"])
T["aumentada"] = (T["aumentada"][0] + ["симметричная увеличенная"], T["aumentada"][1] + ["συμμετρική αυξημένη"])
T["frigioDominante"] = (T["frigioDominante"][0] + ["фригийский мажор"], T["frigioDominante"][1] + ["φρύγιος μείζονα"])
T["hexatonicaDeDosTriadas"] = (T["hexatonicaDeDosTriadas"][0] + ["мажорная гексатоника из двух трезвучий"],
                               T["hexatonicaDeDosTriadas"][1] + ["μείζονα εξατονική δύο τριφώνων"])
for tipo, (eu, de) in EXTRA.items():
    T[tipo] = tuple(T.get(tipo, ([], []))[:2]) + (eu, de)
CAD = r'"((?:[^"\\]|\\.)*)"'
LIN = re.compile(r'^        \.init\(\.(\w+), ' + CAD + r'(?:, alias: \[(.*?)\])?\),$', re.M)
for k, (lang, i) in enumerate([("Ruso", 0), ("Griego", 1), ("Euskera", 2), ("Aleman", 3)]):
    ruta = N / f"NombresDeEscalas+{lang}.swift"; texto = ruta.read_text(encoding="utf-8")
    filas = LIN.findall(texto)
    dueño = {}
    for t, n, _ in filas: dueño.setdefault(norm(n), t)
    for t, n, al in filas:
        for a in re.findall(CAD, al or ""): dueño.setdefault(norm(a), t)
    tipos = {t for t, _, _ in filas}
    for t in T:
        if t not in tipos: print("TIPO DESCONOCIDO", lang, t)
    nuevos = 0; conflictos = []
    def sust(m):
        global nuevos
        t, n, al = m.group(1), m.group(2), m.group(3)
        existentes = re.findall(CAD, al or "")
        extra = []
        for a in (T.get(t) or ())[i:i + 1][0] if len(T.get(t) or ()) > i else []:
            kk = norm(a)
            if kk == norm(n) or kk in map(norm, existentes + extra): continue
            if kk in dueño and dueño[kk] != t: conflictos.append((t, a, dueño[kk])); continue
            dueño[kk] = t; extra.append(a)
        if not extra: return m.group(0)
        nuevos += len(extra)
        todos = ", ".join('"' + a + '"' for a in existentes + extra)
        return f'        .init(.{t}, "{n}", alias: [{todos}]),'
    ruta.write_text(LIN.sub(sust, texto), encoding="utf-8")
    print(lang, nuevos, "alias nuevos; conflictos:", conflictos)
