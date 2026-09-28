#!/usr/bin/env python3
"""Muestra el texto de las ventanas que superan algun umbral del detector.

Uso (python3 del sistema; no necesita el venv):
    python3 .claude/skills/ai-detect/windows_report.py prosa.txt scores.json

`scores.json` es la salida de `econ-ai-detect prosa.txt --no-gate --json`.
El detector no guarda el texto de cada ventana; aqui se reconstruye con una
copia literal de `econ_ai_detector.preprocess.windows` (v3), asi que los
indices coinciden. Si el paquete cambia su particionado, actualizar esto.
"""
import json
import re
import sys
import unicodedata

WINDOW, MIN_TAIL = 250, 120
TRANS = str.maketrans({"‘": "'", "’": "'", "“": '"', "”": '"',
                       "–": "-", "—": "-", "−": "-", "ﬁ": "fi", "ﬂ": "fl"})


def normalize(text):
    text = unicodedata.normalize("NFKC", text).translate(TRANS)
    text = re.sub(r"\d+(?:[.,]\d+)*", "0", text)
    return re.sub(r"\s+", " ", text).strip()


def windows(text):
    w = normalize(text).split()
    out = [" ".join(w[i:i + WINDOW]) for i in range(0, len(w), WINDOW)]
    if len(out) > 1 and len(out[-1].split()) < MIN_TAIL:
        out.pop()
    return out


def main(prosa, scores):
    W = windows(open(prosa, encoding="utf-8").read())
    r = json.load(open(scores))
    S, thr = r["windows"], r["thresholds"]
    assert len(W) == len(S), f"{len(W)} ventanas reconstruidas vs {len(S)} en el JSON: corre el detector con --no-gate"
    lo, hi = thr["lr_k2_min"], thr["nn_margin_k2_min"]
    print(f"{'FLAG' if r['flagged'] else 'sin flag'} | {len(W)} ventanas | umbrales LR>={lo:.3f} NN>={hi:.2f}\n")
    for i, (w, s) in enumerate(zip(W, S)):
        a, b = s["lr_prob"], s["nn_margin"]
        if a < lo and b < hi:
            continue
        tag = "AMBOS" if a >= lo and b >= hi else "uno"
        print(f"=== w{i:02d}  LR={a:.3f}  NN={b:.2f}  [{tag}] ===")
        print("  " + w[:300]); print("  ..."); print("  " + w[-220:] + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
