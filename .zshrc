export EDITOR=vim

PS1='%~ %# '

# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'

# ls aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"
alias g="git"

# pnpm aliases
alias pn="pnpm"

# Yarn aliases
alias y="yarn"
alias yi="yarn init -y"
alias ya="yarn add"
alias yr="yarn remove"
alias yad="yarn add -D"
alias yga="yarn global add"
alias ygr="yarn global remove"
alias yu="yarn upgrade"
alias ygu="yarn global upgrade"
alias yl="yarn list --depth=0"
alias ygl="yarn global list --depth=0"
alias yo="yarn outdated"
alias yd="yarn dev"
alias yb="yarn build"
alias ys="yarn start"

# npm aliases
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nun="npm uninstall"
alias nung="npm uninstall -g"
alias nl="npm list --depth=0"
alias nu="npm update"
alias nug="npm update-g"
alias no="npm outdated"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"

# zsh-completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# set vim key bind
bindkey -v

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# depot_tools
export PATH=$HOME/Tools/depot_tools:$PATH

# bun completions
[ -s "/Users/osgsm/.bun/_bun" ] && source "/Users/osgsm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# composer
export PATH="$HOME/.composer/vendor/bin:$PATH"
