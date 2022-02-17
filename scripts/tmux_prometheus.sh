#/usr/bin/bash

declare -Ar COLORS=(
    [RED]=$'\033[0;31m'
    [GREEN]=$'\033[0;32m'
    [BLUE]=$'\033[0;34m'
    [PURPLE]=$'\033[0;35m'
    [CYAN]=$'\033[0;36m'
    [WHITE]=$'\033[0;37m'
    [YELLOW]=$'\033[0;33m'
    [OFF]=$'\033[0m'
    [BOLD]=$'\033[1m'
)
#echo $browser
#[ -z "${browser}" ] && printf "environment variable 'browser' must be set\n" && exit 1

trigger_pane=$1
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
enter_key="enter"
selectall_key='ctrl-a'
deselectall_key='ctrl-d'
fzf_expect="$selectall_key,$deselectall_key,ctrl-c,esc,enter"
fzf_bind="$selectall_key:select-all,$deselectall_key:deselect-all"

header_tmpl="${COLORS[BOLD]}${selectall_key}${COLORS[OFF]}=select all"
header_tmpl+=", ${COLORS[BOLD]}${COLORS[ORANGE]}${deselectall_key}${COLORS[OFF]}=deselect all"
header_tmpl+=", ${COLORS[BOLD]}${COLORS[YELLOW]}tab${COLORS[OFF]}=select"
header_tmpl+=", ${COLORS[BOLD]}${COLORS[GREEN]}enter${COLORS[OFF]}=open browser"
header_tmpl+=", ${COLORS[BOLD]}${COLORS[RED]}ctrl-c|esc${COLORS[OFF]}=quit"
fzf_header=$header_tmpl

out=$(${CURRENT_DIR}/get_alerts.sh -l | tee /tmp/stage1 |fzf-tmux \
            --multi --ansi -i -1 --height=50% --reverse -0 --inline-info --border \
            --bind="${fzf_bind}" --no-info \
            --header="${fzf_header}" |tee /tmp/stage2)
            #--expect="${fzf_expect}" \

if [ ! -z "$out" ]; then
  # split mutliple line into array
  mapfile -t out <<< "$out"
  urls=""
  for url in "${out[@]}"; do
    url=${url%% *}/alerts
    printf -v urls -- ' %s --new-tab %s' "${urls}" "${url}" 
  done

  echo "${browser}" ${urls} > /tmp/t
  "${browser}" ${urls}
fi
