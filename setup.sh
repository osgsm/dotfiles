#!/bin/zsh

DOT_FILES=(.zshrc .gitconfig .vimrc .tmux.conf .alacritty.yml)

for file in ${DOT_FILES[@]}
do
	ln -s $HOME/dotfiles/$file $HOME/$file
done
