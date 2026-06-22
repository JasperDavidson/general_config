
# Cache brew shellenv — regenerate only when the brew binary itself changes.
# Portable: no-ops gracefully if brew isn't installed (Linux, new machines).
_brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew_shellenv.zsh"
_brew_bin="${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew"
if command -v brew >/dev/null 2>&1; then
  _brew_bin="$(command -v brew)"
fi
if [[ -x "$_brew_bin" && ( ! -f "$_brew_cache" || "$_brew_bin" -nt "$_brew_cache" ) ]]; then
  "$_brew_bin" shellenv zsh >| "$_brew_cache" 2>/dev/null
fi
[[ -f "$_brew_cache" ]] && source "$_brew_cache"
unset _brew_cache _brew_bin

# >>> Codex installer >>>
export PATH="/Users/jasperd@nvidia.com/.local/bin:$PATH"
# <<< Codex installer <<<
