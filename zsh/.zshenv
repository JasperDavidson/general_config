# Loaded for ALL zsh invocations (login, interactive, scripts).
# Keep this minimal — env vars only, no interactive setup.
. "$HOME/.cargo/env" 2>/dev/null || true

# Homebrew's LLVM is keg-only, but Neovim expects clangd on PATH.
[[ -d /opt/homebrew/opt/llvm/bin ]] && path=(/opt/homebrew/opt/llvm/bin $path)
[[ -d /usr/local/opt/llvm/bin ]] && path=(/usr/local/opt/llvm/bin $path)
