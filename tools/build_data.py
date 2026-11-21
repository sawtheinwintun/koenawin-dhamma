"""Build app data JSON from KoeNaWin.xlsx, applying the corrections agreed with the user."""
import json
import posixpath
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

SRC, OUT = sys.argv[1], sys.argv[2]

M = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
A = "http://schemas.openxmlformats.org/drawingml/2006/main"
XDR = "http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing"

z = zipfile.ZipFile(SRC)
shared = ["".join(t.text or "" for t in si.iter(f"{{{M}}}t"))
          for si in ET.fromstring(z.read("xl/sharedStrings.xml")).findall(f"{{{M}}}si")]
wb = ET.fromstring(z.read("xl/workbook.xml"))
relmap = {r.get("Id"): r.get("Target") for r in ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))}


def rels_of(part):
    d, f = posixpath.split(part)
    return {r.get("Id"): posixpath.normpath(posixpath.join(d, r.get("Target")))
            for r in ET.fromstring(z.read(f"{d}/_rels/{f}.rels"))}


sheets = []
for sh in wb.find(f"{{{M}}}sheets"):
    part = "xl/" + relmap[sh.get(f"{{{R}}}id")].lstrip("/").removeprefix("xl/")
    sheets.append((sh.get("name"), part, ET.fromstring(z.read(part))))


def cells(root):
    out = {}
    for c in root.iter(f"{{{M}}}c"):
        v = c.find(f"{{{M}}}v")
        if v is None:
            continue
        out[c.get("r")] = shared[int(v.text)] if c.get("t") == "s" else v.text
    return out


def textbox(part, root):
    paras = []
    for d in root.iter(f"{{{M}}}drawing"):
        droot = ET.fromstring(z.read(rels_of(part)[d.get(f"{{{R}}}id")]))
        for body in droot.iter(f"{{{XDR}}}txBody"):
            paras += ["".join(t.text or "" for t in p.iter(f"{{{A}}}t")) for p in body.findall(f"{{{A}}}p")]
    return paras


# ---- Corrections -----------------------------------------------------------
# Zero-width characters hidden inside words.
INVISIBLE = re.compile("[​‌‍﻿]")

