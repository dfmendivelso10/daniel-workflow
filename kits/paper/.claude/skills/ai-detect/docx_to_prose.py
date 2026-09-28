#!/usr/bin/env python3
"""Extrae la prosa de un .docx para pasarla al detector econ-ai-detect.

Se queda con los parrafos del cuerpo y descarta lo que el detector no debe
ver: tablas, notas de tabla, referencias, encabezados numerados de seccion,
y el texto eliminado por control de cambios (conserva las inserciones).

Uso:
    docx_to_prose.py manuscrito.docx > prosa.txt
    docx_to_prose.py manuscrito.docx --seccion "3. Methods" "4. Results"
"""
import re
import sys
import zipfile
from xml.etree import ElementTree as ET

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def parrafos(path):
    with zipfile.ZipFile(path) as z:
        root = ET.fromstring(z.read("word/document.xml"))
    body = root.find(W + "body")
    out = []
    for p in body.iter(W + "p"):
        # saltar parrafos dentro de tablas
        anc = p
        en_tabla = False
        for tbl in body.iter(W + "tbl"):
            if p in tbl.iter(W + "p"):
                en_tabla = True
                break
        if en_tabla:
            continue
        partes = []
        for child in p:
            if child.tag == W + "del":
                continue
            partes.append("".join(n.text or "" for n in child.iter(W + "t")))
        t = "".join(partes).strip()
        if t:
            out.append(t)
    return out


def es_ruido(t):
    if re.match(r"^\d+(\.\d+)*\.?\s+[A-Z]", t) and len(t) < 90:    # encabezado numerado
        return True
    if re.match(r"^(Table|Figure|Appendix|Annex|Note|Notes)\b", t):  # tablas y notas
        return True
    if re.match(r"^[A-Z][A-Za-z\-]+, [A-Z]\.", t) and re.search(r"\(\d{4}\)", t):  # referencia
        return True
    if re.match(r"^[•\-•]", t):                               # vinetas
        return True
    return False


def main():
    args = sys.argv[1:]
    if not args:
        sys.exit(__doc__)
    path = args[0]
    secciones = None
    if "--seccion" in args:
        i = args.index("--seccion")
        secciones = args[i + 1:]
    ps = parrafos(path)
    # descartar frente del documento (titulo, autores, filiaciones, abstract,
    # keywords): empezar en la primera seccion numerada
    for i, t in enumerate(ps):
        if re.match(r"^1\.(\d+)?\s+[A-Z]", t):
            ps = ps[i:]
            break
    if secciones:
        keep, on = [], False
        for t in ps:
            if re.match(r"^\d+(\.\d+)*\s+[A-Z]", t):
                on = any(t.startswith(s) for s in secciones)
            if on:
                keep.append(t)
        ps = keep
    # cortar en la bibliografia
    for i, t in enumerate(ps):
        if re.match(r"^(\d+\.\s*)?(References|Bibliograph)", t, re.I):
            ps = ps[:i]
            break
    prosa = [t for t in ps if not es_ruido(t)]
    sys.stdout.write("\n\n".join(prosa) + "\n")
    sys.stderr.write(f"{len(prosa)} parrafos de prosa, {sum(len(t.split()) for t in prosa)} palabras\n")


if __name__ == "__main__":
    main()
