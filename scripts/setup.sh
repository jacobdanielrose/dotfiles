#!/bin/bash

set -e

# Function to handle errors
handle_error() {
    echo "An error occurred. Cleaning up..."
    restore_dotfiles
    exit 1
}

# Trap errors to handle them
trap 'handle_error' ERR

# Function to install packages
install_packages() {
    if command -v apt >/dev/null; then
        sudo apt update
        sudo apt install -y zsh git stow curl tar util-linux fontconfig unzip build-essential libtool-bin cmake pkg-config unzip lua5.1 tmux fuse
    elif command -v dnf >/dev/null; then
        echo "Using dnf for package management"
        sudo dnf install -y zsh git stow curl tar util-linux-user fontconfig unzip make cmake gcc lua tmux fuse || {
            echo "Failed to install packages"
            exit 1
        }
    elif command -v pacman >/dev/null; then
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm zsh fontconfig git stow curl tar util-linux ttf-dejavu unzip base-devel cmake lua tmux fuse
    else
        echo "Unsupported package manager. Install zsh, git, stow, curl, tar, util-linux, fuse, and tmux manually."
        exit 1
    fi
}

# Backup existing dotfiles
backup_dotfiles() {
    echo "Backing up existing dotfiles..."
    mkdir -p "$HOME/.dotfiles_backup"
    mv "$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.dotfiles_backup/" 2>/dev/null || true
}

# Restore dotfiles if script fails
restore_dotfiles() {
    echo "Restoring original dotfiles..."
    if [[ -d "$HOME/.dotfiles_backup" ]]; then
        mv "$HOME/.dotfiles_backup"/* "$HOME/"
        rm -rf "$HOME/.dotfiles_backup"
    fi
}

# Install required packages
install_packages

# Backup existing dotfiles
backup_dotfiles

# Change default shell to zsh if chsh is available
if command -v chsh >/dev/null; then
    chsh -s "$(which zsh)"
else
    echo "chsh command not found. Please change the default shell to zsh manually."
fi

# Install fzf
FZF_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -LO "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
if ! tar -xzf "fzf-${FZF_VERSION}-linux_amd64.tar.gz"; then
    echo "Failed to extract fzf tarball. Exiting."
    exit 1
fi
sudo mv fzf /usr/bin
rm "fzf-${FZF_VERSION}-linux_amd64.tar.gz"

# Install Neovim using AppImage if not already installed
if ! command -v nvim >/dev/null; then
    NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    curl -LO "$NEOVIM_APPIMAGE_URL"
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
fi

# Install Zoxide using provided script
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Check if TPM (Tmux Plugin Manager) is installed
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    # Install TPM
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM is already installed. Skipping TPM installation."
fi

# Check if Nerd Font is already installed
if fc-list | grep -q "0xProto"; then
    echo "Nerd Font 0xProto is already installed. Skipping font installation."
else
    # Install Nerd Font 0xProto
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    curl -LO "$FONT_URL"
    unzip -o 0xProto.zip -d "$FONT_DIR"
    rm 0xProto.zip
    fc-cache -fv
fi

# Clone dotfiles repo
if [[ -d "$HOME/dotfiles" && -n "$(ls -A "$HOME"/dotfiles)" ]]; then
    echo "The directory 'dotfiles' already exists and is not empty. Please choose an option:"
    echo "1) Back up existing 'dotfiles' directory"
    echo "2) Overwrite existing 'dotfiles' directory"
    echo "3) Cancel installation"
    read -rp "Enter your choice [1, 2, 3]: " choice

    case $choice in
    1)
        mv "$HOME/dotfiles" "$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
        echo "Existing 'dotfiles' directory backed up."
        ;;
    2)
        rm -rf "$HOME/dotfiles"
        echo "Existing 'dotfiles' directory removed."
        ;;
    3)
        echo "Installation cancelled."
        exit 0
        ;;
    *)
        echo "Invalid choice. Installation cancelled."
        exit 1
        ;;
    esac
fi

# Apply stow
cd "$HOME"
git clone https://github.com/jacobdanielrose/dotfiles.git
cd dotfiles
stow .

echo "Installation complete. Please restart your terminal or log out and back in for changes to take effect."
