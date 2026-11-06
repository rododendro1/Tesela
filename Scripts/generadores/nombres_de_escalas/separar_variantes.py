#!/usr/bin/env python3
"""Separa de los `alias:` del catálogo y de los ficheros de idioma las variantes: otras formas de escribir el nombre
o un alias anterior (otro género, otra transliteración, otra escritura), que pasan a `variantes:`. Es un criterio
aproximado (por parecido de las palabras, con dos listas de excepciones a mano): revisa el diff.
Uso: python3 separar_variantes.py <raíz del repo> [aplicar]   (sin `aplicar`, solo enseña el reparto)"""
import re,sys,glob
from pathlib import Path
import unicodedata,difflib
def norm(s):
    s=s.replace('♯','#').replace('♭','b').replace('ı','i').replace('ə','e').replace('ʿ','').replace('ʾ','').replace("'",'').replace('’','')
    return ''.join(c for c in unicodedata.normalize('NFD',s.lower()) if unicodedata.category(c)!='Mn')
def latino(s): return all(not c.isalpha() or unicodedata.category(c)=='Lm' or 'LATIN' in unicodedata.name(c,'') for c in s)
GEN=re.compile(r'(?<=[a-z])(o|a|os|as|e|u)\b|(?<=[а-я])(ий|ый|ой|ая|ое|ые|ая|ий)\b|(?<=[α-ω])(ος|η|ο|α|ες|οι|ης)\b')
def palabras(s): return [w for w in re.split(r'[\s\-]+',norm(s)) if w]
def esq(w):
    w=GEN.sub('',w)
    for a,b in [('sh','s'),('ch','c'),('kh','k'),('th','t'),('dh','d'),('bh','b'),('gh','g'),('ph','f'),('tz','z'),('ts','z'),('ou','u'),('oo','u'),('ee','i'),('w','v'),('y','i'),('j','z'),('c','z'),('k','c'),('q','c'),('x','c'),('ss','s'),('tt','t'),('nn','n'),('mm','m'),('ll','l'),('ae','e'),('ai','e'),('ei','i'),('h','')]:
        w=w.replace(a,b)
    return w
UMBRAL=0.7
TRAD={('mayor','major'),('menor','minor'),('autentico','authenticus'),('plagal','plagalis'),('natural','naturale'),('duro','durum'),('hexacordo','hexachordum'),('escala','skala')}
def variante_de(a,b):
    """¿a es otra grafía de b?"""
    if norm(a)==norm(b): return True
    pa,pb=palabras(a),palabras(b)
    if ''.join(map(esq,pa))==''.join(map(esq,pb)): return True
    if len(pa)!=len(pb):
        return difflib.SequenceMatcher(None,''.join(map(esq,pa)),''.join(map(esq,pb))).ratio()>=0.9 and abs(len(''.join(pa))-len(''.join(pb)))<=1
    for x,y in zip(pa,pb):
        if x==y: continue
        if (GEN.sub('',x),GEN.sub('',y)) in TRAD or (GEN.sub('',y),GEN.sub('',x)) in TRAD or (x,y) in TRAD or (y,x) in TRAD: return False
        ex,ey=esq(x),esq(y)
        if ex==ey: continue
        if x.isdigit() or y.isdigit(): return False
        if difflib.SequenceMatcher(None,ex,ey).ratio()<UMBRAL: return False
    return True
def separar(nombre,alias,manual_v=(),manual_a=()):
    al,va=[],[]
    for a in alias:
        if a in manual_a: al.append(a); continue
        if a in manual_v: va.append(a); continue
        if latino(nombre) and not latino(a): va.append(a); continue
        if any(variante_de(a,b) for b in [nombre]+al+va): va.append(a)
        else: al.append(a)
    return al,va

