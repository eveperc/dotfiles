#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m[OK]\033[0m %s\n" "$1"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$1"; exit 1; }

# -----------------------------------------------------------
# 1. Homebrew
# -----------------------------------------------------------
install_homebrew() {
  if command -v brew &>/dev/null; then
    success "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
  fi
}

# -----------------------------------------------------------
# 2. Brewfile
# -----------------------------------------------------------
install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
  success "Packages installed"
}

# -----------------------------------------------------------
# 3. Symlinks
# -----------------------------------------------------------
create_symlink() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    warn "Backing up existing $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  success "Linked $dest"
}

setup_symlinks() {
  info "Creating symlinks..."

  # Shell
  create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

  # .config
  create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
  create_symlink "$DOTFILES_DIR/.config/fish" "$HOME/.config/fish"
  create_symlink "$DOTFILES_DIR/.config/wezterm" "$HOME/.config/wezterm"

  success "All symlinks created"
}

# -----------------------------------------------------------
# 4. Oh My Zsh
# -----------------------------------------------------------
install_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh already installed"
  else
    info "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "Oh My Zsh installed"
  fi

  # Powerlevel10k
  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ -d "$p10k_dir" ]; then
    success "Powerlevel10k already installed"
  else
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    success "Powerlevel10k installed"
  fi

  # zsh-autosuggestions
  local auto_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  if [ -d "$auto_dir" ]; then
    success "zsh-autosuggestions already installed"
  else
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$auto_dir"
    success "zsh-autosuggestions installed"
  fi

  # zsh-syntax-highlighting
  local syntax_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  if [ -d "$syntax_dir" ]; then
    success "zsh-syntax-highlighting already installed"
  else
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$syntax_dir"
    success "zsh-syntax-highlighting installed"
  fi
}

# -----------------------------------------------------------
# 5. Tmux Plugin Manager
# -----------------------------------------------------------
install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir" ]; then
    success "TPM already installed"
  else
    info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "TPM installed (run prefix + I in tmux to install plugins)"
  fi
}

# -----------------------------------------------------------
# 6. Git config (user info)
# -----------------------------------------------------------
setup_gitconfig_local() {
  if [ -f "$HOME/.gitconfig.local" ]; then
    success "~/.gitconfig.local already exists"
  else
    info "Setting up Git user config..."
    printf "Git user name: "
    read -r git_name
    printf "Git email: "
    read -r git_email

    cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = ${git_name}
	email = ${git_email}
EOF
    success "~/.gitconfig.local created"
  fi
}

# -----------------------------------------------------------
# 7. macOS defaults
# -----------------------------------------------------------
setup_macos_defaults() {
  printf "\033[1;34m[INFO]\033[0m Apply macOS defaults? (KeyRepeat, Finder, Dock) [y/N]: "
  read -r answer
  if [[ "$answer" != [yY] ]]; then
    warn "Skipped macOS defaults"
    return
  fi

  info "Applying macOS defaults..."

  # キーリピート速度
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Finderで隠しファイルを表示
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # 拡張子を常に表示
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Dockを自動的に隠す
  defaults write com.apple.dock autohide -bool true

  # Dockのアニメーション速度
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.3

  # スクリーンショットの保存先
  mkdir -p "$HOME/Screenshots"
  defaults write com.apple.screencapture location -string "$HOME/Screenshots"

  # .DS_Store をネットワークボリュームに作成しない
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  killall Finder Dock 2>/dev/null || true
  success "macOS defaults applied"
}

# -----------------------------------------------------------
# 8. Git LFS
# -----------------------------------------------------------
setup_git_lfs() {
  info "Setting up Git LFS..."
  git lfs install
  success "Git LFS configured"
}

# -----------------------------------------------------------
# Main
# -----------------------------------------------------------
main() {
  echo ""
  echo "=========================================="
  echo "  Dotfiles Setup Script"
  echo "=========================================="
  echo ""

  install_homebrew
  install_packages
  install_omz
  setup_symlinks
  install_tpm
  setup_gitconfig_local
  setup_git_lfs
  setup_macos_defaults

  echo ""
  echo "=========================================="
  echo "  Setup Complete!"
  echo "=========================================="
  echo ""
  echo "Next steps:"
  echo "  1. tmux を起動して prefix + I でプラグインをインストール"
  echo "  2. 必要に応じて ~/.p10k.zsh を設定 (p10k configure)"
  echo "  3. Neovim を起動して :DppInstall でプラグインをインストール"
  echo ""
}

main "$@"
