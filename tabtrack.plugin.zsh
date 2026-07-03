# tabtrack — automatic tab coloring for your terminal
# https://github.com/wrabit/tabtrack

# ─── Built-in color presets ────────────────────────────────────────────────────
# These are applied by default. User config (~/.tabtrack) takes priority.

declare -A _tt_builtin_colors
declare -a _tt_builtin_order

_tt_builtin_order=(
  'claude*'
  'npm*'
  'yarn*'
  'pnpm*'
  'bun*'
  'brew*'
  'docker*'
  'docker-compose*'
  'git*'
  'python*'
  'pip*'
  'uv'
  'uvx*'
  'node*'
  'ruby*'
  'cargo*'
  'go'
  'ssh*'
  'make*'
  'vim*'
  'nvim*'
  'nano*'
  'htop*'
  'top*'
  'pytest*'
  'rails*'
  'redis*'
  'psql*'
  'mysql*'
  'mongosh*'
  'kubectl*'
  'terraform*'
)

_tt_builtin_colors=(
  'claude*'           '#ff8c00'   # orange
  'npm*'              '#CB3837'   # red
  'yarn*'             '#2C8EBB'   # blue
  'pnpm*'             '#F69220'   # orange
  'bun*'              '#FBF0DF'   # cream
  'brew*'             '#BE862D'   # brown
  'docker*'           '#0db7ed'   # blue
  'docker-compose*'   '#0db7ed'   # blue
  'git*'              '#f14e32'   # orange-red
  'python*'           '#3776AB'   # blue
  'pip*'              '#3776AB'   # blue
  'uv'                '#6340AC'   # purple (exact match)
  'uvx*'              '#6340AC'   # purple
  'node*'             '#339933'   # green
  'ruby*'             '#CC342D'   # red
  'cargo*'            '#DEA584'   # rust
  'go'                '#00ADD8'   # cyan (exact match)
  'ssh*'              '#4E9A06'   # green
  'make*'             '#6D8086'   # gray
  'vim*'              '#019833'   # green
  'nvim*'             '#57A143'   # green
  'nano*'             '#4A90D9'   # blue
  'htop*'             '#2E8B57'   # sea green
  'top*'              '#2E8B57'   # sea green
  'pytest*'           '#696969'   # gray
  'rails*'            '#CC0000'   # red
  'redis*'            '#DC382D'   # red
  'psql*'             '#336791'   # blue
  'mysql*'            '#4479A1'   # blue
  'mongosh*'          '#47A248'   # green
  'kubectl*'          '#326CE5'   # blue
  'terraform*'        '#7B42BC'   # purple
)

# ─── Default (idle) color ──────────────────────────────────────────────────────
# Color shown when no command is running. Set in ~/.tabtrack or export TT_DEFAULT.
# Falls back to #1e1e1e (charcoal) if unset.

TT_DEFAULT="${TT_DEFAULT:-#1e1e1e}"

# ─── Auto-color from command hash ─────────────────────────────────────────────
# When no pattern matches, generate a deterministic color from the string.
# Set TT_AUTO_COLOR=false to disable.

