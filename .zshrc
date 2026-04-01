# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"

# PATH (重複追加を防止)
typeset -U PATH path

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Rancher Desktop
if [ -d "$HOME/.rd/bin" ]; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

# Go
if command -v go &>/dev/null; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi

# Python / Pyenv
if [ -d "/opt/homebrew/opt/python@3.13/libexec/bin" ]; then
  export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"
elif [ -d "/usr/local/opt/python@3.13/libexec/bin" ]; then
  export PATH="/usr/local/opt/python@3.13/libexec/bin:$PATH"
fi

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$("$PYENV_ROOT/bin/pyenv" init --path)"
  eval "$("$PYENV_ROOT/bin/pyenv" init -)"
fi

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor root)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
ZSH_HIGHLIGHT_STYLES[root]='bg=red'

# zoxide (z の代替)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# eza (ls の代替)
if command -v eza &>/dev/null; then
  alias ls="eza --icons --git"
  alias ll="eza --icons --git -la"
  alias lt="eza --icons --git --tree --level=2"
fi

# bat (cat の代替)
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
fi

# yazi: 終了時にカレントディレクトリを追従する関数
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Safe-chain
if [ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]; then
  source "$HOME/.safe-chain/scripts/init-posix.sh"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/katsunori-ibusuki/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
