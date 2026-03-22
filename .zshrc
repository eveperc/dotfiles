# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# Safe-chain
if [ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]; then
  source "$HOME/.safe-chain/scripts/init-posix.sh"
fi
