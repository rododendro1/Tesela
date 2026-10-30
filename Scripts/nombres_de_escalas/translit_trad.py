#!/usr/bin/env python3
"""Transcribe al ruso y al griego los nombres de las escalas tradicionales (menos los melakarta). Uso: translit_trad.py <raíz>"""
import re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))   # Scripts/normalizar_escalas.py
from normalizar_escalas import normalizar as norm
N = Path(sys.argv[1]) / "Packages/Armonia/Sources/ArmoniaTeoria/Escalas/Nombres"
T = {  # original: (ruso, griego)
 "Gōng": ("Гун", "Γκονγκ"), "Shāng": ("Шан", "Σανγκ"), "Jué": ("Цзюэ", "Τζουέ"), "Zhǐ": ("Чжи", "Τζι"), "Yǔ": ("Юй", "Γιου"),
 "Qīngyuè": ("Цинъюэ", "Τσινγκγιουέ"), "Yǎyuè": ("Яюэ", "Γιαγιουέ"), "Yànyuè": ("Яньюэ", "Γιενγιουέ"),
 "P'yŏngjo": ("Пхёнджо", "Πιονγκτζό"), "Kyemyŏnjo": ("Кемёнджо", "Κιεμιονγκτζό"),
 "Təzəta mayor": ("Тезета мажор", None), "Təzəta menor": ("Тезета минор", None),
 "Bati mayor": ("Бати мажор", None), "Bati menor": ("Бати минор", None),
 "Ambassäl": ("Амбассель", "Αμπασέλ"), "Ančihoye": ("Анчихойе", "Ανσιχόγιε"),
 "Ousák": ("Усак", "Ούσακ"), "Hitzáz": ("Хицаз", "Χιτζάζ"), "Hitzazkiár": ("Хицазкяр", "Χιτζάζκιαρ"),
 "Pireótikos": ("Пиреотикос", "Πειραιώτικος"), "Tabahaniótikos": ("Табаханиотикос", "Ταμπαχανιώτικος"),
 "Niavént": ("Ниавент", "Νιαβέντ"), "Nikríz": ("Никриз", "Νικρίζ"), "Kartzigár": ("Карцигар", "Καρτζιγάρ"),
 "Sabáh": ("Сабах", "Σαμπάχ"), "Houzám": ("Хузам", "Χουζάμ"), "Sengáh": ("Сенгах", "Σεγκιάχ"),
 "Tsingánikos": ("Цинганикос", "Τσιγγάνικος"), "Rast": ("Раст", "Ραστ"), "Kiourdí": ("Кюрди", "Κιουρντί"),
 "Houseïní": ("Хусейни", "Χουσεϊνί"),
 "Mohanam": ("Моханам", "Μοχάναμ"), "Hindolam": ("Хиндолам", "Χιντόλαμ"), "Revati": ("Ревати", "Ρεβάτι"),
 "Amṛtavarṣiṇī": ("Амритаваршини", "Αμρυταβαρσίνι"), "Haṃsadhvani": ("Хамсадхвани", "Χαμσαντβάνι"),
 "Ābhogi": ("Абхоги", "Αμπόγκι"), "Madhyamāvatī": ("Мадхьямавати", "Μαντγιαμαβάτι"), "Bilahari": ("Билахари", "Μπιλαχάρι"),
 "Kāmbhoji": ("Камбходжи", "Καμπότζι"), "Ārabhi": ("Арабхи", "Αραμπί"), "Kedāragauḷa": ("Кедарагаула", "Κεδαραγκάουλα"),
 "Bilāval": ("Билавал", "Μπιλαβάλ"), "Kalyāṇ": ("Калйан", "Καλιάν"), "Khamāj": ("Хамадж", "Καμάτζ"),
 "Kāfī": ("Кафи", "Κάφι"), "Āsāvarī": ("Асавари", "Ασαβαρί"), "Bhairavī": ("Бхайрави", "Μπαϊραβί"),
 "Bhairav": ("Бхайрав", "Μπαϊράβ"), "Mārvā": ("Марва", "Μάρβα"), "Pūrvī": ("Пурви", "Πούρβι"), "Toḍī": ("Тоди", "Τόντι"),
 "Bhūpālī": ("Бхупали", "Μπουπάλι"), "Mālkauns": ("Малкаунс", "Μάλκαουνς"), "Durgā": ("Дурга", "Ντούργκα"),
 "Yaman": ("Яман", "Γιαμάν"), "Bāgeśrī": ("Багешри", "Μπαγκέσρι"), "Śivarañjanī": ("Шиваранджани", "Σιβαρατζάνι"),
 "Kalāvatī": ("Калавати", "Καλαβάτι"), "Candrakauns": ("Чандракаунс", "Τσαντρακάουνς"), "Megh": ("Мегх", "Μεγκ"), "Deś": ("Дес", "Ντες"),
 "Pélog selisir": ("Пелог селисир", "Πέλογκ σελίσιρ"), "Sléndro": ("Слендро", "Σλέντρο"),
 "Ritsu": ("Рицу", "Ρίτσου"), "Ryo": ("Рё", "Ριό"), "Yō": ("Ё", "Γιό"), "Min'yō": ("Миё", "Μινιό"),
 "Miyakobushi": ("Миякобуси", "Μιγιακομπούσι"), "In": ("Ин", "Ιν"), "Insen": ("Инсэн", "Ινσέν"), "Iwato": ("Ивато", "Ιουάτο"),
 "Hirajōshi": ("Хирадзёси", "Χιραγιόσι"), "Kumoijōshi": ("Кумоидзёси", "Κουμοϊγιόσι"), "Ryūkyū": ("Рюкю", "Ριουκιού"),
 "Akebono": ("Акэбоно", "Ακεμπόνο"), "Kokin-jōshi": ("Кокин-дзёси", "Κοκίν-τζόσι"),
 "Freygish": ("Фрейгиш", "Φρέιγκις"), "Misheberakh": ("Мишеберах", "Μισεμπεράχ"),
 "Adonai Malakh": ("Адонай малах", "Αντονάι Μαλάχ"), "Magen Avot": ("Маген авот", "Μαγκέν Αβότ"),
 "Ḥijāz": ("Хиджаз", None), "Nahāwand": ("Нахаванд", "Ναχαβάντ"), "Kurd": ("Курд", "Κουρντ"), "ʿAjam": ("Аджам", "Ατζάμ"),
 "Ḥijāzkār": ("Хиджазкар", "Χιτζαζκάρ"), "Nawā Athar": ("Нава Атар", "Νάβα Ατάρ"),
 "Māhur": ("Махур", "Μαχούρ"), "Homāyun": ("Хомаюн", "Χομαγιούν"), "Čahārgāh": ("Чахаргах", "Τσαχαργκάχ"),
}
CAD = r'"((?:[^"\\]|\\.)*)"'
# nombre original -> miembro de TipoDeEscala (las filas se escriben `.tradicional(.miembro, "…")`)
MIEMBRO = {}
for f in (N.parent / "Tradiciones").glob("*.swift"):
    for m in re.finditer(r'static let (`?\w+`?) = TipoDeEscala\(\s*nombre: ' + CAD, f.read_text(encoding="utf-8")):
        MIEMBRO[m.group(2)] = m.group(1)
POR_MIEMBRO = {MIEMBRO[o]: v for o, v in T.items()}
for lang, i in (("Ruso", 0), ("Griego", 1)):
    ruta = N / f"NombresDeEscalas+{lang}.swift"; texto = ruta.read_text(encoding="utf-8")
    ocupados = {norm(n) for n in re.findall(r'^        \.init\(\.\w+, ' + CAD, texto, re.M)}
    vistos = {}; hechos = 0
    def sust(m):
        global hechos
        orig = m.group(1); tr = POR_MIEMBRO.get(orig, (None, None))[i]
        if not tr: return m.group(0)
        k = norm(tr)
        assert k not in ocupados and k not in vistos, (lang, orig, tr, vistos.get(k))
        vistos[k] = orig; hechos += 1
        return f'        .tradicional(.{orig}, "{tr}"),'
    nuevo = re.sub(r'^        \.tradicional\(\.(`?\w+`?)\),$', sust, texto, flags=re.M)
    ruta.write_text(nuevo, encoding="utf-8"); print(lang, hechos, "transcritos")
print("claves sin miembro:", [k for k in T if k not in MIEMBRO])
