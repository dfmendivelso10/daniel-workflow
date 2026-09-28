---
paths:
  - "data/**"
  - "**/raw/**"
  - "**/*.dta"
  - "**/*.sav"
  - "**/restricted/**"
  - "**/confidential/**"
---

# Datos confidenciales y restringidos

**Hay datos que no pueden salir de la máquina para la que fueron aprobados, y hay resultados
que no pueden salir sin revisión de divulgación.** Encuestas a menores de edad, registros
administrativos, historias clínicas, paneles de firmas, cualquier dato bajo acuerdo de uso o
aval ético. Esta regla es el contrato permanente para manejarlos; se carga solo al tocar
directorios y formatos de datos.

Es una **plantilla**: cada proyecto fija en su `CLAUDE.md` qué carpetas cubre, dónde viven
los datos y qué umbrales de divulgación aplican.

---

## Las tres reglas duras

1. **Dónde viven los datos lo decide el proyecto, y esa decisión se escribe.** Dos opciones
   válidas: (a) los datos crudos **no** entran a git (`.gitignore` sobre la carpeta de datos)
   y se guardan aparte con respaldo propio; (b) entran a un repositorio **privado, con un
   solo colaborador o con colaboradores que tengan el mismo acuerdo**, y **nunca** a un
   repositorio público ni a un paquete de replicación. Si un día el repositorio debe abrirse,
   antes se reescribe el historial para sacarlos. La opción elegida y su fecha van en
   `CLAUDE.md`.
2. **Nada sale sin revisión de divulgación.** Toda tabla, figura, coeficiente o conteo
   construido con datos restringidos pasa por una revisión de celdas pequeñas y
   reidentificación *antes* de aparecer en un borrador, una diapositiva, un commit compartido
   o un correo. Umbral por defecto: suprimir celdas con n < 10, y suprimir complementos para
   que los totales no los revelen.
3. **El acceso es por persona y por acuerdo.** Un coautor sin el acuerdo no recibe los datos,
   los identificadores ni salidas que fallen la revisión de divulgación. Un traspaso lleva
   *instrucciones para solicitar acceso*, nunca los datos.

## Mantener los datos fuera del modelo

Todo lo que Claude lee viaja al proveedor del modelo, así que "no sale de la máquina"
incluye el contexto del modelo. **Claude escribe código que corre sobre los datos; no lee
los datos.**

- **Deny rules en `settings.json`.** Valen en todos los modos de permiso, incluido bypass,
  cosa que ningún hook garantiza. Plantilla (ajustar las rutas a las del proyecto):

  ```json
  { "permissions": { "deny": [
      "Read(data/**)", "Edit(data/**)", "Write(data/**)"
  ] } }
  ```

  Cubren las herramientas de archivo de Claude y los comandos de archivo que Claude Code
  reconoce en Bash (`cat`, `head`, `tail`, `sed`, `tee`) y redirecciones; **no** cubren un
  script que abre archivos por su cuenta. Son un guardarraíl, no una prueba: van junto con
  la disciplina de abajo.
- **Solo agregados en la salida de los scripts.** Al diagnosticar o verificar, los scripts
  imprimen conteos, medias, rangos, distribuciones o IDs anonimizados; **nunca una fila
  individual con sus respuestas**. Si un caso concreto hay que mirarlo (un valor imposible,
  un ID duplicado), se imprime el ID y la variable en cuestión, no el registro completo.
- **Herramientas externas de captura graban la sesión.** Complementos de memoria u
  observabilidad (ai-memory, claude-mem, trazas alojadas) guardan prompts y a veces la
  salida de las herramientas. En un proyecto con datos restringidos: ninguno, o uno con
  lista blanca explícita que excluya estas rutas.
- **Claude Code guarda su propio registro.** Transcripciones con la salida de las
  herramientas palabra por palabra en `~/.claude/projects/<proyecto>/` y copias previas de
  archivos editados en `~/.claude/file-history/`, hasta la limpieza automática
  (`cleanupPeriodDays`, 30 días por defecto; las sesiones de Claude Desktop no se limpian
  salvo que se fije `desktopSessionCleanupPeriodDays`). Dos almacenes no se limpian nunca:
  los prompts en `~/.claude/history.jsonl` (los pegados grandes también en
  `~/.claude/paste-cache/`) y la memoria automática en
  `~/.claude/projects/<proyecto>/memory/`. Si contenido restringido entró a una sesión: no
  hacer `--resume` ni `/checkpoint` de ella; correr `claude project purge <ruta>`
  (previsualizar con `--dry-run`), que borra transcripciones, historial de archivos,
  memoria automática y sus líneas en `history.jsonl`; luego vaciar `paste-cache/` y el
  scratchpad de la sesión, que no toca. Los términos de destrucción del acuerdo de datos
  cubren todas estas copias.
- **Consultas a modelos externos suben lo que se adjunta.** El propio paper y el propio
  código se pueden enviar; microdatos restringidos, salidas sin revisión de divulgación, y
  manuscritos ajenos que se están evaluando para una revista, no.

## Sujetos humanos

Si los datos son de personas: el número de protocolo del comité de ética, el uso aprobado y
las restricciones de consentimiento se registran en la documentación interna del proyecto
(no en el README público) y no se analiza más allá del alcance aprobado.

## Topología de git con datos restringidos

- Ramas por autor, integradas por PR; nadie hace force-push de historia compartida. El hook
  `git-guardrails.py` bloquea `--force` y `git add -A`, que es la vía habitual por la que
  un dato crudo se cuela en un commit.
- `MEMORY.md` se sincroniza por git; la memoria automática de Claude
  (`~/.claude/projects/<proyecto>/memory/`) es local a la máquina. Las rutas de datos
  específicas de una máquina van en la memoria local, nunca en archivos versionados.
- Con `CLAUDE_STRICT_PATHS=1`, `git-guardrails` **deniega** (no solo avisa) rutas absolutas
  de máquina dentro del código.

## Referencias cruzadas

- [`git-guardrails.py`](../hooks/git-guardrails.py) — `add -A`, `--force`, rutas fijas.
- `CLAUDE.md` del proyecto — dónde viven los datos, qué carpetas cubre esta regla, umbrales.
