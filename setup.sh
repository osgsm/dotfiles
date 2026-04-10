#!/bin/zsh

# Install xcode
xcode-select --install > /dev/null

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null

DOTFILES=$HOME/dotfiles

# Create symbolic links to $HOME
HOME_FILES=(zshrc gitconfig vimrc tmux.conf alacritty.yml wezterm.lua)
for file in ${HOME_FILES[@]}; do
  ln -sf $DOTFILES/$file $HOME/.$file
done

# Create symbolic links to ~/.config/
CONFIG_FILES=(
  "ghostty:ghostty/config"
  "kitty.conf:kitty/kitty.conf"
  "lazygit.yml:lazygit/config.yml"
  "cmux:cmux"
)
for entry in ${CONFIG_FILES[@]}; do
  src=${entry%%:*}
  dest=${entry#*:}
  mkdir -p $HOME/.config/${dest%/*}
  ln -sf $DOTFILES/$src $HOME/.config/$dest
done

# Brewfile
ln -sf $DOTFILES/Brewfile $HOME/.Brewfile

# Brew install
brew bundle --global
