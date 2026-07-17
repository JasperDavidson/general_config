# ~/.config/zsh/.zshrc
# Loaded for interactive shells. ZDOTDIR points zsh here from ~/.zshenv.

# OMP runs interactive command shells without terminal capabilities.
[[ "$TERM" == dumb ]] && return

# ---------- History ----------
HISTFILE="${ZDOTDIR}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicate entries
setopt HIST_IGNORE_SPACE      # don't record commands starting with space
setopt HIST_VERIFY            # show !! expansion before running
setopt EXTENDED_HISTORY       # timestamp entries

# ---------- Shell options ----------
setopt AUTO_CD                # `foo/bar` with no command cds into it
setopt AUTO_PUSHD             # cd pushes onto dir stack
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shells

# ---------- Completion ----------
# Only rescan completions if the cache is older than 24 hours.
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' menu select                          # arrow-key menu

# ---------- zinit (plugin manager) ----------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ---------- Plugins ----------
# `wait` = turbo mode: load AFTER the prompt appears (keeps startup snappy).
# `lucid` = suppress the "Loaded ..." messages.

# Inline gray suggestions from history (Fish-style). Right-arrow / End to accept.
zinit wait lucid light-mode for \
  atinit"ZSH_AUTOSUGGEST_STRATEGY=(history completion)" \
    zsh-users/zsh-autosuggestions

# Syntax highlighting as you type. Must load AFTER autosuggestions.
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# Up-arrow searches history for what you've typed so far.
zinit wait lucid light-mode for \
  zsh-users/zsh-history-substring-search
# bind up/down after the plugin loads
zinit ice wait lucid atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

# Extra completions (docker, kubectl, gh, etc.)
zinit wait lucid light-mode for \
  zsh-users/zsh-completions

# fzf-tab: fuzzy-pick completions with fzf. Must load AFTER compinit
# but BEFORE syntax highlighting (which fast-syntax-highlighting respects).
zinit wait lucid light-mode for \
  Aloxaf/fzf-tab
# Preview directory contents when tab-completing `cd`
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
# Use a popup-ish layout
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
# Switch groups with `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Vi mode — modal editing on the command line.
# Loaded SYNCHRONOUSLY (no `wait`) so bindings are active on the first prompt.
# Turbo-loading this means the first prompt has no vi bindings — feels broken.
ZVM_KEYTIMEOUT=0.05
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
zinit light jeffreytse/zsh-vi-mode

# ---------- Tool integrations ----------
# Each tool's init script is cached and only regenerated when the binary changes.
# This makes startup fast while staying portable across machines.

_tool_init() {
  local bin="$1" cache="$2"; shift 2
  local bin_path
  bin_path="$(command -v "$bin" 2>/dev/null)" || return 0
  if [[ ! -f "$cache" || "$bin_path" -nt "$cache" ]]; then
    "$bin_path" "$@" >| "$cache" 2>/dev/null
  fi
  source "$cache"
}
_cache="${XDG_CACHE_HOME:-$HOME/.cache}"

# starship prompt
_tool_init starship "$_cache/starship_init.zsh" init zsh

# zoxide: `z foo` jumps, `zi` opens fzf picker
_tool_init zoxide "$_cache/zoxide_init.zsh" init zsh

# fzf: Ctrl-T files, Alt-C dirs. (Ctrl-R is taken by atuin below.)
# Load BEFORE atuin so atuin's Ctrl+R binding wins.
if _tool_init fzf "$_cache/fzf_init.zsh" --zsh; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# atuin: TUI history search on Ctrl+R.
# zsh-vi-mode rebinds keys in its own deferred init, which clobbers atuin's
# Ctrl+R binding. ZVM's `zvm_after_init_commands` array runs AFTER its rebinds,
# so we register atuin there to make sure the binding sticks.
if command -v atuin >/dev/null; then
  _tool_init atuin "$_cache/atuin_init.zsh" init zsh --disable-up-arrow
  zvm_after_init_commands+=('bindkey "^R" atuin-search')
fi

unfunction _tool_init
unset _cache

# ---------- Aliases ----------
[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"

# ---------- Local overrides (not committed) ----------
[[ -f "${ZDOTDIR}/.zshrc.local" ]] && source "${ZDOTDIR}/.zshrc.local"
