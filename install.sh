#!/usr/bin/env bash
# Bootstrap this config repo onto a machine. Idempotent; existing files are backed up.
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
BACKUP_DIR="$STATE_HOME/general_config/backups/$(date +%Y%m%d-%H%M%S)"
MADE_BACKUP=0
INSTALL_BREW=1
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--no-brew] [--dry-run]

Sets up:
  - XDG config links: agents, atuin, cf-include, clangd, gh, ghostty, git, herdr, nvim, starship
  - zsh ZDOTDIR bootstrap via ~/.zshenv
  - shared agent config for Claude, Codex, OpenCode, and Pi
  - Atuin AI permission file
  - Homebrew CLI and app dependencies on macOS unless --no-brew is passed

Existing non-matching files are moved to ~/.local/state/general_config/backups/<timestamp>/.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-brew) INSTALL_BREW=0 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

log() { printf '==> %s\n' "$*"; }
run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

real_path() {
  python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1" 2>/dev/null || printf '%s\n' "$1"
}

backup_target() {
  local target="$1" rel backup
  rel="${target#$HOME/}"
  [[ "$rel" == "$target" ]] && rel="${target#/}"
  backup="$BACKUP_DIR/$rel"
  if [[ "$MADE_BACKUP" -eq 0 ]]; then
    run mkdir -p "$BACKUP_DIR"
    MADE_BACKUP=1
  fi
  run mkdir -p "$(dirname "$backup")"
  if [[ -e "$backup" || -L "$backup" ]]; then
    backup="$backup.$RANDOM"
  fi
  log "Backing up $target -> $backup"
  run mv "$target" "$backup"
}

link_path() {
  local source="$1" target="$2"

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    log "Missing source, skipping: $source"
    return 0
  fi

  if [[ "$source" == "$target" ]]; then
    log "Present: $target"
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ "$(real_path "$source")" == "$(real_path "$target")" ]]; then
      log "Linked: $target"
      return 0
    fi
    backup_target "$target"
  fi

  run mkdir -p "$(dirname "$target")"
  log "Linking $target -> $source"
  run ln -s "$source" "$target"
}

ensure_line() {
  local file="$1" line="$2"
  run mkdir -p "$(dirname "$file")"
  if [[ ! -f "$file" ]] || ! grep -qxF "$line" "$file" 2>/dev/null; then
    log "Adding line to $file: $line"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      printf '[dry-run] append %q to %q\n' "$line" "$file"
    else
      printf '%s\n' "$line" >> "$file"
    fi
  fi
}

install_brew_packages() {
  [[ "$INSTALL_BREW" -eq 1 ]] || return 0
  if [[ "$(uname -s)" != "Darwin" ]]; then
    log "Non-macOS host; skipping Homebrew packages"
    return 0
  fi

  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      printf '[dry-run] install Homebrew\n'
      return 0
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    # shellcheck disable=SC2046
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    # shellcheck disable=SC2046
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  local formulae=(
    git
    gh
    herdr
    neovim
    starship
    zoxide
    fzf
    atuin
    eza
    bat
    fd
    ripgrep
    jq
    tree
    clang-format
    llvm
    rust-analyzer
    lua-language-server
    pyright
    stylua
    ruff
    tectonic
    lazygit
  )

  log "Installing Homebrew formulae"
  local pkg
  for pkg in "${formulae[@]}"; do
    if ! brew list --formula "$pkg" >/dev/null 2>&1; then
      run brew install "$pkg"
    fi
  done

  local casks=(
    font-jetbrains-mono-nerd-font
    ghostty
    skim
  )

  log "Installing Homebrew casks"
  for pkg in "${casks[@]}"; do
    if ! brew list --cask "$pkg" >/dev/null 2>&1; then
      run brew install --cask "$pkg"
    fi
  done
}

install_zinit() {
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ ! -d "$zinit_home" ]]; then
    log "Installing zinit"
    run mkdir -p "$(dirname "$zinit_home")"
    run git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
  fi
}

install_config_links() {
  log "Linking XDG config"
  run mkdir -p "$CONFIG_HOME"

  local item
  for item in agents atuin cf-include clangd gh ghostty git herdr nvim starship.toml; do
    link_path "$REPO_DIR/$item" "$CONFIG_HOME/$item"
  done

  log "Bootstrapping zsh"
  link_path "$REPO_DIR/zsh" "$CONFIG_HOME/zsh"
  ensure_line "$HOME/.zshenv" 'export ZDOTDIR="$HOME/.config/zsh"'
  ensure_line "$HOME/.zshenv" '[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"'

  log "Linking Git compatibility files"
  link_path "$CONFIG_HOME/git/config" "$HOME/.gitconfig"
  link_path "$CONFIG_HOME/git/ignore" "$HOME/.gitignore_global"

  log "Linking shared agent config"
  run mkdir -p "$HOME/.claude" "$HOME/.codex" "$CONFIG_HOME/opencode" "$HOME/.pi/agent"
  link_path "$CONFIG_HOME/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  link_path "$CONFIG_HOME/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
  link_path "$CONFIG_HOME/agents/AGENTS.md" "$CONFIG_HOME/opencode/AGENTS.md"
  link_path "$CONFIG_HOME/agents/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
  link_path "$CONFIG_HOME/agents/skills" "$HOME/.claude/skills"
  link_path "$CONFIG_HOME/agents/skills" "$HOME/.codex/skills"
  link_path "$CONFIG_HOME/agents/skills" "$CONFIG_HOME/opencode/skills"
  link_path "$CONFIG_HOME/agents/skills" "$HOME/.pi/agent/skills"

  log "Linking Atuin AI permissions"
  run mkdir -p "$HOME/.atuin"
  link_path "$REPO_DIR/.atuin/permissions.ai.toml" "$HOME/.atuin/permissions.ai.toml"
}

install_config_links
install_brew_packages
install_zinit

log "Done. Restart your terminal or run: exec zsh"
if [[ "$MADE_BACKUP" -eq 1 ]]; then
  log "Backups: $BACKUP_DIR"
fi
