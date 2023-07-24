#!/bin/zsh

# Install xcode
xcode-select --install > /dev/null

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null

# Create simbolic links
DOT_FILES=(.zshrc .gitconfig .vimrc .tmux.conf .alacritty.yml Brewfile)

for file in ${DOT_FILES[@]}
do
	ln -s $HOME/dotfiles/$file $HOME/$file
done

# Brew install
brew bundle --global