FIXES = [
    # Spelling agreed with the user
    ("သတ္ထာဒေဝမနုဿနံ", "သတ္ထာဒေဝမနုဿာနံ"),
    ("ပုရိသဒမ္မသာရထိ", "ပုရိသဓမ္မသာရထိ"),          # user: ဓမ္မသာရထိ everywhere
    ("ဆိတ်ကွယ်ရာအရပ်၌ပင် မကောင်းမှုကို ပြုတော်မူသော", "ဆိတ်ကွယ်ရာအရပ်၌ပင် မကောင်းမှုကို မပြုတော်မူသော"),
    ("လောကသုံးပါကို သိတော်မူကော", "လောကသုံးပါးကို သိတော်မူသော"),
    # ပထဝီဇယမန္တာန် (၁) and (၁၁): asat instead of stacked consonants, misplaced ေ
    ("ပထဝီဇယံသဗ်ဗံ၊ အနကေ အန်တရာယိကံ၊ ဇယံ ပစ်စကေဗုဒ်ဓါ စ၊ ဇယံ ပရိ မဟသေယော။",
     "ပထဝီ ဇယံ သဗ္ဗံ၊ အနေက အန္တရာယိကံ၊ ဇယံ ပစ္စေကဗုဒ္ဓါ စ၊ ဇယံ ပရိ မဟေသယော။"),
    ("နရေယိကာ တိရစ်ဆာနာ၊ ပတော အသုရကာ ယမာ၊ ဣမေ သဗ်ဗေ ယထာ သတ်တာ၊ ဒုက်ခာ မုစ်စန်တု တတ်တကာ။",
     "နေရယိကာ တိရစ္ဆာနာ၊ ပေတာ အသုရကာ ယမာ၊ ဣမေ သဗ္ဗေ ယထာ သတ္တာ၊ ဒုက္ခာ မုစ္စန္တု တတ္တကာ။"),
    # Inconsistent spellings within the same text
    ("ဗုဒ္ဓါနုဘာဝေန ဝိနသ မေန္တု", "ဗုဒ္ဓါနုဘာဝေန ဝိနာသ မေန္တု"),
    ("သုနက္ခတ္ကံ", "သုနက္ခတ္တံ"),
    ("ဘဂဝန္တံ သိရသာ နာမာမိ", "ဘဂဝန္တံ သိရသာ နမာမိ"),
    ("ဟောကြားတော့်မူသော", "ဟောကြားတော်မူသော"),
    ("ဧဝံ မေဟောတု", "ဧဝံ မေ ဟောတု"),
    ("အဌာ နမေတံဂါထာတော်", "အဋ္ဌာနမေတံဂါထာတော်"),
    ("အဌာနမေတံ ဘိက္ခဝေ", "အဋ္ဌာနမေတံ ဘိက္ခဝေ"),
    ("တယာဇ္ဇ ဂုတ္တာ ဝိဟရေမု ဒိဝသံ၊", "တယာဇ္ဇ ဂုတ္တာ ဝိဟရေမု ဒိဝသံ။"),
    ("နမတ္တု ဗုဒ္ဓါနံ", "နမတ္ထု ဗုဒ္ဓါနံ"),
    ("ယေ ဗြဟ္မဏာ ဝေဒဂူ", "ယေ ဗြာဟ္မဏာ ဝေဒဂူ"),
    ("သစ္စဝဇ္ဖေန", "သစ္စဝဇ္ဇေန"),
    ("သောတ္ထိမေ(တေ)ဟောတု", "သောတ္ထိ မေ (တေ) ဟောတု"),
    ("ဝတသော ဘဂဝါ", "ဝတ သော ဘဂဝါ"),
    ("အရဟံဝတ သော", "အရဟံ ဝတ သော"),
    ("သဟ သဗ္ဗေဟိ ဉာတိဘိ\n", "သဟ သဗ္ဗေဟိ ဉာတိဘိ။\n"),
]

used = set()


def fix_tracked(s):
    s = INVISIBLE.sub("", s)
    for a, b in FIXES:
        if a in s:
            used.add(a)
            s = s.replace(a, b)
    return s


# ---- Buddha attributes -----------------------------------------------------
ATTRS = ["အရဟံ", "သမ္မာသမ္ဗုဒ္ဓေါ", "ဝိဇ္ဇာစရဏသမ္ပန္နော", "သုဂတော", "လောကဝိဒူ",
         "အနုတ္တရောပုရိသဓမ္မသာရထိ", "သတ္ထာဒေဝမနုဿာနံ", "ဗုဒ္ဓေါ", "ဘဂဝါ"]
attr_id = {name: i + 1 for i, name in enumerate(ATTRS)}


def to_attr(raw):
    key = fix_tracked(raw).replace(" ", "")
    return attr_id[key]


MM_DIGITS = str.maketrans("၀၁၂၃၄၅၆၇၈၉", "0123456789")
WEEKDAYS = {"တနင်္လာ": "monday", "အင်္ဂါ": "tuesday", "ဗုဒ္ဓဟူး": "wednesday", "ကြာသပတေး": "thursday",
            "သောကြာ": "friday", "စနေ": "saturday", "တနင်္ဂနွေ": "sunday"}

_, part1, root1 = sheets[0]
c1 = cells(root1)
stages, day_no = [], 0
for s in range(9):
    r = 1 + s * 3
    days = []
    for col in "BCDEFGHIJ":
        day_no += 1
        aid = to_attr(c1[f"{col}{r + 1}"])
        rounds = int(re.search(r"\d+", c1[f"{col}{r + 2}"].translate(MM_DIGITS)).group())
        assert rounds == aid, (col, r, aid, rounds)
        days.append({"day": day_no, "dayInStage": len(days) + 1,
                     "weekday": WEEKDAYS[c1[f"{col}{r}"]], "attributeId": aid,
                     "rounds": rounds, "vegetarian": col == "F"})
    stages.append({"stage": s + 1, "name": c1[f"A{r}"], "days": days})

