---
name: commit
description: Commitear el trabajo actual — verifica el estado, crea una rama si estás en main, stagea archivos específicos (nunca -A) y escribe un commit cuyo asunto dice qué queda cierto después. Hace push y abre un pull request solo con --pr o cuando el usuario lo pide; nunca mergea — un merge ocurre solo cuando el usuario dice explícitamente que mergee. Usar SOLO con intención explícita de commit: "commit", "commitea esto", "abre un PR", o `/commit`. NO invocar ante frases vagas de cierre ("listo", "terminamos"): esas piden confirmación primero. Nunca force-push ni --no-verify.
argument-hint: "[mensaje opcional] [--pr]"
allowed-tools: ["Bash", "Read", "Glob", "Agent"]
---

# Commit

**Un commit no es un pull request, y un pull request no es un merge.** Esta skill termina en
el commit. Hace push y abre un PR solo con `--pr` o cuando el usuario lo pide, y **nunca
mergea**: el merge ocurre solo cuando el usuario pide mergear ese PR (ver "Merge").

## Pasos

### Paso 0: Verificación previa

Antes de tocar git, para los archivos cambiados:

- **Scripts de R:** `Rscript -e 'invisible(parse("<archivo>"))'` por cada `.R` cambiado.
  Un error de sintaxis no se commitea.
- **Si el proyecto tiene un agente `verifier`:** lanzarlo (`Agent` con
  `subagent_type=verifier`) sobre los scripts cambiados y reportar pass/fail antes de
  seguir. Si no existe, decirlo y continuar.
- **Datos y secretos:** confirmar que nada de la carpeta de datos restringidos, ningún
  `settings.local.json` ni credenciales están en el diff.

Si algo falla, detenerse y reportar. El usuario puede anular con "commitea igual"; la razón
queda en el mensaje del commit.

### Paso 1: Estado actual

```bash
git status --porcelain     # COMPLETO, con la columna del índice: puede haber cosas staged por otra sesión
git diff --stat
git log --oneline -5
```

Si hay entradas staged que no son de este trabajo, preguntar antes de seguir: un commit
arrastra TODO lo staged.

### Paso 2: Rama (si estás en `main`)

Nunca commitear directo a `main`. Si la rama actual es `main`, crear una; si ya estás en
una rama de trabajo, commitear ahí.

```bash
git checkout -b <nombre-corto-descriptivo>
```

### Paso 3: Stagear archivos específicos

```bash
git add <archivo1> <archivo2> ...
```

Nunca `git add -A`, `git add .` ni `git add <carpeta>` a ciegas: así se cuelan datos crudos
y archivos ajenos. No stagear `.claude/settings.local.json` ni archivos con secretos.

### Paso 4: Commit con mensaje descriptivo

Si `$ARGUMENTS` trae un mensaje, usarlo tal cual. Si no, analizar el diff staged y escribir
un mensaje que explique el *por qué*, no solo el *qué*.

**El asunto dice qué es CIERTO DESPUÉS del commit**: una frase sobre comportamiento que un
lector podría ir a comprobar. *"Arreglar comentarios del review"* narra la tarde y no dice
nada; *"La clave del caché cubre los datos y el estimador"* es una afirmación verificable
contra el código. El proceso —de qué ronda vino, quién lo pidió, cuántos intentos— va al
cuerpo si va a algún lado. El cuerpo lleva el *por qué*.

```bash
git commit -m "$(cat <<'EOF'
<mensaje>
EOF
)"
```

### Paso 5: Push y pull request — solo con `--pr` o si el usuario lo pide

Sin `--pr` y sin que el usuario pida un PR, este paso se omite: el commit queda local y el
reporte lo dice.

```bash
git push -u origin <rama>
gh pr create --title "<título corto>" --body "$(cat <<'EOF'
## Resumen
<1-3 viñetas>

## Qué cambia para quien use el proyecto
<"Nada", o cada default que se nota: una ruta que se movió, un hook que ahora dispara, un umbral>

## Cómo probar
<lista>
EOF
)"
```

### Paso 6: Reporte

Reportar hash y asunto del commit, la rama, y la URL del PR si se abrió. Decir claramente
que **nada se mergeó**.

## Merge — solo cuando el usuario lo dice

El merge nunca es un paso de esta skill. Mergear solo cuando el usuario pide mergear un PR
concreto ("mergea #12"); "listo", "terminamos" o "commit" no son una orden de merge. Antes
de mergear, comprobar que el CI del PR está en verde y que sus reviews se leyeron.

```bash
gh pr merge <numero> --merge --delete-branch
git checkout main
git status --porcelain     # debe estar vacío antes del pull
git pull
```

El hook `git-guardrails` **deniega** `git pull` (y `merge`, `rebase`) con el árbol sucio,
porque un pull que resuelve encima de trabajo sin commitear no se puede revisar después.
Si el árbol está sucio, limpiarlo a propósito y en comandos separados:

```bash
git stash push -u -m "post-merge: sobrantes"   # -u, o los archivos sin seguimiento se quedan
git pull
git stash pop
```

`ALLOW_DIRTY_MERGE=1` es la salida para un estado sucio que ya miraste y puedes justificar
en voz alta; no es el remedio de rutina.

## Importante

- Nunca commitear directo a `main`.
- Nunca push, PR ni merge sin que se pida (Paso 5 y "Merge").
- Nunca `--force`, nunca `--no-verify`.
- Al mergear a petición del usuario, `--merge` (no `--squash` ni `--rebase`) salvo que diga
  otra cosa.
- Si `$ARGUMENTS` trae el mensaje, usarlo exactamente.

## Banderas

| Bandera | Efecto |
|---|---|
| `--pr` | Tras el commit, push de la rama y apertura de un PR (Paso 5). Nunca mergea. |