FORZAR_ALIAS={"esatonica","Podhale","podhalana","Svaneti","hipoeólico","hipojónico","Yaman Kalyāṇ","Bali","Kumoi","Kokin","Adoshem Malakh",
 "ʿUshshāq de Ṣafī al-Dīn","Nawā de Ṣafī al-Dīn","Abū Salīk de Ṣafī al-Dīn","Rāst de Ṣafī al-Dīn","điệu Bắc","hơi Bắc","điệu Oán","Akadinda"}
FORZAR_VARIANTE={"Tizita","Tizita mayor","Tizita major","Tizita menor","Tizita minor","ichos protos","ichos defteros","ichos tritos","ichos tetartos","Neveser","Sampah","Jiao","Yoo"}

ROOT=Path(sys.argv[1]); APLICAR=len(sys.argv)>2 and sys.argv[2]=="aplicar"
ESC=ROOT/"Packages/Armonia/Sources/ArmoniaTeoria/Escalas"
CAD=r'"((?:[^"\\]|\\.)*)"'
def q(l): return ", ".join('"'+e+'"' for e in l)
def lista(nombre,elems,prefijo,indent,cola):
    """`nombre: [...]` + cola en una línea si cabe en 120 columnas tras `prefijo`; si no, un elemento tras otro."""
    una=f'{nombre}: [{q(elems)}]{cola}'
    if len(prefijo)+len(una)<=120: return una
    lineas=[]; cur=''
    for e in elems:
        tok=f'"{e}",'
        if cur and indent+4+len(cur)+1+len(tok)>120: lineas.append(cur); cur=tok
        else: cur=(cur+' '+tok) if cur else tok
    lineas.append(cur)
    return f'{nombre}: [\n'+''.join(' '*(indent+4)+l+'\n' for l in lineas)+' '*indent+']'+cola
def catalogo(path):
    t=path.read_text(encoding="utf-8"); out=[]; pos=0
    for m in re.finditer(r'alias: \[((?:[^\]\\]|\\.)*)\]',t):
        nombres=re.findall(r'nombre: '+CAD,t[:m.start()])
        if not nombres or '\\(' in m.group(1) or not t[m.end():].startswith(')'): continue
        nombre=nombres[-1]
        a,v=separar(nombre,re.findall(CAD,m.group(1)),FORZAR_VARIANTE,FORZAR_ALIAS)
        if not v: continue
        print(f'{path.name}: {nombre} | alias {a} | variantes {v}')
        prefijo=t[t.rfind('\n',0,m.start())+1:m.start()]
        k=t.rfind('nombre: ',0,m.start()); indent=k-(t.rfind('\n',0,k)+1)
        if a:
            primero=lista('alias',a,prefijo,indent,','); segundo=lista('variantes',v,' '*indent,indent,')')
            ultima=(prefijo+primero).split('\n')[-1]
            juntos='\n' not in primero+segundo and len(ultima)+1+len(segundo)<=120
            nuevo=primero+(' ' if juntos else '\n'+' '*indent)+segundo
        else:
            nuevo=lista('variantes',v,prefijo,indent,')')
        out.append(t[pos:m.start()]+nuevo); pos=m.end()+1
    out.append(t[pos:])
    if APLICAR: path.write_text(''.join(out),encoding="utf-8")
FILA=re.compile(r'^(        \.init\(\.\w+, '+CAD+r'), alias: \[([^\]]*)\]\),$',re.M)
def idioma(path):
    def rep(m):
        a,v=separar(m.group(2),re.findall(CAD,m.group(3)),FORZAR_VARIANTE,FORZAR_ALIAS)
        if not v: return m.group(0)
        print(f'{path.name}: {m.group(2)} | alias {a} | variantes {v}')
        return m.group(1)+(f', alias: [{q(a)}]' if a else '')+f', variantes: [{q(v)}]),'
    t=FILA.sub(rep,path.read_text(encoding="utf-8"))
    if APLICAR: path.write_text(t,encoding="utf-8")
for f in sorted(ESC.rglob("*.swift")):
    if f.parent.name!="Nombres": catalogo(f)
    elif f.name!="NombresDeEscalas.swift": idioma(f)
