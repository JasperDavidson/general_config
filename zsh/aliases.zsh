# Modern replacements (fall back to defaults if tool missing)
command -v eza >/dev/null && {
  alias ls='eza --group-directories-first'
  alias ll='eza -l --git --group-directories-first'
  alias la='eza -la --git --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
}
command -v bat >/dev/null && alias cat='bat --paging=never'

# Git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
