#!/usr/bin/env python3
"""Quita de los alias de `Escalas/` los que son solo la forma normalizada (sin diacríticos) de otra grafía.
Uso: python3 quitar_alias_normalizados.py <raíz del repo> [aplicar]   (sin `aplicar`, solo cuenta)"""
import re,sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))   # Scripts/normalizar_escalas.py
from normalizar_escalas import normalizar as norm
ROOT=Path(sys.argv[1]); APLICAR=len(sys.argv)>2 and sys.argv[2]=="aplicar"
ESC=ROOT/"Packages/Armonia/Sources/ArmoniaTeoria/Escalas"
CAD=re.compile(r'"((?:[^"\\]|\\.)*)"')
def dev(t): return any(0x900<=ord(c)<=0x97F for c in t)
def ascii_(t): return all(ord(c)<128 for c in t)
total=0; grupos={}  # fichero -> lista (dueño, nombres, aliases, nuevos)
for f in sorted(ESC.rglob("*.swift")):
    if f.name in ("TipoDeEscala.swift","NombresDeEscalas.swift") or f.name=="Escala.swift": continue
    s=f.read_text(encoding="utf-8"); out=[]; pos=0; cambios=0
    lang="Nombres" in str(f)
    for m in re.finditer(r',?(\s*)alias: \[((?:[^\]\\]|\\.)*)\]',s):
        cuerpo=m.group(2)
        if "\\(" in cuerpo: continue
        aliases=CAD.findall(cuerpo)
        if lang:
            ini=s.rfind("\n",0,m.start())+1; linea=s[ini:m.start()]
            nombres=CAD.findall(linea)
        else:
            nm=list(re.finditer(r'nombre: "((?:[^"\\]|\\.)*)"',s[:m.start()]))
            nombres=[nm[-1].group(1)]
        escritas=nombres+aliases
        quitar=[]
        for a in aliases:
            if not ascii_(a) or dev(a): continue
            if any(b!=a and norm(b)==norm(a) and (not ascii_(b) or b in nombres) for b in escritas) or any(norm(n)==norm(a) and n!=a for n in nombres):
                quitar.append(a)
        if quitar:
            cambios+=len(quitar)
            resto=[a for a in aliases if a not in quitar]
            if resto: rep=m.group(0)[:m.group(0).index("alias: [")]+"alias: ["+", ".join('"'+a+'"' for a in resto)+"]"
            else: rep=""
            out.append((m.start(),m.end(),rep))
            grupos.setdefault(f,[]).append((nombres[0] if nombres else "?",quitar))
    total+=cambios
    if APLICAR and out:
        for a,b,r in reversed(out): s=s[:a]+r+s[b:]
        f.write_text(s,encoding="utf-8")
print("quitados:",total)
for f,l in grupos.items(): print(f.name,sum(len(q) for _,q in l))
if not APLICAR:
    for f,l in list(grupos.items())[:3]:
        for n,q in l[:5]: print(f.name,n,q)
