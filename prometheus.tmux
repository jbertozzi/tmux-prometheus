#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

all_alerts="$(get_tmux_option '@tmux_prometheus_show_all_alerts')"
flag=""
if (( "$all_alerts" )); then
  flag="-a"
fi

prometheus_alerts="#($CURRENT_DIR/scripts/get_alerts.sh $flag)"

key="$(get_tmux_option '@tmux_prometheus_bind_key' 'm')"

tmux bind-key "$key" run-shell -b "$CURRENT_DIR/scripts/tmux_prometheus.sh &> /tmp/tmux-prometheus.log"

prometheus_interpolation="\#{prometheus_alerts}"

do_interpolation() {
	local input=$1
  local result=""

	result=${input/$prometheus_interpolation/$prometheus_alerts}

	echo $result
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-left"
}
main
