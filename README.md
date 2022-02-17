# tmux-prometheus

Tmux plugin for prometheus.

Features:

* number of alerts in status bar
* open prometheus URL(s) in browser

## #Pre-requisites

### tmux-power

The plugin [tmux-power]() has been slightly modified to support this plugin. You need to install a [fork](https://github.com/jbertozzi/tmux-power) prior to use it:

### fzf

fzf is used to display available prometheus URL with number of firing alerts.

## Configuration


### Environment variables

* `browser`: the path to the browser to open the selected URL(s)
* `TMUX_PROMETHEUS_URLS`: list of coma spearted promehteus URLs to query

An example of browser when running in WSL is:

```
export browser="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"
```

Prometheus instances to query are defined by `TMUX_PROMETHEUS_URLS` environment variable (coma separated list of URLs).

```
TMUX_PROMETHEUS_URLS=$(printf "%s," https://{stg,prd}.toto.com)
TMUX_PROMETHEUS_URLS="${TMUX_PROMETHEUS_URLS%,}"
export TMUX_PROMETHEUS_URL
# or simply 'export TMUX_PROMETHEUS_URL=stg.toto.com,prd.toto.com'
```

If you set this environment variable after you load your `tmux` session, you might need to run:

```
tmux set-environment -g TMUX_PROMETHEUS_URLS
```

### Tmux configuration

To install the plugin:

```
set -g @plugin 'jertozzi/tmux-power'
set -g @plugin 'jbertozzi/tmux-prometheus'
```

A default binding (`ctrl-m`) is provided to open in a browser the selected instance(s).

The default binding can be overriden by setting in your `~/.tmux.conf`:

```
set -g @tmux_prometheus_bind_key 'o'
```

To change the default icon:

```
set -g @tmux_power_prometheus_icon ''
```
