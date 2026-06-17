#!/usr/bin/env bash
#
# calificar_blackhatbash.sh  —  Auto-evaluador de la rama "blackhatbash"
# ============================================================================
# Califica de 0 a 100 los scripts de la rama tomando en cuenta:
#   1. Calidad de los comentarios          (25 pts)  *solo archivos comentados*
#   2. Comentarios en INGLES (gran margen)  (20 pts)
#   3. Commits hechos en HORA DE CLASE      (15 pts)
#   4. Calidad de codigo (sintaxis + lint)  (20 pts)
#   5. Buenas practicas (shebang, exec...)  (10 pts)
#   6. Calidad de mensajes de commit        (10 pts)
#                                          ------------
#                                    TOTAL: 100 pts
#
# Notas de criterio:
#   - El punto 1 promedia SOLO los archivos que llevan comentarios; los que no
#     tienen comentarios no suman ni restan (no se evaluan).
#   - El punto 2 da el puntaje completo solo si el ingles es mayoritario por un
#     gran margen (>= UMBRAL_INGLES); por debajo cae de forma acelerada.
#
# Uso:
#   ./calificar_blackhatbash.sh [rama] [patron]
#   ./calificar_blackhatbash.sh blackhatbash "blackhatbash*.sh"
#
# Requisitos: git, bash 4+, awk. Opcional: shellcheck (para el punto 4).
# ----------------------------------------------------------------------------
set -uo pipefail

# ============================= CONFIGURACION ================================
RAMA="${1:-blackhatbash}"
PATRON="${2:-blackhatbash*.sh}"

# --- Horario de clase de UNIX (hora de Ecuador) ---
# Dias: 1=lun 2=mar 3=mie 4=jue 5=vie 6=sab 7=dom.  EDITA con tus dias reales.
CLASE_DIAS=(1 2 3 4 5)    # por defecto lun-vie; deja SOLO tus dias de clase
CLASE_HORA_INI=7          # 07:00 (incluida)
CLASE_HORA_FIN=9          # 09:00 (NO incluida)  -> clase de 7 a 9 AM

# ¿Un commit hecho en hora de clase SUMA puntos?
#   true  -> trabajaste en el laboratorio durante la sesion (lo premia)
#   false -> "deberias estar prestando atencion" (lo penaliza)
CLASE_SUMA=true

# Diferencia horaria de Ecuador respecto a UTC (UTC-5, sin horario de verano).
# Codespaces corre en UTC y a veces NO trae tzdata, asi que en lugar de un nombre
# de zona usamos aritmetica directa de epoch: hora_local = hora_UTC + UTC_OFFSET.
# Esto funciona siempre, tenga o no tzdata el contenedor.
UTC_OFFSET=-5

# Rango ideal de densidad de comentarios (lineas de comentario / lineas de codigo)
DENS_MIN=0.10
DENS_MAX=0.45

# Inglés: a partir de que proporcion se considera "mayoritario por gran margen".
# 0.80 = el ingles debe ser >= 80% del idioma de la rama para el puntaje completo.
UMBRAL_INGLES=0.80
# ============================================================================

# ------------------------------ Colores -------------------------------------
if [[ -t 1 ]]; then
  C_RESET=$'\e[0m'; C_BOLD=$'\e[1m'; C_DIM=$'\e[2m'
  C_RED=$'\e[31m'; C_GRN=$'\e[32m'; C_YLW=$'\e[33m'; C_BLU=$'\e[34m'; C_CYN=$'\e[36m'
else
  C_RESET=""; C_BOLD=""; C_DIM=""; C_RED=""; C_GRN=""; C_YLW=""; C_BLU=""; C_CYN=""
fi

# ------------------------------ Utilidades ----------------------------------
calc()      { awk "BEGIN{printf \"%.4f\", ($1)}"; }
redondear() { awk "BEGIN{printf \"%.0f\", ($1)}"; }
# imprime una barra de progreso [####----] segun valor/maximo
barra() {
  local v="$1" max="$2" ancho=24
  local llenos; llenos=$(redondear "$v/$max*$ancho")
  (( llenos < 0 )) && llenos=0; (( llenos > ancho )) && llenos=$ancho
  local b="" i
  for ((i=0; i<ancho; i++)); do (( i < llenos )) && b+="#" || b+="."; done
  printf "%s" "$b"
}

