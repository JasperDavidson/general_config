#!/usr/bin/env bash
# Bootstrap a new machine. Idempotent — safe to re-run.
set -euo pipefail

CONFIG_DIR="${HOME}/.config"
ZDOTDIR="${CONFIG_DIR}/zsh"

echo "==> Bootstrapping zsh environment"

# ---------- 1. Homebrew ----------
if ! command -v brew >/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for the rest of this script (Apple Silicon path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ---------- 2. Packages ----------
echo "==> Installing CLI tools"
BREW_PACKAGES=(
  starship
  zoxide
  fzf
  atuin
  eza
  bat
  fd
  ripgrep
  git
)
for pkg in "${BREW_PACKAGES[@]}"; do
  brew list --formula "$pkg" >/dev/null 2>&1 || brew install "$pkg"
done

# ---------- 3. Fonts ----------
echo "==> Installing JetBrainsMono Nerd Font"
brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 \
  || brew install --cask font-jetbrains-mono-nerd-font

# ---------- 4. zinit ----------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  echo "==> Installing zinit"
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ---------- 5. Bootstrap ~/.zshenv to point at ZDOTDIR ----------
# zsh reads $HOME/.zshenv FIRST, before consulting ZDOTDIR. So this stub
# stays at $HOME and just forwards everything to ~/.config/zsh.
ZSHENV="${HOME}/.zshenv"
ZSHENV_LINE='export ZDOTDIR="$HOME/.config/zsh"'
if ! grep -qF "$ZSHENV_LINE" "$ZSHENV" 2>/dev/null; then
  echo "==> Updating ~/.zshenv to set ZDOTDIR"
  {
    echo "$ZSHENV_LINE"
    echo '[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"'
  } >> "$ZSHENV"
fi

# ---------- 6. Migrate existing .zprofile if it lives at $HOME ----------
if [[ -f "${HOME}/.zprofile" && ! -f "${ZDOTDIR}/.zprofile" ]]; then
  echo "==> Moving ~/.zprofile into ${ZDOTDIR}/"
  mv "${HOME}/.zprofile" "${ZDOTDIR}/.zprofile"
fi

echo ""
echo "==> Done. Open a new terminal (or run: exec zsh)"
echo "    Set your terminal font to 'JetBrainsMono Nerd Font' if it didn't auto-pick up."