function _tt_hash_color() {
  local input="$1"
  local hash=0
  local i
  for (( i=1; i<=${#input}; i++ )); do
    hash=$(( (hash * 31 + i * 7 + (i % 17)) % 16777216 ))
  done
  hash=$(( (hash + ${#input} * 13337) % 16777216 ))

  local r=$(( (hash >> 16) & 0xFF ))
  local g=$(( (hash >> 8) & 0xFF ))
  local b=$(( hash & 0xFF ))

  # Keep colors in a comfortable range
  local min_val=60 max_val=200
  r=$((r * (max_val - min_val) / 255 + min_val))
  g=$((g * (max_val - min_val) / 255 + min_val))
  b=$((b * (max_val - min_val) / 255 + min_val))

  # Boost if too dark
  local max_c=$((r > g ? (r > b ? r : b) : (g > b ? g : b)))
  if (( max_c < 120 )); then
    local boost=$((140 - max_c))
    r=$((r + boost)); g=$((g + boost)); b=$((b + boost))
  fi

  printf "%02x%02x%02x" $r $g $b
}

# ─── User config ───────────────────────────────────────────────────────────────
# Load from ~/.tabtrack if it exists

declare -A _tt_user_colors
declare -a _tt_user_order

_tt_user_config="${HOME}/.tabtrack"

if [[ -f "$_tt_user_config" ]]; then
  while IFS="=" read -r configKey hexValue || [[ -n "$hexValue" ]]; do
    [[ "$configKey" == \#* ]] && continue
    [[ -z "$configKey" ]] && continue
    configKey="${configKey## }"
    configKey="${configKey%% }"
    hexValue="${hexValue## }"
    hexValue="${hexValue%% }"
    # Special key: default idle color
    if [[ "$configKey" == "default" ]]; then
      TT_DEFAULT="$hexValue"
      continue
    fi
    _tt_user_order+=( "$configKey" )
    _tt_user_colors[$configKey]="$hexValue"
  done < "$_tt_user_config"
fi

# ─── Core: set tab color ──────────────────────────────────────────────────────
# Currently supports iTerm2. Other terminals can be added here.

function _tt_set_color() {
  if [[ $# -eq 0 ]]; then
    echo -ne "\033]6;1;bg;*;default\a"
    return 0
  fi

  local r g b
  if [[ $# -eq 1 ]]; then
    local hex="${1#\#}"
    r=$(( 16#${hex:0:2} ))
    g=$(( 16#${hex:2:2} ))
    b=$(( 16#${hex:4:2} ))
  else
    r=$1; g=$2; b=$3
  fi

  echo -ne "\033]6;1;bg;red;brightness;$r\a"
  echo -ne "\033]6;1;bg;green;brightness;$g\a"
  echo -ne "\033]6;1;bg;blue;brightness;$b\a"
}

# ─── Pattern matching ──────────────────────────────────────────────────────────

function _tt_match() {
  local input="$1"
  # Extract command name (first word, no path)
  local cmd="${input%% *}"
  cmd="${cmd##*/}"

  # User config takes priority (matched against full input for path patterns)
  for k in "${_tt_user_order[@]}"; do
    if [[ "$input" == $~k ]]; then
      _tt_set_color "${_tt_user_colors[$k]}"
      return 0
    fi
  done

  # Then built-in presets (matched against command name using glob)
  for k in "${_tt_builtin_order[@]}"; do
    if [[ "$cmd" == $~k ]]; then
      _tt_set_color "${_tt_builtin_colors[$k]}"
      return 0
    fi
  done

  # Auto-generate from command hash
  if [[ "${TT_AUTO_COLOR:-true}" == "true" ]]; then
    _tt_set_color "$(_tt_hash_color "$cmd")"
  else
    _tt_set_color "$TT_DEFAULT"
  fi
}

# ─── Idle color ────────────────────────────────────────────────────────────────
# When no command is running, directory patterns from user config are matched
# against $PWD. First match wins; falls back to TT_DEFAULT.

function _tt_idle_color() {
  local k pattern
  for k in "${_tt_user_order[@]}"; do
    pattern="${k/#\~/$HOME}"
    if [[ "$PWD" == $~pattern ]]; then
      echo "${_tt_user_colors[$k]}"
      return 0
    fi
  done
  echo "$TT_DEFAULT"
}

# ─── Hooks ─────────────────────────────────────────────────────────────────────

function _tt_preexec() {
  _tt_match "$1"
}

function _tt_precmd() {
  _tt_set_color "$(_tt_idle_color)"
}

preexec_functions=(${preexec_functions[@]} "_tt_preexec")
precmd_functions=(${precmd_functions[@]} "_tt_precmd")

# ─── Set idle color on startup ─────────────────────────────────────────────────

_tt_set_color "$(_tt_idle_color)"
