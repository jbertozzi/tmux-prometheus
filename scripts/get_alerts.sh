#!/usr/bin/bash

function usage {
  printf "Usage: $0 [ -h ] [ -l ]\n"
  printf "  -u [prometheus_urls,...]: coma spearated list of urls (env TMUX_PROMETHEUS_URLS)\n"
  printf "  -l: list urls instead of displaying onlty total number of alerts\n"
  printf "  -h: this help message\n"
  exit 1
}

o_list=0
o_urls=""
# use environment variable if set
[ ! -z "${TMUX_PROMETHEUS_URLS}" ] && o_urls=${TMUX_PROMETHEUS_URLS}

while getopts "hlu:" opt; do
  case "$opt" in
    l)
      o_list=1
      ;;
    h)
      usage
      ;;
    u)
      o_urls=OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z "${o_urls}" ]; then
  echo "missing '-u' flag or 'TMUX_PROMETHEUS_URLS' environment variable"
  usage
fi

api_alerts="/api/v1/alerts"
IFS=, read -r -a urls <<< "${o_urls}"
declare -A results
for url in "${urls[@]}"; do
	results[$url]=$(curl -s ${url}${api_alerts} | jq '.data.alerts | length')
done

list_urls=""
alerts=0
for url in "${!results[@]}"; do
  (( alerts+=results["$url"] ))
  if [ "$o_list" == "1" ]; then
    printf -v list_urls "%-40s (%s)\n%s" "$url" "${results[$url]}" "${list_urls}"
  fi
done
if (( "$o_list" )); then
  printf "$list_urls"
else
  printf "%d" "$alerts"
fi
