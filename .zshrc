export EDITOR=vim

PS1='%~ %# '

alias g=git

# zsh-completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

# zsh-autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# set vim key bind
bindkey -v

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