schedule = {
    "totalDays": 81,
    "startWeekday": "monday",
    "note": "အဆင့်တိုင်းရဲ့ ၅ ရက်မြောက်နေ့ (vegetarian: true) သည် သက်သတ်လွတ် စားရမည့်နေ့ ဖြစ်သည်။",
    "stages": stages,
}

# ---- Attribute meanings ----------------------------------------------------
c2 = cells(sheets[1][2])
attributes = []
for row in range(2, 11):
    aid = to_attr(c2[f"B{row}"])
    attributes.append({"id": aid, "name": ATTRS[aid - 1], "rounds": aid,
                       # Cell-width line breaks become spaces; breaks after ။ stay.
                       "meaning": re.sub(r"(?<!။)\s*\n\s*", " ", fix_tracked(c2[f"C{row}"])).replace("\n ", "\n").strip()})
for a in attributes:
    if not a["meaning"].endswith(("။", ")")):
        a["meaning"] += "။"
attributes.sort(key=lambda a: a["id"])

# ---- Gathas ----------------------------------------------------------------
NUM = re.compile(r"^\(?([၀-၉]+)\)?\s*။?\s*")
# "...။၂။ ..." or a numbered line inside a block -> separate verses
RUN_ON = re.compile(r"(?<=။)(?=[၀-၉]+။)|\n(?=\([၀-၉]+\))")
HALF = re.compile(r"။ *(?=\S)")                  # one half-verse per line in Pali gathas
PROSE = {7}                                       # the ကန်တော့ text is prose: keep its sentences together
# Sheets whose first paragraph is a section heading, not the gatha's title
TITLES = {13: "နေထိုင်-ပညာ-စီးပွား", 14: "နေနတ်သား-လနတ်သား"}  # as named in Figma


def tidy(s):
    s = re.sub(" {2,}", " ", s)
    return re.sub("၊(?=[^\\s)])", "၊ ", s)          # a space after every ၊


def is_heading(line):
    return "။" not in line and "၊" not in line and len(line) < 30


gathas = []
for idx, (name, part, root) in enumerate(sheets[2:], start=1):
    paras = [tidy(fix_tracked(p + "\n")).rstrip() for p in textbox(part, root)]
    if idx in TITLES:
        title, body = TITLES[idx], paras
    else:
        title, body = paras[0].strip(), paras[1:]
    blocks, cur = [], []
    for p in body:
        if p.strip():
            cur.append(p.strip().lstrip("\t"))
        elif cur:
            blocks.append(cur)
            cur = []
    if cur:
        blocks.append(cur)

    items = []
    for block in blocks:
        if is_heading(block[0]):
            items.append({"type": "heading", "text": block[0]})
            block = block[1:]
            if not block:
                continue
        text = "\n".join(block)
        for piece in RUN_ON.split(text):
            piece = piece.strip()
            if not piece:
                continue
            m = NUM.match(piece)
            item = {"type": "verse"}
            if m and m.group(1):
                item["number"] = int(m.group(1).translate(MM_DIGITS))
                piece = piece[m.end():]
            if idx not in PROSE:
                piece = HALF.sub("။\n", piece).removeprefix("- ")
            item["text"] = piece.strip()
            items.append(item)
    gathas.append({"id": idx, "title": title, "items": items})

unused = [a for a, _ in FIXES if a not in used]
if unused:
    print("UNUSED FIXES:", unused, file=sys.stderr)

for fname, data in [("koenawin_schedule.json", schedule), ("attributes.json", attributes), ("gathas.json", gathas)]:
    with open(posixpath.join(OUT, fname), "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")
print("ok", len(stages), "stages,", len(attributes), "attributes,", len(gathas), "gathas")