# ------------------------- Verificaciones previas ---------------------------
command -v git >/dev/null 2>&1 || { echo "ERROR: git no esta instalado." >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "ERROR: ejecuta esto dentro de tu repositorio git." >&2; exit 1; }

git rev-parse --verify "$RAMA" >/dev/null 2>&1 || {
  echo "${C_YLW}AVISO:${C_RESET} la rama '$RAMA' no existe; usare la rama actual." >&2
  RAMA="$(git rev-parse --abbrev-ref HEAD)"
}

RAMA_ACTUAL="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$RAMA_ACTUAL" != "$RAMA" ]]; then
  echo "${C_YLW}AVISO:${C_RESET} estas en '$RAMA_ACTUAL' pero analizare los archivos del arbol de trabajo." >&2
  echo "       Para precision total: ${C_BOLD}git checkout $RAMA${C_RESET}" >&2
fi

# Lista de archivos a calificar (arbol de trabajo)
mapfile -t FILES < <(find . -path ./.git -prune -o -type f -name "$PATRON" -print | sort)
N=${#FILES[@]}
if (( N == 0 )); then
  echo "ERROR: no encontre archivos que coincidan con '$PATRON'." >&2; exit 1
fi

# ============================================================================
# 1) CALIDAD DE COMENTARIOS  (25 pts)
# ============================================================================
suma_comentarios=0
archivos_con_coment=0
detalle_coment=""
for f in "${FILES[@]}"; do
  read -r codigo coment signif palabras <<<"$(awk '
    NR==1 && /^#!/ {next}
    { l=$0; sub(/^[[:space:]]+/,"",l)
      if (l ~ /^#/) { c=l; sub(/^#+[[:space:]]*/,"",c)
        coment++
        if (c != "") { n=split(c,w,/[[:space:]]+/); pal+=n; if (n>=3) sig++ }
      } else if (l != "") { cod++ }
    }
    END { printf "%d %d %d %d", cod+0, coment+0, sig+0, pal+0 }' "$f")"

  # Si el archivo NO lleva comentarios, no se evalua este criterio (no penaliza).
  if (( coment == 0 )); then
    detalle_coment+=$(printf "    %-22s sin comentarios -> no se evalua\n" "$(basename "$f")")$'\n'
    continue
  fi
  archivos_con_coment=$((archivos_con_coment+1))

  # --- densidad (0-15) ---
  if (( codigo == 0 )); then
    dens_score=0; dens="0"
  else
    dens=$(calc "$coment/$codigo")
    dens_score=$(awk -v d="$dens" -v mn="$DENS_MIN" -v mx="$DENS_MAX" 'BEGIN{
      if (d < mn)       s = 15 * (d/mn)
      else if (d <= mx) s = 15
      else { f = mx/d; if (f<0.4) f=0.4; s = 15*f }     # sobre-comentado: penaliza leve
      printf "%.2f", s }')
  fi
  # --- comentarios significativos (0-10) ---
  sig_score=$(calc "10*$signif/$coment")

  file_score=$(calc "$dens_score+$sig_score")
  suma_comentarios=$(calc "$suma_comentarios+$file_score")
  detalle_coment+=$(printf "    %-22s dens=%-5s coment=%-3s signif=%-3s  -> %5.1f/25\n" \
                    "$(basename "$f")" "$dens" "$coment" "$signif" "$file_score")$'\n'
done
# Promedio SOLO entre los archivos que llevan comentarios.
if (( archivos_con_coment > 0 )); then
  S1=$(calc "$suma_comentarios/$archivos_con_coment"); MAX1=25
else
  S1=0; MAX1=0      # ningun archivo lleva comentarios -> el criterio no aplica
fi

# ============================================================================
# 2) IDIOMA: COMENTARIOS EN INGLES  (20 pts)
# ============================================================================
texto_coment=""
for f in "${FILES[@]}"; do
  texto_coment+="$(awk 'NR==1 && /^#!/ {next}
    { l=$0; sub(/^[[:space:]]+/,"",l)
      if (l ~ /^#/){ sub(/^#+[[:space:]]*/,"",l); print tolower(l) } }' "$f")"$'\n'
done

read -r en es ratio <<<"$(printf '%s' "$texto_coment" | awk '
  BEGIN{
    split("the this that for with and from each loop file code function variable value print check exit return name path line list count input output error these those when then else done while read user when number string array does run script comment example",EN," ")
    split("el la los las un una unos unas de del que para con por como esto esta este estos archivo codigo funcion variable valor imprimir verificar salida retorna nombre ruta linea lista contar entrada error cuando entonces sino mientras leer usuario numero cadena arreglo ejecuta script comentario ejemplo y o si no",ES," ")
    for(i in EN) en_w[EN[i]]=1
    for(i in ES) es_w[ES[i]]=1
  }
  {
    # señal fuerte de español: acentos / ñ / signos
    if ($0 ~ /[áéíóúñ¿¡]/) es += 2
    n=split($0,w,/[^a-záéíóúñ]+/)
    for(i=1;i<=n;i++){ if(w[i]=="")continue; if(en_w[w[i]])en++; if(es_w[w[i]])es++ }
  }
  END{
    tot=en+es
    r = (tot>0) ? en/tot : -1     # -1 = sin señal
    printf "%d %d %.4f", en, es, r
  }')"

if [[ "$ratio" == "-1.0000" || "$ratio" == "-1" ]]; then
  S2=$(calc "20*0.5"); idioma_nota="ambiguo (sin palabras clave detectables)"
else
  # El ingles debe ser mayoritario por GRAN MARGEN:
  #   ratio >= UMBRAL_INGLES        -> 20/20 (puntaje completo)
  #   por debajo del umbral         -> cae de forma acelerada (cuadratica),
  #                                    castigando fuerte la "mayoria debil" y el español
  S2=$(awk -v r="$ratio" -v u="$UMBRAL_INGLES" 'BEGIN{
    if (r >= u) s = 20; else { f = r/u; s = 20 * f * f }
    printf "%.2f", s }')
  pct=$(redondear "$ratio*100")
  gran_margen=$(awk -v r="$ratio" -v u="$UMBRAL_INGLES" 'BEGIN{print (r>=u)?1:0}')
  mayoria=$(awk -v r="$ratio" 'BEGIN{print (r>=0.5)?1:0}')
  if   (( gran_margen )); then marca="ingles mayoritario por gran margen [OK]"
  elif (( mayoria ));     then marca="mayoria debil (aun no por gran margen)"
  else                         marca="el espanol domina [X]"; fi
  idioma_nota="~${pct}% ingles -> $marca  (EN=$en / ES=$es)"
fi

# ============================================================================
# 3) COMMITS EN HORA DE CLASE  (15 pts)
# ============================================================================
# Tomamos el timestamp UNIX (UTC) de cada commit con %ct y calculamos dia/hora
# en hora local con aritmetica pura (offset). NO dependemos de tzdata.
read -r total_commits en_clase <<<"$(
  git log "$RAMA" --no-merges --pretty='%ct' 2>/dev/null | awk \
    -v off="$UTC_OFFSET" -v ini="$CLASE_HORA_INI" -v fin="$CLASE_HORA_FIN" \
    -v dias="${CLASE_DIAS[*]}" '
    BEGIN{ n=split(dias,D," "); for(i=1;i<=n;i++) esdia[D[i]+0]=1 }
    {
      e = $1 + off*3600              # epoch ajustado a hora local
      hour = int(e/3600) % 24; if (hour<0) hour+=24
      d0   = (int(e/86400)+4) % 7    # 0=domingo .. 6=sabado
      if (d0<0) d0+=7
      iso  = (d0==0) ? 7 : d0        # 1=lunes .. 7=domingo
      total++
      if (esdia[iso] && hour>=ini && hour<fin) enclase++
    }
    END{ printf "%d %d", total+0, enclase+0 }'
)"
total_commits=${total_commits:-0}; en_clase=${en_clase:-0}

if (( total_commits == 0 )); then
  S3=0; clase_nota="sin commits en la rama"
else
  frac=$(calc "$en_clase/$total_commits")
  if $CLASE_SUMA; then S3=$(calc "15*$frac")
  else                 S3=$(calc "15*(1-$frac)"); fi
  clase_nota="$en_clase de $total_commits commits en hora de clase ($(redondear "$frac*100")%)"
fi

# ============================================================================
# 4) CALIDAD DE CODIGO: sintaxis + shellcheck  (20 pts)
# ============================================================================
sint_ok=0
for f in "${FILES[@]}"; do bash -n "$f" 2>/dev/null && sint_ok=$((sint_ok+1)); done
sint_score=$(calc "10*$sint_ok/$N")

if command -v shellcheck >/dev/null 2>&1; then
  total_issues=0
  for f in "${FILES[@]}"; do
    iss=$(shellcheck -f gcc "$f" 2>/dev/null | grep -c ':' || true)
    total_issues=$((total_issues + iss))
  done
  prom_issues=$(calc "$total_issues/$N")
  # 0 issues -> 10 ; 5+ issues/archivo -> 0
  lint_score=$(awk -v p="$prom_issues" 'BEGIN{ s=10*(1-p/5); if(s<0)s=0; printf "%.2f", s}')
  lint_nota="$total_issues avisos de shellcheck ($prom_issues/archivo)"
else
  # sin shellcheck: damos los 10 pts en base a la sintaxis y avisamos
  lint_score=$(calc "10*$sint_ok/$N")
  prom_issues="n/d"
  lint_nota="${C_YLW}shellcheck no instalado${C_RESET} (recomiendo: sudo apt install shellcheck)"
fi
S4=$(calc "$sint_score+$lint_score")

# ============================================================================
# 5) BUENAS PRACTICAS: shebang + ejecutable + nombres  (10 pts)
# ============================================================================
con_shebang=0; ejecutables=0; nombres_ok=0
for f in "${FILES[@]}"; do
  head -n1 "$f" | grep -q '^#!' && con_shebang=$((con_shebang+1))
  [[ -x "$f" ]] && ejecutables=$((ejecutables+1))
  base="$(basename "$f")"
  [[ "$base" =~ ^[a-z0-9._-]+$ ]] && nombres_ok=$((nombres_ok+1))   # minusculas, sin espacios
done
sb_score=$(calc "4*$con_shebang/$N")
ex_score=$(calc "3*$ejecutables/$N")
nm_score=$(calc "3*$nombres_ok/$N")
S5=$(calc "$sb_score+$ex_score+$nm_score")

# ============================================================================
# 6) CALIDAD DE MENSAJES DE COMMIT  (10 pts)
# ============================================================================
msgs="$(git log "$RAMA" --no-merges --pretty='%s' 2>/dev/null)"
nmsg=$(printf '%s\n' "$msgs" | grep -c . || true)
if (( nmsg == 0 )); then
  S6=0; msg_nota="sin mensajes de commit"
else
  # longitud media de palabras (ideal >= 4 palabras)
  prom_pal=$(printf '%s\n' "$msgs" | awk 'NF{n+=NF; c++} END{ if(c>0) printf "%.2f", n/c; else print 0}')
  len_score=$(awk -v p="$prom_pal" 'BEGIN{ s=5*(p/4); if(s>5)s=5; printf "%.2f", s}')
  # genericos: "wip","fix","update","test",".", una sola palabra
  genericos=$(printf '%s\n' "$msgs" | grep -iEc '^(wip|fix|update|test|cambios?|\.|\.\.\.|asdf|commit)$' || true)
  gen_score=$(awk -v g="$genericos" -v t="$nmsg" 'BEGIN{ printf "%.2f", 3*(1-g/t) }')
  # ingles en los mensajes
  read -r men ms <<<"$(printf '%s\n' "$msgs" | awk '
    BEGIN{ split("add fix update create remove refactor test script function file branch commit comment for the with",EN," "); for(i in EN)e[EN[i]]=1 }
    { l=tolower($0); n=split(l,w,/[^a-z]+/); for(i=1;i<=n;i++){ if(w[i]=="")continue; if(e[w[i]])en++ ; if(l~/[áéíóúñ]/)es++ } }
    END{ printf "%d %d", en+0, es+0 }')"
  if (( men+ms == 0 )); then ing_score=$(calc "2*0.5"); else ing_score=$(calc "2*$men/($men+$ms)"); fi
  S6=$(calc "$len_score+$gen_score+$ing_score")
  msg_nota="$nmsg commits, ~$prom_pal palabras/mensaje, $genericos genericos"
fi

# ============================================================================
# NOTA FINAL
# ============================================================================
SUMA=$(calc "$S1+$S2+$S3+$S4+$S5+$S6")
MAX_TOTAL=$(calc "$MAX1+20+15+20+10+10")
TOTAL=$(calc "$SUMA/$MAX_TOTAL*100")
TOTAL_R=$(redondear "$TOTAL")

letra() {
  local n="$1"
  if   (( n >= 90 )); then echo "${C_GRN}A — Excelente${C_RESET}"
  elif (( n >= 80 )); then echo "${C_GRN}B — Muy bien${C_RESET}"
  elif (( n >= 70 )); then echo "${C_YLW}C — Aprobado${C_RESET}"
  elif (( n >= 60 )); then echo "${C_YLW}D — Justo${C_RESET}"
  else                     echo "${C_RED}F — A mejorar${C_RESET}"; fi
}

echo
echo "${C_BOLD}${C_CYN}============================================================${C_RESET}"
echo "${C_BOLD}   CALIFICACION DE LA RAMA: ${C_CYN}$RAMA${C_RESET}"
echo "${C_BOLD}${C_CYN}============================================================${C_RESET}"
echo "  Archivos evaluados ($N): ${C_DIM}$(printf '%s ' "${FILES[@]##*/}")${C_RESET}"
echo
printf "  ${C_BOLD}%-34s %6s  %s${C_RESET}\n" "Criterio" "Pts" "Avance"
if (( MAX1 > 0 )); then
  printf "  %-34s %6.1f  [%s]\n" "1. Comentarios (calidad)/25"   "$S1" "$(barra "$S1" 25)"
else
  printf "  %-34s %6s  %s\n" "1. Comentarios (calidad)" "n/a" "(ninguna lleva comentarios; reescalado)"
fi
printf "  %-34s %6.1f  [%s]\n" "2. Comentarios en ingles /20"    "$S2" "$(barra "$S2" 20)"
printf "  %-34s %6.1f  [%s]\n" "3. Commits en hora de clase /15" "$S3" "$(barra "$S3" 15)"
printf "  %-34s %6.1f  [%s]\n" "4. Calidad de codigo /20"        "$S4" "$(barra "$S4" 20)"
printf "  %-34s %6.1f  [%s]\n" "5. Buenas practicas /10"         "$S5" "$(barra "$S5" 10)"
printf "  %-34s %6.1f  [%s]\n" "6. Mensajes de commit /10"       "$S6" "$(barra "$S6" 10)"
echo "  ----------------------------------------------------------"
printf "  ${C_BOLD}%-34s %6s  %s${C_RESET}\n" "NOTA FINAL" "$TOTAL_R/100" "$(letra "$TOTAL_R")"
echo
echo "${C_BOLD}  Detalle${C_RESET}"
echo "${C_DIM}$detalle_coment${C_RESET}"
echo "    Idioma comentarios : $idioma_nota"
echo "    Hora de clase      : $clase_nota"
echo "    Codigo             : $sint_ok/$N sin errores de sintaxis; $lint_nota"
echo "    Buenas practicas   : shebang $con_shebang/$N, ejecutables $ejecutables/$N, nombres $nombres_ok/$N"
echo "    Commits            : $msg_nota"
echo
echo "${C_DIM}  Config en uso: dias=[${CLASE_DIAS[*]}] horas=[$CLASE_HORA_INI-$CLASE_HORA_FIN) UTC_OFFSET=$UTC_OFFSET clase_suma=$CLASE_SUMA${C_RESET}"
echo